local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

local Lib = {}

-- Core
function Lib:Create(instanceName: string, parent: Instance, proporties: table, parentAfter: boolean)
	local instanceCreated
	if parentAfter then
		instanceCreated = Instance.New(instanceName)
	else
		instanceCreated = Instance.New(instanceName, parent)
	end
	if _G.MLoader.comments then
		print("[Multilib-" .. script.Name .. "]", instanceName, parent, proporties)
	end
	for prop, value in pairs(proporties) do
		instanceCreated[prop] = value
	end
	if parentAfter then
		instanceCreated.Parent = parent
	end
	return instanceCreated
end

-- Misc
function Lib:DebrisF(instance: Instance, time: number, funcAfter: any)
	Debris:AddItem(instance, time)
	if _G.MLoader.comments then
		print("[Multilib-" .. script.Name .. "]", "Destroying", instance, "in", time, "s.")
	end
	if funcAfter ~= nil then
		task.delay(time, funcAfter)
	end
end

function Lib:SoundFX(where: any, specs: table)
	local toDelete
	if typeof(where) == "Vector3" then
		where = self:Create("Part", workspace, {
			Size = Vector3.New(0, 0, 0),
			position = where,
			CanCollide = false,
			Anchored = true,
			Transparency = 1,
		})
		toDelete = where
		print("a")
	end
	local sound = self:Create("Sound", where, {
		Name = specs.Name or "sound",
		SoundId = "rbxassetid://" .. specs.id,
		Volume = specs.Volume or 1,
		PlaybackSpeed = specs.speed or 1,
		RollOffMaxDistance = specs.MaxDistance or 1000,
		RollOffMinDistance = specs.MinDistance or 10,
		SoundGroup = SoundService.Master[specs.Group] or SoundService.Master
	})
	sound:Play()

	if toDelete ~= nil then
		task.delay(self.minSoundTime, function()
			self:DebrisF(where, specs.Duration or sound.TimeLength)
		end)
	else
		task.delay(self.minSoundTime, function()
			self:DebrisF(sound, specs.Duration or sound.TimeLength)
		end)
	end
	return sound
end

function Lib:ParticleFX(particle: Instance, strength: number, where: any, WhereSize: Vector3)
	local toDelete
	if typeof(where) == "Vector3" then
		where = self:Create("Part", workspace, {
			Size = WhereSize or Vector3.New(1, 1, 1),
			position = where,
			CanCollide = false,
			Anchored = true,
			Transparency = 1,
		})
		toDelete = where
	end
	local particle = particle:Clone()
	particle.Parent = where
	particle:Emit(strength)
	if toDelete ~= nil then
		task.delay(self.minParticleTime, function()
			self:DebrisF(where, particle.Lifetime.Max)
		end)
	else
		task.delay(self.minParticleTime, function()
			self:DebrisF(particle, particle.Lifetime.Max)
		end)
	end
	return particle
end

function Lib:Motor6D(first: Instance, second: Instance, Parent: Instance)
	return self:Create(
		"Motor6D",
		Parent,{
			Part0 = first,
			Part1 = second,
		}
	)
end

function Lib:Animation(id: number, animator: Instance)
	local Animation = self:Create("Animation", nil, {
		AnimationId = "rbxassetid://" .. id,
	})
	return animator:LoadAnimation(Animation)
end

-- settings
function Lib:SetMinSoundTime(time: number)
	self.minSoundTime = time
end

function Lib:minParticleTime(time: number)
	self.minParticleTime = time
end

-- End
function Lib:Init()
	self.minSoundTime = 1 -- Try to keep it at least one second, otherwise TimeLength will not load properly and sound will not play
	self.minParticleTime = 1
	if _G.MLoader.comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
