local Players = game:GetService("Players")
local Lib = {}

--[=[
	@class Shared Player Package
	SharedPlayer Utils.
]=]

-- Core

--[=[
	@within Shared Player Package
	@return <Player | false>
	Tries to find Player by part.
]=]

-- Core
function Lib:ReturnPlayerByPart(part: Instance)
	if part.Parent:FindFirstChild("Humanoid") then
		local character = part.Parent
		if Players:GetPlayerFromCharacter(character) then
			return Players:GetPlayerFromCharacter(character)
		end
	end
	return false
end

--[=[
	@within Shared Player Package
	@return <Instance | false>
	Tries to find Character by part.
]=]

function Lib:ReturnCharacterByPart(part: Instance)
	if part.Parent:FindFirstChild("Humanoid") then
		return part.Parent
	end
	return false
end

-- End
function Lib:Init(comments: boolean)
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib