local Observer = {}
Observer.__index = Observer

function Observer.new(value: any, ConName: string, ConFunc: any)
	local self = setmetatable({}, Observer)
	self.Value = value
	self.Connections = {}
	if ConName ~= nil and ConFunc ~= nil then
		self.Connections[ConName] = ConFunc
	end
	return self
end

function Observer:Set(value: any)
	if value == nil then
		warn("[Observer]", "No value passed")
		return
	end
	self.Value = value
	for index, ConFunc in self.Connections do
		ConFunc(self)
	end
end

function Observer:ReturnValue()
	return self.Value
end

function Observer:Connect(ConName: string, ConFunc: any)
	if ConName == nil or ConFunc == nil then
		warn("[Observer]", "No Name or Function passed")
		return
	end
	self.Connections[ConName] = ConFunc
end

function Observer:Disconnect(ConName: string)
	if ConName == nil then
		warn("[Observer]", "No Name passed")
		return
	end
	self.Connections[ConName] = nil
end

function Observer:DisconnectAll()
	table.clear(self.Connections)
end

function Observer:Destroy()
	table.clear(self.Connections)
	self.Value = nil
	self = nil
end

return Observer
