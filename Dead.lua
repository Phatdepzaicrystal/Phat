local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenSpeed = 250 -- Điều chỉnh tốc độ dịch chuyển

_G.TeleportEnabled = false -- Biến kiểm soát bật/tắt teleport

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local TeleportButton = Instance.new("TextButton", Frame)
local UICorner = Instance.new("UICorner", Frame)
local ButtonCorner = Instance.new("UICorner", TeleportButton)

-- Cấu hình Frame (khung chứa button)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.05, 0, 0.05, 0) -- Đặt UI góc trên bên trái
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true -- Cho phép kéo UI

-- Bo góc Frame
UICorner.CornerRadius = UDim.new(0, 10)

-- Cấu hình Button
TeleportButton.Size = UDim2.new(0, 180, 0, 50)
TeleportButton.Position = UDim2.new(0.5, -90, 0.5, -25)
TeleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextSize = 20
TeleportButton.Text = "Bật Teleport"

-- Bo góc Button
ButtonCorner.CornerRadius = UDim.new(0, 8)

function topos(p)
    task.spawn(function()
        pcall(function()
            if not _G.TeleportEnabled then return end -- Chỉ dịch chuyển khi được bật

            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end

            local humanoidRootPart = character.HumanoidRootPart
            local distance = (humanoidRootPart.Position - p.Position).Magnitude

            if distance <= 200 then
                humanoidRootPart.CFrame = p
            else
                if not character:FindFirstChild("Root") then
                    local rootPart = Instance.new("Part", character)
                    rootPart.Size = Vector3.new(1, 0.5, 1)
                    rootPart.Name = "Root"
                    rootPart.Anchored = true
                    rootPart.Transparency = 1
                    rootPart.CanCollide = false
                    rootPart.CFrame = humanoidRootPart.CFrame
                end

                local root = character:FindFirstChild("Root")
                if root then
                    local tweenInfo = TweenInfo.new(distance / TweenSpeed, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(root, tweenInfo, {CFrame = p})
                    tween:Play()
                    
                    if _G.StopTween then
                        tween:Cancel()
                    end

                    task.spawn(function()
                        while tween.PlaybackState == Enum.PlaybackState.Playing and _G.TeleportEnabled do
                            humanoidRootPart.CFrame = root.CFrame
                            task.wait()
                        end
                    end)
                end
            end
        end)
    end)
end

-- Toggle Teleport khi bấm nút
TeleportButton.MouseButton1Click:Connect(function()
    _G.TeleportEnabled = not _G.TeleportEnabled
    if _G.TeleportEnabled then
        TeleportButton.Text = "Turn Off Teleport"
        topos(CFrame.new(-346, -69, -49060)) -- Dịch chuyển đến Dead Raid
    else
        TeleportButton.Text = "Turn On Teleport"
    end
end)
