local Lib = {}

--[=[
	@class Table Package
	Table Utils.
]=]

-- Core

--[=[
	@within Table Package
	@return <{}>
	Deep copy of given table.
]=]

function Lib:DeepCopy(tableToCopy: {})
	local copy = {}
	for k, v in tableToCopy do
		if type(v) == "table" then
			v = self:DeepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

-- End
function Lib:Init(comments: boolean)
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
