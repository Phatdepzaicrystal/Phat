local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local device_id = gethwid and gethwid() or "Unknown"

-- Nhập Key từ getgenv()
if not getgenv().Key or getgenv().Key == "" then
    warn("⚠️ Bạn chưa nhập Key!")
    return
end

local providedKey = getgenv().Key

-- Cấu hình GitHub để kiểm tra Key
local GITHUB_URL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

-- API để kiểm tra và thêm HWID
local API_URL = "https://2cb8592c-0d94-4348-86b2-42d0bc9b841d-00-5tyyjf8nengg.sisko.replit.dev:8080/check_hwid"

-- Hàm lấy danh sách Key từ GitHub
local function getKeysFromGitHub()
    local success, response = pcall(function()
        return HttpService:GetAsync(GITHUB_URL, true)
    end)
    if success then
        return HttpService:JSONDecode(response)
    else
        warn("❌ Không thể lấy danh sách Key từ GitHub! URL có thể bị lỗi.")
        return nil
    end
end

-- Hàm kiểm tra và thêm HWID từ API
local function checkAndAddHWID()
    local payload = HttpService:JSONEncode({ hwid = device_id })
    local headers = { ["Content-Type"] = "application/json" }

    local success, response = pcall(function()
        return HttpService:PostAsync(API_URL, payload, Enum.HttpContentType.ApplicationJson, false, headers)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        if data.status == "exists" then
            print("✅ HWID đã tồn tại trong hệ thống!")
        elseif data.status == "saved" then
            print("✅ HWID chưa có, đã thêm vào hệ thống!")
        else
            warn("❌ Lỗi không xác định khi kiểm tra HWID!")
        end
        return true
    else
        warn("❌ Không thể kết nối đến API HWID!")
        return false
    end
end

-- Kiểm tra Key từ GitHub
local keysTable = getKeysFromGitHub()
if not keysTable then
    warn("❌ Không thể tải danh sách Key, script sẽ không chạy!")
    return
end

local keyValid = false
for _, entry in ipairs(keysTable) do
    if entry.code == providedKey then
        keyValid = true
        break
    end
end

if keyValid then
    print("✅ Key hợp lệ!")
    if checkAndAddHWID() then
        print("🚀 Chạy script chính...")
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/refs/heads/main/TestScript.lua"))()
    end
else
    warn("❌ Key không hợp lệ!")
end
