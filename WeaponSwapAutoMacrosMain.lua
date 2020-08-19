local frame = CreateFrame('frame')
frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('PLAYER_LOGOUT')
frame:RegisterEvent('EQUIPMENT_SETS_CHANGED')
frame:RegisterEvent('VARIABLES_LOADED')

-- Thanks to RCIX from Stackoverflow
local function DCtableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                DCtableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

-- Thanks to lua-users.org Wiki
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


local function CrupdateMacro(name, icon, body)
  local preexisting_id = GetMacroIndexByName(name)
  print("Crupdating")
  if preexisting_id == 0 then
    CreateMacro(name, icon, body, true)
  else
    EditMacro(preexisting_id, name, icon, body)
  end
end

local function Reload()
  local _, _, class_id = UnitClass("player")
  local spec_id = GetSpecialization()
  local config = WeaponSwapAutoMacros["config"]
  if config[class_id] then
    if config[class_id][spec_id] then
      local spec_conf = config[class_id][spec_id]
      local name = spec_conf["Name"]
      local item_names = {}

      local set1name = spec_conf["Set1Name"]
      local set1desc = spec_conf["Set1Desc"]

      local set1main_bool = spec_conf["Set1MainBool"]
      local set1main_type = spec_conf["Set1MainType"]
      local set1main_type_desc = spec_conf["Set1MainTypeDesc"]

      local set1off_bool = spec_conf["Set1OffBool"]
      local set1off_type = spec_conf["Set1OffType"]
      local set1off_type_desc = spec_conf["Set1OffTypeDesc"]

      local set2name = spec_conf["Set2Name"]
      local set2desc = spec_conf["Set2Desc"]

      local set2main_bool = spec_conf["Set2MainBool"]
      local set2main_type = spec_conf["Set2MainType"]
      local set2main_type_desc = spec_conf["Set2MainTypeDesc"]

      local set2off_bool = spec_conf["Set2OffBool"]
      local set2off_type = spec_conf["Set2OffType"]
      local set2off_type_desc = spec_conf["Set2OffTypeDesc"]
      
      
      -- Find and verify the right items for swapping
      -- Set 1 Main Hand
      local set1id = C_EquipmentSet.GetEquipmentSetID(set1name)
      if set1id then
        if set1main_bool then
          local main1id = (C_EquipmentSet.GetItemIDs(set1id))[16]
          if main1id then
            local main1name, _, _, _, _, _, main1subtype, _, main1type = GetItemInfo(main1id)
            if main1type == set1main_type then
              item_names["Set1Main"] = main1name
              print(("WeaponSwapAutoMacros: '%s' Equipment set main hand has been identified as '%s'"):format(set1name, main1name))
            else
              print(("WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in main hand. Found one of type  '%s' in the slot instead. Cancelling macro creation for %s spec."):
              format(set1name, set1main_type_desc, main1subtype,  name))
              return            
            end
          else
            print(("WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in main hand. Found an empty slot instead. Cancelling macro creation for %s spec."):
            format(set1name, set1main_type_desc, name))
            return
          end
        end
      else
        print(("WeaponSwapAutoMacros: Could not find configured equipment set with name '%s'. Cancelling macro creation for %s spec. If you want to change the name of the equipment sets, go into Interface>>Addons>>Weapon Swap Auto Macros"):
        format(set1name, name))
        return
      end

      -- Set 1 Off Hand
      local set1id = C_EquipmentSet.GetEquipmentSetID(set1name)
      if set1id then
        if set1off_bool then
          local off1id = (C_EquipmentSet.GetItemIDs(set1id))[17]
          if off1id then
            local off1name, _, _, _, _, _, off1subtype, _, off1type = GetItemInfo(off1id)
            if off1type == set1off_type then
              item_names["Set1Off"] = off1name
              print(("WeaponSwapAutoMacros: '%s' Equipment set off hand has been identified as '%s'"):format(set1name, off1name))
            else
              print(("WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in off hand. Found one of type  '%s' in the slot instead. Cancelling macro creation for %s spec."):
              format(set1name, set1off_type_desc, off1subtype,  name))
              return            
            end
          else
            print(("WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in off hand. Found an empty slot instead. Cancelling macro creation for %s spec."):
            format(set1name, set1off_type_desc, name))
            return
          end
        end
      else
        print(("WeaponSwapAutoMacros: Could not find configured equipment set with name '%s'. Cancelling macro creation for %s spec. If you want to change the name of the equipment sets, go into Interface>>Addons>>Weapon Swap Auto Macros"):
        format(set1name, name))
        return
      end

      -- Set 2 Main Hand
      local set2id = C_EquipmentSet.GetEquipmentSetID(set2name)
      if set2id then
        if set2main_bool then
          local main2id = (C_EquipmentSet.GetItemIDs(set2id))[16]
          if main2id then
            local main2name, _, _, _, _, _, main2subtype, _, main2type = GetItemInfo(main2id)
            if main2type == set2main_type then
              item_names["Set2Main"] = main2name
              print(("WeaponSwapAutoMacros: '%s' Equipment set main hand has been identified as '%s'"):format(set2name, main2name))
            else
              print(("WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in main hand. Found one of type  '%s' in the slot instead. Cancelling macro creation for %s spec."):
              format(set2name, set2main_type_desc, main2subtype,  name))
              return            
            end
          else
            print(("WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in main hand. Found an empty slot instead. Cancelling macro creation for %s spec."):
            format(set2name, set2main_type_desc, name))
            return
          end
        end
      else
        print(("WeaponSwapAutoMacros: Could not find configured equipment set with name '%s'. Cancelling macro creation for %s spec. If you want to change the name of the equipment sets, go into Interface>>Addons>>Weapon Swap Auto Macros"):
        format(set2name, name))
        return
      end


      -- Set 2 Off Hand
      local set2id = C_EquipmentSet.GetEquipmentSetID(set2name)
      if set2id then
        if set2off_bool then
          local off2id = (C_EquipmentSet.GetItemIDs(set2id))[17]
          if off2id then
            local off2name, _, _, _, _, _, off2subtype, _, off2type = GetItemInfo(off2id)
            if off2type == set2off_type then
              item_names["Set2Off"] = off2name
              print(("WeaponSwapAutoMacros: '%s' Equipment set off hand has been identified as '%s'"):format(set2name, off2name))
            else
              print(("WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in off hand. Found one of type  '%s' in the slot instead. Cancelling macro creation for %s spec."):
              format(set2name, set2off_type_desc, off2subtype,  name))
              return            
            end
          else
            print(("WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in off hand. Found an empty slot instead. Cancelling macro creation for %s spec."):
            format(set2name, set2off_type_desc, name))
            return
          end
        end
      else
        print(("WeaponSwapAutoMacros: Could not find configured equipment set with name '%s'. Cancelling macro creation for %s spec. If you want to change the name of the equipment sets, go into Interface>>Addons>>Weapon Swap Auto Macros"):
        format(set2name, name))
        return
      end

      print("Going into macro creation")
      -- Create or update all Macros
      for macro_name, macro_table in pairs(spec_conf["Macros"]) do
        print(macro_name)
        if macro_table["Active"] then
          print("Active")
          local formats = macro_table["Formats"]
          local name = macro_table["MacroName"]
          local icon_id = macro_table["IconId"]
          local filled_formats = {}
          for i, slot in ipairs(formats) do
            filled_formats[i] = item_names[slot]
          end
          local final_body = ((macro_table["Body"]):format(unpack(filled_formats))).."\n-- Created by Weapon Swap Auto Macros"
        
          CrupdateMacro(name, icon_id, final_body)
        end
      end
    end
  end
  
