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
_G.AutoRaceV2 = false

-- Точные безопасные координаты для квеста
local BartiloCFrame = CFrame.new(-1030, 15, -2760)     -- Кафе (Бартило)
local SwanPiratesSpawn = CFrame.new(-1240, 15, -3900)  -- Спавн Пиратов Свана

-- Функция плавного полета (Обход анти-чита)
local function TweenTP(targetCFrame)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0,0,0)
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        if distance > 20 then
            local tweenInfo = TweenInfo.new(distance / 250, Enum.EasingStyle.Linear)
            local tween = game:GetService("TweenService"):Create(hrp, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
            tween.Completed:Wait()
        else
            hrp.CFrame = targetCFrame
        end
    end
end

-- Автоматический клик (Атака)
local function AutoClick()
    local virtualUser = game:GetService("VirtualUser")
    virtualUser:CaptureController()
    virtualUser:ClickButton1(Vector2.new(850, 520))
end

-- Использование оружия/боевого стиля в руке
local function EquipWeapon()
    if player.Backpack:GetChildren()[1] and not player.Character:FindFirstChildOfClass("Tool") then
        local tool = player.Backpack:FindFirstChildOfClass("Tool")
        if tool then player.Character.Humanoid:EquipTool(tool) end
    end
end

-- ПОТОК ДЛЯ ВЫПОЛНЕНИЯ КВЕСТА БАРТИЛО
task.defer(function()
    while true do
        task.wait(0.1)
        if _G.AutoBartilo then
            pcall(function()
                local questName = player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                
                -- Если квест Бартило не взят в интерфейсе игры
                if not string.find(questName, "Swan Pirate") then
                    -- Летим к Бартило в кафе
                    TweenTP(BartiloCFrame)
                    task.wait(0.5)
                    -- Говорим с ним через удаленный сервер игры
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bartilo", "Dialogue")
                else
                    -- Если квест взят, летим фармить 50 мобов
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
                    
                    -- Если нашли живого пирата Свана
                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        EquipWeapon()
                        -- Тепаемся чуть выше него, чтобы он нас не бил в ответ
                        TweenTP(targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        AutoClick()
                    else
                        -- Если мобов рядом нет, летим на точку их спавна ждать их появления
                        TweenTP(SwanPiratesSpawn)
                    end
                end
            end)
        end
    end
end)

-- Меню хака
local function CreateMainMenu()
    local MainMenuGui = Instance.new("ScreenGui")
    MainMenuGui.Name = "AngryMainGui"
    MainMenuGui.Parent = pgui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 220)
    Frame.Position = UDim2.new(0.5, -160, 0.4, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = MainMenuGui
    Instance.new("UICorner").Parent = Frame

    local MTitle = Instance.new("TextLabel")
    MTitle.Size = UDim2.new(1, 0, 0, 45)
    MTitle.Text = "Angry Hub — Bartilo Edition"
    MTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MTitle.TextSize = 20
    MTitle.Font = Enum.Font.SourceSansBold
    MTitle.BackgroundColor3 = Color3.fromRGB(160, 30, 30)
    MTitle.Parent = Frame

    -- КНОПКА 1: ФАРМ 50 ПИРАТОВ (КВЕСТ БАРТИЛО)
    local ToggleBartilo = Instance.new("TextButton")
    ToggleBartilo.Size = UDim2.new(0, 260, 0, 45)
    ToggleBartilo.Position = UDim2.new(0.5, -130, 0.3, 5)
    ToggleBartilo.Text = "Квест Бартило (50 мобов): ВЫКЛ"
    ToggleBartilo.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBartilo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBartilo.Font = Enum.Font.SourceSansBold
    ToggleBartilo.Parent = Frame
    Instance.new("UICorner").Parent = ToggleBartilo

    ToggleBartilo.MouseButton1Click:Connect(function()
        _G.AutoBartilo = not _G.AutoBartilo
        ToggleBartilo.Text = _G.AutoBartilo and "Квест Бартило (50 мобов): ВКЛ" or "Квест Бартило (50 мобов): ВЫКЛ"
        ToggleBartilo.BackgroundColor3 = _G.AutoBartilo and Color3.fromRGB(30, 150, 30) or Color3.fromRGB(40, 40, 40)
    end)

    -- КНОПКА 2: АВТО РАСА V2
    local ToggleV2 = Instance.new("TextButton")
    ToggleV2.Size = UDim2.new(0, 260, 0, 45)
    ToggleV2.Position = UDim2.new(0.5, -130, 0.65, 5)
    ToggleV2.Text = "Открыть Алхимика (Раса V2)"
    ToggleV2.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleV2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleV2.Font = Enum.Font.SourceSansBold
    ToggleV2.Parent = Frame
    Instance.new("UICorner").Parent = ToggleV2

    ToggleV2.MouseButton1Click:Connect(function()
        _G.AutoRaceV2 = true
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
        if remote then
            -- Тепаемся сразу к алхимику и активируем его, если квест Бартило уже сдан
            TweenTP(CFrame.new(614, 73, -4095))
            task.wait(0.5)
            remote:InvokeServer("Alchemist", "Dialogue")
        end
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
