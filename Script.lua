local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local device_id = gethwid and gethwid() or "Unknown"

-- Check if key is provided
if not getgenv().Key or getgenv().Key == "" then
    player:Kick("⚠️ You must enter a key!")
    return
end

local providedKey = getgenv().Key

-- GitHub configuration
local GITHUB_TOKEN = "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"  
local REPO_OWNER = "Phatdepzaicrystal"
local REPO_NAME = "Key"
local FILE_PATH = "keys.json"
local RAW_URL = "https://raw.githubusercontent.com/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/refs/heads/main/" .. FILE_PATH
local API_URL = "https://api.github.com/repos/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/contents/" .. FILE_PATH

-- Function to get keys.json from GitHub
local function getKeys()
    local success, response = pcall(function()
        return HttpService:GetAsync(RAW_URL)
    end)
    if success then
        return HttpService:JSONDecode(response)
    else
        error("Error fetching keys.json from GitHub!")
    end
end

-- Function to get the SHA of keys.json (required for update)
local function getSHA()
    local headers = { ["Authorization"] = "token " .. GITHUB_TOKEN }
    local success, response = pcall(function()
        return HttpService:GetAsync(API_URL, true)
    end)
    if success then
        local data = HttpService:JSONDecode(response)
        return data.sha
    else
        return nil
    end
end

-- Function to update keys.json on GitHub with new content
local function updateKeysOnGitHub(updatedKeys, sha)
    local jsonContent = HttpService:JSONEncode(updatedKeys)
    -- Use base64 encoding function; if using Synapse X, syn.crypt.base64.encode is available.
    local base64Content = (syn and syn.crypt.base64.encode or HttpService.Base64Encode)(jsonContent)
    local payload = {
         message = "🔐 Update keys.json: add HWID",
         content = base64Content,
         sha = sha or nil
    }
    local headers = {
         ["Authorization"] = "token " .. GITHUB_TOKEN,
         ["Content-Type"] = "application/json"
    }
    local success, result = pcall(function()
         return HttpService:RequestAsync{
             Url = API_URL,
             Method = "PUT",
             Headers = headers,
             Body = HttpService:JSONEncode(payload)
         }
    end)
    if success then
         print("✅ Successfully updated keys.json!")
    else
         warn("❌ Failed to update keys.json:", result)
    end
end

-- Function to check the key and add HWID if needed
local function checkAndAddHWID(providedKey)
    local keysTable = getKeys()
    local keyFound = nil
    for i, entry in ipairs(keysTable) do
         if entry.code == providedKey then
              keyFound = entry
              break
         end
    end

    if not keyFound then
         print("❌ The provided key is invalid!")
         player:Kick("Invalid Key!")
         return false
    end

    if keyFound.hwid then
         if keyFound.hwid == device_id then
              print("✅")
              return true
         else
              print("❌ HWID mismatch! Stored HWID: " .. keyFound.hwid .. ", your device HWID: " .. device_id)
              player:Kick("HWID Invalid !")
              return false
         end
    else

         keyFound.hwid = device_id
         print("✅ HWID not set; adding your device HWID to key: " .. providedKey)
         local sha = getSHA()
         updateKeysOnGitHub(keysTable, sha)
         return true
    end
end

-- Check the key and HWID conditions
if checkAndAddHWID(providedKey) then
    print("✅ Wellcome ")
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
else
    print("❌")
    game.Players.LocalPlayer:Kick("Biến")
end
