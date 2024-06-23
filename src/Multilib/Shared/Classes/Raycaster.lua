--!native

--[=[
	@class Raycaster Class
	Raycaster Class, used for raycasting.
]=]

local Raycaster = {}
Raycaster.__index = Raycaster

--[=[
	@within Raycaster Class
	@return <Raycaster>
	Returns Raycaster Class.
]=]

function Raycaster.new(params: RaycastParams)
	local self = setmetatable({}, Raycaster)
	self.Params = params
	return self
end

--[=[
	@within Raycaster Class
	@return <RaycastResult | false>
	Fires ray from given location to given location using given strength.
]=]

function Raycaster:RayFromTo(from: Vector3, to: Vector3, strength: number)
	to = CFrame.lookAt(from, to).LookVector * strength

	local rayResult = workspace:Raycast(from, to, self.Params)

	if rayResult ~= nil then
		return rayResult
	else
		return false
	end
end

--[=[
	@within Raycaster Class
	Destroys Raycaster Class.
]=]

function Raycaster:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return Raycaster
