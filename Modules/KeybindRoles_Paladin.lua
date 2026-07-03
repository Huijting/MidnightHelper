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
	["Rebuke"] = { role = "interrupt", priority = 1 }, -- InterruptAbilities.lua [96231] kind=interrupt pri=1

	-- Movement (Q). Divine Steed = enige class-brede mobility (SpellCategories UTILITY [190784]).
	["Divine Steed"] = { role = "utility_primary", priority = 1 }, -- Q; baseline movement

	-- Kleine defensive (Z). Divine Shield = persoonlijke immunity (SpellCategories DEFENSIVE [642]).
	["Divine Shield"] = { role = "defensive_1", priority = 1 }, -- Z; baseline (642)

	-- Grote defensive (C). Guardian of Ancient Kings (SpellCategories DEFENSIVE [86659]).
	["Guardian of Ancient Kings"] = { role = "defensive_3", priority = 1 }, -- C; baseline (86659)

	-- Extra defensives (category="defensive"; overflow-slots). Allen SpellCategories DEFENSIVE.
	["Divine Protection"] = { category = "defensive", priority = 2 }, -- DEFENSIVE [403876] (kleine DR)
	["Blessing of Protection"] = { category = "defensive", priority = 3 }, -- DEFENSIVE [1022] (fysieke immunity, op ally/self)
	["Blessing of Sacrifice"] = { category = "defensive", priority = 4 }, -- DEFENSIVE [6940] (external DR-transfer)
	["Blessing of Spellwarding"] = { category = "defensive", priority = 5 }, -- DEFENSIVE [204018] (magic immunity, talent)

	-- Dispel / CC (V). Cleanse=dispel; Hammer of Justice/Blinding Light/Repentance=CC/stun.
	["Cleanse"] = { category = "dispel_cc", priority = 1 }, -- SpellCategories HEALING [4987] (poison/disease/magic dispel)
	["Cleanse Toxins"] = { category = "dispel_cc", priority = 2 }, -- SpellCategories UTILITY [213644] (Prot/Ret dispel-variant)
	["Hammer of Justice"] = { category = "dispel_cc", priority = 3 }, -- CROWD_CONTROL [853] (stun)
	["Blinding Light"] = { category = "dispel_cc", priority = 4 }, -- CROWD_CONTROL [105421/115750] (AoE disorient)
	["Repentance"] = { category = "dispel_cc", priority = 5 }, -- CROWD_CONTROL [20066] (incapacitate, talent)
	["Turn Evil"] = { category = "dispel_cc", priority = 6 }, -- CROWD_CONTROL [10326] (fear undead/demon)
	["Blessing of Freedom"] = { category = "dispel_cc", priority = 7 }, -- UTILITY [1044] (root/snare-cleanse op ally/self)

	-- Self-heals (F2 = heal_quick snelle combat-heal; F3 = heal_ooc out-of-combat).
	-- Word of Glory = instant Holy-Power-noodheal, baseline alle specs (SpellCategories HEALING [85673]).
	["Word of Glory"] = { role = "heal_quick", priority = 1 }, -- F2; baseline (85673) instant self-heal
	-- Lay on Hands = grootste out-of-combat noodheal (full HP), baseline (SpellCategories HEALING [633]).
	["Lay on Hands"] = { role = "heal_ooc", priority = 1 }, -- F3; baseline (633) OOC-noodheal

	-- Utility (Blessings / rez / etc.). Blessing of Freedom staat al bij dispel_cc.
	["Redemption"] = { category = "utility", priority = 8 }, -- UTILITY [7328] (out-of-combat rez)
	["Intercession"] = { category = "utility", priority = 9 }, -- UTILITY [391054] (battle-rez, talent)

	--==============================================================================
	-- HOLY (spec 65) - healer.
	-- ST-heals (Holy Light/Flash of Light/Holy Shock als single-target-heal) gaan via
	-- mouseover/click-cast, NIET op toetsen. Op toetsen: damage/AoE-heal-builders +
	-- utility + dispel + defensives + cooldowns + persoonlijke self-heal + raid-heal-CD's.
	--==============================================================================

	-- ST-heals (v6 S6) -> click_cast: geen toets, mouseover/click-cast op raid-frame.
	["Holy Shock"] = { role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [20473]; Holy single-target heal (bouwt ook Holy Power). Ret/Prot hebben geen Holy Shock -> Holy-only, veilig click_cast.
	["Flash of Light"] = { role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [19750]; snelle ST-heal (instant bij Infusion of Light)
	["Holy Light"] = { role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [82326]; grote (dure) ST-filler-heal
	["Bestow Faith"] = { role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [223306]; ST-heal-op-target (talent)
	-- Beacons = buff-op-target (kies doelwit) -> ook click_cast/mouseover.
	["Beacon of Light"] = { role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [53563]; beacon-plaatsing op target
	["Beacon of Faith"] = { role = "click_cast", priority = 1, specs = { 65 } }, -- HEALING [156910]; tweede beacon-op-target (talent)
	-- Raid/AoE-heals BLIJVEN op toetsen.
	["Light of Dawn"] = { category = "raid_heal", priority = 1, bindKey = "Shift+4", specs = { 65 } }, -- HEALING [85222]; AoE-heal-spender (AoE-slot)
	["Holy Prism"] = { category = "raid_heal", priority = 2, specs = { 65 } }, -- HEALING [114165]; AoE-heal/damage
	["Barrier of Faith"] = { category = "spender", priority = 3, specs = { 65 } }, -- HEALING [148039]; raid-shield-op-target (talent)
	["Light's Hammer"] = { category = "spender", priority = 4, specs = { 65 } }, -- HEALING [114158]; ground-AoE-heal (talent)
	["Beacon of Virtue"] = { category = "utility", priority = 4, specs = { 65 } }, -- HEALING [200025]; multi-beacon-AoE (talent)
	-- Heal-cooldowns: grootste = cooldown_bar, rest category="cooldown".
	["Divine Toll"] = { category = "cooldown", priority = 2, specs = { 65, 66 } }, -- Holy R / Prot Shift+F1; instant Holy-Power-burst (heal-CD op Holy)
	["Tyr's Deliverance"] = { category = "cooldown", priority = 3, specs = { 65 } }, -- HEALING [200652]; raid-heal-CD (talent)
	["Aura Mastery"] = { role = "cooldown_bar", priority = 2, specs = { 65 } }, -- HEALING [31821]; raid-defensive-CD (F1-familie)
	["Avenging Crusader"] = { role = "cooldown_bar", priority = 3, specs = { 65 } }, -- HEALING [216331]; Avenging-Wrath-vervanger, grote heal-CD (talent)

	--==============================================================================
	-- PROTECTION (spec 66) - tank.
	--==============================================================================

	["Judgment"] = { category = "main_rotation", priority = 1, specs = { 66, 70 } }, -- SpellArchetypes [20271] ranged builder; Prot 1 / Ret builder
	["Avenger's Shield"] = { category = "main_rotation", priority = 2, specs = { 66 } }, -- InterruptAbilities [31935] (ook interrupt pri2) + Archetypes ranged; ranged builder
	["Hammer of the Righteous"] = { category = "main_rotation", priority = 3, specs = { 66 } }, -- SpellArchetypes [88263] ranged; AoE-cleave builder
	["Blessed Hammer"] = { category = "main_rotation", priority = 3, specs = { 66 } }, -- SpellArchetypes [204019]; talent-alternatief voor Hammer of the Righteous
	["Shield of the Righteous"] = { category = "defensive", priority = 1, specs = { 66 } }, -- SpellArchetypes [53600] melee; verbruikt Holy Power maar is ACTIEVE MITIGATION (block+DR), functioneel defensive, geen damage-spender
	["Consecration"] = { category = "main_rotation", priority = 4, specs = { 66 } }, -- guide.lua Prot-rotatie; ground-AoE, on-cooldown houden
	["Hammer of Wrath"] = { category = "spender", priority = 2, specs = { 66, 70 } }, -- SpellArchetypes [24275] ranged; execute-spender (Prot/Ret)
	["Hand of Reckoning"] = { category = "taunt", priority = 1, specs = { 66 } }, -- taunt (F, eigen kaart)
	["Ardent Defender"] = { category = "defensive", priority = 2, specs = { 66 } }, -- DEFENSIVE [31850]; Prot grote persoonlijke DR
	["Bastion of Light"] = { category = "cooldown", priority = 3, specs = { 66 } }, -- DEFENSIVE [378974]; Prot Holy-Power-burst (talent)

	--==============================================================================
	-- RETRIBUTION (spec 70) - melee DPS.
	--==============================================================================

	["Crusader Strike"] = { category = "main_rotation", priority = 1, specs = { 70 } }, -- SpellArchetypes [35395] melee; Holy-Power-builder
	["Blade of Justice"] = { category = "main_rotation", priority = 3, specs = { 70 } }, -- SpellArchetypes [184575] ranged; builder
	["Templar's Verdict"] = { category = "spender", priority = 1, specs = { 70 } }, -- SpellArchetypes [224266] ranged; Holy-Power-spender (ST)
	["Final Verdict"] = { category = "spender", priority = 1, specs = { 70 } }, -- SpellArchetypes [383328]; Templar's-Verdict-vervanger (talent)
	["Divine Storm"] = { category = "spender", priority = 2, bindKey = "Shift+4", specs = { 70 } }, -- SpellArchetypes [53385] melee; AoE-spender (AoE-slot)
	["Wake of Ashes"] = { category = "cooldown", priority = 2, specs = { 70 } }, -- SpellArchetypes [255937] melee; Ret burst-cooldown
	["Shield of Vengeance"] = { role = "defensive_3", priority = 1, specs = { 70 } }, -- DEFENSIVE [184662]; Ret C (grote def; Holy/Prot = Guardian)
	["Divine Toll"] = { category = "cooldown", priority = 2, specs = { 70 } }, -- Ret instant-Holy-Power-burst (indien getalenteerd)

	--==============================================================================
	-- GROOTSTE COOLDOWN (F1) + extra CD's - baseline waar mogelijk.
	--==============================================================================

	-- Avenging Wrath = grootste offensieve/heal-CD, baseline alle specs (BliZzi OffensiveCDAlert +
	-- guide.lua). F1 = cooldown_bar. (Holy kan Avenging Crusader als vervanger talenten - zie boven.)
	["Avenging Wrath"] = { role = "cooldown_bar", priority = 1 }, -- F1; baseline (31884) grote CD
	-- Sentinel (Prot/Ret hero-Templar-lijn cooldown) - SpellCategories DEFENSIVE [389539].
	["Sentinel"] = { category = "cooldown", priority = 4, specs = { 66, 70 } },
}
