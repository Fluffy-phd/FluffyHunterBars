local _, fluffy = ...
local is_moving = false;


function update_visibility()
	
	if FluffyDBPC == nil then
		InitDB();
	end
	

	if FluffyDBPC["hidden"][1] then

		FluffyBar:Hide();
		FluffyBars_icon_background:Hide();

        for i=1,#FluffyBars_bars do
            FluffyBars_bars[i]:Hide();
        end
        for i=1,#FluffyBars_icons do
            FluffyBars_icons[i]:Hide();
        end
        for i=1,#FluffyBars_icon_glows do
            FluffyBars_icon_glows[i]:Hide();
        end

        for i=1,#FluffyBars_autoshotsparks do
            FluffyBars_autoshotsparks[i]:Hide();
        end
        for i=1,#FluffyBars_autoshotmovements do
            FluffyBars_autoshotmovements[i]:Hide();
        end
	else
		if fluffy.is_player_hunter == false then
			return;
		end
		

		FluffyBar:Show();
		FluffyBars_icon_background:Hide();

        for i=1,#FluffyBars_bars do
            FluffyBars_bars[i]:Hide();
        end
        for i=1,#FluffyBars_icons do
            FluffyBars_icons[i]:Hide();
        end
        for i=1,#FluffyBars_icon_glows do
            FluffyBars_icon_glows[i]:Hide();
        end

        for i=1,#FluffyBars_autoshotsparks do
            FluffyBars_autoshotsparks[i]:Hide();
        end
        for i=1,#FluffyBars_autoshotmovements do
            FluffyBars_autoshotmovements[i]:Hide();
        end

		if FluffyDBPC["icosize"][1] > 0 then
            -- for i=1,#FluffyBars_icons do
            --     FluffyBars_icons[i]:Show();
            -- end
            -- for i=1,#FluffyBars_icon_glows do
            --     FluffyBars_icon_glows[i]:Show();
            -- end
            -- FluffyBars_icon_background:Show();
        else
            FluffyBars_icon_background:Hide();
    
            for i=1,#FluffyBars_icons do
                FluffyBars_icons[i]:Hide();
            end
            for i=1,#FluffyBars_icon_glows do
                FluffyBars_icon_glows[i]:Hide();
            end
        end
	end
end

function update_position()
	if fluffy.is_player_hunter == false then
		return;
	end

	if FluffyDBPC == nil then
		InitDB();
	end

    FluffyBar:SetPoint(FluffyDBPC["pos"][1], FluffyDBPC["pos"][2], FluffyDBPC["pos"][3]);

	-- FluffyBar:SetPoint(FluffyDBPC["pos"][1], FluffyDBPC["pos"][2] + FluffyDBPC["icosize"][1], FluffyDBPC["pos"][3]);
end

function update_size()
	if fluffy.is_player_hunter == false then
		return;
	end

	if FluffyDBPC == nil then
		InitDB();
	end

	-- FluffyBar:SetSize(FluffyDBPC["size"][1] - FluffyDBPC["icosize"][1], FluffyDBPC["size"][2]);
	FluffyBar:SetSize(FluffyDBPC["size"][1], FluffyDBPC["size"][2]);

    for i=1,#FluffyBars_autoshotsparks do
        FluffyBars_autoshotsparks[i]:SetSize(fluffy.autoshot_spark_width, FluffyDBPC["size"][2] - 5);
    end
    for i=1,#FluffyBars_autoshotmovements do
        FluffyBars_autoshotmovements[i]:SetSize(1, FluffyDBPC["size"][2] - 5);
    end

    local h_ = 0;
    if fluffy.consider_melee == 0 then
        h_ = (FluffyDBPC["size"][2] - 5);
    else
        h_ = (0.5 * FluffyDBPC["size"][2] - 3.5);
    end
    for i=1,#FluffyBars_bars do
        FluffyBars_bars[i]:SetSize(1, h_);
    end

	-- local glow_scale = 1.6;

    -- FluffyBars_icon_background:SetPoint('CENTER', -FluffyDBPC["icosize"][1] + 1, -0.5*(FluffyDBPC["icosize"][1] - FluffyDBPC["size"][2]));
    -- FluffyBars_icon_background:SetSize(FluffyDBPC["icosize"][1], FluffyDBPC["icosize"][1]);

    -- for i=1,#FluffyBars_icon_glows do
    --     FluffyBars_icon_glows[i]:SetPoint("CENTER", 0, 0);
    --     FluffyBars_icon_glows[i]:SetSize(FluffyDBPC["icosize"][1]*glow_scale, FluffyDBPC["icosize"][1]*glow_scale);
    -- end

    -- for i=1,#FluffyBars_icons do
    --     FluffyBars_icons[i]:SetSize(FluffyDBPC["icosize"][1]-2, FluffyDBPC["icosize"][1]-2);
    -- end

	update_position();
	update_visibility();
