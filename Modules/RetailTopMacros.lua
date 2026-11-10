local _, ns = ...

--[[
	RetailTopMacros.lua — Midnight (retail): "Top macros", the five macros players use most per spec, as a new first kind
	in the Macros tab. Rob, 10 Nov 2026: "maak het maar, net zoals we nu voor Forever hebben ... minimaal net zo goed".
	Same approach as Modules/ForeverMacros.lua:
	- spells only as {id} in the template; FillTpl puts in the client's own spell name, so it works in every language
	  (the older Utility/Interrupt lists use English names, which a German or French client does not know - AFGELEID);
	- a talent row stays hidden until its talent is known; a row whose spell is not known yet says so and cannot be made;
	- a Make button (InterruptMacros.lua) puts the macro in this character's list as "MH+ <name>", for every kind.
	Data: researched 10 Nov 2026 by three mh-research runs (Midnight-era sources counted per spec, ids measured in wago
	DB2 retail) — notes in the scratchpad of that day. Nobody has tested these macros in game yet.
]]

if ns.IS_FOREVER then
	return
end

-- Rows: { class, spec (C_SpecializationInfo index), key, name, need, talent, tpl, tplShort? }. Filled below.
-- 183 rows (13 classes, 39 specs, 5 each; spec 0 = every spec of the class). Ids GEMETEN in wago DB2 retail
-- 12.1.5.70783; talent = TraitDefinition spell without a baseline row; lengths measured filled in 7+ client
-- languages. Sources per row and every AFGELEID choice: scratchpad retail_macros_A/B/C_notes.md of 10 Nov 2026.
local TOP_MACROS = {
	-- DEATHKNIGHT
	{ class = "DEATHKNIGHT", spec = 0, key = "dk_kick", name = "Mind Freeze", need = 47528, talent = true,
		tpl = "#showtooltip {47528}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {47528}" },
	{ class = "DEATHKNIGHT", spec = 0, key = "dk_brez", name = "Raise Ally", need = 61999, talent = false,
		tpl = "#showtooltip {61999}\n/cast [@mouseover,help,dead][] {61999}" },
	{ class = "DEATHKNIGHT", spec = 0, key = "dk_grip", name = "Death Grip", need = 49576, talent = false,
		tpl = "#showtooltip {49576}\n/cast [@mouseover,harm,nodead][] {49576}" },
	{ class = "DEATHKNIGHT", spec = 1, key = "dk_dnd", name = "DnD Cursor", need = 43265, talent = false,
		tpl = "#showtooltip {43265}\n/cast [mod:ctrl,@player][@cursor] {43265}" },
	{ class = "DEATHKNIGHT", spec = 1, key = "dk_gorefiend", name = "Gorefiend", need = 108199, talent = true,
		tpl = "#showtooltip {108199}\n/cast [mod:shift,@focus,exists][@mouseover,exists,nodead][@player] {108199}" },
	{ class = "DEATHKNIGHT", spec = 2, key = "dk_pillar", name = "Pillar Burst", need = 51271, talent = true,
		tpl = "#showtooltip {51271}\n/use 13\n/use 14\n/cast {51271}\n/cast {46585}\n/cast {49020}" },
	{ class = "DEATHKNIGHT", spec = 2, key = "dk_amz", name = "AMZ Cursor", need = 51052, talent = true,
		tpl = "#showtooltip {51052}\n/cast [@cursor] {51052}" },
	{ class = "DEATHKNIGHT", spec = 3, key = "dk_leap", name = "Ghoul Leap", need = 46584, talent = false,
		tpl = "#showtooltip {47482}\n/cast {47482}\n/petattack\n/startattack" },
	{ class = "DEATHKNIGHT", spec = 3, key = "dk_outbreak", name = "Outbreak", need = 77575, talent = true,
		tpl = "#showtooltip {77575}\n/cast [@mouseover,harm,nodead][] {77575}" },
	-- DEMONHUNTER
	{ class = "DEMONHUNTER", spec = 0, key = "dh_disrupt", name = "Disrupt", need = 183752, talent = false,
		tpl = "#showtooltip {183752}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {183752}" },
	{ class = "DEMONHUNTER", spec = 0, key = "dh_purge", name = "ConsumeMagic", need = 278326, talent = true,
		tpl = "#showtooltip {278326}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {278326}" },
	{ class = "DEMONHUNTER", spec = 1, key = "dh_meta", name = "Meta Cursor", need = 191427, talent = false,
		tpl = "#showtooltip {191427}\n/cast [mod:alt,@player][@cursor] {191427}" },
	{ class = "DEMONHUNTER", spec = 1, key = "dh_misery1", name = "Misery Sigil", need = 207684, talent = true, dkey = "dh_misery",
		tpl = "#showtooltip {207684}\n/cast [@cursor] {207684}" },
	{ class = "DEMONHUNTER", spec = 1, key = "dh_imprison", name = "Imprison", need = 217832, talent = true,
		tpl = "#showtooltip {217832}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {217832}" },
	{ class = "DEMONHUNTER", spec = 2, key = "dh_sigilflame", name = "Flame Sigil", need = 204596, talent = false,
		tpl = "#showtooltip {204596}\n/cast [@cursor] {204596}" },
	{ class = "DEMONHUNTER", spec = 2, key = "dh_infernal", name = "Infernal", need = 189110, talent = false,
		tpl = "#showtooltip {189110}\n/cast [mod:ctrl,@player][@cursor] {189110}" },
	{ class = "DEMONHUNTER", spec = 2, key = "dh_torment", name = "Torment", need = 185245, talent = false,
		tpl = "#showtooltip {185245}\n/cast [@mouseover,harm,nodead][] {185245}" },
	{ class = "DEMONHUNTER", spec = 3, key = "dh_consume", name = "Safe Consume", need = 473662, talent = false, warn = "channelbug",
		tpl = "#showtooltip {473662}\n/cast [nochanneling,@mouseover,harm,nodead][nochanneling] {473662}" },
	{ class = "DEMONHUNTER", spec = 3, key = "dh_shift", name = "Shift Cursor", need = 1234796, talent = false,
		tpl = "#showtooltip {1234796}\n/cast [@cursor] {1234796}" },
	{ class = "DEMONHUNTER", spec = 3, key = "dh_misery3", name = "Misery Sigil", need = 207684, talent = true, dkey = "dh_misery",
		tpl = "#showtooltip {207684}\n/cast [@cursor] {207684}" },
	-- DRUID
	{ class = "DRUID", spec = 0, key = "dr_rebirth", name = "Rebirth", need = 20484, talent = false,
		tpl = "#showtooltip {20484}\n/cast [@mouseover,help,dead][] {20484}" },
	{ class = "DRUID", spec = 1, key = "dr_orbital", name = "CA Cursor", need = 194223, talent = true,
		tpl = "#showtooltip {194223}\n/cast [@cursor] {194223}" },
	{ class = "DRUID", spec = 1, key = "dr_fon", name = "FoN Cursor", need = 205636, talent = true,
		tpl = "#showtooltip {205636}\n/cast [@cursor] {205636}" },
	{ class = "DRUID", spec = 1, key = "dr_innervate1", name = "Innervate", need = 29166, talent = true, dkey = "dr_innervate",
		tpl = "#showtooltip {29166}\n/cast [@mouseover,help,nodead][] {29166}" },
	{ class = "DRUID", spec = 1, key = "dr_sunfire", name = "Sunfire MO", need = 93402, talent = true,
		tpl = "#showtooltip {93402}\n/cast [@mouseover,harm,nodead][] {93402}" },
	{ class = "DRUID", spec = 2, key = "dr_skullbash2", name = "Skull Bash", need = 106839, talent = true, dkey = "dr_skullbash",
		tpl = "#showtooltip {106839}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {106839}" },
	{ class = "DRUID", spec = 2, key = "dr_vortex", name = "Vortex", need = 102793, talent = true,
		tpl = "#showtooltip {102793}\n/cast [@cursor] {102793}" },
	{ class = "DRUID", spec = 2, key = "dr_innervate2", name = "Innervate", need = 29166, talent = true, dkey = "dr_innervate",
		tpl = "#showtooltip {29166}\n/cast [@mouseover,help,nodead][] {29166}" },
	{ class = "DRUID", spec = 2, key = "dr_decurse2", name = "Decurse", need = 2782, talent = true, dkey = "dr_decurse",
		tpl = "#showtooltip {2782}\n/cast [@mouseover,help,nodead][] {2782}" },
	{ class = "DRUID", spec = 3, key = "dr_skullbash3", name = "Skull Bash", need = 106839, talent = true, dkey = "dr_skullbash",
		tpl = "#showtooltip {106839}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {106839}" },
	{ class = "DRUID", spec = 3, key = "dr_moonfire", name = "Moonfire MO", need = 8921, talent = false,
		tpl = "#showtooltip {8921}\n/cast [@mouseover,harm,nodead][] {8921}" },
	{ class = "DRUID", spec = 3, key = "dr_decurse3", name = "Decurse", need = 2782, talent = true, dkey = "dr_decurse",
		tpl = "#showtooltip {2782}\n/cast [@mouseover,help,nodead][] {2782}" },
	{ class = "DRUID", spec = 3, key = "dr_growl", name = "Growl", need = 6795, talent = false,
		tpl = "#showtooltip {6795}\n/cast [@mouseover,harm,nodead][] {6795}" },
	{ class = "DRUID", spec = 4, key = "dr_rejuv", name = "Rejuv MO", need = 774, talent = true,
		tpl = "#showtooltip {774}\n/cast [@mouseover,help,nodead][help,nodead][@player] {774}" },
	{ class = "DRUID", spec = 4, key = "dr_efflo", name = "Efflo Cursor", need = 145205, talent = true,
		tpl = "#showtooltip {145205}\n/cast [@cursor] {145205}" },
	{ class = "DRUID", spec = 4, key = "dr_nsregrowth", name = "NS Regrowth", need = 132158, talent = true,
		tpl = "#showtooltip {8936}\n/cast {132158}\n/cast [@mouseover,help,nodead][help,nodead][@player] {8936}" },
	{ class = "DRUID", spec = 4, key = "dr_innervself", name = "Innervate Me", need = 29166, talent = true,
		tpl = "#showtooltip {29166}\n/cast [@player] {29166}" },
	-- EVOKER
	{ class = "EVOKER", spec = 0, key = "ev_rescue", name = "Rescue", need = 370665, talent = true,
		tpl = "#showtooltip {370665}\n/cast [@mouseover,help,nodead][] {370665}" },
	{ class = "EVOKER", spec = 0, key = "ev_verdant", name = "Verdant", need = 360995, talent = true,
		tpl = "#showtooltip {360995}\n/cast [@mouseover,help,nodead][help,nodead][@player] {360995}" },
	{ class = "EVOKER", spec = 1, key = "ev_quell", name = "Quell", need = 351338, talent = true,
		tpl = "#showtooltip {351338}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {351338}" },
	{ class = "EVOKER", spec = 1, key = "ev_deepbreath", name = "Deep Breath", need = 357210, talent = false,
		tpl = "#showtooltip {357210}\n/cast [@cursor] {357210}" },
	{ class = "EVOKER", spec = 1, key = "ev_cauterize", name = "Cauterize", need = 374251, talent = true,
		tpl = "#showtooltip {374251}\n/cast [@mouseover,help,nodead][] {374251}" },
	{ class = "EVOKER", spec = 2, key = "ev_blossom", name = "Blossom", need = 355913, talent = false,
		tpl = "#showtooltip {355913}\n/cast [@mouseover,help,nodead][help,nodead][@player] {355913}" },
	{ class = "EVOKER", spec = 2, key = "ev_naturalize", name = "Naturalize", need = 360823, talent = false,
		tpl = "#showtooltip {360823}\n/cast [@mouseover,help,nodead][help,nodead][@player] {360823}" },
	{ class = "EVOKER", spec = 2, key = "ev_timedil", name = "Time Dilate", need = 357170, talent = true,
		tpl = "#showtooltip {357170}\n/cast [@mouseover,help,nodead][] {357170}" },
	{ class = "EVOKER", spec = 3, key = "ev_prescience", name = "Prescience", need = 409311, talent = true,
		tpl = "#showtooltip {409311}\n/cast [@mouseover,help,nodead][] {409311}" },
	{ class = "EVOKER", spec = 3, key = "ev_blackattune", name = "Black Attune", need = 395160, talent = true,
		tpl = "#showtooltip {395160}\n/cast [nostance:1] {403264}\n/cast {395160}" },
	{ class = "EVOKER", spec = 3, key = "ev_blistering", name = "Blistering", need = 360827, talent = true,
		tpl = "#showtooltip {360827}\n/cast [@mouseover,help,nodead][] {360827}" },
	-- HUNTER
	{ class = "HUNTER", spec = 1, key = "hu_bm_killcmd", name = "KC + Pet", need = 34026, talent = true,
		tpl = "#showtooltip {34026}\n/petattack\n/cast {34026}\n/use [@pettarget]{16827}\n/use [@pettarget]{17253}\n/use [@pettarget]{49966}" },
	{ class = "HUNTER", spec = 1, key = "hu_bm_trap", name = "Trap Cursor", need = 187650, talent = false,
		tpl = "#showtooltip {187650}\n/cast [@cursor] {187650}" },
	{ class = "HUNTER", spec = 1, key = "hu_bm_turtle", name = "Turtle", need = 186265, talent = false,
		tpl = "#showtooltip {186265}\n/cast {186265}\n/cancelaura {186265}" },
	{ class = "HUNTER", spec = 1, key = "hu_bm_kick", name = "Counter Shot", need = 147362, talent = true,
		tpl = "#showtooltip {147362}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {147362}" },
	{ class = "HUNTER", spec = 1, key = "hu_bm_md", name = "Misdirect", need = 34477, talent = true,
		tpl = "#showtooltip {34477}\n/cast [@mouseover,help,nodead][@focus,help,nodead][@pet,exists,nodead][] {34477}" },
	{ class = "HUNTER", spec = 2, key = "hu_mm_aimed", name = "Aimed NoClip", need = 19434, talent = true,
		tpl = "#showtooltip {19434}\n/cast [nochanneling] {19434}" },
	{ class = "HUNTER", spec = 2, key = "hu_mm_trap", name = "Trap Cursor", need = 187650, talent = false,
		tpl = "#showtooltip {187650}\n/cast [@cursor] {187650}" },
	{ class = "HUNTER", spec = 2, key = "hu_mm_turtle", name = "Turtle", need = 186265, talent = false,
		tpl = "#showtooltip {186265}\n/cast {186265}\n/cancelaura {186265}" },
	{ class = "HUNTER", spec = 2, key = "hu_mm_kick", name = "Counter Shot", need = 147362, talent = true,
		tpl = "#showtooltip {147362}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {147362}" },
	{ class = "HUNTER", spec = 2, key = "hu_mm_md", name = "Misdirect", need = 34477, talent = true,
		tpl = "#showtooltip {34477}\n/cast [@mouseover,help,nodead][@focus,help,nodead][@pet,exists,nodead][] {34477}" },
	{ class = "HUNTER", spec = 3, key = "hu_sv_trap", name = "Trap Cursor", need = 187650, talent = false,
		tpl = "#showtooltip {187650}\n/cast [@cursor] {187650}" },
	{ class = "HUNTER", spec = 3, key = "hu_sv_turtle", name = "Turtle", need = 186265, talent = false,
		tpl = "#showtooltip {186265}\n/cast {186265}\n/cancelaura {186265}" },
	{ class = "HUNTER", spec = 3, key = "hu_sv_md", name = "Misdirect", need = 34477, talent = true,
		tpl = "#showtooltip {34477}\n/cast [@mouseover,help,nodead][@focus,help,nodead][@pet,exists,nodead][] {34477}" },
	{ class = "HUNTER", spec = 3, key = "hu_sv_killcmd", name = "KC Pet Check", need = 259489, talent = true,
		tpl = "#showtooltip {259489}\n/petattack\n/cast [@pet,dead][mod:shift] {982}; [@pet,noexists] {883}; {259489}" },
	{ class = "HUNTER", spec = 3, key = "hu_sv_kick", name = "Muzzle", need = 187707, talent = true,
		tpl = "#showtooltip {187707}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {187707}" },
	-- MAGE
	{ class = "MAGE", spec = 1, key = "ma_ar_iceblock", name = "Ice Block", need = 45438, talent = true,
		tpl = "#showtooltip {45438}\n/stopcasting\n/cast {45438}\n/cancelaura {45438}" },
	{ class = "MAGE", spec = 1, key = "ma_ar_decurse", name = "Decurse", need = 475, talent = true,
		tpl = "#showtooltip {475}\n/cast [@mouseover,help,nodead][help,nodead][@player] {475}" },
	{ class = "MAGE", spec = 1, key = "ma_ar_kick", name = "Counterspell", need = 2139, talent = false,
		tpl = "#showtooltip {2139}\n/stopcasting\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {2139}" },
	{ class = "MAGE", spec = 1, key = "ma_ar_surge", name = "Surge+Trinks", need = 365350, talent = true,
		tpl = "#showtooltip {365350}\n/use 13\n/use 14\n/cast {365350}" },
	{ class = "MAGE", spec = 1, key = "ma_ar_steal", name = "Spellsteal", need = 30449, talent = true,
		tpl = "#showtooltip {30449}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {30449}" },
	{ class = "MAGE", spec = 2, key = "ma_fi_decurse", name = "Decurse", need = 475, talent = true,
		tpl = "#showtooltip {475}\n/cast [@mouseover,help,nodead][help,nodead][@player] {475}" },
	{ class = "MAGE", spec = 2, key = "ma_fi_flamestrike", name = "Flamestrike", need = 2120, talent = true,
		tpl = "#showtooltip {2120}\n/cast [@cursor] {2120}" },
	{ class = "MAGE", spec = 2, key = "ma_fi_kick", name = "Counterspell", need = 2139, talent = false,
		tpl = "#showtooltip {2139}\n/stopcasting\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {2139}" },
	{ class = "MAGE", spec = 2, key = "ma_fi_combust", name = "Combust+Trk", need = 190319, talent = true,
		tpl = "#showtooltip {190319}\n/use 13\n/use 14\n/cast {190319}" },
	{ class = "MAGE", spec = 2, key = "ma_fi_altertime", name = "Alter Cancel", need = 342245, talent = true,
		tpl = "#showtooltip {342245}\n/cancelaura {342246}" },
	{ class = "MAGE", spec = 3, key = "ma_fr_blizzard", name = "Blizzard", need = 190356, talent = true,
		tpl = "#showtooltip {190356}\n/cast [@cursor] {190356}" },
	{ class = "MAGE", spec = 3, key = "ma_fr_decurse", name = "Decurse", need = 475, talent = true,
		tpl = "#showtooltip {475}\n/cast [@mouseover,help,nodead][help,nodead][@player] {475}" },
	{ class = "MAGE", spec = 3, key = "ma_fr_kick", name = "Counterspell", need = 2139, talent = false,
		tpl = "#showtooltip {2139}\n/stopcasting\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {2139}" },
	{ class = "MAGE", spec = 3, key = "ma_fr_iceblock", name = "Ice Block", need = 45438, talent = true,
		tpl = "#showtooltip {45438}\n/stopcasting\n/cast {45438}\n/cancelaura {45438}" },
	{ class = "MAGE", spec = 3, key = "ma_fr_altertime", name = "Alter Cancel", need = 342245, talent = true,
		tpl = "#showtooltip {342245}\n/cancelaura {342246}" },
	-- MONK
	{ class = "MONK", spec = 1, key = "mo_br_provoke", name = "Provoke", need = 115546, talent = false,
		tpl = "#showtooltip {115546}\n/cast [@mouseover,harm,nodead][] {115546}" },
	{ class = "MONK", spec = 1, key = "mo_br_detox", name = "Detox", need = 218164, talent = true,
		tpl = "#showtooltip {218164}\n/cast [@mouseover,help,nodead][help,nodead][@player] {218164}" },
	{ class = "MONK", spec = 1, key = "mo_br_lust", name = "Tiger's Lust", need = 116841, talent = true,
		tpl = "#showtooltip {116841}\n/cast [@mouseover,help,nodead][help,nodead][@player] {116841}" },
	{ class = "MONK", spec = 1, key = "mo_br_kick", name = "Spear Hand", need = 116705, talent = true,
		tpl = "#showtooltip {116705}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {116705}" },
	{ class = "MONK", spec = 1, key = "mo_br_ring", name = "Ring Cursor", need = 116844, talent = true,
		tpl = "#showtooltip {116844}\n/cast [@cursor] {116844}" },
	{ class = "MONK", spec = 2, key = "mo_mw_vivify", name = "Vivify/Rez", need = 116670, talent = false,
		tpl = "#showtooltip {116670}\n/cast [@mouseover,help,dead,nocombat] {115178}; [@mouseover,help,nodead][help,nodead][@player] {116670}" },
	{ class = "MONK", spec = 2, key = "mo_mw_renew", name = "Renewing MO", need = 115151, talent = false,
		tpl = "#showtooltip {115151}\n/cast [@mouseover,help,nodead][help,nodead][@player] {115151}" },
	{ class = "MONK", spec = 2, key = "mo_mw_detox", name = "Detox", need = 115450, talent = false,
		tpl = "#showtooltip {115450}\n/cast [@mouseover,help,nodead][help,nodead][@player] {115450}" },
	{ class = "MONK", spec = 2, key = "mo_mw_soothe", name = "Soothing MO", need = 115175, talent = true,
		tpl = "#showtooltip {115175}\n/cast [@mouseover,help,nodead][help,nodead][@player] {115175}" },
	{ class = "MONK", spec = 2, key = "mo_mw_lust", name = "Tiger's Lust", need = 116841, talent = true,
		tpl = "#showtooltip {116841}\n/cast [@mouseover,help,nodead][help,nodead][@player] {116841}" },
	{ class = "MONK", spec = 3, key = "mo_ww_noclip", name = "TP No Clip", need = 100780, talent = false,
		tpl = "#showtooltip {100780}\n/cast [nochanneling] {100780}" },
	{ class = "MONK", spec = 3, key = "mo_ww_kick", name = "Spear Hand", need = 116705, talent = true,
		tpl = "#showtooltip {116705}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {116705}" },
	{ class = "MONK", spec = 3, key = "mo_ww_detox", name = "Detox", need = 218164, talent = true,
		tpl = "#showtooltip {218164}\n/cast [@mouseover,help,nodead][help,nodead][@player] {218164}" },
	{ class = "MONK", spec = 3, key = "mo_ww_lust", name = "Tiger's Lust", need = 116841, talent = true,
		tpl = "#showtooltip {116841}\n/cast [@mouseover,help,nodead][help,nodead][@player] {116841}" },
	{ class = "MONK", spec = 3, key = "mo_ww_para", name = "Paralysis", need = 115078, talent = true,
		tpl = "#showtooltip {115078}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {115078}" },
	-- PALADIN
	{ class = "PALADIN", spec = 1, key = "pa_ho_shock", name = "Holy Shock", need = 20473, talent = true,
		tpl = "#showtooltip {20473}\n/cast [@mouseover,help,nodead][@mouseover,harm,nodead][] {20473}" },
	{ class = "PALADIN", spec = 1, key = "pa_ho_loh", name = "Lay on Hands", need = 633, talent = true,
		tpl = "#showtooltip {633}\n/stopcasting\n/cast [@mouseover,help,nodead][help,nodead][@player] {633}" },
	{ class = "PALADIN", spec = 1, key = "pa_ho_freedom", name = "Freedom", need = 1044, talent = true,
		tpl = "#showtooltip {1044}\n/stopcasting\n/cast [@mouseover,help,nodead][help,nodead][@player] {1044}" },
	{ class = "PALADIN", spec = 1, key = "pa_ho_sac", name = "Sacrifice", need = 6940, talent = true,
		tpl = "#showtooltip {6940}\n/stopcasting\n/cast [@mouseover,help,nodead][help,nodead] {6940}" },
	{ class = "PALADIN", spec = 1, key = "pa_ho_wog", name = "Word Glory", need = 85673, talent = false,
		tpl = "#showtooltip {85673}\n/cast [@mouseover,help,nodead][help,nodead][@player] {85673}" },
	{ class = "PALADIN", spec = 2, key = "pa_pr_freedom", name = "Freedom", need = 1044, talent = true,
		tpl = "#showtooltip {1044}\n/stopcasting\n/cast [@mouseover,help,nodead][help,nodead][@player] {1044}" },
	{ class = "PALADIN", spec = 2, key = "pa_pr_loh", name = "Lay on Hands", need = 633, talent = true,
		tpl = "#showtooltip {633}\n/stopcasting\n/cast [@mouseover,help,nodead][help,nodead][@player] {633}" },
	{ class = "PALADIN", spec = 2, key = "pa_pr_wog", name = "Word Glory", need = 85673, talent = false,
		tpl = "#showtooltip {85673}\n/cast [@mouseover,help,nodead][help,nodead][@player] {85673}" },
	{ class = "PALADIN", spec = 2, key = "pa_pr_cleanse", name = "Cleanse Tox", need = 213644, talent = true,
		tpl = "#showtooltip {213644}\n/cast [@mouseover,help,nodead][help,nodead][@player] {213644}" },
	{ class = "PALADIN", spec = 2, key = "pa_pr_kick", name = "Rebuke", need = 96231, talent = true,
		tpl = "#showtooltip {96231}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {96231}" },
	{ class = "PALADIN", spec = 3, key = "pa_re_freedom", name = "Freedom", need = 1044, talent = true,
		tpl = "#showtooltip {1044}\n/stopcasting\n/cast [@mouseover,help,nodead][help,nodead][@player] {1044}" },
	{ class = "PALADIN", spec = 3, key = "pa_re_sac", name = "Sacrifice", need = 6940, talent = true,
		tpl = "#showtooltip {6940}\n/stopcasting\n/cast [@mouseover,help,nodead][help,nodead] {6940}" },
	{ class = "PALADIN", spec = 3, key = "pa_re_loh", name = "Lay on Hands", need = 633, talent = true,
		tpl = "#showtooltip {633}\n/stopcasting\n/cast [@mouseover,help,nodead][help,nodead][@player] {633}" },
	{ class = "PALADIN", spec = 3, key = "pa_re_bop", name = "Protect Ally", need = 1022, talent = true,
		tpl = "#showtooltip {1022}\n/stopcasting\n/cast [@mouseover,help,nodead][help,nodead][@player] {1022}" },
	{ class = "PALADIN", spec = 3, key = "pa_re_kick", name = "Rebuke", need = 96231, talent = true,
		tpl = "#showtooltip {96231}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {96231}" },
	-- PRIEST
	{ class = "PRIEST", spec = 1, key = "pr_shield_1", name = "PW Shield", need = 17, talent = false, dkey = "pr_shield",
		tpl = "#showtooltip {17}\n/cast [@mouseover,help,nodead][help,nodead][@player] {17}" },
	{ class = "PRIEST", spec = 1, key = "pr_pi_1", name = "Power Inf", need = 10060, talent = true, dkey = "pr_pi",
		tpl = "#showtooltip {10060}\n/cast [@focus,help,nodead][@mouseover,help,nodead][help,nodead][@player] {10060}" },
	{ class = "PRIEST", spec = 1, key = "pr_feather_1", name = "Feather", need = 121536, talent = true, dkey = "pr_feather",
		tpl = "#showtooltip {121536}\n/cast [mod:alt,@cursor][@player] {121536}" },
	{ class = "PRIEST", spec = 1, key = "pr_dispel_1", name = "Dispel", need = 527, talent = false, dkey = "pr_dispel",
		tpl = "#showtooltip\n/cast [mod:alt,known:32375,@cursor] {32375}; [@mouseover,help,nodead] {527}; [@mouseover,harm,nodead,known:528][harm,nodead,known:528] {528}; {527}",
		tplShort = "#showtooltip\n/cast [mod:alt,@cursor] {32375}; [@mouseover,help,nodead] {527}; [@mouseover,harm,nodead][harm,nodead] {528}; {527}" },
	{ class = "PRIEST", spec = 1, key = "pr_penance", name = "Penance", need = 47540, talent = false,
		tpl = "#showtooltip {47540}\n/cast [@mouseover,exists,nodead][] {47540}" },
	{ class = "PRIEST", spec = 2, key = "pr_sanctify", name = "Sanctify", need = 34861, talent = true,
		tpl = "#showtooltip {34861}\n/cast [@cursor] {34861}" },
	{ class = "PRIEST", spec = 2, key = "pr_pi_2", name = "Power Inf", need = 10060, talent = true, dkey = "pr_pi",
		tpl = "#showtooltip {10060}\n/cast [@focus,help,nodead][@mouseover,help,nodead][help,nodead][@player] {10060}" },
	{ class = "PRIEST", spec = 2, key = "pr_leap", name = "Leap Faith", need = 73325, talent = true,
		tpl = "#showtooltip {73325}\n/cast [@mouseover,help,nodead][] {73325}" },
	{ class = "PRIEST", spec = 2, key = "pr_feather_2", name = "Feather", need = 121536, talent = true, dkey = "pr_feather",
		tpl = "#showtooltip {121536}\n/cast [mod:alt,@cursor][@player] {121536}" },
	{ class = "PRIEST", spec = 2, key = "pr_dispel_2", name = "Dispel", need = 527, talent = false, dkey = "pr_dispel",
		tpl = "#showtooltip\n/cast [mod:alt,known:32375,@cursor] {32375}; [@mouseover,help,nodead] {527}; [@mouseover,harm,nodead,known:528][harm,nodead,known:528] {528}; {527}",
		tplShort = "#showtooltip\n/cast [mod:alt,@cursor] {32375}; [@mouseover,help,nodead] {527}; [@mouseover,harm,nodead][harm,nodead] {528}; {527}" },
	{ class = "PRIEST", spec = 3, key = "pr_silence", name = "Silence", need = 15487, talent = false,
		tpl = "#showtooltip {15487}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {15487}" },
	{ class = "PRIEST", spec = 3, key = "pr_pi_3", name = "Power Inf", need = 10060, talent = true, dkey = "pr_pi",
		tpl = "#showtooltip {10060}\n/cast [@focus,help,nodead][@mouseover,help,nodead][help,nodead][@player] {10060}" },
	{ class = "PRIEST", spec = 3, key = "pr_swpain", name = "SW Pain", need = 589, talent = false,
		tpl = "#showtooltip {589}\n/cast [@mouseover,harm,nodead][] {589}" },
	{ class = "PRIEST", spec = 3, key = "pr_massdispel", name = "Mass Dispel", need = 32375, talent = true,
		tpl = "#showtooltip {32375}\n/cast [@cursor] {32375}" },
	{ class = "PRIEST", spec = 3, key = "pr_dispersion", name = "Dispersion", need = 47585, talent = false,
		tpl = "#showtooltip {47585}\n/stopcasting\n/cancelaura {47585}\n/cast {47585}" },
	-- ROGUE
	{ class = "ROGUE", spec = 1, key = "ro_kick_1", name = "Kick", need = 1766, talent = false, dkey = "ro_kick",
		tpl = "#showtooltip {1766}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {1766}" },
	{ class = "ROGUE", spec = 1, key = "ro_deathmark", name = "Deathmark", need = 360194, talent = true,
		tpl = "#showtooltip {360194}\n/cast {360194}\n/use 13\n/use 14" },
	{ class = "ROGUE", spec = 1, key = "ro_tricks_1", name = "Tricks", need = 57934, talent = true, dkey = "ro_tricks",
		tpl = "#showtooltip {57934}\n/cast [@mouseover,help,nodead][@focus,help,nodead][] {57934}" },
	{ class = "ROGUE", spec = 1, key = "ro_kidney_1", name = "Kidney Shot", need = 408, talent = false, dkey = "ro_kidney",
		tpl = "#showtooltip {408}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {408}" },
	{ class = "ROGUE", spec = 1, key = "ro_blind_1", name = "Blind", need = 2094, talent = true, dkey = "ro_blind",
		tpl = "#showtooltip {2094}\n/cast [@mouseover,harm,nodead][@focus,harm,nodead][] {2094}" },
	{ class = "ROGUE", spec = 2, key = "ro_grapple", name = "Grapple", need = 195457, talent = false,
		tpl = "#showtooltip {195457}\n/cast [@cursor] {195457}" },
	{ class = "ROGUE", spec = 2, key = "ro_kick_2", name = "Kick", need = 1766, talent = false, dkey = "ro_kick",
		tpl = "#showtooltip {1766}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {1766}" },
	{ class = "ROGUE", spec = 2, key = "ro_kidney_2", name = "Kidney Shot", need = 408, talent = false, dkey = "ro_kidney",
		tpl = "#showtooltip {408}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {408}" },
	{ class = "ROGUE", spec = 2, key = "ro_tricks_2", name = "Tricks", need = 57934, talent = true, dkey = "ro_tricks",
		tpl = "#showtooltip {57934}\n/cast [@mouseover,help,nodead][@focus,help,nodead][] {57934}" },
	{ class = "ROGUE", spec = 2, key = "ro_blind_2", name = "Blind", need = 2094, talent = true, dkey = "ro_blind",
		tpl = "#showtooltip {2094}\n/cast [@mouseover,harm,nodead][@focus,harm,nodead][] {2094}" },
	{ class = "ROGUE", spec = 3, key = "ro_dance", name = "Shadow Dance", need = 185313, talent = false,
		tpl = "#showtooltip {185313}\n/cast {185313}\n/cast {121471}\n/cast {280719}" },
	{ class = "ROGUE", spec = 3, key = "ro_cdg", name = "CdG Powder", need = 441423, talent = true,
		tpl = "#showtooltip {319175}\n/cast {441423}\n/cast {319175}" },
	{ class = "ROGUE", spec = 3, key = "ro_shadowstep", name = "Shadowstep", need = 394935, talent = false,
		tpl = "#showtooltip {394935}\n/cast [@mouseover,exists,nodead][] {394935}" },
	{ class = "ROGUE", spec = 3, key = "ro_kick_3", name = "Kick", need = 1766, talent = false, dkey = "ro_kick",
		tpl = "#showtooltip {1766}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {1766}" },
	{ class = "ROGUE", spec = 3, key = "ro_tricks_3", name = "Tricks", need = 57934, talent = true, dkey = "ro_tricks",
		tpl = "#showtooltip {57934}\n/cast [@mouseover,help,nodead][@focus,help,nodead][] {57934}" },
	-- SHAMAN
	{ class = "SHAMAN", spec = 1, key = "sh_quake", name = "Earthquake", need = 61882, talent = true,
		tpl = "#showtooltip {61882}\n/cast [@cursor] {61882}" },
	{ class = "SHAMAN", spec = 1, key = "sh_windshear_1", name = "Wind Shear", need = 57994, talent = true, dkey = "sh_windshear",
		tpl = "#showtooltip {57994}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {57994}" },
	{ class = "SHAMAN", spec = 1, key = "sh_capacitor_1", name = "Capacitor", need = 192058, talent = true, dkey = "sh_capacitor",
		tpl = "#showtooltip {192058}\n/cast [@cursor] {192058}" },
	{ class = "SHAMAN", spec = 1, key = "sh_purge_1", name = "Purge", need = 370, talent = true, dkey = "sh_purge",
		tpl = "#showtooltip {370}\n/cast [@mouseover,harm,nodead][@focus,harm,nodead][] {370}" },
	{ class = "SHAMAN", spec = 1, key = "sh_flameshock", name = "Flame Shock", need = 470411, talent = false,
		tpl = "#showtooltip {470411}\n/cast [@mouseover,harm,nodead][] {470411}" },
	{ class = "SHAMAN", spec = 2, key = "sh_windshear_2", name = "Wind Shear", need = 57994, talent = true, dkey = "sh_windshear",
		tpl = "#showtooltip {57994}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {57994}" },
	{ class = "SHAMAN", spec = 2, key = "sh_surging", name = "Surging", need = 455630, talent = true,
		tpl = "#showtooltip {455630}\n/cast [mod:alt,@cursor][@player] {455630}" },
	{ class = "SHAMAN", spec = 2, key = "sh_selfsurge", name = "Self Surge", need = 8004, talent = false,
		tpl = "#showtooltip {8004}\n/cast [@player] {8004}" },
	{ class = "SHAMAN", spec = 2, key = "sh_capacitor_2", name = "Capacitor", need = 192058, talent = true, dkey = "sh_capacitor",
		tpl = "#showtooltip {192058}\n/cast [@cursor] {192058}" },
	{ class = "SHAMAN", spec = 2, key = "sh_cleanse", name = "Cleanse", need = 51886, talent = true,
		tpl = "#showtooltip {51886}\n/cast [@mouseover,help,nodead][] {51886}" },
	{ class = "SHAMAN", spec = 3, key = "sh_healrain", name = "Healing Rain", need = 73920, talent = true,
		tpl = "#showtooltip {73920}\n/cast [@cursor] {73920}" },
	{ class = "SHAMAN", spec = 3, key = "sh_riptide", name = "Riptide FS", need = 61295, talent = true,
		tpl = "#showtooltip\n/cast [@mouseover,help,nodead][help,nodead] {61295}; [@mouseover,harm,nodead][harm,nodead] {470411}; {61295}" },
	{ class = "SHAMAN", spec = 3, key = "sh_windshear_3", name = "Wind Shear", need = 57994, talent = true, dkey = "sh_windshear",
		tpl = "#showtooltip {57994}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {57994}" },
	{ class = "SHAMAN", spec = 3, key = "sh_purify", name = "Purify", need = 77130, talent = false,
		tpl = "#showtooltip {77130}\n/cast [@mouseover,help,nodead][] {77130}" },
	{ class = "SHAMAN", spec = 3, key = "sh_capacitor_3", name = "Capacitor", need = 192058, talent = true, dkey = "sh_capacitor",
		tpl = "#showtooltip {192058}\n/cast [@cursor] {192058}" },
	-- WARLOCK
	{ class = "WARLOCK", spec = 1, key = "wl_agony", name = "Agony", need = 980, talent = true,
		tpl = "#showtooltip {980}\n/cast [@mouseover,harm,nodead][] {980}" },
	{ class = "WARLOCK", spec = 1, key = "wl_corruption", name = "Corruption", need = 172, talent = false,
		tpl = "#showtooltip {172}\n/cast [@mouseover,harm,nodead][] {172}" },
	{ class = "WARLOCK", spec = 1, key = "wl_interrupt_1", name = "Pet Kick", need = 119898, talent = false, dkey = "wl_interrupt",
		tpl = "#showtooltip\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {119898}" },
	{ class = "WARLOCK", spec = 1, key = "wl_soulstone_1", name = "Soulstone", need = 20707, talent = false, dkey = "wl_soulstone",
		tpl = "#showtooltip {20707}\n/target [@mouseover,noharm,exists]\n/cast [noharm,exists][@player] {20707}\n/targetlasttarget [@mouseover,noharm,exists]" },
	{ class = "WARLOCK", spec = 1, key = "wl_shadowfury_1", name = "Shadowfury", need = 30283, talent = true, dkey = "wl_shadowfury",
		tpl = "#showtooltip {30283}\n/cast [@cursor] {30283}" },
	{ class = "WARLOCK", spec = 2, key = "wl_interrupt_2", name = "Pet Kick", need = 119898, talent = false, dkey = "wl_interrupt",
		tpl = "#showtooltip\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {119898}" },
	{ class = "WARLOCK", spec = 2, key = "wl_demonbolt", name = "Demonbolt", need = 264178, talent = true,
		tpl = "#showtooltip {264178}\n/cast [@mouseover,harm,nodead][] {264178}" },
	{ class = "WARLOCK", spec = 2, key = "wl_soulstone_2", name = "Soulstone", need = 20707, talent = false, dkey = "wl_soulstone",
		tpl = "#showtooltip {20707}\n/target [@mouseover,noharm,exists]\n/cast [noharm,exists][@player] {20707}\n/targetlasttarget [@mouseover,noharm,exists]" },
	{ class = "WARLOCK", spec = 2, key = "wl_shadowfury_2", name = "Shadowfury", need = 30283, talent = true, dkey = "wl_shadowfury",
		tpl = "#showtooltip {30283}\n/cast [@cursor] {30283}" },
	{ class = "WARLOCK", spec = 2, key = "wl_petcontrol", name = "Pet Control", need = 688, talent = false,
		tpl = "/petmoveto [mod:shift,@cursor]\n/petfollow [mod:ctrl]\n/petattack [nomod,@mouseover,harm,nodead][nomod]" },
	{ class = "WARLOCK", spec = 3, key = "wl_havoc", name = "Havoc", need = 80240, talent = true,
		tpl = "#showtooltip {80240}\n/cast [@mouseover,harm,nodead][harm,nodead] {80240}" },
	{ class = "WARLOCK", spec = 3, key = "wl_rainoffire", name = "Rain of Fire", need = 5740, talent = true,
		tpl = "#showtooltip {5740}\n/cast [@cursor] {5740}" },
	{ class = "WARLOCK", spec = 3, key = "wl_infernal", name = "Infernal", need = 1122, talent = true,
		tpl = "#showtooltip {1122}\n/cast [@cursor] {1122}" },
	{ class = "WARLOCK", spec = 3, key = "wl_interrupt_3", name = "Pet Kick", need = 119898, talent = false, dkey = "wl_interrupt",
		tpl = "#showtooltip\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {119898}" },
	{ class = "WARLOCK", spec = 3, key = "wl_soulstone_3", name = "Soulstone", need = 20707, talent = false, dkey = "wl_soulstone",
		tpl = "#showtooltip {20707}\n/target [@mouseover,noharm,exists]\n/cast [noharm,exists][@player] {20707}\n/targetlasttarget [@mouseover,noharm,exists]" },
	-- WARRIOR
	{ class = "WARRIOR", spec = 1, key = "wa_pummel_1", name = "Pummel", need = 6552, talent = false, dkey = "wa_pummel",
		tpl = "#showtooltip {6552}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {6552}" },
	{ class = "WARRIOR", spec = 1, key = "wa_leap_1", name = "Heroic Leap", need = 6544, talent = true, dkey = "wa_leap",
		tpl = "#showtooltip {6544}\n/cast [@cursor] {6544}" },
	{ class = "WARRIOR", spec = 1, key = "wa_execute_1", name = "Execute", need = 163201, talent = false, dkey = "wa_execute",
		tpl = "#showtooltip {163201}\n/cast [@mouseover,harm,nodead][] {163201}" },
	{ class = "WARRIOR", spec = 1, key = "wa_chargevr_1", name = "Charge VR", need = 100, talent = false, dkey = "wa_chargevr",
		tpl = "#showtooltip\n/cast {100}\n/cast {34428}\n/cancelaura {227847}" },
	{ class = "WARRIOR", spec = 1, key = "wa_smash", name = "Smash CDs", need = 167105, talent = true,
		tpl = "#showtooltip {167105}\n/cast {167105}\n/cast {107574}\n/use 13\n/use 14" },
	{ class = "WARRIOR", spec = 2, key = "wa_pummel_2", name = "Pummel", need = 6552, talent = false, dkey = "wa_pummel",
		tpl = "#showtooltip {6552}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {6552}" },
	{ class = "WARRIOR", spec = 2, key = "wa_leap_2", name = "Heroic Leap", need = 6544, talent = true, dkey = "wa_leap",
		tpl = "#showtooltip {6544}\n/cast [@cursor] {6544}" },
	{ class = "WARRIOR", spec = 2, key = "wa_execute_2", name = "Execute", need = 5308, talent = false, dkey = "wa_execute",
		tpl = "#showtooltip {5308}\n/cast [@mouseover,harm,nodead][] {5308}" },
	{ class = "WARRIOR", spec = 2, key = "wa_reck", name = "Reck Avatar", need = 1719, talent = true,
		tpl = "#showtooltip {1719}\n/cast {1719}\n/cast {107574}\n/use 13\n/use 14" },
	{ class = "WARRIOR", spec = 2, key = "wa_chargevr_2", name = "Charge VR", need = 100, talent = false, dkey = "wa_chargevr",
		tpl = "#showtooltip\n/cast {100}\n/cast {34428}\n/cancelaura {227847}" },
	{ class = "WARRIOR", spec = 3, key = "wa_pummel_3", name = "Pummel", need = 6552, talent = false, dkey = "wa_pummel",
		tpl = "#showtooltip {6552}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {6552}" },
	{ class = "WARRIOR", spec = 3, key = "wa_taunt", name = "Taunt", need = 355, talent = false,
		tpl = "#showtooltip {355}\n/cast [@mouseover,harm,nodead][] {355}" },
	{ class = "WARRIOR", spec = 3, key = "wa_intervene", name = "Intervene", need = 3411, talent = true,
		tpl = "#showtooltip\n/cast [@mouseover,help,nodead] {3411}; [harm,nodead] {100}" },
	{ class = "WARRIOR", spec = 3, key = "wa_leap_3", name = "Heroic Leap", need = 6544, talent = true, dkey = "wa_leap",
		tpl = "#showtooltip {6544}\n/cast [@cursor] {6544}" },
	{ class = "WARRIOR", spec = 3, key = "wa_ignorepain", name = "IP Slam", need = 190456, talent = true,
		tpl = "#showtooltip {23922}\n/cast {190456}\n/cast {23922}" },
}

