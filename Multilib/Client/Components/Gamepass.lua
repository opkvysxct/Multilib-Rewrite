local MarketplaceService = game:GetService("MarketplaceService")
local Lib = {}

-- Core
function Lib:CheckPlayerGamepass(ID : number, Prompt : boolean, Func)
	local HasPass = false
	local success, message = pcall(function()
		HasPass = MarketplaceService:UserOwnsGamePassAsync(_G.M_Loader.Player.UserId, ID)
	end)
	if not success then
		warn("[Multilib-" .. script.Name .. "]", "Error checking gamepass ownership" , tostring(message))
		return false
	end
end

-- End

function Lib:Init()
	if _G.M_Loader.Comments then
		warn("[Multilib-" .. script.Name .. "]", script.Name , "Lib Loaded & safe to use.")
	end
end

return Lib