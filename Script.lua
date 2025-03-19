local http = game:GetService("HttpService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local key = getgenv().Key or "Phat-XXXXXXX"

-- Link chứa danh sách key + hwid đã lưu (trên GitHub)
local keysDataURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"

-- Webhook gửi yêu cầu bind HWID nếu key chưa có HWID
local webhookURL = "https://discord.com/api/webhooks/1351710851727364158/CLgOTMvfjEshI-HXkzCi0SK_kYZzx9qi42aZfI92R_YrYBwr3U7H9Se1dIRrMcxxrtPj"

-- Gửi yêu cầu bind HWID (chỉ gửi nếu chưa có HWID)
local function sendHWIDBindRequest()
    local payload = {
        content = "🆕 **HWID Bind Request**",
        embeds = {{
            title = "HWID Request for Key",
            fields = {
                { name = "🔑 Key", value = key, inline = true },
                { name = "🖥️ HWID", value = hwid, inline = true }
            },
            color = 16776960
        }}
    }
    pcall(function()
        http:PostAsync(webhookURL, http:JSONEncode(payload))
    end)
end

-- Kiểm tra key và HWID
local function isValidKeyAndHWID()
    local success, response = pcall(function()
        return http:GetAsync(keysDataURL)
    end)

    if not success then
        return false, "⚠️ Lỗi khi tải dữ liệu key!"
    end

    local data = http:JSONDecode(response)

    for _, entry in pairs(data) do
        if entry.code == key then
            -- Nếu có trường blacklisted
            if entry.blacklisted == true then
                return false, "🚫 Key này đã bị blacklist!"
            end

            -- Nếu chưa có HWID → Gửi yêu cầu bind
            if not entry.hwid or entry.hwid == "" then
                sendHWIDBindRequest()
                return false, "📩 Đã gửi yêu cầu bind HWID. Vui lòng đợi admin xác nhận!"
            end

            -- Kiểm tra HWID khớp
            if entry.hwid == hwid then
                return true, "✅ Key và HWID hợp lệ!"
            else
                return false, "❌ HWID không khớp với key này!"
            end
        end
    end

    return false, "❌ Key không tồn tại hoặc sai định dạng!"
end

-- Kiểm tra trước khi load script chính
local valid, message = isValidKeyAndHWID()
if not valid then
    game.Players.LocalPlayer:Kick(message)
    return
end

-- Load script chính nếu hợp lệ
getgenv().Team = "Marines" -- Pirates hoặc Marines
loadstring(game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/refs/heads/main/Phat.lua"))()
