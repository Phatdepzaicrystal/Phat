local keysJsonUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Phat/main/keys.json"

local success, keysData = pcall(function()
    return loadstring("return " .. game:HttpGet(keysJsonUrl))()
end)

if success and type(keysData) == "table" then
    if keysData[getgenv().Key] and keysData[getgenv().Key] > os.time() * 1000 then
        print("✅ Key hợp lệ! Đang chạy script...")
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    else
        print("❌ Invalid Key!")
    end
else
    print("❌ Error.Plz Wait Admin Fix!")
end
