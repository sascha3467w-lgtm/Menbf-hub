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
_G.AutoBartilo = false

-- Точные безопасные координаты для квеста
local BartiloCFrame = CFrame.new(-1030, 15, -2760)     -- Возле Бартило в Кафе
local SwanPiratesSpawn = CFrame.new(-1240, 15, -3900)  -- Спавн Пиратов Свана

-- Функция жесткого телепорта с защитой от отката (приостановка скорости)
local function SecureTP(targetCFrame)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0,0,0)
        task.wait(0.05)
        hrp.CFrame = targetCFrame
        task.wait(0.2)
    end
end

-- Автоматический клик мыши/тапа экрана
local function AutoClick()
    local virtualUser = game:GetService("VirtualUser")
    virtualUser:CaptureController()
    virtualUser:ClickButton1(Vector2.new(850, 520))
end

-- Проверка и экипировка любого оружия из инвентаря
local function EquipWeapon()
    if player.Backpack and not player.Character:FindFirstChildOfClass("Tool") then
        local tool = player.Backpack:FindFirstChildOfClass("Tool")
        if tool then player.Character.Humanoid:EquipTool(tool) end
    end
end

-- ИСПРАВЛЕННЫЙ ЦИКЛ КВЕСТА БАРТИЛО
task.defer(function()
    while true do
        task.wait(0.5) -- Оптимальная задержка против фризов
        
        if _G.AutoBartilo then
            pcall(function()
                -- Проверяем, взят ли квест на экране игры
                local mainGui = player.PlayerGui:FindFirstChild("Main")
                local questTitle = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest:FindFirstChild("Container") and mainGui.Quest.Container:FindFirstChild("QuestTitle") and mainGui.Quest.Container.QuestTitle:FindFirstChild("Title")
                local hasQuest = questTitle and string.find(questTitle.Text, "Swan Pirate")
                
                if not hasQuest then
                    -- ШАГ 1: Летим к Бартило
                    SecureTP(BartiloCFrame)
                    task.wait(0.3)
                    
                    -- Триггерим диалог
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
                    if remote then
                        remote:InvokeServer("Bartilo", "Dialogue")
                    end
                    task.wait(0.5)
                    
                    -- ИМИТАЦИЯ НАЖАТИЯ ДИАЛОГА (Прокликиваем меню Бартило)
                    local dialogGui = player.PlayerGui:FindFirstChild("DialogueController")
                    if dialogGui and dialogGui:FindFirstChild("BG") and dialogGui.BG.Visible then
                        -- Ищем кнопку "Next" или "Sure" в диалоговом окне игры и кликаем
                        local options = dialogGui.BG:FindFirstChild("Options")
                        if options then
                            for _, btn in pairs(options:GetChildren()) do
                                if btn:IsA("TextButton") and btn.Visible then
                                    -- Кликаем на первый попавшийся доступный ответ (Next/Sure)
                                    local events = getconnections(btn.MouseButton1Click)
                                    for _, connection in pairs(events) do
                                        connection:Fire()
                                    end
                                end
                            end
                        end
                    end
                else
                    -- ШАГ 2: Квест взят, летим фармить пиратов
                    local enemies = workspace:FindFirstChild("Enemies")
                    local targetMob = nil
                    
                    if enemies then
                        for _, v in pairs(enemies:GetChildren()) do
                            if v.Name == "Swan Pirate" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                    end
                    
                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        EquipWeapon()
                        -- Телепортируемся прямо сверху над пиратом (безопасная зона)
                        SecureTP(targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0))
                        AutoClick()
                    else
                        -- Если живых пиратов временно нет, стоим на точке их респавна
                        SecureTP(SwanPiratesSpawn)
                    end
                end
            end)
        end
    end
end)

-- Создание интерфейса хака
local function CreateMainMenu()
    local MainMenuGui = Instance.new("ScreenGui")
    MainMenuGui.Name = "AngryMainGui"
    MainMenuGui.Parent = pgui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 150)
    Frame.Position = UDim2.new(0.5, -160, 0.4, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = MainMenuGui
    Instance.new("UICorner").Parent = Frame

    local MTitle = Instance.new("TextLabel")
    MTitle.Size = UDim2.new(1, 0, 0, 45)
    MTitle.Text = "Angry Hub — Fixed Bartilo"
    MTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MTitle.TextSize = 20
    MTitle.Font = Enum.Font.SourceSansBold
    MTitle.BackgroundColor3 = Color3.fromRGB(160, 30, 30)
    MTitle.Parent = Frame

    -- Переключатель квеста
    local ToggleBartilo = Instance.new("TextButton")
    ToggleBartilo.Size = UDim2.new(0, 260, 0, 50)
    ToggleBartilo.Position = UDim2.new(0.5, -130, 0.45, 5)
    ToggleBartilo.Text = "Квест Бартило (50 пиратов): ВЫКЛ"
    ToggleBartilo.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBartilo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBartilo.Font = Enum.Font.SourceSansBold
    ToggleBartilo.Parent = Frame
    Instance.new("UICorner").Parent = ToggleBartilo

    ToggleBartilo.MouseButton1Click:Connect(function()
        _G.AutoBartilo = not _G.AutoBartilo
        ToggleBartilo.Text = _G.AutoBartilo and "Квест Бартило (50 пиратов): ВКЛ" or "Квест Бартило (50 пиратов): ВЫКЛ"
        ToggleBartilo.BackgroundColor3 = _G.AutoBartilo and Color3.fromRGB(30, 150, 30) or Color3.fromRGB(40, 40, 40)
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
