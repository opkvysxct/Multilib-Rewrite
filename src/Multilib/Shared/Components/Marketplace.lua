local MarketplaceService = game:GetService("MarketplaceService")
local Lib = {}

local function IsPlayer(player)
	if player == nil then
		if player ~= nil then
			return player
		else
			warn("[Multilib-" .. script.Name .. "]", "No player specified.")
			return false
		end
	else
		return player
	end
end

-- Core
function Lib:CheckPlayerGamepass(id : number, Prompt : boolean, player : Player)
	player = IsPlayer(player)
	if player == false then
		return false
	end
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
	elseif Prompt == true then
		MarketplaceService:PromptGamePassPurchase(player,id)
	end
	return false
end

function Lib:PromptProductPurchase(id : number, player : Player)
	player = IsPlayer(player)
	if player == false then
		return false
	end
	MarketplaceService:PromptProductPurchase(player, id)
end

function Lib:PromptPremiumPurchase(player : Player)
	player = IsPlayer(player)
	if player == false then
		return false
	end
	MarketplaceService:PromptPremiumPurchase(player)
end

-- End
function Lib:Init()

end

return Lib