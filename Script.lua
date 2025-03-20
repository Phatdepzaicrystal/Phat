local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Đường dẫn GitHub
local keyListUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local githubApiUrl = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/keys.json"
local githubToken = "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" -- Token GitHub của bạn

-- Lấy thông tin người chơi
local player = Players.LocalPlayer
local hwid = player.UserId .. "-" .. game:GetService("RbxAnalyticsService"):GetClientId()

if not getgenv().Key then
    player:Kick("⚠️ Vui lòng nhập key trước khi chạy script.")
    return
end

-- Hàm tải JSON từ GitHub
local function fetchJson(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    return success and HttpService:JSONDecode(response) or nil
end

-- Lấy danh sách key từ GitHub
local keys = fetchJson(keyListUrl)

if keys then
    local validKey = nil

    -- Kiểm tra key có tồn tại không
    for _, entry in pairs(keys) do
        if entry.code == getgenv().Key then
            validKey = entry
            break
        end
    end

    -- Nếu key hợp lệ, kiểm tra HWID
    if validKey then
        -- Nếu HWID không khớp -> Kick người chơi
        if validKey.hwid and validKey.hwid ~= hwid then
            player:Kick("❌ HWID không hợp lệ!")
            return
        end

        -- Nếu HWID chưa có, cập nhật HWID lên GitHub
        if not validKey.hwid then
            validKey.hwid = hwid

            -- Mã hóa JSON thành base64 để gửi lên GitHub
            local newContent = HttpService:JSONEncode(keys)
            local encodedContent = syn and syn.crypt.base64.encode(newContent) or newContent

            local body = {
                message = "🔄 Cập nhật HWID cho key: " .. validKey.code,
                content = encodedContent,
                sha = fetchJson(githubApiUrl) and fetchJson(githubApiUrl).sha or ""
            }

            local headers = {
                ["Authorization"] = "token " .. githubToken,
                ["Content-Type"] = "application/json"
            }

            if http and http.request then
                http.request({
                    Url = githubApiUrl,
                    Method = "PUT",
                    Headers = headers,
                    Body = HttpService:JSONEncode(body)
                })
                print("✅ HWID mới đã được cập nhật trên GitHub:", hwid)
            else
                print("⚠️ Executor không hỗ trợ `http.request`, không thể cập nhật HWID!")
            end
        end

        print("✅ Key hợp lệ, chạy script...")
        getgenv().Language = "English"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
    else
        player:Kick("❌ Key không hợp lệ!")
    end
else
    player:Kick("❌ Không thể tải danh sách key từ GitHub!")
end
