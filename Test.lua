-- ====================================================================
-- НАСТРОЙКИ БЕЗОПАСНОСТИ И ДОСТУПА
-- ====================================================================
local CorrectKey = "Men9" -- Ваш секретный ключ
local Player = game:GetService("Players").LocalPlayer

-- ====================================================================
-- ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА (ОКНО КЛЮЧА)
-- ====================================================================
local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()
local KeyWindow = OrionLib:MakeWindow({Name = "Проверка Ключа | Men Script", HidePremium = true, SaveConfig = false})

local KeyTab = KeyWindow:MakeTab({Name = "Ввод Ключа", Icon = "rbxassetid://4483345998"})

KeyTab:AddTextbox({
    Name = "Введите ваш секретный ключ:",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        if Value == CorrectKey then
            OrionLib:MakeNotification({
                Name = "Успешно!",
                Content = "Ключ верный. Загрузка меню...",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            task.wait(1)
            KeyWindow:Destroy() -- Закрываем окно ключа
            InitMainScript()    -- Запускаем основное меню
        else
            OrionLib:MakeNotification({
                Name = "Ошибка!",
                Content = "Неверный ключ. Попробуйте еще раз.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- ====================================================================
-- ОСНОВНОЙ СКРИПТ (ЗАПУСКАЕТСЯ ПОСЛЕ ВВОДА КЛЮЧА)
-- ====================================================================
function InitMainScript()
    local MainWindow = OrionLib:MakeWindow({Name = "Men Hub | Blox Fruits", HidePremium = false, SaveConfig = true, ConfigFolder = "MenConfig"})
    local RaceTab = MainWindow:MakeTab({Name = "Авто Раса (v2/v3)", Icon = "rbxassetid://4483345998"})

    _G.AutoRaceV2 = false
    _G.AutoRaceV3 = false
      -- ЛОГИКА АВТО РАСЫ В2
    RaceTab:AddToggle({
        Name = "Авто Выполнение Расы V2",
        Default = false,
        Callback = function(Value)
            _G.AutoRaceV2 = Value
            if Value then
                spawn(function()
                    while _G.AutoRaceV2 do
                        task.wait(1)
                        local Alchemist = workspace:FindFirstChild("Alchemist") or (workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChild("Alchemist"))
                        if Alchemist and Player.Character:FindFirstChild("HumanoidRootPart") then
                            Player.Character.HumanoidRootPart.CFrame = Alchemist.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                            if Alchemist:FindFirstChildOfClass("ClickDetector") then
                                fireclickdetector(Alchemist:FindFirstChildOfClass("ClickDetector"))
                            end
                        end
                        
                        for _, v in pairs(workspace:GetChildren()) do
                            if v.Name == "Flower1" or v.Name == "Flower2" or v.Name == "Flower3" then
                                if v:FindFirstChild("TouchInterest") and Player.Character:FindFirstChild("HumanoidRootPart") then
                                    Player.Character.HumanoidRootPart.CFrame = v.CFrame
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                end)
            end
        end    
    })

    -- ЛОГИКА АВТО РАСЫ В3
    RaceTab:AddToggle({
        Name = "Авто Выполнение Расы V3",
        Default = false,
        Callback = function(Value)
            _G.AutoRaceV3 = Value
            if Value then
                spawn(function()
                    while _G.AutoRaceV3 do
                        task.wait(1)
                        local Arowe = workspace:FindFirstChild("Arowe") or (workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChild("Arowe"))
                        if Arowe and Player.Character:FindFirstChild("HumanoidRootPart") then
                            Player.Character.HumanoidRootPart.CFrame = Arowe.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                            if Arowe:FindFirstChildOfClass("ClickDetector") then
                                fireclickdetector(Arowe:FindFirstChildOfClass("ClickDetector"))
                            end
                        end
                    end
                end)
            end
        end    
    })

    OrionLib:Init()
end
