-- =================================================================
-- CSS-JAVA HUB LOADER (GitHub Integration)
-- =================================================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Базовый адрес твоего репозитория на GitHub (путь к папке GitHub-Ready)
local repoOwner = "ebaaalcyky-collab"
local repoName = "Css-Java"
local branch = "main" -- или master, в зависимости от твоей ветки
local basePath = "CSS-JAVA-GitHub-Ready"

-- Функция для скачивания файлов с GitHub поrelativePath
local function getGitHubFile(filePath)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s/%s", repoOwner, repoName, branch, basePath, filePath)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        return result
    else
        warn("Не удалось загрузить файл: " .. filePath)
        return nil
    end
end

-- Загружаем манифест ассетов и конфиги
local manifestJson = getGitHubFile("assets/asset_manifest.json")
local themesJson = getGitHubFile("config/themes.json")
local defaultConfigJson = getGitHubFile("config/default.json")

-- Парсим конфигурации через HttpService (если файлы в формате JSON)
local assetsManifest = manifestJson and HttpService:JSONDecode(manifestJson) or {}
local themesConfig = themesJson and HttpService:JSONDecode(themesJson) or {}
local defaultConfig = defaultConfigJson and HttpService:JSONDecode(defaultConfigJson) or {}

-- Очистка старого интерфейса
pcall(function()
    if playerGui:FindFirstChild("CssJavaHub") then
        playerGui.CssJavaHub:Destroy()
    end
end)

-- Создание основного ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CssJavaHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Плавающая кнопка открытия/закрытия
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 20, 0.4, 0)
openButton.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
openButton.Text = "⚡"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 22
openButton.Font = Enum.Font.GothamBold
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 12)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(138, 43, 226)
openStroke.Thickness = 2
openStroke.Parent = openButton

-- Главное окно хаба (с учетом твоих офсетов и будущих вкладок)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 300)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(138, 43, 226)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Верхняя панель (DragBar) для перетаскивания на телефоне
local dragBar = Instance.new("TextLabel")
dragBar.Size = UDim2.new(1, 0, 0, 40)
dragBar.BackgroundTransparency = 1
dragBar.Text = "  CSS-JAVA HUB [Home, Movement, Aim, ESP, Other, Settings]"
dragBar.TextColor3 = Color3.fromRGB(255, 255, 255)
dragBar.TextSize = 13
dragBar.Font = Enum.Font.GothamBold
dragBar.Parent = mainFrame

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(180, 180, 180)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

-- Контейнер для будущих вкладок (Home, Movement, Aim, ESP, Other, Settings)
local contentContainer = Instance.new("ScrollingFrame")
contentContainer.Size = UDim2.new(1, -20, 1, -60)
contentContainer.Position = UDim2.new(0, 10, 0, 50)
contentContainer.BackgroundTransparency = 1
contentContainer.CanvasSize = UDim2.new(0, 0, 2, 0)
contentContainer.ScrollBarThickness = 4
contentContainer.Parent = mainFrame

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

-- Перетаскивание интерфейса пальцем на мобильном
local dragging, dragStart, startPos
dragBar.InputBegan:Connect(function(input)
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

print("CSS-JAVA Loader успешно инициализирован из репозитория!")
