-- Player Component

local Lib = {}

-- Core
function Lib:IsFirstPerson()
	-- to do
end

-- End

function Lib:Init()
	if _G.M_Loader.Comments then
		print("[Multilib] Player Lib Loaded & safe to use.")
	end
end

return Lib