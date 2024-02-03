local areas = {
    {
        name = "Hakurei Shrine",
        coord1 = { x = 100, y = 50, z = 1850 },
        coord2 = { x = 190, y = 12, z = 1927 },
		color = "red"
    },
    {
        name = "Moriya Shrine",
        coord1 = { x = 200, y = 150, z = 1950 },
        coord2 = { x = 390, y = 112, z = 2027 },
		color = "green"
    },
    {
     	name = "Myouren Temple",
        coord1 = { x = 444, y = 100, z = 1980 },
        coord2 = { x = 826, y = 37, z = 1800 },
        color = "blue"
    },
    {
     	name = "Human Village",
        coord1 = { x = 700, y = 40, z = 1385 },
        coord2 = { x = 1302, y = -20, z = 1820 },
        color = "green"
    },
    {
        name = "Scarlet Devil Mansion",
        coord1 = { x = 248, y = -50, z = 112 },
        coord2 = { x = 650, y = 200, z = -447 },
		color = "red"
    },
    {
        name = "Misty Lake",
        coord1 = { x = 305, y = -16, z = 458 },
        coord2 = { x = 812, y = 57, z = 937 },
		color = "blue"
    },
    {
        name = "Prismriver Mansion",
        coord1 = { x = 868, y = 3, z = 756 },
        coord2 = { x = 1052, y = 50, z = 544 },
		color = "blue"
    },
    {
        name = "Mokou's House",
        coord1 = { x = 972, y = -5, z = 996 },
        coord2 = { x = 1023, y = 30, z = 1051 },
		color = "red"
    },
    {
        name = "Marisa's House",
        coord1 = { x = 600, y = 5, z = 1430 },
        coord2 = { x = 640, y = -20, z = 1368 },
		color = "yellow"
    },
    {
        name = "Alice's House",
        coord1 = { x = 500, y = 0, z = 1111 },
        coord2 = { x = 570, y = 40, z = 1170 },
		color = "yellow"
    },
	{
        name = "Cirno's Igloo",
        coord1 = { x = 386, y = -30, z = 968 },
        coord2 = { x = 320, y = 20, z = 910 },
		color = "blue"
    },
	{
        name = "Underground Geyser",
        coord1 = { x = -210, y = 110, z = 968 },
        coord2 = { x = -141, y = 185, z = 800 },
		color = "green"
    },
}

cooldown = false;
local elapsed_time = 0

-- Function to check if a player is within the area
local function isPlayerInArea(player)
    local pos = player:get_pos()
	for _, area in ipairs(areas) do
		local minX, maxX = math.min(area.coord1.x, area.coord2.x), math.max(area.coord1.x, area.coord2.x)
		local minY, maxY = math.min(area.coord1.y, area.coord2.y), math.max(area.coord1.y, area.coord2.y)
		local minZ, maxZ = math.min(area.coord1.z, area.coord2.z), math.max(area.coord1.z, area.coord2.z)
        -- Check if the player is within the current area
        if pos.x >= minX and pos.x <= maxX
           and pos.y >= minY and pos.y <= maxY
           and pos.z >= minZ and pos.z <= maxZ then
            return true, area.name, area.color  -- Player is in the area, return true and the area name
        end
    end

    return false, nil  -- Player is not in any of the areas
end

-- Function to handle player position check
local function checkPlayerPosition(player)
    local isInArea, areaName, areaColor = isPlayerInArea(player)
    if isInArea then
		if not cooldown then
			mcl_title.set(player, "subtitle", {text=areaName, color=areaColor})
			cooldown = true
		else
			elapsed_time = 0
        end
	end
end

-- Register the checkPlayerPosition function to be called every 5 seconds
minetest.register_globalstep(function(dtime)
    -- Increment the elapsed time
    elapsed_time = elapsed_time + dtime

    -- Check if 30 seconds have passed
    if elapsed_time >= 30 then
        -- Do something every 30 seconds
		cooldown = false;
        
        -- Reset elapsed time to 0
        elapsed_time = 0
    end
    for _, player in ipairs(minetest.get_connected_players()) do
        checkPlayerPosition(player)
    end
end)
