local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lib = {}

-- Core
function Lib:PutToParallel(Script: Script, where: any)
	if not ReplicatedStorage:FindFirstChild(where) then
		local Folder = Instance.new("Folder",ReplicatedStorage)
		Folder.Name = where
	end
	local Actor = Instance.new("Actor",ReplicatedStorage[where])
	Actor.Name = Script.Name .. "_Actor"
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
