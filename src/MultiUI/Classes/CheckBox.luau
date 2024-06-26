local Mtypes = require(script.Parent.Parent.Types)
local PerfectClone = require(script.Parent.Parent.PerfectClone)
local CheckBox = {}
CheckBox.__index = CheckBox

--[=[
	@class CheckBox
	@client
	Class for CheckBox object.
]=]

--[=[
	@within CheckBox
	@return <table> -- [Checkbox Object]
	Constructor for CheckBox object.
]=]

function CheckBox.new(model: GuiObject, elements: {GuiObject}, IdName: string, uiOrder: number, useSettings: Mtypes.CheckBox)
	local self = setmetatable({}, CheckBox)
	local trueSettings = {}

	useSettings = useSettings or table.clone(Mtypes.TCheckBox)
	trueSettings.Locked = useSettings.Locked or false
	trueSettings.Cooldown = useSettings.Cooldown or 0.25
	trueSettings.StartingValue = useSettings.StartingValue or false

	if useSettings.OverrideDisplayAnimation ~= nil then
		self._DisplayAnimFunc = useSettings.OverrideDisplayAnimation 
	end
	
	model, elements = PerfectClone(model,elements)
	model.LayoutOrder = uiOrder
	
	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end


	self._IsCooldown = false
	self.Initiated = false
	self.ElementType = "Checkbox"
	self.Actions = {}

	self._Model = model
	self._Model.Name = IdName
	self.IdName = IdName

	self.CooldownTime = trueSettings.Cooldown
	self.Value = trueSettings.StartingValue
	self.Locked = trueSettings.Locked

	return self
end

--[=[
	@within CheckBox
	
	should be called only via Form:InitAll().
]=]

function CheckBox:Init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self._ModelElements.Button.Activated:Connect(function()
			if self.Locked == false and self._IsCooldown == false then
				self._IsCooldown = true
				task.delay(self.CooldownTime,function()
					self._IsCooldown = false
				end)
				if self.Value == false then
					self.Value = true
					self:_DisplayAnimFunc(true)
					self:_ExecuteActions()
				else
					self.Value = false
					self:_DisplayAnimFunc(false)
					self:_ExecuteActions()
				end
			end
		end)
	end
end

--[=[
	@within CheckBox
	@return <boolean,string> -- [value and IdName of the object]
	Returns value and IdName of the object.
]=]

function CheckBox:ReturnValues()
	return self.Value, self.IdName
end

--[=[
	@within CheckBox
	
	Changes the CheckBox.locked property.
]=]

function CheckBox:LockStatus(status: boolean)
	self.Locked = status
end

--[=[
	@within CheckBox
	
	Sets the Parent of the CheckBox.model.
]=]

function CheckBox:Append(where: any)
	self._Model.Parent = where
end

--[=[
	@within CheckBox
	@private
	Private Function, should not be called.
]=]

function CheckBox:_DisplayAnimFunc(value: boolean) -- internal private function, do not call
	self._ModelElements.Check.Visible = value
end

--[=[
	@within CheckBox
	
	Adds action that will be executed on every value change.
]=]

function CheckBox:AddAction(actionName: string, action: any)
	self.Actions[actionName] = action
end

--[=[
	@within CheckBox
	
	Removes action that would be executed on every value change.
]=]

function CheckBox:RemoveAction(actionName: string)
	self.Actions[actionName] = nil
end

--[=[
	@within CheckBox
	@private
	Private Function, should not be called.
]=]

function CheckBox:_ExecuteActions()
	for _, action in self.Actions do
		action()
	end
end

--[=[
	@within CheckBox
	Destructor for CheckBox object.
]=]

function CheckBox:Destroy()
	self._Model:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end


return CheckBox
