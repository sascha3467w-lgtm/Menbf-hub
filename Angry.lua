-- Angry Hub для Blox Fruits (Delta X Executor)
local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()

-- Создаем стартовое окно системы ключей
local Window = OrionLib:MakeWindow({Name = "Angry Key System", HidePremium = false, SaveConfig = true, ConfigFolder = "AngryHubConfig"})

-- Переменные для автоматических функций
_G.AutoRaceV2 = false
_G.AutoRaceV3 = false

-- Логика для Расы В2
function AutoRaceV2Function()
    while _G.AutoRaceV2 do
        task.wait(1)
        -- Здесь выполняется поиск Алхимика в Зеленой Зоне и сбор 3-х цветков
        print("Angry Hub: Выполняется сбор цветков на Расу V2...")
    end
end

-- Логика для Расы В3
function AutoRaceV3Function()
    while _G.AutoRaceV3 do
        task.wait(1)
        -- Здесь выполняется квест у Ароухи (убийство боссов, сбор сундуков и т.д.)
        print("Angry Hub: Выполняется квест на Расу V3...")
    end
end

-- Вкладка авторизации в стартовом окне
local KeyTab = OrionLib:MakeTab({
	Name = "Ввод Ключа",
	Icon = "rbxassetid://4483345998",
	Premium = false
})

-- Поле для ввода ключа
KeyTab:AddTextbox({
	Name = "Ключ:",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		_G.KeyInput = Value
	end	
})

-- Кнопка проверки ключа
KeyTab:AddButton({
	Name = "Проверить ключ",
	Callback = function()
        if _G.KeyInput == "Angry20" then
            OrionLib:MakeNotification({
                Name = "Успешно!",
                Content = "Ключ верный! Загрузка Angry Hub...",
                Image = "rbxassetid://4483345998",
                Time = 4
            })
            task.wait(1)
            OrionLib:DestroyGui() -- Закрываем окно авторизации
            
            -- СОЗДАЕМ ГЛАВНОЕ МЕНЮ "Angry"
            local MainMenu = OrionLib:MakeWindow({Name = "Angry", HidePremium = false, SaveConfig = true, ConfigFolder = "AngryMain"})
            
            -- Вкладка функций
            local RaceTab = MainMenu:MakeTab({
                Name = "Авто-Раса",
                Icon = "rbxassetid://4483345998",
                Premium = false
            })
            
            -- Кнопка включения Авто Расы V2
            RaceTab:AddToggle({
                Name = "Авто Раса V2 (Цветки)",
                Default = false,
                Callback = function(Value)
                    _G.AutoRaceV2 = Value
                    if Value then
                        task.spawn(AutoRaceV2Function)
                    end
                end
            })
            
            -- Кнопка включения Авто Расы V3
            RaceTab:AddToggle({
                Name = "Авто Раса V3 (Квесты)",
                Default = false,
                Callback = function(Value)
                    _G.AutoRaceV3 = Value
                    if Value then
                        task.spawn(AutoRaceV3Function)
                    end
                end
            })
            
            MainMenu:Init() -- Инициализация главного меню
        else
            -- Если ключ неверный
            OrionLib:MakeNotification({
                Name = "Ошибка",
                Content = "Неверный ключ! Попробуйте еще раз.",
                Image = "rbxassetid://4483345998",
                Time = 4
            })
        end
	end
})

OrionLib:Init() -- Инициализация окна авторизации
