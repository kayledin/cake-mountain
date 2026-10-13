-- Cake Mountain Universal Money & Resource Fuzzer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("[Cake Mountain] Starting Auto-Fuzzer...")

local function blastRemotes()
    local count = 0
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function()
                -- ลองส่งค่าตัวเลขเงินและคำสั่งยอดฮิตไปทุก RemoteEvent ในเกม
                obj:FireServer(999999999)
                obj:FireServer("AddMoney", 999999999)
                obj:FireServer("AddCash", 999999999)
                obj:FireServer("Buy", 999999999)
                obj:FireServer("Claim", 999999999)
                count += 1
            end)
        elseif obj:IsA("RemoteFunction") then
            pcall(function()
                -- ลองเรียกใช้ RemoteFunction ทุกตัวในเกม
                obj:InvokeServer(999999999)
                obj:InvokeServer("AddMoney", 999999999)
                obj:InvokeServer("Buy", 999999999)
                count += 1
            end)
        end
    end
    print("[Cake Mountain] Fuzzer finished! Sent payloads to " .. tostring(count) .. " remotes.")
end

-- รันคำสั่งทันที
blastRemotes()
