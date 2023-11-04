local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Parallel Component

local Lib = {}

-- Core
function Lib:PutToParallel(Script, Where)
	if not ReplicatedStorage:FindFirstChild(Where) then
		_G.M_Instance:Create("Folder",ReplicatedStorage,{Name = Where})
	end
	local Actor = _G.M_Instance:Create("Actor",ReplicatedStorage[Where],{Name = Script.Name .. "_Actor"})
	Script = Script:Clone()
	Script.Parent = Actor
	return Script, Actor
end

-- End

function Lib:Init()
	if _G.M_Loader.Comments then
		print("[Multilib] Parallel Lib Loaded & safe to use.")
	end
end

return Lib