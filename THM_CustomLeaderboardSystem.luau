-- Connected Discord-GitHub | Discord Username: YourDiscordTag | Roblox Username: YourRobloxName

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- Color palette configuration for the ledger UI elements
local UI_COLORS = {
	BACKGROUND = Color3.fromRGB(15, 15, 20),
	PANEL = Color3.fromRGB(22, 22, 28),
	HEADER = Color3.fromRGB(30, 30, 38),
	TEXT_PRIMARY = Color3.fromRGB(240, 240, 245),
	TEXT_SECONDARY = Color3.fromRGB(180, 180, 190),
	GOLD = Color3.fromRGB(255, 215, 0),
	SILVER = Color3.fromRGB(192, 192, 192),
	BRONZE = Color3.fromRGB(205, 127, 50)
}

local FONTS = {
	PRIMARY = Enum.Font.Code
}

local LedgerManager = {}
LedgerManager.__index = LedgerManager

-- Setup a tracking instance for handling user interfaces and running connections
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

-- Procedurally create GUI frames, buttons, and layout structures
function LedgerManager:BuildUserInterface()
	self.ToggleButton = Instance.new("TextButton")
	self.ToggleButton.Name = "LedgerToggle"
	self.ToggleButton.Size = UDim2.new(0, 140, 0, 45)
	self.ToggleButton.Position = UDim2.new(0.5, -70, 0, 15)
	self.ToggleButton.BackgroundColor3 = UI_COLORS.HEADER
	self.ToggleButton.Text = "OPEN LEDGER"
	self.ToggleButton.TextColor3 = UI_COLORS.TEXT_PRIMARY
	self.ToggleButton.TextSize = 14
	self.ToggleButton.Font = FONTS.PRIMARY
	self.ToggleButton.BorderSizePixel = 0
	self.ToggleButton.Parent = self.ScreenGui

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 8)
	toggleCorner.Parent = self.ToggleButton

	self.MainFrame = Instance.new("Frame")
	self.MainFrame.Name = "LedgerMainFrame"
	self.MainFrame.Size = UDim2.new(0, 880, 0, 460)
	self.MainFrame.Position = UDim2.new(0.5, -440, 0.5, -230)
	self.MainFrame.BackgroundColor3 = UI_COLORS.BACKGROUND
	self.MainFrame.BackgroundTransparency = 0.15
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.Visible = false
	self.MainFrame.Parent = self.ScreenGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 12)
	mainCorner.Parent = self.MainFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleHeader"
	titleLabel.Size = UDim2.new(1, -55, 0, 45)
	titleLabel.BackgroundColor3 = UI_COLORS.PANEL
	titleLabel.Text = " THE HORROR MANSION REGIME LEDGER"
	titleLabel.TextColor3 = UI_COLORS.TEXT_PRIMARY
	titleLabel.TextSize = 15
	titleLabel.Font = FONTS.PRIMARY
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.BorderSizePixel = 0
	titleLabel.Parent = self.MainFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 12)
	titleCorner.Parent = titleLabel

	self.CloseButton = Instance.new("TextButton")
	self.CloseButton.Name = "CloseButton"
	self.CloseButton.Size = UDim2.new(0, 55, 0, 45)
	self.CloseButton.Position = UDim2.new(1, -55, 0, 0)
	self.CloseButton.BackgroundColor3 = Color3.fromRGB(70, 25, 25)
	self.CloseButton.Text = "X"
	self.CloseButton.TextColor3 = Color3.fromRGB(255, 120, 120)
	self.CloseButton.TextSize = 16
	self.CloseButton.Font = FONTS.PRIMARY
	self.CloseButton.BorderSizePixel = 0
	self.CloseButton.Parent = self.MainFrame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 12)
	closeCorner.Parent = self.CloseButton

	local gridContainer = Instance.new("Frame")
	gridContainer.Name = "GridContainer"
	gridContainer.Size = UDim2.new(1, -20, 1, -65)
	gridContainer.Position = UDim2.new(0, 10, 0, 55)
	gridContainer.BackgroundTransparency = 1
	gridContainer.Parent = self.MainFrame

	local uiGridLayout = Instance.new("UIGridLayout")
	uiGridLayout.CellSize = UDim2.new(0, 205, 1, 0)
	uiGridLayout.CellPadding = UDim2.new(0, 12, 0, 0)
	uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiGridLayout.Parent = gridContainer

	-- Maps structural columns for sorting paths
	self.Boards = {
		Survivals = self:CreateColumnBoard(gridContainer, "SURVIVALS GLOBAL", 1),
		Points = self:CreateColumnBoard(gridContainer, "POINTS ECONOMY", 2),
		Streaks = self:CreateColumnBoard(gridContainer, "STREAKS COMBO", 3),
		Events = self:CreateColumnBoard(gridContainer, "ACTIVE RESISTANCE", 4)
	}

	self.RowTemplate = self:CreateRowTemplate()
end