local MAX_LEN = 255

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
			return n
		end
	end
	return nil
end

local function KnownSpell(id)
	local fns = { IsPlayerSpell, C_SpellBook and C_SpellBook.IsSpellKnown }
	for i = 1, 2 do
		local fn = fns[i]
		if fn then
			local ok, v = pcall(fn, id)
			if ok and v == true then
				return true
			end
		end
	end
	return false
end

--- Template → macro text in the client's language, or nil when a spell name cannot be read.
local function FillTpl(tpl)
	local bad = false
	local out = tpl:gsub("{(%d+)}", function(id)
		local nm = SpellName(tonumber(id))
		if not nm then
			bad = true
			return ""
		end
		return nm
	end)
	if bad then
		return nil
	end
	return out
end

local function Body(row)
	local body = FillTpl(row.tpl)
	if body and #body > MAX_LEN and row.tplShort then
		body = FillTpl(row.tplShort)
	end
	return body
end

--- The rows for this class + spec. In the guide preview (another class/spec) every row shows, Make stays off.
function ns.MH_GetTopMacroList()
	local token, specIdx, isPreview = ns.MH_GetMacroClassSpecContext()
	if not token then
		return nil
	end
	if not specIdx or specIdx < 1 then
		return nil, token, specIdx or 0
	end
	local list = {}
	for _, r in ipairs(TOP_MACROS) do
		-- spec 0 = in the top 5 of every spec of that class.
		if r.class == token and (r.spec == specIdx or r.spec == 0) and (isPreview or not r.talent or KnownSpell(r.need)) then
			local desc = ns:L("RMAC_" .. (r.dkey or r.key):upper()) -- dkey: twins in several specs share one text
			if r.warn == "channelbug" then
				desc = desc .. "\n|cffffd200" .. ns:L("MACROS_WARN_CHANNELBUG") .. "|r"
			end
			list[#list + 1] = {
				name = SpellName(r.need) or r.name,
				macroName = r.name,
				desc = desc,
				row = r,
			}
		end
	end
	if #list < 1 then
		return nil, token, specIdx
	end
	return list, token, specIdx
