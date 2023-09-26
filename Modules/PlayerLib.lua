local PlayerHandler = {}
local PlayerData = {} -- Using a regular table for simplicity

local DataStoreService = game:GetService("DataStoreService")
local RavenAdminDataStore = DataStoreService:GetDataStore("RavenAdmin")

-- Function to create a new player entry in PlayerData
function PlayerHandler.NewPlayer(player, playerData)
	local playerId = player.UserId
	local newPlayerEntry = {
		PlayerInstance = player,
		Data = playerData -- Attach the playerData to the player entry
		-- Add more properties as needed
	}
	PlayerData[playerId] = newPlayerEntry
end

function PlayerHandler.LoadPlayer(player)
	local playerId = player.UserId

	-- Define the scopes to load
	local scopesToLoad = {"rank", "ban", "timeout", "warning", "prefix"}

	-- Create a table to store the loaded data
	local playerData = {}
	
	local defaultValues = {
		rank = 0,
		ban = {banned = false, reason = ""},
		timeout = {time = 0, reason = ""},
		warning = {warnings = 0},
		prefix = ";"
	}

	-- Attempt to load data from the DataStore for each scope
	for _, scope in pairs(scopesToLoad) do
		local success, result = pcall(function()
			return RavenAdminDataStore:GetAsync(tostring(playerId) .. "_" .. scope)
		end)

		if success and result then
			playerData[scope] = result
		else
			playerData[scope] = defaultValues[scope]
		end
	end
	
	return playerData
end

function PlayerHandler.GivePlayerData(player)
	return PlayerData[player.UserId]
end

function PlayerHandler.FindPlayerByUsername(partialUsername)
	partialUsername = partialUsername:lower() -- Convert to lowercase for case-insensitive search
	local closestMatch = nil
	local closestMatchLengthDiff = math.huge
	
	-- Check if the partialName is contained within the lowercase name
	for _, player in pairs(game.Players:GetPlayers()) do
		local username = player.Name:lower() 

		
		local startIndex, endIndex = string.find(username, partialUsername)
		if startIndex and endIndex then
			local lengthDiff = math.abs(endIndex - startIndex - #partialUsername)
			if lengthDiff < closestMatchLengthDiff then
				closestMatch = player
				closestMatchLengthDiff = lengthDiff
			end
		end
	end

	return closestMatch
end

function PlayerHandler.FindPlayerByDisplayName(partialDisplayName)
	partialDisplayName = partialDisplayName:lower() -- Convert to lowercase for case-insensitive search
	local closestMatch = nil
	local closestMatchLengthDiff = math.huge

	for _, player in pairs(game.Players:GetPlayers()) do
		local displayName = player.DisplayName:lower() 

		-- Check if the partialDisplayName is contained within the lowercase display name
		local startIndex, endIndex = string.find(displayName, partialDisplayName)
		if startIndex and endIndex then
			local lengthDiff = math.abs(endIndex - startIndex - #partialDisplayName)
			if lengthDiff < closestMatchLengthDiff then
				closestMatch = player
				closestMatchLengthDiff = lengthDiff
			end
		end
	end

	return closestMatch
end


return PlayerHandler
