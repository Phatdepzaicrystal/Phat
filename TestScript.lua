local http = game:GetService("HttpService")
local hwid = gethwid and gethwid() or "Unknown"
local player = game.Players.LocalPlayer

if not getgenv().Key or getgenv().Key == "" then
    player:Kick("⚠️ You must enter a key!")
    return
end

local githubRawURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

-- 🔗 Link webhook Discord để gửi HWID
local webhookURL = "https://discord.com/api/webhooks/1351710851727364158/CLgOTMvfjEshI-HXkzCi0SK_kYZzx9qi42aZfI92R_YrYBwr3U7H9Se1dIRrMcxxrtPj" 
-- Lấy danh sách Key từ GitHub
local success, response = pcall(function()
    return http:GetAsync(githubRawURL)
end)

if success then
    local data = http:JSONDecode(response) -- Giải mã JSON từ GitHub
    local isValid = false
    local validKey = nil

    -- 🔎 Kiểm tra xem HWID có khớp với bất kỳ Key nào trong danh sách không
    for key, hwidList in pairs(data) do
        for _, storedHWID in ipairs(hwidList) do
            if storedHWID == hwid then
                isValid = true
                validKey = key
                break
            end
        end
        if isValid then break end
    end

    -- ✅ Nếu tìm thấy HWID hợp lệ
    if isValid then
        print("✅ HWID và Key hợp lệ! Gửi lên Discord...")

        -- 🎨 Format tin nhắn
        local message = "**🔹 HWID ĐƯỢC XÁC NHẬN 🔹**\n"
        message = message .. "```\n"
        message = message .. "Người chơi: " .. player.Name .. "\n"
        message = message .. "HWID      : " .. hwid .. "\n"
        message = message .. "Key       : " .. validKey .. "\n"
        message = message .. "```\n"
        message = message .. "✅ Truy cập thành công!"

        -- 📩 Gửi HWID + Key lên Discord
        local payload = { content = message }
        http:PostAsync(webhookURL, http:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)

        print("📩 Đã gửi HWID lên Discord!")
    else
        print("❌ HWID hoặc Key không hợp lệ!")
        player:Kick("❌ HWID hoặc Key không hợp lệ! Vui lòng kiểm tra lại.")
    end
else
    print("❌ Lỗi tải dữ liệu từ GitHub!")
end
