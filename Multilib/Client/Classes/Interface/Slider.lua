local Mtypes = require(script.Parent.Parent.Parent.Parent.Types)
local MInstance = require(script.Parent.Parent.Parent.Parent.Shared.Components.Instance)
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Slider = {}
Slider.__index = Slider

--[=[
	@class Slider
	@client
	Class for Slider object.
]=]

--[=[
	@within Slider
	@return <table> -- [Slider Object]
	Constructor for Slider object.
]=]

function Slider.new(model: any, elements: {GuiObject}, IdName: string, useSettings: Mtypes.Slider?)
	local self = setmetatable({}, Slider)

	useSettings = useSettings or {}
	useSettings.Locked = useSettings.Locked or false
	useSettings.Type = useSettings.Type or "Numeric"
	useSettings.SliderArea = useSettings.SliderArea or 1.25
	if useSettings.Type == "Numeric" then
		if useSettings.StartingValue == nil then
			useSettings.StartingValue = 50
			self._StartingValue = useSettings.StartingValue
		else
			self._StartingValue = useSettings.StartingValue
		end
		if useSettings.MinValue == nil then
			useSettings.MinValue = 0
			self._MinValue = useSettings.MinValue
		else
			self._MinValue = useSettings.MinValue
		end
		if useSettings.MaxValue == nil then
			useSettings.MaxValue = 100
			self._MaxValue = useSettings.MaxValue
		else
			self._MaxValue = useSettings.MaxValue
		end
		if useSettings.StepBy == nil then
			useSettings.StepBy = 5
			self._StepBy = useSettings.StepBy
		else
			self._StepBy = useSettings.StepBy
		end
	elseif useSettings.Type == "Text" then
		if useSettings.TextValues == nil then
			useSettings.TextValues = {"FirstValue","startingValue","LastValue"}
			self._TextValues = useSettings.TextValues
		else
			self._TextValues = useSettings.TextValues
		end
		if useSettings.StartingValue == nil then
			useSettings.StartingValue = useSettings.TextValues[1]
			self._StartingValue = useSettings.StartingValue
		else
			self._StartingValue = useSettings.StartingValue
		end
		self._StepBy =  1
		self._MinValue = 0
		self._MaxValue = #useSettings.TextValues - 1
	end

	model, elements = MInstance:PerfectClone(model,elements)

	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end

	self.Initiated = false
	self.ElementType = "Slider"
	self.SubType = useSettings.Type
	self.Actions = {}
	self._Model = model
	self._Model.Name = IdName
	self.IdName = IdName

	self.CooldownTime = useSettings.Cooldown
	self.Value = useSettings.StartingValue
	self.Locked = useSettings.Locked
	self.IsActive = false

	self._ModelElements.Drag.AnchorPoint = Vector2.new(0.5,0.5)

	self._ModelElements.MobileDetect = Instance.new("Frame")
	self._ModelElements.MobileDetect.AnchorPoint = Vector2.new(0.5,0.5)
	self._ModelElements.MobileDetect.Position = UDim2.fromScale(0.5,0.5)
	self._ModelElements.MobileDetect.Size = UDim2.fromScale(useSettings.SliderArea,useSettings.SliderArea)
	self._ModelElements.MobileDetect.BackgroundTransparency = 1
	self._ModelElements.MobileDetect.ZIndex = math.huge
	self._ModelElements.MobileDetect.Name = "MobileDetect"
	self._ModelElements.MobileDetect.Parent = self._ModelElements.Total

	if self.SubType == "Numeric" then
		self:_DisplayAnimFunc(self.Value)
	elseif self.SubType == "Text" then
		self:_DisplayAnimFunc(table.find(self._TextValues,self.Value) - 1)
	end

	return self
end

--[=[
	@within Slider
	
	should be called only via Form:InitAll().
]=]

