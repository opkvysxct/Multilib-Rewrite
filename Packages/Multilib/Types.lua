export type SoundSpecs = {
	Name: string,
	SoundId: number,
	Volume: number?,
	PlaybackSpeed: number?,
	MaxDistance: number?,
	MinDistance: number?,
	SoundGroup: SoundGroup?
}

local Templates = {}

local soundSpecs: SoundSpecs = {
	Name = "SoundSpecTemplate",
	SoundId = 0,
	Volume = 1,
	PlaybackSpeed = 1,
	MaxDistance = 1000,
	MinDistance = 0,
	SoundGroup = nil
}
Templates.TSoundSpecs = soundSpecs

return Templates