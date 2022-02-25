local _, fluffy = ...

local last_update = 0;

fluffy.autoshot_sparks = {};

local function get_point_of_equilibrium_autoshot(A, t)
    local cast_A = A["cast"](t);
    local cd_A = A["cdb"](t);

    local cast_auto = fluffy.ability_autoshot["cast"](t);
    local eWS = fluffy.ability_autoshot["cdb"](t) + cast_auto;

    local d_A = A["dmg"]();
    local d_auto = fluffy.ability_autoshot["dmg"]();

    local p_auto = d_auto / eWS;
    local p_A = d_A / (cd_A + cast_A);

    return (alpha * cast_A * d_auto - d_A * cast_auto) / (alpha * d_auto + d_A);
end

local function get_point_of_equilibrium_abilities(dmg_1, dmg_2)

    local alpha = 1.4;

    return 1.5 * (alpha * dmg_2 - dmg_1)/(alpha * dmg_2 + dmg_1);

end

-- local function get_point_of_equilibrium(A_dmg, B_dmg, A_cast, B_cast)
--     return (A_dmg*(B_cast)-fluffy.recommendation_tolerance*B_dmg*(A_cast))/(fluffy.recommendation_tolerance*B_dmg + A_dmg);
-- end

local intervals_autoshot_starts  = {};
local intervals_autoshot_ends    = {};
local intervals_abilities_starts = {};
local intervals_abilities_ends   = {};

local intervals_abilities_starts_tmp = {};
local intervals_abilities_ends_tmp   = {};



local function optimize_towards_autoshot()
    for A, v in pairs(intervals_abilities_starts) do
        for i = 1,#v do
            local ts = v[i];
            local te = intervals_abilities_ends[A][i];

            for j = 1,#intervals_autoshot_starts do
                local auto_ts = intervals_autoshot_starts[j];
                local auto_te =   intervals_autoshot_ends[j];
                local f = 0;

                if A == fluffy.ability_steadyshot then
                    if j > 1 then
                        f = -get_point_of_equilibrium_autoshot(A, intervals_autoshot_ends[j - 1]);
                    else
                        f = -get_point_of_equilibrium_autoshot(A, auto_ts);
                    end
                end

                local new_ts_1 = ts;
                local new_te_1 = min(auto_ts + f, te);
                if A == fluffy.ability_steadyshot then
                    if fluffy.max_steady_clipping >= 0 then
                        new_te_1 = min(new_te_1, auto_ts + fluffy.max_steady_clipping - fluffy.ability_steadyshot["cast"](auto_ts));
                    end
                end

				if new_ts_1 < new_te_1 + 0.005 then
					table.insert(intervals_abilities_starts_tmp, new_ts_1);
					table.insert(intervals_abilities_ends_tmp, new_te_1);
				end

                local new_ts_2 = max(auto_te, ts);
                local new_te_2 = te;

				ts = new_ts_2;
				te = new_te_2;
            end
			
			if ts < te + 0.005 then
				table.insert(intervals_abilities_starts_tmp, ts);
				table.insert(intervals_abilities_ends_tmp, te);
			end
        end

        if #intervals_abilities_starts_tmp > 0 then
            wipe(intervals_abilities_starts[A]);
            wipe(intervals_abilities_ends[A]);
    
            for k, v in pairs(intervals_abilities_starts_tmp) do
                table.insert(intervals_abilities_starts[A], v);
            end
    
            for k, v in pairs(intervals_abilities_ends_tmp) do
                table.insert(intervals_abilities_ends[A], v);
            end
    
            wipe(intervals_abilities_starts_tmp);
            wipe(intervals_abilities_ends_tmp);
        end
    end
end


