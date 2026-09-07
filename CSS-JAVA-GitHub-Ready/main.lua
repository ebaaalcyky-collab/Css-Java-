-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
    if playerGui:FindFirstChild("CSSJavaHub") then
        playerGui.CSSJavaHub:Destroy()
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CSSJavaHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ════════════════════════════════
-- УТИЛИТЫ АНИМАЦИИ
-- ════════════════════════════════
local function tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.25,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function fadeIn(frame, duration)
    frame.BackgroundTransparency = 1
    frame.Visible = true
    tween(frame, {BackgroundTransparency = frame:GetAttribute("BaseTransparency") or 0.3}, duration or 0.3)
end

-- ════════════════════════════════
-- КНОПКА ОТКРЫТИЯ
-- ════════════════════════════════
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 45, 0, 45)
openButton.Position = UDim2.new(1, -58, 0.5, -22)
openButton.BackgroundColor3 = Color3.fromRGB(8, 6, 18)
openButton.Text = "⚡"
openButton.TextColor3 = Color3.fromRGB(185, 130, 255)
openButton.TextSize = 20
openButton.Font = Enum.Font.GothamBold
openButton.ZIndex = 10
openButton.Parent = screenGui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0, 10)

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(160, 80, 255)
openStroke.Thickness = 1.5
openStroke.Parent = openButton

-- Пульсация обводки кнопки
local pulseUp = true
task.spawn(function()
    while openButton and openButton.Parent do
        local target = pulseUp and 2.5 or 1.5
        tween(openStroke, {Thickness = target}, 0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        pulseUp = not pulseUp
        task.wait(0.9)
    end
end)

-- Hover-эффект кнопки открытия
openButton.MouseEnter:Connect(function()
    tween(openButton, {BackgroundColor3 = Color3.fromRGB(30, 15, 60)}, 0.2)
    tween(openStroke, {Color = Color3.fromRGB(210, 130, 255)}, 0.2)
end)
openButton.MouseLeave:Connect(function()
    tween(openButton, {BackgroundColor3 = Color3.fromRGB(8, 6, 18)}, 0.2)
    tween(openStroke, {Color = Color3.fromRGB(160, 80, 255)}, 0.2)
end)

-- ════════════════════════════════
-- ГЛАВНОЕ ОКНО
-- ════════════════════════════════
local mainFrame = Instance.new("ImageLabel")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 300)
mainFrame.Position = UDim2.new(0.5, -260, 0, 55)
mainFrame.BackgroundColor3 = Color3.fromRGB(6, 4, 14)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ImageTransparency = 0.35
mainFrame.ScaleType = Enum.ScaleType.Crop
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(140, 60, 255)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Анимация обводки окна (цвет переливается)
local strokeHue = 0
task.spawn(function()
    while mainFrame and mainFrame.Parent do
        strokeHue = (strokeHue + 1) % 360
        local r, g, b = Color3.fromHSV(strokeHue/360, 0.7, 1):components()
        -- плавный фиолетово-синий диапазон (не весь спектр)
        local hue = 0.65 + math.sin(tick() * 0.5) * 0.08
        mainStroke.Color = Color3.fromHSV(hue, 0.75, 1)
        task.wait(0.05)
    end
end)

-- Загрузка фона
local function loadGitHubBackground(imageLabel, filePath)
    local url = string.format("https://raw.githubusercontent.com/ebaaalcyky-collab/Css-Java/main/CSS-JAVA-GitHub-Ready/%s", filePath)
    local success, result = pcall(function() return game:HttpGet(url) end)
    if success and result then
        local ok = pcall(function() writefile("css_java_bg_cache.png", result) end)
        if ok then
            local fn = getcustomasset or getsynasset
            if fn then imageLabel.Image = fn("css_java_bg_cache.png") end
        end
    end
end
task.spawn(function() loadGitHubBackground(mainFrame, "assets/background/eye.png") end)

-- ════════════════════════════════
-- ШАПКА
-- ════════════════════════════════
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 44)
topBar.BackgroundColor3 = Color3.fromRGB(10, 6, 24)
topBar.BackgroundTransparency = 0.1
topBar.BorderSizePixel = 0
topBar.ZIndex = 3
topBar.Parent = mainFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)

local topBarFix = Instance.new("Frame")
topBarFix.Size = UDim2.new(1, 0, 0, 14)
topBarFix.Position = UDim2.new(0, 0, 1, -14)
topBarFix.BackgroundColor3 = Color3.fromRGB(10, 6, 24)
topBarFix.BackgroundTransparency = 0.1
topBarFix.BorderSizePixel = 0
topBarFix.ZIndex = 3
topBarFix.Parent = topBar

local topBarLine = Instance.new("Frame")
topBarLine.Size = UDim2.new(1, 0, 0, 1)
topBarLine.Position = UDim2.new(0, 0, 1, 0)
topBarLine.BackgroundColor3 = Color3.fromRGB(150, 70, 255)
topBarLine.BorderSizePixel = 0
topBarLine.ZIndex = 4
topBarLine.Parent = topBar

-- Анимация линии (бегущий свет)
local lineGlow = Instance.new("Frame")
lineGlow.Size = UDim2.new(0, 80, 1, 0)
lineGlow.Position = UDim2.new(-0.2, 0, 0, 0)
lineGlow.BackgroundColor3 = Color3.fromRGB(220, 160, 255)
lineGlow.BackgroundTransparency = 0.3
lineGlow.BorderSizePixel = 0
lineGlow.ZIndex = 5
lineGlow.Parent = topBarLine
Instance.new("UICorner", lineGlow).CornerRadius = UDim.new(0, 4)

task.spawn(function()
    while lineGlow and lineGlow.Parent do
        lineGlow.Position = UDim2.new(-0.15, 0, 0, 0)
        tween(lineGlow, {Position = UDim2.new(1.15, 0, 0, 0)}, 2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.5)
    end
end)

-- Точки-декор
for i, color in ipairs({Color3.fromRGB(180,80,255), Color3.fromRGB(100,40,180), Color3.fromRGB(60,20,120)}) do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 8 + (i-1)*14, 0.5, -4)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.ZIndex = 4
    dot.Parent = topBar
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
end

-- Логотип
local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(0, 180, 1, 0)
logoLabel.Position = UDim2.new(0.5, -90, 0, 0)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "CSS  JAVA"
logoLabel.TextColor3 = Color3.fromRGB(230, 200, 255)
logoLabel.TextSize = 16
logoLabel.Font = Enum.Font.GothamBlack
logoLabel.TextXAlignment = Enum.TextXAlignment.Center
logoLabel.ZIndex = 4
logoLabel.Parent = topBar

-- Анимация цвета логотипа
task.spawn(function()
    while logoLabel and logoLabel.Parent do
        tween(logoLabel, {TextColor3 = Color3.fromRGB(200, 150, 255)}, 1.2, Enum.EasingStyle.Sine)
        task.wait(1.2)
        tween(logoLabel, {TextColor3 = Color3.fromRGB(255, 220, 255)}, 1.2, Enum.EasingStyle.Sine)
        task.wait(1.2)
    end
end)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 180, 0, 14)
statusLabel.Position = UDim2.new(0.5, -90, 1, -16)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● ACTIVE"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 140)
statusLabel.TextSize = 9
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.ZIndex = 4
statusLabel.Parent = topBar

