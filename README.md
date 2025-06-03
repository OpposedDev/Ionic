# Ionic UI Library
![Thumbnail](/images/thumbnail.png)
A simplistic and easy-to-use UI Library made for use on any Roblox executor.

# How to Use

## Loading the Library
```lua
local Ionic = loadstring(game:HttpGet("https://raw.githubusercontent.com/OpposedDev/Ionic/refs/heads/main/source/ioniclibrary.lua"))()
```

## Creating a Window
```lua
local window = library:createWindow({
	Title = "Ionic Library Example", -- Title at the top of the window
	Version = "Example", -- Version displayed at the bottom of the window
	RestoreKeybind = Enum.KeyCode.Insert, -- Minimize / Restore Keybind
})
```

## Creating a Section
```lua
local section = window:createSection({
	Name = "Section"
})
```

## Creating Elements
### Divider
```lua
section:createDivider({
	Text = "Divider Example"
})
```

### Button
```lua
section:createButton({
	Name = "Button Example",
	Flag = "button", -- Flags are currently unused.
	Callback = function()
		-- function that occurs when the button is clicked.
	end,
})
```

### Toggle
```lua
section:createToggle({
	Name = "Toggle Example",
	Flag = "toggle",
	Default = false,
	Callback = function(value: boolean)
		-- function that occurs whenever the toggle is toggled true or false.
	end,
})
```

With the Ionic UI library, you can directly connect your callback to a RunService event.
For information on RunService events, go to Roblox's documentation page for [RunService](https://create.roblox.com/docs/reference/engine/classes/RunService#Heartbeat).
```lua
section:createToggle({
	Name = "Connected Toggle Example",
	Flag = "runtoggle",
	Default = false,
	RBXConnection = "Heartbeat",
	Callback = function()
		-- function that occurs on the chosen RunService event while the toggle is toggled true
	end,
})
```

### Slider
```lua
section:createSlider({
	Name = "Slider Example",
	Flag = "slider",
	Default = 50,
	Range = {0, 100},
	Increment = 1,
	Suffix = "Number",
	Callback = function(value: number)
		-- function that occurs when the slider value is changed.
	end,
})
```

### Color Picker
```lua
section:createColorPicker({
	Name = "Color Picker Example",
	Flag = "color picker",
	Default = Color3.new(1,1,1),
	Callback = function(value: Color3)
		-- function that occurs when the color is changed.
	end,
})
```
