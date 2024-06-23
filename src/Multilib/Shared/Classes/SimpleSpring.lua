local Spring = {}
Spring.__index = Spring

--[=[
	@class SimpleSpring Class
	SimpleSpring Class.
	Note: Its very simple implementation of a spring, its better to use other better classes for it, like Spring from NevermoreEngine created by Quenty.
]=]

--[=[
	@within SimpleSpring Class
	@return <SimpleSpring>
	Creates SimpleSpring Class.
]=]

function Spring.new(position: number, target: number, speed: number, constant: number)
	local self = setmetatable({}, Spring)
	self.time = os.clock()
	self.Position = position or 0
	self.Target = target or 15
	self._Speed = speed or 1
	self._KConstant = constant or 0.01
	return self
end

--[=[
	@within SimpleSpring Class
	Sets target for spring.
]=]

function Spring:SetTarget(target: number)
	self.Target = target
end

--[=[
	@within SimpleSpring Class
	Updates the spring position.
]=]

function Spring:Update(deltaTime: number)
	local xDistance
	if self.Position > self.Target then
		xDistance = self.Position - self.Target
	elseif self.Position < self.Target then
		xDistance = self.Target - self.Position
	else
		xDistance = 0
	end
	local force = (-self._KConstant * xDistance) * self._Speed
	self.Position -= force * deltaTime
end

--[=[
	@within SimpleSpring Class
	Deletes SimpleSpring Class.
]=]

function Spring:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return Spring