-- Мигание статуса
task.spawn(function()
    while statusLabel and statusLabel.Parent do
        tween(statusLabel, {TextTransparency = 0.6}, 0.8, Enum.EasingStyle.Sine)
        task.wait(0.8)
        tween(statusLabel, {TextTransparency = 0}, 0.8, Enum.EasingStyle.Sine)
        task.wait(0.8)
    end
end)

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 50, 1, 0)
versionLabel.Position = UDim2.new(1, -88, 0, 0)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v2.0"
versionLabel.TextColor3 = Color3.fromRGB(120, 70, 200)
versionLabel.TextSize = 10
versionLabel.Font = Enum.Font.GothamMedium
versionLabel.TextXAlignment = Enum.TextXAlignment.Right
versionLabel.ZIndex = 4
versionLabel.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -38, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 15, 100)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(220, 160, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.ZIndex = 5
closeButton.Parent = topBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(140, 60, 220)
closeStroke.Thickness = 1
closeStroke.Parent = closeButton

closeButton.MouseEnter:Connect(function()
    tween(closeButton, {BackgroundColor3 = Color3.fromRGB(120, 20, 60), BackgroundTransparency = 0}, 0.15)
    tween(closeButton, {TextColor3 = Color3.fromRGB(255, 100, 130)}, 0.15)
end)
closeButton.MouseLeave:Connect(function()
    tween(closeButton, {BackgroundColor3 = Color3.fromRGB(60, 15, 100), BackgroundTransparency = 0.3}, 0.15)
    tween(closeButton, {TextColor3 = Color3.fromRGB(220, 160, 255)}, 0.15)
end)

-- ════════════════════════════════
-- НАВИГАЦИЯ
-- ════════════════════════════════
local navPanel = Instance.new("ScrollingFrame")
navPanel.Size = UDim2.new(0, 135, 1, -54)
navPanel.Position = UDim2.new(0, 8, 0, 50)
navPanel.BackgroundColor3 = Color3.fromRGB(8, 5, 20)
navPanel.BackgroundTransparency = 0.3
navPanel.BorderSizePixel = 0
navPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
navPanel.ScrollBarThickness = 2
navPanel.ScrollBarImageColor3 = Color3.fromRGB(140, 60, 255)
navPanel.ZIndex = 3
navPanel.Parent = mainFrame
Instance.new("UICorner", navPanel).CornerRadius = UDim.new(0, 10)

local navStroke = Instance.new("UIStroke")
navStroke.Color = Color3.fromRGB(90, 35, 170)
navStroke.Thickness = 1
navStroke.Parent = navPanel

local navHeader = Instance.new("TextLabel")
navHeader.Size = UDim2.new(1, 0, 0, 22)
navHeader.Position = UDim2.new(0, 0, 0, 4)
navHeader.BackgroundTransparency = 1
navHeader.Text = "МЕНЮ"
navHeader.TextColor3 = Color3.fromRGB(120, 70, 200)
navHeader.TextSize = 9
navHeader.Font = Enum.Font.GothamBold
navHeader.TextXAlignment = Enum.TextXAlignment.Center
navHeader.ZIndex = 4
navHeader.Parent = navPanel

-- ════════════════════════════════
-- КОНТЕНТ
-- ════════════════════════════════
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -158, 1, -54)
contentArea.Position = UDim2.new(0, 150, 0, 50)
contentArea.BackgroundColor3 = Color3.fromRGB(8, 5, 20)
contentArea.BackgroundTransparency = 0.3
contentArea.BorderSizePixel = 0
contentArea.ZIndex = 3
contentArea.Parent = mainFrame
Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 10)

local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(90, 35, 170)
contentStroke.Thickness = 1
contentStroke.Parent = contentArea

local contentHint = Instance.new("TextLabel")
contentHint.Size = UDim2.new(1, 0, 1, 0)
contentHint.BackgroundTransparency = 1
contentHint.Text = "Выбери вкладку"
contentHint.TextColor3 = Color3.fromRGB(80, 50, 130)
contentHint.TextSize = 13
contentHint.Font = Enum.Font.GothamMedium
contentHint.ZIndex = 4
contentHint.Parent = contentArea

