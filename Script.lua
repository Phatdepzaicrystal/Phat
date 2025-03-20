local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/keys.json"
local githubToken = "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"

local player = Players.LocalPlayer
local device_id = gethwid and gethwid() or "Unknown"

-- Kiểm tra nếu không có key thì kick
if not getgenv().Key then
    player:Kick("⚠️ Key may dau thg da den")
    return
end

-- Hàm tải JSON từ GitHub
local function fetchJson(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    return success and HttpService:JSONDecode(response) or nil
end

-- Hàm cập nhật keys.json trên GitHub
local function updateKeysFile(newKeys)
    local newContent = HttpService:JSONEncode(newKeys)

    local shaResponse = fetchJson(githubApiUrl)
    local sha = shaResponse and shaResponse.sha or ""

    local body = HttpService:JSONEncode({
        message = "🔄 Update HWID for key",
        content = game.HttpService:JSONEncode(newContent),
        sha = sha
    })

    local headers = {
        ["Authorization"] = "token " .. githubToken,
        ["Content-Type"] = "application/json"
    }

    local response = http and http.request({
        Url = githubApiUrl,
        Method = "PUT",
        Headers = headers,
        Body = body
    })

    if response then
        print("🔄 GitHub Response:", response.StatusCode, response.Body)
    else
        print("⚠️ Executor không hỗ trợ http.request, không thể cập nhật HWID!")
    end
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
        if validKey.hwid and validKey.hwid ~= device_id then
            player:Kick("❌ Invalid HWID!")
            return
        end

        -- Nếu key chưa có HWID, lưu HWID mới vào GitHub
        if not validKey.hwid then
            validKey.hwid = device_id
            updateKeysFile(keys)
            print("✅ HWID mới đã được cập nhật trên GitHub:", device_id)
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
