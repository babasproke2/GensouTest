mcl_villages.schematic_houses = {}
mcl_villages.schematic_jobs = {}
mcl_villages.schematic_lamps = {}
mcl_villages.schematic_bells = {}
mcl_villages.schematic_wells = {}

local function job_count(schem_lua)
	-- Local copy so we don't trash the schema for other uses, because apparently
	-- there isn't a non-destructive way to count occurrences of a string :(
	local str = schem_lua
	local count = 0

	for _, n in pairs(mobs_mc.jobsites) do
		if string.find(n, "^group:") then
			if n == "group:cauldron" then
				count = count + select(2, string.gsub(str, '"mcl_cauldrons:cauldron', ""))
			else
				minetest.log("warning", string.format("[mcl_villages] Don't know how to handle group %s counting it as 1 job site", n))
				count = count + 1
			end
		else
			count = count + select(2, string.gsub(str, '{name="' .. n .. '"', ""))
		end
	end

	return count
end

local function load_schema(name, mts)
	local schem_lua = minetest.serialize_schematic(mts, "lua", { lua_use_comments = false, lua_num_indent_spaces = 0 })
		.. " return schematic"

	local schematic = loadstring(schem_lua)()

	local data = {
		name = name,
		size = schematic.size,
		schem_lua = schem_lua,
	}

	return data
end

function mcl_villages.register_lamp(record)
	local data = load_schema(record["name"], record["mts"])
	if record["yadjust"] then
		data["yadjust"] = record["yadjust"]
	end
	table.insert(mcl_villages.schematic_lamps, data)
end

function mcl_villages.register_bell(record)
	local data = load_schema(record["name"], record["mts"])
	if record["yadjust"] then
		data["yadjust"] = record["yadjust"]
	end
	table.insert(mcl_villages.schematic_bells, data)
end

function mcl_villages.register_well(record)
	local data = load_schema(record["name"], record["mts"])
	if record["yadjust"] then
		data["yadjust"] = record["yadjust"]
	end
	table.insert(mcl_villages.schematic_wells, data)
end

local optional_fields = { "min_jobs", "max_jobs", "yadjust", "num_others" }

function mcl_villages.register_building(record)
	local data = load_schema(record["name"], record["mts"])

	for _, field in ipairs(optional_fields) do
		if record[field] then
			data[field] = record[field]
		end
	end

	-- Local copy so we don't trash the schema for other uses
	local str = data["schem_lua"]
	local num_beds = select(2, string.gsub(str, '"mcl_beds:bed_[^"]+_bottom"', ""))

	if num_beds > 0 then
		data["num_beds"] = num_beds
	end

	local job_count = job_count(data["schem_lua"])

	if job_count > 0 then
		data["num_jobs"] = job_count
		table.insert(mcl_villages.schematic_jobs, data)
	else
		table.insert(mcl_villages.schematic_houses, data)
	end
end
