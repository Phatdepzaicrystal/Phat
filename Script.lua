local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/keys.json"
local githubToken = "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"

local player = Players.LocalPlayer
local hwid = gethwid and gethwid() or "Unknown" -- Lấy HWID của thiết bị

if not getgenv().Key or getgenv().Key == "" then
    player:Kick("⚠️ Where Your Key?")
    return
end

-- Hàm tải JSON từ GitHub
local function fetchJson(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    return success and HttpService:JSONDecode(response) or nil
end

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

    if validKey then
        -- Nếu HWID đã tồn tại nhưng không khớp, kick
        if validKey.hwid and validKey.hwid ~= hwid then
            player:Kick("❌ Key hợp lệ nhưng HWID không đúng!")
            return
        end

        -- Nếu key chưa có HWID, lưu HWID mới vào GitHub
        if not validKey.hwid then
            validKey.hwid = hwid

            -- Cập nhật JSON với HWID mới
            local updatedKeys = keys
            for _, entry in ipairs(updatedKeys) do
                if entry.code == validKey.code then
                    entry.hwid = hwid
                    break
                end
            end

            local newContent = HttpService:JSONEncode(updatedKeys)
            local encodedContent = syn and syn.crypt.base64.encode(newContent) or newContent

            -- Lấy SHA của file trên GitHub
            local githubData = fetchJson(githubApiUrl)
            local sha = githubData and githubData.sha or ""

            local body = HttpService:JSONEncode({
                message = "🔄 Update HWID for key: " .. validKey.code,
                content = encodedContent,
                sha = sha
            })

            local headers = {
                ["Authorization"] = "token " .. githubToken,
                ["Content-Type"] = "application/json"
            }

            if http and http.request then
                http.request({
                    Url = githubApiUrl,
                    Method = "PUT",
                    Headers = headers,
                    Body = body
                })
                print("✅")
            else
                print("⚠️ Executor Not Support")
            end
        end

        print("✅ Key hợp lệ, chạy script...")
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    else
        player:Kick("❌ Invalid Key!")
    end
else
    player:Kick("❌ Script Down.Plz Wait To Fix")
end
