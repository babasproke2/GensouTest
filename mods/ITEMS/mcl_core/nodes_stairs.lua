local S = minetest.get_translator(minetest.get_current_modname())
mcl_stairs.register_stair_and_slab_simple("stone_rough", "mcl_core:stone", S("Stone Stairs"), S("Stone Slab"), S("Double Stone Slab"),nil, {_mcl_stonecutter_recipes = { "mcl_core:stone" }}, {_mcl_stonecutter_recipes = { "mcl_core:stone" }})

mcl_stairs.register_slab("stone", "mcl_core:stone_smooth",
		{pickaxey=1, material_stone=1},
		{"mcl_stairs_stone_slab_top.png", "mcl_stairs_stone_slab_top.png", "mcl_stairs_stone_slab_side.png"},
		S("Polished Stone Slab"),
		mcl_sounds.node_sound_stone_defaults(), 6, 2,
		S("Double Polished Stone Slab"),
		{_mcl_stonecutter_recipes = { "mcl_core:stone_smooth" }})

mcl_stairs.register_stair_and_slab_simple("andesite", "mcl_core:andesite", S("Andesite Stairs"), S("Andesite Slab"), S("Double Andesite Slab"),nil,{_mcl_stonecutter_recipes = { "mcl_core:andesite" }}, {_mcl_stonecutter_recipes = { "mcl_core:andesite" }})
mcl_stairs.register_stair_and_slab_simple("granite", "mcl_core:granite", S("Granite Stairs"), S("Granite Slab"), S("Double Granite Slab"),nil,{_mcl_stonecutter_recipes = { "mcl_core:granite" }}, {_mcl_stonecutter_recipes = { "mcl_core:granite" }})
mcl_stairs.register_stair_and_slab_simple("diorite", "mcl_core:diorite", S("Diorite Stairs"), S("Diorite Slab"), S("Double Diorite Slab"),nil,{_mcl_stonecutter_recipes = { "mcl_core:diorite" }}, {_mcl_stonecutter_recipes = { "mcl_core:diorite" }})

mcl_stairs.register_stair_and_slab_simple("cobble", "mcl_core:cobble", S("Cobblestone Stairs"), S("Cobblestone Slab"), S("Double Cobblestone Slab"),nil,{_mcl_stonecutter_recipes = { "mcl_core:cobble" }}, {_mcl_stonecutter_recipes = { "mcl_core:cobble" }})
mcl_stairs.register_stair_and_slab_simple("mossycobble", "mcl_core:mossycobble", S("Mossy Cobblestone Stairs"), S("Mossy Cobblestone Slab"), S("Double Mossy Cobblestone Slab"),nil,{_mcl_stonecutter_recipes = { "mcl_core:mossycobble" }}, {_mcl_stonecutter_recipes = { "mcl_core:mossycobble" }})

mcl_stairs.register_stair_and_slab_simple("brick_block", "mcl_core:brick_block", S("Brick Stairs"), S("Brick Slab"), S("Double Brick Slab"),nil,{_mcl_stonecutter_recipes = { "mcl_core:brick_block" }}, {_mcl_stonecutter_recipes = { "mcl_core:brick_block" }})


mcl_stairs.register_stair("sandstone", "mcl_core:normal_sandstone",
		{pickaxey=1, material_stone=1},
		{"mcl_core_sandstone_top.png", "mcl_core_sandstone_bottom.png", "mcl_core_sandstone_normal.png"},
		S("Sandstone Stairs"),
		mcl_sounds.node_sound_stone_defaults(),	0.8, 0.8,
		nil, { _mcl_stonecutter_recipes ={ "mcl_core:sandstone" }})
mcl_stairs.register_slab("sandstone", "group:normal_sandstone",
		{pickaxey=1, material_stone=1},
		{"mcl_core_sandstone_top.png", "mcl_core_sandstone_bottom.png", "mcl_core_sandstone_normal.png"},
		S("Sandstone Slab"),
		mcl_sounds.node_sound_stone_defaults(),	6, 2,
		S("Double Sandstone Slab"), {_mcl_stonecutter_recipes = {"mcl_core:sandstone"}})

