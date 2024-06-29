local Mtypes = require(script.Parent.Parent.Types)
local PerfectClone = require(script.Parent.Parent.PerfectClone)
local TweenService = game:GetService("TweenService")
local DropDownOption = require(script.Parent.DropDownOption)
local DropDownMenu = {}
DropDownMenu.__index = DropDownMenu

--[=[
	@class DropDownMenu
	@client
	Class for DropDownMenu object.
]=]

--[=[
	@within DropDownMenu
	@return <table> -- [DropDownMenu Object]
	Constructor for DropDownMenu object.
]=]

function DropDownMenu.new(model: GuiObject, elements: {GuiObject}, IdName: string, uiOrder: number, DropDownOptions: {}, useSettings: Mtypes.DropDownMenu)
	local self = setmetatable({}, DropDownMenu)
	local trueSettings = {}

	useSettings = useSettings or table.clone(Mtypes.TDropDownMenu)
	trueSettings.Locked = useSettings.Locked or false
	trueSettings.Cooldown = useSettings.Cooldown or 0.25
	trueSettings.Values = useSettings.Values or {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"}
	trueSettings.SelectedValue = useSettings.SelectedValue or trueSettings.Values[1]
	trueSettings.AnimSettings = useSettings.AnimSettings or {Time = 0.25,Height = 2}

	if useSettings.OverrideDisplayAnimation ~= nil then
		self._DisplayAnimFunc = useSettings.OverrideDisplayAnimation 
	end

	model, elements = PerfectClone(model,elements)
	model.LayoutOrder = uiOrder

	self._ModelElements = {}
	for index, value in pairs(elements) do
		self._ModelElements[index] = value
	end
	trueSettings.CanvasSize = useSettings.CanvasSize or self._ModelElements.ScrollingFrame.Size.Y.Scale * 2
	self._ModelElements.ScrollingFrame.CanvasSize = UDim2.fromScale(0,trueSettings.CanvasSize)

	self.Actions = {}
	self._IsCooldown = false
	self.Initiated = false
	self.IsOpen = false
	self.ElementType = "DropDownMenu"
	self.SelectedValue = trueSettings.SelectedValue
	self.AnimSettings = trueSettings.AnimSettings

	self._Model = model
	self._Model.Name = IdName
	self.IdName = IdName
	self.DropDownOptionsSettings = DropDownOptions
	self.DropDownOptions = {}

	self.CooldownTime = trueSettings.Cooldown
	self.Locked = trueSettings.Locked
	self.Values = trueSettings.Values

	self:_DisplayAnimFunc("ChangeLabel",self.SelectedValue)
	self:_DisplayAnimFunc("Collapse",nil,true)

	return self
end

--[=[
	@within DropDownMenu
	
	should be called only via Form:InitAll().
]=]

function DropDownMenu:Init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		local function CreateAndBind(value, order)
			local DropDownOptionObject = DropDownOption.new(
				self.DropDownOptionsSettings.Model,
				self.DropDownOptionsSettings.Elements,
				value,
				order,
				self,
				self.DropDownOptionsSettings.Settings
			)
			DropDownOptionObject:Append(self._ModelElements.ScrollingFrame)
			DropDownOptionObject:Init()
			table.insert(self.DropDownOptions,DropDownOptionObject)
		end
		for index,value in pairs(self.Values) do
			CreateAndBind(value,index)
		end
		local ScaleSub = self._ModelElements.UIListLayout.Padding.Scale / (#self.DropDownOptions * 0.1)
		local ScrollingFrame = self._ModelElements.ScrollingFrame
		for _,element in pairs(self.DropDownOptions) do
			local SizeToSet = (1 / #self.DropDownOptions) - ScaleSub
			element = element._Model

			element.Size = UDim2.new(
				element.Size.X.Scale,
				element.Size.X.Offset,
				SizeToSet,
				element.Size.Y.Offset
			)
		end
		local SizeToSet = (ScrollingFrame.CanvasSize.Y.Scale * (#self.DropDownOptions * 0.1))
		self._ModelElements.UIListLayout.Padding = UDim.new(ScaleSub,0)
		ScrollingFrame.CanvasSize = UDim2.new(
			ScrollingFrame.CanvasSize.X.Scale,
			ScrollingFrame.CanvasSize.X.Offset,
			SizeToSet,
			ScrollingFrame.CanvasSize.Y.Offset)
		self._ModelElements.MainButton.Activated:Connect(function()
			if self.IsOpen == true then
				self:_DisplayAnimFunc("Collapse")
			else
				self:_DisplayAnimFunc("Expand")
			end
		end)
	end
end

--[=[
	@within DropDownMenu
	
	Changes the DropDownMenu.locked property.
]=]

function DropDownMenu:LockStatus(status: boolean)
	self.Locked = status
	for _, DropDownOptionObject in pairs(self.DropDownOptions) do
		DropDownOptionObject:LockStatus(status)
	end
end

--[=[
	@within DropDownMenu
	
	Sets the Parent of the DropDownMenu.model.
]=]

function DropDownMenu:Append(where: any)
	self._Model.Parent = where
end

--[=[
	@within DropDownMenu
	@private
	Private Function, should not be called.
]=]

function DropDownMenu:_DisplayAnimFunc(AnimType: string, value: string, Forced: boolean) -- internal private function, do not call
	local TweenInfoToUse
	if Forced == true then
		TweenInfoToUse = TweenInfo.new(0,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	else
		TweenInfoToUse = TweenInfo.new(self.AnimSettings.Time,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	end
	if AnimType == "ChangeLabel" then
		self._ModelElements.DisplayLabel.Text = value
	elseif AnimType == "Expand" then
		self._ModelElements.ScrollingFrame.Visible = true
		self.IsOpen = true
		TweenService:Create(self._ModelElements.ScrollingFrame,
			TweenInfoToUse,
			{Size = UDim2.fromScale(1,self.AnimSettings.Height)}
		):Play()
	elseif AnimType == "Collapse" then
		self.IsOpen = false
		TweenService:Create(self._ModelElements.ScrollingFrame,
			TweenInfoToUse,
			{Size = UDim2.fromScale(1,0)}
		):Play()
		task.delay(self.AnimSettings.Time,function()
			self._ModelElements.ScrollingFrame.Visible = false
		end)
	end
end

--[=[
	@within DropDownMenu
	
	Adds action that will be executed on every value change.
]=]

function DropDownMenu:AddAction(actionName: string, action: any)
	self.Actions[actionName] = action
end

--[=[
	@within DropDownMenu
	
	Removes action that would be executed on every value change.
]=]

function DropDownMenu:RemoveAction(actionName: string)
	self.Actions[actionName] = nil
end

--[=[
	@within DropDownMenu
	@private
	Private Function, should not be called.
]=]

function DropDownMenu:_ExecuteActions()
	for _, action in pairs(self.Actions) do
		action()
	end
end

--[=[
	@within DropDownMenu
	Inserts element into the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:InsertElement(element: {IdName: string})
	self.RadioButtons[element.IdName] = element
end

--[=[
	@within DropDownMenu
	Inserts multiple elements into the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:InsertElements(elements: {})
	for _, element in pairs(elements) do
		self.RadioButtons[element.IdName] = element
	end
end

--[=[
	@within DropDownMenu
	Removes element from the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:ClearElement(ElementName: string)
	self.RadioButtons[ElementName] = nil
end

--[=[
	@within DropDownMenu
	Clears the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:ClearAllElements()
	table.clear(self.RadioButtons)
end

--[=[
	@within DropDownMenu
	@return <boolean,string> -- [value and IdName of the object]
	Returns value and IdName of the object.
]=]

function DropDownMenu:ReturnValues()
	return self.SelectedValue, self.IdName
end

--[=[
	@within DropDownMenu
	@private
	Selects one button and deselects all the others.
]=]

function DropDownMenu:selectButton(DropDownObject: {IdName: string})
	self.SelectedValue = DropDownObject.IdName
	self:_DisplayAnimFunc("ChangeLabel",self.SelectedValue)
	self:_DisplayAnimFunc("Collapse")
	self:_ExecuteActions()
end

--[=[
	@within DropDownMenu
	Destructor for DropDownMenu object.
]=]

function DropDownMenu:Destroy()
	self._Model:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end


return DropDownMenu
