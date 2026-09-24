--[[
    ============================================================
    STEAL AN EGG -- ALL FITUR v10
    KEY: 1234 (joy / kaw / steal / egg / vip)
    ============================================================
]]

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local HttpService       = game:GetService("HttpService")
local StarterGui        = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService   = game:GetService("TeleportService")
local VirtualUser       = game:GetService("VirtualUser")
local SoundService      = game:GetService("SoundService")
local Workspace         = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- ==================================================
-- ANTI LAYER (PALING ATAS)
-- ==================================================
pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if m == "Kick" or m == "kick" or m == "KickSelf" then return end
        if m == "Destroy" and self == LP then return end
        if m == "TakeDamage" and self == LP.Character then return end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__index
    setreadonly(mt, false)
    mt.__index = newcclosure(function(self, k)
        if k == "Kick" and self == LP then return function() end end
        return old(self, k)
    end)
    setreadonly(mt, true)
end)

pcall(function() if LP.Kick then LP.Kick = function() end end end)

pcall(function()
    if getgc then
        for _, obj in ipairs(getgc(true)) do
            if type(obj) == "table" then
                pcall(function()
                    if rawget(obj,"Kick") then rawset(obj,"Kick",function() end) end
                    if rawget(obj,"Ban") then rawset(obj,"Ban",function() end) end
                end)
            end
        end
    end
end)

pcall(function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if n:find("kick") or n:find("ban") or n:find("punish") or n:find("flag")
            or n:find("detect") or n:find("cheat") or n:find("report")
            or n:find("watchdog") or n:find("ac_") or n:find("moderat")
            or n:find("suspect") or n:find("exploit") then
                pcall(function() hookfunction(v.FireServer, function() end) end)
                v:SetAttribute("SAE_Blocked", true)
            end
        end
    end
end)

pcall(function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            local n = v.Name:lower()
            if n:find("anticheat") or n:find("anti_cheat") or n:find("detect")
            or n:find("watchdog") or n:find("ac_client") or n:find("guardian") then
                pcall(function() v.Disabled = true end)
            end
        end
    end
end)

pcall(function()
    local oldTP = TeleportService.TeleportToPlaceInstance
    getgenv().SAE_AllowHop = false
    hookfunction(oldTP, function(self, ...)
        if getgenv().SAE_AllowHop then
            getgenv().SAE_AllowHop = false
            return oldTP(self, ...)
        end
        return
    end)
end)

pcall(function()
    LP.Idled:Connect(function()
        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
    end)
end)

task.spawn(function() while task.wait(20) do
    pcall(function()
        local c = LP.Character
        if c then local h = c:FindFirstChildOfClass("Humanoid"); if h and h.Health>0 then h.Jump=true end end
    end)
end end)

task.spawn(function() while task.wait(15) do
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and not v:GetAttribute("SAE_Blocked") then
                local n = v.Name:lower()
                if n:find("kick") or n:find("ban") or n:find("detect") or n:find("exploit") then
                    pcall(function() hookfunction(v.FireServer, function() end) end)
                    v:SetAttribute("SAE_Blocked", true)
                end
            end
        end
    end)
end end)

print("[SAE] Anti ACTIVE")

-- ==================================================
-- KEY
-- ==================================================
local VALID_KEYS = {["1234"]=true,["joy"]=true,["kaw"]=true,["steal"]=true,["egg"]=true,["vip"]=true}

-- ==================================================
-- GUI
-- ==================================================
if getgenv then getgenv().SAE_GUI = nil end
pcall(function()
    local old = LP:WaitForChild("PlayerGui"):FindFirstChild("SAE_GUI")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SAE_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
if getgenv then getgenv().SAE_GUI = ScreenGui end

local Th = {
    bg=Color3.fromRGB(15,15,20), panel=Color3.fromRGB(22,22,30),
    accent=Color3.fromRGB(120,90,255), text=Color3.fromRGB(235,235,245),
    sub=Color3.fromRGB(150,150,165), success=Color3.fromRGB(80,220,120), danger=Color3.fromRGB(255,70,90),
}

local function new(class, props, parent)
    local o=Instance.new(class); for k,v in pairs(props) do o[k]=v end
    if parent then o.Parent=parent end; return o
end

-- KEY SCREEN
local KeyFrame = new("Frame", {Name="KeyFrame", Size=UDim2.fromOffset(420,280), Position=UDim2.new(0.5,-210,0.5,-140), BackgroundColor3=Th.bg, BorderSizePixel=0, ZIndex=1000}, ScreenGui)
new("UICorner", {CornerRadius=UDim.new(0,16)}, KeyFrame)
new("UIStroke", {Color=Th.accent, Thickness=2}, KeyFrame)
new("Frame", {Size=UDim2.new(1,0,0,6), BackgroundColor3=Th.accent, BorderSizePixel=0, ZIndex=1001}, KeyFrame)
new("TextLabel", {Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0,20), BackgroundTransparency=1, Text="STEAL AN EGG", TextColor3=Th.text, Font=Enum.Font.GothamBold, TextSize=22, ZIndex=1001}, KeyFrame)
new("TextLabel", {Size=UDim2.new(1,0,0,16), Position=UDim2.new(0,0,0,52), BackgroundTransparency=1, Text="Key System", TextColor3=Th.accent, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=1001}, KeyFrame)

local KeyBox = new("Frame", {Size=UDim2.new(1,-60,0,44), Position=UDim2.new(0,30,0,90), BackgroundColor3=Th.panel, BorderSizePixel=0, ZIndex=1001}, KeyFrame)
new("UICorner", {CornerRadius=UDim.new(0,10)}, KeyBox)
new("UIStroke", {Color=Th.accent, Thickness=1, Transparency=0.5}, KeyBox)
local KeyInput = new("TextBox", {Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text="", PlaceholderText="Masukkan key...", PlaceholderColor3=Th.sub, TextColor3=Th.text, Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, ClearTextOnFocus=false, ZIndex=1002}, KeyBox)
local SubmitBtn = new("TextButton", {Size=UDim2.new(1,-60,0,44), Position=UDim2.new(0,30,0,150), BackgroundColor3=Th.accent, Text="VERIFIKASI", TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=14, AutoButtonColor=true, BorderSizePixel=0, ZIndex=1001}, KeyFrame)
new("UICorner", {CornerRadius=UDim.new(0,10)}, SubmitBtn)
local StatusLabel = new("TextLabel", {Size=UDim2.new(1,0,0,16), Position=UDim2.new(0,0,0,205), BackgroundTransparency=1, Text="", TextColor3=Th.danger, Font=Enum.Font.Gotham, TextSize=12, ZIndex=1001}, KeyFrame)
new("TextLabel", {Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,232), BackgroundTransparency=1, Text="Hint: 1234", TextColor3=Th.sub, Font=Enum.Font.Gotham, TextSize=10, ZIndex=1001}, KeyFrame)

