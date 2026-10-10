--[[
	Live keys: which key a spell is bound to RIGHT NOW on the player's own action bars.

	Rob, 27 sep 2026, for the "How you play" window: "dat die ook realtime kijkt waar wij ze
	hebben neergezet op ons keyboard. Dus niet waar we ze zouden moeten zetten volgens ons
	systeem, maar waar ze werkelijk staan." So this never looks at our keybind scheme. It
	asks the bars what sits in each slot and the binding list which key drives that button.

	Standard Blizzard bars (the eight binding commands in ns.KEYBIND_BAR_COMMANDS), and since
	10 Oct 2026 Bartender4 and ElvUI through LibActionButton (LabSlots below). Other bar addons
	(Dominos, EllesmereUI) are not read yet.

	Matching, cheapest first: the exact spell id, then either side's BASE spell (a talent or
	a proc can put another id on the same button -- Hammer of Light on Eye of Tyr), then a
	macro, which GetActionInfo reports as the spell it casts. The Single-Button Assistant
	slot is skipped: it wears whatever it suggests and is not that spell.

	Reads only. `/mh playkeys` prints the decision per spell, including why a spell has no key.
]]

local _, ns = ...

local function Base(id)
	if not id then
		return nil
	end
	if FindBaseSpellByID then
		local ok, b = pcall(FindBaseSpellByID, id)
		if ok and b then
			return b
		end
	end
	return id
end

--- The client's own name for a spell id (localised, so it compares within one client only).
local function SpellName(id)
	if not (id and C_Spell and C_Spell.GetSpellName) then
		return nil
	end
	local ok, n = pcall(C_Spell.GetSpellName, id)
	if ok and type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
		return n
	end
	return nil
end

--- Bar addons built on LibActionButton (LAB): Bartender4 and ElvUI. Rob, 9 Oct 2026, after /mh presses: "laat
--- mh-research Bartender en ElvUI uitzoeken", then "begin maar". Research: docs/BAR_ADDONS_LIVEKEYS_2026-10-09.md
--- (sources read on GitHub at pinned commits; neither addon is installed here, so NOT yet seen in a client).
--- Each LAB button says which binding command drives it (GetBindingAction: a Blizzard name such as ACTIONBUTTON1, an
--- ELVUIBAR2BUTTON1, or "CLICK BT4Button13:Keybind") and which action slot it shows NOW (_state_action, kept up to
--- date across page and stance changes). Both addons park Blizzard's own buttons, whose "action" attribute then no
--- longer follows the page; so a LAB button's answer wins over MH_CommandSlotMap for the same command.
--- READ ONLY: fields and GetBindingAction, never SetAttribute, bindings or hooks.
--- ElvUI ships its own copy under another name, so LibStub("LibActionButton-1.0") alone would not see it.
local LAB_LIBS = {
	{ major = "LibActionButton-1.0", src = "LAB" },
	{ major = "LibActionButton-1.0-ElvUI", src = "ElvUI" },
}

local function LabSlots(map, src)
	local LibStub = _G.LibStub
	if not LibStub then
		return
	end
	for _, l in ipairs(LAB_LIBS) do
		local okL, lib = pcall(LibStub, l.major, true)
		local okB, buttons = false, nil
		if okL and lib and lib.GetAllButtons then
			okB, buttons = pcall(lib.GetAllButtons, lib)
		end
		for btn in pairs(okB and type(buttons) == "table" and buttons or {}) do
			local header = btn.header
			if not (header and header.disabled) and btn.GetBindingAction then
				local okC, cmd = pcall(btn.GetBindingAction, btn)
				if okC and type(cmd) == "string" and cmd ~= "" then
					local slot = btn._state_type == "action" and tonumber(btn._state_action) or nil
					if slot and issecretvalue and issecretvalue(slot) then
						slot = nil
					end
					-- An empty or non-action state still claims the command: the parked Blizzard slot is stale.
					map[cmd] = slot or false
					local name = btn.GetName and btn:GetName() or ""
					src[cmd] = (l.src == "LAB" and name:match("^BT4Button")) and "Bartender4" or l.src
				end
			end
		end
	end
end

