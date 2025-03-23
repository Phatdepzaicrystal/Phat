local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local HWID = gethwid and gethwid() or "Unknown" -- Lấy HWID
local KeyFileURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json" -- 🔥 Link chứa key
local DiscordWebhook = "https://discord.com/api/webhooks/1352103223837720687/_Y7y3ciBgDTCd7IykQQTy9X9wEjAjD_uZ9y9I5ZYLmLmvn1O7lhBFFWLhtuy3vD87zbP" -- 🔥 Webhook Discord

-- Tải danh sách key từ GitHub
local function GetKeys()
    local success, response = pcall(function()
        return HttpService:GetAsync(KeyFileURL)
    end)

    if success then
        local keysData = HttpService:JSONDecode(response)
        return keysData
    else
        warn("⚠️ Lỗi tải danh sách key từ GitHub!")
        return nil
    end
end

-- Kiểm tra xem HWID đã tồn tại trong danh sách key chưa
local function CheckKey()
    local keys = GetKeys()
    if not keys then return false end

    for _, entry in pairs(keys) do
        if entry.HWID == HWID then
            print("✅ Key hợp lệ! Tiến hành gửi HWID lên webhook...")
            return entry.Key -- Trả về Key nếu tìm thấy HWID
        end
    end
    return nil
end

-- Gửi thông tin HWID lên Discord Webhook
local function SendToWebhook(verifiedKey)
    local data = {
        content = "**:key: Yêu cầu Redeem Key**\n",
        embeds = {{
            title = "Thông tin người dùng",
            fields = {
                { name = ":small_blue_diamond: HWID", value = HWID, inline = true },
                { name = ":id: User ID", value = tostring(LocalPlayer.UserId), inline = true },
                { name = ":bust_in_silhouette: Username", value = LocalPlayer.Name, inline = true },
                { name = ":key: Key Được Duyệt", value = verifiedKey, inline = true }
            },
            color = 16711680
        }}
    }

    local request = syn and syn.request or http_request or request
    if request then
        request({
            Url = DiscordWebhook,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- Chạy script nếu key hợp lệ
local verifiedKey = CheckKey()
if verifiedKey then
    SendToWebhook(verifiedKey)
    print("✅ Key hợp lệ! Chạy script...")

    -- 🔥 Chạy script
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
else
    print("❌ Key không hợp lệ hoặc HWID chưa được đăng ký!")
end
