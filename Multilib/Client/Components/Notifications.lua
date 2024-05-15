local Lib = {}

-- Core


-- settings


-- End
function Lib:Init()
	if _G.MLoader.comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib