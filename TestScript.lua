local http = game:GetService("HttpService")
local device_id = gethwid and gethwid() or "Unknown"

-- Thay thế bằng thông tin GitHub của bạn
local github_username = "Phatdepzaicrystal"
local repo_name = "Key"
local file_path = "hwid_logs.txt"
local github_token = "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"

-- Nội dung cần gửi
local hwid_data = "Device ID: " .. device_id .. "\n"
-- 🔹 URL API GitHub
local url = "https://api.github.com/repos/" .. github_username .. "/" .. repo_name .. "/contents/" .. file_path

-- 🔹 Hàm kiểm tra file có tồn tại không
local function get_file_info()
    local success, response = pcall(function()
        return http:GetAsync(url, true)
    end)

    if success then
        local data = http:JSONDecode(response)
        return data.sha or nil -- Trả về SHA của file nếu tồn tại
    else
        return nil -- File chưa tồn tại
    end
end

-- 🔹 Hàm tải HWID lên GitHub
local function upload_hwid()
    local file_sha = get_file_info() -- Lấy SHA của file (nếu có)

    local jsonData = {
        message = "Update HWID log",
        content = http:Base64Encode(hwid_data), -- Mã hóa nội dung file
        sha = file_sha -- Nếu file tồn tại, thêm SHA để update
    }

    local headers = {
        ["Authorization"] = "token " .. github_token,
        ["Accept"] = "application/vnd.github.v3+json"
    }

    local success, response = pcall(function()
        return http:PostAsync(url, http:JSONEncode(jsonData), Enum.HttpContentType.ApplicationJson, false, headers)
    end)

    if success then
        print("✅ HWID đã được gửi lên GitHub thành công!")
    else
        warn("❌ Gửi HWID thất bại! Kiểm tra lại token và quyền repo.")
    end
end

-- 🔹 Gửi HWID lên GitHub
upload_hwid()
