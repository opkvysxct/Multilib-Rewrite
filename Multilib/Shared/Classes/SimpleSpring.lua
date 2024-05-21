local Spring = {}
Spring.__index = Spring

function Spring.new(position: number, target: number, speed: number, constant: number)
	local self = setmetatable({}, Spring)
	self.time = os.clock()
	self.Position = position or 0
	self.Target = target or 15
	self._Speed = speed or 1
	self._KConstant = constant or 0.01
	return self
end

function Spring:SetTarget(target: number)
	self.Target = target
end

function Spring:Update(deltaTime: number)
	local xDistance
	if self.Position > self.Target then
		xDistance = self.Position - self.Target
	elseif self.Position < self.Target then
		xDistance = self.Target - self.Position
	else
		xDistance = 0
	end
	local Force = (-self._KConstant * xDistance) * self._Speed
	self.Position -= Force * deltaTime
end

return Spring
