local HttpService = game:GetService("HttpService")

-- Tải danh sách key từ GitHub (CẬP NHẬT đường dẫn đúng của bạn)
local keysJsonUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/main/keys.json"

local function loadKeys()
    local success, keysData = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(keysJsonUrl))
    end)
    return success and keysData or {}
end

local keys = loadKeys()

-- Kiểm tra xem có key không
if getgenv().Key and keys[getgenv().Key] and keys[getgenv().Key] > os.time() * 1000 then
    print("✅")
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
else
    print("❌ Key không hợp lệ hoặc đã hết hạn!")
end