-- INJECTED
local InjectionInfo = new("Frame", {Size=UDim2.fromOffset(160,38), Position=UDim2.new(1,-170,1,-48), BackgroundColor3=Th.panel, BorderSizePixel=0, Visible=false, ZIndex=999}, ScreenGui)
new("UICorner", {CornerRadius=UDim.new(0,8)}, InjectionInfo)
new("UIStroke", {Color=Th.accent, Thickness=1, Transparency=0.5}, InjectionInfo)
new("TextLabel", {Size=UDim2.new(1,-10,0,18), Position=UDim2.new(0,5,0,2), BackgroundTransparency=1, Text="● INJECTED", TextColor3=Th.success, Font=Enum.Font.GothamBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=1000}, InjectionInfo)
new("TextLabel", {Size=UDim2.new(1,-10,0,12), Position=UDim2.new(0,5,0,20), BackgroundTransparency=1, Text=LP.Name, TextColor3=Th.text, Font=Enum.Font.Gotham, TextSize=9, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=1000}, InjectionInfo)

-- MAIN
local Main = new("Frame", {Name="Main", Size=UDim2.fromOffset(700,500), Position=UDim2.new(0.5,-350,0.5,-250), BackgroundColor3=Th.bg, BorderSizePixel=0, ClipsDescendants=true, Visible=false}, ScreenGui)
new("UICorner", {CornerRadius=UDim.new(0,14)}, Main)
new("UIStroke", {Color=Th.accent, Thickness=2, Transparency=0.3}, Main)

local LogoFrame = new("Frame", {Name="Logo", Size=UDim2.fromOffset(150,44), Position=UDim2.new(0,20,0,20), BackgroundColor3=Th.accent, BorderSizePixel=0, ZIndex=999, Active=true, Visible=false}, ScreenGui)
new("UICorner", {CornerRadius=UDim.new(0,10)}, LogoFrame)
pcall(function() new("ImageLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Image="https://i.ibb.co/m53kTsX5/file.jpg", ScaleType=Enum.ScaleType.Fit, ZIndex=1}, LogoFrame) end)
new("TextLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="KAW STEAL AN EGG", TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=11, TextStrokeTransparency=0.5, ZIndex=2}, LogoFrame)

local Header = new("Frame", {Size=UDim2.new(1,0,0,50), BackgroundColor3=Th.panel, BorderSizePixel=0}, Main)
new("TextLabel", {Size=UDim2.new(1,-120,0,22), Position=UDim2.new(0,16,0,6), BackgroundTransparency=1, Text="  STEAL AN EGG", TextColor3=Th.text, Font=Enum.Font.GothamBold, TextSize=18, TextXAlignment=Enum.TextXAlignment.Left}, Header)
new("TextLabel", {Size=UDim2.new(1,-120,0,14), Position=UDim2.new(0,16,0,28), BackgroundTransparency=1, Text="  v10 | All Fitur | Anti ON", TextColor3=Th.sub, Font=Enum.Font.Gotham, TextSize=10, TextXAlignment=Enum.TextXAlignment.Left}, Header)
new("Frame", {Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,50), BackgroundColor3=Th.accent, BorderSizePixel=0, BackgroundTransparency=0.5}, Main)

local clsBtn = new("TextButton", {Size=UDim2.fromOffset(28,28), Position=UDim2.new(1,-36,0,11), BackgroundColor3=Th.danger, Text="x", TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=14, BorderSizePixel=0, AutoButtonColor=false}, Header)
new("UICorner", {CornerRadius=UDim.new(0,6)}, clsBtn)
clsBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy(); if getgenv then getgenv().SAE_GUI=nil end end)

local TabBar = new("Frame", {Size=UDim2.new(0,160,1,-50), Position=UDim2.new(0,0,0,50), BackgroundColor3=Th.bg, BorderSizePixel=0}, Main)
local Content = new("Frame", {Size=UDim2.new(1,-160,1,-50), Position=UDim2.new(0,160,0,50), BackgroundColor3=Th.bg, BorderSizePixel=0}, Main)

local function newTab(name)
    local btn = new("TextButton", {Size=UDim2.new(1,-12,0,34), BackgroundColor3=Th.bg, Text="  "..name, TextColor3=Th.text, Font=Enum.Font.GothamMedium, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, AutoButtonColor=false, BorderSizePixel=0}, TabBar)
    new("UICorner", {CornerRadius=UDim.new(0,8)}, btn)
    local page = new("ScrollingFrame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=4, ScrollBarImageColor3=Th.accent, CanvasSize=UDim2.new(0,0,0,0), Visible=false}, Content)
    return btn, page
end
new("UIListLayout", {Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center}, TabBar)

local tabs = {farm=newTab("Farm"), visual=newTab("Visual"), event=newTab("Event"), misc=newTab("Misc"), safety=newTab("Safety"), config=newTab("Config")}
local function showTab(name) for k,p in pairs(tabs) do p[1].BackgroundColor3=Th.bg; p[2].Visible=false end; tabs[name][1].BackgroundColor3=Th.accent; tabs[name][2].Visible=true end
for k,p in pairs(tabs) do p[1].MouseButton1Click:Connect(function() showTab(k) end) end

local function addToggle(page, text, default, cb, locked)
    local row = new("Frame", {Size=UDim2.new(1,-20,0,36), BackgroundTransparency=1}, page)
    new("TextLabel", {Size=UDim2.new(1,-60,1,0), BackgroundTransparency=1, Text=text, TextColor3=Th.text, Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left}, row)
    local sw = new("TextButton", {Size=UDim2.fromOffset(44,22), Position=UDim2.new(1,-44,0.5,-11), BackgroundColor3=default and Th.accent or Color3.fromRGB(50,50,60), Text="", AutoButtonColor=false, BorderSizePixel=0}, row)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, sw)
    local dot = new("Frame", {Size=UDim2.fromOffset(18,18), Position=default and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9), BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0}, sw)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, dot)
    local s=default
    sw.MouseButton1Click:Connect(function()
        if locked then return end
        s=not s
        TweenService:Create(sw,TweenInfo.new(0.15),{BackgroundColor3=s and Th.accent or Color3.fromRGB(50,50,60)}):Play()
        TweenService:Create(dot,TweenInfo.new(0.15),{Position=s and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}):Play()
        cb(s)
    end)
