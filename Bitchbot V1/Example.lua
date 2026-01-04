local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/Bitchbot%20V1/Library.lua"))()

local Window = Library:Window({
    Name = "bitch bot!",
    FadeSpeed = 0.3
}) do
    local Pages = {
        ["Combat"] = Window:Page({
            Name = "combat",
            Columns = 3
        }),

        ["Misc"] = Window:Page({
            Name = "misc",
            Columns = 3
        }),

        ["Visuals"] = Window:Page({
            Name = "visuals",
            Columns = 3
        }),
        
        ["Settings"] = Window:Page({
            Name = "settings",
            Columns = 3
        }),
    } do -- Combat tab
        local AimbotSection = Pages["Combat"]:Section({Name = "Aimbot", Side = 1}) do -- Aimbot section
            local Toggle = AimbotSection:Toggle({
                Name = "Toggle",
                Flag = "Toggle",
                Default = false,
                Callback = function(Value)
                    print(Value)
                end
            })

            Toggle:Colorpicker({
                Name = "Colorpicker",
                Flag = "Colorpicker3",
                Alpha = 0,
                Default = Color3.fromRGB(255, 0, 255),
                Callback = function(Value)
                    print(Value)
                end
            })

            Toggle:Colorpicker({
                Name = "Colorpicker",
                Flag = "Colorpicker3",
                Alpha = 0,
                Default = Color3.fromRGB(255, 0, 0),
                Callback = function(Value)
                    print(Value)
                end
            })

            Toggle:Keybind({
                Name = "Keybind",
                Flag = "Keybind",
                Default = Enum.KeyCode.Z,
                Mode = "Toggle",
                Callback = function(Value)
                    print(Value)
                end
            })

            local Button = AimbotSection:Button()
            Button:NewButton({
                Name = "press",
                Callback = function()
                    print("Pressed")
                end
            })

            local Slider = AimbotSection:Slider({
                Name = "Slider",
                Flag = "Slider",
                Min = 0,
                Max = 100,
                Decimals = 0.1,
                Suffix = "%",
                Default = 100,
                Callback = function(Value)
                    print(Value)
                end
            })

            local Dropdown = AimbotSection:Dropdown({
                Name = "Dropdown",
                Flag = "Dropdown",
                Multi = false,
                Default = "Option 1",
                Items = {"Option 1", "Option 2", "Option 3"},
                Callback = function(Value)
                    print(Value)
                end
            })

            local MultiDropdown = AimbotSection:Dropdown({
                Name = "Multi Dropdown",
                Flag = "MultiDropdown",
                Multi = true,
                Default = {"Option 1", "Option 2"},
                Items = {"Option 1", "Option 2", "Option 3"},
                Callback = function(Value)
                    print(Value)
                end
            })

            local Label = AimbotSection:Label("label", "Left")

            Label:Colorpicker({
                Name = "Colorpicker",
                Flag = "Colorpicker4",
                Alpha = 0,
                Default = Color3.fromRGB(255, 0, 0),
                Callback = function(Value)
                    print(Value)
                end
            })

            Label:Keybind({
                Name = "Keybind",
                Flag = "Keybind2",
                Default = Enum.KeyCode.Z,
                Mode = "Toggle",
                Callback = function(Value)
                    print(Value)
                end
            })

            local Textbox = AimbotSection:Textbox({
                Name = "Textbox",
                Flag = "Textbox",
                Placeholder = "..",
                Default = "suck a cock",
                Callback = function(Value)
                    print(Value)
                end
            })
        end
        local AimbotSection2 = Pages["Combat"]:Section({Name = "Aimbot2", Side = 2})
        local AimbotSection3 = Pages["Combat"]:Section({Name = "Aimbot3", Side = 3})
    end

    do -- Settings tab
        local ThemingSection = Pages["Settings"]:Section({Name = "Theming", Side = 2}) do
            for Index, Value in Library.Theme do 
                ThemingSection:Label(Index, "Left"):Colorpicker({
                    Name = Index,
                    Flag = Index.."Theme",
                    Default = Value,
                    Callback = function(Value)
                        Library.Theme[Index] = Value
                        Library:ChangeTheme(Index, Value)
                    end
                })
            end
        end
        
        local ConfigSection = Pages["Settings"]:Section({Name = "Configs", Side = 1}) do
            local ConfigName 
            local ConfigSelected

            local ConfigsList = ConfigSection:Dropdown({
                Items = { },
                Name = "Configs",
                Flag = "Configs List",
                Callback = function(Value)
                    ConfigSelected = Value
                end
            })

            ConfigSection:Textbox({
                Name = "Config Name",
                Placeholder = ". .",
                Flag = "Config Name",
                Callback = function(Value)
                    ConfigName = Value
                end
            })

            local CreateAndDelete = ConfigSection:Button()

            CreateAndDelete:NewButton({
                Name = "Create",
                Callback = function()
                    if ConfigName and ConfigName ~= "" then
                        if isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                            Library:Notification("Config with this name already exists.", 4, Color3.fromRGB(255, 0, 0))
                            return
                        end

                        writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                        Library:Notification("Created config "..ConfigName.." sucessfully", 4, Color3.fromRGB(0, 255, 0))
                        Library:RefreshConfigsList(ConfigsList)
                    else
                        print(ConfigName)
                    end 
                end
            })

            CreateAndDelete:NewButton({
                Name = "Delete",
                Callback = function()
                    if ConfigSelected and isfile(Library.Folders.Configs .. "/" .. ConfigSelected) then
                        Library:DeleteConfig(ConfigSelected)
                        Library:Notification("Deleted config "..ConfigSelected.." successfully", 5, Color3.fromRGB(0, 255, 0))
                        Library:RefreshConfigsList(ConfigsList)
                    end 
                end
            })

            local SaveAndLoad = ConfigSection:Button()

            SaveAndLoad:NewButton({
                Name = "Save",
                Callback = function()
                    if ConfigSelected then
                        Library:SaveConfig(ConfigSelected)
                        Library:Notification("Saved config "..ConfigSelected.." successfully", 5, Color3.fromRGB(0, 255, 0))
                    end
                end
            })

            SaveAndLoad:NewButton({
                Name = "Load",
                Callback = function()
                    if ConfigSelected then
                        local Success, Error = Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))
                        if not Success then 
                            Library:Notification("Failed to load config "..ConfigSelected.." report this to the developers:\n"..Error, 6, Color3.fromRGB(255, 0, 0))
                        else
                            Library:Notification("Loaded config "..ConfigSelected.." successfully", 5, Color3.fromRGB(0, 255, 0))
                        end
                    end
                end
            })

            local RefreshButton = ConfigSection:Button()

            RefreshButton:NewButton({
                Name = "Refresh",
                Callback = function()
                    Library:Notification("Refreshed list succesfully", 4, Color3.fromRGB(0, 255, 0))
                    Library:RefreshConfigsList(ConfigsList)
                end
            })

            Library:RefreshConfigsList(ConfigsList)
        end

        local MenuSection = Pages["Settings"]:Section({Name = "Menu", Side = 3}) do
            MenuSection:Button():NewButton({
                Name = "Unload",
                Callback = function()
                    Library:Unload()
                end
            })

            MenuSection:Label("Menu keybind", "Left"):Keybind({
                Name = "MenuKeybind",
                Flag = "MenuKeybind",
                Mode = "Toggle",
                Default = Library.MenuKeybind,
                Callback = function(X)
                    print(X)
                    print(Library.Flags["MenuKeybind"].Key)
                    Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                end
            })

            MenuSection:Slider({
                Name = "Tween time",
                Flag = "TweenTime",
                Default = Library.Tween.Time,
                Min = 0,
                Max = 5,
                Decimals = 0.01,
                Callback = function(Value)
                    Library.Tween.Time = Value
                end
            })

            MenuSection:Dropdown({
                Name = "Tween style",
                Flag = "TweenStyle",
                Default = "Cubic",
                Items = {"Linear", "Sine", "Quad", "Cubic", "Quart", "Quint", "Exponential", "Circular", "Back", "Elastic", "Bounce"},
                Callback = function(Value)
                    Library.Tween.Style = Enum.EasingStyle[Value]
                end
            })

            MenuSection:Dropdown({
                Name = "Tween Direction",
                Flag = "TweenDirection",
                Default = "Out",
                Items = {"In", "Out", "InOut"},
                Callback = function(Value)
                    Library.Tween.Direction = Enum.EasingDirection[Value]
                end
            })
        end
    end
end

Library:Notification("Test notification\nmultiline test\na\na\na", 5, Library.Theme.Accent)
