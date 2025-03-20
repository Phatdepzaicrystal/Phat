local HttpService = game:GetService("HttpService")
local http = (syn and syn.request) or (http and http.request) or http_request or request

local GITHUB_TOKEN = "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"  -- Thay bằng token GitHub của bạn
local REPO_OWNER = "Phatdepzaicrystal"
local REPO_NAME = "Key"
local KEYS_FILE = "keys.json"
local HWIDS_FILE = "hwids.json"

local function getGitHubRawURL(file)
    return "https://raw.githubusercontent.com/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/main/" .. file
end

local function getGitHubAPIURL(file)
    return "https://api.github.com/repos/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/contents/" .. file
end

local key = getgenv().Key or ""
local hwid = gethwid and gethwid() or "Unknown"

if key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Vui lòng nhập key trước khi chạy script!")
    return
end

-- Lấy dữ liệu từ GitHub
local function fetchFile(file)
    local success, response = pcall(function()
        return game:HttpGet(getGitHubRawURL(file))
    end)
    return success and HttpService:JSONDecode(response) or {}
end

-- Lưu dữ liệu lên GitHub
local function uploadToGitHub(file, data)
    local jsonContent = HttpService:JSONEncode(data)
    local base64Content = syn and syn.crypt.base64.encode(jsonContent) or jsonContent
    local sha = nil

    local shaRequest = http({
        Url = getGitHubAPIURL(file),
        Method = "GET",
        Headers = { ["Authorization"] = "token " .. GITHUB_TOKEN }
    })

    if shaRequest.StatusCode == 200 then
        local shaResponse = HttpService:JSONDecode(shaRequest.Body)
        sha = shaResponse.sha
    end

    local updateRequest = http({
        Url = getGitHubAPIURL(file),
        Method = "PUT",
        Headers = {
            ["Authorization"] = "token " .. GITHUB_TOKEN,
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            message = "🔐 Update " .. file,
            content = base64Content,
            sha = sha or ""
        })
    })

    return updateRequest.StatusCode == 200 or updateRequest.StatusCode == 201
end

-- Cập nhật keys.json
local function updateKeys()
    local keysData = fetchFile(KEYS_FILE)

    for _, entry in ipairs(keysData) do
        if entry.key == key then
            print("✅ Key hợp lệ, tiếp tục kiểm tra HWID...")
            return true
        end
    end

    game.Players.LocalPlayer:Kick("❌ Key không hợp lệ!")
    return false
end

-- Cập nhật hwids.json
local function updateHWID()
    local hwidsData = fetchFile(HWIDS_FILE)

    for _, entry in ipairs(hwidsData) do
        if entry.hwid == hwid then
            print("✅ HWID đã có, không cần cập nhật.")
            return
        end
    end

    table.insert(hwidsData, { key = key, hwid = hwid })
    if uploadToGitHub(HWIDS_FILE, hwidsData) then
        print("✅ HWID mới đã được lưu trên GitHub:", hwid)
    else
        warn("❌ Lỗi khi cập nhật HWID!")
    end
end

-- Chạy kiểm tra và cập nhật
if updateKeys() then
    updateHWID()
    print("✅ Key hợp lệ, chạy script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
end
