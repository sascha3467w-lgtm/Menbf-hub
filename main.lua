-- ====================================================================
-- СКРИПТ: MenBf (для Murder Mystery 2)
-- КЛЮЧ ДЛЯ ВХОДА: Men1
-- ====================================================================

local CORRECT_KEY = "Men1"

-- Создаем основу для GUI (через CoreGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MenBf_MM2_Gui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Глобальные переменные настроек
_G.AimbotPlayers = false 
_G.AimbotSheriff = false 
_G.AimbotMurder = false
_G.EspPlayers = false 
_G.EspSheriff = false 
_G.EspMurder = false
_G.KillAura = false

-- Функция для определения ролей в MM2
local function GetPlayerRole(plr)
    if not plr or not plr:FindFirstChild("Backpack") or not plr.Character then return "Innocent" end
    if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") then return "Murder" end
    if plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- ====================================================================
-- 1. СИСТЕМА АВТОРИЗАЦИИ (КЛЮЧ)
-- ====================================================================
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Text = "MenBf MM2 — Введите ключ"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
KeyInput.PlaceholderText = "Ключ тут..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Parent = KeyFrame

local KeyButton = Instance.new("TextButton")
KeyButton.Size = UDim2.new(0.6, 0, 0, 30)
KeyButton.Position = UDim2.new(0.2, 0, 0.7, 0)
KeyButton.Text = "Вход"
KeyButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyButton.Parent = KeyFrame

-- ====================================================================
-- 2. КНОПКА ОТКРЫТИЯ/ЗАКРЫТИЯ (ПЛАВАЮЩАЯ)
-- ====================================================================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 15, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "MenBf"
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Visible = false
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0.5, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 3
ToggleStroke.Parent = ToggleButton
-- ====================================================================
-- 3. ГЛАВНОЕ ОКНО С РАДУЖНОЙ ОБВОДКОЙ
-- ====================================================================
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0, 420, 0, 280)
MainMenu.Position = UDim2.new(0.5, -210, 0.5, -140)
MainMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.Parent = ScreenGui

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Thickness = 4
MenuStroke.Parent = MainMenu

-- Скрипт переливания радуги (RGB)
task.spawn(function()
    while true do
        for hue = 0, 1, 1/360 do
            local rainbowColor = Color3.fromHSV(hue, 1, 1)
            MenuStroke.Color = rainbowColor
            ToggleStroke.Color = rainbowColor
            KeyFrame.BackgroundColor3 = rainbowColor
            task.wait(0.02)
        end
    end
end)

local MenuTitle = Instance.new("TextLabel")
MenuTitle.Size = UDim2.new(1, 0, 0, 35)
MenuTitle.Text = "  MenBf MM2 Premium Hub"
MenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
MenuTitle.TextSize = 16
MenuTitle.Font = Enum.Font.SourceSansBold
MenuTitle.Parent = MainMenu

-- Панель вкладок (Слева)
local TabPanel = Instance.new("Frame")
TabPanel.Size = UDim2.new(0, 110, 1, -35)
TabPanel.Position = UDim2.new(0, 0, 0, 35)
TabPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabPanel.Parent = MainMenu

-- Контейнеры для страниц (Справа)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -120, 1, -45)
ContentFrame.Position = UDim2.new(0, 115, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainMenu

local TabCombat = Instance.new("Frame") TabCombat.Size = UDim2.new(1,0,1,0) TabCombat.BackgroundTransparency = 1 TabCombat.Parent = ContentFrame
local TabEsp = Instance.new("Frame") TabEsp.Size = UDim2.new(1,0,1,0) TabEsp.BackgroundTransparency = 1 TabEsp.Visible = false TabEsp.Parent = ContentFrame
local TabAimbot = Instance.new("Frame") TabAimbot.Size = UDim2.new(1,0,1,0) TabAimbot.BackgroundTransparency = 1 TabAimbot.Visible = false TabAimbot.Parent = ContentFrame

-- Кнопки вкладок
local BtnCombat = Instance.new("TextButton") BtnCombat.Size = UDim2.new(0.9, 0, 0, 35) BtnCombat.Position = UDim2.new(0.05, 0, 0.05, 0) BtnCombat.Text = "Combat" BtnCombat.BackgroundColor3 = Color3.fromRGB(40,40,40) BtnCombat.TextColor3 = Color3.fromRGB(255,255,255) BtnCombat.Parent = TabPanel
local BtnEsp = Instance.new("TextButton") BtnEsp.Size = UDim2.new(0.9, 0, 0, 35) BtnEsp.Position = UDim2.new(0.05, 0, 0.25, 0) BtnEsp.Text = "ESP" BtnEsp.BackgroundColor3 = Color3.fromRGB(30,30,30) BtnEsp.TextColor3 = Color3.fromRGB(255,255,255) BtnEsp.Parent = TabPanel
local BtnAimbot = Instance.new("TextButton") BtnAimbot.Size = UDim2.new(0.9, 0, 0, 35) BtnAimbot.Position = UDim2.new(0.05, 0, 0.45, 0) BtnAimbot.Text = "AimBot" BtnAimbot.BackgroundColor3 = Color3.fromRGB(30,30,30) BtnAimbot.TextColor3 = Color3.fromRGB(255,255,255) BtnAimbot.Parent = TabPanel

-- Логика переключения Вкладок
BtnCombat.MouseButton1Click:Connect(function() TabCombat.Visible = true TabEsp.Visible = false TabAimbot.Visible = false BtnCombat.BackgroundColor3 = Color3.fromRGB(40,40,40) BtnEsp.BackgroundColor3 = Color3.fromRGB(30,30,30) BtnAimbot.BackgroundColor3 = Color3.fromRGB(30,30,30) end)
BtnEsp.MouseButton1Click:Connect(function() TabCombat.Visible = false TabEsp.Visible = true TabAimbot.Visible = false BtnCombat.BackgroundColor3 = Color3.fromRGB(30,30,30) BtnEsp.BackgroundColor3 = Color3.fromRGB(40,40,40) BtnAimbot.BackgroundColor3 = Color3.fromRGB(30,30,30) end)
BtnAimbot.MouseButton1Click:Connect(function() TabCombat.Visible = false TabEsp.Visible = false TabAimbot.Visible = true BtnCombat.BackgroundColor3 = Color3.fromRGB(30,30,30) BtnEsp.BackgroundColor3 = Color3.fromRGB(30,30,30) BtnAimbot.BackgroundColor3 = Color3.fromRGB(40,40,40) end)

-- Функция создания красивых переключателей
local function CreateToggle(name, text, pos, parent, globalVar)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.Position = pos
    btn.Text = text .. " [ВЫКЛ]"
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = parent

    btn.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        if _G[globalVar] then
            btn.Text = text .. " [ВКЛ]"
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            btn.Text = text .. " [ВЫКЛ]"
            btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        end
    end)
    return btn
