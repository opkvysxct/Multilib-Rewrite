local MarketplaceService = game:GetService("MarketplaceService")
local Lib = {}

local function IsPlayer(Player)
	if Player == nil then
		if _G.M_Loader.Player ~= nil then
			return _G.M_Loader.Player
		else
			warn("[Multilib-" .. script.Name .. "]", "No Player specified.")
			return false
		end
	else
		return Player
	end
end

-- Core
function Lib:CheckPlayerGamepass(ID : number, Prompt : boolean, Player : Player)
	Player = IsPlayer(Player)
	if Player == false then
		return false
	end
	local HasPass = false
	local success, message = pcall(function()
		HasPass = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, ID)
	end)
	if not success then
		warn("[Multilib-" .. script.Name .. "]", "Error checking gamepass ownership" , tostring(message))
		return false
	end
	if HasPass == true then
		return true
	elseif Prompt == true then
		MarketplaceService:PromptGamePassPurchase(Player,ID)
	end
	return false
end

function Lib:PromptProductPurchase(ID : number, Player : Player)
	Player = IsPlayer(Player)
	if Player == false then
		return false
	end
	MarketplaceService:PromptProductPurchase(Player, ID)
end

function Lib:PromptPremiumPurchase(Player : Player)
	Player = IsPlayer(Player)
	if Player == false then
		return false
	end
	MarketplaceService:PromptPremiumPurchase(Player)
end

-- End
function Lib:Init()
	if _G.M_Loader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name , "Lib Loaded & safe to use.")
	end
end

return Lib