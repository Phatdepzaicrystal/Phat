local http = game:GetService("HttpService")
local device_id = gethwid and gethwid() or "Unknown"

-- Thay thế bằng thông tin GitHub của bạn
local github_username = "Phatdepzaicrystal"
local repo_name = "Key"
local file_path = "hwid_logs.txt"
local github_token = "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"

-- Nội dung cần gửi
local hwid_data = "Device ID: " .. device_id .. "\n"

-- API để gửi HWID lên GitHub
local url = "https://api.github.com/repos/" .. github_username .. "/" .. repo_name .. "/contents/" .. file_path

-- Lấy thông tin file hiện tại (nếu có)
local function get_file_sha()
    local success, response = pcall(function()
        return http:GetAsync(url, true)
    end)
    if success then
        local data = http:JSONDecode(response)
        return data.sha or nil
    end
    return nil
end

-- Hàm gửi HWID lên GitHub
local function upload_hwid()
    local sha = get_file_sha()
    local jsonData = {
        message = "Update HWID log",
        content = http:Base64Encode(hwid_data),
        sha = sha
    }

    local headers = {
        ["Authorization"] = "token " .. github_token,
        ["Accept"] = "application/vnd.github.v3+json"
    }

    local success, response = pcall(function()
        return http:PostAsync(url, http:JSONEncode(jsonData), Enum.HttpContentType.ApplicationJson, false, headers)
    end)

    if success then
        print("HWID đã được gửi lên GitHub thành công!")
    else
        warn("Gửi HWID thất bại!")
    end
end

-- Gửi HWID
upload_hwid()
