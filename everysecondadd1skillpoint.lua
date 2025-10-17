queue_on_teleport("repeat task.wait() until game:IsLoaded() print('aaaaaaaaaaaaaaaaaaaaa') task.wait(2) loadstring(game:HttpGet('https://raw.githubusercontent.com/pa1nx9/ssdinle/main/everysecondadd1skillpoint.lua'))()")


local version = "v0.1"

function MainScript()
    local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/xpa1n/library/main/FluentLibrary.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "every second add 1 skill point 剧本",
        SubTitle = version,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
    })

    local Tabs = {
        main = Window:AddTab({ Title = "主菜单(MAIN)", Icon = "swords" }),
        boss = Window:AddTab({ Title = "老闆(BOSS)", Icon = "swords" }),
        special = Window:AddTab({ Title = "特殊怪物(Special)", Icon = "swords" }),
        ultimate = Window:AddTab({ Title = "究極怪物(Ultimate)", Icon = "swords" }),
    }
     
    local Options = Fluent.Options

    do
        
        local attack = Tabs.main:AddSection("自动攻击")
        local weaponlist = {}
        _G.selectedWeapons = {}

        -- Function to refresh weapon list
        local function refreshWeaponList()
            weaponlist = {}
            local player = game:GetService("Players").LocalPlayer
            if player and player.Backpack then
                for i, v in pairs(player.Backpack:GetChildren()) do
                    if v:IsA("Tool") then
                        table.insert(weaponlist, v.Name)
                    end
                end
            end
            return weaponlist
        end

        -- Initial population
        refreshWeaponList()

        local AttackDropdown = attack:AddDropdown("AttackDropdown", {
            Title = "武器",
            Description = "你可以选择多个选项。",
            Values = weaponlist,
            Multi = true,
            Default = {nil},
        })

        AttackDropdown:OnChanged(function(Value)
            _G.selectedWeapons = {} -- Clear the table first
            for Value, State in next, Value do
                if State then -- Only add if selected
                    table.insert(_G.selectedWeapons, Value)
                end
            end
            print("Mutlidropdown changed:", table.concat(_G.selectedWeapons, ", "))
        end)

        local AutoEquipToggle = attack:AddToggle("AutoEquipToggle", {
            Title = "自动装备武器", 
            Default = false 
        })

        AutoEquipToggle:OnChanged(function()
            task.spawn(function()
                while Options.AutoEquipToggle.Value do
                    task.wait(0.5)
                    
                    pcall(function()
                        local plr = game:GetService("Players").LocalPlayer
                        if not plr then return end
                        
                        local character = plr.Character
                        if not character then return end
                        
                        -- Check if player is alive
                        local humanoid = character:FindFirstChild("Humanoid")
                        if not humanoid or humanoid.Health <= 0 then return end
                        
                        local backpack = plr.Backpack
                        if not backpack then return end
                        
                        -- Move selected tools from Backpack to Character
                        for _, weaponName in pairs(_G.selectedWeapons) do
                            local tool = backpack:FindFirstChild(weaponName)
                            if tool and tool:IsA("Tool") then
                                tool.Parent = character
                                print("Equipped", weaponName)
                            end
                        end
                    end)
                end
            end)
        end)

        local Toggle = attack:AddToggle("AttackToggle", {Title = "自动攻击开关", Default = false })

        Toggle:OnChanged(function()
            while Options.AttackToggle.Value do
                task.wait(1)
                
                pcall(function()
                    local user = game:GetService("VirtualUser")
                    local player = game.Players.LocalPlayer
                    
                    -- Wait for character to exist
                    if not player.Character then return end
                    
                    local mouse = player:GetMouse()
                    user:CaptureController()
                    user:ClickButton1(Vector2.new(mouse.x, mouse.y))
                end)
            end
        end)

        
        local PlayerFarmToggle = Tabs.main:AddToggle("PlayerFarmToggle", {Title = "击杀玩家（危險 ⚠）", Default = false })

        PlayerFarmToggle:OnChanged(function()
            while Options.PlayerFarmToggle.Value do
                task.wait()
                
                local localPlayer = game:GetService("Players").LocalPlayer
                local character = localPlayer.Character
                
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = character.HumanoidRootPart
                    local closestPlayer = nil
                    local closestDistance = math.huge
                    
                    -- Loop through all players
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        -- Skip the local player
                        if player ~= localPlayer then
                            local targetCharacter = player.Character
                            
                            if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                                local targetRoot = targetCharacter.HumanoidRootPart
                                local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
                                
                                -- Check if this player is closer
                                if distance < closestDistance then
                                    closestDistance = distance
                                    closestPlayer = targetRoot
                                end
                            end
                        end
                    end
                    
                    -- Teleport to the closest player
                    if closestPlayer and closestPlayer.Parent.Humanoid.Health > 0 then
                        humanoidRootPart.CFrame = closestPlayer.CFrame * CFrame.new(0, 0, 2)
                        print("Teleported to closest player at distance:", closestDistance)
                    else
                        print("No other players found")
                    end
                else
                    print("Character or HumanoidRootPart not found")
                end
            end
        end)


        local stats = Tabs.main:AddSection("自动属性")

        local StatDropdown = stats:AddDropdown("StatDropdown", {
            Title = "选择属性倍率",
            Values = {"1", "10", "100", "1000", "10000", "100000", "1000000", "10000000", "10000000", "100000000", "1000000000"},
            Multi = false,
            Default = 1,
        })

        _G.currentstatrange = nil
        StatDropdown:OnChanged(function(Value)
            _G.currentstatrange = tonumber(Value)
        end)

        local AutoStatDM = stats:AddToggle("AutoStatDM", {Title = "自动属性 物理伤害", Default = false })

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if Options.AutoStatDM.Value then
                    task.wait(0.5)
                    local args = {[1] = _G.currentstatrange}
                    game:GetService("ReplicatedStorage").skillp.dm:FireServer(unpack(args))
                end
            end
        end))

        local AutoStatMD = stats:AddToggle("AutoStatMD", {Title = "自动属性 魔法伤害", Default = false })

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if Options.AutoStatMD.Value then
                    task.wait(0.5)
                    local args = {[1] = _G.currentstatrange}
                    game:GetService("ReplicatedStorage").skillp.md:FireServer(unpack(args))
                end
            end
        end))

        local AutoStatHP = stats:AddToggle("AutoStatHP", {Title = "自动属性 生命值", Default = false })

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if Options.AutoStatHP.Value then
                    task.wait(0.5)
                    local args = {[1] = _G.currentstatrange}
                    game:GetService("ReplicatedStorage").skillp.hp:FireServer(unpack(args))
                end
            end
        end))

        local AutoStatRG = stats:AddToggle("AutoStatRG", {Title = "自动属性 再生", Default = false })

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if Options.AutoStatRG.Value then
                    task.wait(0.5)
                    local args = {[1] = _G.currentstatrange}
                    game:GetService("ReplicatedStorage").skillp.rg:FireServer(unpack(args))
                end
            end
        end))

        local AutoStatTD = stats:AddToggle("AutoStatTD", {Title = "自动属性 真实伤害", Default = false })

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if Options.AutoStatTD.Value then
                    task.wait(0.5)
                    local args = {[1] = _G.currentstatrange}
                    game:GetService("ReplicatedStorage").skillp.td:FireServer(unpack(args))
                end
            end
        end))

        local AutoStatDF = stats:AddToggle("AutoStatDF", {Title = "自动属性 防御", Default = false })

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if Options.AutoStatDF.Value then
                    task.wait(0.5)
                    local args = {[1] = _G.currentstatrange}
                    game:GetService("ReplicatedStorage").skillp.df:FireServer(unpack(args))
                end
            end
        end))

        local AutoStatSD = stats:AddToggle("AutoStatSD", {Title = "自动属性 速度", Default = false })

        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if Options.AutoStatSD.Value then
                    task.wait(0.5)
                    local args = {[1] = _G.currentstatrange}
                    game:GetService("ReplicatedStorage").skillp.sd:FireServer(unpack(args))
                end
            end
        end))



