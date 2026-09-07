-- CSS JAVA GUI — FIXED SMOOTH STAMINA, JUMP & NOCLIP
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
    local old = playerGui:FindFirstChild("CSSJavaHub")
    if old then old:Destroy() end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CSSJavaHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local C = {
    bg = Color3.fromRGB(5,3,12),
    bgPanel = Color3.fromRGB(9,6,20),
    bgNav = Color3.fromRGB(7,4,18),
    topBar = Color3.fromRGB(11,7,26),
    accent = Color3.fromRGB(150,65,255),
    accentBright = Color3.fromRGB(200,120,255),
    accentDim = Color3.fromRGB(80,30,160),
    accentGlow = Color3.fromRGB(220,170,255),
    text = Color3.fromRGB(230,205,255),
    textDim = Color3.fromRGB(160,130,210),
    textFaint = Color3.fromRGB(90,65,140),
    green = Color3.fromRGB(80,255,140),
    red = Color3.fromRGB(255,80,110),
    tabActive = Color3.fromRGB(35,12,75),
    tabIdle = Color3.fromRGB(16,9,38),
}

local function tw(obj, props, dur, style, dir)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            dur or 0.25,
            style or Enum.EasingStyle.Quart,
            dir or Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C.accent
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function newFrame(parent, size, pos, color, transparency, zindex)
    local f = Instance.new("Frame")
    f.Size = size or UDim2.new(1,0,1,0)
    f.Position = pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3 = color or C.bgPanel
    f.BackgroundTransparency = transparency or 0
    f.BorderSizePixel = 0
    f.ZIndex = zindex or 2
    f.Parent = parent
    return f
end

local function newLabel(parent, text, size, pos, color, textsize, font, zindex, align)
    local l = Instance.new("TextLabel")
    l.Size = size or UDim2.new(1,0,1,0)
    l.Position = pos or UDim2.new(0,0,0,0)
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextColor3 = color or C.text
    l.TextSize = textsize or 12
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.ZIndex = zindex or 3
    l.Parent = parent
    return l
end

-- Background particles
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1,0,1,0)
particleContainer.BackgroundTransparency = 1
particleContainer.ZIndex = 1
particleContainer.ClipsDescendants = true
particleContainer.Parent = screenGui

local particles = {}
for i = 1, 18 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0,math.random(2,4),0,math.random(2,4))
    p.Position = UDim2.new(math.random(),0,math.random(),0)
    p.BackgroundColor3 = Color3.fromHSV(0.72 + math.random()*0.08, 0.6+math.random()*0.3, 1)
    p.BackgroundTransparency = 0.3 + math.random()*0.5
    p.BorderSizePixel = 0
    p.ZIndex = 1
    p.Parent = particleContainer
    corner(p,99)
    particles[i] = {
        frame=p,
        speedX=(math.random()-0.5)*0.0004,
        speedY=-(0.00015+math.random()*0.0003)
    }
end

local menuOpen = false
RunService.Heartbeat:Connect(function()
    if not menuOpen then return end
    for _,pt in ipairs(particles) do
        local f = pt.frame
        local cx = f.Position.X.Scale + pt.speedX
        local cy = f.Position.Y.Scale + pt.speedY
        if cy < -0.02 then cy = 1.02 end
        if cx < -0.02 then cx = 1.02 end
        if cx > 1.02 then cx = -0.02 end
        f.Position = UDim2.new(cx,0,cy,0)
    end
end)

-- Open button
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0,52,0,52)
openButton.Position = UDim2.new(1,-68,0.5,-26)
openButton.BackgroundColor3 = Color3.fromRGB(10,6,24)
openButton.Text = ""
openButton.AutoButtonColor = false
openButton.ZIndex = 20
openButton.Parent = screenGui
corner(openButton,15)
local openStroke = stroke(openButton,C.accent,1.5)

local openGrad = Instance.new("UIGradient")
openGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(20,10,45)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(8,4,18))
})
openGrad.Rotation = 135
openGrad.Parent = openButton

