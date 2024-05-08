local Players = game:GetService("Players")

local Lib = {}

-- Core
function Lib:IsFirstPerson(Threshold: number)
	if Threshold == nil then
		Threshold = 0.2
	end
	if _G.M_Loader.Player.Character ~= nil then
		if _G.M_Loader.Player.Character.Head.LocalTransparencyModifier > Threshold then
			return true
		end
	end
	return false
end

function Lib:ForceFirstPerson(State: boolean)
	if State == true then
		_G.M_Loader.Player.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		_G.M_Loader.Player.CameraMode = Enum.CameraMode.Classic
	end
end

-- End
function Lib:Init()
	if _G.M_Loader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
