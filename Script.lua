local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local hwidListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/hwids.json"
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/hwids.json"
local githubToken = "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"  

local player = Players.LocalPlayer
local hwid = player.UserId .. "-" .. game:GetService("RbxAnalyticsService"):GetClientId()

if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- 📥 Tải dữ liệu JSON từ GitHub
local function fetchJson(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    return success and HttpService:JSONDecode(response) or nil
end

local keys = fetchJson(keyListUrl)
local hwids = fetchJson(hwidListUrl)

if keys and hwids then
    local isKeyValid = false
    local isHWIDValid = false

    for _, k in pairs(keys) do
        if k == getgenv().Key then
            isKeyValid = true
            break
        end
    end

    for _, h in pairs(hwids) do
        if h == hwid then
            isHWIDValid = true
            break
        end
    end

    if isKeyValid then
        if not isHWIDValid then
            table.insert(hwids, hwid)

            local newContent = HttpService:JSONEncode(hwids)
            local encodedContent = syn and syn.crypt.base64.encode(newContent) or base64.encode(newContent) 

            local body = {
                message = "🔄 Update HWIDs",
                content = encodedContent,
                sha = fetchJson(githubApiUrl).sha
            }

            local headers = {
                ["Authorization"] = "token " .. githubToken,
                ["Content-Type"] = "application/json"
            }

            http.request({
                Url = githubApiUrl,
                Method = "PUT",
                Headers = headers,
                Body = HttpService:JSONEncode(body)
            })

            print("✅ HWID mới đã được gửi lên GitHub:", hwid)
        else
            print("✅ HWID hợp lệ, đang chạy script...")
        end

        -- 👉 Chạy script chính
        getgenv().Team = "Marines"  
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/main/Phat.lua"))()
    else
        player:Kick("❌ Invalid Key")
    end
else
    player:Kick("❌ Không thể tải danh sách Key hoặc HWID từ GitHub.")
end
