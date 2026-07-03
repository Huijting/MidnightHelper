local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

--[[
	Naam->rol-classifier voor EVOKER (Devastation 1467, Preservation 1468, Augmentation 1473) - v6-keybind-standaard.
	VERVANGT de oude incomplete draft-versie: dekt ELKE relevante active spell per spec, inclusief
	de self-heals (Verdant Embrace, Renewing Blaze, Living Flame) die eerder ontbraken.

	Bron 1: docs/KEYBIND_MAP_DRAFT_warrior_dk_dh_evoker.md (Devastation/Preservation/Augmentation tabellen).
	Bron 2 (addon-data, ter afleiding van de rol):
	  - JustAC/Data/InterruptAbilities.lua : Quell (351338, kind=interrupt). LET OP: dit is de
	    ENIGE Evoker-entry in dat bestand. Sleep Walk / Landslide / Oppressing Roar staan NIET
	    in InterruptAbilities.lua maar in de CC-lijst van SpellCategories.lua (-> dispel_cc).
	    Tail Swipe / Wing Buffet komen in geen enkele addon-databron voor (niet opgenomen).
	  - JustAC/Data/SpellCategories.lua (DEFENSIVE_SPELLS) : Obsidian Scales (363916),
	    Renewing Blaze (374348), Time Dilation (357170), Time Stop (378441),
	    Spatial Paradox (406732), Blistering Scales (360827), Emerald Communion (370960).
	    Zephyr / Rewind (363534) / Defy Fate / Stasis staan hier NIET in SpellCategories maar
	    komen uit de draft (Interrupt_CCAndCD_Tracker) -> defensive / cooldown-slots.
	  - JustAC/Data/SpellCategories.lua (HEALING_SPELLS) : Verdant Embrace (360995),
	    Living Flame heal (361469), Emerald Blossom (355913), Rewind (363534),
	    Reversion (366155), Spiritbloom (367226), Dream Breath (382614),
	    Temporal Anomaly (382731), Naturalize (360823).
	  - JustAC/Data/SpellCategories.lua (CROWD_CONTROL_SPELLS) : Quell (351338),
	    Sleep Walk (360806), Oppressing Roar (372048). Landslide via draft.
	  - JustAC/Data/SpellCategories.lua (UTILITY_SPELLS) : Hover (358267), Expunge (365585),
	    Cauterizing Flame (374251), Return (361227), Fury of the Aspects (390386),
	    Blessing of the Bronze (381748), Ebon Might (395152), Prescience (409311).
	  - JustAC/Data/SpellArchetypes.lua : damage-abilities (Deep Breath, Pyre, Firestorm,
	    Fire Breath, Disintegrate, Eternity Surge, Eruption, Upheaval, Breath of Eons).
	  - ClassCodex/Data/Evoker/guide.lua : Dream Breath, Temporal Anomaly, Eternity Surge,
	    Time Skip, Tip the Scales, Azure Sweep e.d.

	Gekeyd op de exacte spell-NAAM; de addon matcht dit tegen de live spellbook. Alle specs van
	de class in EEN tabel. Baseline-spells (geen specs-veld) gelden voor alle 3 de specs:
	Quell, Hover, Deep Breath, Obsidian Scales, Zephyr, Sleep Walk, Expunge, Cauterizing Flame,
	Verdant Embrace, Renewing Blaze, Living Flame, Blessing of the Bronze, Fury of the Aspects,
	Landslide, Tip the Scales.

	Heal-ankers (never-lie, per opdracht):
	  - heal_quick (F2) = Verdant Embrace  (instant self-heal + korte pull-to-target)
	  - heal_ooc   (F3) = Living Flame (Devastation/Augmentation) / Renewing Blaze (Preservation)
	  Renewing Blaze staat expliciet op heal_ooc (F3), NIET op de globale F4-Recuperate-slot.

	Overgeslagen (conform regels): Recuperate (globale F4), heal_sustain/F4, racial, trinket,
	potion, en zuivere passieven (Might of the Black Dragonflight, Shattering Stars-talent e.d.).
]]

