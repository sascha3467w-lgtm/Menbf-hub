-- =================================================================
-- СКРИПТ: MbHub Premium v2 | Игра: Blox Fruits
-- =================================================================

-- 1. НАСТРОЙКА КЛЮЧА И АВТО-ХАКИ
local CorrectKey = "Menbf2"
local UserKey = "Menbf2" -- Ваш ключ авторизации

if UserKey ~= CorrectKey then
    game.Players.LocalPlayer:Kick("Неверный ключ для MbHub!")
    return
end

-- Автоматическое включение Хаки (Buso) при старте скрипта
task.spawn(function()
    pcall(function()
        task.wait(2)
        if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
            local args = { [1] = "Buso" }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end)
end)

-- Удаление старого интерфейса
if game.CoreGui:FindFirstChild("MbHubGui") then game.CoreGui.MbHubGui:Destroy() end

-- Переменные управления
_G.Autofarm = false
local LocalPlayer = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ФУНКЦИЯ БЕЗОПАСНОГО ПЕРЕМЕЩЕНИЯ (TWEEN)
local function TweenTo(cframe, speed)
    pcall(function()
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local distance = (character.HumanoidRootPart.Position - cframe.Position).Magnitude
        local duration = distance / speed
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(character.HumanoidRootPart, tweenInfo, {CFrame = cframe})
        tween:Play()
        tween.Completed:Wait()
    end)
end

-- НАДЕЖНАЯ АВТО-АТАКА И ЭКИПИРОВКА ОРУЖИЯ
local function StartAutoAttack()
    task.spawn(function()
        while _G.Autofarm or _G.ChestFarm or _G.AutoRaid do
            pcall(function()
                -- Авто-экипировка
                if not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.Name == "Combat") then
                            LocalPlayer.Character.Humanoid:EquipTool(tool)
                            break
                        end
                    end
                end
                -- Клик атаки
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(851, 529))
            end)
            task.wait(0.1)
        end
    end)
end

-- ЛОГИКА ОПРЕДЕЛЕНИЯ КВЕСТА ПО УРОВНЮ
local function GetQuestData()
    local lvl = LocalPlayer.Data.Level.Value
    if lvl >= 1 and lvl < 10 then return "Bandit Quest Giver", "BanditQuest1", 1, "Bandit"
    elseif lvl >= 10 and lvl < 15 then return "Monkey Quest Giver", "JungleQuest", 1, "Monkey"
    elseif lvl >= 15 and lvl < 30 then return "Monkey Quest Giver", "JungleQuest", 2, "Gorilla"
    else return "Bandit Quest Giver", "BanditQuest1", 1, "Bandit" end
end

-- ЛОГИКА ФАРМА КВЕСТОВ
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.Autofarm then
            pcall(function()
                local npcName, qName, qID, eName = GetQuestData()
                local hasQuest = LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") and LocalPlayer.PlayerGui.Main.Quest.Visible
                
                if not hasQuest then
                    local npc = workspace.NPCs:FindFirstChild(npcName) or workspace.NPCs:FindFirstChild(npcName, true)
                    if npc and npc:FindFirstChild("HumanoidRootPart") then
                        TweenTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3), 200)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", qName, qID)
                    end
                else
                    if workspace:FindFirstChild("Enemies") then
                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                            if enemy.Name == eName and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                                while _G.Autofarm and enemy.Humanoid.Health > 0 do
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ФАРМ СУНДУКОВ
_G.ChestFarm = false
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.ChestFarm then
            pcall(function()
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name:find("Chest") and obj:IsA("Part") or obj:FindFirstChild("TouchInterest") then
                        TweenTo(obj.CFrame, 250)
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
end)

-- 2. СОЗДАНИЕ МЕНЮ
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local TabContainer = Instance.new("Frame")
local ContentContainer = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "MbHubGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- КНОПКА ОТКРЫТИЯ/ЗАКРЫТИЯ (MB)
ToggleButton.Name = "MB_Toggle"
ToggleButton.Parent = ScreenGui
ToggleButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Text = "MB"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.Draggable = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton
ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- ГЛАВНОЕ РАДУЖНОЕ ОКНО (MbHub)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 260)
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
task.spawn(function() while task.wait(0.03) do UIGradient.Rotation = UIGradient.Rotation + 1 end end)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "MbHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold

-- КОНТЕЙНЕРЫ ДЛЯ ВКЛАДОК
TabContainer.Parent = MainFrame
TabContainer.Position = UDim2.new(0, 10, 0, 45)
TabContainer.Size = UDim2.new(0, 90, 0, 205)
TabContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TabContainer.BackgroundTransparency = 0.6
local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabContainer

UIListLayout.Parent = TabContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

ContentContainer.Parent = MainFrame
ContentContainer.Position = UDim2.new(0, 110, 0, 45)
ContentContainer.Size = UDim2.new(0, 300, 0, 205)
ContentContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ContentContainer.BackgroundTransparency = 0.6
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentContainer

-- ФУНКЦИЯ СОЗДАНИЯ ВКЛАДОК
local ActivePages = {}
local function CreateNewTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = TabContainer

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ContentContainer

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(ActivePages) do p.Visible = false end
        page.Visible = true
    end)
    ActivePages[name] = page
    return page
end

-- СТРАНИЦЫ
local FarmPage = CreateNewTab("Фарм")
local ChestPage = CreateNewTab("Сундуки")
local ShopPage = CreateNewTab("Магазин")
local RaidPage = CreateNewTab("Рейды")
ActivePages["Фарм"].Visible = true

-- НАПОЛНЕНИЕ ВКЛАДКИ ФАРМ
local fBtn = Instance.new("TextButton")
fBtn.Size = UDim2.new(0, 280, 0, 40)
fBtn.Position = UDim2.new(0, 10, 0, 10)
fBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
fBtn.Text = "Авто-Квест и Фарм: ВЫКЛ"
fBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fBtn.Font = Enum.Font.GothamBold
fBtn.Parent = FarmPage
Instance.new("UICorner").Parent = fBtn

fBtn.MouseButton1Click:Connect(function()
    _G.Autofarm = not _G.Autofarm
    if _G.Autofarm then
        fBtn.Text = "Авто-Квест и Фарм: ВКЛ"
        fBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 20)
        StartAutoAttack()
    else
        fBtn.Text = "Авто-Квест и Фарм: ВЫКЛ"
        fBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    end
end)

-- НАПОЛНЕНИЕ ВКЛАДКИ СУНДУКИ
local cBtn = Instance.new("TextButton")
