local _, ns = ...

--[[
	Midnight enchants by the id an item link carries (item:<itemID>:<enchantID>:...), so the character
	panel can say per slot whether the enchant on it is one MH advises (Rob, 22 Oct 2026: option C).

	MEASURED by mh-research in Blizzard's DB2 on wago.tools, build 12.1.5.70448, 22 Oct 2026 (SpellEffect,
	CraftingDataEnchantQuality, ItemEffect, SpellItemEnchantment; PTR 12.1.7.70424 identical). The full table
	with the DB2 row of every value is in the side-session note enchant_ids_2026-10-22.md. Generated from it
	by a script, not typed. Profession-tool enchants are left out (not one of the slots we check).
	⚠️ Do not infer a rank or a sibling from an id: the pairs are not always +1 (Thalassian Scout sits between
	Forest Hunter's and Blood Knight's; Sunfire Silk's rank 1 is item 240094, not 240134).

	Row: { slot, English name, rank (1/2), recipe or item spell id, item id }. The name is for matching and
	for a fallback only; the panel shows the name the player's client writes in the tooltip.
]]

ns.MH_ENCHANT_IDS = {
	[7988] = { "HEAD", "Blessing of Speed", 1, 1236070, 243978 },
	[7989] = { "HEAD", "Blessing of Speed", 2, 1236070, 243979 },
	[7990] = { "HEAD", "Empowered Blessing of Speed", 1, 1236071, 243980 },
	[7991] = { "HEAD", "Empowered Blessing of Speed", 2, 1236071, 243981 },
	[7960] = { "HEAD", "Empowered Hex of Leeching", 1, 1236056, 243950 },
	[7961] = { "HEAD", "Empowered Hex of Leeching", 2, 1236056, 243951 },
	[8016] = { "HEAD", "Empowered Rune of Avoidance", 1, 1236084, 244006 },
	[8017] = { "HEAD", "Empowered Rune of Avoidance", 2, 1236084, 244007 },
	[7958] = { "HEAD", "Hex of Leeching", 1, 1236055, 243948 },
	[7959] = { "HEAD", "Hex of Leeching", 2, 1236055, 243949 },
	[8014] = { "HEAD", "Rune of Avoidance", 1, 1236083, 244004 },
	[8015] = { "HEAD", "Rune of Avoidance", 2, 1236083, 244005 },
	[7972] = { "SHOULDER", "Akil'zon's Swiftness", 1, 1236062, 243962 },
	[7973] = { "SHOULDER", "Akil'zon's Swiftness", 2, 1236062, 243963 },
	[8000] = { "SHOULDER", "Amirdrassil's Grace", 1, 1236076, 243990 },
	[8001] = { "SHOULDER", "Amirdrassil's Grace", 2, 1236076, 243991 },
	[7970] = { "SHOULDER", "Flight of the Eagle", 1, 1236061, 243960 },
	[7971] = { "SHOULDER", "Flight of the Eagle", 2, 1236061, 243961 },
	[7998] = { "SHOULDER", "Nature's Grace", 1, 1236075, 243988 },
	[7999] = { "SHOULDER", "Nature's Grace", 2, 1236075, 243989 },
	[8030] = { "SHOULDER", "Silvermoon's Mending", 1, 1236091, 244020 },
	[8031] = { "SHOULDER", "Silvermoon's Mending", 2, 1236091, 244021 },
	[8028] = { "SHOULDER", "Thalassian Recovery", 1, 1236090, 244018 },
	[8029] = { "SHOULDER", "Thalassian Recovery", 2, 1236090, 244019 },
	[7956] = { "CHEST", "Mark of Nalorakk", 1, 1236054, 243946 },
	[7957] = { "CHEST", "Mark of Nalorakk", 2, 1236054, 243947 },
	[8012] = { "CHEST", "Mark of the Magister", 1, 1236082, 244002 },
	[8013] = { "CHEST", "Mark of the Magister", 2, 1236082, 244003 },
	[7984] = { "CHEST", "Mark of the Rootwarden", 1, 1236068, 243974 },
	[7985] = { "CHEST", "Mark of the Rootwarden", 2, 1236068, 243975 },
	[7986] = { "CHEST", "Mark of the Worldsoul", 1, 1236069, 243976 },
	[7987] = { "CHEST", "Mark of the Worldsoul", 2, 1236069, 243977 },
	[7936] = { "LEGS", "Arcanoweave Spellthread", 1, 1229453, 240154 },
	[7937] = { "LEGS", "Arcanoweave Spellthread", 2, 1229454, 240155 },
	[8162] = { "LEGS", "Blood Knight's Armor Kit", 1, 1243979, 244642 },
	[8163] = { "LEGS", "Blood Knight's Armor Kit", 2, 1243980, 244643 },
	[7938] = { "LEGS", "Bright Linen Spellthread", 1, 1229456, 240156 },
	[7939] = { "LEGS", "Bright Linen Spellthread", 2, 1229457, 240157 },
	[8158] = { "LEGS", "Forest Hunter's Armor Kit", 1, 1243975, 244640 },
	[8159] = { "LEGS", "Forest Hunter's Armor Kit", 2, 1243976, 244641 },
	[7934] = { "LEGS", "Sunfire Silk Spellthread", 1, 1229437, 240094 },
	[7935] = { "LEGS", "Sunfire Silk Spellthread", 2, 1229442, 240133 },
	[8160] = { "LEGS", "Thalassian Scout Armor Kit", 1, 1243977, 244644 },
	[8161] = { "LEGS", "Thalassian Scout Armor Kit", 2, 1243978, 244645 },
	[8018] = { "FEET", "Farstrider's Hunt", 1, 1236085, 244008 },
	[8019] = { "FEET", "Farstrider's Hunt", 2, 1236085, 244009 },
	[7962] = { "FEET", "Lynx's Dexterity", 1, 1236057, 243952 },
	[7963] = { "FEET", "Lynx's Dexterity", 2, 1236057, 243953 },
	[7992] = { "FEET", "Shaladrassil's Roots", 1, 1236072, 243982 },
	[7993] = { "FEET", "Shaladrassil's Roots", 2, 1236072, 243983 },
	[7964] = { "FINGER", "Amani Mastery", 1, 1236058, 243954 },
	[7965] = { "FINGER", "Amani Mastery", 2, 1236058, 243955 },
	[7966] = { "FINGER", "Eyes of the Eagle", 1, 1236059, 243956 },
	[7967] = { "FINGER", "Eyes of the Eagle", 2, 1236059, 243957 },
	[7996] = { "FINGER", "Nature's Fury", 1, 1236074, 243986 },
	[7997] = { "FINGER", "Nature's Fury", 2, 1236074, 243987 },
	[7994] = { "FINGER", "Nature's Wrath", 1, 1236073, 243984 },
	[7995] = { "FINGER", "Nature's Wrath", 2, 1236073, 243985 },
	[8024] = { "FINGER", "Silvermoon's Alacrity", 1, 1236088, 244014 },
	[8025] = { "FINGER", "Silvermoon's Alacrity", 2, 1236088, 244015 },
	[8026] = { "FINGER", "Silvermoon's Tenacity", 1, 1236089, 244016 },
	[8027] = { "FINGER", "Silvermoon's Tenacity", 2, 1236089, 244017 },
	[8020] = { "FINGER", "Thalassian Haste", 1, 1236086, 244010 },
	[8021] = { "FINGER", "Thalassian Haste", 2, 1236086, 244011 },
	[8022] = { "FINGER", "Thalassian Versatility", 1, 1236087, 244012 },
	[8023] = { "FINGER", "Thalassian Versatility", 2, 1236087, 244013 },
	[7968] = { "FINGER", "Zul'jin's Mastery", 1, 1236060, 243958 },
	[7969] = { "FINGER", "Zul'jin's Mastery", 2, 1236060, 243959 },
	[8038] = { "WEAPON", "Acuity of the Ren'dorei", 1, 1236095, 244028 },
	[8039] = { "WEAPON", "Acuity of the Ren'dorei", 2, 1236095, 244029 },
	[8040] = { "WEAPON", "Arcane Mastery", 1, 1236097, 244030 },
	[8041] = { "WEAPON", "Arcane Mastery", 2, 1236097, 244031 },
	[7982] = { "WEAPON", "Berserker's Rage", 1, 1236067, 243972 },
	[7983] = { "WEAPON", "Berserker's Rage", 2, 1236067, 243973 },
	[8036] = { "WEAPON", "Flames of the Sin'dorei", 1, 1236094, 244026 },
	[8037] = { "WEAPON", "Flames of the Sin'dorei", 2, 1236094, 244027 },
	[7980] = { "WEAPON", "Jan'alai's Precision", 1, 1236066, 243970 },
	[7981] = { "WEAPON", "Jan'alai's Precision", 2, 1236066, 243971 },
	[8688] = { "WEAPON", "Rite of the Hash'ey", 1, 1291694, 273071 },
	[8689] = { "WEAPON", "Rite of the Hash'ey", 2, 1291694, 273072 },
	[7978] = { "WEAPON", "Strength of Halazzi", 1, 1236065, 243968 },
	[7979] = { "WEAPON", "Strength of Halazzi", 2, 1236065, 243969 },
	[8008] = { "WEAPON", "Worldsoul Aegis", 1, 1236080, 243998 },
	[8009] = { "WEAPON", "Worldsoul Aegis", 2, 1236080, 243999 },
	[8006] = { "WEAPON", "Worldsoul Cradle", 1, 1236079, 243996 },
	[8007] = { "WEAPON", "Worldsoul Cradle", 2, 1236079, 243997 },
	[8010] = { "WEAPON", "Worldsoul Tenacity", 1, 1236081, 244000 },
	[8011] = { "WEAPON", "Worldsoul Tenacity", 2, 1236081, 244001 },
	[8614] = { "RANGED_WEAPON", "Farstrider's Hawkeye", 1, 1262341, 257745 },
	[8615] = { "RANGED_WEAPON", "Farstrider's Hawkeye", 2, 1262344, 257746 },
	[8612] = { "RANGED_WEAPON", "Smuggler's Lynxeye", 1, 1262297, 257747 },
	[8613] = { "RANGED_WEAPON", "Smuggler's Lynxeye", 2, 1262300, 257748 },
}

--- Death Knight runeforges are enchant ids too (same measurement). A DK gets no weapon advice from MH, so these
--- are shown without a verdict rather than as "not our advice".
ns.MH_DK_RUNEFORGES = {
	[3368] = "Rune of the Fallen Crusader", -- spell 53344
	[3370] = "Rune of Razorice", -- spell 53343
	[3847] = "Rune of the Stoneskin Gargoyle", -- spell 62158
	[6241] = "Rune of Sanguination", -- spell 326805
	[6242] = "Rune of Spellwarding", -- spell 326855
	[6243] = "Rune of Hysteria", -- spell 326911
	[6244] = "Rune of Unending Thirst", -- spell 326977
	[6245] = "Rune of the Apocalypse", -- spell 327082
}
