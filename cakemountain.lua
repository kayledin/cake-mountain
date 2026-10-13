if not game:IsLoaded() then
    game.Loaded:Wait()
end

if game.PlaceId ~= 83733952151811 then
    game:GetService("Players").LocalPlayer:Kick("Cake Mountain Hub: Invalid Game!")
    return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

print("[Cake Mountain Hub] Script is running!")

-- ฟังก์ชันช่วยสแกนหา Remote ทั้งหมดในเกมเพื่อดูชื่อจริง (กด F9 ดูในเกมได้เลย)
task.spawn(function()
    print("--- Scanning ReplicatedStorage ---")
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            print("Found Remote:", v.ClassName, "->", v:GetFullName())
        end
    end
    print("---------------------------------")
end)

local CakeHub = {
    Config = {
        AutoDig = true, -- เปิดใช้งานทันทีเพื่อทดสอบ
        DigDelay = 0.5,
    },
    State = {
        Running = true,
    }
}

local Config = CakeHub.Config
local State = CakeHub.State

-- ฟังก์ชันขุดเค้กอัตโนมัติ
task.spawn(function()
    while State.Running do
        if Config.AutoDig then
            pcall(function()
                -- ลองหา Remote ที่เกี่ยวข้องกับการคลิก/ขุด/กินเค้ก
                -- (คุณสามารถดูชื่อจริงที่ได้จากหน้า F9 Console มาใส่ตรงนี้แทนได้)
                for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("dig") or v.Name:lower():find("eat") or v.Name:lower():find("cake") or v.Name:lower():find("click")) then
                        v:FireServer()
                        -- print("Fired:", v.Name) -- เปิดบรรทัดนี้ถ้าต้องการดูว่ายิงอันไหนอยู่
                    end
                end
            end)
        end
        task.wait(Config.DigDelay)
    end
end)
