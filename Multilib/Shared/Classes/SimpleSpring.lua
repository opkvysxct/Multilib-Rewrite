local Spring = {}
Spring.__index = Spring

function Spring.new(position: number, target: number, speed: number, constant: number)
	local self = setmetatable({}, Spring)
	self.time = os.clock()
	self.position = position or 0
	self.target = target or 15
	self.speed = speed or 1
	self.kConstant = constant or 0.01
	return self
end

function Spring:SetTarget(target: number)
	self.target = target
end

function Spring:Update(deltaTime: number)
	local xDistance
	if self.position > self.target then
		xDistance = self.position - self.target
	elseif self.position < self.target then
		xDistance = self.target - self.position
	else
		xDistance = 0
	end
	local Force = (-self.kConstant * xDistance) * self.speed
	self.position -= Force * deltaTime
end

return Spring
