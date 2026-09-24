--[[
    STEAL AN EGG v14 -- MOBILE WORK
    Referensi: Ajjan Hub, Rendang Hub, Goha Hub
    Pattern: GUI-first, touch-event, pcall-safe, no key trigger delay
    KEY: 1234
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- ============ ANTILEAK: HAPUS GUI LAMA ============
if getgenv and getgenv().SAE_GUI then
    pcall(function() getgenv().SAE_GUI:Destroy() end)
end
pcall(function()
    local old = LP:WaitForChild("PlayerGui"):FindFirstChild("SAE_GUI")
    if old then old:Destroy() end
end)

-- ============ SCREENGUI (PAKAI PLAYERGUI UNTUK MOBILE) ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SAE_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 2147483647
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
getgenv().SAE_GUI = ScreenGui

local Th = {
    bg=Color3.fromRGB(18,18,22), panel=Color3.fromRGB(28,28,36),
    accent=Color3.fromRGB(120,90,255), text=Color3.fromRGB(235,235,245),
    sub=Color3.fromRGB(150,150,165), success=Color3.fromRGB(80,220,120),
    danger=Color3.fromRGB(255,70,90), gold=Color3.fromRGB(255,200,80),
}

local function new(c, p, parent)
    local o = Instance.new(c)
    for k,v in pairs(p) do o[k]=v end
    if parent then o.Parent = parent end
    return o
end

-- ============ HELPER: MULTI-EVENT BUTTON ============
local function bindClick(btn, fn)
    btn.MouseButton1Click:Connect(fn)
    pcall(function() btn.Activated:Connect(fn) end)
    pcall(function() btn.TouchTap:Connect(fn) end)
    pcall(function()
        btn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch
            or i.UserInputType == Enum.UserInputType.MouseButton1 then
                fn()
            end
        end)
    end)
end

-- ============ KEY SCREEN ============
local KeyFrame = new("Frame", {
    Name="KeyFrame",
    Size=UDim2.new(0.9, 0, 0, 320),
    Position=UDim2.new(0.05, 0, 0.5, -160),
    BackgroundColor3=Th.bg, BorderSizePixel=0, ZIndex=1000,
}, ScreenGui)
new("UICorner", {CornerRadius=UDim.new(0,16)}, KeyFrame)
new("UIStroke", {Color=Th.accent, Thickness=2}, KeyFrame)
new("Frame", {Size=UDim2.new(1,0,0,8), BackgroundColor3=Th.accent, BorderSizePixel=0, ZIndex=1001}, KeyFrame)

new("TextLabel", {
    Size=UDim2.new(1,0,0,32), Position=UDim2.new(0,0,0,28),
    BackgroundTransparency=1, Text="STEAL AN EGG",
    TextColor3=Th.text, Font=Enum.Font.GothamBold, TextSize=24, ZIndex=1001,
}, KeyFrame)

new("TextLabel", {
    Size=UDim2.new(1,0,0,16), Position=UDim2.new(0,0,0,62),
    BackgroundTransparency=1, Text="Key: 1234",
    TextColor3=Th.accent, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=1001,
}, KeyFrame)

local KeyBox = new("Frame", {
    Size=UDim2.new(1,-60,0,56), Position=UDim2.new(0,30,0,95),
    BackgroundColor3=Th.panel, BorderSizePixel=0, ZIndex=1001, Active=false,
}, KeyFrame)
new("UICorner", {CornerRadius=UDim.new(0,10)}, KeyBox)
new("UIStroke", {Color=Th.accent, Thickness=1, Transparency=0.5}, KeyBox)

local KeyInput = new("TextBox", {
    Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,10,0,0),
    BackgroundTransparency=1, Text="",
    PlaceholderText="Ketik key...",
    PlaceholderColor3=Th.sub, TextColor3=Th.text,
    Font=Enum.Font.Gotham, TextSize=18,
    TextXAlignment=Enum.TextXAlignment.Left,
    ClearTextOnFocus=false, ZIndex=1010,
}, KeyBox)

