local Form = {}
Form.__index = Form

--[=[
	@class Form
	@client
	Class for Form object.
]=]

--[=[
	@within Form
	@return <table> -- [Form Object]
	Constructor for Form object.
]=]

function Form.new() -- mostly abstract class to manage other ui elements
	local self = setmetatable({}, Form)
	self.Data = {}
	self.Elements = {}
	return self
end

--[=[
	@within Form
	Inserts element into the Form.Elements table.
]=]

function Form:insertElement(Element: table)
	self.Elements[Element.IDName] = Element
end

--[=[
	@within Form
	Inserts multiple elements into the Form.Elements table.
]=]

function Form:insertElements(Elements: table)
	for Index, Element in pairs(Elements) do
		self.Elements[Element.IDName] = Element
	end
end

--[=[
	@within Form
	Removes element from the Form.Elements table.
]=]

function Form:clearElement(ElementName: string)
	table.remove(self.Elements,ElementName)
end

--[=[
	@within Form
	Clears the Form.Elements table.
]=]

function Form:clearAllElements()
	table.clear(self.Elements)
end

--[=[
	@within Form
	Initializes all elements inside Form.Elements table.
]=]

function Form:initAll() -- init all elements
	for Index, Element in pairs(self.Elements) do
		Element:init()
	end
end

--[=[
	@within Form
	Sets parent for all elements inside Form.Elements table.
]=]

function Form:appendAll(Where: any) -- random order
	for Index, Element in pairs(self.Elements) do
		Element:append(Where)
	end
end

--[=[
	@within Form
	@return <boolean> -- [true if everything is alright, false if there are problems]
	Validates the data.
]=]

function Form:validate() -- validate if data is not corrupted
	
end

--[=[
	@within Form
	@return <table> -- [table of all data]
	Collects all the data from the form.
]=]

function Form:collectData() -- collect and return all data
	table.clear(self.Data)
	for Index, Element in pairs(self.Elements) do
		local Value, Name = Element:returnValues()
		self.Data[Name] = Value
	end
	return self.Data
end

--[=[
	@within Form
	Destructor for Form object.
]=]

function Form:destroy()
	for Index, Value in pairs(self) do
		Value = nil
	end
end


return Form
