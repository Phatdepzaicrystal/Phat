local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local API_URL = "https://2cb8592c-0d94-4348-86b2-42d0bc9b841d-00-5tyyjf8nengg.sisko.replit.dev:8080"

local GITHUB_URL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"

local function getHWID()
    return gethwid and gethwid() or "Unknown"
end

-- 📌 Gửi Request tới API (Check hoặc Thêm HWID)
local function sendAPIRequest(endpoint, data)
    local jsonData = HttpService:JSONEncode(data)
    local success, response = pcall(function()
        return HttpService:PostAsync(API_URL .. endpoint, jsonData, Enum.HttpContentType.ApplicationJson)
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

-- 📌 Kiểm tra Key và HWID trên GitHub
local function checkKey(providedKey)
    local keysData = getKeysFromGitHub()
    if not keysData then
        player:Kick("❌ Không thể lấy danh sách key từ GitHub!")
        return false
    end

    for _, entry in ipairs(keysData) do
        if entry.code == providedKey then
            if entry.hwid == "" or entry.hwid == getHWID() then
                print("✅ Key hợp lệ!")
                return true
            else
                print("❌ HWID không trùng khớp!")
                player:Kick("⚠️ HWID không trùng với key!")
                return false
            end
        end
    end

    print("❌ Key không hợp lệ!")
    player:Kick("⚠️ Key không hợp lệ!")
    return false
end

-- 📌 Kiểm tra HWID trên API
local function checkHWID()
    local hwid = getHWID()
    local data = { hwid = hwid }
    
    local response = sendAPIRequest("/check_hwid", data)
    if response then
        local result = HttpService:JSONDecode(response)
        if result.status == "valid" then
            print("✅ HWID hợp lệ!")
            return true
        else
            print("❌ HWID không hợp lệ!")
            return false
        end
    else
        warn("❌ Lỗi khi kiểm tra HWID!")
        return false
    end
end

-- 📌 Thêm HWID vào API nếu chưa có
local function addHWID()
    local hwid = getHWID()
    local data = { hwid = hwid }
    
    local response = sendAPIRequest("/add_hwid", data)
    if response then
        local result = HttpService:JSONDecode(response)
        print("✅ HWID đã được thêm: " .. result.message)
    else
        warn("❌ Lỗi khi thêm HWID!")
    end
end

-- 📌 Lấy Key người dùng nhập vào
if not getgenv().Key or getgenv().Key == "" then
    player:Kick("⚠️ Bạn phải nhập key!")
    return
end
local providedKey = getgenv().Key

-- 📌 Kiểm tra Key & HWID trước khi chạy script
if checkKey(providedKey) and checkHWID() then
    print("✅ Key & HWID hợp lệ! Chạy script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2"))()
else
    print("⚠️ Không hợp lệ! Thêm HWID vào API...")
    addHWID()
    player:Kick("⚠️ HWID chưa được đăng ký. Hãy thử lại!")
end
