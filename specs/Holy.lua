local HOLY = {}

HOLY["Name"] = "Holy"

HOLY["Set1Name"] = "Holy_Twohanded"
HOLY["Set1Desc"] = "Equipment set name for your Holy paladin with a twohanded weapon:"
HOLY["Set1MainBool"] = true
HOLY["Set1MainType"] = "INVTYPE_2HWEAPON"
HOLY["Set1MainTypeDesc"] = "twohanded weapon"
HOLY["Set1OffBool"] = false
HOLY["Set1OffType"] = ""
HOLY["Set1OffTypeDesc"] = ""

HOLY["Set2Name"] = "Holy_Shield"
HOLY["Set2Desc"] = "Equipment set name for your Holy paladin with a shield:"
HOLY["Set2MainBool"] = true
HOLY["Set2MainType"] = "LK_ONEHAND"
HOLY["Set2MainTypeDesc"] = "onehanded weapon"
HOLY["Set2OffBool"] = true
HOLY["Set2OffType"] = "INVTYPE_SHIELD"
HOLY["Set2OffTypeDesc"] = "shield"

HOLY["Macros"] = {}

HOLY["Macros"]["Shield of the Righteous"] = {
  Active=true,
  MacroName="SotR WSAM HOLY",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Shield of the Righteous
/equipslot 16 %s
/equipslot 17 %s
]],
  Order = 1,
  Formats = {"Set2Main", "Set2Off"}
}


HOLY["Macros"]["Weapon Swap"] = {
  Active=true,
  MacroName="WS WSAM HOLY",
  IconId = 975736,
  Body = [[
/equipslot 16 %s
/equipslot 17 %s
/equipslot 16 %s
]],
  Order = 2,
  Formats = {"Set2Main", "Set2Off", "Set1Main"}
}

if not _G["WSAM_DEFAULTS"] then
  _G["WSAM_DEFAULTS"] = {}
end

if not _G["WSAM_DEFAULTS"][2] then
  _G["WSAM_DEFAULTS"][2] = {}
end

if not _G["WSAM_DEFAULTS"][2] then
  _G["WSAM_DEFAULTS"][2][1] = {}
end

_G["WSAM_DEFAULTS"][2][1] = HOLY

--/script a={4,6,7};print(("%s %s %s"):format(unpack(a)))
--/script print(_G["WSAM_DEFAULTS"][1][1]["Set1Desc"])