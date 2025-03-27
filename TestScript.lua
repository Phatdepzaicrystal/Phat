-- 🚀 Lấy HWID của thiết bị
local function getHWID()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local HWID = getHWID()
local API_BASE = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev"
local API_CHECK_HWID = API_BASE .. "/check_hwid?hwid=%s"
local API_UPDATE_HWID = API_BASE .. "/update_hwid?hwid=%s"

-- 📌 Gửi yêu cầu kiểm tra HWID
local function checkHWID()
    local url = string.format(API_CHECK_HWID, HWID)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        game.Players.LocalPlayer:Kick("🚫 Không thể kết nối tới máy chủ kiểm tra HWID!")
        return false
    end

    local HttpService = game:GetService("HttpService")
    local data = HttpService:JSONDecode(response)

    if data.status == "valid" then
        return true
    elseif data.status == "not_registered" then
        return "register"
    else
        return false
    end
end

-- 📌 Gửi yêu cầu cập nhật HWID
local function updateHWID()
    local url = string.format(API_UPDATE_HWID, HWID)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success and response then
        local HttpService = game:GetService("HttpService")
        local data = HttpService:JSONDecode(response)
        return data.status == "success"
    end

    return false
end

-- 📌 Kiểm tra & cập nhật HWID nếu chưa có
local result = checkHWID()

if result == true then
    print("✅ HWID hợp lệ! Tiếp tục...")
elseif result == "register" then
    local registered = updateHWID()
    if registered then
        print("✅ HWID đã được gán thành công!")
    else
        game.Players.LocalPlayer:Kick("❌ Không thể gán HWID! Hãy liên hệ hỗ trợ.")
    end
else
    game.Players.LocalPlayer:Kick("❌ HWID không hợp lệ! Hãy reset HWID.")
end
