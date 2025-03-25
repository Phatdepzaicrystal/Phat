local HttpService = game:GetService("HttpService")

local keysJsonUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/main/keys.json"

local function loadKeys()
    local success, keysData = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(keysJsonUrl))
    end)
    return success and keysData or {}
end

local keys = loadKeys()

if getgenv().Key and keys[getgenv().Key] and keys[getgenv().Key] > os.time() * 1000 then
    print("✅")
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
else
    print("❌Invalid Key")
end
