-- Полная очистка прошлых окон хака
local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

if pgui:FindFirstChild("AngryKeySystemGui") then pgui.AngryKeySystemGui:Destroy() end
if pgui:FindFirstChild("AngryMainGui") then pgui.AngryMainGui:Destroy() end

-- Создаем основу для GUI внутри PlayerGui
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

-- Переменные функций
_G.AutoRaceV2 = false
_G.AutoRaceV3 = false

-- Точные неизменяемые координаты для телепортации (Зеленая зона и Гора)
local AlchemistCFrame = CFrame.new(614, 73, -4095) -- Точное место Алхимика
local AroweCFrame = CFrame.new(-3523, 239, -510)    -- Точное место Ароуэ (секретная стена на Diamond)

-- Известные фиксированные координаты спавна синих/красных цветов
local FlowerSpots = {
    CFrame.new(675, 75, -4380),  -- Около Алхимика
    CFrame.new(-920, 40, -1920), -- Кладбище
    CFrame.new(-420, 70, -2980), -- Остров Усоппа
    CFrame.new(2730, 200, -820)  -- Гора около Фабрики
}

-- БЕЗОПАСНАЯ ОСТАНОВКА И ПЕРЕМЕЩЕНИЕ
local function PureTP(targetCFrame)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        -- Обнуляем физику, чтобы античит не вернул назад
        hrp.Velocity = Vector3.new(0,0,0)
        task.wait(0.05)
        hrp.CFrame = targetCFrame
        task.wait(0.4)
    end
end

-- ИЗОЛИРОВАННЫЙ ПОТОК (Защищен от падений и зависаний через task.defer)
task.defer(function()
    while true do
        task.wait(2.5) -- Задержка увеличена, чтобы Delta успевала очищать кэш
        
        -- Логика Авто Расы V2
        if _G.AutoRaceV2 then
            pcall(function()
                -- Поочередно проверяем и прыгаем по известным точкам спавна цветов
                for _, spotCFrame in ipairs(FlowerSpots) do
                    if not _G.AutoRaceV2 then break end
                    PureTP(spotCFrame)
                end
                
                -- Возвращаемся сдавать квест Алхимику
                PureTP(AlchemistCFrame)
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
                if remote then
                    remote:InvokeServer("Alchemist", "Dialogue")
                end
            end)
        end
        
        -- Логика Авто Расы V3
        if _G.AutoRaceV3 then
            pcall(function()
                -- Летим к NPC Arowe
                PureTP(AroweCFrame)
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
                if remote then
                    remote:InvokeServer("Arowe", "Dialogue")
                end
            end)
        end
    end
end)

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
