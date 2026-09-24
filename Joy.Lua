-- file: FoxNameHub_v22.lua
-- gui/ui/key ROMBAK ULANG
-- parent: PlayerGui langsung
-- key: fox

-- ============================================================
-- SERVICES
-- ============================================================
local svc=game.GetService
local Players=svc(game,"Players")
local RS=svc(game,"ReplicatedStorage")
local RF=svc(game,"ReplicatedFirst")
local WS=svc(game,"Workspace")
local UIS=svc(game,"UserInputService")
local TS=svc(game,"TweenService")
local HS=svc(game,"HttpService")
local SG=svc(game,"StarterGui")
local VU=svc(game,"VirtualUser")
local TPS=svc(game,"TeleportService")
local LP=Players.LocalPlayer

-- ============================================================
-- STEALTH (minimal, tidak blocking)
-- ============================================================
pcall(function()
    if not getrawmetatable then return end
    local ok,mt=pcall(getrawmetatable,game)
    if not ok or not mt then return end
    pcall(function() setreadonly(mt,false) end)
    local oNC=mt.__namecall
    mt.__namecall=newcclosure(function(self,...)
        local m=getnamecallmethod()
        if m=="Kick" or m=="kick" or m=="KickSelf" or m=="Ban" then
            if checkcaller and checkcaller() then return oNC(self,...) end
            return
        end
        return oNC(self,...)
    end)
    pcall(function() setreadonly(mt,true) end)
end)
pcall(function()
    LP.Idled:Connect(function()
        pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
    end)
end)

-- ============================================================
-- CLEANUP
-- ============================================================
pcall(function()
    if getgenv().FOX_GUI then getgenv().FOX_GUI:Destroy() end
end)
pcall(function()
    local pg=LP:FindFirstChild("PlayerGui")
    if pg then
        local old=pg:FindFirstChild("FOX_GUI")
        if old then old:Destroy() end
    end
end)

-- ============================================================
-- THEME
-- ============================================================
local T={
    bg=Color3.fromRGB(16,16,20),
    panel=Color3.fromRGB(24,24,30),
    sidebar=Color3.fromRGB(20,20,26),
    item=Color3.fromRGB(30,30,38),
    accent=Color3.fromRGB(80,200,255),
    accentDark=Color3.fromRGB(30,80,110),
    text=Color3.fromRGB(240,240,245),
    sub=Color3.fromRGB(130,130,145),
    ok=Color3.fromRGB(80,220,140),
    bad=Color3.fromRGB(255,80,100),
    warn=Color3.fromRGB(255,180,60),
    stroke=Color3.fromRGB(45,45,55),
}

local function mk(c,p,par)
    local o=Instance.new(c)
    for k,v in pairs(p) do o[k]=v end
    if par then o.Parent=par end
    return o
end

-- ============================================================
-- PARENT GUI (langsung PlayerGui)
-- ============================================================
local PG=LP:WaitForChild("PlayerGui",10)
if not PG then return end

local GUI=mk("ScreenGui",{
    Name="FOX_GUI",
    ResetOnSpawn=false,
    DisplayOrder=999,
    IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    Parent=PG,
})
getgenv().FOX_GUI=GUI

-- ============================================================
-- KEY SCREEN (render pertama, synchronous)
-- ============================================================
local KeyFrame=mk("Frame",{
    Name="KeyFrame",
    Size=UDim2.fromOffset(300,200),
    Position=UDim2.new(0.5,-150,0.5,-100),
    BackgroundColor3=T.bg,
    BorderSizePixel=0,
    ZIndex=500,
    Parent=GUI,
})
mk("UICorner",{CornerRadius=UDim.new(0,12)},KeyFrame)
mk("UIStroke",{Color=T.accent,Thickness=1.5},KeyFrame)

-- Header strip
mk("Frame",{
    Size=UDim2.new(1,0,0,4),
    BackgroundColor3=T.accent,
    BorderSizePixel=0,
    ZIndex=501,
    Parent=KeyFrame,
})

mk("TextLabel",{
    Size=UDim2.new(1,0,0,28),
    Position=UDim2.new(0,0,0,20),
    BackgroundTransparency=1,
    Text="FOX NAME HUB",
    TextColor3=T.text,
    Font=Enum.Font.GothamBold,
    TextSize=18,
    ZIndex=501,
    Parent=KeyFrame,
})

mk("TextLabel",{
    Size=UDim2.new(1,0,0,14),
    Position=UDim2.new(0,0,0,48),
    BackgroundTransparency=1,
    Text="v22 | Delta Mobile",
    TextColor3=T.sub,
    Font=Enum.Font.Gotham,
    TextSize=10,
    ZIndex=501,
    Parent=KeyFrame,
})

-- Input
local KeyInput=mk("TextBox",{
    Size=UDim2.new(1,-40,0,38),
    Position=UDim2.new(0,20,0,80),
    BackgroundColor3=T.panel,
    BorderSizePixel=0,
    Text="",
    PlaceholderText="Masukkan key...",
    PlaceholderColor3=T.sub,
    TextColor3=T.text,
    Font=Enum.Font.Gotham,
    TextSize=14,
    TextXAlignment=Enum.TextXAlignment.Center,
    ClearTextOnFocus=false,
    ZIndex=501,
    Parent=KeyFrame,
})
mk("UICorner",{CornerRadius=UDim.new(0,8)},KeyInput)
mk("UIStroke",{Color=T.stroke,Thickness=1},KeyInput)

-- Verify Button
local VerifyBtn=mk("TextButton",{
    Size=UDim2.new(1,-40,0,36),
    Position=UDim2.new(0,20,0,126),
    BackgroundColor3=T.accent,
    Text="VERIFY",
    TextColor3=Color3.fromRGB(10,20,30),
    Font=Enum.Font.GothamBold,
    TextSize=14,
    AutoButtonColor=true,
    BorderSizePixel=0,
    ZIndex=501,
    Parent=KeyFrame,
})
mk("UICorner",{CornerRadius=UDim.new(0,8)},VerifyBtn)

-- Status
local KeyStatus=mk("TextLabel",{
    Size=UDim2.new(1,0,0,14),
    Position=UDim2.new(0,0,0,170),
    BackgroundTransparency=1,
    Text="",
    TextColor3=T.bad,
    Font=Enum.Font.Gotham,
    TextSize=10,
    ZIndex=501,
    Parent=KeyFrame,
})

-- ============================================================
-- MAIN GUI (hidden sampai verify)
-- ============================================================
local Main=mk("Frame",{
    Name="Main",
    Size=UDim2.fromOffset(600,380),
    Position=UDim2.new(0.5,-300,0.5,-190),
    BackgroundColor3=T.bg,
    BorderSizePixel=0,
    ClipsDescendants=true,
    Visible=false,
    ZIndex=1,
    Parent=GUI,
})
mk("UICorner",{CornerRadius=UDim.new(0,10)},Main)
mk("UIStroke",{Color=T.stroke,Thickness=1},Main)

-- Header
local Header=mk("Frame",{
    Size=UDim2.new(1,0,0,28),
    BackgroundColor3=T.panel,
    BorderSizePixel=0,
    ZIndex=2,
    Parent=Main,
})
mk("TextLabel",{
    Size=UDim2.new(1,-120,1,0),
    Position=UDim2.new(0,10,0,0),
    BackgroundTransparency=1,
    Text="FOX-NAME-HUB",
    TextColor3=T.text,
    Font=Enum.Font.GothamBold,
    TextSize=11,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=3,
    Parent=Header,
})
local MinBtn=mk("TextButton",{
    Size=UDim2.fromOffset(20,20),
    Position=UDim2.new(1,-48,0,4),
    BackgroundTransparency=1,
    Text="−",
    TextColor3=T.sub,
    Font=Enum.Font.GothamBold,
    TextSize=16,
    AutoButtonColor=false,
    BorderSizePixel=0,
    ZIndex=3,
    Parent=Header,
})
local CloseBtn=mk("TextButton",{
    Size=UDim2.fromOffset(20,20),
    Position=UDim2.new(1,-24,0,4),
    BackgroundTransparency=1,
    Text="✕",
    TextColor3=T.bad,
    Font=Enum.Font.GothamBold,
    TextSize=12,
    AutoButtonColor=false,
    BorderSizePixel=0,
    ZIndex=3,
    Parent=Header,
})

-- Sidebar
local Sidebar=mk("Frame",{
    Size=UDim2.new(0,140,1,-28),
    Position=UDim2.new(0,0,0,28),
    BackgroundColor3=T.sidebar,
    BorderSizePixel=0,
    ZIndex=2,
    Parent=Main,
})
mk("Frame",{
    Size=UDim2.new(0,1,1,0),
    Position=UDim2.new(1,0,0,0),
    BackgroundColor3=T.stroke,
    BorderSizePixel=0,
    ZIndex=3,
    Parent=Sidebar,
})