--      -- Build generic Weaponswap
--      local body = ([[
--/equipslot 16 %s
--/equipslot 17 %s
--/equipslot 16 %s
--  ]]):format(WeaponSwapAutoMacros["ArmsOnehanded"], WeaponSwapAutoMacros["ArmsShield"], WeaponSwapAutoMacros["ArmsTwoHanded"]) 
--      CrupdateMacro("lk_swap", 975736, body)
--  
--  
--      -- Build defense stance autoswap
--      local body = ([[
--#showtooltip
--/cast Defensive Stance
--/equipslot 16 %s
--/equipslot 17 %s
--/equipslot 16 %s
--  ]]):format(WeaponSwapAutoMacros["ArmsOnehanded"], WeaponSwapAutoMacros["ArmsShield"], WeaponSwapAutoMacros["ArmsTwoHanded"]) 
--      CrupdateMacro("lk_defensive_s", "INV_Misc_QuestionMark", body)
--  
--  
--      -- Build Mortal Strike
--      body = ([[
--#showtooltip
--/cast Mortal Strike
--/equipslot 16 %s
--  ]]):format(WeaponSwapAutoMacros["ArmsTwoHanded"]) 
--      CrupdateMacro("lk_mortal_strike", "INV_Misc_QuestionMark", body)
--  
--  
--      -- Build Cleave
--      body = ([[
--#showtooltip 
--/cast [talent:5/3] Cleave; Sweeping Strikes
--/equipslot [talent:5/3] 16 %s
--  ]]):format(WeaponSwapAutoMacros["ArmsTwoHanded"]) 
--      CrupdateMacro("lk_cleave_sweep", "INV_Misc_QuestionMark", body) --132338
--  
--  
--      -- Build Shield Block
--      body = ([[
--#showtooltip
--/cast Shield Block
--/equipslot 16 %s
--/equipslot 17 %s
--  ]]):format(WeaponSwapAutoMacros["ArmsOnehanded"], WeaponSwapAutoMacros["ArmsShield"]) 
--      CrupdateMacro("lk_shield_block", "INV_Misc_QuestionMark", body)
--  
--  
--      -- Build Shield Slam
--      body = ([[
--#showtooltip
--/cast Shield Slam
--/equipslot 16 %s
--/equipslot 17 %s
--  ]]):format(WeaponSwapAutoMacros["ArmsOnehanded"], WeaponSwapAutoMacros["ArmsShield"]) 
--      CrupdateMacro("lk_shield_slam", "INV_Misc_QuestionMark", body)

