local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lib = {}

--[=[
	@class Parallel Package
	Parallel Utils.
]=]

-- Core

--[=[
	@within Parallel Package
	@return <Script, Actor>
	Puts given script for later usage as a Parallel script.
]=]

function Lib:PutToParallel(scriptToUse: Script, where: Instance)
	if not ReplicatedStorage:FindFirstChild(where) then
		local folder = Instance.new("Folder")
		folder.Parent = ReplicatedStorage
		folder.Name = where
	end
	local actor = Instance.new("Actor")
	actor.Name = scriptToUse.Name .. "_Actor"
	actor.Parent = ReplicatedStorage[where]
	scriptToUse = scriptToUse:Clone()
	scriptToUse.Parent = actor
	return scriptToUse, actor
end

-- End
function Lib:Init(comments: boolean)
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
