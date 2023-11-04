-- Raycast Component

local Lib = {}

-- Core
function Lib:Ray(From : any, To : any, Strength : number, Params : any)
	local typeofParams = typeof(Params)
	local typeofFrom = typeof(From)
	local typeofTo = typeof(To)
	local ParamsToUse

	if typeofParams == "RaycastParams" then
		ParamsToUse = Params
	elseif typeofParams == "table" then
		ParamsToUse = RaycastParams.new()
		ParamsToUse.CollisionGroup = Params.CG or "Default"
		ParamsToUse.FilterDescendantsInstances = Params.FDI or {}
		ParamsToUse.FilterType = Params.FT or Enum.RaycastFilterType.Exclude
		ParamsToUse.IgnoreWater = Params.IW or true
		ParamsToUse.RespectCanCollide = Params.RCC or true
	else
		ParamsToUse = self.DefParams
	end

	if typeofFrom == "Instance" or typeofFrom == "CFrame" then
		From = From.Position
	end
	if typeofTo == "Instance" or typeofTo == "CFrame" then
		To = To.Position
	end

	To = CFrame.lookAt(From, To).LookVector * Strength

	local RayResult = workspace:Raycast(From,To,ParamsToUse)

	if RayResult ~= nil then
		return RayResult
	else
		return false
	end
end

-- End

function Lib:Init()
	self.DefParams = RaycastParams.new()
	if _G.M_Loader.Comments then
		print("[Multilib] Raycast Lib Loaded & safe to use.")
	end
end

return Lib