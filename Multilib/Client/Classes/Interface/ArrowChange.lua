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

function ArrowChange.new(model: any, elements: table, idName: string, settings: table?)
	local self = setmetatable({}, ArrowChange)

	if settings == nil then settings = {} end
	if settings.locked == nil then settings.locked = false end
	if settings.cooldown == nil then settings.cooldown = 0.25 end
	if settings.overrideDisplayAnimation ~= nil then self.DisplayAnimFunc = settings.overrideDisplayAnimation end
	if settings.values == nil then settings.values = {"first","second","Third"} end
	if settings.startingIndex == nil then settings.startingIndex = 1 end

	local model, elements = self:PerfectClone(model,elements)

	self.modelElements = {}
	for index, value in pairs(elements) do
		self.modelElements[index] = value
	end

	if settings.startingIndex < 1 or settings.startingIndex > #settings.values then
		settings.startingIndex = 1
	end

	self.actualIndex = settings.startingIndex
	self.values = settings.values

	self.isCooldown = false
	self.initiated = false
	self.elementType = "ArrowChange"
	self.actions = {}

	self.model = model
	self.model.Name = idName
	self.idName = idName

	self.cooldownTime = settings.cooldown
	self.value = settings.startingValue
	self.locked = settings.locked

	self:DisplayAnimFunc()

	return self
end

--[=[
	@within ArrowChange
	
	should be called only via Form:InitAll().
]=]

function ArrowChange:Init() -- should be called only via Form:InitAll()
	if self.initiated == false then
		self.initiated = true
		self.modelElements.Left.Activated:Connect(function()
			if self.locked == false then
				if self.actualIndex - 1 == 0 then
					self.actualIndex = #self.values
				else
					self.actualIndex -= 1
				end
				self:DisplayAnimFunc()
				self:ExecuteActions()
			end
		end)
		self.modelElements.Right.Activated:Connect(function()
			if self.locked == false then
				if self.actualIndex + 1 > #self.values then
					self.actualIndex = 1
				else
					self.actualIndex += 1
				end
				self:DisplayAnimFunc()
				self:ExecuteActions()
			end
		end)
	end
end

--[=[
	@within ArrowChange
	
	Updates the values and index (optional).
]=]

function ArrowChange:UpdateValues(values: any, index: number?)
	if index == nil then index = self.actualIndex end

	if index < 1 or index > #values then
		index = 1
	else
		index = self.actualIndex
	end

	self.values = values
	self.actualIndex = index
	self:DisplayAnimFunc()
	self:ExecuteActions()
end

--[=[
	@within ArrowChange
	@return <boolean,string> -- [value and idName of the object]
	Returns value and idName of the object.
]=]

function ArrowChange:ReturnValues()
	return self.values[self.actualIndex], self.idName
end

--[=[
	@within ArrowChange
	
	Changes the ArrowChange.locked property.
]=]

function ArrowChange:LockStatus(status: boolean)
	self.locked = status
end

--[=[
	@within ArrowChange
	
	Sets the Parent of the ArrowChange.model.
]=]

function ArrowChange:Append(where: any)
	self.model.Parent = where
end

--[=[
	@within ArrowChange
	@private
	Private Function, should not be called.
]=]

function ArrowChange:DisplayAnimFunc() -- internal private function, do not call
	self.modelElements.TextLabel.Text = self.values[self.actualIndex]
end

--[=[
	@within ArrowChange
	
	Adds action that will be executed on every value change.
]=]

function ArrowChange:AddAction(actionName: string, action: any)
	self.actions[actionName] = action
end

--[=[
	@within ArrowChange
	
	Removes action that would be executed on every value change.
]=]

function ArrowChange:RemoveAction(actionName: string)
	table.remove(self.actions,actionName)
end

--[=[
	@within ArrowChange
	@private
	Private Function, should not be called.
]=]

function ArrowChange:ExecuteActions()
	for index, action in pairs(self.actions) do
		action()
	end
end


--[=[
	@within ArrowChange
	@private
	Private Function, should not be called.
]=]

function ArrowChange:PerfectClone(trueModel: any, trueElements: table) -- internal private function, do not call (also; not quite perfect)
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
	@within ArrowChange
	Destructor for ArrowChange object.
]=]

function ArrowChange:Destroy()
	self.model:Destroy()
	for index, value in pairs(self) do
		value = nil
	end
end


return ArrowChange
