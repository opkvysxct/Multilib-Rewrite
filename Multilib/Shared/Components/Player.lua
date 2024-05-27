local Players = game:GetService("Players")
local Lib = {}

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

function Lib:ReturnCharacterByPart(part: Instance)
	if part.Parent:FindFirstChild("Humanoid") then
		return part.Parent
	end
	return false
end


-- settings
function Lib:SetCustomValue(value: string)
	self.CustomValue = value
end

-- End
function Lib:Init(comments: boolean)
	self.CustomValue = "Change Me!"
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib