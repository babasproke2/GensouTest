local modname = minetest.get_current_modname()

local allow_nav_hacks = minetest.settings:get_bool("mcl_mob_allow_nav_hacks",false)
local work_dist = 4
local gather_distance = 10

local RESETTLE_DISTANCE = 100 -- If a mob is transported this far from home, it gives up bed and job and resettles

local S = minetest.get_translator(modname)

local badges = {
	"mobs_mc_stone.png",
	"mobs_mc_iron.png",
	"mobs_mc_gold.png",
	"mobs_mc_emerald.png",
	"mobs_mc_diamond.png",
}

local WORK = "work"
local SLEEP = "sleep"
local HOME = "home"
local GATHERING = "gathering"
local PATHFINDING = "gowp"
local RUNAWAY = "runaway"

function mobs_mc.villager_mob:stand_still()
	self.walk_chance = 0
	self.jump = false
end

function mobs_mc.villager_mob:get_badge_textures()
	local t = mobs_mc.professions[self._profession].texture
	if self._profession == "unemployed"	then
		t = mobs_mc.professions[self._profession].textures -- ideally both scenarios should be textures with a list containing 1 or multiple
	end

	if self._profession == "unemployed" or self._profession == "nitwit" then return t end
	local tier = self._max_trade_tier or 1
	return {
		t .. "^" .. badges[tier]
	}
end

function mobs_mc.villager_mob:should_sleep()
	local starts = 18000
	local ends = 6000

	if self._profession == "nitwit" then
		starts = 20000
		ends = 8000
	end

	local tod = minetest.get_timeofday()
	tod = (tod * 24000) % 24000
	return tod >= starts or tod < ends
end

function mobs_mc.villager_mob:should_go_home()
	local tod = (minetest.get_timeofday() * 24000) % 24000

	-- Hide for half an hour
	if self._last_alarm and self._last_alarm > (tod - 500) then
		return true
	end

	local weather = mcl_weather.get_weather()

	if weather == "thunder" or weather == "rain" or weather == "snow" then
		return true
	end

	local starts = 17000
	local ends = 18000

	if self._profession == "nitwit" then
		starts = 19000
		ends = 20000
	end

	return tod >= starts and tod < ends
end

function mobs_mc.villager_mob:get_activity(tod)
	if not tod then
		tod = minetest.get_timeofday()
	end
	tod = (tod * 24000) % 24000

	local work_start = 6000
	local lunch_start = 14000
	local lunch_end = 16000
	local work_end = 17000

	local activity
	if self.state == RUNAWAY then
		activity = RUNAWAY
	elseif self:should_sleep() then
		activity = SLEEP
	elseif self:should_go_home() then
		activity = HOME
	elseif self._profession == "nitwit" then
		activity = "chill"
	elseif self.child then
		-- TODO should be play
		activity = "chill"
	elseif tod >= lunch_start and tod < lunch_end then
		activity = GATHERING
	elseif tod >= work_start and tod < work_end then
		activity = WORK
	else
		activity = "chill"
	end

	return activity
end

function mobs_mc.villager_mob:find_closest_bed()
	local p = self.object:get_pos()

	local unclaimed_beds = {}
	local nn2 = minetest.find_nodes_in_area(vector.offset(p,-48,-48,-48),vector.offset(p,48,48,48), {"group:bed"})
	if nn2 then
		for a,b in pairs(nn2) do
			local bed_node = minetest.get_node(b)
			local bed_name = bed_node.name
			local is_bed_bottom = string.find(bed_name,"_bottom")

			local bed_meta = minetest.get_meta(b)
			local owned_by = bed_meta:get_string("villager")

			-- TODO Why is it looking for a new bed if it has a bed and the bed is in the area?
			if (owned_by and owned_by == self._id) then
				bed_meta:set_string("villager", "")
				bed_meta:set_string("infotext", "")
				owned_by = nil
			end

			if is_bed_bottom then
				local bed_top_meta = minetest.get_meta(mcl_beds.get_bed_top (b))
				local owned_by_player = bed_top_meta:get_string("player")

				if owned_by == "" and (not owned_by_player or owned_by_player == "") then
					table.insert(unclaimed_beds, b)
				end
			end
		end
	end

	local distance_to_closest_block = nil
	local closest_block = nil

	if unclaimed_beds then
		for i,b in pairs(unclaimed_beds) do
			local distance_to_block = vector.distance(p, b)
			if not distance_to_closest_block or distance_to_closest_block > distance_to_block then
				closest_block = b
				distance_to_closest_block = distance_to_block
			end
		end
	end

	return closest_block
