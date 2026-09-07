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

-- Плавающая кнопка для открытия/закрытия на телефоне
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 45, 0, 45)
openButton.Position = UDim2.new(0, 20, 0.4, 0)
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

-- ГЛАВНОЕ ОКНО
local mainFrame = Instance.new("ImageLabel")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 320)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(6, 4, 14)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ImageTransparency = 0.35
mainFrame.ScaleType = Enum.ScaleType.Crop
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(140, 60, 255)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Функция скачивания и установки фона с твоего GitHub
local function loadGitHubBackground(imageLabel, filePath)
    local repoOwner = "ebaaalcyky-collab"
    local repoName = "Css-Java"
    local branch = "main"
    local basePath = "CSS-JAVA-GitHub-Ready"
    
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s/%s", repoOwner, repoName, branch, basePath, filePath)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result then
        local fileName = "css_java_bg_cache.png"
        local writeSuccess = pcall(function()
            writefile(fileName, result)
        end)
        
        if writeSuccess then
            local assetFunc = getcustomasset or getsynasset
            if assetFunc then
                imageLabel.Image = assetFunc(fileName)
            end
        end
    else
        warn("Не удалось подгрузить фон с GitHub, используется чистый стиль.")
    end
end

-- Запускаем загрузку фона в фоне
task.spawn(function()
    loadGitHubBackground(mainFrame, "assets/background/eye.png")
end)

-- Верхняя панель (Шапка)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(12, 8, 28)
topBar.BackgroundTransparency = 0.3
topBar.BorderSizePixel = 0
topBar.ZIndex = 3
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

-- Нижняя граница шапки
local topBarLine = Instance.new("Frame")
topBarLine.Size = UDim2.new(1, 0, 0, 1)
topBarLine.Position = UDim2.new(0, 0, 1, -1)
topBarLine.BackgroundColor3 = Color3.fromRGB(140, 60, 255)
topBarLine.BackgroundTransparency = 0.3
topBarLine.BorderSizePixel = 0
topBarLine.ZIndex = 4
topBarLine.Parent = topBar

-- Декоративная полоска слева в шапке
local logoAccent = Instance.new("Frame")
logoAccent.Size = UDim2.new(0, 4, 0, 18)
logoAccent.Position = UDim2.new(0, 12, 0.5, -9)
logoAccent.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
logoAccent.BorderSizePixel = 0
logoAccent.ZIndex = 4
logoAccent.Parent = topBar

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 2)
accentCorner.Parent = logoAccent

local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(0, 160, 1, 0)
logoLabel.Position = UDim2.new(0, 22, 0, 0)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "CSS  JAVA"
logoLabel.TextColor3 = Color3.fromRGB(220, 190, 255)
logoLabel.TextSize = 15
logoLabel.Font = Enum.Font.GothamBlack
logoLabel.TextXAlignment = Enum.TextXAlignment.Left
logoLabel.ZIndex = 4
logoLabel.Parent = topBar

-- Версия
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 60, 1, 0)
versionLabel.Position = UDim2.new(0, 168, 0, 0)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v2.0"
versionLabel.TextColor3 = Color3.fromRGB(140, 80, 220)
versionLabel.TextSize = 10
versionLabel.Font = Enum.Font.GothamMedium
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.ZIndex = 4
versionLabel.Parent = topBar

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -36, 0.5, -14)
closeButton.BackgroundColor3 = Color3.fromRGB(80, 20, 120)
closeButton.BackgroundTransparency = 0.5
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(200, 150, 255)
closeButton.TextSize = 13
closeButton.Font = Enum.Font.GothamBold
closeButton.ZIndex = 5
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(140, 60, 220)
closeStroke.Thickness = 1
closeStroke.Parent = closeButton

