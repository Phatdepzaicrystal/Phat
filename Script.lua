local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local player = Players.LocalPlayer
local hwid = RbxAnalyticsService:GetClientId()

-- ⚠️ Kiểm tra người dùng đã nhập key chưa
if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- 📥 Tải danh sách key từ GitHub
local success, response = pcall(function()
    return game:HttpGet(keyListUrl)
end)

if success then
    local decodeSuccess, keys = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if decodeSuccess then
        local isValid = false

        -- 🔍 Duyệt từng phần tử trong danh sách
        for _, entry in pairs(keys) do
            if typeof(entry) == "table" and entry.code then
                if entry.code == getgenv().Key then
                    if entry.hwid == nil then
                        -- Chưa có HWID → Cập nhật HWID
                        entry.hwid = hwid
                        isValid = true
                        break
                    elseif entry.hwid == hwid then
                        -- HWID trùng khớp
                        isValid = true
                        break
                    else
                        -- HWID không khớp
                        player:Kick("❌ HWID không hợp lệ!")
                        return
                    end
                end
            end
        end

        if isValid then
            print("[✅] Key hợp lệ! Đang chạy script...")
            getgenv().Team = "Marines"  -- hoặc "Pirates"
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/main/Phat.lua"))()
        else
            player:Kick("❌ Invalid Key")
        end
    else
        player:Kick("❌ Lỗi giải mã danh sách key.")
    end
else
    player:Kick("❌ Không thể kết nối đến máy chủ xác thực key.")
end