end

--- body, reason, token, specIdx, specName, entryName, entryDesc, makeName (same shape as the other kinds + one).
function ns.MH_GetTopMacroContext(panel)
	local list, token, specIdx = ns.MH_GetTopMacroList()
	local _t, _s, isPreview, _c, specName = ns.MH_GetMacroClassSpecContext()
	if not list then
		if not token then
			return nil, "noclass", nil, 0, nil, nil, nil
		end
		if not specIdx or specIdx < 1 then
			return nil, "nospec", token, specIdx, specName, nil, nil
		end
		return nil, "empty", token, specIdx, specName, nil, nil
	end
	local idx = (panel and panel._mhMacrosPickIndex and panel._mhMacrosPickIndex.top) or 1
	if idx < 1 or idx > #list then
		idx = 1
	end
	local e = list[idx]
	if not isPreview and not KnownSpell(e.row.need) then
		return nil, "train", token, specIdx, specName, e.name, e.desc
	end
	local body = Body(e.row)
	if not body then
		return nil, "empty", token, specIdx, specName, e.name, e.desc
	end
	return body, nil, token, specIdx, specName, e.name, e.desc, (not isPreview) and e.macroName or nil
end

--------------------------------------------------------------------------------
-- The older kinds (Interrupt, Utility) carry ENGLISH spell names in their text. Rob, 10 Nov 2026: "Ja zet om".
-- ns.MH_LocalizeMacroBody swaps each English name it knows for the client's own name, by spell id, at the exact
-- places a name sits (after the last "]" of a /cast-like clause, in a castsequence list, after "channeling:").
-- A name it does not know stays as it was, so on an English client nothing changes. Ids: NAME_IDS (measured).
--------------------------------------------------------------------------------
-- 84 names, GEMETEN 10 Nov 2026 in wago DB2 retail 12.1.5.70783: each id is a player spell (skill line, spec spell
-- or class talent node), its enUS name equals the key, and every player id with that English name has the same
-- name in deDE/frFR/esES/ptBR/itIT/ruRU/koKR/zh (esMX differs only in case for Rain of Fire).
local NAME_IDS = {
	["Aimed Shot"] = 19434,
	["Aspect of the Turtle"] = 186265,
	["Barbed Shot"] = 217200,
	["Beacon of Light"] = 53563,
	["Bite"] = 17253, -- hunter pet basic attack
	["Blessing of Protection"] = 1022,
	["Blind"] = 2094,
	["Blizzard"] = 190356,
	["Capacitor Totem"] = 192058,
	["Champion's Spear"] = 376079,
	["Claw"] = 16827, -- hunter pet basic attack
	["Command Demon"] = 119898,
	["Counter Shot"] = 147362,
	["Counterspell"] = 2139,
	["Death Grip"] = 49576,
	["Death and Decay"] = 43265,
	["Deep Breath"] = 357210,
	["Disrupt"] = 183752,
	["Divine Shield"] = 642,
	["Earthquake"] = 61882,
	["Efflorescence"] = 145205,
	["Emerald Blossom"] = 355913,
	["Eruption"] = 395160,
	["Execution Sentence"] = 343527,
	["Fear"] = 5782,
	["Flame Shock"] = 470411,
	["Flamestrike"] = 2120,
	["Freezing Trap"] = 187650,
	["Grappling Hook"] = 195457,
	["Growl"] = 6795, -- druid
	["Hand of Reckoning"] = 62124,
	["Harpoon"] = 190925,
	["Havoc"] = 80240,
	["Healing Rain"] = 73920,
	["Heroic Leap"] = 6544,
	["Holy Word: Sanctify"] = 34861,
	["Hover"] = 358267,
	["Hunter's Mark"] = 257284,
	["Ice Block"] = 45438,
	["Intervene"] = 3411,
	["Kick"] = 1766,
	["Kill Command"] = 34026, -- Survival's own is 259489, same name in every measured locale
	["Leap of Faith"] = 73325,
	["Metamorphosis"] = 191427, -- Vengeance's 187827 overrides it, same name in every measured locale
	["Mind Blast"] = 8092,
	["Mind Freeze"] = 47528,
	["Misdirection"] = 34477,
	["Muzzle"] = 187707,
	["Polymorph"] = 118,
	["Power Word: Barrier"] = 62618,
	["Power Word: Shield"] = 17,
	["Provoke"] = 115546,
	["Pummel"] = 6552,
	["Quell"] = 351338,
	["Rain of Fire"] = 5740,
	["Rapid Fire"] = 257044,
	["Ravager"] = 228920,
	["Rebuke"] = 96231,
	["Regrowth"] = 8936,
	["Rejuvenation"] = 774,
	["Remove Corruption"] = 2782,
	["Rescue"] = 370665,
	["Ring of Peace"] = 116844,
	["Riptide"] = 61295,
	["Shadow Word: Madness"] = 335467,
	["Sigil of Flame"] = 204596,
	["Silence"] = 15487,
	["Skull Bash"] = 106839,
	["Smack"] = 49966, -- hunter pet basic attack
	["Solar Beam"] = 78675,
	["Spear Hand Strike"] = 116705,
	["Summon Black Ox Statue"] = 115315,
	["Summon Jade Serpent Statue"] = 115313,
	["Tentacle Slam"] = 1227280,
	["Tiger Palm"] = 100780,
	["Torment"] = 185245,
	["Tricks of the Trade"] = 57934,
	["Ursol's Vortex"] = 102793,
	["Verdant Embrace"] = 360995,
	["Vivify"] = 116670,
	["Void Torrent"] = 263165,
	["Voidform"] = 228260,
	["Volley"] = 260243,
	["Wind Shear"] = 57994,
}

