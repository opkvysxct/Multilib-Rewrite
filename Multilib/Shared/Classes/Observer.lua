local Observer = {}
Observer.__index = Observer

function Observer:new(Value : any)
	local self = setmetatable({}, Observer)
	self.Value = Value
	self.Connections = {}
	return self
end

function Observer:Set(Value : any)
	if Value == nil then warn("[Observer]", "No value passed") return end
	self.Value = Value
	for index,ConFunc in pairs(self.Connections) do
		ConFunc(self)
	end
end

function Observer:Connect(ConName : string,ConFunc : any)
	if ConName == nil or ConFunc == nil then warn("[Observer]", "No Name or Function passed") return end
	self.Connections[ConName] = ConFunc
end

function Observer:Disconnect(ConName : string)
	if ConName == nil then warn("[Observer]", "No Name passed") return end
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
