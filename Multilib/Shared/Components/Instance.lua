local Debris = game:GetService("Debris")
local Mtypes = require(game:GetService("ReplicatedStorage").Multilib.Types)

local Lib = {}

-- Core
function Lib:Create(instanceName: string, parent: Instance, proporties: {any}, parentAfter: boolean?)
	local instanceCreated
	if parentAfter then
		instanceCreated = Instance.new(instanceName)
	else
		instanceCreated = Instance.new(instanceName, parent)
	end
	for prop, value in proporties do
		instanceCreated[prop] = value
	end
	if parentAfter then
		instanceCreated.Parent = parent
	end
	return instanceCreated
end

function Lib:PerfectClone(trueModel: any, trueElements: {any})
	local model = trueModel:Clone()
	local elements = {}
	for index, element in trueElements do
		local path = string.split(element,"/")
		local followedPath = model
		for _, value in path do
			if followedPath:FindFirstChild(value) then
				followedPath = followedPath[value]
			else
				error("[Multilib-" .. script.Name .. "]" .. " Path not found.")
			end
		end
		elements[index] = followedPath
	end
	return model, elements
end


-- Misc

function Lib:SoundFX(where: any, specs: Mtypes.SoundSpecs)
	local toDelete
	if typeof(where) == "Vector3" then
		where = self:Create("Part", workspace, {
			Size = Vector3.new(0, 0, 0),
			Position = where,
			CanCollide = false,
			Anchored = true,
			Transparency = 1,
		})
		toDelete = where
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
		task.delay(self.MinSoundTime, function()
			Debris:AddItem(where, specs.Duration or sound.TimeLength)
		end)
	else
		task.delay(self.MinSoundTime, function()
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
			Position = where,
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
		task.delay(self.MinParticleTime, function()
			Debris:AddItem(where, particle.Lifetime.Max)
		end)
	else
		task.delay(self.MinParticleTime, function()
			Debris:AddItem(particle, particle.Lifetime.Max)
		end)
	end
	return particle
end

function Lib:Motor6D(first: Instance, second: Instance, parent: Instance)
	return self:Create(
		"Motor6D",
		parent,{
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

-- useSettings
function Lib:SetMinSoundTime(time: number)
	self.MinSoundTime = time
end

function Lib:SetMinParticleTime(time: number)
	self.MinParticleTime = time
end

-- End
function Lib:Init(comments: boolean)
	self.MinSoundTime = 1
	self.MinParticleTime = 1
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
