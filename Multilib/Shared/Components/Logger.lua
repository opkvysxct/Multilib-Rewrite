local RunService = game:GetService("RunService")
local Lib = {}

-- Core

function Lib:Checker()
	if self.IsEnabled == true or RunService:IsStudio() then
		return true
	end
	return false
end

function Lib:Print(Script: Script, Content: any, Force: boolean?)
	if self:Checker() or Force == true then
		print("[".. Script.Name .. "]", Content)
	end
end

function Lib:Warn(Script: Script, Content: any, Force: boolean?)
	if self:Checker() or Force == true  then
		warn("[".. Script.Name .. "]", Content)
	end
end

function Lib:Error(Script: Script, Content: any, Force: boolean?)
	if self:Checker() or Force == true  then
		error("[".. Script.Name .. "]", Content)
	end
end

-- useSettings
function Lib:LoggerSetter(value: boolean)
	self.IsEnabled = value
end

-- End
function Lib:Init(comments: boolean)
	self.IsEnabled = true
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib