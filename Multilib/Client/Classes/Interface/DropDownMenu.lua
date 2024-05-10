local TweenService = game:GetService("TweenService")
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

function DropDownMenu.new(Model: any, Elements: table, IDName: string, DropDownOptions: table, Settings: table)
	local self = setmetatable({}, DropDownMenu)

	if Settings == nil then Settings = {} end
	if Settings.Locked == nil then Settings.Locked = false end
	if Settings.Cooldown == nil then Settings.Cooldown = 0.25 end
	if Settings.Values == nil then Settings.Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
	"eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen",
	"eighteen", "nineteen", "twenty", "twenty-one", "twenty-two", "twenty-three",
	"twenty-four", "twenty-five", "twenty-six", "twenty-seven", "twenty-eight",
	"twenty-nine", "thirty"} end
	if Settings.SelectedValue == nil then Settings.SelectedValue = Settings.Values[1] end
	if Settings.AnimSettings == nil then Settings.AnimSettings = {Time = 0.25,Height = 2} end

	if Settings.OverrideDisplayAnimation ~= nil then self.displayAnimFunc = Settings.OverrideDisplayAnimation end

	local Model, Elements = self:perfectClone(Model,Elements)

	self.ModelElements = {}
	for Index, Value in pairs(Elements) do
		self.ModelElements[Index] = Value
	end
	if Settings.CanvasSize == nil then Settings.CanvasSize = self.ModelElements.ScrollingFrame.Size.Y.Scale * 2 end
	self.ModelElements.ScrollingFrame.CanvasSize = UDim2.fromScale(0,Settings.CanvasSize)

	self.Actions = {}
	self.IsCooldown = false
	self.Initiated = false
	self.IsOpen = false
	self.Type = "DropDownMenu"
	self.SelectedValue = Settings.SelectedValue
	self.AnimSettings = Settings.AnimSettings

	self.Model = Model
	self.Model.Name = IDName
	self.IDName = IDName
	self.DropDownOptionsSettings = DropDownOptions
	self.DropDownOptions = {}

	self.CooldownTime = Settings.Cooldown
	self.Locked = Settings.Locked
	self.Values = Settings.Values

	self:displayAnimFunc("ChangeLabel",self.SelectedValue)
	self:displayAnimFunc("Collapse",nil,true)

	return self
end

--[=[
	@within DropDownMenu
	
	should be called only via Form:InitAll().
]=]