function Slider:Init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		local function Change(LegitimateValue)
			if LegitimateValue ~= self.Value then
				self:_DisplayAnimFunc(LegitimateValue)
				self.Value = LegitimateValue
				self:_ExecuteActions()
			end
		end
		local function Update()
			local total:GuiObject = self._ModelElements.Total
			local mousePos = UserInputService:GetMouseLocation()
			local legitimatePositions = {
				From = total.AbsolutePosition.X,
				To = total.AbsolutePosition.X + total.AbsoluteSize.X
			}
			if mousePos.X > legitimatePositions.From and mousePos.X < legitimatePositions.To then
				local legitimateValue = math.clamp((mousePos.X - legitimatePositions.From) / (legitimatePositions.To - legitimatePositions.From),0,1)
				legitimateValue = legitimateValue * (self._MaxValue - self._MinValue) + self._MinValue
				if legitimateValue < 0.5 then
					legitimateValue = math.floor(legitimateValue)
				else
					legitimateValue = math.ceil(legitimateValue)
				end
				if legitimateValue % self._StepBy == 0 then
					Change(legitimateValue)
				else
					local leftOver = legitimateValue % self._StepBy
					if leftOver > self._StepBy / 2 then
						legitimateValue = math.ceil(legitimateValue / self._StepBy) * self._StepBy
						Change(legitimateValue)
					else
						legitimateValue = math.floor(legitimateValue / self._StepBy) * self._StepBy
						Change(legitimateValue)
					end
				end
			elseif mousePos.X < legitimatePositions.From then
				local LegitimateValue = self._MinValue
				Change(LegitimateValue)
			elseif mousePos.X > legitimatePositions.To then
				local LegitimateValue = self._MaxValue
				Change(LegitimateValue)
			end
		end
		local function Allow(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and self.IsActive == false and self.Locked == false then
				return true
			end
			return false
		end

		self._ModelElements.Drag.InputBegan:Connect(function(input)
			if Allow(input) then
				self.IsActive = true
				RunService:BindToRenderStep(self.IdName .. "SliderFunc",Enum.RenderPriority.Input.Value,Update)
			end
		end)

		self._ModelElements.Drag.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				RunService:UnbindFromRenderStep(self.IdName .. "SliderFunc")
				self.IsActive = false
			end
		end)

		self._ModelElements.MobileDetect.InputBegan:Connect(function(input)
			if Allow(input) then
				self.IsActive = true
				RunService:BindToRenderStep(self.IdName .. "SliderFunc",Enum.RenderPriority.Input.Value,Update)
			end
		end)

		self._ModelElements.MobileDetect.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				RunService:UnbindFromRenderStep(self.IdName .. "SliderFunc")
				self.IsActive = false
			end
		end)
	end
end

--[=[
	@within Slider
	
	Adds action that will be executed on every value change.
]=]

function Slider:AddAction(actionName: string, action: any)
	self.Actions[actionName] = action
end

--[=[
	@within Slider
	
	Removes action that would be executed on every value change.
]=]

function Slider:RemoveAction(actionName: string)
	table.remove(self.Actions,actionName)
end

--[=[
	@within Slider
	@private
	Private Function, should not be called.
]=]

function Slider:_ExecuteActions()
	for _, action in self.Actions do
		action()
	end
end

--[=[
	@within Slider
	@return <boolean,string> -- [value and IdName of the object]
	Returns value and IdName of the object.
]=]

function Slider:ReturnValues()
	return self.Value, self.IdName
end

--[=[
	@within Slider
	
	Changes the Slider.locked property.
]=]

function Slider:LockStatus(status: boolean)
	self.Locked = status
end

--[=[
	@within Slider
	
	Sets the Parent of the Slider.model.
]=]

function Slider:Append(where: any)
	self._Model.Parent = where
end

--[=[
	@within Slider
	@private
	Private Function, should not be called.
]=]

function Slider:_DisplayAnimFunc(value: number) -- internal private function, do not call
	local function ConvertToAbsolute()
		local clampedValue = math.clamp(value, self._MinValue, self._MaxValue)
		local rangeCustom = self._MaxValue - self._MinValue
		local proportion = (clampedValue - self._MinValue) / rangeCustom
		return proportion * 100
	end
	local drag:GuiButton = self._ModelElements.Drag
	local progressBar:GuiObject = self._ModelElements.ProgressBar
	local showText:GuiObject = self._ModelElements.ShowText
	local tweenInfoToUse = TweenInfo.new(0.05,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	TweenService:Create(drag,tweenInfoToUse,{Position = UDim2.fromScale(ConvertToAbsolute() / 100,0.5)}):Play()
	TweenService:Create(progressBar,tweenInfoToUse,{Size = UDim2.fromScale(ConvertToAbsolute() / 100,1)}):Play()
	if self.SubType == "Numeric" then
		showText.Text = value
	elseif self.SubType == "Text" then
		showText.Text = self._TextValues[value + 1]
	end
end

--[=[
	@within Slider
	Destructor for Slider object.
]=]

function Slider:Destroy()
	RunService:UnbindFromRenderStep(self.IdName .. "SliderFunc")
	self._Model:Destroy()
	self = nil
end


return Slider
