local _, fluffy = ...

FluffyBar = CreateFrame("Frame","FluffyBar",UIParent);
FluffyBars_icon_background = CreateFrame("Frame","FluffyBarIconBackground",FluffyBar);

FluffyBars_autoshotsparks = {};
FluffyBars_autoshotmovements = {};
FluffyBars_icon_glows = {};
FluffyBars_icons = {};
FluffyBars_bars = {};

function create_main_bar()
    if fluffy.client_version > 11307 then
        FluffyBar = CreateFrame("Frame","FluffyBar",UIParent, "BackdropTemplate");
    else
        FluffyBar = CreateFrame("Frame","FluffyBar",UIParent);
    end
    FluffyBar:SetFrameStrata("BACKGROUND");
    FluffyBar:SetWidth(100); 
    FluffyBar:SetHeight(100);
    FluffyBar:SetPoint("CENTER",0,0);
    local backdropInfo = {
        bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 6,
        edgeSize = 7,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    }
    FluffyBar:SetBackdrop(backdropInfo);
    FluffyBar:SetMovable(true);
    FluffyBar:EnableMouse(true);
end

function create_icon_anchor()
    FluffyBars_icon_background:SetFrameStrata("BACKGROUND");
    FluffyBars_icon_background:SetPoint("CENTER",0,0);
end

function create_autoshotTrackers(nbars)
    local r1 = fluffy.autoshot_spark_color[1]/255;
    local g1 = fluffy.autoshot_spark_color[2]/255;
    local b1 = fluffy.autoshot_spark_color[3]/255;
    local a1 = fluffy.autoshot_spark_color[4];

    local r2 = fluffy.forbidden_movement_bar_color[1]/255;
    local g2 = fluffy.forbidden_movement_bar_color[2]/255;
    local b2 = fluffy.forbidden_movement_bar_color[3]/255;
    local a2 = fluffy.forbidden_movement_bar_color[4];

    for i = 1,nbars do
        FluffyBarAutoshotSpark = CreateFrame("Frame","FluffyBarAutoshotSpark",FluffyBar);
        FluffyBarAutoshotSpark:SetPoint("CENTER",0,0);
        local t = FluffyBarAutoshotSpark:CreateTexture("AutoSparkTex","OVERLAY")
        t:SetColorTexture(r1, g1, b1, a1);
        t:SetAllPoints(FluffyBarAutoshotSpark)
        FluffyBarAutoshotSpark.texture = t
    
        table.insert(FluffyBars_autoshotsparks, FluffyBarAutoshotSpark);
    
        frame = CreateFrame("Frame","FluffyBarAutoshotMovementBar",FluffyBarAutoshotSpark);
        frame:SetPoint("CENTER",0,0);
        local t = frame:CreateTexture("AutoshotMovTex","OVERLAY")
        t:SetColorTexture(r2, g2, b2, a2);
        t:SetAllPoints(frame)
        frame.texture = t
    
        table.insert(FluffyBars_autoshotmovements, frame);
    end

end

function create_bars(ability, align, nbars, r, g, b, a)
    ability["align"] = align;

    for i=1,nbars do
        frame = CreateFrame("Frame","FluffyBarAbility", FluffyBar);
        frame:SetPoint(align,0,0);
        local t = frame:CreateTexture("AbilityTex","ARTWORK")
        t:SetColorTexture(r/255, g/255, b/255, a);
        t:SetAllPoints(frame)
        frame.texture = t
    
        table.insert(ability["bars"], frame);
        table.insert(FluffyBars_bars, frame);
    end
end

function create_icon(ability, icon_path, r, g, b, a)
    frame_icon = CreateFrame("Frame","FluffyBarsIcon",FluffyBars_icon_background);
    frame_icon:SetPoint("CENTER",0,0);
    local t = frame_icon:CreateTexture(nil,"OVERLAY");
    t:SetTexture(icon_path, false);
    t:SetTexCoord(0.075, 0.925, 0.075, 0.925);
    t:SetAllPoints(frame_icon)
    frame_icon.texture = t

    table.insert(FluffyBars_icons, frame_icon);
    ability["icon"] = frame_icon;

    
    frame_glow = CreateFrame("Frame","FluffyBarsIconGlow",frame_icon);
    frame_glow:SetPoint("CENTER",0,0);
    local tg = frame_glow:CreateTexture(nil,"OVERLAY");
    tg:SetTexture("Interface\\SpellActivationOverlay\\IconAlert", false);
    tg:SetColorTexture(r, g, b, a);
    tg:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625);
    tg:SetAllPoints(frame_glow)
    frame_glow.texture = tg

    table.insert(FluffyBars_icon_glows, frame_glow);
    ability["glow"] = frame_glow;
end