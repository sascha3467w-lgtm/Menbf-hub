-- Настройки скрипта
local Settings = {
    Enabled = true,        -- Включить/выключить аимбот (true/false)
    TeamCheck = false,     -- Проверять на союзников (для Blox Fruits лучше false)
    WallCheck = false,     -- Проверять стены (простреливать ли сквозь текстуры)
    TargetRadius = 300,    -- Радиус захвата цели (в пикселях на экране)
}

-- Сервисы Roblox
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Функция поиска ближайшего противника в радиусе экрана
local function GetClosestPlayer()
    local ClosestTarget = nil
    local MaxDistance = Settings.TargetRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            -- Проверяем, что противник жив
            if player.Character.Humanoid.Health > 0 then
                -- Переводим 3D координаты игрока в 2D координаты экрана
                local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                
                if OnScreen then
                    -- Считаем расстояние от курсора мыши до противника
                    local MouseDistance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(ScreenPosition.X, ScreenPosition.Y)).Magnitude
                    
                    if MouseDistance < MaxDistance then
                        -- Если включена проверка стен, проверяем видимость
                        if Settings.WallCheck then
                            local Parts = Camera:GetPartsObscuringTarget({player.Character.HumanoidRootPart.Position}, {LocalPlayer.Character, player.Character})
                            if #Parts == 0 then
                                MaxDistance = MouseDistance
                                ClosestTarget = player
                            end
                        else
                            MaxDistance = MouseDistance
                            ClosestTarget = player
                        end
                    end
                end
            end
        end
    end
    return ClosestTarget
end

-- Хук (перехват) игрового метода для перенаправления скиллов
local MetaTable = getrawmetatable(game)
local OldIndex = MetaTable.__index
local OldNamecall = MetaTable.__namecall
setreadonly(MetaTable, false)

-- Перехватываем координаты мыши (куда летит скилл)
MetaTable.__index = newcclosure(function(self, index)
    if index == "Hit" and Settings.Enabled and not checkcaller() then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            return Target.Character.HumanoidRootPart.CFrame
        end
    end
    return OldIndex(self, index)
end)

-- Перехватываем направление выстрела/скилла
MetaTable.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    
    if Settings.Enabled and not checkcaller() then
        if Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRayWithWhitelist" or Method == "Raycast" then
            local Target = GetClosestPlayer()
            if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                -- Перенаправляем луч атаки прямо в торс врага
                return OldNamecall(self, Ray.new(Camera.CFrame.Position, (Target.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Unit * 10000))
            end
        end
    end
    
    return OldNamecall(self, ...)
end)

setreadonly(MetaTable, true)
print("Menbf-hub: Blox Fruits PvP Silent Aim успешно загружен!")
