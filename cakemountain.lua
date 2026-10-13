if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- ตรวจสอบ PlaceId ของแมพ Cake Mountain
if game.PlaceId ~= 83733952151811 then
    game:GetService("Players").LocalPlayer:Kick("Cake Mountain Hub: Invalid Game!")
    return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local CakeHub = {
    Started = os.clock(),
    Config = {
        AutoDig = false,
        AutoSell = false,
        AutoUpgradeSpoon = false,
        AutoUpgradeBag = false,
        DigDelay = 0.1,
    },
    State = {
        Running = true,
    }
}

local Config = CakeHub.Config
local State = CakeHub.State

local RemoteFolder = ReplicatedStorage:WaitForChild("Remote", 10)

function CakeHub.GetRemote(name)
    if RemoteFolder then
        return RemoteFolder:FindFirstChild(name, true)
    end
    return nil
end

-- ฟังก์ชันขุดเค้กอัตโนมัติ
task.spawn(function()
    while State.Running do
        if Config.AutoDig then
            pcall(function()
                local digRemote = CakeHub.GetRemote("DigEvent") or CakeHub.GetRemote("EatCake")
                if digRemote then
                    digRemote:FireServer()
                end
            end)
        end
        task.wait(Config.DigDelay)
    end
end)

-- ฟังก์ชันขายเค้กอัตโนมัติ
task.spawn(function()
    while State.Running do
        if Config.AutoSell then
            pcall(function()
                local sellRemote = CakeHub.GetRemote("SellEvent") or CakeHub.GetRemote("SellCakes")
                if sellRemote then
                    sellRemote:FireServer()
                end
            end)
        end
        task.wait(5)
    end
end)

-- ฟังก์ชันอัปเกรดอัตโนมัติ
task.spawn(function()
    while State.Running do
        if Config.AutoUpgradeSpoon then
            pcall(function()
                local upgradeRemote = CakeHub.GetRemote("UpgradeSpoon")
                if upgradeRemote then
                    upgradeRemote:FireServer()
                end
            end)
        end
        if Config.AutoUpgradeBag then
            pcall(function()
                local upgradeRemote = CakeHub.GetRemote("UpgradeBag")
                if upgradeRemote then
                    upgradeRemote:FireServer()
                end
            end)
        end
        task.wait(2)
    end
end)

print("[Cake Mountain Hub] Loaded successfully!")
