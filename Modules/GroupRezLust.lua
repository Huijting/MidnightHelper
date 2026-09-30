--[[
	Battle res and Bloodlust for your group (Rob, 30 Sep 2026).

	Rob saw DDingUI Toolkit on CurseForge (All Rights Reserved: the IDEA only, no code) and
	asked for battle res charges and Bloodlust in MH: "werk die maar uit". Measured that day:
	nothing in MH showed either. His own EllesmereUI already has both as icons (battle res on
	in M+ and raid, Bloodlust switched to "Never"), so he chose an MH version WITH explanation
	that stands down per line where EllesmereUI's icon is already showing.

	What MH adds over an icon is the part a newer player cannot see: WHO in the group can
	revive or cast Bloodlust, and what the two things are (hover the panel).

	⚠️ THE TWO READS ARE CANDIDATES, NOT MEASUREMENTS. Both come from EllesmereUIQoL, a
	12.1-only addon, read on 30 Sep 2026 as a source of candidates (never code):
	  - `C_Spell.GetSpellCharges(20484)` (Rebirth) reports the SHARED group pool inside a
	    Mythic+ key or a raid boss fight, for every class. It compares the numbers without a
	    secret guard, which suggests they are plain on 12.1.
	  - `C_UnitAuras.GetPlayerAuraBySpellID(<Sated id>)` keeps answering mid-fight because the
	    Sated-type debuffs are "field-proven unflagged"; the lockout is 10 minutes.
	Neither is measured on Rob's client yet. So every read here is guarded as if it could be
	secret or wrong, and the first readings per situation go to `ns.db.rezLustLog`, which
	`/mh lust` prints. That log is what turns the candidates into GEMETEN.

	⚠️ THREE STATES FOR BLOODLUST, same rule as ns.Aura: "used", "ready", and "can't read".
	In combat the aura API can answer "nothing" for a debuff you are carrying (Auras.lua,
	measured 12 Aug and 31 Aug), so a "nothing" read while auras are secret never clears a
	lockout we already saw. A sighting always counts.

	Silence is a normal outcome here (the panel only shows in a group inside a dungeon, delve or
	raid; or, with the setting, only in Mythic dungeons, keys and raids), so `/mh lust` prints the decision and the reason, and `/mh lust test` shows the
	panel for 30 seconds wherever you are, with the real readings.
]]

local _, ns = ...

local REBIRTH = 20484 -- the shared battle res pool answers under this id (candidate, see above)
local LOCKOUT = 600 -- Sated lasts 10 minutes; used only when the real expiry is hidden
-- MEASURED 30 Sep 2026 (Rob, raid boss): the pool read 99 of 99, then 98 with 108 s to the next.
-- A pool that large is no limit in practice, so the panel says that instead of counting.
local UNLIMITED = 20

--- Every Bloodlust variant's lockout debuff. Same list in EllesmereUIQoL and JustAC.
local SATED = {
	57723, -- Exhaustion (Heroism)
	57724, -- Sated (Bloodlust)
	80354, -- Temporal Displacement (Time Warp)
	95809, -- Insanity (Ancient Hysteria)
	160455, -- Fatigued (Netherwinds)
	264689, -- Fatigued (Primal Rage)
	390435, -- Exhaustion (Fury of the Aspects)
}

--- Classes with a battle res: Rebirth 20484, Raise Ally 61999, Soulstone 20707, Intercession
--- (461622 in 12.0, `KeybindingData.lua`). JustAC's battle-res category lists exactly these four.
local BREZ_CLASSES = { DRUID = true, DEATHKNIGHT = true, WARLOCK = true, PALADIN = true }