local SubmitBtn = new("TextButton", {
    Size=UDim2.new(1,-60,0,64), Position=UDim2.new(0,30,0,165),
    BackgroundColor3=Th.accent, Text="VERIFIKASI",
    TextColor3=Color3.fromRGB(255,255,255),
    Font=Enum.Font.GothamBold, TextSize=20,
    AutoButtonColor=true, BorderSizePixel=0, ZIndex=1010, Active=true,
}, KeyFrame)
new("UICorner", {CornerRadius=UDim.new(0,12)}, SubmitBtn)

local StatusLabel = new("TextLabel", {
    Size=UDim2.new(1,0,0,18), Position=UDim2.new(0,0,0,240),
    BackgroundTransparency=1, Text="",
    TextColor3=Th.danger, Font=Enum.Font.Gotham, TextSize=13, ZIndex=1001,
}, KeyFrame)

-- ============ MAIN GUI ============
local Main = new("Frame", {
    Name="Main",
    Size=UDim2.new(0.95, 0, 0.85, 0),
    Position=UDim2.new(0.025, 0, 0.075, 0),
    BackgroundColor3=Th.bg, BorderSizePixel=0,
    ClipsDescendants=true, Visible=false,
}, ScreenGui)
new("UICorner", {CornerRadius=UDim.new(0,14)}, Main)
new("UIStroke", {Color=Th.accent, Thickness=2, Transparency=0.2}, Main)

-- Header
local Header = new("Frame", {Size=UDim2.new(1,0,0,50), BackgroundColor3=Th.panel, BorderSizePixel=0}, Main)
new("TextLabel", {
    Size=UDim2.new(1,-60,0,22), Position=UDim2.new(0,16,0,6),
    BackgroundTransparency=1, Text="  STEAL AN EGG",
    TextColor3=Th.text, Font=Enum.Font.GothamBold, TextSize=17,
    TextXAlignment=Enum.TextXAlignment.Left,
}, Header)
new("TextLabel", {
    Size=UDim2.new(1,-60,0,14), Position=UDim2.new(0,16,0,28),
    BackgroundTransparency=1, Text="  Mobile Work | Anti ON",
    TextColor3=Th.sub, Font=Enum.Font.Gotham, TextSize=10,
    TextXAlignment=Enum.TextXAlignment.Left,
}, Header)
new("Frame", {Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,50), BackgroundColor3=Th.accent, BorderSizePixel=0, BackgroundTransparency=0.5}, Main)

-- Close button
local closeBtn = new("TextButton", {
    Size=UDim2.fromOffset(40,40), Position=UDim2.new(1,-50,0,5),
    BackgroundColor3=Th.danger, Text="X",
    TextColor3=Color3.fromRGB(255,255,255),
    Font=Enum.Font.GothamBold, TextSize=18,
    AutoButtonColor=false, BorderSizePixel=0, ZIndex=1010,
}, Header)
new("UICorner", {CornerRadius=UDim.new(0,8)}, closeBtn)
bindClick(closeBtn, function()
    ScreenGui:Destroy()
    getgenv().SAE_GUI = nil
end)

-- Tab bar (horizontal mobile)
local TabBar = new("Frame", {Size=UDim2.new(1,0,0,50), Position=UDim2.new(0,0,0,50), BackgroundColor3=Th.bg, BorderSizePixel=0}, Main)
new("UIListLayout", {Padding=UDim.new(0.005,0), FillDirection=Enum.FillDirection.Horizontal, SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center}, TabBar)

local Content = new("Frame", {Size=UDim2.new(1,0,1,-100), Position=UDim2.new(0,0,0,100), BackgroundColor3=Th.bg, BorderSizePixel=0}, Main)

