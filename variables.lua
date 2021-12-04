local _, fluffy = ...

fluffy.is_casting_autoshot = false;

fluffy.current_addon_version = 205;
fluffy.client_version = 0;
fluffy.is_player_hunter = false;
fluffy.player_id = nil;
fluffy.update_frequency_val = 45;
fluffy.last_update = 0;
fluffy.time_loaded = 0;


fluffy.spell_id_aimed = 19434;
fluffy.spell_id_multi = 2643;
fluffy.spell_id_arcane = 3044;
fluffy.spell_id_auto = 75;
fluffy.spell_id_FD = 5384;
fluffy.spell_id_steady = 34120;
fluffy.spell_id_raptor = 2973;

-- haste buffs
fluffy.haste_id_quick_shots                             = 6150;
fluffy.haste_id_rapid_fire                              = 3045;
fluffy.haste_id_berserking                              = 20554;
fluffy.haste_id_heroism                                 = 32182;
fluffy.haste_id_bloodlust                               = 2825;
fluffy.haste_id_abacus_of_the_violent_odds              = 33807;
fluffy.haste_id_haste_potion                            = 28507;
fluffy.haste_id_hammer_haste                            = 21165;
fluffy.haste_id_dragonspine_trophy                      = 34774;
fluffy.haste_id_crowd_pummeler                          = 13494;
fluffy.haste_id_jackhammer                              = 13533;
fluffy.haste_id_drums1                                  = 35476;


-- fluffy.haste_buffs_table[buff_id] = {expiration_time, value, is_rating, type}
-- type:
-- 1 = melee
-- 2 = ranged
-- 3 = both
fluffy.haste_buffs_table = {};

fluffy.haste_buffs_table[fluffy.haste_id_quick_shots]                           = {0, 1.0, false, 2};
fluffy.haste_buffs_table[fluffy.haste_id_bloodlust]                             = {0, 1.3, false, 3};
fluffy.haste_buffs_table[fluffy.haste_id_heroism]                               = {0, 1.3, false, 3};
fluffy.haste_buffs_table[fluffy.haste_id_berserking]                            = {0, 1.1, false, 3};
fluffy.haste_buffs_table[fluffy.haste_id_rapid_fire]                            = {0, 1.4, false, 2};
fluffy.haste_buffs_table[fluffy.haste_id_haste_potion]                          = {0, 400, true, 3};
fluffy.haste_buffs_table[fluffy.haste_id_hammer_haste]                          = {0, 212, true, 3};
fluffy.haste_buffs_table[fluffy.haste_id_abacus_of_the_violent_odds]            = {0, 260, true, 3};
fluffy.haste_buffs_table[fluffy.haste_id_dragonspine_trophy]                    = {0, 325, true, 3};
fluffy.haste_buffs_table[fluffy.haste_id_crowd_pummeler]                        = {0, 500, true, 3};
fluffy.haste_buffs_table[fluffy.haste_id_jackhammer]                            = {0, 300, true, 3};
fluffy.haste_buffs_table[fluffy.haste_id_drums1]                                = {0, 80, true, 3};

-- bonuses from talents
fluffy.ranged_crit_modifier = 0;
fluffy.ranged_modifier = 1;
fluffy.melee_modifier = 1;
fluffy.multishot_modifier = 1;
fluffy.multishot_crit_bonus = 0;
fluffy.raptor_crit_bonus = 0;
fluffy.hit_bonus = 0;
fluffy.arcane_cd_reduction = 0;
fluffy.serpent_swiftness = 1;

-- ranged weapon stats
fluffy.ammo_dps = 0;
fluffy.rap = 0;
fluffy.quiver_haste = 0;
fluffy.ranged_dmg_min = 0;
fluffy.ranged_dmg_max = 0;
fluffy.ranged_dmg_avg = 0;
fluffy.ranged_base_speed = 0;
fluffy.ranged_hit = 0;
fluffy.ranged_weapon_id = 0;

-- melee weapon stats
fluffy.melee_dmg_avg_main = 0;
fluffy.main_hand_base_speed = 1;
fluffy.melee_dmg_avg_off = 0;
fluffy.off_hand_base_speed = 1;
fluffy.map = 0;
fluffy.melee_mh_weapon_id = 0;
fluffy.melee_oh_weapon_id = 0;


-- general variables for UI
fluffy.msg_color_caution = "AAE74C3C";
fluffy.msg_color_ok = "AA27AE60";
fluffy.msg_color_info = "AA3498DB";
fluffy.msg_color_error = "AAFF0000";

fluffy.bar_len_seconds = 3.4;
fluffy.movement_spark_interval = 0.5;

fluffy.spell_color_steady = "AAFC9803"; -- 252, 152, 3
fluffy.spell_color_multi = "AA0386FC"; -- 3, 134, 254
fluffy.spell_color_arcane = "AAaf7ac5"; -- 175, 122, 197 
fluffy.spell_color_raptor = "AA27ae60"; --39, 174, 96
fluffy.spell_color_melee = "AAd5d8dc"; -- 213, 216, 220
fluffy.spell_color_auto = "AAFF0000"; -- 255, 0, 0

fluffy.icon_path_auto = "Interface\\ICONS\\ability_whirlwind";
fluffy.icon_path_aimed = "Interface\\ICONS\\INV_Spear_07";
fluffy.icon_path_multi = "Interface\\ICONS\\Ability_UpgradeMoonGlaive";
fluffy.icon_path_arcane = "Interface\\ICONS\\Ability_ImpalingBolt";
fluffy.icon_path_steady = "Interface\\ICONS\\Ability_hunter_steadyshot";
fluffy.icon_path_raptor = "Interface\\ICONS\\ability_meleedamage";
fluffy.icon_path_melee = "Interface\\ICONS\\ability_meleedamage";





