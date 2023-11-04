-- Instance Component

local Lib = {}

function Lib:Create(InstanceName,Parent,Proporties)
	local InstanceCreated = Instance.new(InstanceName,Parent)
	if _G.M_Loader.Comments then
		print(InstanceName,Parent,Proporties)
	end
	for prop, value in pairs(Proporties) do
		InstanceCreated[prop] = value
	end
	return InstanceCreated
end

function Lib:doa()
	
end

return Lib