------------------------------ BOSS FARM SECTION

        local autobossection = Tabs.boss:AddSection("自动BOSS刷怪")

        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local location = game:GetService("Workspace").mobs.BOSS
        local mobList2 = {}

        local function refreshMobList2()
            mobList2 = {} -- Clear the existing list
            for i, v in pairs(location:GetChildren()) do
                table.insert(mobList2, v.Name) -- Add mob name to list
                print(v.Name) -- Optional: still print for debugging
            end
        end

        refreshMobList2()

        local MultiDropdown = autobossection:AddDropdown("MultiDropdown", {
            Title = "BOSS名称",
            Description = "你可以选择多个选项",
            Values = mobList2,
            Multi = true,
            Default = {},
        })

        local selectedMobs = {}
        
        MultiDropdown:OnChanged(function(Value)
            selectedMobs = {}
            for Value, State in next, Value do
                table.insert(selectedMobs, Value)
            end
        end)

        autobossection:AddButton({
            Title = "刷新怪物",
            Callback = function()
                refreshMobList2()
                MultiDropdown:SetValues(mobList2)
            end
        })

        local MultiBossFarmToggle = autobossection:AddToggle("MultiBossFarmToggle", {Title = "自动刷怪", Default = false })

        MultiBossFarmToggle:OnChanged(function()
            while Options.MultiBossFarmToggle.Value do
                task.wait()
                
                local player = game.Players.LocalPlayer
                if not player then continue end
                
                local character = player.Character
                if not character then continue end
                
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then continue end
                
                -- Iterate through each selected mob
                for _, mobName in ipairs(selectedMobs) do
                    if not Options.MultiBossFarmToggle.Value then break end
                    
                    local bossMobs = game:GetService("Workspace").mobs:FindFirstChild("BOSS")
                    if bossMobs then
                        local mob = bossMobs:FindFirstChild(mobName)
                        
                        if mob then
                            local humanoid = mob:FindFirstChild("Humanoid")
                            local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
                            
                            -- Check if mob is alive and valid
                            if humanoid and mobRoot and humanoid.Health > 0 then
                                -- Keep teleporting until mob is dead
                                while humanoid.Health > 0 and Options.MultiBossFarmToggle.Value do
                                    pcall(function()
                                        local hrp = player.Character.HumanoidRootPart
                                        
                                        if mobRoot and hrp then
                                            local targetPos = mobRoot.Position
                                            
                                            -- Position above the mob and face towards it
                                            local offset = Vector3.new(0, 0, 3)
                                            local lookAt = CFrame.lookAt(targetPos + offset, targetPos)
                                            hrp.CFrame = lookAt
                                        end
                                    end)
                                    
                                    task.wait()
                                end

                                task.wait()
                            end
                        end
                    end
                end
            end
        end)




