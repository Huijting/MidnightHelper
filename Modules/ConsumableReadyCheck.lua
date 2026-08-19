--[[
	Consumable Ready Check — Fase 1 (Rob, 19 jun 2026).

	Bij het betreden van een dungeon: kijkt of jij (en je groep) klaar zijn met
	consumables. Twee detectie-niveaus, exact zoals de feasibility-analyse
	(docs/CONSUMABLES_READYCHECK_PLAN.md) beschrijft:

	  • EIGEN personage (volledig): tas-aanwezigheid via C_Item.GetItemCount over
	    de bestaande item-ID-lijsten in ns.ConsumablesWowheadByClassSpec, plus
	    "buff actief?" via aura-inspectie van jezelf.
	  • GROEPSLEDEN (alleen buffs): je kunt NIET in hun tassen kijken (API staat
	    dat niet toe). Wel hun ACTIEVE flask/augment-rune-buff lezen via
	    C_UnitAuras. Tas-aanwezigheid van anderen vergt addon-comms → Fase 2.

	Bron-posture (never-lie): we hardcoden GEEN buff-spell-ID's (die wisselen per
	patch). In plaats daarvan leiden we de buff-spell af uit de item-ID via
	C_Item.GetItemSpell — voor flasks/phials en augment runes is de use-spell
	gelijk aan de aura die hij oplegt. Zo blijft de set vanzelf actueel met de
	consumables-data. Lukt dat (nog) niet — item-info niet gecached, of een
	consumable waarvan de use-spell afwijkt van de aura — dan tonen we "?" (status
	onbekend), nooit een vals "ontbreekt". Met /mh auradump kun je live de
	werkelijke buff-spell-ID's van je actieve auras uitlezen ter controle.

	Taint-veilig: uitsluitend read-only inventory + auras; geen beschermde calls.
]]

local _, ns = ...

-- Healthstone (Warlock): klassieke item-ID, al jaren stabiel. Staat niet in de
-- consumables-data (geen class/spec-consumable), dus hier apart. Te verifiëren
-- met /mh auradump-broertje GetItemCount als Blizzard 'm ooit hernummert.
local HEALTHSTONE_IDS = { 5512 }

-- Markeringskleuren (zelfde palet als GearEnchantCheck).
local C_OK, C_BAD, C_UNK = "8cd98c", "e66b6b", "9aa0a8"

local function Col(hex, s)
	return ("|cff%s%s|r"):format(hex, s)
end

-- Ready-check-texturen renderen overal (Unicode ✓/✗ werden tofu in de WoW-
-- chatfont). true = groene check, false = rode X, nil = geel vraagteken.
local ICON_OK = "|TInterface/RAIDFRAME/ReadyCheck-Ready:0|t"
local ICON_BAD = "|TInterface/RAIDFRAME/ReadyCheck-NotReady:0|t"
local ICON_UNK = "|TInterface/RAIDFRAME/ReadyCheck-Waiting:0|t"

local function Mark(state)
	if state == true then
		return ICON_OK
	elseif state == false then
		return ICON_BAD
	end
	return ICON_UNK
end

--------------------------------------------------------------------------------
-- Inventory- en aura-helpers (alle API's geguard + pcall, per .cursorrules)
--------------------------------------------------------------------------------

local function ItemCount(itemID)
	if not itemID then
		return nil
	end
	if C_Item and C_Item.GetItemCount then
		local ok, n = pcall(C_Item.GetItemCount, itemID)
		if ok then
			return n
		end
	end
	if GetItemCount then
		local ok, n = pcall(GetItemCount, itemID)
		if ok then
			return n
		end
	end
	return nil
end

-- Som van een lijst item-ID's in je tassen. @return hasAny(bool), totalCount(num)
local function BagCount(ids)
	if type(ids) ~= "table" then
		return nil, 0
	end
	local total = 0
	local known = false
	for i = 1, #ids do
		local n = ItemCount(ids[i])
		if n ~= nil then
			known = true
			total = total + n
		end
	end
	if not known then
		return nil, 0
	end
	return total > 0, total
end

-- Use-spell van een item (= de aura die flask/rune oplegt). @return spellID|nil
local function ItemUseSpellID(itemID)
	if not itemID then
		return nil
	end
	if C_Item and C_Item.GetItemSpell then
		local ok, _name, sid = pcall(C_Item.GetItemSpell, itemID)
		if ok and sid then
			return sid
		end
	end
	if GetItemSpell then
		local ok, _name, sid = pcall(GetItemSpell, itemID)
		if ok and sid then
			return sid
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- Buff-spell-sets (afgeleid uit de bestaande consumables-data, lazy gebouwd)
--------------------------------------------------------------------------------

local flaskBuffSet, runeBuffSet
local buffSetsReady = false

local function AddCategorySpells(catName, set)
	local data = ns.ConsumablesWowheadByClassSpec
	if type(data) ~= "table" then
		return
	end
	for _, specs in pairs(data) do
		if type(specs) == "table" then
			for _, spec in pairs(specs) do
				local cat = type(spec) == "table" and spec[catName]
				if type(cat) == "table" then
					for _, list in ipairs({ cat.best or {}, cat.alternates or {} }) do
						for i = 1, #list do
							local sid = ItemUseSpellID(list[i])
							if sid then
								set[sid] = true
							end
						end
					end
				end
			end
		end
	end
end

-- Bouwt de flask/rune buff-spell-sets uit de itemdata. Pas "klaar" als er
-- daadwerkelijk iets in zit (item-info kan nog ongecached zijn bij login).
local function EnsureBuffSets()
	if buffSetsReady and flaskBuffSet and next(flaskBuffSet) then
		return
	end
	flaskBuffSet, runeBuffSet = {}, {}
	AddCategorySpells("flask", flaskBuffSet)
	AddCategorySpells("augmentRune", runeBuffSet)
	-- (Food-buff/Well-Fed bewust NIET gedetecteerd: in 12.x is de aura secret en de
	-- food-item-spell is de "eet"-actie, niet de Well-Fed-buff → onbetrouwbaar.
	-- Food blijft daarom alleen-tas. Rob bevestigde de false-negative 21 jun.)
	if next(flaskBuffSet) or next(runeBuffSet) then
		buffSetsReady = true
	end
end

-- Scant een unit op een HELPFUL-aura uit `set`.
-- @return true/false (buff aan/uit), of nil als de set leeg is (status onbekend).
local function UnitHasBuffFromSet(unit, set)
	if type(set) ~= "table" or not next(set) then
		return nil
	end
	-- 12.x: aura.spellId is een 'secret value' → je mag er GEEN tabel mee indexen
	-- (set[aura.spellId] crasht: "cannot be indexed with secret keys"). Daarom de
	-- lookup omdraaien: per BEKENDE spell-ID vragen of de speler die buff heeft.
	-- GetPlayerAuraBySpellID neemt jouw eigen, niet-secret ID → secret-veilig.
	if unit == "player" then
		local anyReadable = false
		for spellID in pairs(set) do
			local has = ns.Aura.HasPlayerAura(spellID)
			if has == true then
				return true
			elseif has == false then
				anyReadable = true
			end
		end
		-- Nothing found. Only call that "no" if at least one lookup actually answered.
		return anyReadable and false or nil
	end
	-- Andere units: hun aura-spellId's zijn secret en niet te matchen → onbekend
	-- (MH-gebruikers vullen dit via comms; niet-MH blijft "?").
	return nil
end

-- Well-Fed-detectie via ICON-ID i.p.v. spell-ID. Techniek geleend van
-- ReadyCheckConsumables (en het bevestigt Robs iconID-idee 21 jun): ÁLLE
-- food-Well-Fed-buffs delen icon 136000, ongeacht welk food. Dus we hoeven geen
-- per-food spell-ID's te kennen — we scannen de helpful auras en matchen het
-- icon. Secret-guard op spellID én icon (12.x: een secret als tabel-key/compare
-- crasht). Omdat dit ALLE foods dekt, is "niet gevonden" = écht niet Well Fed
-- (gewoon rood, geen "?" meer nodig).
local WELL_FED_ICON = 136000

-- @return true (Well Fed) / false (niet) / nil (kon de auras niet lezen).
local function PlayerWellFed()
	local fed = false
	local scanned = ns.Aura.ForEachPlayerBuff(function(aura)
		local sid = aura.spellId
		if not (issecretvalue and issecretvalue(sid)) then
			local icon = aura.icon
			if icon and not (issecretvalue and issecretvalue(icon)) and icon == WELL_FED_ICON then
				fed = true
				return true -- stop
			end
		end
	end)
	if not scanned then
		return nil
	end
	return fed
end

--------------------------------------------------------------------------------
-- Spelercontext + groepslijst
--------------------------------------------------------------------------------

--- A unit's class token, or nil when the client will not say.
---
--- 12.1 (PTR 7, build 68914, 23 jul 2026) makes UnitClass return a SECRET when the
--- unit's identity is secret, alongside UnitSex, UnitRace and UnitIsPVP. A secret
--- cannot be compared and cannot be used as a table key -- `RAID_CLASS_COLORS[token]`
--- throws outright, which is exactly the crash that hit Cisca 23x in July (8356c9d).
--- Every caller in this file already copes with nil, so hand back nil.
local function ClassToken(unit)
	if not UnitClass then
		return nil
	end
	local ok, _, token = pcall(UnitClass, unit)
	if not ok or token == nil then
		return nil
	end
	if issecretvalue and issecretvalue(token) then
		return nil
	end
	return token
end

local function PlayerSpecData()
	local classToken = ClassToken("player")
	local specIndex = GetSpecialization and GetSpecialization()
	if not classToken or not specIndex then
		return nil
	end
	local byClass = ns.ConsumablesWowheadByClassSpec and ns.ConsumablesWowheadByClassSpec[classToken]
	return byClass and byClass[specIndex]
end

-- Best + alternates van een categorie als één id-lijst (voor de tas-telling).
local function CategoryItemIDs(specData, catName)
	local cat = specData and specData[catName]
	if type(cat) ~= "table" then
		return nil
	end
	local ids = {}
	for _, list in ipairs({ cat.best or {}, cat.alternates or {} }) do
		for i = 1, #list do
			ids[#ids + 1] = list[i]
		end
	end
	return ids
end

-- Food = personalFood + feast samen (beide tellen als "food bij je").
local function FoodItemIDs(specData)
	local ids = {}
	for _, catName in ipairs({ "personalFood", "feast" }) do
		local sub = CategoryItemIDs(specData, catName)
		if sub then
			for i = 1, #sub do
				ids[#ids + 1] = sub[i]
			end
		end
	end
	if #ids == 0 then
		return nil
	end
	return ids
end

-- Tas-tier voor flask/rune, gekoppeld aan de geadviseerde consumable per spec:
-- "best" = je hebt de aanbevolen best · "alt" = alleen een alternate · false =
-- geen · nil = onbekend (item-info nog niet gecached → never-lie "?").
local function BagTier(specData, catName)
	local cat = specData and specData[catName]
	if type(cat) ~= "table" then
		return nil
	end
	local hasBest = BagCount(cat.best or {})
	if hasBest == true then
		return "best"
	end
	local hasAlt = BagCount(cat.alternates or {})
	if hasAlt == true then
		return "alt"
	end
	if hasBest == nil and hasAlt == nil then
		return nil
	end
	return false
end

-- Tier → icoon. best/alt tellen beide als "ready" (groene ✓); alt krijgt een
-- subtiele amber "(alt)"-tag zodat je ziet dat je niet op de top-aanrader zit.
local function TierMark(tier)
	if tier == "best" then
		return ICON_OK
	elseif tier == "alt" then
		return ICON_OK .. Col("e8c36a", ns:L("CONSREADY_ALT"))
	elseif tier == false then
		return ICON_BAD
	end
	return ICON_UNK
end

local function GroupUnits()
	if IsInRaid and IsInRaid() then
		local t = {}
		local n = (GetNumGroupMembers and GetNumGroupMembers()) or 0
		for i = 1, n do
			t[#t + 1] = "raid" .. i
		end
		return t
	end
	local t = { "player" }
	local n = (GetNumGroupMembers and GetNumGroupMembers()) or 0
	for i = 1, math.max(0, n - 1) do
		t[#t + 1] = "party" .. i
	end
	return t
end

local function UnitLabel(unit)
	local name = (UnitName and UnitName(unit)) or unit
	local classToken = ClassToken(unit)
	local color = classToken and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classToken]
	if color and color.GenerateHexColor then
		local ok, hex = pcall(color.GenerateHexColor, color)
		if ok and hex then
			return ("|c%s%s|r"):format(hex, name)
		end
	end
	if color and color.r then
		return ("|cff%02x%02x%02x%s|r"):format(color.r * 255, color.g * 255, color.b * 255, name)
	end
	return name
end

--------------------------------------------------------------------------------
-- Rapportregels
--------------------------------------------------------------------------------

local function BuffWord()
	return Col(C_UNK, ns:L("CONSREADY_BUFF"))
end

local function SelfLine()
	local specData = PlayerSpecData()

	-- Tas-checks. Flask/rune getrapt t.o.v. de geadviseerde consumable (best vs
	-- alternate); pots/food/healthstone als simpele aanwezigheid + aantal.
	local flaskTier = BagTier(specData, "flask")
	local runeTier = BagTier(specData, "augmentRune")
	local _, cpotN = BagCount(CategoryItemIDs(specData, "combatPotion"))
	local cpotBag = cpotN and cpotN > 0 or false
	local _, hpotN = BagCount(CategoryItemIDs(specData, "healingPotion"))
	local hpotBag = hpotN and hpotN > 0 or false
	local _, foodN = BagCount(FoodItemIDs(specData))
	local foodBag = foodN and foodN > 0 or false
	local hsBag = BagCount(HEALTHSTONE_IDS)

	-- Buff-checks (eigen auras).
	EnsureBuffSets()
	local flaskBuff = UnitHasBuffFromSet("player", flaskBuffSet)
	local runeBuff = UnitHasBuffFromSet("player", runeBuffSet)

	local function tierBuff(label, tier, buff)
		return label .. " " .. TierMark(tier) .. " " .. Mark(buff) .. BuffWord()
	end
	local function bagOnly(label, bag, count)
		local s = label .. " " .. Mark(bag)
		if bag == true and count and count > 1 then
			s = s .. Col(C_UNK, "×" .. count)
		end
		return s
	end

	local parts = {
		tierBuff(ns:L("CONSREADY_FLASK"), flaskTier, flaskBuff),
		tierBuff(ns:L("CONSREADY_RUNE"), runeTier, runeBuff),
		bagOnly(ns:L("CONSREADY_CPOT"), cpotBag, cpotN),
		bagOnly(ns:L("CONSREADY_HPOT"), hpotBag, hpotN),
		bagOnly(ns:L("CONSREADY_FOOD"), foodBag, foodN),
		bagOnly(ns:L("CONSREADY_HS"), hsBag, nil),
	}
	return Col("ffd100", ns:L("CONSREADY_YOU")) .. "  " .. table.concat(parts, "  ·  ")
end

local function OtherLine(unit)
	EnsureBuffSets()
	local flaskBuff = UnitHasBuffFromSet(unit, flaskBuffSet)
	local runeBuff = UnitHasBuffFromSet(unit, runeBuffSet)
	local name = (UnitName and UnitName(unit)) or unit
	-- Tas-status van anderen kan alleen via comms (Fase 2): aanwezig als dat lid
	-- óók MidnightHelper draait en zijn counts heeft gebroadcast.
	local comms = ns.GetConsumableCommsStatus and ns.GetConsumableCommsStatus(name)
	local parts
	if comms then
		local function pres(n)
			return (n or 0) > 0
		end
		local function bagOnly(label, n)
			local s = label .. " " .. Mark(pres(n))
			if pres(n) and n > 1 then
				s = s .. Col(C_UNK, "×" .. n)
			end
			return s
		end
		parts = {
			ns:L("CONSREADY_FLASK") .. " " .. Mark(pres(comms.flask)) .. " " .. Mark(flaskBuff) .. BuffWord(),
			ns:L("CONSREADY_RUNE") .. " " .. Mark(pres(comms.rune)) .. " " .. Mark(runeBuff) .. BuffWord(),
			bagOnly(ns:L("CONSREADY_CPOT"), comms.cpot),
			bagOnly(ns:L("CONSREADY_HPOT"), comms.hpot),
			bagOnly(ns:L("CONSREADY_FOOD"), comms.food),
			bagOnly(ns:L("CONSREADY_HS"), comms.hs),
		}
	else
		parts = {
			ns:L("CONSREADY_FLASK") .. " " .. Mark(flaskBuff) .. BuffWord(),
			ns:L("CONSREADY_RUNE") .. " " .. Mark(runeBuff) .. BuffWord(),
			Col(C_UNK, "(" .. ns:L("CONSREADY_BAG_UNKNOWN") .. ")"),
		}
	end
	return UnitLabel(unit) .. "  " .. table.concat(parts, "  ·  ")
end

-- @return table lines (gekleurde, chat-klare regels)
local function BuildReportLines()
	local lines = {}
	local dungeon = (GetInstanceInfo and select(1, GetInstanceInfo())) or nil
	local header = (dungeon and dungeon ~= "")
			and ns:L("CONSREADY_HEADER_FMT"):format(dungeon)
		or ns:L("CONSREADY_HEADER")
	lines[#lines + 1] = Col("ffd100", header)

	local units = GroupUnits()
	-- Eerst jij, dan de rest.
	lines[#lines + 1] = SelfLine()
	for i = 1, #units do
		local u = units[i]
		if not UnitIsUnit(u, "player") then
			lines[#lines + 1] = OtherLine(u)
		end
	end

	lines[#lines + 1] = Col(C_UNK, ns:L("CONSREADY_FOOTER"))
	return lines
end

--------------------------------------------------------------------------------
-- Publieke print-functies (/mh dispatch in Core.lua roept deze aan)
--------------------------------------------------------------------------------

-- Eigen tas-tellingen per categorie (voor de comms-broadcast, Fase 2).
function ns.GetOwnConsumableBagCounts()
	local specData = PlayerSpecData()
	local function c(ids)
		local _, n = BagCount(ids)
		return n or 0
	end
	return {
		flask = c(CategoryItemIDs(specData, "flask")),
		rune = c(CategoryItemIDs(specData, "augmentRune")),
		cpot = c(CategoryItemIDs(specData, "combatPotion")),
		hpot = c(CategoryItemIDs(specData, "healingPotion")),
		food = c(FoodItemIDs(specData)),
		hs = c(HEALTHSTONE_IDS),
	}
end

-- Per categorie het eerste item-ID dat de speler ECHT in z'n tassen heeft (voor
-- de "klik om te gebruiken"-knoppen op het bord). nil = niets van die categorie.
function ns.GetOwnConsumableItemIDs()
	local specData = PlayerSpecData()
	local count = (C_Item and C_Item.GetItemCount) or GetItemCount
	local function firstOwned(ids)
		if type(ids) ~= "table" or not count then
			return nil
		end
		for _, id in ipairs(ids) do
			local ok, n = pcall(count, id)
			if ok and n and n > 0 then
				return id
			end
		end
		return nil
	end
	return {
		flask = firstOwned(CategoryItemIDs(specData, "flask")),
		rune = firstOwned(CategoryItemIDs(specData, "augmentRune")),
		weapon = firstOwned(CategoryItemIDs(specData, "weaponOil")),
		cpot = firstOwned(CategoryItemIDs(specData, "combatPotion")),
		hpot = firstOwned(CategoryItemIDs(specData, "healingPotion")),
		food = firstOwned(FoodItemIDs(specData)),
		hs = firstOwned(HEALTHSTONE_IDS),
	}
end

-- Representatief icoon (fileID) per categorie voor de icoon-stijl van het bord.
-- Het aanbevolen (best[1]) item bepaalt het kolom-icoon; voor jezelf valt het
-- terug op wat je echt hebt. Zelfde icoon voor alle rijen in een kolom.
function ns.GetConsumableColumnIcons()
	local specData = PlayerSpecData()
	local getIcon = C_Item and C_Item.GetItemIconByID
	local function repID(cat)
		local t = specData and specData[cat]
		if type(t) ~= "table" then
			return nil
		end
		if type(t.best) == "table" and t.best[1] then
			return t.best[1]
		end
		if type(t.alternates) == "table" and t.alternates[1] then
			return t.alternates[1]
		end
		return nil
	end
	local function ic(id)
		if not (id and getIcon) then
			return nil
		end
		local ok, icon = pcall(getIcon, id)
		return (ok and icon) or nil
	end
	return {
		flask = ic(repID("flask")),
		rune = ic(repID("augmentRune")),
		weapon = ic(repID("weaponOil")),
		cpot = ic(repID("combatPotion")),
		hpot = ic(repID("healingPotion")),
		food = ic(repID("personalFood") or repID("feast")),
		hs = ic(HEALTHSTONE_IDS and HEALTHSTONE_IDS[1]),
	}
end

-- Aanbevolen (best[1]) item-ID per categorie — voor de tooltip als je het item
-- NIET op zak hebt (dan tonen we wat aanbevolen is + "niet in tas").
function ns.GetConsumableRecommendedItemIDs()
	local specData = PlayerSpecData()
	local function repID(cat)
		local t = specData and specData[cat]
		if type(t) ~= "table" then
			return nil
		end
		if type(t.best) == "table" and t.best[1] then
			return t.best[1]
		end
		if type(t.alternates) == "table" and t.alternates[1] then
			return t.alternates[1]
		end
		return nil
	end
	return {
		flask = repID("flask"),
		rune = repID("augmentRune"),
		weapon = repID("weaponOil"),
		cpot = repID("combatPotion"),
		hpot = repID("healingPotion"),
		food = repID("personalFood") or repID("feast"),
		hs = HEALTHSTONE_IDS and HEALTHSTONE_IDS[1] or nil,
	}
end

--------------------------------------------------------------------------------
-- Raid/class-buffs (idee uit ReadyCheckConsumables). Vaste, BEKENDE spell-ID's →
-- veilig te checken. We tonen een buff alleen als de gever-class in de groep zit.
--------------------------------------------------------------------------------

ns.RAID_BUFF_DEFS = {
	{ key = "int",     class = "MAGE",    spellID = 1459,   labelKey = "RAIDBUFF_INT" },     -- Arcane Intellect
	{ key = "stam",    class = "PRIEST",  spellID = 21562,  labelKey = "RAIDBUFF_STAM" },    -- Power Word: Fortitude
	{ key = "ap",      class = "WARRIOR", spellID = 6673,   labelKey = "RAIDBUFF_AP" },      -- Battle Shout
	{ key = "vers",    class = "DRUID",   spellID = 1126,   labelKey = "RAIDBUFF_VERS" },    -- Mark of the Wild
	{ key = "mastery", class = "SHAMAN",  spellID = 462854, labelKey = "RAIDBUFF_MASTERY" }, -- Skyfury
}

-- Zit er iemand van deze class in de groep (of ben jij het)?
local function ClassInGroup(classToken)
	if not classToken then
		return false
	end
	if ClassToken("player") == classToken then
		return true
	end
	local units = GroupUnits()
	for i = 1, #units do
		local token = ClassToken(units[i])
		if token == classToken then
			return true
		end
		-- Unreadable is not absent. If the client hides who this is, we cannot
		-- conclude the group has no Warrior and quietly drop the Battle Shout row
		-- -- that hides real advice, which is the same mistake that told Cisca she
		-- was missing a buff she was holding. Showing a row for a class that is not
		-- there is only noise; hiding one that is costs you the buff.
		if token == nil then
			return true
		end
	end
	return false
end

-- De raid-buffs waarvan de gever-class aanwezig is (anders niet tonen). Cachebaar
-- per render: roep 1× aan en geef door aan RaidBuffStatusForUnit.
function ns.GetActiveRaidBuffDefs()
	local out = {}
	for _, def in ipairs(ns.RAID_BUFF_DEFS) do
		if ClassInGroup(def.class) then
			out[#out + 1] = def
		end
	end
	return out
end

-- Heeft `unit` de aura met spellID? Zie Modules/Auras.lua: true / false / nil (onleesbaar).
local function UnitHasAuraSpell(unit, spellID)
	return ns.Aura.HasUnitBuff(unit, spellID)
end

-- { [def.key] = true/false } voor de actieve raid-buff-defs.
local function RaidBuffStatusForUnit(unit, activeDefs)
	local out = {}
	for _, def in ipairs(activeDefs) do
		out[def.key] = UnitHasAuraSpell(unit, def.spellID)
	end
	return out
end

-- Wie heeft elke raid-buff (volledige groep, NIET leader-gated → ook een
-- niet-leader ziet 't via de tooltip). Werkt met meerdere dezelfde specs.
-- @return { [def.key] = { spellID, has={{name,class}...}, missing={...} } }
function ns.GetRaidBuffHolders()
	local defs = ns.GetActiveRaidBuffDefs()
	local units = { "player" }
	for _, u in ipairs(GroupUnits()) do
		if not UnitIsUnit(u, "player") then
			units[#units + 1] = u
		end
	end
	local out = {}
	for _, def in ipairs(defs) do
		-- Three buckets, not two. Patch 12.1 restricts reading other players' auras, and
		-- a player we cannot read is not a player without the buff: putting them under
		-- "missing" would accuse half the raid of forgetting a buff they are holding.
		-- `unknown` is empty on today's client and nothing renders it yet.
		local has, missing, unknown = {}, {}, {}
		for _, u in ipairs(units) do
			local ctoken = ClassToken(u)
			local entry = { name = (UnitName and UnitName(u)) or u, class = ctoken }
			local state = UnitHasAuraSpell(u, def.spellID)
			if state == true then
				has[#has + 1] = entry
			elseif state == false then
				missing[#missing + 1] = entry
			else
				unknown[#unknown + 1] = entry
			end
		end
		out[def.key] = { spellID = def.spellID, has = has, missing = missing, unknown = unknown }
	end
	return out
end

-- Resterende buff-tijd (in seconden) voor de SPELER per categorie, voor de timer
-- boven de cellen. Keys: flask/rune/weapon/food + "rb_<key>" per raid-buff. nil =
-- geen buff of tijd onbekend (12.x: expirationTime kan secret zijn → geguard).
function ns.GetPlayerBuffRemaining()
	EnsureBuffSets()
	local out = {}
	local now = GetTime and GetTime() or 0
	local function auraRem(spellID)
		local aura = ns.Aura.GetPlayerAura(spellID)
		if not aura then
			return nil
		end
		local exp = aura.expirationTime
		if not exp or (issecretvalue and issecretvalue(exp)) or exp <= 0 then
			return nil
		end
		local r = exp - now
		return r > 0 and r or nil
	end
	local function setRem(set)
		if type(set) ~= "table" then
			return nil
		end
		for sid in pairs(set) do
			local r = auraRem(sid)
			if r then
				return r
			end
		end
		return nil
	end
	out.flask = setRem(flaskBuffSet)
	out.rune = setRem(runeBuffSet)
	-- food: icon-scan voor de Well-Fed-aura → expirationTime
	ns.Aura.ForEachPlayerBuff(function(aura)
		local sid = aura.spellId
		if issecretvalue and issecretvalue(sid) then
			return
		end
		local icon = aura.icon
		if not (icon and not (issecretvalue and issecretvalue(icon)) and icon == WELL_FED_ICON) then
			return
		end
		local exp = aura.expirationTime
		if exp and not (issecretvalue and issecretvalue(exp)) and exp > 0 then
			local r = exp - now
			out.food = r > 0 and r or nil
		end
		return true -- stop
	end)
	-- weapon: tijdelijke wapen-enchant (mainHandExpiration in ms)
	if GetWeaponEnchantInfo then
		local ok, he, ms = pcall(GetWeaponEnchantInfo)
		if ok and he and ms and ms > 0 then
			out.weapon = ms / 1000
		end
	end
	-- raid-buffs: per actieve def
	for _, def in ipairs(ns.GetActiveRaidBuffDefs()) do
		out["rb_" .. def.key] = auraRem(def.spellID)
	end
	return out
end

-- Gestructureerde status per groepslid (gedeelde bron voor chat + het bord).
-- @return { dungeon=string|nil, raidBuffs={activeDefs}, rows = { {unit,name,
--   classToken,isMH, flask={bag,buff}, rune={bag,buff}, weapon=..., cpot={bag,
--   count}, hpot=..., food=..., hs=..., raidbuffs={[key]=bool} } } }
-- flask/rune .bag: voor jezelf "best"/"alt"/false/nil (getrapt); voor anderen
-- true/false (aanwezig via comms) of nil (onbekend). buff: true/false/nil.
function ns.GetConsumableReadyData()
	EnsureBuffSets()
	local dungeon = (GetInstanceInfo and select(1, GetInstanceInfo())) or nil
	if dungeon == "" then
		dungeon = nil
	end
	local rows = {}
	local activeRaidBuffs = ns.GetActiveRaidBuffDefs()

	-- Welke consumable-kolommen tonen we (aaneengesloten, geen gaten)? weapon alleen
	-- als de spec olie gebruikt; healthstone alleen als er een Warlock in de groep
	-- zit (anders zinloos — alleen Warlocks maken ze). Rob-wens 21 jun.
	local pSpec = PlayerSpecData()
	local consumColumns = { "flask", "rune" }
	if pSpec and not pSpec.omitWeaponOil then
		consumColumns[#consumColumns + 1] = "weapon"
	end
	consumColumns[#consumColumns + 1] = "cpot"
	consumColumns[#consumColumns + 1] = "hpot"
	consumColumns[#consumColumns + 1] = "food"
	if ClassInGroup("WARLOCK") then
		consumColumns[#consumColumns + 1] = "hs"
	end

	local function presence(ids)
		local has, n = BagCount(ids)
		return has, n
	end

	-- Eigen rij (volledig).
	do
		local specData = PlayerSpecData()
		local _, cN = presence(CategoryItemIDs(specData, "combatPotion"))
		local _, hN = presence(CategoryItemIDs(specData, "healingPotion"))
		local _, fN = presence(FoodItemIDs(specData))
		local hsHas = presence(HEALTHSTONE_IDS)
		local ctoken = ClassToken("player")
		-- Weapon-olie: alleen specs die 'm gebruiken (Shamans e.d. = omitWeaponOil,
		-- die hebben eigen weapon-imbues). Buff = de tijdelijke wapen-enchant.
		local weapon = nil
		if specData and not specData.omitWeaponOil then
			local hasEnchant = false
			if GetWeaponEnchantInfo then
				local okE, he = pcall(GetWeaponEnchantInfo)
				hasEnchant = (okE and he) and true or false
			end
			weapon = { bag = BagTier(specData, "weaponOil"), buff = hasEnchant }
		end
		rows[#rows + 1] = {
			unit = "player",
			name = (UnitName and UnitName("player")) or "You",
			classToken = ctoken,
			isMH = true,
			flask = { bag = BagTier(specData, "flask"), buff = UnitHasBuffFromSet("player", flaskBuffSet) },
			rune = { bag = BagTier(specData, "augmentRune"), buff = UnitHasBuffFromSet("player", runeBuffSet) },
			weapon = weapon,
			cpot = { bag = (cN and cN > 0) or false, count = cN },
			hpot = { bag = (hN and hN > 0) or false, count = hN },
			food = { bag = (fN and fN > 0) or false, count = fN, buff = PlayerWellFed() },
			hs = { bag = hsHas, count = nil },
			raidbuffs = RaidBuffStatusForUnit("player", activeRaidBuffs),
		}
	end

	-- Overige groepsleden — alleen de LEADER ziet de hele groep; niet-leaders zien
	-- enkel hun eigen rij (Rob-wens 21 jun). Solo telt als leader (geen groep).
	local showGroup = not (IsInGroup and IsInGroup() and UnitIsGroupLeader and not UnitIsGroupLeader("player"))
	local units = showGroup and GroupUnits() or {}
	for i = 1, #units do
		local unit = units[i]
		if not UnitIsUnit(unit, "player") then
			local name = (UnitName and UnitName(unit)) or unit
			local comms = ns.GetConsumableCommsStatus and ns.GetConsumableCommsStatus(name)
			local ctoken = ClassToken(unit)
			local function commsBag(key)
				if not comms then
					return nil, nil
				end
				local n = comms[key] or 0
				return n > 0, n
			end
			local cb, cn = commsBag("cpot")
			local hb, hn = commsBag("hpot")
			local fb, fn = commsBag("food")
			local sb = (commsBag("hs"))
			local flb = (commsBag("flask"))
			local rub = (commsBag("rune"))
			rows[#rows + 1] = {
				unit = unit,
				name = name,
				classToken = ctoken,
				isMH = comms ~= nil,
				flask = { bag = flb, buff = UnitHasBuffFromSet(unit, flaskBuffSet) },
				rune = { bag = rub, buff = UnitHasBuffFromSet(unit, runeBuffSet) },
				cpot = { bag = cb, count = cn },
				hpot = { bag = hb, count = hn },
				food = { bag = fb, count = fn },
				hs = { bag = sb, count = nil },
				raidbuffs = RaidBuffStatusForUnit(unit, activeRaidBuffs),
			}
		end
	end

	return { dungeon = dungeon, rows = rows, raidBuffs = activeRaidBuffs, consumColumns = consumColumns }
end

function ns.PrintConsumableReadyCheck()
	for _, line in ipairs(BuildReportLines()) do
		print(line)
	end
end

-- Hulpcommando: dump je actieve HELPFUL-auras met spell-ID + resterende tijd.
-- Handig om de echte flask/rune-buff-ID's te controleren tegen GetItemSpell.
function ns.PrintPlayerAuraDump()
	local now = (GetTime and GetTime()) or 0
	-- Dump zowel buffs (HELPFUL) als debuffs (HARMFUL); debuffs nodig om bv. de
	-- ritual "Fragility"-debuff te kunnen vangen.
	local function dump(each, headerKey)
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L(headerKey)))
		local n = 0
		local scanned = each(function(data)
			n = n + 1
			local remain = ""
			if data.expirationTime and data.expirationTime > 0 then
				remain = ("  (%ds)"):format(math.max(0, math.floor(data.expirationTime - now)))
			end
			print(("  |cff71d5ff%d|r  %s%s"):format(data.spellId or 0, tostring(data.name or "?"), remain))
		end)
		if not scanned then
			print("  " .. Col(C_BAD, "C_UnitAuras.GetAuraDataByIndex " .. ns:L("CONSREADY_API_MISSING")))
		elseif n == 0 then
			print("  " .. Col(C_UNK, ns:L("AURADUMP_NONE")))
		end
	end
	dump(ns.Aura.ForEachPlayerBuff, "AURADUMP_HEADER")
	dump(ns.Aura.ForEachPlayerDebuff, "AURADUMP_DEBUFF_HEADER")
end

--------------------------------------------------------------------------------
-- Aan/uit (default aan) — zelfde patroon als DungeonLiveCoach
--------------------------------------------------------------------------------

local function Enabled()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return true
	end
	return uiDb.consumableReadyCheck ~= false
end

function ns.IsConsumableReadyCheckEnabled()
	return Enabled()
end

function ns.SetConsumableReadyCheckEnabled(v)
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) == "table" then
		uiDb.consumableReadyCheck = v and true or false
	end
end

function ns.ToggleConsumableReadyCheck()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return
	end
	uiDb.consumableReadyCheck = not Enabled()
	local key = Enabled() and "CONSREADY_TOGGLE_ON" or "CONSREADY_TOGGLE_OFF"
	print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L(key)))
end

--------------------------------------------------------------------------------
-- Auto-check bij dungeon-entry
--------------------------------------------------------------------------------

local lastAutoKey = nil


-- Unieke sleutel voor de drie content-types waarin we de check tonen: dungeon
-- (party-instance), delve (C_PartyInfo) en Ritual Site (scenario). nil = niet in
-- trackbare content. De sleutel verschilt per type/run, zodat de dedup klopt en
-- je 'm bij elke nieuwe ritual/delve/dungeon opnieuw krijgt. Read-only/pcall.
-- Known Ritual Site scenarios that warrant a consumable ready-check (real mini-boss
-- encounters). ALLOW-LIST, not a catch-all: the old "any active scenario" rule also
-- matched open-world scenarios like the Void Showdown, which popped the board solo in
-- the open world (Rob 9 jul). A new ritual site gets a dedicated coach anyway
-- (RitualBossCoach 3236, DaggerspineCoach 3267) - add its scenarioID here too.
local RITUAL_SITE_SCENARIOS = {
	[3236] = true, -- Broken Throne
	[3267] = true, -- Daggerspine
}

local function CurrentContentKey()
	-- Dungeon (party-instance)
	if IsInInstance then
		local inInstance, instanceType = IsInInstance()
		if inInstance and instanceType == "party" then
			return "party:" .. tostring((GetInstanceInfo and select(8, GetInstanceInfo())) or "?")
		end
	end
	-- Delve (actieve run, API)
	if ns.IsDelveInstanceInProgress and ns.IsDelveInstanceInProgress() then
		return "delve:" .. tostring((GetInstanceInfo and select(8, GetInstanceInfo())) or "?")
	end
	-- Ritual Site (outdoor mini-boss scenario): only KNOWN sites (allow-list above),
	-- NOT every scenario - a catch-all also matched the Void Showdown and popped the
	-- board solo. The dedup key holds the real scenarioID, so it's unique per site/run.
	if C_ScenarioInfo and C_ScenarioInfo.GetScenarioInfo then
		local ok, info = pcall(C_ScenarioInfo.GetScenarioInfo)
		if ok and type(info) == "table" and info.scenarioID and RITUAL_SITE_SCENARIOS[info.scenarioID] then
			return "ritual:" .. tostring(info.scenarioID)
		end
	end
	return nil
end

local function MaybeAutoRun(force)
	if not Enabled() then
		if ns.db and ns.db.ui and ns.db.ui.debug then
			print("|cffffcc00MH:|r ConsumableReadyCheck uit (debug)")
		end
		return
	end
	local key = CurrentContentKey()
	if not key then
		lastAutoKey = nil -- content verlaten → volgende ritual/delve/dungeon toont weer
		return
	end
	if not force and key == lastAutoKey then
		return
	end
	lastAutoKey = key
	-- Korte vertraging: aura/roster zijn vlak na de zone-load nog niet gevuld.
	local function run()
		if not CurrentContentKey() then
			return
		end
		--- ⚠️ NIET VANZELF IN EEN RAID. Rob, 19 aug: het bord kwam op bij een
		--- wereldbaas-groep van ruim 5 man — "dat is niet echt handig".
		---
		--- Het is erger dan onhandig. Het bord heeft vijf rijen (MAX_ROWS), dus in een
		--- groep van veertig toont het raid1..raid5: een willekeurige snee waar je zelf
		--- niet eens in hoeft te staan, gepresenteerd als een groepsoverzicht. Een
		--- steekproef die zich voordoet als het geheel is geen ongemak maar een
		--- onwaarheid, en dit bord bestaat juist om te zeggen wie er klaar is.
		---
		--- Een party is in WoW maximaal vijf, dus alles daarboven is per definitie een
		--- raid — `IsInRaid` is precies de grens die het bord aankan.
		---
		--- Alleen de AUTOMATISCHE opening staat stil. Open je hem zelf via de knop of de
		--- zoekbalk, dan krijg je hem gewoon; dan weet je wat je opvraagt.
		if IsInRaid and IsInRaid() then
			return
		end
		-- Visueel bord (Fase 3); valt terug op de chat-versie als het bord-
		-- bestand (nog) niet geladen is.
		if ns.ShowConsumableBoard then
			ns.ShowConsumableBoard()
		else
			ns.PrintConsumableReadyCheck()
		end
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(1.5, run)
	else
		run()
	end
end

-- Bij scenario-events (ritual/delve) is de scenario-info vaak nog niet gevuld op het
-- moment dat het event vuurt (open wereld = geen zone-load). We pollen daarom een
-- paar keer, gespreid over de eerste seconden, tot CurrentContentKey een sleutel
-- geeft. MaybeAutoRun dedupt op lastAutoKey, dus het bord toont hooguit één keer.
local function ScheduleScenarioRecheck()
	if not (C_Timer and C_Timer.After) then
		MaybeAutoRun(false)
		return
	end
	for _, d in ipairs({ 0.3, 1, 2.5, 5, 8 }) do
		C_Timer.After(d, function()
			MaybeAutoRun(false)
		end)
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("CHALLENGE_MODE_START")
ev:RegisterEvent("SCENARIO_UPDATE") -- ritual/delve-scenario start/stop (buiten = geen zone-load)
ev:RegisterEvent("SCENARIO_CRITERIA_UPDATE") -- ritual: scenario-info is bij SCENARIO_UPDATE vaak nog leeg
ev:RegisterEvent("SCENARIO_COMPLETED")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
ev:SetScript("OnEvent", function(_, event)
	if event == "GET_ITEM_INFO_RECEIVED" then
		-- Item-info kwam binnen: laat de buff-sets bij de volgende check
		-- opnieuw bouwen (use-spells kunnen nu wél resolven).
		buffSetsReady = false
		return
	end
	if event == "CHALLENGE_MODE_START" then
		MaybeAutoRun(true)
		return
	end
	-- Scenario-events (ritual/delve): de scenario-info is bij het eerste event vaak
	-- nog niet gevuld (buiten = geen zone-load). Een paar keer opnieuw pollen zodat
	-- het bord BIJ BINNENKOMST verschijnt i.p.v. pas bij een latere stage-update.
	if event == "SCENARIO_UPDATE" or event == "SCENARIO_CRITERIA_UPDATE" then
		ScheduleScenarioRecheck()
		return
	end
	if event == "SCENARIO_COMPLETED" then
		-- Ritual/delve finished: do NOT reset lastAutoKey here. The scenario is still
		-- active during the completion screen, so a follow-up SCENARIO_UPDATE would
		-- re-pop the board (Rob 9 jul: the consumable check reappeared at the END of a
		-- ritual). The dedup key clears naturally when CurrentContentKey() goes nil on
		-- leaving. Hide the board here since the check is pointless once you are done.
		if ns.HideConsumableBoard then
			ns.HideConsumableBoard()
		end
		return
	end
	MaybeAutoRun(false)
end)
