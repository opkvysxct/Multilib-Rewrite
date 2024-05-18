local Lib = {}

-- Core

function Lib:DictionaryFind(dictionary: {any}, requiredValue: any)
	for index, value in pairs(dictionary) do
		if value == requiredValue then
			return index
		end
	end
end

function Lib:DeepCopy(table: {any})
	local copy = {}
	for k, v in pairs(table) do
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
