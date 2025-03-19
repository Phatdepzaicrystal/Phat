local http = game:GetService("HttpService")

-- Link keys.json từ GitHub (sử dụng jsDelivr để tránh bị chặn)
local keysDataURL = "https://cdn.jsdelivr.net/gh/Phatdepzaicrystal/Key@main/keys.json"

-- Thử tải và hiển thị dữ liệu
local success, response = pcall(function()
    return http:GetAsync(keysDataURL)
end)

print("✅ Success:", success)

if success then
    print("📥 Response Content:\n", response)

    local decodeSuccess, data = pcall(function()
        return http:JSONDecode(response)
    end)

    if decodeSuccess then
        print("✅ JSON Decode thành công!")
        for i, v in ipairs(data) do
            print("➡️ Key:", v.code or "Không có code", "| HWID:", v.hwid or "Chưa bind")
        end
    else
        print("❌ Lỗi JSON Decode:", data)
    end
else
    print("❌ Lỗi tải dữ liệu:", response)
end
