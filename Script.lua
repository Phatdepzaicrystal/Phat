local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Link file trên GitHub
local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local hwidListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/hwids.json"
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/hwids.json"
local githubToken = "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"

local player = Players.LocalPlayer
local device_id = gethwid and gethwid() or "Unknown" -- Lấy Device ID từ executor nếu có

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

local keys = fetchJson(keyListUrl)
local hwids = fetchJson(hwidListUrl) or {}

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
        -- Kiểm tra nếu HWID đã tồn tại nhưng Key khác
        for _, entry in pairs(hwids) do
            if entry.hwid == device_id and entry.key ~= getgenv().Key then
                player:Kick("❌ Thiết bị này đã dùng key khác trước đó!")
                return
            end
        end

        -- Nếu HWID chưa có, lưu vào `hwids.json`
        local newEntry = { key = getgenv().Key, hwid = device_id }
        table.insert(hwids, newEntry)

        -- Cập nhật file trên GitHub
        local newContent = HttpService:JSONEncode(hwids)
        local encodedContent = syn and syn.crypt.base64.encode(newContent) or newContent

        local body = {
            message = "🔄 Cập nhật HWID + Key",
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
            print("✅ HWID + Key đã được lưu:", device_id, "-", getgenv().Key)
        else
            print("⚠️ Không thể cập nhật HWID, executor không hỗ trợ `http.request`!")
        end

        print("✅ Key hợp lệ, chạy script...")
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    else
        player:Kick("❌ Key không hợp lệ!")
    end
else
    player:Kick("❌ Script Down.!")
end
