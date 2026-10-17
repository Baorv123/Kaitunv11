local tbl = {
	GuiName = "KaitunV4_OneClickUI",
	Ornament = Color3.fromRGB(222, 198, 160),
	Palette = {
		bg = Color3.fromRGB(246, 247, 250),
		panel = Color3.fromRGB(255, 255, 255),
		card = Color3.fromRGB(241, 242, 247),
		text = Color3.fromRGB(28, 30, 36),
		sub = Color3.fromRGB(96, 100, 112),
		muted = Color3.fromRGB(146, 150, 162),
		border = Color3.fromRGB(224, 226, 233),
		accent = Color3.fromRGB(88, 86, 214),
		success = Color3.fromRGB(46, 176, 110),
	},
	Tabs = {},
	Pages = {},
	Rows = {},
	Selected = "Status",
	StartedAt = os.clock(),
	Create = function(arg, arg2, arg3, parent)
		local instance = Instance.new(arg2)
		local v = pairs
		arg3 = arg3 or {}

		for k, v2 in v(arg3) do
			instance[k] = v2
		end

		instance.Parent = parent
		return instance
	end,
	Corner = function(arg, arg2, arg3)
		return arg:Create("UICorner", { CornerRadius = UDim.new(0, arg3 or 8) }, arg2)
	end,
	Stroke = function(arg, arg2, arg3, arg4, arg5)
		return arg:Create("UIStroke", { Color = arg3 or arg.Palette.border, Transparency = arg4 or 0.5, Thickness = arg5 or 1 }, arg2)
	end,
	Text = function(arg, arg2, arg3, arg4, arg5, arg6)
		return arg:Create("TextLabel", {
			BackgroundTransparency = 1,
			Text = tostring(arg3 or ""),
			TextColor3 = arg.Palette[arg6 or "text"],
			TextSize = arg4 or 12,
			Font = arg5 and Enum.Font.GothamBold or Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextStrokeTransparency = 1,
			ZIndex = 5,
		}, arg2)
	end,
	Card = function(arg, arg2, arg3, arg4)
		local tween = arg:Create("Frame", {
			Size = UDim2.new(1, 0, 0, arg3),
			BackgroundColor3 = arg.Palette.card,
			BackgroundTransparency = 0.35,
			BorderSizePixel = 0,
			LayoutOrder = arg4,
			ZIndex = 4,
		}, arg2)

		arg:Corner(tween, 9)
		arg:Stroke(tween, arg.Palette.border, 0.55, 1)
		return tween
	end,
	GuiParent = function()
		if type(gethui) == "function" then
			local ok, result = pcall(gethui)
			if ok and result then
				return result
			end
		end

		return game.Players.LocalPlayer:WaitForChild("PlayerGui")
	end,
	Page = function(arg, arg2)
		local tween = arg:Create("ScrollingFrame", {
			Name = arg2 .. "Page",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = arg.Palette.accent,
			Visible = false,
			ZIndex = 4,
		}, arg.Body)

		arg:Create("UIPadding", {
			PaddingTop = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
		}, tween)

		arg:Create("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, tween)
		arg.Pages[arg2] = tween
		return tween
	end,
	Row = function(arg, arg2, name, arg3, arg4)
		local v = arg:Card(arg2, 32, arg4)
		v.Name = name
		local v2 = arg:Text(v, arg3, 11, true, "muted")
		v2.Size = UDim2.new(0.42, -10, 1, 0)
		v2.Position = UDim2.fromOffset(9, 0)
		local v3 = arg:Text(v, "...", 11, true, "text")
		v3.Size = UDim2.new(0.58, -18, 1, 0)
		v3.Position = UDim2.new(0.42, 0, 0, 0)
		v3.TextXAlignment = Enum.TextXAlignment.Right
		v3.TextTruncate = Enum.TextTruncate.AtEnd
		arg.Rows[name] = v3
		return v3
	end,
	TabButton = function(arg, arg2, arg3, arg4)
		local tween = arg:Create("TextButton", {
			Name = "Tab_" .. arg3,
			Size = UDim2.fromOffset(130, 28),
			BackgroundColor3 = arg.Palette.card,
			BackgroundTransparency = 0.26,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = arg4,
			ZIndex = 10,
		}, arg2)

		arg:Corner(tween, 10)
		local v = arg:Stroke(tween, arg.Ornament, 0.7, 1)

		local tween2 = arg:Create("Frame", {
			Name = "Jewel",
			Size = UDim2.fromOffset(12, 12),
			Position = UDim2.fromOffset(12, 8),
			BackgroundColor3 = arg.Palette.accent,
			BackgroundTransparency = 0.08,
			BorderSizePixel = 0,
			Rotation = 45,
			ZIndex = 11,
		}, tween)

		arg:Corner(tween2, 3)
		local v2 = arg:Text(tween, string.upper(arg3), 10, true, "sub")
		v2.Position = UDim2.fromOffset(32, 0)
		v2.Size = UDim2.new(1, -38, 1, 0)
		v2.ZIndex = 12
		arg.Tabs[arg3] = { button = tween, stroke = v, jewel = tween2, label = v2 }

		tween.MouseButton1Click:Connect(function()
			arg:Select(arg3)
		end)

		return tween
	end,
	Select = function(arg, selected)
		arg.Selected = selected

		for k, page in pairs(arg.Pages) do
			page.Visible = k == selected
		end

		for k, tab in pairs(arg.Tabs) do
			local flag = k == selected
			tab.button.BackgroundColor3 = flag and arg.Palette.accent or arg.Palette.card
			tab.button.BackgroundTransparency = flag and 0.64 or 0.26
			tab.stroke.Transparency = flag and 0.1 or 0.7
			tab.stroke.Thickness = flag and 1.3 or 1
			tab.jewel.BackgroundColor3 = flag and arg.Palette.text or arg.Palette.accent
			tab.label.TextColor3 = flag and arg.Palette.text or arg.Palette.sub
		end
	end,
	Set = function(arg, arg2, arg3)
		local v = arg.Rows[arg2]

		if v then
			v.Text = tostring(arg3 or "...")
		end
	end,
	SetStatus = function(arg, arg2)
		if arg.StatusValue then
			arg.StatusValue.Text = tostring(arg2 or "...")
		end
	end,
	Build = function(arg)
		local v = arg:GuiParent()

		for _, child in ipairs(v:GetChildren()) do
			if child.Name == arg.GuiName then
				pcall(function()
					child:Destroy()
				end)
			end
		end

		local tween = arg:Create("ScreenGui", {
			Name = arg.GuiName,
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			DisplayOrder = 10060,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		}, v)

		arg.Gui = tween

		local tween2 = arg:Create("Frame", {
			Name = "Main",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(430, 300),
			BackgroundColor3 = arg.Palette.bg,
			BorderSizePixel = 0,
			Active = true,
			Draggable = true,
			ClipsDescendants = true,
			ZIndex = 2,
		}, tween)

		arg:Corner(tween2, 18)
		arg.Main = tween2
		local v2 = arg:Stroke(tween2, arg.Ornament, 0.12, 1.35)
		local create = arg.Create
		local tbl = {}
		local colorSequence = ColorSequence.new
		local tbl2 = {}
		local v3 = ColorSequenceKeypoint.new(0, arg.Ornament)
		local v4 = ColorSequenceKeypoint.new(0.5, arg.Palette.accent)
		local new = ColorSequenceKeypoint.new
		local ornament = arg.Ornament
		tbl2[1] = v3
		tbl2[2] = v4

		do
			local values = table.pack(new(1, ornament))
			table.move(values, 1, values.n, 3, tbl2)
		end

		tbl.Color = colorSequence(tbl2)
		local uiGradient = create(arg, "UIGradient", tbl, v2)

		pcall(function()
			game:GetService("TweenService"):Create(uiGradient, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0), { Rotation = 360 }):Play()
		end)

		local tween3 = arg:Create("Frame", {
			Name = "Root",
			Position = UDim2.fromOffset(10, 10),
			Size = UDim2.new(1, -20, 1, -20),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 3,
		}, tween2)

		local tween4 = arg:Create("Frame", {
			Name = "Header",
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundColor3 = arg.Palette.panel,
			BackgroundTransparency = 0.35,
			BorderSizePixel = 0,
			ZIndex = 4,
		}, tween3)

		arg:Corner(tween4, 14)
		arg:Stroke(tween4, arg.Ornament, 0.54, 1)
		local v5 = arg:Text(tween4, "Kaitun V4", 16, true, "text")
		v5.Position = UDim2.fromOffset(14, 7)
		v5.Size = UDim2.fromOffset(180, 20)
		local v6 = arg:Text(tween4, "Igbao", 10, true, "muted")
		v6.Position = UDim2.fromOffset(15, 28)
		v6.Size = UDim2.fromOffset(180, 14)

		local tween5 = arg:Create("Frame", {
			Name = "LiveChip",
			Position = UDim2.new(1, -100, 0, 15),
			Size = UDim2.fromOffset(52, 20),
			BackgroundColor3 = arg.Palette.card,
			BackgroundTransparency = 0.28,
			BorderSizePixel = 0,
			ZIndex = 5,
		}, tween4)

		arg:Corner(tween5, 10)
		local v7 = arg:Text(tween5, "● LIVE", 10, true, "success")
		v7.Size = UDim2.fromScale(1, 1)
		v7.TextXAlignment = Enum.TextXAlignment.Center

		local tween6 = arg:Create("TextButton", {
			Name = "Minimize",
			Position = UDim2.new(1, -44, 0, 14),
			Size = UDim2.fromOffset(22, 22),
			BackgroundColor3 = arg.Palette.card,
			BackgroundTransparency = 0.42,
			BorderSizePixel = 0,
			Text = "-",
			TextColor3 = arg.Palette.text,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			ZIndex = 5,
		}, tween4)

		arg:Corner(tween6, 8)

		local tween7 = arg:Create("TextButton", {
			Name = "Close",
			Position = UDim2.new(1, -18, 0, 14),
			Size = UDim2.fromOffset(22, 22),
			BackgroundColor3 = arg.Palette.card,
			BackgroundTransparency = 0.42,
			BorderSizePixel = 0,
			Text = "×",
			TextColor3 = arg.Palette.text,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			ZIndex = 5,
		}, tween4)

		arg:Corner(tween7, 8)

		local tween8 = arg:Create("Frame", {
			Name = "Tabs",
			Position = UDim2.fromOffset(0, 58),
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 8,
		}, tween3)

		arg:Create("Frame", {
			Name = "TabLine",
			Size = UDim2.new(1, -24, 0, 1),
			Position = UDim2.new(0, 12, 1, -1),
			BackgroundColor3 = arg.Ornament,
			BackgroundTransparency = 0.72,
			BorderSizePixel = 0,
			ZIndex = 8,
		}, tween8)

		local tween9 = arg:Create("Frame", {
			Name = "NavHost",
			Position = UDim2.fromOffset(4, 1),
			Size = UDim2.new(1, -8, 1, -2),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 9,
		}, tween8)

		arg:Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}, tween9)

		local tween10 = arg:Create("Frame", {
			Name = "Body",
			Position = UDim2.fromOffset(0, 98),
			Size = UDim2.new(1, 0, 1, -98),
			BackgroundColor3 = arg.Palette.panel,
			BackgroundTransparency = 0.4,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 4,
		}, tween3)

		arg:Corner(tween10, 14)
		arg:Stroke(tween10, arg.Ornament, 0.42, 1)
		arg.Body = tween10
		arg:TabButton(tween9, "Status", 1)
		arg:TabButton(tween9, "Info", 2)
		local Status = arg:Page("Status")
		local v8 = arg:Card(Status, 74, 1)
		v8.Name = "StatusCard"
		local v9 = arg:Text(v8, "STATUS", 9, true, "muted")
		v9.Position = UDim2.fromOffset(9, 6)
		v9.Size = UDim2.new(1, -18, 0, 12)
		local v10 = arg:Text(v8, "Loading...", 12, true, "text")
		v10.Position = UDim2.fromOffset(9, 20)
		v10.Size = UDim2.new(1, -18, 0, 48)
		v10.TextWrapped = true
		v10.TextYAlignment = Enum.TextYAlignment.Top
		arg.StatusValue = v10
		arg:Row(Status, "account", "Account", 2)
		arg:Row(Status, "runtime", "Runtime", 3)
		local Info = arg:Page("Info")
		arg:Row(Info, "player", "Player Name", 1)
		arg:Row(Info, "race", "Race Name", 2)
		arg:Row(Info, "tier", "Tier V4", 3)
		local flag = false

		tween6.MouseButton1Click:Connect(function()
			flag = not flag
			tween10.Visible = not flag
			tween8.Visible = not flag
			tween2.Size = flag and UDim2.fromOffset(430, 70) or UDim2.fromOffset(430, 300)
			tween6.Text = flag and "+" or "-"
		end)

		tween7.MouseButton1Click:Connect(function()
			pcall(function()
				tween:Destroy()
			end)
		end)

		arg:Select("Status")
		return arg
	end,
	Splash = function(arg)
		local TweenService = game:GetService("TweenService")
		local Lighting = game:GetService("Lighting")
		local tween = arg:Create("BlurEffect", { Name = "KaitunV4SplashBlur", Size = 0 }, Lighting)
		local tween2 = arg:Create("ScreenGui", { Name = "KaitunV4Splash", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 10070 }, arg:GuiParent())

		local tween3 = arg:Create("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = arg.Palette.bg,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1,
		}, tween2)

		local tween4 = arg:Create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(280, 120),
			BackgroundColor3 = arg.Palette.panel,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
		}, tween2)

		arg:Corner(tween4, 16)
		local v = arg:Stroke(tween4, arg.Palette.border, 1, 1)
		local v2 = arg:Text(tween4, "Kaitun V4", 18, true, "text")
		v2.Position = UDim2.fromOffset(0, 22)
		v2.Size = UDim2.new(1, 0, 0, 26)
		v2.TextXAlignment = Enum.TextXAlignment.Center
		v2.TextTransparency = 1
		local v3 = arg:Text(tween4, "Đang khởi động...", 12, false, "sub")
		v3.Position = UDim2.fromOffset(0, 50)
		v3.Size = UDim2.new(1, 0, 0, 18)
		v3.TextXAlignment = Enum.TextXAlignment.Center
		v3.TextTransparency = 1

		local tween5 = arg:Create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 82),
			Size = UDim2.fromOffset(200, 4),
			BackgroundColor3 = arg.Palette.border,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 2,
		}, tween4)

		arg:Create("UICorner", { CornerRadius = UDim.new(1, 0) }, tween5)

		local tween6 = arg:Create("Frame", {
			Size = UDim2.new(0.35, 0, 1, 0),
			BackgroundColor3 = arg.Palette.accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 3,
		}, tween5)

		arg:Create("UICorner", { CornerRadius = UDim.new(1, 0) }, tween6)
		local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(tween, tweenInfo, { Size = 18 }):Play()
		TweenService:Create(tween3, tweenInfo, { BackgroundTransparency = 0.15 }):Play()
		TweenService:Create(tween4, tweenInfo, { BackgroundTransparency = 0 }):Play()
		TweenService:Create(v, tweenInfo, { Transparency = 0.4 }):Play()
		TweenService:Create(v2, tweenInfo, { TextTransparency = 0 }):Play()
		TweenService:Create(v3, tweenInfo, { TextTransparency = 0 }):Play()
		TweenService:Create(tween5, tweenInfo, { BackgroundTransparency = 0 }):Play()
		TweenService:Create(tween6, tweenInfo, { BackgroundTransparency = 0 }):Play()
		local flag = true

		task.spawn(function()
			while flag do
				tween6.Position = UDim2.new(-0.35, 0, 0, 0)
				local tween7 = TweenService:Create(tween6, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(1, 0, 0, 0) })
				tween7:Play()
				tween7.Completed:Wait()
			end
		end)

		return {
			setSubtitle = function(arg2)
				v3.Text = tostring(arg2 or "")
			end,
			hide = function()
				flag = false
				local tweenInfo2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				TweenService:Create(tween, tweenInfo2, { Size = 0 }):Play()
				TweenService:Create(tween3, tweenInfo2, { BackgroundTransparency = 1 }):Play()
				TweenService:Create(tween4, tweenInfo2, { BackgroundTransparency = 1 }):Play()
				TweenService:Create(v, tweenInfo2, { Transparency = 1 }):Play()
				TweenService:Create(v2, tweenInfo2, { TextTransparency = 1 }):Play()
				TweenService:Create(v3, tweenInfo2, { TextTransparency = 1 }):Play()
				TweenService:Create(tween5, tweenInfo2, { BackgroundTransparency = 1 }):Play()
				TweenService:Create(tween6, tweenInfo2, { BackgroundTransparency = 1 }):Play()

				task.delay(0.4, function()
					pcall(function()
						tween:Destroy()
					end)

					pcall(function()
						tween2:Destroy()
					end)
				end)
			end,
		}
	end,
}

