local RunService = game:GetService("RunService")
--Loading schemat
_G.M_Loader = require(game:GetService("ReplicatedStorage").Multilib)
_G.M_Loader:Init(false)

--Instance Lib
--Create("Instance name", Parent, {Proporties})
local Part = _G.M_Instance:Create("Part",workspace,{Size = Vector3.new(1,1,1)})

--DebrisF(Instance,Time,Function (optional))
_G.M_Instance:DebrisF(Part,5,function()
	print('a')
end)

--SoundFX({Specs},Instance or Vector3)
_G.M_Instance:SoundFX(Vector3.new(0,0,0),{
	ID = 1837819000,
	Volume = 1,
	Speed = 1,
	MaxDistance = 1000,
	MinDistance = 10,
})

local ParticleToUse = script:WaitForChild("ParticleEmitter") -- any particle emitter
--ParticleFX(Particle,Strength,Instance or Vector3, size of Vector3 (optional))
_G.M_Instance:ParticleFX(ParticleToUse,15,Vector3.new(0,50,0),Vector3.new(1,1,5))

--Motor6D(Instance, Instance, Parent)

--Animation(ID, Animator)

local Spring = _G.M_Spring:new()

local timed = 1
RunService.Heartbeat:Connect(function(deltaTime)
	timed += 1
	Spring:Update()
	print(Spring.Position)
	_G.M_Instance:Create("Part",workspace,{
		Size = Vector3.new(1,1,1),
		Position = Vector3.new(timed,Spring.Position * 2,0),
		Anchored = true,
	})
end)