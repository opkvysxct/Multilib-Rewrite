local MInstance = require(script.Parent.Parent.Parent.Shared.Components.Instance)
local TweenService = game:GetService("TweenService")
local Lib = {}

-- Core
function Lib:AppendBigNotif(title: string, description: string, imageID: number?)
	if self.BigNotifConfig.WasConfigured == true then
		if #self._Queue == 0 then
			table.insert(self._Queue,{Title = title, Description = description, ImageID = imageID})
			self:_AppendBigNotifLogic(title, description, imageID)
		else
			table.insert(self._Queue,{Title = title, Description = description, ImageID = imageID})
		end
	else
		warn("[Multilib-" .. script.Name .. "]", "No config provided for Big Notification.")
	end
end

function Lib:AppendSmallNotif(title: string, description: string, imageID: number?)
	if self.SmallNotifConfig.WasConfigured == true then
		self:_AppendSmallNotifLogic(title, description, imageID)
	else
		warn("[Multilib-" .. script.Name .. "]", "No config provided for Small Notification.")
	end
end

function Lib:_AppendBigNotifLogic(title: string, description: string, imageID: number?)
	local model, elements = MInstance:PerfectClone(self.BigNotifConfig.Template,self.BigNotifConfig.TemplatePathes)
	elements.Title.Text = title
	elements.Description.Text = description
	if elements["Image"] then
		elements.Image.Image = "rbxassetid://" .. imageID
	end
	model.Parent = self.BigNotifConfig.AppearWhere
	self.BigNotifConfig.Animations.appear(model,elements)
	task.delay(self.BigNotifConfig.Time,function()
		self.BigNotifConfig.Animations.disappear(model,elements)
		model:Destroy()
		if #self._Queue > 1 then
			local nextNotif = self._Queue[2]
			table.remove(self._Queue,1)
			self:_AppendBigNotifLogic(nextNotif.Title, nextNotif.Description, nextNotif.ImageID)
		else
			table.remove(self._Queue,1)
		end
	end)
end

function Lib:_AppendSmallNotifLogic(title: string, description: string, imageID: number?)
	local model, elements = MInstance:PerfectClone(self.SmallNotifConfig.Template,self.SmallNotifConfig.TemplatePathes)
	local heightBase = model.Size.Y.Scale
	table.insert(self._SmallNotifs,{Model = model, Elements = elements})
	for index, notif in self._SmallNotifs do
		local heighToUse = self.SmallNotifConfig.PositionLogic(index,heightBase)
		self.SmallNotifConfig.Animations.giveWay(notif.Model,notif.Elements, heighToUse)
	end
	elements.Title.Text = title
	elements.Description.Text = description
	if elements["Image"] then
		elements.Image.Image = "rbxassetid://" .. imageID
	end
	model.Parent = self.SmallNotifConfig.AppearWhere
	self.SmallNotifConfig.Animations.appear(model,elements)
	task.delay(self.SmallNotifConfig.Time,function()
		table.remove(self._SmallNotifs,1)
		self.SmallNotifConfig.Animations.disappear(model,elements)
		model:Destroy()
	end)
end

-- Settings
function Lib:SetBigNotifConfig(time: number, appearWhere: GuiObject, template: GuiObject, templatePathes: {GuiObject})
	self.BigNotifConfig.Time = time
	self.BigNotifConfig.AppearWhere = appearWhere
	self.BigNotifConfig.Template = template
	self.BigNotifConfig.TemplatePathes = templatePathes
	self.BigNotifConfig.WasConfigured = true
end

function Lib:SetSmallNotifConfig(time: number, appearWhere: GuiObject, template: GuiObject, templatePathes: {GuiObject}, positionLogic: any?)
	self.SmallNotifConfig.Time = time
	self.SmallNotifConfig.AppearWhere = appearWhere
	self.SmallNotifConfig.Template = template
	self.SmallNotifConfig.TemplatePathes = templatePathes
	self.SmallNotifConfig.WasConfigured = true
	if positionLogic then
		self.SmallNotifConfig.PositionLogic = positionLogic
	end
end

function Lib:SetBigNotifAnimations(anims: {})
	self.BigNotifConfig.Animations = anims
end

function Lib:SetSmallNotifAnimations(anims: {})
	self.SmallNotifConfig.Animations = anims
end

function Lib:SetPadding(padding: number)
	self.Padding = padding
end

-- End
function Lib:Init(comments: boolean)
	self.Padding = 0.01
	self._Queue = {}
	self.BigNotifConfig = {
		WasConfigured = false,
		Time = 6,
		AppearWhere = nil,
		Template = nil,
		TemplatePathes = {},
		Animations = {
			appear = function(model: GuiObject, elements: {GuiObject})
				model.GroupTransparency = 1
				TweenService:Create(model,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{GroupTransparency = 0}):Play()
				task.wait(0.25)
			end,
			disappear = function(model: GuiObject, elements: {GuiObject})
				TweenService:Create(model,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{GroupTransparency = 1}):Play()
				task.wait(0.25)
			end
		}
	}
	self._SmallNotifs = {}
	self.SmallNotifConfig = {
		WasConfigured = false,
		Time = 4,
		AppearWhere = nil,
		Template = nil,
		TemplatePathes = {},
		Animations = {
			appear = function(model: GuiObject, elements: {GuiObject})
				model.Position = UDim2.fromScale(0,1)
				elements.Wrapper.Position = UDim2.fromScale(-1,0)
				TweenService:Create(elements.Wrapper,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{Position = UDim2.fromScale(0,0)}):Play()
				task.wait(0.1)
			end,
			disappear = function(model: GuiObject, elements: {GuiObject})
				TweenService:Create(elements.Wrapper,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{Position = UDim2.fromScale(-1,0)}):Play()
				task.wait(0.1)
			end,
			giveWay = function(model: GuiObject, elements: {GuiObject}, height: number)
				TweenService:Create(model,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{Position = UDim2.fromScale(0,height)}):Play()
			end
		},
		PositionLogic = function(index: number, heightBase: number)
			return 1 - (((#self._SmallNotifs - index) * heightBase) + (self.Padding * (#self._SmallNotifs - index)))
		end
	}
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib