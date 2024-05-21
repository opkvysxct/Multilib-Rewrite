local Mtypes = require(game:GetService("ReplicatedStorage").Multilib.Types)
local MInstance = require(game:GetService("ReplicatedStorage").Multilib.Shared.Components.Instance)
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

function DropDownOption.new(model: any, elements: {GuiObject}, idName: string, DropDownMenu: {any}, settings: Mtypes.DropDownOption?)
	local self = setmetatable({}, DropDownOption)

	if settings == nil then settings = {} end
	if settings.Locked == nil then settings.Locked = false end
	if settings.Cooldown == nil then settings.Cooldown = 0.25 end

	local model, elements = MInstance:PerfectClone(model,elements)

	self._ModelElements = {}
	for index, value in elements do
		self._ModelElements[index] = value
	end


	self._IsCooldown = false
	self.Initiated = false
	self.ElementType = "DropDownOption"
	self.IsSelected = false

	self.Model = model
	self.Model.Name = idName
	self.IdName = idName
	self.DropDownMenu = DropDownMenu

	self.CooldownTime = settings.Cooldown
	self.Locked = settings.Locked

	self._ModelElements.TextLabel.Text = idName

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
	self.Model.Parent = where
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
	self.Model:Destroy()
	for index, value in self do
		value = nil
	end
end


return DropDownOption