end

-- ====================================================================
-- НАПОЛНЕНИЕ ВКЛАДОК (КНОПКИ ВКЛ/ВЫКЛ)
-- ====================================================================
CreateToggle("KillAura", "KillAura (Радиус атаки)", UDim2.new(0, 0, 0.05, 0), TabCombat, "KillAura")

CreateToggle("EspPlr", "ESP Players (Игроки)", UDim2.new(0, 0, 0.05, 0), TabEsp, "EspPlayers")
CreateToggle("EspShr", "ESP Sheriff (Шериф)", UDim2.new(0, 0, 0.25, 0), TabEsp, "EspSheriff")
CreateToggle("EspMrd", "ESP Murder (Убийца)", UDim2.new(0, 0, 0.45, 0), TabEsp, "EspMurder")

CreateToggle("AimPlr", "AimBot Players (Игроки)", UDim2.new(0, 0, 0.05, 0), TabAimbot, "AimbotPlayers")
CreateToggle("AimShr", "AimBot Sheriff (Шериф)", UDim2.new(0, 0, 0.25, 0), TabAimbot, "AimbotSheriff")
CreateToggle("AimMrd", "AimBot Murder (Убийца)", UDim2.new(0, 0, 0.45, 0), TabAimbot, "AimbotMurder")

-- ====================================================================
-- ФУНКЦИОНАЛЬНАЯ ЛОГИКА
-- ====================================================================

-- Проверка ключа
KeyButton.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame.Visible = false
        MainMenu.Visible = true
        ToggleButton.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "НЕВЕРНЫЙ КЛЮЧ!"
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

-- РАБОТА ЦИКЛОВ: ESP, AIMBOT, COMBAT
task.spawn(function()
    local localPlayer = game:GetService("Players").LocalPlayer
    local camera = game:GetService("Workspace").CurrentCamera

    while task.wait(0.1) do
        for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local role = GetPlayerRole(plr)
                local hrp = plr.Character.HumanoidRootPart
                
                -- Логика ESP
                local hasHighlight = hrp:FindFirstChild("MenBf_ESP")
                local shouldEsp = (_G.EspPlayers) or (_G.EspSheriff and role == "Sheriff") or (_G.EspMurder and role == "Murder")
                
                if shouldEsp then
                    if not hasHighlight then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "MenBf_ESP"
                        box.Size = plr.Character:GetExtentsSize()
                        box.AlwaysOnTop = true
                        box.ZIndex = 5
                        box.Adornee = hrp
                        box.Transparency = 0.4
                        box.Parent = hrp
                        
                        if role == "Murder" then box.Color3 = Color3.fromRGB(255, 0, 0)
                        elseif role == "Sheriff" then box.Color3 = Color3.fromRGB(0, 0, 255)
                        else box.Color3 = Color3.fromRGB(0, 255, 0) end
                    end
                else
                    if hasHighlight then hasHighlight:Destroy() end
                end

                -- Логика AIMBOT
                local shouldAim = (_G.AimbotPlayers) or (_G.AimbotSheriff and role == "Sheriff") or (_G.AimbotMurder and role == "Murder")
                if shouldAim and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (localPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < 120 then
                        camera.CFrame = CFrame.new(camera.CFrame.Position, hrp.Position)
                    end
                end

                -- Логика COMBAT
                if _G.KillAura and role == "Murder" then
                    if localPlayer.Character:FindFirstChild("Knife") and (localPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 25 then
                        localPlayer.Character.Knife:Activate()
                    end
                end

            end
        end
    end
end)
