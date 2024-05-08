local Lib = {}

-- Core

function Lib:DictionaryFind(dictionary: table, requiredValue: any)
	for index, value in pairs(dictionary) do
		if value == requiredValue then
			return index
		end
	end
end

function Lib:DeepCopy(Table: table)
	local copy = {}
	for k, v in pairs(Table) do
		if type(v) == "table" then
			v = self:DeepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

-- End
function Lib:Init()
	if _G.MLoader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
