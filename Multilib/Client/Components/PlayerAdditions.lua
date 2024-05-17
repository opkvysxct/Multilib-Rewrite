local Players = game:GetService("Players")

local Lib = {}

--[=[
	@class Player
	@client
	player Functions.
]=]

-- Core

--[=[
	@within Player
	@return <boolean> -- [true/false]
	Checks if the player is in first person.
]=]

function Lib:IsFirstPerson(threshold: number)
	if threshold == nil then
		threshold = 0.2
	end
	if Players.LocalPlayer.Character ~= nil then
		if Players.LocalPlayer.Character.Head.LocalTransparencyModifier > threshold then
			return true
		end
	end
	return false
end

--[=[
	@within Player
	Sets player CameraMode.
]=]

function Lib:ForceFirstPerson(State: boolean)
	if State == true then
		Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
	end
end

-- End
function Lib:Init(comments: boolean)
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
