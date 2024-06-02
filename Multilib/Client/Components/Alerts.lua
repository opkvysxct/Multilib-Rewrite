local MInstance = require(script.Parent.Parent.Parent.Shared.Components.Instance)
local TweenService = game:GetService("TweenService")
local Lib = {}

-- Core
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
		warn("[Multilib-" .. script.Name .. "]", "No config provided for Info Alert.")
		return false
	end
	return true
end

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
		return false
	end
	return valueToReturn
end

function Lib:SetInfoAlertConfig(appearWhere: GuiObject, template: GuiObject, templatePathes: {GuiObject})
	self.InfoAlertConfig.AppearWhere = appearWhere
	self.InfoAlertConfig.Template = template
	self.InfoAlertConfig.TemplatePathes = templatePathes
	self.InfoAlertConfig.WasConfigured = true
end

function Lib:SetInfoAlertAnims(anims: {()-> nil})
	self.InfoAlertConfig.Animations = anims
end

function Lib:SetChoiceAlertConfig(appearWhere: GuiObject, template: GuiObject, templatePathes: {GuiObject})
	self.ChoiceAlertConfig.AppearWhere = appearWhere
	self.ChoiceAlertConfig.Template = template
	self.ChoiceAlertConfig.TemplatePathes = templatePathes
	self.ChoiceAlertConfig.WasConfigured = true
end

function Lib:SetChoiceAlertAnims(anims: {()-> nil})
	self.ChoiceAlertConfig.Animations = anims
end


-- End
function Lib:Init(comments: boolean)
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
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib