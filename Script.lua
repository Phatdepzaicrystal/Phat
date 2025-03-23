local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🔥 GitHub Key Storage
local GitHubToken = "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" -- 🔑 Thay token GitHub của bạn
local RepoOwner = "Phatdepzaicrystal"
local RepoName = "Key"
local KeyFilePath = "keys.json"
local RawKeyFileURL = "https://raw.githubusercontent.com/" .. RepoOwner .. "/" .. RepoName .. "/main/" .. KeyFilePath
local APIKeyFileURL = "https://api.github.com/repos/" .. RepoOwner .. "/" .. RepoName .. "/contents/" .. KeyFilePath

-- 🔥 Webhook Discord
local DiscordWebhook = "https://discord.com/api/webhooks/1352103223837720687/_Y7y3ciBgDTCd7IykQQTy9X9wEjAjD_uZ9y9I5ZYLmLmvn1O7lhBFFWLhtuy3vD87zbP"

-- 🔹 HWID của người dùng
local HWID = gethwid and gethwid() or "Unknown"

-- 🛠️ Tải danh sách key từ GitHub
local function GetKeys()
    local success, response = pcall(function()
        return game:HttpGet(RawKeyFileURL)
    end)

    if success and response then
        return HttpService:JSONDecode(response)
    else
        warn("⚠️ Lỗi tải danh sách key từ GitHub!")
        return nil
    end
end

-- 🛠️ Cập nhật HWID vào GitHub nếu chưa có
local function UpdateKeys(keys)
    local headers = {
        ["Authorization"] = "token " .. GitHubToken,
        ["Accept"] = "application/vnd.github.v3+json",
        ["Content-Type"] = "application/json"
    }

    local encodedKeys = HttpService:JSONEncode(keys)
    local shaResponse = game:HttpGet(APIKeyFileURL)
    local sha = HttpService:JSONDecode(shaResponse).sha

    local data = {
        message = "Update HWID",
        content = HttpService:JSONEncode(keys):gsub(".", function(c)
            return string.format("%02X", string.byte(c))
        end),
        sha = sha
    }

    local success, response = pcall(function()
        return HttpService:PostAsync(APIKeyFileURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, headers)
    end)

    if success then
        print("✅ HWID cập nhật thành công trên GitHub!")
    else
        warn("⚠️ Lỗi cập nhật HWID!")
    end
end

-- 🔑 Kiểm tra Key & HWID
local function CheckKey()
    local keys = GetKeys()
    if not keys then return nil end

    for _, entry in pairs(keys) do
        if entry.code then
            if entry.hwid == nil then
                print("🆕 Gán HWID mới!")
                entry.hwid = HWID
                UpdateKeys(keys)
                return entry.code
            elseif entry.hwid == HWID then
                print("✅ Key hợp lệ!")
                return entry.code
            end
        end
    end
    return nil
end

-- 🚀 Gửi thông tin HWID lên Discord Webhook
local function SendToWebhook(verifiedKey)
    local data = {
        content = "**🔑 Yêu cầu Redeem Key**\n",
        embeds = {{
            title = "Thông tin người dùng",
            fields = {
                { name = "🔹 HWID", value = HWID, inline = true },
                { name = "🔑 Key Được Duyệt", value = verifiedKey, inline = true }
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

-- 🏁 Kiểm tra Key và chạy script chính nếu hợp lệ
local verifiedKey = CheckKey()
if verifiedKey then
    SendToWebhook(verifiedKey)
    print("✅ Key hợp lệ! Chạy script...")
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
else
    print("❌ Key không hợp lệ hoặc HWID chưa được đăng ký!")
    LocalPlayer:Kick("🔴 Key không hợp lệ hoặc HWID chưa được đăng ký!")
end