-- Левая панель навигации
local navPanel = Instance.new("ScrollingFrame")
navPanel.Size = UDim2.new(0, 130, 1, -50)
navPanel.Position = UDim2.new(0, 10, 0, 45)
navPanel.BackgroundColor3 = Color3.fromRGB(8, 5, 18)
navPanel.BackgroundTransparency = 0.4
navPanel.BorderSizePixel = 0
navPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
navPanel.ScrollBarThickness = 2
navPanel.ScrollBarImageColor3 = Color3.fromRGB(140, 60, 255)
navPanel.ZIndex = 3
navPanel.Parent = mainFrame

local navCorner = Instance.new("UICorner")
navCorner.CornerRadius = UDim.new(0, 8)
navCorner.Parent = navPanel

local navStroke = Instance.new("UIStroke")
navStroke.Color = Color3.fromRGB(80, 30, 160)
navStroke.Thickness = 1
navStroke.Parent = navPanel

-- Контейнер для содержимого
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -155, 1, -50)
contentArea.Position = UDim2.new(0, 145, 0, 45)
contentArea.BackgroundColor3 = Color3.fromRGB(9, 6, 20)
contentArea.BackgroundTransparency = 0.35
contentArea.BorderSizePixel = 0
contentArea.ZIndex = 3
contentArea.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentArea

local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(80, 30, 160)
contentStroke.Thickness = 1
contentStroke.Parent = contentArea

-- Иконки для вкладок
local tabIcons = {
    ["Главная"] = "★",
    ["Aimbot"]  = "◎",
    ["Visuals"] = "◈",
    ["Players"] = "◉",
    ["Misc"]    = "◆",
    ["Skins"]   = "◇",
    ["Config"]  = "▣",
}

-- Создание вкладок
local tabs = {"Главная", "Aimbot", "Visuals", "Players", "Misc", "Skins", "Config"}
local yOffset = 10

for _, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -12, 0, 32)
    tabBtn.Position = UDim2.new(0, 6, 0, yOffset)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 12, 45)
    tabBtn.BackgroundTransparency = 0.45
    tabBtn.Text = ""
    tabBtn.ZIndex = 4
    tabBtn.Parent = navPanel

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(100, 40, 200)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    btnStroke.Parent = tabBtn

    -- Левая цветная черточка
    local tabAccentBar = Instance.new("Frame")
    tabAccentBar.Size = UDim2.new(0, 3, 0, 16)
    tabAccentBar.Position = UDim2.new(0, 5, 0.5, -8)
    tabAccentBar.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
    tabAccentBar.BackgroundTransparency = 0.5
    tabAccentBar.BorderSizePixel = 0
    tabAccentBar.ZIndex = 5
    tabAccentBar.Parent = tabBtn

    local accentBarCorner = Instance.new("UICorner")
    accentBarCorner.CornerRadius = UDim.new(0, 2)
    accentBarCorner.Parent = tabAccentBar

    -- Иконка (текстовые символы вместо эмодзи — стабильнее)
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 20, 1, 0)
    iconLabel.Position = UDim2.new(0, 13, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = tabIcons[tabName] or "•"
    iconLabel.TextColor3 = Color3.fromRGB(180, 120, 255)
    iconLabel.TextSize = 12
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.ZIndex = 5
    iconLabel.Parent = tabBtn

    -- Название вкладки
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, -38, 1, 0)
    tabLabel.Position = UDim2.new(0, 35, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = tabName
    tabLabel.TextColor3 = Color3.fromRGB(190, 160, 230)
    tabLabel.TextSize = 11
    tabLabel.Font = Enum.Font.GothamMedium
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.ZIndex = 5
    tabLabel.Parent = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        tabBtn.BackgroundTransparency = 0.15
        tabAccentBar.BackgroundTransparency = 0
        tabLabel.TextColor3 = Color3.fromRGB(220, 190, 255)
        btnStroke.Transparency = 0
        print("Вкладка: " .. tabName)
    end)

    yOffset = yOffset + 38
end
navPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)

-- Логика открытия/закрытия
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

-- Перетаскивание
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
