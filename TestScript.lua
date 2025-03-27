repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- 🛠️ Lấy HWID từ executor
local hwid = gethwid and gethwid() or "Unknown"

-- 🗂️ Tạo thư mục nếu chưa có
if not isfolder("VxezeHub") then
    makefolder("VxezeHub")
end

-- 📄 Đường dẫn file lưu HWID & Key
local hwid_path = "VxezeHub/hwid.txt"
local key_path = "VxezeHub/key.txt"

-- 🔑 Kiểm tra Key nhập vào
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

    -- Nếu file chưa tồn tại, tự động lưu HWID & Key
    if not isfile(hwid_path) then
        if keysData[key] then
            writefile(hwid_path, hwid)
            writefile(key_path, key)
            print("✅ Đã lưu HWID & Key lần đầu:", hwid, key)
        else
            game.Players.LocalPlayer:Kick("❌ Key không hợp lệ! Vui lòng kiểm tra lại.")
            return
        end
    else
        -- Kiểm tra HWID & Key đã lưu
        local saved_hwid = readfile(hwid_path)
        local saved_key = readfile(key_path)
        if saved_hwid ~= hwid then
            game.Players.LocalPlayer:Kick("❌ HWID không khớp! Vui lòng liên hệ hỗ trợ.")
            return
        end
        if saved_key ~= key or not keysData[key] then
            game.Players.LocalPlayer:Kick("❌ Key không hợp lệ hoặc không khớp HWID!")
            return
        end
    end
else
    game.Players.LocalPlayer:Kick("🚫 Không thể kết nối đến máy chủ kiểm tra Key!")
    return
end
------Run Main Script-----------
getgenv().Language = "English"
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
