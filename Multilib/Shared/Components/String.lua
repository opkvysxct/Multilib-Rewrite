local Lib = {}

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
	if _G.MLoader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
