local cooldowns = {};

local function trigger_hug(player_name, target_player_name)
    local player_to_hug = minetest.get_player_by_name(target_player_name);

    if player_to_hug then
        local function spawn_heart_particles(player)
            local pos = player:get_pos();
            minetest.add_particlespawner({
                amount = 30,
                time = 1,
                minpos = {x = pos.x - 0.5, y = pos.y + 1, z = pos.z - 0.5},
                maxpos = {x = pos.x + 0.5, y = pos.y + 1, z = pos.z + 0.5},
                minvel = {x = -1, y = 2, z = -1},
                maxvel = {x = 1, y = 3, z = 1},
                minacc = {x = 0, y = 1, z = 0},
                maxacc = {x = 0, y = 2, z = 0},
                minexptime = 1,
                maxexptime = 2,
                minsize = 1,
                maxsize = 3,
                collisiondetection = true,
                collision_removal = true,
                object_collision = true,
                texture = "heart.png",  
            });
        end;

        spawn_heart_particles(minetest.get_player_by_name(player_name));
        spawn_heart_particles(player_to_hug);

        mcl_title.set(player_to_hug, "title", {text=player_name, color="#00FFFF", stay=60});
        mcl_title.set(player_to_hug, "subtitle", {text="Gave you a warm hug!", color="#FF66B2", stay=60});

        minetest.sound_play("purr3", { to_player = player_name, gain = 1.0 });
        minetest.sound_play("purr3", { to_player = target_player_name, gain = 1.0 });

        cooldowns[player_name] = os.time() + 4;
    end;
end;

minetest.register_chatcommand("hug", {
    params = "<player>",
    func = function(name, param)
        local cooldown = cooldowns[name] or 0;
        local current_time = os.time();

        if current_time >= cooldown then
            trigger_hug(name, param);
            return true, "Hug sent to " .. param;
        else
            local remaining_time = cooldown - current_time;
            return false, "Hug is on cooldown. Please wait warmly.";
        end;
    end;
});

minetest.register_on_rightclickplayer(function(player, clicker)
    local player_name = player:get_player_name();

    local shift_pressed = clicker and clicker:is_player() and clicker:get_player_control().sneak;

    if shift_pressed then
        local pointed_player_name = player_name;

        if pointed_player_name and pointed_player_name ~= player_name then
            local cooldown = cooldowns[player_name] or 0;
            local current_time = os.time();

            if current_time >= cooldown then
                trigger_hug(player_name, pointed_player_name);
            end;
        end;
    end;
end);

p2p.register_on_right_clickplayer(function(clicker, clicked)
    local player_name = clicker:get_player_name();

    local shift_pressed = clicker and clicker:is_player() and clicker:get_player_control().sneak;

    if shift_pressed then
        local pointed_player_name = clicked:get_player_name();

        if pointed_player_name and pointed_player_name ~= player_name then
            local cooldown = cooldowns[player_name] or 0;
            local current_time = os.time();

            if current_time >= cooldown then
                trigger_hug(player_name, pointed_player_name)
            end
        end
    end
end);
