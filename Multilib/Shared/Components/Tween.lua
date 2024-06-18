local TweenService = game:GetService("TweenService")

local Lib = {}

--[=[
	@class Tween Package
	Tween Utils.
]=]

-- Core

--[=[
	@within Tween Package
	Tweens given table.
]=]

function Lib:TweenTable(table: {}, time: number, style: Enum.EasingStyle?, direction: Enum.EasingDirection?, funcAfter: any?)
	style = style or self.DefaultStyle
	direction = direction or self.DefaultDirection
	for index, value in table do
		TweenService:Create(index, TweenInfo.new(time, style, direction), value):Play()
	end
	if funcAfter ~= nil then
		task.delay(time, funcAfter)
	end
end

--[=[
	@within Tween Package
	Tweens given element.
]=]

function Lib:TweenOnce(element: any, time: number, style: Enum.EasingStyle?, direction: Enum.EasingDirection?, funcAfter: any?)
	style = style or self.DefaultStyle
	direction = direction or self.DefaultDirection
	TweenService:Create(element[1], TweenInfo.new(time, style, direction), element[2]):Play()
	if funcAfter ~= nil then
		task.delay(time, funcAfter)
	end
end

-- useSettings
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
