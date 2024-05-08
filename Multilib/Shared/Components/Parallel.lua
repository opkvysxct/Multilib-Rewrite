local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lib = {}

-- Core
function Lib:PutToParallel(Script: Script, Where: any)
	if not ReplicatedStorage:FindFirstChild(Where) then
		_G.MInstance:Create("Folder", ReplicatedStorage, { Name = Where })
	end
	local Actor = _G.MInstance:Create("Actor", ReplicatedStorage[Where], { Name = Script.Name .. "_Actor" })
	Script = Script:Clone()
	Script.Parent = Actor
	return Script, Actor
end

-- End
function Lib:Init()
	if _G.MLoader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