end

function mobs_mc.villager.find_closest_unclaimed_block(p, requested_block_types)
	local nn = minetest.find_nodes_in_area(vector.offset(p,-48,-48,-48),vector.offset(p,48,48,48), requested_block_types)

	local distance_to_closest_block = nil
	local closest_block = nil

	for i,n in pairs(nn) do
		local m = minetest.get_meta(n)

		if m:get_string("villager") == "" then
			local distance_to_block = vector.distance(p, n)
			if not distance_to_closest_block or distance_to_closest_block > distance_to_block then
				closest_block = n
				distance_to_closest_block = distance_to_block
			end
		end
	end
	return closest_block
end

function mobs_mc.villager_mob:check_bed()
	local b = self._bed
	if not b then
		return false
	end

	local n = minetest.get_node(b)

	local is_bed_bottom = string.find(n.name,"_bottom")
	if n and not is_bed_bottom then
		self._bed = nil --the stormtroopers have killed uncle owen
		return false
	else
		return true
	end
end

function mobs_mc.villager_mob:go_home(sleep)
	local b = self._bed
	if not b then
		return
	end

	local bed_node = minetest.get_node(b)
	if not bed_node then
		self._bed = nil
		return
	end

	if vector.distance(self.object:get_pos(),b) < 2 then
		if sleep then
			self.order = SLEEP
		end
	else
		if sleep and self.order == SLEEP then
			self.order = nil
			return
		end

		self:gopath(b,function(self,b)
			local b = self._bed

			if not b then
				return false
			end

			if not minetest.get_node(b) then
				return false
			end

			if vector.distance(self.object:get_pos(),b) < 2 then
				return true
			end
		end, true)
	end
end



function mobs_mc.villager_mob:take_bed()
	if not self then return end

	local p = self.object:get_pos()

	local closest_block = self:find_closest_bed()

	if closest_block then
		local distance_to_block = vector.distance(p, closest_block)
		if distance_to_block < 2 then
			local m = minetest.get_meta(closest_block)
			local owner = m:get_string("villager")
			if owner and owner ~= "" and owner ~= self._id then
				if self.order == "stand" then self.order = nil end
				return
			end

			if self.order ~= SLEEP then
				self.order = SLEEP
				m:set_string("villager", self._id)
				m:set_string("infotext", S("A villager sleeps here"))
				self._bed = closest_block
			end
		else
			self:gopath(closest_block,function(self) end)
		end
	else
		if self.order == "stand" then self.order = nil end
	end
end

local function has_golem(pos)
	for _,o in pairs(minetest.get_objects_inside_radius(pos,16)) do
		local l = o:get_luaentity()
		if l and l.name == "mobs_mc:iron_golem" then return true end
	end
end

function mobs_mc.villager_mob:monsters_near()
	for _,o in pairs(minetest.get_objects_inside_radius(self.object:get_pos(),10)) do
		local l = o:get_luaentity()
		if l and l.type =="monster" then return true end
	end
end

function mobs_mc.villager_mob:has_summon_participants()
	local r = 0
	for _,o in pairs(minetest.get_objects_inside_radius(self.object:get_pos(),10)) do
		local l = o:get_luaentity()
		--TODO check for gossiping
		if l and l.name == "mobs_mc:villager" then r = r + 1 end
	end
	return r > 2
