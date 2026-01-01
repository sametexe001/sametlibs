--[[
    bitchbot v1
    Made by samet

    Example at bottom
    Assign different flags to each element to prevent from configs overriding eachother

    Documentation:
    function Library:Notification(Text: string, Duration: number/float, Color: Color3)

    function Library:Window(Data: table
        Name/name: string,
        Size/size: UDim2,
        FadeSpeed/fadespeed: number/float
    )

    function Window:Page(Data: table
        Icon/icon: string,
        Columns/columns: number
    )

    function Page:Section(Data: table
        Name/name: string,
        Side/side: number
    )

    function Section:Label(Text: string, Alignment: string)
        function Label:Keybind(Data: table
            Name/name: string,
            Mode/mode: string,
            Default/default: EnumItem,
            Flag/flag: string,
            Callback/callback: function
        )

        function Label:Colorpicker(Data: table
            Name/name: string,
            Flag/flag: string,
            Default/default: Color3,
            Alpha/alpha: number,
            Callback/callback: function
        )
    
    function Section:Button(void)
        function Button:NewButton(Data: table
            Name/name: string,
            Callback/callback: function
        )

    function Section:Toggle(Data: table
        Name/name: string,
        Default/default: boolean,
        Flag/flag: string,
        Callback/callback: function
    )
        function Toggle:Keybind(Data: table
            Name/name: string,
            Mode/mode: string,
            Default/default: EnumItem,
            Flag/flag: string,
            Callback/callback: function
        )

        function Toggle:Colorpicker(Data: table
            Name/name: string,
            Flag/flag: string,
            Default/default: Color3,
            Alpha/alpha: number,
            Callback/callback: function
        )

    function Section:Slider(Data: table
        Name/name: string,
        Min/min: number,
        Max/max: number,
        Decimals/decimals: number,
        Default/default: number,
        Suffix/suffix: string,
        Flag/flag: string,
        Callback/callback: function
    )

    function Section:Dropdown(Data: table
        Name/name: string,
        Default/default: string,
        Flag/flag: string,
        Multi/multi: boolean,
        Items/items: table,
        Callback/callback: function
    )

    function Section:Textbox(Data: table
        Name/name: string,
        Default/default: string,
        Placeholder/placeholder: string,
        Flag/flag: string,
        Callback/callback: function
    )
]]

if getgenv().Library and getgenv().Library.Unload then 
    getgenv().Library:Unload()
end

