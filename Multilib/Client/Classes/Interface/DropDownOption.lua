local Mtypes = require(script.Parent.Parent.Parent.Parent.Types)
local MInstance = require(script.Parent.Parent.Parent.Parent.Shared.Components.Instance)
local DropDownOption = {}
DropDownOption.__index = DropDownOption

--[=[
	@class DropDownOption
	@client
	@private
	Class for DropDownOption object.
]=]

--[=[
	@within DropDownOption
	@return <table> -- [DropDownOption Object]
	Constructor for DropDownOption object.
]=]

function DropDownOption.new(model: any, elements: {GuiObject}, IdName: string, DropDownMenu: {}, useSettings: Mtypes.DropDownOption?)
	local self = setmetatable({}, DropDownOption)

	useSettings = useSettings or {}
	useSettings.Locked = useSettings.Locked or false
	useSettings.Cooldown = useSettings.Cooldown or 0.25

	model, elements = MInstance:PerfectClone(model,elements)

	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end


	self._IsCooldown = false
	self.Initiated = false
	self.ElementType = "DropDownOption"
	self.IsSelected = false

	self._Model = model
	self._Model.Name = IdName
	self.IdName = IdName
	self.DropDownMenu = DropDownMenu

	self.CooldownTime = useSettings.Cooldown
	self.Locked = useSettings.Locked

	self._ModelElements.TextLabel.Text = IdName

	return self
end

--[=[
	@within DropDownOption
	
	should be called only via Form:InitAll().
]=]

function DropDownOption:Init() -- should be called only via Form:InitAll()
	if self.Initiated == false then
		self.Initiated = true
		self._ModelElements.Button.Activated:Connect(function()
			if self.Locked == false and self._IsCooldown == false then
				self._IsCooldown = true
				task.delay(self.CooldownTime,function()
					self._IsCooldown = false
				end)
				if self.IsSelected == false then
					self.DropDownMenu:selectButton(self)
				end
			end
		end)
	end
end

--[=[
	@within DropDownOption
	
	Changes the DropDownOption.locked property.
]=]

function DropDownOption:LockStatus(status: boolean)
	self.Locked = status
end

--[=[
	@within DropDownOption
	
	Sets the Parent of the DropDownOption.model.
]=]

function DropDownOption:Append(where: any)
	self._Model.Parent = where
end

--[=[
	@within DropDownOption
	@private
	Changes selection status.
]=]

function DropDownOption:selectionStatus(value: boolean)
	self.IsSelected = value
end

--[=[
	@within DropDownOption
	Destructor for DropDownOption object.
]=]

function DropDownOption:Destroy()
	self._Model:Destroy()
	self = nil
end


return DropDownOption
