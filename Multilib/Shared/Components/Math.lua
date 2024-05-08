local Lib = {}

-- Core

function Lib:Chance(Percent: number, Max: number)
	if math.random(1, Max) <= Percent then
		return true
	else
		return false
	end
end

function Lib:DrawObject(totalChances: number, objectTable: table, chanceFieldName: string)
	local cumulativeChances = {}
	local currentChance = 0
	for _, object in ipairs(objectTable) do
		local chance = object[chanceFieldName]
		currentChance = currentChance + chance
		cumulativeChances[object.ID] = currentChance
  	end

	local randomChance = math.random(0, totalChances)

	for index, chance: number in pairs(cumulativeChances) do
		if chance <= randomChance then continue end
		return objectTable[index]
	end
end

function Lib:Choose(Table : table)
	local Amount = 0
	local TableOfRanges = {}
	for i, v in ipairs(Table) do
		TableOfRanges[i] = NumberRange.new(Amount, Amount + v.Chance)
		Amount += v.Chance	
	end
	local ChosenNumber = math.random(1, Amount)
	for i, v in ipairs(TableOfRanges) do
		if ChosenNumber > v.Min and ChosenNumber <= v.Max then
			return Table[i]
		end
	end
end 

function Lib:ReturnChance(Percent: number, Total: number) -- sani
	return math.floor((Percent / Total * 100) * 10 + 0.5) / 10
end

function Lib:Lerp(a: number, b: number, t: number)
	return a + ((b - a) * t)
end

-- End
function Lib:Init()
	if _G.MLoader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
