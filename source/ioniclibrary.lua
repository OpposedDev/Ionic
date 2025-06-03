playerService = game:GetService("Players")
runService = game:GetService("RunService")
tweenService = game:GetService("TweenService")
userInputService = game:GetService("UserInputService")
playerMouse = playerService.LocalPlayer:GetMouse()

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

createUiStroke = function(parent: Instance, thickness: number, color: Color3, transparency: number)
	local uiStroke = Instance.new("UIStroke", parent)
	uiStroke.Thickness = thickness
	uiStroke.Color = color
	uiStroke.Transparency = transparency
	parent.Changed:Connect(function(property)
		if property == "BackgroundTransparency" then
			uiStroke.Transparency = parent.BackgroundTransparency
		end
	end)
end

createUiGradient = function(parent: Instance, rotation: number, colorinfo: ColorSequence, transparencyinfo: NumberSequence)
	local uiGradient = Instance.new("UIGradient", parent)
	uiGradient.Rotation = rotation
	uiGradient.Color = colorinfo or ColorSequence.new(Color3.new(1,1,1))
	uiGradient.Transparency = transparencyinfo or NumberSequence.new(0)
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
	
	libver = "6/3/2025-stable",
	
	window = {},
	
	pushNotification = function(self, properties)
		
	end,
	
	createWindow = function(self, properties)
		local name: string = properties.Title
		local version: string = properties.Version
		local restorekeybind: Enum.KeyCode = properties.RestoreKeybind or Enum.KeyCode.Insert
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
		
		if properties.UseCore then
			self.main.Parent = game.CoreGui
		end
		
		local window = Instance.new("CanvasGroup", self.main)
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
		
		local minimize = Instance.new("TextButton",title)
		minimize.AnchorPoint = Vector2.new(1,0.5)
		minimize.Position = UDim2.new(1,-2,0.5,0)
		
		minimize.Size = UDim2.new(0,64,0,20)
		
		minimize.BackgroundColor3 = backgroundPrimary
		
		minimize.Text = "Minimize"
		minimize.TextColor3 = textPrimary
		minimize.TextSize = 12
		minimize.Font = Enum.Font.Code
		
		minimize.AutoButtonColor = false
		
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
		
		local windowhover = false
		local windowmove = false
		local mouseoffset = Vector2.new(0,0)
		local minimized = false
		
		minimize.MouseEnter:Connect(function()
			triggerTween(minimize,{BackgroundColor3 = changeBrightness(backgroundPrimary,0.9)})
		end)
		
		minimize.MouseLeave:Connect(function()
			triggerTween(minimize,{BackgroundColor3 = backgroundPrimary})
		end)
		
		minimize.MouseButton1Click:Connect(function()
			triggerTween(window,{GroupTransparency = 1})
			task.wait(smoothTween.Time)
			self.main.Enabled = false
			minimized = true
		end)
		
		title.MouseEnter:Connect(function()
			windowhover = true
		end)
		
		title.MouseLeave:Connect(function()
			windowhover = false
		end)
		
		userInputService.InputBegan:Connect(function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if windowhover then
					mouseoffset = Vector2.new(playerMouse.X,playerMouse.Y)
					windowmove = true
				end
			end
			
			if input.KeyCode == restorekeybind then
				if minimized then
					minimized = false
					self.main.Enabled = true
					triggerTween(window,{GroupTransparency = 0})
				else
					triggerTween(window,{GroupTransparency = 1})
					task.wait(smoothTween.Time)
					self.main.Enabled = false
					minimized = true
				end
			end
		end)
		
		userInputService.InputEnded:Connect(function(input: InputObject)
			windowmove = false
		end)
		
		playerMouse.Move:Connect(function()
			if windowmove then
				local new = Vector2.new(playerMouse.X,playerMouse.Y)
				window.Position += UDim2.new(0, new.X - mouseoffset.X, 0, new.Y - mouseoffset.Y)
				mouseoffset = new
			end
		end)
		
		-- ui instance creation
		createUiListLayout(ssScroll,Enum.FillDirection.Horizontal)
		
		createUiCorner(window, 8)
		createUiCorner(title, 8)
		createUiCorner(sectionSelector, 8)
		createUiCorner(sectionBg, 8)
		createUiCorner(minimize,8)
		
		createUiPadding(ssScroll,5,5,5,5)
		
		local sections = {}
		local firstsection = true
		
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
			
			if firstsection then
				firstsection = false
			else
				section.Visible = false
			end
			
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
				
				local min = properties.Range[1]
				local max = properties.Range[2]
				
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
				slider.Size = UDim2.new(properties.Default / (max - min),0,1,0)
				
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

							local curscaled = math.round((math.clamp(curpos/maxpos,0,1) * (max - min)) / properties.Increment) * properties.Increment + min

							local curnorm = (curscaled - min) / (max - min)

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
			
			function sectionDict:createColorPicker(properties)
				local dH, dS, dV = properties.Default:ToHSV()
				
				local main = Instance.new("TextButton", section)
				main.Name = "colorpicker_"..properties.Name

				main.AnchorPoint = Vector2.new(0.5,0)
				main.Position = UDim2.new(0.5,0,0,17)

				main.Size = UDim2.new(1,0,0,24)

				main.BackgroundColor3 = buttonPrimary

				main.Text = " "..properties.Name
				main.TextColor3 = textPrimary
				main.TextSize = 16
				main.TextXAlignment = Enum.TextXAlignment.Left
				main.TextYAlignment = Enum.TextYAlignment.Center
				main.Font = Enum.Font.Code

				main.AutoButtonColor = false

				local button = Instance.new("TextLabel", main)
				button.AnchorPoint = Vector2.new(1,0)
				button.Position = UDim2.new(1,-5,0,0)

				button.Size = UDim2.new(0,52,0,24)

				button.BackgroundTransparency = 1

				button.Text = "+"
				button.TextColor3 = textSecondary
				button.TextSize = 16
				button.TextXAlignment = Enum.TextXAlignment.Right
				button.Font = Enum.Font.Code
				
				local preview = Instance.new("TextButton", main)
				preview.Active = false
				
				preview.AnchorPoint = Vector2.new(1,0)
				preview.Position = UDim2.new(1,-20,0,2)

				preview.Size = UDim2.new(0,55,0,20)

				preview.BackgroundColor3 = properties.Default

				preview.Text = ""

				preview.AutoButtonColor = false
				
				local picker = Instance.new("Frame", main)
				picker.Active = false
				
				picker.AnchorPoint = Vector2.new(1,0)
				picker.Position = UDim2.new(1,-24,0,26)
				
				picker.Size = UDim2.new(0,200,1,-28)
				
				picker.BackgroundTransparency = 1
				picker.BackgroundColor3 = Color3.new(1,1,1)
				
				local soverlay = Instance.new("Frame",picker)
				soverlay.Size = UDim2.new(1,0,1,0)
				
				soverlay.BackgroundTransparency = 1
				soverlay.BackgroundColor3 = Color3.new(1,1,1)
				
				local overlay = Instance.new("Frame",picker)
				overlay.Size = UDim2.new(1,0,1,0)
				
				overlay.BackgroundTransparency = dV
				overlay.BackgroundColor3 = Color3.new(0,0,0)
				
				local sliderBg = Instance.new("CanvasGroup", main)
				sliderBg.Active = false

				sliderBg.AnchorPoint = Vector2.new(1,0)
				sliderBg.Position = UDim2.new(1,-2,0,26)

				sliderBg.Size = UDim2.new(0,20,1,-28)

				sliderBg.BackgroundTransparency = 1
				sliderBg.BackgroundColor3 = disabled
				
				sliderBg.ClipsDescendants = true
				
				local slider = Instance.new("Frame",sliderBg)
				slider.AnchorPoint = Vector2.new(0,1)
				slider.Position = UDim2.new(0,0,1,0)
				
				slider.Size = UDim2.new(1,0,dV/1,0)
				
				slider.BackgroundTransparency = 1
				slider.BackgroundColor3 = enabled

				slider.BorderSizePixel = 0
				
				local pickercircle = Instance.new("Frame",picker)
				pickercircle.AnchorPoint = Vector2.new(0.5,0.5)
				pickercircle.Position = UDim2.new(dH,0,1-dS,0)
				
				pickercircle.Size = UDim2.new(0,8,0,8)
				
				pickercircle.BackgroundTransparency = 1
				pickercircle.BackgroundColor3 = Color3.new(1,1,1)
				
				local suppressClick = false
				
				local sliderpressed = false
				local sliderhovering = false
				
				local pickerpressed = false
				local pickerhovering = false
				
				local currentColor = properties.Default or Color3.new(1,1,1)
				local opened = false

				main.MouseEnter:Connect(function()
					triggerTween(main,{BackgroundColor3 = changeBrightness(buttonPrimary,0.9)})
				end)

				main.MouseLeave:Connect(function()
					triggerTween(main,{BackgroundColor3 = buttonPrimary})
					suppressClick = false
				end)
				
				main.Activated:Connect(function()
					if suppressClick == true then
						suppressClick = false
						return
					end
					
					opened = not opened
					
					if opened then
						button.Text = "-"
						
						triggerTween(main,{Size = UDim2.new(1,0,0,128)})
						triggerTween(picker,{BackgroundTransparency = 0})
						triggerTween(soverlay,{BackgroundTransparency = 0})
						triggerTween(overlay,{BackgroundTransparency = dV})
						triggerTween(sliderBg,{BackgroundTransparency = 0})
						triggerTween(slider,{BackgroundTransparency = 0})
						triggerTween(pickercircle,{BackgroundTransparency = 0})
					else
						button.Text = "+"
						
						triggerTween(main,{Size = UDim2.new(1,0,0,24)})
						triggerTween(picker,{BackgroundTransparency = 1})
						triggerTween(soverlay,{BackgroundTransparency = 1})
						triggerTween(overlay,{BackgroundTransparency = 1})
						triggerTween(sliderBg,{BackgroundTransparency = 1})
						triggerTween(slider,{BackgroundTransparency = 1})
						triggerTween(pickercircle,{BackgroundTransparency = 1})
					end
				end)
				
				sliderBg.MouseEnter:Connect(function()
					sliderhovering = true
				end)

				sliderBg.MouseLeave:Connect(function()
					sliderhovering = false
				end)
				
				picker.MouseEnter:Connect(function()
					pickerhovering = true
				end)

				picker.MouseLeave:Connect(function()
					pickerhovering = false
				end)

				userInputService.InputBegan:Connect(function(input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if opened then
							if sliderhovering then
								sliderpressed = true
								suppressClick = true
							end
							if pickerhovering then
								pickerpressed = true
								suppressClick = true
							end
						end
					end
				end)

				userInputService.InputEnded:Connect(function(input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						sliderpressed = false
						pickerpressed = false
					end
				end)

				userInputService.InputChanged:Connect(function(input: InputObject)
					if sliderpressed then
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							local curpos = sliderBg.AbsolutePosition.Y - input.Position.Y

							local maxpos = sliderBg.AbsoluteSize.Y
							
							dV = math.clamp(curpos/maxpos + 1,0,1)
							
							overlay.BackgroundTransparency = dV
							
							currentColor = Color3.fromHSV(dH,dS,dV)
							
							preview.BackgroundColor3 = currentColor
							
							properties.Callback(currentColor)

							triggerTween(slider, {Size = UDim2.new(1,0,dV,0)})
						end
					end
					
					if pickerpressed then
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							local curposx,curposy = input.Position.X - picker.AbsolutePosition.X,input.Position.Y - picker.AbsolutePosition.Y

							local maxposx,maxposy = picker.AbsoluteSize.X,picker.AbsoluteSize.Y

							dH = math.clamp(curposx/maxposx,0,1)
							dS = math.clamp(1 - curposy/maxposy,0,1)
							
							pickercircle.Position = UDim2.new(dH,0,1 - dS,0)
							
							currentColor = Color3.fromHSV(dH,dS,dV)
							
							preview.BackgroundColor3 = currentColor
							
							properties.Callback(currentColor)
						end
					end
				end)

				-- ui instance creation
				createUiGradient(soverlay,90,nil,NumberSequence.new{
					NumberSequenceKeypoint.new(0,1),
					NumberSequenceKeypoint.new(1,0)
				})
				
				createUiGradient(picker,0,ColorSequence.new{
					ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),
					ColorSequenceKeypoint.new(0.1,Color3.fromHSV(0.1,1,1)),
					ColorSequenceKeypoint.new(0.2,Color3.fromHSV(0.2,1,1)),
					ColorSequenceKeypoint.new(0.3,Color3.fromHSV(0.3,1,1)),
					ColorSequenceKeypoint.new(0.4,Color3.fromHSV(0.4,1,1)),
					ColorSequenceKeypoint.new(0.5,Color3.fromHSV(0.5,1,1)),
					ColorSequenceKeypoint.new(0.6,Color3.fromHSV(0.6,1,1)),
					ColorSequenceKeypoint.new(0.7,Color3.fromHSV(0.7,1,1)),
					ColorSequenceKeypoint.new(0.8,Color3.fromHSV(0.8,1,1)),
					ColorSequenceKeypoint.new(0.9,Color3.fromHSV(0.9,1,1)),
					ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1)),
				})
				
				createUiStroke(pickercircle,1,Color3.new(0,0,0),1)
				
				createUiCorner(main,8)
				createUiCorner(preview,8)
				createUiCorner(picker,8)
				createUiCorner(sliderBg,8)
				createUiCorner(soverlay,8)
				createUiCorner(overlay,8)
				createUiCorner(pickercircle,5)
			end
			
			function sectionDict:createDropdown(properties)
				local options = properties.Options or {}
				local default = properties.Default or {}
				local multipleoptions: boolean = properties.MultipleOptions or false
				
				local main = Instance.new("TextLabel", section)
				main.Name = "dropdown_"..properties.Name

				main.AnchorPoint = Vector2.new(0.5,0.5)
				main.Position = UDim2.new(0.5,0,0,17)

				main.Size = UDim2.new(1,0,0,24)

				main.BackgroundColor3 = buttonPrimary

				main.Text = " "..properties.Name
				main.TextColor3 = textPrimary
				main.TextSize = 16
				main.TextXAlignment = Enum.TextXAlignment.Left
				main.Font = Enum.Font.Code
				
				local dropdown = Instance.new("TextLabel", main)
				dropdown.AnchorPoint = Vector2.new(1,0.5)
				dropdown.Position = UDim2.new(1,-2,0.5,0)

				dropdown.Size = UDim2.new(0,100,1,-4)

				dropdown.BackgroundColor3 = backgroundPrimary

				dropdown.Text = " "..default[1] or " None"
				dropdown.TextColor3 = textSecondary
				dropdown.TextSize = 14
				dropdown.Font = Enum.Font.Code
				dropdown.TextXAlignment = Enum.TextXAlignment.Left
				
				local sidetext = Instance.new("TextLabel", main)
				sidetext.AnchorPoint = Vector2.new(1,0.5)
				sidetext.Position = UDim2.new(1,-2,0.5,0)

				sidetext.Size = UDim2.new(0,100,1,-4)

				sidetext.BackgroundTransparency = 1

				sidetext.Text = "+ "
				sidetext.TextColor3 = textSecondary
				sidetext.TextSize = 16
				sidetext.Font = Enum.Font.Code
				sidetext.TextXAlignment = Enum.TextXAlignment.Right
				
				if #default > 1 then
					dropdown.Text = " "..default[1].."..."
				end
				
				dropdown.MouseEnter:Connect(function()
					triggerTween(dropdown,{BackgroundColor3 = changeBrightness(backgroundPrimary,0.9)})
				end)

				dropdown.MouseLeave:Connect(function()
					triggerTween(dropdown,{BackgroundColor3 = backgroundPrimary})
				end)
				
				-- ui instance creation
				createUiCorner(main,8)
				createUiCorner(dropdown,8)
			end
			
			return sectionDict
		end
		
		return self.window
	end,
}

return library
