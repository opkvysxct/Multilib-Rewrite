local RunService = game:GetService("RunService")
local Lib = {}

--[=[
	@class Logger Package
	Logger Utils.
]=]

-- Core

--[=[
	@within Logger Package
	@private
	@return <true | false>
	Internal function for checking if logger should log logs.
]=]

function Lib:_Checker()
	if self.IsEnabled == true or RunService:IsStudio() then
		return true
	end
	return false
end

--[=[
	@within Logger Package
	Prints given message, can be forced to do even if logger is disabled for some reason.
]=]

function Lib:Print(parentScript: Script | ModuleScript | LocalScript, content: any, force: boolean?)
	if self:_Checker() or force == true then
		print("[".. parentScript.Name .. "]", content)
	end
end

--[=[
	@within Logger Package
	Warns given message, can be forced to do even if logger is disabled for some reason.
]=]

function Lib:Warn(parentScript: Script | ModuleScript | LocalScript, content: any, force: boolean?)
	if self:_Checker() or force == true  then
		warn("[".. parentScript.Name .. "]", content)
	end
end

--[=[
	@within Logger Package
	Errors given message, can be forced to do even if logger is disabled for some reason.
]=]

function Lib:Error(parentScript: Script | ModuleScript | LocalScript, content: any, force: boolean?)
	if self:_Checker() or force == true  then
		error("[".. parentScript.Name .. "]", content)
	end
end

-- useSettings

--[=[
	@within Logger Package
	Changes IsEnabled status.
]=]

function Lib:LoggerSetter(value: boolean)
	self.IsEnabled = value
end

-- End
function Lib:Init()
	self.IsEnabled = true
end

return Lib