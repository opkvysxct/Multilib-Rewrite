local Observer = {}
Observer.__index = Observer

function Observer.new(value: any, ConName: string, ConFunc: any)
	local self = setmetatable({}, Observer)
	self.value = value
	self.connections = {}
	if ConName ~= nil and ConFunc ~= nil then
		self.connections[ConName] = ConFunc
	end
	return self
end

function Observer:Set(value: any)
	if value == nil then
		warn("[Observer]", "No value passed")
		return
	end
	self.value = value
	for index, ConFunc in self.connections do
		ConFunc(self)
	end
end

function Observer:Connect(ConName: string, ConFunc: any)
	if ConName == nil or ConFunc == nil then
		warn("[Observer]", "No Name or Function passed")
		return
	end
	self.connections[ConName] = ConFunc
end

function Observer:Disconnect(ConName: string)
	if ConName == nil then
		warn("[Observer]", "No Name passed")
		return
	end
	self.connections[ConName] = nil
end

function Observer:DisconnectAll()
	table.clear(self.connections)
end

function Observer:Destroy()
	table.clear(self.connections)
	self.value = nil
	self = nil
end

return Observer
