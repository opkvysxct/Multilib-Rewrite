local RadioButton = {}
RadioButton.__index = RadioButton

--[=[
	@class RadioButton
	@client
	Class for RadioButton object.
]=]

--[=[
	@within RadioButton
	@return <table> -- [RadioButton Object]
	Constructor for RadioButton object.
]=]

function RadioButton.new(Model: any, Elements: table, IDName: string, RadioGroup: table, Settings: table)
	local self = setmetatable({}, RadioButton)

	if Settings == nil then Settings = {} end
	if Settings.Locked == nil then Settings.Locked = false end
	if Settings.Cooldown == nil then Settings.Cooldown = 0.25 end
	if Settings.OverrideDisplayAnimation ~= nil then self.displayAnimFunc = Settings.OverrideDisplayAnimation end

	local Model, Elements = self:perfectClone(Model,Elements)

	self.IsCooldown = false
	self.Initiated = false
	self.Type = "RadioButton"
	self.IsSelected = false

	self.Model = Model
	self.Button = Elements.Button
	self.Check = Elements.Check
	self.IDName = IDName
	self.RadioGroup = RadioGroup

	self.CooldownTime = Settings.Cooldown
	self.Locked = Settings.Locked

	self.RadioGroup:insertElement(self)
	self:displayAnimFunc(false)

	return self
end

--[=[
	@within RadioButton
	
	should be called only via Form:InitAll().
]=]

function RadioButton:init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self.Button.Activated:Connect(function()
			self:check()
		end)
	end
end

--[=[
	@within RadioButton
	
	Changes the RadioButton.Locked property.
]=]

function RadioButton:lockStatus(Status: boolean)
	self.Locked = Status
end

--[=[
	@within RadioButton
	
	Sets the parent of the RadioButton.Model.
]=]

function RadioButton:append(Where: any)
	self.Model.Parent = Where
end

--[=[
	@within RadioButton
	@private
	Private Function, should not be called.
]=]

function RadioButton:displayAnimFunc(Value: boolean) -- internal private function, do not call
	self.Check.Visible = Value
end

--[=[
	@within RadioButton
	@private
	Private Function, should not be called.
]=]

function RadioButton:check() -- internal private function, do not call
	if self.Locked == false and self.IsCooldown == false then
		self.IsCooldown = true
		task.delay(self.CooldownTime,function()
			self.IsCooldown = false
		end)
		if self.IsSelected == false then
			self.RadioGroup:selectButton(self)
		end
	end
end

--[=[
	@within RadioButton
	@private
	Private Function, should not be called.
]=]

function RadioButton:perfectClone(TrueModel: any, TrueElements: table) -- internal private function, do not call (also; not quite perfect)
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
	@within RadioButton
	@private
	Changes selection status.
]=]

function RadioButton:selectionStatus(Value: boolean)
	self.IsSelected = Value
	self:displayAnimFunc(Value)
end

--[=[
	@within RadioButton
	Destructor for RadioButton object.
]=]

function RadioButton:destroy()
	for Index, Value in pairs(self) do
		Value = nil
	end
end


return RadioButton
