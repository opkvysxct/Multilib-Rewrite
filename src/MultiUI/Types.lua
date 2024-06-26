export type ArrowChange = {
	Locked: boolean?,
	Cooldown: number?,
	OverrideDisplayAnimation: (() -> nil)?,
	Values: {string}?,
	StartingIndex: number?
}

export type CheckBox = {
	Locked: boolean?,
	Cooldown: number?,
	OverrideDisplayAnimation: (() -> nil)?,
	StartingValue: boolean?
}

export type DropDownMenu = {
	Locked: boolean?,
	Cooldown: number?,
	OverrideDisplayAnimation: (() -> nil)?,
	Values: {string}?,
	SelectedValue: string?,
	AnimSettings: {Time: number, Height: number}?,
	CanvasSize: number?
}

export type DropDownOption = {
	Locked: boolean?,
	Cooldown: number?
}

export type InputField = {
	Locked: boolean?,
	Cooldown: number?,
	OverrideDisplayAnimation: (() -> nil)?,
	ElementType: string?,
	StartingValue: string?,
	PlaceholderText: string?,
	Lenght: number?,
	CustomCharacters: string?
}

export type RadioButton = {
	Locked: boolean?,
	Cooldown: number?,
	OverrideDisplayAnimation: (() -> nil)?
}

export type Slider = {
	Locked: boolean?,
	Cooldown: number?,
	Type: string?,
	StartingValue: any?,
	MinValue: number?,
	MaxValue: number?,
	StepBy: number?,
	TextValues: {string}?,
}

local Templates = {}

local arrowChange: ArrowChange = {
	Locked = false,
	Cooldown = 1,
	OverrideDisplayAnimation = nil,
	Values = {"One","Two","Three"},
	StartingIndex = 1
}
Templates.TArrowChange = arrowChange

local checkBox: CheckBox = {
	Locked = false,
	Cooldown = 1,
	OverrideDisplayAnimation = nil,
	StartingValue = false
}
Templates.TCheckBox = checkBox

local dropDownMenu: DropDownMenu = {
	Locked = false,
	Cooldown = 1,
	OverrideDisplayAnimation = nil,
	Values = "string",
	SelectedValue = "string",
	AnimSettings = {Time = 1, Height = 2},
	CanvasSize = 4,
}
Templates.TDropDownMenu = dropDownMenu

local dropDownOption: DropDownOption = {
	Locked = false,
	Cooldown = 1,
}
Templates.TDropDownOption = dropDownOption

local inputField: InputField = {
	Locked = false,
	Cooldown = 1,
	OverrideDisplayAnimation = nil,
	ElementType = "Numeric",
	PlaceholderText = "Change me!",
	StartingValue = "Change me!",
	Lenght = 50,
	CustomCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
}
Templates.TInputField = inputField

local radioButton: RadioButton = {
	Locked = false,
	Cooldown = 1,
	OverrideDisplayAnimation = nil
}
Templates.TRadioButton = radioButton

local slider: Slider = {
	Locked = false,
	Cooldown = 1,
	Type = "Numeric",
	StartingValue = 50,
	MinValue = 1,
	MaxValue = 100,
	StepBy = 5,
	TextValues = {"One","Two","Three"},
}
Templates.TSlider = slider

return Templates