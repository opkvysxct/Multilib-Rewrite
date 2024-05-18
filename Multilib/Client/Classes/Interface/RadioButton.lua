local Multilib = require(game:GetService("ReplicatedStorage").Multilib)
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

function RadioButton.new(model: any, elements: {GuiObject}, idName: string, radioGroup: {any}, settings: Multilib.RadioButton?)
	local self = setmetatable({}, RadioButton)

	if settings == nil then settings = {} end
	if settings.Locked == nil then settings.Locked = false end
	if settings.Cooldown == nil then settings.Cooldown = 0.25 end
	if settings.OverrideDisplayAnimation ~= nil then self.DisplayAnimFunc = settings.OverrideDisplayAnimation end

	local model, elements = self:PerfectClone(model,elements)

	self.modelElements = {}
	for index, value in pairs(elements) do
		self.modelElements[index] = value
	end


	self.isCooldown = false
	self.initiated = false
	self.elementType = "RadioButton"
	self.isSelected = false

	self.model = model
	self.model.Name = idName
	self.idName = idName
	self.radioGroup = radioGroup

	self.cooldownTime = settings.Cooldown
	self.locked = settings.Locked

	self.radioGroup:InsertElement(self)
	self:DisplayAnimFunc(false)

	return self
end

--[=[
	@within RadioButton
	
	should be called only via Form:InitAll().
]=]

function RadioButton:Init() -- should be called only via Form:InitAll()
	if self.initiated == false then
		self.initiated = true
		self.modelElements.Button.Activated:Connect(function()
			if self.locked == false and self.isCooldown == false then
				self.isCooldown = true
				task.delay(self.cooldownTime,function()
					self.isCooldown = false
				end)
				if self.isSelected == false then
					self.radioGroup:selectButton(self)
				end
			end
		end)
	end
end

--[=[
	@within RadioButton
	
	Changes the RadioButton.locked property.
]=]

function RadioButton:LockStatus(status: boolean)
	self.locked = status
end

--[=[
	@within RadioButton
	
	Sets the Parent of the RadioButton.model.
]=]

function RadioButton:Append(where: any)
	self.model.Parent = where
end

--[=[
	@within RadioButton
	@private
	Private Function, should not be called.
]=]

function RadioButton:DisplayAnimFunc(value: boolean) -- internal private function, do not call
	self.modelElements.Check.Visible = value
end

--[=[
	@within RadioButton
	@private
	Private Function, should not be called.
]=]

function RadioButton:PerfectClone(trueModel: any, trueElements: {any}) -- internal private function, do not call (also; not quite perfect)
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
	@within RadioButton
	@private
	Changes selection status.
]=]

function RadioButton:selectionStatus(value: boolean)
	self.isSelected = value
	self:DisplayAnimFunc(value)
end

--[=[
	@within RadioButton
	Destructor for RadioButton object.
]=]

function RadioButton:Destroy()
	self.model:Destroy()
	for index, value in pairs(self) do
		value = nil
	end
end


return RadioButton
