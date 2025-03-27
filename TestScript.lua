local hwid = gethwid and gethwid() or "Unknown"
local key = getgenv().Key

if not key or key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập key!")
    return
end

local http = game:HttpGet
local api_url = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/save_key?hwid=" .. hwid .. "&key=" .. key

local success, response = pcall(function()
    return http(api_url)
end)

if success then
    local json = game:GetService("HttpService"):JSONDecode(response)
    if json.status == "false" then
        game.Players.LocalPlayer:Kick("❌ " .. json.message)
    end
else
    game.Players.LocalPlayer:Kick("🚫 Không thể kết nối đến máy chủ!")
end
