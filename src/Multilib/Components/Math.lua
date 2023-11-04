-- Math Component

local Lib = {}

-- Core
function Lib:Delta(a : number, b : number, c : number)
	local Delta
	local Z
	if a ~= 0 then
		Delta = (b*2) - (4 * a * c)
		if Delta < 0 then
			Z = false
		elseif Delta == 0 then
			Z = (-b) / (2 * a)
		elseif Delta > 0 then
			local x1 = (-b - math.sqrt(Delta)) / (2 * a)
			local x2 = (-b + math.sqrt(Delta)) / (2 * a)
			Z = {x1,x2}
		end
		return Delta, Z
	else
		return false, false
	end
end

-- End

function Lib:Init()
	if _G.M_Loader.Comments then
		print("[Multilib] Math Lib Loaded & safe to use.")
	end
end

return Lib