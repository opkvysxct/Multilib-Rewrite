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

function RadioGroup.new(IDName: string)
	local self = setmetatable({}, RadioGroup)
	self.RadioButtons = {}
	self.Actions = {}
	self.IDName = IDName
	self.Selected = nil
	return self
end

--[=[
	@within RadioGroup
	
	should be called only via Form:InitAll().
]=]

function RadioGroup:init() -- should be called only via Form:InitAll()
	for Index, RadioButton in pairs(self.RadioButtons) do
		RadioButton:init()
	end
end

--[=[
	@within RadioGroup
	@return <string,string> -- [IDName of selected and IDName of the object]
	Returns IDName of selected and IDName of the object.
]=]

function RadioGroup:returnValues()
	if self.Selected ~= nil then
		return self.Selected, self.IDName
	else
		return false, self.IDName
	end
end

--[=[
	@within RadioGroup
	Inserts element into the RadioGroup.RadioButtons table.
]=]

function RadioGroup:insertElement(Element: table)
	self.RadioButtons[Element.IDName] = Element
end

--[=[
	@within RadioGroup
	Inserts multiple elements into the RadioGroup.RadioButtons table.
]=]

function RadioGroup:insertElements(Elements: table)
	for Index, Element in pairs(Elements) do
		self.RadioButtons[Element.IDName] = Element
	end
end

--[=[
	@within RadioGroup
	Removes element from the RadioGroup.RadioButtons table.
]=]

function RadioGroup:clearElement(ElementName: string)
	table.remove(self.RadioButtons,ElementName)
end

--[=[
	@within RadioGroup
	Clears the RadioGroup.RadioButtons table.
]=]

function RadioGroup:clearAllElements()
	table.clear(self.RadioButtons)
end

--[=[
	@within RadioGroup
	Sets the parent of every RadioButton.
]=]

function RadioGroup:append(Where: any)
	for Index, RadioButton in pairs(self.RadioButtons) do
		RadioButton:append(Where)
	end
end

--[=[
	@within RadioGroup
	
	Adds action that will be executed on every value change.
]=]

function RadioGroup:addAction(ActionName: string, Action: any)
	self.Actions[ActionName] = Action
end

--[=[
	@within RadioGroup
	
	Removes action that would be executed on every value change.
]=]

function RadioGroup:removeAction(ActionName: string)
	table.remove(self.Actions,ActionName)
end

--[=[
	@within RadioGroup
	@private
	Private Function, should not be called.
]=]

function RadioGroup:executeActions()
	for Index, Action in pairs(self.Actions) do
		Action()
	end
end


--[=[
	@within RadioGroup
	@private
	Selects one button and deselects all the others.
]=]

function RadioGroup:selectButton(RadioButtonObject: table)
	self.Selected = RadioButtonObject.IDName
	for Index, RadioButton in pairs(self.RadioButtons) do
		if RadioButton.IsSelected == true and RadioButton ~= RadioButtonObject then
			RadioButton:selectionStatus(false)
		end
	end
	RadioButtonObject:selectionStatus(true)
	self:executeActions()
end

--[=[
	@within RadioGroup
	Destructor for RadioGroup object.
]=]

function RadioGroup:Destroy()
	for Index, Value in pairs(self) do
		Value = nil
	end
end


return RadioGroup
