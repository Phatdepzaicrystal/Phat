local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local hwidListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/hwids.json"
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/hwids.json"
local githubToken = "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"  -- 🔥 Thay bằng token GitHub

local player = Players.LocalPlayer
local hwid = player.UserId .. "-" .. game:GetService("RbxAnalyticsService"):GetClientId()  -- 📌 Tạo HWID duy nhất

-- ⚠️ Kiểm tra key nhập vào
if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- 📥 Tải danh sách Key từ GitHub
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

    -- 🔍 Kiểm tra Key
    for _, k in pairs(keys) do
        if typeof(k) == "string" then
            if k == getgenv().Key then
                isKeyValid = true
                break
            end
        elseif typeof(k) == "table" and k.code then
            if k.code == getgenv().Key then
                isKeyValid = true
                break
            end
        end
    end

    -- 🔍 Kiểm tra HWID đã tồn tại chưa
    for _, h in pairs(hwids) do
        if h == hwid then
            isHWIDValid = true
            break
        end
    end

    if isKeyValid then
        if not isHWIDValid then
            -- 🚀 Gửi HWID mới lên GitHub
            table.insert(hwids, hwid)

            local newContent = HttpService:JSONEncode(hwids)
            local body = {
                message = "🔄 Update HWIDs",
                content = HttpService:Base64Encode(newContent),
                sha = fetchJson(githubApiUrl).sha
            }

            local headers = {
                ["Authorization"] = "token " .. githubToken,
                ["Content-Type"] = "application/json"
            }

            local request = http.request({
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
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    else
        player:Kick("❌ Invalid Key")
    end
else
    player:Kick("❌ Không thể tải danh sách Key hoặc HWID từ GitHub.")
end
