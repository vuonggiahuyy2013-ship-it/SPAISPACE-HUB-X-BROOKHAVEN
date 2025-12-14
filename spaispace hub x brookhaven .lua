
local Libary = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()
workspace.FallenPartsDestroyHeight = -math.huge

-- MAIN WINDOW
local Window = Libary:MakeWindow({
    Title = "SPAISPACE HUB | Brookhaven RP ",
    SubTitle = "Made by Huy",
    LoadText = "Loading SPAISPACE HUB",
    Flags = "SPAISPACE_HUB_Broookhaven"
})

-- ICON UPDATED HERE
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://136979691479989", BackgroundTransparency = 0 }, 
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- INFO TAB
local InfoTab = Window:MakeTab({ Title = "Info", Icon = "rbxassetid://15309138473" })
InfoTab:AddSection({ "Script Information" })
InfoTab:AddParagraph({ "Owner / Developer:", "Huy" })
InfoTab:AddParagraph({ "Note:", "Copy ca 2 phan va dan vao Executor" })

InfoTab:AddSection({ "Rejoin" })
InfoTab:AddButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

-- TROLL SCRIPTS TAB
local TrollTab = Window:MakeTab({ Title = "Troll Scripts", Icon = "rbxassetid://13364900349" })

TrollTab:AddSection({ "Black Hole" })
TrollTab:AddButton({
    Name = "Black Hole",
    Description = "Pulls Parts towards you",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local Workspace = game:GetService("Workspace")
        local angle, radius, blackHoleActive = 1, 10, false
        local humanoidRootPart, Attachment1

        local function setupPlayer()
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local Folder = Instance.new("Folder", Workspace)
            local Part = Instance.new("Part", Folder)
            local Att = Instance.new("Attachment", Part)
            Part.Anchored, Part.CanCollide, Part.Transparency = true, false, 1
            return hrp, Att
        end
        humanoidRootPart, Attachment1 = setupPlayer()

        if not getgenv().Network then
            getgenv().Network = { BaseParts = {}, Velocity = Vector3.new(14.46, 14.46, 14.46) }
            Network.RetainPart = function(part)
                if typeof(part)=="Instance" and part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
                    table.insert(Network.BaseParts, part)
                    part.CanCollide = false
                end
            end
            LocalPlayer.ReplicationFocus = Workspace
            RunService.Heartbeat:Connect(function()
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                for _, part in pairs(Network.BaseParts) do
                    if part:IsDescendantOf(Workspace) then part.Velocity = Network.Velocity end
                end
            end)
        end

        local function ForcePart(v)
            if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
                for _, x in next, v:GetChildren() do
                    if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then x:Destroy() end
                end
                if v:FindFirstChild("Attachment") then v:FindFirstChild("Attachment"):Destroy() end
                if v:FindFirstChild("AlignPosition") then v:FindFirstChild("AlignPosition"):Destroy() end
                if v:FindFirstChild("Torque") then v:FindFirstChild("Torque"):Destroy() end
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
                for _, v in next, Workspace:GetDescendants() do ForcePart(v) end
                Workspace.DescendantAdded:Connect(function(v) if blackHoleActive then ForcePart(v) end end)
                spawn(function()
                    while blackHoleActive and RunService.RenderStepped:Wait() do
                        angle = angle + math.rad(2)
                        Attachment1.WorldCFrame = humanoidRootPart.CFrame * CFrame.new(math.cos(angle)*radius, 0, math.sin(angle)*radius)
                    end
                end)
            else
                Attachment1.WorldCFrame = CFrame.new(0, -1000, 0)
            end
        end
        LocalPlayer.CharacterAdded:Connect(function()
            humanoidRootPart, Attachment1 = setupPlayer()
            if blackHoleActive then toggleBlackHole() end
        end)
        toggleBlackHole()
    end
})