local Library do
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    
    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower

    local InstanceNew = Instance.new

    local RectNew = Rect.new
    
    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 
        Flags = { },

        Tween = {
            Time = 0.25,
            Style = Enum.EasingStyle.Quart,
            Direction = Enum.EasingDirection.Out
        },

        Folders = {
            Directory = "bitchbot",
            Configs = "bitchbot/Configs",
            Assets = "bitchbot/Assets",
        },

        Images = {
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Value"] = { "Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/horizontalhue.png?raw=true" },
            ["Checkers"] = { "Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        Font = nil,
        KeyList = nil
    }

    Library.__index = Library

    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    local Themes = {
        ["Preset"] = {
            ["Background"] = FromRGB(39, 39, 44),
            ["Inline"] = FromRGB(61, 60, 65),
            ["Outline"] = FromRGB(61, 60, 65),
            ["Page Background"] = FromRGB(49, 48, 52),
            ["Border"] = FromRGB(31, 25, 36),
            ["Accent"] = FromRGB(139, 69, 182),
            ["Text Border"] = FromRGB(0, 0, 0),
            ["Light Accent"] = FromRGB(139, 94, 216),
            ["Element"] = FromRGB(39, 39, 44),
            ["Text"] = FromRGB(230, 230, 230),
            ["Inactive Text"] = FromRGB(185, 185, 185)
        }
    }

    Library.Theme = TableClone(Themes["Preset"])

    -- Folders
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    -- Images
    for Index, Value in Library.Images do 
        local ImageData = Value

        local ImageName = ImageData[1]
        local ImageLink = ImageData[2]
        
        if not isfile(Library.Folders.Assets .. "/" .. ImageName) then
            writefile(Library.Folders.Assets .. "/" .. ImageName, game:HttpGet(ImageLink))
        end
    end

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 

            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.Border = function(self)
            if not self.Instance then 
                return
            end

            local Item = self.Instance
            local UIStroke = Instances:Create("UIStroke", {
                Parent = Item,
                Color = Library.Theme.Border,
                Thickness = 1,
                LineJoinMode = Enum.LineJoinMode.Miter
            })

            UIStroke:AddToTheme({Color = "Border"})

            return UIStroke
        end

        Instances.FadeItem = function(self, Visibility, Speed)
            local Item = self.Instance

            if Visibility == true then 
                Item.Visible = true
            end

            local Descendants = Item:GetDescendants()
            TableInsert(Descendants, Item)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
                end
            end
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
            end

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            local ResizeButton = Instances:Create("ImageButton", {
				Parent = Gui,
                Image = "",
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 10, 0, 10),
				Position = UDim2New(1, -4, 1, -4),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
                ZIndex = 5,
				AutoButtonColor = false,
                Visible = true,
			})  ResizeButton:AddToTheme({ImageColor3 = "Accent"})

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then

                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)

                    Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Resizing = false
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

                        Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                        Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

                        Tween:Create(Gui, TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Delta}, true)
                    end
                end
            end)

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end

            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }

            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        function CustomFont:Get(Name)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end
        end

        CustomFont:New("ProggyClean", 200, "Regular", {
            Url = "https://github.com/bluescan/proggyfonts/raw/refs/heads/master/ProggyOriginal/ProggyClean.ttf"
        })

        Library.Font = CustomFont:Get("ProggyClean")
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        BorderColor3 = FromRGB(0, 0, 0),
        AnchorPoint = Vector2New(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2New(1, 0, 0, 0),
        Size = UDim2New(0, 0, 1, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })

    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        Padding = UDimNew(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right
    })

    Instances:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        PaddingTop = UDimNew(0, 10),
        PaddingBottom = UDimNew(0, 10),
        PaddingRight = UDimNew(0, 10),
        PaddingLeft = UDimNew(0, 10)
    })

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil 
        getgenv().Library = nil
    end

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("Connection%s%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.Color, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.SaveConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config .. ".json") then
            writefile(Library.Folders.Configs .. "/" .. Config .. ".json", Library:GetConfig())
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(Library.Folders.Configs, Library.Folders.Directory .. "/", "")

        for Index, Value in listfiles(Library.Folders.Configs) do
            local FileName = StringGSub(Value, Library.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame, XOffset, YOffset)
        Frame = Frame.Instance
        XOffset = XOffset or 0 
        YOffset = YOffset or 0

        local MousePosition = Vector2New(Mouse.X + XOffset, Mouse.Y + YOffset)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Notification = function(self, Text, Duration, Color)
        local Items = { } do
            Items["Notification"] = Instances:Create("Frame", {
                Parent = self.NotifHolder.Instance,
                Name = "\0",
                BorderColor3 = FromRGB(31, 25, 36),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(39, 39, 44)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Color = FromRGB(61, 60, 65),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Outline"})

            Instances:Create("UIPadding", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 5),
                PaddingBottom = UDimNew(0, 5),
                PaddingRight = UDimNew(0, 10),
                PaddingLeft = UDimNew(0, 5)
            })

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(230, 230, 230),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Text,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["UIStroke2"] = Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                Name = "\0",
                LineJoinMode = Enum.LineJoinMode.Miter
            })  Items["UIStroke2"]:AddToTheme({Color = "Text Border"})

            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, 10, 0, -5),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, 10),
                BorderSizePixel = 0,
                BackgroundColor3 = Color
            }) 
        end

        for Index, Value in Items do 
            local TransparencyProperty = Tween:GetProperty(Value.Instance)  

            if not TransparencyProperty then 
                continue
            end

            if type(TransparencyProperty) == "table" then 
                for _, Property in TransparencyProperty do 
                    if Index == "Text" and Property == "BackgroundTransparency" then 
                        continue
                    end

                    Value.Instance[Property] = 1
                end
            else
                Value.Instance[TransparencyProperty] = 1
            end
        end

        local OldSize = Items["Notification"].Instance.AbsoluteSize
        Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)
        Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None

        Library:Thread(function()
            Items["Notification"]:Tween(nil, {Size = UDim2New(0, OldSize.X, 0, OldSize.Y)})
            task.wait(0.1)
            for Index, Value in Items do 
                local TransparencyProperty = Tween:GetProperty(Value.Instance)  
                
                if not TransparencyProperty then 
                    continue
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        if Index == "Text" and Property == "BackgroundTransparency" then 
                            continue
                        end

                        Value:Tween(nil, {[Property] = 0})
                    end
                else
                    Value:Tween(nil, {[TransparencyProperty] = 0})
                end
            end

            task.delay(Duration + 0.1, function()
                for Index, Value in Items do 
                    local TransparencyProperty = Tween:GetProperty(Value.Instance)  
                    
                    if not TransparencyProperty then 
                        continue
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            Value:Tween(nil, {[Property] = 1})
                        end
                    else
                        Value:Tween(nil, {[TransparencyProperty] = 1})
                    end
                end
                task.wait(0.1)
                Items["Notification"]:Tween(nil, {Size = UDim2New(0, 0, 0, 0)})
                task.wait(0.5)
                Items["Notification"]:Clean()
            end)
        end)
    end

    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Hue = 0,
            Saturation = 0,
            Value = 0,

            Alpha = 0,

            Color = FromRGB(0, 0, 0),
            HexValue = "ffffff",
            LastColor = FromRGB(0, 0, 0),

            HoveringColor = FromRGB(0, 0, 0),
            IsOpen = false,

            Flag = Data.Flag
        }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(61, 60, 65),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(0, 28, 0, 12),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 71, 34)
            })  Items["ColorpickerButton"]:AddToTheme({BorderColor3 = "Outline"})

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Color = FromRGB(31, 25, 36),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["CheckersImage"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Tile,
                ImageTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Checkers"),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                TileSize = UDim2New(0, 6, 0, 6),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["ColorpickerWindow"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + 26),
                BorderColor3 = FromRGB(31, 25, 36),
                Size = UDim2New(0, 211, 0, 207),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(39, 39, 44),
                Visible = false
            })  Items["ColorpickerWindow"]:AddToTheme({BorderColor3 = "Border", BackgroundColor3 = "Background"})

            Items["ColorpickerWindow"]:MakeDraggable()
            Items["ColorpickerWindow"]:MakeResizeable(Vector2New(211, 207), Vector2New(9999, 9999))

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                Color = FromRGB(61, 60, 65),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(61, 60, 65),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 8, 0, 8),
                Size = UDim2New(1, -40, 1, -55),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 71, 34)
            })  Items["Palette"]:AddToTheme({BorderColor3 = "Outline"})

            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Color = FromRGB(31, 25, 36),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Value"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Value"),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Saturation"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Saturation"),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Size = UDim2New(0, 2, 0, 2),
                Position = UDim2New(0, 12, 0, 12),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter
            })

            Items["HueOutline"] = Instances:Create("Frame", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, -8, 0, 8),
                BorderColor3 = FromRGB(61, 60, 65),
                Size = UDim2New(0, 15, 1, -55),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["HueOutline"]:AddToTheme({BorderColor3 = "Outline"})

            Items["Hue"] = Instances:Create("ImageButton", {
                Parent = Items["HueOutline"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(61, 60, 65),
                AutoButtonColor = false,
                Image = "",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIGradient", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })

            Instances:Create("UIStroke", {
                Parent = Items["HueOutline"].Instance,
                Name = "\0",
                Color = FromRGB(31, 25, 36),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["HueOutline"].Instance,
                Name = "\0",
                Size = UDim2New(1, -2, 0, 1),
                Position = UDim2New(0, 1, 0, 12),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter
            })

            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(61, 60, 65),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 8, 1, -25),
                Size = UDim2New(1, -16, 0, 15),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 71, 34)
            })  Items["Alpha"]:AddToTheme({BorderColor3 = "Outline"})

            Instances:Create("UIStroke", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                Color = FromRGB(31, 25, 36),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                TileSize = UDim2New(0, 6, 0, 6),
                Image = Library:GetImage("Checkers"),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Name = "\0",
                Rotation = 0,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
            })

            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                Position = UDim2New(0, 8, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, -2),
                BorderSizePixel = 0,
                ZIndex = 4,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter
            })

            Items["ConfirmButton"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(230, 230, 230),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "[Confirm]",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Size = UDim2New(0.5, -8, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 8, 1, -3),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["ConfirmButton"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["ConfirmButton"].Instance,
                Name = "\0",
                LineJoinMode = Enum.LineJoinMode.Miter
            }):AddToTheme({Color = "Text Border"})

            Items["CloseButton"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(230, 230, 230),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "[Cancel]",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 1),
                Size = UDim2New(0.5, -8, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2New(1, -8, 1, -3),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["CloseButton"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["CloseButton"].Instance,
                Name = "\0",
                LineJoinMode = Enum.LineJoinMode.Miter
            }):AddToTheme({Color = "Text Border"})
        end 

        local Debounce = false
        local RenderStepped

        local SlidingPalette = false 
        local SlidingHue = false 
        local SlidingAlpha = false

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return 
            end

            self.IsOpen = Bool 
            
            Debounce = true 

            if self.IsOpen then 
                Items["ColorpickerWindow"].Instance.Visible = true

                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + 26)
                end)    

                for Index, Value in Library.OpenFrames do 
                    if Value ~= self and Value.Hue then
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[self] = self
            else
                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end

                if Library.OpenFrames[self] then 
                    Library.OpenFrames[self] = nil
                end
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween

            for _,Value in Descendants do
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, self.IsOpen, Data.Window.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, self.IsOpen, Data.Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["ColorpickerWindow"].Instance.Visible = self.IsOpen
            end)
        end

        function Colorpicker:Get()
            return self.Color, self.Alpha 
        end

        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then 
                return
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            self.Saturation = ValueX
            self.Value = ValueY

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.985)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.985)

            Items["PaletteDragger"]:Tween(TweenInfo.new(0.21, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            self:Update()
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then 
                return
            end

            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            self.Hue = ValueY

            local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.985)

            Items["HueDragger"]:Tween(TweenInfo.new(0.21, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 1, SlideY, 0)})
            self:Update()
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not SlidingAlpha then 
                return 
            end
            
            local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)

            self.Alpha = ValueX

            local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.99)

            Items["AlphaDragger"]:Tween(TweenInfo.new(0.21, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 1)})
            self:Update(true)
        end

        function Colorpicker:Update(IsFromAlpha)
            local Hue, Saturation, Value = self.Hue, self.Saturation, self.Value
            local Color = FromHSV(Hue, Saturation, Value)

            self.HoveringColor = Color
            self.HexValue = Color:ToHex()

            Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Color})
            Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})
            Items["CheckersImage"].Instance.ImageTransparency = 1 - self.Alpha

            if not IsFromAlpha then 
                Items["Alpha"]:Tween(nil, {BackgroundColor3 = Color})
            end
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "string" then 
                Color = FromHex(Color)
            elseif type(Color) == "table" then
                Color = FromRGB(Color[1], Color[2], Color[3])
                Alpha = Color[4]
            end

            self.Hue, self.Saturation, self.Value = Color:ToHSV()
            self.Alpha = Alpha or 0

            self.Color = Color

            self.HexValue = self.Color:ToHex()

            self.LastColor = self.Color

            Library.Flags[self.Flag] = {
                Alpha = self.Alpha,
                Color = self.HexValue
            }

            local ColorPositionX = MathClamp(1 - self.Saturation, 0, 0.985)
            local ColorPositionY = MathClamp(1 - self.Value, 0, 0.985)

            local AlphaPositionX = MathClamp(self.Alpha, 0, 0.985)

            local HuePositionY = MathClamp(self.Hue, 0, 0.99)

            Items["PaletteDragger"]:Tween(TweenInfo.new(0.21, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(ColorPositionX, 0, ColorPositionY, 0)})
            Items["HueDragger"]:Tween(TweenInfo.new(0.21, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 1, HuePositionY, 0)})
            Items["AlphaDragger"]:Tween(TweenInfo.new(0.21, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 1)})

            if Data.Callback then 
                Library:SafeCall(Data.Callback, self.Color, self.Alpha)
            end

            self:Update()
        end

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                SlidingPalette = true 

                Colorpicker:SlidePalette(Input)
            end
        end)

        Items["Palette"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                SlidingPalette = false
            end
        end)

        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                SlidingHue = true 

                Colorpicker:SlideHue(Input)
            end
        end)

        Items["Hue"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                SlidingHue = false
            end
        end)

        Items["Alpha"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                SlidingAlpha = true 

                Colorpicker:SlideAlpha(Input)
            end
        end)

        Items["Alpha"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                SlidingAlpha = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then 
                if SlidingPalette then 
                    Colorpicker:SlidePalette(Input)
                end

                if SlidingHue then 
                    Colorpicker:SlideHue(Input)
                end

                if SlidingAlpha then 
                    Colorpicker:SlideAlpha(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                    return 
                end

                if Debounce then 
                    return 
                end

                Colorpicker:SetOpen(false)
            end
        end)
    
        Items["ConfirmButton"]:Connect("MouseButton1Down", function()
            Colorpicker:Set(Colorpicker.HoveringColor, Colorpicker.Alpha)
            Colorpicker.LastColor = Colorpicker.Color
            Colorpicker:SetOpen(false)
        end)

        Items["CloseButton"]:Connect("MouseButton1Down", function()
            Colorpicker:Set(Colorpicker.LastColor, Colorpicker.Alpha)
            Colorpicker:SetOpen(false)
        end)

        if Data.Default then 
            Colorpicker:Set(Data.Default, Data.Alpha)
        end

        Library.SetFlags[Colorpicker.Flag] = function(Value, Alpha)
            Colorpicker:Set(Value, Alpha)
        end

        return Colorpicker, Items 
    end

    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            IsOpen = false,
            Flag = Data.Flag,

            Key = nil,
            Value = "",

            Toggled = false,
            IsPicking = false
        }

        local Items = { } do
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0),
                Position = UDim2New(0, 0, 0, 0),
                Size = UDim2New(0, 0, 0, 15),
                FontFace = Library.Font,
                Text = "None",
                TextSize = 12,
                AutomaticSize = Enum.AutomaticSize.X, 
                TextColor3 = FromRGB(230, 230, 230),
                TextStrokeTransparency = 1,
                BackgroundColor3 = FromRGB(39, 39, 44),
                BorderSizePixel = 2, 
                AutoButtonColor = false,
                BorderColor3 = FromRGB(61, 60, 65)
            })  Items["KeyButton"]:AddToTheme({TextColor3 = "Text", BorderColor3 = "Outline", BackgroundColor3 = "Element"})

            Instances:Create("UIStroke", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = FromRGB(31, 25, 36)
            }):AddToTheme({Color = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                LineJoinMode = Enum.LineJoinMode.Miter,
            }):AddToTheme({Color = "Text Border"})

            Instances:Create("UIPadding", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                PaddingLeft = UDimNew(0, 3),
                PaddingRight = UDimNew(0, 4),
            })

            Items["Window"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AnchorPoint = Vector2New(0, 0),
                Name = "\0",
                Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + 25),
                Size = UDim2New(0, 50, 0, 48),
                BorderSizePixel = 2,
                Visible = false,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Window"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Window"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(230, 230, 230),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Toggle"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Toggle"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Hold",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 15),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Hold"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Hold"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Always"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Always",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 30),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Always"]:AddToTheme({TextColor3 = "Text"})
             
            Instances:Create("UIStroke", {
                Parent = Items["Always"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
        end

        local Modes = {
            ["Toggle"] = Items["Toggle"],
            ["Hold"] = Items["Hold"],
            ["Always"] = Items["Always"]
        }

        function Keybind:Get()
            return Keybind.Toggled, Keybind.Key
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                self.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[self.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                self.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = TextToDisplay

                Library.Flags[self.Flag] = {
                    Mode = self.Mode,
                    Key = self.Key,
                    Toggled = self.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, self.Toggled)
                end
            elseif type(Key) == "table" then
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                self.Key = tostring(Key.Key)

                if Key.Mode then
                    self.Mode = Key.Mode
                    self:SetMode(Key.Mode)
                else
                    self.Mode = "Toggle"
                    self:SetMode("Toggle")
                end

                local KeyString = Keys[self.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                self.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = TextToDisplay

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, self.Toggled)
                end
            elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                self.Mode = Key
                self:SetMode(Keybind.Mode)

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, self.Toggled)
                end
            end

            self.Picking = false
        end

        function Keybind:SetMode(Mode)
            for Index, Value in Modes do 
                if Index == Mode then 
                    Value:ChangeItemTheme({TextColor3 = "Accent"})
                    Value:Tween(nil, {TextColor3 = Library.Theme.Accent})
                else
                    Value:ChangeItemTheme({TextColor3 = "Text"})
                    Value:Tween(nil, {TextColor3 = Library.Theme.Text})
                end
            end

            Library.Flags[self.Flag] = {
                Mode = self.Mode,
                Key = self.Key,
                Toggled = self.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, self.Toggled)
            end
        end

        local Debounce = false
        local RenderStepped

        function Keybind:SetOpen(Bool)
            if Debounce then
                return 
            end

            self.IsOpen = Bool

            Debounce = true

            if self.IsOpen then 
                Items["Window"].Instance.Visible = true

                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["Window"].Instance.Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + 25)
                end)

                for Index, Value in Library.OpenFrames do 
                    if Value ~= self and Value.Key then 
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[self] = self
            else
                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end

                if Library.OpenFrames[self] then 
                    Library.OpenFrames[self] = nil
                end
            end

            local Descendants = Items["Window"].Instance:GetDescendants()
            TableInsert(Descendants, Items["Window"].Instance)

            local NewTween

            for _,Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue 
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, self.IsOpen, Data.Window.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, self.IsOpen, Data.Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["Window"].Instance.Visible = self.IsOpen
            end)
        end

        function Keybind:Press(Bool)
            if self.Mode == "Toggle" then 
                self.Toggled = not self.Toggled
            elseif self.Mode == "Hold" then 
                self.Toggled = Bool
            elseif self.Mode == "Always" then 
                self.Toggled = true
            end

            Library.Flags[Data.Flag] = {
                Mode = self.Mode,
                Key = self.Key,
                Toggled = self.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, self.Toggled)
            end
        end

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            if Keybind.Picking then 
                return
            end

            Keybind.Picking = true
            Items["KeyButton"].Instance.Text = "..."

            local InputBegan 
            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then 
                    Keybind:Set(Input.KeyCode)
                else
                    Keybind:Set(Input.UserInputType)
                end

                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key and not Keybind.Value == "None" then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key and not Keybind.Value == "None"  then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        Items["Always"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always")
        end)

        if Data.Default then
            Keybind.Mode = Data.Mode or "Toggle"
            Keybind:SetMode(Keybind.Mode)
            Keybind:Set({Key = Data.Default, Mode = Data.Mode})
        end

        Library.SetFlags[Keybind.Flag] = function(Value)
            Keybind:Set(Value)
        end

        return Keybind, Items 
    end

    do
        Library.Window = function(self, Data)
            Data = Data or { }

            local Window = {
                Name = Data.Name or Data.name or "bitchbot",
                FadeSpeed = Data.FadeSpeed or Data.fadespeed or 0.25,
                Size = Data.Size or Data.size or UDim2New(0, 763, 0, 530),

                Pages = { },
                Items = { },

                IsOpen = false
            }

            local Items = { } do
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0),
                    Position = UDim2New(0, Camera.ViewportSize.X / 2.5, 0, Camera.ViewportSize.Y / 2.5),
                    BorderColor3 = FromRGB(31, 25, 36),
                    Size = Window.Size,
                    BorderSizePixel = 2,
                    Visible = false,
                    BackgroundColor3 = FromRGB(39, 39, 44)
                })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2New(Window.Size.X.Offset, Window.Size.Y.Offset), Vector2New(9999, 9999))

                Instances:Create("UIStroke", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Color = FromRGB(61, 60, 65),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 4, 0, 4),
                    BorderColor3 = FromRGB(61, 60, 65),
                    Size = UDim2New(1, -8, 1, -8),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(61, 60, 65)
                })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Color = FromRGB(31, 25, 36),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["AccentBackground"] = Instances:Create("Frame", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(139, 69, 182)
                })  Items["AccentBackground"]:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("UIStroke", {
                    Parent = Items["AccentBackground"].Instance,
                    Name = "\0",
                    Color = FromRGB(139, 94, 216),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Light Accent"})

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["AccentBackground"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Window.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0, 2),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})

                Items["NormalBackground"] = Instances:Create("Frame", {
                    Parent = Items["AccentBackground"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 5, 0, 20),
                    BorderColor3 = FromRGB(31, 25, 36),
                    Size = UDim2New(1, -10, 1, -25),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(39, 39, 44)
                })  Items["NormalBackground"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Instances:Create("UIStroke", {
                    Parent = Items["NormalBackground"].Instance,
                    Name = "\0",
                    Color = FromRGB(61, 60, 65),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["NormalBackground"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 42),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, -42),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Pages"] = Instances:Create("Frame", {
                    Parent = Items["NormalBackground"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Window.Items = Items
            end

            local Debounce = false

            function Window:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                self.IsOpen = Bool 

                Debounce = true

                if self.IsOpen then 
                    Items["MainFrame"].Instance.Visible = true
                end

                local Descendants = Items["MainFrame"].Instance:GetDescendants()
                TableInsert(Descendants, Items["MainFrame"].Instance)

                local NewTween

                for _,Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then 
                        continue
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, self.IsOpen, self.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, self.IsOpen, self.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    Items["MainFrame"].Instance.Visible = self.IsOpen
                end)
            end

            function Window:SetText(Text)
                Text = tostring(Text)

                Items["Title"].Instance.Text = Text
            end

            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if GPE then 
                    return 
                end

                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:SetOpen(true)
            return setmetatable(Window, self)
        end

        Library.Page = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self,

                Name = Data.Name or Data.name or "Page",
                Columns = Data.Columns or Data.columns or 3,

                Active = false,

                Items = { },
                ColumnsData = { }
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["Pages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(49, 48, 52)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background"})

                Items["UIStroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    Color = FromRGB(61, 60, 65),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })  Items["UIStroke"]:AddToTheme({Color = "Outline"})

                Items["Hide"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(61, 60, 65)
                })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Outline"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Page.Name,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})

                Items["HideUpper"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 0, 0, -1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 2, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(61, 60, 65)
                })  Items["HideUpper"]:AddToTheme({BackgroundColor3 = "Outline"})

                Items["HideLeft"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 1, 0, -1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(61, 60, 65)
                })  Items["HideLeft"]:AddToTheme({BackgroundColor3 = "Outline"})

                Items["PageContent"] = Instances:Create("Frame", {
                    Parent = Page.Window.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["PageContent"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill
                })

                for Index = 1, Page.Columns do 
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["PageContent"].Instance,
                        Name = "\0",
                        ScrollBarImageColor3 = FromRGB(0, 0, 0),
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarThickness = 0,
                        BackgroundTransparency = 1,
                        Size = UDim2New(1, 0, 1, 0),
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 12),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    Instances:Create("UIPadding", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 12),
                        PaddingBottom = UDimNew(0, 12),
                        PaddingRight = UDimNew(0, 12),
                        PaddingLeft = UDimNew(0, 12)
                    })

                    Page.ColumnsData[Index] = NewColumn
                end

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end

                self.Active = Bool 

                Debounce = true 

                if self.Active then
                    Items["PageContent"].Instance.Visible = true 
                    Items["PageContent"].Instance.Parent = Page.Window.Items["Content"].Instance

                    Items["UIStroke"]:ChangeItemTheme({Color = "Background"})
                    Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Background"})
                    Items["Hide"]:ChangeItemTheme({BackgroundColor3 = "Background"})

                    Items["UIStroke"]:Tween(nil, {Color = Library.Theme.Background})
                    Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme.Background})
                    Items["Hide"]:Tween(nil, {BackgroundColor3 = Library.Theme.Background})
                else
                    Items["PageContent"].Instance.Parent = Library.UnusedHolder.Instance

                    Items["UIStroke"]:ChangeItemTheme({Color = "Outline"})
                    Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Page Background"})
                    Items["Hide"]:ChangeItemTheme({BackgroundColor3 = "Outline"})

                    Items["UIStroke"]:Tween(nil, {Color = Library.Theme.Outline})
                    Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme["Page Background"]})
                    Items["Hide"]:Tween(nil, {BackgroundColor3 = Library.Theme.Outline})
                end

                local Descendants = Items["PageContent"].Instance:GetDescendants()
                TableInsert(Descendants, Items["PageContent"].Instance)

                local NewTween 

                for _,Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, self.Active, Page.Window.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, self.Active, Page.Window.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    Items["PageContent"].Instance.Visible = self.Active
                end)
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do 
                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",
                Side = Data.Side or Data.side or 1,

                Items = { }
            }

            local Items = { } do
                Items["Section"] = Instances:Create("Frame", {
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 25),
                    BorderColor3 = FromRGB(31, 25, 36),
                    BorderSizePixel = 2,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(39, 39, 44)
                })  Items["Section"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Instances:Create("UIStroke", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    Color = FromRGB(61, 60, 65),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 2, 0, -13),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})

                Instances:Create("UIPadding", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 8)
                })

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(1, -16, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Section.Items = Items
            end

            return setmetatable(Section, Library.Sections)
        end

        Library.Sections.Toggle = function(self, Data)
            Data = Data or { }

            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,

                Value = false,
            }

            local Items = { } do 
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Toggle.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 15),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(61, 60, 65),
                    Size = UDim2New(0, 12, 0, 12),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(39, 39, 44)
                })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = FromRGB(31, 25, 36),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(39, 39, 44)
                })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Element"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Toggle.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 22, 0.5, 1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 0, 20),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Toggle:Get()
                return self.Value 
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,

                    Name = Data.Name or Data.name or "Colorpicker",
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or FromRGB(255, 255, 255),
                    Alpha = Data.Alpha or Data.alpha or 0,
                    Callback = Data.Callback or Data.callback or function(Value) end,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,
                    Name = Colorpicker.Name,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Alpha = Colorpicker.Alpha,
                    Callback = Colorpicker.Callback,
                    Parent = Items["SubElements"]   
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,

                    Name = Data.Name or Data.name or "Keybind",
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.Z,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,
                    Name = Keybind.Name,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Callback = Keybind.Callback,
                    Mode = Keybind.Mode,
                    Parent = Items["SubElements"]
                })

                return NewKeybind
            end

            function Toggle:Set(Bool)
                self.Value = Bool
                Library.Flags[self.Flag] = Bool 

                if self.Value then 
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Light Accent", BorderColor3 = "Outline"})
                    Items["Inline"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Light Accent"]})
                    Items["Inline"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                else
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Outline"})
                    Items["Inline"]:ChangeItemTheme({BackgroundColor3 = "Element"})

                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                    Items["Inline"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                end

                if self.Callback then 
                    Library:SafeCall(self.Callback, self.Value)
                end
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle 
        end

        Library.Sections.Button = function(self)
            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,
            }

            local Items = { } do
                Items["Button"] = Instances:Create("Frame", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Holder"] = Instances:Create("Frame", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 15, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -30, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Button:NewButton(Data)
                Data = Data or { }

                local NewButton = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,

                    Name = Data.Name or Data.name or "Button",
                    Callback = Data.Callback or Data.callback or function() end,
                }

                local SubItems = { } do
                    SubItems["NewButton"] = Instances:Create("TextButton", {
                        Parent = Items["Holder"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(61, 60, 65),
                        Text = "",
                        AutoButtonColor = false,
                        Size = UDim2New(1, 0, 1, 0),
                        BorderSizePixel = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(139, 94, 216)
                    })  SubItems["NewButton"]:AddToTheme({BackgroundColor3 = "Light Accent", BorderColor3 = "Outline"})

                    Instances:Create("UIStroke", {
                        Parent = SubItems["NewButton"].Instance,
                        Name = "\0",
                        Color = FromRGB(31, 25, 36),
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }):AddToTheme({Color = "Border"})

                    SubItems["Inline"] = Instances:Create("TextButton", {
                        Parent = SubItems["NewButton"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        Position = UDim2New(0, 1, 0, 1),
                        Size = UDim2New(1, -2, 1, -2),
                        BorderSizePixel = 0,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(139, 69, 182)
                    })  SubItems["Inline"]:AddToTheme({BackgroundColor3 = "Accent"})

                    SubItems["Text"] = Instances:Create("TextLabel", {
                        Parent = SubItems["Inline"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(230, 230, 230),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = NewButton.Name,
                        BackgroundTransparency = 1,
                        Size = UDim2New(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  SubItems["Text"]:AddToTheme({TextColor3 = "Text"})

                    Instances:Create("UIStroke", {
                        Parent = SubItems["Text"].Instance,
                        Name = "\0",
                        LineJoinMode = Enum.LineJoinMode.Miter
                    }):AddToTheme({Color = "Text Border"})
                end

                SubItems["Inline"]:Connect("MouseButton1Down", function()
                    Library:SafeCall(NewButton.Callback)
                end)

                return NewButton
            end

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            Data = Data or { }

            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or 0,
                Min = Data.Min or Data.min or 0,
                Max = Data.Max or Data.max or 100,
                Decimals = Data.Decimals or Data.decimals or 1,
                Suffix = Data.Suffix or Data.suffix or "",
                Callback = Data.Callback or Data.callback or function() end,

                Value = 0,
                Sliding = false
            }

            local Items = { } do
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 33),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})

                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    AutoButtonColor = false,
                    Text = "",
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(61, 60, 65),
                    Size = UDim2New(1, 0, 0, 12),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(39, 39, 44)
                })  Items["RealSlider"]:AddToTheme({BorderColor3 = "Outline", BackgroundColor3 = "Element"})

                Instances:Create("UIStroke", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Color = FromRGB(31, 25, 36),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0.4000000059604645, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(139, 69, 182)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "0.4s",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})
            end

            function Slider:Get()
                return self.Value
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:Set(Value)
                self.Value = MathClamp(Library:Round(Value, self.Decimals), self.Min, self.Max)

                Library.Flags[self.Flag] = self.Value

                Items["Accent"]:Tween(TweenInfo.new(0.21, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((self.Value - self.Min) / (self.Max - self.Min), 0, 1, 0)})
                Items["Value"].Instance.Text = StringFormat("%s%s", tostring(self.Value), self.Suffix)

                if self.Callback then 
                    Library:SafeCall(self.Callback, self.Value)
                end
            end

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Slider.Sliding = true 

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)
                end
            end)

            Items["RealSlider"]:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Slider.Sliding = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    if Slider.Sliding then
                        local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                        Slider:Set(Value)
                    end
                end
            end)

            if Slider.Default then 
                Slider:Set(Slider.Default)
            end
        
            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider
        end

        Library.Sections.Dropdown = function(self, Data)
            Data = Data or { }  

            local Dropdown = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Dropdown",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Items = Data.Items or Data.items or { "One", "Two", "Three" },
                Default = Data.Default or Data.default or nil,
                Callback = Data.Callback or Data.callback or function() end,
                Multi = Data.Multi or Data.multi or false,

                Value = { },
                Options = { },

                IsOpen = false
            }

            local Items = { } do
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 38),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})

                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    AutoButtonColor = false,
                    Text = "",
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(61, 60, 65),
                    Size = UDim2New(1, 0, 0, 15),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(39, 39, 44)
                })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Color = FromRGB(31, 25, 36),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "--",
                    Size = UDim2New(1, -25, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 2, 0, 0),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})

                Instances:Create("Frame", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(31, 25, 36)
                }):AddToTheme({BackgroundColor3 = "Border"})

                Items["OpenIcon"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = ">",
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -4, 0, 0),
                    Size = UDim2New(0, 15, 0, 15),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["OpenIcon"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["OpenIcon"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})

                Items["OptionHolder"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    Visible = false,
                    BorderColor3 = FromRGB(61, 60, 65),
                    Position = UDim2New(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y + 20),
                    Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, 0),
                    BorderSizePixel = 2,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(39, 39, 44)
                })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Color = FromRGB(31, 25, 36),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UIPadding", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 5),
                    PaddingBottom = UDimNew(0, 5),
                    PaddingRight = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 5)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end
            
            function Dropdown:Set(Option)
                if self.Multi then 
                    if type(Option) ~= "table" then 
                        return 
                    end

                    self.Value = Option
                    Library.Flags[self.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = self.Options[Value]

                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true
                        OptionData:Toggle("Active")
                    end

                    local TextToDisplay = #self.Value == 0 and "--" or TableConcat(self.Value, ", ")
                    Items["Value"].Instance.Text = TextToDisplay
                else
                    local OptionData = self.Options[Option]

                    if not OptionData then
                        return
                    end

                    for Index, Value in self.Options do 
                        if Value ~= OptionData then 
                            Value.Selected = false
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true
                            Value:Toggle("Active")
                        end
                    end

                    self.Value = OptionData.Name
                    Library.Flags[self.Flag] = OptionData.Name

                    Items["Value"].Instance.Text = OptionData.Name
                end

                if self.Callback then 
                    Library:SafeCall(self.Callback, self.Value)
                end
            end

            function Dropdown:AddOption(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Option,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2New(1, 0, 0, 15),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  OptionButton:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})

                local OptionData = {
                    Name = Option,
                    Selected = false,
                    Button = OptionButton,
                }

                function OptionData:Toggle(Status)
                    if Status == "Active" then 
                        self.Button:ChangeItemTheme({TextColor3 = "Accent"})
                        self.Button:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    else
                        self.Button:ChangeItemTheme({TextColor3 = "Text"}) 
                        self.Button:Tween(nil, {TextColor3 = Library.Theme.Text})
                    end
                end

                function OptionData:Set()
                    if not Dropdown.IsOpen then 
                        return 
                    end

                    self.Selected = not self.Selected

                    if Dropdown.Multi then 
                        local Index = TableFind(Dropdown.Value, self.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, self.Name)
                        end

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        self:Toggle(Index and "Inactive" or "Active")

                        local TextToDisplay = #Dropdown.Value == 0 and "--" or TableConcat(Dropdown.Value, ", ")
                        Items["Value"].Instance.Text = TextToDisplay
                    else
                        if self.Selected then 
                            for Index, Value in Dropdown.Options do 
                                if Value ~= self then 
                                    Value.Selected = false
                                    Value:Toggle("Inactive")
                                end
                            end

                            self:Toggle("Active")

                            Library.Flags[Dropdown.Flag] = self.Name
                            Dropdown.Value = self.Name

                            Items["Value"].Instance.Text = self.Name
                        else
                            self:Toggle("Inactive")

                            Library.Flags[Dropdown.Flag] = nil
                            Dropdown.Value = nil

                            Items["Value"].Instance.Text = "--"
                        end
                    end

                    if Dropdown.Callback then 
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end 
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                self.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if self.Options[Option] then 
                    self.Options[Option].Button:Clean()
                    self.Options[Option] = nil
                end
            end

            function Dropdown:Clear()
                for Index, Value in self.Options do 
                    self:Remove(Value.Name)
                end
            end

            function Dropdown:Refresh(List)
                Dropdown:Clear()

                for Index, Value in List do 
                    Dropdown:AddOption(Value)
                end
            end

            local Debounce = false
            local RenderStepped

            function Dropdown:SetOpen(Bool)
                if Debounce then
                    return
                end

                self.IsOpen = Bool 

                Debounce = true 

                if self.IsOpen then 
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OpenIcon"]:Tween(nil, {Rotation = 90})

                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["OptionHolder"].Instance.Position = UDim2New(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y + 20)
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, 0)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= self and Value.Options then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[self] = self
                else
                    if Library.OpenFrames[self] then 
                        Library.OpenFrames[self] = nil
                    end

                    Items["OpenIcon"]:Tween(nil, {Rotation = 0})

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["OptionHolder"].Instance)

                local NewTween 

                for _,Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then 
                        continue
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, self.IsOpen, Dropdown.Window.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, self.IsOpen, Dropdown.Window.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    Items["OptionHolder"].Instance.Visible = self.IsOpen
                end)
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                    if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                        return
                    end

                    if Debounce then 
                        return 
                    end

                    Dropdown:SetOpen(false)
                end                    
            end)

            for Index, Value in Dropdown.Items do 
                Dropdown:AddOption(Value)
            end

            if Dropdown.Default then 
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown 
        end

        Library.Sections.Label = function(self, Text, Alignment)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Text or "Label",
                Alignment = Alignment or "Left"
            }

            local Items = { } do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    TextXAlignment = Enum.TextXAlignment[Label.Alignment],
                    AutomaticSize = Enum.AutomaticSize.X,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    ZIndex = 1,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter,
                }):AddToTheme({Color = "Text Border"})

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 0, 20),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,

                    Name = Data.Name or Data.name or "Colorpicker",
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or FromRGB(255, 255, 255),
                    Alpha = Data.Alpha or Data.alpha or 0,
                    Callback = Data.Callback or Data.callback or function(Value) end,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,
                    Name = Colorpicker.Name,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Alpha = Colorpicker.Alpha,
                    Callback = Colorpicker.Callback,
                    Parent = Items["SubElements"]   
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,

                    Name = Data.Name or Data.name or "Keybind",
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.Z,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,
                    Name = Keybind.Name,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Callback = Keybind.Callback,
                    Mode = Keybind.Mode,
                    Parent = Items["SubElements"]
                })

                return NewKeybind
            end

            return Label
        end

        Library.Sections.Textbox = function(self, Data)
            Data = Data or { }

            local Textbox = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Textbox",
                Placeholder = Data.Placeholder or Data.placeholder or "...",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,

                Value = "",
            }

            local Items = { } do
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 38),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(230, 230, 230),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Textbox.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    AnchorPoint = Vector2New(0, 1),
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 12,
                    Size = UDim2New(1, 0, 0, 15),
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(61, 60, 65),
                    Text = "",
                    Position = UDim2New(0, 0, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = FromRGB(230, 230, 230),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(39, 39, 44)
                })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Inactive Text", BackgroundColor3 = "Element", BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    Color = FromRGB(31, 25, 36),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UIPadding", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 5)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Text Border"})
            end

            function Textbox:Get()
                return self.Value
            end

            function Textbox:Set(Text)
                Text = tostring(Text)

                Items["Input"].Instance.Text = Text
                self.Value = Text
                Library.Flags[self.Flag] = Text

                Items["Input"]:ChangeItemTheme({TextColor3 = "Text", PlaceholderColor3 = "Inactive Text", BackgroundColor3 = "Element", BorderColor3 = "Outline"})
                Items["Input"]:Tween(nil, {TextColor3 = Library.Theme.Text})

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, self.Value)
                end
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            Items["Input"]:Connect("Focused", function()
                Items["Input"]:ChangeItemTheme({TextColor3 = "Accent", PlaceholderColor3 = "Inactive Text", BackgroundColor3 = "Element", BorderColor3 = "Outline"})
                Items["Input"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
            end)

            Items["Input"]:Connect("FocusLost", function()
                Textbox:Set(Items["Input"].Instance.Text)
            end)

            if Textbox.Default then 
                Textbox:Set(Textbox.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox
        end
    end
end

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

getgenv().Library = Library
return Library