--- The spell each class uses, so the panel can say "Druid - Rebirth" (Rob, 30 Sep: "voor elke spec
--- zijn eigen naam"). Names come from the client, so they are in the player's own language.
--- A Shaman's is Heroism for the Alliance and Bloodlust for the Horde (KeybindingData.lua:50).
local CLASS_SPELL = {
	DRUID = 20484, DEATHKNIGHT = 61999, WARLOCK = 20707, PALADIN = 461622,
	MAGE = 80353, EVOKER = 390386, HUNTER = 264667,
	SHAMAN = function(unit)
		local ok, faction = pcall(UnitFactionGroup, unit)
		return (ok and faction == "Alliance") and 32182 or 2825
	end,
}

--- Classes with a Bloodlust: Bloodlust/Heroism 2825/32182, Time Warp 80353, Fury of the
--- Aspects 390386, and the hunter's pet (Primal Rage 264667). "pet" = only with the right pet,
--- which we cannot see on somebody else, so the panel says so instead of promising it.
local LUST_CLASSES = { SHAMAN = true, MAGE = true, EVOKER = true, HUNTER = "pet" }

--- Your own spell for each, tried in order; the first one you know is shown with its key
--- (Rob, 30 Sep: "zodat ik niet eerst moet zoeken bij mijn spells"). Intercession is 461622 in
--- 12.0 and was 391054 in Dragonflight (`KeybindingData.lua`); Primal Rage is the pet's spell.
local MY_BREZ = { 20484, 61999, 20707, 461622, 391054 }
local MY_LUST = { 2825, 32182, 80353, 390386, 272678, 264667 }
--- The ordinary resurrection, out of combat (Rob, 30 Sep: "ook de normale res buiten combat").
--- Redemption, Resurrection, Ancestral Spirit, Revive, Resuscitate, Return: JustAC's resurrect list.
local MY_RES = { 7328, 2006, 2008, 50769, 115178, 361227 }

local MAX_NAMES = 3
local PANEL_W = 300
local PAD = 10
local TEST_SECONDS = 30

local function Secret(v)
	return issecretvalue and issecretvalue(v)
end

local function Readable(v)
	return v ~= nil and not Secret(v)
end

local function Now()
	return GetTime and GetTime() or 0
end

local function InCombat()
	return InCombatLockdown and InCombatLockdown() or false
end

local function Prefix()
	return ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
end

--------------------------------------------------------------------------------
-- Setting
--------------------------------------------------------------------------------

local function Ui()
	return ns.db and ns.db.ui
end

function ns.IsRezLustEnabled()
	local ui = Ui()
	return not (type(ui) == "table" and ui.rezLust == false)
end

--- Rob, 30 Sep 2026: "waarom zien we het niet in een delve als we met meerdere zijn, of überhaupt
--- in groepen?" The first version showed only where the SHARED battle res pool exists (keys, raid
--- bosses). Now it shows in every group instance by default; this switch brings back the narrow
--- version for players who want less on screen.
function ns.IsRezLustKeyRaidOnly()
	local ui = Ui()
	return type(ui) == "table" and ui.rezLustKeyRaidOnly == true
end

--------------------------------------------------------------------------------
-- Where are we?
--------------------------------------------------------------------------------

local encounterActive = false

--- A timed keystone run is going. The dungeon's difficulty only turns into Mythic
--- Keystone once the key is in, and IsChallengeModeActive only while the timer runs.
local function InKey()
	local cm = C_ChallengeMode
	if not (cm and cm.IsChallengeModeActive) then
		return false
	end
	local ok, active = pcall(cm.IsChallengeModeActive)
	return ok and active == true
end

local function InBossFight()
	if encounterActive then
		return true
	end
	if IsEncounterInProgress then
		local ok, v = pcall(IsEncounterInProgress)
		return ok and v == true
	end
	return false
end

--- @return string|nil where ("key", "mythic", "raid", "dungeon", "scenario") and the instance
--- type, or nil outside instances. "scenario" is where delves live.
local function Place()
	if not GetInstanceInfo then
		return nil
	end
	local _, kind, difficulty = GetInstanceInfo()
	if kind == "raid" then
		return "raid", kind
	end
	if kind == "party" then
		if InKey() or difficulty == 8 then
			return "key", kind
		end
		if difficulty == 23 then
			return "mythic", kind
		end
		return "dungeon", kind
	end
	if kind == "scenario" then
		return "scenario", kind
	end
	return nil, kind
end

local NARROW = { key = true, mythic = true, raid = true }

--- Where the shared pool applies: in a key, and during a raid boss fight.
local function PoolContext()
	local place = Place()
	if place == "key" then
		return "key"
	end
	if place == "raid" and InBossFight() then
		return "raidboss"
	end
	return nil
