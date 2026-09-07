-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старую версию перед запуском
pcall(function()
    if playerGui:FindFirstChild("CSSJavaHub") then
        playerGui.CSSJavaHub:Destroy()
    end
end)

-- Основной контейнер
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CSSJavaHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Плавающая кнопка открытия — справа по центру, не мешает джойстику
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 45, 0, 45)
openButton.Position = UDim2.new(1, -58, 0.5, -22)  -- правый край, середина
openButton.BackgroundColor3 = Color3.fromRGB(8, 6, 18)
openButton.Text = "⚡"
openButton.TextColor3 = Color3.fromRGB(185, 130, 255)
openButton.TextSize = 20
openButton.Font = Enum.Font.GothamBold
openButton.ZIndex = 10
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 10)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(160, 80, 255)
openStroke.Thickness = 1.5
openStroke.Parent = openButton

-- ГЛАВНОЕ ОКНО — меньше, выше, не перекрывает джойстик и нижние кнопки
local mainFrame = Instance.new("ImageLabel")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 300)
mainFrame.Position = UDim2.new(0.5, -260, 0, 55)  -- сверху, под топбаром игры
mainFrame.BackgroundColor3 = Color3.fromRGB(6, 4, 14)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ImageTransparency = 0.35
mainFrame.ScaleType = Enum.ScaleType.Crop
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(140, 60, 255)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Функция загрузки фона с GitHub
local function loadGitHubBackground(imageLabel, filePath)
    local repoOwner = "ebaaalcyky-collab"
    local repoName = "Css-Java"
    local branch = "main"
    local basePath = "CSS-JAVA-GitHub-Ready"
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s/%s", repoOwner, repoName, branch, basePath, filePath)
    local success, result = pcall(function() return game:HttpGet(url) end)
    if success and result then
        local writeSuccess = pcall(function() writefile("css_java_bg_cache.png", result) end)
        if writeSuccess then
            local assetFunc = getcustomasset or getsynasset
            if assetFunc then imageLabel.Image = assetFunc("css_java_bg_cache.png") end
        end
    end
end
task.spawn(function()
    loadGitHubBackground(mainFrame, "assets/background/eye.png")
end)

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

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 14)
topBarCorner.Parent = topBar

-- Нижний прямой край шапки (UICorner делает скруглёнными все углы, нужен фикс)
local topBarFix = Instance.new("Frame")
topBarFix.Size = UDim2.new(1, 0, 0, 14)
topBarFix.Position = UDim2.new(0, 0, 1, -14)
topBarFix.BackgroundColor3 = Color3.fromRGB(10, 6, 24)
topBarFix.BackgroundTransparency = 0.1
topBarFix.BorderSizePixel = 0
topBarFix.ZIndex = 3
topBarFix.Parent = topBar

-- Светящаяся линия под шапкой
local topBarLine = Instance.new("Frame")
topBarLine.Size = UDim2.new(1, 0, 0, 1)
topBarLine.Position = UDim2.new(0, 0, 1, 0)
topBarLine.BackgroundColor3 = Color3.fromRGB(150, 70, 255)
topBarLine.BackgroundTransparency = 0
topBarLine.BorderSizePixel = 0
topBarLine.ZIndex = 4
topBarLine.Parent = topBar

-- Точки-декор слева
local dot1 = Instance.new("Frame")
dot1.Size = UDim2.new(0, 8, 0, 8)
dot1.Position = UDim2.new(0, 12, 0.5, -4)
dot1.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
dot1.BorderSizePixel = 0
dot1.ZIndex = 4
dot1.Parent = topBar
Instance.new("UICorner", dot1).CornerRadius = UDim.new(1, 0)

local dot2 = Instance.new("Frame")
dot2.Size = UDim2.new(0, 8, 0, 8)
dot2.Position = UDim2.new(0, 25, 0.5, -4)
dot2.BackgroundColor3 = Color3.fromRGB(100, 40, 180)
dot2.BorderSizePixel = 0
dot2.ZIndex = 4
dot2.Parent = topBar
Instance.new("UICorner", dot2).CornerRadius = UDim.new(1, 0)

