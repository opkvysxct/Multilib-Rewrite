local Observer = {}
Observer.__index = Observer

--[=[
	@class Observer Class
	Observer Class.
]=]

--[=[
	@within Observer Class
	@return <ObserverClass>
	Creates Observer Class.
]=]

function Observer.new(value: any)
	assert(value, "[Observer] No value provided for value variable.")
	local self = setmetatable({}, Observer)
	self.Value = value
	self._Connections = {}
	self._Middleware = {}
	return self
end

--[=[
	@within Observer Class
	Sets the value of Observer Class.
]=]

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
end

--[=[
	@within Observer Class
	Connects a function that will be executed on every value change from Observer:Set() function.
]=]

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
end

--[=[
	@within Observer Class
	Disconnects function.
]=]

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
end

--[=[
	@within Observer Class
	Connects a function that will be executed on every value change from Observer:Set() function.
	
	the diffrence here is that Middleware function are executed before the value is set up, and they also allow for chaning the value via return.
]=]

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
end

--[=[
	@within Observer Class
	Disconnects Middleware function.
]=]

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
end

--[=[
	@within Observer Class
	Disconnects all functions and all Middleware functions.
]=]

function Observer:DisconnectAll()
	table.clear(self._Connections)
	table.clear(self._Middleware)
end

--[=[
	@within Observer Class
	Destroys Observer Class.
]=]

function Observer:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return Observer
