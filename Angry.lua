-- Замените старый блок "ФОНОВЫЕ ФУНКЦИИ ДЛЯ РАБОТЫ АВТО-РАСЫ" на этот:

-- Переменные функций
_G.AutoRaceV2 = false
_G.AutoRaceV3 = false

-- БЕЗОПАСНАЯ ФУНКЦИЯ ТЕЛЕПОРТА (без отката анти-читом)
local function SecureTP(targetCFrame)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Чтобы убрать откат, сбрасываем скорость персонажа в 0 перед телепортом
        player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        task.wait(0.05)
        player.Character.HumanoidRootPart.CFrame = targetCFrame
        task.wait(0.3) -- Даем читу Delta время зафиксировать позицию
    end
end

-- Функция сбора цветов для V2
local function CollectFlowersV2()
    -- Цветов может не быть на сервере, проверяем все скрытые папки Workspace
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "Flower1" or v.Name == "Flower2" or v.Name == "Flower3" then
            SecureTP(v.CFrame)
            return -- Нашел один, сделал паузу
        end
    end
    -- Дополнительная проверка, если цветы лежат в специальной папке объектов
    if workspace:FindFirstChild("FlowerZone") then
        for _, v in pairs(workspace.FlowerZone:GetChildren()) do
            if string.find(v.Name, "Flower") then
                SecureTP(v.CFrame)
                return
            end
        end
    end
end

-- ОПТИМИЗИРОВАННЫЙ БЕЗОПАСНЫЙ ПОТОК
spawn(function()
    while true do
        task.wait(1.5) -- Оптимальный интервал для стабильности
        
        -- Логика для Авто Расы V2
        if _G.AutoRaceV2 then
            pcall(function()
                -- Берём/сдаем квест у Алхимика в Зеленой Зоне
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
                if remote then
                    remote:InvokeServer("Alchemist", "Dialogue")
                end
                -- Вызываем безопасный сбор цветов
                CollectFlowersV2()
            end)
        end
        
        -- Логика для Авто Расы V3
        if _G.AutoRaceV3 then
            pcall(function()
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
                if remote then
                    remote:InvokeServer("Arowe", "Dialogue")
                end
                
                -- Безопасный сбор сундуков для квеста Минка
                for _, v in pairs(workspace:GetChildren()) do
                    if string.find(v.Name, "Chest") and v:IsA("Part") then
                        SecureTP(v.CFrame)
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
end)
