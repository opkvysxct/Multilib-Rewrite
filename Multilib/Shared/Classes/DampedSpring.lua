local DampedSpring = {}
DampedSpring.__index = DampedSpring

function DampedSpring.new(
	position: number,
	mass: number,
	target: number,
	speed: number,
	velocity: number,
	constant: number,
	dampingC: number
)
	local self = setmetatable({}, DampedSpring)
	self.mass = mass or 1
	self.position = position or 0
	self.target = target or 15
	self.speed = speed or 5
	self.velocity = velocity or 0
	self.kConstant = constant or 0.05
	self.cDampingC = dampingC or 0.1
	return self
end

function DampedSpring:SetTarget(target: number)
	self.target = target
end

function DampedSpring:Update(deltaTime: number)
	local acceleration = (-self.cDampingC * self.velocity - self.kConstant * (self.position - self.target)) / self.mass
	acceleration = (acceleration * deltaTime) * self.speed
	self.velocity = self.velocity + acceleration
	self.position = self.position + self.velocity
end

return DampedSpring
