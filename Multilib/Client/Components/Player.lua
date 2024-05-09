local Players = game:GetService("Players")

local Lib = {}

--[=[
	@class Player
	@client
	Player Functions.
]=]

-- Core

--[=[
	@within Player
	@return <boolean> -- [true/false]
	Checks if the player is in first person.
]=]

function Lib:IsFirstPerson(Threshold: number)
	if Threshold == nil then
		Threshold = 0.2
	end
	if _G.MLoader.Player.Character ~= nil then
		if _G.MLoader.Player.Character.Head.LocalTransparencyModifier > Threshold then
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
		_G.MLoader.Player.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		_G.MLoader.Player.CameraMode = Enum.CameraMode.Classic
	end
end

-- End
function Lib:Init()
	if _G.MLoader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
