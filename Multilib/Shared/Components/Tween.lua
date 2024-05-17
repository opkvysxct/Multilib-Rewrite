local TweenService = game:GetService("TweenService")

local Lib = {}

-- Core
function Lib:TweenTable(table: table, time: number, style, direction, funcAfter: any)
	if style == nil then
		style = self.defaultStyle
	end
	if direction == nil then
		direction = self.defaultDirection
	end
	for index, value in pairs(table) do
		TweenService:Create(index, TweenInfo.New(time, style, direction), value):Play()
	end
	if funcAfter ~= nil then
		task.delay(time, funcAfter)
	end
end

function Lib:TweenOnce(element: any, time: number, style, direction, funcAfter: any)
	if style == nil then
		style = self.defaultStyle
	end
	if direction == nil then
		direction = self.defaultDirection
	end
	TweenService:Create(element[1], TweenInfo.New(time, style, direction), element[2]):Play()
	if funcAfter ~= nil then
		task.delay(time, funcAfter)
	end
end

--[[
function Lib:TweenMethod(element: instance, time: number, initialValue: any, finalValue: any, methodName: string)
	task.spawn(function()
		local tweenRunning = true
		local increaseValue = (finalValue - initialValue) / (time / 0.015)
		local progress = initialValue
		while tweenRunning and task.wait() do
			progress += increaseValue
			element[methodName](element, progress)
			if progress >= finalValue then
				tweenRunning = false
			end
			-- print(progress)
		end
	end)
end

function Lib:TweenAndReturn(element: any, time: number, style, direction, funcAfter: any)
	local InitData = {}
	for Attribute: string, _ in pairs(element[2]) do
		InitData[Attribute] = element[1][Attribute]
	end
	self:TweenOnce(element, time, style, direction)
	task.wait(time)
	self:TweenOnce({element[1], InitData}, time, style, direction, funcAfter)
end]]--

-- settings
function Lib:SetDefaultStyle(style: any)
	self.defaultStyle = style
end

function Lib:SetDefaultDirection(direction: any)
	self.defaultDirection = direction
end

-- End
function Lib:Init(comments: boolean)
	self.defaultStyle = Enum.EasingStyle.Quad
	self.defaultDirection = Enum.EasingDirection.InOut
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
