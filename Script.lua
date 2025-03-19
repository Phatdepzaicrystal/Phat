local http = game:GetService("HttpService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local key = getgenv().Key or "Phat-XXXXXXX"

-- 👉 Link keys.json dùng jsDelivr CDN để tránh lỗi raw.githubusercontent
local keysDataURL = "https://cdn.jsdelivr.net/gh/Phatdepzaicrystal/Key@main/keys.json"

-- Webhook gửi yêu cầu bind HWID nếu chưa gắn
local webhookURL = "https://discord.com/api/webhooks/1351710851727364158/CLgOTMvfjEshI-HXkzCi0SK_kYZzx9qi42aZfI92R_YrYBwr3U7H9Se1dIRrMcxxrtPj"

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

local function isValidKeyAndHWID()
    local success, response = pcall(function()
        return http:GetAsync(keysDataURL)
    end)

    if not success then
        warn("❌ Không thể tải dữ liệu từ GitHub! Response:", response)
        return false, "⚠️ Lỗi khi tải dữ liệu key từ GitHub! (" .. tostring(response) .. ")"
    end

    local decodeSuccess, data = pcall(function()
        return http:JSONDecode(response)
    end)

    if not decodeSuccess then
        warn("❌ JSON Decode lỗi: ", data)
        return false, "⚠️ Lỗi phân tích JSON dữ liệu key!"
    end

    for _, entry in pairs(data) do
        if entry.code == key then
            if entry.blacklisted then
                return false, "🚫 Key này đã bị blacklist!"
            end
            if not entry.hwid or entry.hwid == "" then
                sendHWIDBindRequest()
                return false, "📩 Đã gửi yêu cầu bind HWID. Vui lòng đợi admin xác nhận!"
            end
            if entry.hwid == hwid then
                return true, "✅ Key và HWID hợp lệ!"
            else
                return false, "❌ HWID không khớp với key này!"
            end
        end
    end

    return false, "❌ Key không tồn tại hoặc sai định dạng!"
end

local valid, message = isValidKeyAndHWID()
if not valid then
    warn("[DEBUG] Key:", key)
    warn("[DEBUG] HWID:", hwid)
    game.Players.LocalPlayer:Kick(message)
    return
end

-- Load script chính
getgenv().Team = "Marines"
loadstring(game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/refs/heads/main/Phat.lua"))()
