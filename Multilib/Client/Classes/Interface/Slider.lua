local Multilib = require(game:GetService("ReplicatedStorage").Multilib)
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

function Slider.new(model: any, elements: {GuiObject}, idName: string, settings: Multilib.Slider?)
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
			self.minValue = settings.MinValue
		else
			self.minValue = settings.MinValue
		end
		if settings.MaxValue == nil then
			settings.MaxValue = 100
			self.maxValue = settings.MaxValue
		else
			self.maxValue = settings.MaxValue
		end
		if settings.StepBy == nil then
			settings.StepBy = 5
			self.stepBy = settings.StepBy
		else
			self.stepBy = settings.StepBy
		end
	elseif settings.ElementType == "Text" then
		if settings.TextValues == nil then
			settings.TextValues = {"FirstValue","startingValue","LastValue"}
			self.textValues = settings.TextValues
		else
			self.textValues = settings.TextValues
		end
		if settings.StartingValue == nil then
			settings.StartingValue = settings.TextValues[1]
			self.startingValue = settings.StartingValue
		else
			self.startingValue = settings.StartingValue
		end
		self.stepBy =  1
		self.minValue = 0
		self.maxValue = #settings.TextValues - 1
	end

	if settings.Locked == nil then settings.Locked = false end

	local model, elements = self:PerfectClone(model,elements)

	self.modelElements = {}
	for index, value in pairs(elements) do
		self.modelElements[index] = value
	end

	self.initiated = false
	self.elementType = "Slider"
	self.subType = settings.ElementType
	self.actions = {}
	self.model = model
	self.model.Name = idName
	self.idName = idName

	self.cooldownTime = settings.Cooldown
	self.value = settings.StartingValue
	self.locked = settings.Locked
	self.isActive = false

	self.modelElements.Drag.AnchorPoint = Vector2.new(0.5,0.5)

	self.modelElements.MobileDetect = Instance.new("Frame")
	self.modelElements.MobileDetect.AnchorPoint = Vector2.new(0.5,0.5)
	self.modelElements.MobileDetect.position = UDim2.fromScale(0.5,0.5)
	self.modelElements.MobileDetect.Size = UDim2.fromScale(settings.SliderArea,settings.SliderArea)
	self.modelElements.MobileDetect.BackgroundTransparency = 1
	self.modelElements.MobileDetect.ZIndex = math.huge
	self.modelElements.MobileDetect.Name = "MobileDetect"
	self.modelElements.MobileDetect.Parent = self.modelElements.Total

	if self.subType == "Numeric" then
		self:DisplayAnimFunc(self.value)
	elseif self.subType == "Text" then
		self:DisplayAnimFunc(table.find(self.textValues,self.value) - 1)
	end

	return self
end

--[=[
	@within Slider
	
	should be called only via Form:InitAll().
]=]

function Slider:Init() -- should be called only via Form:InitAll()
	if self.initiated == false then
		self.initiated = true
		local function Change(LegitimateValue)
			if LegitimateValue ~= self.value then
				self:DisplayAnimFunc(LegitimateValue)
				self.value = LegitimateValue
				self:ExecuteActions()
			end
		end
		local function Update()
			local total:GuiObject = self.modelElements.Total
			local mousePos = UserInputService:GetMouseLocation()
			local legitimatePositions = {
				from = total.AbsolutePosition.X,
				to = total.AbsolutePosition.X + total.AbsoluteSize.X
			}
			if mousePos.X > legitimatePositions.from and mousePos.X < legitimatePositions.to then
				local legitimateValue = math.clamp((mousePos.X - legitimatePositions.from) / (legitimatePositions.to - legitimatePositions.from),0,1)
				legitimateValue = legitimateValue * (self.maxValue - self.minValue) + self.minValue
				if legitimateValue < 0.5 then
					legitimateValue = math.floor(legitimateValue)
				else
					legitimateValue = math.ceil(legitimateValue)
				end
				if legitimateValue % self.stepBy == 0 then
					Change(legitimateValue)
				else
					local leftOver = legitimateValue % self.stepBy
					if leftOver > self.stepBy / 2 then
						legitimateValue = math.ceil(legitimateValue / self.stepBy) * self.stepBy
						Change(legitimateValue)
					else
						legitimateValue = math.floor(legitimateValue / self.stepBy) * self.stepBy
						Change(legitimateValue)
					end
				end
			elseif mousePos.X < legitimatePositions.from then
				local LegitimateValue = self.minValue
				Change(LegitimateValue)
			elseif mousePos.X > legitimatePositions.to then
				local LegitimateValue = self.maxValue
				Change(LegitimateValue)
			end
		end
		local function Allow(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and self.isActive == false and self.locked == false then
				return true
			end
			return false
		end

		self.modelElements.Drag.InputBegan:Connect(function(input)
			if Allow(input) then
				self.isActive = true
				RunService:BindToRenderStep(self.idName .. "SliderFunc",Enum.RenderPriority.Input.value,Update)
			end
		end)

		self.modelElements.Drag.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				RunService:UnbindFromRenderStep(self.idName .. "SliderFunc")
				self.isActive = false
			end
		end)

		self.modelElements.MobileDetect.InputBegan:Connect(function(input)
			if Allow(input) then
				self.isActive = true
				RunService:BindToRenderStep(self.idName .. "SliderFunc",Enum.RenderPriority.Input.value,Update)
			end
		end)

		self.modelElements.MobileDetect.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				RunService:UnbindFromRenderStep(self.idName .. "SliderFunc")
				self.isActive = false
			end
		end)
	end
