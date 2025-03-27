repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- 🛠️ Lấy HWID từ executor
local hwid = gethwid and gethwid() or "Unknown"

-- 🗂️ Tạo thư mục nếu chưa có
if not isfolder("VxezeHub") then
    makefolder("VxezeHub")
end

-- 📄 Đường dẫn file lưu HWID
local file_path = "VxezeHub/hwid.txt"

-- 🔍 Kiểm tra nếu HWID đã lưu trước đó
if isfile(file_path) then
    local saved_hwid = readfile(file_path)
    if saved_hwid ~= hwid then
        game.Players.LocalPlayer:Kick("❌ HWID không khớp! Vui lòng liên hệ hỗ trợ.")
        return
    end
else
    -- 📝 Lưu HWID vào file nếu chưa có
    writefile(file_path, hwid)
end

-- ✅ Nếu HWID hợp lệ, tiếp tục chạy script
print("✅ HWID hợp lệ:")

getgenv().Language = "English"
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
