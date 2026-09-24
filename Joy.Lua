-- file: Joy_Hub_v17.lua
-- purpose: Steal an Egg — bypass posisi, fly-integrated steal, anti-detect
-- platform: Delta Mobile
-- key: joy

local P=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RF=game:GetService("ReplicatedFirst")
local WS=game:GetService("Workspace")
local UIS=game:GetService("UserInputService")
local RSvc=game:GetService("RunService")
local TS=game:GetService("TweenService")
local HS=game:GetService("HttpService")
local SG=game:GetService("StarterGui")
local VU=game:GetService("VirtualUser")
local TPS=game:GetService("TeleportService")
local LP=P.LocalPlayer

-- ============================================================
-- 1. STEALTH LAYER
-- ============================================================
local function stealthInit()
    local ok,mt=pcall(getrawmetatable,game)
    if not ok or not mt then return end
    local oldNC=mt.__namecall
    local oldIDX=mt.__index
    local blockSet={Kick=true,kick=true,KickSelf=true,Ban=true,BanSelf=true}
    setreadonly(mt,false)
    mt.__namecall=newcclosure(function(self,...)
        local m=getnamecallmethod()
        if blockSet[m] then
            if checkcaller and checkcaller() then
                return oldNC(self,...)
            end
            local cs=getcallingscript and getcallingscript()
            if cs and cs~=LP.PlayerScripts and cs~=LP.PlayerGui then
                return
            end
            return
        end
        return oldNC(self,...)
    end)
    mt.__index=newcclosure(function(self,k)
        if k=="Kick" or k=="kick" or k=="Ban" then
            if checkcaller and checkcaller() then
                return oldIDX(self,k)
            end
            return function() end
        end
        return oldIDX(self,k)
    end)
    setreadonly(mt,true)
end
pcall(stealthInit)

pcall(function()
    LP.Idled:Connect(function()
        pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
    end)
end)

-- ============================================================
-- 2. CLEANUP + THEME
-- ============================================================
if getgenv and getgenv().JOY_GUI then pcall(function() getgenv().JOY_GUI:Destroy() end) end
local oldG=LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("JOY_GUI")
if oldG then oldG:Destroy() end

local T={
    bg=Color3.fromRGB(15,15,20),panel=Color3.fromRGB(24,24,32),
    accent=Color3.fromRGB(138,92,255),accent2=Color3.fromRGB(80,200,255),
    text=Color3.fromRGB(240,240,250),sub=Color3.fromRGB(140,140,160),
    ok=Color3.fromRGB(80,220,140),bad=Color3.fromRGB(255,80,100),
    warn=Color3.fromRGB(255,180,60),
}

local function mk(c,p,par)
    local o=Instance.new(c)
    for k,v in pairs(p) do o[k]=v end
    if par then o.Parent=par end
    return o
end

local GUI=mk("ScreenGui",{Name="JOY_GUI",ResetOnSpawn=false,DisplayOrder=2147483647,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},LP:WaitForChild("PlayerGui"))
getgenv().JOY_GUI=GUI

-- ============================================================
-- 3. KEY SCREEN
-- ============================================================
local KeyF=mk("Frame",{Size=UDim2.fromOffset(300,230),Position=UDim2.new(0.5,-150,0.5,-115),BackgroundColor3=T.bg,BorderSizePixel=0,ZIndex=1000},GUI)
mk("UICorner",{CornerRadius=UDim.new(0,16)},KeyF)
mk("UIStroke",{Color=T.accent,Thickness=2},KeyF)

mk("ImageLabel",{Size=UDim2.fromOffset(64,64),Position=UDim2.new(0.5,-32,0,16),BackgroundTransparency=1,Image="rbxassetid://6031075931",ZIndex=1001},KeyF)
mk("TextLabel",{Size=UDim2.new(1,0,0,24),Position=UDim2.new(0,0,0,88),BackgroundTransparency=1,Text="JOY HUB v17",TextColor3=T.text,Font=Enum.Font.GothamBold,TextSize=20,ZIndex=1001},KeyF)
mk("TextLabel",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,114),BackgroundTransparency=1,Text="Steal an Egg | Delta Mobile",TextColor3=T.sub,Font=Enum.Font.Gotham,TextSize=11,ZIndex=1001},KeyF)

