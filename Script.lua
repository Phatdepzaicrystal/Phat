local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local hwidListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/hwids.json"
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/keys.json"
local githubToken = "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"

local player = Players.LocalPlayer
local hwid = player.UserId .. "-" .. game:GetService("RbxAnalyticsService"):GetClientId()

if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- 📥 Hàm tải JSON từ GitHub
local function fetchJson(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    return success and HttpService:JSONDecode(response) or nil
end

local keys = fetchJson(keyListUrl)

if keys then
    local validKey = nil

    -- 🔍 Kiểm tra key trong danh sách
    for _, entry in pairs(keys) do
        if entry.code == getgenv().Key then
            validKey = entry
            break
        end
    end

    -- Nếu key hợp lệ, kiểm tra userId và HWID
    if validKey then
        -- Nếu key có userId nhưng không khớp tài khoản, kick
        if validKey.userId and tostring(validKey.userId) ~= tostring(player.UserId) then
            player:Kick("❌ Key này không dành cho tài khoản của bạn!")
            return
        end

        -- Nếu key có HWID nhưng không khớp, kick
        if validKey.hwid and validKey.hwid ~= hwid then
            player:Kick("❌ Key này không dành cho thiết bị của bạn!")
            return
        end

        -- Nếu key chưa có HWID, cập nhật HWID lên GitHub
        if not validKey.hwid then
            validKey.hwid = hwid

            local newContent = HttpService:JSONEncode(keys)
            local encodedContent = syn and syn.crypt.base64.encode(newContent) or newContent

            local body = {
                message = "🔄 Update HWID for key: " .. validKey.code,
                content = encodedContent,
                sha = fetchJson(githubApiUrl) and fetchJson(githubApiUrl).sha or ""
            }

            local headers = {
                ["Authorization"] = "token " .. githubToken,
                ["Content-Type"] = "application/json"
            }

            if http and http.request then
                http.request({
                    Url = githubApiUrl,
                    Method = "PUT",
                    Headers = headers,
                    Body = HttpService:JSONEncode(body)
                })
                print("✅ HWID mới đã được cập nhật trên GitHub:", hwid)
            else
                print("⚠️ Executor không hỗ trợ `http.request`, không thể cập nhật HWID!")
            end
        end

        print("✅ Key hợp lệ, chạy script...")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubTH"))()
    else
        player:Kick("❌ Key không hợp lệ!")
    end
else
    player:Kick("❌ Không thể tải danh sách key từ GitHub!")
end