function DropDownMenu:init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		local function CreateAndBind(Value)
			local DropDownOption = _G.MDropDownOption.new(
				self.DropDownOptionsSettings.Model,
				self.DropDownOptionsSettings.Elements,
				Value,
				self,
				self.DropDownOptionsSettings.Settingsa
			)
			DropDownOption:append(self.ModelElements.ScrollingFrame)
			DropDownOption:init()
			table.insert(self.DropDownOptions,DropDownOption)
		end
		for Index,Value in pairs(self.Values) do
			CreateAndBind(Value)
		end
		local ScrollingFrame = self.ModelElements.ScrollingFrame
		for Index,Element in pairs(self.DropDownOptions) do
			local SizeToSet = (1 / #self.DropDownOptions) - self.ModelElements.UIListLayout.Padding.Scale
			Element = Element.Model
			Element.Size = UDim2.new(
				Element.Size.X.Scale,
				Element.Size.X.Offset,
				SizeToSet,
				Element.Size.Y.Offset
			)
		end

		local SizeToSet = (ScrollingFrame.CanvasSize.Y.Scale * (#self.DropDownOptions * 0.1))
		ScrollingFrame.CanvasSize = UDim2.new(
			ScrollingFrame.CanvasSize.X.Scale,
			ScrollingFrame.CanvasSize.X.Offset,
			SizeToSet,
			ScrollingFrame.CanvasSize.Y.Offset)
		self.ModelElements.MainButton.Activated:Connect(function()
			if self.IsOpen == true then
				self:displayAnimFunc("Collapse")
			else
				self:displayAnimFunc("Expand")
			end
		end)
	end
end

--[=[
	@within DropDownMenu
	
	Changes the DropDownMenu.Locked property.
]=]

function DropDownMenu:lockStatus(Status: boolean)
	self.Locked = Status
	for Index, DropDownOption in pairs(self.DropDownOptions) do
		DropDownOption:lockStatus(Status)
	end
end

--[=[
	@within DropDownMenu
	
	Sets the parent of the DropDownMenu.Model.
]=]

function DropDownMenu:append(Where: any)
	self.Model.Parent = Where
end

--[=[
	@within DropDownMenu
	@private
	Private Function, should not be called.
]=]

function DropDownMenu:displayAnimFunc(AnimType: string, Value: string, Forced: boolean) -- internal private function, do not call
	local TweenInfoToUse
	if Forced == true then
		TweenInfoToUse = TweenInfo.new(0,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	else
		TweenInfoToUse = TweenInfo.new(self.AnimSettings.Time,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	end
	if AnimType == "ChangeLabel" then
		self.ModelElements.DisplayLabel.Text = Value
	elseif AnimType == "Expand" then
		self.ModelElements.ScrollingFrame.Visible = true
		self.IsOpen = true
		TweenService:Create(self.ModelElements.ScrollingFrame,
			TweenInfoToUse,
			{Size = UDim2.fromScale(1,self.AnimSettings.Height)}
		):Play()
	elseif AnimType == "Collapse" then
		self.IsOpen = false
		TweenService:Create(self.ModelElements.ScrollingFrame,
			TweenInfoToUse,
			{Size = UDim2.fromScale(1,0)}
		):Play()
		task.delay(0.1,function()
			self.ModelElements.ScrollingFrame.Visible = false
		end)
	end
end

--[=[
	@within DropDownMenu
	
	Adds action that will be executed on every value change.
]=]

function DropDownMenu:addAction(ActionName: string, Action: any)
	self.Actions[ActionName] = Action
end

--[=[
	@within DropDownMenu
	
	Removes action that would be executed on every value change.
]=]

function DropDownMenu:removeAction(ActionName: string)
	table.remove(self.Actions,ActionName)
end

--[=[
	@within DropDownMenu
	@private
	Private Function, should not be called.
]=]

function DropDownMenu:executeActions()
	for Index, Action in pairs(self.Actions) do
		Action()
	end
end

--[=[
	@within DropDownMenu
	Inserts element into the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:insertElement(Element: table)
	self.RadioButtons[Element.IDName] = Element
end

--[=[
	@within DropDownMenu
	Inserts multiple elements into the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:insertElements(Elements: table)
	for Index, Element in pairs(Elements) do
		self.RadioButtons[Element.IDName] = Element
	end
end

--[=[
	@within DropDownMenu
	Removes element from the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:clearElement(ElementName: string)
	table.remove(self.RadioButtons,ElementName)
end

--[=[
	@within DropDownMenu
	Clears the DropDownMenu.RadioButtons table.
]=]

function DropDownMenu:clearAllElements()
	table.clear(self.RadioButtons)
end

--[=[
	@within DropDownMenu
	@return <boolean,string> -- [Value and IDName of the object]
	Returns value and IDName of the object.
]=]

function DropDownMenu:returnValues()
	return self.SelectedValue, self.IDName
end

--[=[
	@within DropDownMenu
	@private
	Selects one button and deselects all the others.
]=]

function DropDownMenu:selectButton(DropDownObject: table)
	self.SelectedValue = DropDownObject.IDName
	self:displayAnimFunc("ChangeLabel",self.SelectedValue)
	self:displayAnimFunc("Collapse")
	self:executeActions()
end

--[=[
	@within DropDownMenu
	@private
	Private Function, should not be called.
]=]

function DropDownMenu:perfectClone(TrueModel: any, TrueElements: table) -- internal private function, do not call (also; not quite perfect)
	local Model = TrueModel:Clone()
	local Elements = {}
	for Index, Element in pairs(TrueElements) do
		local Path = string.split(Element,".")
		local FollowedPath = Model
		for Index2, Value in pairs(Path) do
			FollowedPath = FollowedPath[Value]
		end
		Elements[Index] = FollowedPath
	end
	return Model, Elements
end

--[=[
	@within DropDownMenu
	Destructor for DropDownMenu object.
]=]

function DropDownMenu:destroy()
	self.Model:Destroy()
	for Index, Value in pairs(self) do
		Value = nil
	end
end


return DropDownMenu
