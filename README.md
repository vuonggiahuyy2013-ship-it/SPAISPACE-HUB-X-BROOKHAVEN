-- SPAISPACE HUB for Brookhaven RP
-- Modified by Huy Tạo | Original by Luscaa and venom
-- Translated to English and rebranded

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()
workspace.FallenPartsDestroyHeight = -math.huge

-- Main Window Configuration
local Window = Library:MakeWindow({
    Title = "SPAISPACE HUB | Brookhaven RP",
    SubTitle = "Modified by Huy Tạo | Original by Luscaa and venom",
    LoadText = "Loading SPAISPACE HUB...",
    Flags = "SPAISPACE_HUB_Brookhaven"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://131669852271916", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- Info Tab
local InfoTab = Window:MakeTab({ Title = "Info", Icon = "rbxassetid://15309138473" })

InfoTab:AddSection({ "Script Information" })
InfoTab:AddParagraph({ "Owner / Developer:", "Luscaa and venom (Modified by Huy Tạo)" })
InfoTab:AddParagraph({ "Collaborators:", "Blue, sukuna, Magekko, Darkness, Star, Toddy" })
InfoTab:AddParagraph({ "You are using:", "SPAISPACE HUB Brookhaven" })
InfoTab:AddParagraph({"Your executor:", executor})

InfoTab:AddSection({ "Rejoin Server" })
InfoTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

-- Troll Scripts Tab
local TrollTab = Window:MakeTab({ Title = "Troll Scripts", Icon = "rbxassetid://13364900349" })

TrollTab:AddSection({ "Black Hole" })
TrollTab:AddButton({
    Name = "Black Hole",
    Description = "Activate to pull Parts towards your character",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local Workspace = game:GetService("Workspace")

        local angle = 1
        local radius = 10
        local blackHoleActive = false

        local function setupPlayer()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local Folder = Instance.new("Folder", Workspace)
            local Part = Instance.new("Part", Folder)
            local Attachment1 = Instance.new("Attachment", Part)
            Part.Anchored = true
            Part.CanCollide = false
            Part.Transparency = 1

            return humanoidRootPart, Attachment1
        end

        local humanoidRootPart, Attachment1 = setupPlayer()

        if not getgenv().Network then
            getgenv().Network = {
                BaseParts = {},
                Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
            }

            Network.RetainPart = function(part)
                if typeof(part) == "Instance" and part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
                    table.insert(Network.BaseParts, part)
                    part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                    part.CanCollide = false
                end
            end

            local function EnablePartControl()
                LocalPlayer.ReplicationFocus = Workspace
                RunService.Heartbeat:Connect(function()
                    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                    for _, part in pairs(Network.BaseParts) do
                        if part:IsDescendantOf(Workspace) then
                            part.Velocity = Network.Velocity
                        end
                    end
                end)
            end

            EnablePartControl()
        end

        local function ForcePart(v)
            if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
                for _, x in next, v:GetChildren() do
                    if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
                        x:Destroy()
                    end
                end
                if v:FindFirstChild("Attachment") then
                    v:FindFirstChild("Attachment"):Destroy()
                end
                if v:FindFirstChild("AlignPosition") then
                    v:FindFirstChild("AlignPosition"):Destroy()
                end
                if v:FindFirstChild("Torque") then
                    v:FindFirstChild("Torque"):Destroy()
                end
                v.CanCollide = false

                local Torque = Instance.new("Torque", v)
                Torque.Torque = Vector3.new(1000000, 1000000, 1000000)
                local AlignPosition = Instance.new("AlignPosition", v)
                local Attachment2 = Instance.new("Attachment", v)
                Torque.Attachment0 = Attachment2
                AlignPosition.MaxForce = math.huge
                AlignPosition.MaxVelocity = math.huge
                AlignPosition.Responsiveness = 500
                AlignPosition.Attachment0 = Attachment2
                AlignPosition.Attachment1 = Attachment1
            end
        end

        local function toggleBlackHole()
            blackHoleActive = not blackHoleActive
            if blackHoleActive then
                for _, v in next, Workspace:GetDescendants() do
                    ForcePart(v)
                end

                Workspace.DescendantAdded:Connect(function(v)
                    if blackHoleActive then
                        ForcePart(v)
                    end
                end)

                spawn(function()
                    while blackHoleActive and RunService.RenderStepped:Wait() do
                        angle = angle + math.rad(2)

                        local offsetX = math.cos(angle) * radius
                        local offsetZ = math.sin(angle) * radius

                        Attachment1.WorldCFrame = humanoidRootPart.CFrame * CFrame.new(offsetX, 0, offsetZ)
                    end
                end)
            else
                Attachment1.WorldCFrame = CFrame.new(0, -1000, 0)
            end
        end

        LocalPlayer.CharacterAdded:Connect(function()
            humanoidRootPart, Attachment1 = setupPlayer()
            if blackHoleActive then
                toggleBlackHole()
            end
        end)

        local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/miroeramaa/TurtleLib/main/TurtleUiLib.lua"))()
        local window = library:Window("SPAISPACE HUB")

        window:Slider("Blackhole Radius",1,100,10, function(Value)
           radius = Value
        end)

        window:Toggle("Blackhole", true, function(Value)
               if Value then
                    toggleBlackHole()
                else
                    blackHoleActive = false
                end
        end)

        spawn(function()
            while true do
                RunService.RenderStepped:Wait()
                if blackHoleActive then
                    angle = angle + math.rad(2)
                end
            end
        end)

        toggleBlackHole()
    end
})

TrollTab:AddSection({ "Pull Parts" })
TrollTab:AddButton({
    Name = "Pull Parts",
    Description = "Get close to the selected player to use this",
    Callback = function()
        -- Gui to Lua
        -- Version: 3.2

        -- Instances:
        local Gui = Instance.new("ScreenGui")
        local Main = Instance.new("Frame")
        local Box = Instance.new("TextBox")
        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
        local Label = Instance.new("TextLabel")
        local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
        local Button = Instance.new("TextButton")
        local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")

        -- Properties:
        Gui.Name = "SPAISPACE_PartsGUI"
        Gui.Parent = gethui()
        Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        Main.Name = "Main"
        Main.Parent = Gui
        Main.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Main.BorderSizePixel = 0
        Main.Position = UDim2.new(0.335954279, 0, 0.542361975, 0)
        Main.Size = UDim2.new(0.240350261, 0, 0.166880623, 0)
        Main.Active = true
        Main.Draggable = true

        Box.Name = "Box"
        Box.Parent = Main
        Box.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
        Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Box.BorderSizePixel = 0
        Box.Position = UDim2.new(0.0980926454, 0, 0.218712583, 0)
        Box.Size = UDim2.new(0.801089942, 0, 0.364963502, 0)
        Box.FontFace = Font.new("rbxasset://fonts/families/SourceSansSemibold.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Box.PlaceholderText = "Enter player name"
        Box.Text = ""
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.TextScaled = true
        Box.TextSize = 31.000
        Box.TextWrapped = true

        UITextSizeConstraint.Parent = Box
        UITextSizeConstraint.MaxTextSize = 31

        Label.Name = "Label"
        Label.Parent = Main
        Label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
        Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Label.BorderSizePixel = 0
        Label.Size = UDim2.new(1, 0, 0.160583943, 0)
        Label.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Label.Text = "Pull Parts | SPAISPACE HUB"
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextScaled = true
        Label.TextSize = 14.000
        Label.TextWrapped = true

        UITextSizeConstraint_2.Parent = Label
        UITextSizeConstraint_2.MaxTextSize = 21

        Button.Name = "Button"
        Button.Parent = Main
        Button.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
        Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Button.BorderSizePixel = 0
        Button.Position = UDim2.new(0.183284417, 0, 0.656760991, 0)
        Button.Size = UDim2.new(0.629427791, 0, 0.277372271, 0)
        Button.Font = Enum.Font.Nunito
        Button.Text = "Pull | OFF"
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextScaled = true
        Button.TextSize = 28.000
        Button.TextWrapped = true

        UITextSizeConstraint_3.Parent = Button
        UITextSizeConstraint_3.MaxTextSize = 28

        -- Scripts:
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local UserInputService = game:GetService("UserInputService")
        local Workspace = game:GetService("Workspace")

        local character
        local humanoidRootPart

        mainStatus = true
        UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
                mainStatus = not mainStatus
                Main.Visible = mainStatus
            end
        end)

        local Folder = Instance.new("Folder", Workspace)
        local Part = Instance.new("Part", Folder)
        local Attachment1 = Instance.new("Attachment", Part)
        Part.Anchored = true
        Part.CanCollide = false
        Part.Transparency = 1

        if not getgenv().Network then
            getgenv().Network = {
                BaseParts = {},
                Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
            }

            Network.RetainPart = function(Part)
                if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
                    table.insert(Network.BaseParts, Part)
                    Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                    Part.CanCollide = false
                end
            end

            local function EnablePartControl()
                LocalPlayer.ReplicationFocus = Workspace
                RunService.Heartbeat:Connect(function()
                    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                    for _, Part in pairs(Network.BaseParts) do
                        if Part:IsDescendantOf(Workspace) then
                            Part.Velocity = Network.Velocity
                        end
                    end
                end)
            end

            EnablePartControl()
        end

        local function ForcePart(v)
            if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
                for _, x in ipairs(v:GetChildren()) do
                    if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
                        x:Destroy()
                    end
                end
                if v:FindFirstChild("Attachment") then
                    v:FindFirstChild("Attachment"):Destroy()
                end
                if v:FindFirstChild("AlignPosition") then
                    v:FindFirstChild("AlignPosition"):Destroy()
                end
                if v:FindFirstChild("Torque") then
                    v:FindFirstChild("Torque"):Destroy()
                end
                v.CanCollide = false
                local Torque = Instance.new("Torque", v)
                Torque.Torque = Vector3.new(100000, 100000, 100000)
                local AlignPosition = Instance.new("AlignPosition", v)
                local Attachment2 = Instance.new("Attachment", v)
                Torque.Attachment0 = Attachment2
                AlignPosition.MaxForce = math.huge
                AlignPosition.MaxVelocity = math.huge
                AlignPosition.Responsiveness = 200
                AlignPosition.Attachment0 = Attachment2
                AlignPosition.Attachment1 = Attachment1
            end
        end

        local blackHoleActive = false
        local DescendantAddedConnection

        local function toggleBlackHole()
            blackHoleActive = not blackHoleActive
            if blackHoleActive then
                Button.Text = "Pull Parts | ON"
                for _, v in ipairs(Workspace:GetDescendants()) do
                    ForcePart(v)
                end

                DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
                    if blackHoleActive then
                        ForcePart(v)
                    end
                end)

                spawn(function()
                    while blackHoleActive do
                        RunService.RenderStepped:Wait()
                        -- Target player logic here
                    end
                end)
            else
                Button.Text = "Pull Parts | OFF"
                if DescendantAddedConnection then
                    DescendantAddedConnection:Disconnect()
                end
            end
        end

        Button.MouseButton1Click:Connect(function()
            toggleBlackHole()
        end)
    end
})

-- Teleport Tab (New Feature)
local TeleportTab = Window:MakeTab({ Title = "Teleport", Icon = "rbxassetid://13364900349" })

TeleportTab:AddSection({ "Player Teleport" })
TeleportTab:AddButton({
    Name = "Teleport to Player",
    Description = "Teleport to selected player",
    Callback = function()
        local playerName = "PlayerName" -- This would need a UI to select players
        for _, player in pairs(game.Players:GetPlayers()) do
            if string.find(string.lower(player.Name), string.lower(playerName)) then
                game.Players.LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position)
                break
            end
        end
    end
})

-- Settings Tab (New Feature)
local SettingsTab = Window:MakeTab({ Title = "Settings", Icon = "rbxassetid://15309138473" })

SettingsTab:AddSection({ "UI Settings" })
SettingsTab:AddToggle({
    Name = "Show Notifications",
    Default = true,
    Callback = function(value)
        -- Notification toggle logic
    end
})

SettingsTab:AddButton({
    Name = "Destroy GUI",
    Callback = function()
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui.Name:find("SPAISPACE") then
                gui:Destroy()
            end
        end
    end
})

-- Final Loading Message
warn("SPAISPACE HUB loaded successfully!")
warn("Use RightControl to toggle Parts Pull GUI")
warn("Happy gaming!")

-- Auto-hide instructions after 10 seconds
delay(10, function()
    warn("SPAISPACE HUB: GUI is active. Check your screen for the interface.")
end)
