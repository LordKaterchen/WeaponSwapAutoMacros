local FURY = {}

FURY["Name"] = "Fury"

FURY["Set1Name"] = "Fury_Offense"
FURY["Set1Desc"] = "Equipment set name for your Fury warrior with two weapons:"
FURY["Set1MainBool"] = true
FURY["Set1MainType"] = "LK_WEAPON"
FURY["Set1MainTypeDesc"] = "weapon"
FURY["Set1OffBool"] = true
FURY["Set1OffType"] = "LK_WEAPON"
FURY["Set1OffTypeDesc"] = "weapon"

FURY["Set2Name"] = "Fury_Shield"
FURY["Set2Desc"] = "Equipment set name for your Fury warrior with a shield:"
FURY["Set2MainBool"] = true
FURY["Set2MainType"] = "LK_WEAPON"
FURY["Set2MainTypeDesc"] = "weapon"
FURY["Set2OffBool"] = true
FURY["Set2OffType"] = "INVTYPE_SHIELD"
FURY["Set2OffTypeDesc"] = "shield"

FURY["Macros"] = {}

FURY["Macros"]["Rampage"] = {
  Active=true,
  MacroName="RA WSAM FURY",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Rampage
/equipslot 16 %s
/equipslot 17 %s
]],
  Order = 1,
  Formats = {"Set1Main", "Set1Off"}
}

FURY["Macros"]["Raging Blow"] = {
  Active=true,
  MacroName="RB WSAM FURY",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Raging Blow
/equipslot 16 %s
/equipslot 17 %s
]],
  Order = 2,
  Formats = {"Set1Main", "Set1Off"}
}

FURY["Macros"]["Onslaught"] = {
  Active=true,
  MacroName="OS WSAM FURY",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Onslaught
/equipslot 16 %s
/equipslot 17 %s
]],
  Order = 3,
  Formats = {"Set1Main", "Set1Off"}
}

FURY["Macros"]["Siegebreaker"] = {
  Active=true,
  MacroName="SIEGE WSAM FURY",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Siegebreaker
/equipslot 16 %s
/equipslot 17 %s
]],
  Order = 4,
  Formats = {"Set1Main", "Set1Off"}
}

FURY["Macros"]["Shield Block"] = {
  Active=true,
  MacroName="SB WSAM FURY",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Shield Block
/equipslot 16 %s
/equipslot 17 %s
]],
  Order = 5,
  Formats = {"Set2Main", "Set2Off"}
}

FURY["Macros"]["Shield Slam"] = {
  Active=true,
  MacroName="SS WSAM FURY",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Shield Slam
/equipslot 16 %s
/equipslot 17 %s
]],
  Order = 6,
  Formats = {"Set2Main", "Set2Off"}
}


FURY["Macros"]["Weapon Swap"] = {
  Active=true,
  MacroName="WS WSAM FURY",
  IconId = 975736,
  Body = [[
/equipslot 16 %s
/equipslot 17 %s
/equipslot 16 %s
]],
  Order = 7,
  Formats = {"Set2Main", "Set2Off", "Set1Main"}
}


if not _G["WSAM_DEFAULTS"] then
  _G["WSAM_DEFAULTS"] = {}
end

if not _G["WSAM_DEFAULTS"][1] then
  _G["WSAM_DEFAULTS"][1] = {}
end

if not _G["WSAM_DEFAULTS"][1] then
  _G["WSAM_DEFAULTS"][1][2] = {}
end

_G["WSAM_DEFAULTS"][1][2] = FURY

--/script a={4,6,7};print(("%s %s %s"):format(unpack(a))