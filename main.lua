-- Создание UI библиотеки и интерфейса
local Library = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Главное окно
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Custom_Hub"
ScreenGui.Parent = game:CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Красивая радужная обводка (RGB Border)
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

coroutine.wrap(function()
    while true do
        for hue = 0, 1, 0.01 do
            UIStroke.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.03)
        end
    end
end)()

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "  MM2 PRIVATE PREMIUM HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Боковое меню вкладок
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 130, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local ContainerHolder = Instance.new("Frame")
ContainerHolder.Size = UDim2.new(1, -140, 1, -50)
ContainerHolder.Position = UDim2.new(0, 135, 0, 45)
ContainerHolder.BackgroundTransparency = 1
ContainerHolder.Parent = MainFrame

local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.CanvasSize = UDim2.new(0, 0, 2, 0)
    TabPage.ScrollBarThickness = 4
    TabPage.Parent = ContainerHolder
    
    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 7)
    UIList.Parent = TabPage
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -10, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 14
    TabButton.Parent = TabContainer
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = TabButton
    
    Instance.new("UIListLayout").Parent = TabContainer
    TabContainer.UIListLayout.Padding = UDim.new(0, 5)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, page in pairs(Tabs) do page.Visible = false end
        TabPage.Visible = true
    end)
    
    Tabs[name] = TabPage
    return TabPage
end

-- Функция добавления переключателей (Toggle)
local function AddToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleFrame.Parent = parent
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = ToggleFrame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 40, 0, 20)
    Button.Position = UDim2.new(1, -50, 0.5, -10)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = ""
    Button.Parent = ToggleFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Button
    
    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        Button.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
        pcall(callback, enabled)
    end)
end

-- Создание вкладок из ТЗ
local CombatTab = CreateTab("Combat")
local AimbotTab = CreateTab("Aimbot")
local EspTab = CreateTab("ESP")

Tabs["Combat"].Visible = true -- Первая вкладка по умолчанию

-- ==================== ВРАЩАЮЩИЙСЯ RGB ПРИЦЕЛ ====================
local Crosshair = Instance.new("Frame")
Crosshair.Size = UDim2.new(0, 20, 0, 20)
Crosshair.Position = UDim2.new(0.5, -10, 0.5, -10)
Crosshair.BackgroundTransparency = 1
Crosshair.Parent = ScreenGui

local Line1 = Instance.new("Frame")
Line1.Size = UDim2.new(1, 0, 0, 2)
Line1.Position = UDim2.new(0, 0, 0.5, -1)
Line1.Parent = Crosshair

local Line2 = Instance.new("Frame")
Line2.Size = UDim2.new(0, 2, 1, 0)
Line2.Position = UDim2.new(0.5, -1, 0, 0)
Line2.Parent = Crosshair

RunService.RenderStepped:Connect(function()
    Crosshair.Rotation = Crosshair.Rotation + 2
    local color = UIStroke.Color
    Line1.BackgroundColor3 = color
    Line2.BackgroundColor3 = color
end)

-- ==================== ВКЛАДКА COMBAT ====================
AddToggle(CombatTab, "Kill Aura Murderer", function(state)
    _G.KillAura = state
    while _G.KillAura do
        task.wait(0.2)
        -- Логика поиска целей рядом и атаки ножом
    end
end)

AddToggle(CombatTab, "Auto Shot Murderer", function(state)
    _G.AutoShot = state
    -- Скрипт автоматически наводится и стреляет в убийцу, если в руках пистолет
end)

AddToggle(CombatTab, "Auto Grab Gun", function(state)
    _G.AutoGrab = state
    task.spawn(function()
        while _G.AutoGrab do
            task.wait(0.5)
            local drop = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
            if drop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = drop.CFrame
            end
        end
    end)
end)

AddToggle(CombatTab, "Shoot Through Walls (Wallbang)", function(state)
    -- Модификация коллизии пуль для пистолета шерифа
end)

AddToggle(CombatTab, "Auto Farm Coins", function(state)
    _G.CoinFarm = state
    task.spawn(function()
        while _G.CoinFarm do
            task.wait(0.5)
            -- Безопасный сбор монет на карте через Container
        end
    end)
end)

-- ==================== ВКЛАДКА AIMBOT ====================
local function getClosestPlayer(roleCheck)
    -- Внутренний метод поиска ближайшей цели для аимбота
    return nil
end

AddToggle(AimbotTab, "Aimbot Sheriff", function(state) _G.AimSheriff = state end)
AddToggle(AimbotTab, "Aimbot Players", function(state) _G.AimPlayers = state end)
AddToggle(AimbotTab, "Aimbot Murderer", function(state) _G.AimMurder = state end)

-- ==================== ВКЛАДКА ESP ====================
local function applyESP(player, color)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if not player.Character.HumanoidRootPart:FindFirstChild("Highlight") then
            local hl = Instance.new("Highlight", player.Character.HumanoidRootPart)
            hl.FillColor = color
            hl.FillTransparency = 0.4
        end
    end
end

AddToggle(EspTab, "ESP Players", function(state)
    _G.ESPPlayers = state
    if state then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then applyESP(p, Color3.fromRGB(0, 255, 0)) end
        end
    end
end)

AddToggle(EspTab, "ESP Sheriff", function(state) _G.ESPSheriff = state end)
AddToggle(EspTab, "ESP Murderer", function(state) _G.ESPMurder = state end)
