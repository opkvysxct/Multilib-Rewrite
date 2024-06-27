local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MInstance = require(ReplicatedStorage.Packages.Multilib).Shared.C.Instance
local TweenService = game:GetService("TweenService")
local Lib = {}

--[=[
	@class Alerts Package
	Alerts Utils.
]=]

-- Core

--[=[
	@within Alerts Package
	Appends info alert on screen with given proporties, then yields until player input is provided.
]=]

function Lib:AppendInfoAlert(title: string, description: string, imageID: number?)
	if self.InfoAlertConfig.WasConfigured == true then
		local canProceed = false
		local model, elements = MInstance:PerfectClone(self.InfoAlertConfig.Template,self.InfoAlertConfig.TemplatePathes)
		elements.Title.Text = title
		elements.Description.Text = description
		if imageID ~= nil then
			elements.Image.Image = "rbxassetid://" .. imageID
		end
		model.Parent = self.InfoAlertConfig.AppearWhere
		self.InfoAlertConfig.Animations.appear(model,elements)
		elements.Proceed.Activated:Once(function()
			self.InfoAlertConfig.Animations.disappear(model,elements)
			model:Destroy()
			canProceed = true
		end)
		repeat task.wait()
		until canProceed
	else
		warn("[MultiUI-" .. script.Name .. "]", "No config provided for Info Alert.")
		return
	end
end

--[=[
	@within Alerts Package
	@return <true | false>
	Appends choice alert on screen with given proporties, then yields until player input is provided.
]=]

function Lib:AppendChoiceAlert(title: string, description: string, imageID: number?)
	local valueToReturn = nil
	if self.ChoiceAlertConfig.WasConfigured == true then
		local canProceed = false
		local model, elements = MInstance:PerfectClone(self.ChoiceAlertConfig.Template,self.ChoiceAlertConfig.TemplatePathes)
		elements.Title.Text = title
		elements.Description.Text = description
		if imageID ~= nil then
			elements.Image.Image = "rbxassetid://" .. imageID
		end
		model.Parent = self.ChoiceAlertConfig.AppearWhere
		self.ChoiceAlertConfig.Animations.appear(model,elements)
		local cons = {}
		cons["yes"] = elements.Yes.Activated:Once(function()
			cons["no"]:Disconnect()
			self.ChoiceAlertConfig.Animations.disappear(model,elements)
			model:Destroy()
			valueToReturn = true
			canProceed = true
		end)
		cons["no"] = elements.No.Activated:Once(function()
			cons["no"]:Disconnect()
			self.ChoiceAlertConfig.Animations.disappear(model,elements)
			model:Destroy()
			valueToReturn = false
			canProceed = true
		end)
		repeat task.wait()
		until canProceed
	else
		warn("[Multilib-" .. script.Name .. "]", "No config provided for Choice Alert.")
		return
	end
	return valueToReturn
end

--[=[
	@within Alerts Package
	Sets config for info alert.
]=]

function Lib:SetInfoAlertConfig(appearWhere: GuiObject, template: GuiObject, templatePathes: {GuiObject})
	self.InfoAlertConfig.AppearWhere = appearWhere
	self.InfoAlertConfig.Template = template
	self.InfoAlertConfig.TemplatePathes = templatePathes
	self.InfoAlertConfig.WasConfigured = true
end

--[=[
	@within Alerts Package
	Sets anims for info config.
]=]

function Lib:SetInfoAlertAnims(anims: {()-> nil})
	self.InfoAlertConfig.Animations = anims
end

--[=[
	@within Alerts Package
	Sets config for choice alert.
]=]

function Lib:SetChoiceAlertConfig(appearWhere: GuiObject, template: GuiObject, templatePathes: {GuiObject})
	self.ChoiceAlertConfig.AppearWhere = appearWhere
	self.ChoiceAlertConfig.Template = template
	self.ChoiceAlertConfig.TemplatePathes = templatePathes
	self.ChoiceAlertConfig.WasConfigured = true
end

--[=[
	@within Alerts Package
	Sets anims for choice config.
]=]

function Lib:SetChoiceAlertAnims(anims: {()-> nil})
	self.ChoiceAlertConfig.Animations = anims
end

-- End
function Lib:Init()
	self.InfoAlertConfig = {
		WasConfigured = false,
		Template = nil,
		TemplatePathes = {},
		AppearWhere = nil,
		Animations = {
			appear = function(model: GuiObject, elements: {GuiObject})
				model.Size = UDim2.fromScale(0,0)
				TweenService:Create(model,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{Size = UDim2.fromScale(1,1)}):Play()
				task.wait(0.25)
			end,
			disappear = function(model: GuiObject, elements: {GuiObject})
				TweenService:Create(model,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{Size = UDim2.fromScale(0,0)}):Play()
				task.wait(0.25)
			end
		}
	}
	self.ChoiceAlertConfig = {
		WasConfigured = false,
		Template = nil,
		TemplatePathes = {},
		AppearWhere = nil,
		Animations = {
			appear = function(model: GuiObject, elements: {GuiObject})
				model.Size = UDim2.fromScale(0,0)
				TweenService:Create(model,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{Size = UDim2.fromScale(1,1)}):Play()
				task.wait(0.25)
			end,
			disappear = function(model: GuiObject, elements: {GuiObject})
				TweenService:Create(model,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{Size = UDim2.fromScale(0,0)}):Play()
				task.wait(0.25)
			end
		}
	}
end

return Lib