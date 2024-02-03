mcl_dye = {}
mcl_dye.colors = mcl_dyes.colors
mcl_dye.unicolor_to_dye = mcl_dyes.unicolor_to_dye

mcl_dye.mcl2dyes_translate = {}
for k, v in pairs(mcl_dyes.colors) do
	mcl_dye.mcl2dyes_translate["mcl_dye:"..(v.mcl2 or k)] = "mcl_dyes:"..k
end

-- Override of minetest.register_craft rewrites crafing recipes that use mcl2 item names to use the mcla eqivalents.
-- It's necessary to prevent turning old lapis, bone meal, ink sacs and cocoanuts into dye as
-- before 0.81 the "mcl_dye:blue" item was the same as lapis.
-- This essentially means in mcla "mcl_dye:blue" is still lapis (via alias) but all recipes
-- using that itemstring are rewritten to use "mcl_dyes:blue" so they still work the same.

local old_mt_reg_craft = minetest.register_craft
function minetest.register_craft(recipe)
	if recipe.recipe and type(recipe.recipe) == "table" then
		recipe = table.copy(recipe) --we're possibly modifying the input table; make a copy not to cause confusion
		for k,v in pairs(recipe.recipe) do
			if type(v) == "table" then
				for l,w in pairs(v) do
					if mcl_dye.mcl2dyes_translate[w] then
						recipe.recipe[k][l] = mcl_dye.mcl2dyes_translate[w]
					end
				end
			elseif type(v) == "string"then
				if mcl_dye.mcl2dyes_translate[v] then
					recipe.recipe[k] = mcl_dye.mcl2dyes_translate[v]
				end
			end
		end
	end
	return old_mt_reg_craft(recipe)
end
