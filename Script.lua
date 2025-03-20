local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 🔹 GitHub thông tin
local githubRepo = "Phatdepzaicrystal/Key" -- Repo GitHub của bạn
local keysFile = "keys.json" -- File chứa danh sách key
local hwidsFile = "hwids.json" -- File lưu HWID + Key
local githubToken = "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" -- Thay bằng token của bạn

-- 🔹 Lấy Device ID (HWID)
local function getDeviceId()
    if gethwid then
        return gethwid() -- Một số executor hỗ trợ gethwid()
    elseif game:GetService("RbxAnalyticsService"):GetClientId() then
        return game:GetService("RbxAnalyticsService"):GetClientId() -- Cách tạm thời
    else
        return "Unknown"
    end
end

local player = Players.LocalPlayer
local hwid = getDeviceId()

if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- 🔹 Hàm tải JSON từ GitHub
local function fetchJson(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    return success and HttpService:JSONDecode(response) or nil
end

-- 🔹 URL file keys & hwids
local keysUrl = "https://raw.githubusercontent.com/" .. githubRepo .. "/main/" .. keysFile
local hwidsUrl = "https://raw.githubusercontent.com/" .. githubRepo .. "/main/" .. hwidsFile

local keys = fetchJson(keysUrl)
local hwids = fetchJson(hwidsUrl) or {}

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
        -- Kiểm tra nếu HWID đã tồn tại nhưng không khớp -> Kick
        for _, entry in pairs(hwids) do
            if entry.key == validKey.code and entry.hwid ~= hwid then
                player:Kick("❌ HWID không hợp lệ!")
                return
            end
        end

        -- Nếu HWID chưa được lưu, thêm vào GitHub
        local newEntry = { key = validKey.code, hwid = hwid }
        table.insert(hwids, newEntry)

        -- 🔹 Cập nhật hwids.json trên GitHub
        local newContent = HttpService:JSONEncode(hwids)
        local encodedContent = syn and syn.crypt.base64.encode(newContent) or newContent

        local body = {
            message = "🔄 Update HWID for key: " .. validKey.code,
            content = encodedContent,
            sha = fetchJson("https://api.github.com/repos/" .. githubRepo .. "/contents/" .. hwidsFile).sha
        }

        local headers = {
            ["Authorization"] = "token " .. githubToken,
            ["Content-Type"] = "application/json"
        }

        if http and http.request then
            http.request({
                Url = "https://api.github.com/repos/" .. githubRepo .. "/contents/" .. hwidsFile,
                Method = "PUT",
                Headers = headers,
                Body = HttpService:JSONEncode(body)
            })
            print("✅ HWID đã được lưu trên GitHub:", hwid)
        else
            print("⚠️ Executor không hỗ trợ `http.request`, không thể cập nhật HWID!")
        end

        -- 🔹 Key hợp lệ -> Load script chính
        print("✅ Key hợp lệ, chạy script...")
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    else
        player:Kick("❌ Key không hợp lệ!")
    end
else
    player:Kick("❌ Không thể tải danh sách key từ GitHub!")
end
