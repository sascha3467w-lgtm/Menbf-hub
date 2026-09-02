local SG = Instance.new("ScreenGui")
SG.Name = "MenBf_Pr"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local MM = Instance.new("Frame")
MM.Size = UDim2.new(0, 340, 0, 220)
MM.Position = UDim2.new(0.5, -170, 0.5, -110)
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

-- Создание КРАСИВОГО ВРАЩАЮЩЕГОСЯ ПРИЦЕЛА (Crosshair)
local Crosshair = Instance.new("Frame")
Crosshair.Size = UDim2.new(0, 20, 0, 20)
Crosshair.Position = UDim2.new(0.5, -10, 0.5, -10)
Crosshair.BackgroundTransparency = 1
Crosshair.Parent = SG

local Line1 = Instance.new("Frame")
Line1.Size = UDim2.new(1, 0, 0, 2)
Line1.Position = UDim2.new(0, 0, 0.5, -1)
Line1.BackgroundColor3 = Color3.fromRGB(255, 0, 85) -- Красивый неоновый цвет
Line1.BorderSizePixel = 0
Line1.Parent = Crosshair

local Line2 = Instance.new("Frame")
Line2.Size = UDim2.new(0, 2, 1, 0)
Line2.Position = UDim2.new(0.5, -1, 0, 0)
Line2.BackgroundColor3 = Color3.fromRGB(255, 0, 85)
Line2.BorderSizePixel = 0
Line2.Parent = Crosshair

-- Скрипт плавного вращения прицела
task.spawn(function()
    local angle = 0
    while task.wait(0.01) do
        angle = angle + 2
        Crosshair.Rotation = angle
    end
end)

-- Кнопка сворачивания меню
local Tg = Instance.new("TextButton")
Tg.Size = UDim2.new(0, 50, 0, 50)
Tg.Position = UDim2.new(0, 10, 0.4, 0)
Tg.Text = "MenBf"
Tg.Visible = true
Tg.Active = true Tg.Draggable = true Tg.Parent = SG
Instance.new("UICorner", Tg).CornerRadius = UDim.new(0.5, 0)
Tg.MouseButton1Click:Connect(function() MM.Visible = not MM.Visible end)

local C_F = Instance.new("Frame") 
C_F.Size = UDim2.new(0, 230, 0, 200) 
C_F.Position = UDim2.new(0, 95, 0, 10) 
C_F.BackgroundTransparency = 1 
C_F.ZIndex = 2
C_F.Parent = MM

local T1 = Instance.new("Frame") T1.Size = UDim2.new(1,0,1,0) T1.BackgroundTransparency = 1 T1.Visible = true T1.Parent = C_F
local T2 = Instance.new("Frame") T2.Size = UDim2.new(1,0,1,0) T2.BackgroundTransparency = 1 T2.Visible = false T2.Parent = C_F
local T3 = Instance.new("Frame") T3.Size = UDim2.new(1,0,1,0) T3.BackgroundTransparency = 1 T3.Parent = C_F

local function AddT(txt, y, f)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 80, 0, 30)
    b.Position = UDim2.new(0, 8, 0, y)
    b.Text = txt 
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.ZIndex = 3
    b.Parent = MM
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function() 
        T1.Visible = false T2.Visible = false T3.Visible = false 
        f.Visible = true 
    end)
end
AddT("Combat", 10, T1) AddT("ESP", 45, T2) AddT("AimBot", 80, T3)

-- Глобальные переменные функций
_G.AP = false _G.AS = false _G.AM = false
_G.EP = false _G.ES = false _G.EM = false
_G.KA = false _G.GG = false _G.FS = false _G.FM = false _G.ASM = false

local function CreateBtn(txt, y, p, gv)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.Position = UDim2.new(0, 0, 0, y)
    b.Text = txt .. " [OFF]"
    b.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.ZIndex = 4
    b.Parent = p
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        _G[gv] = not _G[gv]
        b.Text = txt .. (_G[gv] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = _G[gv] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end)
end

CreateBtn("KillAura", 2, T1, "KA")
CreateBtn("Auto Grab Gun", 30, T1, "GG")
CreateBtn("Fling Sheriff", 58, T1, "FS")
CreateBtn("Fling Murder", 86, T1, "FM")
CreateBtn("Auto Shot Murder", 114, T1, "ASM") -- НОВАЯ ФУНКЦИЯ

CreateBtn("ESP Players", 5, T2, "EP")
CreateBtn("ESP Sheriff", 38, T2, "ES")
CreateBtn("ESP Murder", 71, T2, "EM")

CreateBtn("Aim Players", 5, T3, "AP")
CreateBtn("Aim Sheriff", 38, T3, "AS")
CreateBtn("Aim Murder", 71, T3, "AM")

-- Метод Флинга (Fling)
local function FastGhostFling(targetHrp)
    local lp = game:GetService("Players").LocalPlayer
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

-- Основной цикл
task.spawn(function()
    local lp = game:GetService("Players").LocalPlayer
    local cam = game:GetService("Workspace").CurrentCamera
    
    while task.wait(0.04) do
        -- Автоподбор пистолета
        if _G.GG and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local gun = game.Workspace:FindFirstChild("GunDrop") or game.Workspace:FindFirstChild("Gun") or game.Workspace:FindFirstChild("PlayerDrop")
            if gun then
                local targetPart = gun:IsA("BasePart") and gun or gun:FindFirstChildOfClass("BasePart")
                if targetPart then lp.Character.HumanoidRootPart.CFrame = targetPart.CFrame end
            end
        end
        
        -- Перебор игроков
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
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

                -- Логика AUTO SHOT MURDER (Авто-выстрел в Мардера)
                if _G.ASM and isM then
                    local myGun = lp.Character:FindFirstChild("Gun") or lp.Backpack:FindFirstChild("Gun")
                    if myGun then
                        -- Берём пистолет в руки
                        myGun.Parent = lp.Character
                        -- Мгновенно целимся в торс мардера
                        cam.CFrame = CFrame.new(cam.CFrame.Position, hrp.Position)
                        -- Стреляем
                        myGun:Activate()
                    end
                end

                -- Киллаура (для Мардера)
                if _G.KA and (lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")) and not isM then
                    local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                    if (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 18 then
                        knife.Parent = lp.Character 
                        knife:Activate()
                    end
                end

                -- Флинг
                if (_G.FS and isS) or (_G.FM and isM) then
                    task.spawn(function() FastGhostFling(hrp) end)
                end
            end
        end
    end
end)
