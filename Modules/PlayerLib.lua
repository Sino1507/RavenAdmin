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

return PlayerHandler
