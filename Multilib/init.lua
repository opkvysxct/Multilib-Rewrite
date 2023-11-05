--Multilib Rewrite
--VYSX 2023

local Multilib = {}

function Multilib:InitServer(Comments)
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
			print("[Multilib-" .. class.Name .. "] Registered")
		end
	end
	for index,class in script.Server.Classes:GetChildren() do
		_G["M_" .. class.Name] = require(class)
		if self.Comments then
			print("[Multilib-" .. class.Name .. "] Registered")
		end
	end
end

function Multilib:InitClient(Comments)
	self.Comments = Comments
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
			print("[Multilib-" .. class.Name .. "] Registered")
		end
	end
	for index,class in script.Client.Classes:GetChildren() do
		_G["M_" .. class.Name] = require(class)
		if self.Comments then
			print("[Multilib-" .. class.Name .. "] Registered")
		end
	end
end

return Multilib