local KB=mk("Frame",{Size=UDim2.new(1,-40,0,40),Position=UDim2.new(0,20,0,142),BackgroundColor3=T.panel,BorderSizePixel=0,ZIndex=1001},KeyF)
mk("UICorner",{CornerRadius=UDim.new(0,10)},KB)
mk("UIStroke",{Color=T.accent,Thickness=1,Transparency=0.5},KB)
local KI=mk("TextBox",{Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text="",PlaceholderText="Key...",PlaceholderColor3=T.sub,TextColor3=T.text,Font=Enum.Font.Gotham,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,ZIndex=1010},KB)

local SB=mk("TextButton",{Size=UDim2.new(1,-40,0,36),Position=UDim2.new(0,20,0,188),BackgroundColor3=T.accent,Text="VERIFY",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=14,AutoButtonColor=true,BorderSizePixel=0,ZIndex=1010},KeyF)
mk("UICorner",{CornerRadius=UDim.new(0,10)},SB)

-- ============================================================
-- 4. MAIN GUI (resizable)
-- ============================================================
local Main=mk("Frame",{Name="Main",Size=UDim2.fromOffset(360,400),Position=UDim2.new(0.5,-180,0.5,-200),BackgroundColor3=T.bg,BorderSizePixel=0,ClipsDescendants=true,Visible=false},GUI)
mk("UICorner",{CornerRadius=UDim.new(0,14)},Main)
mk("UIStroke",{Color=T.accent,Thickness=2,Transparency=0.2},Main)

local H=mk("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=T.panel,BorderSizePixel=0},Main)
mk("ImageLabel",{Size=UDim2.fromOffset(32,32),Position=UDim2.new(0,12,0,8),BackgroundTransparency=1,Image="rbxassetid://6031075931"},H)
mk("TextLabel",{Size=UDim2.new(1,-140,0,20),Position=UDim2.new(0,52,0,8),BackgroundTransparency=1,Text="JOY HUB v17",TextColor3=T.text,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left},H)
mk("TextLabel",{Size=UDim2.new(1,-140,0,14),Position=UDim2.new(0,52,0,26),BackgroundTransparency=1,Text="Steal an Egg | Mobile",TextColor3=T.sub,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},H)

local CloseB=mk("TextButton",{Size=UDim2.fromOffset(32,32),Position=UDim2.new(1,-40,0,8),BackgroundColor3=T.bad,Text="X",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=14,AutoButtonColor=false,BorderSizePixel=0,ZIndex=5},H)
mk("UICorner",{CornerRadius=UDim.new(0,8)},CloseB)

local ResizeH=mk("Frame",{Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-20,1,-20),BackgroundColor3=T.accent,BackgroundTransparency=0.3,ZIndex=6},Main)
mk("UICorner",{CornerRadius=UDim.new(0,6)},ResizeH)

local TabBar=mk("Frame",{Size=UDim2.new(1,0,0,36),Position=UDim2.new(0,0,0,48),BackgroundColor3=T.bg,BorderSizePixel=0},Main)
mk("UIListLayout",{Padding=UDim.new(0,4),FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center},TabBar)

local Content=mk("Frame",{Size=UDim2.new(1,0,1,-84),Position=UDim2.new(0,0,0,84),BackgroundColor3=T.bg,BorderSizePixel=0},Main)

