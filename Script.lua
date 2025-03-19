local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local hwidListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/hwids.json"
local hwidUploadUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/hwids.json"

local player = Players.LocalPlayer

-- ⚠️ Kiểm tra người dùng đã nhập key chưa
if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- 🖥️ Lấy HWID từ hệ thống
local function getHWID()
    local handle = io.popen("wmic csproduct get uuid")
    local result = handle:read("*a")
    handle:close()
    return result:match("[0-9A-F-]+") or "Unknown"
end

local hwid = getHWID()
print("🔹 HWID của bạn: ", hwid)

-- 📥 Tải danh sách key từ GitHub
local function fetchData(url)
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

local keys = fetchData(keyListUrl)
local hwids = fetchData(hwidListUrl)

if not keys or not hwids then
    player:Kick("❌ Không thể kết nối đến máy chủ xác thực key.")
    return
end

-- ✅ Kiểm tra key có hợp lệ không
local isValidKey = false
for _, k in pairs(keys) do
    if typeof(k) == "table" and k.code == getgenv().Key then
        isValidKey = true
        break
    end
end

if not isValidKey then
    player:Kick("❌ Invalid Key")
    return
end

-- 🔍 Kiểm tra HWID có trong danh sách không
local isHWIDRegistered = false
for _, h in pairs(hwids) do
    if h.hwid == hwid then
        isHWIDRegistered = true
        break
    end
end

if not isHWIDRegistered then
    -- 🚀 Nếu HWID chưa có, thêm vào GitHub
    local newHWID = {
        hwid = hwid,
        username = player.Name
    }
    table.insert(hwids, newHWID)

    local jsonData = HttpService:JSONEncode(hwids)
    local successPost, postResponse = pcall(function()
        return HttpService:PostAsync(hwidUploadUrl, jsonData)
    end)

    if successPost then
        print("[✅] HWID đã được lưu lên GitHub!")
    else
        print("[❌] Không thể lưu HWID lên GitHub!")
    end
end

print("[✅] Key & HWID hợp lệ! Đang chạy script...")

-- 👉 Chạy script chính tại đây
getgenv().Team = "Marines"  -- hoặc "Pirates"
loadstring(game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/main/Phat.lua"))()