end

local function get_ground_below_floating_object(float_pos)
	local pos = float_pos
	repeat
		pos = vector.offset(pos, 0, -1, 0)
		local node = minetest.get_node(pos)
	until node.name ~= "air"

	-- If pos is 1 below float_pos, then just return float_pos as there is no air below it
	if pos.y == float_pos.y - 1 then
		return float_pos
	end

	return pos
end

function mobs_mc.villager_mob:summon_golem()
	vector.offset(self.object:get_pos(),-10,-10,-10)
	local nn = minetest.find_nodes_in_area_under_air(vector.offset(self.object:get_pos(),-8,-6,-8),vector.offset(self.object:get_pos(),8,6,8),{"group:solid","group:water"})
	table.shuffle(nn)
	for _,n in pairs(nn) do
		local up = minetest.find_nodes_in_area(vector.offset(n,0,1,0),vector.offset(n,0,3,0),{"air"})
		if up and #up >= 3 then
			local obj = minetest.add_entity(vector.offset(n,0,1,0),"mobs_mc:iron_golem")
			local ent = obj:get_luaentity()
			if ent then
				local bell = minetest.find_node_near(n, 48, {"mcl_bells:bell"})
				if not bell and self._bed then
					bell = minetest.find_node_near(self._bed, 48, {"mcl_bells:bell"})
				end

				if bell then
					ent._home = get_ground_below_floating_object(bell)
				else
					ent._home = n
				end

				return obj
			end
		end
	end
end

function mobs_mc.villager_mob:check_summon(dtime)
	-- TODO has selpt in last 20?
	if self._summon_timer and self._summon_timer > 30 then
		local pos = self.object:get_pos()
		self._summon_timer = 0
		if has_golem(pos) then return end
		if not self:monsters_near() then return end
		if not self:has_summon_participants() then return end
		self:summon_golem()
	elseif self._summon_timer == nil  then
		self._summon_timer = 0
	end
	self._summon_timer = self._summon_timer + dtime
end

function mobs_mc.villager_mob:has_traded()
	if not self._trades then
		return false
	end
	local cur_trades_tab = minetest.deserialize(self._trades)
	if cur_trades_tab and type(cur_trades_tab) == "table" then
		for trader, trades in pairs(cur_trades_tab) do
			if trades.traded_once then
				return true
			end
		end
	end
	return false
end

function mobs_mc.villager_mob:unlock_trades()
	if not self._trades then
		return false
	end
	local has_unlocked = false

	local trades = minetest.deserialize(self._trades)
	if trades and type(trades) == "table" then
		for trader, trade in pairs(trades) do
			local trade_tier_too_high = trade.tier > self._max_trade_tier
			if not trade_tier_too_high then
				if trade["locked"] == true then
					trade.locked = false
					trade.trade_counter = 0
					has_unlocked = true
				end
			end
		end
		if has_unlocked then
			self._trades = minetest.serialize(trades)
		end
	end
end

----- JOBSITE LOGIC
local function get_profession_by_jobsite(js)
	for k,v in pairs(mobs_mc.professions) do
		if v.jobsite == js then
			return k
		-- Catch Nitwit doesn't have a jobsite
		elseif v.jobsite and v.jobsite:find("^group:") then
			local group = v.jobsite:gsub("^group:", "")
			if minetest.get_item_group(js, group) > 0 then
				return k
			end
		end
	end
end

function mobs_mc.villager_mob:employ(jobsite_pos)
	local n = minetest.get_node(jobsite_pos)
	local m = minetest.get_meta(jobsite_pos)
	local p = get_profession_by_jobsite(n.name)
	if p and m:get_string("villager") == "" then
		m:set_string("villager",self._id)
		m:set_string("infotext", S("A villager works here"))
		self._jobsite = jobsite_pos

		if not self:has_traded() then
			self._profession=p
			self:set_textures()
		end
		return true
	end
