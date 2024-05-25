local Mtypes = require(game:GetService("ReplicatedStorage").Multilib.Types)
local MInstance = require(game:GetService("ReplicatedStorage").Multilib.Shared.Components.Instance)
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

function ArrowChange.new(model: any, elements: {GuiObject}, IdName: string, settings: Mtypes.ArrowChange?)
	local self = setmetatable({}, ArrowChange)

	if settings == nil then settings = {} end
	if settings.Locked == nil then settings.Locked = false end
	if settings.Cooldown == nil then settings.Cooldown = 0.25 end
	if settings.OverrideDisplayAnimation ~= nil then self._DisplayAnimFunc = settings.OverrideDisplayAnimation end
	if settings.Values == nil then settings.Values = {"first","second","Third"} end
	if settings.StartingIndex == nil then settings.StartingIndex = 1 end

	local model, elements = MInstance:PerfectClone(model,elements)

	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end

	if settings.StartingIndex < 1 or settings.StartingIndex > #settings.Values then
		settings.StartingIndex = 1
	end

	self.ActualIndex = settings.StartingIndex
	self.Values = settings.Values

	self._IsCooldown = false
	self.Initiated = false
	self.ElementType = "ArrowChange"
	self.Actions = {}

	self._Model = model
	self._Model.Name = IdName
	self.IdName = IdName

	self.CooldownTime = settings.Cooldown
	self.Value = settings.StartingValue
	self.Locked = settings.Locked

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
	if index == nil then index = self.ActualIndex end

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
	for index, action in self.Actions do
		action()
	end
end

--[=[
	@within ArrowChange
	Destructor for ArrowChange object.
]=]

function ArrowChange:Destroy()
	self._Model:Destroy()
	for _, value in self do
		value = nil
	end
end


return ArrowChange
