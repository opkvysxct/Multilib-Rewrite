local Lib = {}

--[=[
	@class String Package
	String Utils.
]=]

-- Core

--[=[
	@within String Package
	@return <string>
	Splits string by capital letters.
	Provided by https://github.com/NiceAssasin123
]=]

function Lib:SplitStringByCapitalLetters(string: string)
    local result = {}
    local pattern = "%u%l*"

    for word in string.gmatch(string, pattern) do
        table.insert(result, word)
    end

    return result
end

-- End
function Lib:Init()

end

return Lib