end

function mobs_mc.villager_mob:look_for_job(requested_jobsites)
	local p = self.object:get_pos()

	local closest_block = mobs_mc.villager.find_closest_unclaimed_block(p, requested_jobsites)

	if closest_block then
		local gp = self:gopath(closest_block,function(self)
			if self and self.state == "stand" then
				self.order = WORK
			end
		end)

		if gp then
			return closest_block
		end
	end

	return nil
end

function mobs_mc.villager_mob:get_a_job()
	if self.order == WORK then self.order = nil end

	local requested_jobsites = mobs_mc.jobsites
	if self:has_traded() then
		requested_jobsites = {mobs_mc.professions[self._profession].jobsite}
	end

	local p = self.object:get_pos()
	local n = minetest.find_node_near(p,1,requested_jobsites)
	if n and self:employ(n) then return true end

	if self.state ~= PATHFINDING then
		self:look_for_job(requested_jobsites)
	end
end

function mobs_mc.villager_mob:retrieve_my_jobsite()
	if not self or not self._jobsite then
		return
	end
	local n = mcl_vars.get_node(self._jobsite)
	local m = minetest.get_meta(self._jobsite)
	if m:get_string("villager") == self._id then
		return n
	end
	return
end

function mobs_mc.villager_mob:remove_job()
	self._jobsite = nil
	if not self:has_traded() then
		self._profession = "unemployed"
		self._trades = nil
		self:set_textures()
	end
end

function mobs_mc.villager_mob:validate_jobsite()
	if self._profession == "unemployed" then return false end

	local job_block = self:retrieve_my_jobsite()
	if not job_block then
		if self.order == WORK then
			self.order = nil
		end

		self:remove_job()
		return false
	else
		local resettle = vector.distance(self.object:get_pos(),self._jobsite) > RESETTLE_DISTANCE
		if resettle then
			local m = minetest.get_meta(self._jobsite)
			m:set_string("villager", nil)
			m:set_string("infotext", nil)
			self:remove_job()
			return false
		end
		return true
	end
end

function mobs_mc.villager_mob:do_work()
	if self.child then
		return
	end

	if self:validate_jobsite() then

		local jobsite = self._jobsite
		local distance_to_jobsite = vector.distance(self.object:get_pos(), jobsite)

		if distance_to_jobsite < work_dist then
			if self.state ~= PATHFINDING and self.order ~= WORK then
				self.order = WORK
				self:unlock_trades()
			end
		else
			if self.order == WORK then
				self.order = nil
				return
			end
			self:gopath(jobsite, function(self, jobsite)
				if not self then
					return false
				end
				if not self._jobsite then
					return false
				end
				if vector.distance(self.object:get_pos(), self._jobsite) < work_dist then
					return true
				end
			end)
		end
	elseif self._profession == "unemployed" or self:has_traded() then
		self:get_a_job()
	end
end

function mobs_mc.villager_mob:teleport_to_town_bell()
	local looking_for_type = {}
	table.insert(looking_for_type, "mcl_bells:bell")

	local p = self.object:get_pos()
	local nn =
		minetest.find_nodes_in_area(vector.offset(p, -48, -48, -48), vector.offset(p, 48, 48, 48), looking_for_type)

	for _, n in pairs(nn) do
		local target_point = get_ground_below_floating_object(n)

		if target_point then
			self.object:set_pos(target_point)
			return
		end
	end
end

