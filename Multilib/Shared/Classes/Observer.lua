local Observer = {}
Observer.__index = Observer

function Observer.new(valueIndex : any, value: any?, conName: string?, ConFunc: any?)
	local self = setmetatable({}, Observer)
	self.Values = {}
	self._LastValues = {}
	self._Connections = {}
	if conName ~= nil and ConFunc ~= nil then
		self._Connections[conName] = ConFunc
	end
	setmetatable(self.Values,{
		__newindex = function(_: {any}, index, value)
			if not self._LastValues[index] or self._LastValues[index] ~= value then
				self._LastValues[index] = value
				for _, ConFunc in self._Connections do
					ConFunc(index, value)
				end
			end
		end
	})
	self.Values[valueIndex] = value
	self._LastValues[valueIndex] = value
	return self
end

function Observer:Connect(conName: string, ConFunc: any)
	if conName == nil or ConFunc == nil then
		warn("[Observer]", "No Name or Function passed")
		return
	end
	self._Connections[conName] = ConFunc
end

function Observer:Disconnect(conName: string?)
	if conName == nil then
		table.clear(self._Connections)
		return
	end
	self._Connections[conName] = nil
end

function Observer:Destroy()
	self = nil
end

return Observer
