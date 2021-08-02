local _, fluffy = ...

local update_interval_seconds = 0.1;
local last_update = 0;

fluffy.autoshot_sparks = {};


-- local final_rotation_indices = {};
-- local final_rotation_t = {};
-- local final_rotation_A = {};


-- local function get_triggered_cooldown(A1, A2, t)
--     local ts_triggered_cooldown = 0;
-- 	if fluffy.client_version > 11307 then
--         if A1 == fluffy.ability_aimedshot and A2 == fluffy.ability_autoshot then
--             ts_triggered_cooldown = t + A2["cdb"](t);
--         elseif A1 == fluffy.ability_raptorstrike and A2 == fluffy.ability_meleestrike then
--             ts_triggered_cooldown = t + A2["cdb"](t);
--         elseif A1 == fluffy.ability_meleestrike and A2 == fluffy.ability_raptorstrike then
--             ts_triggered_cooldown = t + A1["cdb"](t);
--         elseif A1 == A2 then
--             ts_triggered_cooldown = t + A1["cdb"](t);
--         end
--     else
--         if A1 == fluffy.ability_aimedshot and A2 == fluffy.ability_arcaneshot then
--             ts_triggered_cooldown = t + A2["cdb"](t);
--         elseif A1 == fluffy.ability_arcaneshot and A2 == fluffy.ability_aimedshot then
--             ts_triggered_cooldown = t + A2["cdb"](t);
--         elseif A1 == fluffy.ability_raptorstrike and A2 == fluffy.ability_meleestrike then
--             ts_triggered_cooldown = t + A2["cdb"](t);
--         elseif A1 == fluffy.ability_meleestrike and A2 == fluffy.ability_raptorstrike then
--             ts_triggered_cooldown = t + A1["cdb"](t);
--         elseif A1 == A2 then
--             ts_triggered_cooldown = t + A1["cdb"](t);
--         end
--     end	

--     return ts_triggered_cooldown;
-- end

-- local function get_cast_delay(A, ts, A_ref, ts_ref)

--     local gcd = (ts_ref + 1.5) * A["gcd"] * A_ref["gcd"];
--     local ts_triggered_cooldown = get_triggered_cooldown(A_ref, A, ts_ref + A_ref["cast"](ts_ref));
--     local te_ref = max(ts_triggered_cooldown, max(ts_ref + A_ref["cast"](ts_ref), gcd));

--     return max(te_ref - ts, 0);
-- end

-- local t_ends_tmp = {};
-- local damage_tmp = {};
-- local function get_expected_dps(A, ts, t_init)
--     local t_start = ts;
--     local t_end = ts + A["cast"](ts);

--     local shift = 0;
--     local n_ref = #final_rotation_indices;
--     local i;
--     local A_tmp;
--     local te_tmp;

--     t_ends_tmp[A] = t_end;
--     for j=1, n_ref do
--         i = final_rotation_indices[j];
--         A_tmp = final_rotation_A[i];
--         te_tmp = t_ends_tmp[A_tmp];
--         if te_tmp == nil then
--             t_ends_tmp[A_tmp] = final_rotation_t[i] + A_tmp["cast"](final_rotation_t[i]);
--         else
--             t_ends_tmp[A_tmp] = max(te_tmp, final_rotation_t[i] + A_tmp["cast"](final_rotation_t[i]));
--         end
--         damage_tmp[A_tmp] = 0;
--     end
--     damage_tmp[A] = A["dmg"]();
--     -- print("[T]" .. t_ends_tmp[A] - t_init .. " vs. " .. t_end - t_init);
    
--     for j=1, n_ref do
--         i = final_rotation_indices[j];
--         A_tmp = final_rotation_A[i];
--         damage_tmp[A_tmp] = damage_tmp[A_tmp] + A_tmp["dmg"]();
--     end

--     local ref_idx = n_ref + 1;
--     for j=1, n_ref do
--         i = final_rotation_indices[j];
--         if t_start <= final_rotation_t[i] + 0.0005 then
--             ref_idx = j;
--             break;
--         end
--     end