ns.KeybindRoleClassifier.EVOKER = {
	-- ============================================================
	-- BASELINE (alle 3 specs: 1467 Devastation, 1468 Preservation, 1473 Augmentation)
	-- ============================================================
	-- Interrupt (E) - enige Evoker-entry in InterruptAbilities.lua
	["Quell"] = { role = "interrupt", priority = 1 },
	-- Movement (Q / Shift+Q)
	["Hover"] = { role = "utility_primary", priority = 1 },              -- Q (movement, baseline)
	["Deep Breath"] = { role = "utility_primary", priority = 2 },        -- Shift+Q (movement, ook major damage-CD)
	-- Kleine defensive (Z)
	["Obsidian Scales"] = { role = "defensive_1", priority = 1 },        -- Z (kleine def, baseline)
	-- Grote defensive (C)
	["Zephyr"] = { role = "defensive_3", priority = 1 },                 -- C (grote def, groeps-damage-reductie, baseline)
	-- Dispel / CC (V-cluster)
	["Sleep Walk"] = { category = "dispel_cc", priority = 1 },           -- V (incapacitate CC, baseline)
	["Expunge"] = { category = "dispel_cc", priority = 2 },              -- Shift+V (poison-dispel, baseline)
	["Cauterizing Flame"] = { category = "dispel_cc", priority = 3 },    -- Ctrl+V (bleed/poison/curse/disease-dispel, overflow)
	["Landslide"] = { category = "dispel_cc", priority = 4 },            -- T (root-CC, baseline; draft: Interrupt_CCAndCD_Tracker)
	-- Self-heals (heal-ankers)
	["Verdant Embrace"] = { role = "heal_quick", priority = 1 },         -- F2 heal-anker: instant self-heal (baseline)
	["Living Flame"] = { role = "heal_ooc", priority = 1 },              -- F3 heal-anker: out-of-combat/filler self-heal (baseline)
	-- Renewing Blaze: persoonlijke self-heal-over-time. Op heal_ooc (F3), NIET F4-Recuperate.
	-- Baseline (alle specs beschikbaar); voor Deva/Aug is dit het F3-anker naast Living Flame's damage-filler.
	["Renewing Blaze"] = { role = "heal_ooc", priority = 2 },            -- F3 (self-heal, baseline alle 3 specs)
	-- Utility (R / F / T)
	["Blessing of the Bronze"] = { category = "utility", priority = 1 }, -- R/F (raid-buff, baseline)
	["Fury of the Aspects"] = { category = "cooldown", priority = 5 },   -- Shift+F1 (groeps-Bloodlust, baseline)
	["Tip the Scales"] = { category = "cooldown", priority = 6 },        -- F1-familie (empower-instant-modifier, ~2min offensive CD; baseline)

	-- ============================================================
	-- DEVASTATION (1467) - ranged dps
	-- ============================================================
	-- Builders / main_rotation (Azure Strike is Deva-builder + Aug-AoE-tweeling; zie gedeeld blok onderaan)
	["Fire Breath"] = { category = "main_rotation", priority = 2, specs = { 1467, 1468, 1473 } }, -- 3/Shift+4 (empower-builder; ook Pres/Aug)
	-- Spenders
	["Disintegrate"] = { category = "spender", priority = 1, specs = { 1467 } },         -- 4 (Essence-spender, channel)
	["Eternity Surge"] = { category = "spender", priority = 2, specs = { 1467 } },       -- 5 (empower-spender, ST-piercing)
	-- AoE (Shift-tweelingen)
	["Azure Sweep"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 1467 } },  -- AoE (Shift-tweeling Azure Strike)
	["Pyre"] = { category = "spender", priority = 6, bindKey = "Shift+4", specs = { 1467 } },               -- AoE-spender (Shift-tweeling Disintegrate)
	["Firestorm"] = { category = "main_rotation", priority = 7, bindKey = "Shift+5", specs = { 1467 } },    -- AoE (extra, proc-based)
	-- Grootste CD (F1) + extra CD's
	["Dragonrage"] = { role = "cooldown_bar", priority = 1, specs = { 1467 } },          -- F1 (grootste CD: burst-venster)
	-- Utility (F3)
	["Oppressing Roar"] = { category = "utility", priority = 2, specs = { 1467 } },      -- F3 (groeps-fear/CC-duur-extender)

	-- ============================================================
	-- PRESERVATION (1468) - healer
	-- ST-heals + ST-HoTs (Reversion/Echo/Spiritbloom/Verdant Embrace/Living Flame) lopen via
	-- mouseover/Click-Cast (role="click_cast", priority=1), GEEN keybind-slot (v6 SS6).
	-- Raid/AoE-heals staan op toets (main_rotation/spender). Heal-CD's onder category="cooldown".
	-- Pres krijgt hier verder: utility/dispel/defensives + persoonlijke self-heal.
	-- ============================================================
	-- Single-target-heals / ST-HoTs -> Click-Cast (mouseover), GEEN toets (v6 SS6)
	["Reversion"] = { role = "click_cast", priority = 1, specs = { 1468 } },             -- ST-HoT (366155, HEALING_SPELLS) -> mouseover/click-cast
	["Echo"] = { role = "click_cast", priority = 1, specs = { 1468 } },                  -- ST-heal/HoT-buffer (Essence) -> mouseover/click-cast
	["Spiritbloom"] = { role = "click_cast", priority = 1, specs = { 1468 } },           -- empower ST-split-heal (367226) -> mouseover/click-cast
	-- (Verdant Embrace = baseline heal_quick/F2, werkt ook op ally als ST-heal; niet dubbel keyen.)
	-- (Living Flame heal = baseline heal_ooc/F3, ST-heal-filler; niet dubbel keyen.)
	-- "Builders" / raid-AoE-heal (kernrotatie, op toets)
	["Dream Breath"] = { category = "raid_heal", priority = 1, specs = { 1468 } },   -- empower raid-AoE-heal
	["Temporal Anomaly"] = { category = "raid_heal", priority = 2, specs = { 1468 } }, -- raid-AoE-shield, Echo-generator
	-- Raid/AoE-heal (op toets)
	["Emerald Blossom"] = { category = "raid_heal", priority = 3, specs = { 1468 } },      -- Essence-spender, AoE-heal
	-- Heal-COOLDOWNS (v6 SS6): grootste = cooldown_bar, rest category="cooldown"
	["Dream Flight"] = { role = "cooldown_bar", priority = 1, specs = { 1468 } },        -- F1 (grootste heal-CD: grote burst-raid-heal)
	["Stasis"] = { category = "cooldown", priority = 2, specs = { 1468 } },              -- Shift+F1 (banked-heals major CD)
	["Emerald Communion"] = { category = "cooldown", priority = 3, specs = { 1468 } },   -- extra CD (self/raid channel-heal, mana; SpellCategories defensive)
	["Rewind"] = { category = "cooldown", priority = 4, specs = { 1468 } },              -- F1-familie (grote heal-CD: rewind group-health; vorige ronde -> laten)
	["Time Dilation"] = { category = "cooldown", priority = 5, specs = { 1468 } },       -- external heal-CD (357170, damage-delay op ally; SpellCategories defensive)
	-- (Preservation self-heal Renewing Blaze staat in het BASELINE-blok op heal_ooc/F3.)
	-- Utility
	["Source of Magic"] = { category = "utility", priority = 2, specs = { 1468 } },      -- R (mana-support op ally)

	-- ============================================================
	-- AUGMENTATION (1473) - support/buff dps
	-- ============================================================
	-- "Builders" / kernbuffs (hoofdrotatie, elke GCD-cyclus)
	["Ebon Might"] = { category = "main_rotation", priority = 1, specs = { 1473 } },     -- 1 (kern-supportbuff)
	["Prescience"] = { category = "main_rotation", priority = 2, specs = { 1473 } },     -- 2 (target-buff)
	-- Spenders
	["Eruption"] = { category = "spender", priority = 1, specs = { 1473 } },             -- 4 (Essence-spender, vervangt Disintegrate)
	["Upheaval"] = { category = "spender", priority = 2, specs = { 1473 } },             -- 5 (empower-spender/AoE-launch)
	-- Grootste CD (F1) + extra CD's
	["Breath of Eons"] = { role = "cooldown_bar", priority = 1, specs = { 1473 } },      -- F1 (grootste CD: gebundelde raid-damage)
	-- Extra defensive (Shift+C) - cheat-death (draft, geen SpellCategories-entry)
	["Defy Fate"] = { role = "defensive_4", priority = 1, specs = { 1473 } },            -- Shift+C (cheat-death, extra grote def)
	-- Utility
	["Blistering Scales"] = { category = "utility", priority = 2, specs = { 1473 } },    -- R (ally-defensive-buff + thorns)
	["Time Skip"] = { category = "utility", priority = 3, specs = { 1473 } },            -- T (groep-cooldown-reset support)

	-- ============================================================
	-- GEDEELDE DPS-SPELLS over meerdere specs
	-- ============================================================
	-- Living Flame doet dubbel dienst als filler-damage (Deva/Aug 3, Pres 5) EN als heal_ooc-anker
	-- hierboven. Als filler-damage staat het onder heal_ooc (baseline) verwerkt; hier geen dubbele key.
	-- Azure Strike is Devastation-builder (2) en Augmentation-AoE-tweeling (Shift+3) - zelfde spell:
	["Azure Strike"] = { category = "main_rotation", priority = 1, specs = { 1467, 1473 } }, -- Deva builder / Aug AoE-tweeling
}

