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

function Slider.new(Model: any, Elements: table, IDName: string, Settings: table)
	local self = setmetatable({}, Slider)

	if Settings == nil then Settings = {} end
	if Settings.Type == nil then Settings.Type = "Numeric" end
	if Settings.SliderArea == nil then Settings.SliderArea = 1.25 end
	if Settings.Type == "Numeric" then
		if Settings.StartingValue == nil then
			Settings.StartingValue = 50
			self.StartingValue = Settings.StartingValue
		else
			self.StartingValue = Settings.StartingValue
		end
		if Settings.MinValue == nil then
			Settings.MinValue = 0
			self.MinValue = Settings.MinValue
		else
			self.MinValue = Settings.MinValue
		end
		if Settings.MaxValue == nil then
			Settings.MaxValue = 100
			self.MaxValue = Settings.MaxValue
		else
			self.MaxValue = Settings.MaxValue
		end
		if Settings.StepBy == nil then
			Settings.StepBy = 5
			self.StepBy = Settings.StepBy
		else
			self.StepBy = Settings.StepBy
		end
	elseif Settings.Type == "Text" then
		if Settings.TextValues == nil then
			Settings.TextValues = {"FirstValue","StartingValue","LastValue"}
			self.TextValues = Settings.TextValues
		else
			self.TextValues = Settings.TextValues
		end
		if Settings.StartingValue == nil then
			Settings.StartingValue = Settings.TextValues[1]
			self.StartingValue = Settings.StartingValue
		else
			self.StartingValue = Settings.StartingValue
		end
		self.StepBy =  1
		self.MinValue = 0
		self.MaxValue = #Settings.TextValues - 1
	end

	if Settings.Locked == nil then Settings.Locked = false end

	local Model, Elements = self:perfectClone(Model,Elements)

	self.ModelElements = {}
	for Index, Value in pairs(Elements) do
		self.ModelElements[Index] = Value
	end

	self.Initiated = false
	self.Type = "Slider"
	self.SubType = Settings.Type
	self.Actions = {}
	self.Model = Model
	self.Model.Name = IDName
	self.IDName = IDName

	self.CooldownTime = Settings.Cooldown
	self.Value = Settings.StartingValue
	self.Locked = Settings.Locked
	self.Active = false

	self.ModelElements.Drag.AnchorPoint = Vector2.new(0.5,0.5)

	self.ModelElements.MobileDetect = Instance.new("Frame")
	self.ModelElements.MobileDetect.AnchorPoint = Vector2.new(0.5,0.5)
	self.ModelElements.MobileDetect.Position = UDim2.fromScale(0.5,0.5)
	self.ModelElements.MobileDetect.Size = UDim2.fromScale(Settings.SliderArea,Settings.SliderArea)
	self.ModelElements.MobileDetect.BackgroundTransparency = 1
	self.ModelElements.MobileDetect.ZIndex = math.huge
	self.ModelElements.MobileDetect.Name = "MobileDetect"
	self.ModelElements.MobileDetect.Parent = self.ModelElements.Total

	if self.SubType == "Numeric" then
		self:displayAnimFunc(self.Value)
	elseif self.SubType == "Text" then
		self:displayAnimFunc(table.find(self.TextValues,self.Value) - 1)
	end

	return self
end

--[=[
	@within Slider
	
	should be called only via Form:InitAll().
]=]

