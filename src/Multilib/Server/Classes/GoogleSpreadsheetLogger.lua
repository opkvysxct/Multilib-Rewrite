local HttpService = game:GetService("HttpService")
local Logger = require(script.Parent.Parent.Parent.Shared.Components.Logger)
local GoogleSpreadsheetLogger = {}
GoogleSpreadsheetLogger.__index = GoogleSpreadsheetLogger

GoogleSpreadsheetLogger.Types = {
	["Short_anwser"] = "Short_anwser",
	["Single_choice"] = "Single_choice",
	["Multi_choice"] = "Multi_choice",
}

--[=[
	@class GoogleSpreadsheetLogger Class
	GoogleSpreadsheetLogger Class.
]=]

--[=[
	@within GoogleSpreadsheetLogger Class
	@return <GoogleSpreadsheetLogger>
	Creates GoogleSpreadsheetLogger Class.
]=]

function GoogleSpreadsheetLogger.new(formKey: string, shouldLog: boolean?)
	local self = setmetatable({}, GoogleSpreadsheetLogger)
	self.FormKey = formKey
	self.ShouldLog = shouldLog or false
	self.Options = {}
	self._Url = "https://docs.google.com/forms/d/e/" .. self.FormKey .. "/formResponse?usp=pp_url"
	return self
end

--[=[
	@within GoogleSpreadsheetLogger Class
	Adds new option to GoogleSpreadsheetLogger Class.
]=]

function GoogleSpreadsheetLogger:AddNewOption(optionAlias: string, optionKey: number, optionType: string, optionAnwers: {}?) -- options are pretty much static so no delete function is implemented
	self.Options[optionAlias] = {
		OptionKey = optionKey,
		OptionType = optionType,
		OptionAnwers = optionAnwers or "ANY"
	}
end

--[=[
	@within GoogleSpreadsheetLogger Class
	@private
	Connects url strings.
]=]

function GoogleSpreadsheetLogger:_ConnectURL(url: string, toConnect: string)
	return url .. "&entry." .. toConnect
end

--[=[
	@within GoogleSpreadsheetLogger Class
	Logs things to Google Spreadsheet.
]=]

function GoogleSpreadsheetLogger:Log(toSend: {})
	local finalURL = self._Url
	for _, option in toSend do
		local optionData = self.Options[option.OptionAlias]
		if optionData.OptionType == self.Types.Short_anwser then
			finalURL = self:_ConnectURL(
				finalURL,
				optionData.OptionKey .. "=" .. option.OptionAnwser
			)
		elseif optionData.OptionType == self.Types.Single_choice then
			if table.find(optionData.OptionAnwers,option.OptionAnwser) then
				finalURL = self:_ConnectURL(
					finalURL,
					optionData.OptionKey .. "=" .. option.OptionAnwser
				)
			else
				Logger:Warn(script, "No such option as: " .. option.OptionAnwser .. " in: " .. option.OptionAlias)
			end
		elseif optionData.OptionType == self.Types.Multi_choice then
			for _, optionAnwser in option.OptionAnwser do
				if table.find(optionData.OptionAnwers,optionAnwser) then
					finalURL = self:_ConnectURL(
						finalURL,
						optionData.OptionKey .. "=" .. optionAnwser
					)
				else
					Logger:Warn(script, "No such option as: " .. optionAnwser .. " in: " .. option.OptionAlias)
				end
			end
		end
	end
	local succes, errorMessage = pcall(function()
		HttpService:PostAsync(finalURL, "")
	end)
	if succes then
		if self.ShouldLog then
			for _, option in toSend do
				if self.Options[option.OptionAlias].OptionType == self.Types.Multi_choice then
					local anwser = ""
					for _, optionAnwser in option.OptionAnwser do
						anwser = anwser .. optionAnwser .. " "
					end
					Logger:Print(script,"LOGGED OPTION: " .. option.OptionAlias .. " | WITH ANWSER: " .. anwser)
				else
					Logger:Print(script,"LOGGED OPTION: " .. option.OptionAlias .. " | WITH ANWSER: " .. option.OptionAnwser)
				end
			end
		end
	else
		Logger:Warn(script, errorMessage)
	end
end

--[=[
	@within GoogleSpreadsheetLogger Class
	Destroys the GoogleSpreadsheetLogger Class.
]=]

function GoogleSpreadsheetLogger:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return GoogleSpreadsheetLogger
