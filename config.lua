local _, fluffy = ...

--[[
    BAR COLORS: {red [0 - 255], green[0 - 255], blue[0 - 255], alpha[0 - 1]}
--]]
fluffy.color_autoshot = {255, 0, 0, 0.0};
fluffy.color_arcaneshot = {175, 122, 197, 0.9};
fluffy.color_multishot = {3, 134, 254, 0.9};
fluffy.color_steadyshot = {252, 152, 3, 0.9};
fluffy.color_raptorstrike = {39, 174, 96, 0.9};
fluffy.color_meleestrike = {213, 216, 220, 0.9};

-- autoshot tracker, width in pixels
fluffy.autoshot_spark_width = 2;
-- {red [0 - 255], green[0 - 255], blue[0 - 255], alpha[0 - 1]}
fluffy.autoshot_spark_color = {255, 255, 255, 1};
-- {red [0 - 255], green[0 - 255], blue[0 - 255], alpha[0 - 1]}
fluffy.forbidden_movement_bar_color = {255, 0, 0, 0.25};
-- 0: shown, 1: hidden
fluffy.autoshot_tracker_hidden = 0;

-- visibility

--[[
    WHICH ABILITIES TO CONSIDER AND WHEN
    0: never
    1: always
--]]
fluffy.consider_arcaneshot = 1;
fluffy.consider_multishot = 1;
fluffy.consider_steadyshot = 1;
fluffy.consider_melee = 1;

--[[
    DISPLAY STYLE

    0: suggestions flow from right to left
    1: suggestions flow from the sides to the center
--]]

fluffy.display_mode = 0;

--[[
    WHEN VISIBLE
    0: shows the bars according to the settings (either shown or hidden all the time)    
    1: shows the bars only in combat when the settings is set to visible
--]]
fluffy.show_only_in_combat = 0;

--[[
    HOW FAR INTO THE FUTURE WE LOOK FOR TEH RECOMMENDATIONS CHOICES  [SECONDS]  
--]]
fluffy.future_window_lenght = 3;

