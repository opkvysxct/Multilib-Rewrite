--Multilib Rewrite
--VYSX 2023

local Multilib = {}

function Multilib:Init(Comments)
	self.Comments = Comments
	for index,component in script.Components:GetChildren() do
		_G["M_" .. component.Name] = require(component)
		_G["M_" .. component.Name]:Init()
	end
	for index,class in script.Classes:GetChildren() do
		_G["M_" .. class.Name] = require(class)
	end
end

return Multilib