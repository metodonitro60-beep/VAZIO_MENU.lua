-- VAZIO' MENU V1.05
-- RED / BLACK
-- COMPLETE INTEGRATED VERSION

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local VERSION = "V1.05"
local DECAL_ID = "rbxthumb://type=Asset&id=464093673&w=420&h=420"

local RED = Color3.fromRGB(255,35,35)
local RED_DARK = Color3.fromRGB(110,10,10)
local RED_SOFT = Color3.fromRGB(255,80,80)

local BLACK = Color3.fromRGB(5,5,5)
local BLACK2 = Color3.fromRGB(14,14,14)
local BLACK3 = Color3.fromRGB(25,25,25)

local WHITE = Color3.fromRGB(245,245,245)
local GRAY = Color3.fromRGB(150,150,150)

local ESPColors = {
	Killer = Color3.fromRGB(255,35,35),
	Survivor = Color3.fromRGB(50,255,90),
	Unknown = Color3.fromRGB(255,220,40),

	Valve = Color3.fromRGB(255,70,70),
	Fuse = Color3.fromRGB(255,170,40),
	Generator = Color3.fromRGB(60,140,255),
	CarBattery = Color3.fromRGB(190,70,255),

	UseValve = Color3.fromRGB(255,50,50),
	UseFuse = Color3.fromRGB(255,130,30),

	Health = Color3.fromRGB(50,255,90),
	HealthLow = Color3.fromRGB(255,35,35)
}

local Settings = {
	PlayerESP = false,
	ValveESP = false,
	FuseESP = false,
	GeneratorESP = false,
	CarBatteryESP = false,
	UseLocationESP = false,

	Username = true,
	Role = true,
	Distance = true,
	Health = true,

	ObjectiveTracker = false
}

--==================================================
-- CLEAN OLD GUI
--==================================================

local Old = PlayerGui:FindFirstChild("VAZIO_MENU")

if Old then
	Old:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "VAZIO_MENU"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--==================================================
-- UTILS
--==================================================

local function New(class, properties, parent)
	local object = Instance.new(class)

	for property, value in pairs(properties or {}) do
		object[property] = value
	end

	object.Parent = parent

	return object
end

local function Corner(object, radius)
	New("UICorner", {
		CornerRadius = UDim.new(0, radius)
	}, object)
end

local function Outline(object, color, thickness)
	New("UIStroke", {
		Color = color,
		Thickness = thickness or 1
	}, object)
end

local function Draggable(object, handle)

	object.Active = true
	handle = handle or object
	handle.Active = true

	local dragging = false
	local dragStart
	local startPosition
	local dragInput

	handle.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPosition = object.Position

			input.Changed:Connect(function()

				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end

			end)
		end
	end)

	handle.InputChanged:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			dragInput = input
		end

	end)

	UserInputService.InputChanged:Connect(function(input)

		if dragging and input == dragInput then

			local delta = input.Position - dragStart

			object.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
		end

	end)
end

--==================================================
-- LOADING
--==================================================

local Loading = New("Frame", {
	Size = UDim2.fromScale(1,1),
	BackgroundColor3 = BLACK,
	BorderSizePixel = 0
}, Gui)

local LoadingImage = New("ImageLabel", {
	Size = UDim2.fromOffset(130,130),
	Position = UDim2.new(0.5,-65,0.35,-65),
	BackgroundTransparency = 1,
	Image = DECAL_ID,
	ScaleType = Enum.ScaleType.Fit
}, Loading)

Corner(LoadingImage,65)
Outline(LoadingImage,RED,3)

New("TextLabel", {
	Size = UDim2.fromOffset(400,40),
	Position = UDim2.new(0.5,-200,0.57,0),
	BackgroundTransparency = 1,
	Text = "VAZIO'",
	TextColor3 = WHITE,
	TextSize = 28,
	Font = Enum.Font.GothamBold
}, Loading)

local LoadingText = New("TextLabel", {
	Size = UDim2.fromOffset(400,30),
	Position = UDim2.new(0.5,-200,0.64,0),
	BackgroundTransparency = 1,
	Text = "CARREGANDO... 0%",
	TextColor3 = RED_SOFT,
	TextSize = 13,
	Font = Enum.Font.Gotham
}, Loading)