function mobs_mc.villager_mob:go_to_town_bell()
	if not self:ready_to_path(true) then
		if self._pf_last_failed then
			if (os.time() - self._pf_last_failed) < 5 then
				return
			else
				self._pf_last_failed = nil
			end
		end
	end

	local looking_for_type={}
	table.insert(looking_for_type, "mcl_bells:bell")

	local p = self.object:get_pos()
	local nn = minetest.find_nodes_in_area(vector.offset(p,-48,-48,-48),vector.offset(p,48,48,48), looking_for_type)

	--Ideally should check for closest available. It'll make pathing easier.
	for _,n in pairs(nn) do
		local target_point = get_ground_below_floating_object(n)

		if vector.distance(self.object:get_pos(), target_point) > gather_distance then
			local gp = self:gopath(target_point, function(self)
				if self then
					self.order = GATHERING
				end
			end)

			if gp then
				return n
			end
		end

	end

	return nil
end
--[[
function mobs_mc.villager_mob:validate_bed()
	if not self or not self._bed then
		return false
	end
	local n = mcl_vars.get_node(self._bed)
	if not n then
		self._bed = nil
		return false
	end

	local bed_valid = true

	local m = minetest.get_meta(self._bed)

	local resettle = vector.distance(self.object:get_pos(),self._bed) > RESETTLE_DISTANCE
	if resettle then
		m:set_string("villager", nil)
		self._bed = nil
		bed_valid = false
		return false
	end

	local owned_by_player = m:get_string("player")
	if owned_by_player ~= "" then
		m:set_string("villager", nil)
		self._bed = nil
		bed_valid = false
		return false
	end

	if m:get_string("villager") ~= self._id then
		self._bed = nil
		return false
	else
		return true
	end

end
--]]

function mobs_mc.villager_mob:sleep_over()
	local p = self.object:get_pos()
	local distance_to_closest_bed = 1000
	local closest_bed = nil
	local nn2 =
		minetest.find_nodes_in_area(vector.offset(p, -48, -48, -48), vector.offset(p, 48, 48, 48), { "group:bed" })

	if nn2 then
		for a, b in pairs(nn2) do
			local distance_to_bed = vector.distance(p, b)
			if distance_to_closest_bed > distance_to_bed then
				closest_bed = b
				distance_to_closest_bed = distance_to_bed
			end
		end
	end

	if closest_bed and distance_to_closest_bed >= 3 then
		self:gopath(closest_bed)
	end
end

function mobs_mc.villager_mob:do_activity()
	if allow_nav_hacks then
		-- When a night is skipped telport villagers to their bed or bell
		if self.last_skip == nil then
			self.last_skip = 0
		end
		local last_skip = mcl_beds.last_skip()
		if self.last_skip < last_skip then
			self.last_skip = last_skip
			if self:check_bed() then
				self.object:set_pos(self._bed)
			else
				self:teleport_to_town_bell()
			end

			self.waypoints = nil
			self._target = nil
			self.current_target = nil
			self.attack = nil
			self.following = nil
			self.state = "stand"
			self.order = "stand"
			self._pf_last_failed = os.time()
			self.object:set_velocity(vector.zero())
			self.object:set_acceleration(vector.zero())
			self:set_animation("stand")
		end
	end

	if self.following or self.state == PATHFINDING then
		return
	end

	if not self:check_bed() then
		self:take_bed()
	end

	if (not self:should_sleep()) and self.order == SLEEP then
		self.order = nil
	end

	-- Only check in day or during thunderstorm but wandered_too_far code won't work
	local wandered_too_far = false
	if self:check_bed() then
		wandered_too_far = (self.state ~= PATHFINDING) and (vector.distance(self.object:get_pos(), self._bed) > 50)
	end
	local activity = self:get_activity()
	-- TODO separate sleep and home activities when villagers can sleep
	if activity == SLEEP or activity == HOME then
		if self:check_bed() then
			self:go_home(true)
		else
			-- If it's sleepy time and we don't have a bed, hide in someone elses house
			self:sleep_over()
		end
	elseif activity == WORK then
		self:do_work()
	elseif activity == GATHERING then
		self:go_to_town_bell()
	elseif wandered_too_far then
		self:go_home(false)
	else
		self.order = nil
	end
end
