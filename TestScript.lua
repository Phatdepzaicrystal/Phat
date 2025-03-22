local HttpService = game:GetService("HttpService")
local HWID = gethwid and gethwid() or "Unknown"
local player = game.Players.LocalPlayer

if not getgenv().Key or getgenv().Key == "" then
    player:Kick("⚠️ You must enter a key!")
    return
end

-- 🔹 Cấu hình GitHub
local github_username = "Phatdepzaicrystal"
local repo_name = "Key"
local file_path = "keys.json"

-- 🔹 Cấu hình Webhook Discord
local DiscordWebhook = "https://discord.com/api/webhooks/1351710851727364158/CLgOTMvfjEshI-HXkzCi0SK_kYZzx9qi42aZfI92R_YrYBwr3U7H9Se1dIRrMcxxrtPj"

-- 🔹 Link API GitHub để lấy danh sách Key
local github_api_url = "https://raw.githubusercontent.com/" .. github_username .. "/" .. repo_name .. "/main/" .. file_path

-- 🔹 Link script cần chạy nếu key đúng
local script_url = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"

-- 🔹 Lấy danh sách Key từ GitHub
local function getKeysFromGitHub()
    local request = syn and syn.request or http_request or request
    if not request then
        print("❌ Không hỗ trợ request HTTP!")
        return nil
    end

    local response = request({
        Url = github_api_url,
        Method = "GET"
    })

    if response.StatusCode == 200 then
        return HttpService:JSONDecode(response.Body)
    else
        print("❌ Không thể lấy dữ liệu từ GitHub! Mã lỗi:", response.StatusCode)
        return nil
    end
end

-- 🔹 Kiểm tra HWID có trong danh sách không
local function checkHWID(keys)
    for _, entry in ipairs(keys) do
        if entry.hwid == HWID then
            print("✅ HWID hợp lệ! Chạy script...")
            return entry.key -- Trả về Key nếu HWID hợp lệ
        end
    end
    return nil
end

-- 🔹 Gửi HWID & Key lên Webhook Discord
local function sendHWIDToDiscord(UserKey)
    local data = {
        content = "**:key: Yêu cầu Redeem Key**\n",
        embeds = {{
            title = "Thông tin người dùng",
            fields = {
                { name = ":small_blue_diamond: HWID", value = HWID, inline = true },
                { name = ":id: User ID", value = tostring(game.Players.LocalPlayer.UserId), inline = true },
                { name = ":bust_in_silhouette: Username", value = game.Players.LocalPlayer.Name, inline = true },
                { name = ":key: Key sử dụng", value = UserKey, inline = true }
            },
            color = 16711680
        }}
    }

    local request = syn and syn.request or http_request or request
    if request then
        request({
            Url = DiscordWebhook,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- 🔹 Chạy script nếu Key đúng
local function runScript()
    getgenv().Language = "English"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
end

-- 🔹 Kiểm tra tất cả HWID, nếu trùng thì gửi Webhook + chạy script
local keys_data = getKeysFromGitHub()
if keys_data then
    local validKey = checkHWID(keys_data.keys)
    if validKey then
        sendHWIDToDiscord(validKey)
        runScript()
    else
        print("❌ HWID không hợp lệ!")
    end
else
    print("❌ Không thể tải danh sách Key!")
end
