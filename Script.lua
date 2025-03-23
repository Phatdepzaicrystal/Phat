local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GitHubToken = "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"
local RepoOwner = "Phatdepzaicrystal"
local RepoName = "Key"
local KeyFilePath = "keys.json"
local RawKeyFileURL = "https://raw.githubusercontent.com/" .. RepoOwner .. "/" .. RepoName .. "/main/" .. KeyFilePath
local APIKeyFileURL = "https://api.github.com/repos/" .. RepoOwner .. "/" .. RepoName .. "/contents/" .. KeyFilePath

local HWID = gethwid and gethwid() or "Unknown"

local function GetKeys()
    local success, response = pcall(function()
        return game:HttpGet(RawKeyFileURL)
    end)

    if success and response then
        return HttpService:JSONDecode(response)
    else
        warn("⚠️ Lỗi tải danh sách key từ GitHub!")
        return nil
    end
end

local function GetFileSHA()
    local success, response = pcall(function()
        return game:HttpGet(APIKeyFileURL)
    end)

    if success and response then
        local jsonResponse = HttpService:JSONDecode(response)
        return jsonResponse.sha
    else
        warn("⚠️ Lỗi lấy SHA file trên GitHub!")
        return nil
    end
end

local function EncodeBase64(data)
    return game:HttpGet("https://api64.ipify.org?format=json&data=" .. HttpService:JSONEncode(data))
end

local function UpdateKeys(keys)
    local sha = GetFileSHA()
    if not sha then
        warn("⚠️ Không lấy được SHA file trên GitHub!")
        return
    end

    local headers = {
        ["Authorization"] = "token " .. GitHubToken,
        ["Accept"] = "application/vnd.github.v3+json",
        ["Content-Type"] = "application/json"
    }

    local data = {
        message = "Update HWID",
        content = EncodeBase64(HttpService:JSONEncode(keys)),
        sha = sha
    }

    local success, response = pcall(function()
        return HttpService:PostAsync(APIKeyFileURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, headers)
    end)

    if success then
        print("✅ HWID cập nhật thành công trên GitHub!")
    else
        warn("⚠️ Lỗi cập nhật HWID!")
    end
end

local function CheckKey()
    local keys = GetKeys()
    if not keys then return nil end

    for _, entry in pairs(keys) do
        if entry.code then
            if entry.hwid == nil then
                print("🆕 Gán HWID mới!")
                entry.hwid = HWID
                UpdateKeys(keys)
                return entry.code
            elseif entry.hwid == HWID then
                print("✅ Key hợp lệ!")
                return entry.code
            end
        end
    end
    return nil
end

local verifiedKey = CheckKey()
if verifiedKey then
    print("✅ Key hợp lệ! Chạy script...")
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
else
    print("❌ Key không hợp lệ hoặc HWID chưa được đăng ký!")
    LocalPlayer:Kick("🔴 Key không hợp lệ hoặc HWID chưa được đăng ký!")
end