local v = tbl:Splash()
task.wait(0.9)
tbl:Build()
v.setSubtitle("Đang tải Kaitun...")
v.hide()

spawn(function()
	setfpscap(getgenv().Kurinian.FPS)
end)

if workspace:GetAttribute("MAP") and workspace:GetAttribute("MAP") ~= "Sea3" then
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
end

if not isfile("cachejobid.json") then
	writefile("cachejobid.json", "{}")
end

if not isfile("meyyhub_cache.json") then
	writefile("meyyhub_cache.json", "{}")
end

local ok, result = pcall(function()
	return game.HttpService:JSONDecode(readfile("meyyhub_cache.json"))
end)

if not ok then
	result = {}
end

local tbl2 = {}

if getgenv().Kurinian.Help and getgenv().Kurinian.Help.Account then
	for _, v2 in pairs(getgenv().Kurinian.Help.Account) do
		if v2 and v2 ~= "" then
			tbl2[v2] = true
		end
	end
end

isaccmain = {}

if getgenv().Kurinian.Main and getgenv().Kurinian.Main.Account then
	for _, v2 in pairs(getgenv().Kurinian.Main.Account) do
		if v2 and v2 ~= "" then
			isaccmain[v2] = true
		end
	end
end

local name = game.Players.LocalPlayer.Name

if isaccmain[name] then
	tbl:Set("account", "Main - " .. name)
elseif tbl2[name] then
	tbl:Set("account", "Help - " .. name)
else
	tbl:Set("account", "Unknown - " .. name)
end

tbl:Set("player", name)
local localPlayer = game.Players.LocalPlayer
result[game.JobId] = math.floor(tick())
writefile("meyyhub_cache.json", game.HttpService:JSONEncode(result))

thuaaa = function()
	if game:GetService("Players").LocalPlayer.Team then
		return
	end

	if getgenv().Team == "Marines" or not getgenv().Team then
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
	elseif getgenv().Team == "Pirates" then
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
	end
end

if getgenv().Team == "Marines" or not getgenv().Team then
	thuaaa()
elseif getgenv().Team == "Pirates" then
	thuaaa()
end

local chooseTeam = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ChooseTeam", true)
local uiController = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("UIController", true)

if chooseTeam and chooseTeam.Visible then
	while true do
		task.wait(1)

		if chooseTeam and chooseTeam.Visible and uiController then
			for _, v2 in pairs(getgc(true)) do
				if type(v2) == "function" and getfenv(v2).script == uiController then
					local v3 = getconstants(v2)

					pcall(function()
						if (v3[1] == "Pirates" or v3[1] == "Marines") and #v3 == 1 then
							if v3[1] == getgenv().Team then
								v2(getgenv().Team)
							end
						end
					end)
				end
			end
		end

		if not game:GetService("Players").LocalPlayer.Team then
			continue
		end
		break
	end
end

game:GetService("TeleportService")
game:GetService("HttpService")

if not isfile("noguchi/fruitdatas.json") then
	writefile("noguchi/fruitdatas.json", game:HttpGet("https://raw.githubusercontent.com/noguchihyuga/bin/refs/heads/main/fruitdatas.json"))
end

getgenv().Kurinian.Team = getgenv().Kurinian.Team and (getgenv().Kurinian.Team == "Marines" or getgenv().Kurinian.Team == "Pirates") and getgenv().Kurinian.Team or "Marines"

for _, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
	if child:FindFirstChild("ChooseTeam") then
		firesignal(child.ChooseTeam.Container[getgenv().Kurinian.Team].Frame.TextButton.Activated)
	end
end

local now = tick()

while true do
	wait()

	if tick() - now > 5 then
		game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
	end

	if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen") then
		continue
	end
	break
end

