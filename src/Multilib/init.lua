--Multilib Rewrite
--VYSX 2023

local Multilib = {}

function Multilib:Init(Comments)
	self.Comments = Comments
	for index,component in script.Components:GetChildren() do
		_G["M_" .. component.Name] = require(component)
	end
end

return Multilib