end

--------------------------------------------------------------------------------
-- EllesmereUI stands in for a line when its own icon is switched on
--------------------------------------------------------------------------------

--- Reads EllesmereUIQoL's own settings through the getter it publishes. Read-only.
--- @param key string "battleRes" or "bloodlust"
local function EllesmereShows(key)
	local get = rawget(_G, "_EUI_BattleRes_DB")
	if type(get) ~= "function" then
		return false
	end
	local ok, db = pcall(get)
	local profile = ok and type(db) == "table" and db.profile
	local slice = type(profile) == "table" and profile[key]
	if type(slice) ~= "table" or not slice.enabled then
		return false
	end
	-- Their own defaults when the key was never written: battle res shows, Bloodlust not.
	local vis = slice.visibility or (key == "battleRes" and "MPLUS_AND_RAID" or "NEVER")
	return vis ~= "NEVER"
end

--------------------------------------------------------------------------------
-- Measurements: the first and the latest reading per situation
--------------------------------------------------------------------------------

local function Log(kind, situation, row)
	ns.db = ns.db or {}
	local log = ns.db.rezLustLog or {}
	ns.db.rezLustLog = log
	log[kind] = log[kind] or {}
	local slot = log[kind][situation] or {}
	log[kind][situation] = slot
	row.at = (time and time()) or 0
	row.build = select(4, GetBuildInfo())
	if not slot.first then
		slot.first = row
	end
	slot.last = row
	slot.count = (slot.count or 0) + 1
end

local function Shape(v)
	if v == nil then
		return "nil"
	end
	if Secret(v) then
		return "secret"
	end
	return tostring(v)
end

--------------------------------------------------------------------------------
-- Battle res
--------------------------------------------------------------------------------

--- @return table|nil charges {cur, max, nextIn}, string why
local function ReadBrez(logIt)
	local fn = C_Spell and C_Spell.GetSpellCharges
	if not fn then
		return nil, "no GetSpellCharges on this client"
	end
	local ok, info = pcall(fn, REBIRTH)
	local cur, max, start, dur
	if ok and type(info) == "table" then
		pcall(function()
			cur, max, start, dur = info.currentCharges, info.maxCharges,
				info.cooldownStartTime, info.cooldownDuration
		end)
	end
	local why, out
	if not ok then
		why = "the game refused"
	elseif type(info) ~= "table" then
		why = "no shared pool here"
	elseif not (Readable(cur) and Readable(max)) then
		why = "charges are hidden (secret)"
	elseif max <= 0 then
		why = "no shared pool here"
	else
		why = "ok"
		out = { cur = cur, max = max }
		if cur < max and Readable(start) and Readable(dur) and dur > 0 then
			local left = start + dur - Now()
			if left > 0 then
				out.nextIn = left
			end
		end
	end
	if logIt then
		local ctx = PoolContext() or "elsewhere"
		local difficulty = GetInstanceInfo and select(3, GetInstanceInfo())
		-- The difficulty goes in the key: 30 Sep 2026 a raid boss reported 99 of 99 charges, and which
		-- difficulty that was could not be told from the log afterwards.
		Log("brez", (InCombat() and "combat:" or "calm:") .. ctx .. ":d" .. tostring(difficulty), {
			result = why, cur = Shape(cur), max = Shape(max), start = Shape(start), dur = Shape(dur),
		})
	end
	return out, why
end

--------------------------------------------------------------------------------
-- Bloodlust: your own lockout debuff
--------------------------------------------------------------------------------

local lust = { expiry = 0, known = false, guess = false, id = nil }

--- @return table|nil aura, boolean answered, number|nil id
local function FindSated()
	local fn = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID
	if not fn then
		return nil, false
	end
	local answered = false
	for _, id in ipairs(SATED) do
		local ok, aura = pcall(fn, id)
		if ok then
			answered = true
			if aura then
				return aura, true, id
			end
		end
	end
	return nil, answered
end

local function Trusted()
	return ns.Aura and ns.Aura.Trusted and ns.Aura.Trusted() or false
end

