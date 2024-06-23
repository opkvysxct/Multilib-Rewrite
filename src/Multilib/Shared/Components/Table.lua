local Lib = {}

--[=[
	@class Table Package
	Table Utils.
]=]

-- Core

--[=[
	@within Table Package
	@return <table>
	Deep copy of a given table.
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
function Lib:Init()

end

return Lib
