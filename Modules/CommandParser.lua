local CommandParser = {}
local PlayerHandler = require(script.Parent.PlayerLib)
local CommandHandler = require(script.Parent.CommandLib)

function CommandParser.ParseCommand(inputString, player)
	local commandData = {}
	local args = {}
	
	local prefix = PlayerHandler.GivePlayerData(player).Data.prefix
	

	if inputString:sub(1, #prefix) == prefix then
		inputString = inputString:sub(#prefix + 1)
	end

	-- Extract the first word (presumably the command) from the input string
	local firstWord = inputString:match("(%S+)")

	if firstWord then
		commandData.name = CommandHandler.FindCommandInString(firstWord).name

		
		inputString = inputString:gsub(firstWord, "", 1)

		-- Extract the arguments separated by commas
		for arg in inputString:gmatch("([^,]+)") do
			table.insert(args, arg:match("^%s*(.-)%s*$")) -- Trim whitespace from arguments
		end

		commandData.args = args
	end

	return commandData
end

return CommandParser
