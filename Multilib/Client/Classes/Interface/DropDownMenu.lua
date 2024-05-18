local Multilib = require(game:GetService("ReplicatedStorage").Multilib)
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

function DropDownMenu.new(model: any, elements: {GuiObject}, idName: string, DropDownOptions: {any}, settings: Multilib.DropDownMenu?)
	local self = setmetatable({}, DropDownMenu)

	if settings == nil then settings = {} end
	if settings.Locked == nil then settings.Locked = false end
	if settings.Cooldown == nil then settings.Cooldown = 0.25 end
	if settings.Values == nil then settings.Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
	"eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen",
	"eighteen", "nineteen", "twenty", "twenty-one", "twenty-two", "twenty-three",
	"twenty-four", "twenty-five", "twenty-six", "twenty-seven", "twenty-eight",
	"twenty-nine", "thirty"} end
	if settings.SelectedValue == nil then settings.SelectedValue = settings.Values[1] end
	if settings.AnimSettings == nil then settings.AnimSettings = {Time = 0.25,Height = 2} end

	if settings.OverrideDisplayAnimation ~= nil then self.DisplayAnimFunc = settings.OverrideDisplayAnimation end

	local model, elements = self:PerfectClone(model,elements)

	self.modelElements = {}
	for index, value in pairs(elements) do
		self.modelElements[index] = value
	end
	if settings.CanvasSize == nil then settings.CanvasSize = self.modelElements.ScrollingFrame.Size.Y.Scale * 2 end
	self.modelElements.ScrollingFrame.CanvasSize = UDim2.fromScale(0,settings.CanvasSize)

	self.actions = {}
	self.isCooldown = false
	self.initiated = false
	self.IsOpen = false
	self.elementType = "DropDownMenu"
	self.SelectedValue = settings.SelectedValue
	self.AnimSettings = settings.AnimSettings

	self.model = model
	self.model.Name = idName
	self.idName = idName
	self.DropDownOptionsSettings = DropDownOptions
	self.DropDownOptions = {}

	self.cooldownTime = settings.Cooldown
	self.locked = settings.Locked
	self.values = settings.Values

	self:DisplayAnimFunc("ChangeLabel",self.SelectedValue)
	self:DisplayAnimFunc("Collapse",nil,true)

	return self
end

--[=[
	@within DropDownMenu
	
	should be called only via Form:InitAll().
]=]

function DropDownMenu:Init() -- should be called only via Form:InitAll()
	if self.initiated == false then
		self.initiated = true
		local function CreateAndBind(value)
			local DropDownOption = DropDownOption.new(
				self.DropDownOptionsSettings.model,
				self.DropDownOptionsSettings.elements,
				value,
				self,
				self.DropDownOptionsSettings.Settingsa
			)
			DropDownOption:Append(self.modelElements.ScrollingFrame)
			DropDownOption:Init()
			table.insert(self.DropDownOptions,DropDownOption)
		end
		for index,value in pairs(self.values) do
			CreateAndBind(value)
		end
		local ScrollingFrame = self.modelElements.ScrollingFrame
		for index,element in pairs(self.DropDownOptions) do
			local SizeToSet = (1 / #self.DropDownOptions) - self.modelElements.UIListLayout.Padding.Scale
			element = element.model
			element.Size = UDim2.new(
				element.Size.X.Scale,
				element.Size.X.Offset,
				SizeToSet,
				element.Size.Y.Offset
			)
		end

		local SizeToSet = (ScrollingFrame.CanvasSize.Y.Scale * (#self.DropDownOptions * 0.1))
		ScrollingFrame.CanvasSize = UDim2.new(
			ScrollingFrame.CanvasSize.X.Scale,
			ScrollingFrame.CanvasSize.X.Offset,
			SizeToSet,
			ScrollingFrame.CanvasSize.Y.Offset)
		self.modelElements.MainButton.Activated:Connect(function()
			if self.IsOpen == true then
				self:DisplayAnimFunc("Collapse")
			else
				self:DisplayAnimFunc("Expand")
			end
		end)
	end
end

--[=[
	@within DropDownMenu
	
	Changes the DropDownMenu.locked property.
]=]

function DropDownMenu:LockStatus(status: boolean)
	self.locked = status
	for index, DropDownOption in pairs(self.DropDownOptions) do
		DropDownOption:LockStatus(status)
	end
end

--[=[
	@within DropDownMenu
	
	Sets the Parent of the DropDownMenu.model.
]=]

function DropDownMenu:Append(where: any)
	self.model.Parent = where
end

--[=[
	@within DropDownMenu
	@private
	Private Function, should not be called.
]=]

function DropDownMenu:DisplayAnimFunc(AnimType: string, value: string, Forced: boolean) -- internal private function, do not call
	local TweenInfoToUse
	if Forced == true then
		TweenInfoToUse = TweenInfo.new(0,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	else
		TweenInfoToUse = TweenInfo.new(self.AnimSettings.Time,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	end
	if AnimType == "ChangeLabel" then
		self.modelElements.DisplayLabel.Text = value
	elseif AnimType == "Expand" then
		self.modelElements.ScrollingFrame.Visible = true
		self.IsOpen = true
		TweenService:Create(self.modelElements.ScrollingFrame,
			TweenInfoToUse,
			{Size = UDim2.fromScale(1,self.AnimSettings.Height)}
		):Play()
	elseif AnimType == "Collapse" then
		self.IsOpen = false
		TweenService:Create(self.modelElements.ScrollingFrame,
			TweenInfoToUse,
			{Size = UDim2.fromScale(1,0)}
		):Play()
		task.delay(self.AnimSettings.Time,function()
			self.modelElements.ScrollingFrame.Visible = false
		end)
	end
end

--[=[
	@within DropDownMenu
	
	Adds action that will be executed on every value change.
]=]

function DropDownMenu:AddAction(actionName: string, action: any)
	self.actions[actionName] = action
end

--[=[
	@within DropDownMenu
	
	Removes action that would be executed on every value change.
]=]

function DropDownMenu:RemoveAction(actionName: string)
	table.remove(self.actions,actionName)
end

--[=[
	@within DropDownMenu
	@private
	Private Function, should not be called.
]=]

function DropDownMenu:ExecuteActions()
	for index, action in pairs(self.actions) do
		action()
	end
end

--[=[
	@within DropDownMenu
	Inserts element into the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:InsertElement(element: {any})
	self.RadioButtons[element.idName] = element
end

--[=[
	@within DropDownMenu
	Inserts multiple elements into the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:InsertElements(elements: {any})
	for index, element in pairs(elements) do
		self.RadioButtons[element.idName] = element
	end
end

--[=[
	@within DropDownMenu
	Removes element from the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:ClearElement(ElementName: string)
	table.remove(self.RadioButtons,ElementName)
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
	@return <boolean,string> -- [value and idName of the object]
	Returns value and idName of the object.
]=]

function DropDownMenu:ReturnValues()
	return self.SelectedValue, self.idName
end

--[=[
	@within DropDownMenu
	@private
	Selects one button and deselects all the others.
]=]

function DropDownMenu:selectButton(DropDownObject: {any})
	self.SelectedValue = DropDownObject.idName
	self:DisplayAnimFunc("ChangeLabel",self.SelectedValue)
	self:DisplayAnimFunc("Collapse")
	self:ExecuteActions()
end

--[=[
	@within DropDownMenu
	@private
	Private Function, should not be called.
]=]

function DropDownMenu:PerfectClone(trueModel: any, trueElements: {any}) -- internal private function, do not call (also; not quite perfect)
	local model = trueModel:Clone()
	local elements = {}
	for index, element in pairs(trueElements) do
		local path = string.split(element,".")
		local followedPath = model
		for Index2, value in pairs(path) do
			followedPath = followedPath[value]
		end
		elements[index] = followedPath
	end
	return model, elements
end

--[=[
	@within DropDownMenu
	Destructor for DropDownMenu object.
]=]

function DropDownMenu:Destroy()
	self.model:Destroy()
	for index, value in pairs(self) do
		value = nil
	end
end


return DropDownMenu