--- binding command -> slot, as the buttons themselves report it (this follows the main bar's
--- page and a druid's forms); the fixed table when a button frame is missing. Then the bar
--- addons' own buttons on top. Second return: command -> where the slot came from.
local function CommandSlots()
	local map = ns.MH_CommandSlotMap and ns.MH_CommandSlotMap() or {}
	local src = {}
	for _, bar in ipairs(ns.KEYBIND_BAR_COMMANDS or {}) do
		for i = 1, 12 do
			local cmd = bar.prefix .. i
			if not map[cmd] then
				map[cmd] = bar.first + i - 1
			end
		end
	end
	for cmd in pairs(map) do
		src[cmd] = "Blizzard"
	end
	LabSlots(map, src)
	return map, src
end

--- What the player sees on the button: Blizzard's own short form ("S-2", "M4"), else the key.
local function ShortKey(key)
	if GetBindingText then
		local ok, s = pcall(GetBindingText, key, true)
		if ok and type(s) == "string" and s ~= "" then
			return s
		end
	end
	return key
end

-- Rebuilt at most once per redraw burst; the window calls ns.LiveKeysInvalidate on bar events.
local cache

function ns.LiveKeysInvalidate()
	cache = nil
end

local function Build()
	local slots = {}
	local map, src = CommandSlots()
	for cmd, slot in pairs(map) do
		local key
		if slot and GetBindingKey then
			local ok, k1 = pcall(GetBindingKey, cmd)
			key = ok and k1 or nil
		end
		if key and key ~= "" and GetActionInfo then
			local okA, kind, id = pcall(GetActionInfo, slot)
			local assisted = false
			if C_ActionBar and C_ActionBar.IsAssistedCombatAction then
				local okS, v = pcall(C_ActionBar.IsAssistedCombatAction, slot)
				assisted = okS and v and true or false
			end
			if okA and (kind == "spell" or kind == "macro") and id and not assisted
				and not (issecretvalue and issecretvalue(id)) then
				slots[#slots + 1] = { slot = slot, cmd = cmd, key = key, kind = kind, id = id, base = Base(id),
					name = SpellName(id), src = src[cmd] or "?" }
			end
		end
	end
	-- With the key block placed, its bars come right after the main bar: placing parks the old
	-- buttons on bar 4 (block D, slots 25-36), which sorts before bar 5 (37-48). MEASURED 5 Oct 2026
	-- on Rob's Discipline Priest: Flash Heal on block 3 and its parked copy on Alt C, and the card
	-- said [Alt C]. Without the block: main bar first, then slot order, as before.
	-- 5 Oct 2026 evening, Rob's sister's Balance Druid: the card said Revive [F8] while the block has
	-- Revive on F3 (Rob: "er staat echt F8"). Where F8 comes from is NOT measured; /mh playkeys shows it.
	-- What is sure: with the block placed, the block IS the main bar (keys 1-5 left bar 1), so a copy on
	-- bar 1 with some other key must not win. Block first, then bar 1, then the rest.
	local rank = {}
	local blockPlaced = ns.KeyBlockIsPlaced and ns.KeyBlockIsPlaced() and ns.KeyBlockBars and true or false
	if blockPlaced then
		local bars = ns.KeyBlockBars()
		for _, letter in ipairs({ "A", "B", "C" }) do
			local bar = (ns.KEYBIND_BAR_COMMANDS or {})[bars[letter]]
			if bar then
				rank[bar.prefix] = 0
			end
		end
	end
	local function Rank(s)
		local prefix = s.cmd:match("^(.-)%d+$") or ""
		if rank[prefix] then
			return rank[prefix]
		end
		if prefix == "ACTIONBUTTON" then
			return blockPlaced and 1 or 0
		end
		return 2
	end
	for _, s in ipairs(slots) do
		s.rank = Rank(s)
	end
	table.sort(slots, function(a, b)
		if a.rank ~= b.rank then
			return a.rank < b.rank
		end
		return a.slot < b.slot
	end)
	return slots
end

--- Every bound action button that holds a spell or macro, in rank order (KeyPresses: the never-pressed spells on easy
--- keys are swap places too). The list is the cache itself: read it, do not change it.
function ns.LiveKeysAll()
	cache = cache or Build()
	return cache
end

--- @return string|nil shortKey, table|nil hit  (hit: slot, cmd, key, kind, id)
function ns.LiveKeyForSpell(spellID)
	if not spellID then
		return nil
	end
	cache = cache or Build()
	local base = Base(spellID)
	-- Last resort, the same name in this client: a spec can carry its own spell under the same name.
	-- MEASURED 5 Oct 2026 on Carola's Balance Druid: Wrath sat on block key 1 and /mh playkeys said
	-- "not on a bound button". DERIVED, not measured: Balance Wrath is its own id (190984 per
	-- mh-research) and the card asks for another. Same shape: Intimidation, Kill Command, Execute.
	local name = SpellName(spellID)
	local byBase, byName
	for _, s in ipairs(cache) do
		if s.id == spellID then
			return ShortKey(s.key), s
		end
		if not byBase and s.base == base then
			byBase = s
		end
		if not byName and name and s.kind == "spell" and s.name == name then
			byName = s
		end
	end
	local hit = byBase or byName
	if hit then
		return ShortKey(hit.key), hit
	end
	return nil
end

--- `/mh playkeys`: for the active spec, every spell on the card and on Stay alive, with its key.
function ns.PrintPlayKeys()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	ns.LiveKeysInvalidate()
	cache = Build()
	print(("%s live keys: %d bound action buttons hold a spell or macro"):format(prefix, #cache))
	-- Where they came from, so "no Bartender buttons seen" is visible instead of silent.
	local bySrc = {}
	for _, s in ipairs(cache) do
		bySrc[s.src] = (bySrc[s.src] or 0) + 1
	end
	print(("   sources: Blizzard %d, Bartender4 %d, ElvUI %d, other LibActionButton %d"):format(bySrc.Blizzard or 0,
		bySrc.Bartender4 or 0, bySrc.ElvUI or 0, bySrc.LAB or 0))
	local specID
	if ns.GetSpecialization and ns.GetSpecializationInfo then
		local idx = ns.GetSpecialization()
		specID = idx and ns.GetSpecializationInfo(idx) or nil
	end
	local ids, seen = {}, {}
	local card = specID and ns.GetPlayCard and ns.GetPlayCard(specID)
	for _, s in ipairs((card and card.steps) or {}) do
		if s.spellID and not seen[s.spellID] then
			seen[s.spellID] = true
			ids[#ids + 1] = s.spellID
		end
	end
	for _, s in ipairs((ns.GetSurvivalPlan and ns.GetSurvivalPlan(specID)) or {}) do
		if s.spellID and not seen[s.spellID] then
			seen[s.spellID] = true
			ids[#ids + 1] = s.spellID
		end
	end
	for _, id in ipairs(ids) do
		local name = C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(id) or tostring(id)
		local short, hit = ns.LiveKeyForSpell(id)
		if short then
			print(("   %-24s %-6s slot %d (%s, %s %d, %s)"):format(name, short, hit.slot, hit.cmd, hit.kind, hit.id,
				hit.src or "?"))
		else
			print(("   %-24s |cff9d9d9dnot on a bound button (Blizzard bars, Bartender4, ElvUI)|r"):format(name))
		end
	end
end
