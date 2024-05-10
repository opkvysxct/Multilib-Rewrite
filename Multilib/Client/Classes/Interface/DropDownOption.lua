local DropDownOption = {}
DropDownOption.__index = DropDownOption

--[=[
	@class DropDownOption
	@client
	@private
	Class for DropDownOption object.
]=]

--[=[
	@within DropDownOption
	@return <table> -- [DropDownOption Object]
	Constructor for DropDownOption object.
]=]

function DropDownOption.new(Model: any, Elements: table, IDName: string, DropDownMenu: table, Settings: table)
	local self = setmetatable({}, DropDownOption)

	if Settings == nil then Settings = {} end
	if Settings.Locked == nil then Settings.Locked = false end
	if Settings.Cooldown == nil then Settings.Cooldown = 0.25 end

	local Model, Elements = self:perfectClone(Model,Elements)

	self.ModelElements = {}
	for Index, Value in pairs(Elements) do
		self.ModelElements[Index] = Value
	end


	self.IsCooldown = false
	self.Initiated = false
	self.Type = "DropDownOption"
	self.IsSelected = false

	self.Model = Model
	self.Model.Name = IDName
	self.IDName = IDName
	self.DropDownMenu = DropDownMenu

	self.CooldownTime = Settings.Cooldown
	self.Locked = Settings.Locked

	self.ModelElements.TextLabel.Text = IDName

	return self
end

--[=[
	@within DropDownOption
	
	should be called only via Form:InitAll().
]=]

function DropDownOption:init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self.ModelElements.Button.Activated:Connect(function()
			if self.Locked == false and self.IsCooldown == false then
				self.IsCooldown = true
				task.delay(self.CooldownTime,function()
					self.IsCooldown = false
				end)
				if self.IsSelected == false then
					self.DropDownMenu:selectButton(self)
				end
			end
		end)
	end
end

--[=[
	@within DropDownOption
	
	Changes the DropDownOption.Locked property.
]=]

function DropDownOption:lockStatus(Status: boolean)
	self.Locked = Status
end

--[=[
	@within DropDownOption
	
	Sets the parent of the DropDownOption.Model.
]=]

function DropDownOption:append(Where: any)
	self.Model.Parent = Where
end

--[=[
	@within DropDownOption
	@private
	Private Function, should not be called.
]=]

function DropDownOption:perfectClone(TrueModel: any, TrueElements: table) -- internal private function, do not call (also; not quite perfect)
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
	@within DropDownOption
	@private
	Changes selection status.
]=]

function DropDownOption:selectionStatus(Value: boolean)
	self.IsSelected = Value
end

--[=[
	@within DropDownOption
	Destructor for DropDownOption object.
]=]

function DropDownOption:destroy()
	self.Model:Destroy()
	for Index, Value in pairs(self) do
		Value = nil
	end
end


return DropDownOption
