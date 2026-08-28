-- =================================================================
-- ОБНОВЛЕННЫЙ СКРИПТ: MbHub | Игра: Blox Fruits (Авто-Квесты)
-- =================================================================

-- 1. СИСТЕМА КЛЮЧА
local CorrectKey = "MenBf2"
local UserKey = "MenBf2"

if UserKey ~= CorrectKey then
    game.Players.LocalPlayer:Kick("Неверный ключ для MbHub!")
    return
end

-- Удаление старой копии GUI
if game.CoreGui:FindFirstChild("MbHubGui") then
    game.CoreGui.MbHubGui:Destroy()
end

-- Переменные
_G.Autofarm = false
local LocalPlayer = game.Players.LocalPlayer

-- Вспомогательная функция автоматической экипировки оружия
local function EquipWeapon()
    pcall(function()
        if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            -- Ищет стиль боя или меч в инвентаре и берет в руки
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.Name == "Combat") then
                    LocalPlayer.Character.Humanoid:EquipTool(tool)
                    break
                end
            end
        end
    end)
end

-- Функция имитации кликов / авто-атаки
local function AutoAttack()
    task.spawn(function()
        while _G.Autofarm do
            pcall(function()
                EquipWeapon() -- Автоматом берем оружие в руку
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(851, 529))
            end)
            task.wait(0.1)
        end
    end)
end

-- Функция определения текущего квеста в зависимости от уровня (Первый мир)
local function GetQuestData()
    local Level = LocalPlayer.Data.Level.Value
    local QuestNPC, QuestName, QuestID, EnemyName
    
    if Level >= 1 and Level < 10 then
        QuestNPC = "Bandit Quest Giver"
        QuestName = "BanditQuest1"
        QuestID = 1
        EnemyName = "Bandit"
    elseif Level >= 10 and Level < 15 then
        QuestNPC = "Monkey Quest Giver"
        QuestName = "JungleQuest"
        QuestID = 1
        EnemyName = "Monkey"
    elseif Level >= 15 and Level < 30 then
        QuestNPC = "Monkey Quest Giver"
        QuestName = "JungleQuest"
        QuestID = 2
        EnemyName = "Gorilla"
    else
        -- Заглушка, если уровень выше стартовых островов
        QuestNPC = "Bandit Quest Giver"
        QuestName = "BanditQuest1"
        QuestID = 1
        EnemyName = "Bandit"
    end
    return QuestNPC, QuestName, QuestID, EnemyName
end

-- Главная функция проверки и взятия квеста
local function CheckAndTakeQuest(questNPC, questName, questID)
    local hasQuest = LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") and LocalPlayer.PlayerGui.Main.Quest.Visible
    if not hasQuest then
        -- Телепорт к квест-гиверу
        local npc = workspace.NPCs:FindFirstChild(questNPC) or workspace.NPCs:FindFirstChild(questNPC, true)
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            task.wait(0.5)
            -- Отправка сигнала серверу о взятии квеста
            local args = { [1] = "StartQuest", [2] = questName, [3] = questID }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end

-- Поиск врагов по имени из квеста
local function GetTargetEnemy(enemyName)
    local Nearest = nil
    local MinDistance = math.huge
    if workspace:FindFirstChild("Enemies") then
        for _, npc in pairs(workspace.Enemies:GetChildren()) do
            if npc.Name == enemyName and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                if Distance < MinDistance then
                    MinDistance = Distance
                    Nearest = npc
                end
            end
        end
    end
    return Nearest
end

-- Основной цикл фарма и квестов
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.Autofarm then
            pcall(function()
                local qNPC, qName, qID, eName = GetQuestData()
                
                -- Проверяем квест: если его нет — берем
                local hasQuest = LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") and LocalPlayer.PlayerGui.Main.Quest.Visible
                if not hasQuest then
                    CheckAndTakeQuest(qNPC, qName, qID)
                else
                    -- Если квест есть, летим убивать нужных мобов
                    local Target = GetTargetEnemy(eName)
                    if Target then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    end
                end
            end)
        end
    end
end)

-- 2. ГРАФИЧЕСКИЙ ИНТЕРФЕЙС (GUI)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local FarmButton = Instance.new("TextButton")
local TeleportButton = Instance.new("TextButton")

ScreenGui.Name = "MbHubGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- КНОПКА МВ (СВЕРНУТЬ/РАЗВЕРНУТЬ)
ToggleButton.Name = "MB_Toggle"
ToggleButton.Parent = ScreenGui
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Text = "MB"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ОКНО МЕНЮ (РАДУЖНОЕ)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})
UIGradient.Parent = MainFrame

task.spawn(function()
    while task.wait(0.03) do
        UIGradient.Rotation = UIGradient.Rotation + 2
    end
end)

Title.Name = "Title"
Title.Parent = MainFrame
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "MbHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold

-- КНОПКА «АВТО-КВЕСТ + ФАРМ»
FarmButton.Name = "FarmButton"
FarmButton.Parent = MainFrame
FarmButton.Position = UDim2.new(0.1, 0, 0.3, 0)
FarmButton.Size = UDim2.new(0, 240, 0, 40)
FarmButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FarmButton.Text = "Авто-Квест & Фарм: ВЫКЛ"
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.TextSize = 14
FarmButton.Font = Enum.Font.GothamBold

local ButtonCorner1 = Instance.new("UICorner")
ButtonCorner1.CornerRadius = UDim.new(0, 6)
ButtonCorner1.Parent = FarmButton

FarmButton.MouseButton1Click:Connect(function()
    _G.Autofarm = not _G.Autofarm
    if _G.Autofarm then
        FarmButton.Text = "Авто-Квест & Фарм: ВКЛ"
        FarmButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        AutoAttack()
    else
        FarmButton.Text = "Авто-Квест & Фарм: ВЫКЛ"
        FarmButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- КНОПКА ТЕЛЕПОРТА
TeleportButton.Name = "TeleportButton"
TeleportButton.Parent = MainFrame
TeleportButton.Position = UDim2.new(0.1, 0, 0.6, 0)
TeleportButton.Size = UDim2.new(0, 240, 0, 40)
TeleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TeleportButton.Text = "ТП в Кафе (2 Мир)"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextSize = 16
TeleportButton.Font = Enum.Font.GothamBold

local ButtonCorner2 = Instance.new("UICorner")
ButtonCorner2.CornerRadius = UDim.new(0, 6)
ButtonCorner2.Parent = TeleportButton

TeleportButton.MouseButton1Click:Connect(function()
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1154, 73, 244)
    end)
end)
