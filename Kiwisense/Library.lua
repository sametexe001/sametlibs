--[[
    kiwisense
    Made by samet

    assign different flags to each element to prevent from configs overriding eachother
    example is at the bottom

    documentation:

    function Library:Window(Data: table
        Name/name: string
        Version/version: string
        Logo/logo: string
        Size/size: UDim2
        FadeSpeed/fadespeed: number/float
    )

    function Library:Watermark(Text: string, Logo: string)
    function Library:KeybindsList(void)
    function Library:Notification(Data: table
        Name/name: string
        Description/description: string
        Duration/duration: number
        Icon/icon: string
        IconColor/iconcolor: Color3
    )

    function Window:Page(
        Name/name: string
        Icon/icon: string
        Columns/columns: number
        SubPages/subpages: boolean
    )

    function Page:SubPage(
        Name/name: string
        Icon/icon: string
        Columns/columns: number
    )

    function Page/SubPage:Section(
        Name/name: string
        Icon/icon: string
        Side/side: number
    )

    function Section:Toggle(
        Name/name: string
        Default/default: boolean
        Flag/flag: string
        Callback/callback: function
    )

    function Toggle:Keybind(
        Name/name: string
        Flag/flag: string
        Mode/mode: string
        Default/default: Enum.KeyCode/Enum.UserInputType
        Callback/callback: function
    )

    function Toggle:Colorpicker(
        Name/name: string
        Default/default: Color3
        Flag/flag: string
        Alpha/alpha: number/float
        Callback/callback: function
    )

    function Section:Slider(
        Name/name: string
        Min/min: number
        Max/max: number
        Default/default: number
        Decimals/decimals: number
        Flag/flag: string
        Suffix/suffix: string
        Callback/callback: function
    )

    function Section:Textbox(
        Name/name: string
        Default/default: string
        Placeholder/placeholder: string
        Flag/flag: string
        Callback/callback: function
    )

    function Section:Dropdown(
        Name/name: string
        Items/items: table
        Default/default: string
        MaxSize/maxsize: number
        Flag/flag: string
        Multi/multi: boolean
        Callback/callback: function
    )

    function Section:Button(
        Name/name: string
        Callback/callback: function
    )

    function Section:Label(Name: string, Alignment: string)

    
    function Label:Keybind(
        Name/name: string
        Flag/flag: string
        Mode/mode: string
        Default/default: Enum.KeyCode/Enum.UserInputType
        Callback/callback: function
    )

    function Label:Colorpicker(
        Name/name: string
        Default/default: Color3
        Flag/flag: string
        Alpha/alpha: number/float
        Callback/callback: function
    )
]]

local LoadingTick = os.clock()

if getgenv().Library then
    getgenv().Library:Unload()
end

local ESPFonts = { }
local SelectedESPFont

