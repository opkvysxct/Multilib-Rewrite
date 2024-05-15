local InputField = {}
InputField.__index = InputField

--[=[
	@class InputField
	@client
	Class for InputField object.
]=]

--[=[
	@within InputField
	@return <table> -- [InputField Object]
	Constructor for InputField object.
]=]

function InputField.New(model: any, elements: table, idName: string, settings: table)
	local self = setmetatable({}, InputField)

	if settings == nil then settings = {} end
	if settings.locked == nil then settings.locked = false end
	if settings.cooldown == nil then settings.cooldown = 0.25 end
	if settings.elementType == nil then settings.elementType = "Numeric" end
	if settings.placeholderText == nil then settings.placeholderText = "Input" end
	if settings.lenght == nil then settings.lenght = 10 end

	local model, elements = self:PerfectClone(model,elements)

	self.modelElements = {}
	for index, value in pairs(elements) do
		self.modelElements[index] = value
	end

	if settings.elementType == "Numeric" then
		self.allowedCharacters = "1234567890"
	elseif settings.elementType == "Text" then
		self.allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	else
		if settings.customCharacters == nil then settings.customCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" end
		self.allowedCharacters = settings.customCharacters
	end

	self.modelElements.Input.placeholderText = settings.placeholderText

	self.isCooldown = false
	self.initiated = false
	self.elementType = "InputField"
	self.lenght = settings.lenght
	self.subType = settings.elementType
	self.actions = {}

	self.model = model
	self.model.Name = idName
	self.idName = idName

	self.cooldownTime = settings.cooldown
	self.value = settings.startingValue
	self.locked = settings.locked

	return self
end

--[=[
	@within InputField
	
	should be called only via Form:InitAll().
]=]

function InputField:Init() -- should be called only via Form:InitAll()
	if self.initiated == false then
		self.initiated = true
		self.modelElements.Clear.Activated:Connect(function()
			self.modelElements.Input.Text = ""
		end)
		self.modelElements.Input.Changed:Connect(function(Property: string)
			if Property == "Text" then
				local Text = self.modelElements.Input.Text
				Text = string.split(Text,"")
				if #Text > self.lenght then -- lenght Checker
					local NewText = {}
					for index = 1, self.lenght do
						NewText[index] = Text[index]
					end
					Text = NewText
				end
				local Allowed = string.split(self.allowedCharacters,"")
				local NewText = Text
				for index, Letter in Text do
					if not table.find(Allowed,Letter) then
						table.remove(NewText,table.find(NewText,Letter))
					end
				end
				Text = NewText
				NewText = ""
				for index, Letter in Text do
					NewText ..= Letter
				end
				Text = NewText
				self.modelElements.Input.Text = Text
				self.value = Text
				self:ExecuteActions()
			end
		end)
	end
end

--[=[
	@within InputField
	@return <boolean,string> -- [value and idName of the object]
	Returns value and idName of the object.
]=]

function InputField:ReturnValues()
	return self.value, self.idName
end

--[=[
	@within InputField
	
	Changes the InputField.locked property.
]=]

function InputField:LockStatus(status: boolean)
	self.locked = status
	self.modelElements.Input.TextEditable = status
end

--[=[
	@within InputField
	
	Sets the parent of the InputField.model.
]=]

function InputField:Append(where: any)
	self.model.parent = where
end

--[=[
	@within InputField
	
	Adds action that will be executed on every value change.
]=]

function InputField:AddAction(actionName: string, action: any)
	self.actions[actionName] = action
end

--[=[
	@within InputField
	
	Removes action that would be executed on every value change.
]=]

function InputField:RemoveAction(actionName: string)
	table.remove(self.actions,actionName)
end

--[=[
	@within InputField
	@private
	Private Function, should not be called.
]=]

function InputField:ExecuteActions()
	for index, action in pairs(self.actions) do
		action()
	end
end


--[=[
	@within InputField
	@private
	Private Function, should not be called.
]=]

function InputField:PerfectClone(trueModel: any, trueElements: table) -- internal private function, do not call (also; not quite perfect)
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
	@within InputField
	Destructor for InputField object.
]=]

function InputField:Destroy()
	self.model:Destroy()
	for index, value in pairs(self) do
		value = nil
	end
end


return InputField
