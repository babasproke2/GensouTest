--MCmobs v0.4
--maikerumine
--made for MC like Survival game
--License for code WTFPL and otherwise stated in readmes

local trading_items = {
	{ itemstring = "mcl_core:obsidian", amount_min = 1, amount_max = 1 },
	{ itemstring = "mcl_core:gravel", amount_min = 8, amount_max = 16 },
	{ itemstring = "mcl_mobitems:leather", amount_min = 4, amount_max = 10 },
	{ itemstring = "mcl_nether:soul_sand", amount_min = 4, amount_max = 16 },
	{ itemstring = "mcl_nether:nether_brick", amount_min = 4, amount_max = 16 },
	{ itemstring = "mcl_mobitems:string", amount_min = 3, amount_max = 9 },
	{ itemstring = "mcl_nether:quartz", amount_min = 4, amount_max = 10 },
	{ itemstring = "mcl_potions:water", amount_min = 1, amount_max = 1 },
	{ itemstring = "mcl_core:iron_nugget", amount_min = 10, amount_max = 36 },
	{ itemstring = "mcl_throwing:ender_pearl", amount_min = 2, amount_max = 6 },
	{ itemstring = "mcl_potions:fire_resistance", amount_min = 1, amount_max = 1 },
	{ itemstring = "mcl_potions:fire_resistance_splash", amount_min = 1, amount_max = 1 },
}

local S = minetest.get_translator("mobs_mc")
local mod_bows = minetest.get_modpath("mcl_bows") ~= nil

function mobs_mc.player_wears_gold(player)
	for i=1, 6 do
		local stack = player:get_inventory():get_stack("armor", i)
		local item = stack:get_name()
		if minetest.get_item_group(item, "golden") ~= 0 then
			return true
		end
	end
end

local function check_light(pos, environmental_light, artificial_light, sky_light)
	if artificial_light > 11 then
		return false, "To bright"
	end
	return true, ""
end