-- trimms the intervals in A such as A := A \setminus [ts_B, te_B]
local function set_minus(A, ts_B, te_B)
    local ints_A_tgt_s = intervals_abilities_starts[A];
    local ints_A_tgt_e = intervals_abilities_ends[A];

    for i=1,#ints_A_tgt_s do
        local ts_A = ints_A_tgt_s[i];
        local te_A = ints_A_tgt_e[i];

        if te_B >= ts_A and ts_B <= te_A then

            local new_ts_A = ts_A;
            local new_te_A = ts_B;

            if new_ts_A < new_te_A + 0.005 then
                table.insert(intervals_abilities_starts_tmp, new_ts_A);
                table.insert(intervals_abilities_ends_tmp, new_te_A);
            end

            ts_A = te_B;
        end

        if ts_A < te_A + 0.005 then
            table.insert(intervals_abilities_starts_tmp, ts_A);
            table.insert(intervals_abilities_ends_tmp, te_A);
        end
    end

    if #intervals_abilities_starts_tmp > 0 then
        wipe(intervals_abilities_starts[A]);
        wipe(intervals_abilities_ends[A]);

        for k, v in pairs(intervals_abilities_starts_tmp) do
            table.insert(intervals_abilities_starts[A], v);
        end

        for k, v in pairs(intervals_abilities_ends_tmp) do
            table.insert(intervals_abilities_ends[A], v);
        end

        wipe(intervals_abilities_starts_tmp);
        wipe(intervals_abilities_ends_tmp);
    end
end

local ability_priority_indices = {};
local ability_priority_abilities = {};
local ability_priority_dmg = {};
local function sort_ability_priority(a, b)
    return ability_priority_dmg[a] > ability_priority_dmg[b];
end

local function sort_ability_priority_2(a, b)

    if ability_priority_abilities[a] == fluffy.ability_steadyshot then
        return true;
    elseif ability_priority_abilities[a] == fluffy.ability_multishot and ability_priority_abilities[b] ~= fluffy.ability_steadyshot then
        return true;
    end

    return false;
end

local function optimize_intervals_simple()

    -- calculating disjoint intervals
    local idx = 1;
    for B, ints_B in pairs(intervals_abilities_starts) do 
        local dmg_B = B["dmg"]();
        local ints_B_tmp = intervals_abilities_ends[B];
        table.insert(ability_priority_dmg, dmg_B);
        table.insert(ability_priority_abilities, B);
        table.insert(ability_priority_indices, idx);
        idx = idx + 1;
    end

    -- clipping of interval ends
    -- table.sort(ability_priority_indices, sort_ability_priority);
    table.sort(ability_priority_indices, sort_ability_priority_2);

    for i_tmp=1,#ability_priority_indices do 
        local i = ability_priority_indices[i_tmp];

        local B = ability_priority_abilities[i];
        local ints_B_s = intervals_abilities_starts[B];
        local ints_B_e = intervals_abilities_ends[B];

        for j_tmp=i_tmp+1,#ability_priority_indices do 
            local j = ability_priority_indices[j_tmp];

            local A = ability_priority_abilities[j];

            for i=1,#ints_B_s do
                local ts_B = ints_B_s[i];
                local te_B = ints_B_e[i];
    
                set_minus(A, ts_B, te_B);
            end
        end
    end

    -- clipping of interval ends
    -- table.sort(ability_priority_indices, sort_ability_priority);
    -- table.sort(ability_priority_indices, sort_ability_priority_2);

    for i_tmp=1,#ability_priority_indices do 
        local i = ability_priority_indices[i_tmp];

        local B = ability_priority_abilities[i];
        local dmg_B = ability_priority_dmg[i];
        local ints_B_s = intervals_abilities_starts[B];
        local ints_B_e = intervals_abilities_ends[B];

        for j_tmp=i_tmp+1,#ability_priority_indices do 
            local j = ability_priority_indices[j_tmp];

            local A = ability_priority_abilities[j];
            local dmg_A = ability_priority_dmg[j];
            local ints_A_s = intervals_abilities_starts[A];
            local ints_A_e = intervals_abilities_ends[A];

            --intervals in A will be clipped by intervals in B
            for k=1,#ints_A_e do
                local ts_A = ints_A_s[k];
                local te_A = ints_A_e[k];

                if ts_A < te_A then
                    for l=1,#ints_B_s do
                        local ts_B = ints_B_s[l];
                        local te_B = ints_B_e[l];

                        if (ts_B < te_B) and (ts_B >= te_A) then
                            -- print(- get_point_of_equilibrium_abilities(dmg_A, dmg_B));
                            te_A = min(te_A, ts_B - get_point_of_equilibrium_abilities(dmg_A, dmg_B));
                        end
                    end
    
                    ints_A_e[k] = te_A;
                end
            end
        end
    end

    wipe(ability_priority_abilities);
    wipe(ability_priority_dmg);
    wipe(ability_priority_indices);
