local RET = {}

RET["Name"] = "Retribution"

RET["Set1Name"] = "Ret_Twohanded"
RET["Set1Desc"] = "Equipment set name for your Retribution paladin with a twohanded weapon:"
RET["Set1MainBool"] = true
RET["Set1MainType"] = "INVTYPE_2HWEAPON"
RET["Set1MainTypeDesc"] = "twohanded weapon"
RET["Set1OffBool"] = false
RET["Set1OffType"] = ""
RET["Set1OffTypeDesc"] = ""

RET["Set2Name"] = "Ret_Shield"
RET["Set2Desc"] = "Equipment set name for your Retribution paladin with a shield:"
RET["Set2MainBool"] = true
RET["Set2MainType"] = "LK_ONEHAND"
RET["Set2MainTypeDesc"] = "onehanded weapon"
RET["Set2OffBool"] = true
RET["Set2OffType"] = "INVTYPE_SHIELD"
RET["Set2OffTypeDesc"] = "shield"

RET["Macros"] = {}

RET["Macros"]["Blade of Justice"] = {
  Active=true,
  MacroName="BoJ WSAM RET",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Blade of Justice
/equipslot 16 %s
]],
  Order = 1,
  Formats = {"Set1Main"}
}

RET["Macros"]["Divine Storm"] = {
  Active=true,
  MacroName="DS WSAM RET",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Divine Storm
/equipslot 16 %s
]],
  Order = 2,
  Formats = {"Set1Main"}
}

RET["Macros"]["Templar's Verdict"] = {
  Active=true,
  MacroName="TV WSAM RET",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Templar's Verdict
/equipslot 16 %s
]],
  Order = 3,
  Formats = {"Set1Main"}
}

RET["Macros"]["Shield of the Righteous"] = {
  Active=true,
  MacroName="SotR WSAM RET",
  IconId = "INV_Misc_QuestionMark",
  Body = [[
#showtooltip
/cast Shield of the Righteous
/equipslot 16 %s
/equipslot 17 %s
]],
  Order = 4,
  Formats = {"Set2Main", "Set2Off"}
}


RET["Macros"]["Weapon Swap"] = {
  Active=true,
  MacroName="WS WSAM RET",
  IconId = 975736,
  Body = [[
/equipslot 16 %s
/equipslot 17 %s
/equipslot 16 %s
]],
  Order = 5,
  Formats = {"Set2Main", "Set2Off", "Set1Main"}
}

if not _G["WSAM_DEFAULTS"] then
  _G["WSAM_DEFAULTS"] = {}
end

if not _G["WSAM_DEFAULTS"][2] then
  _G["WSAM_DEFAULTS"][2] = {}
end

if not _G["WSAM_DEFAULTS"][2] then
  _G["WSAM_DEFAULTS"][2][3] = {}
end

_G["WSAM_DEFAULTS"][2][3] = RET

--/script a={4,6,7};print(("%s %s %s"):format(unpack(a)))
--/script print(_G["WSAM_DEFAULTS"][1][1]["Set1Desc"])