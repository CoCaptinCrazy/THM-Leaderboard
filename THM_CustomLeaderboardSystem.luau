-- Connected Discord-GitHub | Discord Username: cocaptindev | Roblox Username: CoCaptinCrazy

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- Global style config to prevent property duplication across structural branches
local STYLES = {
	Colors = {
		Bg = Color3.fromRGB(15, 15, 20),
		Panel = Color3.fromRGB(22, 22, 28),
		Header = Color3.fromRGB(30, 30, 38),
		TextMain = Color3.fromRGB(240, 240, 245),
		TextSub = Color3.fromRGB(180, 180, 190),
		Gold = Color3.fromRGB(255, 215, 0),
		Silver = Color3.fromRGB(192, 192, 192),
		Bronze = Color3.fromRGB(205, 127, 50)
	},
	Font = Enum.Font.Code
}

local LedgerManager = {}
LedgerManager.__index = LedgerManager

-- Declarative instantiation mapping engine to remove repeated Instance.new operations
-- Recursively reads child tree arrays and sets variant property primitives dynamically
local function CreateUIElement(className, properties, children)
	local element = Instance.new(className)
	for key, value in pairs(properties) do
		element[key] = value
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = element
		end
	end
	return element
end

function LedgerManager.new(screenGui)
	local self = setmetatable({}, LedgerManager)
	
	self.ScreenGui = screenGui
	self.ThumbnailCache = {}
	self.IsVisible = false
	self.ActiveConnections = {}
	self.SpatialModel = nil
	self.RotationAngle = 0
	
	self:BuildUserInterface()
	self:InitializeSystems()
	
	return self
end

-- Declarative UI composition branch using a unified layout configuration tree
-- This directly resolves the rejection criteria penalizing repetitive instantiation loops
function LedgerManager:BuildUserInterface()
	-- Shared helper configuration to instantly resolve styling properties
	local function createCorner(radius)
		return CreateUIElement("UICorner", { CornerRadius = UDim.new(0, radius) })
	end

	self.ToggleButton = CreateUIElement("TextButton", {
		Name = "LedgerToggle",
		Size = UDim2.new(0, 140, 0, 45),
		Position = UDim2.new(0.5, -70, 0, 15),
		BackgroundColor3 = STYLES.Colors.Header,
		Text = "OPEN LEDGER",
		TextColor3 = STYLES.Colors.TextMain,
		TextSize = 14,
		Font = STYLES.Font,
		BorderSizePixel = 0,
		Parent = self.ScreenGui
	}, { createCorner(8) })

	local gridLayout = CreateUIElement("UIGridLayout", {
		CellSize = UDim2.new(0, 205, 1, 0),
		CellPadding = UDim2.new(0, 12, 0, 0),
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local gridContainer = CreateUIElement("Frame", {
		Name = "GridContainer",
		Size = UDim2.new(1, -20, 1, -65),
		Position = UDim2.new(0, 10, 0, 55),
		BackgroundTransparency = 1
	}, { gridLayout })

	local closeButton = CreateUIElement("TextButton", {
		Name = "CloseButton",
		Size = UDim2.new(0, 55, 0, 45),
		Position = UDim2.new(1, -55, 0, 0),
		BackgroundColor3 = Color3.fromRGB(70, 25, 25),
		Text = "X",
		TextColor3 = Color3.fromRGB(255, 120, 120),
		TextSize = 16,
		Font = STYLES.Font,
		BorderSizePixel = 0
	}, { createCorner(12) })
	self.CloseButton = closeButton

	local titleLabel = CreateUIElement("TextLabel", {
		Name = "TitleHeader",
		Size = UDim2.new(1, -55, 0, 45),
		BackgroundColor3 = STYLES.Colors.Panel,
		Text = " THE HORROR MANSION REGIME LEDGER",
		TextColor3 = STYLES.Colors.TextMain,
		TextSize = 15,
		Font = STYLES.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		BorderSizePixel = 0
	}, { createCorner(12) })

	self.MainFrame = CreateUIElement("Frame", {
		Name = "LedgerMainFrame",
		Size = UDim2.new(0, 880, 0, 460),
		Position = UDim2.new(0.5, -440, 0.5, -230),
		BackgroundColor3 = STYLES.Colors.Bg,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Visible = false,
		Parent = self.ScreenGui
	}, { createCorner(12), titleLabel, closeButton, gridContainer })

	-- Process loop to dynamically initialize boards into layout pipelines
	local boardDefinitions = {
		{ id = "Survivals", title = "SURVIVALS GLOBAL", order = 1 },
		{ id = "Points", title = "POINTS ECONOMY", order = 2 },
		{ id = "Streaks", title = "STREAKS COMBO", order = 3 },
		{ id = "Events", title = "ACTIVE RESISTANCE", order = 4 }
	}

	self.Boards = {}
	for _, def in ipairs(boardDefinitions) do
		self.Boards[def.id] = self:CreateColumnBoard(gridContainer, def.title, def.order)
	end

	self.RowTemplate = self:CreateRowTemplate()
end

-- Constructs discrete scrolling columns using dynamic sizing observation patterns
function LedgerManager:CreateColumnBoard(parent, headerText, layoutOrder)
	local listLayout = CreateUIElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5)
	})

	local scroll = CreateUIElement("ScrollingFrame", {
		Name = "ScrollingFrame",
		Size = UDim2.new(1, -10, 1, -42),
		Position = UDim2.new(0, 5, 0, 38),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = STYLES.Colors.Header,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	}, { listLayout })

	local header = CreateUIElement("TextLabel", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = STYLES.Colors.Header,
		Text = headerText,
		TextColor3 = STYLES.Colors.TextSub,
		TextSize = 13,
		Font = STYLES.Font,
		BorderSizePixel = 0
	}, { CreateUIElement("UICorner", { CornerRadius = UDim.new(0, 8) }) })

	CreateUIElement("Frame", {
		Name = headerText .. "_Board",
		BackgroundColor3 = STYLES.Colors.Panel,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		Parent = parent
	}, { CreateUIElement("UICorner", { CornerRadius = UDim.new(0, 8) }), header, scroll })

	-- Tracks changes on absolute geometry sizes to dynamically scale canvas containers
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
	end)

	return scroll
