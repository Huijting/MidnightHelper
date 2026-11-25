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

	Two lines, only for an item you can send (not Soulbound, not "Binds when picked up", not a quest item):
	  recipe      "MH: your other Alchemy: Ima (14, needs 50), Bob (60, can learn it)"
	  ingredient  "MH: on your other characters: Alchemy: Ima · Cooking: Bob"
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

--- Your OTHER characters: { guid, name, profs = { [skill line] = { name, rank, max } } }.
local function Others()
	local out, me = {}, MyGUID()
	local store = ns.db and (ns.IS_FOREVER and ns.db.foreverChars or ns.db.charCurrencies)
	if type(store) ~= "table" then
		return out
	end
	for guid, rec in pairs(store) do
		if guid ~= me and type(rec) == "table" and type(rec.name) == "string" and type(rec.profs) == "table" then
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
			out[#out + 1] = { guid = guid, name = rec.name, profs = profs }
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
	local parts, profName = {}, nil
	for _, c in ipairs(Others()) do
		local p = c.profs[line]
		if p then
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
			parts[#parts + 1] = #bits > 0 and ("%s (%s)"):format(c.name, table.concat(bits, ", ")) or c.name
		end
	end
	if #parts == 0 then
		return nil, ("no other character with skill line %d"):format(line)
	end
	return ns:L("FALT_RECIPE_FMT"):format(profName or "?", table.concat(parts, ", ")),
		("recipe, skill line %d, needs %s, %d character(s)"):format(line, tostring(need), #parts)
end

--- The ingredient line, or nil + why.
local function IngredientLine(id)
	local keys = ns.ReagentUseKeys and ns.ReagentUseKeys(id)
	if not keys then
		return nil, "not an ingredient in our list"
	end
	local others = Others()
	local groups = {}
	for _, key in ipairs(keys) do
		local line = KeyLine(key)
		local names, profName = {}, nil
		for _, c in ipairs(others) do
			local p = line and c.profs[line]
			if p then
				profName = profName or p.name
				names[#names + 1] = c.name
			end
		end
		if #names > 0 then
			groups[#groups + 1] = ("%s: %s"):format(profName or key, table.concat(names, ", "))
		end
	end
	if #groups == 0 then
		return nil, "no other character has a profession that uses it"
	end
	return ns:L("FALT_MAT_FMT"):format(table.concat(groups, " · ")), ("ingredient, %d profession(s)"):format(#groups)
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
			local classID, subID
			if inst then
				local okI, _, _, _, _, _, c, s = pcall(inst, id)
				if okI then
					classID, subID = c, s
				end
			end
			local text, reason
			if classID == 9 then
				text, reason = RecipeLine(id, data, subID)
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
end

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
