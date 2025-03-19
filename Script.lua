local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 🌍 Đường dẫn file trên GitHub
local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local hwidListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/hwids.json"
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/hwids.json"

-- 🔑 Token GitHub để cập nhật HWID
local githubToken = "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"  

-- 📌 Lấy thông tin người chơi & HWID
local player = Players.LocalPlayer
local hwid = player.UserId .. "-" .. game:GetService("RbxAnalyticsService"):GetClientId()

-- 🚫 Nếu chưa nhập key, kick ngay lập tức
if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- 📥 Hàm tải dữ liệu JSON từ GitHub
local function fetchJson(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    return success and HttpService:JSONDecode(response) or nil
end

-- 🔄 Lấy danh sách key và HWID từ GitHub
local keys = fetchJson(keyListUrl)
local hwids = fetchJson(hwidListUrl)

-- 🚨 Nếu không tải được dữ liệu, kick
if not keys or not hwids then
    player:Kick("❌ Error")
    return
end

-- 🔍 Kiểm tra Key hợp lệ
local isKeyValid = false
for _, k in pairs(keys) do
    if k == getgenv().Key then
        isKeyValid = true
        break
    end
end

-- 🚫 Nếu key không hợp lệ, kick ngay
if not isKeyValid then
    player:Kick("❌ Key không hợp lệ!")
    return
end

-- 🔍 Kiểm tra HWID hợp lệ
local isHWIDValid = false
for _, h in pairs(hwids) do
    if h == hwid then
        isHWIDValid = true
        break
    end
end

-- ✅ Nếu HWID hợp lệ, chạy script chính
if isHWIDValid then
    print("✅ HWID hợp lệ, đang chạy script...")
else
    -- 📌 Nếu HWID chưa có, thêm vào GitHub
    table.insert(hwids, hwid)

    -- 🔄 Encode dữ liệu JSON
    local newContent = HttpService:JSONEncode(hwids)
    local encodedContent = syn and syn.crypt.base64.encode(newContent) or base64.encode(newContent) 

    -- 📨 Tạo body request để cập nhật file trên GitHub
    local body = {
        message = "🔄 Update HWIDs",
        content = encodedContent,
        sha = fetchJson(githubApiUrl).sha
    }

    local headers = {
        ["Authorization"] = "token " .. githubToken,
        ["Content-Type"] = "application/json"
    }

    -- 📡 Gửi request để cập nhật danh sách HWID trên GitHub
    local success, err = pcall(function()
        http.request({
            Url = githubApiUrl,
            Method = "PUT",
            Headers = headers,
            Body = HttpService:JSONEncode(body)
        })
    end)

    if success then
        print("✅ HWID mới đã được gửi lên GitHub:", hwid)
    else
        print("❌ Lỗi khi gửi HWID lên GitHub:", err)
    end
end

-- 🚀 Chạy script chính sau khi kiểm tra xong
getgenv().Team = "Marines"  
loadstring(game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/main/Phat.lua"))()
