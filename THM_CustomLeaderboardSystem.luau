local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	task.wait()
	LocalPlayer = Players.LocalPlayer
end

local ScreenGui = script.Parent
local playerGui = ScreenGui.Parent

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -60, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ToggleButton.Text = "OPEN LEDGER"
ToggleButton.TextColor3 = Color3.fromRGB(240, 240, 245)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.Code
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 850, 0, 450)
MainFrame.Position = UDim2.new(0.5, -425, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -50, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleLabel.Text = "THE HORROR MANSION REGIME LEDGER"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.Code
TitleLabel.BorderSizePixel = 0
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleLabel

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 50, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.Code
CloseButton.BorderSizePixel = 0
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 12)
CloseCorner.Parent = CloseButton

local GridContainer = Instance.new("Frame")
GridContainer.Name = "GridContainer"
GridContainer.Size = UDim2.new(1, -20, 1, -60)
GridContainer.Position = UDim2.new(0, 10, 0, 50)
GridContainer.BackgroundTransparency = 1
GridContainer.Parent = MainFrame

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellSize = UDim2.new(0, 200, 1, 0)
UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 0)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.Parent = GridContainer

local function CreateBoard(name, labelText, layoutOrder)
	local board = Instance.new("Frame")
	board.Name = name .. "Board"
	board.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	board.BorderSizePixel = 0
	board.LayoutOrder = layoutOrder
	board.Parent = GridContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = board

	local header = Instance.new("TextLabel")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 30)
	header.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	header.Text = labelText
	header.TextColor3 = Color3.fromRGB(200, 200, 210)
	header.TextSize = 14
	header.Font = Enum.Font.Code
	header.BorderSizePixel = 0
	header.Parent = board

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 8)
	headerCorner.Parent = header

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "ScrollingFrame"
	scroll.Size = UDim2.new(1, -10, 1, -40)
	scroll.Position = UDim2.new(0, 5, 0, 35)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
	scroll.Parent = board

	local list = Instance.new("UIListLayout")
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 4)
	list.Parent = scroll

	return board
end

local survivalsBoard = CreateBoard("Survivals", "SURVIVALS GLOBAL", 1)
local pointsBoard = CreateBoard("Points", "POINTS ECONOMY", 2)
local streaksBoard = CreateBoard("Streaks", "STREAKS COMBO", 3)

local EventName = "ACTIVE EVENT"
local CurrencyMetric = "NO EVENT HOST COMMENCING"

local eventBoard = CreateBoard("Event", string.upper(EventName), 4)
local EventScroll = eventBoard.ScrollingFrame

local MessageLabel = Instance.new("TextLabel")
MessageLabel.Name = "MessageLabel"
MessageLabel.Size = UDim2.new(1, 0, 0, 40)
MessageLabel.BackgroundTransparency = 1
MessageLabel.Text = string.upper(CurrencyMetric)
MessageLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
MessageLabel.TextSize = 12
MessageLabel.Font = Enum.Font.Code
MessageLabel.LayoutOrder = 1
Instance.new("UICorner").Parent = MessageLabel
MessageLabel.Parent = EventScroll

local function CreateRowTemplate()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 35)
	frame.BackgroundTransparency = 1

	local avatar = Instance.new("ImageLabel")
	avatar.Name = "Avatar"
	avatar.Size = UDim2.new(0, 30, 0, 30)
	avatar.Position = UDim2.new(0, 2, 0.5, -15)
	avatar.BackgroundTransparency = 1
	avatar.Parent = frame

	local label = Instance.new("TextLabel")
	label.Name = "TextLabel"
	label.Size = UDim2.new(1, -40, 1, 0)
	label.Position = UDim2.new(0, 38, 0, 0)
	label.BackgroundTransparency = 1
	label.TextSize = 10
	label.Font = Enum.Font.Code
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	return frame
end

local rowTemplate = CreateRowTemplate()
local thumbnailCache = {}

local function PopulateFeed(scrollingFrame, statName, defaultColor)
	if not ScreenGui or not ScreenGui.Parent then return end
	
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	local plist = Players:GetPlayers()

	table.sort(plist, function(a, b)
		local aStats = a:FindFirstChild("leaderstats")
		local bStats = b:FindFirstChild("leaderstats")
		local aVal = aStats and aStats:FindFirstChild(statName) and aStats[statName].Value or 0
		local bVal = bStats and bStats:FindFirstChild(statName) and bStats[statName].Value or 0
		return aVal > bVal
	end)

	for i, p in ipairs(plist) do
		local stats = p:FindFirstChild("leaderstats")
		local val = stats and stats:FindFirstChild(statName)
		local valueText = val and tostring(val.Value) or "0"

		local row = rowTemplate:Clone()
		row.TextLabel.Text = tostring(i) .. ". " .. p.Name .. " - " .. valueText

		if i == 1 then
			row.TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		elseif i == 2 then
			row.TextLabel.TextColor3 = Color3.fromRGB(192, 192, 192)
			row.TextLabel.TextSize = 11
		elseif i == 3 then
			row.TextLabel.TextColor3 = Color3.fromRGB(205, 127, 50)
			row.TextLabel.TextSize = 11
		else
			row.TextLabel.TextColor3 = defaultColor
		end

		local userId = p.UserId
		if thumbnailCache[userId] then
			row.Avatar.Image = thumbnailCache[userId]
		else
			task.spawn(function()
				local thumbType = Enum.ThumbnailType.HeadShot
				local thumbSize = Enum.ThumbnailSize.Size48x48
				local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
				if isReady then
					thumbnailCache[userId] = content
					row.Avatar.Image = content
				end
			end)
		end

		row.LayoutOrder = i
		row.Parent = scrollingFrame
	end
end

ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	ToggleButton.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	ToggleButton.Visible = true
end)

task.spawn(function()
	while true do
		if not ScreenGui or not ScreenGui.Parent then break end
		PopulateFeed(survivalsBoard.ScrollingFrame, "Survivals", Color3.fromRGB(255, 100, 100))
		PopulateFeed(pointsBoard.ScrollingFrame, "Points", Color3.fromRGB(100, 255, 100))
		PopulateFeed(streaksBoard.ScrollingFrame, "Streaks", Color3.fromRGB(255, 255, 100))
		task.wait(3)
	end
end)