local ItemList=mk("ScrollingFrame",{
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=2,
    ScrollBarImageColor3=T.stroke,
    CanvasSize=UDim2.new(0,0,0,0),
    ZIndex=2,
    Parent=Sidebar,
})
mk("UIListLayout",{
    Padding=UDim.new(0,2),
    SortOrder=Enum.SortOrder.LayoutOrder,
    Parent=ItemList,
})
mk("UIPadding",{
    PaddingLeft=UDim.new(0,6),
    PaddingRight=UDim.new(0,6),
    PaddingTop=UDim.new(0,6),
    Parent=ItemList,
})

-- Content
local ContentPanel=mk("Frame",{
    Size=UDim2.new(1,-140,1,-28),
    Position=UDim2.new(0,140,0,28),
    BackgroundColor3=T.bg,
    BorderSizePixel=0,
    ZIndex=1,
    Parent=Main,
})

local PageTitle=mk("TextLabel",{
    Size=UDim2.new(1,-16,0,24),
    Position=UDim2.new(0,8,0,6),
    BackgroundTransparency=1,
    Text="Auto",
    TextColor3=T.text,
    Font=Enum.Font.GothamBold,
    TextSize=12,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=2,
    Parent=ContentPanel,
})
mk("Frame",{
    Size=UDim2.new(1,-16,0,1),
    Position=UDim2.new(0,8,0,32),
    BackgroundColor3=T.stroke,
    BorderSizePixel=0,
    ZIndex=2,
    Parent=ContentPanel,
})

local PageContent=mk("ScrollingFrame",{
    Size=UDim2.new(1,-16,1,-46),
    Position=UDim2.new(0,8,0,38),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=2,
    ScrollBarImageColor3=T.stroke,
    CanvasSize=UDim2.new(0,0,0,0),
    ZIndex=2,
    Parent=ContentPanel,
})
mk("UIListLayout",{
    Padding=UDim.new(0,4),
    SortOrder=Enum.SortOrder.LayoutOrder,
    Parent=PageContent,
})

-- Status bar
local StatusBar=mk("Frame",{
    Size=UDim2.new(1,0,0,18),
    Position=UDim2.new(0,0,1,-18),
    BackgroundColor3=T.panel,
    BorderSizePixel=0,
    ZIndex=5,
    Parent=Main,
})
local StatusLabel=mk("TextLabel",{
    Size=UDim2.new(1,-10,1,0),
    Position=UDim2.new(0,6,0,0),
    BackgroundTransparency=1,
    Text="Ready.",
    TextColor3=T.ok,
    Font=Enum.Font.Gotham,
    TextSize=9,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6,
    Parent=StatusBar,
})
local function setStatus(msg,color)
    pcall(function()
        StatusLabel.Text=tostring(msg):sub(1,80)
        StatusLabel.TextColor3=color or T.ok
    end)
end

-- ============================================================
-- MENU CONFIG
-- ============================================================
local MENU={
    {id="info",    label="Info"},
    {id="auto",    label="Auto"},
    {id="farm",    label="Farm"},
    {id="rift",    label="Rift"},
    {id="visual",  label="Visual"},
    {id="utility", label="Utility"},
    {id="config",  label="Config"},
}

local pages={}

local function makePage()
    local pg=mk("Frame",{
        Size=UDim2.new(1,0,0,0),
        BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y,
        Visible=false,
        Parent=PageContent,
    })
    mk("UIListLayout",{
        Padding=UDim.new(0,4),
        SortOrder=Enum.SortOrder.LayoutOrder,
        Parent=pg,
    })
    return pg
end

local function showPage(id)
    for _,p in pairs(pages) do p.Visible=false end
    if pages[id] then
        pages[id].Visible=true
        PageTitle.Text=id:sub(1,1):upper()..id:sub(2)
    end
    for _,it in ipairs(MENU) do
        if it._btn then
            if it.id==id then
                it._btn.BackgroundColor3=T.item
                it._btn.TextColor3=T.text
            else
                it._btn.BackgroundColor3=T.sidebar
                it._btn.TextColor3=T.sub
            end
        end
    end
end

-- Build sidebar buttons
for _,item in ipairs(MENU) do
    local btn=mk("TextButton",{
        Size=UDim2.new(1,0,0,26),
        BackgroundColor3=T.sidebar,
        Text=item.label,
        TextColor3=T.sub,
        Font=Enum.Font.Gotham,
        TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
        AutoButtonColor=false,
        BorderSizePixel=0,
        ZIndex=3,
        Parent=ItemList,
    })
    mk("UICorner",{CornerRadius=UDim.new(0,6)},btn)
    mk("UIPadding",{
        PaddingLeft=UDim.new(0,10),
        Parent=btn,
    })
    item._btn=btn
    pages[item.id]=makePage()
    btn.MouseButton1Click:Connect(function() showPage(item.id) end)
    pcall(function() btn.TouchTap:Connect(function() showPage(item.id) end) end)
end

-- ============================================================
-- COMPONENTS
-- ============================================================
local function addCategory(pg,txt)
    return mk("TextLabel",{
        Size=UDim2.new(1,0,0,18),
        BackgroundTransparency=1,
        Text=txt,
        TextColor3=T.sub,
        Font=Enum.Font.GothamBold,
        TextSize=9,
        TextXAlignment=Enum.TextXAlignment.Left,
        Parent=pg,
    })
end