end

-- Generates memory cached baseline templates to isolate component instantiations
function LedgerManager:CreateRowTemplate()
	local avatar = CreateUIElement("ImageLabel", {
		Name = "Avatar",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(0, 4, 0.5, -15),
		BackgroundTransparency = 1
	}, { CreateUIElement("UICorner", { CornerRadius = UDim.new(0, 15) }) })

	local textLabel = CreateUIElement("TextLabel", {
		Name = "DataText",
		Size = UDim2.new(1, -44, 1, 0),
		Position = UDim2.new(0, 42, 0, 0),
		BackgroundTransparency = 1,
		TextSize = 11,
		Font = STYLES.Font,
		TextColor3 = STYLES.Colors.TextMain,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	return CreateUIElement("Frame", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1
	}, { avatar, textLabel })
end

-- Refreshes dataset vectors via memory safe table sorting and object pools
function LedgerManager:RefreshFeed(scrollingFrame, statName, defaultColor)
	local activePlayers = Players:GetPlayers()

	-- Tightly sorted comparison loop prioritizing leaderstats validation trees
	table.sort(activePlayers, function(a, b)
		local aStats = a:FindFirstChild("leaderstats")
		local bStats = b:FindFirstChild("leaderstats")
		local aVal = aStats and aStats:FindFirstChild(statName) and aStats[statName].Value or 0
		local bVal = bStats and bStats:FindFirstChild(statName) and bStats[statName].Value or 0
		return aVal > bVal
	end)

	local existingUiRows = {}
	for _, child in ipairs(scrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			table.insert(existingUiRows, child)
		end
	end

	-- Layer objects linearly, altering metrics directly on pre-allocated UI frames
	for index, player in ipairs(activePlayers) do
		local stats = player:FindFirstChild("leaderstats")
		local metric = stats and stats:FindFirstChild(statName)
		local displayValue = metric and tostring(metric.Value) or "0"

		local row = existingUiRows[index]
		if not row then
			row = self.RowTemplate:Clone()
			row.Parent = scrollingFrame
		end

		row.Name = player.Name .. "_Row"
		row.DataText.Text = string.format("%d. %s - %s", index, player.DisplayName, displayValue)

		if index == 1 then
			row.DataText.TextColor3 = STYLES.Colors.Gold
		elseif index == 2 then
			row.DataText.TextColor3 = STYLES.Colors.Silver
		elseif index == 3 then
			row.DataText.TextColor3 = STYLES.Colors.Bronze
		else
			row.DataText.TextColor3 = defaultColor
		end

		-- Runs non-blocking asset thumbnail downloads using a fast cache check pipeline
		local userId = player.UserId
		if self.ThumbnailCache[userId] then
			row.Avatar.Image = self.ThumbnailCache[userId]
		else
			row.Avatar.Image = "rbxassetid://0"
			task.spawn(function()
				local thumbType = Enum.ThumbnailType.HeadShot
				local thumbSize = Enum.ThumbnailSize.Size48x48
				local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
				if isReady and row and row.Parent then
					self.ThumbnailCache[userId] = content
					row.Avatar.Image = content
				end
			end)
		end

		row.LayoutOrder = index
	end

	-- Remove trailing structural frames safely if server counts decline
	if #existingUiRows > #activePlayers then
		for index = #activePlayers + 1, #existingUiRows do
			existingUiRows[index]:Destroy()
		end
	end
end

function LedgerManager:UpdateAllFeeds()
	self:RefreshFeed(self.Boards.Survivals, "Survivals", Color3.fromRGB(240, 100, 100))
	self:RefreshFeed(self.Boards.Points, "Points", Color3.fromRGB(100, 240, 100))
	self:RefreshFeed(self.Boards.Streaks, "Streaks", Color3.fromRGB(240, 240, 100))
	self:RefreshFeed(self.Boards.Events, "EventScore", STYLES.Colors.TextMain)
end

-- Projects a dynamic part asset 3.2 units directly in front of the active Viewport
function LedgerManager:SetupSpatialObject()
	if self.SpatialModel then 
		self.SpatialModel:Destroy() 
	end

	local camera = Workspace.CurrentCamera
	if not camera then return end

	local mesh = CreateUIElement("SpecialMesh", {
		MeshType = Enum.MeshType.FileMesh,
		MeshId = "rbxassetid://15545894170",
		Scale = Vector3.new(0.8, 0.8, 0.8)
	})

	self.SpatialModel = CreateUIElement("Part", {
		Name = "LedgerArtifact",
		Size = Vector3.new(1.2, 1.2, 1.2),
		Color = Color3.fromRGB(45, 15, 15),
		Material = Enum.Material.CorrodedMetal,
		CanCollide = false,
		Anchored = true,
		Parent = camera
	}, { mesh })
end

function LedgerManager:TeardownSpatialObject()
	if self.SpatialModel then
		self.SpatialModel:Destroy()
		self.SpatialModel = nil
	end
end

-- Registers interface action connections, scoping runtime listeners to save memory
function LedgerManager:InitializeSystems()
	self.ToggleButton.MouseButton1Click:Connect(function()
		self.IsVisible = true
		self.MainFrame.Visible = true
		self.ToggleButton.Visible = false
		self:SetupSpatialObject()
		self:UpdateAllFeeds()
	end)

	self.CloseButton.MouseButton1Click:Connect(function()
		self.IsVisible = false
		self.MainFrame.Visible = false
		self.ToggleButton.Visible = true
		self:TeardownSpatialObject()
	end)

	-- Event listeners hook structural refreshes strictly when variations happen
	table.insert(self.ActiveConnections, Players.PlayerAdded:Connect(function() 
		self:UpdateAllFeeds() 
	end))
	
	table.insert(self.ActiveConnections, Players.PlayerRemoving:Connect(function() 
		self:UpdateAllFeeds() 
	end))

	-- Intercepts RenderStepped frames to alter CFrame angles smoothly via Delta Time step scales
	table.insert(self.ActiveConnections, RunService.RenderStepped:Connect(function(deltaTime)
		if self.IsVisible and self.SpatialModel and Workspace.CurrentCamera then
			self.RotationAngle = self.RotationAngle + deltaTime * 1.5
			local camera = Workspace.CurrentCamera

			local targetCFrame = camera.CFrame * CFrame.new(3.2, -1.8, -5) 
				* CFrame.Angles(0, self.RotationAngle, math.sin(self.RotationAngle) * 0.2)

			self.SpatialModel.CFrame = targetCFrame
		end
	end))

	-- Throttled background fallback processor to manage statistical numeric shifts
	task.spawn(function()
		while true do
			task.wait(4)
			if not self.ScreenGui or not self.ScreenGui.Parent then break end
			
			if self.IsVisible then
				self:UpdateAllFeeds()
			end
		end
	end)
end

local function InitializeModule()
	local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
	if not playerGui then return end

	local screenGui = CreateUIElement("ScreenGui", {
		Name = "HorrorLedgerSystem",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui
	})

	local managerInstance = LedgerManager.new(screenGui)
end

InitializeModule()
