local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local device_id = gethwid and gethwid() or "Unknown"

-- Check if key is provided
if not getgenv().Key or getgenv().Key == "" then
    player:Kick("⚠️ You must enter a key!")
    return
end

local providedKey = getgenv().Key

-- GitHub configuration
local REPO_OWNER = "Phatdepzaicrystal"
local REPO_NAME = "Key"
local FILE_PATH = "keys.json"

-- ✅ Sử dụng raw URL chính xác
local RAW_URL = "https://raw.githubusercontent.com/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/main/" .. FILE_PATH

-- API để lưu HWID
local HWID_API_URL = "https://2cb8592c-0d94-4348-86b2-42d0bc9b841d-00-5tyyjf8nengg.sisko.replit.dev:8080/save_hwid"

-- Function lấy danh sách key từ GitHub
local function getKeys()
    local success, response = pcall(function()
        return HttpService:GetAsync(RAW_URL)
    end)
    if success then
        return HttpService:JSONDecode(response)
    else
        error("❌ Lỗi khi tải keys.json từ GitHub!")
    end
end

-- Function gửi HWID lên API nếu chưa có
local function saveHWID(key)
    local payload = HttpService:JSONEncode({
        key = key,
        hwid = device_id
    })

    local success, result = pcall(function()
        return HttpService:PostAsync(HWID_API_URL, payload, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("✅ HWID đã được lưu vào API!")
    else
        warn("❌ Lỗi khi lưu HWID vào API!")
    end
end

-- Function kiểm tra key có hợp lệ không
local function checkKey(providedKey)
    local keysTable = getKeys()
    
    for _, entry in ipairs(keysTable) do
        if entry.code == providedKey then
            print("✅ Key hợp lệ!")
            saveHWID(providedKey) -- Lưu HWID vào API
            return true
        end
    end

    print("❌ Key không hợp lệ!")
    player:Kick("Invalid key!")
    return false
end

-- Kiểm tra key trước khi chạy script
if checkKey(providedKey) then
    print("✅ Đang tải script chính...")
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2"))()
else
    print("❌ Không thể chạy script!")
end