end

local function update_bars(ability, left_shift_px, shift_y, fluffyBar_len, fluffyBar_len_seconds)
	local bar_min_width = 5;

    local height = 0;
    if fluffy.consider_melee ~= 0 then
        if ability == fluffy.ability_meleestrike then
            height = -0.5*(0.5 * FluffyDBPC["size"][2] - 2);
        elseif ability == fluffy.ability_raptorstrike then
            height = -0.5*(0.5 * FluffyDBPC["size"][2] - 2);
        else
            height = 0.5*(0.5 * FluffyDBPC["size"][2] - 1);
        end
    end    

    if fluffy.display_mode == 0 then
        local t = GetTime();
        local bar_idx = 1;
        local Ws = ability["windows_s"];
        local We = ability["windows_e"];
        local n = #Ws;
        local m = #ability["bars"];
    
        for i=1,min(n, m) do
            local ts = max(0, Ws[i]- t);
            local te = min(fluffyBar_len_seconds, max(0, We[i]- t));
            -- print(ability["name"] .. " -> " .. ts .. " - " .. te);
    
            if ts <= fluffyBar_len_seconds and te > 0 then
                local ps = (fluffyBar_len) * ts / fluffyBar_len_seconds;
                local pe = (fluffyBar_len) * te / fluffyBar_len_seconds;
    
                local px_start = ps;
                local px_end = pe;
                local px_width = (px_end - px_start);
                -- print(ability["name"] .. "[" .. ps .. ", " .. pe .. "]" .. "[" .. px_width .. "]");
    
                local bar = ability["bars"][bar_idx];
    
                if px_width > bar_min_width then
                    bar:SetWidth(px_width);
                    bar:SetPoint('LEFT', px_start + 3, height);
                    bar:Show();
                else
                    bar:Hide();
                end
            end

            bar_idx = bar_idx + 1;
        end        
    elseif fluffy.display_mode == 1 then
        local t = GetTime();
        local bar_idx = 1;
        local Ws = ability["windows_s"];
        local We = ability["windows_e"];
        local n = #Ws;
        local m = #ability["bars"] / 2;
        -- m = 1;
    
        -- n = min(n, 1);
    
        local mid_point = fluffyBar_len * 0.5;
    
        for i=1,min(n, m) do
            local ts = max(0, Ws[i]- t);
            local te = min(fluffyBar_len_seconds, max(0, We[i]- t));
    
            if ts <= fluffyBar_len_seconds and te > 0 then
                local ps = 0.5 * (fluffyBar_len) * ts / fluffyBar_len_seconds;
                local pe = 0.5 * (fluffyBar_len) * te / fluffyBar_len_seconds;
    
                local px_start = ps;
                local px_end = pe;
                local px_width = (px_end - px_start);
    
                local bar = ability["bars"][bar_idx];
    
                if px_width > bar_min_width then
                    bar:SetWidth(px_width);
                    bar:SetPoint('CENTER', px_start + px_width*0.5, height);
                    bar:Show();
                else
                    bar:Hide();
                end
    
                bar_idx = bar_idx + 1;
    
                px_end = -ps;
                px_start = -pe;
    
                bar = ability["bars"][bar_idx];
    
                if px_width > bar_min_width then
                    bar:SetWidth(px_width);
                    bar:SetPoint('CENTER', px_start + px_width*0.5, height);
                    bar:Show();
                else
                    bar:Hide();
                end
    
                bar_idx = bar_idx + 1;
            end
    
        end        
    end



end

