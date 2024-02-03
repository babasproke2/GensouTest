local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_privilege("maphack", {
	description = S("Can place and use advanced blocks like mob spawners, command blocks and barriers."),
})

for _, action in pairs({"grant", "revoke"}) do
	minetest["register_on_priv_" .. action](function(name, _, priv)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end

		local meta = player:get_meta()

		--[[
			so e.g. hackers who have been revoked of the interact privilege
			will not automatically get the interact privilege through the mcl shields code back
		]]
		if priv == "interact" then
			if action == "revoke" then
				meta:set_int("mcl_privs:interact_revoked", 1)
			else
				meta:set_int("mcl_privs:interact_revoked", 0)
			end
		end
	end)
end
