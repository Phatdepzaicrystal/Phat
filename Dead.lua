local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenSpeed = 100 -- Mặc định tốc độ bay

_G.TeleportEnabled = false -- Biến kiểm soát bật/tắt teleport

-- 🖥️ Tạo GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local TeleportButton = Instance.new("TextButton", Frame)
local SpeedLabel = Instance.new("TextLabel", Frame)
local SpeedSlider = Instance.new("TextButton", Frame)
local UICorner = Instance.new("UICorner", Frame)
local ButtonCorner = Instance.new("UICorner", TeleportButton)

-- 📌 Cấu hình Frame (khung chứa button)
Frame.Size = UDim2.new(0, 220, 0, 130)
Frame.Position = UDim2.new(0.05, 0, 0.05, 0) -- Góc trên bên trái
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true -- Kéo UI được

-- 🎨 Bo góc Frame
UICorner.CornerRadius = UDim.new(0, 10)

-- 📌 Cấu hình Button Teleport
TeleportButton.Size = UDim2.new(0, 180, 0, 50)
TeleportButton.Position = UDim2.new(0.5, -90, 0.2, 0)
TeleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextSize = 20
TeleportButton.Text = "Bật Teleport"

-- 🎨 Bo góc Button
ButtonCorner.CornerRadius = UDim.new(0, 8)

-- 📌 Nhãn hiển thị tốc độ bay
SpeedLabel.Size = UDim2.new(0, 180, 0, 20)
SpeedLabel.Position = UDim2.new(0.5, -90, 0.6, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 16
SpeedLabel.Text = "Tốc độ: " .. TweenSpeed

-- 📌 Thanh trượt chỉnh tốc độ
SpeedSlider.Size = UDim2.new(0, 180, 0, 10)
SpeedSlider.Position = UDim2.new(0.5, -90, 0.8, 0)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SpeedSlider.Text = ""

-- ✈️ Hàm di chuyển chậm bằng TweenService
function topos(targetCFrame)
    if not _G.TeleportEnabled then return end -- Kiểm tra có bật teleport không

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local humanoidRootPart = character.HumanoidRootPart
    local distance = (humanoidRootPart.Position - targetCFrame.Position).Magnitude

    -- Cấu hình TweenInfo
    local tweenInfo = TweenInfo.new(distance / TweenSpeed, Enum.EasingStyle.Linear)

    -- Tạo Tween di chuyển nhân vật
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()

    -- Dừng di chuyển khi tắt teleport
    task.spawn(function()
        while tween.PlaybackState == Enum.PlaybackState.Playing and _G.TeleportEnabled do
            task.wait()
        end
        if not _G.TeleportEnabled then
            tween:Cancel()
        end
    end)
end

-- 🛠 Toggle Teleport khi bấm nút
TeleportButton.MouseButton1Click:Connect(function()
    _G.TeleportEnabled = not _G.TeleportEnabled
    if _G.TeleportEnabled then
        TeleportButton.Text = "Tắt Teleport"

        -- Gửi request mở cổng trước khi teleport
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-346, -69, -49060))

        -- Sau khi mở cổng, bay chậm đến Dead Raid
        topos(CFrame.new(-346, -69, -49060)) 
    else
        TeleportButton.Text = "Bật Teleport"
    end
end)

-- 📌 Điều chỉnh tốc độ bay khi kéo thanh trượt
SpeedSlider.MouseButton1Down:Connect(function()
    local connection
    connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local newSpeed = math.clamp((input.Position.X - SpeedSlider.AbsolutePosition.X) / SpeedSlider.AbsoluteSize.X * 200, 50, 500)
            TweenSpeed = math.floor(newSpeed)
            SpeedLabel.Text = "Tốc độ: " .. TweenSpeed
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)