Services = setmetatable({}, { __index = function(arg, arg2)
	local ok2, result2 = pcall(function()
		return cloneref(game:GetService(arg2))
	end)

	if ok2 then
		rawset(arg, arg2, result2)
		return result2
	end
	error("Invalid Roblox Service: " .. tostring(arg2))
end })

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local localPlayer2 = Players.LocalPlayer
;(localPlayer2.Character or localPlayer2.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")

local tbl3 = {
	eq = function()
		for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if child:IsA("Tool") and child.ToolTip == "Melee" and not _G.USESWORD then
				if not pcall(function()
					game.Players.LocalPlayer.Character.Humanoid:EquipTool(child)
				end) then
					continue
				end
			elseif child:IsA("Tool") and child.ToolTip == "Sword" and _G.USESWORD then
				if not pcall(function()
					game.Players.LocalPlayer.Character.Humanoid:EquipTool(child)
				end) then
					continue
				end
			else
				continue
			end

			break
		end
	end,
	haki = function()
		if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
		end
	end,
	join = function(arg, arg2)
		local str = arg2 and (arg2 == "Marines" or arg2 == "Pirates") and arg2 or "Marines"

		for _, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
			if child:FindFirstChild("ChooseTeam") then
				firesignal(child.ChooseTeam.Container[str].Frame.TextButton.Activated)
			end
		end
	end,
	tele = function(arg, arg2)
		if arg2 then
			game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", arg2)
		else
			game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
		end
	end,
	topos = function(arg, arg2, arg3)
		pcall(function()
			if not arg3 then
				game.Players.LocalPlayer.Character.Humanoid.Sit = false
			end
		end)

		local localPlayer3 = game:GetService("Players").LocalPlayer
		local humanoidRootPart = (localPlayer3.Character or localPlayer3.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
		local tween = TweenService:Create(humanoidRootPart, TweenInfo.new((humanoidRootPart.Position - arg2.Position).Magnitude / 280, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = arg2 })
		tween:Play()
		return tween
	end,
	noclip = function(arg, arg2)
		spawn(function()
			while wait() do
				if loadstring(arg2)() and not game.Players.LocalPlayer.Character.Humanoid.Sit then
					if not Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
						local bodyVelocity = Instance.new("BodyVelocity")
						bodyVelocity.Name = "BodyClip"
						bodyVelocity.Parent = Players.LocalPlayer.Character.HumanoidRootPart
						bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
						bodyVelocity.Velocity = Vector3.zero
					end

					for _, descendant in pairs(Players.LocalPlayer.Character:GetDescendants()) do
						if descendant:IsA("BasePart") then
							descendant.CanCollide = false
						end
					end
				else
					pcall(function()
						Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
					end)
				end
			end
		end)
	end,
	getdis = function(arg, arg2, arg3)
		return (arg2.Position - (arg3 or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame).Position).Magnitude
	end,
}

if workspace:GetAttribute("MAP") and workspace:GetAttribute("MAP") == "Sea1" then
	SeaIndex = 1
elseif workspace:GetAttribute("MAP") and workspace:GetAttribute("MAP") == "Sea2" then
	SeaIndex = 2
elseif workspace:GetAttribute("MAP") and workspace:GetAttribute("MAP") == "Sea3" then
	SeaIndex = 3
end

Portals = ({
	{
		Vector3.new(-7894.62, 5545.4917, -380.24634),
		Vector3.new(-4607.8228, 872.5423, -1667.5569),
		Vector3.new(61163.85, 11.759522, 1819.7842),
		Vector3.new(3876.2805, 35.10614, -1939.3202),
	},
	{
		Vector3.new(-288.46246, 306.1306, 597.99884),
		Vector3.new(2284.912, 15.152046, 905.4829),
		Vector3.new(923.2125, 126.976006, 32852.832),
		Vector3.new(-6508.558, 89.034996, -132.83954),
	},
	{},
})[SeaIndex]

GetPortal = function(arg)
	local n = 9e9
	local v2 = nil

	for _, v3 in Portals, nil, nil do
		local v4 = CaculateDistance(v3, arg)

		if v4 < CaculateDistance(arg) - 300 and v4 < n then
			n = v4
			v2 = v3
		end
	end

	if v2 then
		Remotes.CommF_:InvokeServer("requestEntrance", v2)
		return task.wait()
	end
end

GetEntries = function(arg)
	local v2 = nil
	local n = 9e9
	local v3 = nil

	for _, v4 in W, v2, nil do
		local v5 = CaculateDistance(v4, arg)

		if v5 < CaculateDistance(arg) - 700 and v5 < n then
			n = v5
			v3 = v4
		end
	end

	if v3 then
		if os.time() - 0 > 30 then
			for i = 1, 10 do
				task.wait()
			end
		end
	end
end

AwaitUntilPlayerLoaded = function(arg)
	repeat
		task.wait()
	until arg.Character

	arg.Character:WaitForChild("Humanoid")

	repeat
		task.wait()
	until arg.Character.Humanoid.Health > 0
end

ConvertTo = function(arg, arg2)
	return arg.new(arg2.X, arg2.Y, arg2.Z)
end

CaculateDistance = function(arg, arg2)
	if not arg then
		return 0
	end
	arg2 = arg2 or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	return (ConvertTo(Vector3, arg) - ConvertTo(Vector3, arg2)).magnitude
end

InArea = function(arg)
	local worldOrigin = workspace:FindFirstChild("_WorldOrigin")
	if not worldOrigin or not worldOrigin:FindFirstChild("Locations") then
		return nil
	end
	local position = typeof(arg) == "CFrame" and arg.Position or arg
	local v2 = next
	local children, v3 = worldOrigin.Locations:GetChildren()
	local n = 0
	local v4 = nil

	for _, v5 in v2, children, v3 do
		if v5:FindFirstChild("Mesh") and (position - v5.Position).Magnitude <= v5.Mesh.Scale.X / 2 + 500 then
			if n < v5.Mesh.Scale.X then
				n = v5.Mesh.Scale.X
				v4 = v5
			end
		end
	end

	return v4
end

GetSpawnPoint = function(arg)
	local playerSpawns = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") and workspace._WorldOrigin.PlayerSpawns:FindFirstChild(game.Players.LocalPlayer.Team.Name)
	if not playerSpawns then
		return nil
	end
	local position = typeof(arg) == "CFrame" and arg.Position or typeof(arg) == "Vector3" and arg or arg.Position
	local v2 = next
	local children, v3 = playerSpawns:GetChildren()

	for _, v4 in v2, children, v3 do
		if v4:FindFirstChild("Part") and (v4.Part.Position - position).Magnitude <= 2500 then
			return v4
		end
	end

	return nil
end

CanBypassTeleport = function(arg)
	local v2 = InArea(arg)
	if not v2 then
		return false
	end
	local name2 = v2.Name
	if name2:find("Dimension") or name2:find("Submerged") or name2 == "Sealed Cavern" or name2:lower():find("under") then
		return false
	end
	local data = game.Players.LocalPlayer:FindFirstChild("Data")
	data = data and data:FindFirstChild("LastSpawnPoint")
	if data and data.Value == "SubmergedIsland" then
		return false
	end
	local humanoidRootPart = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return false
	end

	if (arg - humanoidRootPart.Position).Magnitude <= 3500 then
		return false
	end
	return true
end

GetBypassCFrame = function(arg)
	local humanoidRootPart = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return nil
	end
	local playerSpawns = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") and workspace._WorldOrigin.PlayerSpawns:FindFirstChild(game.Players.LocalPlayer.Team.Name)
	if not playerSpawns then
		return nil
	end
	local v2 = GetSpawnPoint(humanoidRootPart)
	local v3 = next
	local children, v4 = playerSpawns:GetChildren()
	local huge = math.huge
	local v5 = nil

	for _, v6 in v3, children, v4 do
		if v6:FindFirstChild("Part") then
			local magnitude = (arg - humanoidRootPart.Position).Magnitude
			local magnitude2 = (v6.Part.Position - humanoidRootPart.Position).Magnitude
			local magnitude3 = (v6.Part.Position - arg).Magnitude
			local v7 = GetSpawnPoint(v6.Part)

			if magnitude >= 3000 and v7 ~= v2 and magnitude2 <= 10000 and magnitude3 <= huge then
				huge = magnitude3
				v5 = v6
			end
		end
	end

	return v5
end

BypassTP = function(arg)
	if not CanBypassTeleport(arg) then
		return false
	end
	local v2 = GetBypassCFrame(arg)
	if not v2 then
		return false
	end
	local character = game.Players.LocalPlayer.Character
	if not character then
		return false
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return false
	end

	pcall(function()
		character.LastSpawnPoint.Disabled = true
	end)

	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetLastSpawnPoint", v2.Name)
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
	character:PivotTo(v2.Part.CFrame)
	humanoid:ChangeState(15)

	while true do
		task.wait()
		if not (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0) then
			continue
		end
		break
	end

	return true
end

RequestEntrance = function(arg)
	if not Portals then
		return false
	end
	local huge = math.huge
	local v2 = nil

	for _, v3 in next, Portals, nil do
		local magnitude = (v3 - (typeof(arg) == "CFrame" and arg.Position or arg)).Magnitude

		if magnitude < huge then
			huge = magnitude
			v2 = v3
		end
	end

	if v2 and huge < CaculateDistance(arg) then
		if TweenInstance then
			pcall(function()
				TweenInstance:Cancel()
			end)
		end

		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", v2)
		task.wait(1)
		return true
	end
end

tbl3.tpbypass = function(arg, arg2)
	if not arg2 or TweenDebounce then
		return
	end
	local flag = typeof(arg2) ~= "CFrame" and ConvertTo(CFrame, arg2) or arg2

	if TweenInstance then
		pcall(function()
			TweenInstance:Cancel()
		end)
	end

	if not (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
		return
	end

	-- if CaculateDistance(flag) >= 5000 then
--     if BypassTP(flag.Position) then
--         return
--     end
-- end

	for _, descendant in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
		end
	end

	local head = game.Players.LocalPlayer.Character:WaitForChild("Head")

	if not head:FindFirstChild("eltrul") then
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Name = "eltrul"
		bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.Parent = head
	end

	if CaculateDistance(flag) > 500 then
		if RequestEntrance(flag) then
			return tbl3:topos(flag)
		end
	end

	if CaculateDistance(Vector3.new(11256, -2138, 9888), flag) < CaculateDistance(flag) - 700 and SeaIndex == 3 then
		local cframe = CFrame.new(-16269, 23, 1371)
		if CaculateDistance(cframe) > 60 then
			return tbl3:topos(cframe) and task.wait(1)
		end
		require(game.ReplicatedStorage.Modules.Net):RemoteFunction("SubmarineWorkerSpeak"):InvokeServer("TravelToSubmergedIsland")
		AwaitUntilPlayerLoaded(game.Players.LocalPlayer)
		task.wait(1)
	end

	local cframe = CFrame.new(flag.Position)
	local linear = Enum.EasingStyle.Linear
	TweenInstance = Services.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(CaculateDistance(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, cframe) / 280, linear), { CFrame = cframe })
	TweenInstance:Play()
end

local cframe = CFrame.new(3030.93433, 2280.98389, -7324.29102, -0.422564238, -3.94092625e-09, -0.90633297, 2.88951862e-09, 1, -5.69540548e-09, 0.90633297, -5.02554043e-09, -0.422564238)
local cframe2 = CFrame.new(28286.35546875, 14896.5078125, 102.62469482422)

gotoTemple = function()
	if tbl3:getdis(cframe2) <= 100 then
		return true
	end

	if tbl3:getdis(cframe) > 30 then
		tbl3:tpbypass(cframe)
		return false
	end

	pcall(function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Teleport")
	end)

	task.wait(1)
	return tbl3:getdis(cframe2) <= 100
end

getdoor = function(arg)
	return workspace.Map["Temple of Time"]:WaitForChild((arg or game:GetService("Players").LocalPlayer.Data.Race.Value) .. "Corridor"):WaitForChild("Door").Entrance
end

getdis = function(...)
	return tbl3:getdis(...)
end

local tbl4 = {}
local cframe3 = CFrame.new(28692.3477, 14887.5605, -53.7669983, 0.707131445, 0, -0.707082093, 0, 1, 0, 0.707082093, 0, 0.707131445)
local cframe4 = CFrame.new(28782.7246, 14898.9902, -59.6069946, 0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, 0.707134247)
local cframe5 = CFrame.new(28700.875, 14888.2598, -154.110992, -1, 0, 0, 0, 1, 0, 0, 0, -1)
local cframe6 = CFrame.new(28795.7715, 14888.2598, -112.917999, -0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, -0.707134247)
local cframe7 = CFrame.new(28658.4551, 14888.2598, -121.372009, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
local cframe8 = CFrame.new
tbl4[1] = cframe3
tbl4[2] = cframe4
tbl4[3] = cframe5
tbl4[4] = cframe6
tbl4[5] = cframe7

do
	local values = table.pack(cframe8(28742.4688, 14887.5596, -18.2120056, 0.92051065, 0, 0.390717506, 0, 1, 0, -0.390717506, 0, 0.92051065))
	table.move(values, 1, values.n, 6, tbl4)
end

isplrshouldkill = function(arg)
	if arg.Character and arg.Character:FindFirstChild("HumanoidRootPart") and arg.Character:FindFirstChild("Humanoid") and arg.Character.Humanoid.Health > 0 then
		for _, v2 in pairs(tbl4) do
			if getdis(arg.Character.HumanoidRootPart.CFrame, v2) < 5 then
				return true
			end
		end
	end

	return false
end

local tbl5 = {
	Human = "Last Resort",
	Mink = "Agility",
	Fishman = "Water Body",
	Skypiea = "Heavenly Blood",
	Ghoul = "Heightened Senses",
	Cyborg = "Energy Core",
	Draco = "Primordial Reign",
}

local tbl6 = {
	Human = workspace._WorldOrigin.Locations:WaitForChild("Trial of Strength"),
	Mink = workspace._WorldOrigin.Locations:WaitForChild("Trial of Speed"),
	Fishman = workspace._WorldOrigin.Locations:WaitForChild("Trial of Water"),
	Skypiea = workspace._WorldOrigin.Locations:WaitForChild("Trial of the King"),
	Ghoul = workspace._WorldOrigin.Locations:WaitForChild("Trial of Carnage"),
	Cyborg = workspace._WorldOrigin.Locations:WaitForChild("Trial of the Machine"),
	Draco = workspace._WorldOrigin.Locations:WaitForChild("Trial of Flames"),
}

_G.playersinserver = {}

updateplayers = function()
	if not _G.playersinserver then
		_G.playersinserver = {}
	end

	local playersinserver = {}

	for _, child in pairs(game.Players:GetChildren()) do
		local function fn()
			local ok2, result2 = pcall(function()
				return workspace.Map["Temple of Time"]:WaitForChild(child.Data.Race.Value .. "Corridor"):WaitForChild("Door"):WaitForChild("Entrance")
			end)

			if ok2 then
				return result2
			end
			return nil
		end

		playersinserver[child] = { Race = child.Data.Race.Value, Door = fn() }
	end

	_G.playersinserver = playersinserver
end

tier1 = game.Players.LocalPlayer.Data.Race.C.Value

isshouldturnonability = function()
	local n = 0

	for _, child in pairs(workspace.Characters:GetChildren()) do
		if child.Name ~= game.Players.LocalPlayer.Name and child:FindFirstChild("HumanoidRootPart") then
			local value = game.Players:FindFirstChild(child.Name).Data.Race.Value

			if value ~= "Draco" then
				local door = workspace.Map["Temple of Time"]:FindFirstChild(value .. "Corridor"):FindFirstChild("Door")
				local cFrame = child.HumanoidRootPart.CFrame

				if getdis(door:FindFirstChild("Entrance").CFrame, cFrame) < 10 then
					if child.HumanoidRootPart:FindFirstChild(tbl5[game.Players:WaitForChild(child.Name).Data.Race.Value]) then
						n += 1
					end
				end
			end
		end
	end

	return n >= 1
end

local function fn()
	if not isaccmain[game.Players.LocalPlayer.Name] then
		return false
	end
	local value = game.Players.LocalPlayer.Data.Race.Value

	for _, player in pairs(game.Players:GetPlayers()) do
		if tbl2[player.Name] then
			local ok2, result2 = pcall(function()
				return player.Data.Race.Value
			end)

			if ok2 and result2 == value then
				warn("[KaitunV4] Acc help " .. player.Name .. " cùng tộc " .. value .. " → skip trial")
				return true
			end
		end
	end

	return false
end

local function fn2(arg)
	local ok2, result2 = pcall(function()
		return workspace.Map["Temple of Time"][arg.Data.Race.Value .. "Corridor"].Door.Entrance
	end)

	if ok2 then
		return result2
	end
	return nil
end

local function fn3(arg)
	local character = arg.Character
	if not (character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0) then
		return false
	end
	local humanoidRootPart = character.HumanoidRootPart
	local v2 = fn2(arg)
	if v2 and getdis(humanoidRootPart.CFrame, v2.CFrame) < 30 then
		return true
	end

	for _, v3 in pairs(tbl4) do
		if getdis(humanoidRootPart.CFrame, v3) < 30 then
			return true
		end
	end

	local v3 = tbl5[select(2, pcall(function()
		return arg.Data.Race.Value
	end)) or ""]

	if v3 and humanoidRootPart:FindFirstChild(v3) then
		return true
	end
	return false
end

local function fn4()
	local n = 0
	local n2 = 0

	for _, player in pairs(game.Players:GetPlayers()) do
		if tbl2[player.Name] then
			n += 1

			if fn3(player) then
				n2 += 1
			end
		end
	end

	if n == 0 then
		return true, 0, 0
	end
	return n2 >= n, n2, n
end

talktoonggianaodo = function()
	local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")

	if response == 1 then
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin")
	elseif response == 2 then
		repeat
			wait()
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Teleport")
			tbl3:topos(CFrame.new(3028, 2281, -7325))
		until tbl3:getdis(CFrame.new(28286.35546875, 14896.5078125, 102.62469482422)) <= 15
	else
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
		wait(1)
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue")
	end
end

getBlueGear = function()
	if not game.workspace.Map:FindFirstChild("MysticIsland") then
		return nil
	end

	for _, child in pairs(game.workspace.Map.MysticIsland:GetChildren()) do
		if child:IsA("MeshPart") and child.MeshId == "rbxassetid://10153114969" then
			return child
		end
	end
end

isnight = function()
	local clockTime = game.Lighting.ClockTime
	return clockTime >= 16 or clockTime < 5
end

isfullmoon = function()
	return game:GetService("Lighting"):GetAttribute("MoonPhase") == 5
end

tbl3:noclip("return true")

getmob1 = function(arg)
	local tbl7 = {}
	local v2 = next
	local children, v3 = game.Workspace.Enemies:GetChildren()

	for _, v4 in v2, children, v3 do
		if v4:IsA("Model") and (typeof(arg) == "table" and table.find(arg, v4.Name) or v4.Name == arg) and v4:FindFirstChild("Humanoid") and v4.Humanoid.Health > 0 and v4:FindFirstChild("HumanoidRootPart") then
			table.insert(tbl7, v4)
		end
	end

	return tbl7
end

checkmob_ = function(arg)
	return arg and arg:FindFirstChild("HumanoidRootPart") and arg:FindFirstChild("Humanoid") and arg.Humanoid.Health > 0
end

noideaforname = function(arg)
	if tbl2[arg.Name] then
		return false
	end
	return true
end

getplayers = function()
	local tbl7 = {}

	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= game.Players.LocalPlayer and player.Character and not isaccmain[player.Name] and noideaforname(player) then
			if player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
				for _, v2 in pairs(tbl4) do
					if getdis(player.Character.HumanoidRootPart.CFrame, v2) < 10 then
						tbl7[player.Character] = true
					end
				end
			end
		end
	end

	return tbl7
end

checkbackpack = function(arg)
	return game.Players.LocalPlayer.Backpack:FindFirstChild(arg) or game.Players.LocalPlayer.Character:FindFirstChild(arg)
end

local function fn5()
	local ok2, result2 = pcall(function()
		return game:GetService("HttpService"):JSONDecode(readfile("meyyhub/trialdonev4.json"))
	end)

	if ok2 and type(result2) == "table" then
		return result2
	end
	return {}
end

local function fn6(arg)
	local name2 = game.Players.LocalPlayer.Name
	local v2 = fn5()[name2]
	return v2 ~= nil and v2[tostring(arg)] == true
end

local function fn7(arg)
	if not isfolder("meyyhub") then
		makefolder("meyyhub")
	end

	local v2 = fn5()
	local name2 = game.Players.LocalPlayer.Name
	v2[name2] = v2[name2] or {}

	if v2[name2][tostring(arg)] ~= true then
		v2[name2][tostring(arg)] = true

		pcall(function()
			writefile("meyyhub/trialdonev4.json", game:GetService("HttpService"):JSONEncode(v2))
		end)
	end
end

local function fn8()
	local ok2, result2, result3, result4 = pcall(function()
		return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Check")
	end)

	if not ok2 or type(result2) ~= "number" then
		return nil
	end
	return result2, result3, result4
end

local function fn9(arg)
	local num = tonumber(arg)
	local num2 = tonumber(game.Players.LocalPlayer.Data.Fragments.Value)
	if num and num2 and num2 < num then
		return false
	end
	local tbl7 = { "UpgradeRace", "Buy" }

	if game.Players.LocalPlayer.Data.Race.Value == "Draco" then
		tbl7[3] = 2
	end

	pcall(function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(tbl7))
	end)

	return true
end

trialable = function()
	local n = game.Players.LocalPlayer.Data.Race.C.Value or 0
	if n >= 6 or fn6(n) then
		return false
	end

	if fn and fn() then
		return false, "same_race_ally"
	end

	if not game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
		if checkbackpack(tbl5[game:GetService("Players").LocalPlayer.Data.Race.Value]) then
			return true
		end
		return false
	end

	local v2, v3, v4 = fn8()
	if v2 == nil then
		return false
	end

	if v2 == 5 then
		return false
	end

	if v2 == 6 then
		return false, (tonumber(v3) or 2) - 2
	end

	if v2 == 1 or v2 == 3 then
		return false
	end

	if v2 == 2 or v2 == 4 or v2 == 7 then
		if not fn9(v4) then
			return false, "raiding"
		end
		return true, "buyfrag"
	end

	if v2 == 0 then
		return true, v3
	end

	if v2 ~= 8 then
		return false
	end
	return true, 10 - (tonumber(v3) or 0)
end

status = function(statusnow)
	_G.statusnow = statusnow
end

gettimeserver = function()
	return os.time()
end

followMainAccount = function()
	if isaccmain[game.Players.LocalPlayer.Name] then
		return true
	end
	local flag = false
	local v2 = gettimeserver()
	local v3 = nil
	local followMain = nil

	pcall(function()
		local v4 = pairs
		local account = getgenv().Kurinian.Main.Account or {}

		for _, v5 in v4(account) do
			local ok2, result2 = pcall(function()
				return game.HttpService:JSONDecode(game:HttpGet("https://nanhhub.vercel.app/api/mainaccount/" .. v5))
			end)

			if ok2 and result2 and result2.data then
				local jobid = result2.data.jobid
				local time = result2.data.time

				if jobid and time and v2 - time < 30 then
					if jobid == game.JobId then
						flag = true
						return
					end

					if not v3 then
						v3 = jobid
						followMain = v5
					end

					continue
				end

				warn("[followMain] " .. v5 .. " stale/offline, thử main tiếp...")
			end
		end
	end)

	if not flag and v3 then
		status("Follow main: " .. followMain)

		pcall(function()
			game.ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", v3)
		end)
	end

	return flag
end

webhook = function(arg)
	local str

	if arg == "trial" then
		str = "Done Trial"
	else
		str = "Done Full Tier"
	end

	if getgenv().Kurinian.Webhook.Url == "" then
		return
	end
	local url = getgenv().Kurinian.Webhook.Url

	local tbl7 = {
		username = "ʚ Iwgbao ɞ ",
		avatar_url = "https://cdn.discordapp.com/attachments/1483412809957113917/1505120553734766713/cte_2.jfif?ex=6a09783f&is=6a0826bf&hm=8d8bf1376c3a05cbf82f7f36dc174b1c4d026c73fd391c5daea947010c6b4d41&",
		embeds = {
			{
				title = " <a:a_afx_heart_pink:1213626268205973504> Kaitun V4 <a:a_afx_heart_pink:1213626268205973504> ",
				description = str,
				color = 11986679,
				fields = {
					{
						name = " <a:ast_dcr_thovotay:1418115206671892521> Name :",
						value = "```" .. game.Players.LocalPlayer.Name .. "```",
						inline = true,
					},
					{
						name = " <a:ast_dcr_thovotay:1418115206671892521> Tier",
						value = "```" .. game.Players.LocalPlayer.Data.Race.C.Value .. "```",
						inline = false,
					},
				},
				footer = {
					text = "ʚ Iwgbao ɞ | " .. os.date("%H:%M:%S %d/%m/%Y"),
					icon_url = "https://cdn.discordapp.com/attachments/1483412809957113917/1505120554104127528/cute.jfif?ex=6a09783f&is=6a0826bf&hm=5cf5e8f83ba3c797a5901813eb66d4df716f617473ce7c089d6f66912f205dc5&",
				},
				thumbnail = {
					url = "https://cdn.discordapp.com/attachments/1503282260856672367/1504877443993833714/1778860380021.png?ex=6a0895d5&is=6a074455&hm=86c9de11e9c2f8b291bda710bb406d11144c7af5fe5fd26edb34ea84b7c8aeef&",
				},
				image = {
					url = "https://cdn.discordapp.com/attachments/1325479541195673610/1504873598450663595/1778860201529.png?ex=6a089241&is=6a0740c1&hm=5b09db29f8c9e48e88f5026c45977d2a41c9343746dae3bae37bbdbf4f7cfc3e&",
				},
			},
		},
	}

	pcall(function()
		local json = game:GetService("HttpService"):JSONEncode(tbl7)
		local request_ = syn and syn.request or http_request or request or http and http.request
		if not request_ then
			warn("[KaitunV4] Executor không có request() -> không gửi được webhook")
			return
		end

		local ok2, result2 = pcall(function()
			return request_({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = json })
		end)

		if ok2 then
			print(" Sent webhook: " .. game.Players.LocalPlayer.Name .. " | code: " .. tostring(type(result2) == "table" and result2.StatusCode or "?"))
		else
			warn(" Webhook error: " .. tostring(result2))
		end
	end)
end

local function fn10(arg)
	local ok2, result2 = pcall(function()
		return game:GetService("HttpService"):JSONDecode(readfile("meyyhub/webhookv4.json"))
	end)

	if not ok2 or type(result2) ~= "table" then
		result2 = {}
	end

	local name2 = game.Players.LocalPlayer.Name
	if result2[name2] and result2[name2][arg] then
		return false
	end
	result2[name2] = result2[name2] or {}
	result2[name2][arg] = true

	if not isfolder("meyyhub") then
		makefolder("meyyhub")
	end

	pcall(function()
		writefile("meyyhub/webhookv4.json", game:GetService("HttpService"):JSONEncode(result2))
	end)

	return true
end

if not getgenv()._meyyWebhookWatcher then
	getgenv()._meyyWebhookWatcher = true

	spawn(function()
		local n = game.Players.LocalPlayer.Data.Race.C.Value or 0

		while wait(2) do
			local webhook_ = getgenv().Kurinian.Webhook or {}

			if webhook_.Url and webhook_.Url ~= "" then
				local n2 = game.Players.LocalPlayer.Data.Race.C.Value or 0

				if n2 > n then
					if webhook_.DoneTrial and fn10("trial_" .. n2) then
						webhook("trial")
						n = n2
					else
						n = n2
					end
				end

				local n3 = tonumber((getgenv().Kurinian.Main or {}).Tier) or 6

				if webhook_.DoneTier and n2 >= n3 then
					local ok2, result2 = pcall(function()
						return game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getRaceLevel")
					end)

					if ok2 and result2 == 4 and fn10("tier_" .. n2) then
						webhook("tier")
					end
				end
			end
		end
	end)
end

local account = (getgenv().Kurinian.Main or {}).Account or {}
local request_ = syn and syn.request or http_request or request
local request_2

if request_ then
	request_2 = request_
else
	request_2 = http and http.request
end

local function fn11()
	return (getgenv().Kurinian.Main or {}).TurnKey or "default"
end

local n = nil

local function fn12()
	local ok2, result2 = pcall(function()
		return game.HttpService:JSONDecode(game:HttpGet("https://nanhhub.vercel.app/api/turn/" .. fn11()))
	end)

	if ok2 and result2 and type(result2.turn) == "number" then
		n = math.max(1, math.min(result2.turn, #account))
		return n
	end

	if n then
		return n
	end
	return 1
end

local function fn13(arg)
	if not request_2 then
		return
	end

	pcall(function()
		request_2({
			Url = "https://nanhhub.vercel.app/api/turn/" .. fn11(),
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = game.HttpService:JSONEncode({ turn = arg }),
		})
	end)
end

local function fn14()
	local v2 = fn12()
	return account[v2], v2
end

local function fn15()
	local n2 = #account
	local n3 = fn12() % n2 + 1
	fn13(n3)
	return account[n3], n3
end

local function fn16()
	if not isaccmain[game.Players.LocalPlayer.Name] then
		return false
	end
	local name2 = game.Players.LocalPlayer.Name
	return fn14() == name2
end

local function fn17(arg)
	local ok2, result2 = pcall(function()
		return game.HttpService:JSONDecode(game:HttpGet("https://nanhhub.vercel.app/api/mainaccount/" .. arg))
	end)

	if ok2 and result2 and result2.data then
		return result2.data
	end
	return nil
end

local function fn18(arg)
	if not isaccmain[game.Players.LocalPlayer.Name] then
		return
	end

	if not request_2 then
		return
	end

	pcall(function()
		request_2({
			Url = "https://nanhhub.vercel.app/api/mainaccount/" .. game.Players.LocalPlayer.Name,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = game.HttpService:JSONEncode({
				jobid = game.JobId,
				placeid = tostring(game.PlaceId),
				time = gettimeserver(),
				fullmoon = isfullmoon(),
				trialStatus = arg,
			}),
		})
	end)
end

local function fn19()
	if isaccmain[game.Players.LocalPlayer.Name] then
		return false
	end
	local v2 = gettimeserver()

	for _, v3 in ipairs(account) do
		local v4 = fn17(v3)

		if v4 then
			local jobid = v4.jobid
			local time = v4.time
			local fullmoon = v4.fullmoon
			local trialStatus = v4.trialStatus

			if jobid and time and v2 - time < 30 then
				if fullmoon and (trialStatus == "waiting_fullmoon" or trialStatus == "trialing") then
					if jobid == game.JobId then
						return true
					end
					status("Main đang trial có Full Moon! Joining: " .. v3)

					pcall(function()
						game.ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", jobid)
					end)

					return true
				end
			end
		end
	end

	return false
end

local function fn20()
	if not isaccmain[game.Players.LocalPlayer.Name] then
		return false
	end
	local followTurnHolder = fn14()
	if not followTurnHolder or followTurnHolder == game.Players.LocalPlayer.Name then
		return true
	end
	local v2 = fn17(followTurnHolder)
	if not v2 or not v2.jobid or not v2.time then
		return false
	end
	local time = v2.time
	if gettimeserver() - time >= 30 then
		return false
	end

	if v2.jobid == game.JobId then
		return true
	end

	if v2.fullmoon and (v2.trialStatus == "waiting_fullmoon" or v2.trialStatus == "trialing") then
		status("Follow turn holder: " .. followTurnHolder)

		pcall(function()
			game.ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", v2.jobid)
		end)
	end

	return false
end

local function fn21()
	if isaccmain[game.Players.LocalPlayer.Name] then
		return false
	end

	if #account == 0 then
		return false
	end
	local v2 = fn14()
	if not v2 then
		return false
	end
	local v3 = fn17(v2)
	if not v3 or not v3.jobid or not v3.time then
		return false
	end
	local time = v3.time
	if gettimeserver() - time >= 30 then
		return false
	end

	if v3.jobid == game.JobId then
		return true
	end
	status("Follow turn holder (ally): " .. v2)

	pcall(function()
		game.ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", v3.jobid)
	end)

	return true
end

local function fn22()
	if not isaccmain[game.Players.LocalPlayer.Name] then
		return
	end
	fn18("trial_done")
	status("Trial xong! Next: " .. (fn15() or "?") .. " | Hop training...")
	task.wait(2)
	Hop.A(8)
end

local n2 = 0
local v2 = nil
local n3 = 3
local n4 = 0
local n5 = 3

local function fn23()
	if tick() - n2 >= n3 then
		n2 = tick()
		v2 = fn14()
	end

	return v2
end

local function fn24()
	if not isaccmain[game.Players.LocalPlayer.Name] then
		return false
	end
	local name2 = game.Players.LocalPlayer.Name
	return fn23() == name2
end

local function fn25()
	if tick() - n4 >= n5 then
		n4 = tick()
		return true
	end
	return false
end

local function fn26()
	if not isaccmain[game.Players.LocalPlayer.Name] then
		return false
	end

	if #account <= 1 then
		return false
	end

	if not fn24() then
		return false
	end
	local n6 = tonumber((getgenv().Kurinian.Main or {}).Tier) or 6

	if n6 <= (game.Players.LocalPlayer.Data.Race.C.Value or 0) then
		fn18("trial_done")
		local v3 = fn15()
		v2 = v3
		n2 = tick()
		status("Done Tier " .. n6 .. " → Skip , Next: " .. (v3 or "?"))
		task.wait(2)
		Hop.A(8)
		return true
	end

	return false
end

local function fn27(arg)
	if not isaccmain[game.Players.LocalPlayer.Name] then
		return false
	end

	if #account <= 1 then
		return false
	end

	if arg then
		return false
	end

	if not fn24() then
		return false
	end
	local v3 = fn15()
	v2 = v3
	n2 = tick()
	status("Đến lượt nhưng còn đang Training → bỏ qua lượt, next: " .. (v3 or "?"))
	return true
end

Hop = {}
getgenv().FailedJobIds = {}
getgenv().LastApiRefresh = 0

local function fn28(arg)
	return "meyy_history_" .. tostring(arg) .. ".json"
end

local HttpService = game:GetService("HttpService")

local function fn29(arg)
	local v3 = fn28(arg)

	if isfile and isfile(v3) then
		local ok2, result2 = pcall(function()
			return HttpService:JSONDecode(readfile(v3))
		end)

		if ok2 and type(result2) == "table" then
			return result2
		end
	end

	return {}
end

local function fn30(arg, arg2)
	local v3 = fn28(arg)

	if writefile then
		pcall(function()
			writefile(v3, HttpService:JSONEncode(arg2))
		end)
	end
end

local flag = false

Hop.API = function(arg, arg2, arg3)
	arg2 = arg2 or 12
	arg3 = arg3 or 25
	local str = "https://dragonstoroautohopapi.up.railway.app/?key=" .. arg
	local n6 = math.floor(arg3 / 5)

	if n6 < 1 then
		n6 = 1
	end

	for i = 1, n6 do
		local v3 = fn29(arg)
		local tbl7 = {}

		for _, v4 in ipairs(v3) do
			tbl7[v4] = true
		end

		local ok2, result2 = pcall(function()
			local response = nil

			pcall(function()
				response = game:HttpGet(str)
			end)

			if not response then
				local v4 = (syn and syn.request or request or http.request)({ Url = str, Method = "GET" })

				if v4 then
					response = v4.Body
				end
			end

			if not response then
				return "ERROR"
			end
			local data = HttpService:JSONDecode(response)
			if typeof(data) ~= "table" then
				return "ERROR"
			end
			local servers = data.servers or data["Make By Dragons Toro"]

			if typeof(servers) ~= "table" then
				for _, v4 in pairs(data) do
					if type(v4) == "table" and v4[1] and type(v4[1]) == "table" and (v4[1].joinId or v4[1].jobId) then
						servers = v4
						break
					end
				end
			end

			if typeof(servers) ~= "table" then
				return "ERROR"
			end
			local tbl8 = {}
			local tbl9 = {}
			local tbl10 = {}

			for _, server in ipairs(servers) do
				local joinId = server.joinId or server.jobId or server.jobid or server.id
				local num = arg2
				local players

				if type(server.players) == "number" then
					players = server.players
				else
					players = 99

					if type(server.players) == "string" then
						local match, v4 = server.players:match("^%s*(%d+)%s*/%s*(%d+)%s*$")
						players = tonumber(match) or tonumber(server.players) or 99
						num = tonumber(v4) or num
					end
				end

				if joinId and not tbl8[joinId] then
					tbl8[joinId] = true
					table.insert(tbl10, joinId)
					table.insert(tbl9, { jobid = joinId, players = players, capacity = num, name = server.server })
				end
			end

			fn30(arg, tbl10)
			local tbl11 = {}
			local tbl12 = {}

			for _, v4 in ipairs(tbl9) do
				if v4.players > 2 and v4.players < arg2 and v4.players < v4.capacity then
					table.insert(tbl12, v4)

					if not tbl7[v4.jobid] then
						table.insert(tbl11, v4)
					end
				end
			end

			tbl11 = #tbl11 > 0 and tbl11 or tbl12
			if #tbl11 == 0 then
				return "NO_SERVER"
			end
			local n7 = 0

			for _, v4 in ipairs(tbl11) do
				if flag then
					return false
				end
				local jobid = v4.jobid
				if jobid == game.JobId then
					continue
				end

				if getgenv().FailedJobIds[jobid] then
					continue
				end
				n7 += 1

				if pcall(function()
					game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer("teleport", jobid)
				end) then
					game:GetService("TeleportService").TeleportInitFailed:Connect(function(arg4, arg5)
						if arg5 == Enum.TeleportResult.GameFull then
							print("Full nguoi")
							joinFailed = true
							local v5 = jobid
							getgenv().FailedJobIds[v5] = tick()
						end
					end)

					if not joinFailed then
						return true
					end
					continue
				end

				getgenv().FailedJobIds[jobid] = tick()
				task.wait(1)
			end

			return "FAILED_HOP"
		end)

		if ok2 and result2 == true then
			return true
		end

		if not ok2 or result2 == "NO_SERVER" or result2 == "FAILED_HOP" or result2 == "ERROR" then
			if i < n6 then
				task.wait(5)
			end
		end
	end

	return false
end

Hop.A = function(arg)
	local n6 = arg or 8
	local v3 = game

	for _, v4 in pairs(game:GetService("HttpService"):JSONDecode(v3:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
		if v4.playing < n6 and v4.id ~= game.JobId then
			game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer("teleport", v4.id)
			break
		end
	end
end

local function fn31(arg, arg2, arg3)
	Hop.API(arg, arg2, arg3)
end

checkgear = function()
	local ok2, result2 = pcall(function()
		return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TempleClock", "Check")
	end)

	if ok2 and result2 and type(result2) == "table" then
		if result2.HadPoint then
			local str = tostring((getgenv().Kurinian.Main or getgenv().Kurinian.Main or {}).Gear or "")

			if str == "" then
				str = "A-B-A"
			end

			local match, str2, str3 = str:match("^(.-)%-(.-)%-(.-)$")

			if not (match and str2 and str3) then
				str3 = "A"
				str2 = "B"
				match = "A"
			end

			local function fn32(arg)
				if not arg then
					return "Alpha"
				end
				local match2 = string.lower(tostring(arg)):match("^%s*(.-)%s*$") or ""
				if match2 == "đỏ" or match2 == "red" or match2 == "a" then
					return "Alpha"
				end

				if match2 == "xanh" or match2 == "blue" or match2 == "b" then
					return "Omega"
				end
				return "Alpha"
			end

			local tbl7 = { [2] = fn32(match), [3] = fn32(str2), [4] = fn32(str3) }
			local completed = result2.RaceDetails and result2.RaceDetails.Completed or 1
			local str4 = (completed == 1 or completed == 5) and "Blank" or tbl7[completed] or "Alpha"
			local a = result2.RaceDetails and result2.RaceDetails.A or 0
			local b = result2.RaceDetails and result2.RaceDetails.B or 0
			local str5 = "Gear" .. tostring(completed)

			if a >= 2 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TempleClock", "SpendPoint", str5, "Omega")
			elseif b >= 2 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TempleClock", "SpendPoint", str5, "Alpha")
			else
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TempleClock", "SpendPoint", str5, str4)
			end
		end
	end
end

CheckAlive = function(arg)
	return arg and arg.Parent and arg:FindFirstChild("Humanoid") and arg:FindFirstChild("HumanoidRootPart") and arg:FindFirstChild("Humanoid").Health > 0
end

GetMobPosition = function(arg)
	local vector = Vector3.zero
	local n6 = 0

	for _, child in pairs(workspace.Enemies:GetChildren()) do
		if child.Name == arg and child:FindFirstChild("HumanoidRootPart") then
			vector += child.HumanoidRootPart.Position
			n6 += 1
		end
	end

	if n6 > 0 then
		return vector / n6
	end
	return nil
end

BringMob = function(arg)
	if arg then
		local children = game.Workspace.Enemies:GetChildren()

		if #children > 0 then
			local tbl7 = {}

			for _, child in pairs(children) do
				if not tbl7[child.Name] then
					tbl7[child.Name] = GetMobPosition(child.Name)
				end
			end

			for _, child in pairs(workspace.Enemies:GetChildren()) do
				if child.Name == arg.Name and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart") then
					if not (child.Humanoid.MaxHealth > 50000) then
						if (child.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 350 then
							for k, v3 in pairs(tbl7) do
								k = k and child.Name == k and v3

								if k then
									Gay = CFrame.new(v3.X, v3.Y, v3.Z)
									Cac = (child.HumanoidRootPart.Position - Gay.Position).Magnitude

									if Cac > 3 and Cac <= 280 then
										tbl3:topos(child.HumanoidRootPart)
										child.HumanoidRootPart.CanCollide = false
										child.Humanoid.WalkSpeed = 0
										child.Humanoid.JumpPower = 0
										child.Humanoid:ChangeState(14)
										sethiddenproperty(localPlayer, "SimulationRadius", math.huge)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

Kill = function(arg, arg2)
	pcall(function()
		if setsimulationradius then
			setsimulationradius(50000)
		end

		sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 5000)
	end)

	local flag2 = not arg
	if flag2 or typeof(arg) ~= "Instance" or not CheckAlive(arg) then
		return
	end
	local name2 = arg.Name

	local function fn32()
		local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return 0
		end
		local n6 = 0

		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child.Name == name2 and child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") and (child.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude <= 100 then
				n6 += child.Humanoid.Health
			end
		end

		return n6
	end

	local v3 = fn32()
	local now2 = os.clock()
	if flag2 or not CheckAlive(arg) then
		return
	end
	local exitTo = nil
	local flag3, v4, humanoidRootPart, flag4, bodyVelocity, flag5, v5

	while true do
		flag3 = arg2 and not arg2()

		if flag3 then
			exitTo = 1
			break
		elseif not CheckAlive(arg) then
			exitTo = 1
			break
		else
			task.wait()
			BringMob(arg)
			v4 = fn32()

			if v4 < v3 then
				exitTo = 2
				break
			elseif not (v3 < v4) then
				if os.clock() - now2 >= 15 then
					exitTo = 1
					break
				else
					humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

					if flag4 then
						bodyVelocity = Instance.new("BodyVelocity")
						bodyVelocity.Name = "KillFloat"
						bodyVelocity.Parent = humanoidRootPart
						bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
						bodyVelocity.Velocity = Vector3.zero
					end

					tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
					flag5 = not arg or not arg.Parent or not CheckAlive(arg)

					if not flag5 then
						v5 = arg2 and arg2()
						flag5 = not v5
					end

					if flag5 then
						exitTo = 1
						break
					else
						continue
					end
				end
			end
		end

		break
	end

	local humanoidRootPart2

	if exitTo == 1 then
		humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

		if humanoidRootPart2:FindFirstChild("BodyClip") then
			localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
		end

		return
	end

	local exitTo4, exitTo5, exitTo6, exitTo2, exitTo3

	if exitTo == 2 then
		now2 = os.clock()
		v3 = v4
		exitTo4 = nil

		while true do
			humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
			flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

			if flag4 then
				bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.Name = "KillFloat"
				bodyVelocity.Parent = humanoidRootPart
				bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
				bodyVelocity.Velocity = Vector3.zero
			end

			tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
			flag5 = not arg or not arg.Parent or not CheckAlive(arg)

			if not flag5 then
				v5 = arg2 and arg2()
				flag5 = not v5
			end

			if flag5 then
				exitTo4 = 1
				break
			else
				exitTo5 = nil

				while true do
					flag3 = arg2 and not arg2()

					if flag3 then
						exitTo5 = 1
						break
					elseif not CheckAlive(arg) then
						exitTo5 = 1
						break
					else
						task.wait()
						BringMob(arg)
						v4 = fn32()

						if v4 < v3 then
							exitTo5 = 2
							break
						elseif not (v3 < v4) then
							if os.clock() - now2 >= 15 then
								exitTo5 = 1
								break
							else
								humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
								flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

								if flag4 then
									bodyVelocity = Instance.new("BodyVelocity")
									bodyVelocity.Name = "KillFloat"
									bodyVelocity.Parent = humanoidRootPart
									bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
									bodyVelocity.Velocity = Vector3.zero
								end

								tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
								flag5 = not arg or not arg.Parent or not CheckAlive(arg)

								if not flag5 then
									v5 = arg2 and arg2()
									flag5 = not v5
								end

								if flag5 then
									exitTo5 = 1
									break
								else
									continue
								end
							end
						end
					end

					break
				end

				if exitTo5 == 1 then
					exitTo4 = 2
					break
				elseif exitTo5 == 2 then
					now2 = os.clock()
					v3 = v4
					continue
				end
			end

			break
		end

		if exitTo4 == 1 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end

		if exitTo4 == 2 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end

		v3 = v4
		exitTo6 = nil

		while true do
			exitTo2 = nil

			while true do
				humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

				if flag4 then
					bodyVelocity = Instance.new("BodyVelocity")
					bodyVelocity.Name = "KillFloat"
					bodyVelocity.Parent = humanoidRootPart
					bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
					bodyVelocity.Velocity = Vector3.zero
				end

				tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
				flag5 = not arg or not arg.Parent or not CheckAlive(arg)

				if not flag5 then
					v5 = arg2 and arg2()
					flag5 = not v5
				end

				if flag5 then
					exitTo2 = 1
					break
				else
					exitTo3 = nil

					while true do
						flag3 = arg2 and not arg2()

						if flag3 then
							exitTo3 = 1
							break
						elseif not CheckAlive(arg) then
							exitTo3 = 1
							break
						else
							task.wait()
							BringMob(arg)
							v4 = fn32()

							if not (v4 < v3) then
								if v3 < v4 then
									exitTo3 = 2
									break
								elseif os.clock() - now2 >= 15 then
									exitTo3 = 1
									break
								else
									humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
									flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

									if flag4 then
										bodyVelocity = Instance.new("BodyVelocity")
										bodyVelocity.Name = "KillFloat"
										bodyVelocity.Parent = humanoidRootPart
										bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
										bodyVelocity.Velocity = Vector3.zero
									end

									tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
									flag5 = not arg or not arg.Parent or not CheckAlive(arg)

									if not flag5 then
										v5 = arg2 and arg2()
										flag5 = not v5
									end

									if flag5 then
										exitTo3 = 1
										break
									else
										continue
									end
								end
							end
						end

						break
					end

					if exitTo3 == 1 then
						exitTo2 = 2
						break
					elseif exitTo3 == 2 then
						v3 = v4
						continue
					end
				end

				break
			end

			if exitTo2 == 1 then
				exitTo6 = 1
				break
			elseif exitTo2 == 2 then
				exitTo6 = 2
				break
			else
				now2 = os.clock()
				v3 = v4
				exitTo4 = nil

				while true do
					humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

					if flag4 then
						bodyVelocity = Instance.new("BodyVelocity")
						bodyVelocity.Name = "KillFloat"
						bodyVelocity.Parent = humanoidRootPart
						bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
						bodyVelocity.Velocity = Vector3.zero
					end

					tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
					flag5 = not arg or not arg.Parent or not CheckAlive(arg)

					if not flag5 then
						v5 = arg2 and arg2()
						flag5 = not v5
					end

					if flag5 then
						exitTo4 = 1
						break
					else
						exitTo5 = nil

						while true do
							flag3 = arg2 and not arg2()

							if flag3 then
								exitTo5 = 1
								break
							elseif not CheckAlive(arg) then
								exitTo5 = 1
								break
							else
								task.wait()
								BringMob(arg)
								v4 = fn32()

								if v4 < v3 then
									exitTo5 = 2
									break
								elseif not (v3 < v4) then
									if os.clock() - now2 >= 15 then
										exitTo5 = 1
										break
									else
										humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
										flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

										if flag4 then
											bodyVelocity = Instance.new("BodyVelocity")
											bodyVelocity.Name = "KillFloat"
											bodyVelocity.Parent = humanoidRootPart
											bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
											bodyVelocity.Velocity = Vector3.zero
										end

										tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
										flag5 = not arg or not arg.Parent or not CheckAlive(arg)

										if not flag5 then
											v5 = arg2 and arg2()
											flag5 = not v5
										end

										if flag5 then
											exitTo5 = 1
											break
										else
											continue
										end
									end
								end
							end

							break
						end

						if exitTo5 == 1 then
							exitTo4 = 2
							break
						elseif exitTo5 == 2 then
							now2 = os.clock()
							v3 = v4
							continue
						end
					end

					break
				end

				if exitTo4 == 1 then
					exitTo6 = 3
					break
				elseif exitTo4 ~= 2 then
					v3 = v4
					continue
				end
			end

			break
		end

		if exitTo6 == 1 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end

		if exitTo6 == 2 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end

		if exitTo6 ~= 3 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end
	else
		v3 = v4
		exitTo2 = nil

		while true do
			humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
			flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

			if flag4 then
				bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.Name = "KillFloat"
				bodyVelocity.Parent = humanoidRootPart
				bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
				bodyVelocity.Velocity = Vector3.zero
			end

			tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
			flag5 = not arg or not arg.Parent or not CheckAlive(arg)

			if not flag5 then
				v5 = arg2 and arg2()
				flag5 = not v5
			end

			if flag5 then
				exitTo2 = 1
				break
			else
				exitTo3 = nil

				while true do
					flag3 = arg2 and not arg2()

					if flag3 then
						exitTo3 = 1
						break
					elseif not CheckAlive(arg) then
						exitTo3 = 1
						break
					else
						task.wait()
						BringMob(arg)
						v4 = fn32()

						if not (v4 < v3) then
							if v3 < v4 then
								exitTo3 = 2
								break
							elseif os.clock() - now2 >= 15 then
								exitTo3 = 1
								break
							else
								humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
								flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

								if flag4 then
									bodyVelocity = Instance.new("BodyVelocity")
									bodyVelocity.Name = "KillFloat"
									bodyVelocity.Parent = humanoidRootPart
									bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
									bodyVelocity.Velocity = Vector3.zero
								end

								tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
								flag5 = not arg or not arg.Parent or not CheckAlive(arg)

								if not flag5 then
									v5 = arg2 and arg2()
									flag5 = not v5
								end

								if flag5 then
									exitTo3 = 1
									break
								else
									continue
								end
							end
						end
					end

					break
				end

				if exitTo3 == 1 then
					exitTo2 = 2
					break
				elseif exitTo3 == 2 then
					v3 = v4
					continue
				end
			end

			break
		end

		if exitTo2 == 1 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end

		if exitTo2 == 2 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end

		now2 = os.clock()
		v3 = v4
		exitTo4 = nil

		while true do
			humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
			flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

			if flag4 then
				bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.Name = "KillFloat"
				bodyVelocity.Parent = humanoidRootPart
				bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
				bodyVelocity.Velocity = Vector3.zero
			end

			tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
			flag5 = not arg or not arg.Parent or not CheckAlive(arg)

			if not flag5 then
				v5 = arg2 and arg2()
				flag5 = not v5
			end

			if flag5 then
				exitTo4 = 1
				break
			else
				exitTo5 = nil

				while true do
					flag3 = arg2 and not arg2()

					if flag3 then
						exitTo5 = 1
						break
					elseif not CheckAlive(arg) then
						exitTo5 = 1
						break
					else
						task.wait()
						BringMob(arg)
						v4 = fn32()

						if v4 < v3 then
							exitTo5 = 2
							break
						elseif not (v3 < v4) then
							if os.clock() - now2 >= 15 then
								exitTo5 = 1
								break
							else
								humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
								flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

								if flag4 then
									bodyVelocity = Instance.new("BodyVelocity")
									bodyVelocity.Name = "KillFloat"
									bodyVelocity.Parent = humanoidRootPart
									bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
									bodyVelocity.Velocity = Vector3.zero
								end

								tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
								flag5 = not arg or not arg.Parent or not CheckAlive(arg)

								if not flag5 then
									v5 = arg2 and arg2()
									flag5 = not v5
								end

								if flag5 then
									exitTo5 = 1
									break
								else
									continue
								end
							end
						end
					end

					break
				end

				if exitTo5 == 1 then
					exitTo4 = 2
					break
				elseif exitTo5 == 2 then
					now2 = os.clock()
					v3 = v4
					continue
				end
			end

			break
		end

		if exitTo4 == 1 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end

		if exitTo4 == 2 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end

		v3 = v4
		exitTo6 = nil

		while true do
			exitTo2 = nil

			while true do
				humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

				if flag4 then
					bodyVelocity = Instance.new("BodyVelocity")
					bodyVelocity.Name = "KillFloat"
					bodyVelocity.Parent = humanoidRootPart
					bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
					bodyVelocity.Velocity = Vector3.zero
				end

				tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
				flag5 = not arg or not arg.Parent or not CheckAlive(arg)

				if not flag5 then
					v5 = arg2 and arg2()
					flag5 = not v5
				end

				if flag5 then
					exitTo2 = 1
					break
				else
					exitTo3 = nil

					while true do
						flag3 = arg2 and not arg2()

						if flag3 then
							exitTo3 = 1
							break
						elseif not CheckAlive(arg) then
							exitTo3 = 1
							break
						else
							task.wait()
							BringMob(arg)
							v4 = fn32()

							if not (v4 < v3) then
								if v3 < v4 then
									exitTo3 = 2
									break
								elseif os.clock() - now2 >= 15 then
									exitTo3 = 1
									break
								else
									humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
									flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

									if flag4 then
										bodyVelocity = Instance.new("BodyVelocity")
										bodyVelocity.Name = "KillFloat"
										bodyVelocity.Parent = humanoidRootPart
										bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
										bodyVelocity.Velocity = Vector3.zero
									end

									tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
									flag5 = not arg or not arg.Parent or not CheckAlive(arg)

									if not flag5 then
										v5 = arg2 and arg2()
										flag5 = not v5
									end

									if flag5 then
										exitTo3 = 1
										break
									else
										continue
									end
								end
							end
						end

						break
					end

					if exitTo3 == 1 then
						exitTo2 = 2
						break
					elseif exitTo3 == 2 then
						v3 = v4
						continue
					end
				end

				break
			end

			if exitTo2 == 1 then
				exitTo6 = 1
				break
			elseif exitTo2 == 2 then
				exitTo6 = 2
				break
			else
				now2 = os.clock()
				v3 = v4
				exitTo4 = nil

				while true do
					humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

					if flag4 then
						bodyVelocity = Instance.new("BodyVelocity")
						bodyVelocity.Name = "KillFloat"
						bodyVelocity.Parent = humanoidRootPart
						bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
						bodyVelocity.Velocity = Vector3.zero
					end

					tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
					flag5 = not arg or not arg.Parent or not CheckAlive(arg)

					if not flag5 then
						v5 = arg2 and arg2()
						flag5 = not v5
					end

					if flag5 then
						exitTo4 = 1
						break
					else
						exitTo5 = nil

						while true do
							flag3 = arg2 and not arg2()

							if flag3 then
								exitTo5 = 1
								break
							elseif not CheckAlive(arg) then
								exitTo5 = 1
								break
							else
								task.wait()
								BringMob(arg)
								v4 = fn32()

								if v4 < v3 then
									exitTo5 = 2
									break
								elseif not (v3 < v4) then
									if os.clock() - now2 >= 15 then
										exitTo5 = 1
										break
									else
										humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
										flag4 = humanoidRootPart and not humanoidRootPart:FindFirstChild("KillFloat")

										if flag4 then
											bodyVelocity = Instance.new("BodyVelocity")
											bodyVelocity.Name = "KillFloat"
											bodyVelocity.Parent = humanoidRootPart
											bodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
											bodyVelocity.Velocity = Vector3.zero
										end

										tbl3:topos(arg:GetPivot() * CFrame.new(0, 20, 0))
										flag5 = not arg or not arg.Parent or not CheckAlive(arg)

										if not flag5 then
											v5 = arg2 and arg2()
											flag5 = not v5
										end

										if flag5 then
											exitTo5 = 1
											break
										else
											continue
										end
									end
								end
							end

							break
						end

						if exitTo5 == 1 then
							exitTo4 = 2
							break
						elseif exitTo5 == 2 then
							now2 = os.clock()
							v3 = v4
							continue
						end
					end

					break
				end

				if exitTo4 == 1 then
					exitTo6 = 3
					break
				elseif exitTo4 ~= 2 then
					v3 = v4
					continue
				end
			end

			break
		end

		if exitTo6 == 1 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end

		if exitTo6 == 2 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end

		if exitTo6 ~= 3 then
			humanoidRootPart2 = localPlayer.Character.HumanoidRootPart

			if humanoidRootPart2:FindFirstChild("BodyClip") then
				localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
			end

			return
		end
	end

	if localPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
		localPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
	end
end

_G.ShouldSendData = false

if not getgenv()._mainStatusLoopStarted then
	getgenv()._mainStatusLoopStarted = true

	spawn(function()
		while wait(1) do
			if isaccmain[game.Players.LocalPlayer.Name] then
				local str

				if fn16() then
					str = isfullmoon() and "trialing" or "waiting_fullmoon"
				else
					str = "training"
				end

				fn18(str)
			end
		end
	end)
end

local function fn32(arg)
	if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return false
	end
	alovuoivuoi = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if (player.Character.HumanoidRootPart.Position - alovuoivuoi).Magnitude <= arg then
				return true
			end
		end
	end

	return false
end

spawn(function()
	local v3

	while wait() do
		tuatoioi = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CheckTempleDoor")
		if not tuatoioi then
			status("Lever chưa pull , tự pull ")
			continue
		end
		_G.ShouldSendData = false
		if fn26() then
			continue
		end
		local v4, v5 = trialable()
		fn27(v4)
		local flag2 = tbl2[game.Players.LocalPlayer.Name] == true
		local flag3 = isnight() and isfullmoon() or false

		if flag2 and not flag3 then
			status("Follow main (Acc Help)")

			if fn25() then
				if not fn21() then
					if not fn19() then
						followMainAccount()
					end
				end
			end

			continue
		end

		if not v4 and not flag2 then
			status("Training")
			if v5 == "raiding" then
				status("Tự Farm Frag Đi Free Đừng đòi hỏi")
				continue
			end

			if v5 == "buyfrag" then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
				return
			end

			pcall(function()
				if game.Players.LocalPlayer.Character.RaceEnergy.Value == 1 then
					game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
					game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
				end
			end)

			local tbl7 = {
				Bone = {
					pos = CFrame.new(-9504.8564453125, 172.14292907714844, 6057.259765625),
					mob = { "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy" },
				},
				Kata = {
					pos = CFrame.new(214.688675, 126.626984, -12600.2236),
					mob = { "Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker" },
				},
				Tiki = {
					pos = CFrame.new(-16759.58984375, 71.283767700195312, 1595.3399658203125),
					mob = { "Serpent Hunter", "Kissed Warrior", "Skull Slayer", "Isle Champion" },
				},
			}

			local training = (getgenv().Kurinian.Main or {}).Training
			training = training and tbl7[training]

			if not training then
				status("Training: getgenv().Kurinian 'Training' sai (Bone/Kata/Tiki) -> tạm dùng Bone")
				training = tbl7.Bone
			end

			local pos = training.pos
			local mob = training.mob

			if getdis(pos) < 500 then
				local v6 = getmob1(mob)

				for _, v7 in pairs(v6) do
					if checkmob_(v7) then
						if fn32(500) then
							Hop.A(7)
						end

						while true do
							wait()
							tbl3:eq()
							tbl3:haki()

							pcall(function()
								local humanoidRootPart = v7:FindFirstChild("HumanoidRootPart")
								if not humanoidRootPart then
									return
								end
								status("Training (Kill Mobs)")
								tbl3:topos(humanoidRootPart.CFrame * CFrame.new(0, 20, 0))
							end)

							spawn(function()
								pcall(function()
									if game.Players.LocalPlayer.Character.RaceEnergy.Value == 1 then
										game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
										game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
									end
								end)
							end)

							if not (not v7 or not v7.Parent or not v7:FindFirstChild("Humanoid") or v7.Humanoid.Health <= 0) then
								continue
							end
							break
						end
					end
				end
			else
				tbl3:tpbypass(pos)
			end

			continue
		end

		if isnight() and isfullmoon() then
			local v6 = fn24()

			if isaccmain[game.Players.LocalPlayer.Name] then
				if not v6 then
					if fn25() then
						if not fn20() then
							n2 = 0
							v2 = nil
						end
					end
				end
			elseif fn25() then
				if not fn19() then
					followMainAccount()
				end
			end

			if not (isaccmain[game.Players.LocalPlayer.Name] and not v6) then
				local method = (getgenv().Kurinian.Main or {}).Method or ""

				if isaccmain[game.Players.LocalPlayer.Name] and method == 1 and not isfullmoon() then
					fn31("Fullmoon", 12, 2)
				end

				spawn(checkgear)
				_G.ShouldSendData = true

				if not workspace.Map:FindFirstChild("Temple of Time") then
					if game:GetService("ReplicatedStorage").MapStash:FindFirstChild("Temple of Time") then
						local map = workspace.Map
						game:GetService("ReplicatedStorage").MapStash:FindFirstChild("Temple of Time").Parent = map
					end
				elseif workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 0 then
					status("Kill Players After Trial")

					if _G.MeyyDidTrial then
						fn7(game.Players.LocalPlayer.Data.Race.C.Value or 0)
						_G.MeyyDidTrial = false
					end

					for k in pairs(getplayers()) do
						if k then
							while true do
								wait()

								pcall(function()
									local topos = tbl3.topos
									local v7 = tbl3
									local cFrame = k.HumanoidRootPart.CFrame
									local cframe9 = CFrame.new

									local function fn33()
										local n6 = math.random(1, 4)
										local n7 = math.random(1, 4)

										if math.random(1, 2) == 1 then
											n6 *= -1
										end

										if math.random(1, 2) == 1 then
											n7 *= -1
										end

										return n6, 3, n7
									end

									local v8, v9, v10 = fn33()
									topos(v7, cFrame * cframe9(v8, v9, v10))
								end)

								if not (not k or not k.Parent or not k:FindFirstChild("Humanoid") or not k:FindFirstChild("HumanoidRootPart") or k.Humanoid.Health <= 0 or workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 1) then
									continue
								end
								break
							end
						end
					end

					if next(getplayers()) == nil then
						local reset = getgenv().Kurinian.Help.Reset

						if not isaccmain[game.Players.LocalPlayer.Name] and reset then
							game.Players.LocalPlayer.Character.Humanoid.Health = 0
						end

						if not isaccmain[game.Players.LocalPlayer.Name] then
							status("Next Main Account")
							task.wait(5)

							if not fn21() then
								if not fn19() then
									followMainAccount()
								end
							end
						end

						if isaccmain[game.Players.LocalPlayer.Name] then
							tier2 = game.Players.LocalPlayer.Data.Race.C.Value

							if tier1 < tier2 then
								fn22()
							end
						end
					end
				else
					local v7 = nil

					if tbl6[game:GetService("Players").LocalPlayer.Data.Race.Value] then
						v7 = tbl6[game:GetService("Players").LocalPlayer.Data.Race.Value]
					end

					if v7 and getdis(v7.CFrame) < 1500 then
						status("Doing trial")
						_G.MeyyDidTrial = true
						local value = game.Players.LocalPlayer.Data.Race.Value

						if value == "Mink" then
							pcall(function()
								tbl3:topos(workspace.Map.MinkTrial.Ceiling.CFrame * CFrame.new(0, -13, 0))
							end)
						elseif value == "Skypiea" then
							pcall(function()
								tbl3:topos(workspace.Map.SkyTrial.Model.FinishPart.CFrame)
							end)
						elseif value == "Cyborg" then
							pcall(function()
								tbl3:topos(workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0, 500, 0))
							end)
						elseif value == "Human" or value == "Ghoul" then
							for _, child in pairs(game.Workspace.Enemies:GetChildren()) do
								if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 then
									if getdis(child.HumanoidRootPart.CFrame, v7.CFrame) < 1500 then
										while true do
											wait()
											tbl3:eq()
											tbl3:haki()

											pcall(function()
												tbl3:topos(child:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 30, 0))
											end)

											if not (not child or not child:FindFirstChild("HumanoidRootPart") or not child:FindFirstChild("Humanoid") or child.Humanoid.Health <= 0) then
												continue
											end
											break
										end
									end
								end
							end
						elseif value == "Fishman" then
							for _, child in pairs(workspace.SeaBeasts:GetChildren()) do
								pcall(function()
									if child:FindFirstChild("Health") and child.Health.Value > 0 and child:FindFirstChild("HumanoidRootPart") and getdis(child.HumanoidRootPart.CFrame, v7) < 1500 then
										while true do
											wait()
											tbl3:topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0))
											_G.SHOULDSPAMSKILLS = true
											if not (not child or not child:FindFirstChild("Health") or child.Health.Value <= 0 or not child:FindFirstChild("HumanoidRootPart")) then
												continue
											end
											break
										end

										_G.SHOULDSPAMSKILLS = false
									end
								end)
							end
						end
					elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Timer.Visible == false then
						if isaccmain[game.Players.LocalPlayer.Name] then
							if game.Players.LocalPlayer.Data.Race.C.Value == getgenv().Kurinian.Main.Tier and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getRaceLevel") == 4 then
								status("Done Tier")
							end
						end

						repeat
							wait()
							v3 = getdoor()
						until v3 ~= nil

						local v8 = getdis(v3.CFrame)
						status("Ready for trialing")

						if v8 < 3000 then
							local flag4, v9, v10 = fn4()

							if isaccmain[game.Players.LocalPlayer.Name] and not flag4 then
								if not _G.MeyyWaitAllyStart then
									_G.MeyyWaitAllyStart = tick()
								end

								local meyyWaitAllyStart = _G.MeyyWaitAllyStart

								if tick() - meyyWaitAllyStart > 45 then
									flag4 = true
								else
									status("Wait Acc Help ... (" .. v9 .. "/" .. v10 .. ")")
								end
							end

							if not (isaccmain[game.Players.LocalPlayer.Name] and not flag4) then
								_G.MeyyWaitAllyStart = nil
								tbl3:topos(v3.CFrame)

								if isaccmain[game.Players.LocalPlayer.Name] then
									pcall(function()
										game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
										status("Ennable V3")
									end)
								elseif isshouldturnonability() then
									game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
								end
							end
						else
							gotoTemple()
						end
					end
				end
			end
		elseif not isaccmain[game.Players.LocalPlayer.Name] then
			if fn25() then
				if not fn19() then
					status("Follow main")
					followMainAccount()
				end
			end
		elseif fn24() then
			status("Waiting Full Moon...")

			if ((getgenv().Kurinian.Main or {}).Method or "") == 1 then
				fn31("Fullmoon", 12, 2)
			end
		else
			status("Training | Follow")

			if fn25() then
				fn20()
			end
		end
	end
end)

local tbl7 = {
	["Buddha-Buddha"] = true,
	["T-Rex-T-Rex"] = true,
	["Dragon-Dragon"] = true,
	["Yeti-Yeti"] = true,
	["Leopard-Leopard"] = true,
	["Venom-Venom"] = true,
	["Phoenix-Phoenix"] = true,
	["Kitsune-Kitsune"] = true,
	["Mammoth-Mammoth"] = true,
	["Gas-Gas"] = true,
	["Portal-Portal"] = true,
}

local tbl8 = { Melee = true, ["Blox Fruit"] = true, Sword = true, Gun = true }
local tbl9 = { Z = true, X = true, C = true, V = true, F = true }

getallweapon = function()
	local tbl10 = {}

	for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		if child:IsA("Tool") and tbl8[child.ToolTip] then
			table.insert(tbl10, child)
		end
	end

	for _, child in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if child:IsA("Tool") and tbl8[child.ToolTip] then
			table.insert(tbl10, child)
		end
	end

	return tbl10
end

EquipTool = function(arg)
	local v3 = game.Players.LocalPlayer.Backpack:FindFirstChild(arg)

	if v3 then
		game.Players.LocalPlayer.Character.Humanoid:EquipTool(v3)
	end
end

spawn(function()
	while wait() do
		if _G.SHOULDSPAMSKILLS then
			local v3 = getallweapon()

			for _, v4 in pairs(v3) do
				if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills:FindFirstChild(v4.Name) then
					EquipTool(v4.Name)
				end
			end

			for _, v4 in pairs(v3) do
				if v4.Parent ~= game.Players.LocalPlayer.Character then
					EquipTool(v4.Name)
				end

				local v5 = game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills:FindFirstChild(v4.Name)

				if v5 then
					for _, child in pairs(v5:GetChildren()) do
						if tbl9[child.Name] then
							local cooldown = child:WaitForChild("Cooldown")
							local title = child:WaitForChild("Title")

							if title.TextColor3 == Color3.new(1, 1, 1) or title.TextColor3 == Color3.fromRGB(255, 255, 255) then
								if cooldown.Size == UDim2.new(0, 0, 1, -1) then
									if child.Name == "V" then
										if not tbl7[v5.Name] then
											game:service("VirtualInputManager"):SendKeyEvent(true, "V", false, game)
											wait(0.1)
											game:service("VirtualInputManager"):SendKeyEvent(false, "V", false, game)
											wait(1.5)
										end
									else
										game:service("VirtualInputManager"):SendKeyEvent(true, child.Name, false, game)
										wait(0.1)
										game:service("VirtualInputManager"):SendKeyEvent(false, child.Name, false, game)
										wait(1.5)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

pcall(function()
	local response = game:HttpGet("https://pastefy.app/X6xLHpIv/raw?part=attack.lua")

	if response then
		loadstring(response)()
	end
end)

CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)
CameraShakerR:Stop()

spawn(function()
	while wait() do
		tbl3:haki()
	end
end)

dropdown = function(arg, arg2)
	local ok2, result2 = pcall(function()
		return game.HttpService:JSONDecode(readfile("meyyhub/kaitunv4.json"))
	end)

	if not ok2 then
		result2 = {}

		if not isfolder("meyyhub") then
			makefolder("meyyhub")
		end

		writefile("meyyhub/kaitunv4.json", "{}")
	end

	if result2[arg2.Title] then
		arg2.Value = result2[arg2.Title] or ""
	end

	local callback = arg2.Callback

	arg2.Callback = function(arg3)
		callback(arg3)

		local ok3, result3 = pcall(function()
			return game.HttpService:JSONDecode(readfile("meyyhub/kaitunv4.json"))
		end)

		if not ok3 then
			result3 = {}

			if not isfolder("meyyhub") then
				makefolder("meyyhub")
			end

			writefile("meyyhub/kaitunv4.json", "{}")
		end

		result3[arg2.Title] = arg3
		writefile("meyyhub/kaitunv4.json", game.HttpService:JSONEncode(result3))
	end

	return (arg:Dropdown(arg2))
end

spawn(function()
	while wait(0.25) do
		pcall(function()
			local data = game.Players.LocalPlayer.Data
			tbl:Set("player", game.Players.LocalPlayer.Name)
			tbl:Set("race", tostring(data.Race.Value))
			tbl:Set("tier", "V4 Tier " .. tostring(data.Race.C.Value or 0))

			local function fn33()
				local startedAt = tbl.StartedAt
				local n6 = math.floor(os.clock() - startedAt)
				return string.format("%02dh %02dm %02ds", math.floor(n6 / 3600), math.floor(n6 % 3600 / 60), n6 % 60)
			end

			tbl:Set("runtime", fn33())
		end)

		if _G.statusnow then
			tbl:SetStatus(_G.statusnow)
		end
	end
end)
