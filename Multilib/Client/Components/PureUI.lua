local Lib = {}

-- Core
function Lib:CreateRoot()
	
end

-- useSettings


-- End
function Lib:Init(comments: boolean)
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib