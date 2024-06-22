local MInstance = require(script.Parent.Parent.Components.Instance)
local AnimContainer = {}
AnimContainer.__index = AnimContainer

function AnimContainer.new(animator: Animator)
	local self = setmetatable({}, AnimContainer)
	self.Anims = {
		Uncategorized = {},
		Categorized = {}
	}
	self.Animator = animator
	return self
end

function AnimContainer:NewCategory(categoryName: string)
	self.Anims.Categorized[categoryName] = {}
end

function AnimContainer:InsertNew(anim: any, animName: string, categoryName: string?)
	local function DoLogic(animFianl)
		if categoryName ~= nil then
			if self.Anims.Categorized[categoryName] ~= nil then
				self.Anims.Categorized[categoryName][animName] = animFianl
			else
				self:NewCategory(categoryName)
				self.Anims.Categorized[categoryName][animName] = animFianl
			end
		else
			self.Anims.Uncategorized[animName] = animFianl
		end
	end
	if anim:IsA("Animation") then
		DoLogic(anim)
	elseif typeof(anim) == "number" then
		DoLogic(MInstance:Animation(anim,self.Animator))
	end
end

function AnimContainer:GetRandom(categoryName: string)
	local category = self.Anims.Categorized[categoryName]
	local allFromCategory = {}
	for _, anim in category do
		table.insert(allFromCategory,anim)
	end
	return allFromCategory[math.random(1,#allFromCategory)]
end

function AnimContainer:RemoveAnim(animName: string, categoryName: string?)
	if categoryName ~= nil then
		self.Anims[categoryName][animName] = nil
	else
		self.Anims.Uncategorized[animName] = nil
	end
end

function AnimContainer:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end


return AnimContainer
