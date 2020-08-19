print("LOADING FURY")
local FURY = {}

FURY["Name"] = "Fury"

FURY["Set1Name"] = "Fury_Twohanders"
FURY["Set1Desc"] = "Equipment set name for your Fury warrior with two twohanded weapons:"
FURY["Set1MainBool"] = true
FURY["Set1MainType"] = "INVTYPE_2HWEAPON"
FURY["Set1MainTypeDesc"] = "twohanded weapon"
FURY["Set1OffBool"] = true
FURY["Set1OffType"] = "INVTYPE_2HWEAPON"
FURY["Set1OffTypeDesc"] = "twohanded weapon"

FURY["Set2Name"] = "Fury_Shield"
FURY["Set2Desc"] = "Equipment set name for your Fury warrior with a shield:"
FURY["Set2MainBool"] = true
FURY["Set2MainType"] = "INVTYPE_2HWEAPON"
FURY["Set2MainTypeDesc"] = "twohanded weapon"
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
  Formats = {"Set1Main", "Set1Off"}
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