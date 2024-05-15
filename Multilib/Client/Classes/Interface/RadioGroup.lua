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

function RadioGroup.New(idName: string)
	local self = setmetatable({}, RadioGroup)
	self.radioButtons = {}
	self.actions = {}
	self.idName = idName
	self.selected = nil
	return self
end

--[=[
	@within RadioGroup
	
	should be called only via Form:InitAll().
]=]

function RadioGroup:Init() -- should be called only via Form:InitAll()
	for index, radioButton in pairs(self.radioButtons) do
		radioButton:Init()
	end
end

--[=[
	@within RadioGroup
	@return <string,string> -- [idName of selected and idName of the object]
	Returns idName of selected and idName of the object.
]=]

function RadioGroup:ReturnValues()
	if self.selected ~= nil then
		return self.selected, self.idName
	else
		return false, self.idName
	end
end

--[=[
	@within RadioGroup
	Inserts element into the RadioGroup.RadioButtons table.
]=]

function RadioGroup:insertElement(element: table)
	self.radioButtons[element.idName] = element
end

--[=[
	@within RadioGroup
	Inserts multiple elements into the RadioGroup.RadioButtons table.
]=]

function RadioGroup:insertElements(elements: table)
	for index, element in pairs(elements) do
		self.radioButtons[element.idName] = element
	end
end

--[=[
	@within RadioGroup
	Removes element from the RadioGroup.RadioButtons table.
]=]

function RadioGroup:clearElement(ElementName: string)
	table.remove(self.radioButtons,ElementName)
end

--[=[
	@within RadioGroup
	Clears the RadioGroup.RadioButtons table.
]=]

function RadioGroup:clearAllElements()
	table.clear(self.radioButtons)
end

--[=[
	@within RadioGroup
	Sets the parent of every radioButton.
]=]

function RadioGroup:Append(where: any)
	for index, radioButton in pairs(self.radioButtons) do
		radioButton:Append(where)
	end
end

--[=[
	@within RadioGroup
	
	Adds action that will be executed on every value change.
]=]

function RadioGroup:AddAction(actionName: string, action: any)
	self.actions[actionName] = action
end

--[=[
	@within RadioGroup
	
	Removes action that would be executed on every value change.
]=]

function RadioGroup:RemoveAction(actionName: string)
	table.remove(self.actions,actionName)
end

--[=[
	@within RadioGroup
	@private
	Private Function, should not be called.
]=]

function RadioGroup:ExecuteActions()
	for index, action in pairs(self.actions) do
		action()
	end
end


--[=[
	@within RadioGroup
	@private
	Selects one button and deselects all the others.
]=]

function RadioGroup:selectButton(radioButtonObject: table)
	self.selected = radioButtonObject.idName
	for index, radioButton in pairs(self.radioButtons) do
		if radioButton.isSelected == true and radioButton ~= radioButtonObject then
			radioButton:selectionStatus(false)
		end
	end
	radioButtonObject:selectionStatus(true)
	self:ExecuteActions()
end

--[=[
	@within RadioGroup
	Destructor for RadioGroup object.
]=]

function RadioGroup:Destroy()
	for index, value in pairs(self) do
		value = nil
	end
end


return RadioGroup
