local CheckBox = {}
CheckBox.__index = CheckBox

function CheckBox.new(Model: any, Settings: table)
	local self = setmetatable({}, CheckBox)
	if Settings.StartingValue == nil then
		Settings.StartingValue = false
	end
	if Settings.Locked == nil then
		Settings.Locked = false
	end
	self.ModelElements = Model
	self.Value = Settings.StartingValue
	self.Locked = Settings.Locked
	return self
end

function CheckBox:Check()
	if self.Locked == false then
		if self.Value == false then
			self.Value = true
		else
			self.Value = false
		end
	end
end

function CheckBox:LockStatus(Status: boolean)
	self.Locked = Status
end

function CheckBox:Destroy()
	
end


return CheckBox
