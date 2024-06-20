local Observer = {}
Observer.__index = Observer

function Observer.new(value: any)
	assert(value, "[Observer] No value provided for value variable.")
	local self = setmetatable({}, Observer)
	self.Value = value
	self._Connections = {}
	self._Middleware = {}
	return self
end

function Observer:Set(value: any)
	assert(value, "[Observer] No value provided for value variable.")
	for _, mConnection in self._Middleware do
		local res = mConnection.ConFunc(value)
		if res ~= nil then
			value = res
		end
	end
	self.Value = value
	for _, cConnection in self._Connections do
		cConnection.ConFunc(self.Value)
	end
	return true
end

function Observer:Connect(conName: string, ConFunc: (any) -> nil)
	assert(typeof(conName) == "string", "[Observer] Wrong type or no value provided for conName.")
	assert(typeof(ConFunc) == "function", "[Observer] Wrong type or no value provided for ConFunc.")
	for _, cConnection in self._Connections do
		if cConnection.ConName == conName then
			warn("[Observer]", "Connection with same name already exists.")
			return false
		end
	end
	table.insert(self._Connections,{ConName = conName,ConFunc = ConFunc})
	return true
end

function Observer:Disconnect(conName: string)
	assert(typeof(conName) == "string", "[Observer] Wrong type or no value provided for conName.")
	local toDelete
	for index, cConnection in self._Connections do
		if cConnection.ConName == conName then
			toDelete = index
			break
		end
	end
	if toDelete == nil then
		warn("[Observer]", "Didn't found connection with that name")
		return false
	end
	table.remove(self._Connections,toDelete)
	return true
end

function Observer:MiddlewareConnect(conName: string, ConFunc: (any) -> any | nil)
	assert(typeof(conName) == "string", "[Observer] Wrong type or no value provided for conName.")
	assert(typeof(ConFunc) == "function", "[Observer] Wrong type or no value provided for ConFunc.")
	for _, mConnection in self._Middleware do
		if mConnection.ConName == conName then
			warn("[Observer]", "MiddlewareConnection with same name already exists.")
			return false
		end
	end
	table.insert(self._Middleware,{ConName = conName,ConFunc = ConFunc})
	return true
end

function Observer:MiddelwareDisconnect(conName: string)
	assert(typeof(conName) == "string", "[Observer] Wrong type or no value provided for conName.")
	local toDelete
	for index, mConnection in self._Middleware do
		if mConnection.ConName == conName then
			toDelete = index
			break
		end
	end
	if toDelete == nil then
		warn("[Observer]", "Didn't found MiddelwareConnection with that name")
		return false
	end
	table.remove(self._Connections,toDelete)
	return true
end

function Observer:DisconnectAll()
	table.clear(self._Connections)
	table.clear(self._Middleware)
	return true
end

function Observer:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
	return true
end

return Observer
