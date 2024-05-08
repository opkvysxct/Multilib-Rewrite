--Multilib Rewrite
--VYSX 2023

--Loading schemat
--_G.MLoader = require(game:GetService("ReplicatedStorage").Multilib)
--_G.MLoader:InitServer(true/false (Comments)) or _G.MLoader:InitClient(true/false (Comments))

local Multilib = {}

function Multilib:InitServer(Comments: boolean)
	self.Comments = Comments
	for index, component in script.Shared.Components:GetDescendants() do
		if component:IsA("ModuleScript") then
			_G["M" .. component.Name] = require(component)
			_G["M" .. component.Name]:Init()
		end
	end
	pcall(function()
		if script.Server.Components then
			for index, component in script.Server.Components:GetDescendants() do
				if component:IsA("ModuleScript") then
					_G["M" .. component.Name] = require(component)
					_G["M" .. component.Name]:Init()
				end
			end
		end
	end)
	for index, class in script.Shared.Classes:GetDescendants() do
		if class:IsA("ModuleScript") then
			_G["M" .. class.Name] = require(class)
			if self.Comments then
				warn("[Multilib-" .. class.Name .. "] Registered")
			end
		end
	end
	for index, class in script.Server.Classes:GetDescendants() do
		if class:IsA("ModuleScript") then
			_G["M" .. class.Name] = require(class)
			if self.Comments then
				warn("[Multilib-" .. class.Name .. "] Registered")
			end
		end
	end
	if self.Comments then
		warn("[Multilib]", "Done loading all Classes and Components.")
	end
end

function Multilib:InitClient(Comments: boolean)
	self.Comments = Comments
	self.Player = game:GetService("Players").LocalPlayer
	for index, component in script.Shared.Components:GetDescendants() do
		if component:IsA("ModuleScript") then
			_G["M" .. component.Name] = require(component)
			_G["M" .. component.Name]:Init()
		end
	end
	for index, component in script.Client.Components:GetDescendants() do
		if component:IsA("ModuleScript") then
			_G["M" .. component.Name] = require(component)
			_G["M" .. component.Name]:Init()
		end
	end
	for index, class in script.Shared.Classes:GetDescendants() do
		if class:IsA("ModuleScript") then
			_G["M" .. class.Name] = require(class)
			if self.Comments then
				warn("[Multilib-" .. class.Name .. "] Registered")
			end
		end
	end
	if script.Client.Classes then
		for index, class in script.Client.Classes:GetDescendants() do
			if class:IsA("ModuleScript") then
				_G["M" .. class.Name] = require(class)
				if self.Comments then
					warn("[Multilib-" .. class.Name .. "] Registered")
				end
			end
		end
	end
	if self.Comments then
		warn("[Multilib]", "Done loading all Classes and Components.")
	end
end

return Multilib
