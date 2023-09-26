local CommandHandler = {}
local PlayerHandler = require(script.Parent.PlayerLib)


function printCommand(speaker, args)
	return print(table.concat(args, " "))
end

function killCommand(speaker, args)
	local target = PlayerHandler.FindPlayerByUsername(args[1]) or PlayerHandler.FindPlayerByDisplayName(args[1]) or error("Arguments not defined or player not reachable!")
	target.Character:BreakJoints()
end

function kickCommand(speaker, args)
	local target = PlayerHandler.FindPlayerByUsername(args[1]) or PlayerHandler.FindPlayerByDisplayName(args[1]) or error("Arguments not defined or player not reachable!")
	local reason = (#args > 2 and table.concat(table.remove(args, 1), " ")) or (#args == 2 and args[2]) or "N/A"
	target:Kick("You have been kicked by: "..speaker.Name.."!\nReason: "..reason)
end

-- Define a list of commands with their ranks and aliases
local commands = {
	{ name = "print", rank = 5, aliases = {"write", "output"}, callback = printCommand },
	{ name = "kill", rank = 2, aliases = {"end", "terminate"}, callback = killCommand },
	{ name = "kick", rank = 2, aliases = {"remove"}, callback = kickCommand },
}


function CommandHandler.GetAllCommands()
	return commands
end


function CommandHandler.HasPermission(player, commandName)
	local playerRank = PlayerHandler.GivePlayerData(player).Data.rank

		for _, command in ipairs(commands) do
		if command.name == commandName or table.find(command.aliases, commandName) then
			return playerRank >= command.rank
		end
	end

	-- If the command doesn't exist, consider it restricted
	return false
end

function CommandHandler.GetCommandDataByNameOrAlias(commandName)
	for _, command in ipairs(commands) do
		if command.name == commandName or table.find(command.aliases, commandName) then
			return command
		end
	end

	
	return nil
end

function CommandHandler.FindCommandInString(inputString)
	-- Extract the first word (presumably the command) from the input string
	local firstWord = inputString:match("(%S+)")

	if firstWord then
		local commandData = CommandHandler.GetCommandDataByNameOrAlias(firstWord)
		return commandData
	end


	return nil
end

return CommandHandler
