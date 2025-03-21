local HttpService = game:GetService("HttpService")
local device_id = gethwid and gethwid() or "Unknown"

-- Cấu hình GitHub
local GITHUB_TOKEN = "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"  -- Thay bằng token của bạn
local REPO_OWNER = "Phatdepzaicrystal"
local REPO_NAME = "Key"
local FILE_PATH = "keys.json"
local RAW_URL = "https://raw.githubusercontent.com/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/refs/heads/main/" .. FILE_PATH
local API_URL = "https://api.github.com/repos/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/contents/" .. FILE_PATH

-- Hàm tải keys.json từ GitHub
local function getKeys()
    local success, response = pcall(function()
        return HttpService:GetAsync(RAW_URL)
    end)
    if success then
        return HttpService:JSONDecode(response)
    else
        error("Lỗi tải keys.json từ GitHub!")
    end
end

-- Hàm lấy SHA của file keys.json (cần cho việc update file)
local function getSHA()
    local headers = { ["Authorization"] = "token " .. GITHUB_TOKEN }
    local success, response = pcall(function()
        return HttpService:GetAsync(API_URL, true)
    end)
    if success then
        local data = HttpService:JSONDecode(response)
        return data.sha
    else
        return nil
    end
end

-- Hàm cập nhật keys.json trên GitHub với nội dung mới
local function updateKeysOnGitHub(updatedKeys, sha)
    local jsonContent = HttpService:JSONEncode(updatedKeys)
    -- Sử dụng hàm Base64 của Synapse X nếu có, nếu không bạn cần thay thế
    local base64Content = (syn and syn.crypt.base64.encode or HttpService.Base64Encode)(jsonContent)
    local payload = {
         message = "🔐 Update keys.json: thêm HWID",
         content = base64Content,
         sha = sha or nil
    }
    local headers = {
         ["Authorization"] = "token " .. GITHUB_TOKEN,
         ["Content-Type"] = "application/json"
    }
    local success, result = pcall(function()
         return HttpService:RequestAsync{
             Url = API_URL,
             Method = "PUT",
             Headers = headers,
             Body = HttpService:JSONEncode(payload)
         }
    end)
    if success then
         print("✅ Update keys.json thành công!")
    else
         warn("❌ Update keys.json thất bại:", result)
    end
end

-- Hàm tự động chọn key hợp lệ
local function autoSelectKey(keysTable)
    -- Ở đây, ta chọn key đầu tiên có userId khác nil (tức đã được gán) hoặc key đầu tiên nếu chưa được gán
    for _, entry in ipairs(keysTable) do
         if entry.userId then
              return entry.code, true  -- true: đã có HWID
         end
    end
    -- Nếu không tìm thấy key nào có userId, chọn key đầu tiên (có thể là key trống)
    if #keysTable > 0 then
         return keysTable[1].code, false
    end
    return nil, false
end

-- Hàm kiểm tra và cập nhật HWID cho key nếu chưa có
local function checkAndAddHWID(user_key)
    local keysTable = getKeys()
    local keyFound = false
    local hwidPresent = false
    for i, entry in ipairs(keysTable) do
         if entry.code == user_key then
              keyFound = true
              if not entry.hwid then
                   entry.hwid = device_id
                   hwidPresent = false
                   print("✅ HWID được thêm vào key:", user_key)
              else
                   hwidPresent = (entry.hwid == device_id)
                   if not hwidPresent then
                        print("❌ HWID không khớp! Đã lưu HWID:", entry.hwid, "mà máy của bạn là:", device_id)
              end
              break
         end
    end
    if not keyFound then
         print("❌ Key không tồn tại trong hệ thống!")
         return false
    end
    -- Cập nhật file trên GitHub nếu HWID chưa có (hoặc không khớp, bạn có thể quyết định không update nếu không khớp)
    if not hwidPresent then
         local sha = getSHA()
         updateKeysOnGitHub(keysTable, sha)
         -- Sau khi update, nếu HWID không khớp thì dừng
         if not hwidPresent then
              return false
         end
    end
    return hwidPresent
end

-- Tự động chọn key (theo logic bạn mong muốn)
local user_key, alreadyHasHWID = autoSelectKey(getKeys())
if not user_key then
    print("❌ Không tìm thấy key hợp lệ!")
    return
end

-- Kiểm tra và cập nhật HWID nếu cần
local valid = checkAndAddHWID(user_key)

if valid then
    print("✅ Điều kiện key & HWID thoả mãn!")
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
else
    print("❌ Key hoặc HWID không hợp lệ, không chạy script.")
    game.Players.LocalPlayer:Kick("Key hoặc HWID không hợp lệ!")
end
