local Lib = {}

-- Core
function Lib:ReturnCustomValue()
	return self.CustomValue
end

-- Settings
function Lib:SetCustomValue(Value: string)
	self.CustomValue = Value
end

-- End
function Lib:Init()
	self.CustomValue = "Change Me!"
	if _G.MLoader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib