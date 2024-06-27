local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Draggable = {}
Draggable.__index = Draggable

--[=[
	@class Dragable Class
	@client
	Dragable Class.
]=]

-- Core

--[=[
	@within Dragable Class
	@return <DraggableClass>
	Creates Dragable Class.
]=]

function Draggable.new(movable: GuiObject, draggable: GuiObject, ui: ScreenGui)
	local self = setmetatable({}, Draggable)
	self.Movable = movable
	self.Draggable = draggable
	self.Ui = ui
	self._Id = HttpService:GenerateGUID(false)
	self._LastMousePosition = nil
	self.Movable.Position = UDim2.new(
		0,
		self.Movable.AbsolutePosition.X,
		0,
		self.Movable.AbsolutePosition.Y
	)
	self:_Activate()
	return self
end

--[=[
	@within Dragable Class
	@private
	Runs the class logic.
]=]

function Draggable:_Activate()
	local function Move()
		if self._LastMousePosition == nil then
			self._LastMousePosition = UserInputService:GetMouseLocation()
		end
		local newMousePosition = UserInputService:GetMouseLocation()
		local movablePos = self.Movable.AbsolutePosition
		local clampX = self.Ui.AbsoluteSize.X - self.Movable.AbsoluteSize.X
		local clampY = self.Ui.AbsoluteSize.Y - self.Movable.AbsoluteSize.Y
		local mousePosDiff = newMousePosition - self._LastMousePosition
		self._LastMousePosition = newMousePosition
		self.Movable.Position = UDim2.fromOffset(
			math.clamp(movablePos.X + mousePosDiff.X,0,clampX),
			math.clamp(movablePos.Y + mousePosDiff.Y,0,clampY)
		)
	end
	local function Allow(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			return true
		end
		return false
	end
	self.Draggable.InputBegan:Connect(function(input)
		if Allow(input) then
			RunService:BindToRenderStep(self._Id .. self.Movable.Name .. "DraggableFunc",Enum.RenderPriority.Input.Value + 1,Move)
		end
	end)
	self.Draggable.InputEnded:Connect(function(input)
		if Allow(input) then
			RunService:UnbindFromRenderStep(self._Id .. self.Movable.Name .. "DraggableFunc")
			self._LastMousePosition = nil
		end
	end)
end

--[=[
	@within Dragable Class
	@private
	Destroys Dragable Class.
]=]


function Draggable:Destroy()
	self.Draggable:Destroy()
	self.Movable:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end


return Draggable