function Slider:init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		local function Change(LegitimateValue)
			if LegitimateValue ~= self.Value then
				self:displayAnimFunc(LegitimateValue)
				self.Value = LegitimateValue
				self:executeActions()
			end
		end
		local function Update()
			local Total:GuiObject = self.ModelElements.Total
			local MousePos = UserInputService:GetMouseLocation()
			local LegitimatePositions = {
				From = Total.AbsolutePosition.X,
				To = Total.AbsolutePosition.X + Total.AbsoluteSize.X
			}
			if MousePos.X > LegitimatePositions.From and MousePos.X < LegitimatePositions.To then
				local LegitimateValue = math.clamp((MousePos.X - LegitimatePositions.From) / (LegitimatePositions.To - LegitimatePositions.From),0,1)
				LegitimateValue = LegitimateValue * (self.MaxValue - self.MinValue) + self.MinValue
				if LegitimateValue < 0.5 then
					LegitimateValue = math.floor(LegitimateValue)
				else
					LegitimateValue = math.ceil(LegitimateValue)
				end
				if LegitimateValue % self.StepBy == 0 then
					Change(LegitimateValue)
				else
					local LeftOver = LegitimateValue % self.StepBy
					if LeftOver > self.StepBy / 2 then
						LegitimateValue = math.ceil(LegitimateValue / self.StepBy) * self.StepBy
						Change(LegitimateValue)
					else
						LegitimateValue = math.floor(LegitimateValue / self.StepBy) * self.StepBy
						Change(LegitimateValue)
					end
				end
			elseif MousePos.X < LegitimatePositions.From then
				local LegitimateValue = self.MinValue
				Change(LegitimateValue)
			elseif MousePos.X > LegitimatePositions.To then
				local LegitimateValue = self.MaxValue
				Change(LegitimateValue)
			end
		end
		local function Allow(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch and self.IsActive == false and self.Locked == false then
				return true
			end
			return false
		end

		self.ModelElements.Drag.InputBegan:Connect(function(input)
			if Allow(input) then
				self.IsActive = true
				RunService:BindToRenderStep(self.IDName .. "SliderFunc",Enum.RenderPriority.Input.Value,Update)
			end
		end)

		self.ModelElements.Drag.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				RunService:UnbindFromRenderStep(self.IDName .. "SliderFunc")
				self.IsActive = false
			end
		end)

		self.ModelElements.MobileDetect.InputBegan:Connect(function(input)
			if Allow(input) then
				self.IsActive = true
				RunService:BindToRenderStep(self.IDName .. "SliderFunc",Enum.RenderPriority.Input.Value,Update)
			end
		end)

		self.ModelElements.MobileDetect.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				RunService:UnbindFromRenderStep(self.IDName .. "SliderFunc")
				self.IsActive = false
			end
		end)
	end
end

--[=[
	@within Slider
	
	Adds action that will be executed on every value change.
]=]

function Slider:addAction(ActionName: string, Action: any)
	self.Actions[ActionName] = Action
end

--[=[
	@within Slider
	
	Removes action that would be executed on every value change.
]=]

function Slider:removeAction(ActionName: string)
	table.remove(self.Actions,ActionName)
end

--[=[
	@within Slider
	@private
	Private Function, should not be called.
]=]

function Slider:executeActions()
	for Index, Action in pairs(self.Actions) do
		Action()
	end
end

--[=[
	@within Slider
	@return <boolean,string> -- [Value and IDName of the object]
	Returns value and IDName of the object.
]=]

function Slider:returnValues()
	return self.Value, self.IDName
end

--[=[
	@within Slider
	
	Changes the Slider.Locked property.
]=]

function Slider:lockStatus(Status: boolean)
	self.Locked = Status
end

--[=[
	@within Slider
	
	Sets the parent of the Slider.Model.
]=]

function Slider:append(Where: any)
	self.Model.Parent = Where
end

--[=[
	@within Slider
	@private
	Private Function, should not be called.
]=]

function Slider:displayAnimFunc(Value: number) -- internal private function, do not call
	local function convertToAbsolute(Value: number)
		local ClampedValue = math.clamp(Value, self.MinValue, self.MaxValue)
		local RangeCustom = self.MaxValue - self.MinValue
		local Proportion = (ClampedValue - self.MinValue) / RangeCustom
		return Proportion * 100
	end
	local Drag:GuiButton = self.ModelElements.Drag
	local ProgressBar:GuiObject = self.ModelElements.ProgressBar
	local ShowText:GuiObject = self.ModelElements.ShowText
	local TweenInfoToUse = TweenInfo.new(0.05,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	TweenService:Create(Drag,TweenInfoToUse,{Position = UDim2.fromScale(convertToAbsolute(Value) / 100,0.5)}):Play()
	TweenService:Create(ProgressBar,TweenInfoToUse,{Size = UDim2.fromScale(convertToAbsolute(Value	) / 100,1)}):Play()
	if self.SubType == "Numeric" then
		ShowText.Text = Value
	elseif self.SubType == "Text" then
		ShowText.Text = self.TextValues[Value + 1]
	end
end

--[=[
	@within Slider
	@private
	Private Function, should not be called.
]=]

function Slider:perfectClone(TrueModel: any, TrueElements: table) -- internal private function, do not call (also; not quite perfect)
	local Model = TrueModel:Clone()
	local Elements = {}
	for Index, Element in pairs(TrueElements) do
		local Path = string.split(Element,".")
		local FollowedPath = Model
		for Index2, Value in pairs(Path) do
			FollowedPath = FollowedPath[Value]
		end
		Elements[Index] = FollowedPath
	end
	return Model, Elements
end

--[=[
	@within Slider
	Destructor for Slider object.
]=]

function Slider:destroy()
	self.Model:Destroy()
	for Index, Value in pairs(self) do
		Value = nil
	end
end


return Slider
