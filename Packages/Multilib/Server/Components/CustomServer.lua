local Lib = {}

-- Core
function Lib:ReturnCustomValue()
	return self.CustomValue
end

-- useSettings
function Lib:SetCustomValue(value: string)
	self.CustomValue = value
end

-- End
function Lib:Init()
	self.CustomValue = "Change Me!"
end

return Lib