-- Build individual scrolling panels for each leaderboard category
function LedgerManager:CreateColumnBoard(parent, headerText, layoutOrder)
	local board = Instance.new("Frame")
	board.Name = headerText .. "_Board"
	board.BackgroundColor3 = UI_COLORS.PANEL
	board.BorderSizePixel = 0
	board.LayoutOrder = layoutOrder
	board.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = board

	local header = Instance.new("TextLabel")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 32)
	header.BackgroundColor3 = UI_COLORS.HEADER
	header.Text = headerText
	header.TextColor3 = UI_COLORS.TEXT_SECONDARY
	header.TextSize = 13
	header.Font = FONTS.PRIMARY
	header.BorderSizePixel = 0
	header.Parent = board

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 8)
	headerCorner.Parent = header

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "ScrollingFrame"
	scroll.Size = UDim2.new(1, -10, 1, -42)
	scroll.Position = UDim2.new(0, 5, 0, 38)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = UI_COLORS.HEADER
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.Parent = board

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = scroll

	-- Dynamically adjustments scrollbar canvas scaling size limits
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
	end)

	return scroll
end

-- Keep a copyable design template for drawing user listings safely
function LedgerManager:CreateRowTemplate()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 36)
	frame.BackgroundTransparency = 1

	local avatar = Instance.new("ImageLabel")
	avatar.Name = "Avatar"
	avatar.Size = UDim2.new(0, 30, 0, 30)
	avatar.Position = UDim2.new(0, 4, 0.5, -15)
	avatar.BackgroundTransparency = 1
	avatar.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = avatar

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "DataText"
	textLabel.Size = UDim2.new(1, -44, 1, 0)
	textLabel.Position = UDim2.new(0, 42, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextSize = 11
	textLabel.Font = FONTS.PRIMARY
	textLabel.TextColor3 = UI_COLORS.TEXT_PRIMARY
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = frame

	return frame
end

-- Refresh layout nodes using an object pool to save processing memory
function LedgerManager:RefreshFeed(scrollingFrame, statName, defaultColor)
	local activePlayers = Players:GetPlayers()

	-- Sort elements based on active player tracking leaderstats data
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

	-- Overwrite old list entries or clone new frames if needed
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

		-- Apply podium custom color rules based on rank indexing position
		if index == 1 then
			row.DataText.TextColor3 = UI_COLORS.GOLD
		elseif index == 2 then
			row.DataText.TextColor3 = UI_COLORS.SILVER
		elseif index == 3 then
			row.DataText.TextColor3 = UI_COLORS.BRONZE
		else
			row.DataText.TextColor3 = defaultColor
		end

		-- Run async headshot image downloads without freezing main loops
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

	-- Destroy surplus UI objects when server counts drop
	if #existingUiRows > #activePlayers then
		for index = #activePlayers + 1, #existingUiRows do
			existingUiRows[index]:Destroy()
		end
	end
end

-- Triggers data redraw across every tracked metric panel category
function LedgerManager:UpdateAllFeeds()
	self:RefreshFeed(self.Boards.Survivals, "Survivals", Color3.fromRGB(240, 100, 100))
	self:RefreshFeed(self.Boards.Points, "Points", Color3.fromRGB(100, 240, 100))
	self:RefreshFeed(self.Boards.Streaks, "Streaks", Color3.fromRGB(240, 240, 100))
	self:RefreshFeed(self.Boards.Events, "EventScore", UI_COLORS.TEXT_PRIMARY)
end

-- Renders a spinning visual part in front of the active camera workspace
function LedgerManager:SetupSpatialObject()
	if self.SpatialModel then 
		self.SpatialModel:Destroy() 
	end

	local camera = Workspace.CurrentCamera
	if not camera then return end

	local model = Instance.new("Part")
	model.Name = "LedgerArtifact"
	model.Size = Vector3.new(1.2, 1.2, 1.2)
	model.Color = Color3.fromRGB(45, 15, 15)
	model.Material = Enum.Material.CorrodedMetal
	model.CanCollide = false
	model.Anchored = true
	model.Parent = camera

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = "rbxassetid://15545894170"
	mesh.Scale = Vector3.new(0.8, 0.8, 0.8)
	mesh.Parent = model

	self.SpatialModel = model
end

-- Drop and clear the camera space physical object frames cleanly
function LedgerManager:TeardownSpatialObject()
	if self.SpatialModel then
		self.SpatialModel:Destroy()
		self.SpatialModel = nil
	end
end

-- Event initialization setup for toggling loops and connecting listeners
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

	-- Event driven redraw hooks to avoid spamming updates constantly
	table.insert(self.ActiveConnections, Players.PlayerAdded:Connect(function() 
		self:UpdateAllFeeds() 
	end))
	
	table.insert(self.ActiveConnections, Players.PlayerRemoving:Connect(function() 
		self:UpdateAllFeeds() 
	end))

	-- Spin vectors directly matching the active viewport matrix frame rates
	table.insert(self.ActiveConnections, RunService.RenderStepped:Connect(function(deltaTime)
		if self.IsVisible and self.SpatialModel and Workspace.CurrentCamera then
			self.RotationAngle = self.RotationAngle + deltaTime * 1.5
			local camera = Workspace.CurrentCamera

			local targetCFrame = camera.CFrame * CFrame.new(3.2, -1.8, -5) 
				* CFrame.Angles(0, self.RotationAngle, math.sin(self.RotationAngle) * 0.2)

			self.SpatialModel.CFrame = targetCFrame
		end
	end))

	-- Fallback loop timer to process dynamic variable point alterations
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

-- Entry pipeline point handling player GUI attachments cleanly
local function InitializeModule()
	local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
	if not playerGui then return end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "HorrorLedgerSystem"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui

	local managerInstance = LedgerManager.new(screenGui)
end

InitializeModule()