local tabNames={"Farm","Visual","Event","Misc","Safety","Cfg"}
local tabs={}
for i,n in ipairs(tabNames) do
    local b=mk("TextButton",{Size=UDim2.fromOffset(52,26),BackgroundColor3=T.bg,Text=n,TextColor3=T.text,Font=Enum.Font.GothamBold,TextSize=10,AutoButtonColor=false,BorderSizePixel=0},TabBar)
    mk("UICorner",{CornerRadius=UDim.new(0,6)},b)
    local pg=mk("ScrollingFrame",{Size=UDim2.new(1,-8,1,-8),Position=UDim2.new(0,4,0,4),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,ScrollBarImageColor3=T.accent,CanvasSize=UDim2.new(0,0,0,0),Visible=false},Content)
    mk("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},pg)
    tabs[string.lower(n)]={btn=b,page=pg}
end

local function showTab(k)
    for a,t in pairs(tabs) do t.btn.BackgroundColor3=T.bg; t.page.Visible=false end
    tabs[k].btn.BackgroundColor3=T.accent
    tabs[k].page.Visible=true
end

local function bind(b,fn)
    b.MouseButton1Click:Connect(fn)
    pcall(function() b.TouchTap:Connect(fn) end)
end

for k,t in pairs(tabs) do bind(t.btn,function() showTab(k) end) end

-- Drag
local drag=false; local dS,dP
H.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        drag=true; dS=i.Position; dP=Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if drag then
        local d=i.Position-dS
        Main.Position=UDim2.new(dP.X.Scale,dP.X.Offset+d.X,dP.Y.Scale,dP.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
end)

-- Resize
local rsz=false; local rS,rZ
ResizeH.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        rsz=true; rS=i.Position; rZ=Main.Size
    end
end)
UIS.InputChanged:Connect(function(i)
    if rsz and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-rS
        Main.Size=UDim2.fromOffset(math.clamp(rZ.X.Offset+d.X,260,700),math.clamp(rZ.Y.Offset+d.Y,240,720))
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then rsz=false end
end)

-- ============================================================
-- 5. COMPONENTS
-- ============================================================
local function addToggle(pg,txt,def,cb)
    local r=mk("Frame",{Size=UDim2.new(1,-8,0,32),BackgroundTransparency=1},pg)
    mk("TextLabel",{Size=UDim2.new(1,-56,1,0),BackgroundTransparency=1,Text=txt,TextColor3=T.text,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left},r)
    local s=mk("TextButton",{Size=UDim2.fromOffset(44,22),Position=UDim2.new(1,-44,0.5,-11),BackgroundColor3=def and T.accent or Color3.fromRGB(45,45,55),Text="",AutoButtonColor=false,BorderSizePixel=0},r)
    mk("UICorner",{CornerRadius=UDim.new(1,0)},s)
    local d=mk("Frame",{Size=UDim2.fromOffset(18,18),Position=def and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},s)
    mk("UICorner",{CornerRadius=UDim.new(1,0)},d)
    local st=def
    bind(s,function()
        st=not st
        TS:Create(s,TweenInfo.new(0.15),{BackgroundColor3=st and T.accent or Color3.fromRGB(45,45,55)}):Play()
        TS:Create(d,TweenInfo.new(0.15),{Position=st and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}):Play()
        if cb then cb(st) end
    end)
end

local function addBtn(pg,txt,cb,color)
    local b=mk("TextButton",{Size=UDim2.new(1,-8,0,32),BackgroundColor3=color or T.accent,Text=txt,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=11,AutoButtonColor=true,BorderSizePixel=0},pg)
    mk("UICorner",{CornerRadius=UDim.new(0,8)},b)
    bind(b,cb)
end

