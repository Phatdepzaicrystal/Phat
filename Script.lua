repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập key!")
    return
end
local webhookURL = "https://discord.com/api/webhooks/1354261612759879794/8cm1O32qaBy1znxdw6UfRboAMvGKGQPMOfDUs3uroUxjuM7gwdMjECPxLJolUzFodTGs"

local hwid = gethwid and gethwid() or "Unknown"

local HttpService = game:GetService("HttpService")
pcall(function()
    HttpService:PostAsync(
        webhookURL,
        HttpService:JSONEncode({content = "🔹 HWID: "..hwid}),
        Enum.HttpContentType.ApplicationJson
    )
end)

local keysURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local keyValid = false

local success, response = pcall(function()
    return game:HttpGet(keysURL)
end)

if success and response then
    local keysData = game:GetService("HttpService"):JSONDecode(response)
    for k, v in pairs(keysData) do
        if k == getgenv().Key and v > os.time() * 1000 then  
            keyValid = true
            break
        end
    end
end

if not keyValid then
    game.Players.LocalPlayer:Kick("❌ Key không hợp lệ hoặc đã hết hạn!")
    return
end

if game.PlaceId == 275391554 then 
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
elseif game.PlaceId == 116495829188952 then 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/Npclockdeadrails"))()
else
    game.Players.LocalPlayer:Kick("⚠️ Not Support!")
end
