local S = minetest.get_translator(minetest.get_current_modname())
local doc_mod = minetest.get_modpath("doc")
local extra_nodes = minetest.settings:get_bool("mcl_extra_nodes", true)

mcl_stairs.register_slab("lapisblock", {
	recipeitem="mcl_core:lapisblock",
	groups={pickaxey=3, not_in_creative_inventory=extra_nodes and 0 or 1},
	tiles={"mcl_core_lapis_block.png", "mcl_core_lapis_block.png", "mcl_stairs_lapis_block_slab.png"},
	description=S("Lapis Lazuli Slab"),
	double_description=S("Double Lapis Lazuli Slab"),
	register_craft=extra_nodes,
})
mcl_stairs.register_stair("lapisblock", {
	recipeitem="mcl_core:lapisblock",
	groups={pickaxey=3, not_in_creative_inventory=extra_nodes and 0 or 1},
	tiles={"mcl_stairs_lapis_block_slab.png", "mcl_core_lapis_block.png", "mcl_core_lapis_block.png", "mcl_core_lapis_block.png", "mcl_core_lapis_block.png", "mcl_stairs_lapis_block_slab.png"},
	description=S("Lapis Lazuli Stairs"),
	corner_stair_texture_override="woodlike",
	register_craft=extra_nodes,
})

mcl_stairs.register_slab("goldblock", {
	recipeitem="mcl_core:goldblock",
	groups={pickaxey=4, not_in_creative_inventory=extra_nodes and 0 or 1},
	tiles={"default_gold_block.png", "default_gold_block.png", "mcl_stairs_gold_block_slab.png"},
	description=S("Slab of Gold"),
	double_description=S("Double Slab of Gold"),
	register_craft=extra_nodes,
})
mcl_stairs.register_stair("goldblock", {
	recipeitem="mcl_core:goldblock",
	groups={pickaxey=4, not_in_creative_inventory=extra_nodes and 0 or 1},
	tiles={"mcl_stairs_gold_block_slab.png", "default_gold_block.png", "default_gold_block.png", "default_gold_block.png", "default_gold_block.png", "mcl_stairs_gold_block_slab.png"},
	description=S("Stairs of Gold"),
	corner_stair_texture_override="woodlike",
	register_craft=extra_nodes,
})

mcl_stairs.register_slab("ironblock", {
	recipeitem="mcl_core:ironblock",
	groups={pickaxey=2, not_in_creative_inventory=extra_nodes and 0 or 1},
	tiles={"default_steel_block.png", "default_steel_block.png", "mcl_stairs_iron_block_slab.png"},
	description=S("Slab of Iron"),
	double_description=S("Double Slab of Iron"),
	register_craft=extra_nodes,
})
mcl_stairs.register_stair("ironblock", {
	recipeitem="mcl_core:ironblock",
	groups={pickaxey=2, not_in_creative_inventory=extra_nodes and 0 or 1},
	tiles={"mcl_stairs_iron_block_slab.png", "default_steel_block.png", "default_steel_block.png", "default_steel_block.png", "default_steel_block.png", "mcl_stairs_iron_block_slab.png"},
	description=S("Stairs of Iron"),
	corner_stair_texture_override="woodlike",
	register_craft=extra_nodes,
})

mcl_stairs.register_stair("stonebrickcracked", {
	recipeitem="mcl_core:stonebrickcracked",
	groups={pickaxey=1, not_in_creative_inventory=extra_nodes and 0 or 1},
	tiles={"mcl_core_stonebrick_cracked.png"},
	description=S("Cracked Stone Brick Stairs"),
	corner_stair_texture_override="woodlike",
	register_craft=extra_nodes,
})
mcl_stairs.register_slab("stonebrickcracked", {
	recipeitem="mcl_core:stonebrickcracked",
	groups={pickaxey=1, not_in_creative_inventory=extra_nodes and 0 or 1},
	tiles={"mcl_core_stonebrick_cracked.png"},
	description=S("Cracked Stone Brick Slab"),
	double_description=S("Double Cracked Stone Brick Slab"),
	register_craft=extra_nodes,
})

local canonical_color = "yellow"
for name,cdef in pairs(mcl_dyes.colors) do
	local is_canonical = name == canonical_color
	mcl_stairs.register_stair_and_slab("concrete_"..name, {
		groups={pickaxey=1, not_in_creative_inventory=extra_nodes and 0 or 1},
		recipeitem="mcl_colorblocks:concrete_"..name,
		stair_description=S(cdef.readable_name.. " Concrete Stairs"),
		slab_description=S(cdef.readable_name.. " Concrete Slab"),
		double_description=S(cdef.readable_name.. " Double Slab"),
		register_craft=extra_nodes,
	})

	if doc_mod then
		if not is_canonical then
			doc.add_entry_alias("nodes", "mcl_stairs:slab_concrete_"..canonical_color, "nodes", "mcl_stairs:slab_concrete_"..name)
			doc.add_entry_alias("nodes", "mcl_stairs:slab_concrete_"..canonical_color.."_double", "nodes", "mcl_stairs:slab_concrete_"..name.."_double")
			doc.add_entry_alias("nodes", "mcl_stairs:stair_concrete_"..canonical_color, "nodes", "mcl_stairs:stair_concrete_"..name)
			minetest.override_item("mcl_stairs:slab_concrete_"..name, { _doc_items_create_entry = false })
			minetest.override_item("mcl_stairs:slab_concrete_"..name.."_double", { _doc_items_create_entry = false })
			minetest.override_item("mcl_stairs:stair_concrete_"..name, { _doc_items_create_entry = false })
		else
			minetest.override_item("mcl_stairs:slab_concrete_"..name, { _doc_items_entry_name = S("Concrete Slab") })
			minetest.override_item("mcl_stairs:slab_concrete_"..name.."_double", { _doc_items_entry_name = S("Double Concrete Slab") })
			minetest.override_item("mcl_stairs:stair_concrete_"..name, { _doc_items_entry_name = S("Concrete Stairs") })
		end
	end
end
