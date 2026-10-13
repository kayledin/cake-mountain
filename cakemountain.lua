if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ลบ UI เก่าหากมีอยู่
if PlayerGui:FindFirstChild("CakeHeightHub") then
    PlayerGui.CakeHeightHub:Destroy()
end

-- สร้าง UI หน้าต่างควบคุม
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CakeHeightHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
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
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
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
TitleLabel.Text = "CAKE MOUNTAIN - AUTO DIG & HEIGHT"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- ตัวแปรระบบ
local AutoDigActive = false
local TargetHeight = 100
local DigSpeed = 0.2

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -24, 1, -55)
Container.Position = UDim2.new(0, 12, 0, 48)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)
UIList.Parent = Container

-- 1. ช่องกรอกระดับความสูง (Y-Level)
local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(1, 0, 0, 42)
InputFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
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
InputLabel.Text = "กำหนดระดับความสูง (Y):"
InputLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
InputLabel.TextSize = 12
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = InputFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 100, 0, 28)
TextBox.Position = UDim2.new(1, -110, 0.5, -14)
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
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

-- 2. ปุ่ม Teleport ไประดับความสูง
local TpBtn = Instance.new("TextButton")
TpBtn.Size = UDim2.new(1, 0, 0, 40)
TpBtn.BackgroundColor3 = Color3.fromRGB(60, 110, 200)
TpBtn.Text = "ย้ายตัวละครไปชั้นความสูงที่ระบุ"
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
        local pos = char.HumanoidRootPart.Position
        char.HumanoidRootPart.CFrame = CFrame.new(pos.X, TargetHeight, pos.Z)
    end
end)

-- 3. ปุ่ม Toggle Auto Dig
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ToggleBtn.Text = "Auto Dig: OFF"
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
        ToggleBtn.Text = "Auto Dig: ON"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        ToggleBtn.Text = "Auto Dig: OFF"
    end
end)

-- ซ่อน/แสดง UI ด้วย RightShift
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ลูปการทำงาน
task.spawn(function()
    while true do
        if AutoDigActive then
            pcall(function()
                -- ค้นหาการเรียกใช้งาน Event ของตัวเกม
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then
                        local name = obj.Name:lower()
                        if name:find("dig") or name:find("click") or name:find("mine") or name:find("hit") then
                            obj:FireServer()
                        end
                    end
                end
            end)
        end
        task.wait(DigSpeed)
    end
end)
