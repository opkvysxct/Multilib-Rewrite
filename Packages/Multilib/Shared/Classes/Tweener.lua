local TweenService = game:GetService("TweenService")
local Tweener = {}
Tweener.__index = Tweener

--[=[
	@within Tweener Class
	@return <Tweener>
	Creates Tweener Class.
]=]

function Tweener.new(time: number, defaultStyle: Enum.EasingStyle, defaultDirection: Enum.EasingDirection)
	local self = setmetatable({}, Tweener)
	self.DefaultTime = time
	self.DefaultStyle = defaultStyle
	self.DefaultDirection = defaultDirection
	return self
end

--[=[
	@within Tweener Class
	Tweens given table.
]=]

function Tweener:TweenTable(tableToUse: {}, time: number?, style: Enum.EasingStyle?, direction: Enum.EasingDirection?, funcAfter: any?)
	time = time or self.DefaultTime
	style = style or self.DefaultStyle
	direction = direction or self.DefaultDirection
	for index, value in tableToUse do
		TweenService:Create(index, TweenInfo.new(time, style, direction), value):Play()
	end
	if funcAfter ~= nil then
		task.delay(time, funcAfter)
	end
end

--[=[
	@within Tweener Class
	Tweens given element.
]=]

function Tweener:TweenOnce(element: any, time: number?, style: Enum.EasingStyle?, direction: Enum.EasingDirection?, funcAfter: any?)
	time = time or self.DefaultTime
	style = style or self.DefaultStyle
	direction = direction or self.DefaultDirection
	TweenService:Create(element[1], TweenInfo.new(time, style, direction), element[2]):Play()
	if funcAfter ~= nil then
		task.delay(time, funcAfter)
	end
end

--[=[
	@within Tweener Class
	Destroys Tweener Class.
]=]

function Tweener:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return Tweener