TrollTab:AddSection({ "Bring Parts GUI" })
TrollTab:AddButton({
    Name = "Bring Parts",
    Description = "Activate GUI to bring parts to player",
    Callback = function()
        local Gui = Instance.new("ScreenGui")
        local Main = Instance.new("Frame")
        local Box = Instance.new("TextBox")
        local Button = Instance.new("TextButton")
        
        Gui.Name, Gui.Parent = "Gui", game.CoreGui or game.Players.LocalPlayer.PlayerGui
        Main.Parent, Main.BackgroundColor3 = Gui, Color3.fromRGB(75, 75, 75)
        Main.Position, Main.Size = UDim2.new(0.33, 0, 0.54, 0), UDim2.new(0.24, 0, 0.16, 0)
        Main.Active, Main.Draggable = true, true
        
        Box.Parent, Box.PlaceholderText = Main, "Player Name"
        Box.Position, Box.Size = UDim2.new(0.1, 0, 0.2, 0), UDim2.new(0.8, 0, 0.36, 0)
        Box.TextScaled = true
        
        Button.Parent, Button.Text = Main, "Bring | Off"
        Button.Position, Button.Size = UDim2.new(0.18, 0, 0.65, 0), UDim2.new(0.62, 0, 0.27, 0)
        Button.TextScaled = true

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Workspace = game:GetService("Workspace")
        local LocalPlayer = Players.LocalPlayer
        local character, humanoidRootPart
        
        local Folder = Instance.new("Folder", Workspace)
        local Part = Instance.new("Part", Folder)
        local Attachment1 = Instance.new("Attachment", Part)
        Part.Anchored, Part.CanCollide, Part.Transparency = true, false, 1

        local function ForcePart(v)
             if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and v.Name ~= "Handle" then
                v.CanCollide = false
                local AlignPosition = Instance.new("AlignPosition", v)
                local Attachment2 = Instance.new("Attachment", v)
                AlignPosition.MaxForce, AlignPosition.MaxVelocity, AlignPosition.Responsiveness = math.huge, math.huge, 200
                AlignPosition.Attachment0, AlignPosition.Attachment1 = Attachment2, Attachment1
            end
        end

        local blackHoleActive = false
        local function toggle()
            blackHoleActive = not blackHoleActive
            Button.Text = blackHoleActive and "Bring | On" or "Bring | Off"
            if blackHoleActive then
                for _, v in ipairs(Workspace:GetDescendants()) do ForcePart(v) end
                spawn(function()
                    while blackHoleActive and RunService.RenderStepped:Wait() do
                        if humanoidRootPart then Attachment1.WorldCFrame = humanoidRootPart.CFrame end
                    end
                end)
            end
        end

        local selectedPlayer
        Box.FocusLost:Connect(function(enter)
            if enter then
                for _, p in pairs(Players:GetPlayers()) do
                    if string.find(string.lower(p.Name), string.lower(Box.Text)) then
                        selectedPlayer = p
                        Box.Text = p.Name
                        break
                    end
                end
            end
        end)

        Button.MouseButton1Click:Connect(function()
            if selectedPlayer and selectedPlayer.Character then
                humanoidRootPart = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                toggle()
            end
        end)
    end
})
TrollTab:AddSection({ "Invisible" })
TrollTab:AddButton({
    Name = "Go Invisible (FE)",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer({[1]=102344834840946,[2]=70400527171038,[3]=0,[4]=0,[5]=0,[6]=0})
        game:GetService("ReplicatedStorage").Remotes.Wear:InvokeServer(111858803548721)
    end
})

-- TROLL PLAYERS TAB
local TrollPlayers = Window:MakeTab({ Title = "Troll Players", Icon = "rbxassetid://131153193945220" })
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local selectedPlayerName

local function KillPlayerCouch()
    if not selectedPlayerName then return end
    local target = Players:FindFirstChild(selectedPlayerName)
    if not target or not target.Character then return end
    
    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
    wait(0.2)
    ReplicatedStorage.RE["1Too1l"]:InvokeServer("PickingTools", "Couch")
    wait(0.3)
    
    local tool = LocalPlayer.Backpack:FindFirstChild("Couch")
    if tool then tool.Parent = LocalPlayer.Character end
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
    
    local hum = LocalPlayer.Character.Humanoid
    local root = LocalPlayer.Character.HumanoidRootPart
    local tRoot = target.Character.HumanoidRootPart
    
    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    local align = Instance.new("BodyPosition", tRoot)
    align.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    align.Position = root.Position
    
    spawn(function()
        local startTime = tick()
        while tick() - startTime < 4 do
            root.CFrame = tRoot.CFrame
            align.Position = root.Position
            game:GetService("RunService").Heartbeat:Wait()
        end
        align:Destroy()
        root.CFrame = CFrame.new(145, -350, 21) -- Void location
        wait(0.5)
        ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    end)
end

local PlayerSection = TrollPlayers:AddSection({ Name = "Target Selector" })
local function getPlayerList()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.Name) end end
    return names
end

local TrollDropdown = PlayerSection:AddDropdown({
    Name = "Select Target",
    Options = getPlayerList(),
    Callback = function(v) selectedPlayerName = v end
})

PlayerSection:AddButton({ Name = "Refresh List", Callback = function() TrollDropdown:Refresh(getPlayerList()) end })
PlayerSection:AddButton({ Name = "Kill (Couch)", Callback = KillPlayerCouch })

-- TELEPORT TAB
local TpTab = Window:MakeTab({"Teleports", "tp"})
local tps = {
    {"Backstage", CFrame.new(192, 4, 272)},
    {"Bank", CFrame.new(165, -35, 179)},
    {"Agency", CFrame.new(672, 4, -296)},
    {"Fountain", CFrame.new(136, 4, 117)}
}
for _, d in ipairs(tps) do
    TpTab:AddButton({ Name = d[1], Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = d[2] end })
end

-- TOOLS TAB
local ToolsTab = Window:MakeTab({ Title = "Tools", Icon = "rbxassetid://131669852271916" })
ToolsTab:AddButton({ Name = "Clear Tools", Callback = function() ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools") end })
ToolsTab:AddButton({
    Name = "Spin Character",
    Callback = function()
        local root = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        game:GetService("RunService").RenderStepped:Connect(function(dt)
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(2000)*dt, 0)
        end)
    end
})

-- UNIVERSAL
local UniversalTab = Window:MakeTab({ Title = "Universal", Icon = "rbxassetid://131669852271916" })
UniversalTab:AddButton({ Name = "Infinite Yield", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end })
UniversalTab:AddButton({ Name = "Fly GUI", Callback = function() loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Fly-v3-7412"))() end })

print("SPAISPACE HUB Loaded (Split Version). Made by Huy.")
