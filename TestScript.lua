repeat
    wait()
until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local httpService = game:GetService("HttpService")
local hwidApi = "https://c36d7cfb-6f3a-4e9a-841d-4e7bcdc7e592-00-33ro0chwsdbwl.kirk.replit.dev/storehwid"
local keyFile = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

local function getHWID()
    return gethwid and gethwid() or "Unknown"
end

local function checkKey(key)
    local success, result =
        pcall(
        function()
            return httpService:JSONDecode(game:HttpGet(keyFile))
        end
    )

    if not success then
        return false
    end
    return result[key] ~= nil
end

local function sendHWID(key)
    local hwid = getHWID()
    local data = httpService:JSONEncode({key = key, hwid = hwid})

    local success, response =
        pcall(
        function()
            return httpService:PostAsync(hwidApi, data, Enum.HttpContentType.ApplicationJson)
        end
    )

    return success and response and response:find('"success":true') ~= nil
end

if not getgenv().Key or not checkKey(getgenv().Key) then
    player:Kick("❌ Invalid Key! Please enter a valid key.")
    return
end

if not sendHWID(getgenv().Key) then
    player:Kick("❌ HWID registration failed! Contact support.")
    return
end

getgenv().Language = "English"
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
