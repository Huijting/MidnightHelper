local _, ns = ...

--[[
	AltProfTip.lua — Forever AND Midnight: the tooltip of a recipe or an ingredient names YOUR OTHER characters who can use
	it, so you know to whom to send it (25 Nov 2026).

	Rob via Sparring 25-11, letterlijk (Forever Druid, "Recipe: Elixir of Minor Agility"): "Dat heb ik op deze niet, maar ik
	weet dat ik op een andere wel alchemie heb. Dan ga ik eerst naar karakters kijken om te kijken wie het heeft. Kunnen
	wij dat niet hier vermelden in de tooltip, zodat ik weet naar wie ik het moet gaan sturen?" … "Eigenlijk wil ik het
	natuurlijk wel voor alles wat we eventueel kunnen versturen naar anderen." -> on the proposal (step 1 now: recipes
	and ingredients; step 2 gear: research first) "Ja, dat klopt zo. Kun je het voor beide versies maken, Forever en
	Midnight?"

	Three lines, only for an item you can send (not Soulbound, not "Binds when picked up", not a quest item):
	  recipe      "MH: your other Alchemy: Ima (14, needs 50), Bob (60, can learn it)"
	  ingredient  "MH: on your other characters: Alchemy: Ima · Cooking: Bob"
	  gear        "MH: your other characters who can wear this: Ima (item level 12 -> 20), Bob (from level 40), Cid"
	              (step 2, same day; see the Gear section below)
	No other character with the profession = no line. Off: /mh alttip off (or the switch in the settings).

	Data, every piece MEASURED (25 Nov 2026):
	  - The profession of a recipe ITEM: item class 9, subclass 1-11 (wago DB2 ItemSubClass ClassID=9, Forever 71091 has
	    0-9, Midnight 70961 0-11; 0 = Book). Subclass -> skill line below.
	  - Other characters, Forever: ns.db.foreverChars[guid].profs = { key, name, rank, max } (ForeverChars.lua), keys as in
	    ns.FOREVER_PROFS. Midnight: ns.db.charCurrencies[guid].profs = { n, r, m, s = skill line } (AltOverview.lua). Both
	    seen filled in Rob's SavedVariables. A character counts only after one login with a version that saves it.
	  - The skill a recipe needs: the tooltip's own line, read with the client's format ITEM_MIN_SKILL ("Requires %s (%d)"),
	    so it works in every language.
	  - Forever only: "can learn it" / "already knows it" from ns.db.foreverKnownRecipes[guid] (filled once that character
	    opened the profession window; keys are GUIDs, seen in Rob's SV) and the spell the item teaches
	    (ns.ForeverRecipeTeaches). Without that list only the skill and, when it is too low, "needs N".
	  - Midnight: only name + skill. A Midnight profession has a skill per expansion and the saved skill is the one
	    GetProfessionInfo gives (max 100 in Rob's SV: the Midnight one); the recipe can be of another expansion, so MH
	    does not say "can learn".
	  - Ingredients: the same data as the "Used for" line (ns.ReagentUseKeys, ReagentUse.lua).
	/mh alttip prints the last decision and its reason (CLAUDE.md: a module that can stay quiet needs that).
]]

local PREFIX = "|cffffcc00Midnight Helper:|r "
local last = "nothing hovered yet"

-- Recipe subclass -> skill line (both games use the same numbers; 10 and 11 exist in Midnight only).
local RECIPE_LINE = { [1] = 165, [2] = 197, [3] = 202, [4] = 164, [5] = 185, [6] = 171, [7] = 129, [8] = 333, [9] = 356,
	[10] = 755, [11] = 773 }

local function On()
	return not (ns.db and ns.db.altProfTip == false)
end

local function Readable(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

local function MyGUID()
	local g = UnitGUID and UnitGUID("player")
	return Readable(g) and g or nil
end

local KEY_LINE
local function KeyLine(key)
	if not KEY_LINE then
		KEY_LINE = {}
		for _, p in ipairs(ns.FOREVER_PROFS or {}) do
			KEY_LINE[p[1]] = p[2]
		end
		for key2, line in pairs(ns.REAGENT_LINES or {}) do
			KEY_LINE[key2] = KEY_LINE[key2] or line
		end
	end
	return KEY_LINE[key]
end

--[[ Who can you MAIL it to? (25 Nov 2026, Rob via Sparring on a War Torn Cape: "hier staat dat ik op heel veel
	karakters zou kunnen gebruiken. Maar kan ik überhaupt wel sturen?")
	Forever: mail only reaches a character on the same realm (GlobalStrings ERR_MAIL_CANT_SEND_REALM "You can't send mail
	to that realm.", GEMETEN Forever 71091) -> another realm is left out. Another faction: in classic WoW mail does not
	cross factions; for Forever NOT measured (no string says it either way) -> those names go apart at the end, "probably
	not". No realm saved: the server number in the GUID decides. A character whose faction MH has not saved yet keeps its
	place with "(faction ?)". Rob's SV, GEMETEN 25 Nov: one realm; 10 Horde, 4 Alliance (Ima Bankgirl, Ima Tinyroque, Inchy
	Shootalot, Joey Whatever), 3 without a faction (Ima Lockie, Ima Magymage, Ima Warman). /mh alttip lists the verdict.
	Midnight: not filtered. Non-bound items and reagents go to every character of your Warband through the Warband bank
	(AFGELEID from the retail Warband feature, not measured here), whatever the realm or faction. ]]
local function ServerID(guid)
	return type(guid) == "string" and guid:match("^Player%-(%d+)%-") or nil
end

local function Reach(rec, guid)
	if not ns.IS_FOREVER then
		return "ok", "Midnight: Warband bank"
	end
	local myRealm = GetRealmName and GetRealmName()
	local okF, myFac = pcall(function()
		return UnitFactionGroup and UnitFactionGroup("player")
	end)
	myFac = okF and myFac or nil
	if Readable(myRealm) and type(rec.realm) == "string" and rec.realm ~= myRealm then
		return "realm", "another realm (" .. rec.realm .. "): no mail"
	end
	-- No realm saved (2 of Rob's 17 in his SV, 25 Nov): the server number in the GUID ("Player-6944-...") says it.
	local mine, theirs = ServerID(MyGUID()), ServerID(guid)
	if type(rec.realm) ~= "string" and mine and theirs and mine ~= theirs then
		return "realm", "another server (" .. theirs .. "): no mail"
	end
	if not (Readable(myFac) and type(rec.faction) == "string" and rec.faction ~= "") then
		return "unknown", "faction not saved yet (log in on it once)"
	end
	if rec.faction ~= myFac then
		return "faction", "other faction (" .. rec.faction .. "): mail probably not possible"
	end
	return "ok", "same realm and faction"
end

--- The name as the line shows it: "(faction ?)" when MH does not know yet whether you can mail it.
local function Shown(c)
	return c.reach == "unknown" and ns:L("FALT_FACQ_FMT"):format(c.name) or c.name
end

--- " · other faction (mail probably not possible): A, B" for the names in `list`, or "".
local function FactionTail(list)
	if #list == 0 then
		return ""
	end
	table.sort(list)
	local shown = {}
	for i = 1, math.min(3, #list) do
		shown[i] = list[i]
	end
	local s = table.concat(shown, ", ")
	if #list > 3 then
		s = s .. ns:L("FALT_MORE_FMT"):format(#list - 3)
	end
	return ns:L("FALT_OTHERFAC_FMT"):format(s)
end

--- Your OTHER characters: { guid, name, reach, profs = { [skill line] = { name, rank, max } } }. Another realm (Forever) is
--- left out here already.
local function Others()
	local out, me = {}, MyGUID()
	local store = ns.db and (ns.IS_FOREVER and ns.db.foreverChars or ns.db.charCurrencies)
	if type(store) ~= "table" then
		return out
	end
	for guid, rec in pairs(store) do
		local reach = type(rec) == "table" and Reach(rec, guid) or nil
		if guid ~= me and type(rec) == "table" and type(rec.name) == "string" and type(rec.profs) == "table"
			and reach ~= "realm" then
			local profs = {}
			for _, p in ipairs(rec.profs) do
				if type(p) == "table" then
					if ns.IS_FOREVER then
						local line = KeyLine(p.key)
						if line then
							profs[line] = { name = p.name, rank = tonumber(p.rank), max = tonumber(p.max) }
						end
					elseif tonumber(p.s) then
						profs[tonumber(p.s)] = { name = p.n, rank = tonumber(p.r), max = tonumber(p.m) }
					end
				end
			end
			out[#out + 1] = { guid = guid, name = rec.name, profs = profs, reach = reach }
		end
	end
	table.sort(out, function(a, b)
		return tostring(a.name) < tostring(b.name)
	end)
	return out
end

local function Lines(data)
	return (type(data) == "table" and type(data.lines) == "table") and data.lines or {}
end

--- Can this item be sent to another character? false + why when it cannot.
local function Sendable(id, data)
	for _, l in ipairs(Lines(data)) do
		local t = l and l.leftText
		if Readable(t) and type(t) == "string" then
			if (ITEM_SOULBOUND and t == ITEM_SOULBOUND) then
				return false, "soulbound"
			end
			if (ITEM_BIND_ON_PICKUP and t == ITEM_BIND_ON_PICKUP) then
				return false, "binds when picked up"
			end
		end
	end
	local info = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	if info then
		local ok, _, _, _, _, _, _, _, _, _, _, _, _, _, bindType = pcall(info, id)
		if ok and (bindType == 1 or bindType == 4) then
			return false, bindType == 1 and "binds when picked up" or "a quest item"
		end
	end
	return true
end

local MIN_SKILL_PAT
--- The skill the tooltip says this recipe needs ("Requires Alchemy (50)"), or nil.
local function NeedSkill(data)
	if not MIN_SKILL_PAT and type(ITEM_MIN_SKILL) == "string" then
		-- Placeholders first (also the positional %1$s / %2$d some clients use), then escape the rest, then the captures.
		local p = ITEM_MIN_SKILL:gsub("%%%d%$s", "\1"):gsub("%%%d%$d", "\2"):gsub("%%s", "\1"):gsub("%%d", "\2")
		p = p:gsub("[%(%)%.%[%]%+%-%*%?%^%$%%]", "%%%0")
		p = p:gsub("\1", "(.+)"):gsub("\2", "(%%d+)")
		MIN_SKILL_PAT = "^" .. p .. "$"
	end
	if not MIN_SKILL_PAT then
		return nil
	end
	for _, l in ipairs(Lines(data)) do
		local t = l and l.leftText
		if Readable(t) and type(t) == "string" then
			local a, b = t:match(MIN_SKILL_PAT)
			local n = tonumber(b) or tonumber(a) -- the number may come first in another language
			if n then
				return n
			end
		end
	end
	return nil
end

local function Known(guid)
	local all = ns.db and ns.db.foreverKnownRecipes
	local t = type(all) == "table" and all[guid]
	return type(t) == "table" and next(t) ~= nil and t or nil
end

--- The recipe line, or nil + why.
local function RecipeLine(id, data, sub)
	local line = RECIPE_LINE[sub]
	if not line then
		return nil, "a recipe book, no profession"
	end
	local need = NeedSkill(data)
	local spell = ns.IS_FOREVER and ns.ForeverRecipeTeaches and ns.ForeverRecipeTeaches(id) or nil
	local parts, profName, apart = {}, nil, {}
	for _, c in ipairs(Others()) do
		local p = c.profs[line]
		if p and c.reach == "faction" then
			apart[#apart + 1] = c.name
		elseif p then
			profName = profName or p.name
			local bits = {}
			if p.rank then
				bits[#bits + 1] = tostring(p.rank)
			end
			if ns.IS_FOREVER then
				local known = Known(c.guid)
				if known and spell and known[spell] then
					bits[#bits + 1] = ns:L("FALT_KNOWS")
				elseif need and p.rank and p.rank < need then
					bits[#bits + 1] = ns:L("FALT_NEEDS_FMT"):format(need)
				elseif known and need and p.rank then
					bits[#bits + 1] = ns:L("FALT_CAN")
				end
			end
			parts[#parts + 1] = #bits > 0 and ("%s (%s)"):format(Shown(c), table.concat(bits, ", ")) or Shown(c)
		end
	end
	if #parts == 0 then
		return nil, ("no other character with skill line %d you can mail to (%d of the other faction)"):format(line,
			#apart)
	end
	return ns:L("FALT_RECIPE_FMT"):format(profName or "?", table.concat(parts, ", ")) .. FactionTail(apart),
		("recipe, skill line %d, needs %s, %d character(s), %d other faction"):format(line, tostring(need), #parts,
			#apart)
end

--- The ingredient line, or nil + why.
local function IngredientLine(id)
	local keys = ns.ReagentUseKeys and ns.ReagentUseKeys(id)
	if not keys then
		return nil, "not an ingredient in our list"
	end
	local others = Others()
	local groups, apart, seenApart = {}, {}, {}
	for _, key in ipairs(keys) do
		local line = KeyLine(key)
		local names, profName = {}, nil
		for _, c in ipairs(others) do
			local p = line and c.profs[line]
			if p and c.reach == "faction" then
				if not seenApart[c.name] then
					seenApart[c.name] = true
					apart[#apart + 1] = c.name
				end
			elseif p then
				profName = profName or p.name
				names[#names + 1] = Shown(c)
			end
		end
		if #names > 0 then
			groups[#groups + 1] = ("%s: %s"):format(profName or key, table.concat(names, ", "))
		end
	end
	if #groups == 0 then
		return nil, ("no other character you can mail to has a profession that uses it (%d of the other faction)")
			:format(#apart)
	end
	return ns:L("FALT_MAT_FMT"):format(table.concat(groups, " · ")) .. FactionTail(apart),
		("ingredient, %d profession(s), %d other faction"):format(#groups, #apart)
end

--------------------------------------------------------------------------------
-- Gear (25 Nov 2026, step 2; Rob via Sparring, on the advice "in beide games eerst 'kan dragen + hoger item level'.
-- Forever gaat dan ook de gear onthouden": "Zeg je ja? JA"). Who of your other characters can wear this weapon or
-- armor, from which level, and whether its item level is higher than what that character wears in that slot (rings
-- and trinkets: the lower of the two). Never "better": no stats, no spec guess.
-- Who may wear what: MEASURED 25 Nov 2026 in wago DB2 SkillRaceClassInfo (Forever 1.60.1.71091, Midnight 12.1.5.70961),
-- the union of ClassMask over all rows of a skill (class bit = 2^(classID-1); Midnight's bit 16384 is no class of ours).
-- Forever: Mail for Hunter/Shaman and Plate for Warrior/Paladin from level 40 (MinLevel 40, Availability 0).
--------------------------------------------------------------------------------
local GAME = ns.IS_FOREVER and {
	-- 7 libram / 8 idol / 9 totem: Paladin / Druid / Shaman, AFGELEID (classic rule; not in that table).
	armor = { [1] = 1503, [2] = 1103, [3] = 3, [4] = 0, [6] = 67, [7] = 2, [8] = 1024, [9] = 64 },
	armorAt40 = { [3] = 68, [4] = 3 },
	weapon = { [0] = 79, [1] = 71, [2] = 13, [3] = 13, [4] = 1115, [5] = 1091, [6] = 1031, [7] = 399, [8] = 7,
		[10] = 1493, [13] = 1101, [15] = 1501, [16] = 13, [18] = 13, [19] = 400 },
	weaponLevel = { [6] = 20 }, -- Polearms from level 20 (MinLevel 20)
} or {
	armor = { [1] = -1, [2] = 7791, [3] = 4199, [4] = 35, [6] = 67 },
	armorAt40 = {},
	weapon = { [0] = 6767, [1] = 4199, [2] = 13, [3] = 13, [4] = 5755, [5] = 5219, [6] = 1575, [7] = 7087, [8] = 4135,
		[9] = 2048, [10] = 6101, [13] = 7757, [15] = 7645, [18] = 13, [19] = 400 },
	weaponLevel = {},
}
local CLASS_ID = { WARRIOR = 1, PALADIN = 2, HUNTER = 3, ROGUE = 4, PRIEST = 5, DEATHKNIGHT = 6, SHAMAN = 7, MAGE = 8,
	WARLOCK = 9, MONK = 10, DRUID = 11, DEMONHUNTER = 12, EVOKER = 13 }

local function HasBit(mask, classID)
	if mask == -1 then
		return true
	end
	local bit = 2 ^ (classID - 1)
	return math.floor(mask / bit) % 2 == 1
end

-- equip location -> the slot(s) to compare with (two = the lower of the two)
local SLOT_OF = {
	INVTYPE_HEAD = { 1 }, INVTYPE_NECK = { 2 }, INVTYPE_SHOULDER = { 3 }, INVTYPE_CHEST = { 5 }, INVTYPE_ROBE = { 5 },
	INVTYPE_WAIST = { 6 }, INVTYPE_LEGS = { 7 }, INVTYPE_FEET = { 8 }, INVTYPE_WRIST = { 9 }, INVTYPE_HAND = { 10 },
	INVTYPE_FINGER = { 11, 12 }, INVTYPE_TRINKET = { 13, 14 }, INVTYPE_CLOAK = { 15 },
	INVTYPE_WEAPON = { 16 }, INVTYPE_2HWEAPON = { 16 }, INVTYPE_WEAPONMAINHAND = { 16 },
	INVTYPE_WEAPONOFFHAND = { 17 }, INVTYPE_SHIELD = { 17 }, INVTYPE_HOLDABLE = { 17 },
	INVTYPE_RANGED = { ns.IS_FOREVER and 18 or 16 }, INVTYPE_RANGEDRIGHT = { ns.IS_FOREVER and 18 or 16 },
	INVTYPE_THROWN = { 18 }, INVTYPE_RELIC = { 18 },
}

local function ItemLevel(link)
	if C_Item and C_Item.GetDetailedItemLevelInfo then
		local ok, v = pcall(C_Item.GetDetailedItemLevelInfo, link)
		if ok and tonumber(v) then
			return math.floor(tonumber(v))
		end
	end
	local info = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	if info then
		local ok, _, _, _, v = pcall(info, link)
		if ok and tonumber(v) then
			return math.floor(tonumber(v))
		end
	end
	return nil
end

--- The other characters with their class, level and saved gear: { name, class, level, gear }.
local function OthersGear()
	local out, me = {}, MyGUID()
	local store = ns.db and (ns.IS_FOREVER and ns.db.foreverChars or ns.db.charCurrencies)
	if type(store) ~= "table" then
		return out
	end
	for guid, rec in pairs(store) do
		local reach = type(rec) == "table" and Reach(rec, guid) or nil
		if guid ~= me and type(rec) == "table" and type(rec.name) == "string" and CLASS_ID[rec.class or ""]
			and reach ~= "realm" then
			out[#out + 1] = { name = rec.name, classID = CLASS_ID[rec.class], level = tonumber(rec.level),
				gear = type(rec.gear) == "table" and rec.gear or nil, reach = reach }
		end
	end
	return out
end

--- The gear line, or nil + why. link = the hovered item's link (for its item level).
local function GearLine(id, link, classID, subID, equipLoc, minLevel)
	local slots = SLOT_OF[equipLoc or ""]
	if not slots then
		return nil, "not something you wear"
	end
	local mask, at40, needLevel
	if classID == 4 then
		mask, at40 = GAME.armor[subID], GAME.armorAt40[subID]
		if subID == 0 then
			mask = -1 -- rings, necks, trinkets, off-hand items: every class
		end
	elseif classID == 2 then
		mask, needLevel = GAME.weapon[subID], GAME.weaponLevel[subID]
	end
	if not mask then
		return nil, ("item class %s subclass %s: not judged"):format(tostring(classID), tostring(subID))
	end
	local ilvl = link and ItemLevel(link)
	local rows, apart = {}, {}
	for _, c in ipairs(OthersGear()) do
		local can, from = HasBit(mask, c.classID), nil
		if not can and at40 and HasBit(at40, c.classID) then
			can, from = true, 40
		end
		if can and c.reach == "faction" then
			apart[#apart + 1] = c.name
		elseif can then
			from = math.max(from or 0, needLevel or 0, tonumber(minLevel) or 0)
			local row = { name = Shown(c), gain = -1 }
			if c.level and from > c.level then
				row.from = from
			elseif ilvl and c.gear then
				local worst
				for _, s in ipairs(slots) do
					local g = c.gear[s]
					local v = type(g) == "table" and tonumber(g.i) or nil
					if not g then
						v = 0 -- an empty slot: anything is more
					end
					if v and (not worst or v < worst) then
						worst = v
					end
				end
				if worst and ilvl > worst then
					row.was, row.now, row.gain = worst, ilvl, ilvl - worst
					row.empty = (worst == 0)
				end
			end
			rows[#rows + 1] = row
		end
	end
	if #rows == 0 then
		return nil, ("none of your other characters you can mail to can wear it (%d of the other faction)"):format(#apart)
	end
	table.sort(rows, function(a, b)
		if a.gain ~= b.gain then
			return a.gain > b.gain
		end
		return tostring(a.name) < tostring(b.name)
	end)
	local parts = {}
	for i = 1, math.min(3, #rows) do
		local r = rows[i]
		if r.from then
			parts[#parts + 1] = ns:L("FALT_GEAR_LEVEL_FMT"):format(r.name, r.from)
		elseif r.empty then
			parts[#parts + 1] = ns:L("FALT_GEAR_EMPTY_FMT"):format(r.name)
		elseif r.now then
			parts[#parts + 1] = ns:L("FALT_GEAR_UP_FMT"):format(r.name, r.was, r.now)
		else
			parts[#parts + 1] = r.name
		end
	end
	local text = table.concat(parts, ", ")
	if #rows > 3 then
		text = text .. ns:L("FALT_MORE_FMT"):format(#rows - 3)
	end
	return ns:L("FALT_GEAR_FMT"):format(text) .. FactionTail(apart),
		("gear, %d character(s), %d other faction, item level %s"):format(#rows, #apart, tostring(ilvl))
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType
	and Enum.TooltipDataType.Item then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
		if not On() or not (tooltip == GameTooltip or tooltip == ItemRefTooltip) then
			return
		end
		local ok, err = pcall(function()
			local id = type(data) == "table" and data.id
			if type(id) ~= "number" or not Readable(id) then
				return
			end
			local can, why = Sendable(id, data)
			if not can then
				last = ("item %d: no line, %s"):format(id, why)
				return
			end
			local inst = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
			local classID, subID, equipLoc
			if inst then
				local okI, _, _, _, loc, _, c, s = pcall(inst, id)
				if okI then
					classID, subID, equipLoc = c, s, loc
				end
			end
			local text, reason
			if classID == 9 then
				text, reason = RecipeLine(id, data, subID)
			elseif classID == 2 or classID == 4 then
				-- Not "a and b:GetItem()": an `and` keeps only the first value, and the link is the second.
				local link
				if tooltip.GetItem then
					local _, l = tooltip:GetItem()
					link = l
				end
				local minLevel, quality
				local info = (C_Item and C_Item.GetItemInfo) or GetItemInfo
				if info then
					local okM, _, _, q, _, ml = pcall(info, link or id)
					minLevel = okM and ml or nil
					quality = okM and q or nil
				end
				-- 25 Nov 2026 (Rob via Sparring: "Ja, op 1 en 2"): no gear line for a grey (Poor) item: nobody mails junk.
				-- White stays: at low level white gear is real gear (Rob's Nomadic Gloves are white, |cnIQ1 in his SV).
				if quality == 0 then
					text, reason = nil, "a grey (Poor) item: no gear line"
				else
					text, reason = GearLine(id, link, classID, subID, equipLoc, minLevel)
				end
			else
				text, reason = IngredientLine(id)
			end
			if text then
				tooltip:AddLine(text, 0.6, 0.8, 1, true)
				tooltip:Show()
				last = ("item %d: shown (%s)"):format(id, reason)
			else
				last = ("item %d: no line, %s"):format(id, reason)
			end
		end)
		if not ok then
			last = "error: " .. tostring(err)
		end
	end)
else
	last = "this client has no TooltipDataProcessor"
end

--- /mh alttip [on|off]: the switch, and what MH decided for the last item and why.
function ns.AltProfTipSlash(arg)
	arg = (arg or ""):lower()
	ns.db = ns.db or {}
	if arg == "on" then
		ns.db.altProfTip = nil
	elseif arg == "off" then
		ns.db.altProfTip = false
	end
	local others = Others()
	local withProf = 0
	for _, c in ipairs(others) do
		if next(c.profs) then
			withProf = withProf + 1
		end
	end
	print(PREFIX .. ("other characters in tooltips: %s (/mh alttip on|off). Saved other characters: %d, with a profession: %d.")
		:format(On() and "on" or "off", #others, withProf))
	print("  last item: " .. last)
	-- who counts as someone you can mail to, and why (25 Nov 2026)
	local store = ns.db and (ns.IS_FOREVER and ns.db.foreverChars or ns.db.charCurrencies)
	local rowsOut, me = {}, MyGUID()
	for guid, rec in pairs(type(store) == "table" and store or {}) do
		if guid ~= me and type(rec) == "table" and type(rec.name) == "string" then
			local r, why = Reach(rec, guid)
			local word = (r == "ok" and "counts") or (r == "unknown" and "counts, marked (faction ?)")
				or (r == "faction" and "apart at the end") or "left out"
			rowsOut[#rowsOut + 1] = ("  %s: %s (%s)"):format(rec.name, word, why)
		end
	end
	table.sort(rowsOut)
	for _, l in ipairs(rowsOut) do
		print(l)
	end
end
ns.AltProfTipReach = Reach -- the offline check calls it

--- For the settings switch.
function ns.IsAltProfTipOn()
	return On()
end

function ns.SetAltProfTip(on)
	ns.db = ns.db or {}
	if on then
		ns.db.altProfTip = nil
	else
		ns.db.altProfTip = false
	end
end
