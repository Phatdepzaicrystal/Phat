repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập key!")
    return
end

-- 🔗 URL chứa danh sách Key & HWID
local keysURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local hwidURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/hwid.json"

local keyValid = false
local hwidValid = false
local hwidRegistered = false

-- 🚀 Lấy HWID của thiết bị
local function getHWID()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local HWID = gethwid and gethwid() or "Unknown"

-- 📌 Kiểm tra Key
local function checkKey()
    local success, response = pcall(function()
        return game:HttpGet(keysURL)
    end)

    if not success then
        game.Players.LocalPlayer:Kick("🚫 Không thể kết nối tới máy chủ kiểm tra key!")
        return
    end

    local HttpService = game:GetService("HttpService")
    local keysData = HttpService:JSONDecode(response)

    if keysData[getgenv().Key] and keysData[getgenv().Key] > os.time() then
        keyValid = true
    end
end

-- 📌 Kiểm tra HWID đã gắn với Key chưa
local function checkHWID()
    local success, response = pcall(function()
        return game:HttpGet(hwidURL)
    end)

    if not success then
        game.Players.LocalPlayer:Kick("🚫 Không thể kết nối tới máy chủ kiểm tra HWID!")
        return
    end

    local HttpService = game:GetService("HttpService")
    local hwidData = HttpService:JSONDecode(response)

    if hwidData[getgenv().Key] and hwidData[getgenv().Key] == HWID then
        hwidValid = true
    elseif hwidData[getgenv().Key] == nil then
        hwidRegistered = false
    end
end

-- 🔄 Cập nhật HWID nếu chưa có
local function updateHWID()
    local updateURL = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/hwid.json"
    local requestBody = {
        message = "Gán HWID với Key",
        content = game:GetService("HttpService"):JSONEncode({[getgenv().Key] = HWID}),
        sha = nil  -- Lấy SHA từ GitHub trước khi cập nhật (cần thêm API Token nếu dùng API này)
    }

    local rq = http_request or request or syn and syn.request
    if rq then
        local res = rq({
            Url = updateURL,
            Method = "PUT",
            Headers = {
                ["Authorization"] = "token YOUR_GITHUB_API_TOKEN",
                ["Content-Type"] = "application/json"
            },
            Body = game:GetService("HttpService"):JSONEncode(requestBody)
        })

        if res and res.StatusCode == 200 then
            hwidRegistered = true
        end
    else
        game.Players.LocalPlayer:Kick("❌ Không thể cập nhật HWID! Hãy liên hệ hỗ trợ.")
    end
end

-- 📌 Tiến hành kiểm tra Key & HWID
checkKey()
checkHWID()

if not keyValid then
    game.Players.LocalPlayer:Kick("❌ Key không hợp lệ hoặc đã hết hạn!")
    return
end

if not hwidValid then
    if hwidRegistered then
        game.Players.LocalPlayer:Kick("❌ HWID không hợp lệ! Hãy reset HWID.")
    else
        updateHWID()
        if hwidRegistered then
            print("✅ HWID đã được gán với Key! Đang tải script...")
        else
            game.Players.LocalPlayer:Kick("❌ Không thể gán HWID! Hãy liên hệ hỗ trợ.")
        end
    end
    return
end

print("✅ Key & HWID hợp lệ! Đang tải script...")
