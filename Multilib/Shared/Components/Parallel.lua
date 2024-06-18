local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lib = {}

-- Core
function Lib:PutToParallel(Script: Script, where: any)
	if not ReplicatedStorage:FindFirstChild(where) then
		local Folder = Instance.new("Folder")
		Folder.Parent = ReplicatedStorage
		Folder.Name = where
	end
	local Actor = Instance.new("Actor")
	Actor.Name = Script.Name .. "_Actor"
	Actor.Parent = ReplicatedStorage[where]
	Script = Script:Clone()
	Script.Parent = Actor
	return Script, Actor
end

-- End
function Lib:Init(comments: boolean)
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
