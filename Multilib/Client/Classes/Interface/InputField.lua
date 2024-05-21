local Mtypes = require(game:GetService("ReplicatedStorage").Multilib.Types)
local MInstance = require(game:GetService("ReplicatedStorage").Multilib.Shared.Components.Instance)
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

	local model, elements = MInstance:PerfectClone(model,elements)

	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end

	if settings.ElementType == "Numeric" then
		self.allowedCharacters = "1234567890"
	elseif settings.ElementType == "Text" then
		self.allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	else
		if settings.customCharacters == nil then settings.customCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" end
		self.allowedCharacters = settings.customCharacters
	end

	self._ModelElements.Input.placeholderText = settings.PlaceholderText

	self._IsCooldown = false
	self.Initiated = false
	self.ElementType = "InputField"
	self.lenght = settings.Lenght
	self.SubType = settings.ElementType
	self.Actions = {}

	self.Model = model
	self.Model.Name = idName
	self.IdName = idName

	self.CooldownTime = settings.Cooldown
	self.Value = settings.StartingValue
	self.Locked = settings.Locked

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
				self._ModelElements.Input.Text = Text
				self.Value = Text
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
	self.Model.Parent = where
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
	table.remove(self.Actions,actionName)
end

--[=[
	@within InputField
	@private
	Private Function, should not be called.
]=]

function InputField:_ExecuteActions()
	for index, action in self.Actions do
		action()
	end
end

--[=[
	@within InputField
	Destructor for InputField object.
]=]

function InputField:Destroy()
	self.Model:Destroy()
	for index, value in self do
		value = nil
	end
end


return InputField
