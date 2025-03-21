local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- 🔗 API URL (Check & Thêm HWID)
local API_URL = "https://2cb8592c-0d94-4348-86b2-42d0bc9b841d-00-5tyyjf8nengg.sisko.replit.dev:8080"

-- 🔗 GitHub URL (Danh sách Key)
local GITHUB_URL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"

-- 📌 Lấy HWID của thiết bị
local function getHWID()
    return  gethwid and gethwid() or "Unknown"
end

-- 📌 Gửi Request tới API (Check hoặc Thêm HWID)
local function sendAPIRequest(endpoint, data, method)
    local jsonData = HttpService:JSONEncode(data)
    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = API_URL .. endpoint,
            Method = method,
            Headers = {["Content-Type"] = "application/json"},
            Body = jsonData
        })
    end)
    return success and response or nil
end

-- 📌 Lấy danh sách Key từ GitHub
local function getKeysFromGitHub()
    local success, response = pcall(function()
        return HttpService:GetAsync(GITHUB_URL)
    end)
    if success then
        return HttpService:JSONDecode(response)
    else
        return nil
    end
end

-- 📌 Kiểm tra Key trên GitHub
local function checkKey(providedKey)
    local keysData = getKeysFromGitHub()
    if not keysData then
        warn("❌ Không thể lấy danh sách key từ GitHub!")
        return false
    end

    for _, entry in ipairs(keysData) do
        if entry.code == providedKey then
            return true
        end
    end

    warn("❌ Key không hợp lệ!")
    return false
end

-- 📌 Kiểm tra HWID trên API
local function checkHWID()
    local hwid = getHWID()
    local data = { hwid = hwid }
    
    local response = sendAPIRequest("/check_hwid", data, "POST")
    if response then
        local result = HttpService:JSONDecode(response.Body)
        if result.status == "valid" then
            print("✅ HWID hợp lệ!")
            return true
        else
            return false
        end
    else
        warn("❌ Lỗi khi kiểm tra HWID!")
        return false
    end
end

-- 📌 Tự động thêm HWID vào API nếu chưa có
local function addHWID()
    local hwid = getHWID()
    local data = { hwid = hwid }
    
    local response = sendAPIRequest("/add_hwid", data, "POST")
    if response then
        local result = HttpService:JSONDecode(response.Body)
        print("✅ HWID đã được thêm: " .. result.message)
    else
        warn("❌ Lỗi khi thêm HWID!")
    end
end

-- 📌 Lấy Key người dùng nhập vào
if not getgenv().Key or getgenv().Key == "" then
    warn("⚠️ Bạn phải nhập key!")
    return
end
local providedKey = getgenv().Key

-- 📌 Kiểm tra Key & HWID trước khi chạy script
if checkKey(providedKey) then
    if checkHWID() then
        print("✅ Key & HWID hợp lệ! Chạy script...")
    else
        print("⚠️ HWID chưa có! Đang thêm vào API...")
        addHWID()
    end

    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
else
    warn("❌ Key không hợp lệ, script sẽ không chạy.")
end