---------------------- SPECIAL MONSTER

        local autospecialsection = Tabs.special:AddSection("多重特殊怪物刷怪")

        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local location = game:GetService("Workspace").mobs.special
        local mobList4 = {}

        local function refreshMobList4()
            mobList4 = {} -- Clear the existing list
            for i, v in pairs(location:GetChildren()) do
                table.insert(mobList4, v.Name) -- Add mob name to list
                print(v.Name) -- Optional: still print for debugging
            end
        end

        refreshMobList4()

        local SpecialMultiDropdown = autospecialsection:AddDropdown("SpecialMultiDropdown", {
            Title = "特殊怪物名稱",
            Description = "你可以选择多个选项",
            Values = mobList4,
            Multi = true,
            Default = {},
        })

        local specialselectedMobs = {}
        
        SpecialMultiDropdown:OnChanged(function(Value)
            specialselectedMobs = {}
            for Value, State in next, Value do
                table.insert(specialselectedMobs, Value)
            end
        end)

        autospecialsection:AddButton({
            Title = "刷新怪物",
            Callback = function()
                refreshMobList2()
                MultiDropdown:SetValues(mobList4)
            end
        })

        local MultiSpecialFarmToggle = autospecialsection:AddToggle("MultiSpecialFarmToggle", {Title = "自动刷怪", Default = false })

        MultiSpecialFarmToggle:OnChanged(function()
            while Options.MultiSpecialFarmToggle.Value do
                task.wait()
                
                local player = game.Players.LocalPlayer
                if not player then continue end
                
                local character = player.Character
                if not character then continue end
                
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then continue end
                
                -- Iterate through each selected mob
                for _, mobName in ipairs(specialselectedMobs) do
                    if not Options.MultiSpecialFarmToggle.Value then break end
                    
                    local specialMobs = game:GetService("Workspace").mobs:FindFirstChild("special")
                    if specialMobs then
                        local mob = specialMobs:FindFirstChild(mobName)
                        
                        if mob then
                            local humanoid = mob:FindFirstChild("Humanoid")
                            local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
                            
                            -- Check if mob is alive and valid
                            if humanoid and mobRoot and humanoid.Health > 0 then
                                while humanoid.Health > 0 and Options.MultiSpecialFarmToggle.Value do
                                    pcall(function()
                                        local hrp = player.Character.HumanoidRootPart
                                        
                                        if mobRoot and hrp then
                                            local targetPos = mobRoot.Position
                                            
                                            -- Position above the mob and face towards it
                                            local offset = Vector3.new(0, 0, 3)
                                            local lookAt = CFrame.lookAt(targetPos + offset, targetPos)
                                            hrp.CFrame = lookAt
                                        end
                                    end)
                                    
                                    task.wait()
                                end

                                task.wait()
                            end
                        end
                    end
                end
            end
        end)


	---- anti afk
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
        -- -- -- -- -- -- -- 
    end
    Window:SelectTab(1)
end

MainScript()
