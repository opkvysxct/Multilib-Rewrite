local DampedSpring = {}
DampedSpring.__index = DampedSpring

function DampedSpring.new(
	Position: number,
	Mass: number,
	Target: number,
	Speed: number,
	Velocity: number,
	Constant: number,
	DampingC: number
)
	local self = setmetatable({}, DampedSpring)
	self.Mass = Mass or 1
	self.Position = Position or 0
	self.Target = Target or 15
	self.Speed = Speed or 5
	self.Velocity = Velocity or 0
	self.K_Constant = Constant or 0.05
	self.C_DampingC = DampingC or 0.1
	return self
end

function DampedSpring:SetTarget(Target: number)
	self.Target = Target
end

function DampedSpring:Update(DeltaTime: number)
	local acceleration = (-self.C_DampingC * self.Velocity - self.K_Constant * (self.Position - self.Target)) / self.Mass
	acceleration = (acceleration * DeltaTime) * self.Speed
	self.Velocity = self.Velocity + acceleration
	self.Position = self.Position + self.Velocity
end

return DampedSpring
