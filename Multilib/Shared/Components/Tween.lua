local TweenService = game:GetService("TweenService")

local Lib = {}

-- Core
function Lib:TweenTable(table: {any}, time: number, style: Enum.EasingStyle, direction: Enum.EasingDirection, funcAfter: any?)
	if style == nil then
		style = self.DefaultStyle
	end
	if direction == nil then
		direction = self.DefaultDirection
	end
	for index, value in table do
		TweenService:Create(index, TweenInfo.new(time, style, direction), value):Play()
	end
	if funcAfter ~= nil then
		task.delay(time, funcAfter)
	end
end

function Lib:TweenOnce(element: any, time: number, style: Enum.EasingStyle, direction: Enum.EasingDirection, funcAfter: any?)
	if style == nil then
		style = self.DefaultStyle
	end
	if direction == nil then
		direction = self.DefaultDirection
	end
	TweenService:Create(element[1], TweenInfo.new(time, style, direction), element[2]):Play()
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
	for Attribute: string, _ in element[2]) do
		InitData[Attribute] = element[1][Attribute]
	end
	self:TweenOnce(element, time, style, direction)
	task.wait(time)
	self:TweenOnce({element[1], InitData}, time, style, direction, funcAfter)
end]]--

-- settings
function Lib:SetDefaultStyle(style: any)
	self.DefaultStyle = style
end

function Lib:SetDefaultDirection(direction: any)
	self.DefaultDirection = direction
end

-- End
function Lib:Init(comments: boolean)
	self.DefaultStyle = Enum.EasingStyle.Quad
	self.DefaultDirection = Enum.EasingDirection.InOut
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
