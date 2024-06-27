local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lib = {}

local function IsPlayer(player)
	if RunService:IsClient() and player == nil then
		return Players.LocalPlayer
	else
		return player
	end
end

--[=[
	@class Marketplace Package
	Marketplace Utils.
]=]

-- Core

--[=[
	@within Marketplace Package
	@return <true | false>
	Checks if given player have given gamepass.
]=]

function Lib:CheckPlayerGamepass(id : number, prompt : boolean, player : Player?)
	player = IsPlayer(player)
	if player == nil then return false end
	local hasPass = false
	local success, message = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, id)
	end)
	if not success then
		warn("[Multilib-" .. script.Name .. "]", "Error checking gamepass ownership" , tostring(message))
		return false
	end
	if hasPass == true then
		return true
	elseif prompt == true then
		MarketplaceService:PromptGamePassPurchase(player,id)
	end
	return false
end

--[=[
	@within Marketplace Package
	Prompts given product to given player.
]=]

function Lib:PromptProductPurchase(id : number, player : Player)
	player = IsPlayer(player)
	MarketplaceService:PromptProductPurchase(player, id)
end

--[=[
	@within Marketplace Package
	Prompts Roblox Premium to given player.
]=]

function Lib:PromptPremiumPurchase(player : Player)
	player = IsPlayer(player)
	MarketplaceService:PromptPremiumPurchase(player)
end

-- End
function Lib:Init()

end

return Lib