local function addSlider(pg,txt,mn,mx,def,cb)
    local r=mk("Frame",{Size=UDim2.new(1,-8,0,40),BackgroundTransparency=1},pg)
    local l=mk("TextLabel",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text=txt..": "..def,TextColor3=T.text,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},r)
    local bg=mk("Frame",{Size=UDim2.new(1,0,0,8),Position=UDim2.new(0,0,0,24),BackgroundColor3=Color3.fromRGB(45,45,55),BorderSizePixel=0},r)
    mk("UICorner",{CornerRadius=UDim.new(1,0)},bg)
    local f=mk("Frame",{Size=UDim2.new((def-mn)/(mx-mn),0,1,0),BackgroundColor3=T.accent,BorderSizePixel=0},bg)
    mk("UICorner",{CornerRadius=UDim.new(1,0)},f)
    local k=mk("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.new((def-mn)/(mx-mn),-7,0.5,-7),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},bg)
    mk("UICorner",{CornerRadius=UDim.new(1,0)},k)
    local dr=false
    local function up(x)
        local p=math.clamp((x-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1)
        f.Size=UDim2.new(p,0,1,0); k.Position=UDim2.new(p,-7,0.5,-7)
        local v=math.floor(mn+(mx-mn)*p); l.Text=txt..": "..v
        if cb then cb(v) end
    end
    bg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true; up(i.Position.X) end end)
    UIS.InputChanged:Connect(function(i) if dr and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then up(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=false end end)
end

local function addLabel(pg,txt,color)
    local l=mk("TextLabel",{Size=UDim2.new(1,-8,0,18),BackgroundTransparency=1,Text=txt,TextColor3=color or T.sub,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},pg)
    return l
end

-- ============================================================
-- 6. STATE
-- ============================================================
local S={
    AutoSteal=false,AutoTransport=false,SilentSteal=false,
    SafeRoute=true,MaxDistance=800,
    ESPBox=false,ESPName=false,ESPRarity=false,
    AutoHatch=false,AutoFusion=false,
    AutoDrones=false,AutoSamples=false,AutoVault=false,AutoSell=false,
    GodMode=false,AntiTrap=false,Noclip=false,
    ManualFly=false,
    Walk=60,Jump=120,
    AutoHop=false,MaxP=3,
    Logs={},
}

-- ============================================================
-- 7. REMOTE RESOLVER (dynamic, multi-parameter)
-- ============================================================
local RemoteCache={steal={},hatch={},fusion={},sell={},pickup={},drones={},samples={},vault={}}

local function scanRemotes()
    for k in pairs(RemoteCache) do RemoteCache[k]={} end
    local containers={RS,RF,WS}
    local kws={
        steal={"steal","pickup","collect","grab","take"},
        hatch={"hatch","incubate","open"},
        fusion={"fusion","fuse","combine","merge"},
        sell={"sell","shop","trade"},
        pickup={"pickup","collect","grab"},
        drones={"drone","scramble","hunt"},
        samples={"sample","scramblepart","collectpart"},
        vault={"vault","component","part"},
    }
    for _,parent in ipairs(containers) do
        local ok,desc=pcall(function() return parent:GetDescendants() end)
        if ok then
            for _,v in ipairs(desc) do
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    local n=v.Name:lower()
                    for cat,words in pairs(kws) do
                        for _,w in ipairs(words) do
                            if n:find(w) then
                                table.insert(RemoteCache[cat],v)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    -- Fallback: kalau nama generic, cek ancestor name
    for _,parent in ipairs(containers) do
        local ok,desc=pcall(function() return parent:GetDescendants() end)
        if ok then
            for _,v in ipairs(desc) do
                if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and #RemoteCache.steal==0 then
                    local anc=v.Parent and v.Parent.Name:lower() or ""
                    if anc:find("egg") or anc:find("steal") or anc:find("collect") then
                        table.insert(RemoteCache.steal,v)
                    end
                end
            end
        end
    end
end
pcall(scanRemotes)

local function fireAll(cat, ...)
    local list=RemoteCache[cat] or {}
    local okCount=0
    for _,r in ipairs(list) do
        local ok=pcall(function()
            if r:IsA("RemoteFunction") then r:InvokeServer(...) else r:FireServer(...) end
        end)
        if ok then okCount=okCount+1 end
    end
    return okCount
end

-- ============================================================
-- 8. ZONE DETECTOR (Common / Guard Ayam / Netral)
-- ============================================================
local NetralZones={}
local function detectZones()
    NetralZones={}
    local kws={"common","guard","ayam","chicken","neutral","spawn","lobby","safe"}
    for _,v in ipairs(WS:GetDescendants()) do
        if v:IsA("BasePart") then
            local n=v.Name:lower()
            for _,k in ipairs(kws) do
                if n:find(k) then
                    table.insert(NetralZones,v)
                    break
                end
            end
        end
    end
end
pcall(detectZones)

local function getNearestZone(fromPos)
    local best,bestD=nil,math.huge
    for _,z in ipairs(NetralZones) do
        local d=(z.Position-fromPos).Magnitude
        if d<bestD then bestD=d; best=z end
    end
    return best,bestD
end

-- ============================================================
-- 9. POSITION VALIDATOR (anti-rubberband, max speed)
-- ============================================================
local PosState={lastPos=nil,lastTime=0,rubberCount=0,lockUntil=0}

local function checkRubberband()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local cur=LP.Character.HumanoidRootPart.Position
    local now=tick()
    if PosState.lastPos and (now-PosState.lastTime)<1.0 then
        local dist=(cur-PosState.lastPos).Magnitude
        if dist>50 and PosState.lastPos.Magnitude>0 then
            PosState.rubberCount=PosState.rubberCount+1
            if PosState.rubberCount>=2 then
                PosState.lockUntil=now+5
                PosState.rubberCount=0
            end
        else
            PosState.rubberCount=math.max(0,PosState.rubberCount-0.5)
        end
    end
    PosState.lastPos=cur
    PosState.lastTime=now
end

local function isLocked()
    return tick()<PosState.lockUntil
end

local function safeTeleport(targetCF, steps, stepTime)
    steps=steps or 3
    stepTime=stepTime or 0.18
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return false end
    local hrp=LP.Character.HumanoidRootPart
    local startCF=hrp.CFrame
    local from=startCF.Position
    local to=targetCF.Position
    -- via netral zone dulu
    local zone=select(1,getNearestZone(from))
    local waypoints={}
    if zone and (zone.Position-from).Magnitude>10 then
        table.insert(waypoints,CFrame.new(zone.Position+Vector3.new(0,3,0)))
    end
    for i=1,steps do
        local alpha=i/steps
        local p=from:Lerp(to,alpha)
        table.insert(waypoints,CFrame.new(p,to))
    end
    for _,wp in ipairs(waypoints) do
        pcall(function()
            TS:Create(hrp,TweenInfo.new(stepTime,Enum.EasingStyle.Linear),{CFrame=wp}):Play()
        end)
        task.wait(stepTime+0.02)
    end
    return true
end

-- ============================================================
-- 10. FLY (internal, dipakai Auto Steal)
-- ============================================================
local fBV,fBG
local function startFly()
    if fBV then return end
    local c=LP.Character; if not c then return end
    local h=c:FindFirstChild("HumanoidRootPart"); if not h then return end
    fBV=Instance.new("BodyVelocity",h); fBV.MaxForce=Vector3.new(1e5,1e5,1e5); fBV.Velocity=Vector3.zero
    fBG=Instance.new("BodyGyro",h); fBG.MaxTorque=Vector3.new(1e5,1e5,1e5); fBG.P=1e4
end
local function stopFly()
    if fBV then fBV:Destroy(); fBV=nil end
    if fBG then fBG:Destroy(); fBG=nil end
end

-- ============================================================
-- 11. HONEYPOT FILTER
-- ============================================================
local HoneypotKeywords={"honeypot","bait","decoy","trap","fake","dummy","test"}
local function isHoneypot(v)
    local anc=v
    local depth=0
    while anc and depth<8 do
        local n=anc.Name:lower()
        for _,k in ipairs(HoneypotKeywords) do
            if n:find(k) then return true end
        end
        anc=anc.Parent
        depth=depth+1
    end
    return false
end

-- ============================================================
-- 12. EGG DETECTOR
-- ============================================================
local RAR={
    Common=Color3.fromRGB(255,255,255),Uncommon=Color3.fromRGB(80,200,120),
    Rare=Color3.fromRGB(60,140,255),Epic=Color3.fromRGB(170,80,255),
    Legendary=Color3.fromRGB(255,180,40),Mythic=Color3.fromRGB(255,80,120),
    Cosmic=Color3.fromRGB(100,220,255),Secret=Color3.fromRGB(255,0,180),
    Eternal=Color3.fromRGB(255,240,140),Divine=Color3.fromRGB(255,255,255),
}

local function isEgg(v)
    if not (v:IsA("BasePart") or v:IsA("Model")) then return false end
    if isHoneypot(v) then return false end
    local n=v.Name:lower()
    if n:find("egg") or v:GetAttribute("IsEgg") or v:GetAttribute("Rarity") then
        local pos=v:IsA("BasePart") and v.Position or (v.PrimaryPart and v.PrimaryPart.Position)
        if pos and pos.Y>-50 then return true end
    end
    return false
end

local function getEggPos(v)
    if v:IsA("BasePart") then return v.Position end
    if v:IsA("Model") and v.PrimaryPart then return v.PrimaryPart.Position end
    local p=v:FindFirstChildWhichIsA("BasePart")
    return p and p.Position
end

local function getEggCF(v)
    if v:IsA("BasePart") then return v.CFrame end
    if v:IsA("Model") and v.PrimaryPart then return v.PrimaryPart.CFrame end
    local p=v:FindFirstChildWhichIsA("BasePart")
    return p and p.CFrame
end

local function rar(v)
    local r=v:GetAttribute("Rarity")
    return RAR[r] and r or "Common"
end
local function rarColor(v) return RAR[rar(v)] or RAR.Common end

-- ============================================================
-- 13. AUTO STEAL (fly integrated, safe route)
-- ============================================================
local AutoStealRunning=false

local function autoStealStep()
    if isLocked() then return end
    if not AutoStealRunning then return end

    -- Cari target egg
    local eggs={}
    for _,v in ipairs(WS:GetDescendants()) do
        if isEgg(v) then
            local p=getEggPos(v)
            if p and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local d=(p-LP.Character.HumanoidRootPart.Position).Magnitude
                if d<S.MaxDistance then table.insert(eggs,v) end
            end
        end
    end
    if #eggs==0 then return end

    local target=eggs[1]
    local tcf=getEggCF(target)
    if not tcf then return end

    -- Internal fly active
    startFly()

    -- Safe route via netral zone
    if S.SafeRoute then
        safeTeleport(tcf,3,0.16)
    else
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame=tcf*CFrame.new(0,2,0)
            end
        end)
    end

    -- Fire steal remotes
    fireAll("steal",target)
    fireAll("pickup",target)

    -- Auto transport ke pen
    if S.AutoTransport then
        task.wait(0.1)
        for _,v in ipairs(WS:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("pen") or v.Name:lower():find("base") or v.Name:lower():find("deposit") or v.Name:lower():find("kandang")) then
                if not isHoneypot(v) then
                    safeTeleport(v.CFrame,2,0.16)
                    break
                end
            end
        end
    end

    if not S.ManualFly then
        task.wait(0.1)
        stopFly()
    end
end

task.spawn(function()
    while task.wait(0.35+math.random()*0.25) do
        checkRubberband()
        if S.AutoSteal and not isLocked() then
            AutoStealRunning=true
            pcall(autoStealStep)
        else
            AutoStealRunning=false
            if not S.ManualFly and fBV then stopFly() end
        end
    end
end)

-- Manual fly (opsional, Misc tab)
task.spawn(function()
    while task.wait(0.1) do
        if S.ManualFly then
            local c=LP.Character
            if c then
                local h=c:FindFirstChild("HumanoidRootPart")
                if h and not fBV then startFly() end
                if fBV then
                    local d=Vector3.zero
                    local cam=WS.CurrentCamera
                    if UIS:IsKeyDown(Enum.KeyCode.W) then d+=cam.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then d-=cam.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then d+=Vector3.yAxis end
                    fBV.Velocity=d.Magnitude>0 and d.Unit*S.Walk or Vector3.zero
                    fBG.CFrame=cam.CFrame
                end
            end
        elseif not S.AutoSteal and fBV then
            stopFly()
        end
    end
end)

-- ============================================================
-- 14. ESP
-- ============================================================
local espF=mk("Folder",{Name="ESP"},GUI)
task.spawn(function()
    while task.wait(0.5) do
        for _,v in pairs(espF:GetChildren()) do v:Destroy() end
        if S.ESPBox or S.ESPName or S.ESPRarity then
            for _,v in ipairs(WS:GetDescendants()) do
                if isEgg(v) then
                    local t=v:IsA("BasePart") and v or v.PrimaryPart
                    if t then
                        if S.ESPBox then
                            local b=Instance.new("BoxHandleAdornment",espF)
                            b.Adornee=t; b.Size=t.Size+Vector3.new(0.5,0.5,0.5)
                            b.Transparency=0.5; b.Color3=rarColor(v); b.AlwaysOnTop=true
                        end
                        if S.ESPName or S.ESPRarity then
                            local bg=Instance.new("BillboardGui",espF)
                            bg.Size=UDim2.fromOffset(160,50); bg.StudsOffsetWorldSpace=Vector3.new(0,3,0)
                            bg.AlwaysOnTop=true; bg.Adornee=t
                            local l=Instance.new("TextLabel",bg)
                            l.Size=UDim2.fromScale(1,1); l.BackgroundTransparency=1
                            l.TextColor3=rarColor(v); l.Font=Enum.Font.GothamBold
                            l.TextSize=11; l.TextStrokeTransparency=0.5
                            local tx=""
                            if S.ESPName then tx=tx..v.Name end
                            if S.ESPRarity then tx=tx.."\n"..rar(v) end
                            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                                local d=(t.Position-LP.Character.HumanoidRootPart.Position).Magnitude
                                tx=tx.."\n"..math.floor(d).." studs"
                            end
                            l.Text=tx
                        end
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- 15. AUTOMATION (validated — auto disable kalau remote kosong)
-- ============================================================
task.spawn(function()
    while task.wait(2.5) do
        if S.AutoHatch and #RemoteCache.hatch>0 then
            fireAll("hatch")
        end
    end
end)

task.spawn(function()
    while task.wait(5) do
        if S.AutoFusion and #RemoteCache.fusion>0 then
            fireAll("fusion")
        end
    end
end)

task.spawn(function()
    while task.wait(6) do
        if S.AutoSell and #RemoteCache.sell>0 then
            fireAll("sell")
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if S.AutoDrones and not isLocked() then
            for _,v in ipairs(WS:GetDescendants()) do
                if v:IsA("Model") and (v.Name:lower():find("drone") or v.Name:lower():find("scramble")) and not isHoneypot(v) then
                    local h=v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                    if h and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        safeTeleport(h.CFrame,2,0.18)
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(2.5) do
        if (S.AutoSamples or S.AutoVault) and not isLocked() then
            for _,v in ipairs(WS:GetDescendants()) do
                if v:IsA("BasePart") and not isHoneypot(v) then
                    local n=v.Name:lower()
                    local match=(S.AutoSamples and (n:find("sample") or n:find("scramblepart")))
                    or (S.AutoVault and (n:find("vault") or n:find("component")))
                    if match then safeTeleport(v.CFrame,2,0.18) end
                end
            end
        end
    end
end)

-- ============================================================
-- 16. CHARACTER MODS
-- ============================================================
task.spawn(function()
    while task.wait(1) do
        if S.GodMode then
            local c=LP.Character
            if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.MaxHealth=math.huge; h.Health=math.huge end end
        end
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        if S.Noclip then
            local c=LP.Character
            if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide=false end end end
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if S.AntiTrap then
            for _,v in ipairs(WS:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("trap") or v.Name:lower():find("spike")) then
                    v.CanTouch=false; v.CanCollide=false
                end
            end
        end
    end
end)

-- Refresh zones + remotes setiap 30s
task.spawn(function()
    while task.wait(30) do
        pcall(detectZones)
        pcall(scanRemotes)
    end
end)

-- ============================================================
-- 17. UI HOOKUP
-- ============================================================
addLabel(tabs.farm.page,"Status: Stealth "..(getrawmetatable and "ON" or "OFF"),T.ok)
addLabel(tabs.farm.page,"Zones: "..#NetralZones.." | Remotes: "..#RemoteCache.steal,T.sub)

addToggle(tabs.farm.page,"Auto Steal (Fly Integrated)",false,function(v) S.AutoSteal=v end)
addToggle(tabs.farm.page,"Safe Route (Netral Zone)",true,function(v) S.SafeRoute=v end)
addToggle(tabs.farm.page,"Auto Transport",false,function(v) S.AutoTransport=v end)
addToggle(tabs.farm.page,"Silent Steal",false,function(v) S.SilentSteal=v end)
addSlider(tabs.farm.page,"Max Distance (studs)",100,3000,800,function(v) S.MaxDistance=v end)
addBtn(tabs.farm.page,"Rescan Remotes + Zones",function()
    pcall(scanRemotes)
    pcall(detectZones)
    local n=#RemoteCache.steal
    pcall(function() SG:SetCore("SendNotification",{Title="JOY",Text="Steal remotes: "..n, Duration=2}) end)
end,T.accent2)

addToggle(tabs.visual.page,"ESP Box",false,function(v) S.ESPBox=v end)
addToggle(tabs.visual.page,"ESP Name",false,function(v) S.ESPName=v end)
addToggle(tabs.visual.page,"ESP Rarity",false,function(v) S.ESPRarity=v end)

addToggle(tabs.event.page,"Auto Hatch",false,function(v) S.AutoHatch=v end)
addToggle(tabs.event.page,"Auto Fusion",false,function(v) S.AutoFusion=v end)
addToggle(tabs.event.page,"Auto Drones",false,function(v) S.AutoDrones=v end)
addToggle(tabs.event.page,"Auto Samples",false,function(v) S.AutoSamples=v end)
addToggle(tabs.event.page,"Auto Vault",false,function(v) S.AutoVault=v end)
addToggle(tabs.event.page,"Auto Sell Low Rarity",false,function(v) S.AutoSell=v end)

addToggle(tabs.misc.page,"Godmode",false,function(v) S.GodMode=v end)
addToggle(tabs.misc.page,"Anti Trap",false,function(v) S.AntiTrap=v end)
addToggle(tabs.misc.page,"Noclip",false,function(v) S.Noclip=v end)
addToggle(tabs.misc.page,"Manual Fly (opsional)",false,function(v) S.ManualFly=v end)
addSlider(tabs.misc.page,"WalkSpeed",16,300,60,function(v)
    S.Walk=v
    local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed=v end
end)
addSlider(tabs.misc.page,"JumpPower",50,400,120,function(v)
    S.Jump=v
    local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.UseJumpPower=true; h.JumpPower=v end
end)

addToggle(tabs.safety.page,"Anti Kick [LOCK]",true,function() end)
addToggle(tabs.safety.page,"Anti Detect [LOCK]",true,function() end)
addToggle(tabs.safety.page,"Anti AFK [LOCK]",true,function() end)
addToggle(tabs.safety.page,"Auto Hop",false,function(v) S.AutoHop=v end)
addSlider(tabs.safety.page,"Max Player",1,30,3,function(v) S.MaxP=v end)
addBtn(tabs.safety.page,"Cari Server Sepi",function()
    local rq=(syn and syn.request) or (http and http.request) or http_request or request
    if not rq then return end
    pcall(function()
        local r=rq({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
        local d=HS:JSONDecode(r.Body)
        for _,s in ipairs(d.data) do
            if s.playing<=S.MaxP and s.id~=game.JobId then
                getgenv().JOY_AllowHop=true
                TPS:TeleportToPlaceInstance(game.PlaceId,s.id,LP)
                return
            end
        end
    end)
end)

addBtn(tabs.cfg.page,"Save Config",function()
    pcall(function() if writefile then writefile("Joy17_Cfg.json",HS:JSONEncode(S)) end end)
end)
addBtn(tabs.cfg.page,"Load Config",function()
    pcall(function()
        if readfile and isfile and isfile("Joy17_Cfg.json") then
            local d=HS:JSONDecode(readfile("Joy17_Cfg.json"))
            for k,v in pairs(d) do S[k]=v end
        end
    end)
end)
addBtn(tabs.cfg.page,"Force Rebuild GUI",function()
    GUI:Destroy()
    getgenv().JOY_GUI=nil
end,T.bad)

showTab("farm")

-- ============================================================
-- 18. KEY GATE
-- ============================================================
local KEYS={["joy"]=true,["Joy"]=true,["JOY"]=true,["1234"]=true,["1"]=true,["bazz"]=true,["steal"]=true,["egg"]=true}
local vf=false
local function doV()
    if vf then return end
    local i=tostring(KI.Text or ""):gsub("%s+","")
    if KEYS[i] then
        vf=true
        KeyF.Visible=false
        Main.Visible=true
        pcall(function() SG:SetCore("SendNotification",{Title="JOY HUB v17",Text="Verified.",Duration=3}) end)
    else
        KI.Text=""
    end
end
bind(SB,doV)
pcall(function() KI.FocusLost:Connect(function(e) if e then doV() end end) end)
bind(CloseB,function() GUI:Destroy(); getgenv().JOY_GUI=nil end)

-- ============================================================
-- 19. TELEPORT GUARD
-- ============================================================
pcall(function()
    local o=TPS.TeleportToPlaceInstance
    getgenv().JOY_AllowHop=false
    hookfunction(o,function(self,...)
        if getgenv().JOY_AllowHop then getgenv().JOY_AllowHop=false; return o(self,...) end
        return
    end)
end)

print("[JOY v17] Loaded. Key: joy")
pcall(function() SG:SetCore("SendNotification",{Title="JOY HUB v17",Text="Ready. Key: joy",Duration=4}) end)
