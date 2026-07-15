--[[
	Healer cooldown cheat-sheet (Healer initiative, piece 1). Per healer spec:
	your major healing cooldowns + a one-line "when to save it". Data-only module
	+ a /mh healcds printout; this same table also feeds piece 4 (per-boss
	heal-lens callouts), so it is the single verified source of healer CDs.

	NEVER-LIE — every spellID + base cooldown is taken from Rob's installed JustAC
	data, generated from client build 12.1.0.68301, not guessed:
	  - JustAC/Data/SpellCooldowns.lua   -> [spellID] = cooldownMs  (the `cd`)
	  - JustAC/Data/SpellCategories.lua  -> spec ownership (e.g. [114052] =
	    Ascendance (Restoration), which corrected a stale 114049 note elsewhere)
	Spell NAMES are resolved LIVE via C_Spell.GetSpellName(id), so every game
	locale shows the client's own name (no hardcoded English). `cd` is in seconds.

	`when` is a GENERIC guidance type (kept generic so the text is always true for
	the tagged spell, and the localization stays tiny):
	  raid  = save for a big raid-wide burst
	  ext   = cast on a tank/ally about to take a big hit (protects them, not you)
	  self  = personal panic button / channel
	  haste = line up with your biggest healing burst
	  mana  = use when the group is low on mana
	  flow  = pop during heavy sustained damage for extra throughput

	Healer specIDs: Holy Paladin 65, Restoration Druid 105, Preservation Evoker
	1468, Mistweaver Monk 270, Discipline Priest 256, Holy Priest 257,
	Restoration Shaman 264.
]]

local _, ns = ...

local WHEN = {
	raid = "HEALCD_WHEN_RAID",
	ext = "HEALCD_WHEN_EXT",
	self = "HEALCD_WHEN_SELF",
	haste = "HEALCD_WHEN_HASTE",
	mana = "HEALCD_WHEN_MANA",
	flow = "HEALCD_WHEN_FLOW",
}

ns.HEALER_COOLDOWNS = {
	-- Holy Paladin (65)
	[65] = {
		{ id = 31884, cd = 120, when = "flow" }, -- Avenging Wrath
		{ id = 375576, cd = 60, when = "flow" }, -- Divine Toll
		{ id = 200652, cd = 90, when = "raid" }, -- Tyr's Deliverance
		{ id = 31821, cd = 180, when = "raid" }, -- Aura Mastery (raid DR)
		{ id = 6940, cd = 120, when = "ext" }, -- Blessing of Sacrifice
		{ id = 633, cd = 600, when = "ext" }, -- Lay on Hands (emergency full heal)
	},
	-- Restoration Druid (105)
	[105] = {
		{ id = 740, cd = 180, when = "raid" }, -- Tranquility
		{ id = 33891, cd = 180, when = "flow" }, -- Incarnation: Tree of Life
		{ id = 323764, cd = 120, when = "flow" }, -- Convoke the Spirits
		{ id = 102342, cd = 90, when = "ext" }, -- Ironbark
	},
	-- Preservation Evoker (1468)
	[1468] = {
		{ id = 363534, cd = 240, when = "raid" }, -- Rewind
		{ id = 359816, cd = 120, when = "raid" }, -- Dream Flight
		{ id = 370960, cd = 180, when = "flow" }, -- Emerald Communion
		{ id = 370537, cd = 90, when = "flow" }, -- Stasis
		{ id = 357170, cd = 60, when = "ext" }, -- Time Dilation
	},
	-- Mistweaver Monk (270)
	[270] = {
		{ id = 115310, cd = 180, when = "raid" }, -- Revival
		{ id = 325197, cd = 120, when = "raid" }, -- Invoke Chi-Ji, the Red Crane
		{ id = 322118, cd = 120, when = "raid" }, -- Invoke Yu'lon, the Jade Serpent
		{ id = 116849, cd = 120, when = "ext" }, -- Life Cocoon
		{ id = 115176, cd = 300, when = "self" }, -- Zen Meditation
	},
	-- Discipline Priest (256)
	[256] = {
		{ id = 421453, cd = 240, when = "flow" }, -- Ultimate Penitence
		{ id = 62618, cd = 180, when = "raid" }, -- Power Word: Barrier
		{ id = 33206, cd = 180, when = "ext" }, -- Pain Suppression
		{ id = 472433, cd = 90, when = "flow" }, -- Evangelism
		{ id = 10060, cd = 120, when = "haste" }, -- Power Infusion
	},
	-- Holy Priest (257)
	[257] = {
		{ id = 265202, cd = 720, when = "raid" }, -- Holy Word: Salvation
		{ id = 64843, cd = 180, when = "raid" }, -- Divine Hymn
		{ id = 200183, cd = 120, when = "flow" }, -- Apotheosis
		{ id = 47788, cd = 180, when = "ext" }, -- Guardian Spirit
		{ id = 10060, cd = 120, when = "haste" }, -- Power Infusion
	},
	-- Restoration Shaman (264)
	[264] = {
		{ id = 108280, cd = 180, when = "raid" }, -- Healing Tide Totem
		{ id = 98008, cd = 180, when = "raid" }, -- Spirit Link Totem
		{ id = 114052, cd = 180, when = "raid" }, -- Ascendance (Restoration)
		{ id = 16191, cd = 180, when = "mana" }, -- Mana Tide Totem
	},
}

--- The CD list for a spec, or nil if it isn't a (known) healer spec.
function ns.GetHealerCooldowns(specID)
	return specID and ns.HEALER_COOLDOWNS[specID] or nil
end

--- The player's current spec id IF it is a healer spec we have data for, else nil.
function ns.GetPlayerHealerSpecID()
	if not (GetSpecialization and GetSpecializationInfo) then
		return nil
	end
	local idx = GetSpecialization()
	if not idx then
		return nil
	end
	local id = GetSpecializationInfo(idx)
	if id and ns.HEALER_COOLDOWNS[id] then
		return id
	end
	return nil
end

--- The guidance locale key for a `when` type (nil-safe).
function ns.GetHealerCooldownWhenKey(whenType)
	return WHEN[whenType]
end

-- Seconds → a short "2 min" / "1.5 min" / "45s" label.
local function FormatCD(seconds)
	if not seconds or seconds <= 0 then
		return "?"
	end
	if seconds >= 60 then
		return ("%g min"):format(seconds / 60)
	end
	return ("%ds"):format(seconds)
end
ns.FormatHealerCooldown = FormatCD

-- Localized spell name for a CD entry (live client name; never hardcoded).
local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local n = C_Spell.GetSpellName(id)
		if n and n ~= "" then
			return n
		end
	end
	return "spell " .. tostring(id)
end
ns.HealerCooldownSpellName = SpellName

--- /mh healcds — print the player's healing-CD cheat-sheet to chat. A visual
--- Codex/Academy page can render the same ns.HEALER_COOLDOWNS data later.
function ns.PrintHealerCooldownSheet()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	local specID = ns.GetPlayerHealerSpecID()
	if not specID then
		print(("%s %s"):format(prefix, ns:L("HEALCD_NOT_HEALER")))
		return
	end
	print(("%s |cff8fd3ff%s|r"):format(prefix, ns:L("HEALCD_TITLE")))
	for _, c in ipairs(ns.HEALER_COOLDOWNS[specID]) do
		print(("   |cffffd100%s|r |cff9d9d9d(%s)|r — %s"):format(
			SpellName(c.id), FormatCD(c.cd), ns:L(WHEN[c.when] or "")
		))
	end
end
