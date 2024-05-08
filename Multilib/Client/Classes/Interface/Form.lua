local Form = {}
Form.__index = Form


function Form.new()
	local self = setmetatable({}, Form)
	self.Data = {}
	self.Elements = {}
	return self
end

function Form:Validate()
	
end

function Form:CollectData()
	
end

function Form:Destroy()
	
end


return Form
