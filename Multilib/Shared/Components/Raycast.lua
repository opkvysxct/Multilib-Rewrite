--!native
local Mtypes = require(script.Parent.Parent.Parent.Types)
local Lib = {}

--[=[
	@class Raycast Package
	Raycast Utils.
]=]

-- Core

--[=[
	@within Raycast Package
	@return <RaycastResult | false>
	Fires ray from given location to given location using given strength.
]=]

function Lib:Ray(from: any, to: any, strength: number, params: RaycastParams?)
	local typeofParams = typeof(params)
	local typeofFrom = typeof(from)
	local typeofTo = typeof(to)
	local paramsToUse

	if typeofParams == "RaycastParams" then
		paramsToUse = params
	else
		paramsToUse = self.DefParams
	end

	if typeofFrom == "Instance" or typeofFrom == "CFrame" then
		from = from.Position
	end
	if typeofTo == "Instance" or typeofTo == "CFrame" then
		to = to.Position
	end

	to = CFrame.lookAt(from, to).LookVector * strength

	local rayResult = workspace:Raycast(from, to, paramsToUse)

	if rayResult ~= nil then
		return rayResult
	else
		return false
	end
end

-- useSettings

--[=[
	@within Raycast Package
	Sets default RaycastParams.
]=]

function Lib:SetDefaultParams(params: RaycastParams)
	assert(typeof(params) == "RaycastParams", "[Multilib-" .. script.Name .. "] " .. "Wrong type or no value provided for params.")
	self.DefParams = params
end

-- End
function Lib:Init(comments: boolean)
	self.DefParams = RaycastParams.new()
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
