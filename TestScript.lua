repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local http = game:HttpGet
local player = game.Players.LocalPlayer
local hwidApi = "https://c36d7cfb-6f3a-4e9a-841d-4e7bcdc7e592-00-33ro0chwsdbwl.kirk.replit.dev/storehwid" 
local keyFile = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

local function getHWID()
    return  gethwid and gethwid() or "Unknown"
end

local function checkKey(key)
    local success, keys = pcall(function()
        return game.HttpService:JSONDecode(http(keyFile))
    end)
    if not success then return false end
    return keys[key] ~= nil
end

local function sendHWID(key)
    local hwid = getHWID()
    local data = game.HttpService:JSONEncode({ key = key, hwid = hwid })
    local response = http(hwidApi, "POST", data, true)

    return response:find('"success":true') ~= nil
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
loadstring(http("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
