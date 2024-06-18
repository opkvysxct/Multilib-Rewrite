local Mtypes = require(script.Parent.Parent.Parent.Parent.Types)
local MInstance = require(script.Parent.Parent.Parent.Parent.Shared.Components.Instance)
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

function RadioButton.new(model: any, elements: {GuiObject}, IdName: string, radioGroup: {any}, useSettings: Mtypes.RadioButton?)
	local self = setmetatable({}, RadioButton)

	useSettings = useSettings or {}
	useSettings.Locked = useSettings.Locked or false
	useSettings.Cooldown = useSettings.Cooldown or 0.25

	if useSettings.OverrideDisplayAnimation ~= nil then
		self._DisplayAnimFunc = useSettings.OverrideDisplayAnimation 
	end

	model, elements = MInstance:PerfectClone(model,elements)

	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end


	self._IsCooldown = false
	self.Initiated = false
	self.ElementType = "RadioButton"
	self.IsSelected = false

	self._Model = model
	self._Model.Name = IdName
	self.IdName = IdName
	self.radioGroup = radioGroup

	self.CooldownTime = useSettings.Cooldown
	self.Locked = useSettings.Locked

	self.radioGroup:InsertElement(self)
	self:_DisplayAnimFunc(false)

	return self
end

--[=[
	@within RadioButton
	
	should be called only via Form:InitAll().
]=]

function RadioButton:Init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self._ModelElements.Button.Activated:Connect(function()
			if self.Locked == false and self._IsCooldown == false then
				self._IsCooldown = true
				task.delay(self.CooldownTime,function()
					self._IsCooldown = false
				end)
				if self.IsSelected == false then
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
	self.Locked = status
end

--[=[
	@within RadioButton
	
	Sets the Parent of the RadioButton.model.
]=]

function RadioButton:Append(where: any)
	self._Model.Parent = where
end

--[=[
	@within RadioButton
	@private
	Private Function, should not be called.
]=]

function RadioButton:_DisplayAnimFunc(value: boolean) -- internal private function, do not call
	self._ModelElements.Check.Visible = value
end

--[=[
	@within RadioButton
	@private
	Changes selection status.
]=]

function RadioButton:selectionStatus(value: boolean)
	self.IsSelected = value
	self:_DisplayAnimFunc(value)
end

--[=[
	@within RadioButton
	Destructor for RadioButton object.
]=]

function RadioButton:Destroy()
	self._Model:Destroy()
	self = nil
end


return RadioButton
