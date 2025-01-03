local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
local textLabel = Instance.new("TextLabel")

screenGui.Parent = game.CoreGui
screenGui.DisplayOrder = 100

textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 300, 0, 50)
textLabel.Position = UDim2.new(0, 10, 0, 10) 
textLabel.Font = Enum.Font.FredokaOne 
textLabel.TextScaled = true 
textLabel.BackgroundTransparency = 1 
textLabel.TextStrokeTransparency = 0

local function rainbowColor()
    local Dreamon = 0
    while true do
        Dreamon = Dreamon + 0.01
        if Dreamon > 1 then Dreamon = 0 end
        textLabel.TextColor3 = Color3.fromHSV(Dreamon, 1, 1) 
        RunService.RenderStepped:Wait()
    end
end

local frameCount = 0
local lastUpdate = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()

    if now - lastUpdate >= 1 then
        local fps = frameCount / (now - lastUpdate)
        frameCount = 0
        lastUpdate = now

        local userName = LocalPlayer.Name
        textLabel.Text = string.format("%s, FPS: %d",userName, math.floor(fps))
    end
end)

spawn(rainbowColor)
