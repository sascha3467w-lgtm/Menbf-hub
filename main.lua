-- =================================================================
-- СКРИПТ: MbHub GOD v4 | Игра: Blox Fruits (Второе Море + Боссы)
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

-- Удаление старого GUI
if game.CoreGui:FindFirstChild("MbHubGui") then game.CoreGui.MbHubGui:Destroy() end

-- Переменные управления
_G.Autofarm = false
_G.ChestFarm = false
_G.AutoRaid = false
_G.BossFarm = false
_G.SelectedBoss = "Jeremy" -- По умолчанию

local LocalPlayer = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ФУНКЦИЯ ПЛАВНОГО И БЕЗОПАСНОГО ПОЛЕТА (TWEEN)
local function TweenTo(cframe, speed)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local distance = (character.HumanoidRootPart.Position - cframe.Position).Magnitude
    local duration = distance / speed
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(character.HumanoidRootPart, tweenInfo, {CFrame = cframe})
    tween:Play()
    tween.Completed:Wait()
end

-- ЖЕСТКАЯ АВТО-АТАКА + АВТО-КЛИКЕР
local function StartMegaAttack()
    task.spawn(function()
        while _G.Autofarm or _G.ChestFarm or _G.AutoRaid or _G.BossFarm do
            pcall(function()
                -- 1. Экипировка оружия
                if not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.Name == "Combat") then
                            LocalPlayer.Character.Humanoid:EquipTool(tool)
                            break
                        end
                    end
                end
                -- 2. Физический клик + Фаст Атак
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    local VirtualUser = game:GetService("VirtualUser")
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(851, 529))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.random(1, 9999))
                end
            end)
            task.wait(0.01) -- Бешеная скорость ударов
        end
    end)
end

-- ЛОГИКА ОПРЕДЕЛЕНИЯ КВЕСТА ДЛЯ 2 МОРЯ
local function GetQuestData()
    local lvl = LocalPlayer.Data.Level.Value
    if lvl >= 700 and lvl < 775 then return "Raider Quest Giver", "Area1Quest", 1, "Raider"
    elseif lvl >= 775 and lvl < 875 then return "Raider Quest Giver", "Area1Quest", 2, "Mercenary"
    elseif lvl >= 875 and lvl < 900 then return "Swan Bandit Quest Giver", "Area2Quest", 1, "Swan Bandit"
    else return "Raider Quest Giver", "Area1Quest", 1, "Raider" end
end

-- ЦИКЛ АВТО-КВЕСТА И АВТО-ФАРМА
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
                        task.wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", qName, qID)
                    end
                else
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy.Name == eName and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                            while _G.Autofarm and enemy.Humanoid.Health > 0 do
                                LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ФАРМ ВЫБРАННОГО БОССА (2 МОРЕ)
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.BossFarm then
            pcall(function()
                local bossName = _G.SelectedBoss
                local targetBoss = workspace.Enemies:FindFirstChild(bossName) or workspace:FindFirstChild(bossName, true)
                
                if targetBoss and targetBoss:FindFirstChild("HumanoidRootPart") and targetBoss.Humanoid.Health > 0 then
                    -- Летим к боссу и удерживаем позицию сверху
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetBoss.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                else
                    -- Если босса нет, летим на точку его спавна, чтобы подождать
                    if bossName == "Jeremy" then
                        TweenTo(CFrame.new(2316, 449, -782), 200)
                    elseif bossName == "Fajita" then
                        TweenTo(CFrame.new(-2085, 431, -1470), 200)
                    elseif bossName == "Diamond" then
                        TweenTo(CFrame.new(-1204, 332, -1524), 200)
                    end
                end
            end)
        end
    end
end)

-- БЕЗОПАСНЫЙ СБОР СУНДУКОВ (TWEEN ПО КАРТЕ)
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.ChestFarm then
            pcall(function()
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name:find("Chest") and (obj:IsA("Part") or obj:IsA("MeshPart")) then
                        TweenTo(obj.CFrame, 250)
                        task.wait(0.3)
                        break
                    end
                end
            end)
        end
    end
end)

-- =================================================================
-- ГРАФИЧЕСКИЙ ИНТЕРФЕЙС GUI (РАДУЖНЫЙ)
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local ContentScroll = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "MbHubGui"
ScreenGui.Parent = game.CoreGui

-- КНОПКА МВ (ДЛЯ СВЕРТЫВАНИЯ)
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

-- ГЛАВНОЕ РАДУЖНОЕ ОКНО
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
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "MbHub VIP v4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold

-- КОНТЕЙНЕР
ContentScroll.Parent = MainFrame
ContentScroll.Position = UDim2.new(0, 15, 0, 50)
ContentScroll.Size = UDim2.new(1, -30, 1, -65)
ContentScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ContentScroll.BackgroundTransparency = 0.5
ContentScroll.CanvasSize = UDim2.new(0, 0, 5, 0) -- Очень длинный скролл
Instance.new("UICorner").Parent = ContentScroll

UIListLayout.Parent = ContentScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- ФУНКЦИЯ СОЗДАНИЯ КНОПОК
local function CreateButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = ContentScroll
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
-- КНОПКИ ФУНКЦИЙ НА ЭКРАНЕ
-- ==========================================

-- 1. Авто-Фарм уровня + Квесты
local farmToggle = CreateButton("🔴 Включить Авто-Квест и Атаку", Color3.fromRGB(130, 30, 30), function()
    _G.Autofarm = not _G.Autofarm
        