end

--[=[
	@within Slider
	
	Adds action that will be executed on every value change.
]=]

function Slider:AddAction(actionName: string, action: any)
	self.actions[actionName] = action
end

--[=[
	@within Slider
	
	Removes action that would be executed on every value change.
]=]

function Slider:RemoveAction(actionName: string)
	table.remove(self.actions,actionName)
end

--[=[
	@within Slider
	@private
	Private Function, should not be called.
]=]

function Slider:ExecuteActions()
	for index, action in pairs(self.actions) do
		action()
	end
end

--[=[
	@within Slider
	@return <boolean,string> -- [value and idName of the object]
	Returns value and idName of the object.
]=]

function Slider:ReturnValues()
	return self.value, self.idName
end

--[=[
	@within Slider
	
	Changes the Slider.locked property.
]=]

function Slider:LockStatus(status: boolean)
	self.locked = status
end

--[=[
	@within Slider
	
	Sets the Parent of the Slider.model.
]=]

function Slider:Append(where: any)
	self.model.Parent = where
end

--[=[
	@within Slider
	@private
	Private Function, should not be called.
]=]

function Slider:DisplayAnimFunc(value: number) -- internal private function, do not call
	local function ConvertToAbsolute(value: number)
		local clampedValue = math.clamp(value, self.minValue, self.maxValue)
		local rangeCustom = self.maxValue - self.minValue
		local proportion = (clampedValue - self.minValue) / rangeCustom
		return proportion * 100
	end
	local drag:GuiButton = self.modelElements.Drag
	local progressBar:GuiObject = self.modelElements.ProgressBar
	local showText:GuiObject = self.modelElements.ShowText
	local tweenInfoToUse = TweenInfo.new(0.05,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	TweenService:Create(drag,tweenInfoToUse,{position = UDim2.fromScale(ConvertToAbsolute(value) / 100,0.5)}):Play()
	TweenService:Create(progressBar,tweenInfoToUse,{Size = UDim2.fromScale(ConvertToAbsolute(value	) / 100,1)}):Play()
	if self.subType == "Numeric" then
		showText.Text = value
	elseif self.subType == "Text" then
		showText.Text = self.textValues[value + 1]
	end
end

--[=[
	@within Slider
	@private
	Private Function, should not be called.
]=]

function Slider:PerfectClone(trueModel: any, trueElements: {any}) -- internal private function, do not call (also; not quite perfect)
	local model = trueModel:Clone()
	local elements = {}
	for index, element in pairs(trueElements) do
		local path = string.split(element,".")
		local followedPath = model
		for Index2, value in pairs(path) do
			followedPath = followedPath[value]
		end
		elements[index] = followedPath
	end
	return model, elements
end

--[=[
	@within Slider
	Destructor for Slider object.
]=]

function Slider:Destroy()
	self.model:Destroy()
	for index, value in pairs(self) do
		value = nil
	end
end


return Slider
