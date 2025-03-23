local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🔥 Thông tin GitHub
local GitHubToken = "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" 
local RepoOwner = "Phatdepzaicrystal"
local RepoName = "Key"
local KeyFilePath = "keys.json"
local KeyFileURL = "https://api.github.com/repos/" .. RepoOwner .. "/" .. RepoName .. "/contents/" .. KeyFilePath

-- 🔥 Thông tin Webhook
local DiscordWebhook = "https://discord.com/api/webhooks/1352103223837720687/_Y7y3ciBgDTCd7IykQQTy9X9wEjAjD_uZ9y9I5ZYLmLmvn1O7lhBFFWLhtuy3vD87zbP"

-- 🔹 Thông tin người dùng
local HWID = gethwid and gethwid() or "Unknown"
local UserId = tostring(LocalPlayer.UserId)

-- 🛠️ Lấy danh sách key từ GitHub (có token)
local function GetKeys()
    local headers = {
        ["Authorization"] = "token " .. GitHubToken,
        ["Accept"] = "application/vnd.github.v3.raw"
    }

    local success, response = pcall(function()
        return HttpService:GetAsync(KeyFileURL, false, headers)
    end)

    if success then
        return HttpService:JSONDecode(response)
    else
        warn("⚠️ Lỗi tải danh sách key từ GitHub!")
        return nil
    end
end

-- 🛠️ Cập nhật HWID vào GitHub (nếu HWID chưa có)
local function UpdateKeys(keys)
    local headers = {
        ["Authorization"] = "token " .. GitHubToken,
        ["Accept"] = "application/vnd.github.v3+json",
        ["Content-Type"] = "application/json"
    }

    local updatedKeys = HttpService:JSONEncode(keys)
    local shaResponse = HttpService:GetAsync(KeyFileURL, false, headers)
    local sha = HttpService:JSONDecode(shaResponse).sha

    local data = {
        message = "Update HWID for user",
        content = HttpService:JSONEncode(updatedKeys):gsub(".", function(c)
            return string.format("%02X", string.byte(c))
        end),
        sha = sha
    }

    local success, response = pcall(function()
        return HttpService:PostAsync(KeyFileURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, headers)
    end)

    if success then
        print("✅ Cập nhật HWID thành công!")
    else
        warn("⚠️ Lỗi cập nhật HWID!")
    end
end

-- 🔑 Kiểm tra Key & HWID
local function CheckKey()
    local keys = GetKeys()
    if not keys then return nil end

    for _, entry in pairs(keys) do
        if entry.code and entry.userId == UserId then
            if entry.hwid == nil then
                print("🆕 Gán HWID mới!")
                entry.hwid = HWID
                UpdateKeys(keys) -- 🛠️ Cập nhật HWID lên GitHub
                return entry.code
            elseif entry.hwid == HWID then
                print("✅ Key hợp lệ!")
                return entry.code
            else
                print("❌ HWID không hợp lệ!")
                return nil
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
                { name = "🆔 User ID", value = UserId, inline = true },
                { name = "👤 Username", value = LocalPlayer.Name, inline = true },
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

-- 🏁 Chạy script nếu key hợp lệ
local verifiedKey = CheckKey()
if verifiedKey then
    SendToWebhook(verifiedKey)
    print("✅ Key hợp lệ! Chạy script...")

    -- 🔥 Chạy script nếu key đúng
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
else
    print("❌ Key không hợp lệ hoặc HWID chưa được đăng ký!")
end
