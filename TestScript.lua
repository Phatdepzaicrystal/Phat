local http = game:GetService("HttpService")

-- Cấu hình API của bạn
local api_url = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev"  -- Thay bằng URL API thật
local hwid = gethwid and gethwid() or "Unknown"

-- Lấy key từ GitHub
local github_keys_url = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local key

local success, err = pcall(function()
    local response = http:GetAsync(github_keys_url, true)
    local keys = http:JSONDecode(response)
    
    for k, v in pairs(keys) do
        key = k -- Lấy Key đầu tiên từ danh sách GitHub
        break
    end
end)

if not success or not key then
    print("⚠️ Không thể lấy key từ GitHub:", err)
    return
end

-- Gửi yêu cầu kiểm tra Key & HWID
local response
success, err = pcall(function()
    response = http:GetAsync(api_url .. "/Checkkey?key=" .. key .. "&hwid=" .. hwid, true)
end)

if success then
    local data = http:JSONDecode(response)
    if data["status"] == "true" and data["Key_Status"] then
        print("✅ Key hợp lệ, chạy script...")
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    else
        print("❌ Key không hợp lệ hoặc HWID bị blacklist:", data["message"])
        game.Players.LocalPlayer:Kick(data["message"])
    end
else
    print("⚠️ Lỗi kết nối API:", err)
end
