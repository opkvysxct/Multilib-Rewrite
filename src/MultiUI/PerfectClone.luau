--COPY OF MAINSTREAM MULTILIB -> SHARED -> COMPONENTS -> INSTANCES:PerfectClone(trueModel: any, trueElements: {})
return function (trueModel: any, trueElements: {}) : (GuiObject, {any})
	local model = trueModel:Clone()
	local elements = {}
	for index, element in trueElements do
		local path = string.split(element,".")
		local followedPath = model
		for _, value in path do
			if followedPath:FindFirstChild(value) then
				followedPath = followedPath[value]
			else
				error("[Multilib-" .. script.Name .. "]" .. " Path not found.")
			end
		end
		elements[index] = followedPath
	end
	return model, elements
end