local dot3 = Instance.new("Frame")
dot3.Size = UDim2.new(0, 8, 0, 8)
dot3.Position = UDim2.new(0, 38, 0.5, -4)
dot3.BackgroundColor3 = Color3.fromRGB(60, 20, 120)
dot3.BorderSizePixel = 0
dot3.ZIndex = 4
dot3.Parent = topBar
Instance.new("UICorner", dot3).CornerRadius = UDim.new(1, 0)

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

-- Статус-лейбл под логотипом
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 180, 0, 14)
statusLabel.Position = UDim2.new(0.5, -90, 1, -16)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● ACTIVE"
statusLabel.TextColor3 = Color3.fromRGB(130, 255, 160)
statusLabel.TextSize = 9
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.ZIndex = 4
statusLabel.Parent = topBar

-- Версия справа
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

-- Кнопка закрытия
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

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(140, 60, 220)
closeStroke.Thickness = 1
closeStroke.Parent = closeButton

-- ════════════════════════════════
-- НАВИГАЦИЯ (левая панель)
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

local navCorner = Instance.new("UICorner")
navCorner.CornerRadius = UDim.new(0, 10)
navCorner.Parent = navPanel

local navStroke = Instance.new("UIStroke")
navStroke.Color = Color3.fromRGB(90, 35, 170)
navStroke.Thickness = 1
navStroke.Parent = navPanel

-- Заголовок над табами
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
-- КОНТЕНТ ОБЛАСТЬ
-- ════════════════════════════════
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -158, 1, -54)
contentArea.Position = UDim2.new(0, 150, 0, 50)
contentArea.BackgroundColor3 = Color3.fromRGB(8, 5, 20)
contentArea.BackgroundTransparency = 0.3
contentArea.BorderSizePixel = 0
contentArea.ZIndex = 3
contentArea.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentArea

local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(90, 35, 170)
contentStroke.Thickness = 1
contentStroke.Parent = contentArea

-- Placeholder текст в контент зоне
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
    ["Главная"] = "★",
    ["Aimbot"]  = "◎",
    ["Visuals"] = "◈",
    ["Players"] = "◉",
    ["Misc"]    = "◆",
    ["Skins"]   = "◇",
    ["Config"]  = "▣",
}

local tabs = {"Главная", "Aimbot", "Visuals", "Players", "Misc", "Skins", "Config"}
local yOffset = 28
local allTabBtns = {}

for _, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -14, 0, 30)
    tabBtn.Position = UDim2.new(0, 7, 0, yOffset)
    tabBtn.BackgroundColor3 = Color3.fromRGB(18, 10, 40)
    tabBtn.BackgroundTransparency = 0.3
    tabBtn.Text = ""
    tabBtn.ZIndex = 4
    tabBtn.Parent = navPanel

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 7)
    btnCorner.Parent = tabBtn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(80, 30, 160)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = tabBtn

    -- Левая полоска
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(0, 3, 0, 14)
    tabBar.Position = UDim2.new(0, 4, 0.5, -7)
    tabBar.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
    tabBar.BackgroundTransparency = 0.6
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 5
    tabBar.Parent = tabBtn
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 2)

    -- Иконка
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

    -- Название
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

    table.insert(allTabBtns, {btn=tabBtn, bar=tabBar, stroke=btnStroke, lbl=nameLbl})

    tabBtn.MouseButton1Click:Connect(function()
        -- Сбросить все
        for _, t in ipairs(allTabBtns) do
            t.btn.BackgroundTransparency = 0.3
            t.bar.BackgroundTransparency = 0.6
            t.stroke.Transparency = 0.5
            t.lbl.TextColor3 = Color3.fromRGB(180, 150, 220)
        end
        -- Подсветить активную
        tabBtn.BackgroundTransparency = 0.05
        tabBar.BackgroundTransparency = 0
        btnStroke.Transparency = 0
        nameLbl.TextColor3 = Color3.fromRGB(230, 200, 255)
        contentHint.Text = tabName
        print("Вкладка: " .. tabName)
    end)

    yOffset = yOffset + 36
end
navPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 8)

-- ════════════════════════════════
-- ЛОГИКА ОТКРЫТИЯ / ЗАКРЫТИЯ
-- ════════════════════════════════
local isOpen = false
openButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
    openButton.Text = isOpen and "⨯" or "⚡"
end)

closeButton.MouseButton1Click:Connect(function()
    isOpen = false
    mainFrame.Visible = false
    openButton.Text = "⚡"
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
