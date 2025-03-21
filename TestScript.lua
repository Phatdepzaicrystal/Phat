local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🔥 THAY LINK GITHUB CỦA BẠN Ở ĐÂY 🔥
local GitHub_User = "Phatdepzaicrystal"
local Repo_Keys = "Key"
local Repo_HWIDs = "Key"
local File_Keys = "keys.json"
local File_HWIDs = "hwids.txt"
local GitHub_Token = "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"  -- 🔥 THAY TOKEN CỦA BẠN 🔥

local HWID = gethwid and gethwid() or "Unknown"

--------------------------------------------------------------------
-- 🔹 HÀM LẤY DỮ LIỆU TỪ GITHUB
--------------------------------------------------------------------
local function getGitHubData(repo, file)
    local url = "https://raw.githubusercontent.com/" .. GitHub_User .. "/" .. repo .. "/main/" .. file
    local success, response = pcall(function()
        return HttpService:GetAsync(url, true)
    end)
    if success then
        return response
    else
        return nil
    end
end

--------------------------------------------------------------------
-- 🔹 YÊU CẦU NGƯỜI DÙNG NHẬP KEY
--------------------------------------------------------------------
local function getUserKey()
    local UserInput = game:GetService("UserInputService")
    print("🔑 Vui lòng nhập Key:")
    local input = UserInput.InputBegan:Wait()
    return input.KeyCode.Name  -- (Hoặc có thể dùng GUI nhập)
end

--------------------------------------------------------------------
-- 🔹 KIỂM TRA KEY
--------------------------------------------------------------------
local function checkKey(userKey)
    local keyData = getGitHubData(Repo_Keys, File_Keys)
    if keyData then
        local keys = HttpService:JSONDecode(keyData)
        for _, validKey in pairs(keys) do
            if userKey == validKey then
                print("✅ Key hợp lệ!")
                return true
            end
        end
    end
    print("❌ Key không hợp lệ! Kick người chơi.")
    LocalPlayer:Kick("⚠️ Sai Key! Vui lòng kiểm tra lại.")
    return false
end

--------------------------------------------------------------------
-- 🔹 KIỂM TRA & THÊM HWID LÊN GITHUB
--------------------------------------------------------------------
local function checkHWID()
    local hwidData = getGitHubData(Repo_HWIDs, File_HWIDs)

    if hwidData and string.find(hwidData, HWID) then
        print("✅ HWID hợp lệ, tiếp tục chạy script.")
        return true
    else
        print("🔄 HWID chưa có, đang gửi lên GitHub...")

        -- Gửi HWID lên GitHub
        local url = "https://api.github.com/repos/" .. GitHub_User .. "/" .. Repo_HWIDs .. "/contents/" .. File_HWIDs
        local sha = nil

        -- Lấy SHA nếu file đã tồn tại (để ghi đè)
        local success, response = pcall(function()
            return HttpService:GetAsync(url, true)
        end)
        if success then
            local data = HttpService:JSONDecode(response)
            sha = data.sha
        end

        -- Dữ liệu cần gửi
        local newContent = hwidData and (hwidData .. "\n" .. HWID) or HWID
        local jsonData = {
            message = "Thêm HWID mới",
            content = HttpService:Base64Encode(newContent),
            sha = sha
        }

        local headers = {
            ["Authorization"] = "token " .. GitHub_Token,
            ["Accept"] = "application/vnd.github.v3+json"
        }

        local successUpload, _ = pcall(function()
            return HttpService:PostAsync(
                url,
                HttpService:JSONEncode(jsonData),
                Enum.HttpContentType.ApplicationJson,
                false,
                headers
            )
        end)

        if successUpload then
            print("✅ HWID đã được gửi lên GitHub thành công!")
            return true
        else
            print("❌ Gửi HWID thất bại! Kiểm tra lại token hoặc kết nối mạng.")
            return false
        end
    end
end

--------------------------------------------------------------------
-- 🔹 THỰC THI SCRIPT
--------------------------------------------------------------------
local userKey = getUserKey()
if checkKey(userKey) then
    if checkHWID() then
        print("✅ Chạy script chính!")
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    end
end
