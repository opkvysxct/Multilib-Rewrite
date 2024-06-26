local RadioGroup = {}
RadioGroup.__index = RadioGroup

--[=[
	@class RadioGroup
	@client
	Class for RadioGroup object.
]=]

--[=[
	@within RadioGroup
	@return <table> -- [RadioGroup Object]
	Constructor for RadioGroup object.
]=]

function RadioGroup.new(IdName: string)
	local self = setmetatable({}, RadioGroup)
	self.RadioButtons = {}
	self.Actions = {}
	self.IdName = IdName
	self.Selected = nil
	return self
end

--[=[
	@within RadioGroup
	
	should be called only via Form:InitAll().
]=]

function RadioGroup:Init() -- should be called only via Form:InitAll()
	for _, radioButton in self.RadioButtons do
		radioButton:Init()
	end
end

--[=[
	@within RadioGroup
	@return <string,string> -- [IdName of Selected and IdName of the object]
	Returns IdName of Selected and IdName of the object.
]=]

function RadioGroup:ReturnValues()
	if self.Selected ~= nil then
		return self.Selected, self.IdName
	else
		return false, self.IdName
	end
end

--[=[
	@within RadioGroup
	Inserts element into the RadioGroup.RadioButtons table.
]=]

function RadioGroup:InsertElement<T>(element: any)
	self.RadioButtons[element.IdName] = element
end

--[=[
	@within RadioGroup
	Inserts multiple elements into the RadioGroup.RadioButtons table.
]=]

function RadioGroup:InsertElements(elements: {})
	for _, element in elements do
		self.RadioButtons[element.IdName] = element
	end
end

--[=[
	@within RadioGroup
	Removes element from the RadioGroup.RadioButtons table.
]=]

function RadioGroup:ClearElement(ElementName: string)
	self.RadioButtons[ElementName] = nil
end

--[=[
	@within RadioGroup
	Clears the RadioGroup.RadioButtons table.
]=]

function RadioGroup:ClearAllElements()
	table.clear(self.RadioButtons)
end

--[=[
	@within RadioGroup
	Sets the Parent of every radioButton.
]=]

function RadioGroup:Append<T>(where: T)
	for _, radioButton in self.RadioButtons do
		radioButton:Append(where)
	end
end

--[=[
	@within RadioGroup
	
	Adds action that will be executed on every value change.
]=]

function RadioGroup:AddAction(actionName: string, action: any)
	self.Actions[actionName] = action
end

--[=[
	@within RadioGroup
	
	Removes action that would be executed on every value change.
]=]

function RadioGroup:RemoveAction(actionName: string)
	self.Actions[actionName] = nil
end

--[=[
	@within RadioGroup
	@private
	Private Function, should not be called.
]=]

function RadioGroup:_ExecuteActions()
	for _, action in self.Actions do
		action()
	end
end


--[=[
	@within RadioGroup
	@private
	Selects one button and deselects all the others.
]=]

function RadioGroup:selectButton(radioButtonObject: any)
	self.Selected = radioButtonObject.IdName
	for _, radioButton in self.RadioButtons do
		if radioButton.isSelected == true and radioButton ~= radioButtonObject then
			radioButton:selectionStatus(false)
		end
	end
	radioButtonObject:selectionStatus(true)
	self:_ExecuteActions()
end

--[=[
	@within RadioGroup
	Destructor for RadioGroup object.
]=]

function RadioGroup:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end


return RadioGroup
