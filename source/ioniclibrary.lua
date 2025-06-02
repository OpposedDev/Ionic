playerService = game:GetService("Players")
runService = game:GetService("RunService")
tweenService = game:GetService("TweenService")
userInputService = game:GetService("UserInputService")

connectionTypes = {
	Heartbeat = runService.Heartbeat,
	RenderStepped = runService.RenderStepped,
	Stepped = runService.Stepped,
	PreRender = runService.PreRender,
	PreSimulation = runService.PreSimulation,
	PreAnimation = runService.PreAnimation,
	PostSimulation = runService.PostSimulation
}

function changeBrightness(color, multiplier)
	local h, s, v = color:ToHSV()
	return Color3.fromHSV(h, s, v*multiplier)
end

function formatFloat(number: number): string
	local formatted = string.format("%.3f", number) --> omit to three decimals
	formatted = formatted:gsub("%.?0+$", "") --> remove the dot and trailing zeroes
	return formatted
end

createUiCorner = function(parent: Instance, radius: number)
	local uiCorner = Instance.new("UICorner", parent)
	uiCorner.CornerRadius = UDim.new(0, radius)
end

createUiListLayout = function(parent: Instance, direction: Enum.FillDirection)
	local uiListLayout = Instance.new("UIListLayout", parent)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0,5)
	if direction then
		uiListLayout.FillDirection = direction
	end
end

createUiPadding = function(parent: Instance, left: number, right: number, up: number, down: number)
	local uiPadding = Instance.new("UIPadding", parent)
	uiPadding.PaddingLeft = UDim.new(0, left)
	uiPadding.PaddingRight = UDim.new(0, right)
	uiPadding.PaddingTop = UDim.new(0, up)
	uiPadding.PaddingBottom = UDim.new(0, down)
end

smoothTween = TweenInfo.new(
	0.4,
	Enum.EasingStyle.Quart,
	Enum.EasingDirection.Out,
	0,
	false,
	0
)

triggerTween = function(instance: Instance, properties: Instance)
	local tween = tweenService:Create(instance, smoothTween, properties)
	tween:Play()
end

