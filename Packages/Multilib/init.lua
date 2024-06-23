local RunService = game:GetService("RunService")
--Multilib Rewrite
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

local Multilib = {}

	Multilib.TypesPath = script.Types
	Multilib.Types = require(Multilib.TypesPath)

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
	Multilib.Shared.C.String = require(script.Shared.Components.String)
	Multilib.Shared.C.Table = require(script.Shared.Components.Table)
	Multilib.Shared.C.CustomShared = require(script.Shared.Components.CustomShared)

	--SHARED CLASSES
	Multilib.Shared.CC = {}
	Multilib.Shared.CC.AnimContainer = require(script.Shared.Classes.AnimContainer)
	Multilib.Shared.CC.DampedSpring = require(script.Shared.Classes.DampedSpring)
	Multilib.Shared.CC.NumberComputer = require(script.Shared.Classes.NumberComputer)
	Multilib.Shared.CC.Observer = require(script.Shared.Classes.Observer)
	Multilib.Shared.CC.Raycaster = require(script.Shared.Classes.Raycaster)
	Multilib.Shared.CC.ReasonTo = require(script.Shared.Classes.ReasonTo)
	Multilib.Shared.CC.SimpleSpring = require(script.Shared.Classes.SimpleSpring)
	Multilib.Shared.CC.Tweener = require(script.Shared.Classes.Tweener)

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
	Multilib.Client.C.CustomClient = require(script.Client.Components.CustomClient)
	Multilib.Client.C.PlayerAdditions = require(script.Client.Components.PlayerAdditions)

	--CLIENT CLASSES
	Multilib.Client.CC = {}
	Multilib.Client.CC.Draggable = require(script.Client.Classes.Draggable)


	--[=[
		@within Main Package
		Initializes Packages.
	]=]

	function Multilib:Init()
		if RunService:IsServer() then
			for _, Component in self.Shared.C do
				Component:Init()
			end
			for _, Component in self.Server.C do
				Component:Init()
			end
		elseif RunService:IsClient() then
			for _, Component in self.Shared.C do
				Component:Init()
			end
			for _, Component in self.Client.C do
				Component:Init()
			end
		end
	end

return Multilib
