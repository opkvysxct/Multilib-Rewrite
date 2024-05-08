local Form = {}
Form.__index = Form

function Form.new() -- mostly abstract class to manage other ui elements
	local self = setmetatable({}, Form)
	self.Data = {}
	self.Elements = {}
	return self
end

function Form:insertElement(Element: table)
	self.Elements[Element.IDName] = Element
end

function Form:insertElements(Elements: table)
	for Index, Element in pairs(Elements) do
		self.Elements[Element.IDName] = Element
	end
end

function Form:clearElement(ElementName: string)
	table.remove(self.Elements,ElementName)
end

function Form:clearAllElements()
	table.clear(self.Elements)
end

function Form:initAll() -- init all elements
	for Index, Element in pairs(self.Elements) do
		Element:init()
	end
end

function Form:appendAll(Where: any) -- random order
	for Index, Element in pairs(self.Elements) do
		Element:append(Where)
	end
end

function Form:validate() -- validate if data is not corrupted
	
end

function Form:collectData() -- collect and return all data
	table.clear(self.Data)
	for Index, Element in pairs(self.Elements) do
		local Value,Name = Element:returnValues()
		self.Data[Name] = Value
	end
	return self.Data
end

function Form:destroy()
	for Index, Value in pairs(self) do
		Value = nil
	end
end


return Form
