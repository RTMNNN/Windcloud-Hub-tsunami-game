local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "WindCloud Hub",
    LoadingTitle = "WindCloud Hub",
    LoadingSubtitle = "The Tsunamis Game",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main")
local TeleportTab = Window:CreateTab("Teleport")

local BananaFarm = false
local AutoFarm = false
local CoinEnabled = false
local TPWalkSpeed = 0
local FinishRouteRunning = false
local FinishRouteCancel = false

local function teleport(x, y, z)
    local character = Player.Character

    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    end
end

RunService.Heartbeat:Connect(function()
    if TPWalkSpeed > 0 then
        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if humanoid and root and humanoid.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + humanoid.MoveDirection * TPWalkSpeed
        end
    end
end)

MainTab:CreateToggle({
    Name = "Banana Farm",
    CurrentValue = false,
    Callback = function(Value)
        BananaFarm = Value

        if Value then
            task.spawn(function()
                while BananaFarm do
                    local character = Player.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")

                    if root then
                        local oldPosition = root.CFrame

                        teleport(-188, -2084, -19)

                        task.wait(1.5)

                        if BananaFarm and root.Parent then
                            root.CFrame = oldPosition
                        end
                    end

                    task.wait(0.2)
                end
            end)
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarm = Value

        if Value then
            task.spawn(function()
                while AutoFarm do
                    local character = Player.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                    if root and humanoid then
                        local jumping = true

                        task.spawn(function()
                            while jumping and AutoFarm do
                                humanoid.Jump = true
                                task.wait(0.1)
                            end
                        end)

                        local route = {
                            Vector3.new(11, 120, -982),
                            Vector3.new(-171, 121, 476),
                            Vector3.new(151, 121, 477),
                            Vector3.new(151, 121, -24),
                            Vector3.new(-166, 121, -22),
                            Vector3.new(-168, 121, -524),
                            Vector3.new(152, 121, -523),
                            Vector3.new(11, 120, -982)
                        }

                        for _, position in ipairs(route) do
                            if not AutoFarm then
                                break
                            end

                            local tween = TweenService:Create(
                                root,
                                TweenInfo.new(1, Enum.EasingStyle.Linear),
                                {CFrame = CFrame.new(position)}
                            )

                            tween:Play()

                            while tween.PlaybackState == Enum.PlaybackState.Playing do
                                if not AutoFarm then
                                    tween:Cancel()
                                    break
                                end

                                task.wait()
                            end

                            if AutoFarm then
                                task.wait(1)
                            end
                        end

                        jumping = false

                        if AutoFarm then
                            local endTween = TweenService:Create(
                                root,
                                TweenInfo.new(1, Enum.EasingStyle.Linear),
                                {CFrame = CFrame.new(-11, 40, -1052)}
                            )

                            endTween:Play()

                            while endTween.PlaybackState == Enum.PlaybackState.Playing do
                                if not AutoFarm then
                                    endTween:Cancel()
                                    break
                                end

                                task.wait()
                            end

                            if AutoFarm then
                                task.wait(1.9)

                                humanoid.Health = 0

                                local newCharacter = Player.CharacterAdded:Wait()

                                if AutoFarm then
                                    newCharacter:WaitForChild("HumanoidRootPart")
                                    newCharacter:WaitForChild("Humanoid")
                                    task.wait(1)
                                end
                            end
                        end
                    end

                    task.wait(0.2)
                end
            end)
        end
    end
})

MainTab:CreateToggle({
    Name = "Bring Coins",
    CurrentValue = false,
    Callback = function(Value)
        CoinEnabled = Value

        if Value then
            task.spawn(function()
                while CoinEnabled do
                    task.wait(0.1)

                    local character = Player.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")

                    if root then
                        for _, v in pairs(Workspace:GetDescendants()) do
                            if v.Name == "CoinCollision" then
                                v.CFrame = root.CFrame
                            end
                        end
                    end
                end
            end)
        end
    end
})

MainTab:CreateInput({
    Name = "WalkSpeed",
    PlaceholderText = "Enter WalkSpeed",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local value = tonumber(Text)
        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if value and humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

MainTab:CreateInput({
    Name = "Jump Power",
    PlaceholderText = "Enter Jump Power",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local value = tonumber(Text)
        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if value and humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = value
        end
    end
})

MainTab:CreateInput({
    Name = "TP Walk",
    PlaceholderText = "Enter TP Walk Speed",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local value = tonumber(Text)

        if value then
            TPWalkSpeed = value
        end
    end
})

MainTab:CreateButton({
    Name = "Remove All Customized Speed",
    Callback = function()
        TPWalkSpeed = 0

        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
    end
})

TeleportTab:CreateButton({
    Name = "TP to First Cave",
    Callback = function()
        teleport(-171, 121, 476)
    end
})

TeleportTab:CreateButton({
    Name = "TP to Second Cave",
    Callback = function()
        teleport(151, 121, 477)
    end
})

TeleportTab:CreateButton({
    Name = "TP to Third Cave",
    Callback = function()
        teleport(151, 121, -24)
    end
})

TeleportTab:CreateButton({
    Name = "TP to Fourth Cave",
    Callback = function()
        teleport(-166, 121, -22)
    end
})

TeleportTab:CreateButton({
    Name = "TP to Fifth Cave",
    Callback = function()
        teleport(-168, 121, -524)
    end
})

TeleportTab:CreateButton({
    Name = "TP to Sixth Cave",
    Callback = function()
        teleport(152, 121, -523)
    end
})

TeleportTab:CreateButton({
    Name = "TP to End",
    Callback = function()
        teleport(11, 120, -982)
    end
})

TeleportTab:CreateButton({
    Name = "Finish the Game",
    Callback = function()
        if FinishRouteRunning then
            return
        end

        FinishRouteRunning = true
        FinishRouteCancel = false

        Rayfield:Notify({
            Title = "Notification.",
            Content = "Please Wait!",
            Duration = 3,
            Image = 4483362458,
        })

        local character = Player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if root and humanoid then
            local jumping = true

            task.spawn(function()
                while jumping and FinishRouteRunning and not FinishRouteCancel do
                    humanoid.Jump = true
                    task.wait(0.1)
                end
            end)

            local function tweenTo(position)
                if FinishRouteCancel then
                    return false
                end

                local tween = TweenService:Create(
                    root,
                    TweenInfo.new(1, Enum.EasingStyle.Linear),
                    {CFrame = CFrame.new(position)}
                )

                tween:Play()

                while tween.PlaybackState == Enum.PlaybackState.Playing do
                    if FinishRouteCancel then
                        tween:Cancel()
                        return false
                    end

                    task.wait()
                end

                return true
            end

            local route = {
                Vector3.new(11, 120, -982),
                Vector3.new(-171, 121, 476),
                Vector3.new(151, 121, 477),
                Vector3.new(151, 121, -24),
                Vector3.new(-166, 121, -22),
                Vector3.new(-168, 121, -524),
                Vector3.new(152, 121, -523),
                Vector3.new(11, 120, -982)
            }

            for _, position in ipairs(route) do
                if not tweenTo(position) then
                    break
                end

                task.wait(1)
            end

            jumping = false
        end

        FinishRouteRunning = false
        FinishRouteCancel = false
    end
})

TeleportTab:CreateButton({
    Name = "Cancel Finish Route",
    Callback = function()
        if FinishRouteRunning then
            FinishRouteCancel = true

            Rayfield:Notify({
                Title = "Route Cancelled",
                Content = "Finish the Game route has been stopped.",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})