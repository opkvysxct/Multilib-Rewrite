local Mtypes = require(game:GetService("ReplicatedStorage").Multilib.Types)
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

function InputField.new(model: any, elements: {GuiObject}, idName: string, settings: Mtypes.InputField?)
	local self = setmetatable({}, InputField)

	if settings == nil then settings = {} end
	if settings.Locked == nil then settings.Locked = false end
	if settings.Cooldown == nil then settings.Cooldown = 0.25 end
	if settings.ElementType == nil then settings.ElementType = "Numeric" end
	if settings.PlaceholderText == nil then settings.PlaceholderText = "Input" end
	if settings.Lenght == nil then settings.Lenght = 10 end

	local model, elements = self:_PerfectClone(model,elements)

	self.modelElements = {}
	for index, value in elements do
		self.modelElements[index] = value
	end

	if settings.ElementType == "Numeric" then
		self.allowedCharacters = "1234567890"
	elseif settings.ElementType == "Text" then
		self.allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	else
		if settings.customCharacters == nil then settings.customCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" end
		self.allowedCharacters = settings.customCharacters
	end

	self.modelElements.Input.placeholderText = settings.PlaceholderText

	self._isCooldown = false
	self.initiated = false
	self.elementType = "InputField"
	self.lenght = settings.Lenght
	self.subType = settings.ElementType
	self.actions = {}

	self.model = model
	self.model.Name = idName
	self.idName = idName

	self._cooldownTime = settings.Cooldown
	self.value = settings.StartingValue
	self.locked = settings.Locked

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
				self:_ExecuteActions()
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
	
	Sets the Parent of the InputField.model.
]=]

function InputField:Append(where: any)
	self.model.Parent = where
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

function InputField:_ExecuteActions()
	for index, action in self.actions do
		action()
	end
end


--[=[
	@within InputField
	@private
	Private Function, should not be called.
]=]

function InputField:_PerfectClone(trueModel: any, trueElements: {any}) -- internal private function, do not call (also; not quite perfect)
	local model = trueModel:Clone()
	local elements = {}
	for index, element in trueElements do
		local path = string.split(element,".")
		local followedPath = model
		for Index2, value in path do
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
	for index, value in self do
		value = nil
	end
end


return InputField
