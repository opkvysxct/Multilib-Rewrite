local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RecipeProcessor = {}
RecipeProcessor.__index = RecipeProcessor

function RecipeProcessor:new()
	local self = setmetatable({}, RecipeProcessor)
	self.Producs = {}
	return self
end

function RecipeProcessor:AddListener(ID : number, FuncAfter : any)
	self.Producs[ID] = FuncAfter
end

function RecipeProcessor:Process(receiptInfo)	
	local userId = receiptInfo.PlayerId
	local productId = receiptInfo.ProductId

	local player = Players:GetPlayerByUserId(userId)
	if player then
		local handler = self.Producs[productId]
		local success, result = pcall(handler, receiptInfo, player)
		if success then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to process receipt:", receiptInfo, result)
		end
	end
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

function RecipeProcessor:Run()
	MarketplaceService.ProcessReceipt = self.Process
end

return RecipeProcessor
