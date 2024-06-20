local ReasonTo = {}
ReasonTo.__index = ReasonTo

function ReasonTo.new()
	local self = setmetatable({}, ReasonTo)
	self._AnyReasons = 0
	self._SpecificReasons = {}
	return self
end

function ReasonTo:AddAnyReason(time: number?, funcAfter: () -> nil?)
	self._AnyReasons += 1
	if time then
		task.delay(time,function()
			self._AnyReasons -= 1
			funcAfter()
		end)
	end
	return true
end

function ReasonTo:AddSpecificReason(reasonName: string, funcAfter: () -> nil?)
	self._SpecificReasons[reasonName] = true
	if funcAfter then
		funcAfter()
	end
	return true
end

function ReasonTo:RemoveSpecificReason(reasonName: string)
	self._SpecificReasons[reasonName] = nil
	return true
end

function ReasonTo:ClearReasons()
	table.clear(self._SpecificReasons)
	self._AnyReasons = 0
	return true
end

function ReasonTo:CanProceed()
	if self._AnyReasons == 0 and #self._SpecificReasons == 0 then
		return true
	end
	return false
end

function ReasonTo:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
	return true
end


return ReasonTo