local function buildCrosshair(parent,zindex)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0,32,0,32)
    container.Position = UDim2.new(0.5,-16,0.5,-16)
    container.BackgroundTransparency = 1
    container.ZIndex = zindex or 21
    container.Parent = parent

    local ring = Instance.new("Frame")
    ring.Size = UDim2.new(1,0,1,0)
    ring.BackgroundTransparency = 1
    ring.ZIndex = zindex or 21
    ring.Parent = container
    corner(ring,99)
    stroke(ring,C.accentBright,2)

    local innerRing = Instance.new("Frame")
    innerRing.Size = UDim2.new(0,14,0,14)
    innerRing.Position = UDim2.new(0.5,-7,0.5,-7)
    innerRing.BackgroundTransparency = 1
    innerRing.ZIndex = (zindex or 21)+1
    innerRing.Parent = container
    corner(innerRing,99)
    stroke(innerRing,C.accentDim,1)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0,5,0,5)
    dot.Position = UDim2.new(0.5,-2.5,0.5,-2.5)
    dot.BackgroundColor3 = C.accentBright
    dot.BorderSizePixel = 0
    dot.ZIndex = (zindex or 21)+2
    dot.Parent = container
    corner(dot,99)

    local lines = {
        {w=2,h=7,x=-1,y=-16},
        {w=2,h=7,x=-1,y=9},
        {w=7,h=2,x=-16,y=-1},
        {w=7,h=2,x=9,y=-1}
    }

    for _,ld in ipairs(lines) do
        local l = Instance.new("Frame")
        l.Size = UDim2.new(0,ld.w,0,ld.h)
        l.Position = UDim2.new(0.5,ld.x,0.5,ld.y)
        l.BackgroundColor3 = C.accentBright
        l.BorderSizePixel = 0
        l.ZIndex = (zindex or 21)+1
        l.Parent = container
        corner(l,1)
    end

    return container
end

local crosshairIcon = buildCrosshair(openButton,21)

local crossAngle = 0
RunService.Heartbeat:Connect(function()
    crossAngle = (crossAngle + 0.6) % 360
    if crosshairIcon.Parent then
        crosshairIcon.Rotation = crossAngle
    end
end)

-- Button dragging
local btnDrag,btnDragStart,btnStartPos,btnMoved=false,nil,nil,false

openButton.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        btnDrag=true
        btnMoved=false
        btnDragStart=inp.Position
        btnStartPos=openButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if btnDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local d=inp.Position-btnDragStart
        if math.abs(d.X)>5 or math.abs(d.Y)>5 then btnMoved=true end
        openButton.Position=UDim2.new(
            btnStartPos.X.Scale,btnStartPos.X.Offset+d.X,
            btnStartPos.Y.Scale,btnStartPos.Y.Offset+d.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        btnDrag=false
    end
end)

-- Main window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0,520,0,305)
mainFrame.Position = UDim2.new(0.5,-260,0,58)
mainFrame.BackgroundColor3 = C.bg
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 3
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
corner(mainFrame,16)

local mainStroke = stroke(mainFrame,C.accent,1.5)

local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(10,6,24)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(6,3,14)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(12,5,22))
})
mainGrad.Rotation=120
mainGrad.Parent=mainFrame

-- Header
local topBar=newFrame(mainFrame,UDim2.new(1,0,0,46),UDim2.new(0,0,0,0),C.topBar,0.05,4)
corner(topBar,16)
local topFix=newFrame(topBar,UDim2.new(1,0,0,16),UDim2.new(0,0,1,-16),C.topBar,0.05,4)

local topGrad=Instance.new("UIGradient")
topGrad.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(18,10,42)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(8,5,20))
})
topGrad.Rotation=90
topGrad.Parent=topBar

local divLine=newFrame(topBar,UDim2.new(1,0,0,1),UDim2.new(0,0,1,0),C.accent,0,5)
local lineBlick=newFrame(divLine,UDim2.new(0,100,1,0),UDim2.new(-0.2,0,0,0),C.accentGlow,0.2,6)
corner(lineBlick,4)

local logoLabel=newLabel(
    topBar,"CSS  JAVA",
    UDim2.new(0,180,1,0),UDim2.new(0.5,-90,0,0),
    C.text,16,Enum.Font.GothamBlack,5,Enum.TextXAlignment.Center
)