local LoadingBackground = New("Frame", {
	Size = UDim2.fromOffset(300,6),
	Position = UDim2.new(0.5,-150,0.71,0),
	BackgroundColor3 = BLACK3,
	BorderSizePixel = 0
}, Loading)

Corner(LoadingBackground,5)

local LoadingBar = New("Frame", {
	Size = UDim2.new(0,0,1,0),
	BackgroundColor3 = RED,
	BorderSizePixel = 0
}, LoadingBackground)

Corner(LoadingBar,5)

task.spawn(function()

	for i = 0,100 do

		LoadingBar.Size = UDim2.new(i/100,0,1,0)
		LoadingText.Text = "CARREGANDO... "..i.."%"

		task.wait(0.1)
	end

	Loading:Destroy()

end)

--==================================================
-- OPEN BUTTON
--==================================================

local OpenButton = New("ImageButton", {
	Size = UDim2.fromOffset(58,58),
	Position = UDim2.new(0,18,0.5,-29),
	BackgroundColor3 = BLACK,
	BorderSizePixel = 0,
	Image = DECAL_ID,
	ScaleType = Enum.ScaleType.Fit,
	AutoButtonColor = false
}, Gui)

Corner(OpenButton,29)
Outline(OpenButton,RED,3)

Draggable(OpenButton)

--==================================================
-- MAIN MENU
--==================================================

local Main = New("Frame", {
	Size = UDim2.fromOffset(440,315),
	Position = UDim2.new(0.5,-220,0.5,-157),
	BackgroundColor3 = BLACK,
	BorderSizePixel = 0,
	Visible = false
}, Gui)

Corner(Main,10)
Outline(Main,RED,2)

--==================================================
-- HEADER
--==================================================

local Header = New("Frame", {
	Size = UDim2.new(1,0,0,55),
	BackgroundColor3 = BLACK2,
	BorderSizePixel = 0
}, Main)

Corner(Header,10)

local Logo = New("ImageLabel", {
	Size = UDim2.fromOffset(40,40),
	Position = UDim2.fromOffset(8,7),
	BackgroundTransparency = 1,
	Image = DECAL_ID,
	ScaleType = Enum.ScaleType.Fit
}, Header)

Corner(Logo,20)

New("TextLabel", {
	Size = UDim2.new(1,-110,1,0),
	Position = UDim2.fromOffset(58,0),
	BackgroundTransparency = 1,
	Text = "VAZIO'  |  "..VERSION,
	TextColor3 = WHITE,
	TextSize = 17,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left
}, Header)

local Close = New("TextButton", {
	Size = UDim2.fromOffset(38,38),
	Position = UDim2.new(1,-46,0,8),
	BackgroundColor3 = RED_DARK,
	Text = "X",
	TextColor3 = WHITE,
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false
}, Header)

Corner(Close,7)

Draggable(Main,Header)

Close.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

OpenButton.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = New("Frame", {
	Size = UDim2.new(0,100,1,-65),
	Position = UDim2.fromOffset(0,60),
	BackgroundColor3 = BLACK2,
	BorderSizePixel = 0
}, Main)

local Content = New("Frame", {
	Size = UDim2.new(1,-110,1,-65),
	Position = UDim2.fromOffset(105,60),
	BackgroundColor3 = BLACK2,
	BorderSizePixel = 0
}, Main)

Corner(Content,8)

local Pages = {}

local function CreatePage(name)

	local page = New("ScrollingFrame", {
		Size = UDim2.new(1,-12,1,-12),
		Position = UDim2.fromOffset(6,6),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = RED,
		CanvasSize = UDim2.new(0,0,0,0),
		Visible = false
	}, Content)

	local layout = New("UIListLayout", {
		Padding = UDim.new(0,6),
		SortOrder = Enum.SortOrder.LayoutOrder
	}, page)

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

		page.CanvasSize = UDim2.new(
			0,
			0,
			0,
			layout.AbsoluteContentSize.Y + 15
		)

	end)

	Pages[name] = page

	return page
end

local ESPPage = CreatePage("ESP")
local ItemsPage = CreatePage("ITENS")
local TrackerPage = CreatePage("TRACKER")
local ColorsPage = CreatePage("CORES")
local ConfigPage = CreatePage("CONFIG")

