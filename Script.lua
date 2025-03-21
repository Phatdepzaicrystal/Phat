local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- URL chứa keys.json trên GitHub
local keysURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

-- API cập nhật keys.json trên GitHub
local updateURL = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/keys.json"
local githubToken = "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" 

-- 📌 Lấy HWID từ Executor hoặc Client ID từ Roblox
local hwid = gethwid and gethwid() or "Unknown"

-- 📌 Hàm lấy keys.json từ GitHub
local function getKeys()
    local success, result = pcall(function()
        return HttpService:GetAsync(keysURL)
    end)

    if success then
        return HttpService:JSONDecode(result)
    else
        return nil
    end
end

-- 📌 Hàm lấy SHA của keys.json từ GitHub
local function getSHA()
    local success, result = pcall(function()
        return HttpService:GetAsync(updateURL, true, {
            ["Authorization"] = "token " .. githubToken
        })
    end)

    if success then
        local data = HttpService:JSONDecode(result)
        return data.sha
    else
        return nil
    end
end

-- 📌 Hàm cập nhật keys.json lên GitHub
local function updateKeys(keys)
    local content = HttpService:JSONEncode(keys)
    local sha = getSHA()

    if not sha then
        LocalPlayer:Kick("❌ Lỗi lấy SHA của keys.json!")
        return false
    end

    local data = {
        message = "Update keys.json",
        content = HttpService:Base64Encode(content),
        sha = sha
    }

    local headers = {
        ["Authorization"] = "token " .. githubToken,
        ["Content-Type"] = "application/json"
    }

    local success, response = pcall(function()
        return HttpService:PostAsync(updateURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, headers)
    end)

    return success
end

-- 📌 Hàm lấy key của người chơi từ danh sách keys.json
local function getUserKey(keysData)
    for key, storedHWID in pairs(keysData) do
        if storedHWID == hwid or storedHWID == "" then
            return key
        end
    end
    return nil
end

-- 📌 Kiểm tra key & HWID
local keysData = getKeys()

if keysData then
    local userKey = getUserKey(keysData)

    if userKey then
        if keysData[userKey] == hwid then
            print("✅ Key & HWID hợp lệ! Đang chạy script...")
            getgenv().Language = "English"
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
        elseif keysData[userKey] == "" then
            -- 🚀 Nếu HWID chưa có, tự động thêm HWID vào GitHub
            keysData[userKey] = hwid
            if updateKeys(keysData) then
                print("✅ HWID đã được liên kết với key!")
                LocalPlayer:Kick("⚠️ HWID của bạn đã được liên kết! Vui lòng thử lại.")
            else
                LocalPlayer:Kick("❌ Lỗi khi cập nhật keys.json!")
            end
        else
            LocalPlayer:Kick("❌ Key đúng nhưng HWID sai!")
        end
    else
        LocalPlayer:Kick("❌ Không tìm thấy key hợp lệ!")
    end
else
    LocalPlayer:Kick("❌ Không thể lấy danh sách keys!")
end
