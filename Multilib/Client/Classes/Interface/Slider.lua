local Mtypes = require(game:GetService("ReplicatedStorage").Multilib.Types)
local MInstance = require(game:GetService("ReplicatedStorage").Multilib.Shared.Components.Instance)
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

function Slider.new(model: any, elements: {GuiObject}, idName: string, settings: Mtypes.Slider?)
	local self = setmetatable({}, Slider)

	if settings == nil then settings = {} end
	if settings.ElementType == nil then settings.ElementType = "Numeric" end
	if settings.SliderArea == nil then settings.SliderArea = 1.25 end
	if settings.ElementType == "Numeric" then
		if settings.StartingValue == nil then
			settings.StartingValue = 50
			self.startingValue = settings.StartingValue
		else
			self.startingValue = settings.StartingValue
		end
		if settings.MinValue == nil then
			settings.MinValue = 0
			self._MinValue = settings.MinValue
		else
			self._MinValue = settings.MinValue
		end
		if settings.MaxValue == nil then
			settings.MaxValue = 100
			self._MaxValue = settings.MaxValue
		else
			self._MaxValue = settings.MaxValue
		end
		if settings.StepBy == nil then
			settings.StepBy = 5
			self._StepBy = settings.StepBy
		else
			self._StepBy = settings.StepBy
		end
	elseif settings.ElementType == "Text" then
		if settings.TextValues == nil then
			settings.TextValues = {"FirstValue","startingValue","LastValue"}
			self._TextValues = settings.TextValues
		else
			self._TextValues = settings.TextValues
		end
		if settings.StartingValue == nil then
			settings.StartingValue = settings.TextValues[1]
			self.startingValue = settings.StartingValue
		else
			self.startingValue = settings.StartingValue
		end
		self._StepBy =  1
		self._MinValue = 0
		self._MaxValue = #settings.TextValues - 1
	end

	if settings.Locked == nil then settings.Locked = false end

	local model, elements = MInstance:PerfectClone(model,elements)

	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end

	self.Initiated = false
	self.ElementType = "Slider"
	self.SubType = settings.ElementType
	self.Actions = {}
	self.Model = model
	self.Model.Name = idName
	self.IdName = idName

	self.CooldownTime = settings.Cooldown
	self.Value = settings.StartingValue
	self.Locked = settings.Locked
	self.IsActive = false

	self._ModelElements.Drag.AnchorPoint = Vector2.new(0.5,0.5)

	self._ModelElements.MobileDetect = Instance.new("Frame")
	self._ModelElements.MobileDetect.AnchorPoint = Vector2.new(0.5,0.5)
	self._ModelElements.MobileDetect.Position = UDim2.fromScale(0.5,0.5)
	self._ModelElements.MobileDetect.Size = UDim2.fromScale(settings.SliderArea,settings.SliderArea)
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
				from = total.AbsolutePosition.X,
				to = total.AbsolutePosition.X + total.AbsoluteSize.X
			}
			if mousePos.X > legitimatePositions.from and mousePos.X < legitimatePositions.to then
				local legitimateValue = math.clamp((mousePos.X - legitimatePositions.from) / (legitimatePositions.to - legitimatePositions.from),0,1)
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
			elseif mousePos.X < legitimatePositions.from then
				local LegitimateValue = self._MinValue
				Change(LegitimateValue)
			elseif mousePos.X > legitimatePositions.to then
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
				RunService:BindToRenderStep(self.IdName .. "SliderFunc",Enum.RenderPriority.Input.value,Update)
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
				RunService:BindToRenderStep(self.IdName .. "SliderFunc",Enum.RenderPriority.Input.value,Update)
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
	for index, action in self.Actions do
		action()
	end
end

--[=[
	@within Slider
	@return <boolean,string> -- [value and idName of the object]
	Returns value and idName of the object.
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
	self.Model.Parent = where
end

--[=[
	@within Slider
	@private
	Private Function, should not be called.
]=]

function Slider:_DisplayAnimFunc(value: number) -- internal private function, do not call
	local function ConvertToAbsolute(value: number)
		local clampedValue = math.clamp(value, self._MinValue, self._MaxValue)
		local rangeCustom = self._MaxValue - self._MinValue
		local proportion = (clampedValue - self._MinValue) / rangeCustom
		return proportion * 100
	end
	local drag:GuiButton = self._ModelElements.Drag
	local progressBar:GuiObject = self._ModelElements.ProgressBar
	local showText:GuiObject = self._ModelElements.ShowText
	local tweenInfoToUse = TweenInfo.new(0.05,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	TweenService:Create(drag,tweenInfoToUse,{position = UDim2.fromScale(ConvertToAbsolute(value) / 100,0.5)}):Play()
	TweenService:Create(progressBar,tweenInfoToUse,{Size = UDim2.fromScale(ConvertToAbsolute(value	) / 100,1)}):Play()
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
	self.Model:Destroy()
	for index, value in self do
		value = nil
	end
end


return Slider
