local HttpService = game:GetService("HttpService")
local http_request = (syn and syn.request) or (http and http.request) or http_request or request

local github_token = "ghp_xxx" -- Thay bằng token GitHub của bạn
local repo = "Phatdepzaicrystal/Key"
local keys_file = "keys.json"
local hwids_file = "hwids.json"

local key = getgenv().Key or ""
local hwid = game:GetService("RbxAnalyticsService"):GetClientId() -- HWID theo thiết bị

if key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Vui lòng nhập key!") 
    return
end

-- Hàm lấy dữ liệu từ GitHub
function fetchFile(file)
    local url = "https://raw.githubusercontent.com/"..repo.."/main/"..file
    local success, response = pcall(function() return game:HttpGet(url) end)
    if success then
        return HttpService:JSONDecode(response)
    else
        return {}
    end
end

-- Hàm ghi dữ liệu lên GitHub
function uploadToGitHub(file, data)
    local json = HttpService:JSONEncode(data)
    local base64 = syn and syn.crypt.base64.encode(json) or json
    local apiURL = "https://api.github.com/repos/"..repo.."/contents/"..file

    -- Lấy SHA nếu file đã tồn tại
    local sha = nil
    local shaReq = http_request({
        Url = apiURL, 
        Method = "GET", 
        Headers = {["Authorization"] = "token "..github_token}
    })
    if shaReq.StatusCode == 200 then
        sha = HttpService:JSONDecode(shaReq.Body).sha
    end

    -- Cập nhật file trên GitHub
    http_request({
        Url = apiURL, 
        Method = "PUT",
        Headers = {
            ["Authorization"] = "token "..github_token, 
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            message = "🔐 Update "..file, 
            content = base64, 
            sha = sha or ""
        })
    })
end

-- Kiểm tra key hợp lệ
local keys = fetchFile(keys_file)
local validKey = false
for _, entry in pairs(keys) do
    if entry.key == key then
        validKey = true
        break
    end
end
if not validKey then
    game.Players.LocalPlayer:Kick("❌ Key không hợp lệ!")
    return
end

-- Kiểm tra HWID đã tồn tại chưa
local hwids = fetchFile(hwids_file)
local hwidExists = false
for _, entry in pairs(hwids) do
    if entry.hwid == hwid then
        hwidExists = true
        break
    end
end

-- Nếu HWID chưa có thì lưu vào GitHub
if not hwidExists then
    table.insert(hwids, {key = key, hwid = hwid})
    uploadToGitHub(hwids_file, hwids)
    print("✅ HWID mới đã được lưu trên GitHub:", hwid)
end

print("✅ Key hợp lệ, chạy script...")
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