end

local function RestoreDefaults()
  if not WeaponSwapAutoMacros then
    WeaponSwapAutoMacros = {}
  end

  if not WeaponSwapAutoMacros["config"] then
    WeaponSwapAutoMacros["config"] = {}
  end
  
  WeaponSwapAutoMacros["config"] = _G["WSAM_DEFAULTS"] 
  Reload()
end


frame:HookScript('OnEvent', function(self, event, arg1, ...)
  if event == 'ADDON_LOADED' and arg1 == "WeaponSwapAutoMacros" then
    -- Load Defaults into Saved Settings for all missing entries
    if not WeaponSwapAutoMacros then
      WeaponSwapAutoMacros = {}
    end

    if not WeaponSwapAutoMacros["config"] then
      WeaponSwapAutoMacros["config"] = {}
    end
    
    WeaponSwapAutoMacros["config"] = DCtableMerge(deepcopy(_G["WSAM_DEFAULTS"]), WeaponSwapAutoMacros["config"]) 


     --Reload()
  elseif event == 'EQUIPMENT_SETS_CHANGED' then
    Reload()
  elseif event == "PLAYER_LOGOUT" then
    _G["WeaponSwapAutoMacros"] = WeaponSwapAutoMacros; 
  elseif event == "VARIABLES_LOADED" then
  
    local config = LibStub("AceConfig-3.0")
    local dialog = LibStub("AceConfigDialog-3.0")
  
    local options = {
        type = "group",
        name = "WeaponSwapAutoMacros"
    }

    options.args = {}

    options.args["RestoreDefaults"] = {
      type = "execute",
      order = 1,
      name = "Restore Default Values",
      desc = "Reset all macro monfigurations to the default values. Try this at least once if the addon throws any errors or you misconfigured it.",
      func = function()
        RestoreDefaults()
      end,
      width = 1.5,
    }

    options.args["RecreateMacros"] = {
      type = "execute",
      order = 1,
      name = "Recreate Macros",
      desc = "Create or update all macros based on the current configuration for your current spec.",
      func = function()
        RestoreDefaults()
      end,
      width = 1.5,
    }

    local MyAddon = {}
    local panelorder = 1
    -- Build Options Interface
    for class_id, specs in ipairs(WeaponSwapAutoMacros["config"]) do
      for spec_id, spec_config in ipairs(specs) do
        panelorder = panelorder + 1
        options.args[spec_config.Name] = {}
        local current_options = options.args[spec_config.Name]
        current_options.order = panelorder
        current_options.type = "group"
        current_options.name = spec_config.Name
        current_options.args = {}

        -- setting up the set names
        current_options.args.setone = {
          type = "input",
          order = 1,
          name = spec_config["Set1Desc"],
          width = "full",
          set = function(info,val) spec_config["Set1Name"]=val end,
          get = function(info) return spec_config["Set1Name"] end            
        }
        current_options.args.settwo = {
          type = "input",
          order = 2,
          name = spec_config["Set2Desc"],
          width = "full",
          set = function(info,val) spec_config["Set2Name"]=val end,
          get = function(info) return spec_config["Set2Name"] end            
        }
        
        current_options.args.macroframe = {
          order = 3,
          type = "group",
          inline = true,
          name = L["Macro Settings"],
          args = {}
        }
        local macroframe = current_options.args.macroframe

        local toggleorder = 0
        for macro_key, macro_table in pairs(spec_config["Macros"]) do
          toggleorder = toggleorder + 1
          macroframe.args[macro_key] = {
            type = "toggle",
            order = toggleorder,
            name = ("Create %s Macro"):format(macro_key),
            width = "double",
            set = function(info,val) MyAddon.enabled = val end,
            get = function(info) return MyAddon.enabled end            
          }
        end
        
      end
    end


    config:RegisterOptionsTable("WeaponSwapAutoMacros", options, {"/wsam"})
    dialog:AddToBlizOptions("WeaponSwapAutoMacros")
    
--    print("Variables Loaded")
--    local MyAddon = {};
--    MyAddon.panel = CreateFrame( "Frame", "WeaponSwapAutoMacrosOptions", UIParent );
--    -- Register in the Interface Addon Options GUI
--    -- Set the name for the Category for the Options Panel
--    MyAddon.panel.name = "Weapon Swap Auto Macros";
--    
--    local refresh_button = CreateFrame("Button","WeaponSwapAutoMacros_Button_RefreshMacros", MyAddon.panel, "UIPanelButtonTemplate")
--    refresh_button:SetPoint("TOPLEFT",10,-10)
--    refresh_button:SetWidth(110)
--    refresh_button:SetHeight(22)
--    refresh_button:SetText("Refresh Macros")
--    refresh_button:SetScript("OnClick", function(self, arg1)
--      Reload()
--    end)
--
--    local restore_defaults_button = CreateFrame("Button","WeaponSwapAutoMacros_Button_RestoreDefaults", MyAddon.panel, "UIPanelButtonTemplate")
--    restore_defaults_button:SetPoint("TOPLEFT",130,-10)
--    restore_defaults_button:SetWidth(110)
--    restore_defaults_button:SetHeight(22)
--    restore_defaults_button:SetText("Restore Defaults")
--    restore_defaults_button:SetScript("OnClick", function(self, arg1)
--      RestoreDefaults()
--    end)
--
--    local myCheckButton = CreateFrame("CheckButton", "myCheckButton_GlobalName", MyAddon.panel, "ChatConfigCheckButtonTemplate");
--    myCheckButton:SetPoint("TOPLEFT", 10, -40);
--    myCheckButton_GlobalNameText:SetText("My checkbox");
--    myCheckButton.tooltip = "This is where you place MouseOver Text.";
--    myCheckButton:SetScript("OnClick", 
--      function()
--        --do stuff
--      end
--    );
    
    
    
    
    
    
    -- Add the panel to the Interface Options
    -- InterfaceOptions_AddCategory(MyAddon.panel);
 
    
    -- Make a child panel
    --MyAddon.childpanel = CreateFrame( "Frame", "WeaponSwapAutomacrosChild", MyAddon.panel);
    --MyAddon.childpanel.name = "MyChild";
    -- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
    --MyAddon.childpanel.parent = MyAddon.panel.name;
    -- Add the child to the Interface Options
    --InterfaceOptions_AddCategory(MyAddon.childpanel);
    print("Myaddonadded")
  end    
end)


--function frame:OnEvent(event, arg1)
--  if event == 'ADDON_LOADED' and arg1 == "WeaponSwapAutoMacros" then
--    print(_G["WeaponSwapAutoMacros"])
--    Reload()
--  elseif event == 'EQUIPMENT_SETS_CHANGED' then
--    Reload()
--  elseif event == "PLAYER_LOGOUT" then
--    _G["WeaponSwapAutoMacros"] = 17; -- We've met; commit it to memory.
--  end    
--end




SLASH_LK_RELOAD1 = "/lk_reload"
SlashCmdList["LK_RELOAD"] = function()
  Reload()
end

