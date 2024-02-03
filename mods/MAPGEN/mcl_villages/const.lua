local water_villages = minetest.settings:get_bool("mcl_villages_allow_water_villages", false)

-- switch for debugging
function mcl_villages.debug(message)
	minetest.log("verbose", "[mcl_villages] "..message)
end

mcl_villages.surface_mat = {}

function mcl_villages.grundstellungen()
	mcl_villages.surface_mat = mcl_villages.Set {
		"mcl_core:dirt_with_grass",
		--"mcl_core:dry_dirt_with_grass",
		"mcl_core:dirt_with_grass_snow",
		--"mcl_core:dirt_with_dry_grass",
		"mcl_core:podzol",
		"mcl_core:sand",
		"mcl_core:redsand",
		--"mcl_core:silver_sand",
		"mcl_core:snow"
	}

	-- allow villages on more surfaces
	mcl_villages.surface_mat["mcl_colorblocks:hardened_clay"] = true
	mcl_villages.surface_mat["mcl_colorblocks:hardened_clay_orange"] = true
	mcl_villages.surface_mat["mcl_colorblocks:hardened_clay_red"] = true
	mcl_villages.surface_mat["mcl_colorblocks:hardened_clay_white"] = true
	mcl_villages.surface_mat["mcl_core:andesite"] = true
	mcl_villages.surface_mat["mcl_core:coarse_dirt"] = true
	mcl_villages.surface_mat["mcl_core:diorite"] = true
	mcl_villages.surface_mat["mcl_core:dirt"] = true
	mcl_villages.surface_mat["mcl_core:granite"] = true
	mcl_villages.surface_mat["mcl_core:grass_path"] = true
	mcl_villages.surface_mat["mcl_core:sandstone"] = true
	mcl_villages.surface_mat["mcl_core:sandstonesmooth"] = true
	mcl_villages.surface_mat["mcl_core:sandstonesmooth2"] = true
	mcl_villages.surface_mat["mcl_core:stone"] = true
	mcl_villages.surface_mat["mcl_core:stone_with_coal"] = true
	mcl_villages.surface_mat["mcl_core:stone_with_iron"] = true

	if water_villages then
		mcl_villages.surface_mat["mcl_core:water_source"] = true
		mcl_villages.surface_mat["mcl_core:river_water_source"] = true
		mcl_villages.surface_mat["mcl_core:water_flowing"] = true
		mcl_villages.surface_mat["mcl_core:river_water_flowing"] = true
	end
end

--
-- possible surfaces where buildings can be built
--

--
-- path to schematics
--
schem_path = mcl_villages.modpath.."/schematics/"

--
-- list of schematics
--
local basic_pseudobiome_villages = minetest.settings:get_bool("basic_pseudobiome_villages", true)

mcl_villages.schematic_table = {
	{name = "large_house",	mts = schem_path.."large_house.mts",	hwidth = 11, hdepth = 12, hheight =  9, hsize = 14, max_num = 0.08 , rplc = basic_pseudobiome_villages },
	{name = "blacksmith",	mts = schem_path.."blacksmith.mts",	hwidth =	7, hdepth =  7, hheight = 13, hsize = 13, max_num = 0.055, rplc = basic_pseudobiome_villages },
	{name = "butcher",	mts = schem_path.."butcher.mts",	hwidth = 11, hdepth =  8, hheight = 10, hsize = 14, max_num = 0.03 , rplc = basic_pseudobiome_villages },
	{name = "church",	mts = schem_path.."church.mts",		hwidth = 13, hdepth = 13, hheight = 14, hsize = 15, max_num = 0.04 , rplc = basic_pseudobiome_villages },
	{name = "farm",		mts = schem_path.."farm.mts",		hwidth =	7, hdepth =  7, hheight = 13, hsize = 13, max_num = 0.1  , rplc = basic_pseudobiome_villages },
	{name = "lamp",		mts = schem_path.."lamp.mts",		hwidth =	3, hdepth =  3, hheight = 13, hsize = 10, max_num = 0.1  , rplc = false											 },
	{name = "library",	mts = schem_path.."library.mts",	hwidth = 12, hdepth = 12, hheight =  8, hsize = 13, max_num = 0.04 , rplc = basic_pseudobiome_villages },
	{name = "medium_house",	mts = schem_path.."medium_house.mts",	hwidth =	8, hdepth = 12, hheight =  8, hsize = 14, max_num = 0.08 , rplc = basic_pseudobiome_villages },
	{name = "small_house",	mts = schem_path.."small_house.mts",	hwidth =	9, hdepth =  7, hheight =  8, hsize = 13, max_num = 0.7  , rplc = basic_pseudobiome_villages },
	{name = "tavern",	mts = schem_path.."tavern.mts",		hwidth = 11, hdepth = 10, hheight = 10, hsize = 13, max_num = 0.050, rplc = basic_pseudobiome_villages },
	{name = "well",		mts = schem_path.."well.mts",		hwidth =	6, hdepth =  8, hheight =  6, hsize = 10, max_num = 0.045, rplc = basic_pseudobiome_villages },
}

