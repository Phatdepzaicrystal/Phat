repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- 🛠️ Lấy HWID từ executor
local hwid = gethwid and gethwid() or "Unknown"

-- 🗂️ Tạo thư mục nếu chưa có
if not isfolder("VxezeHub") then
    makefolder("VxezeHub")
end

-- 📄 Đường dẫn file lưu HWID
local hwid_path = "VxezeHub/hwid.txt"

-- 🔍 Kiểm tra nếu HWID đã lưu trước đó
if isfile(hwid_path) then
    local saved_hwid = readfile(hwid_path)
    if saved_hwid ~= hwid then
        game.Players.LocalPlayer:Kick("❌ HWID không khớp! Vui lòng liên hệ hỗ trợ.")
        return
    end
else
    -- 📝 Lưu HWID vào file nếu chưa có
    writefile(hwid_path, hwid)
end

-- 🔑 Kiểm tra Key từ GitHub
local key = getgenv().Key
if not key or key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

-- 🌍 URL chứa danh sách Key trên GitHub
local key_url = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

-- 🛠️ Lấy dữ liệu Key từ GitHub
local success, response = pcall(function()
    return game:HttpGet(key_url)
end)

if success and response then
    local HttpService = game:GetService("HttpService")
    local keysData = HttpService:JSONDecode(response)
    if keysData[key] and keysData[key] == hwid then
        print("✅ Key hợp lệ và khớp HWID:", hwid)
    else
        game.Players.LocalPlayer:Kick("❌ Key không hợp lệ hoặc không khớp HWID!")
        return
    end
else
    game.Players.LocalPlayer:Kick("🚫 Không thể kết nối đến máy chủ kiểm tra Key!")
    return
end

getgenv().Language = "English"
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
