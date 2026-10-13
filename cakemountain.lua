if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- โหลด Ouroboros Hub เบื้องหลัง
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"))()
end)

-- ลบ UI เก่าหากมีอยู่
if PlayerGui:FindFirstChild("CakeHeightHub") then
    PlayerGui.CakeHeightHub:Destroy()
end

-- สร้าง GUI หน้าต่างควบคุม
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CakeHeightHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 320) -- เพิ่มขนาด MainFrame นิดหน่อยเพื่อให้พอปุ่มใหม่
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- แถบ Title ด้านบน
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "CAKE MOUNTAIN - HEIGHT DIGGER HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- ตัวแปรระบบ
local AutoDigActive = false
local AnchorActive = false
local TargetHeight = 580
local DigSpeed = 0.15

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -24, 1, -55)
Container.Position = UDim2.new(0, 12, 0, 48)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)
UIList.Parent = Container

-- 1. ช่องกำหนดระดับความสูง (Y-Level)
local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(1, 0, 0, 42)
InputFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
InputFrame.BorderSizePixel = 0
InputFrame.Parent = Container

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = InputFrame

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(0, 180, 1, 0)
InputLabel.Position = UDim2.new(0, 10, 0, 0)
InputLabel.BackgroundTransparency = 1
InputLabel.Font = Enum.Font.GothamMedium
InputLabel.Text = "กำหนดระดับความสูงการขุด (Y):"
InputLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
InputLabel.TextSize = 12
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = InputFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 100, 0, 28)
TextBox.Position = UDim2.new(1, -110, 0.5, -14)
TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
TextBox.Text = "580"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.GothamBold
TextBox.TextSize = 12
TextBox.Parent = InputFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 5)
BoxCorner.Parent = TextBox

TextBox.FocusLost:Connect(function()
    local val = tonumber(TextBox.Text)
    if val then
        TargetHeight = val
    end
end)

-- 2. ปุ่มย้ายตัวละคร
local TpBtn = Instance.new("TextButton")
TpBtn.Size = UDim2.new(1, 0, 0, 40)
TpBtn.BackgroundColor3 = Color3.fromRGB(60, 110, 200)
TpBtn.Text = "วาร์ปไปที่ระดับความสูง"
TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TpBtn.Font = Enum.Font.GothamBold
TpBtn.TextSize = 12
TpBtn.Parent = Container

local TpCorner = Instance.new("UICorner")
TpCorner.CornerRadius = UDim.new(0, 6)
TpCorner.Parent = TpBtn

TpBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local pos = hrp.Position
        hrp.CFrame = CFrame.new(pos.X, TargetHeight, pos.Z)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end)

-- 3. ปุ่มตรึงตำแหน่งลอยตัว (Anchor)
local AnchorBtn = Instance.new("TextButton")
AnchorBtn.Size = UDim2.new(1, 0, 0, 40)
AnchorBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
AnchorBtn.Text = "ตรึงตำแหน่งลอยตัว: OFF"
AnchorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AnchorBtn.Font = Enum.Font.GothamBold
AnchorBtn.TextSize = 12
AnchorBtn.Parent = Container

local TogAnchorCorner = Instance.new("UICorner")
TogAnchorCorner.CornerRadius = UDim.new(0, 6)
TogAnchorCorner.Parent = AnchorBtn

AnchorBtn.MouseButton1Click:Connect(function()
    AnchorActive = not AnchorActive
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if AnchorActive then
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.Anchored = true
        end
        AnchorBtn.BackgroundColor3 = Color3.fromRGB(50, 170, 70)
        AnchorBtn.Text = "ตรึงตำแหน่งลอยตัว: ON"
    else
        if hrp then
            hrp.Anchored = false
        end
        AnchorBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        AnchorBtn.Text = "ตรึงตำแหน่งลอยตัว: OFF"
    end
end)

-- 4. ปุ่ม Auto Dig (ใช้ช้อนขุด)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ToggleBtn.Text = "Auto Dig (ใช้ช้อนขุดอัตโนมัติ): OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
ToggleBtn.Parent = Container

local TogCorner = Instance.new("UICorner")
TogCorner.CornerRadius = UDim.new(0, 6)
TogCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    AutoDigActive = not AutoDigActive
    if AutoDigActive then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 170, 70)
        ToggleBtn.Text = "Auto Dig (ใช้ช้อนขุดอัตโนมัติ): ON"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        ToggleBtn.Text = "Auto Dig (ใช้ช้อนขุดอัตโนมัติ): OFF"
    end
end)

-- ปุ่ม RightShift สำหรับ ซ่อน/แสดง UI
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ลูปการขุดเบื้องหลัง
task.spawn(function()
    while true do
        if AutoDigActive then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then
                        local name = obj.Name:lower()
                        if name:find("dig") or name:find("mine") or name:find("hit") or name:find("cake") then
                            obj:FireServer()
                        end
                    end
                end
            end)
        end
        
        -- ตรวจสอบและตรึงตำแหน่งตัวละครอย่างต่อเนื่องหากเปิดใช้งาน
        if AnchorActive then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and not hrp.Anchored then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.Anchored = true
                end
            end)
        end
        task.wait(DigSpeed)
    end
end)