local function addToggleRow(pg,txt,def,cb)
    local r=mk("Frame",{
        Size=UDim2.new(1,0,0,28),
        BackgroundColor3=T.panel,
        BorderSizePixel=0,
        Parent=pg,
    })
    mk("UICorner",{CornerRadius=UDim.new(0,6)},r)
    mk("TextLabel",{
        Size=UDim2.new(1,-56,1,0),
        Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text=txt,
        TextColor3=T.text,
        Font=Enum.Font.Gotham,
        TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
        Parent=r,
    })
    local sw=mk("TextButton",{
        Size=UDim2.fromOffset(34,18),
        Position=UDim2.new(1,-40,0.5,-9),
        BackgroundColor3=def and T.accent or Color3.fromRGB(45,45,55),
        Text="",
        AutoButtonColor=false,
        BorderSizePixel=0,
        Parent=r,
    })
    mk("UICorner",{CornerRadius=UDim.new(1,0)},sw)
    local dot=mk("Frame",{
        Size=UDim2.fromOffset(14,14),
        Position=def and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),
        BackgroundColor3=Color3.new(1,1,1),
        BorderSizePixel=0,
        Parent=sw,
    })
    mk("UICorner",{CornerRadius=UDim.new(1,0)},dot)
    local st=def
    local function toggle()
        st=not st
        pcall(function()
            TS:Create(sw,TweenInfo.new(0.15),{BackgroundColor3=st and T.accent or Color3.fromRGB(45,45,55)}):Play()
            TS:Create(dot,TweenInfo.new(0.15),{Position=st and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()
        end)
        if cb then pcall(cb,st) end
    end
    sw.MouseButton1Click:Connect(toggle)
    pcall(function() sw.TouchTap:Connect(toggle) end)
    return r
end

local function addSliderRow(pg,txt,mn,mx,def,cb)
    local r=mk("Frame",{
        Size=UDim2.new(1,0,0,42),
        BackgroundColor3=T.panel,
        BorderSizePixel=0,
        Parent=pg,
    })
    mk("UICorner",{CornerRadius=UDim.new(0,6)},r)
    local lbl=mk("TextLabel",{
        Size=UDim2.new(1,-16,0,16),
        Position=UDim2.new(0,10,0,3),
        BackgroundTransparency=1,
        Text=txt..": "..def,
        TextColor3=T.text,
        Font=Enum.Font.Gotham,
        TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
        Parent=r,
    })
    local bg=mk("Frame",{
        Size=UDim2.new(1,-20,0,5),
        Position=UDim2.new(0,10,0,28),
        BackgroundColor3=Color3.fromRGB(45,45,55),
        BorderSizePixel=0,
        Parent=r,
    })
    mk("UICorner",{CornerRadius=UDim.new(1,0)},bg)
    local fill=mk("Frame",{
        Size=UDim2.new((def-mn)/(mx-mn),0,1,0),
        BackgroundColor3=T.accent,
        BorderSizePixel=0,
        Parent=bg,
    })
    mk("UICorner",{CornerRadius=UDim.new(1,0)},fill)
    local knob=mk("Frame",{
        Size=UDim2.fromOffset(12,12),
        Position=UDim2.new((def-mn)/(mx-mn),-6,0.5,-6),
        BackgroundColor3=Color3.new(1,1,1),
        BorderSizePixel=0,
        Parent=bg,
    })
    mk("UICorner",{CornerRadius=UDim.new(1,0)},knob)
    local dr=false
    local function up(x)
        local p=math.clamp((x-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1)
        fill.Size=UDim2.new(p,0,1,0)
        knob.Position=UDim2.new(p,-6,0.5,-6)
        local v=math.floor(mn+(mx-mn)*p)
        lbl.Text=txt..": "..v
        if cb then pcall(cb,v) end
    end
    bg.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dr=true; up(i.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dr and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            up(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dr=false
        end
    end)
    return r
end

local function addBtnRow(pg,txt,cb,color)
    local b=mk("TextButton",{
        Size=UDim2.new(1,0,0,28),
        BackgroundColor3=color or T.accent,
        Text=txt,
        TextColor3=Color3.fromRGB(10,20,30),
        Font=Enum.Font.GothamBold,
        TextSize=11,
        AutoButtonColor=true,
        BorderSizePixel=0,
        Parent=pg,
    })
    mk("UICorner",{CornerRadius=UDim.new(0,6)},b)
    b.MouseButton1Click:Connect(function() pcall(cb) end)
    pcall(function() b.TouchTap:Connect(function() pcall(cb) end) end)
    return b
end

local function addRow(pg,txt,value)
    local r=mk("Frame",{
        Size=UDim2.new(1,0,0,26),
        BackgroundColor3=T.panel,
        BorderSizePixel=0,
        Parent=pg,
    })
    mk("UICorner",{CornerRadius=UDim.new(0,6)},r)
    mk("TextLabel",{
        Size=UDim2.new(1,-70,1,0),
        Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text=txt,
        TextColor3=T.text,
        Font=Enum.Font.Gotham,
        TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
        Parent=r,
    })
    local val=mk("TextLabel",{
        Size=UDim2.new(0,60,1,0),
        Position=UDim2.new(1,-70,0,0),
        BackgroundTransparency=1,
        Text=value or "—",
        TextColor3=T.sub,
        Font=Enum.Font.Gotham,
        TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Right,
        Parent=r,
    })
    return r,val
end

-- ============================================================
-- STATE
-- ============================================================
local S={
    AutoSteal=false,AutoPlace=false,AutoHatch=false,AutoFuse=false,AutoSell=false,
    AutoTreadmill=false,AutoUpgrade=false,AutoClaim=false,AutoEquipBest=false,
    MaxDistance=800,SafeRoute=true,
    ESPBox=false,ESPName=false,ESPRarity=false,
    GuardESP=false,PlayerESP=false,Tracer=false,
    ManualFly=false,Noclip=false,Walk=60,Jump=120,
    AntiRagdoll=false,AntiAFK=true,
    RiftBossAuto=false,RiftSacrifice=false,
    AutoHop=false,MaxP=3,
}

-- ============================================================
-- REMOTE RESOLVER
-- ============================================================
local RC={steal={},place={},hatch={},fuse={},sell={},treadmill={},upgrade={},claim={},equip={},rift={}}
local function scanRemotes()
    for k in pairs(RC) do RC[k]={} end
    local kws={
        steal={"steal","pickup","collect","grab","take"},
        place={"place","put","deposit"},
        hatch={"hatch","incubate","open"},
        fuse={"fuse","fusion","combine","merge"},
        sell={"sell","shop","trade"},
        treadmill={"treadmill","train","run"},
        upgrade={"upgrade","upg"},
        claim={"claim","reward"},
        equip={"equip","wear"},
        rift={"rift","boss","overlord","sacrifice"},
    }
    for _,parent in ipairs({RS,RF,WS}) do
        local ok,desc=pcall(function() return parent:GetDescendants() end)
        if ok then
            for _,v in ipairs(desc) do
                if v.ClassName=="RemoteEvent" or v.ClassName=="RemoteFunction" or v.ClassName=="UnreliableRemoteEvent" then
                    local n=v.Name:lower()
                    for cat,words in pairs(kws) do
                        for _,w in ipairs(words) do
                            if n:find(w) then table.insert(RC[cat],v); break end
                        end
                    end
                end
            end
        end
    end
end
pcall(scanRemotes)

local function fireAll(cat,...)
    local okCount=0
    for _,r in ipairs(RC[cat] or {}) do
        local ok=pcall(function()
            if r.ClassName=="RemoteFunction" then r:InvokeServer(...) else r:FireServer(...) end
        end)
        if ok then okCount=okCount+1 end
    end
    return okCount
end
local function verify(cat) return #(RC[cat] or {})>0 end

-- ============================================================
-- EGG DETECTOR + FLY + TELEPORT
-- ============================================================
local HP={"honeypot","bait","decoy","trap","fake","dummy"}
local function isHoneypot(v)
    local anc=v; local d=0
    while anc and d<8 do
        local n=anc.Name:lower()
        for _,k in ipairs(HP) do if n:find(k) then return true end end
        anc=anc.Parent; d=d+1
    end
    return false
end

local RAR={
    Common=Color3.fromRGB(255,255,255),Uncommon=Color3.fromRGB(80,200,120),
    Rare=Color3.fromRGB(60,140,255),Epic=Color3.fromRGB(170,80,255),
    Legendary=Color3.fromRGB(255,180,40),Mythic=Color3.fromRGB(255,80,120),
    Cosmic=Color3.fromRGB(100,220,255),Secret=Color3.fromRGB(255,0,180),
}
local function isEgg(v)
    if not (v:IsA("BasePart") or v:IsA("Model")) then return false end
    if isHoneypot(v) then return false end
    local n=v.Name:lower()
    if n:find("egg") or v:GetAttribute("IsEgg") or v:GetAttribute("Rarity") then return true end
    return false
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

local fBV,fBG
local function startFly()
    if fBV then return end
    local c=LP.Character; if not c then return end
    local h=c:FindFirstChild("HumanoidRootPart"); if not h then return end
    fBV=Instance.new("BodyVelocity",h)
    fBV.MaxForce=Vector3.new(1e5,1e5,1e5)
    fBV.Velocity=Vector3.zero
    fBG=Instance.new("BodyGyro",h)
    fBG.MaxTorque=Vector3.new(1e5,1e5,1e5)
    fBG.P=1e4
end
local function stopFly()
    if fBV then fBV:Destroy(); fBV=nil end
    if fBG then fBG:Destroy(); fBG=nil end
end

local function safeTeleport(targetCF,steps,stepTime)
    steps=steps or 3; stepTime=stepTime or 0.16
    if not LP.Character then return false end
    local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local from=hrp.Position
    local to=targetCF.Position
    for i=1,steps do
        local alpha=i/steps
        local wp=CFrame.new(from:Lerp(to,alpha),to)
        pcall(function()
            TS:Create(hrp,TweenInfo.new(stepTime,Enum.EasingStyle.Linear),{CFrame=wp}):Play()
        end)
        task.wait(stepTime+0.02)
    end
    return true
end

-- ============================================================
-- BUILD PAGES
-- ============================================================

-- INFO
do
    local pg=pages.info
    addCategory(pg,"BRAND")
    addRow(pg,"Hub","Fox Name Hub")
    addRow(pg,"Version","v22")
    addRow(pg,"Style","Nasi Rendang")
    addCategory(pg,"RUNTIME")
    addRow(pg,"Executor","Delta Mobile")
    addRow(pg,"Game",tostring(game.PlaceId))
    addRow(pg,"Player",LP.Name)
    addCategory(pg,"STATUS")
    local _,stVal=addRow(pg,"Stealth","—")
    local _,rmVal=addRow(pg,"Steal Remotes","—")
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                stVal.Text=(getrawmetatable and "ON") or "OFF"
                rmVal.Text=tostring(#RC.steal)
            end)
        end
    end)
end

-- AUTO
do
    local pg=pages.auto
    addCategory(pg,"AUTO STEAL")
    addToggleRow(pg,"Auto Steal",false,function(v) S.AutoSteal=v end)
    addToggleRow(pg,"Auto Place",false,function(v) S.AutoPlace=v end)
    addToggleRow(pg,"Auto Hatch",false,function(v) S.AutoHatch=v end)
    addToggleRow(pg,"Auto Fuse",false,function(v) S.AutoFuse=v end)
    addToggleRow(pg,"Auto Sell",false,function(v) S.AutoSell=v end)
    addCategory(pg,"SETTINGS")
    addSliderRow(pg,"Max Distance",100,3000,800,function(v) S.MaxDistance=v end)
    addBtnRow(pg,"Rescan Remotes",function()
        pcall(scanRemotes)
        setStatus("Rescan: "..#RC.steal.." steal remotes",T.ok)
    end)
end

-- FARM
do
    local pg=pages.farm
    addCategory(pg,"TREADMILL")
    addToggleRow(pg,"Auto Treadmill",false,function(v) S.AutoTreadmill=v end)
    addToggleRow(pg,"Auto Upgrade",false,function(v) S.AutoUpgrade=v end)
    addCategory(pg,"CLAIM")
    addToggleRow(pg,"Auto Claim",false,function(v) S.AutoClaim=v end)
    addToggleRow(pg,"Auto Equip Best",false,function(v) S.AutoEquipBest=v end)
end

-- RIFT
do
    local pg=pages.rift
    addCategory(pg,"RIFT EVENT")
    addToggleRow(pg,"Auto Rift Boss",false,function(v) S.RiftBossAuto=v end)
    addToggleRow(pg,"Auto Sacrifice",false,function(v) S.RiftSacrifice=v end)
end

-- VISUAL
do
    local pg=pages.visual
    addCategory(pg,"EGG ESP")
    addToggleRow(pg,"Egg ESP Box",false,function(v) S.ESPBox=v end)
    addToggleRow(pg,"Egg ESP Name",false,function(v) S.ESPName=v end)
    addToggleRow(pg,"Egg ESP Rarity",false,function(v) S.ESPRarity=v end)
    addCategory(pg,"OTHER ESP")
    addToggleRow(pg,"Guard ESP",false,function(v) S.GuardESP=v end)
    addToggleRow(pg,"Player ESP",false,function(v) S.PlayerESP=v end)
    addToggleRow(pg,"Tracer",false,function(v) S.Tracer=v end)
end

-- UTILITY
do
    local pg=pages.utility
    addCategory(pg,"MOVEMENT")
    addToggleRow(pg,"Manual Fly",false,function(v) S.ManualFly=v end)
    addToggleRow(pg,"Noclip",false,function(v) S.Noclip=v end)
    addSliderRow(pg,"WalkSpeed",16,300,60,function(v)
        S.Walk=v
        local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed=v end
    end)
    addSliderRow(pg,"JumpPower",50,400,120,function(v)
        S.Jump=v
        local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.UseJumpPower=true; h.JumpPower=v end
    end)
    addCategory(pg,"SAFETY")
    addToggleRow(pg,"Anti Ragdoll",false,function(v) S.AntiRagdoll=v end)
    addToggleRow(pg,"Anti AFK",true,function(v) S.AntiAFK=v end)
    addCategory(pg,"SERVER")
    addToggleRow(pg,"Auto Server Hop",false,function(v) S.AutoHop=v end)
    addSliderRow(pg,"Max Player",1,30,3,function(v) S.MaxP=v end)
    addBtnRow(pg,"Cari Server Sepi",function()
        local rq=(syn and syn.request) or (http and http.request) or http_request or request
        if not rq then setStatus("HTTP not available",T.bad); return end
        pcall(function()
            local r=rq({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
            local d=HS:JSONDecode(r.Body)
            for _,s in ipairs(d.data) do
                if s.playing<=S.MaxP and s.id~=game.JobId then
                    getgenv().FOX_AllowHop=true
                    TPS:TeleportToPlaceInstance(game.PlaceId,s.id,LP)
                    return
                end
            end
        end)
    end)
end

-- CONFIG
do
    local pg=pages.config
    addCategory(pg,"STATE")
    addToggleRow(pg,"Auto Steal",false,function(v) S.AutoSteal=v end)
    addToggleRow(pg,"Safe Route",true,function(v) S.SafeRoute=v end)
    addCategory(pg,"FILE")
    addBtnRow(pg,"Save Config",function()
        pcall(function()
            if writefile then writefile("Fox22_Cfg.json",HS:JSONEncode(S)) end
        end)
        setStatus("Saved.",T.ok)
    end)
    addBtnRow(pg,"Load Config",function()
        pcall(function()
            if readfile and isfile and isfile("Fox22_Cfg.json") then
                local d=HS:JSONDecode(readfile("Fox22_Cfg.json"))
                for k,v in pairs(d) do S[k]=v end
                setStatus("Loaded.",T.ok)
            end
        end)
    end)
    addCategory(pg,"UTILITY")
    addBtnRow(pg,"Rescan All",function()
        pcall(scanRemotes)
        setStatus("Rescan done.",T.ok)
    end)
    addBtnRow(pg,"Force Rebuild GUI",function()
        if getgenv().FOX_GUI then getgenv().FOX_GUI:Destroy() end
        getgenv().FOX_GUI=nil
    end,T.bad)
end

showPage("auto")

-- ============================================================
-- DRAG + MINIMIZE
-- ============================================================
local drag=false; local dS,dP
Header.InputBegan:Connect(function(i)
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
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        drag=false
    end
end)

local minimized=false
local function toggleMin()
    minimized=not minimized
    Sidebar.Visible=not minimized
    ContentPanel.Visible=not minimized
    StatusBar.Visible=not minimized
    Main.Size=minimized and UDim2.fromOffset(600,28) or UDim2.fromOffset(600,380)
end
MinBtn.MouseButton1Click:Connect(toggleMin)
pcall(function() MinBtn.TouchTap:Connect(toggleMin) end)

-- ============================================================
-- KEY VERIFY
-- ============================================================
local KEYS={
    ["fox"]=true,["Fox"]=true,["FOX"]=true,
    ["joy"]=true,["Joy"]=true,["JOY"]=true,
    ["1234"]=true,["1"]=true,["bazz"]=true,
    ["ajjans"]=true,["steal"]=true,["egg"]=true,
}
local verified=false
local function doVerify()
    if verified then return end
    local input=tostring(KeyInput.Text or ""):gsub("%s+","")
    if KEYS[input] then
        verified=true
        KeyFrame.Visible=false
        Main.Visible=true
        setStatus("Verified. Key: "..input,T.ok)
    else
        KeyInput.Text=""
        KeyStatus.Text="Key salah."
        KeyStatus.TextColor3=T.bad
    end
end
VerifyBtn.MouseButton1Click:Connect(doVerify)
pcall(function() VerifyBtn.TouchTap:Connect(doVerify) end)
pcall(function()
    KeyInput.FocusLost:Connect(function(enter)
        if enter then doVerify() end
    end)
end)

local function closeGUI()
    pcall(function()
        if getgenv().FOX_GUI then getgenv().FOX_GUI:Destroy() end
    end)
    getgenv().FOX_GUI=nil
end
CloseBtn.MouseButton1Click:Connect(closeGUI)
pcall(function() CloseBtn.TouchTap:Connect(closeGUI) end)

-- ============================================================
-- LOOPS
-- ============================================================
local ASR=false
local function autoStealStep()
    if not ASR then return end
    if not verify("steal") then
        setStatus("No steal remote.",T.bad)
        S.AutoSteal=false
        return
    end
    local eggs={}
    for _,v in ipairs(WS:GetDescendants()) do
        if isEgg(v) then
            local p=v:IsA("BasePart") and v.Position or (v.PrimaryPart and v.PrimaryPart.Position)
            if p and LP.Character then
                local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (p-hrp.Position).Magnitude<S.MaxDistance then
                    table.insert(eggs,v)
                end
            end
        end
    end
    if #eggs==0 then return end
    local target=eggs[1]
    local tcf=getEggCF(target)
    if not tcf then return end
    startFly()
    safeTeleport(tcf,3,0.16)
    fireAll("steal",target)
    if not S.ManualFly then
        task.wait(0.1)
        stopFly()
    end
end

task.spawn(function()
    while task.wait(0.35+math.random()*0.25) do
        if S.AutoSteal then
            ASR=true
            pcall(autoStealStep)
        else
            ASR=false
            if not S.ManualFly and fBV then stopFly() end
        end
    end
end)

task.spawn(function()
    while task.wait(3) do
        if S.AutoPlace and verify("place") then fireAll("place") end
        if S.AutoHatch and verify("hatch") then fireAll("hatch") end
        if S.AutoFuse and verify("fuse") then fireAll("fuse") end
        if S.AutoSell and verify("sell") then fireAll("sell") end
    end
end)

task.spawn(function()
    while task.wait(5) do
        if S.AutoTreadmill and verify("treadmill") then fireAll("treadmill") end
        if S.AutoUpgrade and verify("upgrade") then fireAll("upgrade") end
        if S.AutoClaim and verify("claim") then fireAll("claim") end
    end
end)

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

task.spawn(function()
    while task.wait(0.15) do
        if S.Noclip then
            local c=LP.Character
            if c then
                for _,v in ipairs(c:GetChildren()) do
                    if v:IsA("BasePart") and v.CanCollide then v.CanCollide=false end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if S.AntiRagdoll then
            local c=LP.Character
            if c then
                local h=c:FindFirstChildOfClass("Humanoid")
                if h then
                    h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
                    h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
                end
            end
        end
    end
end)

-- ESP
local espF=mk("Folder",{Name="ESP",Parent=GUI})
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
                            b.Adornee=t
                            b.Size=t.Size+Vector3.new(0.5,0.5,0.5)
                            b.Transparency=0.5
                            b.Color3=rarColor(v)
                            b.AlwaysOnTop=true
                        end
                        if S.ESPName or S.ESPRarity then
                            local bg=Instance.new("BillboardGui",espF)
                            bg.Size=UDim2.fromOffset(150,44)
                            bg.StudsOffsetWorldSpace=Vector3.new(0,3,0)
                            bg.AlwaysOnTop=true
                            bg.Adornee=t
                            local l=Instance.new("TextLabel",bg)
                            l.Size=UDim2.fromScale(1,1)
                            l.BackgroundTransparency=1
                            l.TextColor3=rarColor(v)
                            l.Font=Enum.Font.GothamBold
                            l.TextSize=11
                            l.TextStrokeTransparency=0.5
                            local tx=""
                            if S.ESPName then tx=tx..v.Name end
                            if S.ESPRarity then tx=tx.."\n"..rar(v) end
                            l.Text=tx
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(30) do
        pcall(scanRemotes)
    end
end)

-- Teleport guard
pcall(function()
    local o=TPS.TeleportToPlaceInstance
    getgenv().FOX_AllowHop=false
    if hookfunction then
        hookfunction(o,function(self,...)
            if getgenv().FOX_AllowHop then
                getgenv().FOX_AllowHop=false
                return o(self,...)
            end
            return
        end)
    end
end)

print("[FOX v22] Loaded. Key: fox")    end)
    pcall(function() setreadonly(mt,true) end)
end)
pcall(function()
    LP.Idled:Connect(function()
        pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
    end)
end)

if getgenv and getgenv().FOX_GUI then pcall(function() getgenv().FOX_GUI:Destroy() end) end
local oldG=LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("FOX_GUI")
if oldG then oldG:Destroy() end

local function findParent()
    for _,p in ipairs({(gethui and gethui()) or nil, CG, LP:FindFirstChild("PlayerGui")}) do
        if p then
            local ok=pcall(function()
                local t=Instance.new("ScreenGui")
                t.Name="__FOX_T__"
                t.Parent=p
                t:Destroy()
            end)
            if ok then return p end
        end
    end
    return LP:WaitForChild("PlayerGui")
end
local GP=findParent()

local T={
    bg=Color3.fromRGB(18,18,22),panel=Color3.fromRGB(26,26,32),
    sidebar=Color3.fromRGB(22,22,28),item=Color3.fromRGB(32,32,40),
    accent=Color3.fromRGB(255,255,255),accentHot=Color3.fromRGB(80,200,255),
    text=Color3.fromRGB(240,240,245),sub=Color3.fromRGB(140,140,155),
    ok=Color3.fromRGB(80,220,140),bad=Color3.fromRGB(255,80,100),
    warn=Color3.fromRGB(255,180,60),stroke=Color3.fromRGB(50,50,60),
}

local function mk(c,p,par)
    local o=Instance.new(c)
    for k,v in pairs(p) do o[k]=v end
    if par then o.Parent=par end
    return o
end

local GUI=mk("ScreenGui",{Name="FOX_GUI",ResetOnSpawn=false,DisplayOrder=2147483647,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},GP)
getgenv().FOX_GUI=GUI

-- Key Screen
local KeyF=mk("Frame",{Size=UDim2.fromOffset(320,220),Position=UDim2.new(0.5,-160,0.5,-110),BackgroundColor3=T.bg,BorderSizePixel=0,ZIndex=1000},GUI)
mk("UICorner",{CornerRadius=UDim.new(0,12)},KeyF)
mk("UIStroke",{Color=T.stroke,Thickness=1},KeyF)
mk("TextLabel",{Size=UDim2.new(1,0,0,24),Position=UDim2.new(0,0,0,18),BackgroundTransparency=1,Text="FOX NAME HUB",TextColor3=T.text,Font=Enum.Font.GothamBold,TextSize=18,ZIndex=1001},KeyF)
mk("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,0,44),BackgroundTransparency=1,Text="v21 | Nasi Rendang Style",TextColor3=T.sub,Font=Enum.Font.Gotham,TextSize=10,ZIndex=1001},KeyF)
local KB=mk("Frame",{Size=UDim2.new(1,-40,0,40),Position=UDim2.new(0,20,0,76),BackgroundColor3=T.panel,BorderSizePixel=0,ZIndex=1001},KeyF)
mk("UICorner",{CornerRadius=UDim.new(0,8)},KB)
mk("UIStroke",{Color=T.stroke,Thickness=1},KB)
local KI=mk("TextBox",{Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text="",PlaceholderText="Key...",PlaceholderColor3=T.sub,TextColor3=T.text,Font=Enum.Font.Gotham,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,ZIndex=1010},KB)
local SB=mk("TextButton",{Size=UDim2.new(1,-40,0,36),Position=UDim2.new(0,20,0,126),BackgroundColor3=T.accentHot,Text="VERIFY",TextColor3=Color3.fromRGB(10,20,30),Font=Enum.Font.GothamBold,TextSize=14,AutoButtonColor=true,BorderSizePixel=0,ZIndex=1010},KeyF)
mk("UICorner",{CornerRadius=UDim.new(0,8)},SB)
local KeyStatus=mk("TextLabel",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,170),BackgroundTransparency=1,Text="",TextColor3=T.bad,Font=Enum.Font.Gotham,TextSize=11,ZIndex=1001},KeyF)

-- Main Frame
local Main=mk("Frame",{Name="Main",Size=UDim2.fromOffset(620,400),Position=UDim2.new(0.5,-310,0.5,-200),BackgroundColor3=T.bg,BorderSizePixel=0,ClipsDescendants=true,Visible=false},GUI)
mk("UICorner",{CornerRadius=UDim.new(0,10)},Main)
mk("UIStroke",{Color=T.stroke,Thickness=1},Main)

local Header=mk("Frame",{Size=UDim2.new(1,0,0,30),BackgroundColor3=T.panel,BorderSizePixel=0},Main)
mk("TextLabel",{Size=UDim2.new(1,-200,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text="FOX-NAME-HUB",TextColor3=T.text,Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},Header)
mk("TextLabel",{Size=UDim2.new(0,140,1,0),Position=UDim2.new(1,-180,0,0),BackgroundTransparency=1,Text="discord.gg/foxhub",TextColor3=T.sub,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Right},Header)
local MinB=mk("TextButton",{Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-56,0,5),BackgroundTransparency=1,Text="−",TextColor3=T.sub,Font=Enum.Font.GothamBold,TextSize=14,AutoButtonColor=false,BorderSizePixel=0},Header)
local CloseB=mk("TextButton",{Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-28,0,5),BackgroundTransparency=1,Text="✕",TextColor3=T.sub,Font=Enum.Font.GothamBold,TextSize=12,AutoButtonColor=false,BorderSizePixel=0},Header)

-- Sidebar
local Sidebar=mk("Frame",{Size=UDim2.new(0,150,1,-30),Position=UDim2.new(0,0,0,30),BackgroundColor3=T.sidebar,BorderSizePixel=0},Main)
mk("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,0,0,0),BackgroundColor3=T.stroke,BorderSizePixel=0},Sidebar)

local SearchBox=mk("Frame",{Size=UDim2.new(1,-16,0,26),Position=UDim2.new(0,8,0,8),BackgroundColor3=T.item,BorderSizePixel=0},Sidebar)
mk("UICorner",{CornerRadius=UDim.new(0,6)},SearchBox)
mk("ImageLabel",{Size=UDim2.fromOffset(14,14),Position=UDim2.new(0,6,0.5,-7),BackgroundTransparency=1,Image="rbxassetid://3926305904",ImageRectOffset=Vector2.new(284,4),ImageRectSize=Vector2.new(24,24),ImageColor3=T.sub},SearchBox)
local SearchInput=mk("TextBox",{Size=UDim2.new(1,-32,1,0),Position=UDim2.new(0,26,0,0),BackgroundTransparency=1,Text="",PlaceholderText="Search...",PlaceholderColor3=T.sub,TextColor3=T.text,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false},SearchBox)

local ItemList=mk("ScrollingFrame",{Size=UDim2.new(1,0,1,-50),Position=UDim2.new(0,0,0,42),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=T.stroke,CanvasSize=UDim2.new(0,0,0,0)},Sidebar)
mk("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},ItemList)
mk("UIPadding",{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingTop=UDim.new(0,4)},ItemList)

-- Content Panel
local ContentPanel=mk("Frame",{Size=UDim2.new(1,-150,1,-30),Position=UDim2.new(0,150,0,30),BackgroundColor3=T.bg,BorderSizePixel=0},Main)
local PageTitle=mk("TextLabel",{Size=UDim2.new(1,-16,0,26),Position=UDim2.new(0,8,0,8),BackgroundTransparency=1,Text="Auto",TextColor3=T.text,Font=Enum.Font.GothamBold,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left},ContentPanel)
mk("Frame",{Size=UDim2.new(1,-16,0,1),Position=UDim2.new(0,8,0,36),BackgroundColor3=T.stroke,BorderSizePixel=0},ContentPanel)
local PageContent=mk("ScrollingFrame",{Size=UDim2.new(1,-16,1,-46),Position=UDim2.new(0,8,0,42),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=T.stroke,CanvasSize=UDim2.new(0,0,0,0)},ContentPanel)
mk("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},PageContent)

-- Status Bar
local StatusBar=mk("Frame",{Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,1,-20),BackgroundColor3=T.panel,BorderSizePixel=0,ZIndex=10},Main)
local StatusLbl=mk("TextLabel",{Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,6,0,0),BackgroundTransparency=1,Text="Ready.",TextColor3=T.ok,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11},StatusBar)
local function setStatus(msg,color)
    pcall(function() StatusLbl.Text=tostring(msg):sub(1,80); StatusLbl.TextColor3=color or T.ok end)
end

-- Menu Items (Nasi Rendang fitur)
local MENU={
    {id="info",     label="Info",      icon="rbxassetid://3926305904", ri=Vector2.new(4,4),   rs=Vector2.new(24,24)},
    {id="auto",     label="Auto",      icon="rbxassetid://3926305904", ri=Vector2.new(244,4), rs=Vector2.new(24,24)},
    {id="farm",     label="Farm",      icon="rbxassetid://3926305904", ri=Vector2.new(124,4), rs=Vector2.new(24,24)},
    {id="rift",     label="Rift",      icon="rbxassetid://3926305904", ri=Vector2.new(204,4), rs=Vector2.new(24,24)},
    {id="visual",   label="Visual",    icon="rbxassetid://3926305904", ri=Vector2.new(364,4), rs=Vector2.new(24,24)},
    {id="utility",  label="Utility",   icon="rbxassetid://3926305904", ri=Vector2.new(84,4),  rs=Vector2.new(24,24)},
    {id="config",   label="Config",    icon="rbxassetid://3926305904", ri=Vector2.new(404,4), rs=Vector2.new(24,24)},
}

local pages={}
local activeId=nil

local function makePage(id)
    local pg=mk("Frame",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,Visible=false},PageContent)
    mk("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},pg)
    return pg
end

local function showPage(id)
    for a,p in pairs(pages) do p.Visible=false end
    if pages[id] then pages[id].Visible=true; PageTitle.Text=id:sub(1,1):upper()..id:sub(2) end
    for _,it in ipairs(MENU) do
        local btn=it._btn
        if btn then
            if it.id==id then btn.BackgroundColor3=T.item; btn.TextColor3=T.text
            else btn.BackgroundColor3=T.sidebar; btn.TextColor3=T.sub end
        end
    end
    activeId=id
end

for _,item in ipairs(MENU) do
    local btn=mk("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=T.sidebar,Text="      "..item.label,TextColor3=T.sub,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,BorderSizePixel=0},ItemList)
    mk("UICorner",{CornerRadius=UDim.new(0,6)},btn)
    mk("ImageLabel",{Size=UDim2.fromOffset(16,16),Position=UDim2.new(0,8,0.5,-8),BackgroundTransparency=1,Image=item.icon,ImageRectOffset=item.ri,ImageRectSize=item.rs,ImageColor3=T.sub},btn)
    item._btn=btn
    btn.MouseButton1Click:Connect(function() showPage(item.id) end)
    pcall(function() btn.TouchTap:Connect(function() showPage(item.id) end) end)
    pages[item.id]=makePage(item.id)
end

-- Components
local function addCategory(pg,txt)
    return mk("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Text=txt,TextColor3=T.sub,Font=Enum.Font.GothamBold,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},pg)
end

local function addRow(pg,txt,value,cb)
    local r=mk("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundColor3=T.panel,Text="",AutoButtonColor=false,BorderSizePixel=0},pg)
    mk("UICorner",{CornerRadius=UDim.new(0,6)},r)
    mk("TextLabel",{Size=UDim2.new(1,-60,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text=txt,TextColor3=T.text,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left},r)
    mk("TextLabel",{Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-28,0.5,-10),BackgroundTransparency=1,Text=value or ">",TextColor3=T.sub,Font=Enum.Font.GothamBold,TextSize=12},r)
    r.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
    pcall(function() r.TouchTap:Connect(function() if cb then pcall(cb) end end) end)
    return r
end

local function addToggleRow(pg,txt,def,cb)
    local r=mk("Frame",{Size=UDim2.new(1,0,0,30),BackgroundColor3=T.panel,BorderSizePixel=0},pg)
    mk("UICorner",{CornerRadius=UDim.new(0,6)},r)
    mk("TextLabel",{Size=UDim2.new(1,-60,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text=txt,TextColor3=T.text,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left},r)
    local sw=mk("TextButton",{Size=UDim2.fromOffset(36,18),Position=UDim2.new(1,-44,0.5,-9),BackgroundColor3=def and T.accentHot or Color3.fromRGB(50,50,60),Text="",AutoButtonColor=false,BorderSizePixel=0},r)
    mk("UICorner",{CornerRadius=UDim.new(1,0)},sw)
    local dot=mk("Frame",{Size=UDim2.fromOffset(14,14),Position=def and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},sw)
    mk("UICorner",{CornerRadius=UDim.new(1,0)},dot)
    local st=def
    local function toggle()
        st=not st
        TS:Create(sw,TweenInfo.new(0.15),{BackgroundColor3=st and T.accentHot or Color3.fromRGB(50,50,60)}):Play()
        TS:Create(dot,TweenInfo.new(0.15),{Position=st and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()
        if cb then pcall(cb,st) end
    end
    sw.MouseButton1Click:Connect(toggle)
    pcall(function() sw.TouchTap:Connect(toggle) end)
    return r
end

local function addSliderRow(pg,txt,mn,mx,def,cb)
    local r=mk("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=T.panel,BorderSizePixel=0},pg)
    mk("UICorner",{CornerRadius=UDim.new(0,6)},r)
    local l=mk("TextLabel",{Size=UDim2.new(1,-16,0,16),Position=UDim2.new(0,10,0,4),BackgroundTransparency=1,Text=txt..": "..def,TextColor3=T.text,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left},r)
    local bg=mk("Frame",{Size=UDim2.new(1,-20,0,6),Position=UDim2.new(0,10,0,28),BackgroundColor3=Color3.fromRGB(45,45,55),BorderSizePixel=0},r)
    mk("UICorner",{CornerRadius=UDim.new(1,0)},bg)
    local fill=mk("Frame",{Size=UDim2.new((def-mn)/(mx-mn),0,1,0),BackgroundColor3=T.accentHot,BorderSizePixel=0},bg)
    mk("UICorner",{CornerRadius=UDim.new(1,0)},fill)
    local knob=mk("Frame",{Size=UDim2.fromOffset(12,12),Position=UDim2.new((def-mn)/(mx-mn),-6,0.5,-6),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},bg)
    mk("UICorner",{CornerRadius=UDim.new(1,0)},knob)
    local dr=false
    local function up(x)
        local p=math.clamp((x-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1)
        fill.Size=UDim2.new(p,0,1,0); knob.Position=UDim2.new(p,-6,0.5,-6)
        local v=math.floor(mn+(mx-mn)*p); l.Text=txt..": "..v
        if cb then pcall(cb,v) end
    end
    bg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true; up(i.Position.X) end end)
    UIS.InputChanged:Connect(function(i) if dr and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then up(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=false end end)
    return r
end

local function addBtnRow(pg,txt,cb,color)
    local r=mk("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundColor3=color or T.accentHot,Text=txt,TextColor3=Color3.fromRGB(10,20,30),Font=Enum.Font.GothamBold,TextSize=11,AutoButtonColor=true,BorderSizePixel=0},pg)
    mk("UICorner",{CornerRadius=UDim.new(0,6)},r)
    r.MouseButton1Click:Connect(function() pcall(cb) end)
    pcall(function() r.TouchTap:Connect(function() pcall(cb) end) end)
    return r
end

-- State
local S={
    AutoSteal=false,AutoPlace=false,AutoHatch=false,AutoFuse=false,AutoSell=false,
    AutoTreadmill=false,AutoUpgrade=false,AutoClaim=false,AutoEquipBest=false,
    FilterRarity="All",FilterMutation="All",MaxDistance=800,
    ESPBox=false,ESPName=false,ESPRarity=false,ESPMutation=false,
    GuardESP=false,PlayerESP=false,Tracer=false,
    AutoHop=false,MaxP=3,
    ManualFly=false,Noclip=false,Walk=60,Jump=120,
    AntiRagdoll=false,AntiAFK=true,
    RiftBossAuto=false,RiftSacrifice=false,
}

-- Remote Resolver (Steal an Egg)
local RC={steal={},place={},hatch={},fuse={},sell={},treadmill={},upgrade={},claim={},equip={},rift={},drones={}}
local function scanRemotes()
    for k in pairs(RC) do RC[k]={} end
    local kws={
        steal={"steal","pickup","collect","grab","take"},
        place={"place","put","deposit"},
        hatch={"hatch","incubate","open"},
        fuse={"fuse","fusion","combine","merge"},
        sell={"sell","shop","trade"},
        treadmill={"treadmill","train","run"},
        upgrade={"upgrade","upg"},
        claim={"claim","reward","collect"},
        equip={"equip","wear"},
        rift={"rift","boss","overlord","sacrifice"},
        drones={"drone","scramble"},
    }
    for _,parent in ipairs({RS,RF,WS}) do
        local ok,desc=pcall(function() return parent:GetDescendants() end)
        if ok then
            for _,v in ipairs(desc) do
                if v.ClassName=="RemoteEvent" or v.ClassName=="RemoteFunction" or v.ClassName=="UnreliableRemoteEvent" then
                    local n=v.Name:lower()
                    for cat,words in pairs(kws) do
                        for _,w in ipairs(words) do
                            if n:find(w) then table.insert(RC[cat],v); break end
                        end
                    end
                end
            end
        end
    end
end
pcall(scanRemotes)

local function fireAll(cat,...)
    local okCount=0
    for _,r in ipairs(RC[cat] or {}) do
        local ok=pcall(function()
            if r.ClassName=="RemoteFunction" then r:InvokeServer(...) else r:FireServer(...) end
        end)
        if ok then okCount=okCount+1 end
    end
    return okCount
end
local function verify(cat) return #(RC[cat] or {})>0 end

-- Egg Detector (Steal an Egg)
local RAR={
    Common=Color3.fromRGB(255,255,255),Uncommon=Color3.fromRGB(80,200,120),
    Rare=Color3.fromRGB(60,140,255),Epic=Color3.fromRGB(170,80,255),
    Legendary=Color3.fromRGB(255,180,40),Mythic=Color3.fromRGB(255,80,120),
    Cosmic=Color3.fromRGB(100,220,255),Secret=Color3.fromRGB(255,0,180),
    Eternal=Color3.fromRGB(255,240,140),Divine=Color3.fromRGB(255,255,255),
}
local HP={"honeypot","bait","decoy","trap","fake","dummy","test"}
local function isHoneypot(v)
    local anc=v; local d=0
    while anc and d<8 do
        local n=anc.Name:lower()
        for _,k in ipairs(HP) do if n:find(k) then return true end end
        anc=anc.Parent; d=d+1
    end
    return false
end
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
local function getEggCF(v)
    if v:IsA("BasePart") then return v.CFrame end
    if v:IsA("Model") and v.PrimaryPart then return v.PrimaryPart.CFrame end
    local p=v:FindFirstChildWhichIsA("BasePart")
    return p and p.CFrame
end
local function rar(v) local r=v:GetAttribute("Rarity"); return RAR[r] and r or "Common" end
local function rarColor(v) return RAR[rar(v)] or RAR.Common end

-- Zone + Validator + Fly
local Zones={}
local function detectZones()
    Zones={}
    local kws={"common","guard","ayam","chicken","neutral","spawn","lobby","safe","safezone"}
    for _,v in ipairs(WS:GetDescendants()) do
        if v:IsA("BasePart") then
            local n=v.Name:lower()
            for _,k in ipairs(kws) do
                if n:find(k) then table.insert(Zones,v); break end
            end
        end
    end
end
pcall(detectZones)

local PS={lastPos=nil,lastTime=0,rubberCount=0,lockUntil=0}
local function checkRubberband()
    if not LP.Character then return end
    local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local cur=hrp.Position
    local now=tick()
    if PS.lastPos and (now-PS.lastTime)<1.0 then
        local dist=(cur-PS.lastPos).Magnitude
        if dist>50 and PS.lastPos.Magnitude>0 then
            PS.rubberCount=PS.rubberCount+1
            if PS.rubberCount>=2 then PS.lockUntil=now+5; PS.rubberCount=0; setStatus("Rubberband. Lock 5s.",T.bad) end
        else PS.rubberCount=math.max(0,PS.rubberCount-0.5) end
    end
    PS.lastPos=cur; PS.lastTime=now
end
local function isLocked() return tick()<PS.lockUntil end

local fBV,fBG
local function startFly()
    if fBV then return end
    local c=LP.Character; if not c then return end
    local h=c:FindFirstChild("HumanoidRootPart"); if not h then return end
    fBV=Instance.new("BodyVelocity",h); fBV.MaxForce=Vector3.new(1e5,1e5,1e5); fBV.Velocity=Vector3.zero
    fBG=Instance.new("BodyGyro",h); fBG.MaxTorque=Vector3.new(1e5,1e5,1e5); fBG.P=1e4
end
local function stopFly() if fBV then fBV:Destroy(); fBV=nil end; if fBG then fBG:Destroy(); fBG=nil end end
local function safeTeleport(targetCF,steps,stepTime)
    steps=steps or 3; stepTime=stepTime or 0.16
    if not LP.Character then return false end
    local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local from=hrp.Position; local to=targetCF.Position
    local waypoints={}
    for i=1,steps do
        local alpha=i/steps
        table.insert(waypoints,CFrame.new(from:Lerp(to,alpha),to))
    end
    for _,wp in ipairs(waypoints) do
        pcall(function() TS:Create(hrp,TweenInfo.new(stepTime,Enum.EasingStyle.Linear),{CFrame=wp}):Play() end)
        task.wait(stepTime+0.02)
    end
    return true
end

-- ============================================================
-- PAGE BUILDS (Nasi Rendang Fitur)
-- ============================================================

-- INFO
do
    local pg=pages.info
    addCategory(pg,"BRAND")
    addRow(pg,"Fox Name Hub","v21")
    addRow(pg,"Style","Nasi Rendang")
    addRow(pg,"Discord","discord.gg/foxhub")
    addCategory(pg,"RUNTIME")
    addRow(pg,"Executor","Delta Mobile")
    addRow(pg,"Game",game.PlaceId.."")
    addRow(pg,"Player",LP.Name)
    addCategory(pg,"STATUS")
    local st=addRow(pg,"Stealth","—")
    local rm=addRow(pg,"Remotes (steal)","—")
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                st.Text=((getrawmetatable and "ON") or "OFF")
                rm.Text=tostring(#RC.steal)
            end)
        end
    end)
end

-- AUTO (Auto Steal, Place, Hatch, Fuse, Sell)
do
    local pg=pages.auto
    addCategory(pg,"AUTO STEAL")
    addToggleRow(pg,"Auto Steal",false,function(v) S.AutoSteal=v end)
    addToggleRow(pg,"Auto Place",false,function(v) S.AutoPlace=v end)
    addToggleRow(pg,"Auto Hatch",false,function(v) S.AutoHatch=v end)
    addToggleRow(pg,"Auto Fuse",false,function(v) S.AutoFuse=v end)
    addToggleRow(pg,"Auto Sell",false,function(v) S.AutoSell=v end)
    addCategory(pg,"FILTER")
    addSliderRow(pg,"Max Distance",100,3000,800,function(v) S.MaxDistance=v end)
    addBtnRow(pg,"Rescan Remotes",function()
        pcall(scanRemotes)
        setStatus("Rescan: "..#RC.steal.." steal remotes",T.ok)
    end)
end

-- FARM (Treadmill, Upgrade, Claim)
do
    local pg=pages.farm
    addCategory(pg,"TREADMILL")
    addToggleRow(pg,"Auto Treadmill",false,function(v) S.AutoTreadmill=v end)
    addToggleRow(pg,"Auto Upgrade",false,function(v) S.AutoUpgrade=v end)
    addCategory(pg,"CLAIM")
    addToggleRow(pg,"Auto Claim",false,function(v) S.AutoClaim=v end)
    addToggleRow(pg,"Auto Equip Best",false,function(v) S.AutoEquipBest=v end)
end

-- RIFT (Boss, Sacrifice)
do
    local pg=pages.rift
    addCategory(pg,"RIFT EVENT")
    addToggleRow(pg,"Auto Rift Boss",false,function(v) S.RiftBossAuto=v end)
    addToggleRow(pg,"Auto Sacrifice",false,function(v) S.RiftSacrifice=v end)
    addCategory(pg,"INFO")
    addRow(pg,"Rift Timer","30 min")
    addRow(pg,"Boss Tokens","—")
end

-- VISUAL (ESP)
do
    local pg=pages.visual
    addCategory(pg,"EGG ESP")
    addToggleRow(pg,"Egg ESP Box",false,function(v) S.ESPBox=v end)
    addToggleRow(pg,"Egg ESP Name",false,function(v) S.ESPName=v end)
    addToggleRow(pg,"Egg ESP Rarity",false,function(v) S.ESPRarity=v end)
    addToggleRow(pg,"Egg ESP Mutation",false,function(v) S.ESPMutation=v end)
    addCategory(pg,"OTHER ESP")
    addToggleRow(pg,"Guard ESP",false,function(v) S.GuardESP=v end)
    addToggleRow(pg,"Player ESP",false,function(v) S.PlayerESP=v end)
    addToggleRow(pg,"Tracer",false,function(v) S.Tracer=v end)
end

-- UTILITY (Server Hop, Fly, Noclip)
do
    local pg=pages.utility
    addCategory(pg,"MOVEMENT")
    addToggleRow(pg,"Manual Fly",false,function(v) S.ManualFly=v end)
    addToggleRow(pg,"Noclip",false,function(v) S.Noclip=v end)
    addSliderRow(pg,"WalkSpeed",16,300,60,function(v)
        S.Walk=v
        local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed=v end
    end)
    addSliderRow(pg,"JumpPower",50,400,120,function(v)
        S.Jump=v
        local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.UseJumpPower=true; h.JumpPower=v end
    end)
    addCategory(pg,"SAFETY")
    addToggleRow(pg,"Anti Ragdoll",false,function(v) S.AntiRagdoll=v end)
    addToggleRow(pg,"Anti AFK",true,function(v) S.AntiAFK=v end)
    addCategory(pg,"SERVER")
    addToggleRow(pg,"Auto Server Hop",false,function(v) S.AutoHop=v end)
    addSliderRow(pg,"Max Player",1,30,3,function(v) S.MaxP=v end)
    addBtnRow(pg,"Cari Server Sepi",function()
        local rq=(syn and syn.request) or (http and http.request) or http_request or request
        if not rq then setStatus("HTTP not available",T.bad); return end
        pcall(function()
            local r=rq({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
            local d=HS:JSONDecode(r.Body)
            for _,s in ipairs(d.data) do
                if s.playing<=S.MaxP and s.id~=game.JobId then
                    getgenv().FOX_AllowHop=true
                    TPS:TeleportToPlaceInstance(game.PlaceId,s.id,LP)
                    return
                end
            end
        end)
    end)
end

-- CONFIG
do
    local pg=pages.config
    addCategory(pg,"STATE")
    addToggleRow(pg,"Auto Steal",false,function(v) S.AutoSteal=v end)
    addToggleRow(pg,"Safe Route",true,function(v) S.SafeRoute=v end)
    addCategory(pg,"FILE")
    addBtnRow(pg,"Save Config",function()
        pcall(function() if writefile then writefile("Fox21_Cfg.json",HS:JSONEncode(S)) end end)
        setStatus("Saved.",T.ok)
    end)
    addBtnRow(pg,"Load Config",function()
        pcall(function()
            if readfile and isfile and isfile("Fox21_Cfg.json") then
                local d=HS:JSONDecode(readfile("Fox21_Cfg.json"))
                for k,v in pairs(d) do S[k]=v end
                setStatus("Loaded.",T.ok)
            end
        end)
    end)
    addCategory(pg,"UTILITY")
    addBtnRow(pg,"Rescan All",function()
        pcall(scanRemotes); pcall(detectZones)
        setStatus("Rescan done.",T.ok)
    end)
    addBtnRow(pg,"Force Rebuild GUI",function()
        if getgenv().FOX_GUI then getgenv().FOX_GUI:Destroy() end
        getgenv().FOX_GUI=nil
    end,T.bad)
end

showPage("auto")

-- Drag + Minimize
local drag=false; local dS,dP
Header.InputBegan:Connect(function(i)
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

local minimized=false
local function toggleMin()
    minimized=not minimized
    Sidebar.Visible=not minimized
    ContentPanel.Visible=not minimized
    StatusBar.Visible=not minimized
    Main.Size=minimized and UDim2.fromOffset(620,30) or UDim2.fromOffset(620,400)
end
MinB.MouseButton1Click:Connect(toggleMin)
pcall(function() MinB.TouchTap:Connect(toggleMin) end)

-- Key Gate
local KEYS={["fox"]=true,["Fox"]=true,["FOX"]=true,["joy"]=true,["Joy"]=true,["JOY"]=true,["1234"]=true,["1"]=true,["bazz"]=true,["steal"]=true,["egg"]=true,["ajjans"]=true}
local vf=false
local function doV()
    if vf then return end
    local i=tostring(KI.Text or ""):gsub("%s+","")
    if KEYS[i] then
        vf=true; KeyF.Visible=false; Main.Visible=true
        setStatus("Verified. Fox v21 active.",T.ok)
    else
        KI.Text=""; KeyStatus.Text="Key salah."; KeyStatus.TextColor3=T.bad
    end
end
SB.MouseButton1Click:Connect(doV)
pcall(function() SB.TouchTap:Connect(doV) end)
pcall(function() KI.FocusLost:Connect(function(e) if e then doV() end end) end)

local function closeGUI()
    if getgenv().FOX_GUI then getgenv().FOX_GUI:Destroy() end
    getgenv().FOX_GUI=nil
end
CloseB.MouseButton1Click:Connect(closeGUI)
pcall(function() CloseB.TouchTap:Connect(closeGUI) end)

-- ============================================================
-- LOOPS (Auto Steal, Auto Place, Auto Hatch, Auto Fuse, Auto Sell, Treadmill)
-- ============================================================
local ASR=false
local function autoStealStep()
    if isLocked() or not ASR then return end
    if not verify("steal") then
        setStatus("No steal remote.",T.bad)
        S.AutoSteal=false
        return
    end
    local eggs={}
    for _,v in ipairs(WS:GetDescendants()) do
        if isEgg(v) then
            local p=v:IsA("BasePart") and v.Position or (v.PrimaryPart and v.PrimaryPart.Position)
            if p and LP.Character then
                local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (p-hrp.Position).Magnitude<S.MaxDistance then table.insert(eggs,v) end
            end
        end
    end
    if #eggs==0 then return end
    local target=eggs[1]
    local tcf=getEggCF(target)
    if not tcf then return end
    startFly()
    safeTeleport(tcf,3,0.16)
    fireAll("steal",target)
    if not S.ManualFly then task.wait(0.1); stopFly() end
end

task.spawn(function()
    while task.wait(0.32+math.random()*0.28) do
        checkRubberband()
        if S.AutoSteal and not isLocked() then
            ASR=true
            pcall(autoStealStep)
        else
            ASR=false
            if not S.ManualFly and fBV then stopFly() end
        end
    end
end)

-- Auto Place / Hatch / Fuse / Sell
task.spawn(function()
    while task.wait(3) do
        if S.AutoPlace and verify("place") then fireAll("place") end
        if S.AutoHatch and verify("hatch") then fireAll("hatch") end
        if S.AutoFuse and verify("fuse") then fireAll("fuse") end
        if S.AutoSell and verify("sell") then fireAll("sell") end
    end
end)

-- Treadmill / Upgrade / Claim
task.spawn(function()
    while task.wait(5) do
        if S.AutoTreadmill and verify("treadmill") then fireAll("treadmill") end
        if S.AutoUpgrade and verify("upgrade") then fireAll("upgrade") end
        if S.AutoClaim and verify("claim") then fireAll("claim") end
    end
end)

-- Manual Fly
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
        elseif not S.AutoSteal and fBV then stopFly() end
    end
end)

-- Noclip
task.spawn(function()
    while task.wait(0.15) do
        if S.Noclip then
            local c=LP.Character
            if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide=false end end end
        end
    end
end)

-- Anti Ragdoll
task.spawn(function()
    while task.wait(0.5) do
        if S.AntiRagdoll then
            local c=LP.Character
            if c then
                local h=c:FindFirstChildOfClass("Humanoid")
                if h then h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false); h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false) end
            end
        end
    end
end)

-- ESP
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
                            if LP.Character then
                                local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then tx=tx.."\n"..math.floor((t.Position-hrp.Position).Magnitude).." studs" end
                            end
                            l.Text=tx
                        end
                    end
                end
            end
        end
    end
end)

-- Refresh
task.spawn(function() while task.wait(30) do pcall(detectZones); pcall(scanRemotes) end end)

-- Teleport Guard
pcall(function()
    local o=TPS.TeleportToPlaceInstance
    getgenv().FOX_AllowHop=false
    if hookfunction then
        hookfunction(o,function(self,...)
            if getgenv().FOX_AllowHop then getgenv().FOX_AllowHop=false; return o(self,...) end
            return
        end)
    end
end)

print("[FOX v21] Loaded. Key: fox")
pcall(function() SG:SetCore("SendNotification",{Title="FOX NAME HUB v21",Text="Ready. Key: fox",Duration=4}) end)
setStatus("Loaded. Key: fox",T.ok)
