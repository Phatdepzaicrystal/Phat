local keysUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

local success, response = pcall(function()
    return game:HttpGet(keysUrl)
end)

if success then
    local keysData = game:GetService("HttpService"):JSONDecode(response)
    local playerId = game.Players.LocalPlayer.UserId
    local isValid = false

    if typeof(keysData) == "table" then
        for _, v in pairs(keysData) do
            if v == tostring(playerId) then
                isValid = true
                break
            end
        end
    end

    if isValid then
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    else
        print("❌ Key không hợp lệ! Đang kick...")
        game.Players.LocalPlayer:Kick("❌ Invalid Key")
    end
else
    print("Error")
    game.Players.LocalPlayer:Kick("Error Plz Wait Admin Fix!")
end