end

-- local function clip_interval_starts()
-- 	for A, _ in pairs(intervals_abilities_starts) do
-- 		for B, _ in pairs(intervals_abilities_starts) do
-- 			if A ~= B then
-- 				clip_intervals_abilities(A, B);
-- 			end
-- 		end
-- 	end
-- end


local function analyze_windows_of_opportunities_experimental(abilities, window_length)

    local t = GetTime();

    -- first we define curently expected windows for autoshot casts
    local auto_cast = fluffy.ability_autoshot["cast"](t);
    for k, auto_fired_time in pairs(fluffy.autoshot_sparks) do
        table.insert(intervals_autoshot_ends, auto_fired_time);
        table.insert(intervals_autoshot_starts, auto_fired_time - auto_cast);

        table.insert(fluffy.ability_autoshot["windows_s"], auto_fired_time - auto_cast);
        table.insert(fluffy.ability_autoshot["windows_e"], auto_fired_time);
    end

    --then we start with defining intervals for each ability
    for k, A in pairs(abilities) do
        local tmp_ = max(fluffy.cast_finishes, max(t, t + A["cd"](t)));
        table.insert(intervals_abilities_starts[A], tmp_);
        table.insert(intervals_abilities_ends[A], t + window_length);
    end

    optimize_towards_autoshot();
    optimize_intervals_simple();

    -- DONE, we post process the results
    for A, TMP_START in pairs(intervals_abilities_starts) do
        local TMP_END = intervals_abilities_ends[A];

        for i = 1,#TMP_START do
            local ts = TMP_START[i];
            local te = TMP_END[i];

            if ts < te then
                table.insert(A["windows_s"], ts);
                table.insert(A["windows_e"], te);
            end
        end
    end
    
    if fluffy.ability_raptorstrike["known"] then
        local cd_raptor = max(fluffy.cast_finishes, max(t + fluffy.ability_raptorstrike["cd"](t), t));
        local cd_melee = max(fluffy.cast_finishes, max(t + fluffy.ability_meleestrike["cd"](t), t));
        -- print(cd_melee - t);

        if fluffy.melee_mh_weapon_id > 0 then
            if (cd_melee < cd_raptor) then

                if (IsUsableSpell(fluffy.ability_raptorstrike["active_id"])) then
                    table.insert(fluffy.ability_meleestrike["windows_s"], cd_melee);
                    table.insert(fluffy.ability_meleestrike["windows_e"], cd_raptor);
        
                    
                    table.insert(fluffy.ability_raptorstrike["windows_s"], cd_raptor);
                    table.insert(fluffy.ability_raptorstrike["windows_e"], cd_raptor + 25);
                else
                    table.insert(fluffy.ability_meleestrike["windows_s"], cd_melee);
                    table.insert(fluffy.ability_meleestrike["windows_e"], cd_melee + 25);
                end
            else
                if (IsUsableSpell(fluffy.ability_raptorstrike["active_id"])) then
                    table.insert(fluffy.ability_raptorstrike["windows_s"], cd_raptor);
                    table.insert(fluffy.ability_raptorstrike["windows_e"], cd_raptor + 25);
                else
                    table.insert(fluffy.ability_meleestrike["windows_s"], cd_melee);
                    table.insert(fluffy.ability_meleestrike["windows_e"], cd_melee + 25);
                end
            end
        end
    end
    
    wipe(intervals_autoshot_starts);
    wipe(intervals_autoshot_ends);
    for k,v in pairs(intervals_abilities_starts) do
        wipe(v);
    end
    for k,v in pairs(intervals_abilities_ends) do
        wipe(v);
    end
