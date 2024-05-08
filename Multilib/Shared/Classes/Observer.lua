local Observer = {}
Observer.__index = Observer

function Observer.new(Value: any, ConName: string, ConFunc: any)
	local self = setmetatable({}, Observer)
	self.Value = Value
	self.Connections = {}
	if ConName ~= nil and ConFunc ~= nil then
		self.Connections[ConName] = ConFunc
	end
	return self
end

function Observer:set(Value: any)
	if Value == nil then
		warn("[Observer]", "No value passed")
		return
	end
	self.Value = Value
	for index, ConFunc in pairs(self.Connections) do
		ConFunc(self)
	end
end

function Observer:connect(ConName: string, ConFunc: any)
	if ConName == nil or ConFunc == nil then
		warn("[Observer]", "No Name or Function passed")
		return
	end
	self.Connections[ConName] = ConFunc
end

function Observer:disconnect(ConName: string)
	if ConName == nil then
		warn("[Observer]", "No Name passed")
		return
	end
	self.Connections[ConName] = nil
end

function Observer:disconnectAll()
	table.clear(self.Connections)
end

function Observer:destroy()
	table.clear(self.Connections)
	self.Value = nil
	self = nil
end

return Observer
