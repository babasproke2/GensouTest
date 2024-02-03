mcl_inventory = {}
local S = minetest.get_translator("mcl_inventory")

dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/creative.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/survival.lua")

--local mod_player = minetest.get_modpath("mcl_player")
--local mod_craftguide = minetest.get_modpath("mcl_craftguide")

---Returns a single itemstack in the given inventory to the main inventory, or drop it when there's no space left.
local function return_item(itemstack, dropper, pos, inv)
	if dropper:is_player() then
		-- Return to main inventory
		if inv:room_for_item("main", itemstack) then
			inv:add_item("main", itemstack)
		else
			-- Drop item on the ground
			local v = dropper:get_look_dir()
			local p = vector.offset(pos, 0, 1.2, 0)
			p.x = p.x + (math.random(1, 3) * 0.2)
			p.z = p.z + (math.random(1, 3) * 0.2)
			local obj = minetest.add_item(p, itemstack)
			if obj then
				v.x = v.x * 4
				v.y = v.y * 4 + 2
				v.z = v.z * 4
				obj:set_velocity(v)
				obj:get_luaentity()._insta_collect = false
			end
		end
	else
		-- Fallback for unexpected cases
		minetest.add_item(pos, itemstack)
	end
	return itemstack
end

---Return items in the given inventory list (name) to the main inventory, or drop them if there is no space left.
local function return_fields(player, name)
	local inv = player:get_inventory()

	local list = inv:get_list(name)
	if not list then return end
	for i, stack in ipairs(list) do
		return_item(stack, player, player:get_pos(), inv)
		stack:clear()
		inv:set_stack(name, i, stack)
	end
end

local function set_inventory(player, armor_change_only)
	if minetest.is_creative_enabled(player:get_player_name()) then
		if armor_change_only then
			-- Stay on survival inventory plage if only the armor has been changed
			mcl_inventory.set_creative_formspec(player, 0, 0, nil, nil, "inv")
		else
			mcl_inventory.set_creative_formspec(player, 0, 1)
		end
		return
	end

	player:set_inventory_formspec(mcl_inventory.build_survival_formspec(player))
end

-- Drop items in craft grid and reset inventory on closing
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.quit then
		return_fields(player, "craft")
		return_fields(player, "enchanting_lapis")
		return_fields(player, "enchanting_item")
		if not minetest.is_creative_enabled(player:get_player_name()) and (formname == "" or formname == "main") then
			set_inventory(player)
		end
	end
end)


function mcl_inventory.update_inventory_formspec(player)
	set_inventory(player)
end

-- Drop crafting grid items on leaving
minetest.register_on_leaveplayer(function(player)
	return_fields(player, "craft")
	return_fields(player, "enchanting_lapis")
	return_fields(player, "enchanting_item")
end)

minetest.register_on_joinplayer(function(player)
	--init inventory
	local inv = player:get_inventory()

	inv:set_width("main", 9)
	inv:set_size("main", 36)
	inv:set_size("offhand", 1)

	--set hotbar size
	player:hud_set_hotbar_itemcount(9)
	--add hotbar images
	player:hud_set_hotbar_image("mcl_inventory_hotbar.png")
	player:hud_set_hotbar_selected_image("mcl_inventory_hotbar_selected.png")

	-- In Creative Mode, the initial inventory setup is handled in creative.lua
	if not minetest.is_creative_enabled(player:get_player_name()) then
		set_inventory(player)
	end

	--[[ Make sure the crafting grid is empty. Why? Because the player might have
	items remaining in the crafting grid from the previous join; this is likely
	when the server has been shutdown and the server didn't clean up the player
	inventories. ]]
	return_fields(player, "craft")
	return_fields(player, "enchanting_item")
	return_fields(player, "enchanting_lapis")
end)

function mcl_inventory.update_inventory(player)
	local player_gamemode = player:get_meta():get_string("gamemode")
	if player_gamemode == "" then player_gamemode = "survival" end

	if player_gamemode == "creative" then
		mcl_inventory.set_creative_formspec(player)
	elseif player_gamemode == "survival" then
		player:set_inventory_formspec(mcl_inventory.build_survival_formspec(player))
	end
	mcl_meshhand.update_player(player)
end

mcl_player.register_on_visual_change(mcl_inventory.update_inventory_formspec)

local old_is_creative_enabled = minetest.is_creative_enabled

function minetest.is_creative_enabled(name)
	if old_is_creative_enabled(name) then return true end
	if not name then return false end
	assert(type(name) == "string", "minetest.is_creative_enabled requires a string (the playername) argument. This is likely an error in a non-mineclonia mod.")
	local p = minetest.get_player_by_name(name)
	if p then
		return p:get_meta():get_string("gamemode") == "creative"
	end
	return false
end

local gamemodes = {
	"survival",
	"creative"
}

function mcl_inventory.player_set_gamemode(p,g)
	local m = p:get_meta()
	m:set_string("gamemode",g)
	if g == "survival" then
		 mcl_experience.setup_hud(p)
		 mcl_experience.update(p)
	elseif g == "creative" then
		 mcl_experience.remove_hud(p)
	end
	mcl_meshhand.update_player(p)
	set_inventory(p)
end

minetest.register_chatcommand("gamemode",{
	params = S("[<gamemode>] [<player>]"),
	description = S("Change gamemode (survival/creative) for yourself or player"),
	privs = { server = true },
	func = function(n,param)
		-- Full input validation ( just for @erlehmann <3 )
		local p
		local args = param:split(" ")
		if args[2] ~= nil then
			p = minetest.get_player_by_name(args[2])
			n = args[2]
		else
			p = minetest.get_player_by_name(n)
		end
		if not p then
			return false, S("Player not online")
		end
		if args[1] ~= nil and table.indexof(gamemodes, args[1]) == -1 then
			return false, S("Gamemode @1 does not exist.", args[1])
		elseif args[1] ~= nil then
			mcl_inventory.player_set_gamemode(p,args[1])
		end

		--Result message - show effective game mode
		local gm = p:get_meta():get_string("gamemode")
		if gm == "" then gm = gamemodes[1] end
		return true, S("Gamemode for player @1: @2", n, gm)
	end
})
