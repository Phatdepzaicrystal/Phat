local keysJsonUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json" 

local success, keysData = pcall(function()
    return game:GetService("HttpService"):JSONDecode(game:HttpGet(keysJsonUrl))
end)

if success and type(keysData) == "table" then
    for key, expiry in pairs(keysData) do
        if string.find(key, "Vxeze-") and expiry > os.time() * 1000 then
            print("✅ Key hợp lệ! Đang chạy script...")
            getgenv().Language = "English"
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
            break
        end
    end
else
    print("❌ Không tải được danh sách key!")
end
