local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RecipeProcessor = {}
RecipeProcessor.__index = RecipeProcessor

--[=[
	@class ReceiptProcessor Class
	ReceiptProcessor Class.
]=]

--[=[
	@within ReceiptProcessor Class	
	@return <ReceiptProcessorClass>
	Creates ReceiptProcessor Class.
]=]

function RecipeProcessor.new()
	local self = setmetatable({}, RecipeProcessor)
	self.Producs = {}
	self:_Run()
	return self
end

--[=[
	@within ReceiptProcessor Class	
	Adds listener and a function connected to it.
]=]

function RecipeProcessor:AddListener(id: number, funcAfter: any)
	self.Producs[id] = funcAfter
end

--[=[
	@within ReceiptProcessor Class	
	@private
	Runs the class logic.
]=]

function RecipeProcessor:_Run()
	MarketplaceService.ProcessReceipt = function(receiptInfo)
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

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player: Player, gamepassID: number, wasPurchased : boolean)
		warn(player,gamepassID,wasPurchased)
		if wasPurchased == true then
			local handler = self.Producs[gamepassID]
			local success, result = pcall(handler, gamepassID, player)
			if success then
				warn("Purchase Granted")
			else
				warn("Failed to process receipt:", gamepassID, result)
			end
		end
	end)
end

--[=[
	@within ReceiptProcessor Class	
	Destroys ReceiptProcessor Class.
]=]

function RecipeProcessor:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return RecipeProcessor
