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
	self.radioButtons = {}
	self.Actions = {}
	self.IdName = IdName
	self.selected = nil
	return self
end

--[=[
	@within RadioGroup
	
	should be called only via Form:InitAll().
]=]

function RadioGroup:Init() -- should be called only via Form:InitAll()
	for index, radioButton in self.radioButtons do
		radioButton:Init()
	end
end

--[=[
	@within RadioGroup
	@return <string,string> -- [IdName of selected and IdName of the object]
	Returns IdName of selected and IdName of the object.
]=]

function RadioGroup:ReturnValues()
	if self.selected ~= nil then
		return self.selected, self.IdName
	else
		return false, self.IdName
	end
end

--[=[
	@within RadioGroup
	Inserts element into the RadioGroup.RadioButtons table.
]=]

function RadioGroup:InsertElement(element: {any})
	self.radioButtons[element.IdName] = element
end

--[=[
	@within RadioGroup
	Inserts multiple elements into the RadioGroup.RadioButtons table.
]=]

function RadioGroup:InsertElements(elements: {any})
	for index, element in elements do
		self.radioButtons[element.IdName] = element
	end
end

--[=[
	@within RadioGroup
	Removes element from the RadioGroup.RadioButtons table.
]=]

function RadioGroup:ClearElement(ElementName: string)
	table.remove(self.radioButtons,ElementName)
end

--[=[
	@within RadioGroup
	Clears the RadioGroup.RadioButtons table.
]=]

function RadioGroup:ClearAllElements()
	table.clear(self.radioButtons)
end

--[=[
	@within RadioGroup
	Sets the Parent of every radioButton.
]=]

function RadioGroup:Append(where: any)
	for index, radioButton in self.radioButtons do
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
	table.remove(self.Actions,actionName)
end

--[=[
	@within RadioGroup
	@private
	Private Function, should not be called.
]=]

function RadioGroup:_ExecuteActions()
	for index, action in self.Actions do
		action()
	end
end


--[=[
	@within RadioGroup
	@private
	Selects one button and deselects all the others.
]=]

function RadioGroup:selectButton(radioButtonObject: {any})
	self.selected = radioButtonObject.IdName
	for index, radioButton in self.radioButtons do
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
	for index, value in self do
		value = nil
	end
end


return RadioGroup