--
-- maximum allowed difference in height for building a sttlement
--
mcl_villages.max_height_difference = 56
mcl_villages.half_map_chunk_size = 40

--
-- Biome based block substitutions
--
-- TODO maybe this should be in the biomes?
mcl_villages.biome_map = {
	BambooJungle = "bamboo",
	BambooJungleEdge = "bamboo",
	BambooJungleEdgeM = "bamboo",
	BambooJungleM = "bamboo",

	Jungle = "jungle",
	JungleEdge = "jungle",
	JungleEdgeM = "jungle",
	JungleM = "jungle",

	Desert = "desert",

	Savanna = "acacia",
	SavannaM = "acacia",

	Mesa = "hardened_clay",
	MesaBryce = "hardened_clay ",
	MesaPlateauF = "hardened_clay",
	MesaPlateauFM = "hardened_clay",

	MangroveSwamp = "mangrove",

	RoofedForest = "dark_oak",

	BirchForest = "birch",
	BirchForestM = "birch",

	ColdTaiga = "spruce",
	ExtremeHills = "spruce",
	ExtremeHillsM = "spruce",
	IcePlains = "spruce",
	IcePlainsSpikes = "spruce",
	MegaSpruceTaiga = "spruce",
	MegaTaiga = "spruce",
	Taiga = "spruce",
	["ExtremeHills+"] = "spruce",

	CherryGrove = "cherry",

	-- no change
	--FlowerForest = "oak",
	--Forest = "oak",
	--MushroomIsland = "",
	--Plains = "oak",
	--StoneBeach = "",
	--SunflowerPlains = "oak",
	--Swampland = "oak",
}