end

local function addButton(page, text, cb)
    local btn = new("TextButton", {Size=UDim2.new(1,-20,0,34), BackgroundColor3=Th.accent, Text=text, TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=true, BorderSizePixel=0}, page)
    new("UICorner", {CornerRadius=UDim.new(0,8)}, btn)
    btn.MouseButton1Click:Connect(cb)
end

local function addDropdown(page, text, options, default, cb)
    local row = new("Frame", {Size=UDim2.new(1,-20,0,34), BackgroundTransparency=1}, page)
    new("TextLabel", {Size=UDim2.new(1,-140,1,0), BackgroundTransparency=1, Text=text, TextColor3=Th.text, Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left}, row)
    local cur=default; local idx=1; for i,o in ipairs(options) do if o==default then idx=i end end
    local btn = new("TextButton", {Size=UDim2.fromOffset(130,26), Position=UDim2.new(1,-130,0.5,-13), BackgroundColor3=Color3.fromRGB(40,40,50), Text=cur, TextColor3=Th.text, Font=Enum.Font.Gotham, TextSize=11, AutoButtonColor=false, BorderSizePixel=0}, row)
    new("UICorner", {CornerRadius=UDim.new(0,6)}, btn)
    btn.MouseButton1Click:Connect(function() idx=idx+1; if idx>#options then idx=1 end; cur=options[idx]; btn.Text=cur; cb(cur) end)
end

local function addSlider(page, text, min, max, default, cb)
    local row = new("Frame", {Size=UDim2.new(1,-20,0,50), BackgroundTransparency=1}, page)
    new("TextLabel", {Size=UDim2.new(1,0,0,18), BackgroundTransparency=1, Text=text..": "..default, TextColor3=Th.text, Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left}, row)
    local bg = new("Frame", {Size=UDim2.new(1,0,0,8), Position=UDim2.new(0,0,0,30), BackgroundColor3=Color3.fromRGB(50,50,60), BorderSizePixel=0}, row)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, bg)
    local fill = new("Frame", {Size=UDim2.new((default-min)/(max-min),0,1,0), BackgroundColor3=Th.accent, BorderSizePixel=0}, bg)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, fill)
    local knob = new("Frame", {Size=UDim2.fromOffset(14,14), Position=UDim2.new((default-min)/(max-min),-7,0.5,-7), BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0}, bg)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, knob)
    local drag=false
    local function upd(x)
        local p=math.clamp((x-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1)
        fill.Size=UDim2.new(p,0,1,0); knob.Position=UDim2.new(p,-7,0.5,-7)
        local v=math.floor(min+(max-min)*p)
        row:FindFirstChildOfClass("TextLabel").Text=text..": "..v
        cb(v)
    end
    bg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; upd(i.Position.X) end end)
    UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position.X) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
end

SubmitBtn.MouseButton1Click:Connect(function()
    if VALID_KEYS[KeyInput.Text] then
        StatusLabel.Text = "Key valid! Loading..."
        StatusLabel.TextColor3 = Th.success
        task.wait(0.6)
        KeyFrame.Visible = false
        Main.Visible = true
        LogoFrame.Visible = true
        InjectionInfo.Visible = true
    else
        StatusLabel.Text = "Key salah! Coba: 1234"
        StatusLabel.TextColor3 = Th.danger
        KeyInput.Text = ""
    end
end)

-- STATE
local State = {
    AutoSteal=false, MultiTarget=false, AutoTransport=false, SilentSteal=false, FilterRarity="All", FilterWeight=0,
    AutoHatch=false, AutoFusion=false, AutoSell=false, AutoBuyTrails=false, AutoUpgrade=false,
    AutoHuntDrones=false, AutoCollectSamples=false, AutoVaultParts=false,
    ESP=false, ESPTracer=false, ESPDistance=false, ESPName=false, ESPRarity=false, ESPBox=false,
    SpawnPredict=false, AlertSound=false, DivineRadar=false, BiomeTracker=false, MergingAlert=false, StatsHUD=false,
    GodMode=false, AntiTrap=false, Fly=false, Noclip=false,
    WalkSpeed=60, JumpPower=120, AutoHop=false, HopMaxPlayers=3,
}

-- FARM
addToggle(tabs.farm[2], "Auto Steal Semua Telur", false, function(v) State.AutoSteal=v end)
addDropdown(tabs.farm[2], "Filter Rarity", {"All","Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine"}, "All", function(v) State.FilterRarity=v end)
addSlider(tabs.farm[2], "Min Weight (kg)", 0, 100000000, 0, function(v) State.FilterWeight=v end)
addToggle(tabs.farm[2], "Multi-Target Prioritas", false, function(v) State.MultiTarget=v end)
addToggle(tabs.farm[2], "Auto Transport ke Base", false, function(v) State.AutoTransport=v end)
addToggle(tabs.farm[2], "Silent Steal", false, function(v) State.SilentSteal=v end)

-- VISUAL
addToggle(tabs.visual[2], "Egg ESP (Box)", false, function(v) State.ESPBox=v; State.ESP=v end)
addToggle(tabs.visual[2], "Egg ESP (Name)", false, function(v) State.ESPName=v; State.ESP=v end)
addToggle(tabs.visual[2], "Egg ESP (Rarity Color)", false, function(v) State.ESPRarity=v; State.ESP=v end)
addToggle(tabs.visual[2], "Tracer", false, function(v) State.ESPTracer=v end)
addToggle(tabs.visual[2], "Distance ESP", false, function(v) State.ESPDistance=v end)
addToggle(tabs.visual[2], "Spawn Prediction", false, function(v) State.SpawnPredict=v end)
addToggle(tabs.visual[2], "Alert Sound Mythic+", false, function(v) State.AlertSound=v end)
addToggle(tabs.visual[2], "Divine Radar", false, function(v) State.DivineRadar=v end)
addToggle(tabs.visual[2], "Biome Tracker", false, function(v) State.BiomeTracker=v end)
addToggle(tabs.visual[2], "Biome Merging Alert", false, function(v) State.MergingAlert=v end)
addToggle(tabs.visual[2], "Stats HUD", false, function(v) State.StatsHUD=v end)

