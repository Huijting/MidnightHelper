local _, ns = ...

-- ForeverDungeonGuideData.lua - GENERATED 18 Nov 2026 (dg_gen.lua, build chat scratchpad) from the mh-research data
-- of that day. Do not edit by hand: change the source data and generate again. Sources and dates per line in
-- docs/forever/DUNGEONGIDS_DATA_2026-11-18.md; the texts are FDG_* keys in Locales/enUS.lua (and the packs).
-- npc ids GEMETEN (Wowhead Forever tooltips), encounter ids + boss names per language GEMETEN (DB2 DungeonEncounter
-- 1.60.1.70959) except where a comment says otherwise; item ids + 'Dropped by' GEMETEN (Wowhead Forever); roles AFGELEID.
-- one = a line has one source only (the guide says so); recheck = new Forever dungeon, check again later (Rob).
-- Step 2a (same day, later): 11 dungeons ~28-55 (dg2_gen.lua); part = wing (FDGP_* key: Scarlet Monastery, Maraudon), a header
-- in the text; extraNpc may be a list (The Lost Dwarves).
-- Sources of step 2a: docs/forever/DUNGEONGIDS_DATA2A_2026-11-18.md.

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_DGUIDE = {
	[389] = { -- RFC
		bosses = {
			{ npc = 11517, encounter = 2732, name = "Oggleflint",
				names = { deDE = "Flintauge", frFR = "Lorgnesilex", esES = "Ogglesílex", esMX = "Ogglesílex", ptBR = "Pederneiro", ruRU = "Огглфлинт" },
				does = { "FDG_RFC_1_D1", "FDG_RFC_1_D2" },
				tip = "FDG_RFC_1_T",
				-- src: cleave 2x IV+MOB; troggs 2x MOB+WH (WT ook); tip 2x MOB+WH (WT ook)
			},
			{ npc = 11520, encounter = 2733, name = "Taragaman the Hungerer",
				names = { deDE = "Taragaman der Hungerleider", frFR = "Taragaman l’Affameur", esES = "Taragaman el Hambriento", esMX = "Taragaman el Hambriento", ptBR = "Taragaman, o Famélico", ruRU = "Тарагаман Ненасытный" },
				does = { "FDG_RFC_2_D1", "FDG_RFC_2_D2" },
				tip = "FDG_RFC_2_T",
				-- src: 2x IV+MOB (WH zegt hetzelfde)
			},
			{ npc = 11518, encounter = 2734, name = "Jergosh the Invoker",
				names = { deDE = "Jergosh der Herbeirufer", frFR = "Jergosh l’Invocateur", esES = "Jergosh el Convocador", esMX = "Jergosh el Convocador", ptBR = "Jergosh, o Invocador", ruRU = "Жергош Призыватель Духов" },
				does = { "FDG_RFC_3_D1", "FDG_RFC_3_D2" },
				tip = "FDG_RFC_3_T",
				-- src: 2x IV+MOB (WH zegt hetzelfde)
			},
			{ npc = 11519, encounter = 2735, name = "Bazzalan",
				names = { deDE = "Bazzalan", frFR = "Bazzalan", esES = "Bazzalan", esMX = "Bazzalan", ptBR = "Bazzalan", ruRU = "Баззалан" },
				does = { "FDG_RFC_4_D1", "FDG_RFC_4_D2" },
				tip = "FDG_RFC_4_T",
				-- src: does 2x IV+MOB; eerst doden 2x IV+WH (MOB zegt het in de tekst, maar 'adds first' in de DPS-regel); gif weghalen 2x MOB+WT
			},
		},
		loot = {
			{ item = 272996, boss = 11517, role = "FDG_RFC_L1" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 14150, boss = 11518, role = "FDG_RFC_L2" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 14145, boss = 11520, role = "FDG_RFC_L3" }, -- src: WHT Dropped by + FC + IV + MOB
		},
	},
	[3065] = { -- THANES
		bosses = {
			{ npc = 261306, encounter = 3493, name = "Faldrim Anvilmar", recheck = true,
				names = { deDE = "Faldrim Anvilmar", frFR = "Faldrim Courbenclume", esES = "Faldrim Yunquemar", esMX = "Faldrim Yunquemar", ptBR = "Faldrim Sidermar", ruRU = "Фалдрим Старая Наковальня" },
				does = { "FDG_THANES_1_D1", "FDG_THANES_1_D2", "FDG_THANES_1_D3" },
				tip = "FDG_THANES_1_T",
				-- src: rondlopen 2x IV+WT; curse 2x IV+MOB (WT: 20%, 10 min); blast 2x IV+WT; tip 2x IV+WT (GS ook)
			},
			{ npc = 261316, encounter = 3495, name = "Magmatus", recheck = true,
				names = { deDE = "Magmatus", frFR = "Magmatus", esES = "Magmatus", esMX = "Magmatus", ptBR = "Magmatus", ruRU = "Магматий" },
				does = { "FDG_THANES_2_D1", "FDG_THANES_2_D2", "FDG_THANES_2_D3" },
				tip = "FDG_THANES_2_T",
				-- src: summoner 2x IV+WT; vuur rond hem 2x IV+WT; brand op willekeurige speler 2x IV+GS (MOB beschrijft het als een vuurring rond hem); tip 2x IV+WT | DB2 encounter name: Infurnus | MEASURE: Name: DB2 encounter 3495 = 'Infurnus'; Wowhead npc 261316 and every guide = 'Magmatus'. Which name does the client show?
			},
			{ npc = 261311, encounter = 3494, name = "Plunder", recheck = true,
				names = { deDE = "Schleppweg", frFR = "Pilleur", esES = "Pillaje", esMX = "Saqueador", ptBR = "Pilhar", ruRU = "Крад" },
				does = { "FDG_THANES_3_D1", "FDG_THANES_3_D2" },
				tip = "FDG_THANES_3_T",
				-- src: knockback 2x IV+MOB (WT ook); charge 2x MOB+WT (CQ ook); tip 2x IV+WT (GS, CQ ook)
			},
			{ npc = 261319, encounter = 3496, name = "Durgen Dirgehammer", recheck = true,
				names = { deDE = "Durgen Dirgehammer", frFR = "Durgen Mornemartel", esES = "Durgen Martillo Funesto", esMX = "Durgen Martillo de Endecha", ptBR = "Durgen Martelúgubre", ruRU = "Дарген Сокрушающий Молот" },
				does = { "FDG_THANES_4_D1", "FDG_THANES_4_D2" },
				tip = "FDG_THANES_4_T",
				-- src: 2x IV+MOB (WT, GS ook)
			},
		},
		loot = {
			{ item = 271095, boss = 261316, role = "FDG_THANES_L1", recheck = true }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 271098, boss = 261311, role = "FDG_THANES_L2", recheck = true }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 270256, boss = 261319, role = "FDG_THANES_L3", recheck = true }, -- src: WHT Dropped by + FC + IV + MOB
		},
	},
	[2999] = { -- LORD
		bosses = {
			{ npc = 250483, encounter = 3353, name = "Witherfang", recheck = true,
				names = { deDE = "Welkzahn", frFR = "Croc-Flétri", esES = "Colmimarchito", esMX = "Marchitacolmillos", ptBR = "Sugapresa", ruRU = "Сухожвал" },
				does = { "FDG_LORD_1_D1", "FDG_LORD_1_D2" },
				tip = "FDG_LORD_1_T",
				-- src: spinnen 2x IV+MOB; gif 2x IV+MOB; leegzuigen 2x GS+RF; tip 2x GS+RF
			},
			{ npc = 250631, encounter = 3357, name = "The Abandoned", recheck = true,
				names = { deDE = "Der Verlassene", frFR = "L’Abandonné", esES = "El Abandonado", esMX = "El Abandonado", ptBR = "O Abandonado", ruRU = "Покинутый" },
				does = { "FDG_LORD_2_D1", "FDG_LORD_2_D2" },
				tip = "FDG_LORD_2_T",
				-- src: golven 2x IV+MOB (GS, MG ook); vaardigheden 2x IV+MOB; volle mana 2x MM+WFG; onderbreken 2x IV+MOB
			},
			{ npc = 250660, encounter = 3355, name = "The Baron", recheck = true,
				names = { deDE = "Der Baron", frFR = "Le baron", esES = "El barón", esMX = "El barón", ptBR = "O Barão", ruRU = "Барон" },
				does = { "FDG_LORD_3_D1", "FDG_LORD_3_D2" },
				tip = "FDG_LORD_3_T",
				-- src: cleave 2x IV+MOB; knock + threat 2x IV+MOB (GS ook); volle health 2x MG+RF; terug-taunten 2x IV+GS; achter hem 2x IV+RF | DB2 encounter name: The Butcher | MEASURE: Name: DB2 encounter 3355 = 'The Butcher'; Wowhead npc 250660, FC and the guides = 'The Baron'. Which name does the client show?
			},
			{ npc = 256035, encounter = 3411, name = "Viktor the Vile", optional = true, recheck = true,
				names = { deDE = "Viktor der Üble", frFR = "Viktor le Vil", esES = "Viktor el Abyecto", esMX = "Viktor, el Vil", ptBR = "Viktor, o Vil", ruRU = "Виктор Вероломный" },
				does = { "FDG_LORD_4_D1", "FDG_LORD_4_D2" },
				tip = "FDG_LORD_4_T",
				-- src: optioneel 2x GS+MG; vuur + golven 2x IV+MOB (5 golven: GS+MG); hard slaan 2x GS+MG; tip 2x IV+MOB
			},
			{ npc = 256097, encounter = 3412, name = "Bjork", recheck = true,
				names = { deDE = "Bjork", frFR = "Bjork", esES = "Bjork", esMX = "Bjork", ptBR = "Bjork", ruRU = "Бьорк" },
				does = { "FDG_LORD_5_D1", "FDG_LORD_5_D2" },
				tip = "FDG_LORD_5_T",
				-- src: knockback 2x IV+MOB; magieschild 2x GS+MG; tip 2x IV+MG
			},
			{ npc = 250657, encounter = 3354, name = "Rath'mael", recheck = true,
				names = { deDE = "Rath'mael", frFR = "Rath’mael", esES = "Rath'mael", esMX = "Rath'mael", ptBR = "Rath'mael", ruRU = "Рат'маэль" },
				does = { "FDG_LORD_6_D1", "FDG_LORD_6_D2" },
				tip = "FDG_LORD_6_T",
				-- src: vuurveld 2x IV+MOB (op plek tank: GS+RF); puls rond hem 2x IV+MOB; tip 2x IV+MOB (wegstappen: GS+MG)
			},
			{ encounter = 3408, name = "Lordaeron Captain", rare = true, recheck = true,
				names = { deDE = "Hauptmann von Lordaeron", frFR = "Capitaine de Lordaeron", esES = "Capitán de Lordaeron", esMX = "Capitán de Lordaeron", ptBR = "Capitão de Lordaeron", ruRU = "Лордеронский капитан" },
				does = { "FDG_LORD_7_D1", "FDG_LORD_7_D2" },
				tip = "FDG_LORD_7_T",
				-- src: 2x IV+MM
			},
		},
		loot = {
			{ item = 271203, boss = 250483, role = "FDG_LORD_L1", recheck = true }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 271216, boss = 250631, role = "FDG_LORD_L2", recheck = true }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 271213, boss = 250657, role = "FDG_LORD_L3", recheck = true }, -- src: WHT Dropped by + FC + IV
		},
	},
	[43] = { -- WC
		bosses = {
			{ npc = 3671, encounter = 585, name = "Lady Anacondra",
				names = { deDE = "Lady Anacondra", frFR = "Dame Anacondra", esES = "Lady Anacondra", esMX = "Lady Anacondra", ptBR = "Lady Sucurina", ruRU = "Леди Анакондра" },
				does = { "FDG_WC_1_D1", "FDG_WC_1_D2" },
				tip = "FDG_WC_1_T",
				-- src: spells 2x IV+MOB; vier plekken 2x MOB+WT; tip 2x IV+MOB
			},
			{ npc = 3669, encounter = 586, name = "Lord Cobrahn",
				names = { deDE = "Lord Kobrahn", frFR = "Seigneur Cobrahn", esES = "Lord Cobrahn", esMX = "Lord Cobrahn", ptBR = "Lorde Cobrahn", ruRU = "Лорд Кобран" },
				does = { "FDG_WC_2_D1", "FDG_WC_2_D2" },
				tip = "FDG_WC_2_T",
				-- src: 2x IV+MOB; tip 2x MOB+WT
			},
			{ npc = 3653, encounter = 587, name = "Kresh", one = true,
				names = { deDE = "Kresh", frFR = "Kresh", esES = "Kresh", esMX = "Kresh", ptBR = "Cresh", ruRU = "Криг" },
				does = { "FDG_WC_3_D1" },
				tip = "FDG_WC_3_T",
				-- src: does 2x IV+MOB; tip 1x IV
			},
			{ npc = 3670, encounter = 588, name = "Lord Pythas",
				names = { deDE = "Lord Pythas", frFR = "Seigneur Pythas", esES = "Lord Pythas", esMX = "Lord Pythas", ptBR = "Lorde Pítias", ruRU = "Лорд Питонас" },
				does = { "FDG_WC_4_D1", "FDG_WC_4_D2" },
				tip = "FDG_WC_4_T",
				-- src: 2x IV+MOB (IV zet dit stuk per ongeluk onder de kop 'Lord Serpentis'); tip 2x IV+GG
			},
			{ npc = 3674, encounter = 589, name = "Skum",
				names = { deDE = "Skum", frFR = "Skum", esES = "Skum", esMX = "Skum", ptBR = "Skória", ruRU = "Шкам" },
				does = { "FDG_WC_5_D1" },
				tip = "FDG_WC_5_T",
				-- src: 2x IV+MOB (IV: spread; MOB: de bliksem doet weinig)
			},
			{ npc = 3673, encounter = 590, name = "Lord Serpentis",
				names = { deDE = "Lord Serpentis", frFR = "Seigneur Serpentis", esES = "Lord Serpentis", esMX = "Lord Serpentis", ptBR = "Lorde Serpentis", ruRU = "Лорд Серпентис" },
				does = { "FDG_WC_6_D1" },
				tip = "FDG_WC_6_T",
				-- src: 2x IV+MOB
			},
			{ npc = 5775, encounter = 591, name = "Verdan the Everliving", one = true,
				names = { deDE = "Verdan der Ewiglebende", frFR = "Verdan l’Immortel", esES = "Verdan el Eterno", esMX = "Verdan el Eterno", ptBR = "Verdan, o Sempre-vivo", ruRU = "Вердан Вечноживущий" },
				does = { "FDG_WC_7_D1", "FDG_WC_7_D2" },
				tip = "FDG_WC_7_T",
				-- src: wortels 2x IV+MOB; tank hard 1x MOB; tip 2x IV+MOB
			},
			{ npc = 3654, encounter = 592, name = "Mutanus the Devourer",
				names = { deDE = "Mutanus der Verschlinger", frFR = "Mutanus le Dévoreur", esES = "Mutanus el Devorador", esMX = "Mutanus el Devorador", ptBR = "Mutanus, o Devorador", ruRU = "Мутанус Пожиратель" },
				does = { "FDG_WC_8_D1", "FDG_WC_8_D2" },
				tip = "FDG_WC_8_T",
				-- src: 2x IV+MOB (WH ook); Disciple heel houden 2x IV+WH
			},
			{ npc = 5912, name = "Deviate Faerie Dragon", rare = true, one = true,
				names = { deDE = "Deviatfeendrache", frFR = "Dragon féérique déviant", esES = "Dragón férico descarriado", esMX = "Dragón feérico descarriado", ptBR = "Dragoleta Anormal", ruRU = "Загадочный волшебный дракон" },
				does = { "FDG_WC_9_D1", "FDG_WC_9_D2" },
				tip = "FDG_WC_9_T",
				-- src: rare 2x IV+GG (WHT 'Rare Elite'); geen vaardigheden 1x IV; tip 1x IV
			},
		},
		loot = {
			{ item = 6469, boss = 3673, role = "FDG_WC_L1" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 6631, boss = 5775, role = "FDG_WC_L2" }, -- src: WHT Dropped by + FC + IV
			{ item = 6627, boss = 3654, role = "FDG_WC_L3" }, -- src: WHT Dropped by + FC + IV + MOB
		},
	},
	[36] = { -- DM
		bosses = {
			{ npc = 644, encounter = 2741, name = "Rhahk'Zor",
				names = { deDE = "Rhahk'Zor", frFR = "Rhahk’Zor", esES = "Rhahk'Zor", esMX = "Rhahk'Zor", ptBR = "Rhahk'Zor", ruRU = "Рак'Зор" },
				does = { "FDG_DM_1_D1" },
				tip = "FDG_DM_1_T",
				-- src: 2x IV+MOB
			},
			{ npc = 643, extraNpc = 642, encounter = 2742, name = "Sneed",
				names = { deDE = "Sneed", frFR = "Sneed", esES = "Sneed", esMX = "Sneed", ptBR = "Sneed", ruRU = "Снид" },
				does = { "FDG_DM_2_D1", "FDG_DM_2_D2" },
				tip = "FDG_DM_2_T",
				-- src: does 2x IV+MOB; goblins eerst 2x IV+FH; tank eerst 2x MOB+FH
			},
			{ npc = 3586, encounter = 3676, name = "Miner Johnson", rare = true, one = true,
				names = { deDE = "Minenarbeiter Johnson", frFR = "Mineur Johnson", esES = "Minero Johnson", esMX = "Minero Johnson", ptBR = "Minerador João", ruRU = "Шахтер Джонсон" },
				does = { "FDG_DM_3_D1", "FDG_DM_3_D2" },
				tip = "FDG_DM_3_T",
				-- src: rare 2x IV+FH (WHT 'Rare Elite'); tougher miner 1x IV; tip 1x IV
			},
			{ npc = 1763, encounter = 2743, name = "Gilnid",
				names = { deDE = "Gilnid", frFR = "Gilnid", esES = "Gilnid", esMX = "Gilnid", ptBR = "Gilnid", ruRU = "Гилнид" },
				does = { "FDG_DM_4_D1" },
				tip = "FDG_DM_4_T",
				-- src: metaal op tank 2x IV+MOB; trager threat 2x IV+WFI; tip 2x IV+MOB
			},
			{ npc = 647, encounter = 2744, name = "Captain Greenskin",
				names = { deDE = "Kapitän Grünhaut", frFR = "Capitaine Vertepeau", esES = "Capitán Verdetez", esMX = "Capitán Verdetez", ptBR = "Capitão Peleverde", ruRU = "Капитан Зеленямс" },
				does = { "FDG_DM_5_D1", "FDG_DM_5_D2" },
				tip = "FDG_DM_5_T",
				-- src: cleave 2x IV+MOB; gif 2x MOB+FH; tip 2x IV+MOB
			},
			{ npc = 646, encounter = 2745, name = "Mr. Smite",
				names = { deDE = "Handlanger Pein", frFR = "M. Châtiment", esES = "Don Mamporro", esMX = "Don Mamporro", ptBR = "Sr. Castiga", ruRU = "Мистер Каюк" },
				does = { "FDG_DM_6_D1", "FDG_DM_6_D2" },
				tip = "FDG_DM_6_T",
				-- src: 2x IV+MOB (IV: 66% en 33%; 'hidden' = MOB+FH)
			},
			{ npc = 645, encounter = 2746, name = "Cookie",
				names = { deDE = "Krümel", frFR = "Macaron", esES = "Cocinitas", esMX = "Cocinitas", ptBR = "Cuca", ruRU = "Пирожок" },
				does = { "FDG_DM_7_D1" },
				tip = "FDG_DM_7_T",
				-- src: 2x IV+MOB
			},
			{ npc = 639, encounter = 2747, name = "Edwin VanCleef",
				names = { deDE = "Edwin van Cleef", frFR = "Edwin VanCleef", esES = "Edwin VanCleef", esMX = "Edwin VanCleef", ptBR = "Edwin VanCleef", ruRU = "Эдвин ван Клиф" },
				does = { "FDG_DM_8_D1", "FDG_DM_8_D2" },
				tip = "FDG_DM_8_T",
				-- src: 2x IV+MOB (IV: 50%; MOB: 'as his health drops')
			},
		},
		loot = {
			{ item = 5191, boss = 639, role = "FDG_DM_L1" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 7230, boss = 646, role = "FDG_DM_L2" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 5193, boss = 639, role = "FDG_DM_L3" }, -- src: WHT Dropped by + FC + IV + MOB
		},
	},
	[33] = { -- SFK
		bosses = {
			{ npc = 3914, encounter = 2748, name = "Rethilgore",
				names = { deDE = "Rotkralle", frFR = "Rethiltripe", esES = "Rethilgore", esMX = "Rethilgore", ptBR = "Rethilgore", ruRU = "Ретилгор" },
				does = { "FDG_SFK_1_D1" },
				tip = "FDG_SFK_1_T",
				-- src: drain 2x IV+WFDB (MOB en WH: niet gevaarlijk); tip 2x IV+MOB (WH ook)
			},
			{ npc = 3886, encounter = 2749, name = "Razorclaw the Butcher",
				names = { deDE = "Klingenklaue der Metzger", frFR = "Tranchegriffe le Boucher", esES = "Zarpador el Carnicero", esMX = "Zarpador el Carnicero", ptBR = "Garraguda, o Açougueiro", ruRU = "Остроклык Мясник" },
				does = { "FDG_SFK_2_D1" },
				tip = "FDG_SFK_2_T",
				-- src: 2x IV+MOB
			},
			{ npc = 3887, encounter = 2750, name = "Baron Silverlaine",
				names = { deDE = "Baron Silberlein", frFR = "Baron d’Argelaine", esES = "Barón Filargenta", esMX = "Barón Filargenta", ptBR = "Barão Silverlaine", ruRU = "Барон Сильверлейн" },
				does = { "FDG_SFK_3_D1" },
				tip = "FDG_SFK_3_T",
				-- src: 2x IV+MOB (WH ook); tip 2x MOB+WH (IV: heal more) | MEASURE: Veil of Shadow: curse on one player or on everyone near him? (7068 vs 460755; 23224 also exists)
			},
			{ npc = 4278, encounter = 2751, name = "Commander Springvale",
				names = { deDE = "Kommandant Grüntal", frFR = "Commandant Printeval", esES = "Comandante Vallefont", esMX = "Comandante Vallefont", ptBR = "Comandante Floraval", ruRU = "Командир Спрингвейл" },
				does = { "FDG_SFK_4_D1", "FDG_SFK_4_D2" },
				tip = "FDG_SFK_4_T",
				-- src: 2x IV+MOB (WH ook). Kill-volgorde verschilt: IV de Guardsman eerst, MOB+WH de Servitor eerst; daarom niet in de tip
			},
			{ npc = 4279, encounter = 2752, name = "Odo the Blindwatcher",
				names = { deDE = "Odo der Blindseher", frFR = "Odo l’Aveugle", esES = "Odo el vigía ciego", esMX = "Odo el Vigía Ciego", ptBR = "Odo, o Vigia Cego", ruRU = "Одо Слепой Страж" },
				does = { "FDG_SFK_5_D1", "FDG_SFK_5_D2" },
				tip = "FDG_SFK_5_T",
				-- src: bats 2x IV+MOB; sterker bij weinig leven 2x WT+WFDB; tip 2x IV+MOB
			},
			{ npc = 4274, encounter = 2753, name = "Fenrus the Devourer",
				names = { deDE = "Fenrus der Verschlinger", frFR = "Fenrus le Dévoreur", esES = "Fenrus el Devorador", esMX = "Fenrus el Devorador", ptBR = "Fenrus, o Devorador", ruRU = "Фенрус Пожиратель" },
				does = { "FDG_SFK_6_D1", "FDG_SFK_6_D2" },
				tip = "FDG_SFK_6_T",
				-- src: spit 2x IV+MOB; voidwalkers 2x IV+MOB (IV: bij 50%, MOB: geen moment, daarom geen getal; WT zegt 'geen adds', WFDB 'helpers bij zijn dood')
			},
			{ npc = 3927, encounter = 2754, name = "Wolf Master Nandos",
				names = { deDE = "Wolfmeister Nandos", frFR = "Maître-loup Nandos", esES = "Maestro de lobos Nandos", esMX = "Maestro de lobos Nandos", ptBR = "Nandos, o Mestre de Lobos", ruRU = "Командир воргенов Нандос" },
				does = { "FDG_SFK_7_D1" },
				tip = "FDG_SFK_7_T",
				-- src: 2x IV+MOB (WH ook)
			},
			{ npc = 4275, encounter = 2755, name = "Archmage Arugal",
				names = { deDE = "Erzmagier Arugal", frFR = "Archimage Arugal", esES = "Archimago Arugal", esMX = "Archimago Arugal", ptBR = "Arquimago Arugal", ruRU = "Верховный маг Аругал" },
				does = { "FDG_SFK_8_D1", "FDG_SFK_8_D2", "FDG_SFK_8_D3" },
				tip = "FDG_SFK_8_T",
				-- src: bolts 2x IV+MOB; teleport 2x IV+MOB (WH ook); worgen 2x MOB+CQ; tip 2x IV+MOB
			},
			{ npc = 3872, name = "Deathsworn Captain", rare = true, one = true,
				names = { deDE = "Todeshöriger Captain", frFR = "Capitaine Ligemort", esES = "Capitán Juramorte", esMX = "Capitán Juramorte", ptBR = "Capitão Devoto da Morte", ruRU = "Капитан служителей Смерти" },
				does = { "FDG_SFK_9_D1", "FDG_SFK_9_D2" },
				tip = "FDG_SFK_9_T",
				-- src: rare 1x IV (WHT 'Rare Elite'); helpers 2x IV+WFG; tip 1x IV. Cleave weggelaten: IV zegt 'geen vaardigheden', WT en WFG zeggen cleave
			},
		},
		loot = {
			{ item = 6220, boss = 4275, role = "FDG_SFK_L1" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 6324, boss = 4275, role = "FDG_SFK_L2" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 273643, boss = 4278, role = "FDG_SFK_L3" }, -- src: WHT Dropped by + FC + IV + MOB
		},
	},
	[34] = { -- STOCKS
		bosses = {
			{ npc = 1696, encounter = 2756, name = "Targorr the Dread",
				names = { deDE = "Targorr der Schreckliche", frFR = "Targorr le Terrifiant", esES = "Targor el Pavoroso", esMX = "Targorr el Pavoroso", ptBR = "Targorr, o Horror", ruRU = "Таргорр Ужасный" },
				does = { "FDG_STOCKS_1_D1", "FDG_STOCKS_1_D2" },
				tip = "FDG_STOCKS_1_T",
				-- src: 2x IV+MOB (enrage: IV 30%, MOB ~20%, daarom geen getal)
			},
			{ npc = 1666, encounter = 2757, name = "Kam Deepfury",
				names = { deDE = "Kam Tiefenzorn", frFR = "Kam Furie-du-fond", esES = "Kam Furiahonda", esMX = "Kam Furiahonda", ptBR = "Kam Fundafúria", ruRU = "Кам Гневливый" },
				does = { "FDG_STOCKS_2_D1" },
				tip = "FDG_STOCKS_2_T",
				-- src: 2x IV+MOB
			},
			{ npc = 1717, encounter = 2758, name = "Hamhock",
				names = { deDE = "Hamhock", frFR = "Hamhock", esES = "Hamhock", esMX = "Hamhock", ptBR = "Ramoque", ruRU = "Хрупконог" },
				does = { "FDG_STOCKS_3_D1", "FDG_STOCKS_3_D2" },
				tip = "FDG_STOCKS_3_T",
				-- src: 2x IV+MOB
			},
			{ npc = 1663, encounter = 2759, name = "Dextren Ward",
				names = { deDE = "Dextren Ward", frFR = "Dextren Ward", esES = "Dextren Ward", esMX = "Dextren Ward", ptBR = "Flávio Lúcio", ruRU = "Декстрен Вард" },
				does = { "FDG_STOCKS_4_D1" },
				tip = "FDG_STOCKS_4_T",
				-- src: 2x IV+MOB
			},
			{ npc = 1716, encounter = 2760, name = "Bazil Thredd",
				names = { deDE = "Bazil Thredd", frFR = "Bazil Thredd", esES = "Bazil Thredd", esMX = "Bazil Thredd", ptBR = "Basílio Taborda", ruRU = "Базиль Тредд" },
				does = { "FDG_STOCKS_5_D1", "FDG_STOCKS_5_D2" },
				tip = "FDG_STOCKS_5_T",
				-- src: 2x IV+MOB
			},
			{ npc = 1720, name = "Bruegal Ironknuckle", rare = true,
				names = { deDE = "Bruegal Eisenfaust", frFR = "Bruegal Ironknuckle", esES = "Bruegal Nudoferro", esMX = "Bruegal Nudoferro", ptBR = "Bruegal Ferroque", ruRU = "Бругал Железный Кулак" },
				does = { "FDG_STOCKS_6_D1" },
				tip = "FDG_STOCKS_6_T",
				-- src: 2x IV+MOB
			},
		},
		loot = {
			{ item = 273827, boss = 1716, role = "FDG_STOCKS_L1" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 273809, boss = 1717, role = "FDG_STOCKS_L2" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 273811, boss = 1717, role = "FDG_STOCKS_L3" }, -- src: WHT Dropped by + FC + IV + MOB
		},
	},
	[48] = { -- BFD
		bosses = {
			{ npc = 4887, encounter = 2916, encounterAlt = 2761, name = "Ghamoo-ra",
				names = { deDE = "Ghamoo-ra", frFR = "Ghamoo-Ra", esES = "Ghamoo-Ra", esMX = "Ghamoo-ra", ptBR = "Ghamoo-ra", ruRU = "Гхаму-ра" },
				does = { "FDG_BFD_1_D1", "FDG_BFD_1_D2" },
				tip = "FDG_BFD_1_T",
				-- src: 2x IV+MOB; tip 2x IV+GG
			},
			{ npc = 4831, encounter = 2915, encounterAlt = 2762, name = "Lady Sarevess",
				names = { deDE = "Lady Sarevess", frFR = "Dame Sarevess", esES = "Lady Sarevess", esMX = "Lady Sarevess", ptBR = "Lady Sarevess", ruRU = "Леди Саревесс" },
				does = { "FDG_BFD_2_D1", "FDG_BFD_2_D2" },
				tip = "FDG_BFD_2_T",
				-- src: 2x IV+MOB
			},
			{ npc = 6243, encounter = 2914, encounterAlt = 2763, name = "Gelihast",
				names = { deDE = "Gelihast", frFR = "Gelihast", esES = "Gelihast", esMX = "Gelihast", ptBR = "Gelihast", ruRU = "Гелихаст" },
				does = { "FDG_BFD_3_D1" },
				tip = "FDG_BFD_3_T",
				-- src: 2x IV+MOB
			},
			{ npc = 12902, encounter = 2913, encounterAlt = 2764, name = "Lorgus Jett",
				names = { deDE = "Lorgus Jett", frFR = "Lorgus Jett", esES = "Lorgus Jett", esMX = "Lorgus Jett", ptBR = "Lorgus Jett", ruRU = "Лоргус Джетт" },
				does = { "FDG_BFD_4_D1", "FDG_BFD_4_D2" },
				tip = "FDG_BFD_4_T",
				-- src: plekken 2x FC+CQ; schild 2x IV+MOB; tip 2x IV+MOB
			},
			{ npc = 12876, name = "Baron Aquanis", optional = true,
				names = { deDE = "Baron Aquanis", frFR = "Baron Aquanis", esES = "Barón Aquanis", esMX = "Barón Aquanis", ptBR = "Barão Aquanis", ruRU = "Барон Акванис" },
				does = { "FDG_BFD_5_D1", "FDG_BFD_5_D2" },
				tip = "FDG_BFD_5_T",
				-- src: optioneel + water 2x MOB+SK; frost 2x SK+GG; tip 2x MOB+SK. IV noemt hem niet (7 bazen)
			},
			{ npc = 4830, encounter = 2912, encounterAlt = 2765, name = "Old Serra'kis",
				names = { deDE = "Alter Serra'kis", frFR = "Vieux Serra’kis", esES = "Viejo Serra'kis", esMX = "Viejo Serra'kis", ptBR = "Velho Serra'kis", ruRU = "Старина Серракис" },
				does = { "FDG_BFD_6_D1" },
				tip = "FDG_BFD_6_T",
				-- src: 2x IV+MOB; tip 2x IV+GG
			},
			{ npc = 4832, encounter = 2911, encounterAlt = 2766, name = "Twilight Lord Kelris",
				names = { deDE = "Twilight-Lord Kelris", frFR = "Seigneur du Crépuscule Kelris", esES = "Señor Crepuscular Kelris", esMX = "Señor Crepuscular Kelris", ptBR = "Senhor do Crepúsculo Kelris", ruRU = "Повелитель сумрака Келрис" },
				does = { "FDG_BFD_7_D1", "FDG_BFD_7_D2" },
				tip = "FDG_BFD_7_T",
				-- src: 2x IV+MOB; tip 2x IV+WH (CQ ook)
			},
			{ npc = 4829, encounter = 2910, encounterAlt = 2767, name = "Aku'mai",
				names = { deDE = "Aku'mai", frFR = "Aku’mai", esES = "Aku'mai", esMX = "Aku'mai", ptBR = "Aku'mai", ruRU = "Аку'май" },
				does = { "FDG_BFD_8_D1", "FDG_BFD_8_D2" },
				tip = "FDG_BFD_8_T",
				-- src: 2x IV+MOB
			},
		},
		loot = {
			{ item = 6909, boss = 4829, role = "FDG_BFD_L1" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 1155, boss = 4832, role = "FDG_BFD_L2" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 6907, boss = 4887, role = "FDG_BFD_L3" }, -- src: WHT Dropped by + FC + IV + MOB
		},
	},
	[2998] = { -- EXCAV
		bosses = {
			{ npc = 260322, encounter = 3480, name = "Saltspine", recheck = true,
				names = { deDE = "Salzrücken", frFR = "Seléchine", esES = "Espinasal", esMX = "Salespina", ptBR = "Salespino", ruRU = "Солеспин" },
				does = { "FDG_EXCAV_1_D1", "FDG_EXCAV_1_D2" },
				tip = "FDG_EXCAV_1_T",
				-- src: 2x IV+WT (GS ook)
			},
			{ npc = 260325, encounter = 3481, name = "Shadetooth", recheck = true,
				names = { deDE = "Schemenzahn", frFR = "Dent-Sombre", esES = "Sombradiente", esMX = "Dentumbra", ptBR = "Caninumbra", ruRU = "Тенезуб" },
				does = { "FDG_EXCAV_2_D1", "FDG_EXCAV_2_D2" },
				tip = "FDG_EXCAV_2_T",
				-- src: raptors 2x IV+GS (IV: minder healing, GS: meer schade; daarom 'a wound'); rest 2x IV+GS (WT ook); tip 2x IV+WT (GS ook)
			},
			{ npc = 260808, encounter = 3644, name = "Highland Horror", optional = true, recheck = true,
				names = { deDE = "Hochlandschrecken", frFR = "Horreur des hautes-terres", esES = "Horror de las Tierras Altas", esMX = "Horror de las Tierras Altas", ptBR = "Horror do Planalto", ruRU = "Ужас нагорья" },
				does = { "FDG_EXCAV_3_D1", "FDG_EXCAV_3_D2" },
				tip = "FDG_EXCAV_3_T",
				-- src: optioneel/quest/geen gear 2x WT+WFDB (FDJ: quest-doel, geen baas); vaardigheden 2x WT+WFDB; tip 2x WT+WFDB
			},
			{ npc = 260326, encounter = 3482, name = "Relic Guardian", recheck = true,
				names = { deDE = "Reliktwächter", frFR = "Gardien des reliques", esES = "Guardián de reliquias", esMX = "Guardián de reliquias", ptBR = "Guardião da Relíquia", ruRU = "Страж реликвий" },
				does = { "FDG_EXCAV_4_D1", "FDG_EXCAV_4_D2" },
				tip = "FDG_EXCAV_4_T",
				-- src: 2x IV+GS (WT ook); tip 2x IV+WFDB
			},
		},
		loot = {
			{ item = 273029, boss = 260326, role = "FDG_EXCAV_L1", recheck = true }, -- src: WHT Dropped by + FC + IV
			{ item = 273027, boss = 260325, role = "FDG_EXCAV_L2", recheck = true }, -- src: WHT Dropped by + FC + IV
			{ item = 273028, boss = 260326, role = "FDG_EXCAV_L3", recheck = true }, -- src: WHT Dropped by + FC + IV
		},
	},
	[2959] = { -- DAL
		bosses = {
			{ npc = 247126, encounter = 3311, name = "Atrexis the Grave Knight", recheck = true,
				names = { deDE = "Atrexis der Grabritter", frFR = "Atrexis le Chevalier de la tombe", esES = "Atrexis el Caballero de la Tumba", esMX = "Atrexis, el Caballero de la tumba", ptBR = "Atrexis, o Cavaleiro da Sepultura", ruRU = "Атрексий Могильный Рыцарь" },
				does = { "FDG_DAL_1_D1", "FDG_DAL_1_D2", "FDG_DAL_1_D3" },
				tip = "FDG_DAL_1_T",
				-- src: rondlopen 2x GS+WFA; skeletten 2x IV+WH (MOB, GS ook); disarm 2x IV+WH (MOB, GS ook); hard op tank 2x MOB+GS (WH ook); necro's eerst 2x GS+WFA; geen AoE 2x WH+MOB (IV, GS ook)
			},
			{ npc = 247032, encounter = 3310, name = "Lyn the Ignored", optional = true, recheck = true,
				names = { deDE = "Lyn der Ignorierte", frFR = "Lyn l’Ignoré", esES = "Lyn el Ignorado", esMX = "Lyn, el Ignorado", ptBR = "Lyn, o Ignorado", ruRU = "Лин Забытый" },
				does = { "FDG_DAL_2_D1", "FDG_DAL_2_D2", "FDG_DAL_2_D3" },
				tip = "FDG_DAL_2_T",
				-- src: oproepen 2x IV+WH (GS ook); tome maken 2x IV+GS (WH: 'Ambermill Leyline Focus'; gebouw verschilt per gids, daarom geen gebouw); volley 2x IV+WH (MOB, GS ook); curse 2x IV+GS (MOB, WH ook); skeletten 2x IV+WH (MOB, GS ook); decurse 2x IV+GS; tank skeletten 2x MOB+WFA. Onderbreken weggelaten: IV zegt 'kan niet', WFA zegt 'wel'
			},
			{ npc = 245999, encounter = 3298, name = "Arcane Anomaly", recheck = true,
				names = { deDE = "Arkananomalie", frFR = "Anomalie arcanique", esES = "Anomalía Arcana", esMX = "Anomalía Arcana", ptBR = "Anomalia Arcana", ruRU = "Волшебная аномалия" },
				does = { "FDG_DAL_3_D1", "FDG_DAL_3_D2", "FDG_DAL_3_D3" },
				tip = "FDG_DAL_3_T",
				-- src: draaiende straal 2x IV+GS (WFA ook; MOB: rechte lijn); dodelijk 2x IV+GS; bolts 2x IV+GS (WH, WFA ook); adds aan de rand 2x IV+WH (lijken op elkaar, zie notes); midden 2x IV+WH; wegblijven 2x GS+WFA
			},
			{ npc = 246008, encounter = 3300, name = "Mana Devourer", recheck = true,
				names = { deDE = "Manaschlinger", frFR = "Dévoreur de mana", esES = "Devorador de maná", esMX = "Devorador de maná", ptBR = "Devorador de Mana", ruRU = "Пожиратель маны" },
				does = { "FDG_DAL_4_D1", "FDG_DAL_4_D2", "FDG_DAL_4_D3" },
				tip = "FDG_DAL_4_T",
				-- src: plek 2x IV+WH (GS ook); mana 2x IV+WH (MOB, GS ook); dot op tank 2x IV+WH (MOB, GS ook); alles eerst 2x IV+WH; snel 2x IV+GS (MOB, WH ook)
			},
			{ npc = 246003, encounter = 3299, name = "Fel Ancient", recheck = true,
				names = { deDE = "Teufelsurtum", frFR = "Ancien gangrené", esES = "Anciano vil", esMX = "Anciano vil", ptBR = "Anciente Vil", ruRU = "Древень Скверны" },
				does = { "FDG_DAL_5_D1", "FDG_DAL_5_D2", "FDG_DAL_5_D3" },
				tip = "FDG_DAL_5_T",
				-- src: midden stad 2x IV+GS; barrière + praten 2x WFA+CX (WH-commentaar ook); wortels 2x IV+WH (GS, MOB ook); poelen 2x IV+GS (WH, MOB ook); tip 2x IV+MOB (vrijmaken: IV+WH+GS)
			},
			{ npc = 246017, encounter = 3302, name = "Unstable Sentinel", recheck = true,
				names = { deDE = "Instabile Schildwache", frFR = "Sentinelle instable", esES = "Centinela inestable", esMX = "Centinela inestable", ptBR = "Sentinela Oscilante", ruRU = "Нестабильный часовой" },
				does = { "FDG_DAL_6_D1", "FDG_DAL_6_D2" },
				tip = "FDG_DAL_6_T",
				-- src: puls + 25 yd 2x IV+WH (MOB ook, GS: groot gebied); tomes 2x IV+WH; tip 2x IV+WH (MOB ook). GS en WFA: de wind-up is te onderbreken/stunnen (niet in de tekst)
			},
			{ npc = 246016, encounter = 3301, name = "Arcanic Enigma", recheck = true,
				names = { deDE = "Arkanes Mysterium", frFR = "Enigme arcanique", esES = "Enigma Arcano", esMX = "Enigma arcano", ptBR = "Enigma Arcânico", ruRU = "Чародейская энигма" },
				does = { "FDG_DAL_7_D1", "FDG_DAL_7_D2", "FDG_DAL_7_D3" },
				tip = "FDG_DAL_7_T",
				-- src: phantoms 2x IV+WH (MOB, GS ook); critter 2x IV+WH (GS ook); stilte 2x IV+WH (MOB, GS ook); manalings 2x IV+WH (MOB, GS ook); tip 2x IV+WH (MOB, GS ook) | DB2 encounter name: Mana Elemental | MEASURE: Name: DB2 encounter 3301 = 'Mana Elemental'; Wowhead npc 246016, FC and every guide = 'Arcanic Enigma'. Which name does the client show?
			},
			{ npc = 246020, encounter = 3303, name = "Shade of the Archmage", recheck = true,
				names = { deDE = "Schemen des Erzmagiers", frFR = "Ombre de l’archimage", esES = "Sombra del archimago", esMX = "Sombra del archimago", ptBR = "Vulto do Arquimago", ruRU = "Тень верховного мага" },
				does = { "FDG_DAL_8_D1", "FDG_DAL_8_D2", "FDG_DAL_8_D3" },
				tip = "FDG_DAL_8_T",
				-- src: portaal 2x IV+GS; bol 2x IV+WH (MOB, GS ook); mana-cyclus 2x IV+WH (MOB, GS ook); spreiden 2x IV+WH (MOB ook); afstand 2x IV+WH (GS ook); reset 2x WH+GG (CX, WFDB ook)
			},
		},
		loot = {
			{ item = 273040, boss = 246008, role = "FDG_DAL_L1", recheck = true }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 273037, boss = 246003, role = "FDG_DAL_L2", recheck = true }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 273052, boss = 246020, role = "FDG_DAL_L3", recheck = true }, -- src: WHT Dropped by + FC + IV + MOB
		},
	},
	[90] = { -- GNOMER
		bosses = {
			{ npc = 7361, extraNpc = 6215, encounter = 2768, name = "Grubbis", optional = true,
				names = { deDE = "Grubbis", frFR = "Grubbis", esES = "Grubbis", esMX = "Grubbis", ptBR = "Grúdio", ruRU = "Грязнюк" },
				does = { "FDG_GNOMER_1_D1", "FDG_GNOMER_1_D2" },
				tip = "FDG_GNOMER_1_T",
				-- src: event + Emi 2x IV+WH (MOB, WT, CQ, UGT ook); golven 2x IV+WH (MOB, CQ ook); Chomper 2x CQ+WT (UGT, MOB ook); tip 2x CQ+WT (WFDB ook)
			},
			{ npc = 7079, encounter = 2769, name = "Viscous Fallout",
				names = { deDE = "Verflüssigte Ablagerung", frFR = "Retombée visqueuse", esES = "Radiactivo viscoso", esMX = "Radiactivo viscoso", ptBR = "Precipitação Radioativa Viscosa", ruRU = "Липкая муть" },
				does = { "FDG_GNOMER_2_D1", "FDG_GNOMER_2_D2" },
				tip = "FDG_GNOMER_2_T",
				-- src: plek 2x IV+WH (MOB ook; CQ zegt een gang ernaast); gif 2x MOB+CQ (IV en WT: geen bijzondere vaardigheden); tip 2x IV+WH (MOB, UGT ook)
			},
			{ npc = 6235, encounter = 2770, name = "Electrocutioner 6000",
				names = { deDE = "Elektrokutor 6000", frFR = "Électrocuteur 6000", esES = "Electrocutor 6000", esMX = "Electrocutor 6000", ptBR = "Eletrocutor 6000", ruRU = "\"Электрошокер-6000\"" },
				does = { "FDG_GNOMER_3_D1", "FDG_GNOMER_3_D2", "FDG_GNOMER_3_D3" },
				tip = "FDG_GNOMER_3_T",
				-- src: bliksem 2x IV+WT (MOB, CQ, UGT ook); kegel voor hem 2x IV+CQ (UGT ook); sleutel 2x IV+WT (WH, CQ, UGT ook); spreiden 2x IV+WT; alleen tank vooraan 2x CQ+UGT (MOB ook). Onderbreken weggelaten: MOB/CQ/UGT ja, WT/WFDB nee
			},
			{ npc = 6229, encounter = 2771, name = "Crowd Pummeler 9-60",
				names = { deDE = "Meuteverprügler 9-60", frFR = "Disperseur de foule 9-60", esES = "Golpeamasa 9-60", esMX = "Golpeamasa 9-60", ptBR = "Espanca-gente 9-60", ruRU = "\"Толпогон 9-60\"" },
				does = { "FDG_GNOMER_4_D1", "FDG_GNOMER_4_D2" },
				tip = "FDG_GNOMER_4_T",
				-- src: kegel 2x IV+CQ (MOB, UGT ook); dichtbij + spells stoppen 2x IV+CQ (WT: trapt wie dichtbij staat); weggedraaid 2x MOB+UGT; afstand 2x IV+WT (MOB, CQ ook)
			},
			{ npc = 7800, encounter = 2772, name = "Mekgineer Thermaplugg",
				names = { deDE = "Robogenieur Thermaplugg", frFR = "Mekgénieur Thermojoncteur", esES = "Mekigeniero Termochufe", esMX = "Mekigeniero Termochufe", ptBR = "Mecangenheiro Termaplugue", ruRU = "Анжинер Термоштепсель" },
				does = { "FDG_GNOMER_5_D1", "FDG_GNOMER_5_D2", "FDG_GNOMER_5_D3" },
				tip = "FDG_GNOMER_5_T",
				-- src: bommen 2x IV+WH (CQ, MOB, WT, UGT, MG ook); sneller bij minder leven 2x CQ+WT (WFDB ook); knop 2x IV+WH (CQ, WT, UGT, MG ook); knockback + threat 2x IV+WT (MG ook); tip 2x CQ+UGT (MG: een ranged)
			},
			{ npc = 6228, name = "Dark Iron Ambassador", rare = true,
				names = { deDE = "Botschafter der Dunkeleisenzwerge", frFR = "Ambassadeur Sombrefer", esES = "Embajador Hierro Negro", esMX = "Embajador Hierro Negro", ptBR = "Embaixador Ferro Negro", ruRU = "Посол из клана Черного Железа" },
				does = { "FDG_GNOMER_6_D1", "FDG_GNOMER_6_D2" },
				tip = "FDG_GNOMER_6_T",
				-- src: rare 2x IV+WT (WH, CQ, UGT, FC, WHT ook); plek 2x IV+WH (WT ook); helpers 2x IV+WT (CQ, WH ook); vuurbal 2x IV+WT; tip: eerst trash 2x IV+UGT, helpers + onderbreken 2x IV+WT
			},
		},
		loot = {
			{ item = 9459, boss = 7800, role = "FDG_GNOMER_L1" }, -- src: WHT Dropped by + FC + IV + MOB (WH ook)
			{ item = 9452, boss = 7079, role = "FDG_GNOMER_L2" }, -- src: WHT Dropped by + FC + IV + MOB (WH, CQ ook)
			{ item = 274068, boss = 6229, role = "FDG_GNOMER_L3" }, -- src: WHT Dropped by + FC + IV + MOB (WH, CQ ook)
		},
	},
	[47] = { -- RFK
		bosses = {
			{ npc = 6168, encounter = 2773, name = "Roogug", optional = true,
				names = { deDE = "Roogug", frFR = "Roogug", esES = "Roogug", esMX = "Roogug", ptBR = "Rugug", ruRU = "Ругуг" },
				does = { "FDG_RFK_1_D1", "FDG_RFK_1_D2" },
				tip = "FDG_RFK_1_T",
				-- src: optioneel + warrior-quest 2x IV+WH (WFG volgt WH); elementaal 2x IV+WH (WT ook); mobs bij hem 2x IV+WH (WT ook); tip 2x IV+WH (WT ook)
			},
			{ npc = 4424, encounter = 2774, name = "Aggem Thorncurse",
				names = { deDE = "Aggem Dornfluch", frFR = "Aggem Malépine", esES = "Aggem Malaespina", esMX = "Aggem Malaespina", ptBR = "Aggem Pragacardo", ruRU = "Аггем Терновое Проклятие" },
				does = { "FDG_RFK_2_D1" },
				tip = "FDG_RFK_2_T",
				-- src: 2x IV+WH (WT, MOB ook); tip 2x IV+WH (WT ook; MOB: de boar negeren mag ook)
			},
			{ npc = 4428, encounter = 2775, name = "Death Speaker Jargba",
				names = { deDE = "Todessprecher Jargba", frFR = "Nécrorateur Jargba", esES = "Portavoz de la muerte Jargba", esMX = "Portavoz de la muerte Jargba", ptBR = "Morta-voz Jargba", ruRU = "Вестник смерти Джаргба" },
				does = { "FDG_RFK_3_D1", "FDG_RFK_3_D2" },
				tip = "FDG_RFK_3_T",
				-- src: twee helpers 2x IV+WH (WT: Acolyte + Groundshaker); hard 2x WH+MOB; mind control 2x IV+WH (WT, MOB ook); CC 2x IV+WH (MOB ook); onderbreken 2x MOB+WT. Kill-volgorde verschilt (IV: helpers eerst, WH/MOB: Jargba eerst), daarom niet in de tip
			},
			{ npc = 4420, encounter = 2776, name = "Overlord Ramtusk",
				names = { deDE = "Oberanführer Rammhauer", frFR = "Seigneur Brusquebroche", esES = "Señor Supremo Colmicarnero", esMX = "Señor supremo Colmicarnero", ptBR = "Lorde Supremo Marretusco", ruRU = "Властитель Злоклык" },
				does = { "FDG_RFK_4_D1", "FDG_RFK_4_D2" },
				tip = "FDG_RFK_4_T",
				-- src: Spearhides 2x IV+WH (WT ook); spinnen 2x WH+WT (MOB ook); tank hard 2x IV+WH (MOB ook); CC 2x IV+WH (WT, MOB ook); uit melee 2x MOB+WT
			},
			{ npc = 4422, encounter = 2777, name = "Agathelos the Raging",
				names = { deDE = "Agathelos der Tobende", frFR = "Agathelos le Déchaîné", esES = "Agathelos el Furioso", esMX = "Agathelos el Furioso", ptBR = "Agathelos, o Furioso", ruRU = "Агателос Свирепый" },
				does = { "FDG_RFK_5_D1", "FDG_RFK_5_D2" },
				tip = "FDG_RFK_5_T",
				-- src: hard 2x WH+WT (MOB ook); enrage 2x WH+MOB; tip 2x IV+WH
			},
			{ npc = 4421, encounter = 2778, name = "Charlga Razorflank",
				names = { deDE = "Charlga Klingenflanke", frFR = "Charlga Trancheflanc", esES = "Charlga Filonavaja", esMX = "Charlga Filonavaja", ptBR = "Charlga Talhaflanco", ruRU = "Чарлга Остробок" },
				does = { "FDG_RFK_6_D1", "FDG_RFK_6_D2" },
				tip = "FDG_RFK_6_T",
				-- src: bliksem 2x WH+WT (MOB, SK ook); immuun + heal 2x IV+WH (WT, SK ook); uit de hut 2x IV+WH (WT ook); spreiden 2x WH+WT (MOB, SK ook); onderbreken 2x IV+WH (SK ook)
			},
			{ npc = 4842, name = "Earthcaller Halmgar", rare = true,
				names = { deDE = "Erdenrufer Halmgar", frFR = "Implorateur de la terre Halmgar", esES = "Clamor de Tierra Halmgar", esMX = "Clamatierras Halmgar", ptBR = "Arauto da Terra Halmgar", ruRU = "Заклинательница земли Халмгар" },
				does = { "FDG_RFK_7_D1", "FDG_RFK_7_D2" },
				tip = "FDG_RFK_7_T",
				-- src: rare 2x IV+WT (WH, FC, WHT ook); vaardigheden 2x IV+WH (WT ook); totems 2x IV+WH (WT ook); elementaal 2x WH+WT
			},
			{ npc = 4425, name = "Blind Hunter", rare = true,
				names = { deDE = "Blinder Jäger", frFR = "Chasseur aveugle", esES = "Cazador ciego", esMX = "Cazador ciego", ptBR = "Caçador Cego", ruRU = "Слепой охотник" },
				does = { "FDG_RFK_8_D1", "FDG_RFK_8_D2" },
				tip = "FDG_RFK_8_T",
				-- src: rare 2x IV+WT (WH, FC, WHT ook); grotten 2x WH+WT (FDJ ook); silence 2x IV+WH (WT ook); tip 2x IV+WH (WT: blijf ver weg)
			},
		},
		loot = {
			{ item = 6687, boss = 4420, role = "FDG_RFK_L1" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 274158, boss = 4424, role = "FDG_RFK_L2" }, -- src: WHT Dropped by + FC + IV + MOB
			{ item = 6694, boss = 4421, role = "FDG_RFK_L3" }, -- src: WHT Dropped by + FC + IV + MOB
		},
	},
	[189] = { -- SM
		bosses = {
			{ npc = 3983, encounter = 444, name = "Interrogator Vishas", part = "FDGP_GRAVEYARD",
				names = { deDE = "Befrager Vishas", frFR = "Interrogateur Vislar", esES = "Interrogador Vishas", esMX = "Interrogador Vishas", ptBR = "Interrogador Vishas", ruRU = "Дознаватель Вишас" },
				does = { "FDG_SM_1_D1", "FDG_SM_1_D2" },
				tip = "FDG_SM_1_T",
				-- src: plek + crusaders 2x IV+WT (WH: meestal een humanoid erbij); dot 2x IV+WH (GG ook; IV/WH vuur, GG schaduw, daarom geen school); alleen hem 2x IV+WH; crusaders eerst 2x WT+WFDB
			},
			{ npc = 6490, name = "Azshir the Sleepless", part = "FDGP_GRAVEYARD", rare = true,
				names = { deDE = "Azshir der Schlaflose", frFR = "Azshir le Sans-sommeil", esES = "Azshir el Insomne", esMX = "Azshir el Insomne", ptBR = "Ashir, o Insone", ruRU = "Азшир Неспящий" },
				does = { "FDG_SM_2_D1", "FDG_SM_2_D2" },
				tip = "FDG_SM_2_T",
				-- src: rare 2x IV+WH (WT, FC, WHT ook); fear 2x IV+WH (WT ook); vloek die later pijn doet 2x WH+WT (GG ook; IV: decursen); tip 2x IV+WH (WT ook)
			},
			{ npc = 6488, name = "Fallen Champion", part = "FDGP_GRAVEYARD", rare = true,
				names = { deDE = "Gestürzter Held", frFR = "Champion mort", esES = "Campeón caído", esMX = "Campeón caído", ptBR = "Campeão Caído", ruRU = "Павший воитель" },
				does = { "FDG_SM_3_D1", "FDG_SM_3_D2" },
				tip = "FDG_SM_3_T",
				-- src: rare 2x IV+WH (WT, FC, WHT ook); cleave 2x IV+WH (WT, GG ook); tip 2x IV+WH (WT ook). 'Sterker bij weinig leven' weggelaten: alleen IV
			},
			{ npc = 6489, name = "Ironspine", part = "FDGP_GRAVEYARD", rare = true,
				names = { deDE = "Eisenrücken", frFR = "Echine-de-fer", esES = "Dorsacerado", esMX = "Dorsacerado", ptBR = "Espinha de Ferro", ruRU = "Железноспин" },
				does = { "FDG_SM_4_D1", "FDG_SM_4_D2" },
				tip = "FDG_SM_4_T",
				-- src: rare 2x IV+WH (WT, FC, WHT ook); vloek 2x IV+WT (WH, GG ook); wolk 2x IV+WH (WT ook); tip 2x IV+WT
			},
			{ npc = 4543, encounter = 2779, name = "Bloodmage Thalnos", part = "FDGP_GRAVEYARD",
				names = { deDE = "Blutmagier Thalnos", frFR = "Mage de sang Thalnos", esES = "Mago sangriento Thalnos", esMX = "Mago sangriento Thalnos", ptBR = "Mago Sangrento Thalnos", ruRU = "Волшебник крови Талнос" },
				does = { "FDG_SM_5_D1", "FDG_SM_5_D2" },
				tip = "FDG_SM_5_T",
				-- src: plek 2x IV+WT (WFDB ook); vuur rond hem 2x IV+WH; vuur onder spelers 2x GG+WT (IV ook); ver weg 2x IV+WH (WT ook); uit de vlammen 2x GG+WT. Onderbreken weggelaten: IV ja, WT/WFDB nee
			},
			{ npc = 3974, encounter = 446, name = "Houndmaster Loksey", part = "FDGP_LIBRARY",
				names = { deDE = "Hundemeister Loksey", frFR = "Maître-chien Loksey", esES = "Domador de jaurías Loksey", esMX = "Maestro de canes Loksey", ptBR = "Mestre de Matilha Lobato", ruRU = "Псарь Локси" },
				does = { "FDG_SM_6_D1", "FDG_SM_6_D2" },
				tip = "FDG_SM_6_T",
				-- src: honden 2x IV+WH (WT, GG ook); frenzy bij weinig leven 2x IV+WH (WT ook); tip 2x IV+WH (WT, GG, WFDB ook)
			},
			{ npc = 6487, encounter = 447, name = "Arcanist Doan", part = "FDGP_LIBRARY",
				names = { deDE = "Arkanist Doan", frFR = "Arcaniste Doan", esES = "Arcanista Doan", esMX = "Arcanista Doan", ptBR = "Arcanista Doan", ruRU = "Чародей Доан" },
				does = { "FDG_SM_7_D1", "FDG_SM_7_D2", "FDG_SM_7_D3" },
				tip = "FDG_SM_7_T",
				-- src: schaap + silence 2x IV+WH (WT, GG ook); grote ontploffing 2x IV+WH (WT, GG, WFDB ook); kist + sleutel 2x IV+WH (WT, MOB, FDJ ook); tip 2x IV+WH (WT: de kamer uit)
			},
			{ npc = 3975, encounter = 448, name = "Herod", part = "FDGP_ARMORY",
				names = { deDE = "Herod", frFR = "Hérode", esES = "Herod", esMX = "Herod", ptBR = "Herodes", ruRU = "Ирод" },
				does = { "FDG_SM_8_D1", "FDG_SM_8_D2" },
				tip = "FDG_SM_8_T",
				-- src: cleave 2x IV+WH; spinnen 2x IV+WH (WT, GG, WFDB ook); trainees 2x IV+WH (WT, GG, WFDB, FDJ ook); wegstappen 2x IV+WH (WT, GG ook); samenblijven 2x IV+WH (GG ook). Wanneer hij spint verschilt (IV: vanaf de helft, GG: elke 15-25 s): weggelaten
			},
			{ npc = 4542, encounter = 449, name = "High Inquisitor Fairbanks", part = "FDGP_CATHEDRAL", optional = true,
				names = { deDE = "Hochinquisitor Schönufer", frFR = "Grand inquisiteur Fairbanks", esES = "Alto inquisidor Ribalimpia", esMX = "Alto inquisidor Ribalimpia", ptBR = "Alto-inquisidor Fairbanks", ruRU = "Верховный инквизитор Фэйрбанкс" },
				does = { "FDG_SM_9_D1", "FDG_SM_9_D2", "FDG_SM_9_D3" },
				tip = "FDG_SM_9_T",
				-- src: optioneel 2x CQ+HP (WFG ook); verborgen kamer rechts 2x IV+WT (WFDB ook); fakkel 2x IV+HP (FDJ zegt een deur); fear + slaap 2x WH+WT (GG, WFDB ook); vloek 2x IV+WH (GG ook); heal 2x IV+WH (WT, GG ook); ligt als dood 2x WH+CQ; tip 2x WH+WT (GG ook) | MEASURE: In game: does the torch in the small side room open his room?
			},
			{ npc = 3976, name = "Scarlet Commander Mograine", part = "FDGP_CATHEDRAL",
				names = { deDE = "Scharlachroter Kommandant Mograine", frFR = "Commandant écarlate Mograine", esES = "Comandante Escarlata Mograine", esMX = "Comandante Escarlata Mograine", ptBR = "Comandante Escarlate Mograine", ruRU = "Командир Могрейн из Алого ордена" },
				does = { "FDG_SM_10_D1", "FDG_SM_10_D2" },
				tip = "FDG_SM_10_T",
				-- src: plek 2x WH+FDJ (WCALC ook); alles komt mee 2x WH+GG; paladin + stun + schild 2x IV+WH (GG ook); tip 2x WH+GG (WCALC ook) | MEASURE: No DB2 row: DB2 has one encounter for this fight, 450 'High Inquisitor Whitemane'. Does ENCOUNTER_START fire when you pull Mograine, and with which id?
			},
			{ npc = 3977, encounter = 450, name = "High Inquisitor Whitemane", part = "FDGP_CATHEDRAL",
				names = { deDE = "Hochinquisitorin Weißsträhne", frFR = "Grande inquisitrice Blanchetête", esES = "Alta inquisidora Melenablanca", esMX = "Alta inquisidora Melenablanca", ptBR = "Alta-inquisidora Cristalba", ruRU = "Верховный инквизитор Вайтмейн" },
				does = { "FDG_SM_11_D1", "FDG_SM_11_D2" },
				tip = "FDG_SM_11_T",
				-- src: komt na Mograine 2x IV+WH (WT, GG, FDJ ook); slaap + opwekken + vol leven 2x IV+WH (GG, WFDB ook); tip 2x IV+WH (WFDB ook)
			},
		},
		loot = {
			{ item = 7685, boss = 4543, role = "FDG_SM_L1", part = "FDGP_GRAVEYARD" }, -- src: WHT Dropped by + FC + IV + WH
			{ item = 274291, boss = 4543, role = "FDG_SM_L2", part = "FDGP_GRAVEYARD" }, -- src: WHT Dropped by + FC + IV + WH
			{ item = 274290, boss = 3983, role = "FDG_SM_L3", part = "FDGP_GRAVEYARD" }, -- src: WHT Dropped by + FC + IV + WH
			{ item = 7713, boss = 6487, role = "FDG_SM_L4", part = "FDGP_LIBRARY" }, -- src: WHT Dropped by + FC + IV (WH noemt hem ook)
			{ item = 7710, boss = 3974, role = "FDG_SM_L5", part = "FDGP_LIBRARY" }, -- src: WHT Dropped by + FC + IV
			{ item = 274293, boss = 6487, role = "FDG_SM_L6", part = "FDGP_LIBRARY" }, -- src: WHT Dropped by + FC + IV
			{ item = 7717, boss = 3975, role = "FDG_SM_L7", part = "FDGP_ARMORY" }, -- src: WHT Dropped by + FC + IV + WH
			{ item = 7719, boss = 3975, role = "FDG_SM_L8", part = "FDGP_ARMORY" }, -- src: WHT Dropped by + FC + IV + WH
			{ item = 274295, boss = 3975, role = "FDG_SM_L9", part = "FDGP_ARMORY" }, -- src: WHT Dropped by + IV (FDJ ook; FC en de WH-loottabel noemen hem niet)
			{ item = 7726, boss = 3976, role = "FDG_SM_L10", part = "FDGP_CATHEDRAL" }, -- src: WHT Dropped by + FC + IV + WH
			{ item = 7723, boss = 3976, role = "FDG_SM_L11", part = "FDGP_CATHEDRAL" }, -- src: WHT Dropped by + FC + IV + WH
			{ item = 7721, boss = 3977, role = "FDG_SM_L12", part = "FDGP_CATHEDRAL" }, -- src: WHT Dropped by + FC + IV + WH
		},
	},
	[2970] = { -- DROWN
		bosses = {
			{ npc = 258905, encounter = 3474, name = "Zul'Alai", recheck = true,
				names = { deDE = "Zul'Alai", frFR = "Zul’Alai", esES = "Zul'Alai", esMX = "Zul'Alai", ptBR = "Zul'Alai", ruRU = "Зул'алай" },
				does = { "FDG_DROWN_1_D1", "FDG_DROWN_1_D2", "FDG_DROWN_1_D3" },
				tip = "FDG_DROWN_1_T",
				-- src: hard op tank 2x IV+WH; slam 2x WH+OL (IV, WFA ook); eind 2x IV+WH (OL ook, alle drie 30%); afstand 2x IV+WFA (OL ook); dispel tank 2x IV+WH (OL ook)
			},
			{ npc = 258924, encounter = 3475, name = "Var'Taka", recheck = true,
				names = { deDE = "Var'Taka", frFR = "Var’Taka", esES = "Var'Taka", esMX = "Var'Taka", ptBR = "Var'Taka", ruRU = "Вар'така" },
				does = { "FDG_DROWN_2_D1", "FDG_DROWN_2_D2", "FDG_DROWN_2_D3" },
				tip = "FDG_DROWN_2_T",
				-- src: priesteressen 2x IV+WH (MOBU, OL ook); cleave + harpoen 2x IV+WH (OL ook); parel 2x WT+OL (WH ook); tip 2x IV+WH (OL ook)
			},
			{ npc = 260042, encounter = 3476, name = "Captain Dreadrise", recheck = true,
				names = { deDE = "Captain Dreadrise", frFR = "Capitaine Lèveffroi", esES = "Capitán Alzapavor", esMX = "Capitán Alzapavor", ptBR = "Capitão Pavoral", ruRU = "Капитан Морожад" },
				does = { "FDG_DROWN_3_D1", "FDG_DROWN_3_D2", "FDG_DROWN_3_D3" },
				tip = "FDG_DROWN_3_T",
				-- src: bel 2x IV+WH (MOBU, OL ook); volley 2x IV+WH (OL ook); parel 2x WT+OL (WH ook); onderbreken 2x IV+WH (OL ook); bel aanvallen 2x IV+MOBU
			},
			{ npc = 260202, encounter = 3478, name = "Deathless Marrow", recheck = true,
				names = { deDE = "Unsterbliches Mark", frFR = "Moelle impérissable", esES = "Tuétano Inextinguible", esMX = "Tuétano inextinguible", ptBR = "Tutano Imorredouro", ruRU = "Живая Смерть" },
				does = { "FDG_DROWN_4_D1", "FDG_DROWN_4_D2", "FDG_DROWN_4_D3" },
				tip = "FDG_DROWN_4_T",
				-- src: altaar in het westen 2x OL+WT ('bloedbol': alleen OL, weggelaten); golven 2x IV+WH (MOBU, OL ook); bloedbolts 2x IV+WH (OL ook); meer schade per add 2x MOBU+OL (WFA ook); schildwachters eerst 2x IV+WH; paar adds dan baas 2x OL+WH(method.gg) | DB2 encounter name: Deathless Guardians | MEASURE: Name: DB2 encounter 3478 = 'Deathless Guardians' (the adds); Wowhead npc 260202, Blizzard's 9 Nov hotfix note and every guide = 'Deathless Marrow'. Which name does the client show?
			},
			{ npc = 263886, encounter = 3511, name = "Primeval Elemental", optional = true, recheck = true,
				names = { deDE = "Urtümlicher Elementar", frFR = "Élémentaire primitif", esES = "Elemental primigenio", esMX = "Elemental primitivo", ptBR = "Elemental Primevo", ruRU = "Первородный элементаль" },
				does = { "FDG_DROWN_5_D1", "FDG_DROWN_5_D2", "FDG_DROWN_5_D3" },
				tip = "FDG_DROWN_5_T",
				-- src: optioneel 2x WH+WFA; plek 2x MOBU+OL (WFA ook); offerings 2x IV+WH (OL ook); vaardigheden 2x IV+WH (OL ook); adem 2x IV+WH (OL ook)
			},
			{ npc = 260243, extraNpc = 260274, encounter = 3479, name = "Min'loth the Serpent", recheck = true,
				names = { deDE = "Min'loth die Schlange", frFR = "Min’loth le Serpent", esES = "Min'loth la Serpiente", esMX = "Min'loth, la Serpiente", ptBR = "Min'loth, a Serpente", ruRU = "Мин'лот-Змей" },
				does = { "FDG_DROWN_6_D1", "FDG_DROWN_6_D2", "FDG_DROWN_6_D3" },
				tip = "FDG_DROWN_6_T",
				-- src: twee fasen 2x IV+WH (MOBU, OL ook); trol 2x IV+WH (OL ook; IV en WH ruilen de twee spellnamen om, daarom zonder namen); slang 2x IV+WH (MOBU, OL ook); gif weghalen 2x IV+WH (OL ook); sparen voor slang 2x OL+WFA (MOBU ook) | MEASURE: npc: 260243 has the loot (WHT 'Elite', zone 16550; IV database). extraNpc 260274 (WHT 'Min'loth the Serpent', Normal, no zone) is the creature whose death counts for the Legacy challenge (FC; FDJ uses it). Is 260274 the serpent form?
			},
			{ npc = 264172, name = "Umbra", rare = true, recheck = true,
				names = { deDE = "Umbra", frFR = "Umbra", esES = "Umbra", esMX = "Umbra", ptBR = "Umbra", ruRU = "Умбра" },
				does = { "FDG_DROWN_7_D1", "FDG_DROWN_7_D2" },
				tip = "FDG_DROWN_7_T",
				-- src: rare 2x IV+WH (WHT 'Rare Elite'); plek 2x IV+OL; murlocs 2x IV+WH (OL ook); bloeding 2x WH+OL; geen vaardigheden 2x IV+WH; tip 2x IV+WH (OL ook)
			},
			{ npc = 264177, name = "Gill", rare = true, recheck = true,
				names = { deDE = "Gill", frFR = "Gill", esES = "Branquia", esMX = "Branquia", ptBR = "Gelra", ruRU = "Жабр" },
				does = { "FDG_DROWN_8_D1", "FDG_DROWN_8_D2" },
				tip = "FDG_DROWN_8_T",
				-- src: rare 2x IV+WH (WHT 'Rare Elite'); plek 2x IV+WH (OL ook); dynamiet op tank 2x WH+OL (IV: dynamiet); tip 2x IV+WH
			},
			{ npc = 260468, name = "\"Pyromancer\" Braxton", rare = true, one = true, recheck = true,
				names = { deDE = "\"Pyromant\" Braxton", frFR = "« Pyromancien » Braxton", esES = "\"Piromántico\" Braxton", esMX = "\"Piromántico\" Braxton", ptBR = "\"Piromante\" Brites", ruRU = "\"Пиромант\" Бракстон" },
				does = { "FDG_DROWN_9_D1", "FDG_DROWN_9_D2" },
				tip = "FDG_DROWN_9_T",
				-- src: rare 2x IV+WHT('Rare Elite'); plek 2x IV+OL (WH-commentaar ook); kopstoot 1x IV; tip 1x IV
			},
		},
		loot = {
			{ item = 274606, boss = 260202, role = "FDG_DROWN_L1", recheck = true }, -- src: WHT Dropped by + IV + WH + OL
			{ item = 274608, boss = 260243, role = "FDG_DROWN_L2", recheck = true }, -- src: WHT Dropped by + IV + WH + OL
			{ item = 274604, boss = 260042, role = "FDG_DROWN_L3", recheck = true }, -- src: WHT Dropped by + IV + WH + OL
		},
	},
	[129] = { -- RFD
		bosses = {
			{ npc = 7355, encounter = 2780, name = "Tuten'kash",
				names = { deDE = "Tuten'kash", frFR = "Tuten’kash", esES = "Tuten'kash", esMX = "Tuten'kash", ptBR = "Tutan'kash", ruRU = "Тутен'каш" },
				does = { "FDG_RFD_1_D1", "FDG_RFD_1_D2" },
				tip = "FDG_RFD_1_T",
				-- src: gong + golven 2x WH+WT (FDJ ook); pas na elke golf 2x WH+HP (WFG ook); web vooraan 2x WH+WT; vloek trager 2x WFG(WH Forever-tooltip)+IVC, WT: decursen; tip 2x WH+WT
			},
			{ npc = 7356, encounter = 2781, name = "Plaguemaw the Rotting", optional = true,
				names = { deDE = "Plaguemaw der Faulende", frFR = "Pestegueule le Pourrissant", esES = "Faucepeste el Podrido", esMX = "Faucepeste el Podrido", ptBR = "Pragorja, o Podre", ruRU = "Чумобрюх Гнилой" },
				does = { "FDG_RFD_2_D1", "FDG_RFD_2_D2" },
				tip = "FDG_RFD_2_T",
				-- src: optioneel + escort 2x WH+WT (IV questpagina 10 nov, FDJ ook); adds een voor een 2x WH+WT (WFG ook); tip 2x WH+WT
			},
			{ npc = 7357, encounter = 2782, name = "Mordresh Fire Eye",
				names = { deDE = "Mordresh Feuerauge", frFR = "Mordresh Œil-de-Feu", esES = "Mordresh Ojo de Fuego", esMX = "Mordresh Ojo de Fuego", ptBR = "Mordresh Olho-de-Fogo", ruRU = "Мордреш Огненный Глаз" },
				does = { "FDG_RFD_3_D1", "FDG_RFD_3_D2" },
				tip = "FDG_RFD_3_T",
				-- src: botten + skeletten 2x WH+WT (FDJ ook); vuurbal + vuur rond hem 2x WH+WT; area damage 2x WH+WT; onderbreken 2x WH+WT
			},
			{ npc = 8567, encounter = 2784, name = "Glutton",
				names = { deDE = "Nimmersatt", frFR = "Glouton", esES = "Glotón", esMX = "Glotón", ptBR = "Glutão", ruRU = "Обжора" },
				does = { "FDG_RFD_4_D1", "FDG_RFD_4_D2" },
				tip = "FDG_RFD_4_T",
				-- src: wolk 2x WH+WT (HP ook); enrage 2x WH+WT; tip 2x WH+WT (HP ook)
			},
			{ npc = 7354, encounter = 2783, name = "Ragglesnout", rare = true,
				names = { deDE = "Struppmähne", frFR = "Groinfendu", esES = "Morrandrajos", esMX = "Morrandrajos", ptBR = "Trombarrão", ruRU = "Круглорыл" },
				does = { "FDG_RFD_5_D1", "FDG_RFD_5_D2" },
				tip = "FDG_RFD_5_T",
				-- src: rare 2x WT+FC (FDJ, WFG, IVC ook; WHT zegt 'Elite', zie measure); vaardigheden 2x WH+WT; tip 2x WH+WT | MEASURE: Rare in Forever? WT, FC and FDJ say rare, but WHT says 'Elite', not 'Rare Elite' (Classic tooltip too), and he has a DB2 row. Is he there every run?
			},
			{ npc = 7358, encounter = 2785, name = "Amnennar the Coldbringer",
				names = { deDE = "Amnennar der Kältebringer", frFR = "Amnennar le Porte-Froid", esES = "Amnennar el Gélido", esMX = "Amnennar el Gélido", ptBR = "Amnennar, o Frigífero", ruRU = "Амненнар Хладовей" },
				does = { "FDG_RFD_6_D1", "FDG_RFD_6_D2" },
				tip = "FDG_RFD_6_T",
				-- src: knockback 2x WH+WT (HP, IVC ook); bevriezen 2x WH+WT; geesten 2x WH+WT (wat je ermee doet verschilt: WH aanvallen, WT ontwijken; daarom geen advies); tip 2x WH+WT (HP, IVC ook)
			},
		},
		loot = {
			{ item = 274381, boss = 7358, role = "FDG_RFD_L1" }, -- src: WHT Dropped by + WH + WFDB (FC noemt hem niet)
			{ item = 10772, boss = 8567, role = "FDG_RFD_L2" }, -- src: WHT Dropped by + FC + WH (WFDB ook)
			{ item = 10770, boss = 7357, role = "FDG_RFD_L3" }, -- src: WHT Dropped by + FC + WH (WFDB ook)
		},
	},
	[3039] = { -- KROL
		bosses = {
			{ npc = 258966, encounter = 3450, name = "Slavecrusher Grox", recheck = true,
				names = { deDE = "Sklavenbrecher Grox", frFR = "Brise-esclave Grox", esES = "Machacaesclavos Grox", esMX = "Muelesclavos Grox", ptBR = "Grox Esmaga-escravos", ruRU = "Рабомучитель Грокс" },
				does = { "FDG_KROL_1_D1", "FDG_KROL_1_D2" },
				tip = "FDG_KROL_1_T",
				-- src: patrouille 2x WH+WT; gevangenen 2x WH+WT (GGA ook); stun 2x WH+WT; tip 2x WH+WT. MOBU en CQ: 'geen bijzondere vaardigheden'
			},
			{ npc = 258972, encounter = 3452, name = "Twilight Commander Zarmok", recheck = true,
				names = { deDE = "Twilight-Kommandant Zarmok", frFR = "Commandant du Crépuscule Zarmok", esES = "Comandante Crepuscular Zarmok", esMX = "Comandante Crepuscular Zarmok", ptBR = "Comandante do Crepúsculo Zarmok", ruRU = "Сумеречный командир Зармок" },
				does = { "FDG_KROL_2_D1", "FDG_KROL_2_D2", "FDG_KROL_2_D3" },
				tip = "FDG_KROL_2_T",
				-- src: hard 2x WH+CQ; spin/bloeding 2x WH+WT (CQ ook); charge 2x WT+MOBU (MOBU: verste speler, WT: willekeurig, daarom zonder doel); poort 2x WT+CQ; tip 2x WH+WT. Enrage 30%: alleen WH (method.gg = zelfde auteur), weggelaten
			},
			{ npc = 259281, encounter = 3453, name = "War Handler Ashka", recheck = true,
				names = { deDE = "Kriegswärterin Ashka", frFR = "Marchande de guerre Ashka", esES = "Cuidadora de guerra Ashka", esMX = "Líder bélica Ashka", ptBR = "Domadora de Guerra Ashka", ruRU = "Военачальница Ашка" },
				does = { "FDG_KROL_3_D1", "FDG_KROL_3_D2" },
				tip = "FDG_KROL_3_T",
				-- src: wolven 2x WH+WT (MOBU, WFA ook); opjagen 2x WH+WT; tip 2x WH+WT. MOBU: volgorde maakt niet uit. Fear: alleen GGA, weggelaten | DB2 encounter name: Handler Ashka | MEASURE: Name: DB2 encounter 3453 = 'Handler Ashka'; Wowhead npc 259281, WH, WT and CQ = 'War Handler Ashka'. Which name does the client show?
			},
			{ npc = 258964, encounter = 3449, name = "Nar'gurk", recheck = true,
				names = { deDE = "Nar'gurk", frFR = "Nar’gurk", esES = "Nar'gurk", esMX = "Nar'gurk", ptBR = "Nar'gurk", ruRU = "Нар'гурк" },
				does = { "FDG_KROL_4_D1", "FDG_KROL_4_D2", "FDG_KROL_4_D3" },
				tip = "FDG_KROL_4_T",
				-- src: casters 2x WH+WT (MOBU ook); groepsschade 2x WH+WT; overname 2x WH+WT (CQ ook); casters eerst 2x WH+WT (MOBU ook); speler niet doden 2x WH+GGA
			},
			{ npc = 264773, name = "Bossman Toof", recheck = true,
				names = { deDE = "Bossmann Toof", frFR = "Boss Kof", esES = "Jefazo Toof", esMX = "Jefe Toof", ptBR = "Chefe Dentão", ruRU = "Босс Туф" },
				does = { "FDG_KROL_5_D1", "FDG_KROL_5_D2", "FDG_KROL_5_D3" },
				tip = "FDG_KROL_5_T",
				-- src: bruggen 2x WH+WT; sjamanen 2x WH+WT (MOBU, CQ ook); minder healing 2x WH+WT (WT: 'een sterkere Centurion', Centurions verlagen healing); tip 2x WH+MOBU (WFA ook)
			},
			{ npc = 258968, encounter = 3451, name = "Overlord Mugg", recheck = true,
				names = { deDE = "Oberanführer Mugg", frFR = "Suzerain Mugg", esES = "Señor supremo Mugg", esMX = "Señor supremo Mugg", ptBR = "Lorde Supremo Mugg", ruRU = "Властитель Магг" },
				does = { "FDG_KROL_6_D1", "FDG_KROL_6_D2", "FDG_KROL_6_D3" },
				tip = "FDG_KROL_6_T",
				-- src: centurions 2x WH+WT (MOBU, CQ ook); sprong 2x WH+WT (MOBU, CQ ook); wapens 2x WH+WT; centurions eerst 2x WH+WT (CQ ook); spreiden 2x WT+MOBU | DB2 encounter name: Overseer Mugg | MEASURE: Name: DB2 encounter 3451 = 'Overseer Mugg'; Wowhead npc 258968, every guide and a stream nameplate (GGA) = 'Overlord Mugg'. Which name does the client show?
			},
			{ npc = 262716, name = "Kroog", rare = true, one = true, recheck = true,
				names = { deDE = "Kroog", frFR = "Kroog", esES = "Kroog", esMX = "Kroog", ptBR = "Kroog", ruRU = "Кроог" },
				does = { "FDG_KROL_7_D1" },
				tip = "FDG_KROL_7_T",
				-- src: rare 2x CQ+FDJ (WHT 'Rare Elite'). Vaardigheden: geen bron gevonden (CQ, WH, WT, MOBU, WFA noemen er geen); tip = eerlijke regel, 0 bronnen
			},
		},
		loot = {
			{ item = 274998, boss = 258972, role = "FDG_KROL_L1", recheck = true }, -- src: WHT Dropped by + CQ + WFA (id: FDJ)
			{ item = 275005, boss = 258964, role = "FDG_KROL_L2", recheck = true }, -- src: WHT Dropped by + CQ + WFA (id: FDJ)
			{ item = 275001, boss = 259281, role = "FDG_KROL_L3", recheck = true }, -- src: WHT Dropped by + CQ + WFA (id: FDJ)
		},
	},
	[70] = { -- ULDA
		bosses = {
			{ npc = 6910, encounter = 547, name = "Revelosh",
				names = { deDE = "Revelosh", frFR = "Revelosh", esES = "Revelosh", esMX = "Revelosh", ptBR = "Revelosh", ruRU = "Ревелош" },
				does = { "FDG_ULDA_1_D1", "FDG_ULDA_1_D2", "FDG_ULDA_1_D3" },
				tip = "FDG_ULDA_1_T",
				-- src: helpers 2x WT+CQ; bliksem 2x WT+CQ (IVC ook); Shaft 2x WT+CQ (WHT 7741 'Dropped by: Revelosh'); onderbreken 2x WT+CQ; zelfde speler 2x IVC(Classic)+AW
			},
			{ npc = 6906, extraNpc = { 6907, 6908 }, encounter = 548, name = "The Lost Dwarves",
				names = { deDE = "Die verschollenen Zwerge", frFR = "Les nains perdus", esES = "Los enanos desaparecidos", esMX = "Los enanos desaparecidos", ptBR = "Os Anões Perdidos", ruRU = "Потерянные дворфы" },
				does = { "FDG_ULDA_2_D1", "FDG_ULDA_2_D2", "FDG_ULDA_2_D3" },
				tip = "FDG_ULDA_2_T",
				-- src: drie dwergen 2x WT+CQ (IVC ook); alleen Horde 2x WT+FDJ (IVC ook; WHT: alle drie ondertitel 'Ironforge'); kist 2x WT+CQ (IVC, FC 'Baelog's Chest' ook); volgorde 2x WT+CQ (IVC Classic: Olaf eerst los trekken, wijkt af)
			},
			{ npc = 7228, encounter = 549, name = "Ironaya",
				names = { deDE = "Ironaya", frFR = "Ironaya", esES = "Hierraya", esMX = "Hierraya", ptBR = "Ferronaya", ruRU = "Иронайа" },
				does = { "FDG_ULDA_3_D1", "FDG_ULDA_3_D2", "FDG_ULDA_3_D3" },
				tip = "FDG_ULDA_3_T",
				-- src: staf 2x WT+CQ (IVC ook; WHT 7733 'Use: Place in the Uldaman map room'); voorkant + knockback 2x WT+CQ (IVC ook); stomp-stun 2x CQ+EXP (AW ook); tip wegdraaien 2x WT+CQ, buiten bereik 2x CQ+EXP. Weggelaten: tank verliest threat (alleen IVC), DoT-immuun (alleen WT)
			},
			{ npc = 7023, encounter = 1887, name = "Obsidian Sentinel",
				names = { deDE = "Obsidianschildwache", frFR = "Sentinelle d’obsidienne", esES = "Centinela Obsidiano", esMX = "Centinela obsidiana", ptBR = "Sentinela de Obsidiana", ruRU = "Обсидиановый часовой" },
				does = { "FDG_ULDA_4_D1", "FDG_ULDA_4_D2" },
				tip = "FDG_ULDA_4_T",
				-- src: scherven 2x WT+CQ (WT: bij 66% en 33%, CQ: steeds als je hem raakt; daarom geen moment); mage-quest 2x FC+FDJ (WFG ook); tip 2x WT+CQ
			},
			{ npc = 7206, encounter = 551, name = "Ancient Stone Keeper",
				names = { deDE = "Uralter Steinbewahrer", frFR = "Ancien gardien en pierre", esES = "Vigilante pétreo anciano", esMX = "Vigilante de piedra anciano", ptBR = "Antigo Protetor de Pedra", ruRU = "Древний каменный хранитель" },
				does = { "FDG_ULDA_5_D1", "FDG_ULDA_5_D2" },
				tip = "FDG_ULDA_5_T",
				-- src: pantser/leven 2x WT+CQ; zandwolken 2x CQ+IVC (WT ook); tip 2x CQ+IVC. Weggelaten: vertragen + stilte in het zand (alleen WT), DoT-immuun (alleen WT)
			},
			{ npc = 7291, encounter = 552, name = "Galgann Firehammer",
				names = { deDE = "Galgann Feuerhammer", frFR = "Galgann Martel-de-Feu", esES = "Galgann Flamartillo", esMX = "Galgann Flamartillo", ptBR = "Galnann Martelígneo", ruRU = "Галганн Огнемолот" },
				does = { "FDG_ULDA_6_D1", "FDG_ULDA_6_D2" },
				tip = "FDG_ULDA_6_T",
				-- src: helpers 2x WT+CQ (WT: twee; IVC: bodyguards); vuur rond hem 2x CQ+IVC; meer vuurschade 2x WT+CQ; helpers eerst 2x WT+IVC; weghalen 2x WT+CQ
			},
			{ npc = 4854, encounter = 553, name = "Grimlok",
				names = { deDE = "Grimlok", frFR = "Grimelok", esES = "Grimlok", esMX = "Grimlok", ptBR = "Grimlok", ruRU = "Гримлок" },
				does = { "FDG_ULDA_7_D1", "FDG_ULDA_7_D2" },
				tip = "FDG_ULDA_7_T",
				-- src: helpers + basilisk 2x WT+CQ (EXP ook); krimpen 2x CQ+IVC; bliksem 2x CQ+IVC; tip 2x WT+CQ (IVC ook)
			},
			{ npc = 2748, encounter = 554, name = "Archaedas",
				names = { deDE = "Archaedas", frFR = "Archaedas", esES = "Archaedas", esMX = "Archaedas", ptBR = "Arkhaedas", ruRU = "Аркедас" },
				does = { "FDG_ULDA_8_D1", "FDG_ULDA_8_D2", "FDG_ULDA_8_D3" },
				tip = "FDG_ULDA_8_T",
				-- src: vier beelden + deur: 2x BRADY+WHC-commentaar (beide Classic; CMG ook); Forever: AW noemt Stone Keepers in de laatste hallen en spreekt het niet tegen. Altaar wekt hem 2x CQ+IVC (WFG ook); dwergen/grote wachters 2x WT+CQ (IVC ook); stun 2x WT+CQ; tip 2x CQ+IVC (WT: eerst alle adds dood, wijkt af) | MEASURE: How many players must click each altar (the four statues, and Archaedas)? Classic: three (CMG data0=3, Wowhead Classic comment). CQ: one player wakes Archaedas; IVC: everyone clicks.
			},
		},
		loot = {
			{ item = 9419, boss = 7291, role = "FDG_ULDA_L1" }, -- src: WHT Dropped by + FC + CQ (FDJ ook)
			{ item = 9416, boss = 4854, role = "FDG_ULDA_L2" }, -- src: WHT Dropped by + FC + CQ (FDJ ook)
			{ item = 274428, boss = 7023, role = "FDG_ULDA_L3", recheck = true }, -- src: WHT Dropped by + FC ('New') + CQ (FDJ ook)
		},
	},
	[209] = { -- ZF
		bosses = {
			{ npc = 7795, encounter = 593, name = "Hydromancer Velratha",
				names = { deDE = "Wasserbeschwörerin Velratha", frFR = "Hydromancienne Velratha", esES = "Hidromántica Velratha", esMX = "Hidromántica Velratha", ptBR = "Hidromante Velratha", ruRU = "Гидромантка Велрата" },
				does = { "FDG_ZF_1_D1", "FDG_ZF_1_D2" },
				tip = "FDG_ZF_1_T",
				-- src: patrouille 2x IVQ+CQ (HP, FDJ ook); heal 2x CQ+HP; tip alleen trekken 2x CQ+HP, onderbreken 2x CQ+HP. Weggelaten: knockback en frost bolt (alleen HP)
			},
			{ npc = 7273, encounter = 594, name = "Gahz'rilla", optional = true,
				names = { deDE = "Gahz'rilla", frFR = "Gahz’rilla", esES = "Gahz'rilla", esMX = "Gahz'rilla", ptBR = "Gahz'rilla", ruRU = "Газ'рилла" },
				does = { "FDG_ZF_2_D1", "FDG_ZF_2_D2", "FDG_ZF_2_D3" },
				tip = "FDG_ZF_2_T",
				-- src: gong + Mallet 2x CQ+IVQ (IVC, HP ook); Hinterlands 2x CQ+IVC; slam + val 2x MOB+CQ; ijs/vertragen 2x MOB+CQ; tip 2x CQ+IVC (HP ook; MOB: in de boog van de ingang)
			},
			{ npc = 8127, encounter = 595, name = "Antu'sul",
				names = { deDE = "Antu'sul", frFR = "Antu’sul", esES = "Antu'sul", esMX = "Antu'sul", ptBR = "Antu'sul", ruRU = "Анту'сул" },
				does = { "FDG_ZF_3_D1", "FDG_ZF_3_D2", "FDG_ZF_3_D3" },
				tip = "FDG_ZF_3_T",
				-- src: bassin vol basilisken 2x CQ+HP; start vroeg 2x IVC+HP; basilisken roepen 2x MOB+CQ (IVC ook); blijven na zijn dood 2x IVC+HP; totems + heal 2x MOB+CQ; tip 2x MOB+CQ
			},
			{ npc = 7272, encounter = 596, name = "Theka the Martyr",
				names = { deDE = "Theka der Märtyrer", frFR = "Theka le Martyr", esES = "Theka el Mártir", esMX = "Theka el Mártir", ptBR = "Theka, o Mártir", ruRU = "Тека Мученик" },
				does = { "FDG_ZF_4_D1", "FDG_ZF_4_D2", "FDG_ZF_4_D3" },
				tip = "FDG_ZF_4_T",
				-- src: scarabeeën + AoE 2x IVC+HP (CQ: kamer vol scarabeeën); ziekte 2x CQ+HP; vorm + immuun 2x CQ+HP (CQ 15 s, HP 30 s: daarom geen getal); tip wegtrekken 2x IVC+HP, afmaken 2x CQ+HP
			},
			{ npc = 7271, encounter = 597, name = "Witch Doctor Zum'rah",
				names = { deDE = "Hexendoktor Zum'rah", frFR = "Féticheur Zum’rah", esES = "Médico brujo Zum'rah", esMX = "Médico brujo Zum'rah", ptBR = "Mandingueiro Zum'rah", ruRU = "Знахарь Зум'рах" },
				does = { "FDG_ZF_5_D1", "FDG_ZF_5_D2", "FDG_ZF_5_D3" },
				tip = "FDG_ZF_5_T",
				-- src: zombies 2x CQ+IVC (HP ook); kampen eerst 2x IVC+HP; ward 2x CQ+MOB (HP ook); volley + heal 2x MOB+CQ (IVC ook); tip ward 2x CQ+HP, onderbreken 2x MOB+CQ
			},
			{ npc = 7796, encounter = 598, name = "Nekrum Gutchewer",
				names = { deDE = "Nekrum der Ausweider", frFR = "Nekrum Mâchentrailles", esES = "Nekrum Cometripas", esMX = "Nekrum Cometripas", ptBR = "Nekrum Cometripas", ruRU = "Некрум Кишкожуй" },
				does = { "FDG_ZF_6_D1", "FDG_ZF_6_D2" },
				tip = "FDG_ZF_6_T",
				-- src: trappen-event 2x CQ+HP (IVC, WFBE ook; WHT 8444 Executioner's Key 'Dropped by: Sandfury Executioner'); laatste golf 2x CQ+HP (IVQ ook); bovenaan blijven 2x CQ+HP (IVC: niet de piramide af); Nekrum eerst 2x CQ+HP (WFBE ook)
			},
			{ npc = 7275, encounter = 599, name = "Shadowpriest Sezz'ziz",
				names = { deDE = "Schattenpriester Sezz'ziz", frFR = "Prêtre des ombres Sezz’ziz", esES = "Sacerdote oscuro Sezz'ziz", esMX = "Sacerdote oscuro Sezz'ziz", ptBR = "Sacerdote Sombrio Diz'ieh", ruRU = "Жрец Тьмы Шезз'зиз" },
				does = { "FDG_ZF_7_D1", "FDG_ZF_7_D2" },
				tip = "FDG_ZF_7_T",
				-- src: heal 2x CQ+HP (WFG ook); fear 2x CQ+HP (IVC ook); tip 2x CQ+HP. Weggelaten: waar de healer staat (HP/WFBE: op afstand, CQ: dicht bij elkaar)
			},
			{ npc = 7604, name = "Sergeant Bly", optional = true,
				names = { deDE = "Sergeant Bly", frFR = "Sergent Bly", esES = "Sargento Bly", esMX = "Sargento Bly", ptBR = "Sargento Bly", ruRU = "Сержант Блай" },
				does = { "FDG_ZF_8_D1", "FDG_ZF_8_D2" },
				tip = "FDG_ZF_8_T",
				-- src: Weegli eerst 2x IVC+HP (WFBE ook; CQ: Weegli blaast de deur open); Bly + vrienden vallen aan 2x IVC+CQ (HP ook); alleen voor de quest 2x IVC+HP (WHT 8548 'Dropped by: Sergeant Bly'); healer eerst 2x CQ+HP (WFBE ook)
			},
			{ npc = 7267, extraNpc = 7797, encounter = 600, name = "Chief Ukorz Sandscalp",
				names = { deDE = "Häuptling Ukorz Sandskalp", frFR = "Chef Ukorz Scalpessable", esES = "Jefe Ukorz Cabellarena", esMX = "Jefe Ukorz Cabellarena", ptBR = "Chefe Ukorz Escalpareia", ruRU = "Вождь Укорз Песчаный Череп" },
				does = { "FDG_ZF_9_D1", "FDG_ZF_9_D2" },
				tip = "FDG_ZF_9_T",
				-- src: samen met Ruuzlu 2x MOB+CQ (IVC, FDJ ook); achter de deur 2x CQ+IVC; voorkant 2x MOB+CQ (IVC ook); enrage 2x CQ+HP (IVC ook); tip wegdraaien 2x MOB+CQ, Ruuzlu eerst 2x MOB+CQ
			},
			{ npc = 10082, name = "Zerillis", rare = true, one = true,
				names = { deDE = "Zerillis", frFR = "Zerillis", esES = "Zerillis", esMX = "Zerillis", ptBR = "Zerillis", ruRU = "Зериллис" },
				does = { "FDG_ZF_10_D1", "FDG_ZF_10_D2" },
				tip = "FDG_ZF_10_T",
				-- src: rare 2x IVC+CQ (WHT 'Rare Elite'); schieten/net 2x IVC+CQ (HP, WW ook); tip 1x HP
			},
			{ npc = 10080, name = "Sandarr Dunereaver", rare = true, one = true,
				names = { deDE = "Sandarr der Wüstenräuber", frFR = "Sandarr Ravadune", esES = "Sandarr Asaltadunas", esMX = "Sandarr Asaltadunas", ptBR = "Sandarr Aniquiladunas", ruRU = "Сандарр Разоритель Барханов" },
				does = { "FDG_ZF_11_D1", "FDG_ZF_11_D2" },
				tip = "FDG_ZF_11_T",
				-- src: rare 2x CQ+HP (WHT 'Rare Elite'); onderbreken 2x HP+WW; tip 1x HP
			},
			{ npc = 10081, name = "Dustwraith", rare = true, one = true,
				names = { deDE = "Karaburan", frFR = "Ame en peine poudreuse", esES = "Suciespectro", esMX = "Ánima de polvo", ptBR = "Assombração de Poeira", ruRU = "Пыльный призрак" },
				does = { "FDG_ZF_12_D1", "FDG_ZF_12_D2" },
				tip = "FDG_ZF_12_T",
				-- src: rare 2x CQ+HP (WHT 'Rare Elite'); gif 2x HP+WW; tip 1x HP
			},
		},
		loot = {
			{ item = 274641, boss = 7272, role = "FDG_ZF_L1", recheck = true }, -- src: WHT Dropped by + CQ + FDJ (speler-screenshot 10 nov)
			{ item = 9476, boss = 7267, role = "FDG_ZF_L2" }, -- src: WHT Dropped by + FC + CQ
			{ item = 9467, boss = 7273, role = "FDG_ZF_L3" }, -- src: WHT Dropped by + FC + CQ
		},
	},
	[349] = { -- MARA
		bosses = {
			{ npc = 13282, encounter = 422, name = "Noxxion", part = "FDGP_ORANGE_SIDE",
				names = { deDE = "Noxxion", frFR = "Noxcion", esES = "Noxxion", esMX = "Noxxion", ptBR = "Tóxxico", ruRU = "Ноксион" },
				does = { "FDG_MARA_1_D1", "FDG_MARA_1_D2", "FDG_MARA_1_D3" },
				tip = "FDG_MARA_1_T",
				-- src: gif op groep 2x CQ+IVC (WOWF ook); kopieën 2x CQ+IVC (WT ook); Rod 2x CQ+WHT 17702 'Dropped by: Noxxion' (FDJ ook); tip 2x CQ+IVC
			},
			{ npc = 12258, encounter = 423, name = "Razorlash", part = "FDGP_ORANGE_SIDE",
				names = { deDE = "Schlingwurzler", frFR = "Tranchefouet", esES = "Latisable", esMX = "Latisable", ptBR = "Azorrague", ruRU = "Бритвохлест" },
				does = { "FDG_MARA_2_D1" },
				tip = "FDG_MARA_2_T",
				-- src: 2x WT+IVC (WOWF, CQ ook); tip 2x WT+IVC (CQ ook)
			},
			{ npc = 12236, encounter = 424, name = "Lord Vyletongue", part = "FDGP_PURPLE_SIDE",
				names = { deDE = "Lord Schlangenzunge", frFR = "Seigneur Vylelangue", esES = "Lord Lenguavil", esMX = "Lord Lenguavil", ptBR = "Lorde Torpelíngua", ruRU = "Лорд Злоязыкий" },
				does = { "FDG_MARA_3_D1", "FDG_MARA_3_D2", "FDG_MARA_3_D3" },
				tip = "FDG_MARA_3_T",
				-- src: wachters 2x WT+CQ (IVC ook); schieten + teleport 2x WT+CQ (IVC ook); stun 2x WT+IVC (WOWF ook); Diamond 2x CQ+WHT 17703 'Dropped by: Lord Vyletongue' (FDJ ook); tip 2x WT+CQ (WFBE ook)
			},
			{ npc = 12225, encounter = 425, name = "Celebras the Cursed", part = "FDGP_POISON_FALLS",
				names = { deDE = "Celebras der Verfluchte", frFR = "Celebras le Maudit", esES = "Celebras el Maldito", esMX = "Celebras el Maldito", ptBR = "Celebras, o Amaldiçoado", ruRU = "Келебрас Проклятый" },
				does = { "FDG_MARA_4_D1", "FDG_MARA_4_D2", "FDG_MARA_4_D3" },
				tip = "FDG_MARA_4_T",
				-- src: helpers 2x WT+IVC (CQ ook); wortels 2x WT+IVC; vertragen 2x WOWF+WW; scepter + shortcut 2x CQ+WT (WHT 17191: portal naar Earth Song Falls); tip boss eerst 2x WT+IVC (CQ ook), onderbreken 2x WT+CQ
			},
			{ npc = 12237, name = "Meshlok the Harvester", part = "FDGP_POISON_FALLS", rare = true,
				names = { deDE = "Meshlok der Ernter", frFR = "Meshlok le Moissonneur", esES = "Meshlok el Cosechador", esMX = "Meshlok el Cosechador", ptBR = "Meshloc, o Ceifador", ruRU = "Мешлок Жнец" },
				does = { "FDG_MARA_5_D1", "FDG_MARA_5_D2" },
				tip = "FDG_MARA_5_T",
				-- src: rare 2x WT+CQ (WHT 'Rare Elite'); stomp 2x WT+IVC (WW ook); tip 2x WT+CQ. Plek: WT/WOWF/WW bij Poison Falls; FDJ paarse vleugel; CQ tussen oranje en paars
			},
			{ npc = 12203, encounter = 426, name = "Landslide", part = "FDGP_EARTH_SONG_FALLS",
				names = { deDE = "Erdrutsch", frFR = "Glissement de terrain", esES = "Derrumblo", esMX = "Derrumblo", ptBR = "Soterrador", ruRU = "Обвал" },
				does = { "FDG_MARA_6_D1", "FDG_MARA_6_D2" },
				tip = "FDG_MARA_6_T",
				-- src: stun + helpers 2x CQ+WT (IVC ook); helpers sterven mee 2x CQ+WT; knockback 2x WT+IVC; tip muur 2x WT+CQ (IVC ook), negeren 2x WT+CQ
			},
			{ npc = 13601, encounter = 427, name = "Tinkerer Gizlock", part = "FDGP_EARTH_SONG_FALLS",
				names = { deDE = "Tüftler Gizlock", frFR = "Bricoleur Kadenaz", esES = "Manitas Gizlock", esMX = "Manitas Gizlock", ptBR = "Engenhoqueiro Bugitranca", ruRU = "Ремонтник Гизлок" },
				does = { "FDG_MARA_7_D1", "FDG_MARA_7_D2" },
				tip = "FDG_MARA_7_T",
				-- src: vuur + explosieven 2x WT+CQ (IVC, WOWF ook); schieten 2x WT+CQ (WHC ook); tip 2x WT+CQ (WHC, WFBE ook; IVC Classic: casters juist op afstand) | MEASURE: Part: Classic had him in Earth Song Falls (IVC Inner, WHC, WT text, WOWF; WW: moved to the Wicked Grotto in patch 4.0.3). CQ, WFBE, wowfdb and the retail Journal (UiMap 280) put him on the purple side. Which one in Forever?
			},
			{ npc = 13596, encounter = 428, name = "Rotgrip", part = "FDGP_EARTH_SONG_FALLS",
				names = { deDE = "Faulschnapper", frFR = "Grippe-charogne", esES = "Escamapodrida", esMX = "Escamapodrida", ptBR = "Putrigarra", ruRU = "Гнилопасть" },
				does = { "FDG_MARA_8_D1", "FDG_MARA_8_D2" },
				tip = "FDG_MARA_8_T",
				-- src: meer onder de prinses 2x WT+CQ (IVC ook); hydra's eerst 2x WT+WHC; hard + bloeden 2x WT+WOWF; tip 2x WT+CQ
			},
			{ npc = 12201, encounter = 429, name = "Princess Theradras", part = "FDGP_EARTH_SONG_FALLS",
				names = { deDE = "Prinzessin Theradras", frFR = "Princesse Theradras", esES = "Princesa Theradras", esMX = "Princesa Theradras", ptBR = "Princesa Theradras", ruRU = "Принцесса Терадрас" },
				does = { "FDG_MARA_9_D1", "FDG_MARA_9_D2" },
				tip = "FDG_MARA_9_T",
				-- src: fear 2x WT+CQ (WOWF ook); stofwolk + keien 2x WT+CQ; tip 2x WT+CQ. Weggelaten: waar de tank haar zet (WT: achterin het platform; CQ: weg van de randen)
			},
		},
		loot = {
			{ item = 17744, boss = 13282, role = "FDG_MARA_L1", part = "FDGP_ORANGE_SIDE" }, -- src: WHT Dropped by + FC + CQ
			{ item = 17752, boss = 12236, role = "FDG_MARA_L2", part = "FDGP_PURPLE_SIDE" }, -- src: WHT Dropped by + FC + CQ
			{ item = 17738, boss = 12225, role = "FDG_MARA_L3", part = "FDGP_POISON_FALLS" }, -- src: WHT Dropped by + FC + CQ
			{ item = 17715, boss = 12201, role = "FDG_MARA_L4", part = "FDGP_EARTH_SONG_FALLS" }, -- src: WHT Dropped by + FC + CQ
		},
	},
	[2994] = { -- ALCAZ
		bosses = {
			{ npc = 255997, encounter = 3410, name = "Tidemistress Ca'zass", recheck = true,
				names = { deDE = "Gezeitenherrin Ca'zass", frFR = "Maîtresse des marées Ca’zass", esES = "Maestra de las mareas Ca'zass", esMX = "Ama de las mareas Ca'zass", ptBR = "Senhora das Marés Ca'zass", ruRU = "Повелительница приливов Ка'засс" },
				does = { "FDG_ALCAZ_1_D1", "FDG_ALCAZ_1_D2", "FDG_ALCAZ_1_D3" },
				tip = "FDG_ALCAZ_1_T",
				-- src: twee adds 2x WH+MOBU (CQ ook); schapen 2x CQ+MOBU (WH ook); volley 2x WH+MOBU; blizzard 2x WH+CQ; onderbreken 2x CQ+MOBU; adds eerst 2x WH+CQ (MOBU ook); uit blizzard 2x WH+CQ
			},
			{ npc = 255391, encounter = 3403, name = "Overseer Wrex", recheck = true,
				names = { deDE = "Aufseher Wrex", frFR = "Surveillant Wrex", esES = "Sobrestante Wrex", esMX = "Sobrestante Wrex", ptBR = "Feitor Wrex", ruRU = "Надзиратель Рекс" },
				does = { "FDG_ALCAZ_2_D1", "FDG_ALCAZ_2_D2" },
				tip = "FDG_ALCAZ_2_T",
				-- src: drie kamers 2x WH+MOBU (CQ: zijn hele kamer); sleutelbos 2x CQ+FDJ (Journal.lua r.305-308); tip 2x WH+MOBU. CQ wil hem juist de gang in trekken; niet in de tekst
			},
			{ npc = 257016, encounter = 3418, name = "Katerina the Cleaner", recheck = true,
				names = { deDE = "Katerina die Aufräumerin", frFR = "Katerina la Nettoyeuse", esES = "Katerina la Limpiadora", esMX = "Katerina, la Limpiadora", ptBR = "Katerina, a Faxineira", ruRU = "Катерина Чистильщица" },
				does = { "FDG_ALCAZ_3_D1", "FDG_ALCAZ_3_D2" },
				tip = "FDG_ALCAZ_3_T",
				-- src: benedenverdieping 2x CQ+FDJ; chaplains 2x WH+MOBU (CQ ook); speler aanvallen 2x WH+MOBU (WH: willekeurig, MOBU: ranged); tip 2x WH+WT (controle BC R6; mmonerds en ssegold citeren WH). Gif op tank: alleen WH, weggelaten | MEASURE: CQ (8 Nov) describes heavy fire on the whole group and a room full of fire; WH (15 Nov) and MOBU (16 Nov) do not. Which is right?
			},
			{ npc = 255702, extraNpc = 255707, encounter = 3409, name = "Blazeroar", recheck = true,
				names = { deDE = "Blazeroar", frFR = "Rugiflamme", esES = "Rugellama", esMX = "Rugellamas", ptBR = "Rugequeima", ruRU = "Пламеяра" },
				does = { "FDG_ALCAZ_4_D1", "FDG_ALCAZ_4_D2" },
				tip = "FDG_ALCAZ_4_T",
				-- src: Zarla + vuur + draak 2x WH+MOBU (CQ ook; moment: WH 30%, MOBU ~20%, daarom geen getal); adem voor haar 2x WH+MOBU; fear 2x WH+MOBU; tip 2x WH+MOBU. 'Vuur doet niets': alleen CQ, weggelaten
			},
			{ npc = 256236, encounter = 3415, name = "The Questioner", recheck = true,
				names = { deDE = "Der Verhörer", frFR = "L’Interrogateur", esES = "El Interrogador", esMX = "El interrogador", ptBR = "O Questionador", ruRU = "Дознаватель" },
				does = { "FDG_ALCAZ_5_D1", "FDG_ALCAZ_5_D2", "FDG_ALCAZ_5_D3" },
				tip = "FDG_ALCAZ_5_T",
				-- src: helpers 2x WH+MOBU; leegzuigen 2x WH+MOBU (onderbreken: MOBU, dispel: WH); sleutel 2x FC+MOBU (FDJ ook); als laatste 2x WH+MOBU (CQ ook)
			},
		},
		loot = {
			{ item = 276735, boss = 255997, role = "FDG_ALCAZ_L1", recheck = true }, -- src: WHT Dropped by + CQ (id: FDJ)
			{ item = 276739, boss = 257016, role = "FDG_ALCAZ_L2", recheck = true }, -- src: WHT Dropped by + CQ (id: FDJ)
			{ item = 276732, boss = 255391, role = "FDG_ALCAZ_L3", recheck = true }, -- src: WHT Dropped by + CQ (id: FDJ)
		},
	},
}
