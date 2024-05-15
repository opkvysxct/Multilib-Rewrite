local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lib = {}

-- Core
function Lib:PutToParallel(Script: Script, where: any)
	if not ReplicatedStorage:FindFirstChild(where) then
		_G.MInstance:Create("Folder", ReplicatedStorage, { Name = where })
	end
	local Actor = _G.MInstance:Create("Actor", ReplicatedStorage[where], { Name = Script.Name .. "_Actor" })
	Script = Script:Clone()
	Script.parent = Actor
	return Script, Actor
end

-- End
function Lib:Init()
	if _G.MLoader.comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
