local frame = CreateFrame('frame')
frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('PLAYER_LOGOUT')
frame:RegisterEvent('EQUIPMENT_SETS_CHANGED')
frame:RegisterEvent('VARIABLES_LOADED')
frame:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')



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


-- Create or update an existing macro by name
local function CrupdateMacro(name, icon, body)
  local preexisting_id = GetMacroIndexByName(name)
  if preexisting_id == 0 then
    CreateMacro(name, icon, body, true)
  else
    EditMacro(preexisting_id, name, icon, body)
  end
end


-- Recreate all Macros. Mostly called due to an Equipment set change event or through the button in the interface addon options
local function Recreate()
  local _, _, class_id = UnitClass("player")
  local spec_id = GetSpecialization()
  local config = WeaponSwapAutoMacros["config"]

  -- Only do something if there is a configuration for our current class
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
            if (main1type == set1main_type) or (set1main_type == "LK_WEAPON" and (main1type == "INVTYPE_WEAPON" or main1type == "INVTYPE_2HWEAPON" or main1type == "INVTYPE_WEAPONMAINHAND")) or (set1main_type == "LK_ONEHAND" and (main1type == "INVTYPE_WEAPON" or main1type == "INVTYPE_WEAPONMAINHAND")) then
              item_names["Set1Main"] = main1name
              --print(("|cff22dd22WeaponSwapAutoMacros: '%s' main hand identified as '%s'"):format(set1name, main1name))
            else
              print(("|cffcc2222WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in main hand. Found one of type  '%s' in the slot instead. Cancelling macro creation for %s spec."):
              format(set1name, set1main_type_desc, main1subtype,  name))
              return            
            end
          else
            print(("|cffcc2222WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in main hand. Found an empty slot instead. Cancelling macro creation for %s spec."):
            format(set1name, set1main_type_desc, name))
            return
          end
        end
      else
        print(("|cffcc2222WeaponSwapAutoMacros: Could not find configured equipment set with name '%s'. Cancelling macro creation for %s spec. If you want to change the name of the equipment sets, go into Interface>>Addons>>Weapon Swap Auto Macros"):
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
            if (off1type == set1off_type) or (set1off_type == "LK_WEAPON" and (off1type == "INVTYPE_WEAPON" or off1type == "INVTYPE_2HWEAPON" or off1type == "INVTYPE_WEAPONoffHAND")) or (set1off_type == "LK_ONEHAND" and (off1type == "INVTYPE_WEAPON" or off1type == "INVTYPE_WEAPONoffHAND")) then
              item_names["Set1Off"] = off1name
              --print(("|cff22dd22WeaponSwapAutoMacros: '%s' off hand identified as '%s'"):format(set1name, off1name))
            else
              print(("|cffcc2222WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in off hand. Found one of type  '%s' in the slot instead. Cancelling macro creation for %s spec."):
              format(set1name, set1off_type_desc, off1subtype,  name))
              return            
            end
          else
            print(("|cffcc2222WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in off hand. Found an empty slot instead. Cancelling macro creation for %s spec."):
            format(set1name, set1off_type_desc, name))
            return
          end
        end
      else
        print(("|cffcc2222WeaponSwapAutoMacros: Could not find configured equipment set with name '%s'. Cancelling macro creation for %s spec. If you want to change the name of the equipment sets, go into Interface>>Addons>>Weapon Swap Auto Macros"):
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
            if (main2type == set2main_type) or (set2main_type == "LK_WEAPON" and (main2type == "INVTYPE_WEAPON" or main2type == "INVTYPE_2HWEAPON" or main2type == "INVTYPE_WEAPONMAINHAND")) or (set2main_type == "LK_ONEHAND" and (main2type == "INVTYPE_WEAPON" or main2type == "INVTYPE_WEAPONMAINHAND")) then
              item_names["Set2Main"] = main2name
              --print(("|cff22dd22WeaponSwapAutoMacros: '%s' main hand identified as '%s'"):format(set2name, main2name))
            else
              print(("|cffcc2222WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in main hand. Found one of type  '%s' in the slot instead. Cancelling macro creation for %s spec."):
              format(set2name, set2main_type_desc, main2subtype,  name))
              return            
            end
          else
            print(("|cffcc2222WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in main hand. Found an empty slot instead. Cancelling macro creation for %s spec."):
            format(set2name, set2main_type_desc, name))
            return
          end
        end
      else
        print(("|cffcc2222WeaponSwapAutoMacros: Could not find configured equipment set with name '%s'. Cancelling macro creation for %s spec. If you want to change the name of the equipment sets, go into Interface>>Addons>>Weapon Swap Auto Macros"):
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
            if (off2type == set2off_type) or (set2off_type == "LK_WEAPON" and (off2type == "INVTYPE_WEAPON" or off2type == "INVTYPE_2HWEAPON" or off2type == "INVTYPE_WEAPONoffHAND")) or (set2off_type == "LK_ONEHAND" and (off2type == "INVTYPE_WEAPON" or off2type == "INVTYPE_WEAPONoffHAND")) then
              item_names["Set2Off"] = off2name
              --print(("|cff22dd22WeaponSwapAutoMacros: '%s' off hand identified as '%s'"):format(set2name, off2name))
            else
              print(("|cffcc2222WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in off hand. Found one of type  '%s' in the slot instead. Cancelling macro creation for %s spec."):
              format(set2name, set2off_type_desc, off2subtype,  name))
              return            
            end
          else
            print(("|cffcc2222WeaponSwapAutoMacros: Equipment set '%s' requires an item of type '%s' in off hand. Found an empty slot instead. Cancelling macro creation for %s spec."):
            format(set2name, set2off_type_desc, name))
            return
          end
        end
      else
        print(("|cffcc2222WeaponSwapAutoMacros: Could not find configured equipment set with name '%s'. Cancelling macro creation for %s spec. If you want to change the name of the equipment sets, go into Interface>>Addons>>Weapon Swap Auto Macros"):
        format(set2name, name))
        return
      end

      -- Create or update all Macros
      for macro_name, macro_table in pairs(spec_conf["Macros"]) do
        if macro_table["Active"] then
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
end

-- Restore all default values for a clean slate
local function RestoreDefaults()
  if not WeaponSwapAutoMacros then
    WeaponSwapAutoMacros = {}
  end

  if not WeaponSwapAutoMacros["config"] then
    WeaponSwapAutoMacros["config"] = {}
  end
  
  WeaponSwapAutoMacros["config"] = DCtableMerge(WeaponSwapAutoMacros["config"], _G["WSAM_DEFAULTS"])
end

-- Make sure that a newly chosen macro name does not collide with any existing one
local function ValidMacroName(name, given_macro_key)
  if string.len(name) > 16 then
      return ("Your chosen macro name '%s' is too long. Macros are limited to 16 characters each."):format(name)
  end
  for class_id, specs in pairs(WeaponSwapAutoMacros["config"]) do
    for spec_id, spec_config in pairs(specs) do
      for macro_key, macro_table in pairs(spec_config["Macros"]) do
        if macro_table["MacroName"] == name and macro_key ~= given_macro_key then
          return ("Your chosen macro name '%s' collides with the macro name for %s. Every macro name must be fully unique."):format(name, macro_key)
        end
      end
    end
  end
  return true
end

-- Create and populate the option panel in interface>>addons
local function CreateOptions()
  local config = LibStub("AceConfig-3.0")
  local dialog = LibStub("AceConfigDialog-3.0")

  -- main option frame contianing two buttons
  local options = {
      type = "group",
      name = "Weapon Swap Auto Macros",
      desc = "All changes are immediately persisted. Please recreate all macros after changing any of the options.",
      descStyle = "inline",
      inline = true,
  }

  options.args = {}

  options.args["RestoreDefaults"] = {
    type = "execute",
    order = 1,
    name = "Restore Default Values",
    desc = "Reset all macro configurations to the default values. Try this at least once if the addon throws any errors or you misconfigured it.",
    func = function()
      RestoreDefaults()
    end,
    width = 1.5,
  }

  options.args["RecreateMacros"] = {
    type = "execute",
    order = 1,
    name = "Recreate Macros (current spec)",
    desc = "Create or update all macros based on the current configuration for your current spec. Recreation is also triggered on changing specs or updating equipment sets.",
    func = function()
      Recreate()
    end,
    width = 1.5,
  }

  local panelorder = 1

  -- Create sub frames for each spec
  for class_id, specs in pairs(WeaponSwapAutoMacros["config"]) do
    for spec_id, spec_config in pairs(specs) do
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
        desc = "",
        width = "full",
        validate = function(info, val)
          if val == spec_config["Set2Name"] then
            return "Cannot give both sets in a spec the same name!"
          else
            return true
          end
        end,
        set = function(info,val) spec_config["Set1Name"]=val end,
        get = function(info) return spec_config["Set1Name"] end            
      }
      current_options.args.settwo = {
        type = "input",
        order = 2,
        desc = "",
        name = spec_config["Set2Desc"],
        width = "full",
        validate = function(info, val)
          if val == spec_config["Set1Name"] then
            return "Cannot give both sets in a spec the same name!"
          else
            return true
          end
        end,
        set = function(info,val) spec_config["Set2Name"]=val end,
        get = function(info) return spec_config["Set2Name"] end            
      }
      
      -- create another subframe for all the macros in a spec and populate it
      current_options.args.macroframe = {
        order = 3,
        type = "group",
        inline = true,
        name = "Macro Settings",
        args = {}
      }
      local macroframe = current_options.args.macroframe

      local offset = 0
      for _, _ in pairs(spec_config["Macros"]) do offset=offset+1 end


      for macro_key, macro_table in pairs(spec_config["Macros"]) do
        -- make the last line prettier for odd options
        local width = 1.0
        if offset == macro_table["Order"] and (offset % 2) ~= 0 then
          width = 2.2
        end
        
        
        macroframe.args[macro_key] = {
          type = "toggle",
          order = macro_table["Order"],
          name = ("%s"):format(macro_key),
          width = width,
          set = function(info,val) macro_table["Active"] = val end,
          get = function(info) return macro_table["Active"] end            
        }
        
        macroframe.args[macro_key.."key"] = {
          type = "input",
          order = macro_table["Order"] + offset,
          name = ("%s Macro Name:"):format(macro_key),
          --width = width,
          validate = function(info, val) return ValidMacroName(val, macro_key) end,            
          set = function(info,val) 
            macro_table["MacroName"] = val
          end,
          get = function(info) return macro_table["MacroName"] end,
          hidden = function(info) return not macro_table["Active"] end            
        }
      end
      
    end
  end
  config:RegisterOptionsTable("WeaponSwapAutoMacros", options, {"/wsam"})
  dialog:AddToBlizOptions("WeaponSwapAutoMacros")
end


-- Main Event hook for the whole addon
frame:HookScript('OnEvent', function(self, event, arg1, ...)

  -- Upon loading the addon make sure that the global config is complete
  -- Will fill in all missing pieces with default values if necessary
  if event == 'ADDON_LOADED' and arg1 == "WeaponSwapAutoMacros" then
    -- Load Defaults into Saved Settings for all missing entries

    if not WeaponSwapAutoMacros then
      WeaponSwapAutoMacros = {}
    end
    if not WeaponSwapAutoMacros["config"] then
      WeaponSwapAutoMacros["config"] = {}
    end
   
    WeaponSwapAutoMacros["config"] = DCtableMerge(deepcopy(_G["WSAM_DEFAULTS"]), WeaponSwapAutoMacros["config"]) 

    -- Overwrite non-configurable values with defaults so that updates get persisted into existing configs
    for class_id, specs in pairs(WeaponSwapAutoMacros["config"]) do
      for spec_id, spec_config in pairs(specs) do
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set1Desc"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set1Desc"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set1MainBool"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set1MainBool"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set1MainType"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set1MainType"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set1MainTypeDesc"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set1MainTypeDesc"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set1OffBool"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set1OffBool"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set1OffType"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set1OffType"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set1OffTypeDesc"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set1OffTypeDesc"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set2Desc"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set2Desc"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set2MainBool"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set2MainBool"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set2MainType"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set2MainType"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set2MainTypeDesc"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set2MainTypeDesc"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set2OffBool"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set2OffBool"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set2OffType"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set2OffType"] 
        WeaponSwapAutoMacros["config"][class_id][spec_id]["Set2OffTypeDesc"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Set2OffTypeDesc"] 
        for macro_key, macro_table in pairs(spec_config["Macros"]) do
          WeaponSwapAutoMacros["config"][class_id][spec_id]["Macros"][macro_key]["IconId"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Macros"][macro_key]["IconId"] 
          WeaponSwapAutoMacros["config"][class_id][spec_id]["Macros"][macro_key]["Body"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Macros"][macro_key]["Body"] 
          WeaponSwapAutoMacros["config"][class_id][spec_id]["Macros"][macro_key]["Order"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Macros"][macro_key]["Order"] 
          WeaponSwapAutoMacros["config"][class_id][spec_id]["Macros"][macro_key]["Formats"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Macros"][macro_key]["Formats"] 
          WeaponSwapAutoMacros["config"][class_id][spec_id]["Macros"][macro_key]["Set2OffTypeDesc"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Macros"][macro_key]["Set2OffTypeDesc"] 
          WeaponSwapAutoMacros["config"][class_id][spec_id]["Macros"][macro_key]["Set2OffTypeDesc"] = _G["WSAM_DEFAULTS"][class_id][spec_id]["Macros"][macro_key]["Set2OffTypeDesc"]
        end
      end
    end 

  -- Upon equipment set change or spec change, recreate all the macros
  elseif event == 'EQUIPMENT_SETS_CHANGED' or event == "PLAYER_SPECIALIZATION_CHANGED" then
    Recreate()
    
  -- Upon logout or ui reload make sure the saved variables are available in global space for write out
  elseif event == "PLAYER_LOGOUT" then
    _G["WeaponSwapAutoMacros"] = WeaponSwapAutoMacros; 

  -- After everyting is loaded add this addons options to the interface option panel and create the slashcommand
  elseif event == "VARIABLES_LOADED" then
    CreateOptions()  
  end
end)
