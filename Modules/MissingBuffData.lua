--[[
	Missing Buff — data (Rob-wens 3 jul 2026). Eigen, onafhankelijk geverifieerde
	dataset (Wowhead 12.0.7); GEEN kopie van de MissingClassBuff-addon.

	Doel: tonen welke onderhoudbare class-buff jij kunt casten maar NIET actief hebt
	(raid-buff, vorm, shield, wapen-imbue, poison, stance, pet). Combat-procs en
	cooldowns horen hier NIET (bv. Voidform, Bloodlust) — die staan niet permanent op.

	Velden per entry:
	  spell     = spell-ID om "geleerd?" te checken (C_SpellBook.IsSpellKnown) + te casten
	  buff      = aura-ID om "actief op speler?" te checken (meestal == spell)
	  kind      = "raid" | "self" | "form" | "imbue_mh" | "imbue_oh" | "stance"
	  specs     = {specID,...} optioneel; alleen tonen voor deze specialisaties
	  showCombat= true → ook in combat waarschuwen (vormen/stances/pet); default false
	  textKey   = locale-key voor het label (MBUFF_TXT_*)
	  prio      = weergavevolgorde (laag = eerst)

	Geverifieerde uitsluitingen (never-lie): Voidform 194249 (cooldown), Summon Water
	Elemental 31687 (functioneel weg voor Frost), Horn of Winter 57330 (rune-generator,
	geen buff), Vengeance/Crusader Aura (passief/reis, geen combat-onderhoud). Monk,
	Demon Hunter en non-Unholy Death Knight hebben géén trackbare onderhoudsbuff.

	Poisons (Rogue) en pets (Hunter/Warlock/Unholy DK) worden apart in de engine
	afgehandeld (groeps-/statuslogica), zie ns.MISSING_POISONS / MissingBuff.lua.
]]

local _, ns = ...

-- Spec-ID's die we nodig hebben voor gating.
-- 102 Balance · 258 Shadow · 62 Arcane · 65 Holy(Pal) · 262 Ele · 263 Enh · 264 Resto(Sha)
-- 265 Affliction · 267 Destruction · 1473 Augmentation

