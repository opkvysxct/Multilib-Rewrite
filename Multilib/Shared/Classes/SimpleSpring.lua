local Spring = {}
Spring.__index = Spring

function Spring:new(Position : number, Target : number, Speed : number, Constant : number)
	local self = setmetatable({}, Spring)
	self.Time = os.clock()
	self.Position = Position or 0
	self.Target = Target or 15
	self.Speed = Speed or 1
	self.K_Constant = Constant or 0.01
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
	local X_Distance
	if self.Position > self.Target then
		X_Distance = self.Position - self.Target
	elseif self.Position < self.Target then
		X_Distance= self.Target - self.Position
	else
		X_Distance = 0
	end
	local Force = (-self.K_Constant * X_Distance) * self.Speed
	self.Position -= Force
end

return Spring