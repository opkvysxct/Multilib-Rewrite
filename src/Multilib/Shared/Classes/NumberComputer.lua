local HttpService = game:GetService("HttpService")
local NumberComputer = {}
NumberComputer.__index = NumberComputer

--[=[
	@class NumberComputer Class
	NumberComputer Class.
]=]

--[=[
	@within NumberComputer Class
	@return <NumberComputerClass>
	Creates NumberComputer Class.
]=]

function NumberComputer.new(baseValue: number)
	assert(typeof(baseValue) == "number", "[NumberComputer] Wrong type or no value provided for baseValue.")
	local self = setmetatable({}, NumberComputer)
	self.ComputedValue = baseValue
	self._LastComputedValue = self.ComputedValue
	self._BaseValue = baseValue
	self._Operations = {}
	self._Connections = {}
	self._CheckGUID = HttpService:GenerateGUID(false)
	self._LastComputeGUID = self._CheckGUID
	return self
end

--[=[
	@within NumberComputer Class
	@return <number>
	Returns computed value.
]=]

function NumberComputer:GetValue(reCompute: boolean?)
	if self._CheckGUID ~= self._LastComputeGUID or reCompute == true then
		self:_Compute()
	end
	return self.ComputedValue
end

--[=[
	@within NumberComputer Class
	Updates existing operation with new parameters.
]=]

function NumberComputer:UpdateOperation(operationName: string, operationBaseNumber: number)
	assert(typeof(operationName) == "string", "[NumberComputer] Wrong type or no value provided for operationName.")
	assert(typeof(operationBaseNumber) == "number", "[NumberComputer] Wrong type or no value provided for operationBaseNumber.")
	local operationFounded
	for _, operation in self._Operations do
		if operation.OperationName == operationName then
			operationFounded = operation
		end
	end
	if operationFounded == nil then
		warn("[NumberComputer]", "Didn't found operation with that name")
		return
	end
	operationFounded.OperationBaseNumber = operationBaseNumber
	self:_Compute()
end

--[=[
	@within NumberComputer Class
	@private
	Computes every operation that was added.
]=]

function NumberComputer:_Compute()
	self._LastComputedValue = self.ComputedValue
	local function Check(a: number, b: number)
		assert(typeof(a) == "number", "[NumberComputer] Wrong type or no value in computation step.")
		assert(typeof(b) == "number", "[NumberComputer] Wrong type or no value in computation step.")
		return true
	end
	local operations = {
		["+"] = function(a: number, b: number)
			if Check(a,b) then
				return a + b
			end
		end,
		["-"] = function(a: number, b: number)
			if Check(a,b) then
				return a - b
			end
		end,
		["*"] = function(a: number, b: number)
			if Check(a,b) then
				return a * b
			end
		end,
		["/"] = function(a: number, b: number)
			if Check(a,b) then
				assert(b ~= 0, "[NumberComputer] Cannot divide by 0.")
				return a / b
			end
		end,
		["^"] = function(a: number, b: number)
			if Check(a,b) then
				return a ^ b
			end
		end,
		["%"] = function(a: number, b: number)
			if Check(a,b) then
				return a % b
			end
		end,
	}
	local res = self._BaseValue
	for _, operation in self._Operations do
		res = operations[operation.OperationType](res, operation.OperationBaseNumber)
	end
	self._LastComputeGUID = self._CheckGUID
	self.ComputedValue = res
	for _, cConnection in self._Connections do
		cConnection.ConFunc(self.ComputedValue, self._LastComputedValue)
	end
end

--[=[
	@within NumberComputer Class
	Inserts new operation to be computed.
]=]

function NumberComputer:InsertOperation(operationName: string, operationBaseNumber: number, operationType: string)
	assert(typeof(operationName) == "string", "[NumberComputer] Wrong type or no value provided for operationName.")
	assert(typeof(operationBaseNumber) == "number", "[NumberComputer] Wrong type or no value provided for operationBaseNumber.")
	assert(typeof(operationType) == "string", "[NumberComputer] Wrong type or no value provided for operationType.")
	local validTypes = {"+","-","*","/","^","%"}
	if not table.find(validTypes,operationType) then error("[NumberComputer] Invalid type provided for operationType.") end
	for _, operation in self._Operations do
		if operation.OperationName == operationName then
			warn("[NumberComputer]", "Operation with same name already exists.")
			return
		end
	end
	table.insert(self._Operations,
		{
			OperationName =  operationName,
			OperationBaseNumber = operationBaseNumber,
			OperationType = operationType
		}
	)
	self._CheckGUID = HttpService:GenerateGUID(false)
	self:_Compute()
end

--[=[
	@within NumberComputer Class
	Removes given operation.
]=]

function NumberComputer:RemoveOperation(operationName: string)
	assert(typeof(operationName) == "string", "[NumberComputer] Wrong type or no value provided for operationName.")
	local toDelete = nil
	for index, operation in self._Operations do
		if operation.OperationName == operationName then
			toDelete = index
			break
		end
	end
	if toDelete == nil then
		warn("[NumberComputer]", "Didn't found connection with that name")
		return
	end
	table.remove(self._Operations,toDelete)
	self._CheckGUID = HttpService:GenerateGUID(false)
	self:_Compute()
end

--[=[
	@within NumberComputer Class
	Connects a function that will be executed after any change.
]=]

function NumberComputer:Connect(conName: string, ConFunc: (number, number) -> nil)
	assert(typeof(conName) == "string", "[NumberComputer] Wrong type or no value provided for conName.")
	assert(typeof(ConFunc) == "function", "[NumberComputer] Wrong type or no value provided for ConFunc.")
	for _, cConnection in self._Connections do
		if cConnection.ConName == conName then
			warn("[NumberComputer]", "Connection with same name already exists.")
			return
		end
	end
	table.insert(self._Connections,{ConName = conName,ConFunc = ConFunc})
end


--[=[
	@within NumberComputer Class
	Disconnects a function that would be executed after any change.
]=]

function NumberComputer:Disconnect(conName: string)
	assert(typeof(conName) == "string", "[NumberComputer] Wrong type or no value provided for conName.")
	local toDelete
	for index, cConnection in self._Connections do
		if cConnection.ConName == conName then
			toDelete = index
			break
		end
	end
	if toDelete == nil then
		warn("[NumberComputer]", "Didn't found connection with that name")
		return
	end
	table.remove(self._Connections,toDelete)
end

--[=[
	@within NumberComputer Class
	Destroys NumberComputer Class.
]=]

function NumberComputer:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return NumberComputer