local function update_autoshot_spark(idx, t, fluffyBar_len, fluffyBar_len_seconds)


    if fluffy.autoshot_tracker_hidden == 1 then
        return;
    end

    local shift_y = 0.5;

    if fluffy.display_mode == 0 then
        FluffyBars_autoshotsparks[idx]:Hide();
        FluffyBars_autoshotmovements[idx]:Hide();

        local nmax = #FluffyBars_autoshotsparks;
        if idx > nmax then
            return;
        end
    
        local auto_t = fluffy.autoshot_sparks[idx];
        local spark_bar = FluffyBars_autoshotsparks[idx];
        local movement_bar = FluffyBars_autoshotmovements[idx];
    
        local active_spark_position_seconds = auto_t - t;
        local active_spark_position = fluffyBar_len * active_spark_position_seconds / (fluffyBar_len_seconds);
    
        
        if active_spark_position_seconds <= 0 or active_spark_position_seconds > fluffyBar_len_seconds + fluffy.movement_spark_interval then
            movement_bar:Hide();
            spark_bar:Hide();
        elseif active_spark_position_seconds > fluffyBar_len_seconds then
            -- print(active_spark_position_seconds - fluffyBar_len_seconds);
            local movement_start_seconds = max(0, active_spark_position_seconds - fluffy.movement_spark_interval);
            local pixelw_auto_window = (fluffyBar_len_seconds - movement_start_seconds) * fluffyBar_len / fluffyBar_len_seconds;
            -- local empty_space = (active_spark_position_seconds - fluffyBar_len_seconds) * fluffyBar_len / fluffyBar_len_seconds;

            spark_bar:SetPoint('LEFT', fluffyBar_len + 3, shift_y - 1);
            -- spark_bar:SetWidth(0.1);
            spark_bar:Show();

            movement_bar:SetWidth(pixelw_auto_window);
            movement_bar:SetPoint('RIGHT', 0, shift_y);
            movement_bar:Show();
        else
            local movement_start_seconds = max(0, active_spark_position_seconds - fluffy.movement_spark_interval);
            local pixelw_auto_window = max(0, ((active_spark_position_seconds - movement_start_seconds) * fluffyBar_len / fluffyBar_len_seconds));
            local ps = movement_start_seconds * fluffyBar_len/ (fluffyBar_len_seconds);

            spark_bar:SetPoint('LEFT', active_spark_position + 3, shift_y - 1);
            -- spark_bar:SetWidth(fluffy.autoshot_spark_width);
            spark_bar:Show();
    
            movement_bar:SetWidth(pixelw_auto_window);
            movement_bar:SetPoint('LEFT', -pixelw_auto_window, shift_y);
            movement_bar:Show();
        end        
    elseif fluffy.display_mode == 1 then
        local nmax = #FluffyBars_autoshotsparks;
        local idx1 = 2*(idx - 1) + 1;
        local idx2 = idx1 + 1;
        if idx2 > nmax then
            return;
        end
        FluffyBars_autoshotsparks[idx1]:Hide();
        FluffyBars_autoshotmovements[idx1]:Hide();
        FluffyBars_autoshotsparks[idx2]:Hide();
        FluffyBars_autoshotmovements[idx2]:Hide();

        local auto_t = fluffy.autoshot_sparks[idx];
        local spark_bar1 = FluffyBars_autoshotsparks[idx1];
        local movement_bar1 = FluffyBars_autoshotmovements[idx1];
        local spark_bar2 = FluffyBars_autoshotsparks[idx2];
        local movement_bar2 = FluffyBars_autoshotmovements[idx2];
    
        local active_spark_position_seconds = auto_t - t;
        local active_spark_position1 = 0.5 * fluffyBar_len * active_spark_position_seconds / (fluffyBar_len_seconds);
        local active_spark_position2 = -active_spark_position1;
        
        local mshift_seconds = max(0.02, active_spark_position_seconds - fluffy.movement_spark_interval);
    
        
        if active_spark_position_seconds <= 0  or active_spark_position_seconds > fluffyBar_len_seconds then
            movement_bar1:Hide();
            movement_bar2:Hide();
    
            spark_bar1:Hide();
            spark_bar2:Hide();
        else
    
            if active_spark_position_seconds > fluffyBar_len_seconds then
                -- if mshift_seconds < fluffyBar_len_seconds then
                --     local px_start = ceil(mshift_seconds * 0.5 * fluffyBar_len / fluffyBar_len_seconds);
                --     local px_shift = ceil(fluffy.movement_spark_interval * 0.5 * fluffyBar_len / fluffyBar_len_seconds);
                --     local w = ceil(0.5 * fluffyBar_len - px_start);
                --     local p = ceil(0.5 * px_shift);
                --     -- print(0.5*fluffyBar_len - px_start);
                --     movement_bar1:SetWidth(w);
                --     movement_bar2:SetWidth(w);
                --     movement_bar1:SetPoint('CENTER', -p, 0);
                --     movement_bar2:SetPoint('CENTER',  p, 0);
                --     movement_bar1:Show();
                --     movement_bar2:Show();
                -- end
                -- spark_bar1:SetPoint('CENTER', active_spark_position1, 0);
                -- spark_bar2:SetPoint('CENTER', active_spark_position2, 0);
    
                -- spark_bar1:SetWidth(0.0001);
                -- spark_bar2:SetWidth(0.0001);
                -- spark_bar1:Show();
                -- spark_bar2:Show();
            else
                local mshift_rel = active_spark_position_seconds - mshift_seconds;
                local pixelw_auto_window = max(0, (mshift_rel * 0.5 * fluffyBar_len / fluffyBar_len_seconds));
                local p = ceil(0.5*pixelw_auto_window);
    
                movement_bar1:SetWidth(pixelw_auto_window);
                movement_bar2:SetWidth(pixelw_auto_window);
                movement_bar1:SetPoint('CENTER', -p, shift_y);
                movement_bar2:SetPoint('CENTER',  p, shift_y);
                movement_bar1:Show();
                movement_bar2:Show();
                spark_bar1:SetPoint('CENTER', active_spark_position1, shift_y - 1);
                spark_bar2:SetPoint('CENTER', active_spark_position2, shift_y - 1);
                spark_bar1:Show();
                spark_bar2:Show();
            end
    
        end
    end
