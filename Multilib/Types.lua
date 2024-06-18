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
	Type: string,
	StartingValue: any,
	MinValue: number,
	MaxValue: number,
	StepBy: number,
	TextValues: {string}?,
}

local Templates = {}

local SoundSpecs: SoundSpecs = {
	Name = "SoundSpecTemplate",
	SoundId = 0,
	Volume = 1,
	PlaybackSpeed = 1,
	MaxDistance = 1000,
	MinDistance = 0,
	SoundGroup = nil
}
Templates.TSoundSpecs = SoundSpecs

local ArrowChange: ArrowChange = {
	Locked = false,
	Cooldown = 1,
	OverrideDisplayAnimation = nil,
	Values = {"One","Two","Three"},
	StartingIndex = 1
}
Templates.TArrowChange = ArrowChange

local CheckBox: CheckBox = {
	Locked = false,
	Cooldown = 1,
	OverrideDisplayAnimation = nil,
}
Templates.TCheckBox = CheckBox

local DropDownMenu: DropDownMenu = {
	Locked = false,
	Cooldown = 1,
	OverrideDisplayAnimation = nil,
	Values = string,
	SelectedValue = string,
	AnimSettings = {Time = 1, Height = 2}
}
Templates.TDropDownMenu = DropDownMenu

local DropDownOption: DropDownOption = {
	Locked = false,
	Cooldown = 1,
}
Templates.TDropDownOption = DropDownOption

local InputField: InputField = {
	Locked = false,
	Cooldown = 1,
	OverrideDisplayAnimation = nil,
	ElementType = "Numeric",
	PlaceholderText = "Change me!",
	Lenght = 50
}
Templates.TInputField = InputField

local RadioButton: RadioButton = {
	Locked = false,
	Cooldown = 1,
	OverrideDisplayAnimation = nil
}
Templates.TRadioButton = RadioButton

local Slider: Slider = {
	Locked = false,
	Cooldown = 1,
	Type = "Numeric",
	StartingValue = 50,
	MinValue = 1,
	MaxValue = 100,
	StepBy = 5,
	TextValues = {"One","Two","Three"},
}
Templates.TSlider = Slider

return Templates