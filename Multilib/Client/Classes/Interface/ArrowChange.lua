local Mtypes = require(script.Parent.Parent.Parent.Parent.Types)
local MInstance = require(script.Parent.Parent.Parent.Parent.Shared.Components.Instance)
local ArrowChange = {}
ArrowChange.__index = ArrowChange

--[=[
	@class ArrowChange
	@client
	Class for ArrowChange object.
]=]

--[=[
	@within ArrowChange
	@return <table> -- [ArrowChange Object]
	Constructor for ArrowChange object.
]=]

function ArrowChange.new(model: any, elements: {GuiObject}, IdName: string, useSettings: Mtypes.ArrowChange?)
	local self = setmetatable({}, ArrowChange)

	useSettings = useSettings or {}
	useSettings.Locked = useSettings.Locked or false
	useSettings.Cooldown = useSettings.Cooldown or 0.25
	useSettings.Values = useSettings.Values or {"first","second","Third"}
	useSettings.StartingIndex = useSettings.StartingIndex or 1

	if useSettings.OverrideDisplayAnimation ~= nil then
		self._DisplayAnimFunc = useSettings.OverrideDisplayAnimation 
	end

	model, elements = MInstance:PerfectClone(model,elements)

	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end

	if useSettings.StartingIndex < 1 or useSettings.StartingIndex > #useSettings.Values then
		useSettings.StartingIndex = 1
	end

	self.ActualIndex = useSettings.StartingIndex
	self.Values = useSettings.Values

	self._IsCooldown = false
	self.Initiated = false
	self.ElementType = "ArrowChange"
	self.Actions = {}

	self._Model = model
	self._Model.Name = IdName
	self.IdName = IdName

	self.CooldownTime = useSettings.Cooldown
	self.Value = useSettings.StartingValue
	self.Locked = useSettings.Locked

	self:_DisplayAnimFunc()

	return self
end

--[=[
	@within ArrowChange
	
	should be called only via Form:InitAll().
]=]

function ArrowChange:Init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self._ModelElements.Left.Activated:Connect(function()
			if self.Locked == false then
				if self.ActualIndex - 1 == 0 then
					self.ActualIndex = #self.Values
				else
					self.ActualIndex -= 1
				end
				self:_DisplayAnimFunc()
				self:_ExecuteActions()
			end
		end)
		self._ModelElements.Right.Activated:Connect(function()
			if self.Locked == false then
				if self.ActualIndex + 1 > #self.Values then
					self.ActualIndex = 1
				else
					self.ActualIndex += 1
				end
				self:_DisplayAnimFunc()
				self:_ExecuteActions()
			end
		end)
	end
end

--[=[
	@within ArrowChange
	
	Updates the values and index (optional).
]=]

function ArrowChange:UpdateValues(values: any, index: number?)
	index = index or self.ActualIndex

	if index < 1 or index > #values then
		index = 1
	else
		index = self.ActualIndex
	end

	self.Values = values
	self.ActualIndex = index
	self:_DisplayAnimFunc()
	self:_ExecuteActions()
end

--[=[
	@within ArrowChange
	@return <boolean,string> -- [value and IdName of the object]
	Returns value and IdName of the object.
]=]

function ArrowChange:ReturnValues()
	return self.Values[self.ActualIndex], self.IdName
end

--[=[
	@within ArrowChange
	
	Changes the ArrowChange.locked property.
]=]

function ArrowChange:LockStatus(status: boolean)
	self.Locked = status
end

--[=[
	@within ArrowChange
	
	Sets the Parent of the ArrowChange.model.
]=]

function ArrowChange:Append(where: any)
	self._Model.Parent = where
end

--[=[
	@within ArrowChange
	@private
	Private Function, should not be called.
]=]

function ArrowChange:_DisplayAnimFunc() -- internal private function, do not call
	self._ModelElements.TextLabel.Text = self.Values[self.ActualIndex]
end

--[=[
	@within ArrowChange
	
	Adds action that will be executed on every value change.
]=]

function ArrowChange:AddAction(actionName: string, action: any)
	self.Actions[actionName] = action
end

--[=[
	@within ArrowChange
	
	Removes action that would be executed on every value change.
]=]

function ArrowChange:RemoveAction(actionName: string)
	table.remove(self.Actions,actionName)
end

--[=[
	@within ArrowChange
	@private
	Private Function, should not be called.
]=]

function ArrowChange:_ExecuteActions()
	for _, action in self.Actions do
		action()
	end
end

--[=[
	@within ArrowChange
	Destructor for ArrowChange object.
]=]

function ArrowChange:Destroy()
	self._Model:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end


return ArrowChange
