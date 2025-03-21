local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- URL file keys.json (lấy qua raw URL)
local keysUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
-- URL GitHub API dùng để update file keys.json
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/keys.json"
local githubToken = "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" -- Thay bằng token của bạn

-- Tạo HWID (ví dụ: kết hợp UserId và ClientId)
local hwid = player.UserId .. "-" .. game:GetService("RbxAnalyticsService"):GetClientId()

-- Kiểm tra xem key đã được nhập hay chưa
if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- Hàm tải JSON từ một URL
local function fetchJson(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        return HttpService:JSONDecode(response)
    else
        warn("Lỗi tải JSON:", response)
        return nil
    end
end

-- Lấy danh sách key từ GitHub
local keysData = fetchJson(keysUrl)
if not keysData then
    player:Kick("❌ Không thể tải danh sách key từ GitHub!")
    return
end

-- Tìm entry có trường "code" trùng với getgenv().Key
local entry = nil
for _, v in ipairs(keysData) do
    if v["code"] == getgenv().Key then
        entry = v
        break
    end
end

if not entry then
    player:Kick("❌ Key không hợp lệ!")
    return
end

-- Nếu entry đã có "hwid" và không khớp với HWID hiện tại → Kick
if entry.hwid then
    if entry.hwid ~= hwid then
        player:Kick("❌ HWID không khớp!")
        return
    end
else
    -- Nếu chưa có "hwid", cập nhật entry với HWID hiện tại và update file lên GitHub
    entry.hwid = hwid

    local newContent = HttpService:JSONEncode(keysData)
    -- GitHub API yêu cầu nội dung được mã hóa Base64; nếu dùng Synapse, sử dụng hàm mã hóa của Synapse
    local encodedContent = syn and syn.crypt.base64.encode(newContent) or newContent

    -- Lấy SHA hiện tại của file keys.json từ GitHub API
    local apiData = fetchJson(githubApiUrl)
    local currentSHA = apiData and apiData.sha or ""

    local body = {
        message = "🔄 Update HWID cho key: " .. entry["code"],
        content = encodedContent,
        sha = currentSHA
    }
    local headers = {
        ["Authorization"] = "token " .. githubToken,
        ["Content-Type"] = "application/json"
    }

    if http and http.request then
        local requestData = {
            Url = githubApiUrl,
            Method = "PUT",
            Headers = headers,
            Body = HttpService:JSONEncode(body)
        }
        local success, result = pcall(function() return http.request(requestData) end)
        if success then
            print("✅ HWID đã được cập nhật:", hwid)
            print("⚠️ HWID của bạn đã được liên kết, đang chạy script...")
            return
        else
            player:Kick("❌ Lỗi cập nhật HWID!")
            return
        end
    else
        player:Kick("⚠️ Executor không hỗ trợ http.request, không thể cập nhật HWID!")
        return
    end
end

-- Nếu key và HWID hợp lệ, chạy script VxezeHub
print("✅ Key và HWID hợp lệ! Đang chạy script...")
getgenv().Language = "English"
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