local library = {
	defaultColors = {
		backgroundPrimary = Color3.new(0.2,0.2,0.2),
		backgroundSecondary = Color3.new(0.25,0.25,0.25),
		textPrimary = Color3.new(1,1,1),
		textSecondary = Color3.new(0.7,0.7,0.7),
		enabled = Color3.new(0,0.5,1),
		disabled = Color3.new(0.1,0.1,0.1),
		buttonPrimary = Color3.new(0.25,0.25,0.25),
		buttonSecondary = Color3.new(0.2,0.2,0.2),
	},
	
	main = nil,
	
	libver = "6/1/2025-stable",
	
	window = {},
	
	pushNotification = function(self, properties)
		
	end,
	
	createWindow = function(self, properties)
		local name: string = properties.Title
		local version: string = properties.Version
		local theme = properties.Theme or self.defaultColors
		
		-- theme validation
		local backgroundPrimary: Color3 = theme.backgroundPrimary or self.defaultColors.backgroundPrimary
		local backgroundSecondary: Color3 = theme.backgroundSecondary or self.defaultColors.backgroundSecondary
		local enabled: Color3 = theme.enabled or self.defaultColors.enabled
		local disabled: Color3 = theme.disabled or self.defaultColors.disabled
		local textPrimary: Color3 = theme.textPrimary or self.defaultColors.textPrimary
		local textSecondary: Color3 = theme.textSecondary or self.defaultColors.textSecondary
		local buttonPrimary: Color3 = theme.buttonPrimary or self.defaultColors.buttonPrimary
		local buttonSecondary: Color3 = theme.buttonSecondary or self.defaultColors.buttonSecondary
		
		self.main = Instance.new("ScreenGui", playerService.LocalPlayer.PlayerGui)
		self.main.IgnoreGuiInset = true
		self.main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		
		local window = Instance.new("Frame", self.main)
		window.Name = "window"
		
		window.AnchorPoint = Vector2.new(0.5,0.5)
		window.Position = UDim2.new(0.5,0,0.5,0)
		
		window.Size = UDim2.new(0,512,0,640)
		
		window.BackgroundColor3 = backgroundPrimary
		
		window.ZIndex = 0
		
		local title = Instance.new("TextLabel", window)
		title.Name = "title"
		
		title.AnchorPoint = Vector2.new(0.5,0.5)
		title.Position = UDim2.new(0.5,0,0,17)
		
		title.Size = UDim2.new(0,502,0,24)
		
		title.BackgroundColor3 = backgroundSecondary
		
		title.Text = " "..name
		title.TextColor3 = textPrimary
		title.TextSize = 16
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Font = Enum.Font.Code
		
		local versiontext = Instance.new("TextLabel", window)
		versiontext.Name = "version"

		versiontext.AnchorPoint = Vector2.new(0.5,1)
		versiontext.Position = UDim2.new(0.5,0,1,0)

		versiontext.Size = UDim2.new(0,502,0,24)

		versiontext.BackgroundTransparency = 1

		versiontext.Text = "version: "..version.." || library version: "..self.libver
		versiontext.TextColor3 = textSecondary
		versiontext.TextSize = 12
		versiontext.TextXAlignment = Enum.TextXAlignment.Left
		versiontext.Font = Enum.Font.Code
		
		local sectionSelector = Instance.new("CanvasGroup",window)
		sectionSelector.AnchorPoint = Vector2.new(0.5,0.5)
		sectionSelector.Position = UDim2.new(0.5,0,0,51)

		sectionSelector.Size = UDim2.new(0,502,0,34)
		
		sectionSelector.BackgroundColor3 = changeBrightness(backgroundPrimary, 1/1.25)
		
		sectionSelector.ClipsDescendants = true
		
		local ssScroll = Instance.new("ScrollingFrame",sectionSelector)
		ssScroll.Size = UDim2.new(1,0,1,0)
		
		ssScroll.BackgroundTransparency = 1
		
		ssScroll.CanvasSize = UDim2.new(1,0,0,0)
		
		ssScroll.AutomaticSize = Enum.AutomaticSize.X
		
		ssScroll.ScrollBarThickness = 0
		
		local sectionBg = Instance.new("CanvasGroup",window)
		sectionBg.AnchorPoint = Vector2.new(0.5,1)
		sectionBg.Position = UDim2.new(0.5,0,1,-21)

		sectionBg.Size = UDim2.new(0,502,0,546)
		
		sectionBg.BackgroundColor3 = changeBrightness(backgroundPrimary, 1/1.25)
		
		sectionBg.ClipsDescendants = true
		
		-- ui instance creation
		createUiListLayout(ssScroll,Enum.FillDirection.Horizontal)
		
		createUiCorner(window, 8)
		createUiCorner(title, 8)
		createUiCorner(sectionSelector, 8)
		createUiCorner(sectionBg, 8)
		
		createUiPadding(ssScroll,5,5,5,5)
		
		local sections = {}
		
		function self.window:createSection(properties)
			local sectionDict = {}
			
			local sectionButton = Instance.new("TextButton", ssScroll)
			sectionButton.Name = "section"
			
			sectionButton.Size = UDim2.new(0,#properties.Name*8+16,1,0)
			
			sectionButton.BackgroundColor3 = backgroundPrimary
			
			sectionButton.Text = properties.Name
			sectionButton.TextColor3 = textPrimary
			sectionButton.TextSize = 16
			sectionButton.Font = Enum.Font.Code
			
			sectionButton.AutoButtonColor = false
			
			local section = Instance.new("ScrollingFrame", sectionBg)
			section.Size = UDim2.new(1,0,1,0)
			
			section.BackgroundTransparency = 1
			section.BorderSizePixel = 0
			
			section.CanvasSize = UDim2.new(0,0,1,0)
			
			section.ScrollBarThickness = 8
			
			section.AutomaticSize = Enum.AutomaticSize.Y
			
			section.Visible = false
			
			sections[properties.Name] = section
			
			
			-- ui instance creation
			createUiCorner(sectionButton, 8)
			createUiPadding(section, 5, 5, 5, 5)
			createUiListLayout(section, Enum.FillDirection.Vertical)
			
			sectionButton.MouseEnter:Connect(function()
				triggerTween(sectionButton,{BackgroundColor3 = changeBrightness(backgroundPrimary,0.9)})
			end)
			
			sectionButton.MouseLeave:Connect(function()
				triggerTween(sectionButton,{BackgroundColor3 = backgroundPrimary})
			end)
			
			sectionButton.MouseButton1Click:Connect(function()
				for _,v in pairs(sections) do
					v.Visible = false
				end
				
				sections[properties.Name].Visible = true
			end)
			
			function sectionDict:createDivider(properties)
				local divider = Instance.new("TextLabel",section)
				divider.Size = UDim2.new(1,0,0,16)
				
				divider.BackgroundTransparency = 1
				
				divider.Text = properties.Text
				divider.TextColor3 = textSecondary
				divider.TextSize = 14
				divider.Font = Enum.Font.Code
			end
			
			function sectionDict:createButton(properties)
				local main = Instance.new("TextButton", section)
				main.Name = "button_"..properties.Name

				main.AnchorPoint = Vector2.new(0.5,0.5)
				main.Position = UDim2.new(0.5,0,0,17)

				main.Size = UDim2.new(1,0,0,24)

				main.BackgroundColor3 = buttonPrimary

				main.Text = " "..properties.Name
				main.TextColor3 = textPrimary
				main.TextSize = 16
				main.TextXAlignment = Enum.TextXAlignment.Left
				main.Font = Enum.Font.Code
				
				main.AutoButtonColor = false
				
				local button = Instance.new("TextLabel", main)
				button.AnchorPoint = Vector2.new(1,0.5)
				button.Position = UDim2.new(1,-5,0.5,0)
				
				button.Size = UDim2.new(0,52,1,-4)
				
				button.BackgroundTransparency = 1
				
				button.Text = "Execute"
				button.TextColor3 = textPrimary
				button.TextSize = 14
				button.Font = Enum.Font.Code
				
				main.MouseEnter:Connect(function()
					triggerTween(main,{BackgroundColor3 = changeBrightness(buttonPrimary,0.9)})
				end)
				
				main.MouseLeave:Connect(function()
					triggerTween(main,{BackgroundColor3 = buttonPrimary})
				end)
				
				main.MouseButton1Click:Connect(properties.Callback)
				
				-- ui instance creation
				createUiCorner(main,8)
			end
			
			function sectionDict:createToggle(properties)
				local rbxconnection = nil
				if properties.RBXConnection then
					if connectionTypes[properties.RBXConnection] then
						rbxconnection = connectionTypes[properties.RBXConnection]
					end
				end
				
				local main = Instance.new("TextLabel", section)
				main.Name = "toggle_"..properties.Name

				main.AnchorPoint = Vector2.new(0.5,0.5)
				main.Position = UDim2.new(0.5,0,0,17)

				main.Size = UDim2.new(1,0,0,24)

				main.BackgroundColor3 = buttonPrimary

				main.Text = " "..properties.Name
				main.TextColor3 = textPrimary
				main.TextSize = 16
				main.TextXAlignment = Enum.TextXAlignment.Left
				main.Font = Enum.Font.Code

				local button = Instance.new("TextButton", main)
				button.AnchorPoint = Vector2.new(1,0.5)
				button.Position = UDim2.new(1,-2,0.5,0)

				button.Size = UDim2.new(0,55,1,-4)

				button.BackgroundColor3 = disabled

				button.Text = ""
				
				button.AutoButtonColor = false
				
				local value = properties.Default
				local connection
				
				local hovering = false
				
				if value then
					button.BackgroundColor3 = enabled
					
					if rbxconnection then
						connection = rbxconnection:Connect(properties.Callback)
					else
						properties.Callback(value)
					end
				end

				button.MouseEnter:Connect(function()
					hovering = true
					
					if value then
						triggerTween(button,{BackgroundColor3 = changeBrightness(enabled,0.9)})
					else
						triggerTween(button,{BackgroundColor3 = changeBrightness(disabled,0.9)})
					end
				end)

				button.MouseLeave:Connect(function()
					hovering = false
					
					if value then
						triggerTween(button,{BackgroundColor3 = enabled})
					else
						triggerTween(button,{BackgroundColor3 = disabled})
					end
				end)

				button.MouseButton1Click:Connect(function()
					value = not value
					
					if rbxconnection then
						if value then
							connection = rbxconnection:Connect(properties.Callback)
						else
							if connection then
								connection:Disconnect()
							end
						end
					else
						properties.Callback(value)
					end
					
					if value then
						if hovering then
							triggerTween(button,{BackgroundColor3 = changeBrightness(enabled,0.9)})
						else
							triggerTween(button,{BackgroundColor3 = enabled})
						end
					else
						if hovering then
							triggerTween(button,{BackgroundColor3 = changeBrightness(disabled,0.9)})
						else
							triggerTween(button,{BackgroundColor3 = disabled})
						end
					end
				end)

				-- ui instance creation
				createUiCorner(main,8)
				createUiCorner(button,8)
			end
			
			function sectionDict:createSlider(properties)
				local suffix: string = properties.Suffix or ""
				
				local main = Instance.new("TextLabel", section)
				main.Name = "slider_"..properties.Name

				main.AnchorPoint = Vector2.new(0.5,0.5)
				main.Position = UDim2.new(0.5,0,0,17)

				main.Size = UDim2.new(1,0,0,24)

				main.BackgroundColor3 = buttonPrimary

				main.Text = " "..properties.Name
				main.TextColor3 = textPrimary
				main.TextSize = 16
				main.TextXAlignment = Enum.TextXAlignment.Left
				main.Font = Enum.Font.Code

				local text = Instance.new("TextLabel", main)
				text.AnchorPoint = Vector2.new(1,0.5)
				text.Position = UDim2.new(1,-165,0.5,0)

				text.Size = UDim2.new(0,52,1,-4)

				text.BackgroundTransparency = 1

				text.Text = properties.Default.." "..suffix
				text.TextColor3 = textPrimary
				text.TextSize = 14
				text.Font = Enum.Font.Code
				text.TextXAlignment = Enum.TextXAlignment.Right
				
				local sliderBg = Instance.new("CanvasGroup",main)
				sliderBg.AnchorPoint = Vector2.new(1,0.5)
				sliderBg.Position = UDim2.new(1,-2,0.5,0)

				sliderBg.Size = UDim2.new(0,160,1,-4)
				
				sliderBg.BackgroundColor3 = disabled
				
				sliderBg.ClipsDescendants = true
				
				local slider = Instance.new("Frame",sliderBg)
				slider.Size = UDim2.new(properties.Default / (properties.Max - properties.Min),0,1,0)
				
				slider.BackgroundColor3 = enabled
				
				slider.BorderSizePixel = 0
				
				local localpressed = false
				local hovering = false
				
				sliderBg.MouseEnter:Connect(function()
					hovering = true
				end)
				
				sliderBg.MouseLeave:Connect(function()
					hovering = false
				end)
				
				userInputService.InputBegan:Connect(function(input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if hovering then
							localpressed = true
						end
					end
				end)
				
				userInputService.InputEnded:Connect(function(input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						localpressed = false
					end
				end)
				
				userInputService.InputChanged:Connect(function(input: InputObject)
					if localpressed then
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							local curpos = input.Position.X - sliderBg.AbsolutePosition.X

							local maxpos = sliderBg.AbsoluteSize.X

							local curscaled = math.round((math.clamp(curpos/maxpos,0,1) * (properties.Max - properties.Min)) / properties.Increment) * properties.Increment + properties.Min

							local curnorm = (curscaled - properties.Min) / (properties.Max - properties.Min)

							text.Text = formatFloat(curscaled).." "..suffix

							triggerTween(slider, {Size = UDim2.new(curnorm,0,1,0)})

							properties.Callback(curscaled)
						end
					end
				end)

				-- ui instance creation
				createUiCorner(main, 8)
				createUiCorner(sliderBg, 8)
			end
			
			return sectionDict
		end
		
		return self.window
	end,
}

return library
