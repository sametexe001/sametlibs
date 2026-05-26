local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/secrethaxx/Library.lua"))()

local Window = Library:Window({
    Name = 'secrethaxx<font color="rgb(126, 192, 255)">.club</font> | developer  | lifetime',
    Rank = "developer"
}) do
    do
        -- 
        local Watermark = Window:Watermark({
            Name = "cappcuino ballerina stuck in washing machine",
            SubName = "cappcuino ballerina stuck in washing machine diddy"
        })

        local KeybindList = Window:KeybindList({
            Name = 'hot<font color="rgb(126, 192, 255)">keys</font>'
        })

        --[[
        local StaffList = Window:StaffList({
            Name ='staff<font color="rgb(0, 80, 255)"> list</font>'
        })

        StaffList:Add("samet", "owner")
        StaffList:Add("samet", "owner")
        StaffList:Add("samet", "owner")

        local TargetIndicator = Window:TargetIndicator({
            Name = "target<font color='rgb(0, 80, 255)'> info</font>"
        })

        TargetIndicator:SetTarget(game:GetService("Players").LocalPlayer)

        task.spawn(function()
            while task.wait(1) do 
                game.Players.LocalPlayer.Character.Humanoid.Health = math.random(30, 100)

                --TargetIndicator:ClearItems()
            end
        end)

        TargetIndicator:AddItem("rbxassetid://125055486069298")
        TargetIndicator:AddItem("rbxassetid://125055486069298")
        TargetIndicator:AddItem("rbxassetid://125055486069298")
        TargetIndicator:AddItem("rbxassetid://125055486069298")

        TargetIndicator:AddItem("rbxassetid://125055486069298")
        TargetIndicator:AddItem("rbxassetid://125055486069298")
        TargetIndicator:AddItem("rbxassetid://125055486069298")
        TargetIndicator:AddItem("rbxassetid://125055486069298")
        --]]
    end

    local CombatPage = Window:Page({Name = "combat"})
    local MiscPage = Window:Page({Name = "misc"})
    local VisualsPage = Window:Page({Name = "visuals"})
    local PlayersPage = Window:Page({Name = "players"})

    do -- combat
        local aimbot = CombatPage:Section({Name = "aimbot", Side = 1}) 
        local multisection = CombatPage:MultiSection({Side = 2})
        local aimbot2 = multisection:Add("aimbot")
        local aimbot3 = multisection:Add("aimbot")

        do -- aimbot
            local toggleporn = aimbot:Toggle({Name = "aimbot", Flag = "aimbot", Default = false})   
            aimbot:Button({Name = "aimbot", Callback = function()
                print("aimbot")
            end})         
            aimbot:Slider({Name = "aimbot", Flag = "aimbot", Min = 0, Max = 100, Default = 0, Decimals = 1, Suffix = "ft"})
            aimbot:Dropdown({Name = "aimbot", Flag = "aimbot", Items = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}, Multi = false})

            toggleporn:Colorpicker({Flag = "aimbot", Default = Color3.fromRGB(255, 255, 255)})
            local toggleporn = aimbot:Toggle({Name = "aimbot", Flag = "aimbot", Default = false}) 
            toggleporn:Keybind({Name = "aimbot keybind", Flag = "aimbot", Default = Enum.UserInputType.MouseButton2})

            aimbot:Textbox({Name = "aimbot", Flag = "aimbot", Numeric = true, Placeholder = "Enter a number", Default = ""})
            aimbot:Textbox({Name = "aimbot", Flag = "aimbot", Numeric = false, Finished = false, Placeholder = "Enter anything", Default = ""})
        end

        do -- aimbot2
            local togglesex = aimbot2:Toggle({Name = "test toggle", Flag = "diddy"})
            local Settinghs = togglesex:Settings()

            Settinghs:Button({Name = "aimbot", Callback = function()
                print("aimbot")
            end})         
            Settinghs:Slider({Name = "aimbot", Flag = "aimbot", Min = 0, Max = 100, Default = 0, Decimals = 1, Suffix = "ft"})
            Settinghs:Dropdown({Name = "aimbot", Flag = "aimbot", Items = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}, Multi = false})
        end
    end
end

task.spawn(function()
    for i = 1, 10 do 
        Library:Notification({
            Name = "notificationnononononononon",
            Time = 5
        })
        task.wait(0.5)
    end
end)

Window:InitWindow()
