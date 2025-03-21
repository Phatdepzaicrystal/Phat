local http = game:GetService("HttpService")

local key_url = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local api_url = "https://2cb8592c-0d94-4348-86b2-42d0bc9b841d-00-5tyyjf8nengg.sisko.replit.dev/Checkkey" -- Thay bằng API của bạn

-- Lấy HWID từ thiết bị
local HWID = gethwid and gethwid() or "Unknown"

-- Tải danh sách Key từ GitHub
local success, response = pcall(function()
    return http:GetAsync(key_url)
end)

if success then
    local key_data = http:JSONDecode(response)
    local key_found = nil

    -- Duyệt tất cả các Key trong danh sách
    for key, _ in pairs(key_data) do
        -- Gửi Key + HWID lên API để kiểm tra
        local url = api_url .. "?key=" .. key .. "&hwid=" .. HWID
        local hwid_check_success, hwid_response = pcall(function()
            return http:GetAsync(url)
        end)

        if hwid_check_success then
            local hwid_data = http:JSONDecode(hwid_response)
            if hwid_data.status == "true" and hwid_data.Key_Status then
                key_found = key
                break -- Nếu tìm thấy key hợp lệ thì dừng vòng lặp
            end
        end
    end

    if key_found then
        print("✅ Key hợp lệ! HWID xác minh thành công. Chạy script...")
        -- Thêm lệnh load script vào đây nếu cần
    else
        print("❌ Không tìm thấy Key hợp lệ! Kick khỏi game.")
        game.Players.LocalPlayer:Kick("Key hoặc HWID không hợp lệ!")
    end
else
    print("❌ Lỗi tải Key từ GitHub!")
end
