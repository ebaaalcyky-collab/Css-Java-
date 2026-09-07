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
screenGui.Parent = playerGui

-- Плавающая кнопка для открытия/закрытия на телефоне
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 45, 0, 45)
openButton.Position = UDim2.new(0, 20, 0.4, 0)
openButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
openButton.Text = "⚡"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 20
openButton.Font = Enum.Font.GothamBold
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 10)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(120, 150, 255)
openStroke.Thickness = 2
openStroke.Parent = openButton

-- ГЛАВНОЕ ОКНО
local mainFrame = Instance.new("ImageLabel")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 320)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ImageTransparency = 0.35
mainFrame.ScaleType = Enum.ScaleType.Crop
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(100, 130, 220)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Функция скачивания и установки фона с твоего GitHub
local function loadGitHubBackground(imageLabel, filePath)
    local repoOwner = "ebaaalcyky-collab"
    local repoName = "Css-Java"
    local branch = "main" -- если ветка master, поменяй здесь
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

-- Запускаем загрузку фона в фоне, чтобы не вешать игру
task.spawn(function()
    -- Укажи имя своего файла картинки в папке assets/background/
    loadGitHubBackground(mainFrame, "assets/background/eye.png")
end)

-- Верхняя панель (Шапка)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(0, 150, 1, 0)
logoLabel.Position = UDim2.new(0, 15, 0, 0)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "CSS JAVA"
logoLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
logoLabel.TextSize = 16
logoLabel.Font = Enum.Font.GothamBlack
logoLabel.TextXAlignment = Enum.TextXAlignment.Left
logoLabel.Parent = topBar

-- Кнопка закрытия (крестик)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
closeButton.BackgroundTransparency = 0.5
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Левая панель навигации (Вкладки)
local navPanel = Instance.new("ScrollingFrame")
navPanel.Size = UDim2.new(0, 130, 1, -50)
navPanel.Position = UDim2.new(0, 10, 0, 45)
navPanel.BackgroundTransparency = 0.7
navPanel.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
navPanel.BorderSizePixel = 0
navPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
navPanel.ScrollBarThickness = 2
navPanel.Parent = mainFrame

local navCorner = Instance.new("UICorner")
navCorner.CornerRadius = UDim.new(0, 8)
navCorner.Parent = navPanel

-- Контейнер для содержимого
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -155, 1, -50)
contentArea.Position = UDim2.new(0, 145, 0, 45)
contentArea.BackgroundTransparency = 0.5
contentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
contentArea.BorderSizePixel = 0
contentArea.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentArea

-- Создание вкладок
local tabs = {"Главная", "Aimbot", "Visuals", "Players", "Misc", "Skins", "Config"}
local yOffset = 8

for _, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -12, 0, 32)
    tabBtn.Position = UDim2.new(0, 6, 0, yOffset)
    tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tabBtn.BackgroundTransparency = 0.4
    tabBtn.Text = " " .. tabName
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = navPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
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
