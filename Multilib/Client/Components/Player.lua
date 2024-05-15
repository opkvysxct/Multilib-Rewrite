local Players = game:GetService("Players")

local Lib = {}

--[=[
	@class player
	@client
	player Functions.
]=]

-- Core

--[=[
	@within player
	@return <boolean> -- [true/false]
	Checks if the player is in first person.
]=]

function Lib:IsFirstPerson(threshold: number)
	if threshold == nil then
		threshold = 0.2
	end
	if _G.MLoader.player.Character ~= nil then
		if _G.MLoader.player.Character.Head.LocalTransparencyModifier > threshold then
			return true
		end
	end
	return false
end

--[=[
	@within player
	Sets player CameraMode.
]=]

function Lib:ForceFirstPerson(State: boolean)
	if State == true then
		_G.MLoader.player.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		_G.MLoader.player.CameraMode = Enum.CameraMode.Classic
	end
end

-- End
function Lib:Init()
	if _G.MLoader.comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
