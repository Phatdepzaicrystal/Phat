local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local hwidListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/hwids.json"

local player = Players.LocalPlayer
local hwid = game:GetService("RbxAnalyticsService"):GetClientId() -- 📌 Lấy HWID từ thiết bị

-- ⚠️ Kiểm tra xem người chơi đã nhập key chưa
if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- 📥 Tải danh sách key từ GitHub
local function getData(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        if decodeSuccess then
            return data
        end
    end
    return nil
end

local keys = getData(keyListUrl)
local hwids = getData(hwidListUrl)

if not keys or not hwids then
    player:Kick("❌ Không thể kết nối đến máy chủ xác thực.")
    return
end

local isValidKey = false
local isValidHWID = false

-- 🔍 Kiểm tra key hợp lệ
for _, k in pairs(keys) do
    if typeof(k) == "string" then
        if k == getgenv().Key then
            isValidKey = true
            break
        end
    elseif typeof(k) == "table" and k.code then
        if k.code == getgenv().Key then
            isValidKey = true
            break
        end
    end
end

-- 🔍 Kiểm tra HWID hợp lệ
for _, h in pairs(hwids) do
    if h == hwid then
        isValidHWID = true
        break
    end
end

if isValidKey and isValidHWID then
    print("[✅] Key & HWID hợp lệ! Đang chạy script...")
    getgenv().Team = "Marines"  -- hoặc "Pirates"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/main/Phat.lua"))()
else
    player:Kick("❌ Key hoặc HWID không hợp lệ.")
end