end

local function sort_windows(a, b)
    return a[2] < b[2];
end

local windows_s = {};
local windows_e = {};
local function draw_intervals(fluffyBar_len_seconds, t, left_shift_px, shift_y, fluffyBar_len, fluffyBar_len_seconds)

    for i=1,#FluffyBars_bars do
        FluffyBars_bars[i]:Hide();
    end
    -- for i=1,#FluffyBars_icons do
    --     FluffyBars_icons[i]:Show();
    -- end
    -- for i=1,#FluffyBars_icon_glows do
    --     FluffyBars_icon_glows[i]:Show();
    -- end

    -- local A = fluffy.ability_autoshot;
    -- local Aws = A["windows_s"];
    -- local Awe = A["windows_e"];
    -- for i=1,#Aws do
    --     table.insert(windows_s, {A, Aw[i][1], Aw[i][2]});
    -- end

    -- A = fluffy.ability_aimedshot;
    -- Aw = A["windows"];
    -- for i=1,#Aw do
    --     table.insert(windows, {A, Aw[i][1], Aw[i][2]});
    -- end

    -- A = fluffy.ability_arcaneshot;
    -- Aw = A["windows"];
    -- for i=1,#Aw do
    --     table.insert(windows, {A, Aw[i][1], Aw[i][2]});
    -- end

    -- A = fluffy.ability_multishot;
    -- Aw = A["windows"];
    -- for i=1,#Aw do
    --     table.insert(windows, {A, Aw[i][1], Aw[i][2]});
    -- end

    -- A = fluffy.ability_steadyshot;
    -- Aw = A["windows"];
    -- for i=1,#Aw do
    --     table.insert(windows, {A, Aw[i][1], Aw[i][2]});
    -- end

    -- A = fluffy.ability_raptorstrike;
    -- Aw = A["windows"];
    -- for i=1,#Aw do
    --     table.insert(windows, {A, Aw[i][1], Aw[i][2]});
    -- end

    -- A = fluffy.ability_meleestrike;
    -- Aw = A["windows"];
    -- for i=1,#Aw do
    --     table.insert(windows, {A, Aw[i][1], Aw[i][2]});
    -- end
    -- table.sort(windows, sort_windows);


    -- if #windows < 1 then
    --     return;
    -- end

    -- local first_ability = windows[1][1];
    -- local is_glowing = false;
    
    
    -- local t = GetTime();
    -- if t >= windows[1][2] then
    --     is_glowing = true;
    -- end

    -- -- icons and their glows
    -- for i=1,#top_bar_abilities do
    --     if first_ability == top_bar_abilities[i] then
    --         top_bar_abilities[i]["icon"]:Show();

    --         if is_glowing then
    --             top_bar_abilities[i]["glow"]:Show();
    --         end
    --         break;
    --     end
    -- end
    -- for i=1,#bottom_bar_abilities do
    --     if first_ability == bottom_bar_abilities[i] then
    --         bottom_bar_abilities[i]["icon"]:Show();

    --         if is_glowing then
    --             bottom_bar_abilities[i]["glow"]:Show();
    --         end
    --         break;
    --     end
    -- end

    update_bars(fluffy.ability_autoshot, left_shift_px, shift_y, fluffyBar_len, fluffyBar_len_seconds);
    update_bars(fluffy.ability_aimedshot, left_shift_px, shift_y, fluffyBar_len, fluffyBar_len_seconds);
    update_bars(fluffy.ability_arcaneshot, left_shift_px, shift_y, fluffyBar_len, fluffyBar_len_seconds);
    update_bars(fluffy.ability_steadyshot, left_shift_px, shift_y, fluffyBar_len, fluffyBar_len_seconds);
    update_bars(fluffy.ability_raptorstrike, left_shift_px, shift_y, fluffyBar_len, fluffyBar_len_seconds);
    update_bars(fluffy.ability_meleestrike, left_shift_px, shift_y, fluffyBar_len, fluffyBar_len_seconds);
    
    
    update_bars(fluffy.ability_multishot, left_shift_px, shift_y, fluffyBar_len, fluffyBar_len_seconds);

    -- wipe(windows);