ns.MISSING_BUFF_DEFS = {
	DRUID = {
		{ spell = 1126, buff = 1126, kind = "raid", prio = 10, textKey = "MBUFF_TXT_MISSING" }, -- Mark of the Wild (+3% Vers)
		{ spell = 24858, buff = 24858, kind = "form", specs = { 102 }, showCombat = true, prio = 5, textKey = "MBUFF_TXT_FORM" }, -- Moonkin Form
		{ spell = 768, buff = 768, kind = "form", specs = { 103 }, showCombat = true, prio = 5, textKey = "MBUFF_TXT_FORM" }, -- Cat Form (Feral)
		{ spell = 5487, buff = 5487, kind = "form", specs = { 104 }, showCombat = true, prio = 5, textKey = "MBUFF_TXT_FORM" }, -- Bear Form (Guardian)
		{ spell = 474750, buff = 474750, kind = "ally", prio = 40, textKey = "MBUFF_TXT_ALLY" }, -- Symbiotic Relationship
	},
	MAGE = {
		{ spell = 1459, buff = 1459, kind = "raid", prio = 10, textKey = "MBUFF_TXT_MISSING" }, -- Arcane Intellect
		{ spell = 205022, buff = 210126, kind = "self", specs = { 62 }, prio = 20, textKey = "MBUFF_TXT_MISSING" }, -- Arcane Familiar (talent 205022 → buff 210126)
	},
	PRIEST = {
		{ spell = 21562, buff = 21562, kind = "raid", prio = 10, textKey = "MBUFF_TXT_MISSING" }, -- Power Word: Fortitude (+5% Stam)
		{ spell = 232698, buff = 232698, kind = "form", specs = { 258 }, showCombat = true, prio = 5, textKey = "MBUFF_TXT_FORM" }, -- Shadowform
	},
	WARRIOR = {
		{ spell = 6673, buff = 6673, kind = "raid", prio = 10, textKey = "MBUFF_TXT_MISSING" }, -- Battle Shout (+5% AP)
		-- Stances zijn talenten; de engine toont "USE STANCE" als je een stance-talent
		-- kent maar geen stance actief hebt (groepslogica via ns.MISSING_STANCES).
	},
	EVOKER = {
		-- Blessing of the Bronze: je cast 364342, de Evoker-eigen buff-aura is 381748.
		{ spell = 364342, buff = 381748, kind = "raid", prio = 10, textKey = "MBUFF_TXT_MISSING" },
		-- Source of Magic: op een healer in de groep (alleen tonen als er een healer is).
		{ spell = 369459, buff = 369459, kind = "ally", needHealer = true, prio = 30, textKey = "MBUFF_TXT_ALLY" },
	},
	SHAMAN = {
		{ spell = 462854, buff = 462854, kind = "raid", prio = 10, textKey = "MBUFF_TXT_MISSING" }, -- Skyfury
		{ spell = 192106, buff = 192106, kind = "self", specs = { 262, 263 }, showCombat = true, prio = 20, textKey = "MBUFF_TXT_SHIELD" }, -- Lightning Shield
		{ spell = 52127, buff = 52127, kind = "self", specs = { 264 }, showCombat = true, prio = 20, textKey = "MBUFF_TXT_SHIELD" }, -- Water Shield
		{ spell = 974, buff = 974, kind = "ally", prio = 25, textKey = "MBUFF_TXT_ALLY" }, -- Earth Shield (op ally/tank; elke spec die 'm talent, niet spec-gated)
		-- Earth Shield op JEZELF: alleen met de Elemental Orbit-talent (383010); kan náást
		-- Lightning/Water Shield staan. Gegate op de talent i.p.v. spec (Ele/Enh/Resto).
		{ spell = 383648, buff = 383648, kind = "self", reqSpell = 383010, showCombat = true, prio = 22, textKey = "MBUFF_TXT_SHIELD" }, -- Earth Shield (self, Elemental Orbit)
		-- Wapen/schild-imbues (talenten). "learned" bepaalt of de spec 'm heeft; actief
		-- = tijdelijke wapen-enchant op de betreffende slot.
		{ spell = 318038, kind = "imbue_mh", specs = { 262, 263 }, prio = 30, textKey = "MBUFF_TXT_IMBUE" }, -- Flametongue Weapon
		{ spell = 33757, kind = "imbue_mh", specs = { 263 }, prio = 30, textKey = "MBUFF_TXT_IMBUE" }, -- Windfury Weapon
		{ spell = 382021, kind = "imbue_mh", specs = { 264 }, prio = 30, textKey = "MBUFF_TXT_IMBUE" }, -- Earthliving Weapon
		{ spell = 462757, kind = "imbue_oh", specs = { 262 }, prio = 30, textKey = "MBUFF_TXT_IMBUE" }, -- Thunderstrike Ward (schild)
		{ spell = 457481, kind = "imbue_oh", specs = { 264 }, prio = 30, textKey = "MBUFF_TXT_IMBUE" }, -- Tidecaller's Guard (schild)
	},
	WARLOCK = {
		{ spell = 108503, buff = 196099, kind = "self", specs = { 265, 267 }, prio = 20, textKey = "MBUFF_TXT_MISSING" }, -- Grimoire of Sacrifice (talent 108503 → buff 196099)
	},
	PALADIN = {
		-- Rites zijn wederzijds uitsluitende wapen-imbues (main-hand, 1u). Slot-gebaseerd
		-- detecteren (elke wapen-imbue actief = oké) i.p.v. per-aura, anders geeft de één
		-- een valse "andere Rite mist"-melding. Gegate op geleerd (talent).
		{ spell = 433568, kind = "imbue_mh", prio = 20, textKey = "MBUFF_TXT_IMBUE" }, -- Rite of Sanctification
		{ spell = 433583, kind = "imbue_mh", prio = 21, textKey = "MBUFF_TXT_IMBUE" }, -- Rite of Adjuration
		{ spell = 53563, buff = 53563, kind = "ally", specs = { 65 }, prio = 15, textKey = "MBUFF_TXT_ALLY" }, -- Beacon of Light (Holy)
		{ spell = 156910, buff = 156910, kind = "ally", specs = { 65 }, prio = 16, textKey = "MBUFF_TXT_ALLY" }, -- Beacon of Faith (Holy talent)
	},
	-- Rogue: poisons apart (1 lethal + 1 non-lethal), zie ns.MISSING_POISONS.
	-- Monk / Demon Hunter / Death Knight (non-Unholy): geen trackbare onderhoudsbuff.
}

-- Warrior-stances (talenten). Toon "USE STANCE" als er minstens één geleerd is maar
-- geen enkele actief. Detectie via shapeshift-form in de engine.
ns.MISSING_STANCES = {
	{ spell = 386208, textKey = "MBUFF_TXT_STANCE" }, -- Defensive Stance (default)
	{ spell = 386164, textKey = "MBUFF_TXT_STANCE" }, -- Battle Stance
	{ spell = 386196, textKey = "MBUFF_TXT_STANCE" }, -- Berserker Stance
}

-- Rogue-poisons: precies één lethal + één non-lethal hoort actief te zijn. De engine
-- checkt of er uit elke groep een buff op de speler staat; zo niet → waarschuwing.
-- "learned" bepaalt of de poison beschikbaar is (baseline of getalenteerd).
ns.MISSING_POISONS = {
	lethal = {
		{ spell = 315584 }, -- Instant Poison (baseline)
		{ spell = 2823 }, -- Deadly Poison (talent)
		{ spell = 8679 }, -- Wound Poison (baseline)
		{ spell = 381664 }, -- Amplifying Poison (talent)
	},
	nonlethal = {
		{ spell = 3408 }, -- Crippling Poison (baseline)
		{ spell = 5761 }, -- Numbing Poison (talent)
		{ spell = 381637 }, -- Atrophic Poison (talent)
	},
}

-- Pet-logica per class (engine bepaalt "hoort een pet te hebben"):
--   Hunter: altijd, behalve Marksman (254) zonder Unbreakable Bond (1223323).
--   Warlock: altijd, behalve met Grimoire of Sacrifice (196099) actief.
--   Death Knight: alleen Unholy (252) — permanente ghoul (Raise Dead 46584).
ns.MISSING_PET = {
	HUNTER = { revive = 982, call = 883, mmSpec = 254, mmPetTalent = 1223323 },
	WARLOCK = { summon = 688, sacrificeBuff = 196099 },
	DEATHKNIGHT = { summon = 46584, specs = { 252 } },
}
