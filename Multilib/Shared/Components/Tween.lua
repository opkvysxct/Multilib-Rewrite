local TweenService = game:GetService("TweenService")

local Lib = {}

-- Core
function Lib:TweenTable(Table : table, Time : number, Style, Direction, FuncAfter : any)
	if Style == nil then
		Style = self.DefaultStyle
	end
	if Direction == nil then
		Direction = self.DefaultDirection
	end
	for index, value in pairs(Table) do
		TweenService:Create(index,
			TweenInfo.new(Time,Style,Direction),
			value):Play()
	end
	if FuncAfter ~= nil then
		task.delay(Time,FuncAfter)
	end
end

function Lib:TweenOnce(Element : any, Time : number, Style, Direction, FuncAfter : any)
	if Style == nil then
		Style = self.DefaultStyle
	end
	if Direction == nil then
		Direction = self.DefaultDirection
	end
	TweenService:Create(Element[1],
		TweenInfo.new(Time,Style,Direction),
		Element[2]):Play()
	if FuncAfter ~= nil then
		task.delay(Time,FuncAfter)
	end
end

-- Settings

function Lib:SetDefaultStyle(Style : any)
	self.DefaultStyle = Style
end

function Lib:SetDefaultDirection(Direction : any)
	self.DefaultDirection = Direction
end

-- End

function Lib:Init()
	self.DefaultStyle = Enum.EasingStyle.Quad
	self.DefaultDirection = Enum.EasingDirection.InOut
	if _G.M_Loader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name , "Lib Loaded & safe to use.")
	end
end

return Lib