end

local abilities_to_consider = {};

-- local function can_consider_melee(mode)
--     -- if mode == 0 then
--     --     return false;
--     -- elseif mode == 1 then
--     --     return true;
--     -- else
--     --     if IsItemInRange(8149, "target") and UnitExists("target") and UnitIsVisible("target") and UnitCanAttack("player", "target") and (not UnitIsDead("target")) then
--     --         return true;
--     --     end
--     -- end
--     return false;
-- end
local last_time_moved = 0;
function analyze_game_state(window_len)


    local t = GetTime();
    if  fluffy.update_frequency_val * (t - last_update) < 1 then
        return;
    end
    last_update = t;
    -- local name, text, texture, startTime, endTime, isTradeSkill, castID, spellID = CastingInfo();
    -- if name ~= nil then
    --     print(startTime/1000 - fluffy.cast_finishes, endTime/1000 - fluffy.cast_finishes);
    -- end
    

    wipe(fluffy.ability_autoshot["windows_s"]);
    wipe(fluffy.ability_aimedshot["windows_s"]);
    wipe(fluffy.ability_arcaneshot["windows_s"]);
    wipe(fluffy.ability_multishot["windows_s"]);
    wipe(fluffy.ability_steadyshot["windows_s"]);
    wipe(fluffy.ability_raptorstrike["windows_s"]);
    wipe(fluffy.ability_meleestrike["windows_s"]);
    wipe(fluffy.ability_autoshot["windows_e"]);
    wipe(fluffy.ability_aimedshot["windows_e"]);
    wipe(fluffy.ability_arcaneshot["windows_e"]);
    wipe(fluffy.ability_multishot["windows_e"]);
    wipe(fluffy.ability_steadyshot["windows_e"]);
    wipe(fluffy.ability_raptorstrike["windows_e"]);
    wipe(fluffy.ability_meleestrike["windows_e"]);
    wipe(fluffy.autoshot_sparks);
    if fluffy.is_player_hunter == false or fluffy.ranged_weapon_id == 0 then
		return;
	end    
    update_player_stats();

    local spell, _, _, _, endTime = UnitCastingInfo("player");
    if not fluffy.is_casting_autoshot then
        fluffy.cast_finishes = t;
    else
        fluffy.cast_finishes = fluffy.ability_autoshot["next_start"];
    end
    if spell then
        fluffy.cast_finishes = max(fluffy.cast_finishes, endTime * 0.001);
    else
        local spellC, _, _, _, endTimeC = UnitChannelInfo("player");
        if spellC then
            fluffy.cast_finishes = max(fluffy.cast_finishes, endTimeC * 0.001);
        end
    end

    if fluffy.feign_death_active == 1 then
		fluffy.ability_autoshot["fired"] = t;
		fluffy.ability_autoshot["next_start"] = t + fluffy.ability_autoshot["cdb"](t);

		local mainSpeed, _ = UnitAttackSpeed("player");
		fluffy.ability_meleestrike["fired"] = t;
		fluffy.ability_meleestrike["next_start"] = t + mainSpeed;
    end

    local autoshot_shift = fluffy.ability_autoshot["next_start"];
    if autoshot_shift < t - 1.2*fluffy.ability_autoshot["cast"](t) then
        autoshot_shift = t;
    end
    autoshot_shift = max(fluffy.cast_finishes, max(autoshot_shift, fluffy.autoshot_delay));
    -- if (IsPlayerMoving() or IsFalling()) then
    --     last_time_moved = t;
    -- end
    autoshot_shift = autoshot_shift + fluffy.ability_autoshot["cast"](autoshot_shift);
    -- autoshot_shift = max(autoshot_shift, last_time_moved + fluffy.movement_spark_interval);
    table.insert(fluffy.autoshot_sparks, autoshot_shift);

    while autoshot_shift < t + 3*window_len do
        -- print(autoshot_shift - t - fluffy.ability_autoshot["cast"](autoshot_shift));
        -- print(autoshot_shift - t);
        autoshot_shift = autoshot_shift + fluffy.ability_autoshot["cast"](autoshot_shift) + fluffy.ability_autoshot["cdb"](autoshot_shift);
        table.insert(fluffy.autoshot_sparks, autoshot_shift);
        -- print(#fluffy.autoshot_sparks);
    end


    -- if fluffy.ability_aimedshot["known"] and IsUsableSpell(fluffy.ability_aimedshot["active_id"]) then
    --     table.insert(abilities_to_consider, fluffy.ability_aimedshot);
    -- end

    -- if fluffy.ability_meleestrike["known"] and can_consider_melee(fluffy.ability_meleestrike["forbid"]) then
    --     table.insert(abilities_to_consider, fluffy.ability_meleestrike);
    -- end

    -- if fluffy.ability_raptorstrike["known"] and (can_consider_melee(fluffy.ability_raptorstrike["forbid"]) and IsUsableSpell(fluffy.ability_raptorstrike["active_id"])) then
    --     table.insert(abilities_to_consider, fluffy.ability_raptorstrike);
    -- end

    if fluffy.ability_arcaneshot["known"] and IsUsableSpell(fluffy.ability_arcaneshot["active_id"]) then
        table.insert(abilities_to_consider, fluffy.ability_arcaneshot);
        if intervals_abilities_starts[fluffy.ability_arcaneshot] == nil then
            intervals_abilities_starts[fluffy.ability_arcaneshot] = {};
        end
        if intervals_abilities_ends[fluffy.ability_arcaneshot] == nil then
            intervals_abilities_ends[fluffy.ability_arcaneshot] = {};
        end
    end

    if fluffy.ability_multishot["known"] and IsUsableSpell(fluffy.ability_multishot["active_id"]) then
        table.insert(abilities_to_consider, fluffy.ability_multishot);
        if intervals_abilities_starts[fluffy.ability_multishot] == nil then
            intervals_abilities_starts[fluffy.ability_multishot] = {};
        end
        if intervals_abilities_ends[fluffy.ability_multishot] == nil then
            intervals_abilities_ends[fluffy.ability_multishot] = {};
        end
    end

    if fluffy.ability_steadyshot["known"] and IsUsableSpell(fluffy.ability_steadyshot["active_id"]) then
        table.insert(abilities_to_consider, fluffy.ability_steadyshot);
        if intervals_abilities_starts[fluffy.ability_steadyshot] == nil then
            intervals_abilities_starts[fluffy.ability_steadyshot] = {};
        end
        if intervals_abilities_ends[fluffy.ability_steadyshot] == nil then
            intervals_abilities_ends[fluffy.ability_steadyshot] = {};
        end
    end
    if intervals_abilities_starts[fluffy.ability_autoshot] == nil then
        intervals_abilities_starts[fluffy.ability_autoshot] = {};
    end
    if intervals_abilities_ends[fluffy.ability_autoshot] == nil then
        intervals_abilities_ends[fluffy.ability_autoshot] = {};
    end

    -- print(fluffy.ability_arcaneshot["dmg"]());
    -- print(fluffy.ability_steadyshot["dmg"]());
    -- print("---");

    -- if fluffy.ability_autoshot["known"] and IsUsableSpell(fluffy.ability_autoshot["active_id"]) then
    --     table.insert(abilities_to_consider, fluffy.ability_autoshot);
    -- end

    -- table.insert(fluffy.ability_arcaneshot["windows_s"], 0);
    -- table.insert(fluffy.ability_arcaneshot["windows_e"], t + 5*window_len);

    
    -- local tinit = GetTime();
    -- analyze_windows_of_opportunities_cd(abilities_to_consider, t, t + 5*window_len);
    analyze_windows_of_opportunities_experimental(abilities_to_consider, 2*window_len);
    -- print(GetTime() - tinit);
    wipe(abilities_to_consider);
end
