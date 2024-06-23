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

function Form.new() -- mostly abstract class to manage other ui Elements
	local self = setmetatable({}, Form)
	self.Data = {}
	self.Elements = {}
	return self
end

--[=[
	@within Form
	Inserts element into the Form.Elements table.
]=]

function Form:InsertElement(element: {})
	self.Elements[element.IdName] = element
end

--[=[
	@within Form
	Inserts multiple Elements into the Form.Elements table.
]=]

function Form:InsertElements(Elements: {})
	for _, element in Elements do
		self.Elements[element.IdName] = element
	end
end

--[=[
	@within Form
	Removes element from the Form.Elements table.
]=]

function Form:ClearElement(ElementName: string)
	table.remove(self.Elements,ElementName)
end

--[=[
	@within Form
	Clears the Form.Elements table.
]=]

function Form:ClearAllElements()
	table.clear(self.Elements)
end

--[=[
	@within Form
	Initializes all Elements inside Form.Elements table.
]=]

function Form:InitAll() -- Init all Elements
	for _, element in self.Elements do
		element:Init()
	end
end

--[=[
	@within Form
	Sets Parent for all Elements inside Form.Elements table.
]=]

function Form:AppendAll(where: any) -- random order
	for _, element in self.Elements do
		element:Append(where)
	end
end

--[=[
	@within Form
	@return <boolean> -- [true if everything is alright, false if there are problems]
	Validates the data.
]=]

function Form:Validate() -- Validate if data is not corrupted
	
end

--[=[
	@within Form
	@return <table> -- [table of all data]
	Collects all the data from the form.
]=]

function Form:CollectData() -- collect and return all data
	table.clear(self.Data)
	for _, element in self.Elements do
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
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end


return Form
