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
	task.wait(self.MinSoundTime)
	if ToDelete ~= nil then
		self:DebrisF(Where,Sound.TimeLength)
	else
		self:DebrisF(Sound,Sound.TimeLength)
	end
end

-- End

function Lib:Init()
	self.MinSoundTime = 1 -- Try to keep it at least one second, otherwise TimeLength will not load properly and sound will not play
	if _G.M_Loader.Comments then
		print("[Multilib] Instance Lib Loaded & safe to use.")
	end
end

return Lib