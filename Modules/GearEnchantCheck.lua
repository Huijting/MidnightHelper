--[[
	Gear Enchant Check (Rob-wens 15 jun, uitgebreid 15 jun #2). Scant je uitgeruste,
	enchantbare slots, vlagt slots zonder enchant, en stelt per slot een Midnight-
	enchant voor op basis van de top-secundaire-stat van je spec (hergebruikt de
	Vault Advisor-stat-weights, ns.VAULT_ADVISOR_SPEC_WEIGHTS).

	Elke suggestie is een klikbare/hoverbare link (tooltip via spell-/item-link).
	Klik op een suggestie → de naam landt in het kopieerveld onderaan, voorge-
	selecteerd voor Ctrl+C (handig voor een Auction House-zoekopdracht) — net als
	het consumables-paneel.

	Bron-posture (never-lie): enchant-namen/IDs uit Wowhead 12.0.7 (research 15 jun,
	zie SESSION_NOTES). Secundaire-stat-enchants (Haste/Crit/Mastery/Vers) zitten op
	RINGEN + een proc-WAPEN. HEAD en FEET hebben tertiary-keuze-enchants (Speed/
	Leech/Avoidance). CHEST geeft primary. LEGS gebruiken Leatherworking-armor-kits
	(Agi/Str) of Tailoring-spellthreads (Int). SHOULDER heeft optionele utility-
	enchants (effect nog te bevestigen, dus geen stat-claim). Het is een stat-
	gematchte suggestie, geen pure BiS — voor min-maxen een class-guide raadplegen.

	Taint-veilig: alleen read-only inventory + spec; geen beschermde calls.
]]

local _, ns = ...

-- Enchantbare uitrustingsslots in 12.0 (slotID → labelglobal). Blizzard-globals
-- zijn al gelokaliseerd, dus geen eigen slotnaam-vertalingen nodig.
local SLOTS = {
	{ id = 16, label = "WEAPONENCHANT_THROWN" }, -- main hand; fallback hieronder
	{ id = 5, label = "CHESTSLOT" },
	{ id = 1, label = "HEADSLOT" },
	{ id = 3, label = "SHOULDERSLOT" },
	{ id = 11, label = "FINGER0SLOT" },
	{ id = 12, label = "FINGER1SLOT" },
	{ id = 8, label = "FEETSLOT" },
	{ id = 7, label = "LEGSSLOT" },
}

-- Enchant-entries. sid = spell-ID (display + tooltip via GetSpellLinkMarkup); ah =
-- exacte item-naam voor de AH-zoekopdracht. Voor LEGS/SHOULDER gebruiken we iid
-- (item-ID) omdat dat fysieke items zijn (kit/spellthread/scroll).
local RING_BY_STAT = {
	haste = { sid = 1236088, ah = "Enchant Ring - Silvermoon's Alacrity" },
	crit = { sid = 1236074, ah = "Enchant Ring - Nature's Fury" },
	mastery = { sid = 1236060, ah = "Enchant Ring - Zul'jin's Mastery" },
	vers = { sid = 1236089, ah = "Enchant Ring - Silvermoon's Tenacity" },
}
--- Not keyed by stat, and that is the point: it raises crit EFFECTIVENESS rather than a
--- secondary stat, so it sits outside the by-stat table that could never have found it.
--- Spell id confirmed against Rob's client, 19 aug (`/mh spell 1236059`).
local RING_EFFECT = { sid = 1236059, ah = "Enchant Ring - Eyes of the Eagle" }
local WEAPON_BY_STAT = {
	haste = { sid = 1236067, ah = "Enchant Weapon - Berserker's Rage" },
	crit = { sid = 1236066, ah = "Enchant Weapon - Jan'alai's Precision" },
	mastery = { sid = 1236097, ah = "Enchant Weapon - Arcane Mastery" },
	vers = { sid = 1236081, ah = "Enchant Weapon - Worldsoul Tenacity" },
}
local CHEST_PRIMARY = { sid = 1236069, ah = "Enchant Chest - Mark of the Worldsoul" }

-- HEAD + FEET tertiary-keuze: Speed / Leech / Avoidance.
--- ⚠️ THESE COME IN TWO RANKS AND WE WERE RECOMMENDING THE CHEAP ONE. The plain versions
--- are what our own Enchanting guide calls a skill-up craft (`enUS.lua`, the 25-40 line),
--- and all six specs the stale-advice audit checked want the "Empowered" rank instead —
--- Rob's own helm was already wearing Empowered Rune of Avoidance while this table told
--- him to buy the other one.
---
--- Both ids confirmed against his client on 19 aug via `/mh spell`, not taken from the
--- guide pages that suggested them.
---
--- ✅ All three now confirmed. The first two came back named, which put the Empowered ids
--- exactly one above their plain versions (1236083→1236084, 1236070→1236071) and made
--- 1236056 the obvious third. It was still sent to the client before being written down,
--- and it came back "Enchant Helm - Empowered Hex of Leeching". The pattern was right —
--- which is not the same as it having been safe to assume, and is why the audit's own
--- unsourced id was the one thing it refused to hand over.
local HEAD_TERTIARY = {
	{ sid = 1236071, ah = "Enchant Helm - Empowered Blessing of Speed" },
	{ sid = 1236056, ah = "Enchant Helm - Empowered Hex of Leeching" },
	{ sid = 1236084, ah = "Enchant Helm - Empowered Rune of Avoidance" },
}
local FEET_TERTIARY = {
	{ sid = 1236085, ah = "Enchant Boots - Farstrider's Hunt" },
	{ sid = 1236072, ah = "Enchant Boots - Shaladrassil's Roots" },
	{ sid = 1236057, ah = "Enchant Boots - Lynx's Dexterity" },
}
-- LEGS: top-tier kit (Agi/Str) en spellthread (Int).
local LEG_AGISTR = { iid = 244640, ah = "Forest Hunter's Armor Kit" }
local LEG_INT = { iid = 240154, ah = "Arcanoweave Spellthread" }
--- SHOULDER: Speed-enchant.
---
--- ⚠️ THE AH STRING SAID "Shoulder" AND THE ITEM IS "Shoulders". One missing letter, and
--- the copy box handed the player a search that matches nothing — so the enchant looked
--- like it did not exist. Found by the stale-advice audit on 19 aug; every other slot's
--- prefix (`Enchant Ring -`, `Enchant Helm -`, `Enchant Boots -`, `Enchant Chest -`,
--- `Enchant Weapon -`) is correct, which is why nobody ever noticed this one.
---
--- A hand-typed name that nothing checks is a standing invitation to this bug. The right
--- repair is to ask the client for the item's own name by id — `C_Item.GetItemInfo` knows
--- it — rather than storing a second copy of a string the game already owns. Left as a
--- typo fix for now because the copy-box path feeds several slots and that is its own
--- change; noted here so it does not get forgotten.
local SHOULDER_OPT = { iid = 243962, ah = "Enchant Shoulders - Akil'zon's Swiftness" }

-- Midnight-gems (12.0.7, geverifieerd — zie docs/GEMS_12.0.7_DATA.md). Blue/rare,
-- prismatic (passen in elke socket), ilvl 295 "Flawless". Dual-stat: +16 hoofdstat
-- (mineraal) + 7 bijstat (prefix); mono-gem = +17. We raden de gem aan met +16 van
-- je top-secundaire-stat en +7 van je tweede-beste (key = "major|minor"). Item-ID's
-- 1-op-1 van de Wowhead-itempagina's (never-lie).
local GEM_BY_PAIR = {
	-- Amethyst = +16 Mastery
	["mastery|mastery"] = { iid = 240896, ah = "Flawless Masterful Amethyst" },
	["mastery|crit"]    = { iid = 240898, ah = "Flawless Deadly Amethyst" },
	["mastery|haste"]   = { iid = 240900, ah = "Flawless Quick Amethyst" },
	["mastery|vers"]    = { iid = 240902, ah = "Flawless Versatile Amethyst" },
	-- Garnet = +16 Critical Strike
	["crit|crit"]       = { iid = 240904, ah = "Flawless Deadly Garnet" },
	["crit|mastery"]    = { iid = 240908, ah = "Flawless Masterful Garnet" },
	["crit|haste"]      = { iid = 240906, ah = "Flawless Quick Garnet" },
	["crit|vers"]       = { iid = 240910, ah = "Flawless Versatile Garnet" },
	-- Peridot = +16 Haste
	["haste|haste"]     = { iid = 240888, ah = "Flawless Quick Peridot" },
	["haste|mastery"]   = { iid = 240892, ah = "Flawless Masterful Peridot" },
	["haste|crit"]      = { iid = 240890, ah = "Flawless Deadly Peridot" },
	["haste|vers"]      = { iid = 240894, ah = "Flawless Versatile Peridot" },
	-- Lapis = +16 Versatility
	["vers|vers"]       = { iid = 240912, ah = "Flawless Versatile Lapis" },
	["vers|mastery"]    = { iid = 240918, ah = "Flawless Masterful Lapis" },
	["vers|crit"]       = { iid = 240914, ah = "Flawless Deadly Lapis" },
	["vers|haste"]      = { iid = 240916, ah = "Flawless Quick Lapis" },
}

-- Slots die een socket kunnen hebben (we scannen ze allemaal; de echte check is of er
-- een LEGE socket in zit). Blizzard-slotnaam-globals zijn al gelokaliseerd.
local GEM_SLOTS = {
	{ id = 1, label = "HEADSLOT" },
	{ id = 2, label = "NECKSLOT" },
	{ id = 3, label = "SHOULDERSLOT" },
	{ id = 5, label = "CHESTSLOT" },
	{ id = 6, label = "WAISTSLOT" },
	{ id = 7, label = "LEGSSLOT" },
	{ id = 8, label = "FEETSLOT" },
	{ id = 9, label = "WRISTSLOT" },
	{ id = 10, label = "HANDSSLOT" },
	{ id = 11, label = "FINGER0SLOT" },
	{ id = 12, label = "FINGER1SLOT" },
	{ id = 13, label = "TRINKET0SLOT" },
	{ id = 14, label = "TRINKET1SLOT" },
	{ id = 15, label = "BACKSLOT" },
	{ id = 16, label = "WEAPON" },
	{ id = 17, label = "SECONDARYHANDSLOT" },
}

-- Eversong Diamond = epische "Thalassian Diamond"-socket-gem. UNIQUE-EQUIPPED: je kunt
-- er maar ÉÉN dragen over al je sockets. We raden de geverifieerde +32 Primary Stat
-- (Indecipherable, 240983) aan — klasse-agnostisch (jouw hoofdstat) en Class-Codex-pick.
-- De andere varianten (Powerful/Stoic/Telluric) hadden geen betrouwbare stat-regel op
-- Wowhead (één staat als bugged), dus die claimen we niet (never-lie).
local DIAMOND_REC = { iid = 240983, ah = "Indecipherable Eversong Diamond" }
-- Alle bekende Thalassian-Diamond-ID's (ilvl 295 + 278) — alleen voor "heb ik er al
-- een?"-detectie, zodat we niet om een tweede vragen (het is unique).
local DIAMOND_IDS = {
	[240983] = true, [240982] = true, -- Indecipherable
	[240967] = true, [240966] = true, -- Powerful
	[240971] = true, [240970] = true, -- Stoic
	[240969] = true, [240968] = true, -- Telluric
}

--------------------------------------------------------------------------------
-- Spec top-secundaire-stat (uit de Vault Advisor-weights)
--------------------------------------------------------------------------------

local function SpecWeightKey()
	if not (GetSpecialization and GetSpecializationInfo and UnitClass) then
		return nil
	end
	local specIndex = GetSpecialization()
	if not specIndex then
		return nil
	end
	local specID = GetSpecializationInfo(specIndex)
	local classFile = select(2, UnitClass("player"))
	if not (specID and classFile) then
		return nil
	end
	return ("%s_%d"):format(classFile, specID)
end

-- Levert "haste"/"crit"/"mastery"/"vers" of nil.
local function TopStat()
	local key = SpecWeightKey()
	local w = key and ns.VAULT_ADVISOR_SPEC_WEIGHTS and ns.VAULT_ADVISOR_SPEC_WEIGHTS[key]
	if not w then
		return nil
	end
	local best, bestStat
	for _, stat in ipairs({ "haste", "crit", "mastery", "vers" }) do
		local v = w[stat]
		if v and (not best or v > best) then
			best, bestStat = v, stat
		end
	end
	return bestStat
end

-- Volledige stat-rangschikking (top → laag) voor de gem-aanrader: order[1] = beste
-- secundaire stat, order[2] = tweede-beste. nil = onbekende spec/geen weights.
local function RankedStats()
	local key = SpecWeightKey()
	local w = key and ns.VAULT_ADVISOR_SPEC_WEIGHTS and ns.VAULT_ADVISOR_SPEC_WEIGHTS[key]
	if not w then
		return nil
	end
	local order = { "haste", "crit", "mastery", "vers" }
	table.sort(order, function(a, b)
		return (w[a] or 0) > (w[b] or 0)
	end)
	return order
end

-- Hoofdstat van de speler ("int"/"agi"/"str") = de hoogste van Str/Agi/Int. Bepaalt o.a.
-- de leg-enchant (Int → spellthread, Agi/Str → armor kit). nil = niet te bepalen.
local function PrimaryStat()
	if not UnitStat then
		return nil
	end
	local str = UnitStat("player", 1)
	local agi = UnitStat("player", 2)
	local int = UnitStat("player", 4)
	-- 12.x: in restricted content (follower dungeons, delves, rituals) player stats
	-- come back as SECRET values — comparing them taints execution and errors. Bail
	-- to "unknown"; callers already fall back to showing both leg enchants.
	local function secret(v)
		return issecretvalue ~= nil and v ~= nil and issecretvalue(v) == true
	end
	if secret(str) or secret(agi) or secret(int) then
		return nil
	end
	str, agi, int = str or 0, agi or 0, int or 0
	if int >= str and int >= agi then
		return "int"
	elseif agi >= str then
		return "agi"
	end
	return "str"
end

-- Aantal LEGE sockets op een uitgerust item (0 = geen lege sockets / geen item).
-- LET OP: GetItemStats geeft het TOTAAL aantal sockets van een item (uit de stat-
-- template, óók al gevuld) via de EMPTY_SOCKET_*-keys — niet alleen de lege. Daarom:
-- leeg = totaal − reeds gesockete gems (gem-ID's uit de item-link). (Fix Rob 24 jun:
-- gevulde sockets werden anders toch als EMPTY gevlagd.)
local function EmptySocketCount(slotId)
	local link = GetInventoryItemLink and GetInventoryItemLink("player", slotId)
	if not link then
		return 0
	end
	local stats
	if C_Item and C_Item.GetItemStats then
		stats = C_Item.GetItemStats(link)
	elseif GetItemStats then
		stats = {}
		GetItemStats(link, stats)
	end
	local total = 0
	if stats then
		for k, v in pairs(stats) do
			if type(k) == "string" and k:find("EMPTY_SOCKET") then
				total = total + (tonumber(v) or 0)
			end
		end
	end
	if total == 0 then
		return 0
	end
	-- Reeds gevulde gems tellen: de gem-velden in de link (gem1..gem4; 0 = leeg).
	local filled = 0
	local g1, g2, g3, g4 = link:match("item:%d+:%-?%d*:(%d*):(%d*):(%d*):(%d*)")
	for _, g in ipairs({ g1, g2, g3, g4 }) do
		local id = tonumber(g)
		if id and id ~= 0 then
			filled = filled + 1
		end
	end
	local empty = total - filled
	return empty > 0 and empty or 0
end

--------------------------------------------------------------------------------
-- /mh socket — kunnen we het socket-venster zelf openen?
--------------------------------------------------------------------------------

--[[
	Cisca wist niet hoe je een gem in een socket krijgt. Terecht: wij zeggen WELKE gem
	("socket 1× Eversong Diamond") en DAT er sockets leeg zijn, maar nergens hoe. Dat
	is een werkwoord dat je al moet kennen, en precies het soort gat waar deze addon
	voor bestaat — uitleggen, niet alleen tellen.

	Een knop die het venster gewoon opent is beter dan welke uitleg ook. Of dat mag, is
	geen kwestie van mening: `SocketInventoryItem` bestaat al jaren, maar 12.x heeft veel
	UI-acties beschermd, en dan faalt hij stil of met ADDON_ACTION_BLOCKED.

	⚠️ NIET UIT MIJN HOOFD BEANTWOORDEN. Deze probe vraagt het de client:
	   1. bestaat de functie?
	   2. is onze aanroep secure?
	   3. en — het enige dat echt telt — STAAT HET VENSTER OPEN na de aanroep?

	Stap 3 is er omdat 1 en 2 allebei "ja" kunnen zeggen terwijl er niets gebeurt. Een
	geslaagde pcall bewijst alleen dat er geen fout kwam, niet dat het werkte; dat is
	dezelfde val als een lege uitkomst voor een afwezigheid aanzien. Daarom wordt er een
	halve seconde later gekeken of `ItemSocketingFrame` zichtbaar is.
]]

function ns.ProbeSocketUI()
	local p = "|cffffff78Midnight Helper:|r"
	print(("%s socket-UI probe"):format(p))

	local fn = _G.SocketInventoryItem
	print(("   SocketInventoryItem: %s"):format(
		type(fn) == "function" and "|cff40c040bestaat|r" or "|cffff5040ONTBREEKT|r"))
	if type(fn) ~= "function" then
		print("   |cff8a8f98Dan is een knop uitgesloten en wordt het een uitleg-tekst.|r")
		return
	end
	print(("   onze aanroep is secure: %s"):format(
		(issecure and issecure()) and "ja" or "|cffe8c36anee (kan geblokkeerd worden)|r"))

	-- Het eerste uitgeruste slot met een lege socket, via dezelfde telling als het advies.
	local slotId, slotName
	for _, gs in ipairs(GEM_SLOTS) do
		if EmptySocketCount(gs.id) > 0 then
			-- `label` is een Blizzard-global ("HEADSLOT"), dus die geeft de speler zijn
			-- eigen slotnaam in zijn eigen taal; anders het nummer.
			slotId = gs.id
			slotName = (gs.label and _G[gs.label]) or ("slot " .. gs.id)
			break
		end
	end
	if not slotId then
		print("   |cff8a8f98Geen leeg socket uitgerust — doe dit met een item dat er wel een heeft,|r")
		print("   |cff8a8f98anders bewijst 'venster bleef dicht' niks.|r")
		return
	end
	print(("   probeert te openen voor: |cffffd100%s|r"):format(tostring(slotName)))

	local ok, err = pcall(fn, slotId)
	print(("   aanroep: %s"):format(ok and "geen fout" or ("|cffff5040" .. tostring(err) .. "|r")))

	-- ⚠️ Het bewijs. "Geen fout" is geen resultaat.
	if C_Timer and C_Timer.After then
		C_Timer.After(0.5, function()
			local f = _G.ItemSocketingFrame
			local shown = f and f.IsShown and f:IsShown()
			print(("   |cffffff78→|r venster open: %s"):format(
				shown and "|cff40c040JA — de knop kan|r" or "|cffff5040NEE — het wordt een uitleg-tekst|r"))
		end)
	end
end

-- Heeft de speler al ergens een Thalassian Diamond gesocket? (Gem-ID's uit de item-link:
-- item:itemID:enchant:gem1:gem2:gem3:gem4:...). Zo ja: niet om een tweede vragen.
local function HasDiamondEquipped()
	for _, gs in ipairs(GEM_SLOTS) do
		local link = GetInventoryItemLink and GetInventoryItemLink("player", gs.id)
		if link then
			local g1, g2, g3, g4 = link:match("item:%d+:%-?%d*:(%d*):(%d*):(%d*):(%d*)")
			for _, g in ipairs({ g1, g2, g3, g4 }) do
				local id = tonumber(g)
				if id and DIAMOND_IDS[id] then
					return true
				end
			end
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Inventory-scan
--------------------------------------------------------------------------------

-- true(item aanwezig), enchanted(bool) — uit de enchantID in de item-link.
local function SlotState(slotId)
	local link = GetInventoryItemLink and GetInventoryItemLink("player", slotId)
	if not link then
		return false, false
	end
	local enchantID = link:match("item:%d+:(%d*)")
	local has = enchantID and enchantID ~= "" and enchantID ~= "0"
	return true, has and true or false
end

--------------------------------------------------------------------------------
-- Link-rendering + AH-naam-registratie
--------------------------------------------------------------------------------

-- Gesockete gems van een item als klikbare links (echte item-links via GetItemGem).
-- Lege tabel = geen gems / geen socket.
local function SocketedGemLinks(link)
	local out = {}
	if not (link and GetItemGem) then
		return out
	end
	for i = 1, 4 do
		local name, gemLink = GetItemGem(link, i)
		if gemLink then
			out[#out + 1] = gemLink
		elseif name then
			out[#out + 1] = name
		end
	end
	return out
end

-- De toegepaste enchant-naam van een slot, gelezen uit de échte item-tooltip
-- (never-lie: we tonen wat het spel toont, geen ID-gok). De game zet de enchant op een
-- regel met het "Enchanted:"-voorvoegsel (ENCHANTED_TOOLTIP, gelokaliseerd) — dat is een
-- veel betrouwbaarder anker dan op kleur gokken (Midnight kleurt item-stats óók groen,
-- en tertiaries als "Indestructible" zijn groene namen). We pakken die regel en strippen
-- het voorvoegsel. nil = niet gevonden (dan tonen we alleen "enchanted").
local function SlotEnchantText(slotId)
	if not (C_TooltipInfo and C_TooltipInfo.GetInventoryItem) then
		return nil
	end
	local data = C_TooltipInfo.GetInventoryItem("player", slotId)
	if not (data and data.lines) then
		return nil
	end
	local prefix = (ENCHANTED_TOOLTIP or "Enchanted: %s"):gsub("%%s.*$", "")
	if prefix == "" then
		prefix = "Enchanted:"
	end
	for _, line in ipairs(data.lines) do
		if TooltipUtil and TooltipUtil.SurfaceArgs then
			TooltipUtil.SurfaceArgs(line)
		end
		local t = line.leftText
		if t and t:find(prefix, 1, true) == 1 then
			local name = t:sub(#prefix + 1):gsub("^%s+", "")
			return name ~= "" and name or nil
		end
	end
	return nil
end

-- Rendert een enchant-entry als klikbare link en registreert de AH-naam onder
-- de link-key ("spell:ID" / "item:ID") in `map` zodat een klik 'm kan kopiëren.
local function LinkOf(map, e)
	if not e then
		return "?"
	end
	if e.sid then
		if map then
			map["spell:" .. e.sid] = e.ah
		end
		if ns.GetSpellLinkMarkup then
			return ns:GetSpellLinkMarkup(e.sid, e.ah)
		end
		return e.ah or ("spell " .. tostring(e.sid))
	elseif e.iid then
		if map then
			map["item:" .. e.iid] = e.ah
		end
		if ns.GetItemLinkMarkup then
			return ns:GetItemLinkMarkup(e.iid, e.ah)
		end
		return e.ah or ("item " .. tostring(e.iid))
	end
	return e.ah or "?"
end

-- Aanbevolen enchant-tekst (gerenderde links) per slot, of nil = geen suggestie.
local function Recommend(slotId, stat, map)
	if slotId == 16 then
		return stat and WEAPON_BY_STAT[stat] and LinkOf(map, WEAPON_BY_STAT[stat]) or nil
	elseif slotId == 11 or slotId == 12 then
		--- ⚠️ THE WHOLE RING MODEL WAS THE WRONG SHAPE, not merely missing a row. We picked
		--- a ring by your best secondary stat, so a ring enchant that grants no secondary
		--- stat could never be suggested by construction — and Eyes of the Eagle, which
		--- raises critical strike EFFECTIVENESS, is what five of the six specs the audit
		--- checked actually want. Only Prot Paladin took a flat-stat ring.
		---
		--- Confirmed by Rob's client on 19 aug: `/mh spell 1236059` came back "Enchant Ring
		--- - Eyes of the Eagle". The four stat rings stay as the alternative, because a
		--- guide majority is not a rule and the footer already says to check a class guide
		--- for true best-in-slot.
		local first = LinkOf(map, RING_EFFECT)
		local byStat = stat and RING_BY_STAT[stat] and LinkOf(map, RING_BY_STAT[stat]) or nil
		if byStat then
			return ns:L("ENCHANT_PICK") .. " " .. first .. " / " .. byStat
		end
		return first
	elseif slotId == 5 then
		return LinkOf(map, CHEST_PRIMARY)
	elseif slotId == 1 then -- head: tertiary keuze
		local parts = {}
		for _, e in ipairs(HEAD_TERTIARY) do
			parts[#parts + 1] = LinkOf(map, e)
		end
		return ns:L("ENCHANT_PICK") .. " " .. table.concat(parts, " / ")
	elseif slotId == 8 then -- feet: tertiary keuze
		local parts = {}
		for _, e in ipairs(FEET_TERTIARY) do
			parts[#parts + 1] = LinkOf(map, e)
		end
		return ns:L("ENCHANT_PICK") .. " " .. table.concat(parts, " / ")
	elseif slotId == 7 then -- legs: kies op hoofdstat (Int → spellthread, Agi/Str → kit)
		local p = PrimaryStat()
		if p == "int" then
			return LinkOf(map, LEG_INT)
		elseif p == "agi" or p == "str" then
			return LinkOf(map, LEG_AGISTR)
		end
		-- Onbekend: toon beide met labels als veilige fallback.
		return ns:L("ENCHANT_LEGS_AGISTR")
			.. " "
			.. LinkOf(map, LEG_AGISTR)
			.. "   "
			.. ns:L("ENCHANT_LEGS_INT")
			.. " "
			.. LinkOf(map, LEG_INT)
	end
	return nil
end

-- Aanbevolen gem: +16 top-stat (mineraal) + 7 tweede-stat (prefix). Gerenderde link
-- (klikbaar → AH-naam) of nil als de spec/weights onbekend zijn (never-lie: geen gok).
local function RecommendGem(map)
	local r = RankedStats()
	if not r then
		return nil
	end
	local e = GEM_BY_PAIR[r[1] .. "|" .. r[2]]
	return e and LinkOf(map, e) or nil
end

--------------------------------------------------------------------------------
-- Rapport-regels (gedeeld door paneel + /mh enchants)
--------------------------------------------------------------------------------

-- @param map table|nil  ontvangt link-key → AH-naam (alleen nodig voor 't paneel)
-- @return table lines
local function BuildReportLines(map)
	local lines = {}
	local stat = TopStat()
	local statLabel = stat and ns:L("ENCHANT_STAT_" .. string.upper(stat)) or "?"
	lines[#lines + 1] = "|cffe8c36a" .. ns:L("ENCHANT_HEADER_FMT"):format(statLabel) .. "|r"
	for _, s in ipairs(SLOTS) do
		local hasItem, enchanted = SlotState(s.id)
		if hasItem then
			local label = (s.id == 16 and (_G.WEAPON or "Weapon")) or _G[s.label] or s.label
			if s.id == 3 then
				-- Shoulder: optioneel. Toon altijd de optionele utility-suggestie,
				-- geen rode MISSING-alarm (effect onbevestigd → geen stat-claim).
				local rec = LinkOf(map, SHOULDER_OPT)
				lines[#lines + 1] = ("|cffc8b88a%s — %s %s|r"):format(label, ns:L("ENCHANT_SHOULDER_OPT"), rec)
			elseif enchanted then
				local ench = SlotEnchantText(s.id)
				local tail = ench and (": " .. ench) or ""
				-- Ook bij een al-geënchant slot de aanbevolen enchant tonen (klikbare
				-- link), zodat je je huidige enchant kunt vergelijken (Rob 24 jun).
				local rec = Recommend(s.id, stat, map)
				local recTail = rec and ("  " .. ns:L("ENCHANT_RECOMMEND") .. " " .. rec) or ""
				lines[#lines + 1] = ("|cff8cd98c%s — %s%s|r%s"):format(label, ns:L("ENCHANT_OK"), tail, recTail)
			else
				local rec = Recommend(s.id, stat, map)
				local tail = rec and ("  " .. ns:L("ENCHANT_RECOMMEND") .. " " .. rec) or ""
				lines[#lines + 1] = ("|cffe66b6b%s — %s|r%s"):format(label, ns:L("ENCHANT_MISSING"), tail)
			end
		end
	end

	-- Witregels tussen de enchant- en gem-sectie voor lucht (Rob 24 jun).
	lines[#lines + 1] = " "
	lines[#lines + 1] = " "

	-- Gem-sectie: 1× unieke Eversong Diamond (+32 primary) + secundaire dual-gems in
	-- de overige sockets. Toont per slot de gesockete gem(s) én eventuele lege sockets.
	local ranked = RankedStats()
	local s1 = ranked and ranked[1]
	local s2 = ranked and ranked[2]
	local s1L = s1 and ns:L("ENCHANT_STAT_" .. string.upper(s1)) or "?"
	local s2L = s2 and ns:L("ENCHANT_STAT_" .. string.upper(s2)) or "?"
	lines[#lines + 1] = "|cffe8c36a" .. ns:L("GEM_HEADER_FMT"):format(s1L, s2L) .. "|r"
	local gemRec = RecommendGem(map)
	local diamondLink = LinkOf(map, DIAMOND_REC)
	-- Best-setup: 1 diamant (uniek) + secundair in de rest.
	if gemRec then
		lines[#lines + 1] = ("|cffc8b88a%s|r"):format(ns:L("GEM_BEST_FMT"):format(diamondLink, gemRec))
	end
	local foundEmpty = false
	for _, gs in ipairs(GEM_SLOTS) do
		local link = GetInventoryItemLink and GetInventoryItemLink("player", gs.id)
		if link then
			local label = (gs.id == 16 and (_G.WEAPON or "Weapon")) or _G[gs.label] or gs.label
			-- Gesockete gem(s) tonen (groen, klikbare gem-links).
			local gems = SocketedGemLinks(link)
			if #gems > 0 then
				lines[#lines + 1] = ("|cff8cd98c%s — %s|r"):format(label, table.concat(gems, ", "))
			end
			-- Lege sockets vlaggen (rood + aanrader).
			local n = EmptySocketCount(gs.id)
			if n > 0 then
				foundEmpty = true
				local cnt = n > 1 and (" ×" .. n) or ""
				local tail = gemRec and ("  " .. ns:L("ENCHANT_RECOMMEND") .. " " .. gemRec) or ""
				lines[#lines + 1] = ("|cffe66b6b%s — %s%s|r%s"):format(label, ns:L("GEM_MISSING"), cnt, tail)
			end
		end
	end
	-- Mis je je unieke diamant nog? Eén keer aanstippen (geen tweede; unique-equipped).
	if not HasDiamondEquipped() then
		lines[#lines + 1] = ("|cffe6c86b%s|r"):format(ns:L("GEM_NO_DIAMOND"):format(diamondLink))
	end
	if not foundEmpty then
		lines[#lines + 1] = ("|cff8cd98c%s|r"):format(ns:L("GEM_OK"))
	end

	lines[#lines + 1] = "|cff9aa0a8" .. ns:L("ENCHANT_FOOTER") .. "|r"
	return lines
end

-- /mh enchants (blijft als handig commando; standaard-route is het paneel).
--- Compact counts for the character side panel: missing enchants, empty sockets.
--- Returns nil, nil when nothing could be read, so a caller can stay silent rather
--- than announce a confident "0 problems" it has no basis for.
---
--- Counts only slots that actually HAVE an item: an empty slot has no missing
--- enchant, it has no item. Reuses SlotState/EmptySocketCount so the panel and the
--- full report can never disagree — one source of truth per fact.
function ns.GetGearEnchantSummary()
	if not GetInventoryItemLink then
		return nil, nil
	end
	local sawItem = false
	local missing, sockets = 0, 0
	for _, s in ipairs(SLOTS) do
		local has, enchanted = SlotState(s.id)
		if has then
			sawItem = true
			if not enchanted then
				missing = missing + 1
			end
		end
	end
	for _, gs in ipairs(GEM_SLOTS) do
		local n = EmptySocketCount(gs.id)
		if n and n > 0 then
			sockets = sockets + n
		end
	end
	if not sawItem then
		return nil, nil -- nothing readable; say nothing
	end
	return missing, sockets
end

function ns.PrintGearEnchantCheck()
	print(("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX")))
	for _, line in ipairs(BuildReportLines(nil)) do
		print("  " .. line)
	end
end

--------------------------------------------------------------------------------
-- Paneel (tab "enchants")
--------------------------------------------------------------------------------

local ui

--- The first equipped slot with an empty socket, or nil.
---
--- Shared by the button and its own enable/disable, so the button can never offer to
--- open a window for a slot the report is not complaining about.
local function FirstEmptySocketSlot()
	for _, gs in ipairs(GEM_SLOTS) do
		if EmptySocketCount(gs.id) > 0 then
			return gs.id, (gs.label and _G[gs.label]) or ("slot " .. gs.id)
		end
	end
	return nil
end

function ns.RefreshGearEnchantPanel()
	if not (ui and ui.body) then
		return
	end
	ui.linkAH = ui.linkAH or {}
	wipe(ui.linkAH)
	ui.body:SetText(table.concat(BuildReportLines(ui.linkAH), "|n"))

	--- ⚠️ THE BUTTON ONLY EXISTS WHEN THERE IS SOMETHING TO SOCKET. Cisca did not know
	--- how to get a gem into a socket, and "socket 1x Eversong Diamond" is a verb you
	--- have to already know. A button that opens the window is the answer, but a button
	--- that is always there and does nothing when you have no empty socket teaches the
	--- opposite lesson — that our buttons are unreliable.
	if ui.socketBtn then
		local slotId, slotName = FirstEmptySocketSlot()
		ui.socketSlot = slotId
		if slotId then
			ui.socketBtn:SetText((ns:L("GEM_OPEN_SOCKET_FMT")):format(slotName))
			ui.socketBtn:SetWidth(ui.socketBtn:GetTextWidth() + 30)
			ui.socketBtn:Show()
		else
			ui.socketBtn:Hide()
		end
	end
end

function ns.BuildGearEnchantPanel(panel)
	if not panel or panel._mhEnchantBuilt then
		return
	end
	panel._mhEnchantBuilt = true
	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -12)
	title:SetText(ns:L("TAB_ENCHANTS"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -14, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.75, 0.78, 0.82)
	subtitle:SetText(ns:L("ENCHANT_SUBTITLE"))

	-- Kopieerbalk onderaan (consumables-patroon): klik een suggestie → naam hier,
	-- voorgeselecteerd voor Ctrl+C (AH-zoekopdracht).
	local copyLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	copyLabel:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	copyLabel:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 14, 16)
	copyLabel:SetJustifyH("LEFT")
	copyLabel:SetText(ns:L("ENCHANT_COPY_LABEL"))
	copyLabel:SetTextColor(0.62, 0.60, 0.55)

	--- "Open the socket window" — measured on 19 aug before it was written. `/mh socket`
	--- reported the frame actually on screen after the call, not merely that the call did
	--- not error, because 12.x has protected a great many UI actions and a protected one
	--- fails quietly. It opened, so the button is honest.
	---
	--- Sits above the copy bar rather than in the report text: the report is a read-only
	--- EditBox whose links go to the auction-house copy box, and threading an action into
	--- that would make one click mean two things.
	local socketBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	socketBtn:SetHeight(22)
	socketBtn:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 14, 44)
	socketBtn:Hide() -- Refresh decides; there may be nothing to socket
	socketBtn:SetScript("OnClick", function()
		local slotId = ui and ui.socketSlot
		if not slotId or not SocketInventoryItem then
			return
		end
		-- Guarded: if 12.x ever protects this, the click must do nothing rather than
		-- throw a Lua error at someone who only wanted help with a gem.
		pcall(SocketInventoryItem, slotId)
	end)

	local copyBox = CreateFrame("EditBox", "MidnightHelperEnchantCopyBox", panel, "InputBoxTemplate")
	copyBox:SetHeight(20)
	copyBox:SetPoint("LEFT", copyLabel, "RIGHT", 10, 0)
	copyBox:SetPoint("RIGHT", panel, "RIGHT", -18, 0)
	copyBox:SetAutoFocus(false)
	copyBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	copyBox:SetScript("OnEditFocusGained", function(self)
		self:HighlightText()
	end)

	-- Read-only EditBox → klikbare/hoverbare enchant-links.
	local body = CreateFrame("EditBox", nil, panel)
	body:SetMultiLine(true)
	body:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	body:SetJustifyH("LEFT")
	body:SetAutoFocus(false)
	body:EnableMouse(true)
	body:SetSpacing(6)
	if body.SetMaxLetters then
		body:SetMaxLetters(0)
	end
	body:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
	body:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -16, 42)
	body:SetScript("OnEscapePressed", body.ClearFocus)
	if ns.AttachDelveTipHyperlinksToEditBox then
		ns:AttachDelveTipHyperlinksToEditBox(body)
	end

	ui = { panel = panel, title = title, subtitle = subtitle, body = body, copyBox = copyBox, copyLabel = copyLabel, socketBtn = socketBtn, linkAH = {} }

	-- Klik op een enchant-link → AH-naam naar de kopieerbalk (val terug op de
	-- tooltip-handler als we de link niet kennen).
	body:SetScript("OnHyperlinkClick", function(_, linkData)
		local name = ui.linkAH and ui.linkAH[linkData]
		if name and name ~= "" then
			copyBox:SetText(name)
			copyBox:SetFocus()
			copyBox:HighlightText()
		end
	end)

	panel:SetScript("OnShow", function()
		ns.RefreshGearEnchantPanel()
	end)

	local ev = CreateFrame("Frame")
	ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	-- Een enchant op een al-gedragen stuk wisselt het item niet, dus
	-- PLAYER_EQUIPMENT_CHANGED vuurt niet — UNIT_INVENTORY_CHANGED (speler) wél.
	ev:RegisterEvent("UNIT_INVENTORY_CHANGED")
	ev:SetScript("OnEvent", function(_, event, unit)
		if event == "UNIT_INVENTORY_CHANGED" and unit and unit ~= "player" then
			return
		end
		if ui and ui.panel and ui.panel:IsShown() then
			-- Korte vertraging: de item-link toont de nieuwe enchantID soms pas een frame later.
			if C_Timer and C_Timer.After then
				C_Timer.After(0.1, ns.RefreshGearEnchantPanel)
			else
				ns.RefreshGearEnchantPanel()
			end
		end
	end)

	ns.RefreshGearEnchantPanel()
end

-- Titel/subtitel meeverversen bij taalwissel.
do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_ENCHANTS"))
			ui.subtitle:SetText(ns:L("ENCHANT_SUBTITLE"))
			if ui.copyLabel then
				ui.copyLabel:SetText(ns:L("ENCHANT_COPY_LABEL"))
			end
			if ui.panel and ui.panel:IsShown() then
				ns.RefreshGearEnchantPanel()
			end
		end
	end
end
