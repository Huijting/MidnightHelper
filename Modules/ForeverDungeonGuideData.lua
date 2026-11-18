local _, ns = ...

-- ForeverDungeonGuideData.lua - GENERATED 18 Nov 2026 (dg_gen.lua, build chat scratchpad) from the mh-research data
-- of that day. Do not edit by hand: change the source data and generate again. Sources and dates per line in
-- docs/forever/DUNGEONGIDS_DATA_2026-11-18.md; the texts are FDG_* keys in Locales/enUS.lua (and the packs).
-- npc ids GEMETEN (Wowhead Forever tooltips), encounter ids + boss names per language GEMETEN (DB2 DungeonEncounter
-- 1.60.1.70959) except where a comment says otherwise; item ids + 'Dropped by' GEMETEN (Wowhead Forever); roles AFGELEID.
-- one = a line has one source only (the guide says so); recheck = new Forever dungeon, check again later (Rob).

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
}
