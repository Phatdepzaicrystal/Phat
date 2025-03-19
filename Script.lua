local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local webhookUrl = "https://discord.com/api/webhooks/1351710851727364158/CLgOTMvfjEshI-HXkzCi0SK_kYZzx9qi42aZfI92R_YrYBwr3U7H9Se1dIRrMcxxrtPj" -- 💬 Thay link Webhook của bạn vào đây

-- ⚠️ Kiểm tra người dùng đã nhập key chưa
if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- 📤 Gửi HWID và thông tin user về Discord Webhook
local function sendHWIDToWebhook()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local data = {
        ["username"] = "HWID Logger",
        ["content"] = "**🔐 Key Info Logger**\n```User: " .. player.Name ..
                      "\nUserId: " .. player.UserId ..
                      "\nHWID: " .. hwid ..
                      "\nKey: " .. getgenv().Key .. "```"
    }

    pcall(function()
        HttpService:PostAsync(
            webhookUrl,
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)
end

-- Gửi HWID trước khi xác thực key
sendHWIDToWebhook()

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
        for _, k in pairs(keys) do
            if typeof(k) == "string" then
                if k == getgenv().Key then
                    isValid = true
                    break
                end
            elseif typeof(k) == "table" and k.code then
                if k.code == getgenv().Key then
                    isValid = true
                    break
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
