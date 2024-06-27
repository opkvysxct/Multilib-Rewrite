local MInstance = require(script.Parent.Parent.Components.Instance)
local Animator = {}
Animator.__index = Animator

--[=[
	@class Animator Class
	Animator Class.
]=]

--[=[
	@within Animator Class	
	@return <AnimatorClass>
	Creates Animator Class.
]=]

function Animator.new(animator: Animator)
	local self = setmetatable({}, Animator)
	self.Anims = {
		Uncategorized = {},
		Categorized = {}
	}
	self.Animator = animator
	return self
end

--[=[
	@within Animator Class	
	Creates new category inside Animator Class.
]=]

function Animator:NewCategory(categoryName: string)
	self.Anims.Categorized[categoryName] = {}
end

--[=[
	@within Animator Class	
	Inserts new animation to Animator Class.
]=]

function Animator:InsertNew(anim: Animation | number, animName: string, categoryName: string?)
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
	if typeof(anim) == "number" then
		DoLogic(MInstance:Animation(anim,self.Animator))
	elseif anim:IsA("Animation") then
		DoLogic(anim)
	end
end

--[=[
	@within Animator Class
	Removes animation from given category, if no categoryName is provided then will remove animation from Uncategorized category.
]=]

function Animator:RemoveAnim(animName: string, categoryName: string?)
	if categoryName ~= nil then
		self.Anims[categoryName][animName] = nil
	else
		self.Anims.Uncategorized[animName] = nil
	end
end


--[=[
	@within Animator Class
	@return <Animation>
	Returns random animation from given category.
]=]

function Animator:GetRandom(categoryName: string)
	local category = self.Anims.Categorized[categoryName]
	local allFromCategory = {}
	for _, anim in category do
		table.insert(allFromCategory,anim)
	end
	return allFromCategory[math.random(1,#allFromCategory)]
end

--[=[
	@within Animator Class
	Destroys Animator Class.
]=]

function Animator:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return Animator
