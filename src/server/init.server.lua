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

--SoundFX({Specs},Instance or Vector3 as position)
_G.M_Instance:SoundFX(Vector3.new(0,0,0),{
	ID = 1837819000,
	Volume = 1,
	Speed = 1,
	MaxDistance = 1000,
	MinDistance = 10,
})