--     local A_prev = A;
--     local A_ref;
--     local ts_ref;
--     local gcd;
--     local ts_triggered_cooldown;
--     local ts_ref_new;
--     for j=ref_idx, n_ref do
--         i = final_rotation_indices[j];

--         A_ref = final_rotation_A[i];

--         ts_ref = final_rotation_t[i];
--         gcd = (t_start + 1.5) * A_prev["gcd"] * A_ref["gcd"];
--         ts_triggered_cooldown = get_triggered_cooldown(A_prev, A_ref, t_end);




--         ts_ref_new = max(ts_triggered_cooldown, max(ts_ref, max(gcd, t_end)));
--         -- print("[C]" .. A_ref["name"] .. "[ " .. ts_ref - t_init .. "] -> [" .. ts_ref_new - t_init .. "]")

--         -- print("[A]" .. A["name"] .. " at " .. ts - GetTime() .. " Delaying " .. A_ref["name"] .. " by " .. ts_ref_new - ts_ref .. " [s]");
--         A_prev = A_ref;
--         t_start = ts_ref_new;
--         t_end = ts_ref_new + A_ref["cast"](ts_ref_new);

--         t_ends_tmp[A_ref] = max(t_ends_tmp[A_ref], t_end);
--     end

--     local global_duration = t_end - t_init;
--     if global_duration < 60 then
--         global_duration = 60;
--     elseif global_duration < 120 then
--         global_duration = 120;
--     elseif global_duration < 180 then
--         global_duration = 180;
--     elseif global_duration < 240 then
--         global_duration = 240;
--     elseif global_duration < 300 then
--         global_duration = 300;
--     end

--     local dps = 0;
--     local t2_duration;
--     local dmg;
--     local t_tmp;
--     for k, v in pairs(damage_tmp) do
--         t2_duration = global_duration - (t_ends_tmp[k] - t_init) - k["cdb"](ts);
--         dmg = (v + t2_duration * k["dps"](t_init));
--         t_tmp = global_duration;
--         -- dmg = v + 0.005 * k["dps"](t_init);
--         -- t_tmp = t_ends_tmp[k] - t_init + 0.005;
--         dps = dps +  dmg / t_tmp;
--         -- print("[X]" .. k["name"] .. " : " .. (t_ends_tmp[k]).. " [s], dps: " .. dmg / t_tmp);
--     end

--     while #t_ends_tmp > 0 do
--         table.remove(t_ends_tmp);
--     end
--     while #damage_tmp > 0 do
--         table.remove(damage_tmp);
--     end

--     -- print("[R]" .. dps .. " dps");
--     wipe(t_ends_tmp);
--     wipe(damage_tmp);
--     return dps;
-- end

-- local function shift_final_rotation(idx_ref, ts, A)

--     local t_start = ts;
--     local t_end = ts + A["cast"](ts);

--     local shift = 0;
--     local n_ref = #final_rotation_indices;

--     -- print("[X]" .. idx_ref .. "/" .. n_ref);

--     local A_prev = A;
--     for j=idx_ref, n_ref do
--         local i = final_rotation_indices[j];

--         local A_ref = final_rotation_A[i];

--         local ts_ref = final_rotation_t[i];
--         local gcd = (t_start + 1.5) * A_prev["gcd"] * A_ref["gcd"];
--         local ts_triggered_cooldown = get_triggered_cooldown(A_prev, A_ref, t_end);

--         local ts_ref_new = max(ts_triggered_cooldown, max(ts_ref, max(gcd, t_end)));

--         local delay_ref = ts_ref_new - ts_ref;
--         -- if delay_ref <= 0.0005 then
--         --     break;
--         -- end
--         final_rotation_t[i] = ts_ref_new;

--         A_prev = A_ref;
--         t_start = ts_ref_new;
--         t_end = ts_ref_new + A_ref["cast"](ts_ref_new);
--     end

--     -- print(A["name"] .. " -> " .. ts - GetTime());
--     -- for j = 1,n_ref do
--     --     local i = final_rotation_indices[j];
--     --     print(final_rotation_A[i]["name"] .. " -> " .. final_rotation_t[i] - GetTime());
--     -- end
-- end

