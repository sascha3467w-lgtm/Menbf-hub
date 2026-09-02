local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local SG = Instance.new("ScreenGui")
SG.Name = "MenBf_Pr_Fixed"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.IgnoreGuiInset = true -- Гарантирует идеальное центрирование прицела на телефонах
SG.Parent = game:GetService("CoreGui") or Players.LocalPlayer:WaitForChild("PlayerGui")

-- Главное меню
local MM = Instance.new("Frame")
MM.Size = UDim2.new(0, 360, 0, 230)
MM.Position = UDim2.new(0.5, -180, 0.5, -115)
MM.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MM.Visible = true
MM.Active = true MM.Draggable = true MM.Parent = SG
local St = Instance.new("UIStroke") St.Thickness = 4 St.Parent = MM

-- Радужная обводка меню
task.spawn(function()
    while true do
        for h = 0, 1, 1/100 do 
            if St and St.Parent then St.Color = Color3.fromHSV(h, 1, 1) end
            task.wait(0.03) 
        end
    end
end)

-- Создание красивого круглого RGB-прицела с полосками
local CrosshairContainer = Instance.new("Frame")
CrosshairContainer.Size = UDim2.new(0, 40, 0, 40)
CrosshairContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
CrosshairContainer.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairContainer.BackgroundTransparency = 1
CrosshairContainer.Parent = SG

-- Основной круг прицела
local CenterCircle = Instance.new("Frame")
CenterCircle.Size = UDim2.new(0, 16, 0, 16)
CenterCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterCircle.AnchorPoint = Vector2.new(0.5, 0.5)
CenterCircle.BackgroundTransparency = 1
CenterCircle.Parent = CrosshairContainer

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Thickness = 2
CircleStroke.Parent = CenterCircle

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = CenterCircle

-- 4 полоски вокруг круга
local lines = {}
for i = 1, 4 do
    local line = Instance.new("Frame")
    line.BorderSizePixel = 0
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    if i == 1 then -- Верхняя
        line.Size = UDim2.new(0, 2, 0, 8)
        line.Position = UDim2.new(0.5, 0, 0.5, -14)
    elseif i == 2 then -- Нижняя
        line.Size = UDim2.new(0, 2, 0, 8)
        line.Position = UDim2.new(0.5, 0, 0.5, 14)
    elseif i == 3 then -- Левая
        line.Size = UDim2.new(0, 8, 0, 2)
        line.Position = UDim2.new(0.5, -14, 0.5, 0)
    elseif i == 4 then -- Правая
        line.Size = UDim2.new(0, 8, 0, 2)
        line.Position = UDim2.new(0.5, 14, 0.5, 0)
    end
    line.Parent = CrosshairContainer
    table.insert(lines, line)
end

-- Скрипт RGB перелива и плавного вращения прицела
task.spawn(function()
    local angle = 0
    while task.wait(0.01) do
        angle = (angle + 1) % 360
        CrosshairContainer.Rotation = angle
        
        local color = Color3.fromHSV(angle / 360, 1, 1)
        CircleStroke.Color = color
        for _, l in ipairs(lines) do
            l.BackgroundColor3 = color
        end
    end
end)

-- Кнопка открытия/закрытия
local Tg = Instance.new("TextButton")
Tg.Size = UDim2.new(0, 55, 0, 55)
Tg.Position = UDim2.new(0, 15, 0.35, 0)
Tg.Text = "MenBf"
Tg.TextColor3 = Color3.fromRGB(255, 255, 255)
Tg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Tg.Visible = true
Tg.Active = true Tg.Draggable = true Tg.Parent = SG
Instance.new("UICorner", Tg).CornerRadius = UDim.new(0.5, 0)
local TgStroke = Instance.new("UIStroke") TgStroke.Thickness = 2 TgStroke.Color = Color3.fromRGB(255,255,255) TgStroke.Parent = Tg
Tg.MouseButton1Click:Connect(function() MM.Visible = not MM.Visible end)

-- Контейнер для списков функций
local C_F = Instance.new("Frame") 
C_F.Size = UDim2.new(0, 240, 0, 210) 
C_F.Position = UDim2.new(0, 105, 0, 10) 
C_F.BackgroundTransparency = 1 
C_F.Parent = MM

-- Функция создания прокручиваемой вкладки (убирает баг наложения кнопок)
local function CreateTabFrame()
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.ScrollBarThickness = 4
    f.Visible = false
    f.Parent = C_F
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = f
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        f.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    return f
end

