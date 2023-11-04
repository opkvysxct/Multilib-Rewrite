local RunService = game:GetService("RunService")
--Loading schemat
_G.M_Loader = require(game:GetService("ReplicatedStorage").Multilib)
_G.M_Loader:Init(true)

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

--local ParticleToUse = script:WaitForChild("ParticleEmitter") -- any particle emitter
--ParticleFX(Particle,Strength,Instance or Vector3, size of Vector3 (optional))
--_G.M_Instance:ParticleFX(ParticleToUse,15,Vector3.new(0,50,0),Vector3.new(1,1,5))

--Motor6D(Instance, Instance, Parent)

--Animation(ID, Animator)

local Spring = _G.M_Spring:new()

--[[local timed = 1
RunService.Heartbeat:Connect(function(deltaTime)
	timed += 1
	Spring:Update()
	_G.M_Instance:Create("Part",workspace,{
		Size = Vector3.new(1,1,1),
		Position = Vector3.new(timed,Spring.Position * 15,0),
		Anchored = true,
	})
end)--]]

--Delta
local delta, z = _G.M_Math:Delta(-2,8,1)
print(delta, z)

--Ray(instance or cframe or position,instance or cframe or position,strength,params(optional))
print(_G.M_Raycast:Ray(workspace.r1.CFrame,workspace.r2,1000,{
	CG = "Default", -- CollisionGroup
	FDI = {workspace.r2}, -- FilterDescendantsInstances
	FT = Enum.RaycastFilterType.Include, -- FilterType
	IW = true, -- IgnoreWater
	RCC = true -- RespectCanCollide
}))

print(_G.M_Math:Pythagorean(5,5))

_G.M_Parallel:PutToParallel(script,"Location")