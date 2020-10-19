local ARMS = {}

ARMS["Name"] = "Arms"

ARMS["Set1Name"] = "Arms_Twohanded"
ARMS["Set1Desc"] = "Equipment set name for your Arms warrior with a twohanded weapon:"
ARMS["Set1MainBool"] = true
ARMS["Set1MainType"] = "INVTYPE_2HWEAPON"
ARMS["Set1MainTypeDesc"] = "twohanded weapon"
ARMS["Set1OffBool"] = false
ARMS["Set1OffType"] = ""
ARMS["Set1OffTypeDesc"] = ""

ARMS["Set2Name"] = "Arms_Shield"
ARMS["Set2Desc"] = "Equipment set name for your Arms warrior with a shield:"
ARMS["Set2MainBool"] = true
ARMS["Set2MainType"] = "LK_ONEHAND"
ARMS["Set2MainTypeDesc"] = "onehanded weapon"
ARMS["Set2OffBool"] = true
ARMS["Set2OffType"] = "INVTYPE_SHIELD"
ARMS["Set2OffTypeDesc"] = "shield"

ARMS["Macros"] = {}

ARMS["Macros"]["Mortal Strike"] = {
  Active=true,
  MacroName="MS WSAM ARMS",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Mortal Strike
/equipslot 16 %s
]],
  Order = 1,
  Formats = {"Set1Main"}
}

ARMS["Macros"]["Cleave"] = {
  Active=true,
  MacroName="CL WSAM ARMS",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip 
/cast [talent:5/3] Cleave; Sweeping Strikes
/equipslot [talent:5/3] 16 %s
]],
  Order = 2,
  Formats = {"Set1Main"}
}

ARMS["Macros"]["Shield Block"] = {
  Active=true,
  MacroName="SB WSAM ARMS",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Shield Block
/equipslot 16 %s
/equipslot 17 %s
]],
  Order = 3,
  Formats = {"Set2Main", "Set2Off"}
}

ARMS["Macros"]["Shield Slam"] = {
  Active=true,
  MacroName="SS WSAM ARMS",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Shield Slam
/equipslot 16 %s
/equipslot 17 %s
]],
  Order = 4,
  Formats = {"Set2Main", "Set2Off"}
}


ARMS["Macros"]["Defensive Stance"] = {
  Active=true,
  MacroName="DS WSAM ARMS",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Defensive Stance
/equipslot 16 %s
/equipslot 17 %s
/equipslot 16 %s
]],
  Order = 5,
  Formats = {"Set2Main", "Set2Off", "Set1Main"}
}

ARMS["Macros"]["Weapon Swap"] = {
  Active=true,
  MacroName="WS WSAM ARMS",
  IconId = 975736,
  Body = [[
/equipslot 16 %s
/equipslot 17 %s
/equipslot 16 %s
]],
  Order = 6,
  Formats = {"Set2Main", "Set2Off", "Set1Main"}
}

ARMS["Macros"]["Sharpen Blade MS"] = {
  Active=true,
  MacroName="SBMS WSAM ARMS",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Sharpen Blade
/cast Mortal Strike
/equipslot 16 %s
]],
  Order = 7,
  Formats = {"Set1Main"}
}

if not _G["WSAM_DEFAULTS"] then
  _G["WSAM_DEFAULTS"] = {}
end

if not _G["WSAM_DEFAULTS"][1] then
  _G["WSAM_DEFAULTS"][1] = {}
end

if not _G["WSAM_DEFAULTS"][1] then
  _G["WSAM_DEFAULTS"][1][1] = {}
end

_G["WSAM_DEFAULTS"][1][1] = ARMS

--/script a={4,6,7};print(("%s %s %s"):format(unpack(a)))
--/script print(_G["WSAM_DEFAULTS"][1][1]["Set1Desc"])