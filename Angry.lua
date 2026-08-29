-- Полная очистка прошлых окон хака
local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

if pgui:FindFirstChild("AngryKeySystemGui") then pgui.AngryKeySystemGui:Destroy() end
if pgui:FindFirstChild("AngryMainGui") then pgui.AngryMainGui:Destroy() end

-- Создаем основу для GUI внутри PlayerGui (100% обход блокировок)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AngryKeySystemGui"
ScreenGui.Parent = pgui
ScreenGui.ResetOnSpawn = false

-- Главный фрейм ввода ключа
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 160)
MainFrame.Position = UDim2.new(0.5, -150, 0.4, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Angry Key System"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.Parent = MainFrame

-- Поле ввода
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 240, 0, 35)
TextBox.Position = UDim2.new(0.5, -120, 0.45, -10)
TextBox.PlaceholderText = "Введите ключ..."
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
TextBox.TextSize = 16
TextBox.Font = Enum.Font.SourceSans
TextBox.Parent = MainFrame

-- Кнопка проверки
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 120, 0, 35)
Button.Position = UDim2.new(0.5, -60, 0.75, -5)
Button.Text = "Проверить"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Button.TextSize = 16
Button.Font = Enum.Font.SourceSansBold
Button.Parent = MainFrame

-- Функции
_G.AutoRaceV2 = false
_G.AutoRaceV3 = false

local function CreateMainMenu()
    local MainMenuGui = Instance.new("ScreenGui")
    MainMenuGui.Name = "AngryMainGui"
    MainMenuGui.Parent = pgui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 200)
    Frame.Position = UDim2.new(0.5, -160, 0.4, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = MainMenuGui
    Instance.new("UICorner").Parent = Frame

    local MTitle = Instance.new("TextLabel")
    MTitle.Size = UDim2.new(1, 0, 0, 45)
    MTitle.Text = "Angry Hub — Blox Fruits"
    MTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MTitle.TextSize = 20
    MTitle.Font = Enum.Font.SourceSansBold
    MTitle.BackgroundColor3 = Color3.fromRGB(160, 30, 30)
    MTitle.Parent = Frame

    -- Кнопка Раса В2
    local ToggleV2 = Instance.new("TextButton")
    ToggleV2.Size = UDim2.new(0, 260, 0, 40)
    ToggleV2.Position = UDim2.new(0.5, -130, 0.35, 5)
    ToggleV2.Text = "Авто Раса V2: ВЫКЛ"
    ToggleV2.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleV2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleV2.Font = Enum.Font.SourceSansBold
    ToggleV2.Parent = Frame
    Instance.new("UICorner").Parent = ToggleV2

    ToggleV2.MouseButton1Click:Connect(function()
        _G.AutoRaceV2 = not _G.AutoRaceV2
        ToggleV2.Text = _G.AutoRaceV2 and "Авто Раса V2: ВКЛ" or "Авто Раса V2: ВЫКЛ"
        ToggleV2.BackgroundColor3 = _G.AutoRaceV2 and Color3.fromRGB(30, 150, 30) or Color3.fromRGB(40, 40, 40)
    end)

    -- Кнопка Раса В3
    local ToggleV3 = Instance.new("TextButton")
    ToggleV3.Size = UDim2.new(0, 260, 0, 40)
    ToggleV3.Position = UDim2.new(0.5, -130, 0.65, 5)
    ToggleV3.Text = "Авто Раса V3: ВЫКЛ"
    ToggleV3.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleV3.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleV3.Font = Enum.Font.SourceSansBold
    ToggleV3.Parent = Frame
    Instance.new("UICorner").Parent = ToggleV3

    ToggleV3.MouseButton1Click:Connect(function()
        _G.AutoRaceV3 = not _G.AutoRaceV3
        ToggleV3.Text = _G.AutoRaceV3 and "Авто Раса V3: ВКЛ" or "Авто Раса V3: ВЫКЛ"
        ToggleV3.BackgroundColor3 = _G.AutoRaceV3 and Color3.fromRGB(30, 150, 30) or Color3.fromRGB(40, 40, 40)
    end)
end

Button.MouseButton1Click:Connect(function()
    if TextBox.Text == "Angry20" then
        ScreenGui:Destroy()
        CreateMainMenu()
    else
        Button.Text = "НЕВЕРНЫЙ КЛЮЧ!"
        Button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        task.wait(1.5)
        Button.Text = "Проверить"
        Button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)
