local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

local Lib = {}

-- Core
function Lib:Create(InstanceName: string, Parent: Instance, Proporties: table, parentAfter: boolean)
	local InstanceCreated
	if parentAfter then
		InstanceCreated = Instance.new(InstanceName)
	else
		InstanceCreated = Instance.new(InstanceName, Parent)
	end
	if _G.M_Loader.Comments then
		print("[Multilib-" .. script.Name .. "]", InstanceName, Parent, Proporties)
	end
	for prop, value in pairs(Proporties) do
		InstanceCreated[prop] = value
	end
	if parentAfter then
		InstanceCreated.Parent = Parent
	end
	return InstanceCreated
end

-- Misc
function Lib:DebrisF(Instance: Instance, Time: number, FuncAfter: any)
	Debris:AddItem(Instance, Time)
	if _G.M_Loader.Comments then
		print("[Multilib-" .. script.Name .. "]", "Destroying", Instance, "in", Time, "s.")
	end
	if FuncAfter ~= nil then
		task.delay(Time, FuncAfter)
	end
end

function Lib:SoundFX(Where: any, Specs: table)
	local ToDelete
	if typeof(Where) == "Vector3" then
		Where = self:Create("Part", workspace, {
			Size = Vector3.new(0, 0, 0),
			Position = Where,
			CanCollide = false,
			Anchored = true,
			Transparency = 1,
		})
		ToDelete = Where
		print("a")
	end
	local Sound = self:Create("Sound", Where, {
		Name = Specs.Name or "Sound",
		SoundId = "rbxassetid://" .. Specs.ID,
		Volume = Specs.Volume or 1,
		PlaybackSpeed = Specs.Speed or 1,
		RollOffMaxDistance = Specs.MaxDistance or 1000,
		RollOffMinDistance = Specs.MinDistance or 10,
		SoundGroup = SoundService.Master[Specs.Group] or SoundService.Master
	})
	Sound:Play()

	if ToDelete ~= nil then
		task.delay(self.MinSoundTime, function()
			self:DebrisF(Where, Specs.Duration or Sound.TimeLength)
		end)
	else
		task.delay(self.MinSoundTime, function()
			self:DebrisF(Sound, Specs.Duration or Sound.TimeLength)
		end)
	end
	return Sound
end

function Lib:ParticleFX(Particle: Instance, Strength: number, Where: any, WhereSize: Vector3)
	local ToDelete
	if typeof(Where) == "Vector3" then
		Where = self:Create("Part", workspace, {
			Size = WhereSize or Vector3.new(1, 1, 1),
			Position = Where,
			CanCollide = false,
			Anchored = true,
			Transparency = 1,
		})
		ToDelete = Where
	end
	local Particle = Particle:Clone()
	Particle.Parent = Where
	Particle:Emit(Strength)
	if ToDelete ~= nil then
		task.delay(self.MinParticleTime, function()
			self:DebrisF(Where, Particle.Lifetime.Max)
		end)
	else
		task.delay(self.MinParticleTime, function()
			self:DebrisF(Particle, Particle.Lifetime.Max)
		end)
	end
	return Particle
end

function Lib:Motor6D(First: Instance, Second: Instance, Parent: Instance)
	return self:Create(
		"Motor6D",
		Parent,{
			Part0 = First,
			Part1 = Second,
		}
	)
end

function Lib:Animation(ID: number, Animator: Instance)
	local Animation = self:Create("Animation", nil, {
		AnimationId = "rbxassetid://" .. ID,
	})
	return Animator:LoadAnimation(Animation)
end

-- Settings
function Lib:SetMinSoundTime(Time: number)
	self.MinSoundTime = Time
end

function Lib:MinParticleTime(Time: number)
	self.MinParticleTime = Time
end

-- End
function Lib:Init()
	self.MinSoundTime = 1 -- Try to keep it at least one second, otherwise TimeLength will not load properly and sound will not play
	self.MinParticleTime = 1
	if _G.M_Loader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
