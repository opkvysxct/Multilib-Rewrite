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
		paramsToUse = RaycastParams.New()
		paramsToUse.CollisionGroup = params.CG or "Default"
		paramsToUse.FilterDescendantsInstances = params.FDI or {}
		paramsToUse.FilterType = params.FT or Enum.RaycastFilterType.Exclude
		paramsToUse.IgnoreWater = params.IW or true
		paramsToUse.RespectCanCollide = params.RCC or false
		paramsToUse.BruteForceAllSlow = params.BFAS or false
	else
		paramsToUse = self.defParams
	end

	if typeofFrom == "instance" or typeofFrom == "CFrame" then
		from = from.position
	end
	if typeofTo == "instance" or typeofTo == "CFrame" then
		to = to.position
	end

	to = CFrame.lookAt(from, to).LookVector * strength

	local RayResult = workspace:Raycast(from, to, paramsToUse)

	if RayResult ~= nil then
		return RayResult
	else
		return false
	end
end

-- settings
function Lib:SetDefaultParams(params: any)
	local typeofParams = typeof(params)
	local newParams
	if typeofParams == "RaycastParams" then
		newParams = params
	elseif typeofParams == "table" then
		newParams = RaycastParams.New()
		newParams.CollisionGroup = params.CG or "Default"
		newParams.FilterDescendantsInstances = params.FDI or {}
		newParams.FilterType = params.FT or Enum.RaycastFilterType.Exclude
		newParams.IgnoreWater = params.IW or true
		newParams.RespectCanCollide = params.RCC or false
		newParams.BruteForceAllSlow = params.BFAS or false
	else
		warn("[Multilib-" .. script.Name .. "]", "No params specified!")
	end
	self.defParams = newParams
end

-- End
function Lib:Init()
	self.defParams = RaycastParams.new()
	if _G.MLoader.comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