local function UpdateLust(logIt)
	local aura, answered, id = FindSated()
	local now = Now()
	local combat = InCombat()
	if aura then
		local exp
		pcall(function()
			exp = aura.expirationTime
		end)
		if Readable(exp) and exp > 0 then
			lust.expiry, lust.guess = exp, false
		elseif lust.expiry <= now then
			-- First sighting while the time is hidden: a fresh lockout is 10 minutes.
			lust.expiry, lust.guess = now + LOCKOUT, true
		end
		lust.known, lust.id = true, id
		if logIt then
			Log("lust", combat and "combat:seen" or "calm:seen", {
				id = id, expiration = Shape(exp), trusted = tostring(Trusted()),
			})
		end
	elseif answered and Trusted() then
		lust.expiry, lust.known, lust.guess, lust.id = 0, true, false, nil
		if logIt then
			Log("lust", combat and "combat:none" or "calm:none", { trusted = "true" })
		end
	elseif logIt then
		-- "Nothing" while auras are secret: keep what we knew, and note that it happened.
		Log("lust", combat and "combat:unsure" or "calm:unsure", {
			answered = tostring(answered), trusted = tostring(Trusted()),
		})
	end
end

--- @return string state ("used", "ready", "unknown"), number|nil secondsLeft, boolean guess
local function LustState()
	local left = lust.expiry - Now()
	if left > 0 then
		return "used", left, lust.guess
	end
	if lust.known then
		return "ready"
	end
	return "unknown"
end

--------------------------------------------------------------------------------
-- Who in the group can
--------------------------------------------------------------------------------

local function GroupUnits()
	local units = { "player" }
	if IsInRaid and IsInRaid() then
		for i = 1, 40 do
			local u = "raid" .. i
			if UnitExists(u) and not UnitIsUnit(u, "player") then
				units[#units + 1] = u
			end
		end
	elseif IsInGroup and IsInGroup() then
		for i = 1, 4 do
			local u = "party" .. i
			if UnitExists(u) then
				units[#units + 1] = u
			end
		end
	end
	return units
end

local function ClassName(classFile)
	local names = rawget(_G, "LOCALIZED_CLASS_NAMES_MALE")
	return (type(names) == "table" and names[classFile]) or classFile
end

local function Colour(classFile, text)
	if C_ClassColor and C_ClassColor.GetClassColor then
		local ok, c = pcall(C_ClassColor.GetClassColor, classFile)
		if ok and c and c.WrapTextInColorCode then
			return c:WrapTextInColorCode(text)
		end
	end
	return text
end

--- "Aeris (Druid), Kel (Warlock) +2 more", or nil when nobody can.
local function WhoCan(classes)
	local parts, extra = {}, 0
	for _, u in ipairs(GroupUnits()) do
		local okC, _, classFile = pcall(UnitClass, u)
		if okC and Readable(classFile) and classes[classFile] then
			if #parts >= MAX_NAMES then
				extra = extra + 1
			else
				local okN, name = pcall(UnitName, u)
				local label = ClassName(classFile)
				if okN and Readable(name) then
					label = ("%s (%s)"):format(name, label)
				end
				local spell = CLASS_SPELL[classFile]
				if type(spell) == "function" then
					spell = spell(u)
				end
				if spell and C_Spell and C_Spell.GetSpellName then
					local okS, sname = pcall(C_Spell.GetSpellName, spell)
					if okS and Readable(sname) then
						label = label .. " - " .. sname
					end
				end
				if classes[classFile] == "pet" then
					label = label .. " " .. ns:L("REZLUST_PET")
				end
				parts[#parts + 1] = Colour(classFile, label)
			end
		end
	end
	if #parts == 0 then
		return nil
	end
	local s = table.concat(parts, ", ")
	if extra > 0 then
		s = s .. " " .. ns:L("REZLUST_MORE_FMT"):format(extra)
	end
	return s
end

local function Known(id)
	for _, fn in ipairs({ rawget(_G, "IsPlayerSpell"), C_SpellBook and C_SpellBook.IsSpellKnown }) do
		if type(fn) == "function" then
			local ok, v = pcall(fn, id)
			if ok and v == true then
				return true
			end
		end
	end
	local isk = rawget(_G, "IsSpellKnown")
	if type(isk) == "function" then
		local ok, v = pcall(isk, id, true) -- true = the pet's spellbook (Primal Rage)
		if ok and v == true then
			return true
		end
	end
	return false
end

--- "Intercession: Your key: 5" for the spell of this kind you know, or nil when you have none.
--- The key comes from LiveKeys, the same reader the How you play window uses: the key it is on
--- right now on the standard Blizzard bars, never our keybind scheme.
local function MyButton(ids, labelKey)
	for _, id in ipairs(ids) do
		if Known(id) then
			local name
			if C_Spell and C_Spell.GetSpellName then
				local ok, n = pcall(C_Spell.GetSpellName, id)
				name = ok and Readable(n) and n or nil
			end
			name = name or ("spell " .. id)
			if labelKey then
				name = ns:L(labelKey):format(name)
			end
			local key = ns.LiveKeyForSpell and ns.LiveKeyForSpell(id)
			local where = key and ns:L("PLAYCARD_KEY_FMT"):format("|cffffffff" .. key .. "|r")
				or ("|cffff9900" .. ns:L("PLAYCARD_KEY_NONE") .. "|r")
			return ("   |cffffd100%s|r: %s"):format(name, where)
		end
	end
	return nil
end

local function Clock(seconds)
	seconds = math.max(0, math.floor(seconds + 0.5))
	return ("%d:%02d"):format(math.floor(seconds / 60), seconds % 60)
end

--------------------------------------------------------------------------------
-- The panel
--------------------------------------------------------------------------------

local panel, ticker
local testUntil = 0

local function HeaderRGB()
	local c = ns.UI_COLORS and ns.UI_COLORS.header
	if type(c) == "table" and c[1] then
		return c[1], c[2], c[3]
	end
	return 0.91, 0.76, 0.42
end

local function BuildLines(logIt)
	local lines = {}
	if not EllesmereShows("battleRes") then
		local ctx = PoolContext()
		if ctx then
			local charges = ReadBrez(logIt)
			if charges and charges.max >= UNLIMITED then
				lines[#lines + 1] = ns:L("REZLUST_BREZ_UNLIMITED")
			elseif charges then
				local line = ns:L("REZLUST_BREZ_FMT"):format(charges.cur, charges.max)
				if charges.nextIn then
					line = line .. " · " .. ns:L("REZLUST_NEXT_FMT"):format(Clock(charges.nextIn))
				end
				if charges.cur <= 0 then
					line = "|cffff5040" .. line .. "|r"
				end
				lines[#lines + 1] = line
			else
				-- /mh lust says which: hidden by the game, refused, or no pool answered.
				lines[#lines + 1] = "|cff9d9d9d" .. ns:L("REZLUST_BREZ_UNREAD") .. "|r"
			end
		else
			if logIt then
				ReadBrez(true)
			end
			lines[#lines + 1] = "|cff9d9d9d" .. ns:L("REZLUST_BREZ_OWN") .. "|r"
		end
	end
	local brezWho = WhoCan(BREZ_CLASSES)
	lines[#lines + 1] = brezWho and ns:L("REZLUST_BREZ_WHO_FMT"):format(brezWho)
		or ("|cffff9900" .. ns:L("REZLUST_BREZ_WHO_NONE") .. "|r")
	lines[#lines + 1] = MyButton(MY_BREZ)
	lines[#lines + 1] = MyButton(MY_RES, "REZLUST_OOC_FMT")

	lines[#lines + 1] = " "
	if not EllesmereShows("bloodlust") then
		local state, left, guess = LustState()
		if state == "used" then
			lines[#lines + 1] = ns:L("REZLUST_LUST_USED_FMT"):format((guess and "~" or "") .. Clock(left))
		elseif state == "ready" then
			lines[#lines + 1] = "|cff40c040" .. ns:L("REZLUST_LUST_READY") .. "|r"
		else
			lines[#lines + 1] = "|cff9d9d9d" .. ns:L("REZLUST_LUST_UNKNOWN") .. "|r"
		end
	end
	local lustWho = WhoCan(LUST_CLASSES)
	lines[#lines + 1] = lustWho and ns:L("REZLUST_LUST_WHO_FMT"):format(lustWho)
		or ("|cffff9900" .. ns:L("REZLUST_LUST_WHO_NONE") .. "|r")
	lines[#lines + 1] = MyButton(MY_LUST)
	return table.concat(lines, "\n")
end

local function SavePos()
	if not panel then
		return
	end
	local p, _, rp, x, y = panel:GetPoint()
	local ui = Ui()
	if type(ui) == "table" then
		ui.rezLustPos = { p, rp, x, y }
	end
end

local function EnsurePanel()
	if panel then
		return panel
	end
	local f = CreateFrame("Frame", "MidnightHelperRezLust", UIParent, "BackdropTemplate")
	f:SetSize(PANEL_W, 80)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePos()
	end)
	local ui = Ui()
	local pos = type(ui) == "table" and ui.rezLustPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 40, -220)
	end
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 14,
			insets = { left = 4, right = 4, top = 4, bottom = 4 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.09, 0.9)
		f:SetBackdropBorderColor(HeaderRGB())
	end

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	if ns.MHScalableFont then
		f.title:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	end
	f.title:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -PAD)
	f.title:SetTextColor(HeaderRGB())
	f.title:SetText(ns:L("REZLUST_TITLE"))

	f.body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	if ns.MHScalableFont then
		f.body:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	end
	f.body:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -6)
	f.body:SetWidth(PANEL_W - PAD * 2)
	f.body:SetJustifyH("LEFT")
	f.body:SetJustifyV("TOP")
	f.body:SetSpacing(2)

	-- Hover explains what the two things are: the part an icon cannot tell a newer player.
	f:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(ns:L("REZLUST_TITLE"), HeaderRGB())
		GameTooltip:AddLine(ns:L("REZLUST_TIP_BREZ"), 1, 1, 1, true)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(ns:L("REZLUST_TIP_LUST"), 1, 1, 1, true)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(ns:L("REZLUST_TIP_MOVE"), 0.6, 0.6, 0.6, true)
		GameTooltip:Show()
	end)
	f:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	f:Hide()
	panel = f
	return f
end

--- @return boolean show, string why
local function ShouldShow()
	if testUntil > Now() then
		return true, "test (/mh lust test)"
	end
	if not ns.IsRezLustEnabled() then
		return false, "turned off in settings"
	end
	local place, kind = Place()
	if not place then
		return false, ("not in a dungeon, delve or raid (instance type %s)"):format(tostring(kind))
	end
	if ns.IsRezLustKeyRaidOnly() and not NARROW[place] then
		return false, ("in %s, but the setting says Mythic+ keys and raids only"):format(place)
	end
	if not (IsInGroup and IsInGroup()) then
		return false, "not in a group"
	end
	return true, "in " .. place
end

local lastLog = 0

local function Refresh()
	local show = ShouldShow()
	if not show then
		if panel then
			panel:Hide()
		end
		if ticker then
			ticker:Cancel()
			ticker = nil
		end
		return
	end
	local f = EnsurePanel()
	-- One logged reading every 5 seconds is plenty to catch each situation.
	local now = Now()
	local logIt = now - lastLog >= 5
	if logIt then
		lastLog = now
	end
	f.body:SetText(BuildLines(logIt))
	f:SetHeight(PAD * 2 + f.title:GetStringHeight() + 6 + f.body:GetStringHeight())
	f:Show()
	if not ticker and C_Timer and C_Timer.NewTicker then
		ticker = C_Timer.NewTicker(0.5, Refresh)
	end
end

function ns.SetRezLustKeyRaidOnly(v)
	local ui = Ui()
	if type(ui) == "table" then
		ui.rezLustKeyRaidOnly = v and true or false
	end
	Refresh()
end

function ns.SetRezLustEnabled(v)
	local ui = Ui()
	if type(ui) == "table" then
		ui.rezLust = v and true or false
	end
	Refresh()
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("GROUP_ROSTER_UPDATE")
ev:RegisterEvent("ENCOUNTER_START")
ev:RegisterEvent("ENCOUNTER_END")
ev:RegisterEvent("CHALLENGE_MODE_START")
ev:RegisterEvent("CHALLENGE_MODE_COMPLETED")
ev:RegisterEvent("CHALLENGE_MODE_RESET")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterUnitEvent("UNIT_AURA", "player")
ev:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
ev:RegisterEvent("UPDATE_BINDINGS")
ev:SetScript("OnEvent", function(_, event)
	if event == "ACTIONBAR_SLOT_CHANGED" or event == "UPDATE_BINDINGS" then
		-- A spell dragged to another button or a key rebound: read the bars again.
		if ns.LiveKeysInvalidate then
			ns.LiveKeysInvalidate()
		end
		if not (panel and panel:IsShown()) then
			return
		end
	end
	if event == "ENCOUNTER_START" then
		encounterActive = true
	elseif event == "ENCOUNTER_END" then
		encounterActive = false
	elseif event == "PLAYER_ENTERING_WORLD" then
		encounterActive = false
	end
	if event == "UNIT_AURA" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then
		-- After combat the aura API can be believed again, so this is where a lockout
		-- we could not see during the fight gets settled.
		UpdateLust(event ~= "UNIT_AURA" or InCombat())
	end
	Refresh()
end)

--------------------------------------------------------------------------------
-- `/mh lust` and `/mh brez`
--------------------------------------------------------------------------------

local function PrintLog()
	local log = ns.db and ns.db.rezLustLog
	if type(log) ~= "table" then
		print("   measured so far: nothing yet (it records while the panel is up)")
		return
	end
	for _, kind in ipairs({ "brez", "lust" }) do
		local rows = log[kind]
		if type(rows) == "table" then
			local keys = {}
			for k in pairs(rows) do
				keys[#keys + 1] = k
			end
			table.sort(keys)
			for _, k in ipairs(keys) do
				local slot = rows[k]
				local last = slot.last or {}
				local bits = {}
				for field, v in pairs(last) do
					if field ~= "at" and field ~= "build" then
						bits[#bits + 1] = field .. "=" .. tostring(v)
					end
				end
				table.sort(bits)
				print(("   %s %-18s x%d  %s"):format(kind, k, slot.count or 0, table.concat(bits, " ")))
			end
		end
	end
end

--- `/mh lust` prints what the panel decided and why, what it read, and what it has measured.
--- `/mh lust test` shows the panel for 30 seconds wherever you are, with the real readings.
function ns.RezLustCommand(arg)
	if arg == "test" then
		testUntil = Now() + TEST_SECONDS
		UpdateLust(true)
		Refresh()
		print(("%s battle res & Bloodlust panel shown for %d seconds, with the real readings."):format(
			Prefix(), TEST_SECONDS))
		return
	end
	UpdateLust(true)
	local show, why = ShouldShow()
	print(("%s battle res & Bloodlust: setting %s · panel %s (%s)"):format(Prefix(),
		ns.IsRezLustEnabled() and "on" or "off", show and "shown" or "hidden", why))
	local ctx = PoolContext()
	local charges, bwhy = ReadBrez(true)
	print(("   in combat %s · shared pool applies here: %s"):format(tostring(InCombat()), ctx or "no"))
	if charges then
		print(("   battle res: %d of %d%s"):format(charges.cur, charges.max,
			charges.nextIn and (", next in " .. Clock(charges.nextIn)) or ""))
	else
		print("   battle res: " .. bwhy)
	end
	local state, left, guess = LustState()
	print(("   Bloodlust: %s%s · lockout id %s · auras trusted %s"):format(state,
		left and (" (" .. (guess and "~" or "") .. Clock(left) .. " left)") or "",
		tostring(lust.id), tostring(Trusted())))
	print(("   EllesmereUI shows: battle res %s, Bloodlust %s (our line stands down where yes)"):format(
		EllesmereShows("battleRes") and "yes" or "no", EllesmereShows("bloodlust") and "yes" or "no"))
	print("   can revive: " .. (WhoCan(BREZ_CLASSES) or "nobody"))
	print("   can Hero: " .. (WhoCan(LUST_CLASSES) or "nobody"))
	PrintLog()
	print("   /mh lust test shows the panel now. /reload writes the measurements to the file.")
end
