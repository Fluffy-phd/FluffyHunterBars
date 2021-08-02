local _, fluffy = ...

FluffyHunterBarAddon = {};
-- lock/unlock, visibility, update frequency, autoshot spark, visible only in combat
FluffyHunterBarAddon.panel = CreateFrame( "Frame", "FluffyHunterBarsConfig", UIParent );
FluffyHunterBarAddon.panel.name = "Fluffy Hunter Bars";
InterfaceOptions_AddCategory(FluffyHunterBarAddon.panel);

-- Color for each ability
FluffyHunterBarAddon.colorpanel = CreateFrame( "Frame", "FluffyHunterBarsConfig_colors", FluffyHunterBarAddon.panel);
FluffyHunterBarAddon.colorpanel.name = "Colors";
FluffyHunterBarAddon.colorpanel.parent = FluffyHunterBarAddon.panel.name;
InterfaceOptions_AddCategory(FluffyHunterBarAddon.colorpanel);

-- Rotation settings, future window length, which abilities should be included in consideration and when
FluffyHunterBarAddon.rotationpanel = CreateFrame( "Frame", "FluffyHunterBarsConfig_rotations", FluffyHunterBarAddon.panel);
FluffyHunterBarAddon.rotationpanel.name = "Rotations";
FluffyHunterBarAddon.rotationpanel.parent = FluffyHunterBarAddon.panel.name;
InterfaceOptions_AddCategory(FluffyHunterBarAddon.rotationpanel);

local function create_editBox(parent_frame, w, h, offset_x, offset_y)
    local edit_box = CreateFrame("EditBox", nil, parent_frame, "InputBoxTemplate");
    edit_box:SetPoint('TOPLEFT', offset_x, offset_y);
    edit_box:SetWidth(w);
    edit_box:SetHeight(h);
    edit_box:SetMovable(false);
    edit_box:SetAutoFocus(false);
    edit_box:SetMultiLine(1);
    edit_box:SetMaxLetters(5);

    edit_box:Show();

    return edit_box;
end

local function create_text(parent_frame, w, h, offset_x, offset_y, align, text, size)
    local f2 = CreateFrame("Frame",nil,parent_frame)
    f2:SetWidth(w);
    f2:SetHeight(h);
    f2:SetAlpha(.90);
    f2:SetPoint(align, offset_x, offset_y);
    f2.text = f2:CreateFontString(nil,"ARTWORK");
    f2.text:SetFont("Fonts\\ARIALN.ttf", size, "OUTLINE");
    f2.text:SetPoint(align, 0, 0);
    f2.text:SetText(text);
    f2:Show();
end

local function create_parent_frame(parent, w, h, offset_x, offset_y)
    local frame = CreateFrame( "Frame", "FluffyHunterBarsConfig_", parent );
    frame:SetPoint('TOPLEFT', offset_x, offset_y);
    frame:SetWidth(w);
    frame:SetHeight(h);
    frame:Show();

    return frame;
end

local function create_checkbox()
end

local function create_dropdown(parent, f, w, h, offset_x, offset_y)

    local dropdown = CreateFrame("Frame", "Test_DropDown", parent, "UIDropDownMenuTemplate");
    UIDropDownMenu_Initialize(dropdown, f);

    dropdown:SetPoint('TOPLEFT', offset_x, offset_y);
    dropdown:SetWidth(w);
    dropdown:SetHeight(h);
    dropdown:Show();

    return dropdown;
end

function Visibility_DropDown_Initialize(self,level)
    local info1 = UIDropDownMenu_CreateInfo();
    info1.hasArrow = true; -- creates submenu
    info1.notCheckable = true;
    info1.text = "Hidden";
    info1.value = 0;
    UIDropDownMenu_AddButton(info1, 1);

    local info2 = UIDropDownMenu_CreateInfo();
    info2.hasArrow = true; -- creates submenu
    info2.notCheckable = true;
    info2.text = "Visible";
    info2.value = 1;
    UIDropDownMenu_AddButton(info2, 1);

    local info3 = UIDropDownMenu_CreateInfo();
    info3.hasArrow = true; -- creates submenu
    info3.notCheckable = true;
    info3.text = "Visible when in combat";
    info3.value = 2;
    UIDropDownMenu_AddButton(info3, 1);
end

function create_configuration_ui()

    -- title and description of the general settings
    local frame_general_title = create_parent_frame(FluffyHunterBarAddon.panel, 600, 100, 0, 0);
    create_text(frame_general_title, 100, 50, 0, 15, "CENTER", "|c"..fluffy.msg_color_ok.."Fluffy Hunter Bars|r (General Settings)", 25);

    -- position and size
    local frame_general_position = create_parent_frame(FluffyHunterBarAddon.panel, 600, 300, 0, -80);
    local edit_box_width = create_editBox(frame_general_position, 100, 25, 200, 0);
    create_text(frame_general_position, 100, 200, 25, 0, "TOPLEFT", "Width", 13);

    local edit_box_height = create_editBox(frame_general_position, 100, 25, 200, -35);
    create_text(frame_general_position, 100, 200, 25, -35, "TOPLEFT", "Height", 13);

    local edit_box_x = create_editBox(frame_general_position, 100, 25, 200, -70);
    create_text(frame_general_position, 100, 200, 25, -70, "TOPLEFT", "Position [X]", 13);

    local edit_box_y = create_editBox(frame_general_position, 100, 25, 200, -105);
    create_text(frame_general_position, 100, 200, 25, -105, "TOPLEFT", "Position [Y]", 13);

    local dropdown_visibility = create_dropdown(frame_general_position, Visibility_DropDown_Initialize, 100, 25, 150, -140);

end