local statusDot=newLabel(topBar,"●",UDim2.new(0,12,0,14),UDim2.new(0.5,-6,1,-17),C.green,8,Enum.Font.GothamBold,5,Enum.TextXAlignment.Center)
local statusTxt=newLabel(topBar,"ACTIVE",UDim2.new(0,60,0,14),UDim2.new(0.5,6,1,-17),C.green,8,Enum.Font.GothamBold,5,Enum.TextXAlignment.Left)

newLabel(topBar,"v2.1",UDim2.new(0,40,1,0),UDim2.new(1,-90,0,0),C.textFaint,9,Enum.Font.GothamMedium,5,Enum.TextXAlignment.Right)

local closeBtn=Instance.new("TextButton")
closeBtn.Size=UDim2.new(0,30,0,30)
closeBtn.Position=UDim2.new(1,-40,0.5,-15)
closeBtn.BackgroundColor3=Color3.fromRGB(55,12,90)
closeBtn.BackgroundTransparency=0.3
closeBtn.Text=""
closeBtn.AutoButtonColor=false
closeBtn.ZIndex=6
closeBtn.Parent=topBar
corner(closeBtn,9)
stroke(closeBtn,C.accentDim,1)

local function makeLine45(parent,rot)
    local l=newFrame(parent,UDim2.new(0,15,0,2),UDim2.new(0.5,-7.5,0.5,-1),Color3.fromRGB(210,150,255),0,7)
    l.Rotation=rot
    corner(l,1)
    return l
end

local cl1=makeLine45(closeBtn,45)
local cl2=makeLine45(closeBtn,-45)

-- Navigation
local navPanel=Instance.new("ScrollingFrame")
navPanel.Size=UDim2.new(0,138,1,-56)
navPanel.Position=UDim2.new(0,8,0,52)
navPanel.BackgroundColor3=C.bgNav
navPanel.BackgroundTransparency=0.25
navPanel.BorderSizePixel=0
navPanel.CanvasSize=UDim2.new(0,0,0,0)
navPanel.ScrollBarThickness=2
navPanel.ScrollBarImageColor3=C.accent
navPanel.ZIndex=4
navPanel.Parent=mainFrame
corner(navPanel,12)
stroke(navPanel,C.accentDim,1)

newLabel(navPanel,"НАВИГАЦИЯ",UDim2.new(1,-10,0,20),UDim2.new(0,5,0,6),C.textFaint,8,Enum.Font.GothamBold,5,Enum.TextXAlignment.Center)
newFrame(navPanel,UDim2.new(1,-20,0,1),UDim2.new(0,10,0,28),C.accentDim,0.4,5)

-- Content Container
local contentPanel=newFrame(mainFrame,UDim2.new(1,-160,1,-56),UDim2.new(0,152,0,52),C.bgPanel,0.2,4)
corner(contentPanel,12)
stroke(contentPanel,C.accentDim,1)

local contentGrad=Instance.new("UIGradient")
contentGrad.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(12,7,28)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(7,4,18))
})
contentGrad.Rotation=145
contentGrad.Parent=contentPanel

local function clearContent()
    for _, child in ipairs(contentPanel:GetChildren()) do
        if child ~= contentGrad and child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

-- =========================================================================
-- ЛОГИКА ПЛАВНЫХ ЧИТ-ФУНКЦИЙ (SPEED, STAMINA, JUMP, NOCLIP)
-- =========================================================================
local speedEnabled = false
local staminaEnabled = false
local highJumpEnabled = false
local noclipEnabled = false

RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- 1. Спидхак (плавная фиксация скорости)
    if hum then
        if speedEnabled then
            hum.WalkSpeed = 30
        elseif hum.WalkSpeed == 30 then
            hum.WalkSpeed = 16
        end

        -- 2. Высокий прыжок (плавная фиксация высоты)
        if highJumpEnabled then
            hum.JumpPower = 75
        elseif hum.JumpPower == 75 then
            hum.JumpPower = 50
        end
    end

    -- 3. Бесконечная стамина (без рывков удерживаем максимум в памяти)
    if staminaEnabled then
        pcall(function()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("NumberValue") or v:IsA("IntValue") then
                    local name = v.Name:lower()
                    if name:find("stamina") or name:find("energy") or name:find("fatigue") or name:find("power") then
                        v.Value = 100
                    end
                end
            end
            if player:FindFirstChild("Data") then
                for _, v in pairs(player.Data:GetChildren()) do
                    if (v.Name:lower():find("stamina") or v.Name:lower():find("energy")) and (v:IsA("NumberValue") or v:IsA("IntValue")) then
                        v.Value = 100
                    end
                end
            end
        end)
    end

    -- 4. Noclip (плавное отключение коллизий без телепортации)
    if noclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Рендер вкладки "Misc"
local function loadMiscTab()
    clearContent()
    
    newLabel(contentPanel, "Дополнительные функции (Misc)", UDim2.new(1,-20,0,25), UDim2.new(0,12,0,10), C.text, 13, Enum.Font.GothamBold, 5, Enum.TextXAlignment.Left)
    
    local function createToggle(name, yPos, getState, setState)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 210, 0, 32)
        btn.Position = UDim2.new(0, 12, 0, yPos)
        btn.BackgroundColor3 = getState() and C.accent or Color3.fromRGB(20, 12, 40)
        btn.Text = name .. (getState() and " [ON]" or " [OFF]")
        btn.TextColor3 = C.text
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamMedium
        btn.ZIndex = 5
        btn.Parent = contentPanel
        corner(btn, 8)
        stroke(btn, C.accentDim, 1)

        btn.MouseButton1Click:Connect(function()
            setState(not getState())
            btn.BackgroundColor3 = getState() and C.accent or Color3.fromRGB(20, 12, 40)
            btn.Text = name .. (getState() and " [ON]" or " [OFF]")
        end)
    end

    createToggle("Спидхак (30)", 42, function() return speedEnabled end, function(v) speedEnabled = v end)
    createToggle("Бесконечная стамина", 80, function() return staminaEnabled end, function(v) staminaEnabled = v end)
    createToggle("Высокий прыжок", 118, function() return highJumpEnabled end, function(v) highJumpEnabled = v end)
    createToggle("Noclip (Сквозь стены)", 156, function() return noclipEnabled end, function(v) noclipEnabled = v end)
end

-- Заглушка для остальных вкладок
local function loadDefaultTab(name, icon, desc)
    clearContent()
    newLabel(contentPanel,icon,UDim2.new(1,0,0,40),UDim2.new(0,0,0.3,0),C.accentDim,28,Enum.Font.GothamBold,5,Enum.TextXAlignment.Center)
    newLabel(contentPanel,name,UDim2.new(1,0,0,24),UDim2.new(0,0,0.48,0),C.text,13,Enum.Font.GothamBold,5,Enum.TextXAlignment.Center)
    newLabel(contentPanel,desc,UDim2.new(1,0,0,18),UDim2.new(0,0,0.56,0),C.textDim,10,Enum.Font.Gotham,5,Enum.TextXAlignment.Center)
end

-- Status bar
local statusBar=newFrame(mainFrame,UDim2.new(1,-160,0,14),UDim2.new(0,152,1,-20),C.bgPanel,0.5,4)
corner(statusBar,5)
local sbText=newLabel(statusBar,"CSS JAVA  |  Готов к работе  |  X Delta",UDim2.new(1,-10,1,0),UDim2.new(0,8,0,0),C.textFaint,8,Enum.Font.Gotham,5,Enum.TextXAlignment.Left)

-- Tabs
local tabData={
    {name="Главная",icon="⌂",desc="Главный раздел управления"},
    {name="Aimbot",icon="⊕",desc="Настройки точного прицела"},
    {name="Visuals",icon="◉",desc="Визуальные эффекты и ESP"},
    {name="Players",icon="⊞",desc="Список игроков на сервере"},
    {name="Misc",icon="≡",desc="Дополнительные функции", isMisc=true},
    {name="Skins",icon="◈",desc="Менеджер скинов и оружия"},
    {name="Config",icon="⊙",desc="Сохранение и загрузка конфигов"},
}

local yOff=36
local allTabs={}
local activeTab=nil