-- EVENT
addToggle(tabs.event[2], "Auto Hunt Drones (Dr.Scramble)", false, function(v) State.AutoHuntDrones=v end)
addToggle(tabs.event[2], "Auto Collect Samples", false, function(v) State.AutoCollectSamples=v end)
addToggle(tabs.event[2], "Auto Collect Vault Parts (Exp.13)", false, function(v) State.AutoVaultParts=v end)
addToggle(tabs.event[2], "Auto Hatch", false, function(v) State.AutoHatch=v end)
addToggle(tabs.event[2], "Auto Fusion (Shrine)", false, function(v) State.AutoFusion=v end)
addToggle(tabs.event[2], "Auto Sell Pet Low", false, function(v) State.AutoSell=v end)

-- MISC
addToggle(tabs.misc[2], "Auto Buy Trails", false, function(v) State.AutoBuyTrails=v end)
addToggle(tabs.misc[2], "Auto Upgrade Pen/Treadmill", false, function(v) State.AutoUpgrade=v end)
addToggle(tabs.misc[2], "Godmode", false, function(v) State.GodMode=v end)
addToggle(tabs.misc[2], "Anti Trap", false, function(v) State.AntiTrap=v end)
addToggle(tabs.misc[2], "Fly + Noclip", false, function(v) State.Fly=v; State.Noclip=v end)
addSlider(tabs.misc[2], "WalkSpeed", 16, 300, 60, function(v) State.WalkSpeed=v; local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=v end end)
addSlider(tabs.misc[2], "JumpPower", 50, 400, 120, function(v) State.JumpPower=v; local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid"); if h then h.UseJumpPower=true; h.JumpPower=v end end)

-- SAFETY
addToggle(tabs.safety[2], "Anti Kick [LOCKED]", true, function() end, true)
addToggle(tabs.safety[2], "Anti Ban [LOCKED]", true, function() end, true)
addToggle(tabs.safety[2], "Anti AFK [LOCKED]", true, function() end, true)
addToggle(tabs.safety[2], "Anti Detect [LOCKED]", true, function() end, true)
addToggle(tabs.safety[2], "Bypass [LOCKED]", true, function() end, true)
addToggle(tabs.safety[2], "Auto Server Hop", false, function(v) State.AutoHop=v end)
addSlider(tabs.safety[2], "Max Player Server", 1, 30, 3, function(v) State.HopMaxPlayers=v end)
addButton(tabs.safety[2], "Cari Server Sepi (PENCET)", function()
    local req=(syn and syn.request) or (http and http.request) or http_request or request
    if not req then return end
    pcall(function()
        local res=req({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
        local data=HttpService:JSONDecode(res.Body)
        for _,srv in ipairs(data.data) do
            if srv.playing<=State.HopMaxPlayers and srv.id~=game.JobId then
                getgenv().SAE_AllowHop = true
                TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LP)
                return
            end
        end
    end)
end)

-- CONFIG
addButton(tabs.config[2], "Save Config", function() pcall(function() if writefile then writefile("SAE_Config.json", HttpService:JSONEncode(State)) end end) end)
addButton(tabs.config[2], "Load Config", function() pcall(function() if readfile and isfile and isfile("SAE_Config.json") then local d=HttpService:JSONDecode(readfile("SAE_Config.json")); for k,v in pairs(d) do State[k]=v end end end) end)

showTab("farm")

-- FUNCTIONS
local RARITY = {
    Common={color=Color3.fromRGB(255,255,255),tier=1}, Uncommon={color=Color3.fromRGB(80,200,120),tier=2},
    Rare={color=Color3.fromRGB(60,140,255),tier=3}, Epic={color=Color3.fromRGB(170,80,255),tier=4},
    Legendary={color=Color3.fromRGB(255,180,40),tier=5}, Mythic={color=Color3.fromRGB(255,80,120),tier=6},
    Cosmic={color=Color3.fromRGB(100,220,255),tier=7}, Secret={color=Color3.fromRGB(255,0,180),tier=8},
    Eternal={color=Color3.fromRGB(255,240,140),tier=9}, Divine={color=Color3.fromRGB(255,255,255),tier=10},
}

local function isEgg(v) return (v:IsA("BasePart") or v:IsA("Model")) and v.Name:lower():find("egg") end
local function getAllEggs() local out={}; for _,v in ipairs(Workspace:GetDescendants()) do if isEgg(v) then table.insert(out,v) end end; return out end
local function getRarity(e) local r=e:GetAttribute("Rarity"); return RARITY[r] and r or "Common" end
local function rarityColor(e) return (RARITY[getRarity(e)] or RARITY.Common).color end
local function rarityTier(e) return (RARITY[getRarity(e)] or RARITY.Common).tier end
local function getWeight(e) return e:GetAttribute("Weight") or 0 end

local flyBV, flyBG
local function startFly()
    if flyBV then return end
    local char=LP.Character; if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    flyBV=Instance.new("BodyVelocity"); flyBV.MaxForce=Vector3.new(1e5,1e5,1e5); flyBV.Velocity=Vector3.zero; flyBV.Parent=hrp
    flyBG=Instance.new("BodyGyro"); flyBG.MaxTorque=Vector3.new(1e5,1e5,1e5); flyBG.P=1e4; flyBG.Parent=hrp
end
local function stopFly()
    if flyBV then flyBV:Destroy(); flyBV=nil end
    if flyBG then flyBG:Destroy(); flyBG=nil end
end

-- STEAL LOOP
task.spawn(function() while task.wait(0.35) do
    if State.AutoSteal then
        startFly()
        local eggs=getAllEggs()
        if #eggs>0 then
            local target=eggs[1]
            for _,e in ipairs(eggs) do
                local ok = (State.FilterRarity=="All" or getRarity(e)==State.FilterRarity) and getWeight(e)>=State.FilterWeight
                if ok and rarityTier(e)>rarityTier(target) then target=e end
            end
            local char=LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame=target.CFrame*CFrame.new(0,2,0)
            end
            for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name:lower():find("steal") then pcall(function() v:FireServer(target) end) end            end
        end
    elseif not State.Fly then
        if flyBV then stopFly() end
    end
end end)

-- ESP
local espFolder=new("Folder",{Name="ESP"},ScreenGui)
task.spawn(function() while task.wait(0.6) do
    for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end
    if State.ESP or State.ESPBox or State.ESPName or State.ESPRarity then
        for _,e in ipairs(getAllEggs()) do
            if State.ESPBox then
                local box=Instance.new("BoxHandleAdornment",espFolder)
                box.Adornee=e; box.Size=(e:IsA("BasePart") and e.Size or Vector3.new(2,2,2))+Vector3.new(0.5,0.5,0.5)
                box.Transparency=0.5; box.Color3=rarityColor(e); box.AlwaysOnTop=true
            end
            if State.ESPName or State.ESPRarity then
                local target=e:IsA("BasePart") and e or e.PrimaryPart
                if target then
                    local bill=Instance.new("BillboardGui",espFolder)
                    bill.Size=UDim2.fromOffset(180,40); bill.StudsOffsetWorldSpace=Vector3.new(0,3,0)
                    bill.AlwaysOnTop=true; bill.Adornee=target
                    local lbl=Instance.new("TextLabel",bill)
                    lbl.Size=UDim2.fromScale(1,1); lbl.BackgroundTransparency=1
                    lbl.TextColor3=rarityColor(e); lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12
                    lbl.TextStrokeTransparency=0.5
                    local txt=""
                    if State.ESPName then txt=txt..e.Name end
                    if State.ESPRarity then txt=txt.."\n"..getRarity(e) end
                    lbl.Text=txt
                end
            end
        end
    end
end end)

-- FLY MANUAL
task.spawn(function() while task.wait(0.1) do
    if State.Fly then
        local char=LP.Character
        if char and not flyBV then
            local hrp=char:FindFirstChild("HumanoidRootPart")
            if hrp then startFly() end
        end
        if flyBV then
            local char=LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dir=Vector3.zero
                local cam=Workspace.CurrentCamera
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir+=cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir-=cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir-=cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir+=cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.yAxis end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir-=Vector3.yAxis end
                flyBV.Velocity=dir.Magnitude>0 and dir.Unit*State.WalkSpeed or Vector3.zero
                flyBG.CFrame=cam.CFrame
            end
        end
    elseif flyBV then
        stopFly()
    end
end end)

-- NOCLIP
task.spawn(function() while task.wait(0.15) do
    if State.Noclip then
        local char=LP.Character
        if char then for _,v in ipairs(char:GetChildren()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide=false end end end
    end
end end)

-- ANTI TRAP
task.spawn(function() while task.wait(2) do
    if State.AntiTrap then
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("trap") or v.Name:lower():find("spike")) then v.CanTouch=false; v.CanCollide=false end
        end
    end
end end)

-- GODMODE
task.spawn(function() while task.wait(1) do
    if State.GodMode then local char=LP.Character; if char then local h=char:FindFirstChildOfClass("Humanoid"); if h then h.MaxHealth=math.huge; h.Health=math.huge end end end
end end)

-- AUTO HATCH
task.spawn(function() while task.wait(2) do
    if State.AutoHatch then
        for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("hatch") then pcall(function() v:FireServer() end) end
        end
    end
end end)

-- AUTO FUSION
task.spawn(function() while task.wait(5) do
    if State.AutoFusion then
        for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("fusion") then pcall(function() v:FireServer() end) end
        end
    end
end end)

-- AUTO SELL
task.spawn(function() while task.wait(10) do
    if State.AutoSell then
        for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("sell") then pcall(function() v:FireServer() end) end
        end
    end
end end)

-- AUTO BUY TRAILS
task.spawn(function() while task.wait(8) do
    if State.AutoBuyTrails then
        for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("trail") then pcall(function() v:FireServer() end) end
        end
    end
end end)

-- AUTO UPGRADE
task.spawn(function() while task.wait(10) do
    if State.AutoUpgrade then
        for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") and (v.Name:lower():find("upgrade") or v.Name:lower():find("treadmill")) then
                pcall(function() v:FireServer() end)
            end
        end
    end
end end)

-- AUTO HUNT DRONES
task.spawn(function() while task.wait(2) do
    if State.AutoHuntDrones then
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and (v.Name:lower():find("drone") or v.Name:lower():find("scramble")) then
                local hrp = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                if hrp and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,2,0)
                    for _,r in ipairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") and r.Name:lower():find("drone") then pcall(function() r:FireServer(v) end) end
                    end
                end
            end
        end
    end
end end)

-- AUTO SAMPLES
task.spawn(function() while task.wait(2) do
    if State.AutoCollectSamples then
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("sample") or v.Name:lower():find("part")) then
                if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0,2,0)
                end
            end
        end
    end
