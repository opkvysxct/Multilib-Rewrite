local Lib = {}

function Lib:RepeatUntil(retries: number, waitTime: number, Function, ConditionFunction)
	local count = 0
	repeat
		count = count + 1
		local success, result = pcall(Function)
		if success and (not ConditionFunction or ConditionFunction(result)) then
			return result
		end
		if waitTime then
			task.wait(waitTime)
		end
	until count >= retries
	return nil
end

-- End
function Lib:Init()
	if _G.MLoader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
