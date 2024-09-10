local version = "v0.1"

function MainScript()
    local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/xpa1n/library/main/FluentLibrary.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "Bladers Rebirth 剧本",
        SubTitle = version,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
    })

    local Tabs = {
        main = Window:AddTab({ Title = "自动农场", Icon = "swords" }),
        boss = Window:AddTab({ Title = "老板农场", Icon = "swords" }),
        stats = Window:AddTab({ Title = "自动统计", Icon = "shield" }),
        qgf = Window:AddTab({ Title = "Quest Giver Farm", Icon = "swords" }),
    }
    
    do

        local mainmain = Tabs.main:AddSection("主要")

        local workspace = game:GetService("Workspace")
        local npcsFolder = workspace:FindFirstChild("NPCs")
        local Players = game:GetService("Players")
        local bossNames = {}
        if npcsFolder then
            for _, npc in ipairs(npcsFolder:GetChildren()) do
                if npc:IsA("Model") and npc.Name:lower():find("boss") then
                    table.insert(bossNames, npc.Name)
                end
            end
        end
        table.sort(bossNames)
        
        local teleportbossNPC = mainmain:AddDropdown("teleportboss", {
        Title = "传送老板NPC",
        Values = bossNames,
        Multi = false,
        Default = "",})

        teleportbossNPC:OnChanged(function(Value)
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").NPCs[Value].HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            end)
        end)

        local otherNames = {}
        if npcsFolder then
            for _, npc in ipairs(npcsFolder:GetChildren()) do
                if npc:IsA("Model") and not npc.Name:lower():find("trainer") and not npc.Name:lower():find("boss") then
                    table.insert(otherNames, npc.Name)
                end
            end
        end
        table.sort(otherNames)

        local teleportotherNPC = mainmain:AddDropdown("teleportother", {
        Title = "传送其他NPC",
        Values = otherNames,
        Multi = false,
        Default = "",})

        teleportotherNPC:OnChanged(function(Value)
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").NPCs[Value].HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            end)
        end)

        function FarmWanderingMobs()
            pcall(function()
                for i,v in pairs(game:GetService("Workspace").World.WanderingTrainers:GetChildren()) do
                    if not _G.AutoBossFarm and _G.AutoFarmWandering then
                        --local mob = game.Workspace.NPCs[v]
                        if not v:FindFirstChild("Head"):FindFirstChild("Cooldown") then
                                if game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false then
                                local trainer = v.PrimaryPart
                                local player = game.Players.LocalPlayer
                                local char = player.Character or player.CharacterAdded:Wait()
                                local hrp = char:WaitForChild("HumanoidRootPart")
                                local tpPos = trainer.CFrame * CFrame.new(0, 0, -5)
                                hrp.CFrame = tpPos
                                workspace.CurrentCamera.CFrame = CFrame.new(tpPos.Position, trainer.Position)
                                wait(1)
                                local button = game:service'VirtualInputManager'
                                button:SendKeyEvent(true, "E", false, game)
                                task.wait()
                                button:SendKeyEvent(false, "E", false, game)
                                wait(3.5)
                                --repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true
                            end
                        end
                    end
                end
            end)
        end

        local autofarmwandering = mainmain:AddToggle("autofarm", {Title = "自动挂机挑战漫游怪物", Default = false})
        autofarmwandering:OnChanged(function()
            _G.AutoFarmWandering = autofarmwandering.Value
        end)

        coroutine.resume(coroutine.create(function()
            while task.wait(1.5) do
                if _G.AutoFarmWandering then
                    FarmWanderingMobs() 
                end
            end
        end))

        

        local mainfarm = Tabs.main:AddSection("自动农场")

        local mobsByLevel = {
           Level_5 = {"Random Trainer 7"},
           Level_10 = {"Random Trainer 2", "Random Trainer 1", "Random Trainer 6"},
           Level_20 = {"Random Trainer 3", "Random Trainer 5", "Random Trainer 4"},
           Level_25 = {"Random Trainer 9"},
           Level_30 = {"Random Trainer 10", "Random Trainer 12", "Random Trainer 14", "Random Trainer 11"},
           Level_40 = {"Random Trainer 15", "Random Trainer 13"},
           Level_60 = {"Random Trainer 22"},
           Level_70 = {"Random Trainer 19", "Random Trainer 21"},
           Level_80 = {"Random Trainer 16", "Random Trainer 18"},
           Level_95 = {"Random Trainer 20", "Random Trainer 17"},
           Level_125 = {"Random Trainer 53", "Random Trainer 55"},
           Level_150 = {"Random Trainer 67", "Random Trainer 54", "Random Trainer 57", "Random Trainer 23"},
           Level_175 = {"Random Trainer 56"},
           Level_200 = {"Random Trainer 58"},
           Level_225 = {"Random Trainer 62", "Random Trainer 59"},
           Level_250 = {"Random Trainer 61", "Random Trainer 60"},
           Level_300 = {"Random Trainer 43", "Random Trainer 44", "Random Trainer 46"},
           Level_350 = {"Random Trainer 47", "Random Trainer 48", "Random Trainer 41"},
           Level_425 = {"Random Trainer 42", "Random Trainer 45", "Random Trainer 40"},
           Level_475 = {"Random Trainer 37", "Random Trainer 34"},
           Level_525 = {"Random Trainer 39", "Random Trainer 36"},
           Level_600 = {"Random Trainer 38", "Random Trainer 35"},
           Level_620 = {"Random Trainer 30"},
           Level_650 = {"Random Trainer 31", "Random Trainer 32", "Random Trainer 25", "Random Trainer 27", "Random Trainer 26"},
           Level_700 = {"Random Trainer 33", "Random Trainer 24", "Random Trainer 28", "Random Trainer 29"},
           Level_725 = {"Random Trainer 50"},
           Level_750 = {"Random Trainer 52", "Random Trainer 51"},
           Level_800 = {"Random Trainer 49"},
           Level_825 = {"Random Trainer 63"},
           Level_850 = {"Random Trainer 64", "Random Trainer 65"},
           Level_900 = {"Random Trainer 70", "Random Trainer 73", "Random Trainer 66"},
           Level_925 = {"Random Trainer 69"},
           Level_950 = {"Random Trainer 75"},
           Level_975 = {"Random Trainer 72"},
           Level_990 = {"Random Trainer 78"},
           Level_999 = {"Random Trainer 71", "Random Trainer 74", "Random Trainer 77", "Random Trainer 76"},
           Level_1000_to_2000 = {"Random Trainer 79", "Random Trainer 86", "Random Trainer 88", "Random Trainer 89", "Random Trainer 90", "Random Trainer 0", "Random Trainer 95", "Random Trainer 94", "Random Trainer 91", "Random Trainer 93", "Random Trainer 80", "Random Trainer 96", "Random Trainer 8", "Random Trainer 81", "Random Trainer 87", "Random Trainer 84", "Random Trainer 83", "Random Trainer 82", "Random Trainer 68", "Random Trainer 85", "Random Trainer 92", },
        }

        local moblist = {}
        for key, _ in pairs(mobsByLevel) do
            table.insert(moblist, key)
        end
        table.sort(moblist, function(a, b)
            local numA = tonumber(a:match("%d+"))
            local numB = tonumber(b:match("%d+"))
            return numA < numB
        end)

        local Dropdown = mainfarm:AddDropdown("Dropdown", {
            Title = "选择怪物",
            Values = moblist,
            Multi = false,
            Default = nil,
        })
    
        _G.SelectedMobs = {}

        Dropdown:OnChanged(function(Value)
            _G.SelectedMobs = mobsByLevel[Value]
        end)
    
        function FarmMobs()
            pcall(function()
                for i,v in pairs(_G.SelectedMobs) do
                    if not _G.AutoBossFarm and _G.AutoFarm then
                        local mob = game.Workspace.NPCs[v]
                        if not mob:FindFirstChild("Head"):FindFirstChild("Cooldown") then
                                if game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false then
                                local trainer = mob.PrimaryPart
                                local player = game.Players.LocalPlayer
                                local char = player.Character or player.CharacterAdded:Wait()
                                local hrp = char:WaitForChild("HumanoidRootPart")
                                local tpPos = trainer.CFrame * CFrame.new(0, 0, -5)
                                hrp.CFrame = tpPos
                                workspace.CurrentCamera.CFrame = CFrame.new(tpPos.Position, trainer.Position)
                                wait(1)
                                local button = game:service'VirtualInputManager'
                                button:SendKeyEvent(true, "E", false, game)
                                task.wait()
                                button:SendKeyEvent(false, "E", false, game)
                                wait(3.5)
                                --repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true
                            end
                        end
                    end
                end
            end)
        end

        local autofarm = mainfarm:AddToggle("autofarm", {Title = "自动农场", Default = false})
        autofarm:OnChanged(function()
            _G.AutoFarm = autofarm.Value
        end)

        coroutine.resume(coroutine.create(function()
            while task.wait(1.5) do
                if _G.AutoFarm then
                    FarmMobs() 
                end
            end
        end))

        local mainskill = Tabs.main:AddSection("自动使用技能")

        local pressR = mainskill:AddToggle("pressRR", {Title = "自动按下 R", Default = false})
        pressR:OnChanged(function()
            _G.PressRButton = pressR.Value
        end)

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if _G.PressRButton then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "R", false, game)
                    task.wait(1)
                    button:SendKeyEvent(false, "R", false, game)
                end
            end
        end))

        local pressT = mainskill:AddToggle("pressTT", {Title = "自动按下 T", Default = false})
        pressT:OnChanged(function()
            _G.PressTButton = pressT.Value
        end)

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if _G.PressTButton then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "T", false, game)
                    task.wait(1)
                    button:SendKeyEvent(false, "T", false, game)
                end
            end
        end))

        local pressY = mainskill:AddToggle("pressYY", {Title = "自动按下 Y", Default = false})
        pressY:OnChanged(function()
            _G.PressYButton = pressY.Value
        end)

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if _G.PressYButton then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "Y", false, game)
                    task.wait(1)
                    button:SendKeyEvent(false, "Y", false, game)
                end
            end
        end))

        local pressZ = mainskill:AddToggle("pressZZ", {Title = "自动按下 Z", Default = false})
        pressZ:OnChanged(function()
            _G.PressZButton = pressZ.Value
        end)

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if _G.PressZButton then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "Z", false, game)
                    task.wait(1)
                    button:SendKeyEvent(false, "Z", false, game)
                end
            end
        end))

        local bossmain = Tabs.boss:AddSection("主要")

        local BossDropdown = bossmain:AddDropdown("Dropdown", {
             Title = "选择Boss",
             Values = {"Boss 1", "Boss 2", "Boss 3", "Boss 4", "Boss 5"},
             Multi = false,
             Default = nil,
         })
     
         _G.SelectedBoss = nil
 
         BossDropdown:OnChanged(function(Value)
             _G.SelectedBoss = Value
         end)
     
         function FarmBoss()
             pcall(function()
                if not _G.AutoBossFarm2 then
                     local mob = game.Workspace.NPCs[_G.SelectedBoss]
                     if not mob:FindFirstChild("Head"):FindFirstChild("Cooldown") then
                             if game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false then
                             local trainer = mob.PrimaryPart
                             local player = game.Players.LocalPlayer
                             local char = player.Character or player.CharacterAdded:Wait()
                             local hrp = char:WaitForChild("HumanoidRootPart")
                             local tpPos = trainer.CFrame * CFrame.new(0, 0, -5)
                             hrp.CFrame = tpPos
                             workspace.CurrentCamera.CFrame = CFrame.new(tpPos.Position, trainer.Position)
                             wait(1)
                             local button = game:service'VirtualInputManager'
                             button:SendKeyEvent(true, "E", false, game)
                             task.wait()
                             button:SendKeyEvent(false, "E", false, game)
                             wait(3.5)
                             --repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true
                         end
                     end
                end
             end)
         end
 
         local bossfarm = bossmain:AddToggle("bossfarm", {Title = "自动挑选指定的Boss", Default = false})
         bossfarm:OnChanged(function()
             _G.AutoBossFarm = bossfarm.Value
         end)
 
         coroutine.resume(coroutine.create(function()
             while task.wait(1.5) do
                 if _G.AutoBossFarm then
                    FarmBoss()
                 end
             end
         end))

         local bossmain2 = Tabs.boss:AddSection("------------")

         _G.AllBoss = {"Boss 1","Boss 2","Boss 3","Boss 4","Boss 5"}
        function AllFarmBoss()

            pcall(function()
                for i,v in pairs(_G.AllBoss) do
                    local mob = game.Workspace.NPCs[v]
                    if not mob:FindFirstChild("Head"):FindFirstChild("Cooldown") then
                            if game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false then
                            local trainer = mob.PrimaryPart
                            local player = game.Players.LocalPlayer
                            local char = player.Character or player.CharacterAdded:Wait()
                            local hrp = char:WaitForChild("HumanoidRootPart")
                            local tpPos = trainer.CFrame * CFrame.new(0, 0, -5)
                            hrp.CFrame = tpPos
                            workspace.CurrentCamera.CFrame = CFrame.new(tpPos.Position, trainer.Position)
                            wait(1)
                            local button = game:service'VirtualInputManager'
                            button:SendKeyEvent(true, "E", false, game)
                            task.wait()
                            button:SendKeyEvent(false, "E", false, game)
                            wait(3.5)
                            --repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true
                        end
                    end
                end
            end)
        end

         local allbossfarm = bossmain2:AddToggle("allbossfarm", {Title = "挂机所有Boss（1-5）", Default = false})
         allbossfarm:OnChanged(function()
             _G.AutoBossFarm2 = allbossfarm.Value
         end)
 
         coroutine.resume(coroutine.create(function()
             while task.wait(1.5) do
                 if _G.AutoBossFarm2 then
                    AllFarmBoss()
                 end
             end
         end))

         local statsmain = Tabs.stats:AddSection("主要")

         local attackstats = statsmain:AddToggle("attackstats", {Title = "自动统计攻击", Default = false})
         attackstats:OnChanged(function()
             _G.AttackxStats = attackstats.Value
         end)
 
         coroutine.resume(coroutine.create(function()
             while task.wait(0.5) do
                 if _G.AttackxStats then
                    pcall(function()
                        local BUTTONPATH = game:GetService("Players").LocalPlayer.PlayerGui.UI.Menu.Stats.Stats.Attack.Increment.Button
                        if BUTTONPATH then
                            local connections = getconnections(BUTTONPATH.MouseButton1Click)
                            for _, connection in pairs(connections) do
                                connection.Function(BUTTONPATH)
                            end
                        end
                    end)
                 end
             end
         end))

         local defensestats = statsmain:AddToggle("defensestats", {Title = "自动统计防御", Default = false})
         defensestats:OnChanged(function()
             _G.DefensexStats = defensestats.Value
         end)
 
         coroutine.resume(coroutine.create(function()
             while task.wait(0.5) do
                 if _G.DefensexStats then
                    pcall(function()
                        local BUTTONPATH = game:GetService("Players").LocalPlayer.PlayerGui.UI.Menu.Stats.Stats.Defence.Increment.Button
                        if BUTTONPATH then
                            local connections = getconnections(BUTTONPATH.MouseButton1Click)
                            for _, connection in pairs(connections) do
                                connection.Function(BUTTONPATH)
                            end
                        end
                    end)
                 end
             end
         end))

         local staminastats = statsmain:AddToggle("staminastats", {Title = "自动统计耐力", Default = false})
         staminastats:OnChanged(function()
             _G.StaminaxStats = staminastats.Value
         end)
 
         coroutine.resume(coroutine.create(function()
             while task.wait(0.5) do
                 if _G.StaminaxStats then
                    pcall(function()
                        local BUTTONPATH = game:GetService("Players").LocalPlayer.PlayerGui.UI.Menu.Stats.Stats.Stamina.Increment.Button
                        if BUTTONPATH then
                            local connections = getconnections(BUTTONPATH.MouseButton1Click)
                            for _, connection in pairs(connections) do
                                connection.Function(BUTTONPATH)
                            end
                        end
                    end)
                 end
             end
         end))

         local speedstats = statsmain:AddToggle("speedstats", {Title = "自动统计速度", Default = false})
         speedstats:OnChanged(function()
             _G.SpeedxStats = speedstats.Value
         end)
 
         coroutine.resume(coroutine.create(function()
             while task.wait(0.5) do
                 if _G.SpeedxStats then
                    pcall(function()
                        local BUTTONPATH = game:GetService("Players").LocalPlayer.PlayerGui.UI.Menu.Stats.Stats.Speed.Increment.Button
                        if BUTTONPATH then
                            local connections = getconnections(BUTTONPATH.MouseButton1Click)
                            for _, connection in pairs(connections) do
                                connection.Function(BUTTONPATH)
                            end
                        end
                    end)
                 end
             end
         end))

         local qgfmain = Tabs.qgf:AddSection("Quest Giver Farm!")
     
        ---jim12
        if game.PlaceId ~= 109291753190313 then
            function FarmTrainerXIIFunction()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                
                local function interactWithNPC()
                    local workspace = game:GetService("Workspace")
                    local npcpos = workspace.NPCs.QuestGiverJim12:WaitForChild("HumanoidRootPart")
                    
                    humanoidRootPart.CFrame = npcpos.CFrame * CFrame.new(0, 0, -5)
                    workspace.CurrentCamera.CFrame = CFrame.new(humanoidRootPart.Position, npcpos.Position)
                    wait(1)
                    print("okworking3")
                    local button = game:GetService('VirtualInputManager')
                    button:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait()
                    button:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    wait(3.5)
                end
            
                local function checkQuestFolder()
                    local playerGui = player:WaitForChild("PlayerGui")
                    local ui = playerGui:WaitForChild("UI")
                    local menu = ui:WaitForChild("Menu")
                    local quests = menu:WaitForChild("Quests")
                    local scrollingFrame = quests:WaitForChild("ScrollingFrame")
                    local questfolder = scrollingFrame:FindFirstChild("NewQuest")
            
                    if questfolder then
                        local questfolderinfo = questfolder:FindFirstChild("Information")
                        if questfolderinfo then
                            local quest = questfolderinfo:FindFirstChild("quest_name")
                            if quest and quest.Text and string.find(quest.Text, "Trainers XII") then
                                print("The quest name contains 'Trainers XII'")
                                local NPCs = {"Random Trainer 79", "Random Trainer 86", "Random Trainer 88", "Random Trainer 0", "Random Trainer 91", "Random Trainer 96", "Random Trainer 81"}


                                for i,v in pairs(NPCs) do
                                    local mob = game.Workspace.NPCs[v]
                                    if not mob:FindFirstChild("Head"):FindFirstChild("Cooldown") then
                                            if game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false then
                                            local trainer = mob.PrimaryPart
                                            local player = game.Players.LocalPlayer
                                            local char = player.Character or player.CharacterAdded:Wait()
                                            local hrp = char:WaitForChild("HumanoidRootPart")
                                            local tpPos = trainer.CFrame * CFrame.new(0, 0, -5)
                                            hrp.CFrame = tpPos
                                            workspace.CurrentCamera.CFrame = CFrame.new(tpPos.Position, trainer.Position)
                                            wait(1)
                                            local button = game:service'VirtualInputManager'
                                            button:SendKeyEvent(true, "E", false, game)
                                            task.wait()
                                            button:SendKeyEvent(false, "E", false, game)
                                            wait(3.5)
                                            --repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true
                                        end
                                    end
                                end


                                return true
                            end
                        end
                    end
                    return false
                end
            
                if not checkQuestFolder() then
                    interactWithNPC()
                end
            end

            local FarmTrainersXII = qgfmain:AddToggle("FarmTrainersXII", {Title = "Quest Giver Jim12", Default = false})
            FarmTrainersXII:OnChanged(function()
                _G.FarmTrainerXII = FarmTrainersXII.Value
            end)

            coroutine.resume(coroutine.create(function()
                while task.wait(1.5) do
                    if _G.FarmTrainerXII then
                        FarmTrainerXIIFunction()
                    end
                end
            end))
        end


        if game.PlaceId == 109291753190313 then

        ---jim13
            function FarmTrainerXIIIFunction()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                
                local function interactWithNPC()
                    local workspace = game:GetService("Workspace")
                    local npcpos = workspace.NPCs.QuestGiverJim13:WaitForChild("HumanoidRootPart")
                    
                    humanoidRootPart.CFrame = npcpos.CFrame * CFrame.new(0, 0, -5)
                    workspace.CurrentCamera.CFrame = CFrame.new(humanoidRootPart.Position, npcpos.Position)
                    wait(1)
                    print("okworking3")
                    local button = game:GetService('VirtualInputManager')
                    button:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait()
                    button:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    wait(3.5)
                end
            
                local function checkQuestFolder()
                    local playerGui = player:WaitForChild("PlayerGui")
                    local ui = playerGui:WaitForChild("UI")
                    local menu = ui:WaitForChild("Menu")
                    local quests = menu:WaitForChild("Quests")
                    local scrollingFrame = quests:WaitForChild("ScrollingFrame")
                    local questfolder = scrollingFrame:FindFirstChild("NewQuest")
            
                    if questfolder then
                        local questfolderinfo = questfolder:FindFirstChild("Information")
                        if questfolderinfo then
                            local quest = questfolderinfo:FindFirstChild("quest_name")
                            if quest and quest.Text and string.find(quest.Text, "Trainers XIII") then
                                print("The quest name contains 'Trainers XIII'")

                                function killmobs(Mobs) 
                                    if _G.FarmTrainerXIII then
                                        local mob = game.Workspace.NPCs[Mobs]
                                        if not mob:FindFirstChild("Head"):FindFirstChild("Cooldown") then
                                                if game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false then
                                                local trainer = mob.PrimaryPart
                                                local player = game.Players.LocalPlayer
                                                local char = player.Character or player.CharacterAdded:Wait()
                                                local hrp = char:WaitForChild("HumanoidRootPart")
                                                local tpPos = trainer.CFrame * CFrame.new(0, 0, -5)
                                                hrp.CFrame = tpPos
                                                workspace.CurrentCamera.CFrame = CFrame.new(tpPos.Position, trainer.Position)
                                                wait(1.5)

                                                while game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false do
                                                    task.wait(1)
                                                    local button = game:service'VirtualInputManager'
                                                    button:SendKeyEvent(true, "E", false, game)
                                                    task.wait(0.5)
                                                    button:SendKeyEvent(false, "E", false, game)
                                                end
                                                print("killing " , Mobs , "now")
                                                while not mob:FindFirstChild("Head"):FindFirstChild("Cooldown") do
                                                    task.wait(1)
                                                    warn("waiting")
                                                end
                                                wait(5)

                                            end
                                        end
                                    end
                                end

                                local NPCs = {"Random Trainer 40", "Random Trainer 30", "Random Trainer 22", "Random Trainer 20", "Random Trainer 28", "Random Trainer 29", "Random Trainer 31", "Random Trainer 17", "Random Trainer 23", "Random Trainer 35", "Random Trainer 18", "Random Trainer 26"}

                                killmobs("Random Trainer 40")
                                task.wait(1)
                                killmobs("Random Trainer 30")
                                task.wait(1)
                                killmobs("Random Trainer 22")
                                task.wait(1)
                                killmobs("Random Trainer 20")
                                task.wait(1)
                                killmobs("Random Trainer 28")
                                task.wait(1)
                                killmobs("Random Trainer 29")
                                task.wait(1)
                                killmobs("Random Trainer 31")
                                task.wait(1)
                                killmobs("Random Trainer 17")
                                task.wait(1)
                                killmobs("Random Trainer 23")
                                task.wait(1)
                                killmobs("Random Trainer 35")
                                task.wait(1)
                                killmobs("Random Trainer 18")
                                task.wait(1)
                                killmobs("Random Trainer 26")
                                task.wait(1)

                                return true
                            end
                        end
                    end
                    return false
                end
            
                if not checkQuestFolder() then
                    interactWithNPC()
                end
            end

            local FarmTrainersXIII = qgfmain:AddToggle("FarmTrainersXIII", {Title = "Quest Giver Jim13", Default = false})
            FarmTrainersXIII:OnChanged(function()
                _G.FarmTrainerXIII = FarmTrainersXIII.Value
                while _G.FarmTrainerXIII do
                    task.wait(1)
                    FarmTrainerXIIIFunction()
                end
            end)

            ---jim14
            function FarmTrainerXIVFunction()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                
                local function interactWithNPC()
                    local workspace = game:GetService("Workspace")
                    local npcpos = workspace.NPCs.QuestGiverJim14:WaitForChild("HumanoidRootPart")
                    
                    humanoidRootPart.CFrame = npcpos.CFrame * CFrame.new(0, 0, -5)
                    workspace.CurrentCamera.CFrame = CFrame.new(humanoidRootPart.Position, npcpos.Position)
                    wait(1)
                    print("okworking3")
                    local button = game:GetService('VirtualInputManager')
                    button:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait()
                    button:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    wait(3.5)
                end
            
                local function checkQuestFolder()
                    local playerGui = player:WaitForChild("PlayerGui")
                    local ui = playerGui:WaitForChild("UI")
                    local menu = ui:WaitForChild("Menu")
                    local quests = menu:WaitForChild("Quests")
                    local scrollingFrame = quests:WaitForChild("ScrollingFrame")
                    local questfolder = scrollingFrame:FindFirstChild("NewQuest")
            
                    if questfolder then
                        local questfolderinfo = questfolder:FindFirstChild("Information")
                        if questfolderinfo then
                            local quest = questfolderinfo:FindFirstChild("quest_name")
                            if quest and quest.Text and string.find(quest.Text, "Trainers XIV") then
                                print("The quest name contains 'Trainers XIV'")

                                function killmobs(Mobs) 
                                    if _G.FarmTrainerXIV then
                                        local mob = game.Workspace.NPCs[Mobs]
                                        if not mob:FindFirstChild("Head"):FindFirstChild("Cooldown") then
                                                if game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false then
                                                local trainer = mob.PrimaryPart
                                                local player = game.Players.LocalPlayer
                                                local char = player.Character or player.CharacterAdded:Wait()
                                                local hrp = char:WaitForChild("HumanoidRootPart")
                                                local tpPos = trainer.CFrame * CFrame.new(0, 0, -5)
                                                hrp.CFrame = tpPos
                                                workspace.CurrentCamera.CFrame = CFrame.new(tpPos.Position, trainer.Position)
                                                wait(1.5)

                                                while game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false do
                                                    task.wait(1)
                                                    local button = game:service'VirtualInputManager'
                                                    button:SendKeyEvent(true, "E", false, game)
                                                    task.wait(0.5)
                                                    button:SendKeyEvent(false, "E", false, game)
                                                end
                                                print("killing " , Mobs , "now")
                                                while not mob:FindFirstChild("Head"):FindFirstChild("Cooldown") do
                                                    task.wait(1)
                                                    warn("waiting")
                                                end
                                                wait(5)

                                            end
                                        end
                                    end
                                end

                                killmobs("Random Trainer 1")
                                task.wait(1)
                                killmobs("Random Trainer 39")
                                task.wait(1)
                                killmobs("Random Trainer 38")
                                task.wait(1)
                                killmobs("Random Trainer 36")
                                task.wait(1)
                                killmobs("Random Trainer 3")
                                task.wait(1)
                                killmobs("Random Trainer 2")
                                task.wait(1)
                                killmobs("Random Trainer 4")
                                task.wait(1)
                                killmobs("Random Trainer 5")
                                task.wait(1)
                                killmobs("Random Trainer 0")
                                task.wait(1)

                                return true
                            end
                        end
                    end
                    return false
                end
            
                if not checkQuestFolder() then
                    interactWithNPC()
                end
            end

            local FarmTrainersXIV = qgfmain:AddToggle("FarmTrainersXIV", {Title = "Quest Giver Jim14", Default = false})
            FarmTrainersXIV:OnChanged(function()
                _G.FarmTrainerXIV = FarmTrainersXIV.Value
                while _G.FarmTrainerXIV do
                    task.wait(1)
                    FarmTrainerXIVFunction()
                end
            end)

            ---jim15
            function FarmTrainerXVFunction()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                
                local function interactWithNPC()
                    local workspace = game:GetService("Workspace")
                    local npcpos = workspace.NPCs.QuestGiverJim15:WaitForChild("HumanoidRootPart")
                    
                    humanoidRootPart.CFrame = npcpos.CFrame * CFrame.new(0, 0, -5)
                    workspace.CurrentCamera.CFrame = CFrame.new(humanoidRootPart.Position, npcpos.Position)
                    wait(1)
                    print("okworking3")
                    local button = game:GetService('VirtualInputManager')
                    button:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait()
                    button:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    wait(3.5)
                end
            
                local function checkQuestFolder()
                    local playerGui = player:WaitForChild("PlayerGui")
                    local ui = playerGui:WaitForChild("UI")
                    local menu = ui:WaitForChild("Menu")
                    local quests = menu:WaitForChild("Quests")
                    local scrollingFrame = quests:WaitForChild("ScrollingFrame")
                    local questfolder = scrollingFrame:FindFirstChild("NewQuest")
            
                    if questfolder then
                        local questfolderinfo = questfolder:FindFirstChild("Information")
                        if questfolderinfo then
                            local quest = questfolderinfo:FindFirstChild("quest_name")
                            if quest and quest.Text and string.find(quest.Text, "Trainers XV") then
                                print("The quest name contains 'Trainers XV'")

                                function killmobs(Mobs) 
                                    if _G.FarmTrainerXV then
                                        local mob = game.Workspace.NPCs[Mobs]
                                        if not mob:FindFirstChild("Head"):FindFirstChild("Cooldown") then
                                                if game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false then
                                                local trainer = mob.PrimaryPart
                                                local player = game.Players.LocalPlayer
                                                local char = player.Character or player.CharacterAdded:Wait()
                                                local hrp = char:WaitForChild("HumanoidRootPart")
                                                local tpPos = trainer.CFrame * CFrame.new(0, 0, -5)
                                                hrp.CFrame = tpPos
                                                workspace.CurrentCamera.CFrame = CFrame.new(tpPos.Position, trainer.Position)
                                                wait(1.5)

                                                while game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == false do
                                                    task.wait(1)
                                                    local button = game:service'VirtualInputManager'
                                                    button:SendKeyEvent(true, "E", false, game)
                                                    task.wait(0.5)
                                                    button:SendKeyEvent(false, "E", false, game)
                                                end
                                                print("killing " , Mobs , "now")
                                                while not mob:FindFirstChild("Head"):FindFirstChild("Cooldown") do
                                                    task.wait(1)
                                                    warn("waiting")
                                                end
                                                wait(5)

                                            end
                                        end
                                    end
                                end

                                killmobs("Random Trainer 33")
                                task.wait(1)
                                killmobs("Random Trainer 43")
                                task.wait(1)
                                killmobs("Random Trainer 42")
                                task.wait(1)
                                killmobs("Random Trainer 11")
                                task.wait(1)
                                killmobs("Random Trainer 13")
                                task.wait(1)
                                killmobs("Random Trainer 10")
                                task.wait(1)
                                killmobs("Random Trainer 9")
                                task.wait(1)
                                killmobs("Random Trainer 14")
                                task.wait(1)
                                killmobs("Random Trainer 12")
                                task.wait(1)
                                killmobs("Random Trainer 41")
                                task.wait(1)
                                killmobs("Random Trainer 53")
                                task.wait(1)
                                killmobs("Random Trainer 48")
                                task.wait(1)
                                killmobs("Random Trainer 49")
                                task.wait(1)
                                killmobs("Random Trainer 45")
                                task.wait(1)

                                return true
                            end
                        end
                    end
                    return false
                end
            
                if not checkQuestFolder() then
                    interactWithNPC()
                end
            end

            local FarmTrainersXV = qgfmain:AddToggle("FarmTrainersXV", {Title = "Quest Giver Jim15", Default = false})
            FarmTrainersXV:OnChanged(function()
                _G.FarmTrainerXV = FarmTrainersXV.Value
                while _G.FarmTrainerXV do
                    task.wait(1)
                    FarmTrainerXVFunction()
                end
            end)

        end


        -- auto farm shit
        -- -- -- -- -- -- -- 
        local function ButtonAdded(child)
            if child.Name == "Button2" and _G.AutoFarm then
                local connections = getconnections(child.MouseButton1Click)
                for _, connection in pairs(connections) do
                    connection.Function(child)
                end
            end
            if child.Name == "Button9" or child.Name == "Button3" and _G.AutoBossFarm or _G.AutoBossFarm2 then
                local connections = getconnections(child.MouseButton1Click)
                for _, connection in pairs(connections) do
                    connection.Function(child)
                end
            end
            if child.Name == "Button2" and _G.AutoFarmWandering then
                local connections = getconnections(child.MouseButton1Click)
                for _, connection in pairs(connections) do
                    connection.Function(child)
                end
            end
            if child.Name == "Button2" or child.Name == "Button3" and _G.FarmTrainerXII then
                local connections = getconnections(child.MouseButton1Click)
                for _, connection in pairs(connections) do
                    connection.Function(child)
                end
            end
            if child.Name == "Button2" or child.Name == "Button3" and _G.FarmTrainerXIII then
                local connections = getconnections(child.MouseButton1Click)
                for _, connection in pairs(connections) do
                    connection.Function(child)
                end
            end
            if child.Name == "Button2" or child.Name == "Button3" and _G.FarmTrainerXIV then
                local connections = getconnections(child.MouseButton1Click)
                for _, connection in pairs(connections) do
                    connection.Function(child)
                end
            end
            if child.Name == "Button2" or child.Name == "Button3" and _G.FarmTrainerXV then
                local connections = getconnections(child.MouseButton1Click)
                for _, connection in pairs(connections) do
                    connection.Function(child)
                end
            end
        end
        game:GetService("Players").LocalPlayer.PlayerGui.Dialogue.Dialogue.ChildAdded:Connect(ButtonAdded)

        coroutine.resume(coroutine.create(function()
            while task.wait(0.5) do
                pcall(function()
                    local BUTTONPATH = game:GetService("Players").LocalPlayer.PlayerGui.Dialogue.Dialogue.Response
                    if BUTTONPATH then
                        local connections = getconnections(BUTTONPATH.MouseButton1Click)
                        for _, connection in pairs(connections) do
                            connection.Function(BUTTONPATH)
                        end
                    end
                end)
            end
        end))


        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if _G.AutoFarm and game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "W", false, game)
                    task.wait()
                    button:SendKeyEvent(false, "W", false, game)
                end
                if _G.AutoBossFarm and game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "W", false, game)
                    task.wait()
                    button:SendKeyEvent(false, "W", false, game)
                end
                if _G.AutoBossFarm2 and game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "W", false, game)
                    task.wait()
                    button:SendKeyEvent(false, "W", false, game)
                end
                if _G.AutoFarmWandering and game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "W", false, game)
                    task.wait()
                    button:SendKeyEvent(false, "W", false, game)
                end
                if _G.FarmTrainerXII and game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "W", false, game)
                    task.wait()
                    button:SendKeyEvent(false, "W", false, game)
                end
                if _G.FarmTrainerXIII and game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "W", false, game)
                    task.wait()
                    button:SendKeyEvent(false, "W", false, game)
                end
                if _G.FarmTrainerXIV and game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "W", false, game)
                    task.wait()
                    button:SendKeyEvent(false, "W", false, game)
                end
                if _G.FarmTrainerXV and game:GetService("Players").LocalPlayer.PlayerGui.UI.BeybladeInfo.Visible == true then
                    local button = game:service'VirtualInputManager'
                    button:SendKeyEvent(true, "W", false, game)
                    task.wait()
                    button:SendKeyEvent(false, "W", false, game)
                end
            end
        end))
        -- -- -- -- -- -- -- 
    end
    Window:SelectTab(1)
end

MainScript()