local T1 = CreateTabFrame() T1.Visible = true -- Combat
local T2 = CreateTabFrame() -- ESP
local T3 = CreateTabFrame() -- AimBot

-- Создание боковых кнопок переключения вкладок
local function AddTabToggle(txt, y, f)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 85, 0, 32)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = txt 
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Parent = MM
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() 
        T1.Visible = false T2.Visible = false T3.Visible = false 
        f.Visible = true 
    end)
end
AddTabToggle("Combat", 15, T1) AddTabToggle("ESP", 55, T2) AddTabToggle("AimBot", 95, T3)

-- Инициализация переменных
_G.AP = false _G.AS = false _G.AM = false
_G.EP = false _G.ES = false _G.EM = false
_G.KA = false _G.GG = false _G.FS = false _G.FM = false _G.ASM = false

-- Автоматическое добавление кнопок в списки без пересечения координат
local function CreateBtn(txt, p, gv)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 30)
    b.Text = txt .. " [OFF]"
    b.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Parent = p
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function()
        _G[gv] = not _G[gv]
        b.Text = txt .. (_G[gv] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = _G[gv] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end)
end

-- Вкладка Combat
CreateBtn("KillAura", T1, "KA")
CreateBtn("Auto Grab Gun", T1, "GG")
CreateBtn("Fling Sheriff", T1, "FS")
CreateBtn("Fling Murder", T1, "FM")
CreateBtn("Auto Shot Murder", T1, "ASM")

-- Вкладка ESP
CreateBtn("ESP Players", T2, "EP")
CreateBtn("ESP Sheriff", T2, "ES")
CreateBtn("ESP Murder", T2, "EM")

-- Вкладка AimBot
CreateBtn("Aim Players", T3, "AP")
CreateBtn("Aim Sheriff", T3, "AS")
CreateBtn("Aim Murder", T3, "AM")

-- Исправленный метод Флинга
local function FastGhostFling(targetHrp)
    local lp = Players.LocalPlayer
    local myChar = lp.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    
    local myHrp = myChar.HumanoidRootPart
    local safePosition = myHrp.CFrame 
    
    pcall(function()
        if targetHrp and targetHrp.Parent then
            myHrp.CFrame = targetHrp.CFrame + Vector3.new(0, 1, 0)
            myHrp.Velocity = Vector3.new(99999, 99999, 99999)
            myHrp.RotVelocity = Vector3.new(0, 99999, 0)
            task.wait(0.1)
        end
    end)
    
    myHrp.CFrame = safePosition
    myHrp.Velocity = Vector3.new(0, 0, 0)
    myHrp.RotVelocity = Vector3.new(0, 0, 0)
end

-- Основной оптимизированный цикл
task.spawn(function()
    local lp = Players.LocalPlayer
    local cam = Workspace.CurrentCamera
    
    while task.wait(0.04) do
        if _G.GG and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local gun = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun") or Workspace:FindFirstChild("PlayerDrop")
            if gun then
                local targetPart = gun:IsA("BasePart") and gun or gun:FindFirstChildOfClass("BasePart")
                if targetPart then lp.Character.HumanoidRootPart.CFrame = targetPart.CFrame end
            end
        end
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local isM = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                local isS = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                
                -- Подсветка (ESP)
                local currentHighlight = p.Character:FindFirstChild("MenESP")
                if _G.EP or (_G.ES and isS) or (_G.EM and isM) then
                    if not currentHighlight then
                        local hl = Instance.new("Highlight")
                        hl.Name = "MenESP"
                        hl.FillTransparency = 0.4
                        hl.OutlineTransparency = 0.2
                        hl.FillColor = isM and Color3.fromRGB(255,0,0) or (isS and Color3.fromRGB(0,0,255) or Color3.fromRGB(0,255,0))
                        hl.Parent = p.Character
                    else
                        currentHighlight.FillColor = isM and Color3.fromRGB(255,0,0) or (isS and Color3.fromRGB(0,0,255) or Color3.fromRGB(0,255,0))
                    end
                else
                    if currentHighlight then currentHighlight:Destroy() end
                end

                -- Аимбот
                if (_G.AP) or (_G.AS and isS) or (_G.AM and isM) then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, hrp.Position)
                end

                -- Auto Shot Murder
                if _G.ASM and isM then
                    local myGun = lp.Character:FindFirstChild("Gun") or lp.Backpack:FindFirstChild("Gun")
                    if myGun then
                        myGun.Parent = lp.Character
                        cam.CFrame = CFrame.new(cam.CFrame.Position, hrp.Position)
                        myGun:Activate()
                    end
                end

                -- Киллаура
                    
