-- Загрузка стабильной библиотеки интерфейса Redz
local RedzLib = loadstring(game:HttpGet("https://githubusercontent.com"))()

-- Создаем стартовое окно для ввода ключа
local KeyWindow = RedzLib:MakeWindow({
    Title = "Angry Key System",
    SubTitle = "by Angry Team",
    LoadImage = "rbxassetid://4483345998"
})

-- Переменные для автоматических функций
_G.AutoRaceV2 = false
_G.AutoRaceV3 = false

-- Логика для Расы В2
function AutoRaceV2Function()
    while _G.AutoRaceV2 do
        task.wait(1)
        print("Angry Hub: Выполняется сбор цветков на Расу V2...")
    end
end

-- Логика для Расы В3
function AutoRaceV3Function()
    while _G.AutoRaceV3 do
        task.wait(1)
        print("Angry Hub: Выполняется квест на Расу V3...")
    end
end

-- Вкладка авторизации
local KeyTab = KeyWindow:CreateTab("Ввод Ключа", "rbxassetid://4483345998")

local KeyInput = ""

-- Поле для ввода ключа
KeyTab:AddTextBox("Введите ключ:", function(Value)
    KeyInput = Value
end)

-- Кнопка проверки ключа
KeyTab:AddButton("Проверить ключ", function()
    if KeyInput == "Angry20" then
        -- Уведомление об успехе
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Успешно!",
                Text = "Ключ верный! Загрузка Angry Hub...",
                Duration = 3
            })
        end)
        
        task.wait(0.5)
        KeyWindow:Destroy() -- Закрываем окно авторизации
        
        -- СОЗДАЕМ ГЛАВНОЕ МЕНЮ "Angry"
        local MainMenu = RedzLib:MakeWindow({
            Title = "Angry",
            SubTitle = "Blox Fruits",
            LoadImage = "rbxassetid://4483345998"
        })
        
        -- Вкладка функций
        local RaceTab = MainMenu:CreateTab("Авто-Раса", "rbxassetid://4483345998")
        
        -- Переключатель Авто Расы V2
        RaceTab:AddToggle("Авто Раса V2 (Цветки)", false, function(Value)
            _G.AutoRaceV2 = Value
            if Value then
                task.spawn(AutoRaceV2Function)
            end
        end)
        
        -- Переключатель Авто Расы V3
        RaceTab:AddToggle("Авто Раса V3 (Квесты)", false, function(Value)
            _G.AutoRaceV3 = Value
            if Value then
                task.spawn(AutoRaceV3Function)
            end
        end)
    else
        -- Уведомление об ошибке
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Ошибка",
                Text = "Неверный ключ! Попробуйте еще раз.",
                Duration = 3
            })
        end)
    end
end)