-- local function sort_rotation(a, b) 
--     return final_rotation_t[a] < final_rotation_t[b]; 
-- end

-- local function update_rotation(A, ts)
--     local n_final = #final_rotation_indices;

--     local ref_idx = 1;
--     local shift = 0;
--     local shift_ref = 0;
--     local dms_gain_max = 0;
--     local dmg_gain_tmp = 0;
--     local t_delay = 0;
    
--     dms_gain_max = get_expected_dps(A, ts, ts);
--     local delay_opti = 0;
--     local idx_ref_update = 1;

--     if n_final > 0 then
--         if ts > final_rotation_t[final_rotation_indices[n_final]] then
--             idx_ref_update = n_final + 1;
--         else
--             for i = 1, n_final do
--                 local j = final_rotation_indices[i];
--                 local ts_ref = final_rotation_t[j];
--                 if ts_ref < ts then
--                     idx_ref_update = i + 1;
--                 end
--             end
--         end
--     else
--         idx_ref_update = n_final + 1;
--     end
--     -- print("  " .. A["name"] .. " : " .. dms_gain_max .. " at time " .. ts - GetTime() .. " idx: " .. idx_ref_update);

--     for j = 1, n_final do
--         local i = final_rotation_indices[j];
--         t_delay = get_cast_delay(A, ts, final_rotation_A[i], final_rotation_t[i]);
--         dmg_gain_tmp = get_expected_dps(A, ts + t_delay, ts);
--         -- print("  " .. A["name"] .. " : " .. dmg_gain_tmp .. " at time " .. t_delay + ts - GetTime() .. " idx: " .. j + 1);

--         if dmg_gain_tmp > dms_gain_max then
--             dms_gain_max = dmg_gain_tmp;
--             delay_opti = t_delay;
--             idx_ref_update = j + 1;
--         end
--     end

--     ts = ts + delay_opti;

--     -- print("CASTING " .. A["name"] .. " at " .. ts - GetTime() .. ", first updated index: " .. idx_ref_update);

--     shift_final_rotation(idx_ref_update, ts, A);

--     -- ok
    
--     table.insert(final_rotation_indices, n_final + 1);
--     table.insert(final_rotation_t, ts);
--     table.insert(final_rotation_A, A);
--     table.sort(final_rotation_indices, sort_rotation);
--     -- collectgarbage();
--     return ts;
-- end

-- local function find_point_of_equilibrium(ordered_index, nsteps)
--     local t_init = final_rotation_t[final_rotation_indices[1]];
--     local global_index = table.remove(final_rotation_indices, ordered_index);
--     local A = final_rotation_A[global_index];
--     local ts = final_rotation_t[global_index];

--     local t_equi = 0;
--     local t_delay;
--     local ts_ref;
--     local A_ref;

--     local dps_ref = get_expected_dps(A, ts, t_init);

--     if ordered_index <= #final_rotation_indices then
--         local i = final_rotation_indices[ordered_index];
--         ts_ref = final_rotation_t[i];
--         A_ref = final_rotation_A[i];

--         if A_ref == A then
--             t_equi = ts_ref;
--         else
--             t_delay = get_cast_delay(A, ts, A_ref, ts_ref);
--             local dps_tmp = get_expected_dps(A, ts + t_delay, t_init);
    
--             if dps_tmp >= dps_ref then
    
--                 t_equi = ts_ref;
    
--             else
--                 dps_ref = dps_tmp;
    
--                 local t1 = ts;
--                 local t2 = ts_ref;
    
--                 while nsteps > 0 do
--                     t_equi = (t1 + t2) * 0.5;
--                     dps_tmp = get_expected_dps(A, t_equi, t_init);
    
--                     if dps_tmp > dps_ref then
--                         t1 = t_equi;
--                     else
--                         t2 = t_equi;
--                     end
    
--                     nsteps = nsteps - 1;
--                 end
--             end
--         end
--     else
--         t_equi = ts + 0.5;
--     end

--     table.insert(final_rotation_indices, ordered_index, global_index);
--     return t_equi;
-- end

-- -- defines the intervals of oppportunities for each ability
-- local function update_intervals(nsteps)
--     local Ws;
--     local We;
--     local ts;
--     local te;
--     local limit = 3;

