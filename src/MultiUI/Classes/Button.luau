local Mtypes = require(script.Parent.Parent.Types)
local PerfectClone = require(script.Parent.Parent.PerfectClone)
local Button = {}
Button.__index = Button

--[=[
	@class Button
	@client
	Class for Button object.
]=]

--[=[
	@within Button
	@return <table> -- [Button Object]
	Constructor for Button object.
]=]

function Button.new(model: GuiObject, elements: {GuiObject}, IdName: string, uiOrder: number, useSettings: Mtypes.Button)
	local self = setmetatable({}, Button)
	local trueSettings = {}

	useSettings = useSettings or table.clone(Mtypes.TButton)
	trueSettings.Locked = useSettings.Locked or false
	trueSettings.Cooldown = useSettings.Cooldown or 0.25

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
	self.ElementType = "Button"
	self.Actions = {}

	self._Model = model
	self._Model.Name = IdName
	self.IdName = IdName

	self.CooldownTime = trueSettings.Cooldown
	self.Locked = trueSettings.Locked

	return self
end

--[=[
	@within Button
	
	should be called only via Form:InitAll().
]=]

function Button:Init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self._ModelElements.Button.Activated:Connect(function()
			if self.Locked == false and self._IsCooldown == false then
				self._IsCooldown = true
				task.delay(self.CooldownTime,function()
					self._IsCooldown = false
				end)
				self:_DisplayAnimFunc(true)
				self:_ExecuteActions()
			end
		end)
	end
end

--[=[
	@within Button
	@return <boolean,string> -- [value and IdName of the object]
	Returns value and IdName of the object.
]=]

function Button:ReturnValues()
	return self.Value, self.IdName
end

--[=[
	@within Button
	
	Changes the Button.locked property.
]=]

function Button:LockStatus(status: boolean)
	self.Locked = status
end

--[=[
	@within Button
	
	Sets the Parent of the Button.model.
]=]

function Button:Append(where: any)
	self._Model.Parent = where
end

--[=[
	@within Button
	@private
	Private Function, should not be called.
]=]

function Button:_DisplayAnimFunc() -- internal private function, do not call
	
end

--[=[
	@within Button
	
	Adds action that will be executed on every value change.
]=]

function Button:AddAction(actionName: string, action: any)
	self.Actions[actionName] = action
end

--[=[
	@within Button
	
	Removes action that would be executed on every value change.
]=]

function Button:RemoveAction(actionName: string)
	self.Actions[actionName] = nil
end

--[=[
	@within Button
	@private
	Private Function, should not be called.
]=]

function Button:_ExecuteActions()
	for _, action in self.Actions do
		action()
	end
end

--[=[
	@within Button
	Destructor for Button object.
]=]

function Button:Destroy()
	self._Model:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end


return Button
