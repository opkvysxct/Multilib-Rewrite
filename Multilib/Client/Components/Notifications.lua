local Lib = {}

-- Core


-- Settings


-- End
function Lib:Init()
	if _G.MLoader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib