local Mtypes = require(game:GetService("ReplicatedStorage").Multilib.Types)
local MInstance = require(game:GetService("ReplicatedStorage").Multilib.Shared.Components.Instance)
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

function CheckBox.new(model: any, elements: {GuiObject}, idName: string, settings: Mtypes.CheckBox?)
	local self = setmetatable({}, CheckBox)

	if settings == nil then settings = {} end
	if settings.Locked == nil then settings.Locked = false end
	if settings.Cooldown == nil then settings.Cooldown = 0.25 end
	if settings.OverrideDisplayAnimation ~= nil then self._DisplayAnimFunc = settings.OverrideDisplayAnimation end

	local model, elements = MInstance:PerfectClone(model,elements)

	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end


	self._IsCooldown = false
	self.Initiated = false
	self.ElementType = "Checkbox"
	self.Actions = {}

	self.Model = model
	self.Model.Name = idName
	self.IdName = idName

	self.CooldownTime = settings.Cooldown
	self.Value = settings.StartingValue
	self.Locked = settings.Locked

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
	@return <boolean,string> -- [value and idName of the object]
	Returns value and idName of the object.
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
	self.Model.Parent = where
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
	table.remove(self.Actions,actionName)
end

--[=[
	@within CheckBox
	@private
	Private Function, should not be called.
]=]

function CheckBox:_ExecuteActions()
	for index, action in self.Actions do
		action()
	end
end

--[=[
	@within CheckBox
	Destructor for CheckBox object.
]=]

function CheckBox:Destroy()
	self.Model:Destroy()
	for index, value in self do
		value = nil
	end
end


return CheckBox
