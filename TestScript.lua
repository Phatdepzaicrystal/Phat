local HttpService = game:GetService("HttpService")

-- 🔹 Lấy HWID từ hệ thống
local HWID = gethwid and gethwid() or "Unknown"

-- 🔹 Cấu hình Webhook Discord
local DiscordWebhook = "https://discord.com/api/webhooks/1351710851727364158/CLgOTMvfjEshI-HXkzCi0SK_kYZzx9qi42aZfI92R_YrYBwr3U7H9Se1dIRrMcxxrtPj"

-- 🔹 Link Key trên GitHub
local key_list_url = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"

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
        Url = key_list_url,
        Method = "GET"
    })

    if response.StatusCode == 200 then
        return HttpService:JSONDecode(response.Body)
    else
        print("❌ Không thể lấy dữ liệu Key! Mã lỗi:", response.StatusCode)
        return nil
    end
end

-- 🔹 Kiểm tra Key có hợp lệ không
local function checkKey(userKey, keys)
    for _, key in ipairs(keys) do
        if key == userKey then
            print("✅ Key hợp lệ!")
            return true
        end
    end
    return false
end

-- 🔹 Gửi HWID lên Webhook Discord
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
    loadstring(game:HttpGet(script_url))()
end

-- 🔹 Nhập Key từ người dùng
print("🔑 Nhập Key của bạn:")
local UserKey = io.read()

-- 🔹 Kiểm tra Key
local keys_data = getKeysFromGitHub()
if keys_data and keys_data.keys then
    if checkKey(UserKey, keys_data.keys) then
        sendHWIDToDiscord(UserKey)
        runScript()
    else
        print("❌ Key không hợp lệ!")
    end
else
    print("❌ Không thể tải danh sách Key!")
end