end end)

-- AUTO VAULT
task.spawn(function() while task.wait(3) do
    if State.AutoVaultParts then
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("vault") or v.Name:lower():find("component")) then
                if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0,2,0)
                end
            end
        end
    end
end end)

-- AUTO TRANSPORT
task.spawn(function() while task.wait(0.7) do
    if State.AutoSteal and State.AutoTransport then
        local char=LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local carrying=false
            for _,v in ipairs(char:GetChildren()) do if v.Name:lower():find("egg") then carrying=true end end
            if carrying then
                for _,v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:lower():find("base") or v.Name:lower():find("deposit")) then
                        char.HumanoidRootPart.CFrame=v.CFrame*CFrame.new(0,3,0)
                        break
                    end
                end
            end
        end
    end
end end)

-- SPAWN PREDICT
local lastCount=0
task.spawn(function() while task.wait(3) do
    if State.SpawnPredict then
        local c=#getAllEggs()
        if c>lastCount then
            StarterGui:SetCore("SendNotification",{Title="Egg Spawn",Text=tostring(c).." eggs on map",Duration=3})
        end
        lastCount=c
    end
end end)

-- DIVINE RADAR
task.spawn(function() while task.wait(5) do
    if State.DivineRadar then
        for _,e in ipairs(getAllEggs()) do
            if rarityTier(e)>=9 then StarterGui:SetCore("SendNotification",{Title="DIVINE",Text=e.Name,Duration=5}) break end
        end
    end
end end)

StarterGui:SetCore("SendNotification",{Title="Steal An Egg v10",Text="Key: 1234",Duration=4})
print("[SAE] v10 All Fitur loaded.")local VALID_KEYS = {["1234"]=true,["joy"]=true,["kaw"]=true,["steal"]=true,["egg"]=true,["vip"]=true}

local Th = {
    bg=Color3.fromRGB(15,15,20), panel=Color3.fromRGB(22,22,30),
    accent=Color3.fromRGB(120,90,255), text=Color3.fromRGB(235,235,245),
    sub=Color3.fromRGB(150,150,165), success=Color3.fromRGB(80,220,120), danger=Color3.fromRGB(255,70,90),
}

local function new(class, props, parent)
    local o=Instance.new(class); for k,v in pairs(props) do o[k]=v end
    if parent then o.Parent=parent end; return o
