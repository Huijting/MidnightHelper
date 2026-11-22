local _, ns = ...

--[[
	ForeverReagentSourceData.lua - WoW Forever 1.60.1.71037: where you get a crafting reagent (172 items, 22 Nov 2026).
	Rob via sparring 22 Nov 2026, verbatim: "1 b", "plek ja", "overnemen, ja" (places and numbers from Zygor: ids,
	coordinates, order; no texts, notes or code). Nothing from Polestar or FlowUp.
	An item is in here only with two sources that agree, or with Rob's own client:
	  gathered = AllTheThings' Forever database + the Wowhead Forever tooltip of the node; Skinning: + Zygor
	  sold     = AllTheThings' seller lists + Rob's client (Auctionator's vendor price cache) or the Wowhead Forever
	             item page. Sellers = AllTheThings' and Zygor's npc ids, only those MH already has a point for
	             (ForeverVendorSpots.lua, Wowhead Forever).
	drops    = AllTheThings + Zygor's farm steps (item ids only). No place: which monsters is not in this file.
	Seller names per language: Wowhead Forever tooltips. Profession names: DB2 SkillLine.
	AllTheThings database: commit 3b009971c7cb9287d3f1291b04c9cd59187cdeaa, under this licence:

MIT License

Copyright (c) 2026 AllTheThings WoW Addon

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

if not ns.IS_FOREVER then
	return
end

-- [item] = "H" Herbalism, "M" Mining, "S" Skinning
ns.REAGENT_GATHERED = {
	[765] = "H", -- Silverleaf
	[785] = "H", -- Mageroyal
	[2447] = "H", -- Peacebloom
	[2449] = "H", -- Earthroot
	[2450] = "H", -- Briarthorn
	[2452] = "H", -- Swiftthistle
	[2453] = "H", -- Bruiseweed
	[3355] = "H", -- Wild Steelbloom
	[3356] = "H", -- Kingsblood
	[3357] = "H", -- Liferoot
	[3358] = "H", -- Khadgar's Whisker
	[3369] = "H", -- Grave Moss
	[3818] = "H", -- Fadeleaf
	[3819] = "H", -- Wintersbite
	[3820] = "H", -- Stranglekelp
	[3821] = "H", -- Goldthorn
	[4625] = "H", -- Firebloom
	[8153] = "H", -- Wildvine
	[8831] = "H", -- Purple Lotus
	[8836] = "H", -- Arthas' Tears
	[8838] = "H", -- Sungrass
	[8839] = "H", -- Blindweed
	[8845] = "H", -- Ghost Mushroom
	[8846] = "H", -- Gromsblood
	[13463] = "H", -- Dreamfoil
	[13464] = "H", -- Golden Sansam
	[13465] = "H", -- Mountain Silversage
	[13466] = "H", -- Plaguebloom
	[13467] = "H", -- Icecap
	[13468] = "H", -- Black Lotus
	[774] = "M", -- Malachite
	[818] = "M", -- Tigerseye
	[1206] = "M", -- Moss Agate
	[1210] = "M", -- Shadowgem
	[1529] = "M", -- Jade
	[1705] = "M", -- Lesser Moonstone
	[2770] = "M", -- Copper Ore
	[2771] = "M", -- Tin Ore
	[2772] = "M", -- Iron Ore
	[2775] = "M", -- Silver Ore
	[2776] = "M", -- Gold Ore
	[2835] = "M", -- Rough Stone
	[2836] = "M", -- Coarse Stone
	[2838] = "M", -- Heavy Stone
	[3858] = "M", -- Mithril Ore
	[3864] = "M", -- Citrine
	[7909] = "M", -- Aquamarine
	[7910] = "M", -- Star Ruby
	[7911] = "M", -- Truesilver Ore
	[7912] = "M", -- Solid Stone
	[9262] = "M", -- Black Vitriol
	[10620] = "M", -- Thorium Ore
	[11370] = "M", -- Dark Iron Ore
	[11382] = "M", -- Blood of the Mountain
	[12361] = "M", -- Blue Sapphire
	[12363] = "M", -- Arcane Crystal
	[12364] = "M", -- Huge Emerald
	[12365] = "M", -- Dense Stone
	[12799] = "M", -- Large Opal
	[12800] = "M", -- Azerothian Diamond
	[249391] = "M", -- Pyrite
	[2318] = "S", -- Light Leather
	[2319] = "S", -- Medium Leather
	[2934] = "S", -- Ruined Leather Scraps
	[4234] = "S", -- Heavy Leather
	[4235] = "S", -- Heavy Hide
	[4304] = "S", -- Thick Leather
	[8170] = "S", -- Rugged Leather
}
-- [item] = the npc ids that sell it
ns.REAGENT_SOLD_BY = {
	[2320] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Coarse Thread
	[2321] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Fine Thread
	[2324] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Bleach
	[2325] = { 3367, 4561, 5817, 8363 }, -- Black Dye
	[2604] = { 66, 1250, 2118, 3081, 3367, 4561, 4775, 4897, 5817, 8363 }, -- Red Dye
	[2605] = { 1286, 3367, 4561, 4775, 5817, 8363 }, -- Green Dye
	[2678] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 6301, 8363 }, -- Mild Spices
	[2692] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Hot Spices
	[2880] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Weak Flux
	[3371] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Empty Vial
	[3372] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Leaded Vial
	[3466] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Strong Flux
	[3713] = { 2381, 2393, 3367, 4561, 4775, 4897, 5817, 8363, 11189 }, -- Soothing Spices
	[3857] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Coal
	[4289] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Salt
	[4291] = { 1148, 2381, 3367, 4561, 4775, 4897, 5817, 8363 }, -- Silken Thread
	[4340] = { 3367, 4561, 5817, 8363 }, -- Gray Dye
	[4341] = { 3367, 4561, 5817, 8363 }, -- Yellow Dye
	[4342] = { 3367, 4561, 5817, 8363 }, -- Purple Dye
	[4399] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Wooden Stock
	[4536] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Shiny Red Apple
	[6217] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Copper Rod
	[6260] = { 66, 1250, 2118, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Blue Dye
	[6530] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Nightcrawlers
	[8343] = { 3367, 4561, 4897, 5817, 8363 }, -- Heavy Silken Thread
	[8925] = { 2381, 3367, 4229, 4561, 4775, 5817, 8363 }, -- Crystal Vial
}
-- [item] = monsters drop it
ns.REAGENT_DROPS = {
	[723] = true, -- Goretusk Liver
	[729] = true, -- Stringy Vulture Meat
	[730] = true, -- Murloc Eye
	[731] = true, -- Goretusk Snout
	[769] = true, -- Chunk of Boar Meat
	[814] = true, -- Flask of Oil
	[1015] = true, -- Lean Wolf Flank
	[1080] = true, -- Tough Condor Meat
	[1468] = true, -- Murloc Fin
	[1475] = true, -- Small Venom Sac
	[2251] = true, -- Gooey Spider Leg
	[2589] = true, -- Linen Cloth
	[2592] = true, -- Wool Cloth
	[2672] = true, -- Stringy Wolf Meat
	[2673] = true, -- Coyote Meat
	[2674] = true, -- Crawler Meat
	[2675] = true, -- Crawler Claw
	[2677] = true, -- Boar Ribs
	[2886] = true, -- Crag Boar Rib
	[2924] = true, -- Crocolisk Meat
	[3172] = true, -- Boar Intestines
	[3173] = true, -- Bear Meat
	[3174] = true, -- Spider Ichor
	[3182] = true, -- Spider's Silk
	[3404] = true, -- Buzzard Wing
	[3667] = true, -- Tender Crocolisk Meat
	[3685] = true, -- Raptor Egg
	[3712] = true, -- Turtle Meat
	[3730] = true, -- Big Bear Meat
	[3731] = true, -- Lion Meat
	[4306] = true, -- Silk Cloth
	[4337] = true, -- Thick Spider's Silk
	[4338] = true, -- Mageweave Cloth
	[4461] = true, -- Raptor Hide
	[4589] = true, -- Long Elegant Feather
	[5465] = true, -- Small Spider Leg
	[5466] = true, -- Scorpid Stinger
	[5467] = true, -- Kodo Meat
	[5468] = true, -- Soft Frenzy Flesh
	[5469] = true, -- Strider Meat
	[5470] = true, -- Thunder Lizard Tail
	[5471] = true, -- Stag Meat
	[5635] = true, -- Sharp Claw
	[5784] = true, -- Slimy Murloc Scale
	[5785] = true, -- Thick Murloc Scale
	[6889] = true, -- Small Egg
	[7067] = true, -- Elemental Earth
	[7068] = true, -- Elemental Fire
	[7069] = true, -- Elemental Air
	[7070] = true, -- Elemental Water
	[7075] = true, -- Core of Earth
	[7076] = true, -- Essence of Earth
	[7077] = true, -- Heart of Fire
	[7078] = true, -- Essence of Fire
	[7079] = true, -- Globe of Water
	[7080] = true, -- Essence of Water
	[7081] = true, -- Breath of Wind
	[7082] = true, -- Essence of Air
	[7972] = true, -- Ichor of Undeath
	[10285] = true, -- Shadow Silk
	[10286] = true, -- Heart of the Wild
	[12037] = true, -- Mystery Meat
	[12184] = true, -- Raptor Flesh
	[12202] = true, -- Tiger Meat
	[12203] = true, -- Red Wolf Meat
	[12207] = true, -- Giant Egg
	[12223] = true, -- Meaty Bat Wing
	[12662] = true, -- Demonic Rune
	[12803] = true, -- Living Essence
	[12808] = true, -- Essence of Undeath
	[12809] = true, -- Guardian Stone
	[12811] = true, -- Righteous Orb
	[14047] = true, -- Runecloth
	[14227] = true, -- Ironweb Spider Silk
	[14256] = true, -- Felcloth
	[19441] = true, -- Huge Venom Sac
	[21024] = true, -- Chimaerok Tenderloin
	[255007] = true, -- Golem Isospring
}
ns.REAGENT_GATHER_NAMES = {
	enUS = { H = "Herbalism", M = "Mining", S = "Skinning" },
	deDE = { H = "Kräuterkunde", M = "Bergbau", S = "Kürschnerei" },
	frFR = { H = "Herboristerie", M = "Minage", S = "Dépeçage" },
	esES = { H = "Botánica", M = "Minería", S = "Desollar" },
	esMX = { H = "Herboristería", M = "Minería", S = "Desuello" },
	ptBR = { H = "Herborismo", M = "Mineração", S = "Esfolamento" },
	ruRU = { H = "Травничество", M = "Горное дело", S = "Снятие шкур" },
}
ns.REAGENT_SELLER_NAMES = {
	enUS = { [66] = "Tharynn Bouden", [1148] = "Nerrist", [1250] = "Drake Lindgren", [1286] = "Edna Mullby", [2118] = "Abigail Shiel", [2381] = "Micha Yance", [2393] = "Christoph Jeffcoat", [3081] = "Wunna Darkmane", [3367] = "Felika", [4229] = "Mythrin'dir", [4561] = "Daniel Bartlett", [4775] = "Felicia Doan", [4897] = "Helenia Olden", [5817] = "Shimra", [6301] = "Gorbold Steelhand", [8363] = "Shadi Mistrunner", [11189] = "Qia" },
	deDE = { [66] = "Tharynn Bouden", [1148] = "Nerrist", [1250] = "Drake Lindgren", [1286] = "Edna Mullby", [2118] = "Abigail Shiel", [2381] = "Micha Yance", [2393] = "Christoph Jeffcoat", [3081] = "Wunna Darkmane", [3367] = "Felika", [4229] = "Mythrin'dir", [4561] = "Daniel Bartlett", [4775] = "Felicia Doan", [4897] = "Helenia Olden", [5817] = "Shimra", [6301] = "Gorbold Steelhand", [8363] = "Shadi Mistrunner", [11189] = "Qia" },
	frFR = { [66] = "Tharynn Bouden", [1148] = "Nerrist", [1250] = "Drake Lindgren", [1286] = "Edna Mullby", [2118] = "Abigail Shiel", [2381] = "Micha Yance", [2393] = "Christoph Jeffcoat", [3081] = "Wunna Darkmane", [3367] = "Felika", [4229] = "Mythrin'dir", [4561] = "Daniel Bartlett", [4775] = "Felicia Doan", [4897] = "Helenia Olden", [5817] = "Shimra", [6301] = "Gorbold Steelhand", [8363] = "Shadi Mistrunner", [11189] = "Qia" },
	esES = { [66] = "Tharynn Bouden", [1148] = "Nerrist", [1250] = "Draco Lindgren", [1286] = "Edna Mullby", [2118] = "Abigail Shiel", [2381] = "Micha Yance", [2393] = "Christoph Yabrigo", [3081] = "Wunna Crinoscuro", [3367] = "Felika", [4229] = "Mythrin'dir", [4561] = "Daniel Bartlett", [4775] = "Felicia Doan", [4897] = "Helenia Olden", [5817] = "Shimra", [6301] = "Gorbold Mano de Acero", [8363] = "Shadi Correbruma", [11189] = "Qia" },
	esMX = { [66] = "Tharynn Bouden", [1148] = "Nerrist", [1250] = "Draco Lindgren", [1286] = "Edna Mullby", [2118] = "Abigail Shiel", [2381] = "Micha Yance", [2393] = "Christoph Jeffcoat", [3081] = "Wunna Crinoscura", [3367] = "Felika", [4229] = "Mythrin'dir", [4561] = "Daniel Bartlett", [4775] = "Felicia Doan", [4897] = "Helenia Olden", [5817] = "Shimra", [6301] = "Gorbold Mano de Acero", [8363] = "Shadi Correbruma", [11189] = "Qia" },
	ptBR = { [66] = "Tirso Boal", [1148] = "Nerrist", [1250] = "Draco Lindgren", [1286] = "Edna Malheiros", [2118] = "Sheila Abigail", [2381] = "Micha Yance", [2393] = "Cristóvão Casaqueiro", [3081] = "Vunna Crina Negra", [3367] = "Felika", [4229] = "Mythrin'dir", [4561] = "Daniel Bartolotto", [4775] = "Felícia Doan", [4897] = "Heleninha Roydman", [5817] = "Shimra", [6301] = "Gorbold Manácero", [8363] = "Shadi Corre com a Névoa", [11189] = "Qia" },
	ruRU = { [66] = "Таринн Боуден", [1148] = "Неррист", [1250] = "Дрейк Линдгрен", [1286] = "Эдна Милби", [2118] = "Эбигейл Шиль", [2381] = "Мика Янс", [2393] = "Кристоф Френч", [3081] = "Вунна Темная Грива", [3367] = "Фелика", [4229] = "Митрин'дир", [4561] = "Даниэль Бартлетт", [4775] = "Фелиция Доан", [4897] = "Еления Ольден", [5817] = "Шимра", [6301] = "Горбольд Сталерук", [8363] = "Шади Вестница Туманов", [11189] = "Кийя" },
}