mcl_stairs.register_stair_and_slab_simple("sandstonesmooth2", "mcl_core:sandstonesmooth2", S("Smooth Sandstone Stairs"), S("Smooth Sandstone Slab"), S("Double Smooth Sandstone Slab"), {_mcl_stonecutter_recipes = {"mcl_core:sandstone"}}, {_mcl_stonecutter_recipes = {"mcl_core:sandstone"}})
mcl_stairs.register_stair_and_slab_simple("sandstonesmooth", "mcl_core:sandstonesmooth", nil, S("Cut Sandstone Slab"), S("Double Cut Sandstone Slab"), {_mcl_stonecutter_recipes = {"mcl_core:sandstone"}}, {_mcl_stonecutter_recipes = {"mcl_core:sandstone","mcl_core:sandstonesmooth2"}})

mcl_stairs.register_stair("redsandstone", "mcl_core:red_sandstone",
		{pickaxey=1, material_stone=1},
		{"mcl_core_red_sandstone_top.png", "mcl_core_red_sandstone_bottom.png", "mcl_core_red_sandstone_normal.png"},
		S("Red Sandstone Stairs"),
		mcl_sounds.node_sound_stone_defaults(), 0.8, 0.8,
		nil, {_mcl_stonecutter_recipes = {"mcl_core:redsandstone"}})
mcl_stairs.register_slab("redsandstone", "group:red_sandstone",
		{pickaxey=1, material_stone=1},
		{"mcl_core_red_sandstone_top.png", "mcl_core_red_sandstone_bottom.png", "mcl_core_red_sandstone_normal.png"},
		S("Red Sandstone Slab"),
		mcl_sounds.node_sound_stone_defaults(), 6, 2,
		S("Double Red Sandstone Slab"), {_mcl_stonecutter_recipes={"mcl_core:redsandstone"}})
mcl_stairs.register_stair_and_slab_simple("redsandstonesmooth2", "mcl_core:redsandstonesmooth2", S("Smooth Red Sandstone Stairs"), S("Smooth Red Sandstone Slab"), S("Double Smooth Red Sandstone Slab"), {_mcl_stonecutter_recipes = {"mcl_core:redsandstone"}}, {_mcl_stonecutter_recipes = {"mcl_core:redsandstone"}})
mcl_stairs.register_stair_and_slab_simple("redsandstonesmooth", "mcl_core:redsandstonesmooth", nil, S("Cut Red Sandstone Slab"), S("Double Cut Red Sandstone Slab"), {_mcl_stonecutter_recipes = {"mcl_core:redsandstone"}}, {_mcl_stonecutter_recipes = {"mcl_core:redsandstone","mcl_core:redsandstonesmooth2"}})

-- Intentionally not group:stonebrick because of mclx_stairs
mcl_stairs.register_stair("stonebrick", "mcl_core:stonebrick",
		{pickaxey=1, material_stone=1},
		{"default_stone_brick.png"},
		S("Stone Bricks Stairs"),
		mcl_sounds.node_sound_stone_defaults(), 6, 1.5,
		nil, {_mcl_stonecutter_recipes = { "mcl_core:stone", "mcl_core:stonebrick" }})
mcl_stairs.register_slab("stonebrick", "mcl_core:stonebrick",
		{pickaxey=1, material_stone=1},
		{"default_stone_brick.png"},
		S("Stone Bricks Slab"),
		mcl_sounds.node_sound_stone_defaults(), 6, 2,
		S("Double Stone Bricks Slab"), {_mcl_stonecutter_recipes = { "mcl_core:stone", "mcl_core:stonebrick" }})

