local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/keys.json"
local githubToken = "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"

local player = Players.LocalPlayer
local hwid = player.UserId .. "-" .. game:GetService("RbxAnalyticsService"):GetClientId()

if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- Hàm tải JSON từ GitHub
local function fetchJson(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    return success and HttpService:JSONDecode(response) or nil
end

-- Lấy danh sách key từ GitHub
local keys = fetchJson(keyListUrl)

if keys then
    local validKey = nil

    -- Kiểm tra key trong danh sách
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
            player:Kick("❌ Invalid HWID!")
            return
        end

        -- Nếu key có HWID nhưng không khớp, kick
        if validKey.hwid and validKey.hwid ~= hwid then
            player:Kick("❌ Invalid HWID!")
            return
        end

        -- Nếu key chưa có HWID, cập nhật HWID lên GitHub
        if not validKey.hwid then
            validKey.hwid = hwid

            -- Lấy SHA của file keys.json
            local fileInfo = fetchJson(githubApiUrl)
            local sha = fileInfo and fileInfo.sha or nil

            if not sha then
                warn("⚠️ Không lấy được SHA của file! Không thể cập nhật HWID!")
                return
            end

            -- Cập nhật HWID vào danh sách keys
            local newContent = HttpService:JSONEncode(keys)
            local encodedContent = syn and syn.crypt.base64.encode(newContent) or HttpService:JSONEncode(newContent)

            local body = {
                message = "🔄 Cập nhật HWID cho key: " .. validKey.code,
                content = encodedContent,
                sha = sha
            }

            local headers = {
                ["Authorization"] = "token " .. githubToken,
                ["Content-Type"] = "application/json"
            }

            if http and http.request then
                local response = http.request({
                    Url = githubApiUrl,
                    Method = "PUT",
                    Headers = headers,
                    Body = HttpService:JSONEncode(body)
                })

                if response and response.Body then
                    print("📢 GitHub API Response:", response.Body)
                end

                print("✅ HWID mới đã được cập nhật trên GitHub:", hwid)
            else
                print("⚠️ Executor không hỗ trợ `http.request`, không thể cập nhật HWID!")
            end
        end

        print("✅ Key hợp lệ, chạy script...")
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    else
        player:Kick("❌ Key không hợp lệ!")
    end
else
    player:Kick("❌ Không thể tải danh sách key từ GitHub!")
end
