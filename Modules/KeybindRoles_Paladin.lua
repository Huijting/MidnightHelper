local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

--[[
	Naam->rol-classifier voor PALADIN (WoW Midnight, addon Midnight Helper, v6-keybind-standaard).
	VERVANGT de oude incomplete draft-versie (ns.KeybindRoleClassifier.PALADIN in
	Modules/KeybindRoles_HunterPaladinShaman.lua). Deze module is de complete, autoritatieve
	bron voor Paladin; laadt na de gedeelde module en overschrijft PALADIN volledig.

	NEVER-LIE. Rollen zijn AFGELEID uit addon-data onder Interface\AddOns\, niet gegokt:
	  - JustAC\Data\SpellCategories.lua      -> defensive / healing / cc / utility (per spellID)
	  - JustAC\Data\InterruptAbilities.lua   -> Rebuke=interrupt(pri1), Avenger's Shield=interrupt(pri2)
	  - JustAC\Data\SpellArchetypes.lua      -> melee/ranged builders+spenders (Judgment, Shield of the
	                                            Righteous, Blade of Justice, Wake of Ashes, etc.)
	  - ClassCodex\Data\Paladin\guide.lua    -> spec-rotaties (Holy/Prot/Ret), hero-talent Templar
	  - BliZzi_Interrupts\Core\Data.lua      -> Rebuke (96231) = interrupt voor spec 66/70; Holy (65)
	                                            = noKick (geen interrupt-rotatie). Rebuke blijft
	                                            spellbook-baseline (alle 3 specs kunnen 'm leren).

	Sleutel = EXACTE spell-NAAM; de addon matcht dit tegen de live spellbook. `specs={id}` maakt
	een entry spec-specifiek; geen `specs` = class-baseline (op alle 3 specs beschikbaar).
	specID's: Holy=65, Protection=66, Retribution=70.

	`id = <spellID>` = PRIMAIRE match-sleutel (PILOT voor de spellID-migratie, review F1.3): de
	live spellbook geeft GELOKALISEERDE namen, dus naam-matchen faalt op elke deDE/frFR/…-game-
	client. KeybindAutoMap matcht daarom eerst op spellID, met de naam als fallback. Alle id's
	hieronder zijn addon-geverifieerd (JustAC SpellCategories/SpellCooldowns/InterruptAbilities/
	SpellArchetypes) — never-lie, niet gegokt.

	Rol-vocab (roles): interrupt, utility_primary, utility_secondary, mobility, defensive_1,
	defensive_2, defensive_3, defensive_4, cooldown_bar, heal_quick, heal_ooc.
	Categorie-vocab (categories): main_rotation, spender, utility, dispel_cc, cooldown, defensive.

	Slots (v6): interrupt=E, movement=Q, kleine def=Z, grote def=C, dispel/CC=V, grootste CD=F1,
	heal_quick=F2, heal_ooc=F3, AoE=Shift+N. NIET opgenomen: Recuperate (F4/heal_sustain), racial,
	trinket, potion, en zuivere passieven.
]]

ns.KeybindRoleClassifier.PALADIN = {

	--==============================================================================
	-- CLASS-BASELINE (geen specs = alle 3 specs: Holy 65 / Prot 66 / Ret 70)
	--==============================================================================

	-- Interrupt (E). Rebuke is spellbook-baseline; BliZzi assigneert 'm actief aan Prot/Ret,
	-- Holy noKick, maar de spell is leerbaar door alle Paladins -> baseline.
	["Rebuke"] = { id = 96231, role = "interrupt", priority = 1 }, -- InterruptAbilities.lua [96231] kind=interrupt pri=1

	-- Movement (Q). Divine Steed = enige class-brede mobility (SpellCategories UTILITY [190784]).
	["Divine Steed"] = { id = 190784, role = "utility_primary", priority = 1 }, -- Q; baseline movement

	-- Kleine defensive (Z). Divine Shield = persoonlijke immunity (SpellCategories DEFENSIVE [642]).
	["Divine Shield"] = { id = 642, role = "defensive_1", priority = 1 }, -- Z; baseline (642)

	-- Grote defensive (C). Guardian of Ancient Kings (SpellCategories DEFENSIVE [86659]).
	["Guardian of Ancient Kings"] = { id = 86659, role = "defensive_3", priority = 1 }, -- C; baseline (86659)

	-- Extra defensives (category="defensive"; overflow-slots). Allen SpellCategories DEFENSIVE.
	["Divine Protection"] = { id = 403876, category = "defensive", priority = 2 }, -- DEFENSIVE [403876] (kleine DR)
	["Blessing of Protection"] = { id = 1022, category = "defensive", priority = 3 }, -- DEFENSIVE [1022] (fysieke immunity, op ally/self)
	["Blessing of Sacrifice"] = { id = 6940, category = "defensive", priority = 4 }, -- DEFENSIVE [6940] (external DR-transfer)
	["Blessing of Spellwarding"] = { id = 204018, category = "defensive", priority = 5 }, -- DEFENSIVE [204018] (magic immunity, talent)

	-- Dispel / CC (V). Cleanse=dispel; Hammer of Justice/Blinding Light/Repentance=CC/stun.
	["Cleanse"] = { id = 4987, category = "dispel_cc", priority = 1 }, -- SpellCategories HEALING [4987] (poison/disease/magic dispel)
	["Cleanse Toxins"] = { id = 213644, category = "dispel_cc", priority = 2 }, -- SpellCategories UTILITY [213644] (Prot/Ret dispel-variant)
	["Hammer of Justice"] = { id = 853, category = "dispel_cc", priority = 3, alsoStop = true }, -- CROWD_CONTROL [853] (stun); JustAC InterruptAbilities [853] kind=cc/stun-interrupt → Spec 08 off-interrupt tag
	["Blinding Light"] = { id = 115750, category = "dispel_cc", priority = 4 }, -- CROWD_CONTROL [115750] (AoE disorient; castbare id per JustAC SpellCooldowns/SpellCategories, 105421 = effect)
	["Repentance"] = { id = 20066, category = "dispel_cc", priority = 5 }, -- CROWD_CONTROL [20066] (incapacitate, talent)
	["Turn Evil"] = { id = 10326, category = "dispel_cc", priority = 6 }, -- CROWD_CONTROL [10326] (fear undead/demon)
	["Blessing of Freedom"] = { id = 1044, category = "dispel_cc", priority = 7 }, -- UTILITY [1044] (root/snare-cleanse op ally/self)

	-- Self-heals (F2 = heal_quick snelle combat-heal; F3 = heal_ooc out-of-combat).
	-- Word of Glory = instant Holy-Power-noodheal, baseline alle specs (SpellCategories HEALING [85673]).
	["Word of Glory"] = { id = 85673, role = "heal_quick", priority = 1 }, -- F2; baseline (85673) instant self-heal
	-- Lay on Hands = grootste out-of-combat noodheal (full HP), baseline (SpellCategories HEALING [633]).
	["Lay on Hands"] = { id = 633, role = "heal_ooc", priority = 1 }, -- F3; baseline (633) OOC-noodheal

	-- Utility (Blessings / rez / etc.). Blessing of Freedom staat al bij dispel_cc.
	["Redemption"] = { id = 7328, category = "utility", priority = 8 }, -- UTILITY [7328] (out-of-combat rez)
	["Intercession"] = { id = 391054, category = "utility", priority = 9 }, -- UTILITY [391054] (battle-rez, talent)

	--==============================================================================
	-- HOLY (spec 65) - healer.
	-- ST-heals (Holy Light/Flash of Light/Holy Shock als single-target-heal) gaan via
	-- mouseover/click-cast, NIET op toetsen. Op toetsen: damage/AoE-heal-builders +
	-- utility + dispel + defensives + cooldowns + persoonlijke self-heal + raid-heal-CD's.
	--==============================================================================

	-- ST-heals (v6 S6) -> click_cast: geen toets, mouseover/click-cast op raid-frame.
	["Holy Shock"] = { id = 20473, role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [20473]; Holy single-target heal (bouwt ook Holy Power). Ret/Prot hebben geen Holy Shock -> Holy-only, veilig click_cast.
	["Flash of Light"] = { id = 19750, role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [19750]; snelle ST-heal (instant bij Infusion of Light)
	["Holy Light"] = { id = 82326, role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [82326]; grote (dure) ST-filler-heal
	["Bestow Faith"] = { id = 223306, role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [223306]; ST-heal-op-target (talent)
	-- Beacons = buff-op-target (kies doelwit) -> ook click_cast/mouseover.
	["Beacon of Light"] = { id = 53563, role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [53563]; beacon-plaatsing op target
	["Beacon of Faith"] = { id = 156910, role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [156910]; tweede beacon-op-target (talent)
	-- Raid/AoE-heals BLIJVEN op toetsen.
	["Light of Dawn"] = { id = 85222, category = "raid_heal", priority = 1, bindKey = "Shift+4", specs = { 65 } }, -- HEALING [85222]; AoE-heal-spender (AoE-slot)
	["Holy Prism"] = { id = 114165, category = "raid_heal", priority = 2, specs = { 65 } }, -- HEALING [114165]; AoE-heal/damage
	["Barrier of Faith"] = { id = 148039, category = "spender", priority = 3, specs = { 65 } }, -- HEALING [148039]; raid-shield-op-target (talent)
	["Light's Hammer"] = { id = 114158, category = "spender", priority = 4, specs = { 65 } }, -- HEALING [114158]; ground-AoE-heal (talent)
	["Beacon of Virtue"] = { id = 200025, category = "utility", priority = 4, specs = { 65 } }, -- HEALING [200025]; multi-beacon-AoE (talent)
	-- Heal-cooldowns: grootste = cooldown_bar, rest category="cooldown".
	["Divine Toll"] = { id = 375576, category = "cooldown", priority = 2, specs = { 65, 66, 70 } }, -- [375576] instant Holy-Power-burst; baseline-CD op alle 3 specs (Holy heal / Prot / Ret). Eén entry: dubbele-key zou anders 2 specs verliezen.
	["Tyr's Deliverance"] = { id = 200652, category = "cooldown", priority = 3, specs = { 65 } }, -- HEALING [200652]; raid-heal-CD (talent)
	["Aura Mastery"] = { id = 31821, role = "cooldown_bar", priority = 2, specs = { 65 } }, -- HEALING [31821]; raid-defensive-CD (F1-familie)
	["Avenging Crusader"] = { id = 216331, role = "cooldown_bar", priority = 3, specs = { 65 } }, -- HEALING [216331]; Avenging-Wrath-vervanger, grote heal-CD (talent)

	--==============================================================================
	-- PROTECTION (spec 66) - tank.
	--==============================================================================

	["Judgment"] = { id = 20271, category = "main_rotation", priority = 1, specs = { 66, 70 } }, -- SpellArchetypes [20271] ranged builder; Prot 1 / Ret builder
	["Avenger's Shield"] = { id = 31935, category = "main_rotation", priority = 2, specs = { 66 }, alsoStop = true }, -- InterruptAbilities [31935] (ook interrupt pri2) + Archetypes ranged; ranged builder; alsoStop → Spec 08 cross-list (stays on 2, rotational-primary)
	["Hammer of the Righteous"] = { id = 88263, category = "main_rotation", priority = 3, specs = { 66 } }, -- SpellArchetypes [88263] ranged; AoE-cleave builder
	["Blessed Hammer"] = { id = 204019, category = "main_rotation", priority = 3, specs = { 66 } }, -- SpellArchetypes [204019]; talent-alternatief voor Hammer of the Righteous
	["Shield of the Righteous"] = { id = 53600, category = "defensive", priority = 1, specs = { 66 } }, -- SpellArchetypes [53600] melee; verbruikt Holy Power maar is ACTIEVE MITIGATION (block+DR), functioneel defensive, geen damage-spender
	["Consecration"] = { id = 26573, category = "main_rotation", priority = 4, specs = { 66 } }, -- guide.lua Prot-rotatie; [26573] castbare id (JustAC SpellCooldowns); ground-AoE, on-cooldown houden
	["Hammer of Wrath"] = { id = 24275, category = "spender", priority = 2, specs = { 66, 70 } }, -- SpellArchetypes [24275] ranged; execute-spender (Prot/Ret)
	["Hand of Reckoning"] = { id = 62124, category = "taunt", priority = 1, specs = { 66 } }, -- [62124] taunt (JustAC SpellCooldowns/SpellCategories); F, eigen kaart
	["Ardent Defender"] = { id = 31850, category = "defensive", priority = 2, specs = { 66 } }, -- DEFENSIVE [31850]; Prot grote persoonlijke DR
	["Bastion of Light"] = { id = 378974, category = "cooldown", priority = 3, specs = { 66 } }, -- DEFENSIVE [378974]; Prot Holy-Power-burst (talent)

	--==============================================================================
	-- RETRIBUTION (spec 70) - melee DPS.
	--==============================================================================

	["Crusader Strike"] = { id = 35395, category = "main_rotation", priority = 1, specs = { 70 } }, -- SpellArchetypes [35395] melee; Holy-Power-builder
	["Blade of Justice"] = { id = 184575, category = "main_rotation", priority = 3, specs = { 70 } }, -- SpellArchetypes [184575] ranged; builder
	["Templar's Verdict"] = { id = 224266, category = "spender", priority = 1, specs = { 70 } }, -- SpellArchetypes [224266] ranged; Holy-Power-spender (ST)
	["Final Verdict"] = { id = 383328, category = "spender", priority = 1, specs = { 70 } }, -- SpellArchetypes [383328]; Templar's-Verdict-vervanger (talent)
	["Divine Storm"] = { id = 53385, category = "spender", priority = 2, bindKey = "Shift+4", specs = { 70 } }, -- SpellArchetypes [53385] melee; AoE-spender (AoE-slot)
	["Wake of Ashes"] = { id = 255937, category = "cooldown", priority = 2, specs = { 70 } }, -- SpellArchetypes [255937] melee; Ret burst-cooldown
	["Shield of Vengeance"] = { id = 184662, role = "defensive_3", priority = 1, specs = { 70 } }, -- DEFENSIVE [184662]; Ret C (grote def; Holy/Prot = Guardian)
	-- Divine Toll staat als één gedeelde baseline-entry bij Holy (specs {65,66,70}); geen aparte Ret-entry (dubbele table-key).

	--==============================================================================
	-- GROOTSTE COOLDOWN (F1) + extra CD's - baseline waar mogelijk.
	--==============================================================================

	-- Avenging Wrath = grootste offensieve/heal-CD, baseline alle specs (BliZzi OffensiveCDAlert +
	-- guide.lua). F1 = cooldown_bar. (Holy kan Avenging Crusader als vervanger talenten - zie boven.)
	["Avenging Wrath"] = { id = 31884, role = "cooldown_bar", priority = 1 }, -- F1; baseline (31884) grote CD
	-- Sentinel (Prot/Ret cooldown) - SpellCategories/SpellCooldowns [389539]. NB: de "hero-Templar-lijn"-
	-- duiding is onbevestigd (review F1.4); het id 389539 is wél addon-geverifieerd.
	["Sentinel"] = { id = 389539, category = "cooldown", priority = 4, specs = { 66, 70 } },
}
