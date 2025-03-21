local HttpService = game:GetService("HttpService")

-- 🔹 Lấy HWID cũ (nếu không có, đặt thành "Unknown")
local device_id = gethwid and gethwid() or "Unknown"

-- 🔹 Thông tin GitHub (HÃY SỬA LẠI CHO PHÙ HỢP)
local github_username = "your-username"
local repo_name       = "your-repo"
local file_path       = "hwid_logs.txt"
local github_token    = "your-github-token"

-- 🔹 Dữ liệu cần ghi
local hwid_data = "Device ID: " .. device_id .. "\n"

-- 🔹 URL API GitHub
local url = "https://api.github.com/repos/" .. github_username .. "/" .. repo_name .. "/contents/" .. file_path

--------------------------------------------------------------------------------
-- 1. HÀM BASE64Encode THỦ CÔNG
--------------------------------------------------------------------------------
local function base64Encode(input)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local s = {}
    local len = #input

    for i = 1, len, 3 do
        local c1 = string.byte(input, i)
        local c2 = string.byte(input, i + 1)
        local c3 = string.byte(input, i + 2)

        -- Đảm bảo c2, c3 không bị nil
        local a1, a2, a3, a4

        if not c2 then
            c2 = 0
        end
        if not c3 then
            c3 = 0
        end

        -- Chia nhỏ thành 4 block 6-bit
        a1 = (c1 >> 2) & 0x3F
        a2 = ((c1 & 0x03) << 4) | (c2 >> 4)
        a3 = ((c2 & 0x0F) << 2) | (c3 >> 6)
        a4 = c3 & 0x3F

        s[#s+1] = b:sub(a1+1, a1+1)
        s[#s+1] = b:sub(a2+1, a2+1)

        if (i + 1) <= len then
            s[#s+1] = b:sub(a3+1, a3+1)
        else
            s[#s+1] = "="
        end

        if (i + 2) <= len then
            s[#s+1] = b:sub(a4+1, a4+1)
        else
            s[#s+1] = "="
        end
    end

    return table.concat(s)
end

--------------------------------------------------------------------------------
-- 2. HÀM LẤY SHA CỦA FILE (NẾU TỒN TẠI)
--------------------------------------------------------------------------------
local function get_file_sha()
    local success, response = pcall(function()
        return HttpService:GetAsync(url, true)
    end)
    if success then
        local data = HttpService:JSONDecode(response)
        return data.sha or nil
    end
    return nil
end

--------------------------------------------------------------------------------
-- 3. HÀM UPLOAD HWID LÊN GITHUB
--------------------------------------------------------------------------------
local function upload_hwid()
    local sha = get_file_sha()

    -- Tạo JSON data cho GitHub
    local jsonData = {
        message = "Update HWID log",
        content = base64Encode(hwid_data),  -- Áp dụng hàm base64Encode
        sha = sha                           -- Nếu file đã có, cần sha để update
    }

    -- Header yêu cầu của GitHub
    local headers = {
        ["Authorization"] = "token " .. github_token,
        ["Accept"] = "application/vnd.github.v3+json"
    }

    -- Gửi request
    local success, response = pcall(function()
        return HttpService:PostAsync(
            url,
            HttpService:JSONEncode(jsonData),
            Enum.HttpContentType.ApplicationJson,
            false,
            headers
        )
    end)

    if success then
        print("HWID đã được gửi lên GitHub thành công!")
    else
        warn("Gửi HWID thất bại! Kiểm tra lại token, repo, hoặc kết nối mạng.")
    end
end

--------------------------------------------------------------------------------
-- 4. THỰC THI
--------------------------------------------------------------------------------
upload_hwid()
