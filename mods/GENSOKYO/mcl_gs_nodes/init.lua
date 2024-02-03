minetest.register_node("mcl_gs_nodes:donation_box", {
	paramtype2 = "facedir",
	drawtype = "nodebox",
	is_ground_content = false,
	sounds = mcl_sounds.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4063, 0.3750, -0.4375, -0.3438, 0.4375, 0.4375},
			{-0.2188, 0.3750, -0.4375, -0.1563, 0.4375, 0.4375},
			{-0.03125, 0.3750, -0.4375, 0.03125, 0.4375, 0.4375},
			{0.1563, 0.3750, -0.4375, 0.2188, 0.4375, 0.4375},
			{0.3438, 0.3750, -0.4375, 0.4063, 0.4375, 0.4375},
			{-0.5000, -0.4375, -0.5000, 0.5000, 0.5000, -0.4375},
			{-0.5000, -0.4375, -0.4375, -0.4375, 0.5000, 0.4375},
			{-0.5000, -0.5000, -0.5000, 0.5000, -0.4375, 0.5000},
			{0.4375, -0.5000, -0.4375, 0.5000, 0.5000, 0.5000},
			{-0.5000, -0.4375, 0.4375, 0.4375, 0.5000, 0.5000}
		}
	},
    description = "Donation Box",
    tiles = {
      "default_wood.png",
      "default_wood.png",
      "donation_box_side.png",
      "donation_box_side.png",
      "donation_box_side.png",
      "donation_box_front.png",
    },
	groups = { handy = 1, axey = 1, deco_block = 1, material_wood = 1, flammable = -1 },
	selection_box = 0.9,
 	_mcl_blast_resistance = 2.5,
	_mcl_hardness = 2.5,

})
