local Mtypes = require(script.Parent.Parent.Types)
local PerfectClone = require(script.Parent.Parent.PerfectClone)
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

function InputField.new(model: GuiObject, elements: {GuiObject}, IdName: string, uiOrder: number, useSettings: Mtypes.InputField)
	local self = setmetatable({}, InputField)
	local trueSettings = {}

	useSettings = useSettings or table.clone(Mtypes.TInputField)
	trueSettings.locked = useSettings.Locked or false
	trueSettings.Cooldown = useSettings.Cooldown or 0.25
	trueSettings.ElementType = useSettings.ElementType or "Numeric"
	trueSettings.PlaceholderText = useSettings.PlaceholderText or "Input"
	trueSettings.Lenght = useSettings.Lenght or 10
	trueSettings.StartingValue = useSettings.StartingValue or "abc"

	model, elements = PerfectClone(model,elements)
	model.LayoutOrder = uiOrder
	
	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end

	if useSettings.ElementType == "Numeric" then
		self.AllowedCharacters = "1234567890"
	elseif useSettings.ElementType == "Text" then
		self.AllowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	else
		trueSettings.CustomCharacters = useSettings.CustomCharacters or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
		self.AllowedCharacters = trueSettings.CustomCharacters
	end

	self._ModelElements.Input.placeholderText = trueSettings.PlaceholderText

	self._IsCooldown = false
	self.Initiated = false
	self.ElementType = "InputField"
	self.Lenght = trueSettings.Lenght
	self.SubType = trueSettings.ElementType
	self.Actions = {}

	self._Model = model
	self._Model.Name = IdName
	self.IdName = IdName

	self.CooldownTime = trueSettings.Cooldown
	self.Value = trueSettings.StartingValue
	self.Locked = trueSettings.locked

	return self
end

--[=[
	@within InputField
	
	should be called only via Form:InitAll().
]=]

function InputField:Init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self._ModelElements.Clear.Activated:Connect(function()
			self._ModelElements.Input.Text = ""
		end)
		self._ModelElements.Input.Changed:Connect(function(Property: string)
			if Property == "Text" then
				local Text = self._ModelElements.Input.Text
				Text = string.split(Text,"")
				if #Text > self.Lenght then -- Lenght Checker
					local NewText = {}
					for index = 1, self.Lenght do
						NewText[index] = Text[index]
					end
					Text = NewText
				end
				local Allowed = string.split(self.AllowedCharacters,"")
				local NewText = Text
				for _, Letter in Text do
					if not table.find(Allowed,Letter) then
						table.remove(NewText,table.find(NewText,Letter))
					end
				end
				Text = NewText
				NewText = ""
				for _, Letter in Text do
					NewText ..= Letter
				end
				Text = NewText
				self._ModelElements.Input.Text = Text
				self.Value = Text
				self:_ExecuteActions()
			end
		end)
	end
end

--[=[
	@within InputField
	@return <boolean,string> -- [value and IdName of the object]
	Returns value and IdName of the object.
]=]

function InputField:ReturnValues()
	return self.Value, self.IdName
end

--[=[
	@within InputField
	
	Changes the InputField.locked property.
]=]

function InputField:LockStatus(status: boolean)
	self.Locked = status
	self._ModelElements.Input.TextEditable = status
end

--[=[
	@within InputField
	
	Sets the Parent of the InputField.model.
]=]

function InputField:Append(where: any)
	self._Model.Parent = where
end

--[=[
	@within InputField
	
	Adds action that will be executed on every value change.
]=]

function InputField:AddAction(actionName: string, action: any)
	self.Actions[actionName] = action
end

--[=[
	@within InputField
	
	Removes action that would be executed on every value change.
]=]

function InputField:RemoveAction(actionName: string)
	self.Actions[actionName] = nil
end

--[=[
	@within InputField
	@private
	Private Function, should not be called.
]=]

function InputField:_ExecuteActions()
	for _, action in self.Actions do
		action()
	end
end

--[=[
	@within InputField
	Destructor for InputField object.
]=]

function InputField:Destroy()
	self._Model:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end


return InputField
