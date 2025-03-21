local HttpService = game:GetService("HttpService")

-- Lấy HWID (nếu không có, gán "Unknown")
local hwid = gethwid and gethwid() or "Unknown"

-- Đường dẫn API với tham số hwid được thêm vào URL
local apiEndpoint = "https://2cb8592c-0d94-4348-86b2-42d0bc9b841d-00-5tyyjf8nengg.sisko.replit.dev/addhwid?hwid=" .. hwid

-- Gửi GET request đến API
local success, response = pcall(function()
    return HttpService:GetAsync(apiEndpoint)
end)

if success then
    print("Response from API: " .. response)
else
    warn("Failed to send HWID: " .. tostring(response))
end
