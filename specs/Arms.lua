print("LOADING ARMS")
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
ARMS["Set2MainType"] = "INVTYPE_WEAPON"
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