local Spring = {}
Spring.__index = Spring

function Spring:new(Position : number, Target : number, Speed : number, Constant : number)
	local self = setmetatable({}, Spring)
	self.Time = os.clock()
	self.Position = Position or 0
	self.Target = Target or 15
	self.Speed = Speed or 1
	self.KConstant = Constant or 0.01
	return self
end

function Spring:SetTarget(Target : number)
	self.Target = Target
end

function Spring:Update(DeltaTime : number)
	local function Update()
		if DeltaTime ~= nil then
			return self.Time + DeltaTime
		else
			return os.clock()
		end
	end
	self.Time = Update()
	local XDistance
	if self.Position > self.Target then
		XDistance = self.Position - self.Target
	elseif self.Position < self.Target then
		XDistance= self.Target - self.Position
	else
		XDistance = 0
	end
	local Force = (-self.KConstant * XDistance) * self.Speed
	self.Position -= Force
end

return Spring