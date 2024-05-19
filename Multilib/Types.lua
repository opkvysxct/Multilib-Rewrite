export type SoundSpecs = {
	Name: string,
	SoundId: number,
	Volume: number,
	PlaybackSpeed: number,
	MaxDistance: number,
	MinDistance: number,
	SoundGroup: SoundGroup
}

export type ArrowChange = {
	Locked: boolean,
	Cooldown: number,
	OverrideDisplayAnimation: () -> nil,
	Values: {string},
	StartingIndex: number
}

export type CheckBox = {
	Locked: boolean,
	Cooldown: number,
	OverrideDisplayAnimation: () -> nil,
}

export type DropDownMenu = {
	Locked: boolean,
	Cooldown: number,
	OverrideDisplayAnimation: () -> nil,
	Values: string,
	SelectedValue: string,
	AnimSettings: {Time: number, Height: number}
}

export type DropDownOption = {
	Locked: boolean,
	Cooldown: number,
}

export type InputField = {
	Locked: boolean,
	Cooldown: number,
	OverrideDisplayAnimation: () -> nil,
	ElementType: string,
	PlaceholderText: string,
	Lenght: number
}

export type RadioButton = {
	Locked: boolean,
	Cooldown: number,
	OverrideDisplayAnimation: () -> nil,
}

export type Slider = {
	Locked: boolean,
	Cooldown: number,
	OverrideDisplayAnimation: () -> nil,
	ElementType: string,
	StartingValue: any,
	MinValue: number,
	MaxValue: number,
	StepBy: number,
	TextValues: {string}?,
}

return nil