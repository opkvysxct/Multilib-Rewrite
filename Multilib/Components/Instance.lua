local Debris = game:GetService("Debris")
-- Instance Component

local Lib = {}

-- Core
function Lib:Create(InstanceName : string,Parent : Instance,Proporties : table)
	local InstanceCreated = Instance.new(InstanceName,Parent)
	if _G.M_Loader.Comments then
		print("[Multilib-Instance]",InstanceName,Parent,Proporties)
	end
	for prop, value in pairs(Proporties) do
		InstanceCreated[prop] = value
	end
	return InstanceCreated
end

-- Misc
function Lib:DebrisF(Instance : Instance, Time : number, Func)
	Debris:AddItem(Instance,Time)
	if _G.M_Loader.Comments then
		print("[Multilib-Instance] Destroying",Instance,"in",Time,"s.")
	end
	if Func ~= nil then
		task.delay(Time,Func)
	end
end

function Lib:SoundFX(Where : any,Specs : table)
	local ToDelete
	if typeof(Where) == "Vector3" then
		Where = self:Create("Part",workspace,{
			Size = Vector3.new(0,0,0),
			Position = Where,
			CanCollide = false,
			Anchored = true,
			Transparency = 1
		})
		ToDelete = Where
	end
	local Sound = self:Create("Sound",Where,{
		SoundId = "rbxassetid://" .. Specs.ID,
		Volume = Specs.Volume or 1,
		PlaybackSpeed = Specs.Speed or 1,
		RollOffMaxDistance = Specs.MaxDistance or 1000,
		RollOffMinDistance = Specs.MinDistance or 10
	})
	Sound:Play()
	
	if ToDelete ~= nil then
		task.delay(self.MinSoundTime,function()
			self:DebrisF(Where,Sound.TimeLength)
		end)
	else
		task.delay(self.MinSoundTime,function()
			self:DebrisF(Sound,Sound.TimeLength)
		end)
	end
	return Sound
end

function Lib:ParticleFX(Particle : Instance, Strength : number, Where : any, WhereSize : Vector3)
	local ToDelete
	if typeof(Where) == "Vector3" then
		Where = self:Create("Part",workspace,{
			Size = WhereSize or Vector3.new(1,1,1),
			Position = Where,
			CanCollide = false,
			Anchored = true,
			Transparency = 1
		})
		ToDelete = Where
	end
	local Particle = Particle:Clone()
	Particle.Parent = Where
	Particle:Emit(Strength)
	if ToDelete ~= nil then
		task.delay(self.MinSoundTime,function()
			self:DebrisF(Where,Particle.Lifetime.Max)
		end)
	else
		task.delay(self.MinSoundTime,function()
			self:DebrisF(Particle,Particle.Lifetime.Max)
		end)
	end
	return Particle
end

function Lib:Motor6D(First : Instance, Second : Instance, Parent : Instance)
	return self:Create("Motor6D",Parent{
		Part0 = First,
		Part1 = Second
	})
end

function Lib:Animation(ID : number, Animator : Instance)
	local Animation = self:Create("Animation",nil,{
		AnimationId = "rbxassetid://" .. ID
	})
	return Animator:LoadAnimation(Animation)
end

-- End

function Lib:Init()
	self.MinSoundTime = 1 -- Try to keep it at least one second, otherwise TimeLength will not load properly and sound will not play
	if _G.M_Loader.Comments then
		print("[Multilib] Instance Lib Loaded & safe to use.")
	end
end

return Lib