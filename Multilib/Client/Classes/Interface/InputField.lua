local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
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

function InputField.new(Model: any, Elements: table, IDName: string, Settings: table)
	local self = setmetatable({}, InputField)

	if Settings == nil then Settings = {} end
	if Settings.Locked == nil then Settings.Locked = false end
	if Settings.Cooldown == nil then Settings.Cooldown = 0.25 end
	if Settings.Type == nil then Settings.Type = "Numeric" end
	if Settings.PlaceholderText == nil then Settings.PlaceholderText = "Input" end
	if Settings.Lenght == nil then Settings.Lenght = 10 end

	local Model, Elements = self:perfectClone(Model,Elements)

	self.ModelElements = {}
	for Index, Value in pairs(Elements) do
		self.ModelElements[Index] = Value
	end

	if Settings.Type == "Numeric" then
		self.AllowedCharacters = "1234567890"
	elseif Settings.Type == "Text" then
		self.AllowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	else
		if Settings.CustomCharacters == nil then Settings.CustomCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" end
		self.AllowedCharacters = Settings.CustomCharacters
	end

	self.ModelElements.Input.PlaceholderText = Settings.PlaceholderText

	self.IsCooldown = false
	self.Initiated = false
	self.Type = "InputField"
	self.Lenght = Settings.Lenght
	self.SubType = Settings.Type
	self.Actions = {}

	self.Model = Model
	self.Model.Name = IDName
	self.IDName = IDName

	self.CooldownTime = Settings.Cooldown
	self.Value = Settings.StartingValue
	self.Locked = Settings.Locked

	return self
end

--[=[
	@within InputField
	
	should be called only via Form:InitAll().
]=]

function InputField:init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self.ModelElements.Clear.Activated:Connect(function()
			self.ModelElements.Input.Text = ""
		end)
		self.ModelElements.Input.Changed:Connect(function(Property: string)
			if Property == "Text" then
				local Text = self.ModelElements.Input.Text
				Text = string.split(Text,"")
				if #Text > self.Lenght then -- Lenght Checker
					local NewText = {}
					for Index = 1, self.Lenght do
						NewText[Index] = Text[Index]
					end
					Text = NewText
				end
				local Allowed = string.split(self.AllowedCharacters,"")
				local NewText = Text
				for Index, Letter in Text do
					if not table.find(Allowed,Letter) then
						table.remove(NewText,table.find(NewText,Letter))
					end
				end
				Text = NewText
				NewText = ""
				for Index, Letter in Text do
					NewText ..= Letter
				end
				Text = NewText
				self.ModelElements.Input.Text = Text
				self.Value = Text
				self:executeActions()
			end
		end)
	end
end

--[=[
	@within InputField
	@return <boolean,string> -- [Value and IDName of the object]
	Returns value and IDName of the object.
]=]

function InputField:returnValues()
	return self.Value, self.IDName
end

--[=[
	@within InputField
	
	Changes the InputField.Locked property.
]=]

function InputField:lockStatus(Status: boolean)
	self.Locked = Status
	self.ModelElements.Input.TextEditable = Status
end

--[=[
	@within InputField
	
	Sets the parent of the InputField.Model.
]=]

function InputField:append(Where: any)
	self.Model.Parent = Where
end

--[=[
	@within InputField
	
	Adds action that will be executed on every value change.
]=]

function InputField:addAction(ActionName: string, Action: any)
	self.Actions[ActionName] = Action
end

--[=[
	@within InputField
	
	Removes action that would be executed on every value change.
]=]

function InputField:removeAction(ActionName: string)
	table.remove(self.Actions,ActionName)
end

--[=[
	@within InputField
	@private
	Private Function, should not be called.
]=]

function InputField:executeActions()
	for Index, Action in pairs(self.Actions) do
		Action()
	end
end


--[=[
	@within InputField
	@private
	Private Function, should not be called.
]=]

function InputField:perfectClone(TrueModel: any, TrueElements: table) -- internal private function, do not call (also; not quite perfect)
	local Model = TrueModel:Clone()
	local Elements = {}
	for Index, Element in pairs(TrueElements) do
		local Path = string.split(Element,".")
		local FollowedPath = Model
		for Index2, Value in pairs(Path) do
			FollowedPath = FollowedPath[Value]
		end
		Elements[Index] = FollowedPath
	end
	return Model, Elements
end

--[=[
	@within InputField
	Destructor for InputField object.
]=]

function InputField:destroy()
	self.Model:Destroy()
	for Index, Value in pairs(self) do
		Value = nil
	end
end


return InputField
