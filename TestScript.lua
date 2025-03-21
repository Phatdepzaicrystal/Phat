local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local API_URL = "https://2cb8592c-0d94-4348-86b2-42d0bc9b841d-00-5tyyjf8nengg.sisko.replit.dev/check_hwid"
local HWID = gethwid and gethwid() or "Unknown"

-- Gửi HWID lên API để kiểm tra
local function checkHWID()
    local requestData = HttpService:JSONEncode({hwid = HWID})
    local success, response = pcall(function()
        return HttpService:PostAsync(API_URL, requestData, Enum.HttpContentType.ApplicationJson, false)
    end)

    if success then
        local jsonResponse = HttpService:JSONDecode(response)
        if jsonResponse.status == "success" then
            print("✅ " .. jsonResponse.message)
            return true
        end
    end

    print("❌ HWID không hợp lệ! Kick người chơi.")
    LocalPlayer:Kick("⚠️ HWID không hợp lệ!")
    return false
end

-- Nếu HWID hợp lệ, chạy script chính
if checkHWID() then
    print("✅ Chạy script chính!")
    getgenv().Language = "English" 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
end
