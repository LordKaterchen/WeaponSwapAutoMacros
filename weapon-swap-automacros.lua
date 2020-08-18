local frame = CreateFrame('Frame')
local VariableLoadCount = 0

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
  if class_id == 1 and spec_id == 1 then
    if C_EquipmentSet.GetEquipmentSetID("Arms_Twohanded") and C_EquipmentSet.GetEquipmentSetID("Arms_Shield") then
      _G["lk_my_twohanded"]=GetItemInfo((C_EquipmentSet.GetItemIDs(C_EquipmentSet.GetEquipmentSetID("Arms_Twohanded")))[16]) 
      _G["lk_my_onehanded"]=GetItemInfo((C_EquipmentSet.GetItemIDs(C_EquipmentSet.GetEquipmentSetID("Arms_Shield")))[16])
      _G["lk_my_shield"]=GetItemInfo((C_EquipmentSet.GetItemIDs(C_EquipmentSet.GetEquipmentSetID("Arms_Shield")))[17])
      print("Lord Katerchen Arms Warrior Weapon Swap Twohanded Weapon: ", _G["lk_my_twohanded"])
      print("Lord Katerchen Arms Warrior Weapon Swap Onehanded Weapon: ", _G["lk_my_onehanded"])
      print("Lord Katerchen Arms Warrior Weapon Swap Shield: ", _G["lk_my_shield"])
  
      if not _G["lk_slash_setup_done"] then
        SLASH_LK_SWAP1 = "/lk_swap"
        SlashCmdList["LK_SWAP"] = function()
          EquipItemByName(_G["lk_my_onehanded"])
          EquipItemByName(_G["lk_my_shield"])
          EquipItemByName(_G["lk_my_twohanded"])
        end
  
        SLASH_LK_TWOHANDED1 = "/lk_twohanded"
        SlashCmdList["LK_TWOHANDED"] = function()
          EquipItemByName(_G["lk_my_twohanded"])
        end
  
        SLASH_LK_SHIELD1 = "/lk_shield"
        SlashCmdList["LK_SHIELD"] = function()
          EquipItemByName(_G["lk_my_onehanded"])
          EquipItemByName(_G["lk_my_shield"])
        end
        _G["lk_slash_setup_done"] = true
      end    
  
      
      -- Build/Update Macros
      local macros_info = {}
  
      -- Build generic Weaponswap
      local body = ([[
/equipslot 16 %s
/equipslot 17 %s
/equipslot 16 %s
  ]]):format(_G["lk_my_onehanded"], _G["lk_my_shield"], _G["lk_my_twohanded"]) 
      CrupdateMacro("lk_swap", 975736, body)
  
  
      -- Build defense stance autoswap
      local body = ([[
#showtooltip
/cast Defensive Stance
/equipslot 16 %s
/equipslot 17 %s
/equipslot 16 %s
  ]]):format(_G["lk_my_onehanded"], _G["lk_my_shield"], _G["lk_my_twohanded"]) 
      CrupdateMacro("lk_defensive_s", "INV_Misc_QuestionMark", body)
  
  
      -- Build Mortal Strike
      body = ([[
#showtooltip
/cast Mortal Strike
/equipslot 16 %s
  ]]):format(_G["lk_my_twohanded"]) 
      CrupdateMacro("lk_mortal_strike", "INV_Misc_QuestionMark", body)
  
  
      -- Build Cleave
      body = ([[
#showtooltip 
/cast [talent:5/3] Cleave; Sweeping Strikes
/equipslot [talent:5/3] 16 %s
  ]]):format(_G["lk_my_twohanded"]) 
      CrupdateMacro("lk_cleave_sweep", "INV_Misc_QuestionMark", body) --132338
  
  
      -- Build Shield Block
      body = ([[
#showtooltip
/cast Shield Block
/equipslot 16 %s
/equipslot 17 %s
  ]]):format(_G["lk_my_onehanded"], _G["lk_my_shield"]) 
      CrupdateMacro("lk_shield_block", "INV_Misc_QuestionMark", body)
  
  
      -- Build Shield Slam
      body = ([[
#showtooltip
/cast Shield Slam
/equipslot 16 %s
/equipslot 17 %s
  ]]):format(_G["lk_my_onehanded"], _G["lk_my_shield"]) 
      CrupdateMacro("lk_shield_slam", "INV_Misc_QuestionMark", body)
  
    else
       print("Could not setup Lord Katerchen Arms Warrior Weapon Swap variables. Need 'Arms_Twohanded' and 'Arms_Shield' Equipment Sets.")
    end
  else
    print("Could not setup Lord Katerchen Arms Warrior Weapon Swap. Class and Spec combo is not supported")
  end
end


frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:RegisterEvent('EQUIPMENT_SETS_CHANGED')

frame:HookScript('OnEvent', function(self, event, ...)
    if event == 'PLAYER_ENTERING_WORLD' then
        Reload()
    elseif event == 'EQUIPMENT_SETS_CHANGED' then
        Reload()
    end
end)


SLASH_LK_RELOAD1 = "/lk_reload"
SlashCmdList["LK_RELOAD"] = function()
  Reload()
end
