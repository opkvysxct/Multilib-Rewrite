local Lib = {}

-- Core


-- Settings
function Lib:SetSmallNotifConfig(time: number, template: GuiObject)
	self.SmallNotifConfig.Time = time
	self.SmallNotifConfig.Template = template
end

function Lib:SetBigNotifConfig(time: number, template: GuiObject)
	self.BigNotifConfig.Time = time
	self.BigNotifConfig.Template = template
end

function Lib:SetPadding(padding: number)
	self.Padding = padding
end

-- End
function Lib:Init(comments: boolean)
	self.Padding = 0.01
	self.SmallNotifConfig = {
		Time = 4,
		Template = nil,
	}
	self.BigNotifConfig = {
		Time = 6,
		Template = nil,
	}
	if comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name, "Lib Loaded & safe to use.")
	end
end

return Lib