local device_id = gethwid and gethwid() or "Unknown"
local key = getgenv().Key

if not key or key == "" then
    game.Players.LocalPlayer:Kick("Bạn chưa nhập key!")
    return
end

local http = game:HttpGet("https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json")
local success, data = pcall(game.HttpService.JSONDecode, game.HttpService, http)

if not success or not data then
    game.Players.LocalPlayer:Kick("Không thể tải dữ liệu key!")
    return
end

local function findKey(k)
    for _, entry in ipairs(data) do
        if entry.code == k then
            return entry
        end
    end
    return nil
end

local keyData = findKey(key)

if not keyData then
    game.Players.LocalPlayer:Kick("Key không hợp lệ!")
    return
end

if keyData.hwid == nil then
    -- Nếu key chưa có HWID, gán device_id vào
    keyData.hwid = device_id
    -- Cần API để cập nhật file JSON
    print("Key hợp lệ! Gán HWID mới:", device_id)
else
    if keyData.hwid ~= device_id then
        game.Players.LocalPlayer:Kick("Invalid Hwid")
        return
    end
end

print("Key hợp lệ! Đang chạy script chính...")
getgenv().Language = "English"
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
