local Debris = game:GetService("Debris")
local Mtypes = require(script.Parent.Parent.Parent.Types)

local Lib = {}

--[=[
	@class Instance Package
	Instance Utils.
]=]

-- Core

--[=[
	@within Instance Package
	@return <Instance>
	Creates and returns object.
]=]

function Lib:Create(instanceName: string, parent: Instance, proporties: {})
	local instanceCreated
	instanceCreated = Instance.new(instanceName)
	for prop, value in proporties do
		instanceCreated[prop] = value
	end
	instanceCreated.Parent = parent
	return instanceCreated
end

--[=[
	@within Instance Package
	@return <Instance, {string = Instance}>
	Clones and returns provided paths.
]=]

function Lib:PerfectClone(trueModel: any, trueElements: {})
	local model = trueModel:Clone()
	local elements = {}
	for index, element in trueElements do
		local path = string.split(element,".")
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

--[=[
	@within Instance Package
	@return <Sound>
	Creates and returns sound.
]=]

function Lib:SoundFX(where: Instance | Vector3, specs: Mtypes.SoundSpecs)
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

--[=[
	@within Instance Package
	@return <ParticleEmitter>
	Copies already existing particle emitter and puts it in given location, then emits it and deletes after emit is done.
]=]

function Lib:ParticleFX(particle: Instance, strength: number, where: Instance | Vector3, WhereSize: Vector3?)
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
	particle = particle:Clone()
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

--[=[
	@within Instance Package
	@return <Motor6D>
	Returns Motor6D.
]=]

function Lib:Motor6D(first: Instance, second: Instance, parent: Instance)
	return self:Create(
		"Motor6D",
		parent,{
			Part0 = first,
			Part1 = second,
		}
	)
end

--[=[
	@within Instance Package
	@return <Animation>
	Returns Animation.
]=]

function Lib:Animation(id: number, animator: Animator)
	local animation = self:Create("Animation", nil, {
		AnimationId = "rbxassetid://" .. id,
	})
	return animator:LoadAnimation(animation)
end

-- useSettings

--[=[
	@within Instance Package
	Sets MinSoundTime.
]=]

function Lib:SetMinSoundTime(time: number)
	self.MinSoundTime = time
end

--[=[
	@within Instance Package
	Sets MinParticleTime.
]=]

function Lib:SetMinParticleTime(time: number)
	self.MinParticleTime = time
end

-- End
function Lib:Init()
	self.MinSoundTime = 1
	self.MinParticleTime = 1
end

return Lib
