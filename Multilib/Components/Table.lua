-- Table Component

local Lib = {}

-- Core
function Lib:Do()
	-- to do
end

-- End

function Lib:Init()
	if _G.M_Loader.Comments then
		print("[Multilib] Table Lib Loaded & safe to use.")
	end
end

return Lib