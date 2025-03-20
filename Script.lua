local HttpService = game:GetService("HttpService")
local http = (syn and syn.request) or (http and http.request) or http_request or request

local GITHUB_TOKEN = "ghp_xxx"  -- Thay bằng token GitHub của bạn
local REPO = "Phatdepzaicrystal/Key"
local KEYS_FILE = "keys.json"
local HWIDS_FILE = "hwids.json"

local key = getgenv().Key or ""
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()  -- HWID theo thiết bị

if key == "" then game.Players.LocalPlayer:Kick("⚠️ Vui lòng nhập key!") return end

-- Hàm lấy dữ liệu từ GitHub
local function fetchFile(file)
    local url = "https://raw.githubusercontent.com/"..REPO.."/main/"..file
    local success, response = pcall(function() return game:HttpGet(url) end)
    return success and HttpService:JSONDecode(response) or {}
end

-- Hàm ghi dữ liệu lên GitHub
local function uploadToGitHub(file, data)
    local json = HttpService:JSONEncode(data)
    local base64 = syn and syn.crypt.base64.encode(json) or json
    local apiURL = "https://api.github.com/repos/"..REPO.."/contents/"..file

    -- Lấy SHA nếu file đã tồn tại
    local sha = nil
    local shaReq = http({Url = apiURL, Method = "GET", Headers = {["Authorization"] = "token "..GITHUB_TOKEN}})
    if shaReq.StatusCode == 200 then
        sha = HttpService:JSONDecode(shaReq.Body).sha
    end

    -- Cập nhật file trên GitHub
    http({
        Url = apiURL, Method = "PUT",
        Headers = {["Authorization"] = "token "..GITHUB_TOKEN, ["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({message = "🔐 Update "..file, content = base64, sha = sha or ""})
    })
end

-- Kiểm tra key hợp lệ
local keys = fetchFile(KEYS_FILE)
local validKey = false
for _, entry in ipairs(keys) do
    if entry.key == key then validKey = true break end
end
if not validKey then game.Players.LocalPlayer:Kick("❌ Key không hợp lệ!") return end

-- Kiểm tra HWID đã tồn tại chưa
local hwids = fetchFile(HWIDS_FILE)
local hwidExists = false
for _, entry in ipairs(hwids) do
    if entry.hwid == hwid then hwidExists = true break end
end

-- Nếu HWID chưa có thì lưu vào GitHub
if not hwidExists then
    table.insert(hwids, {key = key, hwid = hwid})
    uploadToGitHub(HWIDS_FILE, hwids)
    print("✅ HWID mới đã được lưu trên GitHub:", hwid)
end

print("✅ Key hợp lệ, chạy script...")
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
