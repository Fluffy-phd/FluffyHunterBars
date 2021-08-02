local _, fluffy = ...


local function print_help(msg)
	if msg ~= nil then
		if msg:len() > 0 then
			print("Error while using the |c"..fluffy.msg_color_ok.."/fluffy|r command!");
			print("'" .. msg .. "'" .. " is not a recognized option");
		end
	end

	print("Available Fluffy commands:");
	print("------------------");
	print("'|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."info|r'             prints out the current |c"..fluffy.msg_color_caution.."width|r, |c"..fluffy.msg_color_caution.."height|r and |c"..fluffy.msg_color_caution.."icon size|r");
	print("'|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."resize|r |c"..fluffy.msg_color_caution.."w h|r'    sets the UI elements to fit the specified width |c"..fluffy.msg_color_caution.."w|r and height |c"..fluffy.msg_color_caution.."h|r in pixels");
	print("'|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."icosize|r |c"..fluffy.msg_color_caution.."l|r'       sets the size of the ability icons to |c"..fluffy.msg_color_caution.."l x l|r pixels");
	print("'|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."move|r |c"..fluffy.msg_color_caution.."x y|r'      moves the UI elements along the axi with respect to offsets |c"..fluffy.msg_color_caution.."x|r and |c"..fluffy.msg_color_caution.."y|r pixels");
	print("'|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."freq|r |c"..fluffy.msg_color_caution.."n|r'          sets the refresh rate of the UI elements to |c"..fluffy.msg_color_caution.."n|r times per second");
	print("'|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."hide|r'             |c"..fluffy.msg_color_caution.."hides|r the UI elements");
	print("'|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."show|r'            |c"..fluffy.msg_color_caution.."shows|r the UI elements");
	print("'|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."reset|r'            |c"..fluffy.msg_color_caution.."resets|r the position and size of the UI element to default values");
	print("------------------");
	print("|c"..fluffy.msg_color_ok.."Furthermore you may use|r |c"..fluffy.msg_color_info.."SHIFT+CLICK|r |c"..fluffy.msg_color_ok.."to drag the UI elements around|r");
	print("'|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."lock|r'            |c"..fluffy.msg_color_caution.."prevents|r the UI elements from being draggable");
	print("'|c"..fluffy.msg_color_ok.."/fluffy|r |c"..fluffy.msg_color_info.."unlock|r'            |c"..fluffy.msg_color_caution.."allows|r the UI elements to be moved by mouse");
end



local function update_frequency()
	if fluffy.is_player_hunter == false then
		return;
	end
	if FluffyDBPC == nil then
		InitDB();
	end
	fluffy.update_frequency_val = FluffyDBPC["update"][1];
end



function fix()
	update_spell_data()
	update_frequency();
	update_visibility();
	update_size();
	update_position();
end

function print_info()
	print("|c"..fluffy.msg_color_ok.."Fluffy Hunter Bars|r [|c"..fluffy.msg_color_info.."width|r     ] = " .. FluffyDBPC["size"][1]);
	print("|c"..fluffy.msg_color_ok.."Fluffy Hunter Bars|r [|c"..fluffy.msg_color_info.."height|r    ] = " .. FluffyDBPC["size"][2]);
	print("|c"..fluffy.msg_color_ok.."Fluffy Hunter Bars|r [|c"..fluffy.msg_color_info.."icon size|r] = " .. FluffyDBPC["icosize"][1]);
end

function reset()
	if fluffy.is_player_hunter == false then
		FluffyDBPC = {};
		FluffyDBPC["hidden"] = {true};
		fix();
		return;
	end
	
	FluffyDBPC = {};
	FluffyDBPC["version"] = 1;
	FluffyDBPC["pos"] = {"CENTER", 0, 0};
	FluffyDBPC["size"] = {321, 25};
	FluffyDBPC["update"] = {45};
	FluffyDBPC["hidden"] = {false};
	FluffyDBPC["icosize"] = {25};
	FluffyDBPC["locked"] = {false};

	fix();
	
end

function purge()
	FluffyDBPC["quiver"] = {};
	FluffyDBPC["ammo"] = {};
	FluffyDBPC["ranged_weapons"] = {};

	update_ammo_stats();
	update_quiver_haste();
	update_weapon_stats();
end



SLASH_FLUFFY_BAR1 = "/fluffy";
SlashCmdList["FLUFFY_BAR"] = function(msg)
	
	if fluffy.is_player_hunter == false then
		print("'/fluffy' command disabled because this Character is not a hunter")
		return
	end
	
	local idx = 0;
	local args = {};
	local cmd = nil;
	
	for token in string.gmatch(msg, "[^%s]+") do
		if idx == 0 then
			cmd = token;
		else
			args[idx] = token;
		end
		idx = idx + 1;
	end
	
	if FluffyDBPC == nil then
		InitDB();
	end
	
	local nargs = table.getn(args);
	
	if cmd == "resize" and nargs == 2 then
		local w = tonumber(args[1]);
		local h = tonumber(args[2]);
		
		if w ~= nil and h ~= nil then
			FluffyDBPC["size"] = {w, h};
			
			update_size();
		else
			print_help(msg);
			return;
		end
	elseif cmd == "move" and nargs == 2 then
		local x = tonumber(args[1]);
		local y = tonumber(args[2]);

		if x ~= nil and y ~= nil then
			FluffyDBPC["pos"] = {FluffyDBPC["pos"][1], FluffyDBPC["pos"][2] + x, FluffyDBPC["pos"][3] + y};
			update_position();
		else
			print_help(msg);
			return;
		end
	elseif cmd == "freq" and nargs == 1 then
		local n = tonumber(args[1]);

		if n ~= nil then
			FluffyDBPC["update"] = {n};
			update_frequency();
		else
			print_help(msg);
			return;
		end
	elseif cmd == "hide" and nargs == 0 then
		FluffyDBPC["hidden"] = {true};
		update_visibility();
	elseif cmd == "info" and nargs == 0 then
		print_info();
	elseif cmd == "show" and nargs == 0 then
		FluffyDBPC["hidden"] = {false};
		update_visibility();
	elseif cmd == "lock" and nargs == 0 then
		FluffyDBPC["locked"] = {true};
		print("Fluffy Hunter Bars are now locked");
	elseif cmd == "unlock" and nargs == 0 then
		FluffyDBPC["locked"] = {false};
		print("Fluffy Hunter Bars are now unlocked");
	elseif cmd == "reset" and nargs == 0 then
		reset();
	elseif cmd == "purgedb" and nargs == 0 then
		purge();
		print("Fluffy Hunter Bars Cache cleared");
	elseif cmd == "icosize" and nargs == 1 then
		local l = tonumber(args[1]);
		
		if l ~= nil then
			FluffyDBPC["icosize"] = {l};
			
			update_size();
		else
			print_help(msg);
			return;
		end
	else
		print_help(msg);
	end
end 

local variables_frame = CreateFrame("FRAME");
variables_frame:RegisterEvent("ADDON_LOADED");
function variables_frame:OnEvent(event, name )

	fluffy.time_loaded = GetTime() + 5;

	if event == "ADDON_LOADED" and name == "FluffyHunterBars" then
		local _, _, cid = UnitClass("player");
		if cid == 3 then
			fluffy.is_player_hunter = true;
		end

		InitDB();

		if fluffy.is_player_hunter == false then 
			return;
		end
		
		fluffy.player_id = UnitGUID("player");

		if FluffyDBPC["version"] ~= fluffy.current_addon_version then
			purge();
			FluffyDBPC["version"] = fluffy.current_addon_version;
		end
	
	
		fluffy.client_version = select(4, GetBuildInfo());



		update_spell_data();
		

		create_ui();
		-- create_configuration_ui();

		update_frequency();
		update_visibility();
		update_position();
		update_size();

		update_ammo_stats();
		update_quiver_haste();
		update_weapon_stats();
		update_talent_stats();
		update_player_stats();

	end
end

variables_frame:SetScript("OnEvent", variables_frame.OnEvent);

local fluffy_frame_items = CreateFrame("Frame");
fluffy_frame_items:RegisterEvent("UNIT_INVENTORY_CHANGED");
fluffy_frame_items:SetScript("OnEvent",
    function(self, event, arg1)
		if arg1 ~= "player" then 
			return; 
		end
		local weapon_ids_current = {fluffy.melee_mh_weapon_id, fluffy.melee_oh_weapon_id, fluffy.ranged_weapon_id};

		update_spell_data();
		update_weapon_stats();
		update_ammo_stats();
		update_quiver_haste();
		update_talent_stats();

		local weapon_ids_new = {fluffy.melee_mh_weapon_id, fluffy.melee_oh_weapon_id, fluffy.ranged_weapon_id};

		if weapon_ids_new[3] ~= nil then
			if weapon_ids_current[3] ~= nil then
				if weapon_ids_new[3] ~= weapon_ids_current[3] then
					--reset ranged swing
					fluffy.ability_autoshot["fired"] = GetTime();
				end
			else
				--reset ranged swing
				fluffy.ability_autoshot["fired"] = GetTime();
			end
		end
	
		if weapon_ids_new[1] ~= nil then
			if weapon_ids_current[1] ~= nil then
				if weapon_ids_new[1] ~= weapon_ids_current[1] then
					--reset main-hand swing
					fluffy.ability_meleestrike["fired"] = GetTime();
				end
			else
				--reset main-hand swing
				fluffy.ability_meleestrike["fired"] = GetTime();
			end
		end
	
		-- analyze_game_state(fluffy.future_window_lenght);
    end
);

local fluffy_frame_buffs = CreateFrame("Frame");
fluffy_frame_buffs:RegisterEvent("UNIT_AURA");
fluffy_frame_buffs:SetScript("OnEvent",
    function(self, event, arg1)
		if arg1 ~= "player" then 
			return; 
		end

		local haste_table = fluffy.haste_buffs_table;
		for i=1, 40 do
			local _, _, _, _, _, etime, _, _, _, id = UnitBuff("player",i);

			if haste_table[id] ~= nil then
				if id == fluffy.haste_id_berserking then
					if etime > haste_table[id][1] + 0.5 then
						local player_health_ratio = UnitHealth("player") / UnitHealthMax("player");
						haste_table[id][2] = 1.1 + 0.2 * (1 - (math.max(0.4, player_health_ratio)))/0.6;
					end
				end

				haste_table[id][1] = etime;
			end
		end
    end
);

local fluffy_frame_loading = CreateFrame("Frame");

fluffy_frame_loading:RegisterEvent("PLAYER_LEAVING_WORLD");
fluffy_frame_loading:RegisterEvent("PLAYER_ENTERING_WORLD");
fluffy_frame_loading:SetScript("OnEvent",
    function(self, event)
		if event == "PLAYER_LEAVING_WORLD" then
			fluffy.time_loaded = GetTime() + 60;
		elseif event == "PLAYER_ENTERING_WORLD" then
			fluffy.time_loaded = GetTime() + 5;
		end
    end
);