for idx,data in ipairs(tabData) do
    local tabBtn=Instance.new("TextButton")
    tabBtn.Size=UDim2.new(1,-14,0,32)
    tabBtn.Position=UDim2.new(0,7,0,yOff)
    tabBtn.BackgroundColor3=C.tabIdle
    tabBtn.BackgroundTransparency=0.25
    tabBtn.Text=""
    tabBtn.AutoButtonColor=false
    tabBtn.ZIndex=5
    tabBtn.Parent=navPanel
    corner(tabBtn,9)

    local tabStroke=stroke(tabBtn,C.accentDim,1,0.6)
    local tbGrad=Instance.new("UIGradient")
    tbGrad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(28,14,60)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(14,7,32))
    })
    tbGrad.Rotation=90
    tbGrad.Parent=tabBtn

    local acBar=newFrame(tabBtn,UDim2.new(0,3,0,16),UDim2.new(0,4,0.5,-8),C.accent,0.6,6)
    corner(acBar,2)

    local iconL=newLabel(tabBtn,data.icon,UDim2.new(0,22,1,0),UDim2.new(0,11,0,0),C.accentDim,14,Enum.Font.GothamBold,6,Enum.TextXAlignment.Center)
    local nameL=newLabel(tabBtn,data.name,UDim2.new(1,-38,1,0),UDim2.new(0,36,0,0),C.textDim,11,Enum.Font.GothamMedium,6,Enum.TextXAlignment.Left)
    local numL=newLabel(tabBtn,("0%d"):format(idx),UDim2.new(0,20,1,0),UDim2.new(1,-22,0,0),C.textFaint,8,Enum.Font.GothamMedium,6,Enum.TextXAlignment.Right)

    local tabInfo={btn=tabBtn,bar=acBar,stroke=tabStroke,lbl=nameL,icon=iconL,num=numL}
    table.insert(allTabs,tabInfo)

    tabBtn.MouseButton1Click:Connect(function()
        if activeTab==tabBtn then return end
        activeTab=tabBtn

        for _,t in ipairs(allTabs) do
            tw(t.btn,{BackgroundColor3=C.tabIdle,BackgroundTransparency=0.25},0.2)
            tw(t.bar,{BackgroundTransparency=0.6,BackgroundColor3=C.accent},0.2)
            tw(t.stroke,{Transparency=0.6,Color=C.accentDim},0.2)
            tw(t.lbl,{TextColor3=C.textDim},0.2)
            tw(t.icon,{TextColor3=C.accentDim},0.2)
            tw(t.num,{TextColor3=C.textFaint},0.2)
        end

        tw(tabBtn,{BackgroundColor3=C.tabActive,BackgroundTransparency=0},0.2)
        tw(acBar,{BackgroundTransparency=0,BackgroundColor3=C.accentBright},0.2)
        tw(tabStroke,{Transparency=0,Color=C.accent},0.2)
        tw(nameL,{TextColor3=C.text},0.2)
        tw(iconL,{TextColor3=C.accentBright},0.2)
        tw(numL,{TextColor3=C.accent},0.2)

        if data.isMisc then
            loadMiscTab()
        else
            loadDefaultTab(data.name, data.icon, data.desc)
        end
    end)

    yOff=yOff+38
end

navPanel.CanvasSize=UDim2.new(0,0,0,yOff+10)

-- Open / close
local isOpen=false
openButton.MouseButton1Click:Connect(function()
    if btnMoved then btnMoved=false return end
    isOpen = not isOpen
    menuOpen = isOpen
    mainFrame.Visible = isOpen
end)

closeBtn.MouseButton1Click:Connect(function()
    isOpen = false
    menuOpen = false
    mainFrame.Visible = false
end)

-- Window dragging
local drag,dragStart2,startPos2=false,nil,nil
topBar.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        drag=true
        dragStart2=inp.Position
        startPos2=mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if drag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local d=inp.Position-dragStart2
        mainFrame.Position=UDim2.new(startPos2.X.Scale,startPos2.X.Offset+d.X,startPos2.Y.Scale,startPos2.Y.Offset+d.Y)
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        drag=false
    end
end)

mainFrame.Visible=false
