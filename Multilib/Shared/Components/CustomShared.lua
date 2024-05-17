local Lib = {}
export type Lib = {
	ReturnCustomValue: () -> (any)
}
-- Core
function Lib:ReturnCustomValue()
	return self.customValue
end

-- settings
function Lib:SetCustomValue(value: string)
	self.customValue = value
end

-- End
function Lib:Init(comments: boolean)
	self.customValue = "Change Me!"
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib