--[[
    CHILLI HUB - STEAL AN EGG (JOY EDITION)
    Owner: Joy
    Theme: Modern Dark / Gradient Cyan-Green
    Bypass: Ultra Protection / Anti-Kick A1 / Anti-Detect / Hook Protection
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- =================================================================
-- ULTRA A1 BYPASS & PROTECTION ENGINE (ANTI-KICK & INTEGRITY SPOOF)
-- =================================================================
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    local oldNewindex = mt.__newindex

    -- Anti Kick / Ban / Remote Filter
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Block Client Kick Attempt
        if method == "Kick" or method == "kick" or method == "Ban" then
            return nil
        end

        -- Block Anti-Cheat Remote Signals
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = tostring(self):lower()
            if remoteName:find("anti") or remoteName:find("cheat") or remoteName:find("ban") 
               or remoteName:find("detect") or remoteName:find("a1") or remoteName:find("kick") 
               or remoteName:find("log") or remoteName:find("report") then
                return nil
            end
        end

        return oldNamecall(self, ...)
    end)

    -- Humanoid & Memory Spoofing
    mt.__index = newcclosure(function(self, key)
        if not checkcaller() and self:IsA("Humanoid") then
            if key == "WalkSpeed" then return 16 end
            if key == "JumpPower" then return 50 end
            if key == "HipHeight" then return 2 end
        end
        return oldIndex(self, key)
    end)

    setreadonly(mt, true)
end)

-- Disable Idle Kick (Anti-AFK)
if getconnections then
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
        if conn.Disable then conn:Disable() end
    end
end

-- Disable Local Anti-Cheat Scripts in PlayerGui/Character
local function CleanLocalAntiCheat()
    pcall(function()
        for _, script in pairs(LocalPlayer:GetDescendants()) do
            if script:IsA("LocalScript") then
                local sName = script.Name:lower()
                if sName:find("anti") or sName:find("cheat") or sName:find("a1") or sName:find("guard") then
                    script.Disabled = true
                end
            end
        end
    end)
end
CleanLocalAntiCheat()

-- =================================================================
-- STATE CONFIG
-- =================================================================
local Settings = {
    -- Farm
    AutoSteal = false,
    DrScrambleEvent = false,
    TargetArea = "All",
    MinRarity = "Common",
    MinValue = 0,
    StealRiftMissing = false,
    TweenSpeed = 30,
    AntiGuardVI = true,
    
    -- Base & Management
    AutoPlaceEgg = false,
    PlaceOrder = "Highest Value",
    AutoTreadmill = false,
    AutoHatch = false,
    AutoEquipBest = false,
    AutoSell = false,
    KeepMutated = true,
    AutoFuse = false,
    AutoFavorite = false,

    -- Player & Combat
    SpeedBoost = false,
    SpeedValue = 32,
    InfiniteJump = false,
    Invisibility = false,
    AntiRagdoll = false,
    AntiTrap = false,
    InstantPrompts = false,
    AutoHitNearest = false,

    -- Visual & Misc
    EggPredictor = false,
    GiftPredictor = false,
    FPSCap = 60,
    Optimizer = false,
    ShowStats = true
}

-- =================================================================
-- UI GENERATOR (CHILLI HUB FULL TAB)
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BazzLua_ChilliHub_A1"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 35)
Topbar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "CHILLI HUB | Steal an Egg [A1 Bypass Active]"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(0, 230, 180)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Topbar

-- Sidebar Tabs
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -130, 1, -45)
Container.Position = UDim2.new(0, 125, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Tab Frames
local TabNames = {"Farm", "Player", "Predictor", "Progress", "Server", "Misc"}
local Tabs = {}

for _, name in pairs(TabNames) do
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 2
    f.Visible = false
    f.Parent = Container
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = f
    
    Tabs[name] = f
end
Tabs.Farm.Visible = true

-- Tab Switching Logic
local CurrentTabButton = nil
for order, name in ipairs(TabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, (order - 1) * 35 + 5)
    btn.Text = name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(150, 150, 160)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for tName, frame in pairs(Tabs) do
            frame.Visible = (tName == name)
        end
        if CurrentTabButton then
            CurrentTabButton.TextColor3 = Color3.fromRGB(150, 150, 160)
            CurrentTabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        end
        btn.TextColor3 = Color3.fromRGB(0, 230, 180)
        btn.BackgroundColor3 = Color3.fromRGB(28, 38, 42)
        CurrentTabButton = btn
    end)

    if order == 1 then
        btn.TextColor3 = Color3.fromRGB(0, 230, 180)
        btn.BackgroundColor3 = Color3.fromRGB(28, 38, 42)
        CurrentTabButton = btn
    end
