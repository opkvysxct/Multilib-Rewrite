local ReasonTo = {}
ReasonTo.__index = ReasonTo

function ReasonTo.new()
	local self = setmetatable({}, ReasonTo)
	self.AnyReasons = 0
	self.SpecificReasons = {}
	return self
end

function ReasonTo:AddAnyReason(time: number?, funcAfter: any?)
	self.AnyReasons += 1
	if time then
		task.delay(time,function()
			self.AnyReasons -= 1
			funcAfter()
		end)
	end
end

function ReasonTo:AddSpecificReason(reasonName: string, funcAfter: any?)
	self.SpecificReasons[reasonName] = true
	if funcAfter then
		funcAfter()
	end
end

function ReasonTo:RemoveSpecificReason(reasonName: string)
	self.SpecificReasons[reasonName] = nil
end

function ReasonTo:ClearReasons()
	table.clear(self.SpecificReasons)
	self.AnyReasons = 0
end

function ReasonTo:CanProceed()
	if self.AnyReasons == 0 and #self.SpecificReasons == 0 then
		return true
	end
	return false
end

function ReasonTo:Destroy()
	self = nil
end


return ReasonTo
