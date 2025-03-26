repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Yêu cầu nhập Key nếu chưa có
if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập key!")
    return
end

local keysURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local keyValid = false

local success, response = pcall(function()
    return game:HttpGet(keysURL)
end)

if success and response then
    local HttpService = game:GetService("HttpService")
    local keysData = HttpService:JSONDecode(response)
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

local gameScripts = {
    [2753915549] = "loadstring(game:HttpGet("https://pastefy.app/siSSjYcP/raw"))",
    [4442272183] = "loadstring(game:HttpGet("https://pastefy.app/siSSjYcP/raw"))",
    [7449423635] = "loadstring(game:HttpGet("https://pastefy.app/siSSjYcP/raw"))",
}

if gameScripts[game.PlaceId] then
    if game.PlaceId ~= 116495829188952 then
        getgenv().Language = "English"
    end
    loadstring(game:HttpGet(gameScripts[game.PlaceId]))()
else
    game.Players.LocalPlayer:Kick("⚠️Not Support !")
end
