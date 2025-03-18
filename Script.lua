local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local keyListUrl = "https://github.com/Phatdepzaicrystal/Key/blob/main/keys.json"
local player = Players.LocalPlayer

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
        for _, k in pairs(keys) do
            if k == getgenv().Key then
                isValid = true
                break
            end
        end

        if isValid then
            print("[✅] Key hợp lệ! Đang chạy script...")
            -- 👉 Chạy script chính tại đây
            getgenv().Team = "Marines"          -- Pirates or Marines
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/refs/heads/main/Phat.lua"))()
        else
            player:Kick("❌ Invalid Key")
        end
    else
        player:Kick("❌ Lỗi giải mã danh sách key.")
    end
else
    player:Kick("❌ Không thể kết nối đến máy chủ xác thực key.")
end