--###################
--################### piglin
--###################
local piglin = {
	description = S("Piglin"),
	type = "monster",
	passive = false,
	spawn_class = "hostile",
	hp_min = 16,
	hp_max = 16,
	xp_min = 9,
	xp_max = 9,
	armor = {fleshy = 90},
	damage = 4,
	reach = 3,
	collisionbox = {-0.3, -0.01, -0.3, 0.3, 1.94, 0.3},
	visual = "mesh",
	mesh = "extra_mobs_piglin.b3d",
	spawn_in_group = 4,
	spawn_in_group_min = 2,
	textures = { {
		"extra_mobs_piglin.png",
		"mcl_bows_bow_2.png",
	} },
	visual_size = {x=1, y=1},
	sounds = {
		random = "mobs_mc_zombiepig_random",
		war_cry = "mobs_mc_zombiepig_war_cry",
		damage = "mobs_mc_zombiepig_hurt",
		death = "mobs_mc_zombiepig_death",
		distance = 16,
	},
	jump = true,
	makes_footstep_sound = true,
	walk_velocity = 1.4,
	run_velocity = 2.0, -- (was 2.8) hes fast and has bow, but slower compare to hoglin
	drops = {
		{name = "mcl_bows:crossbow",
		chance = 10,
		min = 1,
		max = 1,},
	},
	animation = {
		stand_speed = 30,
		walk_speed = 30,
		run_speed = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 440,
		run_end = 459,
	},
	fear_height = 4,
	view_range = 16,
	pick_up = {"mcl_core:gold_ingot"},
	on_spawn = function(self)
		self.weapon = self.base_texture[2]
		self.gold_items = 0
	end,
	do_custom = function(self)
		if mcl_worlds.pos_to_dimension(self.object:get_pos()) == "overworld" then
			mcl_util.replace_mob(self.object, "mobs_mc:zombified_piglin")
		elseif self.trading == true then
			self.state = "trading"
			self.object:set_bone_position("Arm_Right_Pitch_Control", vector.new(-3,5.785,0), vector.new(20,-20,18))
			self.object:set_bone_position("Head", vector.new(0,6.3,0), vector.new(-40,0,0))
			self.base_texture[2] = "default_gold_ingot.png"
			self.object:set_properties({textures = self.base_texture})
		else
			self.object:set_bone_position("Wield_Item", vector.new(.5,4.5,-1.6), vector.new(90,0,20))
			self.base_texture[2] = self.weapon
			self.object:set_properties({textures = self.base_texture})
			self.object:set_bone_position("Head", vector.new(0,6.3,0), vector.new(0,0,0))
			self.object:set_bone_position("Arm_Right_Pitch_Control", vector.new(-3,5.785,0), vector.new(0,0,0))
		end

		if self.state ~= "attack" then
			self._attacked_by_player = false
		elseif self.attack:is_player() and mobs_mc.player_wears_gold(self.attack) then
			if self._attacked_by_player == false then
				self.state = "stand"
			end
		end
	end,
	on_pick_up  = function(self, itementity)
		local item = itementity.itemstring:split(" ")[1]
		local it = ItemStack(itementity.itemstring)
		if item == "mcl_core:gold_ingot" and self.state ~= "attack" and self.gold_items and self.gold_items < 3 then
			it:take_item(1)
			self.state = "stand"
			self.object:set_animation({x=0,y=79})
			self.trading = true
			self.gold_items = self.gold_items + 1
			self.object:set_bone_position("Wield_Item", vector.new(-1.5,4.9,1.8), vector.new(135,0,90))
			minetest.after(5, function()
				self.gold_items = self.gold_items - 1
				if self.gold_items == 0 then
					self.trading = false
					self.state = "stand"
				end
				local c_pos = self.object:get_pos()
				if c_pos then
					self.what_traded = trading_items[math.random(#trading_items)]
					for x = 1, math.random(self.what_traded.amount_min, self.what_traded.amount_max) do
						local p = c_pos
						local nn=minetest.find_nodes_in_area_under_air(vector.offset(c_pos,-1,-1,-1),vector.offset(c_pos,1,1,1),{"group:solid"})
						if nn and #nn > 0 then
							p = vector.offset(nn[math.random(#nn)],0,1,0)
						end
						minetest.add_item(p, self.what_traded.itemstring)
					end
				end
			end)
		end
		return it
	end,
	do_punch = function(self, hitter)
		if hitter:is_player() then
			self._attacked_by_player = true
		end
	end,
	attack_type = "dogshoot",
	arrow = "mcl_bows:arrow_entity",
	shoot_arrow = function(self, pos, dir)
		if mod_bows then
			if self.attack then
				self.object:set_yaw(minetest.dir_to_yaw(vector.direction(self.object:get_pos(), self.attack:get_pos())))
			end
			-- 2-4 damage per arrow
			local dmg = math.max(4, math.random(2, 8))
			mcl_bows.shoot_arrow("mcl_bows:arrow", pos, dir, self.object:get_yaw(), self.object, nil, dmg)
		end
	end,
	shoot_interval = 2,
	shoot_offset = 1.5,
	dogshoot_switch = 1,
	dogshoot_count_max =1.8,
	attacks_monsters = true,
	attack_animals = true,
	specific_attack = { "player", "mobs_mc:hoglin" },
	check_light = check_light,
}

mcl_mobs.register_mob("mobs_mc:piglin", piglin)


mcl_mobs.register_mob("mobs_mc:sword_piglin",table.merge(piglin,{
	mesh = "extra_mobs_sword_piglin.b3d",
	textures = {"extra_mobs_piglin.png", "default_tool_goldsword.png"},
	on_spawn = function(self)
		self.gold_items = 0
		self.weapon = self.base_texture[2]
		self.object:set_bone_position("Wield_Item", vector.new(0,3.9,1.3), vector.new(90,0,0))
	end,
	drops = {
		{name = "mcl_tools:sword_gold",
		chance = 10,
		min = 1,
		max = 1,},
	},
	attack_type = "dogfight",
	animation = {
		stand_speed = 30,
		walk_speed = 30,
		punch_speed = 45,
		run_speed = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 440,
		run_end = 459,
		punch_start = 189,
		punch_end = 198,
	},
}))

mcl_mobs.register_mob("mobs_mc:zombified_piglin",table.merge(piglin,{
	description = S("Zombiefied Piglin"),
	-- type="animal", passive=false: This combination is needed for a neutral mob which becomes hostile, if attacked
	type = "animal",
	passive = false,
	spawn_class = "passive",
	do_custom = function() end,
	on_spawn = function() end,
	on_rightclick = function() end,
	attack_animals = true,
	prevents_sleep_when_hostile = true,
	mesh = "extra_mobs_sword_piglin.b3d",
	textures = {"extra_mobs_zombified_piglin.png", "default_tool_goldsword.png", "blank.png"},
	attack_type = "dogfight",
	animation = {
		stand_speed = 30,
		walk_speed = 30,
		punch_speed = 45,
		run_speed = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 440,
		run_end = 459,
		punch_start = 189,
		punch_end = 198,
	},
	hp_min = 20,
	hp_max = 20,
	xp_min = 6,
	xp_max = 6,
	armor = {undead = 90, fleshy = 90},
	group_attack = { "mobs_mc:zombified_piglin" },
	damage = 9,
	reach = 2,
	head_swivel = "head.control",
	bone_eye_height = 2.4,
	head_eye_height = 1.4,
	curiosity = 15,
	collisionbox = {-0.3, -0.01, -0.3, 0.3, 1.94, 0.3},
	jump = true,
	makes_footstep_sound = true,
	walk_velocity = .8,
	run_velocity = 2.6,
	pathfinding = 1,
	lava_damage = 0,
	fire_damage = 0,
	fear_height = 4,
	view_range = 16,
	harmed_by_heal = true,
	fire_damage_resistant = true,
	sounds = {
		random = "mobs_mc_zombiepig_random",
		war_cry = "mobs_mc_zombiepig_war_cry",
		death = "mobs_mc_zombiepig_death",
		damage = "mobs_mc_zombiepig_hurt",
		distance = 16,
	},
}))


mcl_mobs.register_mob("mobs_mc:piglin_brute",table.merge(piglin,{
	description = S("Piglin Brute"),
	xp_min = 20,
	xp_max = 20,
	hp_min = 50,
	hp_max = 50,
	fire_resistant = 1,
	do_custom = function() end,
	on_spawn = function() end,
	on_rightclick = function() end,
	attacks_monsters = true,
	lava_damage = 0,
	fire_damage = 0,
	attack_animals = true,
	mesh = "extra_mobs_sword_piglin.b3d",
	textures = { "extra_mobs_piglin_brute.png", "default_tool_goldaxe.png", "blank.png" },
	attack_type = "dogfight",
	animation = {
		stand_speed = 30,
		walk_speed = 30,
		punch_speed = 45,
		run_speed = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 440,
		run_end = 459,
		punch_start = 189,
		punch_end = 198,
	},
	can_despawn = false,
	group_attack = { "mobs_mc:piglin", "mobs_mc:sword_piglin", "mobs_mc:piglin_brute" },
	drops = {
		{name = "mcl_tools:axe_gold",
		chance = 8.5,
		min = 1,
		max = 1,},
	}
}))



mcl_mobs.spawn_setup({
	name = "mobs_mc:piglin",
	type_of_spawning = "ground",
	dimension = "nether",
	min_light = 0,
	max_light = minetest.LIGHT_MAX+1,
	min_height = mcl_vars.mg_lava_nether_max,
	aoc = 3,
	biomes = {
		"Nether",
		"CrimsonForest"
	},
	chance = 150,
})

mcl_mobs.spawn_setup({
	name = "mobs_mc:sword_piglin",
	type_of_spawning = "ground",
	dimension = "nether",
	min_light = 0,
	max_light = minetest.LIGHT_MAX+1,
	min_height = mcl_vars.mg_lava_nether_max,
	aoc = 3,
	biomes = {
		"Nether",
		"CrimsonForest"
	},
	chance = 150,
})

mcl_mobs.spawn_setup({
	name = "mobs_mc:zombified_piglin",
	type_of_spawning = "lava",
	dimension = "nether",
	min_light = 0,
	max_light = minetest.LIGHT_MAX+1,
	min_height = mcl_vars.mg_lava_nether_max,
	aoc = 4,
	biomes = {
		"Nether",
		"CrimsonForest"
	},
	chance = 1000,
})



-- spawn eggs
mcl_mobs.register_egg("mobs_mc:piglin", S("Piglin"), "#7b4a17","#d5c381", 0)
mcl_mobs.register_egg("mobs_mc:piglin_brute", S("Piglin Brute"), "#562b0c","#ddc89d", 0)
mcl_mobs.register_egg("mobs_mc:zombified_piglin", S("Zombie Piglin"), "#ea9393", "#4c7129", 0)