-- Tab names
local tabNames = {"Farm","Visual","Event","Misc","Safety","Config"}
local tabs = {}
for i, name in ipairs(tabNames) do
    local btn = new("TextButton", {
        Size=UDim2.new(1/6,-4,1,-10), Position=UDim2.new(0,0,0,5),
        BackgroundColor3=Th.bg, Text=name,
        TextColor3=Th.text, Font=Enum.Font.GothamBold, TextSize=11,
        AutoButtonColor=false, BorderSizePixel=0,
    }, TabBar)
    new("UICorner", {CornerRadius=UDim.new(0,8)}, btn)
    local page = new("ScrollingFrame", {
        Size=UDim2.new(1,-10,1,-10), Position=UDim2.new(0,5,0,5),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=6, ScrollBarImageColor3=Th.accent,
        CanvasSize=UDim2.new(0,0,0,0), Visible=false,
    }, Content)
    tabs[string.lower(name)] = {btn=btn, page=page, name=name}
end

local function showTab(key)
    for k, t in pairs(tabs) do
        t.btn.BackgroundColor3 = Th.bg
        t.page.Visible = false
    end
    tabs[key].btn.BackgroundColor3 = Th.accent
    tabs[key].page.Visible = true
end

for k, t in pairs(tabs) do
    bindClick(t.btn, function() showTab(k) end)
end

-- ============ COMPONENTS ============
local function addToggle(page, txt, default, cb)
    local row = new("Frame", {Size=UDim2.new(1,-10,0,52), BackgroundTransparency=1}, page)
    new("TextLabel", {
        Size=UDim2.new(1,-80,1,0), BackgroundTransparency=1,
        Text=txt, TextColor3=Th.text, Font=Enum.Font.Gotham, TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, row)
    local sw = new("TextButton", {
        Size=UDim2.fromOffset(60,32), Position=UDim2.new(1,-60,0.5,-16),
        BackgroundColor3=default and Th.accent or Color3.fromRGB(50,50,60),
        Text="", AutoButtonColor=false, BorderSizePixel=0, ZIndex=5,
    }, row)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, sw)
    local dot = new("Frame", {
        Size=UDim2.fromOffset(26,26),
        Position=default and UDim2.new(1,-28,0.5,-13) or UDim2.new(0,3,0.5,-13),
        BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0,
    }, sw)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, dot)
    local s = default
    bindClick(sw, function()
        s = not s
        TweenService:Create(sw,TweenInfo.new(0.15),{BackgroundColor3=s and Th.accent or Color3.fromRGB(50,50,60)}):Play()
        TweenService:Create(dot,TweenInfo.new(0.15),{Position=s and UDim2.new(1,-28,0.5,-13) or UDim2.new(0,3,0.5,-13)}):Play()
        if cb then cb(s) end
    end)
end

local function addButton(page, txt, cb)
    local b = new("TextButton", {
        Size=UDim2.new(1,-10,0,50), BackgroundColor3=Th.accent,
        Text=txt, TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=14,
        AutoButtonColor=true, BorderSizePixel=0,
    }, page)
    new("UICorner", {CornerRadius=UDim.new(0,10)}, b)
    bindClick(b, cb)
end

