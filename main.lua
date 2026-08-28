-- =================================================================
-- Скрипт: MbHub | Игра: Blox Fruits
-- =================================================================

-- 1. СИСТЕМА КЛЮЧА
local CorrectKey = "MenBf2"
local UserKey = "MenBf2" -- Delta X автоматически активирует, если ключ совпадает

if UserKey ~= CorrectKey then
    game.Players.LocalPlayer:Kick("Неверный ключ для MbHub!")
    return
end

-- 2. СОЗДАНИЕ ГРАФИЧЕСКОГО ИНТЕРФЕЙСА (GUI)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TabButtons = Instance.new("Frame")
local Container = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local UIGradient = Instance.new("UIGradient")
local ToggleButton = Instance.new("TextButton") -- Окошко для откр/закр

-- Настройка ScreenGui
ScreenGui.Name = "MbHubGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- НАСТРОЙКА МИНИ-ОКОШКА (КНОПКА ОТКРЫТИЯ/ЗАКРЫТИЯ)
ToggleButton.Name = "MB_Toggle"
ToggleButton.Parent = ScreenGui
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Text = "MB"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true -- Можно перетаскивать по экрану

-- Скругление для кнопки
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

-- Логика кнопки MB (Открыть/Закрыть)
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- НАСТРОЙКА ГЛАВНОГО МЕНЮ
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

-- РАДУЖНОЕ МЕНЮ (UIGradient)
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
})
UIGradient.Parent = MainFrame

-- Анимация перелива радуги
task.spawn(function()
    while task.wait(0.03) do
        UIGradient.Rotation = UIGradient.Rotation + 1
    end
end)

-- НАЗВАНИЕ ВНУТРИ МЕНЮ (MbHub)
Title.Name = "Title"
Title.Parent = MainFrame
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "MbHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold

-- ПАНЕЛЬ ВКЛАДОК
TabButtons.Name = "TabButtons"
TabButtons.Parent = MainFrame
TabButtons.Position = UDim2.new(0, 10, 0, 40)
TabButtons.Size = UDim2.new(0, 100, 0, 240)
TabButtons.BackgroundTransparency = 0.5
TabButtons.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabButtons

UIListLayout.Parent = TabButtons
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- ОСНОВНОЙ КОНТЕЙНЕР ДЛЯ ФУНКЦИЙ
Container.Name = "Container"
Container.Parent = MainFrame
Container.Position = UDim2.new(0, 120, 0, 40)
Container.Size = UDim2.new(0, 320, 0, 240)
Container.BackgroundTransparency = 0.5
Container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 8)
ContainerCorner.Parent = Container

-- 3. ПЕРЕМЕННЫЕ ДЛЯ ФУНКЦИЙ СНКРИПТА
_G.Autofarm = false
local LocalPlayer = game.Players.LocalPlayer

-- Функция авто-атаки (нажатие кликов мыши / ударов оружия)
local function AutoAttack()
    task.spawn(function()
        while _G.Autofarm do
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(851, 529)) -- Эмуляция клика по экрану
            task.wait(0.1)
        end
    end)
end

-- Функция поиска ближайшего NPC для авто-фарма
local function GetNearestNPC()
    local Nearest = nil
    local MinDistance = math.huge
    for _, npc in pairs(workspace.Enemies:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
            if Distance < MinDistance then
                MinDistance = Distance
                Nearest = npc
            end
        end
    end
    return Nearest
end

-- Основной цикл авто-фарма
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.Autofarm then
            pcall(function()
                local Target = GetNearestNPC()
                if Target then
                    -- Телепортация к врагу сверху, чтобы он вас не бил
                    LocalPlayer.Character.HumanoidRootPart.CFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                end
            end)
        end
    end
end)

-- 4. СОЗДАНИЕ СТРАНИЦ И КНОПОК
local Pages = {}

local function CreateTab(name)
    -- Кнопка вкладки
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.TextSize = 14
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.Parent = TabButtons
    
    -- Страница контента
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = Container
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)
    
    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.Padding = UDim.new(0, 5)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    
    Pages[name] = Page
    return Page
end

-- Создаем 3 вкладки
local MainTab = CreateTab("Фарм")
local RaidTab = CreateTab("Рейды")
local MiscTab = CreateTab("Разное")

-- Делаем первую вкладку видимой по умолчанию
Pages["Фарм"].Visible = true

-- ДОБАВЛЕНИЕ ФУНКЦИЙ НА ВКЛАДКУ «ФАРМ»
-- Переключатель Авто-Фарм + Авто-Атака
local FarmToggle = Instance.new("TextButton")
FarmToggle.Size = UDim2.new(0, 300, 0, 40)
FarmToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
FarmToggle.Text = "Авто-Фарм & Атака: ВЫКЛ"
FarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmToggle.Font = Enum.Font.GothamBold
FarmToggle.TextSize = 14
FarmToggle.Parent = MainTab

local FarmCorner = Instance.new("UICorner")
FarmCorner.CornerRadius = UDim.new(0, 6)
FarmCorner.Parent = FarmToggle

FarmToggle.MouseButton1Click:Connect(function()
    _G.Autofarm = not _G.Autofarm
    if _G.Autofarm then
        FarmToggle.Text = "Авто-Фарм & Атака: ВКЛ"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        AutoAttack()
    else
        FarmToggle.Text = "Авто-Фарм & Атака: ВЫКЛ"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    end
end)

-- ДОБАВЛЕНИЕ ФУНКЦИЙ НА ВКЛАДКУ «РЕЙДЫ»
local RaidButton = Instance.new("TextButton")
RaidButton.Size = UDim2.new(0, 300, 0, 40)
RaidButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RaidButton.Text = "Запустить Авто-Рейд (Тест)"
RaidButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RaidButton.Font = Enum.Font.Gotham
RaidButton.TextSize = 14
RaidButton.Parent = RaidTab

RaidButton.MouseButton1Click:Connect(function()
    print("Функция Авто-Рейда активирована! (Ожидает интеграции данжа)")
end)

-- ДОБАВЛЕНИЕ ФУНКЦИЙ НА ВКЛАДКУ «РАЗНОЕ»
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 300, 0, 40)
TeleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TeleportButton.Text = "ТП в Кафе (Второй Мир)"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.Gotham
TeleportButton.TextSize = 14
TeleportButton.Parent = MiscTab

TeleportButton.MouseButton1Click:Connect(function()
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1154, 73, 244)
    end)
end)

print("MbHub успешно загружен!")

