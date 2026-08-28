-- Удаляем старые копии интерфейса, если они зависли
if game.CoreGui:FindFirstChild("MenbfHubMobile") then
    game.CoreGui.MenbfHubMobile:Destroy()
end

-- Создаем супер-легкое мобильное окошко без сторонних библиотек
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "MenbfHubMobile"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Настройки главного окна (компактный размер, чтобы не выходить за границы)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Active = true
MainFrame.Draggable = true -- Меню можно двигать пальцем по экрану!

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
Title.Text = "Menbf Hub | Blox Fruits"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold

-- Кнопка Включения/Выключения Аима
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Text = "Silent Aim: ВЫКЛ"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18
ToggleBtn.Font = Enum.Font.SourceSansBold

-- Логика Аимбота
_G.AimbotActive = false
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

ToggleBtn.MouseButton1Click:Connect(function()
    _G.AimbotActive = not _G.AimbotActive
    if _G.AimbotActive then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        ToggleBtn.Text = "Silent Aim: ВКЛ"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ToggleBtn.Text = "Silent Aim: ВЫКЛ"
    end
end)

-- Поиск ближайшего врага (оптимизированный, без лагов)
local function GetClosestTarget()
    local Closest = nil
    local Dist = 400 -- Радиус работы аима
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
            if p.Character.Humanoid.Health > 0 then
                local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < Dist then
                    Dist = d
                    Closest = p
                end
            end
        end
    end
    return Closest
end

-- Безопасный перехват мыши
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, index)
    if index == "Hit" and _G.AimbotActive and not checkcaller() then
        local t = GetClosestTarget()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            return t.Character.HumanoidRootPart.CFrame
        end
    end
    return oldIndex(self, index)
end)

setreadonly(mt, true)
