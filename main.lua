local SG = Instance.new("ScreenGui")
SG.Name = "MenBf_Pr"
SG.ResetOnSpawn = false
SG.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- ГЛАВНОЕ ОКНО
local MM = Instance.new("Frame")
MM.Size = UDim2.new(0, 340, 0, 220)
MM.Position = UDim2.new(0.5, -170, 0.5, -110)
MM.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MM.Visible = true
MM.Active = true MM.Draggable = true MM.Parent = SG
local St = Instance.new("UIStroke") St.Thickness = 4 St.Parent = MM

task.spawn(function()
    while true do
        for h = 0, 1, 1/100 do St.Color = Color3.fromHSV(h, 1, 1) task.wait(0.03) end
    end
end)

-- КНОПКА ПЕРЕКЛЮЧЕНИЯ ОКНА (Слева на экране)
local Tg = Instance.new("TextButton")
Tg.Size = UDim2.new(0, 50, 0, 50)
Tg.Position = UDim2.new(0, 10, 0.4, 0)
Tg.Text = "MenBf"
Tg.Visible = true
Tg.Active = true Tg.Draggable = true Tg.Parent = SG
Instance.new("UICorner", Tg).CornerRadius = UDim.new(0.5, 0)
Tg.MouseButton1Click:Connect(function() MM.Visible = not MM.Visible end)

-- КОНТЕЙНЕР ДЛЯ ВКЛАДОК (Справа от кнопок навигации)
local C_F = Instance.new("Frame") 
C_F.Size = UDim2.new(1, -95, 1, -10) 
C_F.Position = UDim2.new(0, 90, 0, 5) 
C_F.BackgroundTransparency = 1 
C_F.Parent = MM

local T1 = Instance.new("Frame") T1.Size = UDim2.new(1,0,1,0) T1.BackgroundTransparency = 1 T1.Visible = true T1.Parent = C_F
local T2 = Instance.new("Frame") T2.Size = UDim2.new(1,0,1,0) T2.BackgroundTransparency = 1 T2.Visible = false T2.Parent = C_F
local T3 = Instance.new("Frame") T3.Size = UDim2.new(1,0,1,0) T3.BackgroundTransparency = 1 T3.Visible = false T3.Parent = C_F

-- ФУНКЦИЯ СОЗДАНИЯ КНОПОК НАВИГАЦИИ (Слева в окне)
local function AddT(txt, y, f)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 75, 0, 30)
    b.Position = UDim2.new(0, 5, 0, y)
    b.Text = txt b.Parent = MM
    b.MouseButton1Click:Connect(function() 
        T1.Visible = false T2.Visible = false T3.Visible = false 
        f.Visible = true 
    end)
end
AddT("Combat", 10, T1) AddT("ESP", 45, T2) AddT("AimBot", 80, T3)

_G.AP = false _G.AS = false _G.AM = false
_G.EP = false _G.ES = false _G.EM = false
_G.KA = false _G.GG = false _G.FS = false _G.FM = false

-- ФУНКЦИЯ СОЗДАНИЯ ТУМБЛЕРОВ ФУНКЦИЙ
local function CreateBtn(txt, y, p, gv)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.95, 0, 0, 28)
    b.Position = UDim2.new(0, 0, 0, y)
    b.Text = txt .. " [OFF]"
    b.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Parent = p
    b.MouseButton1Click:Connect(function()
        _G[gv] = not _G[gv]
        b.Text = txt .. (_G[gv] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = _G[gv] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end)
end

CreateBtn("KillAura", 5, T1, "KA")
CreateBtn("Auto Grab Gun", 35, T1, "GG")
CreateBtn("Fling Sheriff", 65, T1, "FS")
CreateBtn("Fling Murder", 95, T1, "FM")

CreateBtn("ESP Players", 5, T2, "EP")
CreateBtn("ESP Sheriff", 35, T2, "ES")
CreateBtn("ESP Murder", 65, T2, "EM")

CreateBtn("Aim Players", 5, T3, "AP")
CreateBtn("Aim Sheriff", 35, T3, "AS")
CreateBtn("Aim Murder", 65, T3, "AM")

-- МГНОВЕННЫЙ НЕВИДИМЫЙ ФЛИНГ
local function FastGhostFling(targetHrp)
    local lp = game:GetService("Players").LocalPlayer
    local myChar = lp.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    
    local myHrp = myChar.HumanoidRootPart
    local safePosition = myHrp.CFrame 
    
    pcall(function()
        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bav.AngularVelocity = Vector3.new(0, 999999, 0)
        bav.Parent = myHrp
        
        if targetHrp and targetHrp.Parent then
            myHrp.CFrame = targetHrp.CFrame + Vector3.new(0, -1.5, 0)
            myHrp.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
        end
        
        task.wait(0.02)
        bav:Destroy()
    end)
    
    myHrp.CFrame = safePosition
    myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end

-- ЦИКЛ ХАКОВ
task.spawn(function()
    local lp = game:GetService("Players").LocalPlayer
    local cam = game:GetService("Workspace").CurrentCamera
    
    while task.wait(0.05) do
        if _G.GG and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local gun = game.Workspace:FindFirstChild("GunDrop") or game.Workspace:FindFirstChild("Gun") or game.Workspace:FindFirstChild("PlayerDrop")
            if gun then
                local targetPart = gun:IsA("BasePart") and gun or gun:FindFirstChildOfClass("BasePart")
                if targetPart then lp.Character.HumanoidRootPart.CFrame = targetPart.CFrame end
            end
        end
        
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local isM = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                local isS = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                
                -- HIGHLIGHT ESP
                local currentHighlight = p.Character:FindFirstChild("MenESP")
                if _G.EP or (_G.ES and isS) or (_G.EM and isM) then
                    if not currentHighlight then
                        local hl = Instance.new("Highlight")
                        hl.Name = "MenESP"
                        hl.FillTransparency = 0.4
                        hl.FillColor = isM and Color3.fromRGB(255,0,0) or (isS and Color3.fromRGB(0,0,255) or Color3.fromRGB(0,255,0))
                        hl.Parent = p.Character
                    end
                else
                    if currentHighlight then currentHighlight:Destroy() end
                end

                -- AIMBOT
                if _G.AP or (_G.AS and isS) or (_G.AM and isM) then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, hrp.Position)
                end

                -- KILL AURA
                if _G.KA and (lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")) and not isM then
                    local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                    if (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 22 then
                        knife.Parent = lp.Character knife:Activate()
                    end
                end

                -- ФЛИНГ
                if (_G.FS and isS) or (_G.FM and isM) then
                    FastGhostFling(hrp)
                end
            end
        end
    end
end)