local function SidebarButton(text,pageName,order)

	local button = New("TextButton", {
		Size = UDim2.new(1,-12,0,38),
		BackgroundColor3 = BLACK3,
		Text = text,
		TextColor3 = WHITE,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		LayoutOrder = order
	}, Sidebar)

	Corner(button,7)

	button.MouseButton1Click:Connect(function()

		for _,page in pairs(Pages) do
			page.Visible = false
		end

		Pages[pageName].Visible = true

		for _,item in ipairs(Sidebar:GetChildren()) do

			if item:IsA("TextButton") then
				item.BackgroundColor3 = BLACK3
			end

		end

		button.BackgroundColor3 = RED_DARK
	end)

	return button
end

SidebarButton("ESP","ESP",1)
SidebarButton("ITENS","ITENS",2)
SidebarButton("TRACKER","TRACKER",3)
SidebarButton("CORES","CORES",4)
SidebarButton("CONFIG","CONFIG",5)

Pages.ESP.Visible = true

--==================================================
-- TOGGLES
--==================================================

local ToggleStates = {}

local function AddToggle(parent,text,setting)

	local button = New("TextButton", {
		Size = UDim2.new(1,-5,0,37),
		BackgroundColor3 = BLACK3,
		Text = "",
		AutoButtonColor = false
	}, parent)

	Corner(button,7)

	New("TextLabel", {
		Size = UDim2.new(1,-60,1,0),
		Position = UDim2.fromOffset(12,0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = WHITE,
		TextSize = 12,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left
	}, button)

	local state = New("TextLabel", {
		Size = UDim2.fromOffset(45,22),
		Position = UDim2.new(1,-53,0.5,-11),
		BackgroundColor3 = RED_DARK,
		Text = "OFF",
		TextColor3 = WHITE,
		TextSize = 9,
		Font = Enum.Font.GothamBold
	}, button)

	Corner(state,5)

	ToggleStates[setting] = state

	local function Update()

		if Settings[setting] then

			state.Text = "ON"
			state.BackgroundColor3 = RED

		else

			state.Text = "OFF"
			state.BackgroundColor3 = RED_DARK

		end

	end

	button.MouseButton1Click:Connect(function()

		Settings[setting] = not Settings[setting]

		Update()

	end)

	Update()

	return button
end

--==================================================
-- ESP PAGE
--==================================================

AddToggle(ESPPage,"Player ESP","PlayerESP")
AddToggle(ESPPage,"Valve ESP","ValveESP")
AddToggle(ESPPage,"Fuse ESP","FuseESP")
AddToggle(ESPPage,"Generator ESP","GeneratorESP")
AddToggle(ESPPage,"Car Battery ESP","CarBatteryESP")
AddToggle(ESPPage,"USE VALVE / USE FUSE","UseLocationESP")
AddToggle(ESPPage,"Username","Username")
AddToggle(ESPPage,"Role","Role")
AddToggle(ESPPage,"Distance","Distance")
AddToggle(ESPPage,"Health","Health")

--==================================================
-- ITEMS
--==================================================

local ItemInfo = New("TextLabel", {
	Size = UDim2.new(1,-5,0,145),
	BackgroundColor3 = BLACK3,
	Text =
		"ITEM ESP\n\n"..
		"VALVE\n"..
		"FUSE\n"..
		"GENERATOR\n"..
		"Car Battery\n\n"..
		"USE VALVE HERE\n"..
		"USE FUSE HERE",
	TextColor3 = WHITE,
	TextSize = 12,
	Font = Enum.Font.Gotham,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center
},ItemsPage)

Corner(ItemInfo,7)

--==================================================
-- TRACKER
--==================================================

New("TextLabel", {
	Size = UDim2.new(1,-5,0,35),
	BackgroundColor3 = BLACK3,
	Text = "OBJECT TRACKER",
	TextColor3 = RED_SOFT,
	TextSize = 14,
	Font = Enum.Font.GothamBold
},TrackerPage)

AddToggle(TrackerPage,"Object Tracker","ObjectiveTracker")

local TrackerText = New("TextLabel", {
	Size = UDim2.new(1,-5,0,190),
	BackgroundColor3 = BLACK3,
	Text = "Tracker desligado",
	TextColor3 = WHITE,
	TextSize = 13,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top
},TrackerPage)

Corner(TrackerText,7)

--==================================================
-- COLORS
--==================================================

local SelectedColor = "Killer"

local ColorNames = {
	"Killer",
	"Survivor",
	"Unknown",
	"Valve",
	"Fuse",
	"Generator",
	"CarBattery",
	"UseValve",
	"UseFuse",
	"Health",
	"HealthLow"
}

local Preview = New("Frame", {
	Size = UDim2.new(1,-5,0,40),
	BackgroundColor3 = ESPColors.Killer
},ColorsPage)

Corner(Preview,7)

local PreviewText = New("TextLabel", {
	Size = UDim2.fromScale(1,1),
	BackgroundTransparency = 1,
	Text = "Killer",
	TextColor3 = WHITE,
	TextSize = 13,
	Font = Enum.Font.GothamBold
},Preview)

for _,name in ipairs(ColorNames) do

	local button = New("TextButton", {
		Size = UDim2.new(1,-5,0,30),
		BackgroundColor3 = ESPColors[name],
		Text = name,
		TextColor3 = WHITE,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false
	},ColorsPage)

	Corner(button,6)

	button.MouseButton1Click:Connect(function()

		SelectedColor = name
		Preview.BackgroundColor3 = ESPColors[name]
		PreviewText.Text = name

	end)

end

local Palette = {
	Color3.fromRGB(255,35,35),
	Color3.fromRGB(255,80,40),
	Color3.fromRGB(255,170,40),
	Color3.fromRGB(255,230,40),
	Color3.fromRGB(50,255,90),
	Color3.fromRGB(40,200,255),
	Color3.fromRGB(70,100,255),
	Color3.fromRGB(170,70,255),
	Color3.fromRGB(255,60,200),
	Color3.fromRGB(255,255,255),
	Color3.fromRGB(120,120,120)
}

for _,color in ipairs(Palette) do

	local button = New("TextButton", {
		Size = UDim2.new(1,-5,0,27),
		BackgroundColor3 = color,
		Text = "",
		AutoButtonColor = false
	},ColorsPage)

	Corner(button,6)

	button.MouseButton1Click:Connect(function()

		ESPColors[SelectedColor] = color

		Preview.BackgroundColor3 = color

	end)

end

--==================================================
-- CONFIG
--==================================================

local ConfigText = New("TextLabel", {
	Size = UDim2.new(1,-5,0,190),
	BackgroundColor3 = BLACK3,
	Text =
		"VAZIO' MENU\n\n"..
		"Version: "..VERSION.."\n"..
		"Theme: RED / BLACK\n"..
		"Decal: 464093673\n\n"..
		"ESP ON / OFF corrigido\n"..
		"USE VALVE corrigido\n"..
		"USE FUSE corrigido\n"..
		"Player HP\n"..
		"Role Detection\n"..
		"Object Tracker\n"..
		"Car Battery",
	TextColor3 = WHITE,
	TextSize = 12,
	Font = Enum.Font.Gotham,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center
},ConfigPage)

Corner(ConfigText,7)

--==================================================
-- ESP STORAGE
--==================================================

local PlayerESP = {}
local ObjectESP = {}

local function RemoveESP(storage,key)

	local data = storage[key]

	if data then

		if data.Gui then
			data.Gui:Destroy()
		end

		storage[key] = nil
	end
end

local function ClearStorage(storage)

	for key,data in pairs(storage) do

		if data.Gui then
			data.Gui:Destroy()
		end

		storage[key] = nil
	end
end

--==================================================
-- BILLBOARD
--==================================================

local function GetPart(object)

	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then

		return object.PrimaryPart
			or object:FindFirstChildWhichIsA("BasePart",true)

	end

	if object:IsA("ProximityPrompt") then

		local current = object.Parent

		for _ = 1,10 do

			if not current then
				break
			end

			if current:IsA("BasePart") then
				return current
			end

			if current:IsA("Model") then

				return current.PrimaryPart
					or current:FindFirstChildWhichIsA("BasePart",true)

			end

			current = current.Parent
		end
	end

	return nil
end

local function CreateESP(part,text,color,offset)

	if not part then
		return nil
	end

	local billboard = Instance.new("BillboardGui")

	billboard.Name = "VAZIO_ESP"
	billboard.Adornee = part
	billboard.Size = UDim2.fromOffset(220,55)
	billboard.StudsOffset = offset or Vector3.new(0,3,0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 10000
	billboard.Parent = Gui

	local label = Instance.new("TextLabel")

	label.Size = UDim2.fromScale(1,1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color
	label.TextStrokeColor3 = BLACK
	label.TextStrokeTransparency = 0
	label.TextSize = 13
	label.Font = Enum.Font.GothamBold
	label.TextWrapped = true
	label.Parent = billboard

	return {
		Gui = billboard,
		Label = label
	}
end

--==================================================
-- ROLE
--==================================================

local function NormalizeRole(value)

	if value == nil then
		return nil
	end

	local v = string.lower(tostring(value))
	v = v:gsub("%s+","")

	if v == "killer"
		or v == "assassin"
		or v == "assassino"
		or v == "slasher"
		or v == "murderer"
		or v == "kill"
		or v == "1" then

		return "Killer"
	end

	if v == "survivor"
		or v == "sobrevivente"
		or v == "victim"
		or v == "victima"
		or v == "player"
		or v == "0" then

		return "Survivor"
	end

	return nil
end

local function GetRole(player)

	local attributes = {
		"Role",
		"role",
		"ROLE",
		"PlayerRole",
		"playerRole",
		"Player_Role",
		"CharacterRole",
		"TeamRole",
		"RoleName",
		"RoleType",
		"Class",
		"Job"
	}

	for _,attribute in ipairs(attributes) do

		local value = player:GetAttribute(attribute)
		local role = NormalizeRole(value)

		if role then
			return role
		end

		if player.Character then

			local charValue =
				player.Character:GetAttribute(attribute)

			local charRole =
				NormalizeRole(charValue)

			if charRole then
				return charRole
			end

		end
	end

	local function SearchValues(container)

		if not container then
			return nil
		end

		for _,child in ipairs(container:GetChildren()) do

			if child:IsA("StringValue") then

				local role =
					NormalizeRole(child.Value)

				if role then
					return role
				end
			end
		end

		return nil
	end

	return SearchValues(player)
		or SearchValues(player.Character)
end

--==================================================
-- PLAYER ESP
--==================================================

local function UpdatePlayer(player)

	if player == LocalPlayer then
		RemoveESP(PlayerESP,player)
		return
	end

	if not Settings.PlayerESP then
		RemoveESP(PlayerESP,player)
		return
	end

	local character = player.Character

	if not character then
		RemoveESP(PlayerESP,player)
		return
	end

	local humanoid =
		character:FindFirstChildOfClass("Humanoid")

	local root =
		character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then
		RemoveESP(PlayerESP,player)
		return
	end

	local role = GetRole(player)
	local roleText = role or "DESCONHECIDO"

	local color = ESPColors.Unknown

	if role == "Killer" then
		color = ESPColors.Killer
	elseif role == "Survivor" then
		color = ESPColors.Survivor
	end

	local distance = 0

	if LocalPlayer.Character then

		local myRoot =
			LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if myRoot then

			distance = math.floor(
				(root.Position - myRoot.Position).Magnitude
			)

		end
	end

	local hp = math.floor(humanoid.Health)
	local maxHp = math.max(1,humanoid.MaxHealth)

	local text = ""

	if Settings.Username then
		text = player.Name
	end

	if Settings.Role then

		if text ~= "" then
			text = text.."\n"
		end

		text = text..roleText
	end

	if Settings.Distance then

		if text ~= "" then
			text = text.."\n"
		end

		text = text..distance.."m"
	end

	if Settings.Health then

		if text ~= "" then
			text = text.."\n"
		end

		text =
			text..
			"\nHP: "..hp.."/"..math.floor(maxHp)
	end

	local old = PlayerESP[player]

	if not old
		or not old.Gui
		or old.Gui.Adornee ~= root then

		RemoveESP(PlayerESP,play
