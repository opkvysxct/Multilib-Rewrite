--Multilib Rewrite
--VYSX 2023

--Loading schemat
--_G.M_Loader = require(game:GetService("ReplicatedStorage").Multilib)
--_G.M_Loader:InitServer(true/false (Comments)) or _G.M_Loader:InitClient(true/false (Comments))

local Multilib = {}

function Multilib:InitServer(Comments : boolean)
	self.Comments = Comments
	for index,component in script.Shared.Components:GetChildren() do
		_G["M_" .. component.Name] = require(component)
		_G["M_" .. component.Name]:Init()
	end
	for index,component in script.Server.Components:GetChildren() do
		_G["M_" .. component.Name] = require(component)
		_G["M_" .. component.Name]:Init()
	end
	for index,class in script.Shared.Classes:GetChildren() do
		_G["M_" .. class.Name] = require(class)
		if self.Comments then
			warn("[Multilib-" .. class.Name .. "] Registered")
		end
	end
	for index,class in script.Server.Classes:GetChildren() do
		_G["M_" .. class.Name] = require(class)
		if self.Comments then
			warn("[Multilib-" .. class.Name .. "] Registered")
		end
	end
	if self.Comments then
		warn("[Multilib]", "Done loading all Classes and Components.")
	end
end

function Multilib:InitClient(Comments : boolean)
	self.Comments = Comments
	self.Player = game:GetService("Players").LocalPlayer
	for index,component in script.Shared.Components:GetChildren() do
		_G["M_" .. component.Name] = require(component)
		_G["M_" .. component.Name]:Init()
	end
	for index,component in script.Client.Components:GetChildren() do
		_G["M_" .. component.Name] = require(component)
		_G["M_" .. component.Name]:Init()
	end
	for index,class in script.Shared.Classes:GetChildren() do
		_G["M_" .. class.Name] = require(class)
		if self.Comments then
			warn("[Multilib-" .. class.Name .. "] Registered")
		end
	end
	for index,class in script.Client.Classes:GetChildren() do
		_G["M_" .. class.Name] = require(class)
		if self.Comments then
			warn("[Multilib-" .. class.Name .. "] Registered")
		end
	end
	if self.Comments then
		warn("[Multilib]", "Done loading all Classes and Components.")
	end
end

return Multilib