-- ════════════════════════════════
-- ВКЛАДКИ
-- ════════════════════════════════
local tabIcons = {
    ["Главная"] = "★", ["Aimbot"] = "◎", ["Visuals"] = "◈",
    ["Players"] = "◉", ["Misc"] = "◆", ["Skins"] = "◇", ["Config"] = "▣",
}
local tabs = {"Главная", "Aimbot", "Visuals", "Players", "Misc", "Skins", "Config"}
local yOffset = 28
local allTabs = {}

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -14, 0, 30)
    tabBtn.Position = UDim2.new(0, 7, 0, yOffset)
    tabBtn.BackgroundColor3 = Color3.fromRGB(18, 10, 40)
    tabBtn.BackgroundTransparency = 0.3
    tabBtn.Text = ""
    tabBtn.ZIndex = 4
    tabBtn.Parent = navPanel
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 7)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(80, 30, 160)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = tabBtn

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(0, 3, 0, 14)
    tabBar.Position = UDim2.new(0, 4, 0.5, -7)
    tabBar.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
    tabBar.BackgroundTransparency = 0.6
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 5
    tabBar.Parent = tabBtn
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 2)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 18, 1, 0)
    iconLbl.Position = UDim2.new(0, 12, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = tabIcons[tabName] or "•"
    iconLbl.TextColor3 = Color3.fromRGB(160, 100, 240)
    iconLbl.TextSize = 11
    iconLbl.Font = Enum.Font.Gotham
    iconLbl.ZIndex = 5
    iconLbl.Parent = tabBtn

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -34, 1, 0)
    nameLbl.Position = UDim2.new(0, 32, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = tabName
    nameLbl.TextColor3 = Color3.fromRGB(180, 150, 220)
    nameLbl.TextSize = 11
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 5
    nameLbl.Parent = tabBtn

    table.insert(allTabs, {btn=tabBtn, bar=tabBar, stroke=btnStroke, lbl=nameLbl, icon=iconLbl})

    -- Hover
    tabBtn.MouseEnter:Connect(function()
        if tabBtn.BackgroundTransparency > 0.1 then
            tween(tabBtn, {BackgroundTransparency = 0.15}, 0.15)
            tween(nameLbl, {TextColor3 = Color3.fromRGB(210, 180, 255)}, 0.15)
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if tabBtn.BackgroundTransparency < 0.2 and tabBtn.BackgroundTransparency > 0.05 then
            tween(tabBtn, {BackgroundTransparency = 0.3}, 0.15)
            tween(nameLbl, {TextColor3 = Color3.fromRGB(180, 150, 220)}, 0.15)
        end
    end)

    tabBtn.MouseButton1Click:Connect(function()
        -- Анимация нажатия (сжатие)
        tween(tabBtn, {Size = UDim2.new(1, -18, 0, 27)}, 0.08, Enum.EasingStyle.Back)
        task.wait(0.08)
        tween(tabBtn, {Size = UDim2.new(1, -14, 0, 30)}, 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        -- Сброс всех вкладок
        for _, t in ipairs(allTabs) do
            tween(t.btn, {BackgroundTransparency = 0.3, BackgroundColor3 = Color3.fromRGB(18, 10, 40)}, 0.2)
            tween(t.bar, {BackgroundTransparency = 0.6}, 0.2)
            tween(t.stroke, {Transparency = 0.5}, 0.2)
            tween(t.lbl, {TextColor3 = Color3.fromRGB(180, 150, 220)}, 0.2)
            tween(t.icon, {TextColor3 = Color3.fromRGB(160, 100, 240)}, 0.2)
        end

        -- Подсветка активной
        tween(tabBtn, {BackgroundTransparency = 0.05, BackgroundColor3 = Color3.fromRGB(40, 15, 80)}, 0.2)
        tween(tabBar, {BackgroundTransparency = 0}, 0.2)
        tween(btnStroke, {Transparency = 0, Color = Color3.fromRGB(160, 80, 255)}, 0.2)
        tween(nameLbl, {TextColor3 = Color3.fromRGB(235, 205, 255)}, 0.2)
        tween(iconLbl, {TextColor3 = Color3.fromRGB(200, 140, 255)}, 0.2)

        -- Fade контент
        contentHint.TextTransparency = 1
        contentHint.Text = tabName
        tween(contentHint, {TextTransparency = 0}, 0.3)

        print("Вкладка: " .. tabName)
    end)

    yOffset = yOffset + 36
end
navPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 8)

-- ════════════════════════════════
-- АНИМАЦИЯ ОТКРЫТИЯ / ЗАКРЫТИЯ
-- ════════════════════════════════
local isOpen = false

local function openMenu()
    isOpen = true
    mainFrame.Visible = true
    -- Начальное состояние
    mainFrame.Position = UDim2.new(0.5, -260, 0, 30)
    mainFrame.BackgroundTransparency = 1
    -- Влетает сверху + появляется
    tween(mainFrame, {
        Position = UDim2.new(0.5, -260, 0, 55),
        BackgroundTransparency = 0
    }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    tween(mainStroke, {Thickness = 1.5}, 0.35)
    openButton.Text = "⨯"
end

local function closeMenu()
    isOpen = false
    -- Улетает вверх + исчезает
    tween(mainFrame, {
        Position = UDim2.new(0.5, -260, 0, 20),
        BackgroundTransparency = 1
    }, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    task.wait(0.25)
    mainFrame.Visible = false
    openButton.Text = "⚡"
end

openButton.MouseButton1Click:Connect(function()
    if isOpen then closeMenu() else openMenu() end
end)

closeButton.MouseButton1Click:Connect(function()
    closeMenu()
end)

-- ════════════════════════════════
-- ПЕРЕТАСКИВАНИЕ
-- ════════════════════════════════
local dragging, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