-- TODO should we handle stripped bark and the like?
-- TODO Should we have an API for this?
mcl_villages.material_substitions = {
	desert = {
		{ "mcl_core:tree", "mcl_core:redsandstonecarved" },
		{ '"mcl_fences:fence([^"]*)"', '"mcl_fences:birch_fence%1"' },
		{
			'"mesecons_pressureplates:pressure_plate_wood_([^"]+)"',
			'"mesecons_pressureplates:pressure_plate_birchwood_%1"',
		},
		{ '"mcl_doors:trapdoor([^"]*)"', '"mcl_doors:birch_trapdoor%1"' },

		{ "mcl_core:wood", "mcl_core:sandstonesmooth" },
		{ '"mcl_stairs:slab_wood([^"]*)"', '"mcl_stairs:slab_sandstonesmooth2%1"' },
		{ '"mcl_stairs:stair_wood([^"]*)"', '"mcl_stairs:stair_sandstonesmooth2%1"' },

		{ "mcl_core:cobble", "mcl_core:sandstone" },
		{ '"mcl_stairs:stair_cobble([^"]*)"', '"mcl_stairs:stair_sandstone%1"' },
		{ '"mcl_walls:cobble([^"]*)"', '"mcl_walls:sandstone%1"' },
		{ '"mcl_stairs:slab_cobble([^"]*)"', '"mcl_stairs:slab_sandstone%1"' },

		{ '"mcl_core:stonebrick"', '"mcl_core:redsandstone"' },
		{ '"mcl_core:stonebrick_([^"]+)"', '"mcl_core:redsandstone_%1"' },
		{ '"mcl_walls:stonebrick([^"]*)"', '"mcl_walls:redsandstone%1"' },
		{ '"mcl_stairs:stair_stonebrick"', '"mcl_stairs:stair_redsandstone"' },
		{ '"mcl_stairs:stair_stonebrick_([^"]+)"', '"mcl_stairs:stair_redsandstone_%1"' },

		{ '"mcl_stairs:slab_brick_block([^"]*)"', '"mcl_core:redsandstonesmooth2%1"' },
		{ '"mcl_core:brick_block"', '"mcl_core:redsandstonesmooth2"' },
	},
	spruce = {
		{ "mcl_core:tree", "mcl_core:sprucetree" },
		{ "mcl_core:wood", "mcl_core:sprucewood" },
		{ '"mcl_fences:fence([^"]*)"', '"mcl_fences:spruce_fence%1"' },
		{ '"mcl_stairs:slab_wood([^"]*)"', '"mcl_stairs:slab_sprucewood%1"' },
		{ '"mcl_stairs:stair_wood([^"]*)"', '"mcl_stairs:stair_sprucewood%1"' },
		{
			'"mesecons_pressureplates:pressure_plate_wood_([^"]+)"',
			'"mesecons_pressureplates:pressure_plate_sprucewood_%1"',
		},
		{ '"mcl_doors:trapdoor([^"]*)"', '"mcl_doors:spruce_trapdoor%1"' },
		{ '"mcl_doors:wooden_door([^"]*)"', '"mcl_doors:spruce_door%1"' },
	},
	birch = {
		{ "mcl_core:tree", "mcl_core:birchtree" },
		{ "mcl_core:wood", "mcl_core:birchwood" },
		{ '"mcl_fences:fence([^"]*)"', '"mcl_fences:birch_fence%1"' },
		{ '"mcl_stairs:slab_wood([^"]*)"', '"mcl_stairs:slab_birchwood%1"' },
		{ '"mcl_stairs:stair_wood([^"]*)"', '"mcl_stairs:stair_birchwood%1"' },
		{
			'"mesecons_pressureplates:pressure_plate_wood_([^"]+)"',
			'"mesecons_pressureplates:pressure_plate_birchwood_%1"',
		},
		{ '"mcl_doors:trapdoor([^"]*)"', '"mcl_doors:birch_trapdoor%1"' },
		{ '"mcl_doors:wooden_door([^"]*)"', '"mcl_doors:birch_door%1"' },
	},
	acacia = {
		{ "mcl_core:tree", "mcl_core:acaciatree" },
		{ "mcl_core:wood", "mcl_core:acaciawood" },
		{ '"mcl_fences:fence([^"]*)"', '"mcl_fences:acacia_fence%1"' },
		{ '"mcl_stairs:slab_wood([^"]*)"', '"mcl_stairs:slab_acaciawood%1"' },
		{ '"mcl_stairs:stair_wood([^"]*)"', '"mcl_stairs:stair_acaciawood%1"' },
		{
			'"mesecons_pressureplates:pressure_plate_wood_([^"]+)"',
			'"mesecons_pressureplates:pressure_plate_acaciawood_%1"',
		},
		{ '"mcl_doors:trapdoor([^"]*)"', '"mcl_doors:acacia_trapdoor%1"' },
		{ '"mcl_doors:wooden_door([^"]*)"', '"mcl_doors:acacia_door%1"' },
	},
	dark_oak = {
		{ "mcl_core:tree", "mcl_core:darktree" },
		{ "mcl_core:wood", "mcl_core:darkwood" },
		{ '"mcl_fences:fence([^"]*)"', '"mcl_fences:dark_oak_fence%1"' },
		{ '"mcl_stairs:slab_wood([^"]*)"', '"mcl_stairs:slab_darkwood%1"' },
		{ '"mcl_stairs:stair_wood([^"]*)"', '"mcl_stairs:stair_darkwood%1"' },
		{
			'"mesecons_pressureplates:pressure_plate_wood_([^"]+)"',
			'"mesecons_pressureplates:pressure_plate_darkwood_%1"',
		},
		{ '"mcl_doors:trapdoor([^"]*)"', '"mcl_doors:dark_oak_trapdoor%1"' },
		{ '"mcl_doors:wooden_door([^"]*)"', '"mcl_doors:dark_oak_door%1"' },
	},
	jungle = {
		{ "mcl_core:tree", "mcl_core:jungletree" },
		{ "mcl_core:wood", "mcl_core:junglewood" },
		{ '"mcl_fences:fence([^"]*)"', '"mcl_fences:jungle_fence%1"' },
		{ '"mcl_stairs:slab_wood([^"]*)"', '"mcl_stairs:slab_junglewood%1"' },
		{ '"mcl_stairs:stair_wood([^"]*)"', '"mcl_stairs:stair_junglewood%1"' },
		{
			'"mesecons_pressureplates:pressure_plate_wood_([^"]+)"',
			'"mesecons_pressureplates:pressure_plate_junglewood_%1"',
		},
		{ '"mcl_doors:trapdoor([^"]*)"', '"mcl_doors:jungle_trapdoor%1"' },
		{ '"mcl_doors:wooden_door([^"]*)"', '"mcl_doors:jungle_door%1"' },
	},
	bamboo = {
		{ "mcl_core:tree", "mcl_core:junglewood" },
		{ "mcl_core:wood", "mcl_bamboo:bamboo_block" },
		{ '"mcl_fences:fence([^"]*)"', '"mcl_fences:bamboo_fence%1"' },
		{ '"mcl_stairs:slab_wood([^"]*)"', '"mcl_stairs:slab_bamboo_block%1"' },
		{ '"mcl_stairs:stair_wood([^"]*)"', '"mcl_stairs:stair_bamboo_block%1"' },
		{
			'"mesecons_pressureplates:pressure_plate_wood_([^"]+)"',
			'"mesecons_pressureplates:pressure_plate_bamboo_%1"',
		},
		{ '"mcl_doors:trapdoor([^"]*)"', '"mcl_doors:trapdoor_bamboo%1"' },
		{ '"mcl_doors:wooden_door([^"]*)"', '"mcl_bamboo:bamboo_door%1"' },

		{ "mcl_core:cobble", "mcl_core:andesite" },
		{ '"mcl_stairs:stair_cobble([^"]*)"', '"mcl_stairs:stair_andesite%1"' },
		{ '"mcl_walls:cobble([^"]*)"', '"mcl_walls:andesite%1"' },
		{ '"mcl_stairs:slab_cobble([^"]*)"', '"mcl_stairs:slab_andesite%1"' },
	},
	cherry = {
		{ "mcl_core:tree", "mcl_cherry_blossom:cherrytree" },
		{ "mcl_core:wood", "mcl_cherry_blossom:cherrywood" },
		{ '"mcl_fences:fence([^"]*)"', '"mcl_fences:cherry_blossom_fence%1"' },
		{ '"mcl_stairs:slab_wood([^"]*)"', '"mcl_stairs:slab_cherry_blossom%1"' },
		{ '"mcl_stairs:stair_wood([^"]*)"', '"mcl_stairs:stair_cherry_blossom%1"' },
		{
			'"mesecons_pressureplates:pressure_plate_wood_([^"]+)"',
			'"mesecons_pressureplates:pressure_plate_cherry_blossom_%1"',
		},
		{ '"mcl_doors:trapdoor([^"]*)"', '"mcl_doors:trapdoor_cherry_blossom%1"' },
		{ '"mcl_doors:wooden_door([^"]*)"', '"mcl_doors:door_cherry_blossom%1"' },
	},
}