local Options, MiscOptions do
    if getgenv().Esp then 
        getgenv().Esp.Unload()
    end 

    local Workspace = cloneref(game:GetService("Workspace"))
    local RunService = cloneref(game:GetService("RunService"))
    local HttpService = cloneref(game:GetService("HttpService"))
    local Players = cloneref(game:GetService("Players"))
    local TweenService = cloneref(game:GetService("TweenService"))

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new 
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new
    local camera = Workspace.CurrentCamera

    local Bones = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
    }

    -- Esp is mainly hardcoded because having to make a library for everything is very useless considering we're working with not more than 10 elements at once. 
    --[[
        PlayersTab.AddBar({Name = "Healthbar"})
        PlayersTab.AddText({Name = "Name"})
        PlayersTab.AddText({Name = "Distance"})
        PlayersTab.AddText({Name = "Weapon"})
        PlayersTab.AddText({Name = "Flags", Color1 = rgb(225, 255, 0)})
        PlayersTab.AddBox({Name = "Box"})

        Each element will have its own concat for their flag <-- this means that if you make a text called name itll make the flags
        ["Name"] = true; 
        ["Name_Color"] = { Color = rgb(255, 255, 255) };
        ["Name_Position"] = "Left";
        which will be overwritten in the table down below. 

        All elements will be updated with a metatable, look for the new index and there will be a refresh function.

        I labelled the main code with important tags because some people dont know how to find my code...
    ]]

    MiscOptions = {
        ["Enabled"] = false;

        -- Boxes
        ["Boxes"] = false;
        ["BoxType"] = "Corner";
        ["Box Gradient 1"] = { Color = rgb(0, 255, 255), Transparency = 0.9 };
        ["Box Gradient 2"] = { Color = rgb(255, 0, 0), Transparency = 0.4 };
        ["Box Gradient Rotation"] = 90;
        ["Box Fill"] = false; 
        ["Box Fill 1"] = { Color = rgb(0, 255, 255), Transparency = 0.9 };
        ["Box Fill 2"] = { Color = rgb(0, 255, 255), Transparency = 0.9 };
        ["Box Fill Rotation"] = 0;

        ["Healthbar"] = false;
        ["Healthbar_Position"] = "Left";
        ["Healthbar_Number"] = false;
        ["Healthbar_Low"] = { Color = rgb(255, 0, 0), Transparency = 1};
        ["Healthbar_Medium"] = { Color = rgb(255, 255, 0), Transparency = 1};
        ["Healthbar_Animations"] = false; 
        ["Healthbar_High"] = { Color = rgb(0, 255, 0), Transparency = 1};
        ["Healthbar_Font"] = "Verdana";
        ["Healthbar_Text_Size"] = 11;
        ["Healthbar_Thickness"] = 1;
        ["Healthbar_Tween"] = false;
        ["Healthbar_EasingStyle"] = "Circular";
        ["Healthbar_EasingDirection"] = "InOut";
        ["Healthbar_Easing_Speed"] = 1;

        -- Text Based Elements
        ["Name_Text"] = false; 
        ["Name_Text_Color"] = { Color = rgb(255, 255, 255) };
        ["Name_Text_Position"] = "Top";
        ["Name_Text_Font"] = "Verdana";
        ["Name_Text_Size"] = 11;
        
        ["Distance_Text"] = false; 
        ["Distance_Text_Color"] = { Color = rgb(255, 255, 255) };
        ["Distance_Text_Position"] = "Bottom";
        ["Distance_Text_Font"] = "Verdana";
        ["Distance_Text_Size"] = 11;
    };  

    Options = setmetatable({}, {__index = MiscOptions, __newindex = function(self, key, value) Esp.RefreshElements(key, value) end});

    local Fonts = {}; do
        local function RegisterFont(Name, Weight, Style, Asset)
            if not isfile(Asset.Id) then
                writefile(Asset.Id, Asset.Font)
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = "Normal",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Asset.Id),
                    },
                },
            }

            if not isfile(Name .. ".font") then
                writefile(Name .. ".font", HttpService:JSONEncode(Data))
            end

            return getcustomasset(Name .. ".font");
        end

        local FontNames = {
            ["ProggyClean"] = "ProggyClean.ttf",
            ["Tahoma"] = "fs-tahoma-8px.ttf",
            ["Verdana"] = "Verdana-Font.ttf",
            ["SmallestPixel"] = "smallest_pixel-7.ttf",
            ["ProggyTiny"] = "ProggyTiny.ttf",
            ["Minecraftia"] = "Minecraftia-Regular.ttf",
            ["Tahoma Bold"] = "tahoma_bold.ttf"
        }

        for name, suffix in FontNames do 
            local RegisteredFont = RegisterFont(name, 400, "Normal", {
                Id = suffix,
                Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/" .. suffix),
            }) 

            Fonts[name] = Font.new(RegisteredFont, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end
    end

    getgenv().Esp = { 
        Players = {}, 
        ScreenGui = Instance.new("ScreenGui", gethui()), 
        Cache = Instance.new("ScreenGui", gethui()), 
        Connections = {}, 
    }; do 
        Esp.ScreenGui.IgnoreGuiInset = true
        Esp.ScreenGui.Name = "EspObject"

        Esp.Cache.Enabled = false   

        function Esp:Create(instance, options)
            local Ins = Instance.new(instance) 
            
            for prop, value in options do 
                Ins[prop] = value
            end
            
            return Ins 
        end

        function Esp:ConvertScreenPoint(world_position)
            local ViewportSize = camera.ViewportSize
            local LocalPos = camera.CFrame:pointToObjectSpace(world_position) 

            local AspectRatio = ViewportSize.X / ViewportSize.Y
            local HalfY = -LocalPos.Z * math.tan(math.rad(camera.FieldOfView / 2))
            local HalfX = AspectRatio * HalfY
            
            local FarPlaneCorner = Vector3.new(-HalfX, HalfY, LocalPos.Z)
            local RelativePos = LocalPos - FarPlaneCorner
        
            local ScreenX = RelativePos.X / (HalfX * 2)
            local ScreenY = -RelativePos.Y / (HalfY * 2)
            
            local OnScreen = -LocalPos.Z > 0 and ScreenX >= 0 and ScreenX <= 1 and ScreenY >= 0 and ScreenY <= 1
            
            -- returns in pixels as opposed to scale
            return Vector3.new(ScreenX * ViewportSize.X, ScreenY * ViewportSize.Y, -LocalPos.Z), OnScreen
        end

        function Esp:Connection(signal, callback)
            local Connection = signal:Connect(callback)
            Esp.Connections[#Esp.Connections + 1] = Connection
            
            return Connection 
        end

        function Esp:BoxSolve(torso)
            if not torso then
                return nil, nil, nil
            end 

            local ViewportTop = torso.Position + (torso.CFrame.UpVector * 1.8) + camera.CFrame.UpVector
            local ViewportBottom = torso.Position - (torso.CFrame.UpVector * 2.5) - camera.CFrame.UpVector
            local Distance = (torso.Position - camera.CFrame.p).Magnitude

            local NewDistance = math.floor(Distance * 0.333)

            local Top, TopIsRendered = Esp:ConvertScreenPoint(ViewportTop)
            local Bottom, BottomIsRendered = Esp:ConvertScreenPoint(ViewportBottom)

            local Width = math.max(math.floor(math.abs(Top.X - Bottom.X)), 3)
            local Height = math.max(math.floor(math.max(math.abs(Bottom.Y - Top.Y), Width / 2)), 3)
            local BoxSize = Vector2.new(math.floor(math.max(Height / 1.5, Width)), Height)
            local BoxPosition = Vector2.new(math.floor(Top.X * 0.5 + Bottom.X * 0.5 - BoxSize.X * 0.5), math.floor(math.min(Top.Y, Bottom.Y)))
            
            return BoxSize, BoxPosition, TopIsRendered, NewDistance 
        end

        function Esp:Lerp(start, finish, t)
            t = t or 1 / 8

            return start * (1 - t) + finish * t
        end

        function Esp:Tween(Object, Properties, Info)
            local tween = TweenService:Create(Object, Info, Properties)
            tween:Play()
            
            return tween
        end

        function Esp.CreateObject( player, typechar ) -- IMPORTANT!
            local Data = { 
                Items = { }, 
                Info = {Character; Humanoid; Health = 0}; 
                Drawings = { }, 
                Type = typechar or "player"
            } 

            local Items = Data.Items; do
                -- Holder
                    Items.Holder = Esp:Create( "Frame" , {
                        Parent = Esp.ScreenGui;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0.4332570433616638, 0, 0.3255814015865326, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 211, 0, 240);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.HolderGradient = Esp:Create( "UIGradient" , {
                        Rotation = 0;
                        Name = "\0";
                        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(255, 255, 255))};
                        Parent = Items.Holder;
                        Enabled = true
                    });

                    -- All directions have a set default parent of Items.Holder 

                    -- Directions 
                        Items.Left = Esp:Create( "Frame" , {
                            Parent = Items.Holder;
                            Size = dim2(0, 0, 1, 0);
                            Name = "\0";
                            BackgroundTransparency = 1;
                            Position = dim2(0, -1, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            ZIndex = 2;
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Items.HealthbarTextsLeft = Esp:Create( "Frame", {
                            Visible = true;
                            BorderColor3 = rgb(0, 0, 0);
                            Parent = Esp.Cache;
                            Name = "\0";
                            BackgroundTransparency = 1;
                            LayoutOrder = -100;
                            BorderSizePixel = 0;
                            ZIndex = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Esp:Create( "UIListLayout" , {
                            FillDirection = Enum.FillDirection.Horizontal;
                            HorizontalAlignment = Enum.HorizontalAlignment.Right;
                            VerticalFlex = Enum.UIFlexAlignment.Fill;
                            Parent = Items.Left;
                            Padding = dim(0, 1);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        Items.LeftTexts = Esp:Create( "Frame" , {
                            LayoutOrder = -100;
                            Parent = Items.Left;
                            BackgroundTransparency = 1;
                            Name = "\0";
                            BorderColor3 = rgb(0, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Esp:Create( "UIListLayout" , {
                            Parent = Items.LeftTexts;
                            Padding = dim(0, 1);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        Items.Bottom = Esp:Create( "Frame" , {
                            Parent = Items.Holder;
                            Size = dim2(1, 0, 0, 0);
                            Name = "\0";
                            BackgroundTransparency = 1;
                            Position = dim2(0, 0, 1, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            ZIndex = 2;
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Esp:Create( "UIListLayout" , {
                            SortOrder = Enum.SortOrder.LayoutOrder;
                            HorizontalAlignment = Enum.HorizontalAlignment.Center;
                            HorizontalFlex = Enum.UIFlexAlignment.Fill;
                            Parent = Items.Bottom;
                            Padding = dim(0, 1)
                        });

                        Items.BottomTexts = Esp:Create( "Frame", {
                            LayoutOrder = 1;
                            Parent = Items.Bottom;
                            BackgroundTransparency = 1;
                            Name = "\0";
                            BorderColor3 = rgb(0, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Esp:Create( "UIListLayout", {
                            Parent = Items.BottomTexts;
                            Padding = dim(0, 1);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        Items.Top = Esp:Create( "Frame" , {
                            Parent = Items.Holder;
                            Size = dim2(1, 0, 0, 0);
                            Name = "\0";
                            BackgroundTransparency = 1;
                            Position = dim2(0, 0, 0, -1);
                            BorderColor3 = rgb(0, 0, 0);
                            ZIndex = 2;
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Esp:Create( "UIListLayout" , {
                            VerticalAlignment = Enum.VerticalAlignment.Bottom;
                            SortOrder = Enum.SortOrder.LayoutOrder;
                            HorizontalAlignment = Enum.HorizontalAlignment.Center;
                            HorizontalFlex = Enum.UIFlexAlignment.Fill;
                            Parent = Items.Top;
                            Padding = dim(0, 1)
                        });

                        Items.TopTexts = Esp:Create( "Frame", {
                            LayoutOrder = -100;
                            Parent = Items.Top;
                            BackgroundTransparency = 1;
                            Name = "\0";
                            BorderColor3 = rgb(0, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Esp:Create( "UIListLayout", {
                            Parent = Items.TopTexts;
                            Padding = dim(0, 1);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        Items.Right = Esp:Create( "Frame" , {
                            Parent = Esp.Cache;
                            Size = dim2(0, 0, 1, 0);
                            Name = "\0";
                            BackgroundTransparency = 1;
                            Position = dim2(1, 1, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            ZIndex = 2;
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Esp:Create( "UIListLayout" , {
                            FillDirection = Enum.FillDirection.Horizontal;
                            VerticalFlex = Enum.UIFlexAlignment.Fill;
                            Parent = Items.Right;
                            Padding = dim(0, 1);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });
                        
                        Items.RightTexts = Esp:Create( "Frame" , {
                            LayoutOrder = 100;
                            Parent = Items.Right;
                            BackgroundTransparency = 1;
                            Name = "\0";
                            BorderColor3 = rgb(0, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                        
                        Esp:Create( "UIListLayout" , {
                            Parent = Items.RightTexts;
                            Padding = dim(0, 1);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        Items.HealthbarTextsRight = Esp:Create( "Frame", {
                            Visible = true;
                            BorderColor3 = rgb(0, 0, 0);
                            Parent = Esp.Cache;
                            Name = "\0";
                            BackgroundTransparency = 1;
                            LayoutOrder = 99;
                            BorderSizePixel = 0;
                            ZIndex = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                    --
                -- 

                -- Corner Boxes
                    Items.Corners = Esp:Create( "Frame", {
                        Parent = Esp.Cache; -- Items.Holder
                        Name = "\0";
                        BackgroundTransparency = 1;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.BottomLeftX = Esp:Create( "ImageLabel", {
                        ScaleType = Enum.ScaleType.Slice;
                        Parent = Items.Corners;
                        BorderColor3 = rgb(0, 0, 0);
                        Name = "\0";
                        BackgroundColor3 = rgb(255, 255, 255);
                        Size = dim2(0.4, 0, 0, 3);
                        AnchorPoint = vec2(0, 1);
                        Image = "rbxassetid://83548615999411";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 1, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        SliceCenter = rect(vec2(1, 1), vec2(99, 2))
                    });

                    Esp:Create( "UIGradient", {
                        Parent = Items.BottomLeftX
                    });

                    Items.BottomLeftY = Esp:Create( "ImageLabel", {
                        ScaleType = Enum.ScaleType.Slice;
                        Parent = Items.Corners;
                        BorderColor3 = rgb(0, 0, 0);
                        Name = "\0";
                        BackgroundColor3 = rgb(255, 255, 255);
                        Size = dim2(0, 3, 0.25, 0);
                        AnchorPoint = vec2(0, 1);
                        Image = "rbxassetid://101715268403902";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 1, -2);
                        ZIndex = 500;
                        BorderSizePixel = 0;
                        SliceCenter = rect(vec2(1, 0), vec2(2, 96))
                    });

                    Esp:Create( "UIGradient", {
                        Rotation = -90;
                        Parent = Items.BottomLeftY
                    });

                    Items.BottomRighX = Esp:Create( "ImageLabel", {
                        ScaleType = Enum.ScaleType.Slice;
                        Parent = Items.Corners;
                        BorderColor3 = rgb(0, 0, 0);
                        Name = "\0";
                        BackgroundColor3 = rgb(255, 255, 255);
                        Size = dim2(0.4, 0, 0, 3);
                        AnchorPoint = vec2(1, 1);
                        Image = "rbxassetid://83548615999411";
                        BackgroundTransparency = 1;
                        Position = dim2(1, 0, 1, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        SliceCenter = rect(vec2(1, 1), vec2(99, 2))
                    });

                    Esp:Create( "UIGradient", {
                        Parent = Items.BottomRighX
                    });

                    Items.BottomLeftY = Esp:Create( "ImageLabel", {
                        ScaleType = Enum.ScaleType.Slice;
                        Parent = Items.Corners;
                        BorderColor3 = rgb(0, 0, 0);
                        Name = "\0";
                        BackgroundColor3 = rgb(255, 255, 255);
                        Size = dim2(0, 3, 0.25, 0);
                        AnchorPoint = vec2(1, 1);
                        Image = "rbxassetid://101715268403902";
                        BackgroundTransparency = 1;
                        Position = dim2(1, 0, 1, -2);
                        ZIndex = 500;
                        BorderSizePixel = 0;
                        SliceCenter = rect(vec2(1, 0), vec2(2, 96))
                    });

                    Esp:Create( "UIGradient", {
                        Rotation = 90;
                        Parent = Items.BottomLeftY
                    });

                    Items.TopLeftY = Esp:Create( "ImageLabel", {
                        ScaleType = Enum.ScaleType.Slice;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Corners;
                        Name = "\0";
                        BackgroundColor3 = rgb(255, 255, 255);
                        Size = dim2(0, 3, 0.25, 0);
                        Image = "rbxassetid://102467475629368";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0, 2);
                        ZIndex = 500;
                        BorderSizePixel = 0;
                        SliceCenter = rect(vec2(1, 0), vec2(2, 98))
                    });

                    Esp:Create( "UIGradient", {
                        Rotation = 90;
                        Parent = Items.TopLeftY
                    });

                    Items.TopRightY = Esp:Create( "ImageLabel", {
                        ScaleType = Enum.ScaleType.Slice;
                        Parent = Items.Corners;
                        BorderColor3 = rgb(0, 0, 0);
                        Name = "\0";
                        BackgroundColor3 = rgb(255, 255, 255);
                        Size = dim2(0, 3, 0.25, 0);
                        AnchorPoint = vec2(1, 0);
                        Image = "rbxassetid://102467475629368";
                        BackgroundTransparency = 1;
                        Position = dim2(1, 0, 0, 2);
                        ZIndex = 500;
                        BorderSizePixel = 0;
                        SliceCenter = rect(vec2(1, 0), vec2(2, 98))
                    });

                    Esp:Create( "UIGradient", {
                        Rotation = -90;
                        Parent = Items.TopRightY
                    });

                    Items.TopRightX = Esp:Create( "ImageLabel", {
                        ScaleType = Enum.ScaleType.Slice;
                        Parent = Items.Corners;
                        BorderColor3 = rgb(0, 0, 0);
                        Name = "\0";
                        BackgroundColor3 = rgb(255, 255, 255);
                        Size = dim2(0.4, 0, 0, 3);
                        AnchorPoint = vec2(1, 0);
                        Image = "rbxassetid://83548615999411";
                        BackgroundTransparency = 1;
                        Position = dim2(1, 0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        SliceCenter = rect(vec2(1, 1), vec2(99, 2))
                    });

                    Esp:Create( "UIGradient", {
                        Parent = Items.TopRightX
                    });

                    Items.TopLeftX = Esp:Create( "ImageLabel", {
                        ScaleType = Enum.ScaleType.Slice;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Corners;
                        Name = "\0";
                        BackgroundColor3 = rgb(255, 255, 255);
                        Image = "rbxassetid://83548615999411";
                        BackgroundTransparency = 1;
                        Size = dim2(0.4, 0, 0, 3);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        SliceCenter = rect(vec2(1, 1), vec2(99, 2))
                    });

                    Esp:Create( "UIGradient", {
                        Parent = Items.TopLeftX
                    });
                -- 

                -- Normal Box 
                    Items.Box = Esp:Create( "Frame" , {
                        Parent = Esp.Cache; -- Items.Holder
                        Name = "\0";
                        BackgroundTransparency = 0.8500000238418579;
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Esp:Create( "UIStroke" , {  
                        Parent = Items.Box;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Items.Inner = Esp:Create( "Frame" , {
                        Parent = Items.Box;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.UIStroke = Esp:Create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        LineJoinMode = Enum.LineJoinMode.Miter;
                        Parent = Items.Inner
                    });

                    Items.BoxGradient = Esp:Create( "UIGradient" , {
                        Parent = Items.UIStroke
                    });

                    Items.Inner2 = Esp:Create( "Frame" , {
                        Parent = Items.Inner;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Esp:Create( "UIStroke" , {
                        Parent = Items.Inner2;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });
                -- 
                
                -- Healthbar
                    Items.Healthbar = Esp:Create( "Frame" , {
                        Name = "Left";
                        Parent = Esp.Cache;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 3, 0, 3);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    Items.HealthbarAccent = Esp:Create( "Frame" , {
                        Parent = Items.Healthbar;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.HealthbarGradient = Esp:Create( "UIGradient" , {
                        Enabled = true;
                        Parent = Items.HealthbarAccent;
                        Rotation = 90;
                        Color = rgbseq{rgbkey(0, rgb(0, 255, 0)), rgbkey(0.5, rgb(255, 125, 0)), rgbkey(1, rgb(255, 0, 0))}
                    });

                    Items.HealthbarText = Esp:Create( "TextLabel", {
                        FontFace = Fonts.ProggyClean;
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Esp.Cache; -- Items.HealthbarTextsLeft
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Esp:Create( "UIStroke", {
                        Parent = Items.HealthbarText;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });
                -- 

                -- Texts
                    Items.Text = Esp:Create( "TextLabel", {
                        FontFace = Fonts.ProggyClean;
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Esp.Cache;
                        Name = "Left";
                        Text = player.Name;
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 9;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Esp:Create( "UIStroke", {
                        Parent = Items.Text;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Items.Distance = Esp:Create( "TextLabel", {
                        FontFace = Fonts.ProggyClean;
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Esp.Cache;
                        Name = "Left";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 9;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Esp:Create( "UIStroke", {
                        Parent = Items.Distance;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });
                -- 
            end
        
            Data.ToolAdded = function(item)
                if not item:FindFirstChild("ItemRoot") then 
                    return 
                end 

                local exists = Data.Info.Character:FindFirstChild(item.Name) 
                Items["weapon"].Text = "[" .. item.Name .. "]"

                pcall(function()
                    Items["weapon"].Parent = exists and Items["Holder"] or Esp.Cache
                end)

                -- Refresh
            end

            Data.HealthChanged = function(Value)
                if not MiscOptions.Healthbar then 
                    return 
                end 

                local Humanoid = Data.Info.Humanoid
                local Multiplier = Value / 100
                local isHorizontal = MiscOptions.Healthbar_Position == "Top" or MiscOptions.Healthbar_Position == "Bottom"

                local Color = MiscOptions.Healthbar_Low.Color:Lerp(MiscOptions.Healthbar_Medium.Color, Multiplier)
                local Color_2 = Color:Lerp(MiscOptions.Healthbar_High.Color, Multiplier)

                if MiscOptions.Healthbar_Tween then  
                    local Health = Data.Info.Health

                    Esp:Tween(Items.HealthbarAccent, {
                        Size = dim2(isHorizontal and Multiplier or 1, -2, isHorizontal and 1 or Multiplier, -2), 
                        Position = dim2(0, 1, isHorizontal and 0 or 1 - Multiplier, 1)
                    }, TweenInfo.new(MiscOptions.Healthbar_Easing_Speed, Enum.EasingStyle[MiscOptions.Healthbar_EasingStyle], Enum.EasingDirection[MiscOptions.Healthbar_EasingDirection], 0, false, 0))
                    Esp:Tween(Items.HealthbarText, {Position = dim2(0, 0, isHorizontal and 0 or 1 - Multiplier, 0), TextColor3 = Color_2}, TweenInfo.new(MiscOptions.Healthbar_Easing_Speed, Enum.EasingStyle[MiscOptions.Healthbar_EasingStyle], Enum.EasingDirection[MiscOptions.Healthbar_EasingDirection], 0, false, 0))
                    
                    task.spawn(function()
                        local Start = tick()
                        
                        while true do
                            if not Esp then 
                                break 
                            end 

                            local Elapsed = tick() - Start
                            local Alpha = math.clamp(Elapsed, 0, 1)

                            local Value = Esp:Lerp(
                                Data.Info.Health, 
                                Value, 
                                TweenService:GetValue(
                                    Alpha, 
                                    Enum.EasingStyle[MiscOptions.Healthbar_EasingStyle], 
                                    Enum.EasingDirection[MiscOptions.Healthbar_EasingDirection]
                                )
                            )   

                            Items.HealthbarText.Text = math.floor(Value)

                            if Elapsed >= MiscOptions.Healthbar_Easing_Speed then 
                                Data.Info.Health = Value 
                                break
                            end

                            task.wait()
                        end                            
                    end)
                else 
                    Items.HealthbarAccent.Size = dim2(isHorizontal and Multiplier or 1, -2, isHorizontal and 1 or Multiplier, -2)
                    Items.HealthbarAccent.Position = dim2(0, 1, isHorizontal and 0 or 1 - Multiplier, 1)
                    Items.HealthbarText.Text = math.floor(Value)
                    Items.HealthbarText.Position = dim2(0, 0, isHorizontal and 0 or 1 - Multiplier, 0)
                    Items.HealthbarText.TextColor3 = Color_2
                end 
            end

            Data.RefreshDescendants = function() 
                local Character = (typechar and player) or player.Character or player.CharacterAdded:Wait()
                local Humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild( "Humanoid" )
                
                Data.Info.Character = typechar and player or Character
                Data.Info.Humanoid = Humanoid
                Data.Info.rootpart = Humanoid.RootPart

                Esp:Connection(Humanoid.HealthChanged, Data.HealthChanged)
                Esp:Connection(Character.ChildAdded, Data.ToolAdded)
                Esp:Connection(Character.ChildRemoved, Data.ToolAdded)

                Data.HealthChanged(Data.Info.Humanoid.Health)
            end 

            Data.Destroy = function()
                if Items["Holder"] then 
                    Items["Holder"].Parent = nil
                    Items["Holder"]:Destroy()
                end 

                if Esp.Players[index] then 
                    Esp.Players[index] = nil
                end 
            end 

            Data.RefreshDescendants()
            Esp:Connection(Data.Info.Character.ChildAdded, Data.ToolAdded)
            Esp:Connection(player.CharacterAdded, Data.RefreshDescendants)
            
            -- Recaching element holders that arent neccessary <- roblox calculates math for them even if they have no objects in them or invisible ;(
            for _,ItemParentor in {Items.Left, Items.Right, Items.Top, Items.Bottom} do  
                Esp:Connection(ItemParentor.ChildAdded, function()
                    task.wait(.1)

                    if ItemParentor.Parent == nil then 
                        return 
                    end
                    
                    ItemParentor.Parent = Items.Holder
                end)    

                Esp:Connection(ItemParentor.ChildRemoved, function()
                    task.wait(.1)
                    if #ItemParentor:GetChildren() == 0 then
                        if ItemParentor.Parent == nil then 
                            return 
                        end 

                        ItemParentor.Parent = Esp.Cache
                    end 
                end)
            end     

            for _,HealthHolder in {"Right", "Left"} do
                local Parent = Items["HealthbarTexts" .. HealthHolder]

                Esp:Connection(Parent.ChildAdded, function()
                    task.wait(.1)

                    if Parent.Parent == nil then 
                        return 
                    end

                    Parent.Parent = Items[HealthHolder]
                end)    

                Esp:Connection(Parent.ChildRemoved, function()
                    task.wait(.1)
                    if #Parent:GetChildren() == 0 then
                        if Parent.Parent == nil then 
                            return 
                        end 

                        Parent.Parent = Esp.Cache
                    end 
                end)
            end 

            Esp.Players[ player.Name ] = Data

            return Data
        end

        function Esp.Update() -- IMPORTANT! 
            if not Esp then 
                return 
            end 

            if Options.Enabled == false then
                return 
            end 

            for _,Data in Esp.Players do
                if not Data.Info then
                    continue 
                end 
            
                local Character = Data.Info.Character

                if not Character then 
                    continue 
                end 

                local Humanoid = Data.Info.Humanoid 

                if not Humanoid then
                    continue 
                end 

                if not (Character or Humanoid) then 
                    continue 
                end 
                
                local Items = Data and Data.Items 

                if not Items then 
                    continue 
                end 

                local BoxSize, BoxPos, OnScreen, Distance = Esp:BoxSolve(Humanoid.RootPart)
                local Holder = Items["Holder"]

                if Holder.Visible ~= OnScreen then 
                    Holder.Visible = OnScreen
                end 

                if not OnScreen then
                    continue
                end 

                local Pos = dim_offset(BoxPos.X, BoxPos.Y)
                if Pos ~= Holder.Position then 
                    Holder.Position = Pos
                end 
                
                local Size = dim2(0, BoxSize.X, 0, BoxSize.Y)
                if Size ~= Holder.Size then 
                    Holder.Size = Size
                end 

                local DistanceLabel = Items.Distance
                local Text = tostring( math.round(Distance) )  .. "m"
                if DistanceLabel.Text ~= Text then 
                    DistanceLabel.Text = Text
                end 
                
                -- if Options["Box Fill"] and Options["Box Spin"] then 
                --     Items["Holder_gradient"].Rotation += Options["Box Spin Speed"] / 100
                -- end

                -- if Options["Box Gradient"] and Options["Box Gradient Spin"] then 
                --     Items["box_outline_gradient"].Rotation += Options["Box Gradient Spin Speed"] / 100
                -- end
            end
        end 
        
        function Esp.RefreshElements(key, value) -- IMPORTANT!
            for _,Data in Esp.Players do
                local Items = Data and Data.Items 

                -- These checks are so annoying
                if not Items then 
                    continue  
                end 

                if not Items.Holder then 
                    continue 
                end 

                if Items.Holder.Parent == nil then 
                    continue 
                end 

                if key == "Enabled" then
                    Items.Holder.Visible = value
                end 

                -- Boxes
                    if key == "BoxType" then
                        if not (Items.Box.Parent == Items.Holder or Items.Corners.Parent == Items.Holder) then 
                            continue
                        end 

                        local isCorner = value == "Corner"
                        Items.Box.Parent = isCorner and Esp.Cache or Items.Holder
                        Items.Corners.Parent = isCorner and Items.Holder or Esp.Cache
                    end 

                    if key == "Boxes" then 
                        local isCorner = Items.Corners.Parent == Items.Holder and true or false
                        local Enabled = value and Items.Holder or Esp.Cache

                        if isCorner then 
                            Items.Corners.Parent = Enabled
                        else 
                            Items.Box.Parent = Enabled
                        end
                    end 

                    if key == "Box Gradient 1" then 
                        local Color = rgbseq{
                            Items.BoxGradient.Color.Keypoints[1], 
                            rgbkey(1, value.Color)
                        }

                        for _,corner in Items.Corners:GetChildren() do 
                            corner:FindFirstChildOfClass("UIGradient").Color = Color
                        end     

                        Items.BoxGradient.Color = Color
                    end 
                    
                    if key == "Box Gradient 2" then 
                        local Color = rgbseq{
                            rgbkey(0, value.Color), 
                            Items.BoxGradient.Color.Keypoints[2]
                        }
                        
                        for _,corner in Items.Corners:GetChildren() do 
                            corner:FindFirstChildOfClass("UIGradient").Color = Color
                        end

                        Items.BoxGradient.Color = Color
                    end 

                    if key == "Box Gradient Rotation" then 
                        Items.BoxGradient.Rotation = value
                    end 

                    if key == "Box Fill" then 
                        Items.Holder.BackgroundTransparency = value and 0 or 1
                    end

                    if key == "Box Fill 1" then 
                        local Path = Items.HolderGradient
                        Path.Transparency = numseq{
                            numkey(0, 1 - value.Transparency), 
                            Path.Transparency.Keypoints[2]
                        };

                        Path.Color = rgbseq{
                            rgbkey(0, value.Color), 
                            Path.Color.Keypoints[2]
                        }
                    end 

                    if key == "Box Fill 2" then 
                        local Path = Items.HolderGradient
                        Path.Transparency = numseq{
                            Path.Transparency.Keypoints[1],
                            numkey(1, 1 - value.Transparency)
                        };

                        Path.Color = rgbseq{
                            Path.Color.Keypoints[1],
                            rgbkey(1, value.Color)
                        };
                    end 

                    if key == "Box Fill Rotation" then 
                        Items.HolderGradient.Rotation = value
                    end 
                -- 

                -- Bars 
                    if key == "Healthbar" then 
                        if Items.Healthbar.Parent == nil then 
                            continue
                        end 

                        Items.Healthbar.Parent = value and Items[Items.Healthbar.Name] or Esp.Cache  
                        Items.HealthbarText.Parent = (Items.HealthbarText.Parent ~= Esp.Cache and value) and Items["HealthbarTexts" .. Items.Healthbar.Name] or Esp.Cache  
                    end 

                    if key == "Healthbar_Position" then 
                        local isEnabled = not (Items.Healthbar.Parent == Esp.Cache)

                        if Items.Healthbar.Parent == nil then 
                            return 
                        end 

                        Items.Healthbar.Parent = isEnabled and Items[value] or Esp.Cache
                        Items.Healthbar.Name = value -- This is super gay
                        Items.HealthbarText.Parent = isEnabled and value and Items.HealthbarText.Parent ~= Esp.Cache and Items["HealthbarTexts" .. Items.Healthbar.Name] or Esp.Cache

                        if value == "Bottom" or value == "Top" then 
                            Items.HealthbarGradient.Rotation = 0 
                        else 
                            Items.HealthbarGradient.Rotation = 90
                        end 

                        Data.HealthChanged(Data.Info.Humanoid.Health)
                    end 
                    
                    if key == "Healthbar_Number" then  
                        if Items.Healthbar.Parent == Esp.Cache then 
                            continue
                        end 

                        local Parent = Items["HealthbarTexts" .. Items.Healthbar.Name]
                        
                        Items.HealthbarText.Parent = value and Parent or Esp.Cache
                    end

                    if key == "Healthbar_Low" then 
                        local Color = rgbseq{
                            Items.HealthbarGradient.Color.Keypoints[1], 
                            Items.HealthbarGradient.Color.Keypoints[2], 
                            rgbkey(1, value.Color)
                        }

                        Items.HealthbarGradient.Color = Color
                    end 

                    if key == "Healthbar_Medium" then 
                        local Color = rgbseq{
                            Items.HealthbarGradient.Color.Keypoints[1], 
                            rgbkey(0.5, value.Color), 
                            Items.HealthbarGradient.Color.Keypoints[3]
                        }

                        Items.HealthbarGradient.Color = Color
                    end

                    if key == "Healthbar_High" then 
                        local Color = rgbseq{
                            rgbkey(0, value.Color), 
                            Items.HealthbarGradient.Color.Keypoints[2], 
                            Items.HealthbarGradient.Color.Keypoints[3]
                        }

                        Items.HealthbarGradient.Color = Color
                    end

                    if key == "Healthbar_Thickness" then 
                        local Bar = Items.Healthbar
                        local isHorizontal = Bar.Parent == Items.Bottom or Bar.Parent == Items.Top

                        Bar.Size = dim2(0, value + 2, 0, value + 2)
                    end

                    if key == "Healthbar_Text_Size" then 
                        Items.HealthbarText.TextSize = value
                    end

                    if key == "Healthbar_Font" then 
                        Items.HealthbarText.FontFace = Fonts[value]
                    end
                -- 
                
                -- Texts
                    local Text;
                    local Match;
                    if string.match(key, "Name") then 
                        Text = Items.Text
                        Match = "Name"
                    elseif string.match(key, "Distance") then 
                        Text = Items.Distance
                        Match = "Distance"
                    end 

                    if Text then 
                        if key == Match .. "_Text" then  
                            if Text.Parent == nil then 
                                continue
                            end

                            Text.Parent = value and Items[Text.Name .. "Texts"] or Esp.Cache
                        end 

                        if key == Match .. "_Text_Position" then 
                            local isEnabled = not (Text.Parent == Esp.Cache)

                            if Text.Parent == nil then 
                                return 
                            end 

                            Text.Parent = isEnabled and Items[value .. "Texts"] or Esp.Cache
                            Text.Name = tostring(value) -- This is super gay

                            if value == "Top" or value == "Bottom" then 
                                Text.AutomaticSize = Enum.AutomaticSize.Y 
                                Text.TextXAlignment = Enum.TextXAlignment.Center
                            else 
                                Text.AutomaticSize = Enum.AutomaticSize.XY 
                                Text.TextXAlignment = Enum.TextXAlignment[value == "Right" and "Left" or "Right"]
                            end     
                        end 

                        if key == Match .. "_Text_Color" then 
                            Text.TextColor3 = value.Color
                        end 

                        if key == Match .. "_Text_Font" then 
                            Text.FontFace = Fonts[value]
                        end 

                        if key == Match .. "_Text_Size" then 
                            Text.TextSize = value
                        end
                    end 
                -- 
            end 
        end; 
        
        function Esp.Unload() 
            for _,player in Players:GetPlayers() do 
                Esp.RemovePlayer(player)
            end

            for _,connection in Esp.Connections do 
                connection:Disconnect() 
                connection = nil
            end 
            
            if Esp.Loop then 
                RunService:UnbindFromRenderStep("Run Loop")
                Esp.Loop = nil
            end 

            Esp.Cache:Destroy() 
            Esp.ScreenGui:Destroy()

            getgenv().Esp = nil
        end 

        function Esp.RemovePlayer(player)
            local Path = Esp.Players[player.Name]
            
            if Path then
                Path.Destroy()
            end
        end 
    end

    for _,player in Players:GetPlayers() do 
        if player == Players.LocalPlayer then continue end
        Esp.CreateObject(player)
    end 

    Esp:Connection(Players.PlayerRemoving, Esp.RemovePlayer)
    Esp:Connection(Players.PlayerAdded, function(player)
        Esp.CreateObject(player)
        for index,value in MiscOptions do 
            Options[index] = value -- gotta trigger that new index
        end 
    end)

    Esp.Loop = RunService:BindToRenderStep("Run Loop", 0, Esp.Update)

    for index,value in MiscOptions do 
        Options[index] = value -- gotta trigger that new index
    end
end

-- beware of somewhat horrible code
local Library do
    -- Services
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local SoundService = cloneref and cloneref(game:GetService("SoundService")) or game:GetService("SoundService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")

    -- Variables
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    -- Globals
    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new

    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromScale = UDim2.fromScale
    local Vector2New = Vector2.new

    local InstanceNew = Instance.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin
    local MathRad = math.rad
    local MathMax = math.max
    local MathMin = math.min

    local TableInsert = table.insert
    local TableFind = table.find
    local TableUnpack = table.unpack
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower

    local CFrameNew = CFrame.new
    local CFrameAngles = CFrame.Angles
    local Vector3New = Vector3.new

    local RectNew = Rect.new

    local IsMobile = UserInputService.TouchEnabled or false

    gethui = gethui or function()
        return CoreGui
    end

    getgenv().Options = { }

    -- Library
    Library = {
        Theme = nil,

        MenuKeybind = tostring(Enum.KeyCode.Z), 
        Flags = { },

        Tween = {
            Time = 0.3,
            Style = Enum.EasingStyle.Cubic,
            Direction = Enum.EasingDirection.Out
        },

        Folders = {
            Directory = "kiwisense",
            Configs = "kiwisense/Configs",
            Assets = "kiwisense/Assets",
            Themes = "kiwisense/Themes"
        },

        Images = { -- you're welcome to reupload the images and replace it with your own links
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

        Themes = { },
        ThemeMap = { },
        ThemeItems = { },
        ThemeColorpickers = { },

        OpenFrames = { },

        CurrentPage = nil,

        SearchItems = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        MainFrame = nil,
        Font = nil,
        KeyList = nil,
    }

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

    Library.__index = Library

    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    for Index, Value in Library.Images do 
        local ImageData = Value

        local ImageName = ImageData[1]
        local ImageLink = ImageData[2]
        
        if not isfile(Library.Folders.Assets .. "/" .. ImageName) then
            writefile(Library.Folders.Assets .. "/" .. ImageName, game:HttpGet(ImageLink))
        end
    end

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

            if Event == "MouseButton1Down" or Event == "MouseButton1Click" then 
                if IsMobile then 
                    Event = "TouchTap"
                end
            elseif Event == "MouseButton2Down" or Event == "MouseButton2Click" then 
                if IsMobile then
                    Event = "TouchLongPress"
                end
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

        Instances.Tooltip = function(self, Text)
            if Text == nil or type(Text) ~= "string" then
                return
            end

            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local MouseLocation = UserInputService:GetMouseLocation()
            local RenderStepped

            local Newtooltip = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, MouseLocation.X, 0, MouseLocation.Y - 38),
                BorderSizePixel = 0,
                ZIndex = 2,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(16, 18, 21)
            })  Newtooltip:AddToTheme({BackgroundColor3 = "Background"})

            local UIStroke = Instances:Create("UIStroke", {
                Parent = Newtooltip.Instance,
                Name = "\0",
                Color = FromRGB(32, 36, 42),
                Transparency = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  UIStroke:AddToTheme({Color = "Border"})

            Instances:Create("UIPadding", {
                Parent = Newtooltip.Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 5),
                PaddingBottom = UDimNew(0, 5),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            })

            local TooltipText = Instances:Create("TextLabel", {
                Parent = Newtooltip.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Text,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 2,
                TextTransparency = 1,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UICorner", {
                Parent = Newtooltip.Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })

            Library:Connect(Gui.MouseEnter, function()
                Newtooltip:Tween(nil, {BackgroundTransparency = 0.15})
                TooltipText:Tween(nil, {TextTransparency = 0})
                UIStroke:Tween(nil, {Transparency = 0.4})

                RenderStepped = RunService.RenderStepped:Connect(function()
                    MouseLocation = UserInputService:GetMouseLocation()
                    Newtooltip:Tween(nil, {Position = UDim2New(0, MouseLocation.X, 0, MouseLocation.Y - 38)})
                end)
            end)

            Library:Connect(Gui.MouseLeave, function()
                Newtooltip:Tween(nil, {BackgroundTransparency = 1})
                TooltipText:Tween(nil, {TextTransparency = 1})
                UIStroke:Tween(nil, {Transparency = 1})

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end)
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            local InputChanged

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
            end

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false

                            InputChanged:Disconnect()
                            InputChanged = nil
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
                Image = "rbxassetid://7368471234",
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 9, 0, 9),
				Position = UDim2New(1, -4, 1, -4),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
                ZIndex = 5,
				AutoButtonColor = false,
                Visible = true,
			})  ResizeButton:AddToTheme({ImageColor3 = "Accent"})

            local InputChanged

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then

                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Resizing = false

                            InputChanged:Disconnect()
                            InputChanged = nil
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

        CustomFont:New("Inter", 200, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf"
        })

        Library.Font = CustomFont:Get("Inter")
    end

    local Themes = {
        ["Preset"] = {
            ["Background"] = FromRGB(16, 18, 21),
            ["Inline"] = FromRGB(22, 25, 29),
            ["Shadow"] = FromRGB(0, 0, 0),
            ["Text"] = FromRGB(255, 255, 255),
            ["Image"] = FromRGB(255, 255, 255),
            ["Dark Gradient"] = FromRGB(211, 211, 211),
            ["Inactive Text"] = FromRGB(185, 185, 185),
            ["Element"] = FromRGB(34, 39, 45),
            ["Accent"] = FromRGB(196, 231, 255),
            ["Border"] = FromRGB(32, 36, 42)
        },

        ["Halloween"] = {
            ["Background"] = FromRGB(11, 10, 9),
            ["Inline"] = FromRGB(23, 18, 16),
            ["Shadow"] = FromRGB(253, 133, 21),
            ["Text"] = FromRGB(198, 198, 198),
            ["Image"] = FromRGB(201, 201, 201),
            ["Dark Gradient"] = FromRGB(211, 202, 195),
            ["Inactive Text"] = FromRGB(179, 179, 179),
            ["Element"] = FromRGB(42, 32, 26),
            ["Accent"] = FromRGB(253, 133, 21),
            ["Border"] = FromRGB(42, 35, 32)
        },

        ["Aqua"] = {
            ["Background"] = FromRGB(19, 21, 23),
            ["Inline"] = FromRGB(31, 35, 39),
            ["Shadow"] = FromRGB(0, 0, 0),
            ["Text"] = FromRGB(245, 245, 245),
            ["Image"] = FromRGB(255, 255, 255),
            ["Dark Gradient"] = FromRGB(211, 211, 211),
            ["Inactive Text"] = FromRGB(185, 185, 185),
            ["Element"] = FromRGB(58, 66, 77),
            ["Accent"] = FromRGB(31, 106, 181),
            ["Border"] = FromRGB(48, 56, 63)
        },

        ["One Tap"] = {
            ["Background"] = FromRGB(51, 51, 51),
            ["Inline"] = FromRGB(30, 30, 30),
            ["Shadow"] = FromRGB(0, 0, 0),
            ["Text"] = FromRGB(245, 245, 245),
            ["Image"] = FromRGB(255, 255, 255),
            ["Dark Gradient"] = FromRGB(211, 211, 211),
            ["Inactive Text"] = FromRGB(185, 185, 185),
            ["Element"] = FromRGB(45, 45, 45),
            ["Accent"] = FromRGB(237, 170, 0),
            ["Border"] = FromRGB(0, 0, 0)
        },
    }

    Library.Theme = TableClone(Themes["Preset"])
    Library.Themes = Themes

    if not isfile(Library.Folders.Directory .. "/AutoLoadConfig (do not modify this).json") then
        writefile(Library.Folders.Directory .. "/AutoLoadConfig (do not modify this).json", "")
    end

    if not isfile(Library.Folders.Directory .. "/AutoLoadTheme (do not modify this).json") then
        writefile(Library.Folders.Directory .. "/AutoLoadTheme (do not modify this).json", "")
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = game:GetService("CoreGui"),
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

    Instances:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        PaddingBottom = UDimNew(0, 15),
        PaddingTop = UDimNew(0, 15),
        PaddingRight = UDimNew(0, 15)
    })

    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDimNew(0, 10)
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

        UserInputService.MouseIconEnabled = true
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
            --Library:Notification("Error caught in function, report this to the devs:\n"..Result, 5, FromRGB(255, 0, 0))
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
        return StringFormat("Flag Number %s %s", FlagNumber, HttpService:GenerateGUID(false))
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

    Library.GetDarkerColor = function(self, Color)
        local Hue, Saturation, Value = Color:ToHSV()
        return FromHSV(Hue, Saturation, Value / 1.35)
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
            Library:Notification({
                Name = "Success",
                Description = "Succesfully deleted config: ".. Config .. ".json",
                Duration = 5,
                Icon = "116339777575852",
                IconColor = FromRGB(52, 255, 164)
            })
        end
    end

    Library.SaveConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config .. ".json") then
            writefile(Library.Folders.Configs .. "/" .. Config .. ".json", Library:GetConfig())
            Library:Notification({
                Name = "Success",
                Description = "Succesfully saved config: ".. Config .. ".json",
                Duration = 5,
                Icon = "116339777575852",
                IconColor = FromRGB(52, 255, 164)
            })
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
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
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

    Library.GetTheme = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Color and StringFind(Index, "Theme") then
                    Config[Index] = {Color = "#" .. Value.Color, Alpha = Value.Alpha}
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadTheme = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Color and StringFind(Index, "Theme") then
                    SetFunction(Value.Color, Value.Alpha)
                end
            end
        end)

        return Success, Result
    end

    Library.DeleteTheme = function(self, Config)
        if isfile(Library.Folders.Themes .. "/" .. Config) then 
            delfile(Library.Folders.Themes .. "/" .. Config)
            Library:Notification({
                Name = "Success",
                Description = "Succesfully deleted config: ".. Config .. ".json",
                Duration = 5,
                Icon = "116339777575852",
                IconColor = FromRGB(52, 255, 164)
            })
        end
    end

    Library.SaveTheme = function(self, Config)
        if isfile(Library.Folders.Themes .. "/" .. Config .. ".json") then
            writefile(Library.Folders.Themes .. "/" .. Config .. ".json", Library:GetTheme())
            Library:Notification({
                Name = "Success",
                Description = "Succesfully saved config: ".. Config .. ".json",
                Duration = 5,
                Icon = "116339777575852",
                IconColor = FromRGB(52, 255, 164)
            })
        end
    end

    Library.RefreshThemesList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(Library.Folders.Themes, Library.Folders.Directory .. "/", "")

        for Index, Value in listfiles(Library.Folders.Themes) do
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

    Library.GetLighterColor = function(self, Color, Increment)
        local Hue, Saturation, Value = Color:ToHSV()
        return FromHSV(Hue, Saturation, Value * Increment)
    end

    local Components = { } do
        Components.Toggle = function(Data)
            local Toggle = { 
                Value = false,
                Flag = Data.Flag
            }

            local Items = { } do
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 20),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = Data.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    Size = UDim2New(0, 20, 0, 20),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(34, 39, 45)
                })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element"})

                Instances:Create("UICorner", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -4, 1, -4),
                    Position = UDim2New(0, 2, 0, 2),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(34, 39, 45)
                })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Element"})

                Instances:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Items["Check"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Visible = true,
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://116339777575852",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ImageTransparency = 1,
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    ImageColor3 = FromRGB(0, 0, 0)
                })

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -24, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Toggle:Get()
                return Toggle.Value
            end

            function Toggle:Set(Bool)
                Toggle.Value = Bool 
                Library.Flags[Toggle.Flag] = Bool

                if Bool then
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Inline"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                    Items["Inline"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

                    Items["Check"]:Tween(nil, {ImageTransparency = 0})
                    Items["Text"]:Tween(nil, {TextTransparency = 0})
                else
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                    Items["Inline"]:ChangeItemTheme({BackgroundColor3 = "Element"})

                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                    Items["Inline"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})

                    Items["Check"]:Tween(nil, {ImageTransparency = 1})
                    Items["Text"]:Tween(nil, {TextTransparency = 0.5})
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Bool)
                end
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool
            end

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then return end
                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.45)})
                Items["Inline"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.45)})
            end)

            Items["Toggle"]:OnHoverLeave(function()
                if Toggle.Value then return end
                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                Items["Inline"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)

            getgenv().Options[Toggle.Flag] = Toggle

            local SearchData = {
                Name = Data.Name,
                Item = Items["Toggle"]
            }

            local PageSearchData = Library.SearchItems[Data.Page]

            if not PageSearchData then 
                return 
            end

            TableInsert(PageSearchData, SearchData)

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            if Data.Default then 
                Toggle:Set(Data.Default)
            end

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle, Items 
        end

        Components.Dropdown = function(Data)
            local Dropdown = {
                Value = { },
                Flag = Data.Flag,
                Type = "Dropdown",
                Name = Data.Name,
                IsOpen = false,
                Options = { }
            }

            local Items = { } do
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 47),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    Text = "", 
                    AutoButtonColor = false,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 25),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(34, 39, 45)
                })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})

                Instances:Create("UIGradient", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Instances:Create("UICorner", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "--",
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 8, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

                Items["OpenIcon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(196, 231, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 20, 0, 20),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://114252321536924",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -3, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["OpenIcon"]:AddToTheme({ImageColor3 = "Accent"})

                Items["OptionHolder"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 0, 125),
                    AutomaticSize = Enum.AutomaticSize.None,
                    Position = UDim2New(0, 0, 0, 0),
                    Visible = false,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UIGradient", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Instances:Create("UIStroke", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Color = FromRGB(32, 36, 42),
                    Transparency = 0.4000000059604645,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UICorner", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["Holder"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 2,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -8, 1, -46),
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 38),
                    BorderSizePixel = 0,
                    ScrollBarImageColor3 = Library.Theme.Border,
                    BottomImage = "rbxassetid://123813291349824",
                    TopImage = "rbxassetid://123813291349824",
                    MidImage = "rbxassetid://123813291349824",
                    ZIndex = 5,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Holder"]:AddToTheme({ScrollBarImageColor3 = "Border"})

                Instances:Create("UIListLayout", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["Search"] = Instances:Create("Frame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -16, 0, 25),
                    Position = UDim2New(0, 8, 0, 8),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 5,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                })  Items["Search"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UIGradient", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Instances:Create("UICorner", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    Color = FromRGB(32, 36, 42),
                    Transparency = 0.4000000059604645,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["SearchIcon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 0.5,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 20, 0, 20),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://71924825350727",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    ZIndex = 5,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["SearchIcon"]:AddToTheme({ImageColor3 = "Image"})

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    AnchorPoint = Vector2New(0, 0.5),
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    PlaceholderText = "search",
                    TextSize = 14,
                    Size = UDim2New(1, -45, 0, 15),
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    ZIndex = 5,
                    Position = UDim2New(0, 35, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = FromRGB(255, 255, 255),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
            end

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.45)})
            end)

            Items["RealDropdown"]:OnHoverLeave(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:Set(Option)
                if Data.Multi then
                    if type(Option) ~= "table" then
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do 
                        local OptionData = Dropdown.Options[Value]
                        
                        if not OptionData then 
                            return
                        end

                        OptionData.Selected = true
                        OptionData:Toggle("Active")
                    end

                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then 
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = OptionData.Name
                    Library.Flags[Dropdown.Flag] = OptionData.Name

                    for Index, Value in Dropdown.Options do 
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = OptionData.Name
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Dropdown.Value)
                end
            end

            function Dropdown:AddOption(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, -5, 0, 25),
                    ZIndex = 5,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  OptionButton:AddToTheme({BackgroundColor3 = "Background"})

                local CheckImage = Instances:Create("ImageLabel", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(196, 231, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 18, 0, 18),
                    Visible = true,
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://116339777575852",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 3, 0.5, 0),
                    ImageTransparency = 1,
                    ZIndex = 5,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  CheckImage:AddToTheme({ImageColor3 = "Accent"})

                Instances:Create("UICorner", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                local OptionText = Instances:Create("TextLabel", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextTransparency = 0.5,
                    AnchorPoint = Vector2New(0, 0.5),
                    ZIndex = 5,
                    TextSize = 14,
                    Size = UDim2New(0, 0, 0, 15),
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Option,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Position = UDim2New(0, 7, 0.5, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  OptionText:AddToTheme({TextColor3 = "Text"})

                local OptionData = {
                    Selected = false,
                    Name = Option,
                    Text = OptionText,
                    RealName = Option,
                    Button = OptionButton,
                    Check = CheckImage
                }

                local DoesItAlreadyExists

                local ChildrenCount = 0
                
                for Index, Value in Items["Holder"].Instance:GetChildren() do
                    if Value:IsA("TextButton") then
                        ChildrenCount = ChildrenCount + 1
                    end
                end

                if Dropdown.Options[Option] then 
                    DoesItAlreadyExists = true
                    local NewName = Option .. " " .. ChildrenCount
                    OptionData.Name = NewName
                    --OptionText.Instance.Text = NewName
                end

                function OptionData:Toggle(Status)
                    if Status == "Active" then 
                        OptionData.Button:Tween(nil, {BackgroundTransparency = 0})
                        OptionData.Text:Tween(nil, {TextTransparency = 0, Position = UDim2New(0, 27, 0.5, 0)})
                        OptionData.Check:Tween(nil, {ImageTransparency = 0})
                    elseif Status == "Inactive" then
                        OptionData.Button:Tween(nil, {BackgroundTransparency = 1})
                        OptionData.Text:Tween(nil, {TextTransparency = 0.5, Position = UDim2New(0, 7, 0.5, 0)})
                        OptionData.Check:Tween(nil, {ImageTransparency = 1})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Data.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.RealName)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.RealName)
                        end

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"

                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.RealName
                            Library.Flags[Dropdown.Flag] = OptionData.RealName

                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.RealName 
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData:Toggle("Inactive")
                            Items["Value"].Instance.Text = "--"
                        end
                    end

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:RemoveOption(Name)
                if Dropdown.Options[Name] then
                    Dropdown.Options[Name].Button:Clean()
                    Dropdown.Options[Name] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:RemoveOption(Value.Name)
                end

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

                Dropdown.IsOpen = Bool
                Items["OptionHolder"].Instance.Parent = Bool and Library.Holder.Instance or Library.UnusedHolder.Instance

                Debounce = true

                if Bool then 
                    Items["OptionHolder"].Instance.Visible = true
                    Items["Holder"].Instance.ZIndex = 11

                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["OptionHolder"].Instance.Position = UDim2New(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y + 30)
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, Data.MaxSize or 165)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value.Name ~= Data.Name then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Data.Name] = Dropdown
                else
                    if Library.OpenFrames[Data.Name] then 
                        Library.OpenFrames[Data.Name] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["OptionHolder"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then 
                        continue
                    end

                    if StringFind(Value.ClassName, "UI") then
                        continue
                    end

                    Value.ZIndex = Bool and 10 or 0

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Data.Window.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Data.Window.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    Items["OptionHolder"].Instance.Visible = Bool
                end)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            getgenv().Options[Dropdown.Flag] = Dropdown

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                        return
                    end

                    if Debounce then 
                        return 
                    end

                    if not Dropdown.IsOpen then
                        return
                    end

                    Dropdown:SetOpen(false)
                end
            end)

            local SearchStepped

            Items["Input"]:Connect("Focused", function()
                if SearchStepped then
                    return
                end

                SearchStepped = RunService.RenderStepped:Connect(function()
                    for Index, Value in Dropdown.Options do 
                        if StringFind(Value.Name:lower(), Items["Input"].Instance.Text:lower()) then 
                            Value.Button.Instance.Visible = true
                        else
                            Value.Button.Instance.Visible = false
                        end
                    end
                end)
            end)

            Items["Input"]:Connect("FocusLost", function()
                if SearchStepped then
                    SearchStepped:Disconnect()
                    SearchStepped = nil
                end
            end)

            local SearchData = {
                Name = Data.Name,
                Item = Items["Dropdown"]
            }

            local PageSearchData = Library.SearchItems[Data.Page]

            if not PageSearchData then 
                return 
            end

            TableInsert(PageSearchData, SearchData)

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            for Index, Value in Data.Items do 
                Dropdown:AddOption(Value)
            end

            if Data.Default then 
                Dropdown:Set(Data.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown, Items
        end

        Components.Colorpicker = function(Data)
            local Colorpicker = {
                IsOpen = false,
                
                Color = FromRGB(0, 0, 0),
                HexValue = "000000",
                Alpha = 0,

                Name = Data.Name,
                Type = "Colorpicker",

                Hue = 0,
                Saturation = 0,
                Value = 0,
            }

            local AnimationsDropdown 
            local AnimationsDropdownItems

            Library.Flags[Data.Flag] = { }

            local Items = { } do
                Items["ColorpickerButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    BorderSizePixel = 0,
                    Position = UDim2New(1, -25, 0, 0),
                    Size = UDim2New(0, 20, 0, 20),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 125, 32)
                })

                local CalculateCount = function(Index)
                    local MaxButtonsAdded = 5

                    local Column = Index % MaxButtonsAdded
                
                    local ButtonSize = Items["ColorpickerButton"].Instance.AbsoluteSize
                    local Spacing = 4
                
                    local XPosition = (ButtonSize.X + Spacing) * Column - Spacing - ButtonSize.X
                
                    Items["ColorpickerButton"].Instance.Position = UDim2New(1, Data.IsToggle and XPosition - 24 or -XPosition, 0.5, 0)
                end

                CalculateCount(Data.Count)

                Instances:Create("UICorner", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -4, 1, -4),
                    Position = UDim2New(0, 2, 0, 2),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 125, 32)
                })

                Instances:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Active = false,
                    Selectable = false,
                    Size = UDim2New(0, 219, 0, 282),
                    Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + 25),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    Visible = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["ColorpickerWindow"]:MakeDraggable()
                Items["ColorpickerWindow"]:MakeResizeable(Vector2New(219, 282), Vector2New(9999, 9999))

                Instances:Create("UIStroke", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    Color = FromRGB(32, 36, 42),
                    Transparency = 0.4000000059604645,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UICorner", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["Shadow"] = Instances:Create("ImageLabel", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(0, 0, 0),
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.8999999761581421,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                })  Items["Shadow"]:AddToTheme({ImageColor3 = "Shadow"})

                Items["Palette"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(1, -16, 1, -125),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 125, 32)
                })

                Instances:Create("UICorner", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
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

                Instances:Create("UICorner", {
                    Parent = Items["Saturation"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["Value"] = Instances:Create("ImageLabel", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 2, 1, 0),
                    Image = Library:GetImage("Value"),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, -1, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UICorner", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["PaletteDragger"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 4, 0, 4),
                    Position = UDim2New(0, 5, 0, 5),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UICorner", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    Thickness = 1.2000000476837158,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["Hue"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -16, 0, 18),
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 8, 1, -90),
                    Text = "",
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UICorner", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Hue"].Instance,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
                }) 

                Items["HueDragger"] = Instances:Create("Frame", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 12, 0.5, 0),
                    Size = UDim2New(0, 3, 1, -8),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0",
                    Thickness = 1.2000000476837158,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Instances:Create("UICorner", {
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Alpha"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    AutoButtonColor = false,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AnchorPoint = Vector2New(0, 1),
                    BorderSizePixel = 0,
                    Position = UDim2New(0, 8, 1, -63),
                    Size = UDim2New(1, -16, 0, 18),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 125, 32)
                })

                Instances:Create("UICorner", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["AlphaDragger"] = Instances:Create("Frame", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 3, 0.5, 0),
                    Size = UDim2New(0, 3, 1, -8),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["AlphaDragger"].Instance,
                    Name = "\0",
                    Thickness = 1.2000000476837158,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Instances:Create("UICorner", {
                    Parent = Items["AlphaDragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

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
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
                })

                Instances:Create("UICorner", {
                    Parent = Items["Checkers"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                local DropdownItems = { } do
                    DropdownItems["Dropdown"] = Instances:Create("Frame", {
                        Parent = Items["ColorpickerWindow"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2New(0, 1),
                        Size = UDim2New(1, -16, 0, 47),
                        Position = UDim2New(0, 8, 1, -8),
                        BorderColor3 = FromRGB(0, 0, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    DropdownItems["Text"] = Instances:Create("TextLabel", {
                        Parent = DropdownItems["Dropdown"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "animations",
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 0, 0, 15),
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  DropdownItems["Text"]:AddToTheme({TextColor3 = "Text"})

                    DropdownItems["RealDropdown"] = Instances:Create("TextButton", {
                        Parent = DropdownItems["Dropdown"].Instance,
                        Text = "", 
                        AutoButtonColor = false,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0, 1),
                        Position = UDim2New(0, 0, 1, 0),
                        Size = UDim2New(1, 0, 0, 25),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(34, 39, 45)
                    })  DropdownItems["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})

                    Instances:Create("UIGradient", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        Rotation = 84,
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                    }):AddToTheme({Color = function()
                        return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                    end})

                    Instances:Create("UICorner", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 4)
                    })

                    DropdownItems["Value"] = Instances:Create("TextLabel", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "--",
                        AutomaticSize = Enum.AutomaticSize.X,
                        Size = UDim2New(0, 0, 0, 15),
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 8, 0.5, 0),
                        BackgroundTransparency = 1,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  DropdownItems["Value"]:AddToTheme({TextColor3 = "Text"})

                    DropdownItems["OpenIcon"] = Instances:Create("ImageLabel", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        ImageColor3 = FromRGB(196, 231, 255),
                        ScaleType = Enum.ScaleType.Fit,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(0, 20, 0, 20),
                        AnchorPoint = Vector2New(1, 0.5),
                        Image = "rbxassetid://114252321536924",
                        BackgroundTransparency = 1,
                        Position = UDim2New(1, -3, 0.5, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  DropdownItems["OpenIcon"]:AddToTheme({ImageColor3 = "Accent"})

                    DropdownItems["OptionHolder"] = Instances:Create("TextButton", {
                        Parent = DropdownItems["Dropdown"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        Visible = false,
                        AutoButtonColor = false,
                        Size = UDim2New(1, 0, 0, 50),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Position = UDim2New(0, 0, 1, 5),
                        BorderSizePixel = 0,
                        ZIndex = 5,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(22, 25, 29)
                    })  DropdownItems["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline"})

                    Instances:Create("UIGradient", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        Rotation = 84,
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                    }):AddToTheme({Color = function()
                        return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                    end})

                    Instances:Create("UIStroke", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        Color = FromRGB(32, 36, 42),
                        Transparency = 0.4000000059604645,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }):AddToTheme({Color = "Border"})

                    Instances:Create("UICorner", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 5)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 2),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    Instances:Create("UIPadding", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 8),
                        PaddingBottom = UDimNew(0, 8),
                        PaddingRight = UDimNew(0, 8),
                        PaddingLeft = UDimNew(0, 8)
                    })
                end

                local Dropdown = { 
                    IsOpen = false,
                    Value = { },
                    Options = { },
                    Flag = Data.Flag .. "AnimationDropdown",
                    Multi = true
                }

                function Dropdown:AddOption(Option)
                    local OptionButton = Instances:Create("TextButton", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = UDim2New(1, 0, 0, 25),
                        ZIndex = 5,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(16, 18, 21)
                    })  OptionButton:AddToTheme({BackgroundColor3 = "Background"})

                    local CheckImage = Instances:Create("ImageLabel", {
                        Parent = OptionButton.Instance,
                        Name = "\0",
                        ImageColor3 = FromRGB(196, 231, 255),
                        ScaleType = Enum.ScaleType.Fit,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(0, 18, 0, 18),
                        Visible = true,
                        AnchorPoint = Vector2New(0, 0.5),
                        Image = "rbxassetid://116339777575852",
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 3, 0.5, 0),
                        ImageTransparency = 1,
                        ZIndex = 5,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  CheckImage:AddToTheme({ImageColor3 = "Accent"})

                    Instances:Create("UICorner", {
                        Parent = OptionButton.Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 5)
                    })

                    local OptionText = Instances:Create("TextLabel", {
                        Parent = OptionButton.Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextTransparency = 0.5,
                        AnchorPoint = Vector2New(0, 0.5),
                        ZIndex = 5,
                        TextSize = 14,
                        Size = UDim2New(0, 0, 0, 15),
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = Option,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutomaticSize = Enum.AutomaticSize.X,
                        Position = UDim2New(0, 7, 0.5, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  OptionText:AddToTheme({TextColor3 = "Text"})

                    local OptionData = {
                        Selected = false,
                        Name = Option,
                        Text = OptionText,
                        Button = OptionButton,
                        Check = CheckImage
                    }

                    function OptionData:Toggle(Status)
                        if Status == "Active" then 
                            OptionData.Button:Tween(nil, {BackgroundTransparency = 0})
                            OptionData.Text:Tween(nil, {TextTransparency = 0, Position = UDim2New(0, 27, 0.5, 0)})
                            OptionData.Check:Tween(nil, {ImageTransparency = 0})
                        elseif Status == "Inactive" then
                            OptionData.Button:Tween(nil, {BackgroundTransparency = 1})
                            OptionData.Text:Tween(nil, {TextTransparency = 0.5, Position = UDim2New(0, 7, 0.5, 0)})
                            OptionData.Check:Tween(nil, {ImageTransparency = 1})
                        end
                    end

                    function OptionData:Set()
                        OptionData.Selected = not OptionData.Selected

                        if Dropdown.Multi then 
                            local Index = TableFind(Dropdown.Value, OptionData.Name)

                            if Index then 
                                TableRemove(Dropdown.Value, Index)
                            else
                                TableInsert(Dropdown.Value, OptionData.Name)
                            end

                            Library.Flags[Dropdown.Flag] = Dropdown.Value

                            OptionData:Toggle(Index and "Inactive" or "Active")

                            local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"

                            DropdownItems["Value"].Instance.Text = TextFormat
                        else
                            if OptionData.Selected then 
                                Dropdown.Value = OptionData.Name
                                Library.Flags[Dropdown.Flag] = OptionData.Name

                                OptionData:Toggle("Active")

                                for Index, Value in Dropdown.Options do 
                                    if Value ~= OptionData then
                                        Value.Selected = false 
                                        Value:Toggle("Inactive")
                                    end
                                end

                                DropdownItems["Value"].Instance.Text = OptionData.Name 
                            else
                                Dropdown.Value = nil
                                Library.Flags[Dropdown.Flag] = nil

                                OptionData:Toggle("Inactive")
                                DropdownItems["Value"].Instance.Text = "--"
                            end
                        end

                        if Dropdown.Callback then 
                            Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                        end
                    end

                    OptionData.Button:Connect("MouseButton1Down", function()
                        OptionData:Set()
                    end)

                    Dropdown.Options[Option] = OptionData
                    return OptionData
                end

                local Debounce = false 

                function Dropdown:SetOpen(Bool)
                    if Debounce then 
                        return 
                    end

                    Dropdown.IsOpen = Bool
                    DropdownItems["OptionHolder"].Instance.Parent = Bool and Library.Holder.Instance or Library.UnusedHolder.Instance

                    Debounce = true

                    if Bool then 
                        DropdownItems["OptionHolder"].Instance.Visible = true

                        RenderStepped = RunService.RenderStepped:Connect(function()
                            DropdownItems["OptionHolder"].Instance.Position = UDim2New(0, DropdownItems["RealDropdown"].Instance.AbsolutePosition.X, 0,  DropdownItems["RealDropdown"].Instance.AbsolutePosition.Y + DropdownItems["RealDropdown"].Instance.AbsoluteSize.Y + 5)
                            DropdownItems["OptionHolder"].Instance.Size = UDim2New(0, DropdownItems["RealDropdown"].Instance.AbsoluteSize.X, 0, 85)
                        end)
                    else
                        if RenderStepped then
                            RenderStepped:Disconnect()
                            RenderStepped = nil
                        end
                    end

                    local Descendants = DropdownItems["OptionHolder"].Instance:GetDescendants()
                    TableInsert(Descendants, DropdownItems["OptionHolder"].Instance)

                    local NewTween

                    for Index, Value in Descendants do 
                        local TransparencyProperty = Tween:GetProperty(Value)

                        if not TransparencyProperty then 
                            continue
                        end

                        if StringFind(Value.ClassName, "UI") then
                            continue
                        end

                        Value.ZIndex = Bool and 10 or 0

                        if type(TransparencyProperty) == "table" then 
                            for _, Property in TransparencyProperty do 
                                NewTween = Tween:FadeItem(Value, Property, Bool, Data.Window.FadeSpeed)
                            end
                        else
                            NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Data.Window.FadeSpeed)
                        end
                    end

                    Library:Connect(NewTween.Tween.Completed, function()
                        Debounce = false
                        DropdownItems["OptionHolder"].Instance.Visible = Bool
                    end)
                end

                function Dropdown:Set(Option)
                    if Dropdown.Multi then
                        if type(Option) ~= "table" then
                            return
                        end

                        Dropdown.Value = Option
                        Library.Flags[Dropdown.Flag] = Option

                        for Index, Value in Option do 
                            local OptionData = Dropdown.Options[Value]
                                
                            if not OptionData then 
                                return
                            end

                            OptionData.Selected = true
                            OptionData:Toggle("Active")
                        end

                        DropdownItems["Value"].Instance.Text = TableConcat(Option, ", ")
                    else
                        if not Dropdown.Options[Option] then 
                            return
                        end

                        local OptionData = Dropdown.Options[Option]

                        Dropdown.Value = OptionData.Name
                        Library.Flags[Dropdown.Flag] = OptionData.Name

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then
                                Value.Selected = false 
                                Value:Toggle("Inactive")
                            else
                                Value.Selected = true 
                                Value:Toggle("Active")
                            end
                        end

                        DropdownItems["Value"].Instance.Text = OptionData.Name
                    end

                    if Dropdown.Callback then 
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                Library.SetFlags[Dropdown.Flag] = function(Value)
                    Dropdown:Set(Value)
                end

                DropdownItems["RealDropdown"]:Connect("MouseButton1Down", function()
                    Dropdown:SetOpen(not Dropdown.IsOpen)
                end)

                Dropdown:AddOption("rainbow")
                Dropdown:AddOption("breathing")

                local OldColor = Colorpicker.Color
                local OldAlpha = Colorpicker.Alpha
                
                Dropdown.Callback = function(Value)
                    if TableFind(Value, "rainbow") then 
                        OldColor = Colorpicker.Color

                        Library:Thread(function()
                            while task.wait() do 
                                local RainbowHue = MathAbs(MathSin(tick() * 0.32))
                                local Color = FromHSV(RainbowHue, 1, 1)

                                Colorpicker:Set(Color, Colorpicker.Alpha)

                                if not TableFind(Value, "rainbow") then
                                    Colorpicker:Set(OldColor, Colorpicker.Alpha)
                                    break
                                end
                            end
                        end)
                    end

                    if TableFind(Value, "breathing") then 
                        Library:Thread(function()
                            OldAlpha = Colorpicker.Alpha
                            while task.wait() do 
                                local AlphaValue = MathAbs(MathSin(tick() * 0.8))

                                Colorpicker:Set(Colorpicker.Color, AlphaValue)

                                if not TableFind(Value, "breathing") then
                                    Colorpicker:Set(Colorpicker.Color, OldAlpha)
                                    break
                                end
                            end
                        end)
                    end
                end

                getgenv().Options[Dropdown.Flag] = Dropdown

                AnimationsDropdown = Dropdown 
                AnimationsDropdownItems = DropdownItems
            end

            local Debounce = false 

            local SlidingPalette = false 
            local SlidingHue = false 
            local SlidingAlpha = false

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Colorpicker.IsOpen = Bool

                Debounce = true
                Items["ColorpickerWindow"].Instance.Parent = Bool and Library.Holder.Instance or Library.UnusedHolder.Instance

                if Bool then 
                    Items["ColorpickerWindow"].Instance.Visible = true
                    Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + 25)
                    
                    for Index, Value in Library.OpenFrames do 
                        if Value.Type == "Colorpicker" then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Data.Name] = Colorpicker
                else
                    if Library.OpenFrames[Data.Name] then 
                        Library.OpenFrames[Data.Name] = nil
                    end
                end

                local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then 
                        continue
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Data.Window.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Data.Window.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    Items["ColorpickerWindow"].Instance.Visible = Bool
                end)                
            end

            function Colorpicker:Get()
                return Colorpicker.Color, Colorpicker.Alpha
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                local Color = FromHSV(Hue, Saturation, Value)

                Colorpicker.Color = Color
                Colorpicker.HexValue = Color:ToHex()

                Library.Flags[Data.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.HexValue
                }

                Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Color})
                Items["Inline"]:Tween(nil, {BackgroundColor3 = Color})
                Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

                if not IsFromAlpha then 
                    Items["Alpha"]:Tween(nil, {BackgroundColor3 = Color})
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Color, Colorpicker.Alpha)
                end
            end

            function Colorpicker:SlidePalette(Input)
                if not SlidingPalette then 
                    return
                end

                if not Input then
                    return
                end

                local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.98)
                local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.97)

                Items["PaletteDragger"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
                Colorpicker:Update()
            end

            function Colorpicker:SlideHue(Input)
                if not SlidingHue then 
                    return
                end

                if not Input then
                    return
                end
                
                local ValueX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 1)
                
                Colorpicker.Hue = ValueX

                local SlideX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 0.98)

                Items["HueDragger"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0.5, 0)})
                Colorpicker:Update()
            end

            function Colorpicker:SlideAlpha(Input)
                if not SlidingAlpha then 
                    return
                end

                if not Input then
                    return
                end
                
                local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
                
                Colorpicker.Alpha = ValueX

                local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.98)

                Items["AlphaDragger"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0.5, 0)})
                Colorpicker:Update(true)
            end

            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = FromRGB(Color[1], Color[2], Color[3])
                    Alpha = Color[4]
                elseif type(Color) == "string" then
                    Color = FromHex(Color)
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0

                local ColorPositionX = MathClamp(1 - Colorpicker.Saturation, 0, 0.98)
                local ColorPositionY = MathClamp(1 - Colorpicker.Value, 0, 0.97)

                local AlphaPositionX = MathClamp(Colorpicker.Alpha, 0, 0.98)

                local HuePositionX = MathClamp(Colorpicker.Hue, 0, 0.98)

                Items["PaletteDragger"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(ColorPositionX, 0, ColorPositionY, 0)})
                Items["HueDragger"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(HuePositionX, 0, 0.5, 0)})
                Items["AlphaDragger"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0.5, 0)})
                Colorpicker:Update()
            end

            getgenv().Options[Data.Flag] = Colorpicker

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            local InputChanged1

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                    SlidingPalette = true
                    Colorpicker:SlidePalette(Input)

                    if InputChanged1 then
                        return
                    end

                    InputChanged1 = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then 
                            SlidingPalette = false

                            InputChanged1:Disconnect()
                            InputChanged1 = nil
                        end
                    end)
                end
            end)

            local InputChanged2

            Items["Hue"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                    SlidingHue = true
                    Colorpicker:SlideHue(Input)
                    
                    if InputChanged2 then
                        return
                    end

                    InputChanged2 = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false

                            InputChanged2:Disconnect()
                            InputChanged2 = nil
                        end
                    end)
                end
            end)

            local InputChanged3

            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                    SlidingAlpha = true
                    Colorpicker:SlideAlpha(Input)

                    if InputChanged3 then
                        return
                    end

                    InputChanged3 = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false

                            InputChanged3:Disconnect()
                            InputChanged3 = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
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
                    if not Colorpicker.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) or Library:IsMouseOverFrame(AnimationsDropdownItems["OptionHolder"]) then
                        return 
                    end

                    if Debounce then 
                        return 
                    end

                    Colorpicker:SetOpen(false)
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end

            Library.SetFlags[Data.Flag] = function(Color, Alpha)
                Colorpicker:Set(Color, Alpha)
            end

            return Colorpicker, Items 
        end

        Components.Keybind = function(Data)
            local Keybind = {
                Type = "Keybind",
                IsOpen = false,

                Key = nil,
                Value = "",
                Mode = "",

                Toggled = false 
            }

            local Modes = { }
            Library.Flags[Data.Flag] = { }
            local ModesDropdown
            local ModesDropdownItems 
            local KeylistItem 

            if Library.KeyList then 
                KeylistItem = Library.KeyList:Add("", "")
            end

            local Items = { } do
                Items["KeyButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = "None",
                    AutomaticSize = Enum.AutomaticSize.X,
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, Data.IsToggle and -25 or 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["KeyButton"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIPadding", {
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 2),
                    PaddingLeft = UDimNew(0, 2)
                })

                Items["KeybindWindow"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + 25),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Visible = false,
                    Size = UDim2New(0, 195, 0, 93),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["KeybindWindow"]:AddToTheme({BackgroundColor3 = "Background"})

                Instances:Create("UIStroke", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Color = FromRGB(32, 36, 42),
                    Transparency = 0.4000000059604645,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UICorner", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["KeybindWindow"]:MakeDraggable()
                Items["KeybindWindow"]:MakeResizeable(Vector2New(155, 93), Vector2New(9999, 9999))

                local DropdownItems = { } do
                    DropdownItems["Dropdown"] = Instances:Create("Frame", {
                        Parent = Items["KeybindWindow"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2New(0, 0),
                        Size = UDim2New(1, -16, 0, 47),
                        Position = UDim2New(0, 8, 0, 8),
                        BorderColor3 = FromRGB(0, 0, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    DropdownItems["Text"] = Instances:Create("TextLabel", {
                        Parent = DropdownItems["Dropdown"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "mode",
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 0, 0, 15),
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  DropdownItems["Text"]:AddToTheme({TextColor3 = "Text"})

                    DropdownItems["RealDropdown"] = Instances:Create("TextButton", {
                        Parent = DropdownItems["Dropdown"].Instance,
                        Text = "", 
                        AutoButtonColor = false,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0, 1),
                        Position = UDim2New(0, 0, 1, 0),
                        Size = UDim2New(1, 0, 0, 25),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(34, 39, 45)
                    })  DropdownItems["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})

                    Instances:Create("UIGradient", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        Rotation = 84,
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                    }):AddToTheme({Color = function()
                        return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                    end})

                    Instances:Create("UICorner", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 4)
                    })

                    DropdownItems["Value"] = Instances:Create("TextLabel", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "--",
                        AutomaticSize = Enum.AutomaticSize.X,
                        Size = UDim2New(0, 0, 0, 15),
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 8, 0.5, 0),
                        BackgroundTransparency = 1,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  DropdownItems["Value"]:AddToTheme({TextColor3 = "Text"})

                    DropdownItems["OpenIcon"] = Instances:Create("ImageLabel", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        ImageColor3 = FromRGB(196, 231, 255),
                        ScaleType = Enum.ScaleType.Fit,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(0, 20, 0, 20),
                        AnchorPoint = Vector2New(1, 0.5),
                        Image = "rbxassetid://114252321536924",
                        BackgroundTransparency = 1,
                        Position = UDim2New(1, -3, 0.5, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  DropdownItems["OpenIcon"]:AddToTheme({ImageColor3 = "Accent"})

                    DropdownItems["OptionHolder"] = Instances:Create("TextButton", {
                        Parent = DropdownItems["Dropdown"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        Visible = false,
                        AutoButtonColor = false,
                        Size = UDim2New(1, 0, 0, 50),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Position = UDim2New(0, 0, 1, 5),
                        BorderSizePixel = 0,
                        ZIndex = 5,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(22, 25, 29)
                    })  DropdownItems["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline"})

                    Instances:Create("UIGradient", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        Rotation = 84,
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                    }):AddToTheme({Color = function()
                        return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                    end})

                    Instances:Create("UIStroke", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        Color = FromRGB(32, 36, 42),
                        Transparency = 0.4000000059604645,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }):AddToTheme({Color = "Border"})

                    Instances:Create("UICorner", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 5)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 2),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    Instances:Create("UIPadding", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 8),
                        PaddingBottom = UDimNew(0, 8),
                        PaddingRight = UDimNew(0, 8),
                        PaddingLeft = UDimNew(0, 8)
                    })
                end

                local Dropdown = { 
                    IsOpen = false,
                    Value = { },
                    Options = { },
                    Flag = Data.Flag .. "ModeDropdown",
                    Multi = false
                }

                function Dropdown:AddOption(Option)
                    local OptionButton = Instances:Create("TextButton", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = UDim2New(1, 0, 0, 25),
                        ZIndex = 5,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(16, 18, 21)
                    })  OptionButton:AddToTheme({BackgroundColor3 = "Background"})

                    local CheckImage = Instances:Create("ImageLabel", {
                        Parent = OptionButton.Instance,
                        Name = "\0",
                        ImageColor3 = FromRGB(196, 231, 255),
                        ScaleType = Enum.ScaleType.Fit,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(0, 18, 0, 18),
                        Visible = true,
                        AnchorPoint = Vector2New(0, 0.5),
                        Image = "rbxassetid://116339777575852",
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 3, 0.5, 0),
                        ImageTransparency = 1,
                        ZIndex = 5,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  CheckImage:AddToTheme({ImageColor3 = "Accent"})

                    Instances:Create("UICorner", {
                        Parent = OptionButton.Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 5)
                    })

                    local OptionText = Instances:Create("TextLabel", {
                        Parent = OptionButton.Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextTransparency = 0.5,
                        AnchorPoint = Vector2New(0, 0.5),
                        ZIndex = 5,
                        TextSize = 14,
                        Size = UDim2New(0, 0, 0, 15),
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = Option,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutomaticSize = Enum.AutomaticSize.X,
                        Position = UDim2New(0, 7, 0.5, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  OptionText:AddToTheme({TextColor3 = "Text"})

                    local OptionData = {
                        Selected = false,
                        Name = Option,
                        Text = OptionText,
                        Button = OptionButton,
                        Check = CheckImage
                    }

                    function OptionData:Toggle(Status)
                        if Status == "Active" then 
                            OptionData.Button:Tween(nil, {BackgroundTransparency = 0})
                            OptionData.Text:Tween(nil, {TextTransparency = 0, Position = UDim2New(0, 27, 0.5, 0)})
                            OptionData.Check:Tween(nil, {ImageTransparency = 0})
                        elseif Status == "Inactive" then
                            OptionData.Button:Tween(nil, {BackgroundTransparency = 1})
                            OptionData.Text:Tween(nil, {TextTransparency = 0.5, Position = UDim2New(0, 7, 0.5, 0)})
                            OptionData.Check:Tween(nil, {ImageTransparency = 1})
                        end
                    end

                    function OptionData:Set()
                        OptionData.Selected = not OptionData.Selected

                        if Dropdown.Multi then 
                            local Index = TableFind(Dropdown.Value, OptionData.Name)

                            if Index then 
                                TableRemove(Dropdown.Value, Index)
                            else
                                TableInsert(Dropdown.Value, OptionData.Name)
                            end

                            Library.Flags[Dropdown.Flag] = Dropdown.Value

                            OptionData:Toggle(Index and "Inactive" or "Active")

                            local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"

                            DropdownItems["Value"].Instance.Text = TextFormat
                        else
                            if OptionData.Selected then 
                                Dropdown.Value = OptionData.Name
                                Library.Flags[Dropdown.Flag] = OptionData.Name

                                OptionData:Toggle("Active")

                                for Index, Value in Dropdown.Options do 
                                    if Value ~= OptionData then
                                        Value.Selected = false 
                                        Value:Toggle("Inactive")
                                    end
                                end

                                DropdownItems["Value"].Instance.Text = OptionData.Name 
                            else
                                Dropdown.Value = nil
                                Library.Flags[Dropdown.Flag] = nil

                                OptionData:Toggle("Inactive")
                                DropdownItems["Value"].Instance.Text = "--"
                            end
                        end

                        if Dropdown.Callback then 
                            Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                        end
                    end

                    OptionData.Button:Connect("MouseButton1Down", function()
                        OptionData:Set()
                    end)

                    Dropdown.Options[Option] = OptionData
                    return OptionData
                end

                function Dropdown:Set(Option)
                    if Dropdown.Multi then
                        if type(Option) ~= "table" then
                            return
                        end

                        Dropdown.Value = Option
                        Library.Flags[Dropdown.Flag] = Option

                        for Index, Value in Option do 
                            local OptionData = Dropdown.Options[Value]
                            
                            if not OptionData then 
                                return
                            end

                            OptionData.Selected = true
                            OptionData:Toggle("Active")
                        end

                        DropdownItems["Value"].Instance.Text = TableConcat(Option, ", ")
                    else
                        if not Dropdown.Options[Option] then 
                            return
                        end

                        local OptionData = Dropdown.Options[Option]

                        Dropdown.Value = OptionData.Name
                        Library.Flags[Dropdown.Flag] = OptionData.Name

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then
                                Value.Selected = false 
                                Value:Toggle("Inactive")
                            else
                                Value.Selected = true 
                                Value:Toggle("Active")
                            end
                        end

                        DropdownItems["Value"].Instance.Text = OptionData.Name
                    end

                    if Dropdown.Callback then 
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end

                    Library.SetFlags[Dropdown.Flag] = function(Value)
                        Dropdown:Set(Value)
                    end
                end

                local _1 = Dropdown:AddOption("toggle")
                local _2 = Dropdown:AddOption("hold")
                local _3 = Dropdown:AddOption("always")

                Modes = {
                    ["toggle"] = _1,
                    ["hold"] = _2,
                    ["always"] = _3
                }

                local Debounce = false 
                local RenderStepped

                function Dropdown:SetOpen(Bool)
                    if Debounce then 
                        return 
                    end

                    Dropdown.IsOpen = Bool
                    DropdownItems["OptionHolder"].Instance.Parent = Bool and Library.Holder.Instance or Library.UnusedHolder.Instance

                    Debounce = true

                    if Bool then 
                        DropdownItems["OptionHolder"].Instance.Visible = true

                        RenderStepped = RunService.RenderStepped:Connect(function()
                            DropdownItems["OptionHolder"].Instance.Position = UDim2New(0, DropdownItems["RealDropdown"].Instance.AbsolutePosition.X, 0,  DropdownItems["RealDropdown"].Instance.AbsolutePosition.Y + DropdownItems["RealDropdown"].Instance.AbsoluteSize.Y + 5)
                            DropdownItems["OptionHolder"].Instance.Size = UDim2New(0, DropdownItems["RealDropdown"].Instance.AbsoluteSize.X, 0, 85)
                        end)
                    else
                        if RenderStepped then
                            RenderStepped:Disconnect()
                            RenderStepped = nil
                        end
                    end

                    local Descendants = DropdownItems["OptionHolder"].Instance:GetDescendants()
                    TableInsert(Descendants, DropdownItems["OptionHolder"].Instance)

                    local NewTween

                    for Index, Value in Descendants do 
                        local TransparencyProperty = Tween:GetProperty(Value)

                        if not TransparencyProperty then 
                            continue
                        end

                        if StringFind(Value.ClassName, "UI") then
                            continue
                        end

                        Value.ZIndex = Bool and 10 or 0

                        if type(TransparencyProperty) == "table" then 
                            for _, Property in TransparencyProperty do 
                                NewTween = Tween:FadeItem(Value, Property, Bool, Data.Window.FadeSpeed)
                            end
                        else
                            NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Data.Window.FadeSpeed)
                        end
                    end

                    Library:Connect(NewTween.Tween.Completed, function()
                        Debounce = false
                        DropdownItems["OptionHolder"].Instance.Visible = Bool
                    end)
                end

                DropdownItems["RealDropdown"]:Connect("MouseButton1Down", function()
                    Dropdown:SetOpen(not Dropdown.IsOpen)
                end)

                ModesDropdown = Dropdown
                ModesDropdownItems = DropdownItems

                local ToggleItems = { } do
                    ToggleItems["Toggle"] = Instances:Create("TextButton", {
                        Parent = Items["KeybindWindow"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Position = UDim2New(0, 8, 0, 65),
                        Size = UDim2New(1, -16, 0, 20),
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    ToggleItems["Text"] = Instances:Create("TextLabel", {
                        Parent = ToggleItems["Toggle"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        TextTransparency = 0.5,
                        Text = "show in keybind list",
                        AutomaticSize = Enum.AutomaticSize.X,
                        Size = UDim2New(0, 0, 0, 15),
                        AnchorPoint = Vector2New(0, 0.5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 0, 0.5, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  ToggleItems["Text"]:AddToTheme({TextColor3 = "Text"})

                    ToggleItems["Indicator"] = Instances:Create("Frame", {
                        Parent = ToggleItems["Toggle"].Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(1, 0.5),
                        Position = UDim2New(1, 0, 0.5, 0),
                        Size = UDim2New(0, 20, 0, 20),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(34, 39, 45)
                    })  ToggleItems["Indicator"]:AddToTheme({BackgroundColor3 = "Element"})

                    Instances:Create("UICorner", {
                        Parent = ToggleItems["Indicator"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 4)
                    })

                    ToggleItems["Inline"] = Instances:Create("Frame", {
                        Parent = ToggleItems["Indicator"].Instance,
                        Name = "\0",
                        Size = UDim2New(1, -4, 1, -4),
                        Position = UDim2New(0, 2, 0, 2),
                        BorderColor3 = FromRGB(0, 0, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(34, 39, 45)
                    })  ToggleItems["Inline"]:AddToTheme({BackgroundColor3 = "Element"})

                    Instances:Create("UICorner", {
                        Parent = ToggleItems["Inline"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 4)
                    })

                    Instances:Create("UIGradient", {
                        Parent = ToggleItems["Inline"].Instance,
                        Name = "\0",
                        Rotation = 84,
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                    }):AddToTheme({Color = function()
                        return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                    end})

                    ToggleItems["Check"] = Instances:Create("ImageLabel", {
                        Parent = ToggleItems["Inline"].Instance,
                        Name = "\0",
                        Visible = true,
                        ScaleType = Enum.ScaleType.Fit,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(1, -2, 1, -2),
                        AnchorPoint = Vector2New(0.5, 0.5),
                        Image = "rbxassetid://116339777575852",
                        BackgroundTransparency = 1,
                        Position = UDim2New(0.5, 0, 0.5, 0),
                        ImageTransparency = 1,
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        ImageColor3 = FromRGB(0, 0, 0)
                    })
                end

                getgenv().Options[Dropdown.Flag] = Dropdown

                local Toggle = { 
                    Value = false,
                    Flag = Data.Flag .. "keybindToggle",
                    Callback = nil,
                }

                function Toggle:Set(Bool)
                    Toggle.Value = Bool 
                    Library.Flags[Toggle.Flag] = Bool

                    if Bool then
                        ToggleItems["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                        ToggleItems["Inline"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

                        ToggleItems["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                        ToggleItems["Inline"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

                        ToggleItems["Check"]:Tween(nil, {ImageTransparency = 0})
                        ToggleItems["Text"]:Tween(nil, {TextTransparency = 0})
                    else
                        ToggleItems["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                        ToggleItems["Inline"]:ChangeItemTheme({BackgroundColor3 = "Element"})

                        ToggleItems["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                        ToggleItems["Inline"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})

                        ToggleItems["Check"]:Tween(nil, {ImageTransparency = 1})
                        ToggleItems["Text"]:Tween(nil, {TextTransparency = 0.5})
                    end

                    if Toggle.Callback then 
                        Library:SafeCall(Toggle.Callback, Bool)
                    end
                end

                Toggle.Callback = function(Value)
                    if KeylistItem then 
                        KeylistItem:SetVisibility(Value)
                    end
                end

                ToggleItems["Toggle"]:Connect("MouseButton1Down", function()
                    Toggle:Set(not Toggle.Value)
                end)

                Toggle:Set(true)

                Dropdown.Callback = function(Value)
                    Keybind.Mode = Value

                    Library.Flags[Data.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }
                end 

                getgenv().Options[Toggle.Flag] = Toggle
            end

            local Update = function()
                if not KeylistItem then 
                    return 
                end

                KeylistItem:SetText(Keybind.Value, Data.Name)
                
                if Keybind.Mode == "hold" then 
                    KeylistItem:SetStatus(Keybind.Toggled and "holding" or "off")
                else
                    KeylistItem:SetStatus(Keybind.Toggled and "on" or "off")
                end

                KeylistItem:Set(Keybind.Toggled)
            end

            local Debounce = false

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Keybind.IsOpen = Bool

                Debounce = true
                Items["KeybindWindow"].Instance.Parent = Bool and Library.Holder.Instance or Library.UnusedHolder.Instance

                if Bool then 
                    Items["KeybindWindow"].Instance.Visible = true
                    Items["KeybindWindow"].Instance.Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + 25)

                    for Index, Value in Library.OpenFrames do 
                        if Value.Type == "Keybind" then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Data.Name] = Keybind
                else
                    ModesDropdown:SetOpen(false)

                    if Library.OpenFrames[Data.Name] then 
                        Library.OpenFrames[Data.Name] = nil
                    end
                end

                local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["KeybindWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then 
                        continue
                    end

                    if StringFind(Value.ClassName, "UI") then
                        continue
                    end

                    Value.ZIndex = Bool and 15 or 0

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Data.Window.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Data.Window.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    Items["KeybindWindow"].Instance.Visible = Bool
                end)
            end

            function Keybind:SetMode(Mode)
                ModesDropdown:Set(Mode)
                
                Library.Flags[Data.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                Update()
            end

            function Keybind:Get()
                return Keybind.Toggled, Keybind.Key
            end

            function Keybind:Set(Key)
                if StringFind(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                    local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    Library.Flags[Data.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "toggle"
                        Keybind:SetMode("toggle")
                    end

                    local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif TableFind({"toggle", "hold", "always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Keybind.Mode)

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Items["KeyButton"]:Tween(nil, {TextTransparency = 0.5})
                Keybind.Picking = false
            end

            function Keybind:Press(Bool)
                if Keybind.Mode == "toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "always" then 
                    Keybind.Toggled = true
                end

                Library.Flags[Data.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            getgenv().Options[Data.Flag] = Keybind

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                if Keybind.Picking then 
                    return
                end

                Keybind.Picking = true

                Items["KeyButton"]:Tween(nil, {TextTransparency = 0})

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
                    if Keybind.Mode == "toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "hold" then 
                        Keybind:Press(true)
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                    if Library:IsMouseOverFrame(Items["KeybindWindow"]) or Library:IsMouseOverFrame(ModesDropdownItems["OptionHolder"]) then 
                        return
                    end

                    if Debounce then 
                        return 
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key and not Keybind.Value == "None"  then
                    if Keybind.Mode == "hold" then 
                        Keybind:Press(false)
                    end
                end
            end)

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            if Data.Default then
               Keybind.Mode = Data.Mode or "toggle"
               Modes[Keybind.Mode]:Set()
               Keybind:Set({Key = Data.Default, Mode = Data.Mode})
            end

            Library.SetFlags[Data.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end
    end

    do -- Element functions
        Library.ESPPreview = function(self, Data)
            local ESPPreview = { 
                Player = nil,
                Items = { },
            }

            local Items = { } do
                Items["EspPreview"] = Instances:Create("TextButton", {
                    Parent = Data.MainFrame.Instance,
                    Name = "\0",
                    Position = UDim2New(1, 10, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 265, 0, 355),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["EspPreview"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["EspPreview"]:MakeDraggable()

                Items["Topbar"] = Instances:Create("Frame", {
                    Parent = Items["EspPreview"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 35),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                })  Items["Topbar"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UIStroke", {
                    Parent = Items["EspPreview"].Instance,
                    Name = "\0",
                    Color = FromRGB(32, 36, 42),
                    Transparency = 0.4000000059604645,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UICorner", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("Frame", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 3),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                }):AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("Frame", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    BackgroundTransparency = 0.4000000059604645,
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(32, 36, 42)
                }):AddToTheme({BackgroundColor3 = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    AnchorPoint = Vector2New(0, 0.5),
                    ZIndex = 2,
                    TextSize = 14,
                    Size = UDim2New(0, 0, 0, 15),
                    RichText = true,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "ESP Preview",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 8, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

                Items["CloseButton"] = Instances:Create("ImageButton", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 17, 0, 17),
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://76001605964586",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -7, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["CloseButton"]:AddToTheme({ImageColor3 = "Image"})

                Instances:Create("UICorner", {
                    Parent = Items["EspPreview"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["CharacterViewportBackground"] = Instances:Create("TextButton", {
                    Parent = Items["EspPreview"].Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 45),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -14, 1, -50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["CharacterViewport"] = Instances:Create("ViewportFrame", {
                    Parent = Items["EspPreview"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 45),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -16, 1, -53),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                -- Box
                    Items.Box = Instances:Create( "Frame" , {
                        BackgroundTransparency = 1;
                        Parent = Items.CharacterViewport.Instance;
                        BorderColor3 = FromRGB(0, 0, 0);
                        Name = "\0";
                        BorderSizePixel = 0;
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    });

                    Items.Left = Instances:Create( "Frame" , {
                        Parent = Items.Box.Instance;
                        Size = UDim2New(0, 100, 1, 0);
                        BackgroundTransparency = 1;
                        Name = "\0";
                        AnchorPoint = Vector2New(1, 0);
                        Position = UDim2New(0, -5, 0, 0);
                        BorderColor3 = FromRGB(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    });

                    Instances:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        VerticalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Items.Left.Instance;
                        Padding = UDimNew(0, 1);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    Items.LeftTexts = Instances:Create( "Frame" , {
                        Parent = Items.Left.Instance;
                        Size = UDim2New(0, 0, 1, 0);
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = UDim2New(1, 1, 0, 0);
                        BorderColor3 = FromRGB(0, 0, 0);
                        LayoutOrder = 9999;
                        ZIndex = 2;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BorderSizePixel = 0;
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    });

                    Instances:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Vertical;
                        Parent = Items.LeftTexts.Instance;
                        Padding = UDimNew(0, 1);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    Items.Top = Instances:Create( "Frame" , {
                        Parent = Items.Box.Instance;
                        Size = UDim2New(1, 0, 0, 100);
                        BackgroundTransparency = 1;
                        Name = "\0";
                        AnchorPoint = Vector2New(0, 1);
                        Position = UDim2New(0, 0, 0, -5);
                        BorderColor3 = FromRGB(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    });

                    Items.TopTexts = Instances:Create( "Frame", {
                        LayoutOrder = -1;
                        Parent = Items.Top.Instance;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = FromRGB(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    });

                    Instances:Create( "UIListLayout" , {
                        VerticalAlignment = Enum.VerticalAlignment.Bottom;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        HorizontalAlignment = Enum.HorizontalAlignment.Center;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Items.Top.Instance;
                        Padding = UDimNew(0, 1)
                    });

                    Items.Right = Instances:Create( "Frame" , {
                        Parent = Items.Box.Instance;
                        Size = UDim2New(0, 100, 1, 0);
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = UDim2New(1, 5, 0, 0);
                        BorderColor3 = FromRGB(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    });

                    Items.RightTexts = Instances:Create( "Frame" , {
                        Parent = Items.Right.Instance;
                        Size = UDim2New(0, 0, 1, 0);
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = UDim2New(0, 0, 0, 0);
                        BorderColor3 = FromRGB(0, 0, 0);
                        LayoutOrder = 9999;
                        ZIndex = 2;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BorderSizePixel = 0;
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    });

                    Instances:Create( "UIListLayout" , {
                        Parent = Items.RightTexts.Instance;
                        Padding = UDimNew(0, 1);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    Instances:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        VerticalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Items.Right.Instance;
                        Padding = UDimNew(0, 1);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    Items.Bottom = Instances:Create( "Frame" , {
                        Parent = Items.Box.Instance;
                        Size = UDim2New(1, 0, 0, 100);
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = UDim2New(0, 0, 1, 5);
                        BorderColor3 = FromRGB(0, 0, 0);
                        AutomaticSize = Enum.AutomaticSize.Y;
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    });
                    
                    Items.BottomTexts = Instances:Create( "Frame", {
                        LayoutOrder = 1;
                        Parent = Items.Bottom.Instance;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = FromRGB(0, 0, 0);
                        Size = UDim2New(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    });

                    Instances:Create( "UIListLayout", {
                        Parent = Items.BottomTexts.Instance;
                        Padding = UDimNew(0, 1);
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center
                    });

                    Instances:Create( "UIListLayout" , {
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        HorizontalAlignment = Enum.HorizontalAlignment.Center;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Items.Bottom.Instance;
                        Padding = UDimNew(0, 1)
                    });

                        Items.BoxHolder = Instances:Create( "Frame" , {
                            Visible = true;
                            Size = UDim2New(1, -2, 1, -2);
                            BorderColor3 = FromRGB(0, 0, 0);
                            Parent = Items.Box.Instance;
                            BackgroundTransparency = 0.8500000238418579;
                            Position = UDim2New(0, 1, 0, 1);
                            Name = "\0";
                            BorderSizePixel = 0;
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        });

                        Items.BoxHolderGradient = Instances:Create( "UIGradient" , {
                            Rotation = 0;
                            Name = "\0";
                            Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(255, 255, 255))};
                            Parent = Items.BoxHolder.Instance;
                            Enabled = true
                        }); 

                        Instances:Create( "UIStroke" , {
                            Parent = Items.BoxHolder.Instance;
                            LineJoinMode = Enum.LineJoinMode.Miter
                        });
                        
                        Items.Inner = Instances:Create( "Frame" , {
                            Parent = Items.BoxHolder.Instance;
                            Name = "\0";
                            BackgroundTransparency = 1;
                            Position = UDim2New(0, 1, 0, 1);
                            BorderColor3 = FromRGB(0, 0, 0);
                            Size = UDim2New(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        });

                        Items.UIStroke = Instances:Create( "UIStroke" , {
                            Color = FromRGB(255, 255, 255);
                            LineJoinMode = Enum.LineJoinMode.Miter;
                            Parent = Items.Inner.Instance
                        });
                        
                        Items.BoxGradient = Instances:Create( "UIGradient" , {
                            Rotation = 0;
                            Name = "\0";
                            Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(255, 255, 255))};
                            Parent = Items.UIStroke.Instance;
                            Enabled = true
                        });
                        
                        Items.Inner2 = Instances:Create( "Frame" , {
                            Parent = Items.BoxHolder.Instance;
                            Name = "\0";
                            BackgroundTransparency = 1;
                            Position = UDim2New(0, 2, 0, 2);
                            BorderColor3 = FromRGB(0, 0, 0);
                            Size = UDim2New(1, -4, 1, -4);
                            BorderSizePixel = 0;
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        });

                        Instances:Create( "UIStroke" , {
                            Parent = Items.Inner2.Instance;
                            LineJoinMode = Enum.LineJoinMode.Miter
                        });
                -- Healthbar
                    Items.HealthBar = Instances:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.Left.Instance;
                        BorderColor3 = FromRGB(0, 0, 0);
                        Size = UDim2New(0, 3, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = FromRGB(0, 0, 0)
                    });

                    Items.Bar = Instances:Create( "Frame" , {
                        Parent = Items.HealthBar.Instance;
                        Name = "\0";
                        Position = UDim2New(0, 1, 0, 1);
                        BorderColor3 = FromRGB(0, 0, 0);
                        Size = UDim2New(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    });

                    Items.BarGradient = Instances:Create( "UIGradient" , {
                        Rotation = 90;
                        Parent = Items.Bar.Instance;
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(255, 125, 0)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
                    });

                    Items.HealthBarText = Instances:Create( "TextLabel" , {
                        FontFace = ESPFonts["ProggyClean"];
                        Parent = Items.HealthBar.Instance;
                        TextColor3 = FromRGB(0, 255, 0);
                        Text = "100";
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        Position = UDim2New(0, 1, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        AnchorPoint = Vector2New(1, 0),
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderColor3 = FromRGB(0, 0, 0);
                        ZIndex = 2;
                        TextSize = 12;
                    })
                -- Name
                        Items.Name = Instances:Create( "TextLabel" , {
                            FontFace = ESPFonts["ProggyClean"];
                            Parent = Items.TopTexts.Instance;
                            TextColor3 = FromRGB(255, 255, 255);
                            TextStrokeColor3 = FromRGB(255, 255, 255);
                            Text = LocalPlayer.Name;
                            Name = "\0";
                            AutomaticSize = Enum.AutomaticSize.XY;
                            Position = UDim2New(0.5, 1, 0, 0);
                            BorderSizePixel = 0;
                            AnchorPoint = Vector2New(0.5, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Center;
                            BorderColor3 = FromRGB(0, 0, 0);
                            ZIndex = 2;
                            TextSize = 12;
                        });

                        Items.WeaponText = Instances:Create( "TextLabel" , {
                            FontFace = ESPFonts["ProggyClean"];
                            Parent = Items.RightTexts.Instance;
                            TextColor3 = FromRGB(255, 255, 255);
                            TextStrokeColor3 = FromRGB(255, 255, 255);
                            Text = "Weapon";
                            Name = "\0";
                            AutomaticSize = Enum.AutomaticSize.XY;
                            Position = UDim2New(0, 1, 0, 0);
                            BorderSizePixel = 0;
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderColor3 = FromRGB(0, 0, 0);
                            ZIndex = 2;
                            TextSize = 12;
                        });

                        Items.Distance = Instances:Create( "TextLabel" , {
                            FontFace = ESPFonts["ProggyClean"];
                            Parent = Items.BottomTexts.Instance;
                            TextColor3 = FromRGB(255, 255, 255);
                            TextStrokeColor3 = FromRGB(255, 255, 255);
                            Text = "Distance";
                            Name = "\0";
                            AutomaticSize = Enum.AutomaticSize.XY;
                            Position = UDim2New(0, 1, 0, 0);
                            BorderSizePixel = 0;
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Center;
                            BorderColor3 = FromRGB(0, 0, 0);
                            ZIndex = 2;
                            TextSize = 12;
                        });

                -- Corner boxes
                        Items.Corners = Instances:Create( "Frame" , {
                            Parent = Items.Box.Instance;
                            Name = "\0";
                            ClipsDescendants = true;
                            BorderColor3 = FromRGB(0, 0, 0);
                            Size = UDim2New(1, 0, 1, 0);
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0;
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        });

                        Items.CornersGradient = Instances:Create( "UIGradient" , {
                            Parent = Items.Corners.Instance;
                        });

                        Items.BottomLeftX = Instances:Create( "ImageLabel" , {
                            ScaleType = Enum.ScaleType.Slice;
                            Parent = Items.Corners.Instance;
                            BorderColor3 = FromRGB(0, 0, 0);
                            Name = "\0";
                            BackgroundColor3 = FromRGB(255, 255, 255);
                            Size = UDim2New(0.25, 0, 0, 3);
                            AnchorPoint = Vector2New(0, 1);
                            Image = "rbxassetid://83548615999411";
                            BackgroundTransparency = 1;
                            Position = UDim2New(0, 0, 1, 0);
                            ZIndex = 2;
                            BorderSizePixel = 0;
                            SliceCenter = RectNew(Vector2New(1, 1), Vector2New(99, 2))
                        });

                        Instances:Create( "UIGradient" , {
                            Parent = Items.BottomLeftX.Instance
                        });

                        Items.BottomLeftY = Instances:Create( "ImageLabel" , {
                            ScaleType = Enum.ScaleType.Slice;
                            Parent = Items.Corners.Instance;
                            BorderColor3 = FromRGB(0, 0, 0);
                            Name = "\0";
                            BackgroundColor3 = FromRGB(255, 255, 255);
                            Size = UDim2New(0, 3, 0.25, -9);
                            AnchorPoint = Vector2New(0, 1);
                            Image = "rbxassetid://101715268403902";
                            BackgroundTransparency = 1;
                            Position = UDim2New(0, 0, 1, -2);
                            ZIndex = 500;
                            BorderSizePixel = 0;
                            SliceCenter = RectNew(Vector2New(1, 0), Vector2New(2, 96))
                        });

                        Instances:Create( "UIGradient" , {
                            Rotation = -90;
                            Parent = Items.BottomLeftY.Instance
                        });

                        Items.BottomLeftX = Instances:Create( "ImageLabel" , {
                            ScaleType = Enum.ScaleType.Slice;
                            Parent = Items.Corners.Instance;
                            BorderColor3 = FromRGB(0, 0, 0);
                            Name = "\0";
                            BackgroundColor3 = FromRGB(255, 255, 255);
                            Size = UDim2New(0.25, 0, 0, 3);
                            AnchorPoint = Vector2New(1, 1);
                            Image = "rbxassetid://83548615999411";
                            BackgroundTransparency = 1;
                            Position = UDim2New(1, 0, 1, 0);
                            ZIndex = 2;
                            BorderSizePixel = 0;
                            SliceCenter = RectNew(Vector2New(1, 1), Vector2New(99, 2))
                        });

                        Instances:Create( "UIGradient" , {
                            Parent = Items.BottomLeftX.Instance
                        });

                        Items.BottomLeftY = Instances:Create( "ImageLabel" , {
                            ScaleType = Enum.ScaleType.Slice;
                            Parent = Items.Corners.Instance;
                            BorderColor3 = FromRGB(0, 0, 0);
                            Name = "\0";
                            BackgroundColor3 = FromRGB(255, 255, 255);
                            Size = UDim2New(0, 3, 0.25, -9);
                            AnchorPoint = Vector2New(1, 1);
                            Image = "rbxassetid://101715268403902";
                            BackgroundTransparency = 1;
                            Position = UDim2New(1, 0, 1, -2);
                            ZIndex = 500;
                            BorderSizePixel = 0;
                            SliceCenter = RectNew(Vector2New(1, 0), Vector2New(2, 96))
                        });

                        Instances:Create( "UIGradient" , {
                            Rotation = 90;
                            Parent = Items.BottomLeftY.Instance
                        });

                        Items.TopLeftY = Instances:Create( "ImageLabel" , {
                            ScaleType = Enum.ScaleType.Slice;
                            BorderColor3 = FromRGB(0, 0, 0);
                            Parent = Items.Corners.Instance;
                            Name = "\0";
                            BackgroundColor3 = FromRGB(255, 255, 255);
                            Size = UDim2New(0, 3, 0.25, -9);
                            Image = "rbxassetid://102467475629368";
                            BackgroundTransparency = 1;
                            Position = UDim2New(0, 0, 0, 2);
                            ZIndex = 500;
                            BorderSizePixel = 0;
                            SliceCenter = RectNew(Vector2New(1, 0), Vector2New(2, 98))
                        });

                        Instances:Create( "UIGradient" , {
                            Rotation = 90;
                            Parent = Items.TopLeftY.Instance
                        });

                        Items.TopRightY = Instances:Create( "ImageLabel" , {
                            ScaleType = Enum.ScaleType.Slice;
                            Parent = Items.Corners.Instance;
                            BorderColor3 = FromRGB(0, 0, 0);
                            Name = "\0";
                            BackgroundColor3 = FromRGB(255, 255, 255);
                            Size = UDim2New(0, 3, 0.25, -9);
                            AnchorPoint = Vector2New(1, 0);
                            Image = "rbxassetid://102467475629368";
                            BackgroundTransparency = 1;
                            Position = UDim2New(1, 0, 0, 2);
                            ZIndex = 500;
                            BorderSizePixel = 0;
                            SliceCenter = RectNew(Vector2New(1, 0), Vector2New(2, 98))
                        });

                        Instances:Create( "UIGradient" , {
                            Rotation = -90;
                            Parent = Items.TopRightY.Instance
                        });

                        Items.TopRightX = Instances:Create( "ImageLabel" , {
                            ScaleType = Enum.ScaleType.Slice;
                            Parent = Items.Corners.Instance;
                            BorderColor3 = FromRGB(0, 0, 0);
                            Name = "\0";
                            BackgroundColor3 = FromRGB(255, 255, 255);
                            Size = UDim2New(0.25, 0, 0, 3);
                            AnchorPoint = Vector2New(1, 0);
                            Image = "rbxassetid://83548615999411";
                            BackgroundTransparency = 1;
                            Position = UDim2New(1, 0, 0, 0);
                            ZIndex = 2;
                            BorderSizePixel = 0;
                            SliceCenter = RectNew(Vector2New(1, 1), Vector2New(99, 2))
                        });

                        Instances:Create( "UIGradient" , {
                            Parent = Items.TopRightX.Instance
                        });

                        Items.TopLeftX = Instances:Create( "ImageLabel" , {
                            ScaleType = Enum.ScaleType.Slice;
                            BorderColor3 = FromRGB(0, 0, 0);
                            Parent = Items.Corners.Instance;
                            Name = "\0";
                            BackgroundColor3 = FromRGB(255, 255, 255);
                            Image = "rbxassetid://83548615999411";
                            BackgroundTransparency = 1;
                            Size = UDim2New(0.25, 0, 0, 3);
                            ZIndex = 2;
                            BorderSizePixel = 0;
                            SliceCenter = RectNew(Vector2New(1, 1), Vector2New(99, 2))
                        });

                        Instances:Create( "UIGradient" , {
                            Parent = Items.TopLeftX.Instance
                        });

                ESPPreview.Items = Items
            end

            function ESPPreview:Set(Item, Property, Value)
                Items[Item].Instance[Property] = Value
            end

            local Math = {} do
                local inf = math.huge
                local negative_inf = -math.huge

                function Math:GetBoundingBox(model, camera, ViewportFrame)
                    model = type(model) ~= 'table' and model:GetDescendants() or model
                    local Min, Max = Vector2New(inf, inf), Vector2New(negative_inf, negative_inf)
                    
                    for _,v in model do
                        if not v:IsA("BasePart") then
                            continue
                        end

                        local Size, cFrame = v.Size, v.CFrame

                        local Corners = {
                            Vector3New( 0.5,  0.5,  0.5),
                            Vector3New(-0.5,  0.5,  0.5),
                            Vector3New( 0.5, -0.5,  0.5),
                            Vector3New(-0.5, -0.5,  0.5),
                            Vector3New( 0.5,  0.5, -0.5),
                            Vector3New(-0.5,  0.5, -0.5),
                            Vector3New( 0.5, -0.5, -0.5),
                            Vector3New(-0.5, -0.5, -0.5),
                        }

                        for _,corner in Corners do
                            local Point = cFrame:PointToWorldSpace(Vector3New(
                                corner.X * Size.X,
                                corner.Y * Size.Y,
                                corner.Z * Size.Z
                            ))

                            local Viewport, Visible = camera:WorldToViewportPoint(Point)

                            if Visible then
                                Min = Vector2New(MathMin(Min.X, Viewport.X), MathMin(Min.Y, Viewport.Y))
                                Max = Vector2New(MathMax(Max.X, Viewport.X), MathMax(Max.Y, Viewport.Y))
                            end
                        end
                    end

                    local AbsoluteSize = ViewportFrame.AbsoluteSize

                    local Size2D = Max - Min

                    local Position = Vector2New(Min.X - 0.05, Min.Y)
                    local Size = Vector2New(Size2D.X + 0.1, Size2D.Y)

                    return UDim2FromScale(Position.X, Position.Y), UDim2FromScale(Size.X, Size.Y)
                end
            end 

            function ESPPreview:SetVisibility(Bool)
                Items["EspPreview"].Instance.Visible = Bool
            end
            
            Items["CloseButton"]:Connect("MouseButton1Down", function()
                ESPPreview:SetVisibility(false)
            end)

            local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

            local ViewportCamera = InstanceNew("Camera")
            Items["CharacterViewport"].Instance.CurrentCamera = ViewportCamera
            ViewportCamera.CameraType = Enum.CameraType.Track
            ViewportCamera.Focus = CFrameNew(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            ViewportCamera.CFrame = CFrameNew(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)

            Library:Connect(RunService.RenderStepped, function()	
                local Pos, Size = Math:GetBoundingBox(ESPPreview.Player, ViewportCamera, Items.CharacterViewport.Instance)
                Items.Box.Instance.Position = Pos
                Items.Box.Instance.Size = Size
            end)

            local ViewportModel

            if LocalCharacter then
                LocalCharacter.Archivable = true
                ViewportModel = LocalCharacter:Clone()

                ViewportModel.PrimaryPart.Anchored = true
                ViewportModel.Parent = Items["CharacterViewport"].Instance

                for Index, Value in ViewportModel:GetDescendants() do
                    if Value:IsA("LocalScript") then
                        Value:Destroy()
                    end
                end

                local HumanoidRootPart = ViewportModel:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    if not ViewportModel.PrimaryPart then
                        ViewportModel.PrimaryPart = HumanoidRootPart
                    end

                    ViewportModel:SetPrimaryPartCFrame(CFrameAngles(0, MathRad(180), 0) + Vector3New(0, 1.5, 0))
                    ViewportCamera.CFrame = CFrameNew(Vector3New(0, 2, 6), Vector3New(0, 1, 0))
                end

                ESPPreview.Player = ViewportModel
            end

            ViewportCamera.CameraSubject = ViewportModel

            local LastPosition 
            local IsRotating = false

            local Sensitivity = 0.7

            local Yaw = MathRad(180)
            local Roll = 0
            local Pitch = 0

            local ClampPitch = function(PitchValue)
                return MathClamp(PitchValue, MathRad(-80), MathRad(80))
            end

            local ViewportInputChanged
            Items["CharacterViewport"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsRotating = true
                    LastPosition = Input.Position

                    if ViewportInputChanged then 
                        return
                    end
                    
                    ViewportInputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            IsRotating = false

                            ViewportInputChanged:Disconnect()
                            ViewportInputChanged = nil
                        end
                    end)
                end
            end)

            Items["CharacterViewport"]:Connect("InputChanged", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if not LastPosition then 
                        return
                    end

                    if not IsRotating then
                        return
                    end
                    
                    local RotationDelta = Input.Position - LastPosition

                    Yaw = Yaw - MathRad(RotationDelta.X * Sensitivity)
                    Pitch = ClampPitch(Pitch - MathRad(RotationDelta.Y * Sensitivity))

                    LastPosition = Input.Position

                    if ViewportModel and ViewportModel.PrimaryPart then
                        local Rotation = CFrameAngles(Pitch, Yaw, Roll)
                        ViewportModel:SetPrimaryPartCFrame(Rotation + Vector3.new(0, 1.5, 0))
                    end
                end
            end)

            return ESPPreview
        end
        
        Library.ChatSystem = function(self, Data)
            local GlobalChat = { }

            local Items = { } do 
                Items["Chat_System"] = Instances:Create("Frame", {
                    Parent = Data.MainFrame.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(0, -15, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 378, 0, 511),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["Chat_System"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["Chat_System"]:MakeDraggable()

                Instances:Create("UICorner", {
                    Parent = Items["Chat_System"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Chat_System"].Instance,
                    Name = "\0",
                    Color = FromRGB(32, 36, 42),
                    Transparency = 0.4000000059604645,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Topbar"] = Instances:Create("Frame", {
                    Parent = Items["Chat_System"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 35),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                })  Items["Topbar"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UICorner", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("Frame", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 3),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                }):AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("Frame", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    BackgroundTransparency = 0.4000000059604645,
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(32, 36, 42)
                }):AddToTheme({BackgroundColor3 = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(196, 231, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://103982381939732",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Logo"]:AddToTheme({ImageColor3 = "Accent"})

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    AnchorPoint = Vector2New(0, 0.5),
                    ZIndex = 2,
                    TextSize = 14,
                    Size = UDim2New(0, 0, 0, 15),
                    RichText = true,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Global chat",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 37, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

                Items["CloseButton"] = Instances:Create("ImageButton", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 17, 0, 17),
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://76001605964586",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -7, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["CloseButton"]:AddToTheme({ImageColor3 = "Image"})

                Items["StatusCircle"] = Instances:Create("Frame", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, -33, 0.5, 0),
                    Size = UDim2New(0, 12, 0, 12),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(62, 255, 91)
                })

                Instances:Create("UICorner", {
                    Parent = Items["StatusCircle"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["StatusCircle"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Items["StatusText"] = Instances:Create("TextLabel", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(62, 255, 91),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Connected",
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, -50, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["StatusCircle"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(62, 255, 91),
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.30000001192092896,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    Size = UDim2New(1, 8, 1, 8),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                })

                Items["SendMessage"] = Instances:Create("Frame", {
                    Parent = Items["Chat_System"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 1, -8),
                    Size = UDim2New(1, -16, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["SendMessage"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    MultiLine = true,
                    CursorPosition = -1,
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    PlaceholderText = "Send message",
                    TextSize = 14,
                    Size = UDim2New(1, -45, 1, 0),
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(34, 39, 45)
                })  Items["Input"]:AddToTheme({BackgroundColor3 = "Element"})

                Instances:Create("UICorner", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["SendMessageButton"] = Instances:Create("TextButton", {
                    Parent = Items["SendMessage"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 35, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(34, 39, 45)
                })  Items["SendMessageButton"]:AddToTheme({BackgroundColor3 = "Element"})

                Instances:Create("UICorner", {
                    Parent = Items["SendMessageButton"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Items["SendImageLabel"] = Instances:Create("ImageLabel", {
                    Parent = Items["SendMessageButton"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(196, 231, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://93681479181206",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["SendImageLabel"]:AddToTheme({ImageColor3 = "Accent"})

                Items["Messages"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["Chat_System"].Instance,
                    Name = "\0",
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = FromRGB(196, 231, 255),
                    MidImage = "rbxassetid://76010408336709",
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 2,
                    Size = UDim2New(1, 0, 1, -80),
                    Selectable = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 35),
                    BottomImage = "rbxassetid://76010408336709",
                    TopImage = "rbxassetid://76010408336709",
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Messages"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Archivable = false,
                    Padding = UDimNew(0, 8)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Messages"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 12),
                    PaddingLeft = UDimNew(0, 8)
                })
            end

            function GlobalChat:SetVisibility(Bool)
                Items["Chat_System"].Instance.Visible = Bool
                Items["Chat_System"].Instance.Parent = Bool and Data.MainFrame.Instance or Library.UnusedHolder
            end

            function GlobalChat:SetStatusText(Text)
                Items["StatusText"].Instance.Text = Text
            end

            local OnMessagePressed            

            function GlobalChat:OnMessageSendPressed(Func)
                OnMessagePressed = Func
            end

            function GlobalChat:GetTypedMessage()
                return Items["Input"].Instance.Text
            end

            function GlobalChat:SendMessage(Avatar, Username, Message, IsLocalPlayer)
                local SubItems = { } do
                    if not IsLocalPlayer then
                        SubItems["Message1"] = Instances:Create("Frame", {
                            Parent = Items["Messages"].Instance,
                            Name = "\0",
                            BackgroundTransparency = 1,
                            Size = UDim2New(1, 0, 0, 45),
                            BorderColor3 = FromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })

                        SubItems["PlayerName"] = Instances:Create("TextLabel", {
                            Parent = SubItems["Message1"].Instance,
                            Name = "\0",
                            FontFace = Library.Font,
                            TextColor3 = FromRGB(255, 255, 255),
                            BorderColor3 = FromRGB(0, 0, 0),
                            Text = Username,
                            Size = UDim2New(0, 0, 0, 15),
                            BackgroundTransparency = 1,
                            Position = UDim2New(0, 38, 0, 0),
                            BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.X,
                            TextSize = 14,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })  SubItems["PlayerName"]:AddToTheme({TextColor3 = "Text"})

                        SubItems["RealMessage"] = Instances:Create("Frame", {
                            Parent = SubItems["Message1"].Instance,
                            Name = "\0",
                            Position = UDim2New(0, 38, 0, 20),
                            BorderColor3 = FromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.XY,
                            BackgroundColor3 = FromRGB(22, 25, 29)
                        })  SubItems["RealMessage"]:AddToTheme({BackgroundColor3 = "Inline"})

                        Instances:Create("UISizeConstraint", {
                            Parent = SubItems["RealMessage"].Instance,
                            Name = "\0",
                            MaxSize = Vector2New(370, 75)
                        })

                        Instances:Create("UICorner", {
                            Parent = SubItems["RealMessage"].Instance,
                            Name = "\0",
                            CornerRadius = UDimNew(0, 4)
                        })

                        SubItems["MessageText"] = Instances:Create("TextLabel", {
                            Parent = SubItems["RealMessage"].Instance,
                            Name = "\0",
                            FontFace = Library.Font,
                            TextColor3 = FromRGB(255, 255, 255),
                            BorderColor3 = FromRGB(0, 0, 0),
                            Text = Message,
                            BackgroundTransparency = 1,
                            TextWrapped = true,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.XY,
                            TextSize = 14,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })  SubItems["MessageText"]:AddToTheme({TextColor3 = "Text"})

                        Instances:Create("UIPadding", {
                            Parent = SubItems["RealMessage"].Instance,
                            Name = "\0",
                            PaddingTop = UDimNew(0, 8),
                            PaddingBottom = UDimNew(0, 8),
                            PaddingRight = UDimNew(0, 8),
                            PaddingLeft = UDimNew(0, 8)
                        })

                        SubItems["Avatar"] = Instances:Create("ImageLabel", {
                            Parent = SubItems["Message1"].Instance,
                            Name = "\0",
                            BorderColor3 = FromRGB(0, 0, 0),
                            AnchorPoint = Vector2New(0, 0.5),
                            Image = Avatar,
                            BackgroundTransparency = 1,
                            Position = UDim2New(0, 0, 0.5, 0),
                            Size = UDim2New(0, 30, 0, 30),
                            BorderSizePixel = 0,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })

                        Instances:Create("UICorner", {
                            Parent = SubItems["Avatar"].Instance,
                            Name = "\0",
                            CornerRadius = UDimNew(0, 4)
                        })
                    else
                        SubItems["Message1"] = Instances:Create("Frame", {
                            Parent = Items["Messages"].Instance,
                            Name = "\0",
                            BackgroundTransparency = 1,
                            Size = UDim2New(1, 0, 0, 45),
                            BorderColor3 = FromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })

                        SubItems["PlayerName"] = Instances:Create("TextLabel", {
                            Parent = SubItems["Message1"].Instance,
                            Name = "\0",
                            FontFace = Library.Font,
                            TextColor3 = FromRGB(255, 255, 255),
                            BorderColor3 = FromRGB(0, 0, 0),
                            Text = Username,
                            AnchorPoint = Vector2New(1, 0),
                            Size = UDim2New(0, 0, 0, 15),
                            BackgroundTransparency = 1,
                            Position = UDim2New(1, -38, 0, 0),
                            BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.X,
                            TextSize = 14,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })  SubItems["PlayerName"]:AddToTheme({TextColor3 = "Text"})

                        SubItems["RealMessage"] = Instances:Create("Frame", {
                            Parent = SubItems["Message1"].Instance,
                            Name = "\0",
                            AnchorPoint = Vector2New(1, 0),
                            Position = UDim2New(1, -38, 0, 20),
                            BorderColor3 = FromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.XY,
                            BackgroundColor3 = FromRGB(22, 25, 29)
                        })  SubItems["RealMessage"]:AddToTheme({BackgroundColor3 = "Inline"})

                        Instances:Create("UISizeConstraint", {
                            Parent = SubItems["RealMessage"].Instance,
                            Name = "\0",
                            MaxSize = Vector2New(370, 75)
                        })

                        Instances:Create("UICorner", {
                            Parent = SubItems["RealMessage"].Instance,
                            Name = "\0",
                            CornerRadius = UDimNew(0, 4)
                        })

                        SubItems["MessageText"] = Instances:Create("TextLabel", {
                            Parent = SubItems["RealMessage"].Instance,
                            Name = "\0",
                            FontFace = Library.Font,
                            TextColor3 = FromRGB(255, 255, 255),
                            BorderColor3 = FromRGB(0, 0, 0),
                            Text = Message,
                            BackgroundTransparency = 1,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.XY,
                            TextWrapped = true,
                            TextSize = 14,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })  SubItems["MessageText"]:AddToTheme({TextColor3 = "Text"})

                        Instances:Create("UIPadding", {
                            Parent = SubItems["RealMessage"].Instance,
                            Name = "\0",
                            PaddingTop = UDimNew(0, 8),
                            PaddingBottom = UDimNew(0, 8),
                            PaddingRight = UDimNew(0, 8),
                            PaddingLeft = UDimNew(0, 8)
                        })

                        SubItems["Avatar"] = Instances:Create("ImageLabel", {
                            Parent = SubItems["Message1"].Instance,
                            Name = "\0",
                            BorderColor3 = FromRGB(0, 0, 0),
                            AnchorPoint = Vector2New(1, 0.5),
                            Image = Avatar,
                            BackgroundTransparency = 1,
                            Position = UDim2New(1, 0, 0.5, 0),
                            Size = UDim2New(0, 30, 0, 30),
                            BorderSizePixel = 0,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })

                        Instances:Create("UICorner", {
                            Parent = SubItems["Avatar"].Instance,
                            Name = "\0",
                            CornerRadius = UDimNew(0, 4)
                        })
                    end
                end
            end

            Items["SendMessageButton"]:Connect("MouseButton1Down", function()
                if GlobalChat:GetTypedMessage() == "" then
                    return
                end
                
                OnMessagePressed()
                Items["SendMessageButton"]:Tween(nil, {BackgroundColor3 = Library:GetDarkerColor(Library.Theme.Accent)})
                task.wait(0.1)
                Items["SendMessageButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)

            Items["SendMessageButton"]:Connect("MouseEnter", function()
                Items["SendMessageButton"]:Tween(nil, {BackgroundColor3 = Library:GetDarkerColor(Library.Theme.Element)})
            end)

            Items["SendMessageButton"]:Connect("MouseLeave", function()
                Items["SendMessageButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)

            Items["Input"]:Connect("MouseEnter", function()
                Items["Input"]:Tween(nil, {BackgroundColor3 = Library:GetDarkerColor(Library.Theme.Element)})
            end)

            Items["Input"]:Connect("MouseLeave", function()
                Items["Input"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)

            Items["Messages"]:Connect("ChildAdded", function()
                wait() -- wait so we ensure the child is added
                Items["Messages"]:Tween(nil, {CanvasPosition = Vector2New(0, Items["Messages"].Instance.AbsoluteCanvasSize.Y - Items["Messages"].Instance.AbsoluteSize.Y)})
            end)

            return GlobalChat 
        end
        
        Library.Notification = function(self, Data)
            Data = Data or { }

            local Notification = {
                Name = Data.Name or Data.name or "Title",
                Description = Data.Description or Data.description or "Description",
                Duration = Data.Duration or Data.duration or 5,
                Icon = Data.Icon or Data.icon or "9080568477801",
                IconColor = Data.IconColor or Data.iconcolor or FromRGB(255, 255, 255),
            }

            local Items = { } do
                Items["Notification"] = Instances:Create("Frame", {
                    Parent = Library.NotifHolder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background"})

                Instances:Create("UIStroke", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    Color = FromRGB(32, 36, 42),
                    Transparency = 0.4000000059604645,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UICorner", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                if Notification.Icon then 
                    Items["Icon"] = Instances:Create("ImageLabel", {
                        Parent = Items["Notification"].Instance,
                        Name = "\0",
                        ImageColor3 = Notification.IconColor,
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(1, 0),
                        Image = "rbxassetid://"..Notification.Icon,
                        BackgroundTransparency = 1,
                        Position = UDim2New(1, 5, 0, 0),
                        Size = UDim2New(0, 22, 0, 22),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                end

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Notification.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 2),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

                Items["Description"] = Instances:Create("TextLabel", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = Notification.Description,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 24),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Description"]:AddToTheme({TextColor3 = "Inactive Text"})
            end

            local OldSize = Items["Notification"].Instance.AbsoluteSize
            Items["Notification"].Instance.BackgroundTransparency = 1
            Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)

            for Index, Value in Items["Notification"].Instance:GetDescendants() do
                if Value:IsA("UIStroke") then 
                    Value.Transparency = 1
                elseif Value:IsA("TextLabel") then 
                    Value.TextTransparency = 1
                elseif Value:IsA("ImageLabel") then 
                    Value.ImageTransparency = 1
                elseif Value:IsA("Frame") then 
                    Value.BackgroundTransparency = 1
                end
            end
            
            task.wait(0.2)

            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None

            Library:Thread(function()
                Items["Notification"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0,  OldSize.X, 0, OldSize.Y)})
                
                task.wait(0.06)

                for Index, Value in Items["Notification"].Instance:GetDescendants() do
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 0}, true)
                    elseif Value:IsA("TextLabel") then
                        Tween:Create(Value, nil, {TextTransparency = 0}, true)
                    elseif Value:IsA("ImageLabel") then
                        Tween:Create(Value, nil, {ImageTransparency = 0}, true)
                    elseif Value:IsA("Frame") then
                        Tween:Create(Value, nil, {BackgroundTransparency = 0}, true)
                    end
                end

                task.delay(Data.Duration, function()
                    for Index, Value in Items["Notification"].Instance:GetDescendants() do
                        if Value:IsA("UIStroke") then
                            Tween:Create(Value, nil, {Transparency = 1}, true)
                        elseif Value:IsA("TextLabel") then
                            Tween:Create(Value, nil, {TextTransparency = 1}, true)
                        elseif Value:IsA("ImageLabel") then
                            Tween:Create(Value, nil, {ImageTransparency = 1}, true)
                        elseif Value:IsA("Frame") then
                            Tween:Create(Value, nil, {BackgroundTransparency = 1}, true)
                        end
                    end

                    task.wait(0.06)

                    Items["Notification"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0)})

                    task.wait(0.5)
                    Items["Notification"]:Clean()
                end)
            end)

            return Notification
        end

        Library.Watermark = function(self, Text, Logo)
            local Watermark = { }

            local Items = { } do
                Items["Watermark"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0),
                    Position = UDim2New(0.5, 0, 0, 15),
                    Size = UDim2New(0, 100, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["Watermark"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["Watermark"]:MakeDraggable()

                Instances:Create("UIGradient", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Instances:Create("UICorner", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(196, 231, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 22, 0, 22),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://"..Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 7, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Logo"]:AddToTheme({ImageColor3 = "Accent"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Text,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 35, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIPadding", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 7)
                })
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            return Watermark 
        end

        Library.KeybindsList = function(self)
            local KeybindList = { }
            self.KeyList = KeybindList

            local Items = { } do
                Items["KeybindsList"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 15, 0.5, 85),
                    Size = UDim2New(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["KeybindsList"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["KeybindsList"]:MakeDraggable()

                Instances:Create("UICorner", {
                    Parent = Items["KeybindsList"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["KeybindsList"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["KeybindsList"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(196, 231, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = "rbxassetid://89224403789635",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 22, 0, 22),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Accent"})  

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["KeybindsList"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "keybinds",
                    Size = UDim2New(0, 0, 0, 15),
                    Position = UDim2New(0, 28, 0, 3),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIPadding", {
                    Parent = Items["KeybindsList"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["KeybindsList"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 28),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function KeybindList:Add(Key, Name)
                local NewKey = Instances:Create("TextLabel", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = "(" .. Key .. ") - ".. Name .. "",
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  NewKey:AddToTheme({TextColor3 = "Text"})

                local NewKeyStatus = Instances:Create("TextLabel", {
                    Parent = NewKey.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = "off",
                    Size = UDim2New(0, 0, 0, 20),
                    AnchorPoint = Vector2New(1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 50, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  NewKeyStatus:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIPadding", {
                    Parent = NewKey.Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 50)
                })

                function NewKey:SetText(Key, Name)
                    NewKey.Instance.Text =  "(" .. Key .. ") - ".. Name .. ""
                end

                function NewKey:SetStatus(Status)
                    NewKeyStatus.Instance.Text = Status
                end

                function NewKey:Remove()
                    NewKey:Clean()
                end

                function NewKey:SetVisibility(Bool)
                    NewKey.Instance.Visible = Bool
                end

                function NewKey:Set(Bool)
                    if Bool then 
                        NewKey:Tween(nil, {TextTransparency = 0})
                        NewKeyStatus:Tween(nil, {TextTransparency = 0})
                    else 
                        NewKey:Tween(nil, {TextTransparency = 0.5})
                        NewKeyStatus:Tween(nil, {TextTransparency = 0.5})
                    end
                end

                return NewKey
            end

            function KeybindList:SetVisibility(Bool)
                Items["KeybindsList"].Instance.Visible = Bool
            end

            return KeybindList
        end 

        Library.Window = function(self, Data)
            Data = Data or { }

            local Window = {
                Name = Data.Name or Data.name or "kiwisense",
                Logo = Data.Logo or Data.logo or "135215559087473",
                FadeSpeed = Data.FadeSpeed or Data.fadespeed or 0.2,
                Version = Data.Version or Data.version or "v1.0.0 alpha",
                Size = not IsMobile and UDim2New(0, 659, 0, 511) or UDim2New(0, 511, 0, 459),

                Pages = { },
                SubPages = { },

                Items = { },
                IsOpen = false
            }

            local Items = { } do
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0),
                    Position = UDim2New(0, Camera.ViewportSize.X / 3.5, 0, Camera.ViewportSize.Y / 3.5),
                    Size = Window.Size,
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2New(Window.Size.X.Offset, Window.Size.Y.Offset), Vector2New(9999, 9999))

                Instances:Create("UICorner", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["Pages"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0),
                    BorderSizePixel = 0,
                    Position = UDim2New(0.5, 0, 1, 8),
                    Size = UDim2New(0, 0, 0, 45),
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["Pages"]:AddToTheme({BackgroundColor3 = "Background"})

                Instances:Create("UICorner", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Holder"] = Instances:Create("Frame", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDimNew(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Shadow"] = Instances:Create("ImageLabel", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(0, 0, 0),
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.8999999761581421,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                })  Items["Shadow"]:AddToTheme({ImageColor3 = "Shadow"})

                Items["Topbar"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 35),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                })  Items["Topbar"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UICorner", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("Frame", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 3),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                }):AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("Frame", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    BackgroundTransparency = 0.4,
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(32, 36, 42)
                }):AddToTheme({BackgroundColor3 = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(196, 231, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 22, 0, 22),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://"..Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 7, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Logo"]:AddToTheme({ImageColor3 = "Accent"})

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    AnchorPoint = Vector2New(0, 0.5),
                    ZIndex = 2,
                    TextSize = 14,
                    Size = UDim2New(0, 0, 0, 15),
                    RichText = true,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Window.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 37, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

                Items["Version"] = Instances:Create("Frame", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    Position = UDim2New(1, 5, 0, 1),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["Version"]:AddToTheme({BackgroundColor3 = "Background"})

                Instances:Create("UIPadding", {
                    Parent = Items["Version"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 6)
                })

                Items["VersionText"] = Instances:Create("TextLabel", {
                    Parent = Items["Version"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = Window.Version,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    Position = UDim2New(0, -2, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["VersionText"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UICorner", {
                    Parent = Items["Version"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Version"].Instance,
                    Name = "\0",
                    Color = FromRGB(32, 36, 42),
                    Transparency = 0.4000000059604645,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UIPadding", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 0)
                })

                Items["CloseButton"] = Instances:Create("ImageButton", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 17, 0, 17),
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://76001605964586",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -7, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["CloseButton"]:AddToTheme({ImageColor3 = "Image"})

                Items["MinimizeButton"] = Instances:Create("ImageButton", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 17, 0, 17),
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://94817928404736",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -27, 0.5, -5),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["MinimizeButton"]:AddToTheme({ImageColor3 = "Image"})

                Items["UnMinimizeButton"] = Instances:Create("ImageButton", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 17, 0, 17),
                    ImageTransparency = 1,
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://77419631183448",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -27, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["UnMinimizeButton"]:AddToTheme({ImageColor3 = "Image"})

                Instances:Create("UIStroke", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Color = FromRGB(32, 36, 42),
                    Transparency = 0.4000000059604645,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 35),
                    Size = UDim2New(1, 0, 1, -35),
                    ClipsDescendants = true,
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Search"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 250, 0, 32),
                    Position = UDim2New(0, 8, 0, 8),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                })  Items["Search"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UIGradient", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Instances:Create("UICorner", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    Color = FromRGB(32, 36, 42),
                    Transparency = 0.4000000059604645,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["SearchIcon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 0.5,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 20, 0, 20),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://71924825350727",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["SearchIcon"]:AddToTheme({ImageColor3 = "Image"})

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    AnchorPoint = Vector2New(0, 0.5),
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    PlaceholderText = "search",
                    TextSize = 14,
                    Size = UDim2New(1, -45, 0, 15),
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    ZIndex = 2,
                    Position = UDim2New(0, 35, 0.5, -2),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = FromRGB(255, 255, 255),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Inactive Text"})

                if IsMobile then 
                    Items["FloatingButton"] = Instances:Create("TextButton", {
                        Parent = Library.Holder.Instance,
                        Text = "",
                        AutoButtonColor = false,
                        Name = "\0",
                        Position = UDim2New(0, 125, 0, 125),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(0, 50, 0, 50),
                        BorderSizePixel = 0,
                        ZIndex = 127,
                        BackgroundColor3 = Library.Theme.Background
                    })  Items["FloatingButton"]:AddToTheme({BackgroundColor3 = "Background"})

                    Items["FloatingButton"]:MakeDraggable()

                    Instances:Create("ImageLabel", {
                        Parent = Items["FloatingButton"].Instance,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Name = "\0",
                        Image = "rbxassetid://" .. Window.Logo,
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2New(0.5, 0.5),
                        Position = UDim2New(0.5, 0, 0.5, 0),
                        ZIndex = 127,
                        Size = UDim2New(1, -25, 1, -25),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Instances:Create("UICorner", {
                        Parent = Items["FloatingButton"].Instance,
                        CornerRadius = UDimNew(1, 0)
                    }) 

                    Items["FloatingButton"]:Connect("InputBegan", function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                            Window:SetOpen(not Window.IsOpen)
                        end
                    end)
                end

                UserInputService.MouseIconEnabled = false

                Items["MouseImage"] = Instances:Create("ImageLabel", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = "rbxassetid://136489814131946",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 0),
                    Size = UDim2New(0, 20, 0, 20),
                    ZIndex = 99999,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["MouseImage"]:AddToTheme({ImageColor3 = "Accent"})

                Library:Connect(RunService.RenderStepped, function()
                    local MouseLocation = UserInputService:GetMouseLocation() 
                    Items["MouseImage"].Instance.Position = UDim2New(0, MouseLocation.X - 1, 0, MouseLocation.Y - 56)
                end)
            end

            local Debounce = false 
            local OldSizes = { }

            function Window:AddToOldSizes(Item, Size)
                if not OldSizes[Item] then
                    OldSizes[Item] = Size
                end
            end

            function Window:GetOldSize(Item)
                if OldSizes[Item] then
                    return OldSizes[Item]
                end
            end

            function Window:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Window.IsOpen = Bool

                Debounce = true

                if Bool then 
                    Items["MainFrame"].Instance.Visible = true
                end

                local Descendants = Items["MainFrame"].Instance:GetDescendants()
                TableInsert(Descendants, Items["MainFrame"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then 
                        continue
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Window.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Window.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    Items["MainFrame"].Instance.Visible = Bool

                    if Window.IsOpen then
                        Items["MouseImage"].Instance.Visible = true
                        UserInputService.MouseIconEnabled = false 
                    else
                        Items["MouseImage"].Instance.Visible = false
                        UserInputService.MouseIconEnabled = true 
                    end
                end)
            end

            function Window:SetText(Text)
                Items["Title"].Instance.Text = Text
            end

            Library:Connect(UserInputService.InputBegan, function(Input, GameProcessedEvent)
                if GameProcessedEvent then 
                    return 
                end

                if tostring(Input.KeyCode) == Library.MenuKeybind 
                or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            local RenderStepped

            Items["Input"]:Connect("Focused", function()
                local PageSearchData = Library.SearchItems[Library.CurrentPage]

                if not PageSearchData then
                    return 
                end

                RenderStepped = RunService.RenderStepped:Connect(function()
                    for Index, Value in PageSearchData do 
                        local Name = Value.Name
                        local Element = Value.Item

                        if StringFind(StringLower(Name), StringLower(Items["Input"].Instance.Text)) then
                            if Items["Input"].Instance.Text ~= "" then 
                                Element.Instance.Visible  = true 
                                Element:Tween(nil, {Size = Window:GetOldSize(Element)})
                            else
                                Element.Instance.Visible  = true 
                                Element:Tween(nil, {Size = Window:GetOldSize(Element)})
                            end
                        else
                            Window:AddToOldSizes(Element, Element.Instance.Size)
                            Element:Tween(nil, {Size = UDim2New(Window:GetOldSize(Element).X.Scale, Window:GetOldSize(Element).X.Offset, 0, 0)})
                            task.wait(0.1)
                            Element.Instance.Visible = false
                        end
                    end
                end)
            end)

            Items["Input"]:Connect("FocusLost", function()
                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end)
            
            local IsMinimized = false
            local OldSize = Items["MainFrame"].Instance.AbsoluteSize

            Items["MinimizeButton"]:Connect("MouseButton1Down", function()
                IsMinimized = not IsMinimized

                if IsMinimized then
                    OldSize = Items["MainFrame"].Instance.AbsoluteSize
                    Items["MainFrame"]:Tween(nil, {Size = UDim2New(0, Items["MainFrame"].Instance.Size.X.Offset, 0, 35)})
                    Items["MinimizeButton"]:Tween(nil, {ImageTransparency = 1})
                    Items["UnMinimizeButton"]:Tween(nil, {ImageTransparency = 0})
                else
                    Items["MainFrame"]:Tween(nil, {Size = UDim2New(0, Items["MainFrame"].Instance.Size.X.Offset, 0, OldSize.Y)})
                    Items["MinimizeButton"]:Tween(nil, {ImageTransparency = 0})
                    Items["UnMinimizeButton"]:Tween(nil, {ImageTransparency = 1})
                end
            end)

            Items["CloseButton"]:Connect("MouseButton1Down", function()
                Window:SetOpen(false)
                task.wait(0.1)
                Library:Unload()
            end)

            Window.Items = Items

            Window:SetOpen(true)
            return setmetatable(Window, self)
        end

        Library.Page = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self,

                Name = Data.Name or Data.name or "combat",
                Icon = Data.Icon or Data.icon or "111178525804834",
                Columns = Data.Columns or Data.columns or 2,
                SubPages = Data.SubPages or Data.subpages or false,

                Active = false,

                Items = { },
                ColumnsData =  { },

                SubPagesStack = { }
            }

            Library.SearchItems[Page] = { }

            local Items = { } do
                Items["PageContent"] = Instances:Create("Frame", {
                    Parent = Page.Window.Items["Content"].Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Columns"] = Instances:Create("Frame", {
                    Parent = Items["PageContent"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 7, 0, 48),
                    Size = UDim2New(1, -14, 1, -55),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Columns"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })

                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["Holder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 32),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(23, 26, 30)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UICorner", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    ImageTransparency = 0.5,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 22, 0, 22),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://"..Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 5, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Image"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Visible = false,
                    Active = true,
                    AnchorPoint = Vector2New(0, 0.5),
                    ZIndex = 2,
                    TextSize = 14,
                    Size = UDim2New(0, 0, 0, 15),
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Page.Name,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 32, 0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIPadding", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 7)
                })

                if not Page.SubPages then
                    for Index = 1, Page.Columns do 
                        local NewColumn = Instances:Create("ScrollingFrame", {
                            Parent = Items["Columns"].Instance,
                            Name = "\0",
                            ScrollBarImageColor3 = FromRGB(0, 0, 0),
                            Active = true,
                            AutomaticCanvasSize = Enum.AutomaticSize.Y,
                            ScrollBarThickness = 0,
                            BorderColor3 = FromRGB(0, 0, 0),
                            BackgroundTransparency = 1,
                            Size = UDim2New(0, 100, 0, 100),
                            BackgroundColor3 = FromRGB(255, 255, 255),
                            ZIndex = 2,
                            BorderSizePixel = 0,
                            CanvasSize = UDim2New(0, 0, 0, 0)
                        })

                        Instances:Create("UIPadding", {
                            Parent = NewColumn.Instance,
                            Name = "\0",
                            PaddingBottom = UDimNew(0, 8)
                        })

                        Instances:Create("UIListLayout", {
                            Parent = NewColumn.Instance,
                            Name = "\0",
                            Padding = UDimNew(0, 14),
                            SortOrder = Enum.SortOrder.LayoutOrder
                        })
                        
                        Page.ColumnsData[Index] = NewColumn
                    end
                end

                if Page.SubPages then 
                    Items["Columns"].Instance.Size = UDim2New(1, -14, 1, -108)

                    Items["SubPages"] = Instances:Create("Frame", {
                        Parent = Items["PageContent"].Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0.5, 1),
                        BorderSizePixel = 0,
                        Position = UDim2New(0.5, 0, 1, -8),
                        Size = UDim2New(0, 0, 0, 45),
                        ZIndex = 2,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = FromRGB(22, 25, 29)
                    })  Items["SubPages"]:AddToTheme({BackgroundColor3 = "Inline"})

                    Instances:Create("UICorner", {
                        Parent = Items["SubPages"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(1, 0)
                    })

                    Items["Holder"] = Instances:Create("Frame", {
                        Parent = Items["SubPages"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 0, 1, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Instances:Create("UIPadding", {
                        Parent = Items["Holder"].Instance,
                        Name = "\0",
                        PaddingRight = UDimNew(0, 8),
                        PaddingLeft = UDimNew(0, 8)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = Items["Holder"].Instance,
                        Name = "\0",
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding = UDimNew(0, 5),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                end

                Items["Inactive"].Instance.Size = UDim2New(0, 25, 0, 32)
            end

            local Debounce = false

            function Page:Switch(Bool)
                if Debounce then 
                    return 
                end

                Page.Active = Bool
                Items["PageContent"].Instance.Visible = Bool
                Items["PageContent"].Instance.Parent = Bool and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance
                
                Debounce = true 

                if Bool then
                    Items["Text"].Instance.Visible = true 
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, Items["Text"].Instance.TextBounds.X + 38, 0, 32)})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0})

                    Library.CurrentPage = Page
                else
                    Items["Text"].Instance.Visible = false 
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 25, 0, 32)})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Image"})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Image, ImageTransparency = 0.5}) 
                end

                local Descendants = Items["PageContent"].Instance:GetDescendants()
                TableInsert(Descendants, Items["PageContent"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then 
                        continue
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Page.Window.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Page.Window.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                end)
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do
                    Value:Switch(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then 
                Page:Switch(true)
            end

            Page.Items = Items
            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Pages.SubPage = function(self, Data)
            Data = Data or { }

            local SubPage = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "SubPage",
                Icon = Data.Icon or Data.icon or "9080568477801",
                Columns = Data.Columns or Data.columns or 2,
                
                Items = { },
                ColumnsData = { }
            }

            Library.SearchItems[SubPage] = { }

            local Items = { } do
                Items["PageContent"] = Instances:Create("Frame", {
                    Parent = SubPage.Page.Items["Columns"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 2,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    Visible = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["PageContent"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })

                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = SubPage.Page.Items["Holder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 32),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Background"})

                Instances:Create("UICorner", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    ImageTransparency = 0.5,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 22, 0, 22),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://"..SubPage.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 5, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Image"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Visible = false,
                    Active = true,
                    AnchorPoint = Vector2New(0, 0.5),
                    ZIndex = 2,
                    TextSize = 14,
                    Size = UDim2New(0, 0, 0, 15),
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = SubPage.Name,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 32, 0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIPadding", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 7)
                })

                for Index = 1, SubPage.Columns do 
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["PageContent"].Instance,
                        Name = "\0",
                        ScrollBarImageColor3 = FromRGB(0, 0, 0),
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarThickness = 0,
                        BorderColor3 = FromRGB(0, 0, 0),
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 100, 0, 100),
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    })

                    Instances:Create("UIPadding", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        PaddingBottom = UDimNew(0, 8)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 14),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                    
                    SubPage.ColumnsData[Index] = NewColumn
                end
            end

            local Debounce = false

            function SubPage:Switch(Bool)
                if Debounce then 
                    return 
                end

                SubPage.Active = Bool
                Items["PageContent"].Instance.Visible = Bool
                Items["PageContent"].Instance.Parent = Bool and SubPage.Page.Items["Columns"].Instance or Library.UnusedHolder.Instance
                
                Debounce = true 

                if Bool then
                    Items["Text"].Instance.Visible = true 
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, Items["Text"].Instance.TextBounds.X + 38, 0, 32)})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0}) 

                    Library.CurrentPage = SubPage
                else
                    Items["Text"].Instance.Visible = false 
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 25, 0, 32)})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Image"})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Image, ImageTransparency = 0.5}) 
                end

                local Descendants = Items["PageContent"].Instance:GetDescendants()
                TableInsert(Descendants, Items["PageContent"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then 
                        continue
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, SubPage.Window.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, SubPage.Window.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                end)
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in SubPage.Page.SubPagesStack do
                    Value:Switch(Value == SubPage)
                end
            end)

            if #SubPage.Page.SubPagesStack == 0 then 
                SubPage:Switch(true)
            end

            SubPage.Items = Items
            TableInsert(SubPage.Page.SubPagesStack, SubPage)
            return setmetatable(SubPage, Library.Pages)
        end

        Library.Pages.Playerlist = function(self, Data)
            local Playerlist = {
                Window = self.Window,
                Page = self,

                CurrentPlayer = nil,

                Players = { }
            }

            local Dropdown

            local Items = { } do
                Playerlist.Page.Items.Columns.Instance:FindFirstChildOfClass("UIListLayout"):Destroy()

                Items["Playerlist"] = Instances:Create("Frame", {
                    Parent = Playerlist.Page.Items["PageContent"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                })  Items["Playerlist"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UICorner", {
                    Parent = Items["Playerlist"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["PlayerlistInline"] = Instances:Create("Frame", {
                    Parent = Items["Playerlist"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -16, 1, -90),
                    Position = UDim2New(0, 8, 0, 8),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["PlayerlistInline"]:AddToTheme({BackgroundColor3 = "Background"})

                Instances:Create("UICorner", {
                    Parent = Items["PlayerlistInline"].Instance,
                    Name = "\0",    
                    CornerRadius = UDimNew(0, 5)
                })

                Items["PlayerHolder"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["PlayerlistInline"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = FromRGB(32, 36, 42),
                    MidImage = "rbxassetid://107505658214891",
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 2,
                    Size = UDim2New(1, -8, 1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 4, 0, 4),
                    BottomImage = "rbxassetid://107505658214891",
                    TopImage = "rbxassetid://107505658214891",
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["PlayerHolder"]:AddToTheme({ScrollBarImageColor3 = "Border"})

                Instances:Create("UIListLayout", {
                    Parent = Items["PlayerHolder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["PlayerHolder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 4),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 4)
                })

                Items["PlayerAvatar"] = Instances:Create("ImageLabel", {
                    Parent = Items["Playerlist"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 50, 0, 50),
                    AnchorPoint = Vector2New(0, 1),
                    Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
                    Position = UDim2New(0, 8, 1, -15),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 21)
                })  Items["PlayerAvatar"]:AddToTheme({BackgroundColor3 = "Background"})

                Instances:Create("UICorner", {
                    Parent = Items["PlayerAvatar"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["PlayerUsername"] = Instances:Create("TextLabel", {
                    Parent = Items["Playerlist"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "?",
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 65, 1, -65),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["PlayerUsername"]:AddToTheme({TextColor3 = "Text"})

                Items["PlayerUserID"] = Instances:Create("TextLabel", {
                    Parent = Items["Playerlist"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "?",
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 65, 1, -50),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["PlayerUserID"]:AddToTheme({TextColor3 = "Text"})

                Items["PlayerAccountAge"] = Instances:Create("TextLabel", {
                    Parent = Items["Playerlist"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "?",
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 65, 1, -35),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["PlayerAccountAge"]:AddToTheme({TextColor3 = "Text"})
            end

            do
                local DropdownItems = { } do
                    DropdownItems["Dropdown"] = Instances:Create("Frame", {
                        Parent = Items["Playerlist"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2New(1, 1),
                        Size = UDim2New(0, 235, 0, 47),
                        Position = UDim2New(1, -8, 1, -20),
                        BorderColor3 = FromRGB(0, 0, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    DropdownItems["Text"] = Instances:Create("TextLabel", {
                        Parent = DropdownItems["Dropdown"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "Status",
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 0, 0, 15),
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  DropdownItems["Text"]:AddToTheme({TextColor3 = "Text"})

                    DropdownItems["RealDropdown"] = Instances:Create("TextButton", {
                        Parent = DropdownItems["Dropdown"].Instance,
                        Text = "", 
                        AutoButtonColor = false,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0, 1),
                        Position = UDim2New(0, 0, 1, 0),
                        Size = UDim2New(1, 0, 0, 25),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(34, 39, 45)
                    })  DropdownItems["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})

                    Instances:Create("UIGradient", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        Rotation = 84,
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                    }):AddToTheme({Color = function()
                        return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                    end})

                    Instances:Create("UICorner", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 4)
                    })

                    DropdownItems["Value"] = Instances:Create("TextLabel", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "--",
                        AutomaticSize = Enum.AutomaticSize.X,
                        Size = UDim2New(0, 0, 0, 15),
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 8, 0.5, 0),
                        BackgroundTransparency = 1,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  DropdownItems["Value"]:AddToTheme({TextColor3 = "Text"})

                    DropdownItems["OpenIcon"] = Instances:Create("ImageLabel", {
                        Parent = DropdownItems["RealDropdown"].Instance,
                        Name = "\0",
                        ImageColor3 = FromRGB(196, 231, 255),
                        ScaleType = Enum.ScaleType.Fit,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(0, 20, 0, 20),
                        AnchorPoint = Vector2New(1, 0.5),
                        Image = "rbxassetid://114252321536924",
                        BackgroundTransparency = 1,
                        Position = UDim2New(1, -3, 0.5, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  DropdownItems["OpenIcon"]:AddToTheme({ImageColor3 = "Accent"})

                    DropdownItems["OptionHolder"] = Instances:Create("TextButton", {
                        Parent = Library.Holder.Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        Visible = false,
                        AutoButtonColor = false,
                        Size = UDim2New(1, 0, 0, 50),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Position = UDim2New(0, 0, 1, 5),
                        BorderSizePixel = 0,
                        ZIndex = 5,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(22, 25, 29)
                    })  DropdownItems["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline"})

                    Instances:Create("UIGradient", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        Rotation = 84,
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                    }):AddToTheme({Color = function()
                        return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                    end})

                    Instances:Create("UIStroke", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        Color = FromRGB(32, 36, 42),
                        Transparency = 0.4000000059604645,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }):AddToTheme({Color = "Border"})

                    Instances:Create("UICorner", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 5)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 2),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    Instances:Create("UIPadding", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 8),
                        PaddingBottom = UDimNew(0, 8),
                        PaddingRight = UDimNew(0, 8),
                        PaddingLeft = UDimNew(0, 8)
                    })

                    DropdownItems["RealDropdown"]:OnHover(function()
                        DropdownItems["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.45)})
                    end)
        
                    DropdownItems["RealDropdown"]:OnHoverLeave(function()
                        DropdownItems["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                    end)
                end

                Dropdown = { 
                    IsOpen = false,
                    Value = { },
                    Options = { },
                    Multi = false
                }

                function Dropdown:AddOption(Option)
                    local OptionButton = Instances:Create("TextButton", {
                        Parent = DropdownItems["OptionHolder"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = UDim2New(1, 0, 0, 25),
                        ZIndex = 5,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(16, 18, 21)
                    })  OptionButton:AddToTheme({BackgroundColor3 = "Background"})

                    local CheckImage = Instances:Create("ImageLabel", {
                        Parent = OptionButton.Instance,
                        Name = "\0",
                        ImageColor3 = FromRGB(196, 231, 255),
                        ScaleType = Enum.ScaleType.Fit,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(0, 18, 0, 18),
                        Visible = true,
                        AnchorPoint = Vector2New(0, 0.5),
                        Image = "rbxassetid://116339777575852",
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 3, 0.5, 0),
                        ImageTransparency = 1,
                        ZIndex = 5,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  CheckImage:AddToTheme({ImageColor3 = "Accent"})

                    Instances:Create("UICorner", {
                        Parent = OptionButton.Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 5)
                    })

                    local OptionText = Instances:Create("TextLabel", {
                        Parent = OptionButton.Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextTransparency = 0.5,
                        AnchorPoint = Vector2New(0, 0.5),
                        ZIndex = 5,
                        TextSize = 14,
                        Size = UDim2New(0, 0, 0, 15),
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = Option,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutomaticSize = Enum.AutomaticSize.X,
                        Position = UDim2New(0, 7, 0.5, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  OptionText:AddToTheme({TextColor3 = "Text"})

                    local OptionData = {
                        Selected = false,
                        Name = Option,
                        Text = OptionText,
                        Button = OptionButton,
                        Check = CheckImage
                    }

                    function OptionData:Toggle(Status)
                        if Status == "Active" then 
                            OptionData.Button:Tween(nil, {BackgroundTransparency = 0})
                            OptionData.Text:Tween(nil, {TextTransparency = 0, Position = UDim2New(0, 27, 0.5, 0)})
                            OptionData.Check:Tween(nil, {ImageTransparency = 0})
                        elseif Status == "Inactive" then
                            OptionData.Button:Tween(nil, {BackgroundTransparency = 1})
                            OptionData.Text:Tween(nil, {TextTransparency = 0.5, Position = UDim2New(0, 7, 0.5, 0)})
                            OptionData.Check:Tween(nil, {ImageTransparency = 1})
                        end
                    end

                    function OptionData:Set()
                        OptionData.Selected = not OptionData.Selected

                        if Dropdown.Multi then 
                            local Index = TableFind(Dropdown.Value, OptionData.Name)

                            if Index then 
                                TableRemove(Dropdown.Value, Index)
                            else
                                TableInsert(Dropdown.Value, OptionData.Name)
                            end

                            OptionData:Toggle(Index and "Inactive" or "Active")

                            local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"

                            DropdownItems["Value"].Instance.Text = TextFormat
                        else
                            if OptionData.Selected then 
                                Dropdown.Value = OptionData.Name

                                OptionData:Toggle("Active")

                                for Index, Value in Dropdown.Options do 
                                    if Value ~= OptionData then
                                        Value.Selected = false 
                                        Value:Toggle("Inactive")
                                    end
                                end

                                DropdownItems["Value"].Instance.Text = OptionData.Name 
                            else
                                Dropdown.Value = nil

                                OptionData:Toggle("Inactive")
                                DropdownItems["Value"].Instance.Text = "--"
                            end
                        end

                        if Dropdown.Callback then 
                            Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                        end
                    end

                    OptionData.Button:Connect("MouseButton1Down", function()
                        OptionData:Set()
                    end)

                    Dropdown.Options[Option] = OptionData
                    return OptionData
                end

                local Debounce = false 
                local RenderStepped

                function Dropdown:SetOpen(Bool)
                    if Debounce then 
                        return 
                    end

                    Dropdown.IsOpen = Bool

                    Debounce = true

                    if Bool then 
                        DropdownItems["OptionHolder"].Instance.Visible = true

                        RenderStepped = RunService.RenderStepped:Connect(function()
                            DropdownItems["OptionHolder"].Instance.Position = UDim2New(0, DropdownItems["RealDropdown"].Instance.AbsolutePosition.X, 0,  DropdownItems["RealDropdown"].Instance.AbsolutePosition.Y + DropdownItems["RealDropdown"].Instance.AbsoluteSize.Y + 5)
                            DropdownItems["OptionHolder"].Instance.Size = UDim2New(0, DropdownItems["RealDropdown"].Instance.AbsoluteSize.X, 0, 85)
                        end)
                    else
                        if RenderStepped then
                            RenderStepped:Disconnect()
                            RenderStepped = nil
                        end
                    end

                    local Descendants = DropdownItems["OptionHolder"].Instance:GetDescendants()
                    TableInsert(Descendants, DropdownItems["OptionHolder"].Instance)

                    local NewTween

                    for Index, Value in Descendants do 
                        local TransparencyProperty = Tween:GetProperty(Value)

                        if not TransparencyProperty then 
                            continue
                        end

                        if StringFind(Value.ClassName, "UI") then
                            continue
                        end

                        Value.ZIndex = Bool and 10 or 0

                        if type(TransparencyProperty) == "table" then 
                            for _, Property in TransparencyProperty do 
                                NewTween = Tween:FadeItem(Value, Property, Bool, Playerlist.Window.FadeSpeed)
                            end
                        else
                            NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Playerlist.Window.FadeSpeed)
                        end
                    end

                    Library:Connect(NewTween.Tween.Completed, function()
                        Debounce = false
                        DropdownItems["OptionHolder"].Instance.Visible = Bool
                    end)
                end

                function Dropdown:Set(Option)
                    if Dropdown.Multi then
                        if type(Option) ~= "table" then
                            return
                        end

                        Dropdown.Value = Option
                        Library.Flags[Dropdown.Flag] = Option

                        for Index, Value in Option do 
                            local OptionData = Dropdown.Options[Value]
                                
                            if not OptionData then 
                                return
                            end

                            OptionData.Selected = true
                            OptionData:Toggle("Active")
                        end

                        DropdownItems["Value"].Instance.Text = TableConcat(Option, ", ")
                    else
                        if not Dropdown.Options[Option] then 
                            return
                        end

                        local OptionData = Dropdown.Options[Option]

                        Dropdown.Value = OptionData.Name
                        Library.Flags[Dropdown.Flag] = OptionData.Name

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then
                                Value.Selected = false 
                                Value:Toggle("Inactive")
                            else
                                Value.Selected = true 
                                Value:Toggle("Active")
                            end
                        end

                        DropdownItems["Value"].Instance.Text = OptionData.Name
                    end

                    if Dropdown.Callback then 
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                DropdownItems["RealDropdown"]:Connect("MouseButton1Down", function()
                    Dropdown:SetOpen(not Dropdown.IsOpen)
                end)

                Dropdown:AddOption("Neutral")
                Dropdown:AddOption("Priority")
                Dropdown:AddOption("Friendly")
            end

            function Playerlist:Add(Player)
                local PlayerItems = { }

                PlayerItems["NewPlayer"] = Instances:Create("TextButton", {
                    Parent = Items["PlayerHolder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    ZIndex = 2,
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(22, 25, 24)
                })  PlayerItems["NewPlayer"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UICorner", {
                    Parent = PlayerItems["NewPlayer"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                PlayerItems["Name"] = Instances:Create("TextLabel", {
                    Parent = PlayerItems["NewPlayer"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.4000000059604645,
                                        ZIndex = 2,
                    Text = Player.Name,
                    Size = UDim2New(0.3499999940395355, 0, 0, 15),
                    Position = UDim2New(0, 10, 0.5, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                PlayerItems["Status"] = Instances:Create("TextLabel", {
                    Parent = PlayerItems["NewPlayer"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                                        ZIndex = 2,
                    TextTransparency = 0.4000000059604645,
                    Text = "Neutral",
                    Size = UDim2New(0.3499999940395355, 0, 0, 15),
                    Position = UDim2New(0.699999988079071, 10, 0.5, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                local Team = Player.Team ~= nil and Player.Team.Name or "None"
                local TeamColor = Player.TeamColor ~= nil and Player.TeamColor.Color or Color3.new(1, 1, 1)

                PlayerItems["Team"] = Instances:Create("TextLabel", {
                    Parent = PlayerItems["NewPlayer"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = TeamColor,
                    TextTransparency = 0.4000000059604645,
                    Text = Team,
                    Size = UDim2New(0.3499999940395355, 0, 0, 15),
                    Position = UDim2New(0.3499999940395355, 10, 0.5, 0),
                                        ZIndex = 2,
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                if Player == LocalPlayer then
                    PlayerItems["Status"].Instance.TextColor3 = Library.Theme.Accent
                    PlayerItems["Status"].Instance.Text = "LocalPlayer"
                    PlayerItems["Status"]:AddToTheme({TextColor3 = "Accent"})
                end

                local PlayerData = {
                    Name = Player.Name,
                    Selected = false,
                    PlayerButton = PlayerItems["NewPlayer"],
                    PlayerName = PlayerItems["Name"],
                    PlayerTeam = PlayerItems["Team"],
                    PlayerStatus = PlayerItems["Status"],
                    Player = Player
                }

                function PlayerData:Toggle(Status)
                    if Status == "Active" then
                        PlayerItems["Name"]:Tween(nil, {TextTransparency = 0})
                        PlayerItems["Status"]:Tween(nil, {TextTransparency = 0})
                        PlayerItems["Team"]:Tween(nil, {TextTransparency = 0})
                        PlayerItems["NewPlayer"]:Tween(nil, {BackgroundTransparency = 0})
                    else
                        PlayerItems["Name"]:Tween(nil, {TextTransparency = 0.4})
                        PlayerItems["Status"]:Tween(nil, {TextTransparency = 0.4})
                        PlayerItems["Team"]:Tween(nil, {TextTransparency = 0.4})
                        PlayerItems["NewPlayer"]:Tween(nil, {BackgroundTransparency = 1})
                    end
                end

                function PlayerData:Set()
                    PlayerData.Selected = not PlayerData.Selected

                    if PlayerData.Selected then
                        Playerlist.Player = PlayerData.Player

                        for Index, Value in Playerlist.Players do 
                            Value.Selected = false
                            Value:Toggle("Inactive")
                        end

                        PlayerData:Toggle("Active")

                        local PlayerAvatar = Players:GetUserThumbnailAsync(Playerlist.Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                        Items["PlayerAvatar"].Instance.Image = PlayerAvatar
                        Items["PlayerUsername"].Instance.Text = Playerlist.Player.DisplayName .. " (@" .. Playerlist.Player.Name .. ")"
                        Items["PlayerUserID"].Instance.Text = tostring(Playerlist.Player.UserId)
                        Items["PlayerAccountAge"].Instance.Text = tostring(Playerlist.Player.AccountAge) .. " days old"
                    else
                        --print("this shit rigged")
                        Playerlist.Player = nil
                        PlayerData:Toggle("Inactive")
                        Items["PlayerAvatar"].Instance.Image = "rbxassetid://98200387761744"
                        Items["PlayerUsername"].Instance.Text = "None"
                        Items["PlayerUserID"].Instance.Text = "None"
                        Items["PlayerAccountAge"].Instance.Text = "None"
                    end

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Playerlist.Player, PlayerData.PlayerStatus.Instance.Text, PlayerData.PlayerTeam.Instance.Text)
                    end
                end

                PlayerItems["NewPlayer"]:Connect("MouseButton1Down", function()
                    PlayerData:Set()
                end)

                PlayerItems["NewPlayer"]:OnHover(function()
                end)

                Playerlist.Players[Player.Name] = PlayerData
                return PlayerData
            end

            function Playerlist:Remove(Name)
                if Playerlist.Players[Name] then
                    Playerlist.Players[Name].PlayerButton:Clean()
                end
                
                Playerlist.Players[Name] = nil
            end

            Dropdown.Callback = function(Value) -- horrible code ik
                if Playerlist.Player then
                    if Playerlist.Player == LocalPlayer then
                        return
                    end

                    if Value == "Neutral" then
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus:Tween(nil, {
                            TextColor3 = Library.Theme["Inactive Text"]
                        })

                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus.Instance.Text = "Neutral"
                    elseif Value == "Priority" then
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus:Tween(nil, {
                            TextColor3 = FromRGB(255, 50, 50)
                        })

                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus.Instance.Text = "Priority"
                    elseif Value == "Friendly" then
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus:Tween(nil, {
                            TextColor3 = FromRGB(83, 255, 83)
                        })

                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus.Instance.Text = "Friendly"
                    else
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus:Tween(nil, {
                            TextColor3 = Library.Theme["Inactive Text"]
                        })

                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus.Instance.Text = "Neutral"
                    end
                end
            end

            for Index, Value in Players:GetPlayers() do 
                Playerlist:Add(Value)
            end

            Library:Connect(Players.PlayerRemoving, function(Player)
                if Playerlist.Players[Player.Name] then 
                    Playerlist:Remove(Player.Name)
                end
            end)

            Library:Connect(Players.PlayerAdded, function(Player)
                Playerlist:Add(Player)
            end)

            return Playerlist
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",
                Side = Data.Side or Data.side or 1,
                Icon = Data.Icon or Data.icon or "9080568477801",

                Items = { }
            }

            local Items = { } do
                Items["Section"] = Instances:Create("Frame", {
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Name = "\0",
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 55),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UICorner", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Items["Topbar"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 35),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                })  Items["Topbar"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UICorner", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Instances:Create("Frame", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 3),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 25, 29)
                }):AddToTheme({BackgroundColor3 = "Inline"})

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(1, -125, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 8, 0.5, 0),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(196, 231, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 18, 0, 18),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://"..Section.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -7, 0.5, -1),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Accent"})

                Instances:Create("Frame", {
                    Parent = Items["Topbar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    BackgroundTransparency = 0.4000000059604645,
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(32, 36, 42)
                }):AddToTheme({BackgroundColor3 = "Border"})

                Instances:Create("UIPadding", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 8)
                })

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 45),
                    Size = UDim2New(1, -16, 0, 0),
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            Section.Items = Items
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
                Tooltip = Data.Tooltip or Data.tooltip or nil,

                Count = 0
            }

            local NewToggle, ToggleItems = Components.Toggle({
                Name = Toggle.Name,
                Parent = Toggle.Section.Items["Content"],
                Flag = Toggle.Flag,
                Default = Toggle.Default,
                Page = Toggle.Page,
                Callback = Toggle.Callback
            })

            ToggleItems["Toggle"]:Tooltip(Toggle.Tooltip)

            function Toggle:Set(Bool)
                NewToggle:Set(Bool)
            end

            function Toggle:Get()
                return NewToggle:Get()
            end

            function Toggle:SetVisibility(Bool)
                NewToggle:SetVisibility(Bool)
            end

            function Toggle:Colorpicker(Data)
                local Colorpicker = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,

                    Name = Data.Name or Data.name,
                    Default = Data.Default or Data.default,
                    Alpha = Data.Alpha or Data.alpha or 0,
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Callback = Data.Callback or Data.callback or function() end,
                    
                    Count = Toggle.Count
                }
                
                Toggle.Count += 1
                Colorpicker.Count = Toggle.Count

                local NewColorpicker, ColorpickerItems = Components.Colorpicker({
                    Window = Colorpicker.Window,
                    Page = Colorpicker.Page,
                    Parent = ToggleItems["SubElements"],
                    Name = Colorpicker.Name,
                    Flag = Colorpicker.Flag,
                    IsToggle = true,
                    Default = Colorpicker.Default,
                    Alpha = Colorpicker.Alpha,
                    Callback = Colorpicker.Callback,
                    Count = Colorpicker.Count
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
                    Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",
                }

                local NewKeybind, KeybindItems = Components.Keybind({
                    Name = Keybind.Name,
                    Parent = ToggleItems["Toggle"],
                    Window = Toggle.Window,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    IsToggle = true,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            return Toggle
        end

        Library.Sections.Button = function(self, Data)
            Data = Data or { }

            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end,
                Tooltip = Data.Tooltip or Data.tooltip or nil
            }

            local Items = { } do
                Items["Button"] = Instances:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 30),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(34, 39, 45)
                })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element"})

                Items["Button"]:Tooltip(Button.Tooltip)

                Items["Button"]:OnHover(function()
                    Items["Button"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.45)})
                end)
    
                Items["Button"]:OnHoverLeave(function()
                    Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                end)    

                Instances:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            end

            function Button:Press()
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

                task.wait(0.1)
                Library:SafeCall(Button.Callback)

                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            local SearchData = {
                Name = Button.Name,
                Item = Items["Button"]
            }

            local PageSearchData = Library.SearchItems[Button.Page]

            if not PageSearchData then
                return
            end

            TableInsert(PageSearchData, SearchData)

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            local Slider = { 
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Min = Data.Min or Data.min or 0,
                Max = Data.Max or Data.max or 100,
                Suffix = Data.Suffix or Data.suffix or "",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or 0,
                Decimals = Data.Decimals or Data.decimals or 1,
                Tooltip = Data.Tooltip or Data.tooltip or nil,
                Callback = Data.Callback or Data.callback or function() end,

                Sliding = false,
                Value = 0
            }

            local Items = { } do
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 38),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Slider"]:Tooltip(Slider.Tooltip)

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    AutoButtonColor = false,
                    Text = "",
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 15),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(34, 39, 45)
                })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element"})

                Items["RealSlider"]:OnHover(function()
                    Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.45)})
                end)
    
                Items["RealSlider"]:OnHoverLeave(function()
                    Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                end)   

                Instances:Create("UICorner", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Size = UDim2New(0.5, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(196, 231, 255)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme["Dark Gradient"])}
                end})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutomaticSize = Enum.AutomaticSize.X,
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
            end

            function Slider:Get()
                return Slider.Value
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                Library.Flags[Slider.Flag] = Slider.Value

                Items["Accent"]:Tween(TweenInfo.new(0.21, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})
                Items["Value"].Instance.Text = StringFormat("%s%s", tostring(Slider.Value), Slider.Suffix)

                if Slider.Callback then 
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            getgenv().Options[Slider.Flag] = Slider

            local SearchData = {
                Name = Slider.Name,
                Item = Items["Slider"]
            }

            local PageSearchData = Library.SearchItems[Slider.Page]

            if not PageSearchData then 
                return 
            end

            TableInsert(PageSearchData, SearchData)

            local InputChanged

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true 

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
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
                Default = Data.Default or Data.default or nil,
                Items = Data.Items or Data.items or { "One", "Two", "Three" },
                Callback = Data.Callback or Data.callback or function() end,
                Multi = Data.Multi or Data.multi or false,
                MaxSize = Data.MaxSize or Data.maxsize or 85,
                Tooltip = Data.Tooltip or Data.tooltip or nil
            }

            local NewDropdown, DropdownItems = Components.Dropdown({
                Window = Dropdown.Window,
                Page = Dropdown.Page,
                Parent = Dropdown.Section.Items["Content"],
                Callback = Dropdown.Callback,
                Name = Dropdown.Name,
                Flag = Dropdown.Flag,
                Items = Dropdown.Items,
                Default = Dropdown.Default,
                Multi = Dropdown.Multi,
                MaxSize = Dropdown.MaxSize or 65
            })  

            DropdownItems["Dropdown"]:Tooltip(Dropdown.Tooltip)

            function Dropdown:Set(Value)
                NewDropdown:Set(Value)
            end

            function Dropdown:Get()
                return NewDropdown:Get()
            end

            function Dropdown:AddOption(Option)
                return NewDropdown:AddOption(Option)
            end

            function Dropdown:RemoveOption(Option)
                return NewDropdown:RemoveOption(Option)
            end

            function Dropdown:Refresh(List)
                return NewDropdown:Refresh(List)
            end

            function Dropdown:SetVisibility(Bool)
                NewDropdown:SetVisibility(Bool)
            end

            return Dropdown
        end

        Library.Sections.Label = function(self, Text, Alignment, Tooltip)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Text or "Label",
                Alignment = Alignment or "Left", 
                
                Count = 0
            }

            local Items = { } do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    ZIndex = 2,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }) 

                Items["Label"]:Tooltip(Tooltip)

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    Text = Label.Name,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(1, -16, 0, 15),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment[Label.Alignment],
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIPadding", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                })

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0.5, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:Colorpicker(Data)
                local Colorpicker = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,

                    Name = Data.Name or Data.name,
                    Default = Data.Default or Data.default,
                    Alpha = Data.Alpha or Data.alpha or 0,
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Callback = Data.Callback or Data.callback or function() end,
                    
                    Count = Label.Count
                }
                
                Label.Count += 1
                Colorpicker.Count = Label.Count

                local NewColorpicker, ColorpickerItems = Components.Colorpicker({
                    Window = Colorpicker.Window,
                    Page = Colorpicker.Page,
                    Parent = Items["SubElements"],
                    Name = Colorpicker.Name,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Alpha = Colorpicker.Alpha,
                    Callback = Colorpicker.Callback,
                    Count = Colorpicker.Count
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
                    Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",
                }

                local NewKeybind, KeybindItems = Components.Keybind({
                    Name = Keybind.Name,
                    Parent = Items["Label"],
                    Window = Label.Window,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            local SearchData = {
                Name = Label.Name,
                Item = Items["Label"]
            }

            local PageSearchData = Library.SearchItems[Label.Page]

            if not PageSearchData then 
                return 
            end

            TableInsert(PageSearchData, SearchData)

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
                Tooltip = Data.Tooltip or Data.tooltip or nil,

                Value = "",
            }

            local Items = { } do
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 47),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Textbox"]:Tooltip(Textbox.Tooltip)

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Textbox.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 25),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(34, 39, 45)
                })  Items["Background"]:AddToTheme({BackgroundColor3 = "Element"})

                Items["Background"]:OnHover(function()
                    Items["Background"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.45)})
                end)
    
                Items["Background"]:OnHoverLeave(function()
                    Items["Background"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                end)   

                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Rotation = 84,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
                })

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    CursorPosition = -1,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    ZIndex = 2,
                    Size = UDim2New(1, 0, 1, 0),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    ClearTextOnFocus = false,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Inactive Text"})

                Instances:Create("UIPadding", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 8)
                })
            end

            function Textbox:Set(Value)
                Items["Input"].Instance.Text = tostring(Value)
                Textbox.Value = Value
                Library.Flags[Textbox.Flag] = Value

                Items["Input"]:ChangeItemTheme({TextColor3 = "Text", PlaceholderColor3 = "Text Inactive"})
                Items["Input"]:Tween(nil, {TextColor3 = Library.Theme.Text})

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end

            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            getgenv().Options[Textbox.Flag] = Textbox

            local SearchData = {
                Name = Textbox.Name,
                Item = Items["Textbox"]
            }

            local PageSearchData = Library.SearchItems[Textbox.Page]

            if not PageSearchData then 
                return 
            end

            TableInsert(PageSearchData, SearchData)

            Items["Input"]:Connect("Focused", function()
                Items["Input"]:ChangeItemTheme({TextColor3 = "Accent", PlaceholderColor3 = "Text Inactive"})
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

    Library.Init = function(self)
        local AutoloadConfig = readfile(Library.Folders.Directory .. "/AutoLoadConfig (do not modify this).json")
        local AutoloadTheme = readfile(Library.Folders.Directory .. "/AutoLoadTheme (do not modify this).json")
        
        if AutoloadConfig ~= "" then
            local Success, Result = Library:LoadConfig(AutoloadConfig)

            if Success then 
                Library:Notification({
                    Name = "Success",
                    Description = "Successfully loaded autoload config",
                    Duration = 5,
                    Icon = "116339777575852",
                    IconColor = Color3.fromRGB(52, 255, 164)
                })
            else
                Library:Notification({
                    Name = "Error!",
                    Description = "Failed to load autoload config, error:\n" .. Result,
                    Duration = 5,
                    Icon = "97118059177470",
                    IconColor = Color3.fromRGB(255, 120, 120)
                })
            end
        end

        if AutoloadTheme ~= "" then
            local Success, Result = Library:LoadTheme(AutoloadTheme)

            if Success then 
                Library:Notification({
                    Name = "Success",
                    Description = "Successfully loaded autoload theme",
                    Duration = 5,
                    Icon = "116339777575852",
                    IconColor = Color3.fromRGB(52, 255, 164)
                })
            else
                Library:Notification({
                    Name = "Error!",
                    Description = "Failed to load autoload theme, error:\n" .. Result,
                    Duration = 5,
                    Icon = "97118059177470",
                    IconColor = Color3.fromRGB(255, 120, 120)
                })
            end
        end
    end
end 

getgenv().Library = Library
return Library
