-- =================================================================
-- СКРИПТ: MbHub VIP Mega | Игра: Blox Fruits (Исправленные кнопки)
-- =================================================================

-- НАСТРОЙКА КЛЮЧА И МГНОВЕННЫЙ АВТО-ХАКИ
local CorrectKey = "Menbf2"
local UserKey = "Menbf2" 

if UserKey ~= CorrectKey then
    game.Players.LocalPlayer:Kick("Неверный ключ для MbHub!")
    return
end

-- Мгновенная активация Хаки (Buso) при инжекте
task.spawn(function()
    pcall(function()
        local args = { [1] = "Buso" }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end)
end)

-- Удаление старого GUI, если оно запущено
if game.CoreGui:FindFirstChild("MbHubGui") then game.CoreGui.MbHubGui:Destroy() end

-- Глобальные переключатели
_G.Autofarm = false
_G.ChestFarm = false
_G.AutoRaid = false

local LocalPlayer = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ФУНКЦИЯ БЕЗОПАСНОГО И ПЛАВНОГО ТЕЛЕПОРТА (TWEEN)
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

-- ЖЕСТКАЯ АВТО-АТАКА И АВТО-ЭКИПИРОВКА ОРУЖИЯ
local function FastAttack()
    task.spawn(function()
        while _G.Autofarm or _G.ChestFarm or _G.AutoRaid do
            pcall(function()
                -- Авто-экипировка (берет боевой стиль или меч)
                if not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.Name == "Combat") then
                            LocalPlayer.Character.Humanoid:EquipTool(tool)
                            break
                        end
                    end
                end
                -- Сама безумно кликает и наносит урон
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.random(1, 9999))
                end
            end)
            task.wait(0.01) -- Бешеная скорость кликов
        end
    end)
end

-- АВТО-КВЕСТ + АВТО-ФАРМ (УМНЫЙ ПОДБОР ПО УРОВНЮ)
local function GetQuestData()
    local lvl = LocalPlayer.Data.Level.Value
    if lvl >= 1 and lvl < 10 then return "Bandit Quest Giver", "BanditQuest1", 1, "Bandit"
    elseif lvl >= 10 and lvl < 15 then return "Monkey Quest Giver", "JungleQuest", 1, "Monkey"
    elseif lvl >= 15 and lvl < 30 then return "Monkey Quest Giver", "JungleQuest", 2, "Gorilla"
    elseif lvl >= 700 and lvl < 775 then return "Raider Quest Giver", "Area1Quest", 1, "Raider"
    elseif lvl >= 1500 and lvl < 1575 then return "Boat Quest Giver", "BoatQuest1", 1, "Pirate Millionaire"
    else return "Bandit Quest Giver", "BanditQuest1", 1, "Bandit" end
end

task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.Autofarm then
            pcall(function()
                local npcName, qName, qID, eName = GetQuestData()
                local hasQuest = LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") and LocalPlayer.PlayerGui.Main.Quest.Visible
                
                if not hasQuest then
                    local npc = workspace.NPCs:FindFirstChild(npcName) or workspace.NPCs:FindFirstChild(npcName, true)
                    if npc and npc:FindFirstChild("HumanoidRootPart") then
                        TweenTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3), 250)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", qName, qID)
                    end
                else
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy.Name == eName and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                            while _G.Autofarm and enemy.Humanoid.Health > 0 do
                                LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ЛОГИКА АВТО-СБОРА СУНДУКОВ ПО КАРТЕ
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.ChestFarm then
            pcall(function()
                local foundChest = false
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name:find("Chest") and (obj:IsA("Part") or obj:IsA("MeshPart")) then
                        foundChest = true
                        TweenTo(obj.CFrame, 350)
                        task.wait(0.2)
                    end
                end
                if not foundChest and workspace:FindFirstChild("ChestModels") then
                    for _, obj in pairs(workspace.ChestModels:GetChildren()) do
                        TweenTo(obj.CFrame, 350)
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
end)

-- СОЗДАНИЕ КРАСИВОГО GUI
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

-- КНОПКА СВЕРНУТЬ/РАЗВЕРНУТЬ (MB)
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
Instance.new("UICorner").Parent = ToggleButton
ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- ГЛАВНОЕ ОКНО С ПЕРЕЛИВОМ РАДУГИ
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 440, 0, 320)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner").Parent = MainFrame

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

-- ВЕРХНЯЯ ПАНЕЛЬ ДЛЯ КНОПОК ВКЛАДОК
TabContainer.Parent = MainFrame
TabContainer.Position = UDim2.new(0, 10, 0, 40)
TabContainer.Size = UDim2.new(1, -20, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TabContainer.BackgroundTransparency = 0.6
Instance.new("UICorner").Parent = TabContainer

UIListLayout.Parent = TabContainer
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- КОНТЕЙНЕР ДЛЯ СТРАНИЦ
ContentContainer.Parent = MainFrame
ContentContainer.Position = UDim2.new(0, 10, 0, 90)
ContentContainer.Size = UDim2.new(1, -20, 0, 220)
ContentContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ContentContainer.BackgroundTransparency = 0.6
Instance.new("UICorner").Parent = ContentContainer

-- ЛОГИКА ВКЛАДОК
local ActivePages = {}
local function CreateNewTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = TabContainer
    Instance.new("UICorner").Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ContentContainer
    page.CanvasSize = UDim2.new(0, 0, 3, 0)
    
    local pList = Instance.new("UIListLayout")
    pList.Parent = page
    pList.Padding = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(ActivePages) do p.Visible = false end
        page.Visible = true
    end)
    ActivePages[name] = page
    return page
end

-- СОЗДАНИЕ СТРАНИЦ
local FarmPage = CreateNewTab("Фарм")
local ChestPage = CreateNewTab("Сундуки")
local ShopPage = CreateNewTab("Магазин")
local RaidPage = CreateNewTab("Рейды")
ActivePages["Фарм"].Visible = true

-- [ВКЛАДКА ФАРМ]
local fBtn = Instance.new("TextButton")
fBtn.Size = UDim2.new(1, 0, 0, 45)
fBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
fBtn.Text = "Авто-Квест и Атака: ВЫКЛ"
