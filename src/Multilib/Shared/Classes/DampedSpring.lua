local DampedSpring = {}
DampedSpring.__index = DampedSpring

--[=[
	@class DampedSpring Class
	DampedSpring Class.

	Note: Its very simple implementation of a spring, its better to use other better classes for it, like Spring from NevermoreEngine created by Quenty.
]=]

--[=[
	@within DampedSpring Class
	@return <DampedSpringClass>
	Creates DampedSpring Class.
]=]

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
	self._Mass = mass or 1
	self.Position = position or 0
	self.Target = target or 15
	self._Speed = speed or 5
	self._Velocity = velocity or 0
	self._KConstant = constant or 0.05
	self._CDamping = dampingC or 0.1
	return self
end

--[=[
	@within DampedSpring Class
	Sets target for DampedSpring Class.
]=]

function DampedSpring:SetTarget(target: number)
	self.Target = target
end

--[=[
	@within DampedSpring Class
	Updates position for DampedSpring Class.
]=]

function DampedSpring:Update(deltaTime: number)
	local acceleration = (-self._CDamping * self._Velocity - self._KConstant * (self.Position - self.Target)) / self._Mass
	acceleration = (acceleration * deltaTime) * self._Speed
	self._Velocity = self._Velocity + acceleration
	self.Position = self.Position + self._Velocity
end

--[=[
	@within DampedSpring Class
	Destroys DampedSpring Class.
]=]

function DampedSpring:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return DampedSpring