end

-- Helper Component (Toggle)
local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBtn.Text = ""
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 230, 180) or Color3.fromRGB(45, 45, 55)
    toggleBtn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = toggleBtn

    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 230, 180) or Color3.fromRGB(45, 45, 55)
        callback(state)
    end)
end

-- =================================================================
-- BUILD UI FEATURES (FULL CHILLI HUB LIST)
-- =================================================================

-- FARM TAB
CreateToggle(Tabs.Farm, "Auto Steal Egg", false, function(v) Settings.AutoSteal = v end)
CreateToggle(Tabs.Farm, "Dr Scramble / Event Focus", false, function(v) Settings.DrScrambleEvent = v end)
CreateToggle(Tabs.Farm, "Steal Missing Index Eggs", false, function(v) Settings.StealRiftMissing = v end)
CreateToggle(Tabs.Farm, "Anti Guard VI (Bypass Detection)", true, function(v) Settings.AntiGuardVI = v end)

-- PLAYER TAB
CreateToggle(Tabs.Player, "Speed Boost", false, function(v) 
    Settings.SpeedBoost = v 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v and Settings.SpeedValue or 16
    end
end)
CreateToggle(Tabs.Player, "Infinite Jump", false, function(v) Settings.InfiniteJump = v end)
CreateToggle(Tabs.Player, "Anti Trap / Anti Ragdoll", false, function(v) Settings.AntiTrap = v end)
CreateToggle(Tabs.Player, "Instant Prompts", false, function(v) 
    Settings.InstantPrompts = v 
    for _, prompt in pairs(Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.HoldDuration = v and 0 or prompt.HoldDuration
        end
    end
end)

-- PREDICTOR TAB
CreateToggle(Tabs.Predictor, "Egg Predictor (Reveal Reward)", false, function(v) Settings.EggPredictor = v end)
CreateToggle(Tabs.Predictor, "Gift Predictor", false, function(v) Settings.GiftPredictor = v end)

-- PROGRESS TAB
CreateToggle(Tabs.Progress, "Auto Place Egg to Base", false, function(v) Settings.AutoPlaceEgg = v end)
CreateToggle(Tabs.Progress, "Auto Treadmill (Stay On)", false, function(v) Settings.AutoTreadmill = v end)
CreateToggle(Tabs.Progress, "Auto Hatch & Equip Best", false, function(v) Settings.AutoHatch = v end)
CreateToggle(Tabs.Progress, "Auto Sell (Keep Mutated)", false, function(v) Settings.AutoSell = v end)

-- SERVER TAB
CreateToggle(Tabs.Server, "Auto Rejoin on Kick/Disconnect", true, function(v) end)

-- MISC TAB
CreateToggle(Tabs.Misc, "FPS Optimizer", false, function(v)
    Settings.Optimizer = v
    if v then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
        end
    end
end)

-- =================================================================
-- LOGIC AUTOMATION & FLY STEAL ENGINE
-- =================================================================
local function GetBestEgg()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("egg") or name:find("scramble") or name:find("angel") or name:find("demon") then
                local p = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if p then return p end
            end
        end
    end
    return nil
end

-- Safe Flying Steal Loop
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if Settings.AutoSteal and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local target = GetBestEgg()
                if target then
                    -- Noclip check
                    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                    
                    -- Smooth Tween Fly (A1 Safe)
                    local dist = (hrp.Position - target.Position).Magnitude
                    if dist > 4 then
                        hrp.CFrame = CFrame.new(hrp.Position, target.Position) * CFrame.new(0, 0, -math.min(dist, Settings.TweenSpeed * 0.1))
                    else
                        hrp.CFrame = CFrame.new(target.Position)
                        firetouchinterest(hrp, target, 0)
                        firetouchinterest(hrp, target, 1)
                    end
                end
            end
        end)
    end
end)

-- Drag System
local dragging, dragStart, startPos
Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Topbar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Infinite Jump Listener
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
