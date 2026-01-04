if getgenv().Library then
	getgenv().Library:Unload()
end

local Library
do
	local Workspace = game:GetService("Workspace")
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local HttpService = game:GetService("HttpService")
	local RunService = game:GetService("RunService")
	local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
	local TweenService = game:GetService("TweenService")
	local Lighting = game:GetService("Lighting")

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
	local UDim2FromScale = UDim2.fromScale
	local UDim2FromOffset = UDim2.fromOffset
	local Vector2New = Vector2.new
	local Vector3New = Vector3.new

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
	local StringLen = string.len

	local InstanceNew = Instance.new

	local CFrameNew = CFrame.new
    local CFrameAngles = CFrame.Angles
    local Vector3New = Vector3.new
	local MathRad = math.rad
    local MathMax = math.max
    local MathMin = math.min

	local RectNew = Rect.new

	local IsMobile = UserInputService.TouchEnabled or false

	Library = {
		Theme = {},

		MenuKeybind = tostring(Enum.KeyCode.RightControl),

		Flags = {},

		Tween = {
			Time = 0.25,
			Style = Enum.EasingStyle.Quart,
			Direction = Enum.EasingDirection.Out,
		},

		FadeSpeed = 0.2,

		Folders = {
			Directory = "uip100",
			Configs = "uip100/Configs",
			Assets = "uip100/Assets",
		},

		-- Ignore below
		Pages = {},
		Sections = {},

		Connections = {},
		Threads = {},

		ThemeMap = {},
		ThemeItems = {},

		OpenFrames = {},

		SetFlags = {},

		UnnamedConnections = 0,
		UnnamedFlags = 0,

		Holder = nil,
		NotifHolder = nil,
		UnusedHolder = nil,
		KeyList = nil,

		Font = nil,
		CopiedColor = nil,
	}

	Library.__index = Library
	Library.Sections.__index = Library.Sections
	Library.Pages.__index = Library.Pages

	local Keys = {
		["Unknown"] = "Unknown",
		["Backspace"] = "Back",
		["Tab"] = "Tab",
		["Clear"] = "Clear",
		["Return"] = "Return",
		["Pause"] = "Pause",
		["Escape"] = "Escape",
		["Space"] = "Space",
		["QuotedDouble"] = '"',
		["Hash"] = "#",
		["Dollar"] = "$",
		["Percent"] = "%",
		["Ampersand"] = "&",
		["Quote"] = "'",
		["LeftParenthesis"] = "(",
		["RightParenthesis"] = " )",
		["Asterisk"] = "*",
		["Plus"] = "+",
		["Comma"] = ",",
		["Minus"] = "-",
		["Period"] = ".",
		["Slash"] = "`",
		["Three"] = "3",
		["Seven"] = "7",
		["Eight"] = "8",
		["Colon"] = ":",
		["Semicolon"] = ";",
		["LessThan"] = "<",
		["GreaterThan"] = ">",
		["Question"] = "?",
		["Equals"] = "=",
		["At"] = "@",
		["LeftBracket"] = "LeftBracket",
		["RightBracket"] = "RightBracked",
		["BackSlash"] = "BackSlash",
		["Caret"] = "^",
		["Underscore"] = "_",
		["Backquote"] = "`",
		["LeftCurly"] = "{",
		["Pipe"] = "|",
		["RightCurly"] = "}",
		["Tilde"] = "~",
		["Delete"] = "Delete",
		["End"] = "End",
		["KeypadZero"] = "Keypad0",
		["KeypadOne"] = "Keypad1",
		["KeypadTwo"] = "Keypad2",
		["KeypadThree"] = "Keypad3",
		["KeypadFour"] = "Keypad4",
		["KeypadFive"] = "Keypad5",
		["KeypadSix"] = "Keypad6",
		["KeypadSeven"] = "Keypad7",
		["KeypadEight"] = "Keypad8",
		["KeypadNine"] = "Keypad9",
		["KeypadPeriod"] = "KeypadP",
		["KeypadDivide"] = "KeypadD",
		["KeypadMultiply"] = "KeypadM",
		["KeypadMinus"] = "KeypadM",
		["KeypadPlus"] = "KeypadP",
		["KeypadEnter"] = "KeypadE",
		["KeypadEquals"] = "KeypadE",
		["Insert"] = "Insert",
		["Home"] = "Home",
		["PageUp"] = "PageUp",
		["PageDown"] = "PageDown",
		["RightShift"] = "RightShift",
		["LeftShift"] = "LeftShift",
		["RightControl"] = "RightControl",
		["LeftControl"] = "LeftControl",
		["LeftAlt"] = "LeftAlt",
		["RightAlt"] = "RightAlt",
	}

	local Themes = {
        ["Preset"] = {
            ["Window Outline"] = FromRGB(0, 34, 37),
            ["Accent"] = FromRGB(94, 213, 213),
            ["Background 1"] = FromRGB(17, 21, 27),
            ["Text"] = FromRGB(255, 255, 255),
            ["Inline"] = FromRGB(19, 25, 31),
            ["Element"] = FromRGB(32, 38, 48),
            ["Inactive Text"] = FromRGB(185, 185, 185),
            ["Border"] =  FromRGB(46, 52, 61),
            ["Background 2"] = FromRGB(24, 28, 36)
        }
	}

	Library.Theme = TableClone(Themes["Preset"])

	-- Folders
	for Index, Value in Library.Folders do
		if not isfolder(Value) then
			makefolder(Value)
		end
	end

	-- Tweening
	local Tween = {}
	do
		Tween.__index = Tween

		Tween.Create = function(self, Item, Info, Goal, IsRawItem)
			Item = IsRawItem and Item or Item.Instance
			Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

			local NewTween = {
				Tween = TweenService:Create(Item, Info, Goal),
				Info = Info,
				Goal = Goal,
				Item = Item,
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

			local NewTween = Tween:Create(
				Item,
				TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction),
				{
					[Property] = Visibility and OldTransparency or 1,
				},
				true
			)

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
	local Instances = {}
	do
		Instances.__index = Instances

		Instances.Create = function(self, Class, Properties)
			local NewItem = {
				Instance = InstanceNew(Class),
				Properties = Properties,
				Class = Class,
			}

			setmetatable(NewItem, Instances)

			for Property, Value in NewItem.Properties do
				NewItem.Instance[Property] = Value
			end

			return NewItem
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
				local NewX = StartPosition.X.Offset + DragDelta.X
				local NewY = StartPosition.Y.Offset + DragDelta.Y

				local ScreenSize = Gui.Parent.AbsoluteSize
				local GuiSize = Gui.AbsoluteSize

				NewX = MathClamp(NewX, 0, ScreenSize.X - GuiSize.X)
				NewY = MathClamp(NewY, 0, ScreenSize.Y - GuiSize.Y)

				self:Tween(
					TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(0, NewX, 0, NewY) }
				)
			end

			local InputChanged

			self:Connect("InputBegan", function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
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
				if
					Input.UserInputType == Enum.UserInputType.MouseMovement
					or Input.UserInputType == Enum.UserInputType.Touch
				then
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
			local CurrentSide = nil

			local StartMouse = nil
			local StartPosition = nil
			local StartSize = nil

			local EdgeThickness = 2

			local MakeEdge = function(Name, Position, Size)
				local Button = Instances:Create("TextButton", {
					Name = "\0",
					Size = Size,
					Position = Position,
					BackgroundColor3 = FromRGB(166, 147, 243),
					BackgroundTransparency = 1,
					Text = "",
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Parent = Gui,
					ZIndex = 99999,
				})
				Button:AddToTheme({ BackgroundColor3 = "Accent" })

				return Button
			end

			local Edges = {
				{
					Button = MakeEdge("Left", UDim2New(0, 0, 0, 0), UDim2New(0, EdgeThickness, 1, 0)),
					Side = "L",
				},

				{
					Button = MakeEdge("Right", UDim2New(1, -EdgeThickness, 0, 0), UDim2New(0, EdgeThickness, 1, 0)),
					Side = "R",
				},

				{
					Button = MakeEdge("Top", UDim2New(0, 0, 0, 0), UDim2New(1, 0, 0, EdgeThickness)),
					Side = "T",
				},

				{
					Button = MakeEdge("Bottom", UDim2New(0, 0, 1, -EdgeThickness), UDim2New(1, 0, 0, EdgeThickness)),
					Side = "B",
				},
			}

			local BeginResizing = function(Side)
				Resizing = true
				CurrentSide = Side

				StartMouse = UserInputService:GetMouseLocation()

				-- store offsets, not absolute screen pos
				StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
				StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)

				for Index, Value in Edges do
					Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
				end
			end

			local EndResizing = function()
				Resizing = false
				CurrentSide = nil

				for Index, Value in Edges do
					Value.Button.Instance.BackgroundTransparency = 1
				end
			end

			for Index, Value in Edges do
				Value.Button:Connect("InputBegan", function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						BeginResizing(Value.Side)
					end
				end)
			end

			Library:Connect(UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if Resizing then
						EndResizing()
					end
				end
			end)

			Library:Connect(RunService.RenderStepped, function()
				if not Resizing or not CurrentSide then
					return
				end

				local MouseLocation = UserInputService:GetMouseLocation()
				local dx = MouseLocation.X - StartMouse.X
				local dy = MouseLocation.Y - StartMouse.Y

				local x, y = StartPosition.X, StartPosition.Y
				local w, h = StartSize.X, StartSize.Y

				if CurrentSide == "L" then
					x = StartPosition.X + dx
					w = StartSize.X - dx
				elseif CurrentSide == "R" then
					w = StartSize.X + dx
				elseif CurrentSide == "T" then
					y = StartPosition.Y + dy
					h = StartSize.Y - dy
				elseif CurrentSide == "B" then
					h = StartSize.Y + dy
				end

				if w < Minimum.X then
					if CurrentSide == "L" then
						x = x - (Minimum.X - w)
					end
					w = Minimum.X
				end
				if h < Minimum.Y then
					if CurrentSide == "T" then
						y = y - (Minimum.Y - h)
					end
					h = Minimum.Y
				end

				self:Tween(
					TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2FromOffset(x, y) }
				)
				self:Tween(
					TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Size = UDim2FromOffset(w, h) }
				)
			end)
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
	local CustomFont = {}
	do
		function CustomFont:New(Name, Weight, Style, Data)
			if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
				return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
			end

			if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then
				writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
			end

			local FontData = {
				name = Name,
				faces = {
					{
						name = "Regular",
						weight = Weight,
						style = Style,
						assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf"),
					},
				},
			}

			writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
			return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
		end

		function CustomFont:Get(Name)
			if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
				return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
			end
		end

		CustomFont:New("Verdana", 400, "Regular", {
			Id = "Verdana",
			Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/verdana.ttf",
		})

		Library.Font = CustomFont:Get("Verdana")
	end

	Library.Holder = Instances:Create("ScreenGui", {
		Parent = gethui(),
		Name = "\0",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 2,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
	})

	Library.UnusedHolder = Instances:Create("ScreenGui", {
		Parent = gethui(),
		Name = "\0",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		Enabled = false,
		ResetOnSpawn = false,
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
		BackgroundColor3 = FromRGB(255, 255, 255),
	})

	Instances:Create("UIListLayout", {
		Parent = Library.NotifHolder.Instance,
		Name = "\0",
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDimNew(0, 8),
	})

	Instances:Create("UIPadding", {
		Parent = Library.NotifHolder.Instance,
		Name = "\0",
		PaddingTop = UDimNew(0, 15),
		PaddingBottom = UDimNew(0, 15),
		PaddingRight = UDimNew(0, 15),
		PaddingLeft = UDimNew(0, 15),
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
			--warn(Result)
			return false
		end

		return Success
	end

	Library.Connect = function(self, Event, Callback, Name)
		Name = Name
			or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

		local NewConnection = {
			Event = Event,
			Callback = Callback,
			Name = Name,
			Connection = nil,
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

	Library.EscapePattern = function(self, String)
		local ShouldEscape = false

		if string.match(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]") then
			ShouldEscape = true
		end

		if ShouldEscape then
			return StringGSub(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
		end

		return String
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
		local Config = {}

		local Success, Result = Library:SafeCall(function()
			for Index, Value in Library.Flags do
				if type(Value) == "table" and Value.Key then
					Config[Index] = { Key = tostring(Value.Key), Mode = Value.Mode, Toggled = Value.Toggled }
				elseif type(Value) == "table" and Value.Color then
					Config[Index] = { Color = "#" .. Value.HexValue, Alpha = Value.Alpha }
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

	Library.RefreshConfigsList = function(self, Element)
		local List = {}
		local ReturnList = {}

		List = listfiles(Library.Folders.Configs)

		for Index = 1, #List do
			local File = List[Index]

			if File:sub(-5) == ".json" then
				local Position = File:find(".json", 1, true)
				local StartPosition = Position

				local Character = File:sub(Position, Position)
				while Character ~= "/" and Character ~= "\\" and Character ~= "" do
					Position = Position - 1
					Character = File:sub(Position, Position)
				end

				if Character == "/" or Character == "\\" then
					TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
				end
			end
		end

		Element:Refresh(ReturnList)
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

	Library.IsMouseOverFrame = function(self, Frame)
		Frame = Frame.Instance

		local MousePosition = Vector2New(Mouse.X, Mouse.Y)

		return MousePosition.X >= Frame.AbsolutePosition.X
			and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X
			and MousePosition.Y >= Frame.AbsolutePosition.Y
			and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
	end

	Library.GetLighterColor = function(self, Color, Increment)
		local Hue, Saturation, Value = Color:ToHSV()
		return FromHSV(Hue, Saturation, Value * Increment)
	end

	do
		Library.CreateColorpicker = function(self, Data)
			local Colorpicker = {
				Hue = 0,
				Saturation = 0,
				Value = 0,

				Alpha = 0,

				IsOpen = false,
				IsOpen2 = false,

				Color = FromRGB(0, 0, 0),
				HexValue = "000000",

				Flag = Data.Flag,
			}

			local Items = {}
			do
				Items["ColorpickerButton"] = Instances:Create("TextButton", {
					Parent = Data.Parent.Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					Size = UDim2New(0, 15, 0, 15),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(140, 255, 213),
				})

				Instances:Create("UIStroke", {
					Parent = Items["ColorpickerButton"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Instances:Create("UIGradient", {
					Parent = Items["ColorpickerButton"].Instance,
					Name = "\0",
					Rotation = 90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(152, 152, 152)),
					}),
				})

				Items["ColorpickerWindow"] = Instances:Create("Frame", {
					Parent = Library.UnusedHolder.Instance,
					Name = "\0",
					Visible = false,
					Position = UDim2New(0, 1032, 0, 123),
					BorderColor3 = FromRGB(0, 34, 37),
					Size = UDim2New(0, 232, 0, 265),
					BorderSizePixel = 2,
					BackgroundColor3 = FromRGB(17, 21, 27),
				})

				Items["Glow"] = Instances:Create("ImageLabel", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(94, 213, 213),
					ScaleType = Enum.ScaleType.Slice,
					ImageTransparency = 0.699999988079071,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundColor3 = FromRGB(255, 255, 255),
					Size = UDim2New(1, 25, 1, 25),
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "http://www.roblox.com/asset/?id=18245826428",
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					ZIndex = -1,
					BorderSizePixel = 0,
					SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
				})
				Items["Glow"]:AddToTheme({ ImageColor3 = "Accent" })

				Instances:Create("UIGradient", {
					Parent = Items["Glow"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({ NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1) }),
				})

				Instances:Create("UIStroke", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					Color = FromRGB(94, 213, 213),
					LineJoinMode = Enum.LineJoinMode.Miter,
				}):AddToTheme({ Color = "Accent" })

				Items["Alpha"] = Instances:Create("TextButton", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(0, 1),
					BorderSizePixel = 0,
					Position = UDim2New(0, 8, 1, -35),
					Size = UDim2New(1, -16, 0, 10),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = FromRGB(140, 255, 213),
				})

				Items["Checkers"] = Instances:Create("ImageLabel", {
					Parent = Items["Alpha"].Instance,
					Name = "\0",
					ScaleType = Enum.ScaleType.Tile,
					BorderColor3 = FromRGB(0, 0, 0),
					TileSize = UDim2New(0, 6, 0, 6),
					Image = "http://www.roblox.com/asset/?id=18274452449",
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 1, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIGradient", {
					Parent = Items["Checkers"].Instance,
					Name = "\0",
					Transparency = NumSequence({
						NumSequenceKeypoint(0, 1),
						NumSequenceKeypoint(0.37, 0.5),
						NumSequenceKeypoint(1, 0),
					}),
				})

				Items["AlphaDragger"] = Instances:Create("Frame", {
					Parent = Items["Alpha"].Instance,
					Name = "\0",
					Size = UDim2New(0, 2, 1, 0),
					Position = UDim2New(0, 8, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = Items["AlphaDragger"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["Hue"] = Instances:Create("TextButton", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(1, 0),
					BorderSizePixel = 0,
					Position = UDim2New(1, -7, 0, 8),
					Size = UDim2New(0, 10, 1, -59),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["HueInline"] = Instances:Create("TextButton", {
					Parent = Items["Hue"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Size = UDim2New(1, 0, 1, 0),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIGradient", {
					Parent = Items["HueInline"].Instance,
					Name = "\0",
					Rotation = 90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 0, 0)),
						RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)),
						RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)),
						RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)),
						RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)),
						RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)),
						RGBSequenceKeypoint(1, FromRGB(255, 0, 0)),
					}),
				})

				Instances:Create("UIStroke", {
					Parent = Items["Hue"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["HueDragger"] = Instances:Create("Frame", {
					Parent = Items["Hue"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = -0.009999999776482582,
					Position = UDim2New(0, 0, 0, 8),
					Size = UDim2New(1, 0, 0, 2),
					ZIndex = 3,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = Items["HueDragger"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

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
					Size = UDim2New(1, -31, 1, -59),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = FromRGB(140, 255, 213),
				})

				Instances:Create("UIStroke", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["Saturation"] = Instances:Create("Frame", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 1, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIGradient", {
					Parent = Items["Saturation"].Instance,
					Name = "\0",
					Transparency = NumSequence({ NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0) }),
				})

				Items["Value"] = Instances:Create("Frame", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 1, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(0, 0, 0),
				})

				Instances:Create("UIGradient", {
					Parent = Items["Value"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({ NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0) }),
				})

				Items["PaletteDragger"] = Instances:Create("Frame", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					Size = UDim2New(0, 2, 0, 2),
					Position = UDim2New(0, 8, 0, 8),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = Items["PaletteDragger"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["HexInput"] = Instances:Create("TextBox", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					ClearTextOnFocus = false,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AnchorPoint = Vector2New(0, 1),
					Size = UDim2New(1, -16, 0, 20),
					PlaceholderColor3 = FromRGB(255, 255, 255),
					Position = UDim2New(0, 8, 1, -7),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["HexInput"]:AddToTheme({ TextColor3 = "Text", BackgroundColor3 = "Element" })

				Instances:Create("UIStroke", {
					Parent = Items["HexInput"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["ColorpickerWindow2"] = Instances:Create("Frame", {
					Parent = Library.UnusedHolder.Instance,
					Name = "\0",
					Position = UDim2New(0, 0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 50, 0, 20),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(32, 38, 48),
					AutomaticSize = Enum.AutomaticSize.Y,
				})
				Items["ColorpickerWindow2"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UIStroke", {
					Parent = Items["ColorpickerWindow2"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Instances:Create("UIListLayout", {
					Parent = Items["ColorpickerWindow2"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 2),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})
			end

			local AddButton = function(Name, Callback)
				local NewButton = Instances:Create("TextButton", {
					Parent = Items["ColorpickerWindow2"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Name,
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, 20),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				NewButton:AddToTheme({ TextColor3 = "Text" })

				NewButton:Connect("MouseButton1Down", function()
					Callback()
					Colorpicker:SetOpen2(false)
				end)

				return NewButton
			end

			AddButton("Copy", function()
				local Red = MathFloor(Colorpicker.Color.R * 255)
				local Green = MathFloor(Colorpicker.Color.G * 255)
				local Blue = MathFloor(Colorpicker.Color.B * 255)

				setclipboard(Red .. ", " .. Green .. ", " .. Blue)
				Library.CopiedColor = Red .. ", " .. Green .. ", " .. Blue
			end)
			AddButton("Paste", function()
				if Library.CopiedColor then
					local Red, Green, Blue = Library.CopiedColor:match("(%d+),%s*(%d+),%s*(%d+)")
					Red, Green, Blue = tonumber(Red), tonumber(Green), tonumber(Blue)

					Colorpicker:Set({ Red, Green, Blue }, Colorpicker.Alpha)
				end
			end)

			local SlidingPalette = false
			local SlidingHue = false
			local SlidingAlpha = false

			local Debounce = false
			local RenderStepped

			local RenderStepped2

			function Colorpicker:Get()
				return Colorpicker.Color, Colorpicker.Alpha
			end

			function Colorpicker:SetOpen(Bool)
				if Debounce then
					return
				end

				Colorpicker.IsOpen = Bool

				Debounce = true

				if Colorpicker.IsOpen then
					Items["ColorpickerWindow"].Instance.Visible = true
					Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance

					RenderStepped = RunService.RenderStepped:Connect(function()
						Items["ColorpickerWindow"].Instance.Position = UDim2New(
							0,
							Items["ColorpickerButton"].Instance.AbsolutePosition.X,
							0,
							Items["ColorpickerButton"].Instance.AbsolutePosition.Y
								+ Items["ColorpickerButton"].Instance.AbsoluteSize.Y
								+ 65
						)
					end)

					for Index, Value in Library.OpenFrames do
						if Value ~= Colorpicker then
							Value:SetOpen(false)
						end
					end

					Library.OpenFrames[Colorpicker] = Colorpicker
				else
					if Library.OpenFrames[Colorpicker] then
						Library.OpenFrames[Colorpicker] = nil
					end

					if RenderStepped then
						RenderStepped:Disconnect()
						RenderStepped = nil
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

					if not Value.ClassName:find("UI") then
						Value.ZIndex = Colorpicker.IsOpen and 104 or 1
						Items["Glow"].Instance.ZIndex = Colorpicker.IsOpen and 103 or 1
					end

					if type(TransparencyProperty) == "table" then
						for _, Property in TransparencyProperty do
							NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
						end
					else
						NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
					end
				end

				NewTween.Tween.Completed:Connect(function()
					Debounce = false
					Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
					task.wait(0.2)
					Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen
							and Library.UnusedHolder.Instance
						or Library.Holder.Instance
				end)
			end

			function Colorpicker:SetOpen2(Bool)
				Colorpicker.IsOpen2 = Bool
				if Bool then
					Items["ColorpickerWindow2"].Instance.Visible = true
					Items["ColorpickerWindow2"].Instance.Parent = Library.Holder.Instance

					RenderStepped2 = RunService.RenderStepped:Connect(function()
						Items["ColorpickerWindow2"].Instance.Position = UDim2New(
							0,
							Items["ColorpickerButton"].Instance.AbsolutePosition.X
								+ Items["ColorpickerButton"].Instance.AbsoluteSize.X,
							0,
							Items["ColorpickerButton"].Instance.AbsolutePosition.Y
								+ Items["ColorpickerButton"].Instance.AbsoluteSize.Y
								+ 65
						)
					end)
				else
					if RenderStepped2 then
						RenderStepped2:Disconnect()
						RenderStepped2 = nil
					end

					Items["ColorpickerWindow2"].Instance.Visible = false
					Items["ColorpickerWindow2"].Instance.Parent = Library.UnusedHolder.Instance
				end
			end

			function Colorpicker:SlidePalette(Input)
				if not Input or not SlidingPalette then
					return
				end

				local ValueX = MathClamp(
					1
						- (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X)
							/ Items["Palette"].Instance.AbsoluteSize.X,
					0,
					1
				)
				local ValueY = MathClamp(
					1
						- (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y)
							/ Items["Palette"].Instance.AbsoluteSize.Y,
					0,
					1
				)

				Colorpicker.Saturation = ValueX
				Colorpicker.Value = ValueY

				local SlideX = MathClamp(
					(Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X)
						/ Items["Palette"].Instance.AbsoluteSize.X,
					0,
					0.99
				)
				local SlideY = MathClamp(
					(Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y)
						/ Items["Palette"].Instance.AbsoluteSize.Y,
					0,
					0.99
				)

				Items["PaletteDragger"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(SlideX, 0, SlideY, 0) }
				)
				Colorpicker:Update()
			end

			function Colorpicker:SlideHue(Input)
				if not Input or not SlidingHue then
					return
				end

				local ValueY = MathClamp(
					(Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y,
					0,
					1
				)

				Colorpicker.Hue = ValueY

				local SlideY = MathClamp(
					(Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y,
					0,
					0.99
				)

				Items["HueDragger"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(0, 0, SlideY, 0) }
				)
				Colorpicker:Update()
			end

			function Colorpicker:SlideAlpha(Input)
				if not Input or not SlidingAlpha then
					return
				end

				local ValueX = MathClamp(
					(Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X)
						/ Items["Alpha"].Instance.AbsoluteSize.X,
					0,
					1
				)

				Colorpicker.Alpha = ValueX

				local SlideX = MathClamp(
					(Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X)
						/ Items["Alpha"].Instance.AbsoluteSize.X,
					0,
					0.99
				)

				Items["AlphaDragger"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(SlideX, 0, 0, 0) }
				)
				Colorpicker:Update(true)
			end

			function Colorpicker:Update(IsFromAlpha)
				local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
				Colorpicker.Color = FromHSV(Hue, Saturation, Value)
				Colorpicker.HexValue = Colorpicker.Color:ToHex()

				Library.Flags[Colorpicker.Flag] = {
					Alpha = Colorpicker.Alpha,
					Color = Colorpicker.Color,
					HexValue = Colorpicker.HexValue,
				}

				Items["ColorpickerButton"]:Tween(nil, { BackgroundColor3 = Colorpicker.Color })
				Items["Palette"]:Tween(nil, { BackgroundColor3 = FromHSV(Hue, 1, 1) })
				Items["HexInput"].Instance.Text = "#" .. Colorpicker.HexValue

				if not IsFromAlpha then
					Items["Alpha"]:Tween(nil, { BackgroundColor3 = Colorpicker.Color })
				end

				if Data.Callback then
					Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
				end
			end

			function Colorpicker:Set(Color, Alpha)
				if type(Color) == "table" then
					Color = FromRGB(Color[1], Color[2], Color[3])
				elseif type(Color) == "string" then
					Color = FromHex(Color)
				end

				Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
				Colorpicker.Alpha = Alpha or 0

				local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.99)
				local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.99)

				local AlphaPositionX = MathClamp(Colorpicker.Alpha, 0, 0.99)

				local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.99)

				Items["PaletteDragger"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0) }
				)
				Items["HueDragger"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(0, 0, HuePositionY, 0) }
				)
				Items["AlphaDragger"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(AlphaPositionX, 0, 0, 0) }
				)
				Colorpicker:Update(false)
			end

			local PaletteChanged

			Items["Palette"]:Connect("InputBegan", function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					SlidingPalette = true
					Colorpicker:SlidePalette(Input)

					if PaletteChanged then 
						return 
					end

					PaletteChanged = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							SlidingPalette = false

							PaletteChanged:Disconnect()
							PaletteChanged = nil
						end
					end)
				end
			end)

			local HueChanged

			Items["HueInline"]:Connect("InputBegan", function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					SlidingHue = true
					Colorpicker:SlideHue(Input)

					if HueChanged then 
						return 
					end

					HueChanged = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							SlidingHue = false

							HueChanged:Disconnect()
							HueChanged = nil
						end
					end)
				end
			end)

			local AlphaChanged

			Items["Alpha"]:Connect("InputBegan", function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					SlidingAlpha = true
					Colorpicker:SlideAlpha(Input)

					if AlphaChanged then 
						return
					end

					AlphaChanged = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							SlidingAlpha = false

							AlphaChanged:Disconnect()
							AlphaChanged = nil
						end
					end)
				end
			end)

			Items["HexInput"]:Connect("FocusLost", function()
				Colorpicker:Set(tostring(Items["HexInput"].Instance.Text), Colorpicker.Alpha)
			end)

			local CompareVectors = function(PointA, PointB)
				return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
			end

			local IsClipped = function(Object, Column)
				local Parent = Column

				local BoundryTop = Parent.AbsolutePosition
				local BoundryBottom = BoundryTop + Parent.AbsoluteSize

				local Top = Object.AbsolutePosition
				local Bottom = Top + Object.AbsoluteSize

				return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
			end

			Items["ColorpickerButton"]:Connect("Changed", function(Property)
				if Property == "AbsolutePosition" and Colorpicker.IsOpen then
					Colorpicker.IsOpen = not IsClipped(
						Items["ColorpickerWindow"].Instance,
						Data.Section.Items["Section"].Instance.Parent
					)
					Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
				end
			end)

			Library:Connect(UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
					if SlidingPalette then
						Colorpicker:SlidePalette(Input)
					elseif SlidingHue then
						Colorpicker:SlideHue(Input)
					elseif SlidingAlpha then
						Colorpicker:SlideAlpha(Input)
					end
				end
			end)

			Library:Connect(UserInputService.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not Colorpicker.IsOpen then
						return
					end

					if
						Library:IsMouseOverFrame(Items["ColorpickerWindow"])
						or Library:IsMouseOverFrame(Items["ColorpickerWindow2"])
					then
						return
					end

					Colorpicker:SetOpen(false)
					Colorpicker:SetOpen2(false)
				end
			end)

			Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
				Colorpicker:SetOpen(not Colorpicker.IsOpen)
			end)

			Items["ColorpickerButton"]:Connect("MouseButton2Down", function()
				Colorpicker:SetOpen2(not Colorpicker.IsOpen2)
			end)

			if Data.Default then
				Colorpicker:Set(Data.Default, Data.Alpha)
			end

			Library.SetFlags[Colorpicker.Flag] = function(Color, Alpha)
				Colorpicker:Set(Color, Alpha)
			end

			return Colorpicker, Items
		end

		Library.CreateKeybind = function(self, Data)
			local Keybind = {
				IsOpen = false,

				Key = "",
				Toggled = false,
				Mode = "",

				Flag = Data.Flag,

				Picking = false,
				Value = "",
			}

			local KeyListItem
			if Library.KeyList then
				KeyListItem = Library.KeyList:Add("", "")
			end

			local Items = {}
			do
				Items["KeyButton"] = Instances:Create("TextButton", {
					Parent = Data.Parent.Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.5,
					Text = "Unbound",
					AutoButtonColor = false,
					Size = UDim2New(0, 0, 0, 15),
					BorderSizePixel = 0,
					BorderColor3 = FromRGB(0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["KeyButton"]:AddToTheme({ TextColor3 = "Text", BackgroundColor3 = "Element" })

				Instances:Create("UIPadding", {
					Parent = Items["KeyButton"].Instance,
					Name = "\0",
					PaddingRight = UDimNew(0, 8),
					PaddingLeft = UDimNew(0, 8),
				})

				Instances:Create("UIStroke", {
					Parent = Items["KeyButton"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["KeybindWindow"] = Instances:Create("Frame", {
					Parent = Library.UnusedHolder.Instance,
					Name = "\0",
					Visible = false,
					Position = UDim2New(0, 114, 0, 35),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 5,
					Size = UDim2New(0, 78, 0, 66),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["KeybindWindow"]:AddToTheme({ BackgroundColor3 = "Element" })

				Items["Toggle"] = Instances:Create("TextButton", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Position = UDim2New(0, 2, 0, 2),
					Size = UDim2New(1, -4, 0, 20),
					ZIndex = 5,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["Toggle"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UIGradient", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					Rotation = -90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(200, 200, 200)),
					}),
				})

				Items["ToggleStroke"] = Instances:Create("UIStroke", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				})
				Items["ToggleStroke"]:AddToTheme({ Color = "Border" })

				Items["ToggleLiner"] = Instances:Create("Frame", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					Size = UDim2New(0, 1, 1, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				Items["ToggleLiner"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Items["ToggleText"] = Instances:Create("TextLabel", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "Toggle",
					AutomaticSize = Enum.AutomaticSize.X,
					AnchorPoint = Vector2New(0, 0.5),
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 7, 0.5, 0),
					BorderSizePixel = 0,
					ZIndex = 5,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["ToggleText"]:AddToTheme({ TextColor3 = "Text" })

				Items["Hold"] = Instances:Create("TextButton", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 2, 0, 22),
					Size = UDim2New(1, -4, 0, 20),
					ZIndex = 5,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["Hold"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UIGradient", {
					Parent = Items["Hold"].Instance,
					Name = "\0",
					Rotation = -90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(200, 200, 200)),
					}),
				})

				Items["HoldStroke"] = Instances:Create("UIStroke", {
					Parent = Items["Hold"].Instance,
					Name = "\0",
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Transparency = 1,
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
				})
				Items["HoldStroke"]:AddToTheme({ Color = "Border" })

				Items["HoldLiner"] = Instances:Create("Frame", {
					Parent = Items["Hold"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = UDim2New(0, 1, 1, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				Items["HoldLiner"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Items["HoldText"] = Instances:Create("TextLabel", {
					Parent = Items["Hold"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.4000000059604645,
					Text = "Hold",
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					AnchorPoint = Vector2New(0, 0.5),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 10, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 5,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["HoldText"]:AddToTheme({ TextColor3 = "Text" })

				Items["AlwaysOn"] = Instances:Create("TextButton", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 2, 0, 44),
					Size = UDim2New(1, -4, 0, 20),
					ZIndex = 5,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})

				Instances:Create("UIGradient", {
					Parent = Items["AlwaysOn"].Instance,
					Name = "\0",
					Rotation = -90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(200, 200, 200)),
					}),
				})

				Items["AlwaysOnStroke"] = Instances:Create("UIStroke", {
					Parent = Items["AlwaysOn"].Instance,
					Name = "\0",
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Transparency = 1,
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
				})
				Items["AlwaysOnStroke"]:AddToTheme({ Color = "Border" })

				Items["AlwaysOnLiner"] = Instances:Create("Frame", {
					Parent = Items["AlwaysOn"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = UDim2New(0, 1, 1, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				Items["AlwaysOnLiner"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Items["AlwaysOnText"] = Instances:Create("TextLabel", {
					Parent = Items["AlwaysOn"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.4000000059604645,
					Text = "Always On",
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					AnchorPoint = Vector2New(0, 0.5),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 10, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 5,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["AlwaysOnText"]:AddToTheme({ TextColor3 = "Text" })

				Items["KeyButton"]:OnHover(function()
					Items["KeyButton"]:Tween(
						nil,
						{ BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35) }
					)
				end)

				Items["KeyButton"]:OnHoverLeave(function()
					Items["KeyButton"]:Tween(nil, { BackgroundColor3 = Library.Theme.Element })
				end)
			end

			local Update = function()
				if KeyListItem then
					KeyListItem:SetText(Data.Name, Keybind.Value)
					KeyListItem:SetStatus(Keybind.Toggled)
				end
			end

			local Modes = {
				["Toggle"] = { Items["Toggle"], Items["ToggleText"], Items["ToggleStroke"], Items["ToggleLiner"] },
				["Hold"] = { Items["Hold"], Items["HoldText"], Items["HoldStroke"], Items["HoldLiner"] },
				["Always On"] = {
					Items["AlwaysOn"],
					Items["AlwaysOnText"],
					Items["AlwaysOnStroke"],
					Items["AlwaysOnLiner"],
				},
			}

			function Keybind:Get()
				return Keybind.Mode, Keybind.Key, Keybind.Toggled
			end

			local Debounce = false
			local RenderStepped

			function Keybind:SetOpen(Bool)
				if Debounce then
					return
				end

				Keybind.IsOpen = Bool

				Debounce = true

				if Keybind.IsOpen then
					Items["KeybindWindow"].Instance.Visible = true
					Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance

					RenderStepped = RunService.RenderStepped:Connect(function()
						Items["KeybindWindow"].Instance.Position = UDim2New(
							0,
							Items["KeyButton"].Instance.AbsolutePosition.X,
							0,
							Items["KeyButton"].Instance.AbsolutePosition.Y
								+ Items["KeyButton"].Instance.AbsoluteSize.Y
								+ 65
						)
					end)

					if not Debounce then
						for Index, Value in Library.OpenFrames do
							if Value ~= Keybind then
								Value:SetOpen(false)
							end
						end

						Library.OpenFrames[Keybind] = Keybind
					end
				else
					if not Debounce then
						if Library.OpenFrames[Keybind] then
							Library.OpenFrames[Keybind] = nil
						end
					end

					if RenderStepped then
						RenderStepped:Disconnect()
						RenderStepped = nil
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

					if type(TransparencyProperty) == "table" then
						for _, Property in TransparencyProperty do
							NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
						end
					else
						NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
					end
				end

				NewTween.Tween.Completed:Connect(function()
					Debounce = false
					Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
					task.wait(0.2)
					Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance
						or Library.Holder.Instance
				end)
			end

			function Keybind:Set(Key)
				if StringFind(tostring(Key), "Enum") then
					Keybind.Key = tostring(Key)

					Key = Key.Name == "Backspace" and "None" or Key.Name

					local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
					local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")
						or "None"

					Keybind.Value = TextToDisplay
					Items["KeyButton"].Instance.Text = TextToDisplay

					Library.Flags[Keybind.Flag] = {
						Mode = Keybind.Mode,
						Key = Keybind.Key,
						Toggled = Keybind.Toggled,
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
						Keybind.Mode = "Toggle"
						Keybind:SetMode("Toggle")
					end

					local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
					local TextToDisplay = KeyString
							and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")
						or "None"

					TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

					Keybind.Value = TextToDisplay
					Items["KeyButton"].Instance.Text = TextToDisplay

					if Key.Toggled then
						Keybind:Press(Key.Toggled, true)
					end

					if Data.Callback then
						Library:SafeCall(Data.Callback, Keybind.Toggled)
					end

					Update()
				elseif TableFind({ "Toggle", "Hold", "Always" }, Key) then
					Keybind.Mode = Key
					Keybind:SetMode(Keybind.Mode)

					if Data.Callback then
						Library:SafeCall(Data.Callback, Keybind.Toggled)
					end

					Update()
				elseif type(Key) == "boolean" then
					Keybind:Press(Key)
				end

				Keybind.Picking = false
			end

			function Keybind:Press(Bool)
				if Keybind.Mode == "Toggle" then
					Keybind.Toggled = not Keybind.Toggled
				elseif Keybind.Mode == "Hold" then
					Keybind.Toggled = Bool
				elseif Keybind.Mode == "Always" then
					Keybind.Toggled = true
				end

				Library.Flags[Keybind.Flag] = {
					Mode = Keybind.Mode,
					Key = Keybind.Key,
					Toggled = Keybind.Toggled,
				}

				if Data.Callback then
					Library:SafeCall(Data.Callback, Keybind.Toggled)
				end

				Update()
			end

			function Keybind:SetMode(Mode)
				for Index, Value in Modes do
					if Index == Mode then
						Value[1]:Tween(nil, { BackgroundTransparency = 0 })
						Value[4]:Tween(nil, { BackgroundTransparency = 0 })
						Value[2]:Tween(nil, { TextTransparency = 0 })
						Value[3]:Tween(nil, { Transparency = 0 })
					else
						Value[1]:Tween(nil, { BackgroundTransparency = 1 })
						Value[4]:Tween(nil, { BackgroundTransparency = 1 })
						Value[2]:Tween(nil, { TextTransparency = 0.4 })
						Value[3]:Tween(nil, { Transparency = 1 })
					end
				end

				Library.Flags[Keybind.Flag] = {
					Mode = Keybind.Mode,
					Key = Keybind.Key,
					Toggled = Keybind.Toggled,
				}

				if Data.Callback then
					Library:SafeCall(Data.Callback, Keybind.Toggled)
				end

				Update()
			end

			local CompareVectors = function(PointA, PointB)
				return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
			end

			local IsClipped = function(Object, Column)
				local Parent = Column

				local BoundryTop = Parent.AbsolutePosition
				local BoundryBottom = BoundryTop + Parent.AbsoluteSize

				local Top = Object.AbsolutePosition
				local Bottom = Top + Object.AbsoluteSize

				return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
			end

			Items["KeyButton"]:Connect("Changed", function(Property)
				if Property == "AbsolutePosition" and Keybind.IsOpen then
					Keybind.IsOpen =
						not IsClipped(Items["KeybindWindow"].Instance, Data.Section.Items["Section"].Instance.Parent)
					Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
				end
			end)

			Items["KeyButton"]:Connect("MouseButton1Click", function()
				Keybind.Picking = true

				Items["KeyButton"].Instance.Text = "."
				Library:Thread(function()
					local Count = 1

					while true do
						if not Keybind.Picking then
							break
						end

						if Count == 4 then
							Count = 1
						end

						Items["KeyButton"].Instance.Text = Count == 1 and "."
							or Count == 2 and ".."
							or Count == 3 and "..."
						Count += 1
						task.wait(0.4)
					end
				end)

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

			Items["KeyButton"]:Connect("MouseButton2Down", function()
				Keybind:SetOpen(not Keybind.IsOpen)
			end)

			Library:Connect(UserInputService.InputBegan, function(Input)
				if Keybind.Value == "None" then
					return
				end

				if tostring(Input.KeyCode) == Keybind.Key then
					if Keybind.Mode == "Toggle" then
						Keybind:Press()
					elseif Keybind.Mode == "Hold" then
						Keybind:Press(true)
					elseif Keybind.Mode == "Always" then
						Keybind:Press(true)
					end
				elseif tostring(Input.UserInputType) == Keybind.Key then
					if Keybind.Mode == "Toggle" then
						Keybind:Press()
					elseif Keybind.Mode == "Hold" then
						Keybind:Press(true)
					elseif Keybind.Mode == "Always" then
						Keybind:Press(true)
					end
				end

				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Keybind.IsOpen then
						return
					end

					if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
						return
					end

					Keybind:SetOpen(false)
				end
			end)

			Library:Connect(UserInputService.InputEnded, function(Input)
				if Keybind.Value == "None" then
					return
				end

				if tostring(Input.KeyCode) == Keybind.Key then
					if Keybind.Mode == "Hold" then
						Keybind:Press(false)
					elseif Keybind.Mode == "Always" then
						Keybind:Press(true)
					end
				elseif tostring(Input.UserInputType) == Keybind.Key then
					if Keybind.Mode == "Hold" then
						Keybind:Press(false)
					elseif Keybind.Mode == "Always" then
						Keybind:Press(true)
					end
				end
			end)

			Items["Toggle"]:Connect("MouseButton1Down", function()
				Keybind.Mode = "Toggle"
				Keybind:SetMode("Toggle")
			end)

			Items["Hold"]:Connect("MouseButton1Down", function()
				Keybind.Mode = "Hold"
				Keybind:SetMode("Hold")
			end)

			Items["AlwaysOn"]:Connect("MouseButton1Down", function()
				Keybind.Mode = "Always"
				Keybind:SetMode("Always On")
			end)

			if Data.Default then
				Keybind:Set({ Key = Data.Default, Mode = Data.Mode or "Toggle", Toggled = Data.Toggled })
			end

			Library.SetFlags[Keybind.Flag] = function(Value)
				Keybind:Set(Value)
			end

			return Keybind, Items
		end

		Library.Watermark = function(self, Name)
			local Watermark = {}

			local Items = {}
			do
				Items["Watermark"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0.5, 0),
					Position = UDim2New(0.5, 0, 0, 25),
					BorderColor3 = FromRGB(0, 34, 37),
					Size = UDim2New(0, 180, 0, 30),
					BorderSizePixel = 2,
					BackgroundColor3 = FromRGB(17, 21, 27),
					ZIndex = 5,
				})
				Items["Watermark"]:AddToTheme({ BackgroundColor3 = "Background 1" })

				Items["UIStroke"] = Instances:Create("UIStroke", {
					Parent = Items["Watermark"].Instance,
					Name = "\0",
					Color = FromRGB(94, 213, 213),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				})
				Items["UIStroke"]:AddToTheme({ Color = "Accent" })

				Instances:Create("UIGradient", {
					Parent = Items["UIStroke"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({
						NumSequenceKeypoint(0, 0),
						NumSequenceKeypoint(0.696, 0.2749999761581421),
						NumSequenceKeypoint(0.84, 0.574999988079071),
						NumSequenceKeypoint(1, 1),
					}),
				})

				Items["Glow"] = Instances:Create("ImageLabel", {
					Parent = Items["Watermark"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(94, 213, 213),
					ScaleType = Enum.ScaleType.Slice,
					ImageTransparency = 0.5,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundColor3 = FromRGB(255, 255, 255),
					Size = UDim2New(1, 25, 1, 25),
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "rbxassetid://18245826428",
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					ZIndex = 4,
					BorderSizePixel = 0,
					SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
				})
				Items["Glow"]:AddToTheme({ ImageColor3 = "Accent" })

				Instances:Create("UIGradient", {
					Parent = Items["Glow"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({ NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1) }),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Watermark"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Name,
					AnchorPoint = Vector2New(0.5, 0.5),
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					BorderSizePixel = 0,
					ZIndex = 5,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })
			end

			function Watermark:SetText(Text)
				Text = tostring(Text)
				Items["Text"].Instance.Text = Text
				Items["Watermark"]:Tween(nil, { Size = UDim2New(0, Items["Text"].Instance.TextBounds.X + 20, 0, 30) })
			end

			function Watermark:SetVisibility(Bool)
				Items["Watermark"].Instance.Visible = Bool
			end

			Watermark:SetText(Name)

			return Watermark
		end

		Library.KeybindList = function(self)
			local KeybindList = {}
			self.KeyList = KeybindList

			local Items = {}
			do
				Items["KeybindList"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0, 0.5),
					Position = UDim2New(0, 20, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = FromRGB(24, 28, 36),
				})
				Items["KeybindList"]:AddToTheme({ BackgroundColor3 = "Background 2" })

				Instances:Create("UIPadding", {
					Parent = Items["KeybindList"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 9),
					PaddingBottom = UDimNew(0, 9),
					PaddingRight = UDimNew(0, 9),
					PaddingLeft = UDimNew(0, 9),
				})

				Items["Liner"] = Instances:Create("Frame", {
					Parent = Items["KeybindList"].Instance,
					Name = "\0",
					Position = UDim2New(0, -9, 0, -9),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 18, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				Items["Liner"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Items["Glow"] = Instances:Create("ImageLabel", {
					Parent = Items["Liner"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(94, 213, 213),
					ScaleType = Enum.ScaleType.Slice,
					ImageTransparency = 0.5,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundColor3 = FromRGB(94, 213, 213),
					Size = UDim2New(0, 113, 1, 8),
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "rbxassetid://18245826428",
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
				})
				Items["Glow"]:AddToTheme({ ImageColor3 = "Accent" })

				Instances:Create("UIGradient", {
					Parent = Items["Glow"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({ NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1) }),
				})

				Items["Title"] = Instances:Create("TextLabel", {
					Parent = Items["KeybindList"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "Keybinds",
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2New(0, 75, 0, 15),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Title"]:AddToTheme({ TextColor3 = "Text" })

				Items["Liner2"] = Instances:Create("Frame", {
					Parent = Items["KeybindList"].Instance,
					Name = "\0",
					Position = UDim2New(0, 0, 0, 21),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(46, 52, 61),
				})
				Items["Liner2"]:AddToTheme({ BackgroundColor3 = "Border" })

				Items["Content"] = Instances:Create("Frame", {
					Parent = Items["KeybindList"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0, 28),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Instances:Create("UIStroke", {
					Parent = Items["KeybindList"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })
			end

			function KeybindList:SetVisibility(Bool)
				Items["KeybindList"].Instance.Visible = Bool
			end

			function KeybindList:Add(Name, Key)
				local NewKey = Instances:Create("TextLabel", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.4000000059604645,
					Text = Name .. " [" .. Key .. "]",
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					BorderColor3 = FromRGB(0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				NewKey:AddToTheme({ TextColor3 = "Text" })

				function NewKey:SetText(Name, Key)
					NewKey.Instance.Text = Name .. " [" .. Key .. "]"
				end

				function NewKey:SetStatus(Bool)
					if NewKey.Instance.Text:find("Menu Keybind") then
						NewKey.Instance.Visible = false
						return
					end
					NewKey.Instance.Visible = Bool
				end

				return NewKey
			end

			return KeybindList
		end


		Library.ArmorViewer = function(self)
			local Viewer = {
				Items = {},
			}

			local Items = {}
			do
				Items["ArmorViewer"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					Position = UDim2New(0, 0, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 295, 0, 220),
					BorderSizePixel = 0,
					ZIndex = 8,
					BackgroundColor3 = FromRGB(24, 28, 36),
				})
				Items["ArmorViewer"]:AddToTheme({ BackgroundColor3 = "Background 2" })

				Items["ArmorViewer"]:MakeDraggable()
				Items["ArmorViewer"]:MakeResizeable(Vector2New(295, 220), Vector2New(9999, 9999))

				Items["Liner"] = Instances:Create("Frame", {
					Parent = Items["ArmorViewer"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 2),
					BorderSizePixel = 0,
					ZIndex = 8,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				Items["Liner"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Items["Glow"] = Instances:Create("ImageLabel", {
					Parent = Items["Liner"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(94, 213, 213),
					ScaleType = Enum.ScaleType.Slice,
					ImageTransparency = 0.5,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundColor3 = FromRGB(94, 213, 213),
					Size = UDim2New(1, 8, 1, 8),
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "rbxassetid://18245826428",
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					ZIndex = 8,
					BorderSizePixel = 0,
					SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
				})
				Items["Glow"]:AddToTheme({ ImageColor3 = "Accent" })

				Instances:Create("UIGradient", {
					Parent = Items["Glow"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({ NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1) }),
				})

				Items["Title"] = Instances:Create("TextLabel", {
					Parent = Items["ArmorViewer"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "inventory",
					Size = UDim2New(0, 0, 0, 15),
					Position = UDim2New(0, 8, 0, 8),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					ZIndex = 8,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Title"]:AddToTheme({ TextColor3 = "Text" })

				Items["Holder"] = Instances:Create("Frame", {
					Parent = Items["ArmorViewer"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 32),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, -16, 1, -40),
					BorderSizePixel = 0,
					ZIndex = 8,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = Items["Holder"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["RealHolder"] = Instances:Create("ScrollingFrame", {
					Parent = Items["Holder"].Instance,
					Name = "\0",
					Active = true,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					BorderSizePixel = 0,
					CanvasSize = UDim2New(0, 0, 0, 0),
					ScrollBarImageColor3 = FromRGB(46, 52, 61),
					MidImage = "rbxassetid://93024691806056",
					BorderColor3 = FromRGB(0, 0, 0),
					ScrollBarThickness = 3,
					Size = UDim2New(1, -4, 1, -8),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0, 4),
					ZIndex = 8,
					BottomImage = "rbxassetid://93024691806056",
					TopImage = "rbxassetid://93024691806056",
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["RealHolder"]:AddToTheme({ ScrollBarImageColor3 = "Border" })

				Instances:Create("UIGridLayout", {
					Parent = Items["RealHolder"].Instance,
					Name = "\0",
					SortOrder = Enum.SortOrder.LayoutOrder,
					CellPadding = UDim2New(0, 8, 0, 8),
					CellSize = UDim2New(0, 82, 0, 82),
				})

				Instances:Create("UIPadding", {
					Parent = Items["RealHolder"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 1),
					PaddingBottom = UDimNew(0, 6),
					PaddingRight = UDimNew(0, 8),
					PaddingLeft = UDimNew(0, 5),
				})
			end

			function Viewer:Add(Name, Icon)
				local NewItemTable = {}

				local NewItem = Instances:Create("Frame", {
					Parent = Items["RealHolder"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 8,
					Size = UDim2New(0, 100, 0, 100),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = NewItem.Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				local NewIcon = Instances:Create("ImageLabel", {
					Parent = NewItem.Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0.5, 0.5),
					ZIndex = 8,
					Image = "rbxassetid://" .. Icon,
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					Size = UDim2New(0, 50, 0, 50),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				function NewItemTable:Remove()
					NewItem:Clean()
					Viewer.Items[Name] = nil
				end

				Viewer.Items[Name] = NewItem
				return NewItemTable
			end

			function Viewer:ClearAllItems()
				for Index, Value in Viewer.Items do
					Value:Remove()
				end
			end

			function Viewer:SetVisibility(Bool)
				Items["ArmorViewer"].Instance.Visible = Bool
			end

			function Viewer:SetTitle(Name)
				Items["Title"].Instance.Text = Name
			end

			function Viewer:SetPosition(Position)
				Items["ArmorViewer"].Instance.Position = Position
			end

			return Viewer
		end

		Library.Notification = function(self, Name, Duration)
			local Items = {}
			do
				Items["Notification"] = Instances:Create("Frame", {
					Parent = self.NotifHolder.Instance,
					Name = "\0",
					Size = UDim2New(0, 20, 0, 20),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = FromRGB(24, 28, 36),
				})
				Items["Notification"]:AddToTheme({ BackgroundColor3 = "Inline" })

				Instances:Create("UIPadding", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 7),
					PaddingBottom = UDimNew(0, 7),
					PaddingRight = UDimNew(0, 7),
					PaddingLeft = UDimNew(0, 7),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Name,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })

				Instances:Create("UIStroke", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })
			end

			local Size = Items["Notification"].Instance.AbsoluteSize

			for Index, Value in Items do
				if Value.Instance:IsA("Frame") then
					Value.Instance.BackgroundTransparency = 1
				elseif Value.Instance:IsA("TextLabel") then
					Value.Instance.TextTransparency = 1
				end
			end

			Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None

			Library:Thread(function()
				for Index, Value in Items do
					if Value.Instance:IsA("Frame") then
						Value:Tween(nil, { BackgroundTransparency = 0 })
					elseif Value.Instance:IsA("TextLabel") then
						Value:Tween(nil, { TextTransparency = 0 })
					end
				end

				Items["Notification"]:Tween(nil, { Size = UDim2New(0, Size.X, 0, Size.Y) })

				task.delay(Duration + 0.1, function()
					for Index, Value in Items do
						if Value.Instance:IsA("Frame") then
							Value:Tween(nil, { BackgroundTransparency = 1 })
						elseif Value.Instance:IsA("TextLabel") then
							Value:Tween(nil, { TextTransparency = 1 })
						end
					end

					Items["Notification"]:Tween(nil, { Size = UDim2New(0, 0, 0, 0) })

					task.wait(0.5)
					Items["Notification"]:Clean()
				end)
			end)
		end

		Library.TargetHud = function(self)
			local TargetHud = {}

			local Items = {}
			do
				Items["TargetHud"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					Size = UDim2New(0, 295, 0, 21),
					Position = UDim2New(0, 0, 0.8, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					ZIndex = 6,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = FromRGB(17, 21, 27),
					Visible = false,
				})
				Items["TargetHud"]:AddToTheme({ BackgroundColor3 = "Background 1" })

				Items["TargetHud"]:MakeDraggable()

				Instances:Create("UIStroke", {
					Parent = Items["TargetHud"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["Title"] = Instances:Create("TextLabel", {
					Parent = Items["TargetHud"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "Target Hud",
					Size = UDim2New(0, 0, 0, 15),
					Position = UDim2New(0, 8, 0, 8),
					BackgroundTransparency = 1,
					ZIndex = 6,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Title"]:AddToTheme({ TextColor3 = "Text" })

				Items["Liner"] = Instances:Create("Frame", {
					Parent = Items["TargetHud"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 2),
					ZIndex = 6,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				Items["Liner"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Items["Glow"] = Instances:Create("ImageLabel", {
					Parent = Items["Liner"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(94, 213, 213),
					ScaleType = Enum.ScaleType.Slice,
					ImageTransparency = 0.5,
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 6,
					BackgroundColor3 = FromRGB(94, 213, 213),
					Size = UDim2New(1, 8, 1, 8),
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "rbxassetid://18245826428",
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					BorderSizePixel = 0,
					SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
				})
				Items["Glow"]:AddToTheme({ ImageColor3 = "Accent" })

				Instances:Create("UIGradient", {
					Parent = Items["Glow"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({ NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1) }),
				})

				Items["Content"] = Instances:Create("Frame", {
					Parent = Items["TargetHud"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					ZIndex = 6,
					Position = UDim2New(0, 8, 0, 32),
					Size = UDim2New(1, -16, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["Avatar"] = Instances:Create("ImageLabel", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
					BackgroundTransparency = 1,
					ZIndex = 6,
					Size = UDim2New(0, 70, 0, 70),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Username"] = Instances:Create("TextLabel", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "-- (@--)",
					Size = UDim2New(1, -77, 0, 15),
					ZIndex = 6,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2New(0, 77, 0, 0),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Username"]:AddToTheme({ TextColor3 = "Text" })

				Instances:Create("UIPadding", {
					Parent = Items["TargetHud"].Instance,
					Name = "\0",
					PaddingBottom = UDimNew(0, 8),
				})

				Instances:Create("UIPadding", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 9),
					PaddingBottom = UDimNew(0, 8),
					PaddingRight = UDimNew(0, 9),
					PaddingLeft = UDimNew(0, 9),
				})

				Items["Bars"] = Instances:Create("Frame", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0, 1),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 77, 1, 0),
					Size = UDim2New(1, -77, 0, 0),
					BorderSizePixel = 0,
					ZIndex = 6,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Bars"].Instance,
					Name = "\0",
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					Padding = UDimNew(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})
			end

			function TargetHud:AddBar(Color)
				local NewBar = {}

				local NewBarBackground = Instances:Create("Frame", {
					Parent = Items["Bars"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0, 1),
					ZIndex = 6,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 77, 1, 0),
					Size = UDim2New(1, 0, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = NewBarBackground.Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				local BarAccent = Instances:Create("Frame", {
					Parent = NewBarBackground.Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0.8999999761581421, 0, 1, 0),
					ZIndex = 6,
					BorderSizePixel = 0,
					BackgroundColor3 = Color,
				})

				Instances:Create("UIGradient", {
					Parent = BarAccent.Instance,
					Name = "\0",
					Rotation = 90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(153, 153, 153)),
					}),
				})

				local BarValue = Instances:Create("TextLabel", {
					Parent = NewBarBackground.Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					ZIndex = 6,
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "90",
					Size = UDim2New(0, 0, 1, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 1, 0, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				BarValue:AddToTheme({ TextColor3 = "Text" })

				Instances:Create("UIStroke", {
					Parent = BarValue.Instance,
					Name = "\0",
				})

				function NewBar:SetPercentage(Percentage)
					local RealPercentage = 1 / 100 * Percentage

					if BarAccent and NewBarBackground then
						BarAccent:Tween(
							TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{ Size = UDim2New(RealPercentage, 0, 1, 0) }
						)
						BarValue.Instance.Text = math.floor(Percentage)
					end
				end

				function NewBar:Remove()
					NewBarBackground:Clean()
					NewBar = nil
				end

				return NewBar
			end

			function TargetHud:SetPlayer(Player)
				local AvatarContent = Players:GetUserThumbnailAsync(
					Player.UserId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size420x420
				)
				Items["Avatar"].Instance.Image = AvatarContent
				Items["Username"].Instance.Text = Player.DisplayName .. " (@" .. Player.Name .. ")"
			end

			function TargetHud:SetVisibility(Bool)
				Items["TargetHud"].Instance.Visible = Bool
			end

			function TargetHud:SetPosition(Position)
				Items["TargetHud"].Instance.Position = Position
			end

			return TargetHud
		end

		Library.Window = function(self, Data)
			Data = Data or {}

			local Window = {
				Name = Data.Name or Data.name or "Bronx Dupe",
				Logo = Data.Logo or Data.logo or "121644323941494",

				Pages = {},
				Items = {},
				IsOpen = false,
			}

			local Items = {}
			do
				Items["MainFrame"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0.5, 0.5),
					Position = UDim2New(0.5, 0, 0.5, 0),
					BorderColor3 = FromRGB(0, 34, 37),
					Size = not IsMobile and UDim2New(0, 621, 0, 542) or UDim2New(0, 375, 0, 400),
					BorderSizePixel = 2,
					BackgroundColor3 = FromRGB(17, 21, 27),
				})
				Items["MainFrame"]:AddToTheme({ BackgroundColor3 = "Background 1" })

				Library.MainFrame = Items["MainFrame"].Instance

				Items["MainFrame"]:MakeDraggable()
				Items["MainFrame"]:MakeResizeable(Vector2New(621, 542), Vector2New(9999, 9999))

				Items["UIStroke"] = Instances:Create("UIStroke", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					Color = FromRGB(94, 213, 213),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				})
				Items["UIStroke"]:AddToTheme({ Color = "Accent" })

				Instances:Create("UIGradient", {
					Parent = Items["UIStroke"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({
						NumSequenceKeypoint(0, 0),
						NumSequenceKeypoint(0.696, 0.2749999761581421),
						NumSequenceKeypoint(0.84, 0.574999988079071),
						NumSequenceKeypoint(1, 1),
					}),
				})

				Items["Inline"] = Instances:Create("Frame", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = UDim2New(0, 1, 0, 1),
					BorderColor3 = FromRGB(0, 34, 37),
					Size = UDim2New(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = Items["Inline"].Instance,
					Name = "\0",
					Color = FromRGB(0, 34, 37),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Window Outline" })

				Items["Logo"] = Instances:Create("ImageLabel", {
					Parent = Items["Inline"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(255, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Image = "rbxassetid://77298421442104",
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 10),
					Size = UDim2New(0, 18, 0, 18),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 0, 0),
				})

				Items["Title"] = Instances:Create("TextLabel", {
					Parent = Items["Inline"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Window.Name,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 32, 0, 10),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Title"]:AddToTheme({ TextColor3 = "Text" })

				Items["Content"] = Instances:Create("Frame", {
					Parent = Items["Inline"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 7, 0, 39),
					ClipsDescendants = true,
					Size = UDim2New(1, -14, 1, -46),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["Pages"] = Instances:Create("Frame", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 30),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Pages"].Instance,
					Name = "\0",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = UDimNew(0, 1),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["Glow"] = Instances:Create("ImageLabel", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(94, 213, 213),
					ScaleType = Enum.ScaleType.Slice,
					ImageTransparency = 0.5,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundColor3 = FromRGB(255, 255, 255),
					Size = UDim2New(1, 25, 1, 25),
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "rbxassetid://18245826428",
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					ZIndex = -1,
					BorderSizePixel = 0,
					SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
				})
				Items["Glow"]:AddToTheme({ ImageColor3 = "Accent" })

				Instances:Create("UIGradient", {
					Parent = Items["Glow"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({ NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1) }),
				})

				Window.Items = Items
			end

			local Debounce = false

			function Window:SetCenter()
				local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
				task.wait()
				Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)

				Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
			end

			function Window:SetOpen(Bool)
				for Index, Value in Library.OpenFrames do
					Value:SetOpen(false)
				end

				if Debounce then
					return
				end

				Window.IsOpen = Bool

				Debounce = true

				if Window.IsOpen then
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
							NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
						end
					else
						NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
					end
				end

				NewTween.Tween.Completed:Connect(function()
					Debounce = false
					Items["MainFrame"].Instance.Visible = Window.IsOpen
				end)
			end

			Library:Connect(UserInputService.InputBegan, function(Input)
				if
					tostring(Input.KeyCode) == Library.MenuKeybind
					or tostring(Input.UserInputType) == Library.MenuKeybind
				then
					Window:SetOpen(not Window.IsOpen)
				end
			end)

			Window:SetCenter()
			task.wait()
			Window:SetOpen(true)
			return setmetatable(Window, Library)
		end

		Library.Page = function(self, Data)
			Data = Data or {}

			local Page = {
				Window = self,

				Name = Data.Name or Data.name or "Page",
				Columns = Data.Columns or Data.columns or 2,

				Items = {},
				ColumnsData = {},
				Active = false,
			}

			local Items = {}
			do
				Items["Inactive"] = Instances:Create("TextButton", {
					Parent = Page.Window.Items["Pages"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 1, 0),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["Liner"] = Instances:Create("Frame", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 1),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				Items["Liner"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Items["Glow"] = Instances:Create("ImageLabel", {
					Parent = Items["Liner"].Instance,
					Name = "\0",
					Visible = false,
					ImageTransparency = 0.5,
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "rbxassetid://18245826428",
					ZIndex = 2,
					BorderSizePixel = 0,
					SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
					ScaleType = Enum.ScaleType.Slice,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					ImageColor3 = FromRGB(94, 213, 213),
					Size = UDim2New(1, 8, 1, 8),
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Glow"]:AddToTheme({ ImageColor3 = "Accent" })

				Instances:Create("UIGradient", {
					Parent = Items["Glow"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({ NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1) }),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.4000000059604645,
					Text = Page.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					AnchorPoint = Vector2New(0.5, 0.5),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 5,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })

				Items["TextGlow"] = Instances:Create("ImageLabel", {
					Parent = Items["Text"].Instance,
					Name = "\0",
					ScaleType = Enum.ScaleType.Slice,
					ImageTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundColor3 = FromRGB(255, 255, 255),
					Size = UDim2New(1, 8, 1, 8),
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "rbxassetid://18245826428",
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 3),
					ZIndex = 2,
					BorderSizePixel = 0,
					SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
				})
				Items["TextGlow"]:AddToTheme({ ImageColor3 = "Text" })

				Instances:Create("UIGradient", {
					Parent = Items["TextGlow"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({ NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1) }),
				})

				Items["Hide"] = Instances:Create("Frame", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0, 1),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 1, 1),
					Size = UDim2New(1, 0, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(17, 21, 27),
				})
				Items["Hide"]:AddToTheme({ BackgroundColor3 = "Background 1" })

				Items["Page"] = Instances:Create("Frame", {
					Parent = Library.UnusedHolder.Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0, 80),
					BorderColor3 = FromRGB(0, 0, 0),
					Visible = false,
					Size = UDim2New(1, 0, 1, -35),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Page"].Instance,
					Name = "\0",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill,
				})

				for Index = 1, Page.Columns do
					local NewColumn = Instances:Create("ScrollingFrame", {
						Parent = Items["Page"].Instance,
						Name = "\0",
						ScrollBarImageColor3 = FromRGB(0, 0, 0),
						Active = true,
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						BorderColor3 = FromRGB(0, 0, 0),
						ScrollBarThickness = 0,
						BackgroundTransparency = 1,
						Size = UDim2New(0, 100, 0, 100),
						CanvasSize = UDim2New(0, 0, 0, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = FromRGB(255, 255, 255),
					})

					Instances:Create("UIPadding", {
						Parent = NewColumn.Instance,
						Name = "\0",
						PaddingTop = UDimNew(0, 5),
						PaddingBottom = UDimNew(0, 8),
						PaddingRight = UDimNew(0, 8),
						PaddingLeft = UDimNew(0, 8),
					})

					Instances:Create("UIListLayout", {
						Parent = NewColumn.Instance,
						Name = "\0",
						Padding = UDimNew(0, 12),
						SortOrder = Enum.SortOrder.LayoutOrder,
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

				Page.Active = Bool

				Debounce = true
				Items["Page"].Instance.Visible = Bool
				Items["Page"].Instance.Parent = Bool and Page.Window.Items["Content"].Instance
					or Library.UnusedHolder.Instance

				if Page.Active then
					Items["Liner"]:Tween(
						TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
						{ BackgroundTransparency = 0, Size = UDim2New(1, 0, 0, 1) }
					)
					Items["TextGlow"]:Tween(nil, { ImageTransparency = 0.7 })
					Items["Text"]:Tween(nil, { TextTransparency = 0 })
					Items["Hide"]:Tween(nil, { BackgroundTransparency = 0 })

					Items["Page"]:Tween(
						TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
						{ Position = UDim2New(0, 0, 0, 35) }
					)
				else
					Items["Liner"]:Tween(
						TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
						{ BackgroundTransparency = 0, Size = UDim2New(0, 0, 0, 1) }
					)
					Items["TextGlow"]:Tween(nil, { ImageTransparency = 1 })
					Items["Text"]:Tween(nil, { TextTransparency = 0.4 })
					Items["Hide"]:Tween(nil, { BackgroundTransparency = 1 })

					Items["Page"]:Tween(
						TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
						{ Position = UDim2New(0, 0, 0, 80) }
					)
				end

				Debounce = false
			end

			Items["Inactive"]:Connect("MouseButton1Down", function()
				for Index, Value in Page.Window.Pages do
					if Value == Page and Page.Active then
						return
					end

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
			Data = Data or {}

			local Section = {
				Window = self.Window,
				Page = self,

				Name = Data.Name or Data.name or "Section",
				Side = Data.Side or Data.side or 1,

				Items = {},
			}

			local Items = {}
			do
				Items["Section"] = Instances:Create("Frame", {
					Parent = Section.Page.ColumnsData[Section.Side].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 0, 40),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = FromRGB(19, 25, 31),
				})
				Items["Section"]:AddToTheme({ BackgroundColor3 = "Inline" })

				Instances:Create("UIStroke", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Instances:Create("UIPadding", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					PaddingBottom = UDimNew(0, 8),
				})

				Items["Topbar"] = Instances:Create("Frame", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 25),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(19, 25, 31),
				})
				Items["Topbar"]:AddToTheme({ BackgroundColor3 = "Inline" })

				Instances:Create("UIGradient", {
					Parent = Items["Topbar"].Instance,
					Name = "\0",
					Rotation = 90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(165, 165, 165)),
					}),
				})

				Instances:Create("UIStroke", {
					Parent = Items["Topbar"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["Liner"] = Instances:Create("Frame", {
					Parent = Items["Topbar"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 1, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				Items["Liner"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Instances:Create("UIGradient", {
					Parent = Items["Liner"].Instance,
					Name = "\0",
					Rotation = 90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(171, 171, 171)),
					}),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Topbar"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Section.Name,
					AnchorPoint = Vector2New(0, 0.5),
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0.5, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })

				Items["Content"] = Instances:Create("Frame", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 35),
					Size = UDim2New(1, -16, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Section.Items = Items
			end

			return setmetatable(Section, Library.Sections)
		end

		Library.Sections.Toggle = function(self, Data)
			Data = Data or {}

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

			local Items = {}
			do
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
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["IndicatorOutline"] = Instances:Create("Frame", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0, 0.5),
					Position = UDim2New(0, 0, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 12, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["IndicatorOutline"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UIStroke", {
					Parent = Items["IndicatorOutline"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["IndicatorInline"] = Instances:Create("Frame", {
					Parent = Items["IndicatorOutline"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, -2, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				Items["IndicatorInline"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.4000000059604645,
					Text = Toggle.Name,
					Size = UDim2New(0, 0, 0, 15),
					AnchorPoint = Vector2New(0, 0.5),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 20, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })

				Items["SubElements"] = Instances:Create("Frame", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(1, 0, 0, 0),
					Size = UDim2New(0, 0, 1, 0),
					ZIndex = 2,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["SubElements"].Instance,
					Name = "\0",
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = UDimNew(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["Toggle"]:OnHover(function()
					-- if Toggle.Value then return end
					Items["IndicatorOutline"]:Tween(
						nil,
						{ BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35) }
					)
				end)

				Items["Toggle"]:OnHoverLeave(function()
					-- if Toggle.Value then return end
					Items["IndicatorOutline"]:Tween(nil, { BackgroundColor3 = Library.Theme.Element })
				end)
			end

			function Toggle:Get()
				return Toggle.Value
			end

			function Toggle:Set(Value)
				Toggle.Value = Value
				Library.Flags[Toggle.Flag] = Value

				if Toggle.Value then
					Items["IndicatorInline"]:Tween(
						TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
						{ BackgroundTransparency = 0, Size = UDim2New(1, -2, 1, -2) }
					)
				else
					Items["IndicatorInline"]:Tween(
						TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
						{ BackgroundTransparency = 1, Size = UDim2New(0, -2, 0, -2) }
					)
				end

				if Toggle.Callback then
					Library:SafeCall(Toggle.Callback, Toggle.Value)
				end
			end

			function Toggle:Colorpicker(Data)
				Data = Data or {}

				local Colorpicker = {
					Window = Toggle.Window,
					Page = Toggle.Page,
					Section = Toggle.Section,

					Flag = Data.Flag or Data.flag or Library:NextFlag(),
					Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
					Alpha = Data.Alpha or Data.alpha or 0,
					Callback = Data.Callback or Data.callback or function() end,
				}

				local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
					Parent = Items["SubElements"],
					Page = Colorpicker.Page,
					Flag = Colorpicker.Flag,
					Section = Colorpicker.Section,
					Default = Colorpicker.Default,
					Alpha = Colorpicker.Alpha,
					Callback = Colorpicker.Callback,
				})

				return NewColorpicker
			end

			function Toggle:Keybind(Data)
				Data = Data or {}

				local Keybind = {
					Window = Toggle.Window,
					Page = Toggle.Page,
					Section = Toggle.Section,

					Name = Data.Name or Data.name or "Keybind",
					Flag = Data.Flag or Data.flag or Library:NextFlag(),
					Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
					Callback = Data.Callback or Data.callback or function() end,
					Mode = Data.Mode or Data.mode or "Toggle",
				}

				local NewKeybind, Items = Library:CreateKeybind({
					Name = Toggle.Name,
					Parent = Items["SubElements"],
					Flag = Keybind.Flag,
					Section = Keybind.Section,
					Default = Keybind.Default,
					Mode = Keybind.Mode,
					Callback = Keybind.Callback,
				})

				return NewKeybind
			end

			function Toggle:SetVisibility(Bool)
				Items["Toggle"].Instance.Visible = Bool
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

		Library.Sections.Button = function(self, Data)
			Data = Data or {}

			local Button = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Button",
				Callback = Data.Callback or Data.callback or function() end,
			}

			local Items = {}
			do
				Items["Button"] = Instances:Create("TextButton", {
					Parent = Button.Section.Items["Content"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Button.Name,
					AutoButtonColor = false,
					Size = UDim2New(1, 0, 0, 20),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["Button"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UIGradient", {
					Parent = Items["Button"].Instance,
					Name = "\0",
					Rotation = 90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(199, 199, 199)),
					}),
				})

				Items["Button"]:OnHover(function()
					Items["Button"]:Tween(
						nil,
						{ BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35) }
					)
				end)

				Items["Button"]:OnHoverLeave(function()
					Items["Button"]:Tween(nil, { BackgroundColor3 = Library.Theme.Element })
				end)
			end

			function Button:SetVisibility(Bool)
				Items["Button"].Instance.Visible = Bool
			end

			function Button:Press()
				Items["Button"]:ChangeItemTheme({ BackgroundColor3 = "Accent" })
				Items["Button"]:Tween(nil, { BackgroundColor3 = Library.Theme.Accent })
				Library:SafeCall(Button.Callback)
				task.wait(0.1)
				Items["Button"]:ChangeItemTheme({ BackgroundColor3 = "Element" })
				Items["Button"]:Tween(nil, { BackgroundColor3 = Library.Theme.Element })
			end

			Items["Button"]:Connect("MouseButton1Down", function()
				Button:Press()
			end)

			return Button
		end

		Library.Sections.Slider = function(self, Data)
			Data = Data or {}

			local Slider = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Slider",
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Min = Data.Min or Data.min or 0,
				Decimals = Data.Decimals or Data.decimals or 1,
				Suffix = Data.Suffix or Data.suffix or "",
				Max = Data.Max or Data.max or 100,
				Default = Data.Default or Data.Default or 0,
				Callback = Data.Callback or Data.callback or function() end,

				Value = 0,
				Sliding = false,
			}

			local Items = {}
			do
				Items["Slider"] = Instances:Create("Frame", {
					Parent = Slider.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 35),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Slider"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Slider.Name,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 15),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })

				Items["RealSlider"] = Instances:Create("TextButton", {
					Parent = Items["Slider"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(0, 1),
					Position = UDim2New(0, 0, 1, 0),
					Size = UDim2New(1, 0, 0, 12),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["RealSlider"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UIStroke", {
					Parent = Items["RealSlider"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["Accent"] = Instances:Create("Frame", {
					Parent = Items["RealSlider"].Instance,
					Name = "\0",
					Position = UDim2New(0, 1, 0, 1),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0.5, 0, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				Items["Accent"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Items["Value"] = Instances:Create("TextBox", {
					Parent = Items["Slider"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					Active = false,
					TextTransparency = 0.5,
					AnchorPoint = Vector2New(1, 0),
					TextSize = 14,
					Size = UDim2New(0, 0, 0, 15),
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "50s",
					Selectable = false,
					BackgroundTransparency = 1,
					Position = UDim2New(1, 0, 0, 0),
					BorderSizePixel = 0,
					ClearTextOnFocus = false,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Value"]:AddToTheme({ TextColor3 = "Text" })

				Items["RealSlider"]:OnHover(function()
					Items["RealSlider"]:Tween(
						nil,
						{ BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35) }
					)
				end)

				Items["RealSlider"]:OnHoverLeave(function()
					Items["RealSlider"]:Tween(nil, { BackgroundColor3 = Library.Theme.Element })
				end)
			end

			function Slider:Get()
				return Slider.Value
			end

			function Slider:Set(Value)
				Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)
				Library.Flags[Slider.Flag] = Slider.Value

				Items["Accent"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), -2, 1, -2) }
				)
				Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)

				if Slider.Value <= Slider.Min then
					Items["Accent"].Instance.Visible = false
				else
					Items["Accent"].Instance.Visible = true
				end

				if Slider.Callback then
					Library:SafeCall(Slider.Callback, Slider.Value)
				end
			end

			local InputChanged

			Items["RealSlider"]:Connect("InputBegan", function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					Slider.Sliding = true

					local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X)
						/ Items["RealSlider"].Instance.AbsoluteSize.X
					local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

					Slider:Set(Value)

					if InputChanged then return end 

					InputChanged = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then 
							Slider.Sliding = false

							if InputChanged then
								InputChanged:Disconnect()
								InputChanged = nil
							end
						end
					end)
				end
			end)

			Library:Connect(UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
					if Slider.Sliding then
						local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X)
							/ Items["RealSlider"].Instance.AbsoluteSize.X
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
			Data = Data or {}

			local Dropdown = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Dropdown",
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Items = Data.Items or Data.items or Data.Options or Data.options or { "One", "Two", "Three" },
				Default = Data.Default or Data.default or nil,
				MaxSize = Data.MaxSize or Data.maxsize or 75,
				Callback = Data.Callback or Data.callback or function() end,
				Multi = Data.Multi or Data.multi or false,

				Options = {},
				Value = {},
				IsOpen = false,
			}

			local Items = {}
			do
				Items["Dropdown"] = Instances:Create("Frame", {
					Parent = Dropdown.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, 45),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Dropdown"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Dropdown.Name,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 15),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })

				Items["RealDropdown"] = Instances:Create("TextButton", {
					Parent = Items["Dropdown"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(0, 1),
					Position = UDim2New(0, 0, 1, 0),
					Size = UDim2New(1, 0, 0, 20),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["RealDropdown"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UIStroke", {
					Parent = Items["RealDropdown"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["Value"] = Instances:Create("TextLabel", {
					Parent = Items["RealDropdown"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "-",
					AnchorPoint = Vector2New(0, 0.5),
					Size = UDim2New(1, -16, 0, 15),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2New(0, 4, 0.5, 0),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Value"]:AddToTheme({ TextColor3 = "Text" })

				Items["OptionHolder"] = Instances:Create("TextButton", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					FontFace = Library.Font,
					Visible = false,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					Position = UDim2New(0, 0, 1, 0),
					Size = UDim2New(1, 0, 0, 130),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["OptionHolder"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UIStroke", {
					Parent = Items["OptionHolder"].Instance,
					Name = "\0",
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Border" })

				Items["Search"] = Instances:Create("TextBox", {
					Parent = Items["OptionHolder"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.5,
					Text = "",
					Size = UDim2New(1, -8, 0, 15),
					Position = UDim2New(0, 4, 0, 4),
					BorderSizePixel = 0,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					PlaceholderColor3 = FromRGB(255, 255, 255),
					TextXAlignment = Enum.TextXAlignment.Left,
					PlaceholderText = "Search..",
					TextSize = 12,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Search"]:AddToTheme({ TextColor3 = "Text" })

				Items["Holder"] = Instances:Create("ScrollingFrame", {
					Parent = Items["OptionHolder"].Instance,
					Name = "\0",
					Active = true,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					BorderSizePixel = 0,
					CanvasSize = UDim2New(0, 0, 0, 0),
					ScrollBarImageColor3 = FromRGB(46, 52, 61),
					MidImage = "rbxassetid://93024691806056",
					BorderColor3 = FromRGB(0, 0, 0),
					ScrollBarThickness = 4,
					Size = UDim2New(1, -4, 1, -26),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0, 22),
					BottomImage = "rbxassetid://93024691806056",
					TopImage = "rbxassetid://93024691806056",
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Holder"]:AddToTheme({ ScrollBarImageColor3 = "Border" })

				Instances:Create("UIPadding", {
					Parent = Items["Holder"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 6),
					PaddingBottom = UDimNew(0, 6),
					PaddingRight = UDimNew(0, 10),
					PaddingLeft = UDimNew(0, 6),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Holder"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["RealDropdown"]:OnHover(function()
					Items["RealDropdown"]:Tween(
						nil,
						{ BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35) }
					)
				end)

				Items["RealDropdown"]:OnHoverLeave(function()
					Items["RealDropdown"]:Tween(nil, { BackgroundColor3 = Library.Theme.Element })
				end)
			end

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
							continue
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

					Dropdown.Value = Option
					Library.Flags[Dropdown.Flag] = Option

					for Index, Value in Dropdown.Options do
						if Value ~= OptionData then
							Value.Selected = false
							Value:Toggle("Inactive")
						else
							Value.Selected = true
							Value:Toggle("Active")
						end
					end

					Items["Value"].Instance.Text = Option
				end

				if Dropdown.Callback then
					Library:SafeCall(Dropdown.Callback, Dropdown.Value)
				end
			end

			local CompareVectors = function(PointA, PointB)
				return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
			end

			local IsClipped = function(Object, Column)
				local Parent = Column

				local BoundryTop = Parent.AbsolutePosition
				local BoundryBottom = BoundryTop + Parent.AbsoluteSize

				local Top = Object.AbsolutePosition
				local Bottom = Top + Object.AbsoluteSize

				return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
			end

			Items["RealDropdown"]:Connect("Changed", function(Property)
				if Property == "AbsolutePosition" and Dropdown.IsOpen then
					Dropdown.IsOpen =
						not IsClipped(Items["OptionHolder"].Instance, Dropdown.Section.Items["Section"].Instance.Parent)
					Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
				end
			end)

			local Debounce = false
			local RenderStepped

			function Dropdown:SetOpen(Bool)
				if Debounce then
					return
				end

				Dropdown.IsOpen = Bool
				Debounce = true

				if Bool then
					Items["OptionHolder"].Instance.Visible = true
					Items["OptionHolder"].Instance.Parent = Library.Holder.Instance

					RenderStepped = RunService.RenderStepped:Connect(function()
						Items["OptionHolder"].Instance.Position = UDim2New(
							0,
							Items["RealDropdown"].Instance.AbsolutePosition.X,
							0,
							Items["RealDropdown"].Instance.AbsolutePosition.Y
								+ Items["RealDropdown"].Instance.AbsoluteSize.Y
								+ 65
						)

						Items["OptionHolder"].Instance.Size =
							UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, Dropdown.MaxSize)
					end)

					for Index, Value in Library.OpenFrames do
						if Value ~= Dropdown then
							Value:SetOpen(false)
						end
					end

					Library.OpenFrames[Dropdown] = Dropdown
				else
					if RenderStepped then
						RenderStepped:Disconnect()
						RenderStepped = nil
					end

					if Library.OpenFrames[Dropdown] then
						Library.OpenFrames[Dropdown] = nil
					end
				end

				local AllInstances = Items["OptionHolder"].Instance:GetDescendants()
				TableInsert(AllInstances, Items["OptionHolder"].Instance)

				local NewTween

				for Index, Value in AllInstances do
					local TransparencyProperty = Tween:GetProperty(Value)

					if not TransparencyProperty then
						continue
					end

					if not Value.ClassName:find("UI") then
						Value.ZIndex = Dropdown.IsOpen and 10 or 1
					end

					if type(TransparencyProperty) == "table" then
						for _, Property in TransparencyProperty do
							NewTween = Tween:FadeItem(Value, Property, Bool, 0.2)
						end
					else
						NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, 0.2)
					end
				end

				Library:Connect(NewTween.Tween.Completed, function()
					Debounce = false
					Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
					task.wait(0.2)
					Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance
						or Library.Holder.Instance
				end)
			end

			function Dropdown:Add(Option)
				local OptionButton = Instances:Create("TextButton", {
					Parent = Items["Holder"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, 20),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				OptionButton:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UIGradient", {
					Parent = OptionButton.Instance,
					Name = "\0",
					Rotation = -90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(200, 200, 200)),
					}),
				})

				local OptionStroke = Instances:Create("UIStroke", {
					Parent = OptionButton.Instance,
					Name = "\0",
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Transparency = 1,
					Color = FromRGB(46, 52, 61),
					LineJoinMode = Enum.LineJoinMode.Miter,
				})
				OptionStroke:AddToTheme({ Color = "Border" })

				local OptionLiner = Instances:Create("Frame", {
					Parent = OptionButton.Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 1, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(94, 213, 213),
				})
				OptionLiner:AddToTheme({ BackgroundColor3 = "Accent" })

				local OptionText = Instances:Create("TextLabel", {
					Parent = OptionButton.Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.4000000059604645,
					Text = Option,
					Size = UDim2New(0, 0, 0, 15),
					AnchorPoint = Vector2New(0, 0.5),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 10, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				OptionText:AddToTheme({ TextColor3 = "Text" })

				local OptionData = {
					Button = OptionButton,
					Selected = false,
					Name = Option,
					Text = OptionText,
					Liner = OptionLiner,
					Stroke = OptionStroke,
				}

				function OptionData:Toggle(Status)
					if Status == "Active" then
						OptionData.Liner:Tween(nil, { BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0) })
						OptionData.Text:Tween(nil, { TextTransparency = 0 })
						OptionData.Button:Tween(nil, { BackgroundTransparency = 0 })
						OptionData.Stroke:Tween(nil, { Transparency = 0 })
					else
						OptionData.Liner:Tween(nil, { BackgroundTransparency = 1 })
						OptionData.Text:Tween(nil, { TextTransparency = 0.4 })
						OptionData.Button:Tween(nil, { BackgroundTransparency = 1 })
						OptionData.Stroke:Tween(nil, { Transparency = 1 })
					end
				end

				function OptionData:Set()
					OptionData.Selected = not OptionData.Selected

					if Data.Multi then
						local Index = TableFind(Dropdown.Value, OptionData.Name)

						if Index then
							TableRemove(Dropdown.Value, Index)
						else
							TableInsert(Dropdown.Value, OptionData.Name)
						end

						OptionData:Toggle(Index and "Inactive" or "Active")

						Library.Flags[Dropdown.Flag] = Dropdown.Value

						local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"
						Items["Value"].Instance.Text = TextFormat
					else
						if OptionData.Selected then
							Dropdown.Value = OptionData.Name
							Library.Flags[Dropdown.Flag] = OptionData.Name

							OptionData.Selected = true
							OptionData:Toggle("Active")

							for Index, Value in Dropdown.Options do
								if Value ~= OptionData then
									Value.Selected = false
									Value:Toggle("Inactive")
								end
							end

							Items["Value"].Instance.Text = OptionData.Name
						else
							Dropdown.Value = nil
							Library.Flags[Dropdown.Flag] = nil

							OptionData.Selected = false
							OptionData:Toggle("Inactive")

							Items["Value"].Instance.Text = "-"
						end
					end

					if Dropdown.Callback then
						Library:SafeCall(Dropdown.Callback, Dropdown.Value)
					end
				end

				OptionData.Button:Connect("MouseButton1Down", function()
					OptionData:Set()
				end)

				Dropdown.Options[OptionData.Name] = OptionData
				return OptionData
			end

			function Dropdown:Remove(Option)
				local OptionData = Dropdown.Options[Option]
				if OptionData then
					OptionData.Button:Clean()
					Dropdown.Options[Option] = nil
				end
			end

			function Dropdown:Refresh(List)
				for Index, Value in Dropdown.Options do
					Dropdown:Remove(Value.Name)
				end

				for Index, Value in List do
					Dropdown:Add(Value)
				end
			end

			for Index, Value in Dropdown.Items do
				Dropdown:Add(Value)
			end

			Items["RealDropdown"]:Connect("MouseButton1Down", function()
				Dropdown:SetOpen(not Dropdown.IsOpen)
			end)

			Library:Connect(UserInputService.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not Dropdown.IsOpen then
						return
					end

					if Library:IsMouseOverFrame(Items["OptionHolder"]) then
						return
					end

					Dropdown:SetOpen(false)
				end
			end)

			local SearchStepped

			Items["Search"]:Connect("Focused", function()
				SearchStepped = RunService.RenderStepped:Connect(function()
					for Index, Value in Dropdown.Options do
						if Items["Search"].Instance.Text ~= "" then
							if
								StringFind(
									StringLower(Value.Name),
									Library:EscapePattern(StringLower(Items["Search"].Instance.Text))
								)
							then
								Value.Button.Instance.Visible = true
							else
								Value.Button.Instance.Visible = false
							end
						else
							Value.Button.Instance.Visible = true
						end
					end
				end)
			end)

			Items["Search"]:Connect("FocusLost", function()
				if SearchStepped then
					SearchStepped:Disconnect()
					SearchStepped = nil
				end
			end)

			Library.SetFlags[Dropdown.Flag] = function(Value)
				Dropdown:Set(Value)
			end

			if Dropdown.Default then
				Dropdown:Set(Dropdown.Default)
			end

			return Dropdown
		end

		Library.Sections.Label = function(self, Name)
			local Label = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Name or "Label",
			}

			local Items = {}
			do
				Items["Label"] = Instances:Create("Frame", {
					Parent = Label.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, 15),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Label"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Label.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 15),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })

				Items["SubElements"] = Instances:Create("Frame", {
					Parent = Items["Label"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(1, 0, 0, 0),
					Size = UDim2New(0, 0, 1, 0),
					ZIndex = 2,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["SubElements"].Instance,
					Name = "\0",
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = UDimNew(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})
			end

			function Label:SetText(Text)
				Text = tostring(Text)
				Items["Text"].Instance.Text = Text
			end

			function Label:SetVisibility(Bool)
				Items["Label"].Instance.Visible = Bool
			end

			function Label:Colorpicker(Data)
				Data = Data or {}

				local Colorpicker = {
					Window = Label.Window,
					Page = Label.Page,
					Section = Label.Section,

					Flag = Data.Flag or Data.flag or Library:NextFlag(),
					Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
					Alpha = Data.Alpha or Data.alpha or 0,
					Callback = Data.Callback or Data.callback or function() end,
				}

				local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
					Parent = Items["SubElements"],
					Page = Colorpicker.Page,
					Flag = Colorpicker.Flag,
					Section = Colorpicker.Section,
					Default = Colorpicker.Default,
					Alpha = Colorpicker.Alpha,
					Callback = Colorpicker.Callback,
				})

				return NewColorpicker
			end

			function Label:Keybind(Data)
				Data = Data or {}

				local Keybind = {
					Window = Label.Window,
					Page = Label.Page,
					Section = Label.Section,

					Name = Data.Name or Data.name or "Keybind",
					Flag = Data.Flag or Data.flag or Library:NextFlag(),
					Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
					Callback = Data.Callback or Data.callback or function() end,
					Mode = Data.Mode or Data.mode or "Toggle",
				}

				local NewKeybind, Items = Library:CreateKeybind({
					Name = Keybind.Name,
					Parent = Items["SubElements"],
					Flag = Keybind.Flag,
					Section = Keybind.Section,
					Default = Keybind.Default,
					Mode = Keybind.Mode,
					Callback = Keybind.Callback,
				})

				return NewKeybind
			end

			return Label
		end

		Library.Sections.Textbox = function(self, Data)
			Data = Data or {}

			local Textbox = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Textbox",
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or "",
				Callback = Data.Callback or Data.callback or function() end,
				Placeholder = Data.Placeholder or Data.placeholder or "...",
				Finished = Data.Finished or Data.finished or false,
				Numeric = Data.Numeric or Data.numeric or false,

				Value = "",
			}

			local Items = {}
			do
				Items["Textbox"] = Instances:Create("Frame", {
					Parent = Textbox.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 20),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Input"] = Instances:Create("TextBox", {
					Parent = Items["Textbox"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					CursorPosition = -1,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					Size = UDim2New(0.6000000238418579, 0, 1, 0),
					BorderSizePixel = 0,
					PlaceholderColor3 = FromRGB(185, 185, 185),
					TextXAlignment = Enum.TextXAlignment.Left,
					PlaceholderText = Textbox.Placeholder,
					TextSize = 14,
					BackgroundColor3 = FromRGB(32, 38, 48),
				})
				Items["Input"]:AddToTheme({
					TextColor3 = "Text",
					PlaceholderColor3 = "Inactive Text",
					BackgroundColor3 = "Element",
				})

				Instances:Create("UIPadding", {
					Parent = Items["Input"].Instance,
					Name = "\0",
					PaddingLeft = UDimNew(0, 6),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Textbox"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Textbox.Name,
					AnchorPoint = Vector2New(1, 0),
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })

				Items["Input"]:OnHover(function()
					Items["Input"]:Tween(
						nil,
						{ BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35) }
					)
				end)

				Items["Input"]:OnHoverLeave(function()
					Items["Input"]:Tween(nil, { BackgroundColor3 = Library.Theme.Element })
				end)
			end

			function Textbox:Get()
				return Textbox.Value
			end

			function Textbox:SetVisibility(Bool)
				Items["Textbox"].Instance.Visible = Bool
			end

			function Textbox:Set(Value)
				if Textbox.Numeric then
					if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
						Value = Textbox.Value
					end
				end

				Textbox.Value = Value
				Items["Input"].Instance.Text = Value
				Library.Flags[Textbox.Flag] = Value

				if Textbox.Callback then
					Library:SafeCall(Textbox.Callback, Textbox.Value)
				end
			end

			if Textbox.Finished then
				Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
					if PressedEnterQuestionMark then
						Textbox:Set(Items["Input"].Instance.Text)
					end
				end)
			else
				Items["Input"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
					Textbox:Set(Items["Input"].Instance.Text)
				end)
			end

			if Textbox.Default then
				Textbox:Set(Textbox.Default)
			end

			Library.SetFlags[Textbox.Flag] = function(Value)
				Textbox:Set(Value)
			end

			return Textbox
		end

		Library.CreateSettingsPage = function(self, Window, KeybindList, Watermark)
			local SettingsPage = Window:Page({ Name = "Settings", Columns = 2 })
			local SettingsSection = SettingsPage:Section({ Name = "Settings", Side = 1 })
			do
				SettingsSection:Button({
					Name = "Unload",
					Callback = function()
						Library:Unload()
					end,
				})

				SettingsSection:Toggle({
					Name = "Watermark",
					Flag = "Watermark",
					Default = true,
					Callback = function(Value)
						Watermark:SetVisibility(Value)
					end,
				})

				SettingsSection:Toggle({
					Name = "Keybind List",
					Flag = "Keybind list",
					Default = true,
					Callback = function(Value)
						KeybindList:SetVisibility(Value)
					end,
				})

				SettingsSection:Label("Menu Keybind"):Keybind({
					Name = "Menu Keybind",
					Flag = "MenuKeybind",
					Default = Library.MenuKeybind,
					Mode = "Toggle",
					Callback = function()
						Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
					end,
				})
			end

			local ConfigsSection = SettingsPage:Section({ Name = "Configs", Side = 2 })
			do
				local ConfigName
				local ConfigSelected

				local ConfigsSearchbox = ConfigsSection:Dropdown({
					Name = "Profiles list",
					Flag = "Profiles list",
					Multi = false,
					Items = {},
					Callback = function(Value)
						ConfigSelected = Value
					end,
				})

				ConfigsSection:Textbox({
					Name = "Config name",
					Default = "",
					Flag = "ConfigName",
					Placeholder = "...",
					Callback = function(Value)
						ConfigName = Value
					end,
				})

				ConfigsSection:Button({
					Name = "Create",
					Callback = function()
						if ConfigName ~= "" then
							if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
								writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
								Library:RefreshConfigsList(ConfigsSearchbox)
								Library:Notification("Created config " .. ConfigName .. ".json", 5)
							end
						end
					end,
				})

				ConfigsSection:Button({
					Name = "Delete",
					Callback = function()
						if ConfigSelected ~= nil then
							delfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json")
							Library:RefreshConfigsList(ConfigsSearchbox)
							Library:Notification("Deleted config " .. ConfigSelected .. ".json", 5, FromRGB(255, 0, 0))
						end
					end,
				})

				ConfigsSection:Button({
					Name = "Load",
					Callback = function()
						if ConfigSelected ~= nil then
							local Success, Result = Library:LoadConfig(
								readfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json")
							)
							if Success then
								Library:Notification("Loaded config " .. ConfigSelected .. ".json", 5)
							else
								Library:Notification("Failed to load config " .. ConfigSelected .. ".json", 5)
							end
						end
					end,
				})

				ConfigsSection:Button({
					Name = "Save",
					Callback = function()
						if ConfigSelected ~= nil then
							writefile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json", Library:GetConfig())
							Library:Notification("Saved config " .. ConfigSelected .. ".json", 5)
						end
					end,
				})

				ConfigsSection:Button({
					Name = "Refresh",
					Callback = function()
						Library:RefreshConfigsList(ConfigsSearchbox)
					end,
				})

				Library:RefreshConfigsList(ConfigsSearchbox)
			end

			local ThemingSection = SettingsPage:Section({ Name = "Theming", Side = 2 })
			do
				for Index, Value in Library.Theme do
					ThemingSection:Label(Index):Colorpicker({
						Flag = Index,
						Default = Value,
						Callback = function(Value)
							Library.Theme[Index] = Value
							Library:ChangeTheme(Index, Value)
						end,
					})
				end
			end
		end
	end
end

getgenv().Library = Library
return Library 
