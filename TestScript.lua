local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 🌐 Thay API URL của bạn
local checkKeyAPI = "https://2cb8592c-0d94-4348-86b2-42d0bc9b841d-00-5tyyjf8nengg.sisko.replit.dev/Checkkey"
local addKeyAPI = "https://2cb8592c-0d94-4348-86b2-42d0bc9b841d-00-5tyyjf8nengg.sisko.replit.dev//Addkey"

local player = Players.LocalPlayer
local hwid = gethwid and gethwid() or "Unknown"

if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- 🚀 Gửi key & HWID lên API để kiểm tra
local function checkKeyAndHWID()
    local data = {
        key = getgenv().Key,
        hwid = hwid
    }

    local response = syn.request({
        Url = checkKeyAPI .. "?key=" .. getgenv().Key .. "&hwid=" .. hwid,
        Method = "GET",
        Headers = {["Content-Type"] = "application/json"}
    })

    if response.StatusCode == 200 then
        local result = HttpService:JSONDecode(response.Body)
        
        if result.status == "true" then
            print("✅ Key hợp lệ, chạy script...")
            getgenv().Language = "English"
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
        else
            player:Kick(result.message)
        end
    else
        player:Kick("❌ Lỗi kết nối API!")
    end
end

-- 🆕 Nếu HWID chưa có trong API, gửi lên API để lưu
local function addKey()
    local response = syn.request({
        Url = addKeyAPI .. "?key=" .. getgenv().Key .. "&hwid=" .. hwid .. "&user=pre",
        Method = "GET",
        Headers = {["Content-Type"] = "application/json"}
    })

    if response.StatusCode == 200 then
        print("✅ HWID đã được lưu vào API.")
        checkKeyAndHWID()
    else
        player:Kick("❌ Lỗi khi gửi HWID lên API!")
    end
end

addKey()