--     for j = 1,min(#final_rotation_indices, limit) do
--         local i = final_rotation_indices[j];
--         Ws = final_rotation_A[i]["windows_s"];
--         We = final_rotation_A[i]["windows_e"];
--         ts = final_rotation_t[i];
--         te = find_point_of_equilibrium(j, nsteps);

--         -- print("[R]" .. final_rotation_A[i]["name"] .. ": " .. ts - GetTime() .. " - " .. te - GetTime());

--         table.insert(Ws, ts);
--         table.insert(We, te);
--     end
-- end

-- local function analyze_windows_of_opportunities(abilities, t_start, t_end)

--     -- local ability_priority = calculate_ability_priority(abilities, t_start);
--     -- wipe(clumped_up_rotation);
--     local n = #abilities;
--     local A;

--     for i=1,n do
--         A = abilities[i];

--         local ts = t_start + A["cd"](t_start);
--         if ts < t_start-A["cast"](ts) then
--             ts = t_start;
--         end
--         ts = update_rotation(A, ts);

--         ts = ts + A["cast"](ts);
--         ts = ts + A["cdb"](ts);
--         while ts < t_end do
--             ts = update_rotation(A, ts);
--             ts = ts + A["cast"](ts);
--             ts = ts + A["cdb"](ts);
--         end
--     end

--     update_intervals(8);

--     wipe(final_rotation_indices);
--     wipe(final_rotation_t);
--     wipe(final_rotation_A);
-- end
local recommendation_tolerance = 2.5;

local function get_point_of_equilibrium_autoshot(A, t)
    local cast_A = A["cast"](t);
    local cd_A = A["cdb"](t);

    local cast_auto = fluffy.ability_autoshot["cast"](t);
    local eWS = fluffy.ability_autoshot["cdb"](t) + cast_auto;

    local d_A = A["dmg"]();
    local d_auto = fluffy.ability_autoshot["dmg"]();

    local alpha = recommendation_tolerance;

    local p_auto = d_auto / eWS;
    local p_A = d_A / (cd_A + cast_A);

    -- local coeff = max(-cast_auto, cast_auto * (alpha - 1) - alpha * cd_A);
    local coeff = -cast_auto;

    return (alpha * cast_A * d_auto + d_A * coeff) / (alpha * d_auto + d_A);
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

                if j > 1 then
                    f = -get_point_of_equilibrium_autoshot(A, intervals_autoshot_ends[j - 1]);
                else
                    f = -get_point_of_equilibrium_autoshot(A, auto_ts);
                end
				

                local new_ts_1 = ts;
                local new_te_1 = min(auto_ts + f, te);

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

-- local function optimize_intervals_abilities(A, B)
	
-- 	local dmg_A = A["dmg"]();
-- 	local dmg_B = B["dmg"]();
-- 	local cast_A = 1.5;
-- 	local cast_B = 1.5;
	
-- 	local f = get_point_of_equilibrium(dmg_A, dmg_B, cast_A, cast_B);
	
-- 	-- intervals in A limit the intervals in B
-- 	-- we limit only the ends of intervals for now
-- 	if f < 0 then
-- 		return false; --no changes to intervals have been performed
-- 	end

-- 	local intervals_start_A = intervals_abilities_starts[A];
-- 	local intervals_end_A   =   intervals_abilities_ends[A];
-- 	local intervals_start_B = intervals_abilities_starts[B];
-- 	local intervals_end_B   =   intervals_abilities_ends[B];
	
-- 	local n_A = #intervals_start_A;
-- 	local n_B = #intervals_start_B;
	
-- 	local out = false;
-- 	-- for each interval in B, we find the closest interval in A further in time and clip the end of B if necessary
-- 	for i =1, n_B do
-- 		local te_B = intervals_end_B[i];
-- 		cast_B = 1.5;
-- 		local ts_A_ref = 0;
		
-- 		for j = 1, n_A do
-- 			local ts_A = intervals_start_A[j];
-- 			if ts_A > te_B then
-- 				if ts_A_ref < 0.005 then
-- 					ts_A_ref = ts_A;
-- 				else
-- 					ts_A_ref = min(ts_A_ref, ts_A);
-- 				end
-- 			end
-- 		end
		
-- 		if ts_A_ref > 0 then
-- 			cast_A = 1.5;
-- 			local f_BA = get_point_of_equilibrium(dmg_B, dmg_A, cast_B, cast_A);
-- 			if f_BA < 0 then
-- 				intervals_end_B[i] = te_B + f_BA;
-- 				out = true;
-- 			end
-- 		end
-- 	end
	
-- 	return out;
-- end

-- local function clip_intervals_abilities(A, B)
	
-- 	local dmg_A = A["dmg"]();
-- 	local dmg_B = B["dmg"]();
-- 	local cast_A = 1.5;
-- 	local cast_B = 1.5;
	
-- 	local f = get_point_of_equilibrium(dmg_A, dmg_B, cast_A, cast_B);
	
-- 	if f < 0 then
-- 		return;
-- 	end
-- 	-- intervals in A limit the intervals in B

-- 	local intervals_start_A = intervals_abilities_starts[A];
-- 	local intervals_end_A   =   intervals_abilities_ends[A];
-- 	local intervals_start_B = intervals_abilities_starts[B];
-- 	local intervals_end_B   =   intervals_abilities_ends[B];
	
-- 	local n_A = #intervals_start_A;
-- 	local n_B = #intervals_start_B;
	
-- 	local out = false;
-- 	-- for each interval in B, we find the closest interval in A earlier in time and clip the start of B if necessary
-- 	for i =1, n_B do
-- 		local ts_B = intervals_start_B[i];
-- 		local te_B = intervals_end_B[i];
-- 		cast_B = 1.5;
-- 		local te_A_ref = te_B + 1;
		
-- 		for j = 1, n_A do
-- 			local te_A = intervals_end_A[j];
-- 			if te_A > ts_B and te_A < te_B then
-- 				te_A_ref = min(te_A_ref, te_A);
-- 			end
-- 		end
-- 		if te_A_ref < te_B then
-- 			intervals_start_B[i] = te_A_ref;
-- 		end
-- 	end
-- end

-- local function optimize_intervals()
-- 	local out = false;
	
-- 	for A, _ in pairs(intervals_abilities_starts) do
-- 		for B, _ in pairs(intervals_abilities_starts) do
-- 			if A ~= B then
-- 				local out_tmp = optimize_intervals_abilities(A, B);
-- 				if out_tmp == true then
-- 					out = true;
-- 				end
-- 			end
-- 		end
-- 	end
	
-- 	return out;
-- end

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

    if fluffy.is_player_hunter == false or fluffy.ranged_weapon_id == 0 then
		return;
	end    

    local t = GetTime();
    if  fluffy.update_frequency_val * (t - last_update) < 1 then
        return;
    end
    last_update = t;
    -- local name, text, texture, startTime, endTime, isTradeSkill, castID, spellID = CastingInfo();
    -- if name ~= nil then
    --     print(startTime/1000 - fluffy.cast_finishes, endTime/1000 - fluffy.cast_finishes);
    -- end
    
    update_player_stats();

	local t = GetTime();
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


    local spell, _, _, _, endTime = UnitCastingInfo("player");
    if spell then
        -- print(UnitCastingInfo("player"));
        fluffy.cast_finishes = max(fluffy.cast_finishes, endTime * 0.001);
    end

    local autoshot_shift = fluffy.ability_autoshot["next_start"];
    if autoshot_shift < t - 1.0*(fluffy.ability_autoshot["cast"](autoshot_shift) + fluffy.ability_autoshot["cdb"](autoshot_shift)) then
        autoshot_shift = t;
    end
    autoshot_shift = max(fluffy.cast_finishes, max(autoshot_shift, fluffy.autoshot_delay));
    if (IsPlayerMoving() or IsFalling()) then
        last_time_moved = t;
    end
    autoshot_shift = autoshot_shift + fluffy.ability_autoshot["cast"](autoshot_shift);
    autoshot_shift = max(autoshot_shift, last_time_moved + fluffy.movement_spark_interval);
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
