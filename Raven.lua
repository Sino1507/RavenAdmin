-- SERVICES
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local PathFindingService = game:GetService("PathfindingService")
local PhysicsService = game:GetService("PhysicsService")
local SoundService = game:GetService("SoundService")

-- MODULES
local PlayerHandler = require(script.Parent.Modules.PlayerLib)--[[
																	PlayerHandler Module:

																	This module provides essential functionality for managing player data and interactions in a Roblox game. It serves as a central hub for handling player-related tasks, including:

																	1. Creating and maintaining player entries in the PlayerData table.
																	2. Loading and saving player-specific data to/from a DataStore.
																	3. Managing player interactions and events within the game.
																--]]
local CommandHandler = require(script.Parent.Modules.CommandLib)--[[
																	CommandHandler Module:

																	Manages game commands, permissions, and data retrieval. Provides functions to check player permissions, retrieve command data, and list all available commands.
																--]]
local CommandParser = require(script.Parent.Modules.CommandParser)--[[
																	CommandParser Module:

																	Provides a function to parse commands and their arguments from a string. It can remove a specified prefix and return the command's name and arguments as a table.
																--]]

-- UTILITY VARIABLES
local gameCreatorId = game.CreatorId

-- UTILITY FUNCTIONS
function CommandAndPermission(name, parsed, player)
	-- Retrieve command data and player data, to check for correct permission
	local CommandData = CommandHandler.FindCommandInString(parsed.name)
	local PlayerData = PlayerHandler.GivePlayerData(player).Data
	
	if CommandData.rank <= PlayerData.rank and CommandData.name == name then 
		return true
	end
	
	return false
end

game.Players.PlayerAdded:Connect(function(Player)
	-- Load default data or saved data
	local Data = PlayerHandler.LoadPlayer(Player)
	
	if Data.ban.banned then 
		local reason = Data.ban.reason
		Player:Kick("\t--BANNED--\t\n\tYou were banned from this experience! Reason:\n\t"..reason)
	end
	
	-- Overwrite player rank, when he matches the creator-ID
	Data.rank = (Player.UserId == gameCreatorId) and 5 or Data.rank
	
	-- Create new player class with provided data
	PlayerHandler.NewPlayer(Player, Data)
	
	Player.Chatted:Connect(function(msg)
		local ParsedData = CommandParser.ParseCommand(msg, Player)

		if CommandAndPermission("print", ParsedData, Player) then 
			print(table.concat(ParsedData.args, " "))
		end
	end)
end)