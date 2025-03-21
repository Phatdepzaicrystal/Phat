local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Đường dẫn file keys.json qua raw URL (GET)
local keysUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
-- Đường dẫn GitHub API để update file keys.json
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/keys.json"
local githubToken = "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" -- Thay bằng token của bạn

-- Tạo HWID bằng cách kết hợp UserId và ClientId (để đảm bảo duy nhất)
local hwid = gethwid and gethwid() or "Unknown"

-- Kiểm tra key có được nhập vào getgenv().Key không
if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- Hàm lấy dữ liệu JSON từ một URL
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

-- Tìm entry có trường "key" trùng với getgenv().Key
local entry = nil
for _, v in ipairs(keysData) do
    if v["key"] == getgenv().Key then
        entry = v
        break
    end
end

if not entry then
    player:Kick("❌ Key không hợp lệ!")
    return
end

-- Kiểm tra HWID: nếu đã có và không khớp thì kick
if entry.hwid then
    if entry.hwid ~= hwid then
        player:Kick("❌ HWID không khớp!")
        return
    end
else
    -- Nếu chưa có HWID, cập nhật entry với HWID hiện tại
    entry.hwid = hwid

    local newContent = HttpService:JSONEncode(keysData)
    -- GitHub API yêu cầu nội dung ở dạng Base64. Nếu Executor hỗ trợ Synapse, dùng hàm mã hóa Base64 của Synapse; nếu không, bạn cần có hàm mã hóa Base64 riêng.
    local encodedContent = syn and syn.crypt.base64.encode(newContent) or newContent

    -- Lấy SHA hiện tại của file keys.json từ GitHub API
    local apiData = fetchJson(githubApiUrl)
    local currentSHA = apiData and apiData.sha or ""

    local body = {
        message = "🔄 Update HWID cho key: " .. entry["key"],
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
            player:Kick("⚠️ HWID của bạn đã được liên kết, vui lòng chạy lại script.")
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