mcl_stairs.register_slab("andesite_smooth", "mcl_core:andesite_smooth",
		{pickaxey=1},
		{"mcl_core_andesite_smooth.png", "mcl_core_andesite_smooth.png", "mcl_stairs_andesite_smooth_slab.png"},
		S("Polished Andesite Slab"),
		nil, 6, nil,
		S("Double Polished Andesite Slab"),
		{_mcl_stonecutter_recipes = { "mcl_core:andesite_smooth", "mcl_core:andesite" }})
mcl_stairs.register_stair("andesite_smooth", "mcl_core:andesite_smooth",
		{pickaxey=1},
		{"mcl_stairs_andesite_smooth_slab.png", "mcl_core_andesite_smooth.png", "mcl_core_andesite_smooth.png", "mcl_core_andesite_smooth.png", "mcl_core_andesite_smooth.png", "mcl_stairs_andesite_smooth_slab.png"},
		S("Polished Andesite Stairs"),
		nil, 6, nil,
		"woodlike",
		{_mcl_stonecutter_recipes = { "mcl_core:andesite_smooth", "mcl_core:andesite" }})

mcl_stairs.register_slab("granite_smooth", "mcl_core:granite_smooth",
		{pickaxey=1},
		{"mcl_core_granite_smooth.png", "mcl_core_granite_smooth.png", "mcl_stairs_granite_smooth_slab.png"},
		S("Polished Granite Slab"),
		nil, 6, nil,
		S("Double Polished Granite Slab"),
		{_mcl_stonecutter_recipes = { "mcl_core:granite_smooth", "mcl_core:granite" }})
mcl_stairs.register_stair("granite_smooth", "mcl_core:granite_smooth",
		{pickaxey=1},
		{"mcl_stairs_granite_smooth_slab.png", "mcl_core_granite_smooth.png", "mcl_core_granite_smooth.png", "mcl_core_granite_smooth.png", "mcl_core_granite_smooth.png", "mcl_stairs_granite_smooth_slab.png"},
		S("Polished Granite Stairs"),
		nil, 6, nil,
		"woodlike",
		{_mcl_stonecutter_recipes = { "mcl_core:granite_smooth", "mcl_core:granite" }})

mcl_stairs.register_slab("diorite_smooth", "mcl_core:diorite_smooth",
		{pickaxey=1},
		{"mcl_core_diorite_smooth.png", "mcl_core_diorite_smooth.png", "mcl_stairs_diorite_smooth_slab.png"},
		S("Polished Diorite Slab"),
		nil, 6, nil,
		S("Double Polished Diorite Slab"),
		{_mcl_stonecutter_recipes = { "mcl_core:diorite_smooth", "mcl_core:diorite" }})
mcl_stairs.register_stair("diorite_smooth", "mcl_core:diorite_smooth",
		{pickaxey=1},
		{"mcl_stairs_diorite_smooth_slab.png", "mcl_core_diorite_smooth.png", "mcl_core_diorite_smooth.png", "mcl_core_diorite_smooth.png", "mcl_core_diorite_smooth.png", "mcl_stairs_diorite_smooth_slab.png"},
		S("Polished Diorite Stairs"),
		nil, 6, nil,
		"woodlike",
		{_mcl_stonecutter_recipes = { "mcl_core:diorite_smooth", "mcl_core:diorite" }})

mcl_stairs.register_stair("stonebrickmossy", "mcl_core:stonebrickmossy",
		{pickaxey=1},
		{"mcl_core_stonebrick_mossy.png"},
		S("Mossy Stone Brick Stairs"),
		mcl_sounds.node_sound_stone_defaults(), 6, 1.5,
		nil,
		{ _mcl_stonecutter_recipes = { "mcl_core:stonebrickmossy" }})

mcl_stairs.register_slab("stonebrickmossy", "mcl_core:stonebrickmossy",
		{pickaxey=1},
		{"mcl_core_stonebrick_mossy.png"},
		S("Mossy Stone Brick Slab"),
		mcl_sounds.node_sound_stone_defaults(), 6, 2,
		S("Double Mossy Stone Brick Slab"), {_mcl_stonecutter_recipes = {"mcl_core:stonebrickmossy"}})


