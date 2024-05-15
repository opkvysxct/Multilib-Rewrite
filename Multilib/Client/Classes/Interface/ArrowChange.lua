local ArrowChange = {}
ArrowChange.__index = ArrowChange

--[=[
	@class ArrowChange
	@client
	Class for ArrowChange object.
]=]

--[=[
	@within ArrowChange
	@return <table> -- [ArrowChange Object]
	Constructor for ArrowChange object.
]=]

function ArrowChange.new(Model: any, Elements: table, IDName: string, Settings: table?)
	local self = setmetatable({}, ArrowChange)

	if Settings == nil then Settings = {} end
	if Settings.Locked == nil then Settings.Locked = false end
	if Settings.Cooldown == nil then Settings.Cooldown = 0.25 end
	if Settings.OverrideDisplayAnimation ~= nil then self.displayAnimFunc = Settings.OverrideDisplayAnimation end
	if Settings.Values == nil then Settings.Values = {"First","Second","Third"} end
	if Settings.StartingIndex == nil then Settings.StartingIndex = 1 end

	local Model, Elements = self:perfectClone(Model,Elements)

	self.ModelElements = {}
	for Index, Value in pairs(Elements) do
		self.ModelElements[Index] = Value
	end

	if Settings.StartingIndex < 1 or Settings.StartingIndex > #Settings.Values then
		Settings.StartingIndex = 1
	end

	self.ActualIndex = Settings.StartingIndex
	self.Values = Settings.Values

	self.IsCooldown = false
	self.Initiated = false
	self.Type = "ArrowChange"
	self.Actions = {}

	self.Model = Model
	self.Model.Name = IDName
	self.IDName = IDName

	self.CooldownTime = Settings.Cooldown
	self.Value = Settings.StartingValue
	self.Locked = Settings.Locked

	self:displayAnimFunc()

	return self
end

--[=[
	@within ArrowChange
	
	should be called only via Form:InitAll().
]=]

function ArrowChange:init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self.ModelElements.Left.Activated:Connect(function()
			if self.Locked == false then
				if self.ActualIndex - 1 == 0 then
					self.ActualIndex = #self.Values
				else
					self.ActualIndex -= 1
				end
				self:displayAnimFunc()
				self:executeActions()
			end
		end)
		self.ModelElements.Right.Activated:Connect(function()
			if self.Locked == false then
				if self.ActualIndex + 1 > #self.Values then
					self.ActualIndex = 1
				else
					self.ActualIndex += 1
				end
				self:displayAnimFunc()
				self:executeActions()
			end
		end)
	end
end

--[=[
	@within ArrowChange
	
	Updates the Values and Index (optional).
]=]

function ArrowChange:updateValues(Values: any, Index: number?)
	if Index == nil then Index = self.ActualIndex end

	if Index < 1 or Index > #Values then
		Index = 1
	else
		Index = self.ActualIndex
	end

	self.Values = Values
	self.ActualIndex = Index
	self:displayAnimFunc()
	self:executeActions()
end

--[=[
	@within ArrowChange
	@return <boolean,string> -- [Value and IDName of the object]
	Returns value and IDName of the object.
]=]

function ArrowChange:returnValues()
	return self.Values[self.ActualIndex], self.IDName
end

--[=[
	@within ArrowChange
	
	Changes the ArrowChange.Locked property.
]=]

function ArrowChange:lockStatus(Status: boolean)
	self.Locked = Status
end

--[=[
	@within ArrowChange
	
	Sets the parent of the ArrowChange.Model.
]=]

function ArrowChange:append(Where: any)
	self.Model.Parent = Where
end

--[=[
	@within ArrowChange
	@private
	Private Function, should not be called.
]=]

function ArrowChange:displayAnimFunc() -- internal private function, do not call
	self.ModelElements.TextLabel.Text = self.Values[self.ActualIndex]
end

--[=[
	@within ArrowChange
	
	Adds action that will be executed on every value change.
]=]

function ArrowChange:addAction(ActionName: string, Action: any)
	self.Actions[ActionName] = Action
end

--[=[
	@within ArrowChange
	
	Removes action that would be executed on every value change.
]=]

function ArrowChange:removeAction(ActionName: string)
	table.remove(self.Actions,ActionName)
end

--[=[
	@within ArrowChange
	@private
	Private Function, should not be called.
]=]

function ArrowChange:executeActions()
	for Index, Action in pairs(self.Actions) do
		Action()
	end
end


--[=[
	@within ArrowChange
	@private
	Private Function, should not be called.
]=]

function ArrowChange:perfectClone(TrueModel: any, TrueElements: table) -- internal private function, do not call (also; not quite perfect)
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
	@within ArrowChange
	Destructor for ArrowChange object.
]=]

function ArrowChange:destroy()
	self.Model:Destroy()
	for Index, Value in pairs(self) do
		Value = nil
	end
end


return ArrowChange