end

-- ==================================================
-- GUI SETUP
-- ==================================================
if getgenv then getgenv().SAE_GUI = nil end
pcall(function()
    local old = LP:WaitForChild("PlayerGui"):FindFirstChild("SAE_GUI")
    if old then old:Destroy() end
end)

local ScreenGui = new("ScreenGui", {Name="SAE_GUI", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=999, IgnoreGuiInset=true}, nil)
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
if getgenv then getgenv().SAE_GUI = ScreenGui end

-- ==================================================
-- KEY SCREEN
-- ==================================================
local KeyFrame = new("Frame", {Name="KeyFrame", Size=UDim2.fromOffset(420,280), Position=UDim2.new(0.5,-210,0.5,-140), BackgroundColor3=Th.bg, BorderSizePixel=0, ZIndex=1000}, ScreenGui)
new("UICorner", {CornerRadius=UDim.new(0,16)}, KeyFrame)
new("UIStroke", {Color=Th.accent, Thickness=2}, KeyFrame)
new("Frame", {Size=UDim2.new(1,0,0,6), BackgroundColor3=Th.accent, BorderSizePixel=0, ZIndex=1001}, KeyFrame)
new("TextLabel", {Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0,20), BackgroundTransparency=1, Text="STEAL AN EGG", TextColor3=Th.text, Font=Enum.Font.GothamBold, TextSize=22, ZIndex=1001}, KeyFrame)
new("TextLabel", {Size=UDim2.new(1,0,0,16), Position=UDim2.new(0,0,0,52), BackgroundTransparency=1, Text="Key System -- Simple", TextColor3=Th.accent, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=1001}, KeyFrame)

local KeyBox = new("Frame", {Size=UDim2.new(1,-60,0,44), Position=UDim2.new(0,30,0,90), BackgroundColor3=Th.panel, BorderSizePixel=0, ZIndex=1001}, KeyFrame)
new("UICorner", {CornerRadius=UDim.new(0,10)}, KeyBox)
new("UIStroke", {Color=Th.accent, Thickness=1, Transparency=0.5}, KeyBox)

local KeyInput = new("TextBox", {Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text="", PlaceholderText="Masukkan key...", PlaceholderColor3=Th.sub, TextColor3=Th.text, Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, ClearTextOnFocus=false, ZIndex=1002}, KeyBox)
local SubmitBtn = new("TextButton", {Size=UDim2.new(1,-60,0,44), Position=UDim2.new(0,30,0,150), BackgroundColor3=Th.accent, Text="VERIFIKASI", TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=14, AutoButtonColor=true, BorderSizePixel=0, ZIndex=1001}, KeyFrame)
new("UICorner", {CornerRadius=UDim.new(0,10)}, SubmitBtn)
local StatusLabel = new("TextLabel", {Size=UDim2.new(1,0,0,16), Position=UDim2.new(0,0,0,205), BackgroundTransparency=1, Text="", TextColor3=Th.danger, Font=Enum.Font.Gotham, TextSize=12, ZIndex=1001}, KeyFrame)
new("TextLabel", {Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,232), BackgroundTransparency=1, Text="Hint: 1234 / joy / kaw / steal / egg / vip", TextColor3=Th.sub, Font=Enum.Font.Gotham, TextSize=10, ZIndex=1001}, KeyFrame)

-- INJECTION INFO
local InjectionInfo = new("Frame", {Size=UDim2.fromOffset(180,50), Position=UDim2.new(1,-190,1,-60), BackgroundColor3=Th.panel, BorderSizePixel=0, Visible=false, ZIndex=999}, ScreenGui)
new("UICorner", {CornerRadius=UDim.new(0,8)}, InjectionInfo)
new("UIStroke", {Color=Th.accent, Thickness=1, Transparency=0.5}, InjectionInfo)
new("TextLabel", {Size=UDim2.new(1,-10,0,18), Position=UDim2.new(0,5,0,4), BackgroundTransparency=1, Text="● INJECTED", TextColor3=Th.success, Font=Enum.Font.GothamBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=1000}, InjectionInfo)
new("TextLabel", {Size=UDim2.new(1,-10,0,12), Position=UDim2.new(0,5,0,20), BackgroundTransparency=1, Text="User: "..LP.Name, TextColor3=Th.text, Font=Enum.Font.Gotham, TextSize=9, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=1000}, InjectionInfo)
new("TextLabel", {Size=UDim2.new(1,-10,0,12), Position=UDim2.new(0,5,0,32), BackgroundTransparency=1, Text="Key: VERIFIED", TextColor3=Th.accent, Font=Enum.Font.Gotham, TextSize=9, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=1000}, InjectionInfo)

-- ==================================================
-- MAIN GUI
-- ==================================================
local Main = new("Frame", {Name="Main", Size=UDim2.fromOffset(680,480), Position=UDim2.new(0.5,-340,0.5,-240), BackgroundColor3=Th.bg, BorderSizePixel=0, ClipsDescendants=true, Visible=false}, ScreenGui)
new("UICorner", {CornerRadius=UDim.new(0,14)}, Main)
new("UIStroke", {Color=Th.accent, Thickness=2, Transparency=0.3}, Main)

