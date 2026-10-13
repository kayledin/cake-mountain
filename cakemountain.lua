if not game:IsLoaded() then
    game.Loaded:Wait()
end

if game.PlaceId ~= 83733952151811 then
    game:GetService("Players").LocalPlayer:Kick("Cake Mountain Hub: Invalid Game!")
    return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ลบ UI เก่าออกถ้ามี
if PlayerGui:FindFirstChild("CakeMountainHub") then
    PlayerGui.CakeMountainHub:Destroy()
end

-- สร้างหน้าต่าง GUI หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CakeMountainHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 300)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- ทำให้ลากย้ายหน้าต่างได้
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- แถบหัวข้อด้านบน
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 8)
TopFix.Position = UDim2.new(0, 0, 1, -8)
TopFix.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "CAKE MOUNTAIN HUB | PC Edition"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- ปุ่มปิด (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -33, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- พื้นที่ใส่ปุ่มฟังก์ชัน
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -20, 1, -52)
ContentContainer.Position = UDim2.new(0, 10, 0, 44)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 250)
ContentContainer.ScrollBarThickness = 4
ContentContainer.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.Parent = ContentContainer

-- ฟังก์ชันสร้างปุ่มเปิด/ปิด (Toggle Button)
local function createToggle(name, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ContentContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 50, 0, 24)
    Button.Position = UDim2.new(1, -58, 0.5, -12)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Button.Text = "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 11
    Button.Parent = ToggleFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = Button

    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.BackgroundColor3 = state and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(60, 60, 70)
        Button.Text = state and "ON" or "OFF"
        pcall(function() callback(state) end)
    end)
end

-- ตัวแปรเก็บสถานะการทำงาน
local Toggles = {
    AutoDig = false,
    AutoSell = false,
}

createToggle("Auto Dig (ขุด/กินเค้กออโต้)", function(state) Toggles.AutoDig = state end)
createToggle("Auto Sell (ขายเค้กออโต้)", function(state) Toggles.AutoSell = state end)

-- ปุ่มซ่อน/แสดงเมนูด้วยคีย์บอร์ด (กดปุ่ม RightShift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ระบบการทำงานเบื้องหลัง (Background Loops)
task.spawn(function()
    while true do
        pcall(function()
            if Toggles.AutoDig then
                for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("dig") or v.Name:lower():find("eat") or v.Name:lower():find("cake") or v.Name:lower():find("click")) then
                        v:FireServer()
                    end
                end
            end
        end)
        task.wait(0.2)
    end
end)

task.spawn(function()
    while true do
        pcall(function()
            if Toggles.AutoSell then
                for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("sell") or v.Name:lower():find("cash")) then
                        v:FireServer()
                    end
                end
            end
        end)
        task.wait(1)
    end
end)

print("[Cake Mountain Hub] PC GUI Loaded Successfully! Press 'RightShift' to hide/show UI.")
