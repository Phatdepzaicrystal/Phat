-------------------------------
local http = game:GetService("HttpService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local key = getgenv().Key or "Phat-XXXXXXX"

-- Link chứa danh sách key + hwid đã lưu (trên GitHub)
local keysDataURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"

-- Webhook để gửi HWID bind request (chỉ lần đầu chưa có HWID)
local webhookURL = "https://discord.com/api/webhooks/1351710851727364158/CLgOTMvfjEshI-HXkzCi0SK_kYZzx9qi42aZfI92R_YrYBwr3U7H9Se1dIRrMcxxrtPj"

-- Gửi request bind HWID (nếu key hợp lệ nhưng chưa có HWID)
local function sendHWIDBindRequest()
    local payload = {
        content = "🆕 HWID Bind Request",
        embeds = {{
            title = "HWID Request for Key",
            fields = {
                { name = "Key", value = key, inline = true },
                { name = "HWID", value = hwid, inline = true }
            },
            color = 16776960
        }}
    }
    pcall(function()
        http:PostAsync(webhookURL, http:JSONEncode(payload))
    end)
end

-- Kiểm tra key và hwid có hợp lệ không
local function isValidKeyAndHWID()
    local success, response = pcall(function()
        return http:GetAsync(keysDataURL)
    end)

    if success then
        local data = http:JSONDecode(response)

        for _, entry in pairs(data) do
            if entry.key == key then
                if entry.blacklisted then
                    return false, "🚫 Key này đã bị blacklist!"
                end

                if entry.hwid == nil or entry.hwid == "" then
                    sendHWIDBindRequest()
                    return true, "🆗 Key hợp lệ, HWID chưa gắn – Đang gửi yêu cầu Bind HWID!"
                end

                if entry.hwid == hwid then
                    return true, "✅ Key và HWID hợp lệ!"
                else
                    return false, "❌ Invalid HWID!!"
                end
            end
        end
        return false, "❌ Key không tồn tại hoặc sai định dạng!"
    else
        return false, "⚠️ Lỗi khi tải dữ liệu key!"
    end
end

-- Xử lý kiểm tra
local valid, message = isValidKeyAndHWID()
if not valid then
    game.Players.LocalPlayer:Kick(message)
    return
end

-- Load script chính nếu pass cả key + hwid
getgenv().Team = "Marines"          -- Pirates or Marines
loadstring(game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/refs/heads/main/Phat.lua"))()
