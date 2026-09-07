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
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 20, 0.4, 0)
openButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
openButton.Text = "⚡"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 22
openButton.Font = Enum.Font.GothamBold
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 12)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(120, 150, 255)
openStroke.Thickness = 2
openStroke.Parent = openButton

-- ГЛАВНОЕ ОКНО С ФОНОМ (ImageLabel вместо Frame)
local mainFrame = Instance.new("ImageLabel")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 750, 0, 450)
mainFrame.Position = UDim2.new(0.5, -375, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false

-- ВСТАВЬ СЮДА ID СВОЕЙ КАРТИНКИ С ГЛАЗОМ ИЗ ROBLOX
mainFrame.Image = "rbxassetid://0000000000" 
mainFrame.ImageTransparency = 0.35 -- Затемнение фона, чтобы интерфейс читался
mainFrame.ScaleType = Enum.ScaleType.Crop
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(100, 130, 220)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Верхняя панель (Шапка / Логотип и кнопка закрытия)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(0, 200, 1, 0)
logoLabel.Position = UDim2.new(0, 20, 0, 0)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "CSS JAVA"
logoLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
logoLabel.TextSize = 20
logoLabel.Font = Enum.Font.GothamBlack
logoLabel.TextXAlignment = Enum.TextXAlignment.Left
logoLabel.Parent = topBar

-- Кнопка закрытия (крестик)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0.5, -17.5)
closeButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
closeButton.BackgroundTransparency = 0.5
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Левая панель навигации (Вкладки)
local navPanel = Instance.new("ScrollingFrame")
navPanel.Size = UDim2.new(0, 160, 1, -65)
navPanel.Position = UDim2.new(0, 15, 0, 55)
navPanel.BackgroundTransparency = 0.8
navPanel.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
navPanel.BorderSizePixel = 0
navPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
navPanel.ScrollBarThickness = 2
navPanel.Parent = mainFrame

local navCorner = Instance.new("UICorner")
navCorner.CornerRadius = UDim.new(0, 10)
navCorner.Parent = navPanel

-- Контейнер для содержимого активной вкладки
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -195, 1, -65)
contentArea.Position = UDim2.new(0, 185, 0, 55)
contentArea.BackgroundTransparency = 0.6
contentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
contentArea.BorderSizePixel = 0
contentArea.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentArea

-- Функция создания кнопок вкладок
local tabs = {"Главная", "Aimbot", "Visuals", "Players", "Misc", "Skins", "Config"}
local yOffset = 10

for _, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -16, 0, 38)
    tabBtn.Position = UDim2.new(0, 8, 0, yOffset)
    tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tabBtn.BackgroundTransparency = 0.5
    tabBtn.Text = "  " .. tabName
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = navPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tabBtn
    
    -- Пример переключения (пока просто меняем цвет для наглядности)
    tabBtn.MouseButton1Click:Connect(function()
        print("Открыта вкладка: " .. tabName)
    end)
    
    yOffset = yOffset + 46
end
navPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)

-- Логика открытия/закрытия главного меню
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

-- Перетаскивание окна пальцем / мышкой за шапку
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