local function addSlider(page, txt, min, max, default, cb)
    local row = new("Frame", {Size=UDim2.new(1,-10,0,60), BackgroundTransparency=1}, page)
    local lbl = new("TextLabel", {
        Size=UDim2.new(1,0,0,22), BackgroundTransparency=1,
        Text=txt..": "..default, TextColor3=Th.text,
        Font=Enum.Font.Gotham, TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, row)
    local bg = new("Frame", {
        Size=UDim2.new(1,0,0,12), Position=UDim2.new(0,0,0,35),
        BackgroundColor3=Color3.fromRGB(50,50,60), BorderSizePixel=0,
    }, row)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, bg)
    local fill = new("Frame", {
        Size=UDim2.new((default-min)/(max-min),0,1,0),
        BackgroundColor3=Th.accent, BorderSizePixel=0,
    }, bg)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, fill)
    local knob = new("Frame", {
        Size=UDim2.fromOffset(20,20),
        Position=UDim2.new((default-min)/(max-min),-10,0.5,-10),
        BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0,
    }, bg)
    new("UICorner", {CornerRadius=UDim.new(1,0)}, knob)
    local drag = false
    local function upd(x)
        local p = math.clamp((x-bg.AbsolutePosition.X)/bg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(p,0,1,0)
        knob.Position = UDim2.new(p,-10,0.5,-10)
        local v = math.floor(min + (max-min)*p)
        lbl.Text = txt..": "..v
        if cb then cb(v) end
    end
    bg.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag = true; upd(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            upd(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

-- ============ FITUR ============
local State = {
    AutoSteal=false, AutoTransport=false, SilentSteal=false, MultiTarget=false,
    ESPBox=false, ESPName=false, ESPRarity=false, SpawnPredict=false,
    AutoHatch=false, AutoFusion=false, AutoSell=false,
    AutoHuntDrones=false, AutoSamples=false, AutoVault=false,
    GodMode=false, AntiTrap=false, Fly=false, Noclip=false,
    WalkSpeed=60, JumpPower=120, AutoHop=false, HopMaxPlayers=3,
}

addToggle(tabs.farm.page, "Auto Steal", false, function(v) State.AutoSteal=v end)
addToggle(tabs.farm.page, "Auto Transport", false, function(v) State.AutoTransport=v end)
addToggle(tabs.farm.page, "Silent Steal", false, function(v) State.SilentSteal=v end)
addToggle(tabs.farm.page, "Multi-Target", false, function(v) State.MultiTarget=v end)

addToggle(tabs.visual.page, "ESP Box", false, function(v) State.ESPBox=v end)
addToggle(tabs.visual.page, "ESP Name", false, function(v) State.ESPName=v end)
addToggle(tabs.visual.page, "ESP Rarity", false, function(v) State.ESPRarity=v end)
addToggle(tabs.visual.page, "Spawn Prediction", false, function(v) State.SpawnPredict=v end)

addToggle(tabs.event.page, "Auto Hunt Drones", false, function(v) State.AutoHuntDrones=v end)
addToggle(tabs.event.page, "Auto Samples", false, function(v) State.AutoSamples=v end)
addToggle(tabs.event.page, "Auto Vault Parts", false, function(v) State.AutoVault=v end)
addToggle(tabs.event.page, "Auto Hatch", false, function(v) State.AutoHatch=v end)
addToggle(tabs.event.page, "Auto Fusion", false, function(v) State.AutoFusion=v end)

addToggle(tabs.misc.page, "Godmode", false, function(v) State.GodMode=v end)
addToggle(tabs.misc.page, "Anti Trap", false, function(v) State.AntiTrap=v end)
addToggle(tabs.misc.page, "Fly", false, function(v) State.Fly=v end)
addToggle(tabs.misc.page, "Noclip", false, function(v) State.Noclip=v end)
addSlider(tabs.misc.page, "WalkSpeed", 16, 300, 60, function(v)
    State.WalkSpeed=v
    local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed=v end
end)
addSlider(tabs.misc.page, "JumpPower", 50, 400, 120, function(v)
    State.JumpPower=v
    local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.UseJumpPower=true; h.JumpPower=v end
end)

addToggle(tabs.safety.page, "Auto Server Hop", false, function(v) State.AutoHop=v end)
addSlider(tabs.safety.page, "Max Player", 1, 30, 3, function(v) State.HopMaxPlayers=v end)
addButton(tabs.safety.page, "Cari Server Sepi (PENCET)", function()
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if not req then return end
    pcall(function()
        local res = req({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
        local data = HttpService:JSONDecode(res.Body)
        for _, srv in ipairs(data.data) do
            if srv.playing <= State.HopMaxPlayers and srv.id ~= game.JobId then
                getgenv().SAE_AllowHop = true
                TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LP)
                return
            end
        end
    end)
end)

addButton(tabs.config.page, "Save Config", function()
    pcall(function()
        if writefile then writefile("SAE_Config.json", HttpService:JSONEncode(State)) end
    end)
end)
addButton(tabs.config.page, "Load Config", function()
    pcall(function()
        if readfile and isfile and isfile("SAE_Config.json") then
            local d = HttpService:JSONDecode(readfile("SAE_Config.json"))
            for k,v in pairs(d) do State[k]=v end
        end
    end)
end)

showTab("farm")

-- ============ KEY LOGIC ============
local VALID_KEYS = {
    ["1234"]=true, ["123"]=true, ["1"]=true,
    ["joy"]=true, ["kaw"]=true, ["steal"]=true,
    ["egg"]=true, ["vip"]=true, ["admin"]=true,
}

local verified = false
local function doVerify()
    if verified then return end
    local input = tostring(KeyInput.Text or ""):gsub("%s+","")
    if VALID_KEYS[input] then
        verified = true
        StatusLabel.Text = "Key valid! Loading..."
        StatusLabel.TextColor3 = Th.success
        task.wait(0.3)
        KeyFrame.Visible = false
        Main.Visible = true
        pcall(function()
            StarterGui:SetCore("SendNotification", {Title="Verified", Text="Welcome!", Duration=3})
        end)
    else
        StatusLabel.Text = "Key salah. Coba: 1234"
        StatusLabel.TextColor3 = Th.danger
        KeyInput.Text = ""
    end
end

bindClick(SubmitBtn, doVerify)
pcall(function()
    KeyInput.FocusLost:Connect(function(e)
        if e then doVerify() end
    end)
end)

-- ============ ANTI LAYER ============
pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if m == "Kick" or m == "kick" or m == "KickSelf" then return end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

pcall(function()
    LP.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
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

-- ============ FUNCTIONS ============
local RARITY = {
    Common={color=Color3.fromRGB(255,255,255)}, Uncommon={color=Color3.fromRGB(80,200,120)},
    Rare={color=Color3.fromRGB(60,140,255)}, Epic={color=Color3.fromRGB(170,80,255)},
    Legendary={color=Color3.fromRGB(255,180,40)}, Mythic={color=Color3.fromRGB(255,80,120)},
    Cosmic={color=Color3.fromRGB(100,220,255)}, Secret={color=Color3.fromRGB(255,0,180)},
    Eternal={color=Color3.fromRGB(255,240,140)}, Divine={color=Color3.fromRGB(255,255,255)},
}

local function isEgg(v)
    return (v:IsA("BasePart") or v:IsA("Model")) and v.Name:lower():find("egg")
end
local function getRarity(e)
    local r = e:GetAttribute("Rarity")
    return RARITY[r] and r or "Common"
end
local function rarityColor(e)
    return (RARITY[getRarity(e)] or RARITY.Common).color
end

-- FLY
local flyBV, flyBG
local function startFly()
    if flyBV then return end
    local char = LP.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
    flyBG.P = 1e4
    flyBG.Parent = hrp
end
local function stopFly()
    if flyBV then flyBV:Destroy(); flyBV=nil end
    if flyBG then flyBG:Destroy(); flyBG=nil end
end

-- STEAL LOOP
task.spawn(function() while task.wait(0.4) do
    if State.AutoSteal then
        startFly()
        for _,v in ipairs(Workspace:GetDescendants()) do
            if isEgg(v) then
                local target = v:IsA("BasePart") and v or v.PrimaryPart
                if target and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0,2,0)
                    for _,r in ipairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") and r.Name:lower():find("steal") then
                            pcall(function() r:FireServer(v) end)
                        end
                    end
                end
                break
            end
        end
    elseif not State.Fly then
        if flyBV then stopFly() end
    end
end end)

-- FLY MANUAL
task.spawn(function() while task.wait(0.1) do
    if State.Fly then
        local char = LP.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and not flyBV then startFly() end
            if flyBV then
                local dir = Vector3.zero
                local cam = Workspace.CurrentCamera
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
                flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * State.WalkSpeed or Vector3.zero
                flyBG.CFrame = cam.CFrame
            end
        end
    elseif flyBV then stopFly() end
end end)

-- ESP
local espFolder = new("Folder", {Name="ESP"}, ScreenGui)
task.spawn(function() while task.wait(0.6) do
    for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end
    if State.ESPBox or State.ESPName or State.ESPRarity then
        for _,v in ipairs(Workspace:GetDescendants()) do
            if isEgg(v) then
                local target = v:IsA("BasePart") and v or v.PrimaryPart
                if target then
                    if State.ESPBox then
                        local box = Instance.new("BoxHandleAdornment", espFolder)
                        box.Adornee = target
                        box.Size = target.Size + Vector3.new(0.5,0.5,0.5)
                        box.Transparency = 0.5
                        box.Color3 = rarityColor(v)
                        box.AlwaysOnTop = true
                    end
                    if State.ESPName or State.ESPRarity then
                        local bill = Instance.new("BillboardGui", espFolder)
                        bill.Size = UDim2.fromOffset(180,50)
                        bill.StudsOffsetWorldSpace = Vector3.new(0,3,0)
                        bill.AlwaysOnTop = true
                        bill.Adornee = target
                        local lbl = Instance.new("TextLabel", bill)
                        lbl.Size = UDim2.fromScale(1,1)
                        lbl.BackgroundTransparency = 1
                        lbl.TextColor3 = rarityColor(v)
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 12
                        lbl.TextStrokeTransparency = 0.5
                        local txt = ""
                        if State.ESPName then txt = txt .. v.Name end
                        if State.ESPRarity then txt = txt .. "\n" .. getRarity(v) end
                        lbl.Text = txt
                    end
                end
            end
        end
    end
end end)

-- ANTI TRAP
task.spawn(function() while task.wait(2) do
    if State.AntiTrap then
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("trap") or v.Name:lower():find("spike")) then
                v.CanTouch = false
                v.CanCollide = false
            end
        end
    end
end end)

-- GODMODE
task.spawn(function() while task.wait(1) do
    if State.GodMode then
        local char = LP.Character
        if char then
            local h = char:FindFirstChildOfClass("Humanoid")
            if h then h.MaxHealth = math.huge; h.Health = math.huge end
        end
    end
end end)

-- NOCLIP
task.spawn(function() while task.wait(0.15) do
    if State.Noclip then
        local char = LP.Character
        if char then
            for _,v in ipairs(char:GetChildren()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end
end end)

-- AUTO HATCH
task.spawn(function() while task.wait(2) do
    if State.AutoHatch then
        for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("hatch") then
                pcall(function() v:FireServer() end)
            end
        end
    end
end end)

-- AUTO FUSION
task.spawn(function() while task.wait(5) do
    if State.AutoFusion then
        for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("fusion") then
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
                end
            end
        end
    end
end end)

-- AUTO VAULT
task.spawn(function() while task.wait(3) do
    if State.AutoVault then
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
task.spawn(function() while task.wait(0.8) do
    if State.AutoSteal and State.AutoTransport then
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local carrying = false
            for _,v in ipairs(char:GetChildren()) do
                if v.Name:lower():find("egg") then carrying = true end
            end
            if carrying then
                for _,v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:lower():find("base") or v.Name:lower():find("deposit")) then
                        char.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0,3,0)
                        break
                    end
                end
            end
        end
    end
end end)

print("[SAE] Mobile Work v14 loaded. Key: 1234")
pcall(function()
    StarterGui:SetCore("SendNotification", {Title="SAE", Text="Loaded. Key: 1234", Duration=4})
end)