local LogoFrame = new("Frame", {Name="Logo", Size=UDim2.fromOffset(150,44), Position=UDim2.new(0,20,0,20), BackgroundColor3=Th.accent, BorderSizePixel=0, ZIndex=999, Active=true, Visible=false}, ScreenGui)
new("UICorner", {CornerRadius=UDim.new(0,10)}, LogoFrame)
pcall(function() new("ImageLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Image="https://i.ibb.co/m53kTsX5/file.jpg", ScaleType=Enum.ScaleType.Fit, ZIndex=1}, LogoFrame) end)
new("TextLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="KAW STEAL AN EGG", TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=11, TextStrokeTransparency=0.5, ZIndex=2}, LogoFrame)

local Header = new("Frame", {Size=UDim2.new(1,0,0,50), BackgroundColor3=Th.panel, BorderSizePixel=0}, Main)
new("TextLabel", {Size=UDim2.new(1,-120,0,22), Position=UDim2.new(0,16,0,6), BackgroundTransparency=1, Text="  STEAL AN EGG", TextColor3=Th.text, Font=Enum.Font.GothamBold, TextSize=18, TextXAlignment=Enum.TextXAlignment.Left}, Header)
new("TextLabel", {Size=UDim2.new(1,-120,0,14), Position=UDim2.new(0,16,0,28), BackgroundTransparency=1, Text="  v7 Final | Anti ON", TextColor3=Th.sub, Font=Enum.Font.Gotham, TextSize=10, TextXAlignment=Enum.TextXAlignment.Left}, Header)
new("Frame", {Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,50), BackgroundColor3=Th.accent, BorderSizePixel=0, BackgroundTransparency=0.5}, Main)

local clsBtn = new("TextButton", {Size=UDim2.fromOffset(28,28), Position=UDim2.new(1,-36,0,11), BackgroundColor3=Th.danger, Text="x", TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=14, BorderSizePixel=0, AutoButtonColor=false}, Header)
new("UICorner", {CornerRadius=UDim.new(0,6)}, clsBtn)
clsBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy(); if getgenv then getgenv().SAE_GUI=nil end end)

local TabBar = new("Frame", {Size=UDim2.new(0,160,1,-50), Position=UDim2.new(0,0,0,50), BackgroundColor3=Th.bg, BorderSizePixel=0}, Main)
local Content = new("Frame", {Size=UDim2.new(1,-160,1,-50), Position=UDim2.new(0,160,0,50), BackgroundColor3=Th.bg, BorderSizePixel=0}, Main)

local function newTab(name)
    local btn = new("TextButton", {Size=UDim2.new(1,-12,0,34), BackgroundColor3=Th.bg, Text="  "..name, TextColor3=Th.text, Font=Enum.Font.GothamMedium, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, AutoButtonColor=false, BorderSizePixel=0}, TabBar)
    new("UICorner", {CornerRadius=UDim.new(0,8)}, btn)
    local page = new("ScrollingFrame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=4, ScrollBarImageColor3=Th.accent, CanvasSize=UDim2.new(0,0,0,0), Visible=false}, Content)
    return btn, page
end
new("UIListLayout", {Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center}, TabBar)

local tabs = {farm=newTab("Farm"), visual=newTab("Visual"), event=newTab("Event"), misc=newTab("Misc"), safety=newTab("Safety"), config=newTab("Config")}
local function showTab(name) for k,p in pairs(tabs) do p[1].BackgroundColor3=Th.bg; p[2].Visible=false end; tabs[name][1].BackgroundColor3=Th.accent; tabs[name][2].Visible=true end
for k,p in pairs(tabs) do p[1].MouseButton1Click:Connect(function() showTab(k) end) end

local function addToggle(page, text, default, cb, locked)
    local row = new("Frame", {Size=UDim2.new(1,-20,0,36), BackgroundTransparency=1}, page)
    new("TextLabel", {Size=UDim2.new(1,-60,1,0), BackgroundTransparency=1, Text=text, TextColor3=Th.text, Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left}, row)
    local sw = new("TextButton", {Size=UDim2.fromOffset(44,22), Position=UDim2.new(1,-44,0.5,-11), BackgroundColor3=default and Th.accent or Color3.fromRGB(50,50,60), Text="", AutoButtonColor=false, BorderSizePixel=0}, row)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, sw)
    local dot = new("Frame", {Size=UDim2.fromOffset(18,18), Position=default and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9), BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0}, sw)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, dot)
    local s=default
    sw.MouseButton1Click:Connect(function()
        if locked then return end
        s=not s
        TweenService:Create(sw,TweenInfo.new(0.15),{BackgroundColor3=s and Th.accent or Color3.fromRGB(50,50,60)}):Play()
        TweenService:Create(dot,TweenInfo.new(0.15),{Position=s and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}):Play()
        cb(s)
    end)
end

local function addButton(page, text, cb)
    local btn = new("TextButton", {Size=UDim2.new(1,-20,0,34), BackgroundColor3=Th.accent, Text=text, TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=true, BorderSizePixel=0}, page)
    new("UICorner", {CornerRadius=UDim.new(0,8)}, btn)
    btn.MouseButton1Click:Connect(cb)
end

-- ==================================================
-- KEY LOGIC
-- ==================================================
SubmitBtn.MouseButton1Click:Connect(function()
    if VALID_KEYS[KeyInput.Text] then
        StatusLabel.Text = "Key valid! Loading..."
        StatusLabel.TextColor3 = Th.success
        task.wait(0.6)
        KeyFrame.Visible = false
        Main.Visible = true
        LogoFrame.Visible = true
        InjectionInfo.Visible = true
        StarterGui:SetCore("SendNotification", {Title="Key Verified", Text="Welcome, "..LP.Name, Duration=4})
    else
        StatusLabel.Text = "Key salah! Coba: 1234"
        StatusLabel.TextColor3 = Th.danger
        KeyInput.Text = ""
    end
end)

-- ==================================================
-- STATE
-- ==================================================
local State = {
    AutoSteal=false, MultiTarget=false, AutoTransport=false, SilentSteal=false, FilterWeight=0,
    AutoHatch=false, AutoFusion=false, AutoSell=false,
    AutoHuntDrones=false, AutoCollectSamples=false, AutoVaultParts=false,
    ESP=false, ESPTracer=false, ESPDistance=false,
    SpawnPredict=false, AlertSound=false, DivineRadar=false,
    GodMode=false, AntiTrap=false, Fly=false, Noclip=false,
    WalkSpeed=60, JumpPower=120, AutoHop=false, HopMaxPlayers=3,
}

-- FARM
addToggle(tabs.farm[2], "Auto Steal Semua Telur", false, function(v) State.AutoSteal=v end)
addToggle(tabs.farm[2], "Multi-Target Prioritas", false, function(v) State.MultiTarget=v end)
addToggle(tabs.farm[2], "Auto Transport ke Base", false, function(v) State.AutoTransport=v end)
addToggle(tabs.farm[2], "Silent Steal", false, function(v) State.SilentSteal=v end)

-- VISUAL
addToggle(tabs.visual[2], "Egg ESP (Box + Name + Rarity)", false, function(v) State.ESP=v end)
addToggle(tabs.visual[2], "Tracer", false, function(v) State.ESPTracer=v end)
addToggle(tabs.visual[2], "Distance ESP", false, function(v) State.ESPDistance=v end)
addToggle(tabs.visual[2], "Spawn Prediction", false, function(v) State.SpawnPredict=v end)
addToggle(tabs.visual[2], "Alert Sound Mythic+", false, function(v) State.AlertSound=v end)
addToggle(tabs.visual[2], "Divine Radar", false, function(v) State.DivineRadar=v end)

