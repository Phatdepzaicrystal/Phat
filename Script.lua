local keysJsonUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json" -- Link chứa key
local webhookUrl = "https://discord.com/api/webhooks/1354261612759879794/8cm1O32qaBy1znxdw6UfRboAMvGKGQPMOfDUs3uroUxjuM7gwdMjECPxLJolUzFodTGs" 

local hwid = gethwid and gethwid() or "Unknown"

local function sendHWIDToWebhook(hwid)
    local data = {
        content = "**📌 HWID Detected!**",
        embeds = {{
            title = "💻 HWID Info",
            description = "```" .. hwid .. "```",
            color = 16711680 -- Màu đỏ
        }}
    }
    local json = game:GetService("HttpService"):JSONEncode(data)

    -- Gửi request HTTP POST đến Webhook
    local success, response = pcall(function()
        return syn and syn.request or request({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = json
        })
    end)

    if success then
        print("✅ Gửi HWID thành công!")
    else
        print("❌ Lỗi gửi HWID!")
    end
end

-- Hàm kiểm tra key hợp lệ
local function checkKeys()
    local success, keysData = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet(keysJsonUrl))
    end)

    if success and type(keysData) == "table" then
        local currentTime = os.time() * 1000 

        for key, expiry in pairs(keysData) do
            if expiry > currentTime then
                print("✅")
                sendHWIDToWebhook(hwid) 
                getgenv().Language = "English"
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
                return
            end
        end
        print("❌ Không tìm thấy key hợp lệ!")
    else
        print("❌ Lỗi tải danh sách key!")
    end
end

checkKeys()
