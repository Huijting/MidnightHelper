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
				names = { deDE = "Lady Anacondra", frFR = "Dame Anacondra", esES = "Lady Anacondra", esMX = "Lady Anacondra", ptBR = "Lady Sucurina", ruRU = "Повелительница Анакондра" },
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
				names = { deDE = "Verdan der Ewiglebende", frFR = "Verdan l’Immortel", esES = "Verdan el Eterno", esMX = "Verdan el Eterno", ptBR = "Verdan, o Sempre-vivo", ruRU = "Вердан Бессмертный" },
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
				names = { deDE = "Kapitän Grünhaut", frFR = "Capitaine Vertepeau", esES = "Capitán Verdepel", esMX = "Capitán Verdetez", ptBR = "Capitão Peleverde", ruRU = "Капитан Зеленямс" },
				does = { "FDG_DM_5_D1", "FDG_DM_5_D2" },
				tip = "FDG_DM_5_T",
				-- src: cleave 2x IV+MOB; gif 2x MOB+FH; tip 2x IV+MOB
			},
			{ npc = 646, encounter = 2745, name = "Mr. Smite",
				names = { deDE = "Handlanger Pein", frFR = "M. Smite", esES = "Sr. Golpin", esMX = "Don Mamporro", ptBR = "Sr. Castiga", ruRU = "Мистер Каюк" },
				does = { "FDG_DM_6_D1", "FDG_DM_6_D2" },
				tip = "FDG_DM_6_T",
				-- src: 2x IV+MOB (IV: 66% en 33%; 'hidden' = MOB+FH)
			},
			{ npc = 645, encounter = 2746, name = "Cookie",
				names = { deDE = "Krümel", frFR = "Macaron", esES = "El Chef", esMX = "Cocinitas", ptBR = "Cuca", ruRU = "Пирожок" },
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
				names = { deDE = "Baron Silberlein", frFR = "Baron d’Argelaine", esES = "Barón Filargenta", esMX = "Barón Filargenta", ptBR = "Barão Silverlaine", ruRU = "Барон Сребролен" },
				does = { "FDG_SFK_3_D1" },
				tip = "FDG_SFK_3_T",
				-- src: 2x IV+MOB (WH ook); tip 2x MOB+WH (IV: heal more) | MEASURE: Veil of Shadow: curse on one player or on everyone near him? (7068 vs 460755; 23224 also exists)
			},
			{ npc = 4278, encounter = 2751, name = "Commander Springvale",
				names = { deDE = "Kommandant Springvale", frFR = "Commandant Springvale", esES = "Comandante Vallefont", esMX = "Comandante Vallefont", ptBR = "Comandante Floraval", ruRU = "Командир Ручьедол" },
				does = { "FDG_SFK_4_D1", "FDG_SFK_4_D2" },
				tip = "FDG_SFK_4_T",
				-- src: 2x IV+MOB (WH ook). Kill-volgorde verschilt: IV de Guardsman eerst, MOB+WH de Servitor eerst; daarom niet in de tip
			},
			{ npc = 4279, encounter = 2752, name = "Odo the Blindwatcher",
				names = { deDE = "Odo der Blindseher", frFR = "Odo l’Aveugle", esES = "Odo el Cegato", esMX = "Odo el Vigía Ciego", ptBR = "Odo, o Vigia Cego", ruRU = "Одо Слепой Страж" },
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
				names = { deDE = "Dextren Ward", frFR = "Dextren Ward", esES = "Dextren Tutor", esMX = "Dextren Ward", ptBR = "Flávio Lúcio", ruRU = "Декстрен Вард" },
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
				names = { deDE = "Elektrokutor 6000", frFR = "Électrocuteur 6000", esES = "Electrocutor 6000", esMX = "Electrocutor 6000", ptBR = "Eletrocutor 6000", ruRU = "Электрошокер 6000" },
				does = { "FDG_GNOMER_3_D1", "FDG_GNOMER_3_D2", "FDG_GNOMER_3_D3" },
				tip = "FDG_GNOMER_3_T",
				-- src: bliksem 2x IV+WT (MOB, CQ, UGT ook); kegel voor hem 2x IV+CQ (UGT ook); sleutel 2x IV+WT (WH, CQ, UGT ook); spreiden 2x IV+WT; alleen tank vooraan 2x CQ+UGT (MOB ook). Onderbreken weggelaten: MOB/CQ/UGT ja, WT/WFDB nee
			},
			{ npc = 6229, encounter = 2771, name = "Crowd Pummeler 9-60",
				names = { deDE = "Meuteverprügler 9-60", frFR = "Faucheur de foule 9-60", esES = "Golpeamasa 9-60", esMX = "Golpeamasa 9-60", ptBR = "Espanca-gente 9-60", ruRU = "\"Толпогон 9-60\"" },
				does = { "FDG_GNOMER_4_D1", "FDG_GNOMER_4_D2" },
				tip = "FDG_GNOMER_4_T",
				-- src: kegel 2x IV+CQ (MOB, UGT ook); dichtbij + spells stoppen 2x IV+CQ (WT: trapt wie dichtbij staat); weggedraaid 2x MOB+UGT; afstand 2x IV+WT (MOB, CQ ook)
			},
			{ npc = 7800, encounter = 2772, name = "Mekgineer Thermaplugg",
				names = { deDE = "Robogenieur Thermaplugg", frFR = "Mekgénieur Thermaplugg", esES = "Mekigeniero Termochufe", esMX = "Mekigeniero Termochufe", ptBR = "Mecangenheiro Termaplugue", ruRU = "Мекжинер Термоштепсель" },
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
				names = { deDE = "Aggem Dornfluch", frFR = "Aggem Mantépine", esES = "Aggem Malaespina", esMX = "Aggem Malaespina", ptBR = "Aggem Pragacardo", ruRU = "Аггем Терновое Проклятие" },
				does = { "FDG_RFK_2_D1" },
				tip = "FDG_RFK_2_T",
				-- src: 2x IV+WH (WT, MOB ook); tip 2x IV+WH (WT ook; MOB: de boar negeren mag ook)
			},
			{ npc = 4428, encounter = 2775, name = "Death Speaker Jargba",
				names = { deDE = "Todessprecher Jargba", frFR = "Nécrorateur Jargba", esES = "Médium Jargba", esMX = "Portavoz de la muerte Jargba", ptBR = "Morta-voz Jargba", ruRU = "Вестник смерти Джаргба" },
				does = { "FDG_RFK_3_D1", "FDG_RFK_3_D2" },
				tip = "FDG_RFK_3_T",
				-- src: twee helpers 2x IV+WH (WT: Acolyte + Groundshaker); hard 2x WH+MOB; mind control 2x IV+WH (WT, MOB ook); CC 2x IV+WH (MOB ook); onderbreken 2x MOB+WT. Kill-volgorde verschilt (IV: helpers eerst, WH/MOB: Jargba eerst), daarom niet in de tip
			},
			{ npc = 4420, encounter = 2776, name = "Overlord Ramtusk",
				names = { deDE = "Oberanführer Rammhauer", frFR = "Seigneur Brusquebroche", esES = "Señor Supremo Colmicarnero", esMX = "Señor supremo Colmicarnero", ptBR = "Lorde Supremo Marretusco", ruRU = "Властитель Таранный Клык" },
				does = { "FDG_RFK_4_D1", "FDG_RFK_4_D2" },
				tip = "FDG_RFK_4_T",
				-- src: Spearhides 2x IV+WH (WT ook); spinnen 2x WH+WT (MOB ook); tank hard 2x IV+WH (MOB ook); CC 2x IV+WH (WT, MOB ook); uit melee 2x MOB+WT
			},
			{ npc = 4422, encounter = 2777, name = "Agathelos the Raging",
				names = { deDE = "Agathelos der Tobende", frFR = "Agathelos l'Enragé", esES = "Agathelos el Furioso", esMX = "Agathelos el Furioso", ptBR = "Agathelos, o Furioso", ruRU = "Агателос Свирепый" },
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
				names = { deDE = "Befrager Vishas", frFR = "Interrogateur Vishas", esES = "Interrogador Vishas", esMX = "Interrogador Vishas", ptBR = "Interrogador Vishas", ruRU = "Дознаватель Вишас" },
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
				names = { deDE = "Blutmagier Thalnos", frFR = "Mage de sang Thalnos", esES = "Mago sangriento Thalnos", esMX = "Mago sangriento Thalnos", ptBR = "Mago Sangrento Thalnos", ruRU = "Волшебник Крови Талнос" },
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
				names = { deDE = "Herod", frFR = "Hérode", esES = "Herod", esMX = "Herod", ptBR = "Herodes", ruRU = "Герод" },
				does = { "FDG_SM_8_D1", "FDG_SM_8_D2" },
				tip = "FDG_SM_8_T",
				-- src: cleave 2x IV+WH; spinnen 2x IV+WH (WT, GG, WFDB ook); trainees 2x IV+WH (WT, GG, WFDB, FDJ ook); wegstappen 2x IV+WH (WT, GG ook); samenblijven 2x IV+WH (GG ook). Wanneer hij spint verschilt (IV: vanaf de helft, GG: elke 15-25 s): weggelaten
			},
			{ npc = 4542, encounter = 449, name = "High Inquisitor Fairbanks", part = "FDGP_CATHEDRAL", optional = true,
				names = { deDE = "Hochinquisitor Fairbanks", frFR = "Grand inquisiteur Fairbanks", esES = "Alto inquisidor Ribalimpia", esMX = "Alto inquisidor Ribalimpia", ptBR = "Alto-inquisidor Fairbanks", ruRU = "Верховный инквизитор Фэйрбанкс" },
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
				names = { deDE = "Hochinquisitor Whitemane", frFR = "Grand Inquisiteur Whitemane", esES = "Alta inquisidora Melenablanca", esMX = "Alta inquisidora Melenablanca", ptBR = "Alta-inquisidora Cristalba", ruRU = "Верховный инквизитор Вайтмейн" },
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
				names = { deDE = "Plaguemaw der Faulende", frFR = "Pestegueule le Pourrissant", esES = "Fauzpeste el Putrefacto", esMX = "Faucepeste el Podrido", ptBR = "Pragorja, o Podre", ruRU = "Чумобрюх Гнилой" },
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
				names = { deDE = "Nar'guk", frFR = "Nar’gurk", esES = "Nar'gurk", esMX = "Nar'gurk", ptBR = "Nar'gurk", ruRU = "Нар'гурк" },
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
				names = { deDE = "Uralter Steinbewahrer", frFR = "Ancien Gardien des pierres", esES = "Vigilante pétreo anciano", esMX = "Vigilante de piedra anciano", ptBR = "Antigo Protetor de Pedra", ruRU = "Древний Хранитель Камня" },
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
				names = { deDE = "Wasserbeschwörerin Velratha", frFR = "Hydromancienne Velratha", esES = "Hidromántica Velratha", esMX = "Hidromántica Velratha", ptBR = "Hidromante Velratha", ruRU = "Гидромант Велрата" },
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
				names = { deDE = "Hexendoktor Zum'rah", frFR = "Sorcier-docteur Zum'rah", esES = "Médico brujo Zum'rah", esMX = "Médico brujo Zum'rah", ptBR = "Mandingueiro Zum'rah", ruRU = "Знахарь Зум'рах" },
				does = { "FDG_ZF_5_D1", "FDG_ZF_5_D2", "FDG_ZF_5_D3" },
				tip = "FDG_ZF_5_T",
				-- src: zombies 2x CQ+IVC (HP ook); kampen eerst 2x IVC+HP; ward 2x CQ+MOB (HP ook); volley + heal 2x MOB+CQ (IVC ook); tip ward 2x CQ+HP, onderbreken 2x MOB+CQ
			},
			{ npc = 7796, encounter = 598, name = "Nekrum Gutchewer",
				names = { deDE = "Nekrum der Ausweider", frFR = "Nekrum Mâchetripes", esES = "Nekrum Cometripas", esMX = "Nekrum Cometripas", ptBR = "Nekrum Cometripas", ruRU = "Некрум Кишкожуй" },
				does = { "FDG_ZF_6_D1", "FDG_ZF_6_D2" },
				tip = "FDG_ZF_6_T",
				-- src: trappen-event 2x CQ+HP (IVC, WFBE ook; WHT 8444 Executioner's Key 'Dropped by: Sandfury Executioner'); laatste golf 2x CQ+HP (IVQ ook); bovenaan blijven 2x CQ+HP (IVC: niet de piramide af); Nekrum eerst 2x CQ+HP (WFBE ook)
			},
			{ npc = 7275, encounter = 599, name = "Shadowpriest Sezz'ziz",
				names = { deDE = "Schattenpriester Sezz'ziz", frFR = "Prêtre des ombres Sezz’ziz", esES = "Sacerdote oscuro Sezz'ziz", esMX = "Sacerdote oscuro Sezz'ziz", ptBR = "Sacerdote Sombrio Diz'ieh", ruRU = "Темный жрец Шезз'зиз" },
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
				names = { deDE = "Häuptling Ukorz Sandskalp", frFR = "Chef Ukorz Scalpessable", esES = "Jefe Ukorz Cabellarena", esMX = "Jefe Ukorz Cabellarena", ptBR = "Chefe Ukorz Escalpareia", ruRU = "Вождь Укорз Песчаная Плешь" },
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
				names = { deDE = "Celebras der Verfluchte", frFR = "Celebras le Maudit", esES = "Celebras el Maldito", esMX = "Celebras el Maldito", ptBR = "Celebras, o Amaldiçoado", ruRU = "Селебрас Проклятый" },
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
				names = { deDE = "Erdrutsch", frFR = "Glissement de terrain", esES = "Derrumblo", esMX = "Derrumblo", ptBR = "Soterrador", ruRU = "Сель" },
				does = { "FDG_MARA_6_D1", "FDG_MARA_6_D2" },
				tip = "FDG_MARA_6_T",
				-- src: stun + helpers 2x CQ+WT (IVC ook); helpers sterven mee 2x CQ+WT; knockback 2x WT+IVC; tip muur 2x WT+CQ (IVC ook), negeren 2x WT+CQ
			},
			{ npc = 13601, encounter = 427, name = "Tinkerer Gizlock", part = "FDGP_EARTH_SONG_FALLS",
				names = { deDE = "Tüftler Gizlock", frFR = "Artisan Gizlock", esES = "Manitas Gizlock", esMX = "Manitas Gizlock", ptBR = "Engenhoqueiro Bugitranca", ruRU = "Ремонтник Гизлок" },
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
	[109] = { -- ST
		bosses = {
			{ npc = 8580, encounter = 3582, encounterAlt = 2814, name = "Atal'alarion", optional = true,
				names = { deDE = "Atal'alarion", frFR = "Atal'alarion", esES = "Atal'alarion", esMX = "Atal'alarion", ptBR = "Atal'alarion", ruRU = "Атал'аларион" },
				does = { "FDG_ST_1_D1", "FDG_ST_1_D2" },
				tip = "FDG_ST_1_T",
				-- src: optioneel 2x CQ+CWF (CQ: 'if they need it'; CWF eigen label 'Optional'); schreinen + volgorde 2x WH+CQ (IVC, WTC ook); slag + de lucht in 2x WH+CQ (IVC, WTC, MOB ook); stun dichtbij 2x CQ+IVC(Classic) (WFDB ook); muur 2x WH+MOB; weggedraaid 2x CQ+MOB; ver weg 2x WH+IVC(Classic) (WTC ook)
			},
			{ npc = 5714, extraNpc = { 5713, 5717, 5712, 5716, 5715 }, name = "Atal'ai Defenders",
				names = { deDE = "Verteidiger der Atal'ai", frFR = "Défenseurs atal’ai", esES = "Defensores Atal'ai", esMX = "Defensores de Atal'ai", ptBR = "Defensores Atal'ai", ruRU = "Защитники Атал'ай" },
				does = { "FDG_ST_2_D1", "FDG_ST_2_D2", "FDG_ST_2_D3" },
				tip = "FDG_ST_2_T",
				-- src: zes op balkons 2x WH+CQ (IVC, WTC, MOB ook); alle zes voor Jammal'an 2x WH+CQ (IVC, WTC ook); ward/totem/demonen 2x WH(vaardighedenlijst)+CQ (WTC ook); tip 2x CQ+MOB (CWF ook) | MEASURE: No name plate for the group: names = DB2 encounter 2954 'Atal'ai Defenders' (DifficultyID 215, the 20-player set; there is no 5-player row). npc 5714 (Loro) is only the first of six. Does the guide show the group name? (generator: put 5714 in KEEP_GROUP if DG_PLATES is used)
			},
			{ npc = 5710, extraNpc = 5711, encounter = 3589, encounterAlt = 488, name = "Jammal'an the Prophet",
				names = { deDE = "Jammal'an der Prophet", frFR = "Jammal'an le prophète", esES = "Jammal'an el Profeta", esMX = "Jammal'an el Profeta", ptBR = "Jammal'an, o Profeta", ruRU = "Джаммал'ан Пророк" },
				does = { "FDG_ST_3_D1", "FDG_ST_3_D2" },
				tip = "FDG_ST_3_T",
				-- src: Ogom erbij 2x WH+CQ (IVC ook); minder leven 2x WH+IVC(Classic) (MOB, CWF ook); schaduw + vloek 2x WH(lijst)+IVC (WFDB ook); speler wordt trol 2x WH+CQ (IVC ook); heal 2x CQ+IVC; vuur op de grond 2x WH+CQ (IVC ook); spreiden 2x WH+IVC (WTC ook); onderbreken 2x CQ+IVC (CWF ook); wegblijven 2x WH+IVC. Kill-volgorde verschilt (WH, MOB, IVC: Ogom eerst; CQ: Jammal'an eerst): niet in de tip
			},
			{ npc = 5721, encounter = 3588, encounterAlt = 486, name = "Dreamscythe",
				names = { deDE = "Traumsense", frFR = "Fauche-rêve", esES = "Guadañasueños", esMX = "Segasueños", ptBR = "Darquimeros", ruRU = "Жнец Снов" },
				does = { "FDG_ST_4_D1", "FDG_ST_4_D2" },
				tip = "FDG_ST_4_T",
				-- src: na Jammal'an 2x WH+WTC(Classic) (WFDB ook; CQ: vliegt in de centrale hal); adem + vleugels 2x WH+CQ (IVC ook); apart trekken 2x CQ+IVC(Classic) (WTC, CWF ook); muur + weggedraaid 2x WH+CQ
			},
			{ npc = 5720, encounter = 3587, encounterAlt = 487, name = "Weaver",
				names = { deDE = "Wirker", frFR = "Tisserand", esES = "Sastrón", esMX = "Sastrón", ptBR = "Tecelão", ruRU = "Ткачик" },
				does = { "FDG_ST_5_D1", "FDG_ST_5_D2" },
				tip = "FDG_ST_5_T",
				-- src: na Jammal'an 2x WH+WTC(Classic) (WFDB ook; CQ: vliegt in de centrale hal); adem + vleugels 2x WH+CQ (IVC ook); apart trekken 2x CQ+IVC(Classic) (WTC, CWF ook); muur + weggedraaid 2x WH+CQ
			},
			{ npc = 5719, encounter = 3586, encounterAlt = 490, name = "Morphaz",
				names = { deDE = "Morphaz", frFR = "Morphaz", esES = "Morphaz", esMX = "Morphaz", ptBR = "Morphaz", ruRU = "Морфаз" },
				does = { "FDG_ST_6_D1", "FDG_ST_6_D2", "FDG_ST_6_D3" },
				tip = "FDG_ST_6_T",
				-- src: na Dreamscythe/Weaver + plek 2x WH+WTC(Classic) (CQ: zuidelijke hal voor Eranikus); adem + vleugels 2x WH+CQ (IVC ook); klassenquests 2x CQ+FDJ (FC ook); omgeving eerst 2x WH+MOB; muur + weggedraaid 2x WH+CQ. Of je hem los van Hazzas kunt trekken verschilt (IVC, WTC, CWF: nee; WH: probeer het): weggelaten
			},
			{ npc = 5722, encounter = 3585, encounterAlt = 491, name = "Hazzas",
				names = { deDE = "Hazzas", frFR = "Hazzas", esES = "Hazzas", esMX = "Hazzas", ptBR = "Hazzas", ruRU = "Хаззас" },
				does = { "FDG_ST_7_D1", "FDG_ST_7_D2" },
				tip = "FDG_ST_7_T",
				-- src: na Dreamscythe/Weaver + plek 2x WH+WTC(Classic) (CQ: zuidelijke hal voor Eranikus); adem + vleugels 2x WH+CQ (IVC ook); omgeving eerst 2x WH+MOB; muur + weggedraaid 2x WH+CQ. Los van Morphaz trekken: zie Morphaz
			},
			{ npc = 5709, encounter = 3584, encounterAlt = 493, name = "Shade of Eranikus",
				names = { deDE = "Eranikus' Schemen", frFR = "Ombre d'Eranikus", esES = "Sombra de Eranikus", esMX = "Sombra de Eranikus", ptBR = "Vulto de Erânicos", ruRU = "Тень Эраникуса" },
				does = { "FDG_ST_8_D1", "FDG_ST_8_D2", "FDG_ST_8_D3" },
				tip = "FDG_ST_8_T",
				-- src: dragonkin komen 2x WH+CQ (WTC, MOB ook); slaap 2x WH+CQ (IVC ook); stun dichtbij 2x WH+CQ (IVC ook); adem vooraan 2x CQ+MOB (WFDB ook, WH-lijst); dragonkin eerst 2x WH+CQ; uit melee 2x WH+CQ; alleen tank vooraan 2x WH+MOB. Wie de slaap krijgt verschilt (WH: hoogste threat; IVC: hoogste threat behalve de tank; MOB: ook de tank): geen doelwit genoemd
			},
			{ npc = 8443, encounter = 3583, encounterAlt = 492, name = "Avatar of Hakkar", optional = true,
				names = { deDE = "Avatar von Hakkar", frFR = "Avatar d'Hakkar", esES = "Avatar de Hakkar", esMX = "Avatar de Hakkar", ptBR = "Avatar de Hakkar", ruRU = "Аватара Хаккара" },
				does = { "FDG_ST_9_D1", "FDG_ST_9_D2", "FDG_ST_9_D3" },
				tip = "FDG_ST_9_T",
				-- src: optioneel + ei uit Tanaris 2x WH+CQ (IVC, MOB ook); rol later 2x WH+IVC(Classic) (CWF ook); kamer in het westen 2x WH+WTC(Classic); golven + bloed + vier vlammen 2x WH+CQ (IVC ook; bloed looten en op een vlam gebruiken: WH letterlijk, controle 2b DE R7); speler gek 2x WH+CQ (IVC, MOB ook); tip 2x WH+CQ (IVC, MOB ook)
			},
		},
		loot = {
			{ item = 10835, boss = 5709, role = "FDG_ST_L1" }, -- src: WHT Dropped by + FC(Classic-lijst) + CQ + WH (FDJ ook)
			{ item = 10806, boss = 5710, role = "FDG_ST_L2" }, -- src: WHT Dropped by + FC(Classic-lijst) + CQ + WH (MOB ook)
			{ item = 10804, boss = 5711, role = "FDG_ST_L3" }, -- src: WHT Dropped by + FC(Classic-lijst) + CQ + WH (MOB ook)
		},
	},
	[230] = { -- BRD
		bosses = {
			{ npc = 9018, encounter = 227, name = "High Interrogator Gerstahn",
				names = { deDE = "Verhörmeisterin Gerstahn", frFR = "Grand Interrogateur Gerstahn", esES = "Alta interrogadora Gerstahn", esMX = "Alta interrogadora Gerstahn", ptBR = "Suprema Interrogadora Gerstahn", ruRU = "Верховный дознаватель Герштан" },
				does = { "FDG_BRD_1_D1", "FDG_BRD_1_D2" },
				tip = "FDG_BRD_1_T",
				-- src: sleutel 2x WH+CQ (IVC, WTC ook); fear 2x WH+CQ (IVC ook); mana 2x WH+CQ (IVC ook); schaduw-dot 2x WH+CQ; packs eerst 2x WH+IVC(Classic); onderbreken 2x WH+IVC (CQ ook)
			},
			{ npc = 9025, encounter = 228, name = "Lord Roccor",
				names = { deDE = "Lord Roccor", frFR = "Seigneur Roccor", esES = "Lord Roccor", esMX = "Lord Roccor", ptBR = "Lorde Pétror", ruRU = "Лорд Роккор" },
				does = { "FDG_BRD_2_D1", "FDG_BRD_2_D2" },
				tip = "FDG_BRD_2_T",
				-- src: plek ring 2x WH+WTC(Classic); 'loopt rond' alleen WTC (Classic): weggelaten; makkelijk 2x WH+CQ; onderbreken 2x WH+IVC(Classic); tip 2x WH+CQ. Stun dichtbij: alleen IVC/WTC (Classic), WH-lijst noemt hem niet: weggelaten
			},
			{ npc = 9319, encounter = 229, name = "Houndmaster Grebmar",
				names = { deDE = "Hundemeister Grebmar", frFR = "Maître-chien Grebmar", esES = "Domador de jaurías Grebmar", esMX = "Maestro de canes Grebmar", ptBR = "Mestre de Matilha Grebmar", ruRU = "Псарь Гребмар" },
				does = { "FDG_BRD_3_D1", "FDG_BRD_3_D2" },
				tip = "FDG_BRD_3_T",
				-- src: twee packs 2x WH+CQ (IVC, WTC ook); sneller 2x WH(lijst)+WTC(Classic) (IVC-lijst ook); tip 2x WH+IVC(Classic) (CQ: eerst beide packs)
			},
			{ extraNpc = { 9027, 9028, 9029, 9030, 9031, 9032 }, encounter = 230, name = "Ring of Law",
				names = { deDE = "Ring des Gesetzes", frFR = "Cercle de la loi", esES = "Círculo de la Ley", esMX = "Círculo de la Ley", ptBR = "Círculo da Lei", ruRU = "Зал Правосудия" },
				does = { "FDG_BRD_4_D1", "FDG_BRD_4_D2", "FDG_BRD_4_D3" },
				tip = "FDG_BRD_4_T",
				-- src: poort dicht 2x WTC+WMC (Classic; WH/CQ niet tegen); arena + golven + willekeurige baas 2x WH+CQ (IVC, WTC ook); schaap 2x WH+CQ (IVC ook); minder healing op de tank 2x WH+WTC(Classic) (CQ noemt de vaardigheid); gif 2x WH+CQ (IVC ook); tweede poort 2x WH+WTC(Classic) (CQ: 'East Garrison' als vervolg); dispel 2x WH+IVC(Classic). Theldren (banner, level 60): weggelaten | MEASURE: No name plate: names = DB2 encounter 230 'Ring of Law'. Six possible bosses (extraNpc); High Justice Grimstone (10096) announces. Does ENCOUNTER_START 230 fire when the boss wave starts or when you step in?
			},
			{ npc = 9024, encounter = 231, name = "Pyromancer Loregrain", optional = true,
				names = { deDE = "Pyromant Weisenkorn", frFR = "Pyromancien Loregrain", esES = "Piromántico Cultugrano", esMX = "Piromántico Fruto del Saber", ptBR = "Piromante Sábia Semente", ruRU = "Пироман Зерно Мудрости" },
				does = { "FDG_BRD_5_D1", "FDG_BRD_5_D2" },
				tip = "FDG_BRD_5_T",
				-- src: optioneel 2x WH+FC (WH: 'optional boss'; FC: 'Rare spawn'); monument 2x WH+WTC(Classic); totem 2x WH+CQ (IVC ook); vuurspells 2x WH(lijst)+IVC; tip 2x WH+CQ (IVC ook) | MEASURE: Rare? Wowhead Classic tooltip = 'Rare Elite', Wowhead Forever tooltip = 'Elite' (both GEMETEN 18 Nov); FC calls him a rare spawn. Is he there every run in Forever?
			},
			{ npc = 9017, encounter = 232, name = "Lord Incendius",
				names = { deDE = "Lord Incendius", frFR = "Seigneur Incendius", esES = "Lord Incendius", esMX = "Lord Incendius", ptBR = "Lorde Incendius", ruRU = "Лорд Опалитель" },
				does = { "FDG_BRD_6_D1", "FDG_BRD_6_D2", "FDG_BRD_6_D3" },
				tip = "FDG_BRD_6_T",
				-- src: Black Anvil + platform 2x WH+CQ (WTC ook); quests 2x WH+FDJ (CQ ook); knockback + niet terug 2x WH+CQ (IVC, WTC ook); vloek 2x IVC+WTC (Classic; WH-lijst noemt de vloek); weg van de rand 2x WH+CQ (WTC: midden); decurse 2x IVC+WTC (Classic)
			},
			{ npc = 9041, extraNpc = 9042, encounter = 233, name = "Warder Stilgiss",
				names = { deDE = "Wärter Stilgiss", frFR = "Gardien Stilgiss", esES = "Guarda Stilgiss", esMX = "Depositario Stilgiss", ptBR = "Carcereiro Stilgiss", ruRU = "Тюремщик Стилгисс" },
				does = { "FDG_BRD_7_D1", "FDG_BRD_7_D2" },
				tip = "FDG_BRD_7_T",
				-- src: Black Vault + Verek 2x WH+CQ (IVC, WTC ook); vorst + bevriezen 2x WH(lijst)+IVC(Classic) (WTC ook); volgorde 2x WH+CQ (WTC ook); onderbreken 2x IVC+WTC (Classic; WH-lijst bevestigt de frostbolt) | MEASURE: Rare? WH (Forever, 4 Nov) heads him '(Rare Spawn)' and Wowhead Classic says 'Rare Elite', but Wowhead Forever says 'Elite' (GEMETEN 18 Nov). Is he there every run in Forever?
			},
			{ npc = 9476, encounter = 2791, name = "Watchman Doomgrip", optional = true,
				names = { deDE = "Wachmann Stahlgriff", frFR = "Sentinelle Doomgrip", esES = "Vigía Presaletal", ptBR = "Vigia Gadanho", ruRU = "Сторож Хватка Смерти" },
				does = { "FDG_BRD_8_D1", "FDG_BRD_8_D2", "FDG_BRD_8_D3" },
				tip = "FDG_BRD_8_T",
				-- src: twaalf kisten 2x WH+CQ (IVC, WTC ook); sleutels uit de dungeon 2x CQ+IVC(Classic) (CQ: van Dark Iron-dwergen; FDJ ook); stenen wachters + Doomgrip 2x WH+CQ (IVC, WTC ook; aantal verschilt: WTC drie of vier, daarom geen getal); Secret Safe + Heart 2x WH+CQ (IVC, WTC ook); tip AFGELEID uit 'meteen' 2x WH+CQ | DB2 encounter name: The Vault | MEASURE: Name: DB2 encounter 2791 = 'The Vault'; the fight there is Watchman Doomgrip with the stone guardians (WH, CQ). Does ENCOUNTER_START 2791 fire for this fight, and which name does the client show?
			},
			{ npc = 9056, encounter = 234, name = "Fineous Darkvire",
				names = { deDE = "Fineous Dunkelader", frFR = "Fineous Sombrevire", esES = "Finoso Virunegro", esMX = "Finoso Virunegro", ptBR = "Fineous Forçanegra", ruRU = "Точень Темнострой" },
				does = { "FDG_BRD_9_D1", "FDG_BRD_9_D2", "FDG_BRD_9_D3" },
				tip = "FDG_BRD_9_T",
				-- src: Hall of Crafting + golems 2x WH+CQ (WTC ook); paladin 2x CQ+IVC(Classic, vaardigheden; WH-lijst ook); hard slaan 2x WH+IVC (WTC ook); heal 2x WH+CQ (IVC, WTC ook); Ironfel + monument + sleutel 2x WH+CQ (FDJ ook); golems eerst 2x WH+CQ; onderbreken 2x WH+CQ (IVC, WTC ook)
			},
			{ npc = 9016, encounter = 235, name = "Bael'Gar",
				names = { deDE = "Bael'Gar", frFR = "Bael'Gar", esES = "Bael'Gar", esMX = "Bael'Gar", ptBR = "Bael'gar", ruRU = "Бейл'Гор" },
				does = { "FDG_BRD_10_D1", "FDG_BRD_10_D2", "FDG_BRD_10_D3" },
				tip = "FDG_BRD_10_T",
				-- src: plek 2x WH+CQ (WTC ook; WHT: Giant); magma vooraan 2x WH+CQ (IVC ook); spawns 2x WH+CQ (IVC ook); quest 2x WH+FDJ (CQ ook); tip 2x WH+CQ (IVC, WTC ook)
			},
			{ npc = 9033, encounter = 236, name = "General Angerforge",
				names = { deDE = "General Zornesschmied", frFR = "Général Forgehargne", esES = "General Forjira", esMX = "General Forjainquina", ptBR = "General Forjaversa", ruRU = "Генерал Кузня Гнева" },
				does = { "FDG_BRD_11_D1", "FDG_BRD_11_D2" },
				tip = "FDG_BRD_11_T",
				-- src: West Garrison 2x CQ+WTC (WH ook); hulp bij schade 2x CQ+WTC (WH: tijdens het gevecht); zwak 2x WH+IVC(Classic) (WTC ook); krijger + armor 2x WH+IVC (WTC ook); kamer leeg 2x WH+CQ; area 2x WH+CQ (WTC ook)
			},
			{ npc = 8983, encounter = 237, name = "Golem Lord Argelmach",
				names = { deDE = "Golemlord Argelmach", frFR = "Seigneur golem Argelmach", esES = "Señor gólem Argelmach", esMX = "Señor Gólem Argelmach", ptBR = "Lorde Golem Argelmach", ruRU = "Повелитель големов Аргелмах" },
				does = { "FDG_BRD_12_D1", "FDG_BRD_12_D2" },
				tip = "FDG_BRD_12_T",
				-- src: Manufactory + golems 2x CQ+WTC (IVC ook); bliksem springt 2x WH+CQ (IVC ook); schild 2x WH(lijst)+WTC(Classic) (IVC-lijst ook); spreiden 2x WH+CQ (IVC ook); golems eerst 2x IVC+WTC (Classic; CQ bevestigt dat ze meedoen)
			},
			{ npc = 9537, encounter = 238, name = "Hurley Blackbreath", optional = true,
				names = { deDE = "Hurley Pestatem", frFR = "Hurley Soufflenoir", esES = "Hurley Negrálito", esMX = "Hurley Negrálito", ptBR = "Hurley Bafonegro", ruRU = "Харли Пьянодых" },
				does = { "FDG_BRD_13_D1", "FDG_BRD_13_D2" },
				tip = "FDG_BRD_13_T",
				-- src: optioneel 2x WH+WTC(Classic); drie vaten + helpers 2x WH+CQ (IVC, WTC ook; aantal helpers verschilt: WH 3, WTC 4); recept + quests 2x WH+FDJ (CQ ook); CC helpers 2x WH+WTC; patrons 2x CQ+WH (WTC ook). IVC: eerst de helpers doden, WH/WTC: Hurley eerst; daarom geen volgorde
			},
			{ npc = 9502, encounter = 239, name = "Phalanx",
				names = { deDE = "Phalanx", frFR = "Phalange", esES = "Falange", esMX = "Falange", ptBR = "Falange", ruRU = "Фаланкс" },
				does = { "FDG_BRD_14_D1", "FDG_BRD_14_D2" },
				tip = "FDG_BRD_14_T",
				-- src: Rocknot + ale + deur 2x WH+CQ (WTC ook); hard + slam + vuurballen 2x WH(lijst)+IVC(Classic) (WTC ook); patrons 2x WH+CQ (WTC ook); healen na vuurballen 2x IVC+WTC (Classic)
			},
			{ npc = 9543, encounter = 240, name = "Ribbly Screwspigot", optional = true,
				names = { deDE = "Ribbly Schraubstutz", frFR = "Ribbly Fermevanne", esES = "Ribbly Llavenrosca", esMX = "Ribbly Llavenrosca", ptBR = "Ribas Parafuseta", ruRU = "Риббли Крутипроб" },
				does = { "FDG_BRD_15_D1", "FDG_BRD_15_D2" },
				tip = "FDG_BRD_15_T",
				-- src: optioneel + cronies 2x IVC+WTC (Classic; FDJ 'Ribbly's Crony'; WH: klein gevecht in de Grim Guzzler); quest 2x WH+CQ (FDJ ook); makkelijk 2x WH+IVC; patrons 2x CQ+WTC. Volgorde (IVC: cronies eerst, WTC: Ribbly eerst) weggelaten
			},
			{ npc = 9499, encounter = 241, name = "Plugger Spazzring", optional = true, one = true,
				names = { deDE = "Stöpsel Zapfring", frFR = "Lanfiche Brouillecircuit", esES = "Plugger Aropatoso", esMX = "Plugger Aropatoso", ptBR = "Birra Guardachave", ruRU = "Штоппор Наливалс" },
				does = { "FDG_BRD_16_D1", "FDG_BRD_16_D2" },
				tip = "FDG_BRD_16_T",
				-- src: barman + ale 2x WH+CQ (WTC ook); optioneel + hele bar 2x WH+WTC(Classic) (CQ ook); te veel mokken 1x WH; tip 2x WH+WTC
			},
			{ npc = 9156, encounter = 242, name = "Ambassador Flamelash",
				names = { deDE = "Botschafter Flammenschlag", frFR = "Ambassadeur Cinglefouet", esES = "Embajador Latifuego", esMX = "Embajador Latifuego", ptBR = "Embaixador Fogaçoite", ruRU = "Посол Огнехлыст" },
				does = { "FDG_BRD_17_D1", "FDG_BRD_17_D2" },
				tip = "FDG_BRD_17_T",
				-- src: plek 2x WH+WTC(Classic); geesten + sterker 2x WH+CQ (IVC, WTC ook); tip 2x WH+CQ (IVC, WTC ook)
			},
			{ npc = 9039, extraNpc = { 9035, 9038, 9040, 9037, 9036, 9034 }, encounter = 243, name = "The Seven",
				names = { deDE = "Die Sieben", frFR = "Les Sept", esES = "Los Siete", esMX = "Los siete", ptBR = "Os Sete", ruRU = "Семеро" },
				does = { "FDG_BRD_18_D1", "FDG_BRD_18_D2", "FDG_BRD_18_D3" },
				tip = "FDG_BRD_18_T",
				-- src: Doom'rel + zeven na elkaar 2x WH+CQ (IVC, WTC ook); klasse 2x WH+WTC(Classic); timer 2x WH+IVC(Classic) (WTC ook); kist 2x WH+FDJ (IVC, WTC ook); tip 2x WH+IVC (WTC ook) | MEASURE: No name plate: names = DB2 encounter 243 'The Seven'; npc 9039 (Doom'rel) is only one of seven. Does the guide show the group name? (generator: put 9039 in KEEP_GROUP if DG_PLATES is used)
			},
			{ npc = 9938, encounter = 244, name = "Magmus",
				names = { deDE = "Magmus", frFR = "Magmus", esES = "Magmus", esMX = "Magmus", ptBR = "Magmus", ruRU = "Магмус" },
				does = { "FDG_BRD_19_D1", "FDG_BRD_19_D2", "FDG_BRD_19_D3" },
				tip = "FDG_BRD_19_T",
				-- src: fakkels + twee bekkens 2x WH+WTC(Classic) (IVC ook); vuur in de hal 2x WH+CQ (IVC, WTC ook); stun 2x WH(lijst)+IVC (WTC ook); deur 2x CQ+WTC; tip 2x WH+CQ (IVC, WTC ook)
			},
			{ npc = 8929, encounter = 2789, name = "Princess Moira Bronzebeard", optional = true,
				names = { deDE = "Prinzessin Moira Bronzebeard", frFR = "Princesse Moira Bronzebeard", esES = "Princesa Moira Barbabronce", esMX = "Princesa Moira Barbabronce", ptBR = "Princesa Moira Barbabronze", ruRU = "Принцесса Мойра Бронзобород" },
				does = { "FDG_BRD_20_D1", "FDG_BRD_20_D2" },
				tip = "FDG_BRD_20_T",
				-- src: optioneel 2x WH+WTC(Classic); healt hem 2x WH+CQ (IVC, WTC ook); spells 2x WH(lijst)+IVC(Classic); quests + vriendelijk 2x WH+CQ (WTC ook); tip 2x WH+CQ (WTC ook)
			},
			{ npc = 9019, encounter = 2790, name = "Emperor Dagran Thaurissan",
				names = { deDE = "Imperator Dagran Thaurissan", frFR = "Empereur Dagran Thaurissan", esES = "Emperador Dagran Thaurissan", esMX = "Emperador Dagran Thaurissan", ptBR = "Imperador Dagran Thaurissan", ruRU = "Император Дагран Тауриссан" },
				does = { "FDG_BRD_21_D1", "FDG_BRD_21_D2" },
				tip = "FDG_BRD_21_T",
				-- src: laatste baas + Moira 2x WH+CQ (WTC ook); vuur + stun + extra slagen 2x WH(lijst)+IVC(Classic); tank healen 2x IVC+WTC (Classic); afspreken 2x WH+WTC (CQ: twee manieren). 'Hij roept alles in zijn kamer': alleen IVC, weggelaten
			},
		},
		loot = {
			{ item = 11815, boss = 9019, role = "FDG_BRD_L1" }, -- src: WHT Dropped by + FC(Classic-lijst) + CQ + WH (IVC ook)
			{ item = 11750, boss = 9024, role = "FDG_BRD_L2" }, -- src: WHT Dropped by + FC(Classic-lijst) + CQ + WH (IVC ook)
			{ item = 11821, boss = 9033, role = "FDG_BRD_L3" }, -- src: WHT Dropped by + FC(Classic-lijst) + CQ + WH (IVC ook)
		},
	},
	[429] = { -- DIRE
		bosses = {
			{ npc = 14354, encounter = 2792, name = "Pusillin", part = "FDGP_EAST",
				names = { deDE = "Pusillin", frFR = "Pusillin", esES = "Pusillín", esMX = "Pusillín", ptBR = "Pusillin", ruRU = "Пузиллин" },
				does = { "FDG_DIRE_1_D1", "FDG_DIRE_1_D2", "FDG_DIRE_1_D3" },
				tip = "FDG_DIRE_1_T",
				-- src: achtervolgen 2x WH+CQ (WTC, IVC ook); vier imps 2x WH+WTC (IVC ook; CQ: 'a few imps'); vuur 2x WH+CQ (WTC ook); sleutel 2x WH+CQ (WTC, IVC ook); tip imps 2x WH+CQ (IVC ook), onderbreken 2x CQ+WTC (WH, IVC ook)
			},
			{ npc = 14327, extraNpc = 14349, encounter = 345, name = "Lethtendris", part = "FDGP_EAST",
				names = { deDE = "Lethtendris", frFR = "Lethtendris", esES = "Lethtendris", esMX = "Lethtendris", ptBR = "Letendris", ruRU = "Лефтендрис" },
				does = { "FDG_DIRE_2_D1", "FDG_DIRE_2_D2" },
				tip = "FDG_DIRE_2_T",
				-- src: imp 2x WH+CQ (WTC, IVC ook); spells 2x WH+WTC (IVC ook); imp eerst 2x WH+CQ (WTC ook; IVC: CC of eerst doden); onderbreken 2x WH+CQ (WTC ook); decursen 2x WH+CQ (WTC, IVC ook)
			},
			{ npc = 13280, encounter = 344, name = "Hydrospawn", part = "FDGP_EAST",
				names = { deDE = "Hydrobrut", frFR = "Hydrogénos", esES = "Hidromilecio", esMX = "Hidromilecio", ptBR = "Rebentágua", ruRU = "Гидротварь" },
				does = { "FDG_DIRE_3_D1", "FDG_DIRE_3_D2" },
				tip = "FDG_DIRE_3_T",
				-- src: vijver 2x WH+WTC (IVC ook); kleine elementalen 2x WH+CQ (WTC, IVC ook); meer schade dan hij 2x WH+WTC; tip 2x WH+CQ (WTC, IVC ook)
			},
			{ npc = 11490, encounter = 343, name = "Zevrim Thornhoof", part = "FDGP_EAST",
				names = { deDE = "Zevrim Dornhuf", frFR = "Zevrim Sabot-de-Ronce", esES = "Zevrim Pezuñahendida", esMX = "Zevrim Pezuñahendida", ptBR = "Zevrim Cascardo", ruRU = "Зеврим Терновое Копыто" },
				does = { "FDG_DIRE_4_D1", "FDG_DIRE_4_D2" },
				tip = "FDG_DIRE_4_T",
				-- src: altaar 2x WH+CQ (WTC, IVC ook); schade dichtbij 2x WH+IVC (WTC, CQ ook); tip heal 2x WH+CQ (WTC, IVC ook), afstand 2x WH+IVC (CQ, WTC ook)
			},
			{ npc = 11492, encounter = 346, name = "Alzzin the Wildshaper", part = "FDGP_EAST",
				names = { deDE = "Alzzin der Wildformer", frFR = "Alzzin le Modeleur", esES = "Alzzin el Formaferal", esMX = "Alzzin el Formaferal", ptBR = "Azzin, o Selvamorfo", ruRU = "Алззин Перевертень" },
				does = { "FDG_DIRE_5_D1", "FDG_DIRE_5_D2", "FDG_DIRE_5_D3" },
				tip = "FDG_DIRE_5_T",
				-- src: Ironbark 2x WH+WTC (CQ, IVC ook); vormen 2x WH+WTC (IVC ook); threat na wissel 2x WH+WTC (CQ ook); adds bij weinig leven 2x WH+WTC (IVC, CQ ook; WH en WTC: 35%); tip 2x WH+WTC (CQ ook)
			},
			{ npc = 14326, encounter = 362, name = "Guard Mol'dar", part = "FDGP_NORTH",
				names = { deDE = "Wache Mol'dar", frFR = "Garde Mol'dar", esES = "Guardia Mol'dar", esMX = "Guardia Mol'dar", ptBR = "Guarda Mol'dar", ruRU = "Стражник Мол'дар" },
				does = { "FDG_DIRE_6_D1", "FDG_DIRE_6_D2", "FDG_DIRE_6_D3" },
				tip = "FDG_DIRE_6_T",
				-- src: plek 2x WH+WTC (FDJ ook); knockback + charge 2x WH+CQ (WTC ook); sleutel binnendeur 2x WH+WTC; tribute 2x WH+WTC (CQ ook); tribute + binnendeur 2x WH+WTC (via wowforeverguides); tip 2x WH+WTC
			},
			{ npc = 14322, encounter = 363, name = "Stomper Kreeg", part = "FDGP_NORTH",
				names = { deDE = "Stampfer Kreeg", frFR = "Kreeg le Marteleur", esES = "Vapuleador Kreeg", esMX = "Vapuleador Kreeg", ptBR = "Pisoteador Kreeg", ruRU = "Топотун Криг" },
				does = { "FDG_DIRE_7_D1", "FDG_DIRE_7_D2", "FDG_DIRE_7_D3" },
				tip = "FDG_DIRE_7_T",
				-- src: booze 2x WH+WTC (CQ ook); spin + stomp 2x WH+WTC; slapen 2x WH+WTC; tip 2x WH+WTC
			},
			{ npc = 14321, encounter = 364, name = "Guard Fengus", part = "FDGP_NORTH",
				names = { deDE = "Wache Fengus", frFR = "Garde Fengus", esES = "Guardia Fengus", esMX = "Guardia Fengus", ptBR = "Guarda Fengus", ruRU = "Стражник Фенгус" },
				does = { "FDG_DIRE_8_D1", "FDG_DIRE_8_D2", "FDG_DIRE_8_D3" },
				tip = "FDG_DIRE_8_T",
				-- src: rondlopen 2x WH+WTC; zelfde vaardigheden 2x WH+WTC (CQ ook); kist + sleutel 2x WH+WTC; tribute 2x WH+WTC; tip 2x WH+WTC
			},
			{ npc = 14323, encounter = 365, name = "Guard Slip'kik", part = "FDGP_NORTH",
				names = { deDE = "Wache Slip'kik", frFR = "Garde Slip'kik", esES = "Guardia Slip'kik", esMX = "Guardia Slip'kik", ptBR = "Guarda Kishutt", ruRU = "Стражник Слип'кик" },
				does = { "FDG_DIRE_9_D1", "FDG_DIRE_9_D2" },
				tip = "FDG_DIRE_9_T",
				-- src: plek 2x WTC+WH; zelfde vaardigheden 2x WH+WTC (CQ ook); val 2x WH+WTC (CQ ook); tip 2x WH+WTC
			},
			{ npc = 14325, encounter = 366, name = "Captain Kromcrush", part = "FDGP_NORTH",
				names = { deDE = "Hauptmann Krombruch", frFR = "Capitaine Kromcrush", esES = "Capitán Kromcrush", esMX = "Capitán Kromcrush", ptBR = "Capitão Kebrapaw", ruRU = "Капитан Давигром" },
				does = { "FDG_DIRE_10_D1", "FDG_DIRE_10_D2", "FDG_DIRE_10_D3" },
				tip = "FDG_DIRE_10_T",
				-- src: hard + fear 2x WH+CQ (WTC ook); twee ogres 2x WH+CQ (WTC ook); pak 2x WH+WTC (CQ ook); tip 2x WH+WTC
			},
			{ npc = 14324, encounter = 367, name = "Cho'Rush the Observer", part = "FDGP_NORTH",
				names = { deDE = "Cho'Rush der Beobachter", frFR = "Cho'Rush l'Observateur", esES = "Cho'Rush el Observador", esMX = "Cho'Rush el Observador", ptBR = "Ez'Magg, o Observador", ruRU = "Чо'Раш Наблюдатель" },
				does = { "FDG_DIRE_11_D1", "FDG_DIRE_11_D2" },
				tip = "FDG_DIRE_11_T",
				-- src: zelfde gevecht 2x WH+CQ (WTC ook); spells 2x WH+WTC; levend houden 2x WH+CQ (WTC ook); stopt 2x WH+WTC; tip 2x WH+CQ (WTC ook) | MEASURE: DB2 has two rows for this one fight: 367 Cho'Rush the Observer and 368 King Gordok. Which ENCOUNTER_START id(s) fire, and does 367 fire at all on a tribute run?
			},
			{ npc = 11501, encounter = 368, name = "King Gordok", part = "FDGP_NORTH",
				names = { deDE = "König Gordok", frFR = "Roi Gordok", esES = "Rey Gordok", esMX = "Rey Gordok", ptBR = "Rei Gordok", ruRU = "Король Гордок" },
				does = { "FDG_DIRE_12_D1", "FDG_DIRE_12_D2", "FDG_DIRE_12_D3" },
				tip = "FDG_DIRE_12_T",
				-- src: samen 2x WH+CQ (WTC ook); charge 2x WH+WMC; stomp 2x WH+WTC; tribute + buffs + kist 2x WH+CQ (WTC ook); praten met Mizzle 2x WH+CQ, buff per wachter WH (controle 2b DE R1); meer wachters = betere kist 2x WH+CQ (WTC ook); tip 2x WH+WTC (CQ ook)
			},
			{ npc = 11489, encounter = 350, name = "Tendris Warpwood", part = "FDGP_WEST",
				names = { deDE = "Tendris Wucherborke", frFR = "Tendris Crochebois", esES = "Tendris Madeguerra", esMX = "Tendris Alabeo", ptBR = "Gavíneo Lenhatorta", ruRU = "Тендрис Криводрев" },
				does = { "FDG_DIRE_13_D1", "FDG_DIRE_13_D2" },
				tip = "FDG_DIRE_13_T",
				-- src: ancients 2x WH+WTC; trample 2x WH+CQ (WTC ook); tip ancients 2x WH+WTC, afstand 2x WH+WTC (CQ: zo weinig mogelijk melee)
			},
			{ npc = 11488, extraNpc = 14308, encounter = 347, name = "Illyanna Ravenoak", part = "FDGP_WEST",
				names = { deDE = "Illyanna Rabeneiche", frFR = "Illyanna Corvichêne", esES = "Illyanna Roblecuervo", esMX = "Illyanna Roblecuervo", ptBR = "Illyanna Corvalho", ruRU = "Иллиана Воронья Ольха" },
				does = { "FDG_DIRE_14_D1", "FDG_DIRE_14_D2" },
				tip = "FDG_DIRE_14_T",
				-- src: beer 2x WH+CQ (WTC ook); schieten + vallen 2x WH+WTC; dichtbij 2x WH+CQ (WTC ook); tip dichtbij 2x WH+WTC, eerst Illyanna 2x WH+WTC
			},
			{ npc = 11487, encounter = 348, name = "Magister Kalendris", part = "FDGP_WEST",
				names = { deDE = "Magister Kalendris", frFR = "Magistère Kalendris", esES = "Magíster Kalendris", esMX = "Magister Kalendris", ptBR = "Magíster Kalendris", ruRU = "Магистр Календрис" },
				does = { "FDG_DIRE_15_D1" },
				tip = "FDG_DIRE_15_T",
				-- src: shadow priest 2x WH+CQ (WTC ook); geest overnemen 2x WH+WTC; onderbreken 2x WH+CQ (WTC ook); schaduwweerstand 2x WH+CQ (WTC ook)
			},
			{ npc = 11467, encounter = 2794, name = "Tsu'zee", part = "FDGP_WEST", rare = true,
				names = { deDE = "Tsu'zee", frFR = "Tsu'zee", esES = "Tsu'zee", esMX = "Tsu'zee", ptBR = "Tsu'zee", ruRU = "Цу'зи" },
				does = { "FDG_DIRE_16_D1", "FDG_DIRE_16_D2" },
				tip = "FDG_DIRE_16_T",
				-- src: rare 2x WTC+CQ (WH 'silver elite', FDJ ook); plek 2x WTC+WH; rogue 2x WH+CQ (WTC ook); blind + stun 2x WH+WTC; tip 2x WH+WTC | MEASURE: Rare in Forever? WTC, CQ, WH and FDJ say rare, but WHT says 'Elite', not 'Rare Elite', and she has a DB2 row (2794). Is she there every run?
			},
			{ npc = 11496, encounter = 349, name = "Immol'thar", part = "FDGP_WEST",
				names = { deDE = "Immol'thar", frFR = "Immol'thar", esES = "Immol'thar", esMX = "Immol'thar", ptBR = "Immol'thar", ruRU = "Бессмер'тер" },
				does = { "FDG_DIRE_17_D1", "FDG_DIRE_17_D2", "FDG_DIRE_17_D3" },
				tip = "FDG_DIRE_17_T",
				-- src: vijf pylonen 2x WH+CQ (WTC ook); ogen 2x WH+CQ (WTC ook); teleport + threat 2x WH+WTC; enrage op de helft 2x WH+WTC; tip ogen 2x WH+CQ (WTC ook), cooldowns 2x WH+WTC
			},
			{ npc = 11486, encounter = 361, name = "Prince Tortheldrin", part = "FDGP_WEST",
				names = { deDE = "Prinz Tortheldrin", frFR = "Prince Tortheldrin", esES = "Príncipe Tortheldrin", esMX = "Príncipe Tortheldrin", ptBR = "Príncipe Tortheldrin", ruRU = "Принц Тортелдрин" },
				does = { "FDG_DIRE_18_D1", "FDG_DIRE_18_D2" },
				tip = "FDG_DIRE_18_T",
				-- src: plek 2x WH+WTC (CQ ook); spin 2x WH+WTC; knockback + threat 2x WH+CQ (WTC ook); tip 2x WH+CQ (WTC ook)
			},
		},
		loot = {
			{ item = 18321, boss = 11492, role = "FDG_DIRE_L1", part = "FDGP_EAST" }, -- src: WHT Dropped by + FC + CQ
			{ item = 18310, boss = 11492, role = "FDG_DIRE_L2", part = "FDGP_EAST" }, -- src: WHT Dropped by + FC + CQ
			{ item = 18311, boss = 14327, role = "FDG_DIRE_L3", part = "FDGP_EAST" }, -- src: WHT Dropped by + FC + CQ
			{ item = 18503, boss = 14325, role = "FDG_DIRE_L4", part = "FDGP_NORTH" }, -- src: WHT Dropped by + FC + CQ
			{ item = 18526, boss = 11501, role = "FDG_DIRE_L5", part = "FDGP_NORTH" }, -- src: WHT Dropped by + FC + CQ
			{ item = 18524, boss = 11501, role = "FDG_DIRE_L6", part = "FDGP_NORTH" }, -- src: WHT Dropped by + FC + CQ
			{ item = 18396, boss = 11486, role = "FDG_DIRE_L7", part = "FDGP_WEST" }, -- src: WHT Dropped by + FC + CQ + WH
			{ item = 18383, boss = 11488, role = "FDG_DIRE_L8", part = "FDGP_WEST" }, -- src: WHT Dropped by + FC + CQ + WH
			{ item = 18391, boss = 11496, role = "FDG_DIRE_L9", part = "FDGP_WEST" }, -- src: WHT Dropped by + FC + CQ + WH
		},
	},
	[229] = { -- BRS
		bosses = {
			{ npc = 9196, encounter = 267, name = "Highlord Omokk", part = "FDGP_LOWER",
				names = { deDE = "Hochlord Omokk", frFR = "Généralissime Omokk", esES = "Alto Señor Omokk", esMX = "Alto señor Omokk", ptBR = "Grão-lorde Omokk", ruRU = "Вождь Омокк" },
				does = { "FDG_BRS_1_D1", "FDG_BRS_1_D2", "FDG_BRS_1_D3" },
				tip = "FDG_BRS_1_T",
				-- src: twee ogres 2x WH+WTC (IVC ook); knockback 2x WH+CQ (WTC, IVC ook); enrage 2x WH+WTC; edelsteen 2x WH+CQ (FDJ ook); tip CC 2x WH+WTC (IVC ook), muur 2x WH+CQ (WTC ook)
			},
			{ npc = 9236, encounter = 268, name = "Shadow Hunter Vosh'gajin", part = "FDGP_LOWER",
				names = { deDE = "Schattenjägerin Vosh'gajin", frFR = "Chasseresse des ombres Vosh'gajin", esES = "Cazador de las Sombras Vosh'gajin", esMX = "Cazadora de las Sombras Vosh'gajin", ptBR = "Caçadora Sombria Vosh'gajin", ruRU = "Темная охотница Вос'гаджин" },
				does = { "FDG_BRS_2_D1", "FDG_BRS_2_D2" },
				tip = "FDG_BRS_2_T",
				-- src: priesters 2x WH+WTC (IVC ook); kikker 2x WH+IVC (WTC ook); vloek 2x WH+CQ (WTC, IVC ook); tip CC + eerst doden 2x WH+WTC (IVC ook), decursen 2x WH+CQ (WTC ook)
			},
			{ npc = 9237, encounter = 269, name = "War Master Voone", part = "FDGP_LOWER",
				names = { deDE = "Kriegsmeister Voone", frFR = "Maître de guerre Voone", esES = "Maestro de guerra Voone", esMX = "Maestro de guerra Voone", ptBR = "Senhor da Guerra Voone", ruRU = "Воевода Вун" },
				does = { "FDG_BRS_3_D1", "FDG_BRS_3_D2" },
				tip = "FDG_BRS_3_T",
				-- src: geen adds + hard 2x WH+WTC (IVC, CQ ook); edelsteen 2x WH+CQ (FDJ ook); trolls eerst 2x CQ+WH; threat 2x WH+WTC (IVC ook). Welke aanvallen hij heeft verschilt (WH: Cleave; CQ: Throw Axe, Mortal Strike): niet in de tekst
			},
			{ npc = 9596, name = "Bannok Grimaxe", part = "FDGP_LOWER", rare = true,
				names = { deDE = "Bannok Grimmaxt", frFR = "Bannok Grimaxe", esES = "Bannok Hachamacabra", esMX = "Bannok Hacha Macabra", ptBR = "Bannok Sinistracha", ruRU = "Баннок Люторез" },
				does = { "FDG_BRS_4_D1", "FDG_BRS_4_D2" },
				tip = "FDG_BRS_4_T",
				-- src: rare 2x WH+WTC (CQ, FC, FDJ, WHT ook); plek 2x WH+WTC (CQ: Hordemar City, FDJ: bij het Storehouse, IVC: Firebrand-kamp; zie notes); plan 2x WH+CQ (WTC, IVC ook); tip 2x WH+WTC
			},
			{ npc = 10596, encounter = 270, name = "Mother Smolderweb", part = "FDGP_LOWER",
				names = { deDE = "Mutter Glimmernetz", frFR = "Matriarche Couveuse", esES = "Madre Telabrasada", esMX = "Madre Telabrasada", ptBR = "Mãe Queimateia", ruRU = "Мать Дымная Паутина" },
				does = { "FDG_BRS_5_D1", "FDG_BRS_5_D2" },
				tip = "FDG_BRS_5_T",
				-- src: kegel 2x WH+WTC (CQ, IVC ook); gif 2x WH+WTC (CQ, IVC ook); tip 2x WH+WTC (IVC ook)
			},
			{ npc = 10584, encounter = 271, name = "Urok Doomhowl", part = "FDGP_LOWER", optional = true,
				names = { deDE = "Urok Schreckensbote", frFR = "Urok Hurleruine", esES = "Urok Aullapocalipsis", esMX = "Urok Aullasino", ptBR = "Urok Uivo-da-ruína", ruRU = "Аррок Смертный Вопль" },
				does = { "FDG_BRS_6_D1", "FDG_BRS_6_D2" },
				tip = "FDG_BRS_6_T",
				-- src: kop + piek 2x WH+CQ (WTC, IVC ook; Roughshod Pike oppakken en samenvoegen: WH, controle 2b DE R4); Warosh 2x CQ+WTC (WH ook); golven 2x WH+CQ (WTC, IVC ook); fear 2x WH+WTC (IVC ook); tip piek 2x WH+WTC (CQ, IVC ook), CC 2x WH+WTC (IVC ook)
			},
			{ npc = 9736, encounter = 272, name = "Quartermaster Zigris", part = "FDGP_LOWER", one = true,
				names = { deDE = "Rüstmeister Zigris", frFR = "Intendant Zigris", esES = "Intendente Zigris", esMX = "Intendente Zigris", ptBR = "Intendente Zigris", ruRU = "Интендант Зигрис" },
				does = { "FDG_BRS_7_D1", "FDG_BRS_7_D2" },
				tip = "FDG_BRS_7_T",
				-- src: storehouse 2x CQ+FDJ; rondlopen 1x WH (controle 2b DE R10); bom 2x CQ+WTC (IVC ook); drankje 2x CQ+IVC; tip 2x WH+CQ (IVC ook). CQ zegt in melee blijven, WTC zegt uit elkaar staan: niet in de tekst
			},
			{ npc = 10220, encounter = 274, name = "Halycon", part = "FDGP_LOWER",
				names = { deDE = "Halycon", frFR = "Halycon", esES = "Halycon", esMX = "Halycon", ptBR = "Halycon", ruRU = "Халикон" },
				does = { "FDG_BRS_8_D1", "FDG_BRS_8_D2" },
				tip = "FDG_BRS_8_T",
				-- src: pups 2x WH+WTC (IVC ook); Gizrul 2x WH+CQ (WTC, FDJ ook); pups eerst 2x WH+WTC (IVC ook); snel drinken 2x WH+WTC (CQ ook)
			},
			{ npc = 10268, encounter = 273, name = "Gizrul the Slavener", part = "FDGP_LOWER",
				names = { deDE = "Gizrul der Geifernde", frFR = "Gizrul l'esclavagiste", esES = "Gizrul el esclavista", esMX = "Gizrul el Esclavista", ptBR = "Gizrul, o Subjugador", ruRU = "Гизрул Поработитель" },
				does = { "FDG_BRS_9_D1", "FDG_BRS_9_D2" },
				tip = "FDG_BRS_9_T",
				-- src: na Halycon 2x WH+CQ (WTC ook); hard 2x WH+IVC (CQ, WTC ook); bijt over tijd 2x WH+WTC; enrage 2x WH+WTC (IVC ook); tip 2x CQ+WTC (WH ook)
			},
			{ npc = 9568, encounter = 275, name = "Overlord Wyrmthalak", part = "FDGP_LOWER",
				names = { deDE = "Oberanführer Wyrmthalak", frFR = "Seigneur Wyrmthalak", esES = "Señor supremo Vermiothalak", esMX = "Señor supremo Vermiothalak", ptBR = "Lorde Supremo Wyrmthalak", ruRU = "Властитель Змейталак" },
				does = { "FDG_BRS_10_D1", "FDG_BRS_10_D2", "FDG_BRS_10_D3" },
				tip = "FDG_BRS_10_T",
				-- src: voorkant + knockback 2x CQ+WTC (WH, IVC ook); twee wachters op de helft 2x WH+CQ (WTC, IVC ook); edelsteen 2x WH+CQ (FDJ ook); tip muur 2x CQ+WTC (WH, IVC ook), CC + hem eerst 2x WH+IVC (WTC ook)
			},
			{ npc = 9816, encounter = 3062, name = "Pyroguard Emberseer", part = "FDGP_UPPER",
				names = { deDE = "Feuerwache Glutseher", frFR = "Pyrogarde Prophète ardent", esES = "Piroguardián brasadivino", esMX = "Piroguardia Brasadivino", ptBR = "Piroguarda Mirabrasa", ruRU = "Пиростраж Созерцатель Углей" },
				does = { "FDG_BRS_11_D1", "FDG_BRS_11_D2", "FDG_BRS_11_D3" },
				tip = "FDG_BRS_11_T",
				-- src: deur + zegel 2x CQ+WTC (WH, WMC ook); questketen begint in Lower 2x WH+CQ; runen-hal + zijkamers 2x WH+CQ (aantal runen alleen WH: weggelaten); altaar + cipiers 2x WH+CQ (WTC, FDJ ook); vuur rond hem 2x WH+WTC (CQ ook); tip area 2x WH+CQ (WTC ook), afstand 2x WH+WTC (CQ ook)
			},
			{ npc = 10264, name = "Solakar Flamewreath", part = "FDGP_UPPER", optional = true,
				names = { deDE = "Solakar Feuerkrone", frFR = "Solakar Voluteflamme", esES = "Solakar Corona de Fuego", esMX = "Solakar Corona de Fuego", ptBR = "Solakar Chamarco", ruRU = "Солакарский огнечервь" },
				does = { "FDG_BRS_12_D1", "FDG_BRS_12_D2", "FDG_BRS_12_D3" },
				tip = "FDG_BRS_12_T",
				-- src: optioneel 2x WH+WTC (CQ: event); Father Flame + golven 2x WH+CQ (WTC ook); hatchers + eieren 2x WH+CQ; stomp 2x WH+WTC (CQ ook); tip muur 2x WH+CQ, hatchers 2x WH+CQ, afstand 2x WH+WTC
			},
			{ npc = 10899, name = "Goraluk Anvilcrack", part = "FDGP_UPPER", optional = true,
				names = { deDE = "Goraluk Hammerbruch", frFR = "Goraluk Anvilcrack", esES = "Goraluk Yunquegrieta", esMX = "Goraluk Yunquegrieta", ptBR = "Goraluk Rachadastra", ruRU = "Горалук Треснувшая Наковальня" },
				does = { "FDG_BRS_13_D1", "FDG_BRS_13_D2", "FDG_BRS_13_D3" },
				tip = "FDG_BRS_13_T",
				-- src: optioneel 2x CQ+WTC (WH ook); melee 2x WH+WTC (CQ ook); piek 2x CQ+WH (FDJ ook); tip 2x WH+WTC
			},
			{ npc = 10509, name = "Jed Runewatcher", part = "FDGP_UPPER", rare = true,
				names = { deDE = "Jed Runenblick", frFR = "Jed Runewatcher", esES = "Jed Observarrunas", esMX = "Jed Vigía de las Runas", ptBR = "Jed Mirarruna", ruRU = "Джед Руновед" },
				does = { "FDG_BRS_14_D1", "FDG_BRS_14_D2" },
				tip = "FDG_BRS_14_T",
				-- src: rare 2x CQ+WTC (WH, FC, FDJ, WHT ook); plek 2x WH+WTC (CQ ook); alleen kijken 2x CQ+WTC (WH ook); tip 2x CQ+WH (WTC ook)
			},
			{ npc = 10429, extraNpc = 10339, encounter = 3063, name = "Warchief Rend Blackhand", part = "FDGP_UPPER",
				names = { deDE = "Kriegshäuptling Rend Blackhand", frFR = "Chef de guerre Rend Blackhand", esES = "Jefe de Guerra Desgarro Puño Negro", esMX = "Jefe de Guerra Rend Puño Negro", ptBR = "Chefe Guerreiro Laceral Mão Negra", ruRU = "Вождь Ренд Чернорук" },
				does = { "FDG_BRS_15_D1", "FDG_BRS_15_D2", "FDG_BRS_15_D3" },
				tip = "FDG_BRS_15_T",
				-- src: golven 2x WH+CQ (WH: zeven tot acht, CQ: ongeveer acht; WTC ook); Gyth adem 2x WH+CQ (WTC ook); Rend springt eraf 2x WH+CQ (WH, WTC: 20%, CQ: geen getal; daarom zonder getal); spin + cleave 2x WH+CQ (WTC ook); tip tweede tank 2x WH+CQ (WTC ook), Gyth eerst 2x WH+CQ (WTC ook), spin 2x CQ+WTC (WH ook)
			},
			{ npc = 10430, encounter = 3068, name = "The Beast", part = "FDGP_UPPER",
				names = { deDE = "Die Bestie", frFR = "La Bête", esES = "La Bestia", esMX = "La Bestia", ptBR = "A Fera", ruRU = "Зверь" },
				does = { "FDG_BRS_16_D1", "FDG_BRS_16_D2" },
				tip = "FDG_BRS_16_T",
				-- src: charge 2x WH+CQ (WTC ook); fear 2x WH+CQ (WTC ook); vuur + knockback 2x WH+CQ (WTC ook); tip muur 2x WH+CQ (WTC ook), spreiden 2x WH+CQ (WTC ook)
			},
			{ npc = 10363, encounter = 3069, name = "General Drakkisath", part = "FDGP_UPPER",
				names = { deDE = "General Drakkisath", frFR = "Général Drakkisath", esES = "General Drakkisath", esMX = "General Drakkisath", ptBR = "General Drakkisath", ruRU = "Генерал Драккисат" },
				does = { "FDG_BRS_17_D1", "FDG_BRS_17_D2", "FDG_BRS_17_D3" },
				tip = "FDG_BRS_17_T",
				-- src: twee wachters 2x WH+CQ (WTC ook); kegel vuur 2x CQ+WTC (WH ook: wegdraaien); paniek-vuur 2x WTC(C)+WMC(C), WH (Forever) noemt dezelfde spell; tip 2x WH+CQ (WTC ook)
			},
		},
		loot = {
			{ item = 13167, boss = 9196, role = "FDG_BRS_L1", part = "FDGP_LOWER" }, -- src: WHT Dropped by + FC + CQ + WH
			{ item = 12653, boss = 9236, role = "FDG_BRS_L2", part = "FDGP_LOWER" }, -- src: WHT Dropped by + FC + CQ + WH
			{ item = 16718, boss = 10268, role = "FDG_BRS_L3", part = "FDGP_LOWER" }, -- src: WHT Dropped by + FC + CQ + WH
			{ item = 12602, boss = 10363, role = "FDG_BRS_L4", part = "FDGP_UPPER" }, -- src: WHT Dropped by + FC + CQ + WH
			{ item = 12940, boss = 10429, role = "FDG_BRS_L5", part = "FDGP_UPPER" }, -- src: WHT Dropped by + FC + CQ + WH
			{ item = 12926, boss = 9816, role = "FDG_BRS_L6", part = "FDGP_UPPER" }, -- src: WHT Dropped by + FC + CQ + WH
		},
	},
	[2974] = { -- BMAW
		bosses = {
			{ npc = 247195, encounter = 3315, name = "Withermaw", recheck = true,
				names = { deDE = "Welkschlund", frFR = "Flétrigueule", esES = "Faucemarchita", esMX = "Faucemarchita", ptBR = "Putrigórjeo", ruRU = "Сухозев" },
				does = { "FDG_BMAW_1_D1", "FDG_BMAW_1_D2", "FDG_BMAW_1_D3" },
				tip = "FDG_BMAW_1_T",
				-- src: beer in grot 2x WT+MOBU (HBW/BLZ-video: 'rotting bear'); maden 2x WT+MOBU (MMN, DBS 1302780 ook); fear 2x WT+MOBU (MMN ook); tegen fear 2x WT+MOBU; maden oppakken/samen doden 2x WT+MMN. Weggelaten: ziektes (alleen WT), lava (CQ; HBW zegt 'larvae')
			},
			{ npc = 247206, encounter = 3316, name = "Impaan the Imprisoner", recheck = true,
				names = { deDE = "Impaan der Kerkermeister", frFR = "Diablaan l'Enfermeur", esES = "Diapaan el Diabólico", esMX = "Diablaan, el Carcelero diabólico", ptBR = "Diabraan, o Diabrisionador", ruRU = "Бесаан Бесноватый" },
				does = { "FDG_BMAW_2_D1", "FDG_BMAW_2_D2" },
				tip = "FDG_BMAW_2_T",
				-- src: demon 2x WHT+CQ (WT: satyr); heuvelpad 2x WT+MOBU; imps 2x WT+MOBU (MMN, DBS 1243318 ook); onderbreken 2x MOBU+MMN; imps snel doden 2x MOBU+MMN (WT ook)
			},
			{ npc = 247198, encounter = 3322, name = "Bonesnout the Unbroken", recheck = true,
				names = { deDE = "Knochenschnauze der Ungebrochene", frFR = "Muflos l'Indompté", esES = "Morrohueso el Inquebrantable", esMX = "Hocicóseo, el Irrompible", ptBR = "Focinhosso, o Inquebrável", ruRU = "Костерыл Несломленный" },
				does = { "FDG_BMAW_3_D1", "FDG_BMAW_3_D2", "FDG_BMAW_3_D3" },
				tip = "FDG_BMAW_3_T",
				-- src: ondode ever 2x WHT+CQ (WT: boar); rondlopen 2x WT+HBW (CQ ook); ritualisten + 25% 2x WT+MOBU (MMN, DBS 1277406 ook; 'satyr': DBS+MMN); stomp 2x WT+MOBU (MMN ook); ritualisten eerst 2x WT+MOBU (CQ, MMN ook); wegstappen 2x MOBU+MMN
			},
			{ npc = 247231, encounter = 3336, name = "Unbound Spirit", recheck = true,
				names = { deDE = "Ungebundener Geist", frFR = "Esprit délié", esES = "Espíritu desvinculado", esMX = "Espíritu desligado", ptBR = "Espírito Desatado", ruRU = "Свободный дух" },
				does = { "FDG_BMAW_4_D1", "FDG_BMAW_4_D2", "FDG_BMAW_4_D3" },
				tip = "FDG_BMAW_4_T",
				-- src: totems 2x WT+DBS 1247237 (MOBU: 'pillars'; WT: de geest is eerst helemaal onkwetsbaar, DBS geeft geen getal); praten + elder 2x WT+MOBU; adds 2x WT+MOBU; daarna makkelijk 2x WT+MOBU; tip 2x WT+MOBU | MEASURE: MMN (17 Nov) lists other moves: fire on the group, a fire nova and a phase in which it cannot be hurt; WT and MOBU describe only the totem fight. Which is right, or both?
			},
			{ npc = 247209, encounter = 3327, name = "Elder Shaman Bloodmane", recheck = true,
				names = { deDE = "Schamanenältester Bloodmane", frFR = "Ancien chaman crin-de-sang", esES = "Chamán anciano Melenasangre", esMX = "Anciano chamán Sangremelena", ptBR = "Xamã Ancião Jubassangue", ruRU = "Старейшина-шаман Кровогрив" },
				does = { "FDG_BMAW_5_D1", "FDG_BMAW_5_D2", "FDG_BMAW_5_D3" },
				tip = "FDG_BMAW_5_T",
				-- src: wolven 2x WT+MOBU (MMN ook); bliksem 2x WT+MMN; buff weghalen 2x WT+MMN (WT noemt alleen de spellnaam, het effect is AFGELEID; MMN: plus 3 s stun); onderbreken 2x WT+MMN. Wolven doden of baas eerst: MOBU en MMN zeggen het tegengestelde, daarom niet in de tip
			},
			{ npc = 247207, encounter = 3323, name = "Blackmaw Behemoth", recheck = true,
				names = { deDE = "Behemoth des Schwarzschlunds", frFR = "Béhémoth noiregueule", esES = "Behemoth Faucenegra", esMX = "Behemoth Faucenegra", ptBR = "Beemote Bocanera", ruRU = "Исполин из клана Черночревов" },
				does = { "FDG_BMAW_6_D1", "FDG_BMAW_6_D2", "FDG_BMAW_6_D3" },
				tip = "FDG_BMAW_6_T",
				-- src: furbolg heelt 2x WT+MOBU; brul 2x WT+MOBU; draaien 2x WT+MOBU; vol leven + harder 2x WT+MOBU (DBS 1244493: 100% heal, 'Enraged'); stun-brul na de furbolg 2x WT+MOBU (WT: stunt iedereen in een groot gebied; MOBU: brul sterker bij enrage; controle 2b FG R12); furbolg eerst 2x WT+MOBU; brul onderbreken 2x WT+MOBU-video. De furbolg heet Clawbert (WT, MOBU, DBS); naam niet in de tekst: geen npc-id, dus geen clientnaam per taal | MEASURE: Clawbert (WT, MOBU, spell text 1244493) has no npc id here: not found at Wowhead, FDJ or the databases searched. Is he a second creature of this encounter, and what is his name in each client?
			},
			{ npc = 247234, encounter = 3334, name = "Varrox Bleakhoof", recheck = true,
				names = { deDE = "Varrox Bleakhoof", frFR = "Varrox Mornesabot", esES = "Varrox Pezuña Lúgubre", esMX = "Varrox Pezuñaumbría", ptBR = "Varrox Execrasco", ruRU = "Варрокс Мутное Копыто" },
				does = { "FDG_BMAW_7_D1", "FDG_BMAW_7_D2", "FDG_BMAW_7_D3" },
				tip = "FDG_BMAW_7_T",
				-- src: laatste baas 2x WT+MOBU (FDJ, CQ ook: zijn kill telt voor Master Spelunker); na Behemoth 2x WT+MOBU; trekken 2x WT+MOBU (DBS 1246453/1246456); ontploffen + poel 2x WT+MOBU (MMN, DBS 1246362 ook); volley + fear 2x MOBU+MMN; tip 2x MOBU+MMN. Onderbreken van volley/fear: alleen MOBU, weggelaten
			},
			{ npc = 269104, name = "Moontouched Wanderer", rare = true, one = true, recheck = true,
				names = { deDE = "Mondbestrahlter Wanderer", frFR = "Vagabond frôlelune", esES = "Errante Lunadón", esMX = "Errante Lunadón", ptBR = "Andarilho Lunamarca", ruRU = "Осененный луной странник" },
				does = { "FDG_BMAW_8_D1" },
				tip = "FDG_BMAW_8_T",
				-- src: rare 2x WT+CQ (WHT 'Rare Elite', FDJ ook); tip 1x WT. Plek (hoek van de thicket): alleen WT, weggelaten
			},
			{ npc = 269111, name = "Gortek the Apprentice", rare = true, one = true, recheck = true,
				names = { deDE = "Gortek der Lehrling", frFR = "Gortek l'apprenti", esES = "Gortek el Aprendiz", esMX = "Gortek, el aprendiz", ptBR = "Gortek, o Aprendiz", ruRU = "Ученик Гортек" },
				does = { "FDG_BMAW_9_D1" },
				tip = "FDG_BMAW_9_T",
				-- src: rare 2x WT+MMN (WHT 'Rare Elite', FDJ ook); tip 1x WT. Plek (bij de helling voor de Behemoth): alleen WT, weggelaten
			},
			{ npc = 250034, name = "Tunnelweb Matriarch", rare = true, one = true, recheck = true,
				names = { deDE = "Tunnelnetzmatriarchin", frFR = "Matriarche tissetunnel", esES = "Matriarca cavatelas", esMX = "Matriarca tunelaraña", ptBR = "Matriarca Teiatúnel", ruRU = "Паутинный матриарх" },
				does = { "FDG_BMAW_10_D1" },
				tip = "FDG_BMAW_10_T",
				-- src: rare 2x WT+MMN (WHT 'Rare Elite'); spin 2x WHT+FDJ; tip 1x WT. Plek: geen bron
			},
		},
		loot = {
			{ item = 280063, boss = 247195, role = "FDG_BMAW_L1", recheck = true }, -- src: WHT Dropped by + MMN + REX (id: FDJ)
			{ item = 280057, boss = 247206, role = "FDG_BMAW_L2", recheck = true }, -- src: WHT Dropped by + MMN + WFA (id: FDJ)
			{ item = 280059, boss = 247198, role = "FDG_BMAW_L3", recheck = true }, -- src: WHT Dropped by + MMN + WFA + REX (id: FDJ)
		},
	},
	[3001] = { -- SHAPER
		bosses = {
			{ npc = 253201, encounter = 3498, name = "Titanosaur", one = true, recheck = true,
				names = { deDE = "Titanosaurus", frFR = "Titanosaure", esES = "Titanosaurio", esMX = "Titanosaurio", ptBR = "Titanossauro", ruRU = "Титанозавр" },
				does = { "FDG_SHAPER_1_D1", "FDG_SHAPER_1_D2" },
				tip = "FDG_SHAPER_1_T",
				-- src: dino + fear 2x WT+CQ; staart 1x CQ (UND volgt CQ); tegen fear 2x WT+CQ; packs eerst 1x WT
			},
			{ npc = 261811, extraNpc = 253218, encounter = 3499, name = "Tor'Rel & Izha'Rel", one = true, recheck = true,
				names = { deDE = "Tor'Rel & Izha'Rel", frFR = "Tor'Rel & Izha'Rel" },
				does = { "FDG_SHAPER_2_D1", "FDG_SHAPER_2_D2" },
				tip = "FDG_SHAPER_2_T",
				-- src: paar 2x WT+CQ (FDJ ook); niet elite 2x CQ+FDJ (WHT 'Normal' GEMETEN); extra raptors 1x WT; een tegelijk 2x WT+CQ; Tor'Rel eerst 1x WT (ijs-raptor remt melee); extra raptors oppakken 1x WT | DB2 encounter name: Ravasaur Hunters | MEASURE: Name: DB2 encounter 3499 = 'Ravasaur Hunters'; the two nameplates are Tor'Rel (261811) and Izha'Rel (253218). Which name does the client show for the fight, and what is Tor'Rel called in esES/esMX/ptBR/ruRU?
			},
			{ npc = 261812, encounter = 3500, name = "Thunderhoof", recheck = true,
				names = { deDE = "Thunderhoof", frFR = "Sabot-Tonnerre", esES = "Pezuña Trueno", esMX = "Cascotrueno", ptBR = "Casco do Trovão", ruRU = "Громокопыт" },
				does = { "FDG_SHAPER_3_D1" },
				tip = "FDG_SHAPER_3_T",
				-- src: bliksem + onderbreken 2x WT+CQ. Weggelaten: thunderclap (alleen CQ), nature resistance (alleen WT) | MEASURE: Name: esES DB2 'Pezuñatrueno' but WHT npc 'Pezuña Trueno'; esMX DB2 'Pezuña Trueno' but WHT npc 'Cascotrueno'. Which does the client show?
			},
			{ npc = 261813, encounter = 3501, name = "Venomridge", recheck = true,
				names = { deDE = "Giftkamm", frFR = "Crête-venin", esES = "Crestaveneno", esMX = "Cimaveneno", ptBR = "Peçonhalta", ruRU = "Ядогорб" },
				does = { "FDG_SHAPER_4_D1", "FDG_SHAPER_4_D2" },
				tip = "FDG_SHAPER_4_T",
				-- src: gif 2x WT+CQ; Alliance-quest 2x WT+CQ; tip 2x WT+CQ. Weggelaten: stomp (alleen CQ)
			},
			{ npc = 262127, encounter = 3507, name = "Direhorn Matriarch", recheck = true,
				names = { deDE = "Terrorhornmatriarchin", frFR = "Matriarche navrecorne", esES = "Matriarca cuernoatroz", esMX = "Matriarca cuernoatroz", ptBR = "Matriarca Escornante", ruRU = "Дикорог-матриарх" },
				does = { "FDG_SHAPER_5_D1", "FDG_SHAPER_5_D2" },
				tip = "FDG_SHAPER_5_T",
				-- src: staart 2x WT+CQ; charge 2x WT+CQ (WT: willekeurig, CQ: wie ver weg staat, daarom zonder doel); tip 2x WT+CQ. Weggelaten: bloeding op tank (alleen CQ), adds eerst (alleen WT)
			},
			{ npc = 261974, encounter = 3503, name = "Cinder", recheck = true,
				names = { deDE = "Zunder", frFR = "Braise", esES = "Cenizas", esMX = "Ceniza", ptBR = "Brasa", ruRU = "Пепел" },
				does = { "FDG_SHAPER_6_D1", "FDG_SHAPER_6_D2" },
				tip = "FDG_SHAPER_6_T",
				-- src: rood paneel + 15 2x WT+CQ (BLZ 9 nov: verschijnt na gebruik van het Archival Panel); vuur-raptor 2x CQ+WFA (WT: vuur); gebied vrij 2x WT+CQ; vuurweerstand 2x WT+CQ
			},
			{ npc = 261993, encounter = 3504, name = "King Op", rare = true, one = true, recheck = true,
				names = { deDE = "König Op", frFR = "Roi Op", esES = "Rey Op", esMX = "Rey Op", ptBR = "Rei Op", ruRU = "Король Оп" },
				does = { "FDG_SHAPER_7_D1" },
				tip = "FDG_SHAPER_7_T",
				-- src: rare 2x WFA+MMO (WHT 'Rare Elite', IVDB ook); gorilla 2x IVDB+MMO (WFA ook). WT en CQ noemen hem niet. Tip = eerlijke regel, 0 bronnen ('pull it on its own' weggehaald: geen bron)
			},
			{ npc = 262297, encounter = 3597, name = "Snowtalon", recheck = true,
				names = { deDE = "Schneekralle", frFR = "Serre-neigeuse", esES = "Garfanieve", esMX = "Garranieve", ptBR = "Garra-de-neve", ruRU = "Снежнокоготь" },
				does = { "FDG_SHAPER_8_D1", "FDG_SHAPER_8_D2" },
				tip = "FDG_SHAPER_8_T",
				-- src: blauw paneel + 15 + grot achter linker waterval 2x WT+CQ; vastvriezen + kou-kegel 2x WT+CQ; naar buiten 2x WT+CQ (WT: uit de grot trekken; CQ: weg van de grote blauwe kristallen, die stillen). Wegdraaien van de groep: alleen WT, weggelaten
			},
			{ npc = 262081, encounter = 3505, name = "Bolt", recheck = true,
				names = { deDE = "Bolt", frFR = "Fulguro", esES = "Rayo", esMX = "Rayo", ptBR = "Seta", ruRU = "Электр" },
				does = { "FDG_SHAPER_9_D1", "FDG_SHAPER_9_D2" },
				tip = "FDG_SHAPER_9_T",
				-- src: geel paneel + 15 2x WT+CQ; bliksem 2x WT+CQ; spreiden 2x WT+CQ. Weggelaten: immuun voor Nature (alleen CQ), plek bij Venomridge (alleen WT)
			},
			{ npc = 272561, encounter = 3600, name = "Vitrix", one = true, recheck = true,
				names = { deDE = "Vitrix", frFR = "Vitrix", esES = "Vitrix", esMX = "Vitrix", ptBR = "Vitrix", ruRU = "Витрикс" },
				does = { "FDG_SHAPER_10_D1", "FDG_SHAPER_10_D2" },
				tip = "FDG_SHAPER_10_T",
				-- src: groen paneel 2x WT+CQ (CQ: alleen door wegstrepen, 'not confirmed directly'); hard 1x WT (vroege groepen in een klap dood); gif op melee 1x CQ; stuns 1x CQ (UND en gametruth volgen CQ) | MEASURE: WT: feeding the green panel without killing Vitrix is enough to reach Nanaya. CQ: Nanaya comes only after all four console bosses are dead. Which is right? And does the green panel call Vitrix (WT yes; CQ only by elimination)?
			},
			{ npc = 261809, encounter = 3502, name = "Nanaya", one = true, recheck = true,
				names = { deDE = "Nanaya", frFR = "Nanaya", esES = "Nanaya", esMX = "Nanaya", ptBR = "Nanaya", ruRU = "Нанайя" },
				does = { "FDG_SHAPER_11_D1", "FDG_SHAPER_11_D2", "FDG_SHAPER_11_D3" },
				tip = "FDG_SHAPER_11_T",
				-- src: laatste baas + pilaar 2x WT+CQ (FDJ ook; DB2 AreaTable 16929 'Pillar of Assimilation'; Titan Panel klikken 1x WT); element 2x WT+CQ; stun 2x WT+DBS 1290463; weerstand 1x CQ (WT: alleen elementen)
			},
		},
		loot = {
			{ item = 280023, boss = 261809, role = "FDG_SHAPER_L1", recheck = true }, -- src: WHT Dropped by + CQ (id: FDJ)
			{ item = 280018, boss = 261812, role = "FDG_SHAPER_L2", recheck = true }, -- src: WHT Dropped by + CQ + REX (id: FDJ)
			{ item = 280014, boss = 261811, role = "FDG_SHAPER_L3", recheck = true }, -- src: WHT Dropped by: Tor'Rel + CQ + REX (id: FDJ)
		},
	},
	[289] = { -- SCHOLO
		bosses = {
			{ npc = 10506, encounter = 2805, name = "Kirtonos the Herald", optional = true,
				names = { deDE = "Kirtonos der Herold", frFR = "Kirtonos le Héraut", esES = "Kirtonos el Heraldo", esMX = "Kirtonos el Heraldo", ptBR = "Kirtonos, o Arauto", ruRU = "Киртонос Глашатай" },
				does = { "FDG_SCHOLO_1_D1", "FDG_SCHOLO_1_D2", "FDG_SCHOLO_1_D3" },
				tip = "FDG_SCHOLO_1_T",
				-- src: deur + Skeleton Key / Lockpicking 280 / Powerful Seaforium Charge 2x WH+CQ (FX, LFC ook; DB2 Lock 1159; controle 2b FG R1); optioneel + brazier 2x WH+CQ (MOB, WT(C), WFG ook); Blood Steward 2x CQ+WT(C) (WH-loottabel, IVC, LFC ook); twee vormen 2x WH+CQ (MOB, WT(C) ook); knockback 2x MOB+WT(C); disarm 2x MOB+CQ (WFG ook); muur 2x WH+WT(C) (CQ ook); curses 2x WH+CQ (MOB, WT(C) ook). WH's vaardighedenlijst bij Kirtonos is die van de Blood Steward (kopieerfout), niet gebruikt | DB2 encounter name: Kirtonos | MEASURE: Name: DB2 encounter 2805 = 'Kirtonos'; Wowhead npc 10506 and every guide = 'Kirtonos the Herald'. Which name does the client show?
			},
			{ npc = 10503, encounter = 2804, name = "Jandice Barov",
				names = { deDE = "Jandice Barov", frFR = "Jandice Barov", esES = "Jandice Barov", esMX = "Jandice Barov", ptBR = "Janice Barov", ruRU = "Джандис Баров" },
				does = { "FDG_SCHOLO_2_D1", "FDG_SCHOLO_2_D2", "FDG_SCHOLO_2_D3" },
				tip = "FDG_SCHOLO_2_T",
				-- src: fakkel 2x WH+WT(C); kopieen 2x WH+MOB (CQ, WT(C), WFG ook); curse 2x WH+MOB (CQ, WT(C) ook); tas 2x WH+CQ (FDJ ook); echte volgen 2x MOB+CQ (marker: WT(C), MOB: target macro); decurse 2x WH+MOB. Hoe je de kopieen opruimt verschilt (CQ/WFG: area damage, WH: 'kan niet met AoE'): weggelaten. Optioneel? WT(C)/IVC ja, WFG 'Skippable: No': niet gezet
			},
			{ npc = 11622, encounter = 2811, name = "Rattlegore",
				names = { deDE = "Blutrippe", frFR = "Cliquettripes", esES = "Traquesangre", esMX = "Traquesangre", ptBR = "Ossorrange", ruRU = "Громоклин" },
				does = { "FDG_SCHOLO_3_D1", "FDG_SCHOLO_3_D2", "FDG_SCHOLO_3_D3" },
				tip = "FDG_SCHOLO_3_T",
				-- src: hard 2x WH+WT(C) (MOB ook); stomp + stun 2x MOB+WFG; knockback 2x WH+MOB (CQ, WT(C) ook); sleutel 2x WH+CQ (MOB-loottabel, WT(C), LFC ook); kamer leeg 2x WH+MOB (CQ, WT(C) ook); buiten stomp 2x MOB+WT(C) (WH: ranged ver weg)
			},
			{ npc = 10433, encounter = 2809, name = "Marduk Blackpool",
				names = { deDE = "Marduk Schwarzborn", frFR = "Marduk Noirétang", esES = "Marduz Pozonegro", esMX = "Marduk Pozonegro", ptBR = "Marduque Lagonero", ruRU = "Мардук Блэкпул" },
				does = { "FDG_SCHOLO_4_D1", "FDG_SCHOLO_4_D2", "FDG_SCHOLO_4_D3" },
				tip = "FDG_SCHOLO_4_T",
				-- src: Viewing Room + studenten 2x MOB+CQ (WT(C) ook); Dawn's Gambit 2x MOB+CQ; aura 2x WH+CQ (WT(C) ook); cleave 2x WH+MOB (WT(C) ook); schild 2x WH+WT(C) (MOB ook); afstand 2x WH+WT(C) (CQ ook); stoppen bij schild 2x WH+WT(C) (MOB ook) | MEASURE: Optional? WT and Icy Veins (both Classic) say Marduk and Vectus are neutral and usually skipped unless someone has Dawn's Gambit; wowf.io (via WFG) says they cannot be skipped. Can a Forever group walk past them?
			},
			{ npc = 10432, encounter = 2813, name = "Vectus",
				names = { deDE = "Vectus", frFR = "Vectus", esES = "Vectus", esMX = "Vectus", ptBR = "Vectus", ruRU = "Вектус" },
				does = { "FDG_SCHOLO_5_D1", "FDG_SCHOLO_5_D2" },
				tip = "FDG_SCHOLO_5_T",
				-- src: Viewing Room 2x WH+MOB (WT(C) ook); Dawn's Gambit 2x CQ+LFC (FDJ ook); vuur op de grond 2x WH+MOB (WT(C), WFG ook); blast 2x WH+MOB (WT(C) ook); tip 2x MOB+WT(C) (WH: 'niet in het vuur') | MEASURE: See Marduk Blackpool: optional in Forever?
			},
			{ npc = 10508, encounter = 2810, name = "Ras Frostwhisper",
				names = { deDE = "Ras Frostraunen", frFR = "Ras Murmegivre", esES = "Ras Levescarcha", esMX = "Ras Murmuhielo", ptBR = "Ras Friomúrmuro", ruRU = "Рас Снегошепот" },
				does = { "FDG_SCHOLO_6_D1", "FDG_SCHOLO_6_D2", "FDG_SCHOLO_6_D3" },
				tip = "FDG_SCHOLO_6_T",
				-- src: lab 2x WH+MOB (WT(C), CQ ook; achter de Viewing Room: WH, IVC); frost + bevriezen 2x WH+MOB (CQ, WFG ook); fear 2x WH+MOB (CQ, WT(C) ook); knockback 2x MOB+WFG; keepsake 2x WH+CQ (LFC, FDJ ook); kamer leeg 2x WH+WT(C); om de beurt onderbreken 2x WH+WT(C) (MOB, CQ: onderbreken); weggedraaid 2x WH+CQ | DB2 encounter name: Ras Frostwhisperer | MEASURE: Name: DB2 encounter 2810 = 'Ras Frostwhisperer'; Wowhead npc 10508 and every guide = 'Ras Frostwhisper'. Which name does the client show?
			},
			{ npc = 16118, encounter = 3055, name = "Kormok", optional = true, one = true,
				names = { deDE = "Kormok", frFR = "Kormok", esES = "Kormok", esMX = "Kormok", ptBR = "Kormok", ruRU = "Кормок" },
				does = { "FDG_SCHOLO_7_D1", "FDG_SCHOLO_7_D2" },
				tip = "FDG_SCHOLO_7_T",
				-- src: optioneel + brazier 2x WH+CQ (WT(C), WFG, FDJ ook); skeletten 2x WT(C)+WFG; botschild 2x WT(C)+WFG; tip 1x WT(C). MOB en WH geven geen tactiek
			},
			{ npc = 10505, encounter = 2803, name = "Instructor Malicia",
				names = { deDE = "Instrukteurin Malicia", frFR = "Instructeur Malicia", esES = "Instructora Malicia", esMX = "Instructora Malicia", ptBR = "Instrutora Malícia", ruRU = "Инструктор Коварница" },
				does = { "FDG_SCHOLO_8_D1", "FDG_SCHOLO_8_D2" },
				tip = "FDG_SCHOLO_8_T",
				-- src: zes 2x WH+CQ (MOB, WT(C), WFG, LFC ook); heal 2x WH+MOB (WT(C), WFG ook); slow 2x WH+MOB; schade over tijd 2x WH+WFG (MOB ook); tip 2x WH+MOB (WT(C), WFG ook). 'Remove the curse' weggelaten: alleen WH noemt het een curse. 'Priestess' weggelaten: geen bron (WH-lijst, WT(C) 'heavy magic user')
			},
			{ npc = 11261, encounter = 2802, name = "Doctor Theolen Krastinov",
				names = { deDE = "Doktor Theolen Krastinov", frFR = "Docteur Theolen Krastinov", esES = "Doctor Theolen Krastinov", esMX = "Doctor Theolen Krastinov", ptBR = "Doutor Theolen Krastinov", ruRU = "Доктор Теолен Крастинов" },
				does = { "FDG_SCHOLO_9_D1", "FDG_SCHOLO_9_D2", "FDG_SCHOLO_9_D3" },
				tip = "FDG_SCHOLO_9_T",
				-- src: zes 2x WH+CQ; resten verbranden 2x WH+CQ (FDJ ook); bloeding 2x WH+MOB (WFG ook); stun 2x MOB+WFG (WH: knockback); enrage 2x WH+CQ (MOB, WT(C), WFG ook; moment: WH/WT(C) 50%, CQ onder de helft, MOB/WFG 'laat': geen getal); cooldowns 2x WH+MOB (WT(C) ook); threat 2x MOB+WT(C)
			},
			{ npc = 10901, encounter = 2808, name = "Lorekeeper Polkelt",
				names = { deDE = "Hüter des Wissens Polkelt", frFR = "Gardien du savoir Polkelt", esES = "Tradicionalista Polkelt", esMX = "Tradicionalista Polkelt", ptBR = "Erudito Pulquério", ruRU = "Сказитель Полкелт" },
				does = { "FDG_SCHOLO_10_D1", "FDG_SCHOLO_10_D2", "FDG_SCHOLO_10_D3" },
				tip = "FDG_SCHOLO_10_T",
				-- src: ziekte 2x WH+MOB (WFG ook); zuur/pantser 2x MOB+WFG (WH ook); weglopen 2x WH+MOB; ziekte weghalen 2x WFG+CQ
			},
			{ npc = 10507, encounter = 2812, name = "The Ravenian",
				names = { deDE = "Der Ravenier", frFR = "Le Voracien", esES = "El Devorador", esMX = "El Devorador", ptBR = "O Corvino", ruRU = "Равениан" },
				does = { "FDG_SCHOLO_11_D1", "FDG_SCHOLO_11_D2", "FDG_SCHOLO_11_D3" },
				tip = "FDG_SCHOLO_11_T",
				-- src: beneden 2x WH+WT(C) (WFG ook); cleave 2x WH+MOB (WFG ook); trample 2x WH+MOB (WFG ook); knockback 2x WH+MOB (WT(C) ook); muur + weg 2x WH+MOB (WFG ook); niet voor hem 2x MOB+WFG. Stapelend pantserverlies: alleen MOB, weggelaten
			},
			{ npc = 10504, encounter = 2807, name = "Lord Alexei Barov",
				names = { deDE = "Lord Alexei Barov", frFR = "Seigneur Alexei Barov", esES = "Lord Alexei Barov", esMX = "Lord Alexei Barov", ptBR = "Lorde Alexei Barov", ruRU = "Лорд Алексей Баров" },
				does = { "FDG_SCHOLO_12_D1", "FDG_SCHOLO_12_D2" },
				tip = "FDG_SCHOLO_12_T",
				-- src: moeilijk 2x WH+WT(C); twee wachters 2x WH+MOB (WT(C) ook); aura 2x WH+MOB (WT(C), WFG ook); curse minder healing 2x WH+MOB (WT(C) ook); CC 2x WH+MOB (WT(C) ook); uit de aura 2x WH+MOB; decurse 2x MOB+WT(C) (WH ook). Kill-volgorde verschilt (WT(C): Barov eerst, MOB: wachters eerst): niet in de tip. Groene vloeistof: alleen WH
			},
			{ npc = 10502, encounter = 2806, name = "Lady Illucia Barov",
				names = { deDE = "Lady Illucia Barov", frFR = "Dame Illucia Barov", esES = "Lady Illucia Barov", esMX = "Lady Illucia Barov", ptBR = "Lady Ilúcia Barov", ruRU = "Леди Иллюсия Баров" },
				does = { "FDG_SCHOLO_13_D1", "FDG_SCHOLO_13_D2" },
				tip = "FDG_SCHOLO_13_T",
				-- src: beneden 2x WH+WT(C); overname 2x WH+MOB (WT(C), WFG, CQ ook); fear 2x WH+MOB (WFG ook); silence 2x WH+MOB (WFG ook); CC speler 2x MOB+WFG (WT(C) ook); onderbreken 2x MOB+WT(C)
			},
			{ npc = 1853, encounter = 2801, name = "Darkmaster Gandling",
				names = { deDE = "Dunkelmeister Gandling", frFR = "Sombre Maître Gandling", esES = "Maestro oscuro Gandling", esMX = "Maestro oscuro Gandling", ptBR = "Umbromestre Gandling", ruRU = "Темный магистр Гандлинг" },
				does = { "FDG_SCHOLO_14_D1", "FDG_SCHOLO_14_D2", "FDG_SCHOLO_14_D3" },
				tip = "FDG_SCHOLO_14_T",
				-- src: na zes 2x WH+MOB (CQ, WT(C), WFG, LFC ook); zijkamer + undead 2x WH+CQ (MOB, WT(C), WFG, FX ook); arcane + curse 2x WH+CQ (WFG ook); reserve 2x WH+MOB (WT(C), LFC ook); onderbreken 2x WH+CQ
			},
		},
		loot = {
			{ item = 13937, boss = 1853, role = "FDG_SCHOLO_L1" }, -- src: WHT Dropped by + CQ + WH + MOB
			{ item = 14487, boss = 10508, role = "FDG_SCHOLO_L2" }, -- src: WHT Dropped by + CQ + WH + MOB
			{ item = 18686, boss = 11622, role = "FDG_SCHOLO_L3" }, -- src: WHT Dropped by + CQ + WH + MOB
		},
	},
	[329] = { -- STRAT
		bosses = {
			{ npc = 10393, encounter = 2799, name = "Skul", part = "FDGP_MAIN_GATE", rare = true,
				names = { deDE = "Skul", frFR = "Krân", esES = "Skul", esMX = "Skul", ptBR = "Kranio", ruRU = "Череп" },
				does = { "FDG_STRAT_1_D1", "FDG_STRAT_1_D2" },
				tip = "FDG_STRAT_1_T",
				-- src: rare 2x CQ+WT(C) (WH, WFG, MOB, WHT 'Rare Elite' ook); caster 2x WH+WFG (CQ ook); onderbreken 2x WH+CQ (WT(C), WFG ook). Plek weggelaten: WT(C)/WFG bij de Main Gate, WH ook een tweede plek in het oosten
			},
			{ npc = 11058, encounter = 2797, name = "Ezra Grimm", part = "FDGP_MAIN_GATE", optional = true,
				names = { deDE = "Ezra Grimm", frFR = "Ezra Grimm", esES = "Ezra Grimm", esMX = "Ezra Grimm", ptBR = "Ezra Carranca", ruRU = "Эзра Гримм" },
				does = { "FDG_STRAT_2_D1", "FDG_STRAT_2_D2", "FDG_STRAT_2_D3" },
				tip = "FDG_STRAT_2_T",
				-- src: optioneel 2x MM(C)+FDJ (WH ook); winkel links van de poort 2x WFG+CQ(quests 18 nov); tabaksdoos 2x WH+MM(C) (FX, FDJ ook); helpers 2x WH+FX; vuur + rookbom 2x WH+MM(C) (FX ook); tabak/quest 2x WH+CQ (MOB ook); eerst leeg 2x WH+FX (FDJ ook); wegdraaien 2x MM(C)+FX
			},
			{ npc = 10558, encounter = 473, name = "Hearthsinger Forresten", part = "FDGP_MAIN_GATE", rare = true,
				names = { deDE = "Herdsinger Forresten", frFR = "Chanteloge Forrestin", esES = "Escupezones Foreste", esMX = "Cantachimeneas Forresten", ptBR = "Cantalar Forresten", ruRU = "Певчий Форрестен" },
				does = { "FDG_STRAT_3_D1", "FDG_STRAT_3_D2" },
				tip = "FDG_STRAT_3_T",
				-- src: rare 2x WH+CQ (WT(C), WFG, WHT 'Rare Elite' ook); slaap 2x WH+CQ (WT(C), WFG ook); meerdere spelers 2x WH+WT(C) (WFG ook); spreiden 2x WH+WT(C) (WFG ook)
			},
			{ npc = 10516, encounter = 472, name = "The Unforgiven", part = "FDGP_MAIN_GATE", optional = true,
				names = { deDE = "Der Unverziehene", frFR = "Le Condamné", esES = "El imperdonable", esMX = "El Imperdonable", ptBR = "O Imperdoável", ruRU = "Непрощенный" },
				does = { "FDG_STRAT_4_D1", "FDG_STRAT_4_D2" },
				tip = "FDG_STRAT_4_T",
				-- src: hinderlaag + geesten 2x MOB+CQ (WH, WT(C), WFG ook); bevriezen 2x MOB+WFG; vertragen 2x WH+CQ; eerst het pack 2x MOB+WH; geesten eerst 2x CQ+WFG (WT(C) ook); optioneel 2x WH+WFA
			},
			{ npc = 11143, encounter = 2798, name = "Postmaster Malown", part = "FDGP_MAIN_GATE", optional = true,
				names = { deDE = "Postmeister Malown", frFR = "Postier Malown", esES = "Jefe de correos Gassol", esMX = "Jefe de correos Gassol", ptBR = "Chefe do Correio Malown", ruRU = "Почтальон Мэлоун" },
				does = { "FDG_STRAT_5_D1", "FDG_STRAT_5_D2" },
				tip = "FDG_STRAT_5_T",
				-- src: optioneel + koerier + derde doos 2x CQ+WH (WT(C), WFG ook; FDJ zegt 'Key to the City', de rest de koerier-sleutels); postmannen bij de derde bus 2x WH+FX (WT(C) ook: bij elke bus; CQ noemt geen postmannen); fear + curses 2x WH+CQ (WFG ook); postmannen eerst 2x WH+WT(C) (WFG ook); decurse 2x WH+WT(C)
			},
			{ npc = 10808, encounter = 474, name = "Timmy the Cruel", part = "FDGP_MAIN_GATE",
				names = { deDE = "Timmy der Grausame", frFR = "Timmy le Cruel", esES = "Timmy el Cruel", esMX = "Timmy el Cruel", ptBR = "Tico, o Cruel", ruRU = "Тайлер" },
				does = { "FDG_STRAT_6_D1", "FDG_STRAT_6_D2", "FDG_STRAT_6_D3" },
				tip = "FDG_STRAT_6_T",
				-- src: plein leeg 2x WT(C)+WFG (MM(C), FDJ ook; CQ zegt 'market square'); melee 2x WH+WT(C) (MOB ook); enrage 2x WH+MOB (WT(C), WFG ook; WFG 20%, de rest geen getal); Bastion-deur in Classic 2x WT(C)+MM(C) (wowforever.be, wowforever.ninja, IVC ook; DB2 Lock 299); tip 2x MOB+WT(C) | MEASURE: Wowhead lists him as 'Rare Elite', but every guide says he always comes once Crusader's Square is cleared. Is he there every run? (ruRU: Wowhead npc 'Тайлер', DB2 474 'Тимми Беспощадный'; which one is on the nameplate?)
			},
			{ npc = 11032, encounter = 476, name = "Malor the Zealous", part = "FDGP_MAIN_GATE", one = true,
				names = { deDE = "Malor der Eifrige", frFR = "Malor le Zélé", esES = "Malor el Entusiasta", esMX = "Malor el Fanático", ptBR = "Malor, o Zeloso", ruRU = "Малор Ревностный" },
				does = { "FDG_STRAT_7_D1", "FDG_STRAT_7_D2", "FDG_STRAT_7_D3" },
				tip = "FDG_STRAT_7_T",
				-- src: optioneel 2x MM(C)+FDJ; strongbox + medaillon 2x WH+CQ (MM(C), FDJ ook); heal 2x CQ+WFG (MM(C), FX ook); volle heal bijna dood 2x MM(C)+FX (WH: Lay on Hands); eigen buit 2x CQ+WHT 'Dropped by' (FX, FDJ ook; WH 4 nov en MM(C) zeiden nog 'geen eigen buit'); onderbreken 2x CQ+WFG (MM(C), FX ook); volle heal niet te onderbreken 1x FX (controle 2b FG R7) | MEASURE: Optional? mmonster (Classic) and the FDJ addon say yes, but wowforeveraddon.com lists him as a normal boss, not among the optional ones. Can a Forever group skip him?
			},
			{ npc = 11120, encounter = 2796, name = "Crimson Hammersmith", part = "FDGP_MAIN_GATE", optional = true, one = true,
				names = { deDE = "Purpurroter Hammerschmied", frFR = "Forgeur de marteaux cramoisi", esES = "Forjador de martillos carmesí", esMX = "Forjador de martillos carmesí", ptBR = "Forjador de Martelos Carmesim", ruRU = "Молотобоец из Багрового Легиона" },
				does = { "FDG_STRAT_8_D1", "FDG_STRAT_8_D2" },
				tip = "FDG_STRAT_8_T",
				-- src: optioneel + plans 2x WH+WT(C) (WFG ook; CQ: 'als je zijn kamer nadert', zie notes); smid-buit 2x WH+CQ; simpel 2x WH+WT(C); tip 1x WT(C) (WFG zegt het bij de Black Guard Swordsmith)
			},
			{ npc = 10997, encounter = 475, name = "Cannon Master Willey", part = "FDGP_MAIN_GATE",
				names = { deDE = "Kanonenmeister Willey", frFR = "Maître canonnier Willey", esES = "Cañonero Jefe Willey", esMX = "Maestro cañonero Willey", ptBR = "Mestre de Canhões Gualter", ruRU = "Мастер-канонир Вилли" },
				does = { "FDG_STRAT_9_D1", "FDG_STRAT_9_D2", "FDG_STRAT_9_D3" },
				tip = "FDG_STRAT_9_T",
				-- src: riflemen 2x WH+MOB (CQ, WT(C), WFG ook); kanonnen + kogels in de kamer 2x WH+MOB (WT(C) ook; CQ: de kogels vallen van hem); onderbreekt casters 2x MOB+WH; tip 2x CQ+WT(C) (WH, MOB ook) | MEASURE: Classic Era: the Scarlet Bastion door (and the Hoard door to Willey) needs The Scarlet Key from Scarlet Monastery or a rogue's Lockpicking (Icy Veins Classic, Warcraft Tavern, mmonster). Wowhead, conquestcapped, Mobalytics and wowf.io do not mention it; Warcraft Tavern Forever, mmonster, wowforever.be and wowforever.ninja do (all based on Classic). Is the key still needed in Forever?
			},
			{ npc = 10811, encounter = 477, name = "Archivist Galford", part = "FDGP_MAIN_GATE",
				names = { deDE = "Archivar Galford", frFR = "Archiviste Galford", esES = "Archivista Galford", esMX = "Archivista Galford", ptBR = "Arquivista Galford", ruRU = "Архивариус Галфорд" },
				does = { "FDG_STRAT_10_D1", "FDG_STRAT_10_D2", "FDG_STRAT_10_D3" },
				tip = "FDG_STRAT_10_T",
				-- src: archief + verbranden 2x WH+CQ (MOB, FDJ ook); branden + tank-wissel 2x WH+WT(C) (MOB, WFG ook; stun: alleen MOB, weggelaten); vuur rond hem 2x WH+MOB; spreiden 2x WT(C)+WFG (MOB ook); terugpakken 2x WT(C)+WFG
			},
			{ npc = 10813, extraNpc = 10812, encounter = 478, name = "Balnazzar", part = "FDGP_MAIN_GATE",
				names = { deDE = "Balnazzar", frFR = "Balnazzar", esES = "Balnazzar", esMX = "Balnazzar", ptBR = "Balnazzar", ruRU = "Балназзар" },
				does = { "FDG_STRAT_11_D1", "FDG_STRAT_11_D2" },
				tip = "FDG_STRAT_11_T",
				-- src: Dathrohan -> Balnazzar 2x WH+CQ (MOB, WT(C), WFG ook; moment: WH 'rond de helft', CQ 'op de helft', de rest geen getal: geen getal); overname 2x WH+MOB (CQ ook); fear 2x WH+MOB (CQ, WT(C), WFG ook); slaap 2x WH+MOB (WT(C), WFG ook); CC speler 2x WH+MOB (CQ ook); dispel 2x WH+WT(C) (MOB ook); afstand 2x WH+WT(C) (MOB ook)
			},
			{ npc = 10809, encounter = 2800, name = "Stonespine", part = "FDGP_SERVICE_GATE", rare = true,
				names = { deDE = "Steinbuckel", frFR = "Echine-de-pierre", esES = "Pidrespina", esMX = "Pidrespina", ptBR = "Petrespáduas", ruRU = "Каменный Гребень" },
				does = { "FDG_STRAT_12_D1", "FDG_STRAT_12_D2" },
				tip = "FDG_STRAT_12_T",
				-- src: rare + patrouille 2x WH+MOB (WT(C), WFG, WHT 'Rare Elite' ook); bloeding 2x WH+WFG; alleen trekken 2x MOB+WFG
			},
			{ npc = 10437, encounter = 480, name = "Nerub'enkan", part = "FDGP_SERVICE_GATE",
				names = { deDE = "Nerub'enkan", frFR = "Nerub'enkan", esES = "Nerub'enkan", esMX = "Nerub'enkan", ptBR = "Nerub'enkan", ruRU = "Неруб'энкан" },
				does = { "FDG_STRAT_13_D1", "FDG_STRAT_13_D2" },
				tip = "FDG_STRAT_13_T",
				-- src: ziggurat 2x WH+CQ (MOB, WT(C) ook); scarabs 2x WH+MOB (CQ, WFG ook); web 2x WH+MOB (WFG ook); pantser 2x WH+WFG; AoE 2x WH+CQ (WFG ook); Acolytes 2x WH+WT(C) (WFG, MM(C) ook; CQ noemt alleen de bazen)
			},
			{ npc = 10436, encounter = 479, name = "Baroness Anastari", part = "FDGP_SERVICE_GATE",
				names = { deDE = "Baroness Anastari", frFR = "Baronne Anastari", esES = "Baronesa Anastari", esMX = "Baronesa Anastari", ptBR = "Baronesa Anastari", ruRU = "Баронесса Анастари" },
				does = { "FDG_STRAT_14_D1", "FDG_STRAT_14_D2", "FDG_STRAT_14_D3" },
				tip = "FDG_STRAT_14_T",
				-- src: ziggurat 2x WH+CQ (MOB, WT(C) ook); overname 2x WH+CQ (MOB, WT(C), WFG ook); silence 2x WH+WT(C) (WFG ook); curse 2x WH+WT(C) (WFG ook); halve health 2x WH+CQ (WT(C), WFG ook); Acolytes 2x WH+WT(C) (WFG ook)
			},
			{ npc = 11121, encounter = 2795, name = "Black Guard Swordsmith", part = "FDGP_SERVICE_GATE", optional = true,
				names = { deDE = "Schwertschmied der schwarzen Wache", frFR = "Fabricant d'épées de la Garde noire", esES = "Armero Guardia Negra", esMX = "Armero Guardia Negra", ptBR = "Cuteleiro da Guarda Negra", ruRU = "Оружейник Черной Стражи" },
				does = { "FDG_STRAT_15_D1" },
				tip = "FDG_STRAT_15_T",
				-- src: optioneel + plans 2x WH+WT(C) (WFG, MM(C) ook; CQ: 'als je zijn plek passeert', zie notes); bij de Baroness 2x WH+WFG (MM(C) ook); smid-buit 2x WH+CQ; tip 2x WT(C)+WFG. Vaardigheden weggelaten: WH 'geen', WFG 'curse'
			},
			{ npc = 10438, encounter = 481, name = "Maleki the Pallid", part = "FDGP_SERVICE_GATE",
				names = { deDE = "Maleki der Leichenblasse", frFR = "Maleki le Blafard", esES = "Maleki el Pálido", esMX = "Maleki el Pálido", ptBR = "Malaki, o Pálido", ruRU = "Малекай Бледный" },
				does = { "FDG_STRAT_16_D1", "FDG_STRAT_16_D2", "FDG_STRAT_16_D3" },
				tip = "FDG_STRAT_16_T",
				-- src: ziggurat 2x WH+WT(C) (CQ ook); ijs + andere speler 2x WH+WFG (MOB, CQ ook; WH 6 s, daarom 'a few seconds'); frost + drain 2x WH+MOB (WFG ook); inhouden 2x WH+CQ (MOB ook); onderbreken 2x MOB+WFG; Acolytes 2x WH+WT(C)
			},
			{ npc = 10435, encounter = 482, name = "Magistrate Barthilas", part = "FDGP_SERVICE_GATE",
				names = { deDE = "Magistrat Barthilas", frFR = "Magistrat Barthilas", esES = "Magistrado Barthilas", esMX = "Magistrado Barthilas", ptBR = "Magistrado Barthilas", ruRU = "Мировой судья Бартилас" },
				does = { "FDG_STRAT_17_D1", "FDG_STRAT_17_D2", "FDG_STRAT_17_D3" },
				tip = "FDG_STRAT_17_T",
				-- src: sleutel 2x CQ+WHT 'Dropped by' (MOB- en WH-loottabel, WT(C), WFG ook); twee plekken 2x WH+WT(C) (MOB, WFG, MM(C) ook); knockback 2x WH+MOB (CQ, WFG ook); muur 2x WH+MOB (CQ, WFG ook) | MEASURE: Does the Service Gate in Forever still need the Key to the City (or Lockpicking 300 / a Seaforium charge)? Every Forever guide says yes, but none reports a run.
			},
			{ npc = 10439, encounter = 483, name = "Ramstein the Gorger", part = "FDGP_SERVICE_GATE",
				names = { deDE = "Ramstein der Verschlinger", frFR = "Ramstein Grandgosier", esES = "Ramstein el Empachador", esMX = "Ramstein el Empachador", ptBR = "Ramstein, o Devorador", ruRU = "Рамштайн Ненасытный" },
				does = { "FDG_STRAT_18_D1", "FDG_STRAT_18_D2", "FDG_STRAT_18_D3" },
				tip = "FDG_STRAT_18_T",
				-- src: plein na ziggurats 2x WT(C)+WFG (CQ, MOB, WH ook); abominaties 2x WH+MOB (CQ, WT(C), WFG ook); knockout + wissel 2x WH+MOB (CQ, WFG ook); trample 2x WH+WFG; golf + wachters 2x WFG+WT(C) (MM(C) ook; CQ zegt de golf vóór Ramstein; controle 2b FG R5); taunt 2x MOB+WFG; AoE 2x CQ+WFG
			},
			{ npc = 10440, encounter = 484, name = "Baron Rivendare", part = "FDGP_SERVICE_GATE",
				names = { deDE = "Baron Rivendare", frFR = "Baron Vaillefendre", esES = "Barón Osahendido", esMX = "Barón Osahendido", ptBR = "Barão Rivendare", ruRU = "Барон Ривендер" },
				does = { "FDG_STRAT_19_D1", "FDG_STRAT_19_D2", "FDG_STRAT_19_D3" },
				tip = "FDG_STRAT_19_T",
				-- src: 45 min 2x CQ+WFG (WT(C), MM(C), FDJ ook; wanneer de klok start verschilt: WT(C)/WFG de Gauntlet-poort, CQ het binnengaan); aura 2x WH+MOB (CQ, WT(C), WFG ook); minder healing 2x WH+MOB (WT(C), WFG ook); skeletten die hem helen 2x MOB+WFG (WH, CQ: skeletten); deur 2x WH+WFG; afstand 2x WH+MOB (WFG ook); skeletten doden 2x WH+MOB (CQ, WFG ook)
			},
		},
		loot = {
			{ item = 276399, boss = 11032, role = "FDG_STRAT_L1", part = "FDGP_MAIN_GATE" }, -- src: WHT Dropped by + CQ + FX (FDJ ook)
			{ item = 276398, boss = 11032, role = "FDG_STRAT_L2", part = "FDGP_MAIN_GATE" }, -- src: WHT Dropped by + CQ + FX (FDJ ook)
			{ item = 13380, boss = 10997, role = "FDG_STRAT_L3", part = "FDGP_MAIN_GATE" }, -- src: WHT Dropped by + CQ + MOB
			{ item = 13346, boss = 10440, role = "FDG_STRAT_L4", part = "FDGP_SERVICE_GATE" }, -- src: WHT Dropped by + WH + MOB
			{ item = 13361, boss = 10440, role = "FDG_STRAT_L5", part = "FDGP_SERVICE_GATE" }, -- src: WHT Dropped by + CQ + MOB
			{ item = 13373, boss = 10439, role = "FDG_STRAT_L6", part = "FDGP_SERVICE_GATE" }, -- src: WHT Dropped by + CQ + MOB
		},
	},
}
