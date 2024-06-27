local ReasonTo = {}
ReasonTo.__index = ReasonTo

--[=[
	@class ReasonTo Class
	ReasonTo Class.
]=]

--[=[
	@within ReasonTo Class
	@return <ReasonToClass>
	Creates ReasonTo Class.
]=]

function ReasonTo.new()
	local self = setmetatable({}, ReasonTo)
	self._AnyReasons = 0
	self._SpecificReasons = {}
end

--[=[
	@within ReasonTo Class
	Adds any reason to ReasonTo Class.
]=]

function ReasonTo:AddAnyReason(time: number?, funcAfter: () -> nil?)
	self._AnyReasons += 1
	if time then
		task.delay(time,function()
			self._AnyReasons -= 1
			funcAfter()
		end)
	end
end

--[=[
	@within ReasonTo Class
	Adds specific reason to ReasonTo Class.
]=]

function ReasonTo:AddSpecificReason(reasonName: string, funcAfter: () -> nil?)
	self._SpecificReasons[reasonName] = true
	if funcAfter then
		funcAfter()
	end
end

--[=[
	@within ReasonTo Class
	Removes specific reason from ReasonTo Class.
]=]

function ReasonTo:RemoveSpecificReason(reasonName: string)
	self._SpecificReasons[reasonName] = nil
end

--[=[
	@within ReasonTo Class
	Removes all reasons from ReasonTo Class.
]=]

function ReasonTo:ClearReasons()
	table.clear(self._SpecificReasons)
	self._AnyReasons = 0
end

--[=[
	@within ReasonTo Class
	@return <true | false>
	Checks if there is any reason to not do something.
]=]

function ReasonTo:CanProceed()
	if self._AnyReasons == 0 and #self._SpecificReasons == 0 then
		return true
	end
	return false
end

--[=[
	@within ReasonTo Class
	Destroys ReasonTo Class.
]=]

function ReasonTo:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return ReasonTo
