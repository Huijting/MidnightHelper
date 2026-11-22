local _, ns = ...

--[[
	ForeverReagentSourceData.lua - WoW Forever 1.60.1.71037: where you get a crafting reagent (87 items, 22 Nov 2026).
	Rob via sparring 22 Nov 2026, verbatim: "1 b", "plek ja", "Zygor b". NOTHING from Zygor, Polestar or FlowUp.
	An item is in here only with two sources that agree:
	  gathered = AllTheThings' Forever database + the Wowhead Forever tooltip of the node ("Requires Mining")
	  sold     = AllTheThings' seller lists + Rob's own client (Auctionator's vendor price cache) or the Wowhead
	             Forever item page. Sellers = only AllTheThings' lists, and only those MH already has a point for
	             (ForeverVendorSpots.lua, Wowhead Forever).
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

-- [item] = "H" Herbalism, "M" Mining
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
}
-- [item] = the npc ids that sell it
ns.REAGENT_SOLD_BY = {
	[2320] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Coarse Thread
	[2321] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Fine Thread
	[2324] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Bleach
	[2325] = { 3367, 4561, 5817, 8363 }, -- Black Dye
	[2604] = { 66, 1250, 2118, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Red Dye
	[2605] = { 3367, 4561, 4775, 5817, 8363 }, -- Green Dye
	[2678] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Mild Spices
	[2692] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Hot Spices
	[2880] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Weak Flux
	[3371] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Empty Vial
	[3372] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Leaded Vial
	[3466] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Strong Flux
	[3713] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Soothing Spices
	[3857] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Coal
	[4289] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Salt
	[4291] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Silken Thread
	[4340] = { 3367, 4561, 5817, 8363 }, -- Gray Dye
	[4341] = { 3367, 4561, 5817, 8363 }, -- Yellow Dye
	[4342] = { 3367, 4561, 5817, 8363 }, -- Purple Dye
	[4399] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Wooden Stock
	[4536] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Shiny Red Apple
	[6217] = { 66, 1250, 2118, 2381, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Copper Rod
	[6260] = { 66, 1250, 2118, 3081, 3367, 4561, 4775, 5817, 8363 }, -- Blue Dye
	[6530] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Nightcrawlers
	[8343] = { 3367, 4561, 5817, 8363 }, -- Heavy Silken Thread
	[8925] = { 2381, 3367, 4561, 4775, 5817, 8363 }, -- Crystal Vial
}
ns.REAGENT_GATHER_NAMES = {
	enUS = { H = "Herbalism", M = "Mining" },
	deDE = { H = "Kräuterkunde", M = "Bergbau" },
	frFR = { H = "Herboristerie", M = "Minage" },
	esES = { H = "Botánica", M = "Minería" },
	esMX = { H = "Herboristería", M = "Minería" },
	ptBR = { H = "Herborismo", M = "Mineração" },
	ruRU = { H = "Травничество", M = "Горное дело" },
}
ns.REAGENT_SELLER_NAMES = {
	enUS = { [66] = "Tharynn Bouden", [1250] = "Drake Lindgren", [2118] = "Abigail Shiel", [2381] = "Micha Yance", [3081] = "Wunna Darkmane", [3367] = "Felika", [4561] = "Daniel Bartlett", [4775] = "Felicia Doan", [5817] = "Shimra", [8363] = "Shadi Mistrunner" },
	deDE = { [66] = "Tharynn Bouden", [1250] = "Drake Lindgren", [2118] = "Abigail Shiel", [2381] = "Micha Yance", [3081] = "Wunna Darkmane", [3367] = "Felika", [4561] = "Daniel Bartlett", [4775] = "Felicia Doan", [5817] = "Shimra", [8363] = "Shadi Mistrunner" },
	frFR = { [66] = "Tharynn Bouden", [1250] = "Drake Lindgren", [2118] = "Abigail Shiel", [2381] = "Micha Yance", [3081] = "Wunna Darkmane", [3367] = "Felika", [4561] = "Daniel Bartlett", [4775] = "Felicia Doan", [5817] = "Shimra", [8363] = "Shadi Mistrunner" },
	esES = { [66] = "Tharynn Bouden", [1250] = "Draco Lindgren", [2118] = "Abigail Shiel", [2381] = "Micha Yance", [3081] = "Wunna Crinoscuro", [3367] = "Felika", [4561] = "Daniel Bartlett", [4775] = "Felicia Doan", [5817] = "Shimra", [8363] = "Shadi Correbruma" },
	esMX = { [66] = "Tharynn Bouden", [1250] = "Draco Lindgren", [2118] = "Abigail Shiel", [2381] = "Micha Yance", [3081] = "Wunna Crinoscura", [3367] = "Felika", [4561] = "Daniel Bartlett", [4775] = "Felicia Doan", [5817] = "Shimra", [8363] = "Shadi Correbruma" },
	ptBR = { [66] = "Tirso Boal", [1250] = "Draco Lindgren", [2118] = "Sheila Abigail", [2381] = "Micha Yance", [3081] = "Vunna Crina Negra", [3367] = "Felika", [4561] = "Daniel Bartolotto", [4775] = "Felícia Doan", [5817] = "Shimra", [8363] = "Shadi Corre com a Névoa" },
	ruRU = { [66] = "Таринн Боуден", [1250] = "Дрейк Линдгрен", [2118] = "Эбигейл Шиль", [2381] = "Мика Янс", [3081] = "Вунна Темная Грива", [3367] = "Фелика", [4561] = "Даниэль Бартлетт", [4775] = "Фелиция Доан", [5817] = "Шимра", [8363] = "Шади Вестница Туманов" },
}
