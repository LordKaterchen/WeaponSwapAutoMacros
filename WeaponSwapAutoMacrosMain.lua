local frame = CreateFrame('frame')
frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('PLAYER_LOGOUT')
frame:RegisterEvent('EQUIPMENT_SETS_CHANGED')
frame:RegisterEvent('VARIABLES_LOADED')

local function CrupdateMacro(name, icon, body)
  local preexisting_id = GetMacroIndexByName(name)
  if preexisting_id == 0 then
    CreateMacro(name, icon, body, true)
  else
    EditMacro(preexisting_id, name, icon, body)
  end
end

local function Reload()
  local _, _, class_id = UnitClass("player")
  local spec_id = GetSpecialization()
  print(WeaponSwapAutoMacros, class_id, spec_id)
  WeaponSwapAutoMacros = WeaponSwapAutoMacros or {}
  if class_id == 1 and spec_id == 1 then
    if C_EquipmentSet.GetEquipmentSetID("Arms_Twohanded") and C_EquipmentSet.GetEquipmentSetID("Arms_Shield") then
      WeaponSwapAutoMacros["ArmsTwoHanded"]=GetItemInfo((C_EquipmentSet.GetItemIDs(C_EquipmentSet.GetEquipmentSetID("Arms_Twohanded")))[16]) 
      WeaponSwapAutoMacros["ArmsOnehanded"]=GetItemInfo((C_EquipmentSet.GetItemIDs(C_EquipmentSet.GetEquipmentSetID("Arms_Shield")))[16])
      WeaponSwapAutoMacros["ArmsShield"]=GetItemInfo((C_EquipmentSet.GetItemIDs(C_EquipmentSet.GetEquipmentSetID("Arms_Shield")))[17])
      print("Lord Katerchen Arms Warrior Weapon Swap Twohanded Weapon: ", WeaponSwapAutoMacros["ArmsTwoHanded"])
      print("Lord Katerchen Arms Warrior Weapon Swap Onehanded Weapon: ", WeaponSwapAutoMacros["ArmsOnehanded"])
      print("Lord Katerchen Arms Warrior Weapon Swap Shield: ", WeaponSwapAutoMacros["ArmsShield"])
      
      -- Build/Update Macros
      local macros_info = {}
  
      -- Build generic Weaponswap
      local body = ([[
/equipslot 16 %s
/equipslot 17 %s
/equipslot 16 %s
  ]]):format(WeaponSwapAutoMacros["ArmsOnehanded"], WeaponSwapAutoMacros["ArmsShield"], WeaponSwapAutoMacros["ArmsTwoHanded"]) 
      CrupdateMacro("lk_swap", 975736, body)
  
  
      -- Build defense stance autoswap
      local body = ([[
#showtooltip
/cast Defensive Stance
/equipslot 16 %s
/equipslot 17 %s
/equipslot 16 %s
  ]]):format(WeaponSwapAutoMacros["ArmsOnehanded"], WeaponSwapAutoMacros["ArmsShield"], WeaponSwapAutoMacros["ArmsTwoHanded"]) 
      CrupdateMacro("lk_defensive_s", "INV_Misc_QuestionMark", body)
  
  
      -- Build Mortal Strike
      body = ([[
#showtooltip
/cast Mortal Strike
/equipslot 16 %s
  ]]):format(WeaponSwapAutoMacros["ArmsTwoHanded"]) 
      CrupdateMacro("lk_mortal_strike", "INV_Misc_QuestionMark", body)
  
  
      -- Build Cleave
      body = ([[
#showtooltip 
/cast [talent:5/3] Cleave; Sweeping Strikes
/equipslot [talent:5/3] 16 %s
  ]]):format(WeaponSwapAutoMacros["ArmsTwoHanded"]) 
      CrupdateMacro("lk_cleave_sweep", "INV_Misc_QuestionMark", body) --132338
  
  
      -- Build Shield Block
      body = ([[
#showtooltip
/cast Shield Block
/equipslot 16 %s
/equipslot 17 %s
  ]]):format(WeaponSwapAutoMacros["ArmsOnehanded"], WeaponSwapAutoMacros["ArmsShield"]) 
      CrupdateMacro("lk_shield_block", "INV_Misc_QuestionMark", body)
  
  
      -- Build Shield Slam
      body = ([[
#showtooltip
/cast Shield Slam
/equipslot 16 %s
/equipslot 17 %s
  ]]):format(WeaponSwapAutoMacros["ArmsOnehanded"], WeaponSwapAutoMacros["ArmsShield"]) 
      CrupdateMacro("lk_shield_slam", "INV_Misc_QuestionMark", body)
  
    else
      print("Could not setup Lord Katerchen Arms Warrior Weapon Swap variables. Need 'Arms_Twohanded' and 'Arms_Shield' Equipment Sets.")
    end
  else
    print("Could not setup Lord Katerchen Arms Warrior Weapon Swap. Class and Spec combo is not supported")
  end
end

WeaponSwapAutoMacros_details = {
  name = "Weapon Swap Auto Macros",
  frame = "WeaponSwapAutoMacros",
  optionsframe = "WeaponSwapAutoMacrosConfigFrame"
};



frame:HookScript('OnEvent', function(self, event, arg1, ...)
  if event == 'ADDON_LOADED' and arg1 == "WeaponSwapAutoMacros" then
    --print(_G["WeaponSwapAutoMacros"])
    print(WeaponSwapAutoMacros)
    --Reload()
  elseif event == 'EQUIPMENT_SETS_CHANGED' then
    Reload()
  elseif event == "PLAYER_LOGOUT" then
    _G["WeaponSwapAutoMacros"] = WeaponSwapAutoMacros; -- We've met; commit it to memory.
  elseif event == "VARIABLES_LOADED" then
    if( myAddOnsFrame_Register ) then
    myAddOnsFrame_Register( WeaponSwapAutoMacros_details );
  end
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

