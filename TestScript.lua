repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- 📂 Thư mục & file lưu trữ
local folder = "VxezeHub"
local hwid_file = folder.."/hwid.txt"
local key_file = folder.."/key.txt"

-- ✅ Tạo thư mục nếu chưa có
if not isfolder(folder) then makefolder(folder) end

-- 🔐 Lấy HWID
local hwid = gethwid and gethwid() or "Unknown"

-- 💾 Kiểm tra & lưu HWID vào file nếu chưa có
if not isfile(hwid_file) then
    writefile(hwid_file, hwid)
end

-- 🔑 Kiểm tra & lưu Key vào file
local key = getgenv().Key
if not key or key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập key!")
    return
end
writefile(key_file, key)

-- 🔗 Link chứa danh sách key từ GitHub
local keysURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local keyValid = false

-- 📡 Gửi yêu cầu HTTP để lấy key từ GitHub
local httpService = game:GetService("HttpService")
local success, response = pcall(function()
    return game:HttpGet(keysURL)
end)

-- 🔍 Kiểm tra Key hợp lệ & khớp HWID
if success and response then
    local keysData = httpService:JSONDecode(response)
    for k, v in pairs(keysData) do
        if k == key and v.hwid == hwid and v.expire > os.time() then  
            keyValid = true
            break
        end
    end
end

-- ❌ Kick nếu Key không hợp lệ hoặc không khớp HWID
if not keyValid then
    game.Players.LocalPlayer:Kick("❌ Key không hợp lệ hoặc không khớp HWID!")
    return
end

-- 🚀 Chạy Script chính nếu Key hợp lệ
getgenv().Language = "English"
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
