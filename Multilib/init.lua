--Multilib Rewrite
--VYSX/FENGEE 2024

--PROJECT NAMING CONVENTION - KEEP IN MIND WHEN CHANGING THINGS
--VARIABLES - camelCase
--CLASSES, TYPES, PUBLIC FUNCTIONS/PROPORTIES - PascalCase
--PRIVATE FUNCTIONS/PROPORTIES - _PascalCase


local Multilib = {}

	Multilib.Types = require(script.Types)

	--SHARED COMPONENTS
	Multilib.Shared = {}
	Multilib.Shared.C = {}
	Multilib.Shared.C.Instance = require(script.Shared.Components.Instance)
	Multilib.Shared.C.Logger = require(script.Shared.Components.Logger)
	Multilib.Shared.C.Loop = require(script.Shared.Components.Loop)
	Multilib.Shared.C.Marketplace = require(script.Shared.Components.Marketplace)
	Multilib.Shared.C.Math = require(script.Shared.Components.Math)
	Multilib.Shared.C.Parallel = require(script.Shared.Components.Parallel)
	Multilib.Shared.C.Player = require(script.Shared.Components.Player)
	Multilib.Shared.C.Raycast = require(script.Shared.Components.Raycast)
	Multilib.Shared.C.String = require(script.Shared.Components.String)
	Multilib.Shared.C.Table = require(script.Shared.Components.Table)
	Multilib.Shared.C.Tween = require(script.Shared.Components.Tween)
	Multilib.Shared.C.CustomShared = require(script.Shared.Components.CustomShared)

	--SHARED CLASSES
	Multilib.Shared.CC = {}
	Multilib.Shared.CC.DampedSpring = require(script.Shared.Classes.DampedSpring)
	Multilib.Shared.CC.Observer = require(script.Shared.Classes.Observer)
	Multilib.Shared.CC.ReasonTo = require(script.Shared.Classes.ReasonTo)
	Multilib.Shared.CC.SimpleSpring = require(script.Shared.Classes.SimpleSpring)

	--SERVER COMPONENTS
	Multilib.Server = {}
	Multilib.Server.C = {}
	Multilib.Server.C.CustomServer = require(script.Server.Components.CustomServer)

	--SERVER CLASSES
	Multilib.Server.CC = {}
	Multilib.Server.CC.ReceiptProcessor = require(script.Server.Classes.ReceiptProcessor)
	
	--CLIENT COMPONENTS
	Multilib.Client = {}
	Multilib.Client.C = {}
	Multilib.Client.C.Alers = require(script.Client.Components.Alerts)
	Multilib.Client.C.CustomClient = require(script.Client.Components.CustomClient)
	Multilib.Client.C.Notifications = require(script.Client.Components.Notifications)
	Multilib.Client.C.PlayerAdditions = require(script.Client.Components.PlayerAdditions)

	--CLIENT CLASSES
	Multilib.Client.CC = {}
	Multilib.Client.CC.Interface = {}
	Multilib.Client.CC.Interface.ArrowChange = require(script.Client.Classes.Interface.ArrowChange)
	Multilib.Client.CC.Interface.CheckBox = require(script.Client.Classes.Interface.CheckBox)
	Multilib.Client.CC.Interface.DropDownMenu = require(script.Client.Classes.Interface.DropDownMenu)
	Multilib.Client.CC.Interface.DropDownOption = require(script.Client.Classes.Interface.DropDownOption)
	Multilib.Client.CC.Interface.Form = require(script.Client.Classes.Interface.Form)
	Multilib.Client.CC.Interface.InputField = require(script.Client.Classes.Interface.InputField)
	Multilib.Client.CC.Interface.RadioButton = require(script.Client.Classes.Interface.RadioButton)
	Multilib.Client.CC.Interface.RadioGroup = require(script.Client.Classes.Interface.RadioGroup)
	Multilib.Client.CC.Interface.Slider = require(script.Client.Classes.Interface.Slider)

	function Multilib:InitServer(comments: boolean)
		for _, Component in self.Shared.C do
			Component:Init(comments)
		end
		for _, Component in self.Server.C do
			Component:Init(comments)
		end
	 end

	function Multilib:InitClient(comments: boolean)
		for _, Component in self.Shared.C do
			Component:Init(comments)
		end
		for _, Component in self.Client.C do
			Component:Init(comments)
		end
	end

return Multilib
