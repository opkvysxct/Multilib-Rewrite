local Lib = {}

-- Core
function Lib:Ray(From: any, To: any, Strength: number, Params: any)
	local typeofParams = typeof(Params)
	local typeofFrom = typeof(From)
	local typeofTo = typeof(To)
	local ParamsToUse

	if typeofParams == "RaycastParams" then
		ParamsToUse = Params
	elseif typeofParams == "table" then
		ParamsToUse = RaycastParams.New()
		ParamsToUse.CollisionGroup = Params.CG or "Default"
		ParamsToUse.FilterDescendantsInstances = Params.FDI or {}
		ParamsToUse.FilterType = Params.FT or Enum.RaycastFilterType.Exclude
		ParamsToUse.IgnoreWater = Params.IW or true
		ParamsToUse.RespectCanCollide = Params.RCC or false
		ParamsToUse.BruteForceAllSlow = Params.BFAS or false
	else
		ParamsToUse = self.DefParams
	end

	if typeofFrom == "instance" or typeofFrom == "CFrame" then
		From = From.position
	end
	if typeofTo == "instance" or typeofTo == "CFrame" then
		To = To.position
	end

	To = CFrame.lookAt(From, To).LookVector * Strength

	local RayResult = workspace:Raycast(From, To, ParamsToUse)

	if RayResult ~= nil then
		return RayResult
	else
		return false
	end
end

-- settings
function Lib:SetDefaultParams(Params: any)
	local typeofParams = typeof(Params)
	local NewParams
	if typeofParams == "RaycastParams" then
		NewParams = Params
	elseif typeofParams == "table" then
		NewParams = RaycastParams.New()
		NewParams.CollisionGroup = Params.CG or "Default"
		NewParams.FilterDescendantsInstances = Params.FDI or {}
		NewParams.FilterType = Params.FT or Enum.RaycastFilterType.Exclude
		NewParams.IgnoreWater = Params.IW or true
		NewParams.RespectCanCollide = Params.RCC or false
		NewParams.BruteForceAllSlow = Params.BFAS or false
	else
		warn("[Multilib-" .. script.Name .. "]", "No params specified!")
	end
	self.DefParams = NewParams
end

-- End
function Lib:Init()
	self.DefParams = RaycastParams.New()
	if _G.MLoader.comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
