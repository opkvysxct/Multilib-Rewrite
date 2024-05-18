local Debris = game:GetService("Debris")
local Multilib = require(game:GetService("ReplicatedStorage").Multilib)

local Lib = {}

-- Core
function Lib:Create(instanceName: string, parent: Instance, proporties: {any}, parentAfter: boolean?)
	local instanceCreated
	if parentAfter then
		instanceCreated = Instance.new(instanceName)
	else
		instanceCreated = Instance.new(instanceName, parent)
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

function Lib:SoundFX(where: any, specs: Multilib.SoundSpecs)
	local toDelete
	if typeof(where) == "Vector3" then
		where = self:Create("Part", workspace, {
			Size = Vector3.new(0, 0, 0),
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
		SoundId = "rbxassetid://" .. specs.SoundId,
		Volume = specs.Volume or 1,
		PlaybackSpeed = specs.PlaybackSpeed or 1,
		RollOffMaxDistance = specs.MaxDistance or 1000,
		RollOffMinDistance = specs.MinDistance or 10,
		SoundGroup = specs.SoundGroup or nil
	})
	sound:Play()

	if toDelete ~= nil then
		task.delay(self.minSoundTime, function()
			Debris:AddItem(where, specs.Duration or sound.TimeLength)
		end)
	else
		task.delay(self.minSoundTime, function()
			Debris:AddItem(sound, specs.Duration or sound.TimeLength)
		end)
	end
	return sound
end

function Lib:ParticleFX(particle: Instance, strength: number, where: any, WhereSize: Vector3?)
	local toDelete
	if typeof(where) == "Vector3" then
		where = self:Create("Part", workspace, {
			Size = WhereSize or Vector3.new(1, 1, 1),
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
			Debris:AddItem(where, particle.Lifetime.Max)
		end)
	else
		task.delay(self.minParticleTime, function()
			Debris:AddItem(particle, particle.Lifetime.Max)
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
function Lib:Init(comments: boolean)
	self.minSoundTime = 1
	self.minParticleTime = 1
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