end

local function gui_MouseDown(self, button)
        
    local shift_key = IsShiftKeyDown();

    if button == "LeftButton" and not self.isMoving and shift_key == true then
        x_coord_before_moving, y_coord_before_moving = self:GetCenter();

        if FluffyDBPC["locked"][1] == true then
            print("Fluffy bars are locked! Please use '|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."unlock|r' to enable repositioning via drag&drop");
            return;
        end
    
        self:StartMoving();
        self.isMoving = true;
        is_moving = true;

    end
end

local function gui_MouseUp(self, button)
    if button == "LeftButton" and self.isMoving then
        if FluffyDBPC["locked"][1] == false then
            print("Fluffy bars are unlocked! Please consider '|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."lock|r' to disable repositioning via drag&drop");
        end

        self:StopMovingOrSizing();
        self.isMoving = false;
        is_moving = false;

        local x_coord_after_moving, y_coord_after_moving = self:GetCenter();

        local shift_x = x_coord_after_moving - x_coord_before_moving;
        local shift_y = y_coord_after_moving - y_coord_before_moving;

        FluffyDBPC["pos"][2] = FluffyDBPC["pos"][2] + shift_x;
        FluffyDBPC["pos"][3] = FluffyDBPC["pos"][3] + shift_y;
    end
end

local function gui_Hide(self, button)
    if ( self.isMoving ) then
        self:StopMovingOrSizing();
        self.isMoving = false;

        local x_coord_after_moving, y_coord_after_moving = self:GetCenter();

        local shift_x = x_coord_after_moving - x_coord_before_moving;
        local shift_y = y_coord_after_moving - y_coord_before_moving;

        FluffyDBPC["pos"][2] = FluffyDBPC["pos"][2] + shift_x;
        FluffyDBPC["pos"][3] = FluffyDBPC["pos"][3] + shift_y;
    end
end

local function gui_Update(self, elapsed)
    
    if fluffy.is_player_hunter == false or FluffyDBPC["hidden"][1] == true or is_moving == true then
        return;
    end

    local t = GetTime();
    if (fluffy.update_frequency_val * (t - fluffy.last_update) < 1) or (fluffy.time_loaded > t) then
        return;
    end

    fluffy.last_update = t;
    update_spell_data();
    -- update_size();
    -- update_weapon_stats();

    fluffy.bar_len_seconds = fluffy.future_window_lenght;
    analyze_game_state(fluffy.future_window_lenght);
    
    local fluffyBar_len = FluffyDBPC["size"][1] - 6;

    local speed, _, _, _, _, _ = UnitRangedDamage("player");
    local fluffyBar_base_height = FluffyDBPC["size"][2];
    
    local shift_top = -3;
    local shift_bottom = 3;
    local left_shift_px = 3;

    local n_sparks = table.getn(fluffy.autoshot_sparks);
    -- n_sparks = 2;
    for i=1,min(n_sparks, #FluffyBars_autoshotsparks) do
        update_autoshot_spark(i, t, fluffyBar_len, fluffy.bar_len_seconds);
    end

    draw_intervals(fluffyBar_len_seconds, t, left_shift_px, shift_top, fluffyBar_len, fluffy.bar_len_seconds);
end



function create_ui()
    
    create_main_bar();
    create_icon_anchor();
    local nbars = 16;

    
    create_autoshotTrackers(nbars);

    local align = 'CENTER';
    create_bars(fluffy.ability_autoshot, align, nbars, fluffy.color_autoshot[1], fluffy.color_autoshot[2], fluffy.color_autoshot[3], fluffy.color_autoshot[4]);
    -- create_bars(fluffy.ability_aimedshot, align, nbars, fluffy.color_aimedshot[1], fluffy.color_aimedshot[2], fluffy.color_aimedshot[3], fluffy.color_aimedshot[4]);
    create_bars(fluffy.ability_arcaneshot, align, nbars, fluffy.color_arcaneshot[1], fluffy.color_arcaneshot[2], fluffy.color_arcaneshot[3], fluffy.color_arcaneshot[4]);
    create_bars(fluffy.ability_multishot, align, nbars, fluffy.color_multishot[1], fluffy.color_multishot[2], fluffy.color_multishot[3], fluffy.color_multishot[4]);
    create_bars(fluffy.ability_steadyshot, align, nbars, fluffy.color_steadyshot[1], fluffy.color_steadyshot[2], fluffy.color_steadyshot[3], fluffy.color_steadyshot[4]);
    create_bars(fluffy.ability_raptorstrike, align, nbars, fluffy.color_raptorstrike[1], fluffy.color_raptorstrike[2], fluffy.color_raptorstrike[3], fluffy.color_raptorstrike[4]);
    create_bars(fluffy.ability_meleestrike, align, nbars, fluffy.color_meleestrike[1], fluffy.color_meleestrike[2], fluffy.color_meleestrike[3], fluffy.color_meleestrike[4]);

    -- create_icon(fluffy.ability_autoshot, fluffy.icon_path_auto, 255, 0, 0, 1);
    -- create_icon(fluffy.ability_aimedshot, fluffy.icon_path_aimed, 255, 0, 0, 1);
    -- create_icon(fluffy.ability_arcaneshot, fluffy.icon_path_arcane, 255, 0, 0, 1);
    -- create_icon(fluffy.ability_multishot, fluffy.icon_path_multi, 255, 0, 0, 1);
    -- create_icon(fluffy.ability_steadyshot, fluffy.icon_path_steady, 255, 0, 0, 1);
    -- create_icon(fluffy.ability_raptorstrike, fluffy.icon_path_raptor, 255, 0, 0, 1);
    -- create_icon(fluffy.ability_meleestrike, fluffy.icon_path_melee, 255, 0, 0, 1);
    
    local x_coord_before_moving = 0;
    local y_coord_before_moving = 0;
    FluffyBar:SetScript("OnMouseDown", gui_MouseDown);
    
    FluffyBar:SetScript("OnMouseUp", gui_MouseUp);
    
    FluffyBar:SetScript("OnHide", gui_Hide);
    
    FluffyBar:SetScript("OnUpdate", gui_Update);
end

local frame_combat_hidden = CreateFrame("Frame","CombatTracker", UIParent);
frame_combat_hidden:SetScript("OnUpdate", 

    function(self, elapsed)

        local t = GetTime();
        if (fluffy.update_frequency_val * (t - fluffy.last_update) < 2) then
            return;
        end
    
        if fluffy.show_only_in_combat == 1 and not UnitAffectingCombat("player") then
            FluffyBar:Hide();
        else
            FluffyBar:Show();
        end
    
    end

);
frame_combat_hidden:Show();
