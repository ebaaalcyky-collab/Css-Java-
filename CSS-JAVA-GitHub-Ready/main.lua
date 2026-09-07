-- CSS JAVA
-- UI entry point.
-- Movement contains only a fixed Speed Hack toggle (30).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
    local old = playerGui:FindFirstChild("CSSJAVA")
    if old then old:Destroy() end
end)

local SPEED = 30
local DEFAULT_SPEED = 16
local speedEnabled = false
local sessionStart = os.clock()

-- Screen
local gui = Instance.new("ScreenGui")
gui.Name = "CSSJAVA"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Floating open button
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.fromOffset(52, 52)
openButton.Position = UDim2.new(0, 18, 0.42, 0)
openButton.BackgroundColor3 = Color3.fromRGB(9, 17, 23)
openButton.Text = "⚡"
openButton.TextColor3 = Color3.fromRGB(235, 249, 255)
openButton.TextSize = 22
openButton.Font = Enum.Font.GothamBold
openButton.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 14)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(170, 220, 238)
openStroke.Thickness = 1.5
openStroke.Parent = openButton

-- Main window
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(720, 430)
main.Position = UDim2.new(0.5, -360, 0.5, -215)
main.BackgroundColor3 = Color3.fromRGB(7, 15, 21)
main.BackgroundTransparency = 0.08
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(150, 205, 222)
mainStroke.Transparency = 0.35
mainStroke.Thickness = 1
mainStroke.Parent = main

-- Background placeholder layer.
local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(5, 12, 17)
background.BackgroundTransparency = 0.05
background.BorderSizePixel = 0
background.ZIndex = 0
background.Parent = main

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 18)
bgCorner.Parent = background

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.fromOffset(175, 430)
sidebar.BackgroundColor3 = Color3.fromRGB(4, 10, 14)
sidebar.BackgroundTransparency = 0.12
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 2
sidebar.Parent = main

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 18)
sideCorner.Parent = sidebar

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, -24, 0, 55)
logo.Position = UDim2.fromOffset(12, 12)
logo.BackgroundTransparency = 1
logo.Text = "CSS JAVA"
logo.TextColor3 = Color3.fromRGB(235, 249, 255)
logo.TextSize = 18
logo.Font = Enum.Font.GothamBold
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.ZIndex = 3
logo.Parent = sidebar

local nav = {
    {"⌂", "Home", "home"},
    {"↗", "Movement", "movement"},
    {"◉", "ESP", "esp"},
    {"⊙", "Aim", "aim"},
    {"◆", "Other", "other"},
    {"⚙", "Settings", "settings"},
}

local buttons = {}
local currentTab = "home"

local function makeNavButton(index, icon, label, id)
    local b = Instance.new("TextButton")
    b.Name = label
    b.Size = UDim2.new(1, -20, 0, 43)
    b.Position = UDim2.fromOffset(10, 72 + (index - 1) * 48)
    b.BackgroundColor3 = Color3.fromRGB(18, 31, 39)
    b.BackgroundTransparency = 1
    b.Text = icon .. "   " .. label
    b.TextColor3 = Color3.fromRGB(151, 172, 181)
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.ZIndex = 3
    b.Parent = sidebar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = b

    buttons[id] = b
    return b
end

for i, item in ipairs(nav) do
    local b = makeNavButton(i, item[1], item[2], item[3])
    b.MouseButton1Click:Connect(function()
        currentTab = item[3]
        for id, btn in pairs(buttons) do
            btn.BackgroundTransparency = id == currentTab and 0.15 or 1
            btn.TextColor3 = id == currentTab
                and Color3.fromRGB(235, 249, 255)
                or Color3.fromRGB(151, 172, 181)
        end
        -- Content visibility is handled below.
    end)
end

local configButton = Instance.new("TextButton")
configButton.Name = "Config"
configButton.Size = UDim2.new(1, -20, 0, 43)
configButton.Position = UDim2.new(0, 10, 1, -55)
configButton.BackgroundTransparency = 1
configButton.Text = "▣   Config"
configButton.TextColor3 = Color3.fromRGB(151, 172, 181)
configButton.TextSize = 13
configButton.Font = Enum.Font.GothamMedium
configButton.TextXAlignment = Enum.TextXAlignment.Left
configButton.ZIndex = 3
configButton.Parent = sidebar

-- Header
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -220, 0, 45)
title.Position = UDim2.fromOffset(200, 15)
title.BackgroundTransparency = 1
title.Text = "HOME"
title.TextColor3 = Color3.fromRGB(240, 248, 252)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 34)
close.Position = UDim2.new(1, -48, 0, 10)
close.BackgroundTransparency = 1
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(160, 180, 190)
close.TextSize = 16
close.Font = Enum.Font.GothamBold
close.ZIndex = 3
close.Parent = main

