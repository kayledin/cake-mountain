if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ลบ UI เก่าออกถ้ามี
if PlayerGui:FindFirstChild("CakeHeightHub") then
    PlayerGui.CakeHeightHub:Destroy()
end

-- สร้างหน้าต่าง GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CakeHeightHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- แถบด้านบน
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "CAKE MOUNTAIN | Height & Rarity Selector"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- ตัวแปรตั้งค่าความสูง
local TargetHeight = 0
local AutoDigActive = false

-- พื้นที่ใส่เนื้อหา
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -24, 1, -50)
Container.Position = UDim2.new(0, 12, 0, 44)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)
UIList.Parent = Container

-- 1. ช่องกรอกระดับความสูง (Height Input)
local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(1, 0, 0, 42)
InputFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
InputFrame.BorderSizePixel = 0
InputFrame.Parent = Container

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = InputFrame

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(0, 160, 1, 0)
InputLabel.Position = UDim2.new(0, 10, 0, 0)
InputLabel.BackgroundTransparency = 1
InputLabel.Font = Enum.Font.GothamMedium
InputLabel.Text = "ระบุความสูง / ชั้น (Y):"
InputLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
InputLabel.TextSize = 12
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = InputFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 120, 0, 28)
TextBox.Position = UDim2.new(1, -130, 0.5, -14)
TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TextBox.Text = "100"
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

-- 2. ปุ่ม Teleport ไปยังระดับความสูงที่เลือก
local TpBtn = Instance.new("TextButton")
TpBtn.Size = UDim2.new(1, 0, 0, 40)
TpBtn.BackgroundColor3 = Color3.fromRGB(70, 110, 210)
TpBtn.Text = "วาร์ปไประดับความสูงที่เลือก (Teleport to Height)"
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
        local currentPos = char.HumanoidRootPart.Position
        local heightVal = tonumber(TextBox.Text) or TargetHeight
        char.HumanoidRootPart.CFrame = CFrame.new(currentPos.X, heightVal, currentPos.Z)
    end
end)

-- 3. ปุ่ม Toggle Auto Dig เฉพาะชั้น
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ToggleBtn.Text = "Auto Dig ณ จุดนี้: OFF"
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
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
        ToggleBtn.Text = "Auto Dig ณ จุดนี้: ON"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        ToggleBtn.Text = "Auto Dig ณ จุดนี้: OFF"
    end
end)

-- ปุ่ม RightShift สำหรับ ซ่อน/แสดง หน้าต่าง UI
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ลูปการทำงานขุดอัตโนมัติ
task.spawn(function()
    while true do
        if AutoDigActive then
            pcall(function()
                for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("dig") or v.Name:lower():find("eat") or v.Name:lower():find("cake") or v.Name:lower():find("mine")) then
                        v:FireServer()
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)
