hugs = {}

-- Register the /hug command
minetest.register_chatcommand("hug", {
	params = "<player>",
	description = "Hug another player",
	privs = {},
	func = function(name, param)
		-- Check if a player is specified
		if not param then
			return false, "Usage: /hug <player>"
		end

		-- Get the player object of the sender
		local sender = minetest.get_player_by_name(name)

		-- Check if the sender is online
		if not sender then
			return false, "Player not found or not online!"
		end

		-- Get the player object of the target
		local target = minetest.get_player_by_name(param)

		-- Check if the target is online
		if not target then
			return false, "Player not found or not online!"
		end

		-- Print in global chat that X player has hugged Y player
		minetest.chat_send_all(name.." has hugged "..param)

		-- Print to the target player that they have been hugged by the sender
		minetest.chat_send_player(param, "You have been hugged by "..name)

		-- Add more effects here i.e. particles or sounds

		return true, "You hugged "..param
	end,
})

