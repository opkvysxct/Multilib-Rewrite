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

function Form.New() -- mostly abstract class to manage other ui elements
	local self = setmetatable({}, Form)
	self.Data = {}
	self.elements = {}
	return self
end

--[=[
	@within Form
	Inserts element into the Form.elements table.
]=]

function Form:insertElement(element: table)
	self.elements[element.idName] = element
end

--[=[
	@within Form
	Inserts multiple elements into the Form.elements table.
]=]

function Form:insertElements(elements: table)
	for index, element in pairs(elements) do
		self.elements[element.idName] = element
	end
end

--[=[
	@within Form
	Removes element from the Form.elements table.
]=]

function Form:clearElement(ElementName: string)
	table.remove(self.elements,ElementName)
end

--[=[
	@within Form
	Clears the Form.elements table.
]=]

function Form:clearAllElements()
	table.clear(self.elements)
end

--[=[
	@within Form
	Initializes all elements inside Form.elements table.
]=]

function Form:initAll() -- Init all elements
	for index, element in pairs(self.elements) do
		element:Init()
	end
end

--[=[
	@within Form
	Sets parent for all elements inside Form.elements table.
]=]

function Form:appendAll(where: any) -- random order
	for index, element in pairs(self.elements) do
		element:Append(where)
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
	for index, element in pairs(self.elements) do
		local value, Name = element:ReturnValues()
		self.Data[Name] = value
	end
	return self.Data
end

--[=[
	@within Form
	Destructor for Form object.
]=]

function Form:Destroy()
	for index, value in pairs(self) do
		value = nil
	end
end


return Form
