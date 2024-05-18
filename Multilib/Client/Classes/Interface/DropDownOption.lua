local Multilib = require(game:GetService("ReplicatedStorage").Multilib)
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

function DropDownOption.new(model: any, elements: {GuiObject}, idName: string, DropDownMenu: {any}, settings: Multilib.DropDownOption?)
	local self = setmetatable({}, DropDownOption)

	if settings == nil then settings = {} end
	if settings.Locked == nil then settings.Locked = false end
	if settings.Cooldown == nil then settings.Cooldown = 0.25 end

	local model, elements = self:PerfectClone(model,elements)

	self.modelElements = {}
	for index, value in pairs(elements) do
		self.modelElements[index] = value
	end


	self.isCooldown = false
	self.initiated = false
	self.elementType = "DropDownOption"
	self.isSelected = false

	self.model = model
	self.model.Name = idName
	self.idName = idName
	self.DropDownMenu = DropDownMenu

	self.cooldownTime = settings.Cooldown
	self.locked = settings.Locked

	self.modelElements.TextLabel.Text = idName

	return self
end

--[=[
	@within DropDownOption
	
	should be called only via Form:InitAll().
]=]

function DropDownOption:Init() -- should be called only via Form:InitAll()
	if self.initiated == false then
		self.initiated = true
		self.modelElements.Button.Activated:Connect(function()
			if self.locked == false and self.isCooldown == false then
				self.isCooldown = true
				task.delay(self.cooldownTime,function()
					self.isCooldown = false
				end)
				if self.isSelected == false then
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
	self.locked = status
end

--[=[
	@within DropDownOption
	
	Sets the Parent of the DropDownOption.model.
]=]

function DropDownOption:Append(where: any)
	self.model.Parent = where
end

--[=[
	@within DropDownOption
	@private
	Private Function, should not be called.
]=]

function DropDownOption:PerfectClone(trueModel: any, trueElements: {any}) -- internal private function, do not call (also; not quite perfect)
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
	@within DropDownOption
	@private
	Changes selection status.
]=]

function DropDownOption:selectionStatus(value: boolean)
	self.isSelected = value
end

--[=[
	@within DropDownOption
	Destructor for DropDownOption object.
]=]

function DropDownOption:Destroy()
	self.model:Destroy()
	for index, value in pairs(self) do
		value = nil
	end
end


return DropDownOption