-- EVENT
addToggle(tabs.event[2], "Auto Hunt Drones", false, function(v) State.AutoHuntDrones=v end)
addToggle(tabs.event[2], "Auto Collect Samples", false, function(v) State.AutoCollectSamples=v end)
addToggle(tabs.event[2], "Auto Collect Vault Parts", false, function(v) State.AutoVaultParts=v end)
addToggle(tabs.event[2], "Auto Hatch", false, function(v) State.AutoHatch=v end)
addToggle(tabs.event[2], "Auto Fusion", false, function(v) State.AutoFusion=v end)

-- MISC
addToggle(tabs.misc[2], "Auto Sell Pet Low", false, function(v) State.AutoSell=v end)
addToggle(tabs.misc[2], "Godmode", false, function(v) State.GodMode=v end)
addToggle(tabs.misc[2], "Anti Trap", false, function(v) State.AntiTrap=v end)
addToggle(tabs.misc[2], "Fly + Noclip (Manual)", false, function(v) State.Fly=v; State.Noclip=v end)

-- SAFETY
addToggle(tabs.safety[2], "Anti Kick [LOCKED]", true, function() end, true)
addToggle(tabs.safety[2], "Anti Ban [LOCKED]", true, function() end, true)
addToggle(tabs.safety[2], "Anti AFK [LOCKED]", true, function() end, true)
addToggle(tabs.safety[2], "Anti Detect [LOCKED]", true, function() end, true)
addToggle(tabs.safety[2], "Bypass [LOCKED]", true, function() end, true)
addToggle(tabs.safety[2], "Auto Server Hop", false, function(v) State.AutoHop=v end)
addButton(tabs.safety[2], "Cari Server Sepi (PENCET)", function()
    local req=(syn and syn.request) or (http and http.request) or http_request or request
    if not req then return end
    pcall(function()
        local res=req({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
        local data=HttpService:JSONDecode(res.Body)
        for _,srv in ipairs(data.data) do
            if srv.playing<=State.HopMaxPlayers and srv.id~=game.JobId then
                getgenv().SAE_AllowHop = true
                TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LP)
                return
            end
        end
    end)
end)

-- CONFIG
addButton(tabs.config[2], "Save Config", function() pcall(function() if writefile then writefile("SAE_Config.json", HttpService:JSONEncode(State)) end end) end)
addButton(tabs.config[2], "Load Config", function() pcall(function() if readfile and isfile and isfile("SAE_Config.json") then local d=HttpService:JSONDecode(readfile("SAE_Config.json")); for k,v in pairs(d) do State[k]=v end end end) end)

showTab("farm")

-- ==================================================
-- ANTI LAYER
-- ==================================================
pcall(function()
    local mt = getrawmetatable(game); local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if m == "Kick" or m == "kick" or m == "KickSelf" then return end
        if m == "Destroy" and self == LP then return end
        if m == "TakeDamage" and self == LP.Character then return end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

pcall(function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if n:find("kick") or n:find("ban") or n:find("detect") or n:find("cheat") then
                pcall(function() hookfunction(v.FireServer, function() end) end)
            end
        end
    end
end)

pcall(function()
    LP.Idled:Connect(function()
        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
    end)
end)

pcall(function()
    local oldTP = TeleportService.TeleportToPlaceInstance
    getgenv().SAE_AllowHop = false
    hookfunction(oldTP, function(self, ...)
        if getgenv().SAE_AllowHop then
            getgenv().SAE_AllowHop = false
            return oldTP(self, ...)
        end
        return
    end)
end)

-- ==================================================
-- FUNCTIONS
-- ==================================================
local function isEgg(v) return (v:IsA("BasePart") or v:IsA("Model")) and v.Name:lower():find("egg") end
local function getAllEggs() local out={}; for _,v in ipairs(Workspace:GetDescendants()) do if isEgg(v) then table.insert(out,v) end end; return out end
local function getRarity(e) local r=e:GetAttribute("Rarity"); return RARITY[r] and r or "Common" end
local function rarityColor(e) return (RARITY[getRarity(e)] or RARITY.Common).color end
local function rarityTier(e) return (RARITY[getRarity(e)] or RARITY.Common).tier end

local flyBV, flyBG
local function startFly()
    if flyBV then return end
    local char=LP.Character; if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    flyBV=Instance.new("BodyVelocity"); flyBV.MaxForce=Vector3.new(1e5,1e5,1e5); flyBV.Velocity=Vector3.zero; flyBV.Parent=hrp
    flyBG=Instance.new("BodyGyro"); flyBG.MaxTorque=Vector3.new(1e5,1e5,1e5); flyBG.P=1e4; flyBG.Parent=hrp
end
local function stopFly()
    if flyBV then flyBV:Destroy(); flyBV=nil end
    if flyBG then flyBG:Destroy(); flyBG=nil end
end

-- STEAL LOOP
task.spawn(function() while task.wait(0.35) do
    if State.AutoSteal then
        startFly()
        local eggs=getAllEggs()
        if #eggs>0 then
            local target=eggs[1]
            for _,e in ipairs(eggs) do if rarityTier(e)>rarityTier(target) then target=e end end
            local char=LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame=target.CFrame*CFrame.new(0,2,0)
            end
            for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name:lower():find("steal") then pcall(function() v:FireServer(target) end) end
            end
        end
    elseif not State.Fly then
        if flyBV then stopFly() end
    end
end end)

-- ESP
local espFolder=new("Folder",{Name="ESP"},ScreenGui)
task.spawn(function() while task.wait(0.6) do
    if State.ESP then
        for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end
        for _,e in ipairs(getAllEggs()) do
            local box=Instance.new("BoxHandleAdornment",espFolder)
            box.Adornee=e; box.Size=(e:IsA("BasePart") and e.Size or Vector3.new(2,2,2))+Vector3.new(0.5,0.5,0.5)
            box.Transparency=0.5; box.Color3=rarityColor(e); box.AlwaysOnTop=true
        end
    end
end end)

-- Anti Trap
task.spawn(function() while task.wait(2) do
    if State.AntiTrap then
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("trap") or v.Name:lower():find("spike")) then v.CanTouch=false; v.CanCollide=false end
        end
    end
end end)

-- Godmode
task.spawn(function() while task.wait(1) do
    if State.GodMode then local char=LP.Character; if char then local h=char:FindFirstChildOfClass("Humanoid"); if h then h.MaxHealth=math.huge; h.Health=math.huge end end end
end end)

StarterGui:SetCore("SendNotification",{Title="Steal An Egg v7",Text="Key: 1234",Duration=4})
print("[SAE] v7 Final loaded. Key: 1234")