local function LocalName(name)
	local id = NAME_IDS[name]
	return id and SpellName(id) or nil
end

local function SwapName(s)
	local lead, bang, core, trail = s:match("^(%s*)(!?)(.-)(%s*)$")
	local loc = core and LocalName(core)
	if not loc then
		return s
	end
	return lead .. bang .. loc .. trail
end

local function SwapClause(clause, isSeq)
	local cond, name = clause:match("^(.*%])(.*)$")
	if not cond then
		cond, name = "", clause
	end
	if isSeq then
		local reset, list = name:match("^(%s*reset=%S+%s*)(.*)$")
		if not reset then
			reset, list = "", name
		end
		local parts = {}
		for p in (list .. ","):gmatch("([^,]*),") do
			parts[#parts + 1] = SwapName(p)
		end
		return cond .. reset .. table.concat(parts, ",")
	end
	return cond .. SwapName(name)
end

function ns.MH_LocalizeMacroBody(body)
	if type(body) ~= "string" or not next(NAME_IDS) then
		return body
	end
	local out = {}
	for line in (body .. "\n"):gmatch("([^\n]*)\n") do
		line = line:gsub("(channeling:)([^%],;]+)", function(k, nm)
			return k .. (LocalName(nm) or nm)
		end)
		local cmd, rest = line:match("^(#showtooltip%s+)(.+)$")
		if not cmd then
			cmd, rest = line:match("^(/[%a]+%s+)(.+)$")
			local c = cmd and cmd:lower():gsub("%s+$", "")
			if c ~= "/cast" and c ~= "/use" and c ~= "/castsequence" and c ~= "/cancelaura" then
				cmd = nil
			end
		end
		if cmd then
			local isSeq = cmd:lower():find("^/castsequence") ~= nil
			local clauses = {}
			for cl in (rest .. ";"):gmatch("([^;]*);") do
				clauses[#clauses + 1] = SwapClause(cl, isSeq)
			end
			line = cmd .. table.concat(clauses, ";")
		end
		out[#out + 1] = line
	end
	return table.concat(out, "\n")
end

-- First kind in the Macros tab.
if ns.MacroPanelTypes then
	table.insert(ns.MacroPanelTypes, 1, {
		id = "top",
		labelKey = "MACROS_TYPE_TOP",
		subtitleKey = "MACROS_TOP_SUBTITLE",
		getList = function()
			return ns.MH_GetTopMacroList()
		end,
		getContext = function(panel)
			return ns.MH_GetTopMacroContext(panel)
		end,
	})
end

--- Part of /mh macrocheck — what each row of this spec would write now (a module that can stay quiet needs that).
function ns.MH_TopMacrosCheck()
	local prefix = "|cffffcc00Midnight Helper:|r "
	local token, specIdx = ns.MH_GetMacroClassSpecContext()
	local n = 0
	for _, r in ipairs(TOP_MACROS) do
		if r.class == token and (r.spec == specIdx or r.spec == 0) then
			n = n + 1
			local body = Body(r)
			print(("%s%s [%s%s]: %s"):format(prefix, r.name, KnownSpell(r.need) and "known" or "not known",
				r.talent and ", talent" or "", body and ("%d bytes | %s"):format(#body, (body:gsub("\n", " | "))) or "no text"))
		end
	end
	print(("%stop macros: %s spec %s, %d rows in the data"):format(prefix, tostring(token), tostring(specIdx), n))
end
