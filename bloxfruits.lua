-- Загружаем красивую и легкую UI библиотеку
local Library = loadstring(game:HttpGet("https://githubusercontent.com"))()
-- Создаем главное окно скрипта
local Window = Library.CreateLib("Menbf Hub | Blox Fruits PvP", "Midnight")

-- Создаем вкладку для функций
local MainTab = Window:NewTab("PvP Функции")
local MainSection = MainTab:NewSection("Авто-Наводка (Silent Aim)")

-- Переменные для работы аима
_G.AimbotEnabled = false
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Переключатель в меню (Вкл/Выкл)
MainSection:NewToggle("Включить Аимбот", "Автоматически наводит скиллы на врагов", function(state)
    _G.AimbotEnabled = state
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Menbf Hub",
            Text = "Аимбот успешно активирован!",
            Duration = 3
        })
    end
end)

-- Ползунок настройки радиуса захвата (FOV)
MainSection:NewSlider("Радиус захвата (FOV)", "Насколько близко к врагу должна быть мышка", 500, 50, function(v)
    _G.FOV_Radius = v
end)
_G.FOV_Radius = 300

-- Безопасный поиск ближайшего игрока
local function GetClosestPlayer()
    local ClosestTarget = nil
    local MaxDistance = _G.FOV_Radius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                local TargetPos = player.Character.HumanoidRootPart.Position
                local LocalPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                
                if LocalPos then
                    local Distance = (TargetPos - LocalPos).Magnitude
                    if Distance < MaxDistance then
                        MaxDistance = Distance
                        ClosestTarget = player
                    end
                end
            end
        end
    end
    return ClosestTarget
end

-- Безопасный перехват направления атаки (без поломки камеры)
local Hook; Hook = hookmetamethod(game, "__index", function(self, index)
    if index == "Hit" and _G.AimbotEnabled and not checkcaller() then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            return Target.Character.HumanoidRootPart.CFrame
        end
    end
    return Hook(self, index)
end)

-- Вкладка Инфо
local InfoTab = Window:NewTab("Информация")
local InfoSection = InfoTab:NewSection("Создатель: sascha3467w-lgtm")
InfoSection:NewLabel("Скрипт создан специально для Delta X")
