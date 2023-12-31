local Lib = {}

-- Core
function Lib:Delta(a : number, b : number, c : number)
	local Delta
	local Z
	if a ~= 0 then
		Delta = math.pow(b, 2) - 4 * a * c
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

function Lib:Pythagorean(a : number, b : number)
	local c = math.sqrt(math.pow(a,2) + math.pow(b,2))
	return c
end

-- Misc
function Lib:Chance(Percent : number, Max : number)
	if math.random(1,Max) <= Percent then
		return true
	else
		return false
	end
end

function Lib:ReturnChance(Percent : number, Total : number) -- sani
	return math.floor((Percent / Total * 100) * 10 + 0.5) / 10
end

function Lib:Lerp(a : number, b : number, t : number)
	return a + (a + (b - a)) * t
end

-- End
function Lib:Init()
	if _G.M_Loader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name , "Lib Loaded & safe to use.")
	end
end

return Lib