local TweenService = game:GetService("TweenService")

local Lib = {}

-- Core
function Lib:TweenTable(Table: table, Time: number, Style, Direction, FuncAfter: any)
	if Style == nil then
		Style = self.DefaultStyle
	end
	if Direction == nil then
		Direction = self.DefaultDirection
	end
	for index, value in pairs(Table) do
		TweenService:Create(index, TweenInfo.new(Time, Style, Direction), value):Play()
	end
	if FuncAfter ~= nil then
		task.delay(Time, FuncAfter)
	end
end

function Lib:TweenOnce(Element: any, Time: number, Style, Direction, FuncAfter: any)
	if Style == nil then
		Style = self.DefaultStyle
	end
	if Direction == nil then
		Direction = self.DefaultDirection
	end
	TweenService:Create(Element[1], TweenInfo.new(Time, Style, Direction), Element[2]):Play()
	if FuncAfter ~= nil then
		task.delay(Time, FuncAfter)
	end
end

-- Not really a tween but whatever ¯\_(ツ)_/¯
function Lib:TweenMethod(Element: Instance, time: number, initialValue: any, finalValue: any, methodName: string)
	task.spawn(function()
		local tweenRunning = true
		local increaseValue = (finalValue - initialValue) / (time / 0.015)
		local progress = initialValue
		while tweenRunning and task.wait() do
			progress += increaseValue
			Element[methodName](Element, progress)
			if progress >= finalValue then
				tweenRunning = false
			end
			-- print(progress)
		end
	end)
end

function Lib:TweenAndReturn(Element: any, Time: number, Style, Direction, FuncAfter: any)
	local InitData = {}
	for Attribute: string, _ in pairs(Element[2]) do
		InitData[Attribute] = Element[1][Attribute]
	end
	self:TweenOnce(Element, Time, Style, Direction)
	task.wait(Time)
	self:TweenOnce({Element[1], InitData}, Time, Style, Direction, FuncAfter)
end

-- Settings
function Lib:SetDefaultStyle(Style: any)
	self.DefaultStyle = Style
end

function Lib:SetDefaultDirection(Direction: any)
	self.DefaultDirection = Direction
end

-- End
function Lib:Init()
	self.DefaultStyle = Enum.EasingStyle.Quad
	self.DefaultDirection = Enum.EasingDirection.InOut
	if _G.M_Loader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib
