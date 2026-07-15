--[[
	Healer cooldown cheat-sheet (Healer initiative, piece 1). Per healer spec:
	your major cooldowns + what each one IS (kind) + a one-line "when to use it".
	Data-only module + a /mh healcds printout; this same table also feeds piece 4
	(per-boss heal-lens callouts), so it is the single verified source of healer CDs.

	NEVER-LIE — every spellID + base cooldown is taken from Rob's installed JustAC
	data, generated from client build 12.1.0.68301, not guessed:
	  - JustAC/Data/SpellCooldowns.lua   -> [spellID] = cooldownMs  (the `cd`)
	  - JustAC/Data/SpellCategories.lua  -> spec ownership (e.g. [114052] =
	    Ascendance (Restoration), which corrected a stale 114049 note elsewhere)
	Spell NAMES are resolved LIVE via C_Spell.GetSpellName(id), so every game
	locale shows the client's own name (no hardcoded English). `cd` is in seconds.

	A "healer cooldown" is not always a heal — the toolkit mixes throughput heals,
	damage-reduction and externals, so each entry carries a `kind` label:
	  heal    = heals people / boosts your own healing output
	  mitig   = reduces damage the group (or you) takes — not a heal
	  ext     = cast on ONE ally to protect or save them
	  util    = a buff or resource cooldown (haste, mana)

	`when` is a generic guidance type (kept generic so the text is always true for
	the tagged spell, and the localization stays small):
	  raid  = save for a big raid-wide burst
	  ext   = cast on the tank/ally about to take a big hit
	  emerg = emergency button — hit it the instant someone (or you) may die
	  self  = your own panic button / channel
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
	emerg = "HEALCD_WHEN_EMERG",
	self = "HEALCD_WHEN_SELF",
	haste = "HEALCD_WHEN_HASTE",
	mana = "HEALCD_WHEN_MANA",
	flow = "HEALCD_WHEN_FLOW",
}

-- Kind label + a scan colour per kind.
local KIND = {
	heal = "HEALCD_KIND_HEAL",
	mitig = "HEALCD_KIND_MITIG",
	ext = "HEALCD_KIND_EXT",
	util = "HEALCD_KIND_UTIL",
}
local KIND_COLOR = {
	heal = "ff40c040", -- green
	mitig = "ff40a0ff", -- blue
	ext = "ffff8040", -- orange
	util = "ffc080ff", -- purple
}

-- Core "bread-and-butter" heals (piece 1, beginner half): each spec's spammable
-- everyday heals + a short tag for what it's FOR. Deliberately NOT in the /mh
-- healcds cooldown sheet; the Academy healer toolkit shows both together.
local TAG = {
	fast = "HEALCORE_TAG_FAST",
	big = "HEALCORE_TAG_BIG",
	hot = "HEALCORE_TAG_HOT",
	aoe = "HEALCORE_TAG_AOE",
	shield = "HEALCORE_TAG_SHIELD",
	channel = "HEALCORE_TAG_CHANNEL",
	bounce = "HEALCORE_TAG_BOUNCE",
}
local TAG_DESC = {
	fast = "HEALCORE_DESC_FAST",
	big = "HEALCORE_DESC_BIG",
	hot = "HEALCORE_DESC_HOT",
	aoe = "HEALCORE_DESC_AOE",
	shield = "HEALCORE_DESC_SHIELD",
	channel = "HEALCORE_DESC_CHANNEL",
	bounce = "HEALCORE_DESC_BOUNCE",
}
local TAG_COLOR = {
	fast = "ff5fe0b0",
	big = "ff70b0ff",
	hot = "ff70d070",
	aoe = "ffffd060",
	shield = "ffe0d040",
	channel = "ff50d0d0",
	bounce = "ffb0e060",
}

ns.HEALER_COOLDOWNS = {
	-- Holy Paladin (65)
	[65] = {
		{ id = 31884, cd = 120, kind = "heal", when = "flow" }, -- Avenging Wrath (boosts healing)
		{ id = 375576, cd = 60, kind = "heal", when = "flow" }, -- Divine Toll
		{ id = 200652, cd = 90, kind = "heal", when = "raid" }, -- Tyr's Deliverance
		{ id = 31821, cd = 180, kind = "mitig", when = "raid" }, -- Aura Mastery (raid magic DR)
		{ id = 6940, cd = 120, kind = "ext", when = "ext" }, -- Blessing of Sacrifice
		{ id = 633, cd = 600, kind = "heal", when = "emerg" }, -- Lay on Hands (full-HP emergency heal, ally OR self)
	},
	-- Restoration Druid (105)
	[105] = {
		{ id = 740, cd = 180, kind = "heal", when = "raid" }, -- Tranquility
		{ id = 33891, cd = 180, kind = "heal", when = "flow" }, -- Incarnation: Tree of Life (healing boost)
		{ id = 323764, cd = 120, kind = "heal", when = "flow" }, -- Convoke the Spirits
		{ id = 102342, cd = 90, kind = "ext", when = "ext" }, -- Ironbark
	},
	-- Preservation Evoker (1468)
	[1468] = {
		{ id = 363534, cd = 240, kind = "heal", when = "raid" }, -- Rewind
		{ id = 359816, cd = 120, kind = "heal", when = "raid" }, -- Dream Flight
		{ id = 370960, cd = 180, kind = "heal", when = "flow" }, -- Emerald Communion
		{ id = 370537, cd = 90, kind = "heal", when = "flow" }, -- Stasis (banks heals)
		{ id = 357170, cd = 60, kind = "ext", when = "ext" }, -- Time Dilation
	},
	-- Mistweaver Monk (270)
	[270] = {
		{ id = 115310, cd = 180, kind = "heal", when = "raid" }, -- Revival
		{ id = 325197, cd = 120, kind = "heal", when = "raid" }, -- Invoke Chi-Ji, the Red Crane
		{ id = 322118, cd = 120, kind = "heal", when = "raid" }, -- Invoke Yu'lon, the Jade Serpent
		{ id = 116849, cd = 120, kind = "ext", when = "ext" }, -- Life Cocoon
		{ id = 115176, cd = 300, kind = "mitig", when = "self" }, -- Zen Meditation (personal DR channel)
	},
	-- Discipline Priest (256)
	[256] = {
		{ id = 421453, cd = 240, kind = "heal", when = "flow" }, -- Ultimate Penitence
		{ id = 62618, cd = 180, kind = "mitig", when = "raid" }, -- Power Word: Barrier (ground DR zone)
		{ id = 33206, cd = 180, kind = "ext", when = "ext" }, -- Pain Suppression
		{ id = 472433, cd = 90, kind = "heal", when = "flow" }, -- Evangelism (extends atonement healing)
		{ id = 10060, cd = 120, kind = "util", when = "haste" }, -- Power Infusion
	},
	-- Holy Priest (257)
	[257] = {
		{ id = 265202, cd = 720, kind = "heal", when = "raid" }, -- Holy Word: Salvation
		{ id = 64843, cd = 180, kind = "heal", when = "raid" }, -- Divine Hymn
		{ id = 200183, cd = 120, kind = "heal", when = "flow" }, -- Apotheosis (Holy Word boost)
		{ id = 47788, cd = 180, kind = "ext", when = "ext" }, -- Guardian Spirit
		{ id = 10060, cd = 120, kind = "util", when = "haste" }, -- Power Infusion
	},
	-- Restoration Shaman (264)
	[264] = {
		{ id = 108280, cd = 180, kind = "heal", when = "raid" }, -- Healing Tide Totem
		{ id = 98008, cd = 180, kind = "mitig", when = "raid" }, -- Spirit Link Totem (health redistribute + DR)
		{ id = 114052, cd = 180, kind = "heal", when = "raid" }, -- Ascendance (Restoration)
		{ id = 16191, cd = 180, kind = "util", when = "mana" }, -- Mana Tide Totem
	},
}

-- Core heals per spec. IDs verified from JustAC/Data/SpellCategories.lua HEALING
-- section (Chain Heal 1064 also cross-checked in KeybindRoles_Shaman) — never
-- guessed. Names resolve live. `tag` = what the heal is for (see TAG/TAG_DESC).
ns.HEALER_CORE_HEALS = {
	-- Holy Paladin (65)
	[65] = {
		{ id = 20473, tag = "fast" }, -- Holy Shock
		{ id = 19750, tag = "fast" }, -- Flash of Light
		{ id = 82326, tag = "big" }, -- Holy Light
		{ id = 85673, tag = "fast" }, -- Word of Glory
		{ id = 85222, tag = "aoe" }, -- Light of Dawn
	},
	-- Restoration Druid (105)
	[105] = {
		{ id = 774, tag = "hot" }, -- Rejuvenation
		{ id = 33763, tag = "hot" }, -- Lifebloom
		{ id = 8936, tag = "fast" }, -- Regrowth
		{ id = 18562, tag = "fast" }, -- Swiftmend
		{ id = 48438, tag = "aoe" }, -- Wild Growth
	},
	-- Preservation Evoker (1468)
	[1468] = {
		{ id = 361469, tag = "fast" }, -- Living Flame
		{ id = 366155, tag = "hot" }, -- Reversion
		{ id = 360995, tag = "fast" }, -- Verdant Embrace
		{ id = 367226, tag = "big" }, -- Spiritbloom
		{ id = 355913, tag = "aoe" }, -- Emerald Blossom
	},
	-- Mistweaver Monk (270)
	[270] = {
		{ id = 115175, tag = "channel" }, -- Soothing Mist
		{ id = 116670, tag = "fast" }, -- Vivify
		{ id = 119611, tag = "hot" }, -- Renewing Mist
		{ id = 124682, tag = "big" }, -- Enveloping Mist
		{ id = 231633, tag = "aoe" }, -- Essence Font
	},
	-- Discipline Priest (256)
	[256] = {
		{ id = 17, tag = "shield" }, -- Power Word: Shield
		{ id = 186263, tag = "fast" }, -- Shadow Mend
		{ id = 194509, tag = "aoe" }, -- Power Word: Radiance
	},
	-- Holy Priest (257)
	[257] = {
		{ id = 2061, tag = "fast" }, -- Flash Heal
		{ id = 2060, tag = "big" }, -- Heal
		{ id = 139, tag = "hot" }, -- Renew
		{ id = 33076, tag = "bounce" }, -- Prayer of Mending
		{ id = 596, tag = "aoe" }, -- Prayer of Healing
	},
	-- Restoration Shaman (264)
	[264] = {
		{ id = 61295, tag = "hot" }, -- Riptide
		{ id = 77472, tag = "big" }, -- Healing Wave
		{ id = 8004, tag = "fast" }, -- Healing Surge
		{ id = 1064, tag = "bounce" }, -- Chain Heal
		{ id = 73920, tag = "aoe" }, -- Healing Rain
	},
}

--- The CD list for a spec, or nil if it isn't a (known) healer spec.
function ns.GetHealerCooldowns(specID)
	return specID and ns.HEALER_COOLDOWNS[specID] or nil
end

--- The core-heal list for a spec, or nil.
function ns.GetHealerCoreHeals(specID)
	return specID and ns.HEALER_CORE_HEALS[specID] or nil
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

--- The player's CLASS's healer spec id (even if not the active spec), or nil if
--- the class has no healing spec. Lets the Academy preview e.g. a Prot Paladin's
--- Holy toolkit instead of showing nothing.
function ns.GetClassHealerSpecID()
	if not (GetNumSpecializations and GetSpecializationInfo) then
		return nil
	end
	local n = GetNumSpecializations() or 0
	for i = 1, n do
		local id = GetSpecializationInfo(i)
		if id and ns.HEALER_COOLDOWNS[id] then
			return id
		end
	end
	return nil
end

--- Locale keys for a CD's guidance / kind label (nil-safe).
function ns.GetHealerCooldownWhenKey(whenType)
	return WHEN[whenType]
end
function ns.GetHealerCooldownKindKey(kind)
	return KIND[kind]
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

-- "[Heal]" style label, coloured by kind.
local function KindLabel(kind)
	local key = KIND[kind]
	if not key then
		return ""
	end
	return ("|c%s[%s]|r"):format(KIND_COLOR[kind] or "ffffffff", ns:L(key))
end
ns.HealerCooldownKindLabel = KindLabel

-- "[Fast]" style label for a core heal, coloured by tag.
local function TagLabel(tag)
	local key = TAG[tag]
	if not key then
		return ""
	end
	return ("|c%s[%s]|r"):format(TAG_COLOR[tag] or "ffffffff", ns:L(key))
end
ns.HealerCoreHealTagLabel = TagLabel

--- The one-line guidance locale key for a core-heal tag (nil-safe).
function ns.GetHealerCoreHealDescKey(tag)
	return TAG_DESC[tag]
end

--- /mh healcds — print the player's cooldown cheat-sheet to chat. A visual
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
		print(("   %s |cffffd100%s|r |cff9d9d9d(%s)|r — %s"):format(
			KindLabel(c.kind), SpellName(c.id), FormatCD(c.cd), ns:L(WHEN[c.when] or "")
		))
	end
end
