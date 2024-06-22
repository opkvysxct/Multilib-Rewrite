--MultiUI
--VYSX/FENGEE 2024

--PROJECT NAMING CONVENTION - KEEP IN MIND WHEN CHANGING THINGS
--VARIABLES - camelCase
--CLASSES, TYPES, PUBLIC FUNCTIONS/PROPORTIES - PascalCase
--PRIVATE FUNCTIONS/PROPORTIES - _PascalCase

--[=[
	@class Main Package
	Container for loaders and all Packages pathes.
]=]

-- Core

local MultiUI = {}

	MultiUI.C = {}
	MultiUI.C.Notifications = require(script.Components.Notifications)
	MultiUI.C.Alerts = require(script.Components.Alerts)

	MultiUI.CC = {}
	MultiUI.CC.ArrowChange = require(script.Classes.ArrowChange)
	MultiUI.CC.CheckBox = require(script.Classes.CheckBox)
	MultiUI.CC.DropDownMenu = require(script.Classes.DropDownMenu)
	MultiUI.CC.DropDownOption = require(script.Classes.DropDownOption)
	MultiUI.CC.Form = require(script.Classes.Form)
	MultiUI.CC.InputField = require(script.Classes.InputField)
	MultiUI.CC.RadioButton = require(script.Classes.RadioButton)
	MultiUI.CC.RadioGroup = require(script.Classes.RadioGroup)
	MultiUI.CC.Slider = require(script.Classes.Slider)

	for _, component in MultiUI.C do
		component:Init()
	end
	
return MultiUI