-- Content
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -215, 1, -75)
content.Position = UDim2.fromOffset(195, 60)
content.BackgroundTransparency = 1
content.ZIndex = 3
content.Parent = main

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 170)
info.Position = UDim2.fromOffset(5, 5)
info.BackgroundColor3 = Color3.fromRGB(12, 24, 31)
info.BackgroundTransparency = 0.18
info.TextColor3 = Color3.fromRGB(218, 234, 241)
info.TextSize = 14
info.Font = Enum.Font.GothamMedium
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Center
info.ZIndex = 4
info.Parent = content

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 14)
infoCorner.Parent = info

local movement = Instance.new("Frame")
movement.Size = UDim2.fromScale(1, 1)
movement.BackgroundTransparency = 1
movement.Visible = false
movement.ZIndex = 4
movement.Parent = content

local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(1, -20, 0, 35)
speedTitle.Position = UDim2.fromOffset(5, 8)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "Speed Hack"
speedTitle.TextColor3 = Color3.fromRGB(235, 247, 252)
speedTitle.TextSize = 16
speedTitle.Font = Enum.Font.GothamBold
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.ZIndex = 5
speedTitle.Parent = movement

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1, -20, 0, 65)
speedButton.Position = UDim2.fromOffset(5, 55)
speedButton.BackgroundColor3 = Color3.fromRGB(15, 27, 34)
speedButton.Text = "Speed Hack: OFF"
speedButton.TextColor3 = Color3.fromRGB(160, 180, 188)
speedButton.TextSize = 15
speedButton.Font = Enum.Font.GothamBold
speedButton.ZIndex = 5
speedButton.Parent = movement

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 12)
speedCorner.Parent = speedButton

local speedStroke = Instance.new("UIStroke")
speedStroke.Color = Color3.fromRGB(100, 130, 140)
speedStroke.Transparency = 0.35
speedStroke.Parent = speedButton

local empty = Instance.new("TextLabel")
empty.Size = UDim2.fromScale(1, 1)
empty.BackgroundTransparency = 1
empty.Text = "Coming soon"
empty.TextColor3 = Color3.fromRGB(120, 145, 154)
empty.TextSize = 14
empty.Font = Enum.Font.GothamMedium
empty.Visible = false
empty.ZIndex = 5
empty.Parent = content

local function refreshTab()
    info.Visible = currentTab == "home"
    movement.Visible = currentTab == "movement"
    empty.Visible = currentTab ~= "home" and currentTab ~= "movement"
    title.Text = string.upper(currentTab)

    if currentTab == "home" then
        for _, btn in pairs(buttons) do
            btn.BackgroundTransparency = 1
        end
        buttons.home.BackgroundTransparency = 0.15
    end
end

local function updateHome()
    local elapsed = math.floor(os.clock() - sessionStart)
    local h = math.floor(elapsed / 3600)
    local m = math.floor((elapsed % 3600) / 60)
    local s = elapsed % 60
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local working = humanoid ~= nil

    info.Text =
        "   HOME\n\n" ..
        "   Username:  " .. player.Name .. "\n" ..
        "   User ID:   " .. tostring(player.UserId) .. "\n" ..
        string.format("   Session:   %02d:%02d:%02d\n", h, m, s) ..
        "   Status:    " .. (working and "● WORKING" or "● WAITING")
end

openButton.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    openButton.Text = main.Visible and "✕" or "⚡"
    if main.Visible then
        refreshTab()
    end
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
    openButton.Text = "⚡"
end)

speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedButton.Text = "Speed Hack: ON"
        speedButton.TextColor3 = Color3.fromRGB(120, 255, 170)
        speedStroke.Color = Color3.fromRGB(120, 255, 170)
        mainStroke.Color = Color3.fromRGB(120, 255, 170)
    else
        speedButton.Text = "Speed Hack: OFF"
        speedButton.TextColor3 = Color3.fromRGB(160, 180, 188)
        speedStroke.Color = Color3.fromRGB(100, 130, 140)
        mainStroke.Color = Color3.fromRGB(150, 205, 222)

        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = DEFAULT_SPEED end
    end
end)

RunService.RenderStepped:Connect(function()
    updateHome()
    if speedEnabled then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = SPEED end
    end
end)

refreshTab()

-- Basic mobile drag support.
local dragging, dragStart, startPos
local dragTarget = title

dragTarget.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
