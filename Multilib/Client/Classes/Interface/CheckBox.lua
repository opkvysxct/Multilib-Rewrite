local CheckBox = {}
CheckBox.__index = CheckBox

function CheckBox.new(Model: any, Elements: table, IDName: string, Settings: table)
	local self = setmetatable({}, CheckBox)

	if Settings == nil then Settings = {} end
	if Settings.StartingValue == nil then Settings.StartingValue = false end
	if Settings.Locked == nil then Settings.Locked = false end
	if Settings.Cooldown == nil then Settings.Cooldown = 0.25 end
	if Settings.OverrideDisplayAnimation ~= nil then self.displayAnimFunc = Settings.OverrideDisplayAnimation end

	local Model, Elements = self:perfectClone(Model,Elements)

	self.IsCooldown = false
	self.Initiated = false
	self.Type = "Checkbox"

	self.Model = Model
	self.Button = Elements.Button
	self.Check = Elements.Check
	self.IDName = IDName

	self.CooldownTime = Settings.Cooldown
	self.Value = Settings.StartingValue
	self.Locked = Settings.Locked

	if Settings.StartingValue == true then self:displayAnimFunc(true) end

	return self
end

function CheckBox:init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self.Button.Activated:Connect(function()
			self:check()
		end)
	end
end

function CheckBox:returnValues()
	return self.Value, self.IDName
end

function CheckBox:check()
	if self.Locked == false and self.IsCooldown == false then
		self.IsCooldown = true
		task.delay(self.CooldownTime,function()
			self.IsCooldown = false
		end)
		if self.Value == false then
			self.Value = true
			self:displayAnimFunc(true)
		else
			self.Value = false
			self:displayAnimFunc(false)
		end
	end
end

function CheckBox:lockStatus(Status: boolean)
	self.Locked = Status
end

function CheckBox:displayAnimFunc(Value: boolean) -- internal private function, do not call
	self.Check.Visible = Value
end

function CheckBox:append(Where: any)
	self.Model.Parent = Where
end

function CheckBox:perfectClone(TrueModel: any, TrueElements: table) -- internal private function, do not call (also; not quite perfect)
	local Model = TrueModel:Clone()
	local Elements = {}
	for Index, Element in pairs(TrueElements) do
		local Path = string.split(Element,".")
		local FollowedPath = Model
		for Index2, Value in pairs(Path) do
			FollowedPath = FollowedPath[Value]
		end
		print(Index,FollowedPath)
		Elements[Index] = FollowedPath
	end
	return Model, Elements
end

function CheckBox:destroy()
	for Index, Value in pairs(self) do
		Value = nil
	end
end


return CheckBox
