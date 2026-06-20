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
	if not (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) then
		return nil
	end
	local i = 1
	while true do
		local ok, data = pcall(C_UnitAuras.GetAuraDataByIndex, unit, i, "HELPFUL")
		if not ok or not data then
			break
		end
		if data.spellId and set[data.spellId] then
			return true, data.expirationTime
		end
		i = i + 1
	end
	return false
end

--------------------------------------------------------------------------------
-- Spelercontext + groepslijst
--------------------------------------------------------------------------------

local function PlayerSpecData()
	local classToken = select(2, UnitClass("player"))
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
	local _, classToken = UnitClass(unit)
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

-- Gestructureerde status per groepslid (gedeelde bron voor chat + het bord).
-- @return { dungeon=string|nil, rows = { {unit,name,classToken,isMH,
--   flask={bag,buff}, rune={bag,buff}, cpot={bag,count}, hpot={...},
--   food={...}, hs={...} } } }
-- flask/rune .bag: voor jezelf "best"/"alt"/false/nil (getrapt); voor anderen
-- true/false (aanwezig via comms) of nil (onbekend). buff: true/false/nil.
function ns.GetConsumableReadyData()
	EnsureBuffSets()
	local dungeon = (GetInstanceInfo and select(1, GetInstanceInfo())) or nil
	if dungeon == "" then
		dungeon = nil
	end
	local rows = {}

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
		local _, ctoken = UnitClass("player")
		rows[#rows + 1] = {
			unit = "player",
			name = (UnitName and UnitName("player")) or "You",
			classToken = ctoken,
			isMH = true,
			flask = { bag = BagTier(specData, "flask"), buff = UnitHasBuffFromSet("player", flaskBuffSet) },
			rune = { bag = BagTier(specData, "augmentRune"), buff = UnitHasBuffFromSet("player", runeBuffSet) },
			cpot = { bag = (cN and cN > 0) or false, count = cN },
			hpot = { bag = (hN and hN > 0) or false, count = hN },
			food = { bag = (fN and fN > 0) or false, count = fN },
			hs = { bag = hsHas, count = nil },
		}
	end

	-- Overige groepsleden.
	local units = GroupUnits()
	for i = 1, #units do
		local unit = units[i]
		if not UnitIsUnit(unit, "player") then
			local name = (UnitName and UnitName(unit)) or unit
			local comms = ns.GetConsumableCommsStatus and ns.GetConsumableCommsStatus(name)
			local _, ctoken = UnitClass(unit)
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
			}
		end
	end

	return { dungeon = dungeon, rows = rows }
end

function ns.PrintConsumableReadyCheck()
	for _, line in ipairs(BuildReportLines()) do
		print(line)
	end
end

-- Hulpcommando: dump je actieve HELPFUL-auras met spell-ID + resterende tijd.
-- Handig om de echte flask/rune-buff-ID's te controleren tegen GetItemSpell.
function ns.PrintPlayerAuraDump()
	if not (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) then
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("AURADUMP_HEADER")))
		print("  " .. Col(C_BAD, "C_UnitAuras.GetAuraDataByIndex " .. ns:L("CONSREADY_API_MISSING")))
		return
	end
	local now = (GetTime and GetTime()) or 0
	-- Dump zowel buffs (HELPFUL) als debuffs (HARMFUL); debuffs nodig om bv. de
	-- ritual "Fragility"-debuff te kunnen vangen.
	local function dump(filter, headerKey)
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L(headerKey)))
		local i = 1
		while true do
			local ok, data = pcall(C_UnitAuras.GetAuraDataByIndex, "player", i, filter)
			if not ok or not data then
				break
			end
			local remain = ""
			if data.expirationTime and data.expirationTime > 0 then
				remain = ("  (%ds)"):format(math.max(0, math.floor(data.expirationTime - now)))
			end
			print(("  |cff71d5ff%d|r  %s%s"):format(data.spellId or 0, tostring(data.name or "?"), remain))
			i = i + 1
		end
		if i == 1 then
			print("  " .. Col(C_UNK, ns:L("AURADUMP_NONE")))
		end
	end
	dump("HELPFUL", "AURADUMP_HEADER")
	dump("HARMFUL", "AURADUMP_DEBUFF_HEADER")
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

local lastAutoInstance = nil

local function CurrentPartyInstanceID()
	if not IsInInstance then
		return nil
	end
	local inInstance, instanceType = IsInInstance()
	if not inInstance or instanceType ~= "party" then
		return nil
	end
	return (GetInstanceInfo and select(8, GetInstanceInfo())) or true
end

local function MaybeAutoRun(force)
	if not Enabled() then
		if ns.db and ns.db.ui and ns.db.ui.debug then
			print("|cffffcc00MH:|r ConsumableReadyCheck uit (debug)")
		end
		return
	end
	local id = CurrentPartyInstanceID()
	if not id then
		return
	end
	if not force and id == lastAutoInstance then
		return
	end
	lastAutoInstance = id
	-- Korte vertraging: aura/roster zijn vlak na de zone-load nog niet gevuld.
	local function run()
		if not CurrentPartyInstanceID() then
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

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("CHALLENGE_MODE_START")
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
	MaybeAutoRun(false)
end)
