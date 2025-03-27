local hwid = gethwid and gethwid() or "Unknown"
local key = getgenv().Key

if not key or key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập key!")
    return
end

local httpService = game:GetService("HttpService")
local api_url = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/check_key?hwid=" .. hwid .. "&key=" .. key

local success, response = pcall(function()
    return httpService:GetAsync(api_url)
end)

if success then
    local json = httpService:JSONDecode(response)
    if json.status == "true" then
        -- ✅ Key hợp lệ -> Chạy script
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    else
        -- ❌ Key không hợp lệ -> Kick người chơi
        game.Players.LocalPlayer:Kick("❌ " .. json.message)
    end
else
    -- 🚫 Lỗi kết nối đến API
    game.Players.LocalPlayer:Kick("🚫 Không thể kết nối đến máy chủ kiểm tra key!")
end
