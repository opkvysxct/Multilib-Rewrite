--!native
local Lib = {}

-- Core
function Lib:Ray(from: any, to: any, strength: number, params: any)
	local typeofParams = typeof(params)
	local typeofFrom = typeof(from)
	local typeofTo = typeof(to)
	local paramsToUse

	if typeofParams == "RaycastParams" then
		paramsToUse = params
	elseif typeofParams == "table" then
		paramsToUse = RaycastParams.new()
		paramsToUse.CollisionGroup = params.CG or "Default"
		paramsToUse.FilterDescendantsInstances = params.FDI or {}
		paramsToUse.FilterType = params.FT or Enum.RaycastFilterType.Exclude
		paramsToUse.IgnoreWater = params.IW or true
		paramsToUse.RespectCanCollide = params.RCC or false
		paramsToUse.BruteForceAllSlow = params.BFAS or false
	else
		paramsToUse = self.DefParams
	end

	if typeofFrom == "instance" or typeofFrom == "CFrame" then
		from = from.Position
	end
	if typeofTo == "instance" or typeofTo == "CFrame" then
		to = to.Position
	end

	to = CFrame.lookAt(from, to).LookVector * strength

	local RayResult = workspace:Raycast(from, to, paramsToUse)

	if RayResult ~= nil then
		return RayResult
	else
		return false
	end
end

-- useSettings
function Lib:SetDefaultParams(params: any)
	local typeofParams = typeof(params)
	local newParams
	if typeofParams == "RaycastParams" then
		newParams = params
	elseif typeofParams == "table" then
		newParams = RaycastParams.new()
		newParams.CollisionGroup = params.CG or "Default"
		newParams.FilterDescendantsInstances = params.FDI or {}
		newParams.FilterType = params.FT or Enum.RaycastFilterType.Exclude
		newParams.IgnoreWater = params.IW or true
		newParams.RespectCanCollide = params.RCC or false
		newParams.BruteForceAllSlow = params.BFAS or false
	else
		warn("[Multilib-" .. script.Name .. "]", "No params specified!")
	end
	self.DefParams = newParams
end

-- End
function Lib:Init(comments: boolean)
	self.DefParams = RaycastParams.new()
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
