local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

--[[
	Naam->rol-classifier voor WARLOCK (WoW Midnight, addon Midnight Helper, v6-keybind-standaard).
	VERVANGT de oude incomplete draft-versie. Deze module is de complete, autoritatieve bron
	voor Warlock; laadt na de gedeelde module en overschrijft WARLOCK volledig.

	NEVER-LIE. Rollen zijn AFGELEID uit addon-data onder Interface\AddOns\, niet gegokt. Elke
	spell hieronder is met NAAM teruggevonden in de addon-data; onbevestigde draft-only namen
	(bv. Nether Portal, Power Siphon) zijn NIET opgenomen. Bronnen:
	  - JustAC\Data\InterruptAbilities.lua -> Spell Lock (19647) kind=interrupt pri=1;
	                                          Call Felhunter (212619) interrupt pri=2;
	                                          Axe Toss (89766) kind=cc mech=12 (stun, via Felguard);
	                                          Howl of Terror (5484) kind=cc mech=5 (fear).
	  - JustAC\Data\SpellCategories.lua    -> DEFENSIVE: Unending Resolve (104773), Dark Pact (108416).
	                                          CROWD_CONTROL: Howl of Terror (5484), Mortal Coil (6789),
	                                          Banish (710), Fear (118699), Spell Lock (19647),
	                                          Axe Toss (89766), Call Felhunter (212619).
	                                          UTILITY: Demonic Gateway (111771), Burning Rush (111400),
	                                          Command Demon (272651), Singe Magic (132411).
	                                          Soulstone (20707) = utility (battle-res), NOOIT heal.
	  - JustAC\Data\SpellArchetypes.lua    -> ranged builders/spenders per spec (Agony 980, Corruption 172,
	                                          Unstable Affliction, Haunt 48181, Malefic Rapture 1254057,
	                                          Malefic Grasp 1261153, Drain Soul, Seed of Corruption 27243,
	                                          Vile Taint, Phantom Singularity 205179, Soul Rot 325640,
	                                          Shadow Bolt 686, Demonbolt 264178, Hand of Gul'dan 86040,
	                                          Call Dreadstalkers 104316, Implosion 196278, Summon Vilefiend
	                                          264119, Grimoire: Felguard 111898, Demonic Tyrant 265187,
	                                          Incinerate 29722, Immolate 348, Conflagrate 17962,
	                                          Chaos Bolt 116858, Shadowburn 17877, Rain of Fire 5740,
	                                          Cataclysm 152108, Channel Demonfire 196448, Havoc 194831,
	                                          Soul Fire 6353, Dimensional Rift 387976, Doom 460555,
	                                          Drain Life 234153). Malevolence (446285) = Hellcaller-CD.
	                                          Summon Darkglare (205180) / Summon Demonic Tyrant (265187) /
	                                          Summon Infernal (157898) = grote spec-cooldowns.
	  - JustAC\Data\HealingItems.lua       -> Healthstone-item (5512) = OOC-noodheal (spell "Create
	                                          Healthstone" -> Healthstone). Drain Life = self-heal-kanaal.
	  - JustAC SpellCategories UTILITY [111400] Burning Rush + Demonic Circle: Teleport = movement.

	Sleutel = EXACTE spell-NAAM; de addon matcht dit tegen de live spellbook. `specs={id}` maakt
	een entry spec-specifiek; geen `specs` = class-baseline (op alle 3 specs beschikbaar).
	specID's: Affliction=265, Demonology=266, Destruction=267.

	Rol-vocab (roles): interrupt, utility_primary, utility_secondary, mobility, defensive_1,
	defensive_2, defensive_3, defensive_4, cooldown_bar, heal_quick, heal_ooc.
	Categorie-vocab (categories): main_rotation, spender, utility, dispel_cc, cooldown, defensive.

	Slots (v6): interrupt=E, movement=Q, kleine def=Z, grote def=C, dispel/CC=V, grootste CD=F1,
	heal_quick=F2, heal_ooc=F3, AoE=Shift+N. NIET opgenomen: Recuperate (F4/heal_sustain), racial,
	trinket, potion, en zuivere passieven. Soulstone = utility (rez), nooit heal.

	Let op interrupt: Warlock heeft GEEN eigen kick. De interrupt loopt via de pet:
	  - Affliction (265) / Destruction (267): Spell Lock via Felhunter.
	  - Demonology (266): Axe Toss via Felguard.
	Beide spells zijn spec-specifiek toegewezen (verschillende pets), daarom specs={} per entry
	i.p.v. baseline.
]]

ns.KeybindRoleClassifier.WARLOCK = {

	--==============================================================================
	-- CLASS-BASELINE (geen specs = alle 3 specs: Affli 265 / Demo 266 / Destro 267)
	--==============================================================================

	-- Movement (Q). Burning Rush + Demonic Circle: Teleport zijn class-brede mobility.
	["Burning Rush"] = { role = "utility_primary", priority = 1 }, -- Q; SpellCategories UTILITY [111400] (movement, hp-drain)
	["Demonic Circle: Teleport"] = { role = "utility_primary", priority = 2 }, -- Q-overflow; teleport naar geplaatste Circle (movement)

	-- Kleine defensive (Z). Dark Pact = instant hp-shield (offert een deel van pet/eigen hp).
	["Dark Pact"] = { role = "defensive_1", priority = 1 }, -- Z; SpellCategories DEFENSIVE [108416] (shield)

	-- Grote defensive (C). Unending Resolve = grote persoonlijke DR (panic-button), alle specs.
	["Unending Resolve"] = { role = "defensive_3", priority = 1 }, -- C; SpellCategories DEFENSIVE [104773]

	-- Dispel / CC (V) + overflow. Alle addon-bevestigd (SpellCategories CROWD_CONTROL / Interrupt).
	["Fear"] = { role = "defensive_2", category = "dispel_cc", priority = 1 }, -- V; CROWD_CONTROL [118699] (single-target fear)
	["Mortal Coil"] = { category = "dispel_cc", priority = 2 }, -- CROWD_CONTROL [6789] (horror-fear + 20% self-heal; talent)
	["Howl of Terror"] = { category = "dispel_cc", priority = 3 }, -- InterruptAbilities [5484] kind=cc mech=5 (AoE-fear; talent)
	["Banish"] = { category = "dispel_cc", priority = 4 }, -- CROWD_CONTROL [710] (banish demon/elemental)

	-- Self-heals. Drain Life = snelle combat-self-heal-kanaal (F2). Healthstone = OOC-noodheal (F3).
	["Drain Life"] = { role = "heal_quick", priority = 1 }, -- F2; SpellArchetypes [234153] kanaal, heelt de caster
	["Healthstone"] = { role = "heal_ooc", priority = 1 }, -- F3; HealingItems [5512] (spell "Create Healthstone" -> item); instant noodheal

	-- Utility (rez / raid-mobility / pet-command). Soulstone = battle-res, NOOIT heal.
	["Soulstone"] = { category = "utility", priority = 1 }, -- SpellCategories UTILITY-context [20707] (combat-res, geen heal)
	["Demonic Gateway"] = { category = "utility", priority = 2 }, -- SpellCategories UTILITY [111771] (raid-mobility, X)
	["Command Demon"] = { category = "utility", priority = 3 }, -- SpellCategories UTILITY [272651] (pet-ability-trigger)
	["Create Healthstone"] = { category = "utility", priority = 4 }, -- levert het Healthstone-item (utility-cast, out-of-combat)
	["Create Soulwell"] = { category = "utility", priority = 5 }, -- raid-Healthstone-well (utility)

	--==============================================================================
	-- AFFLICTION (spec 265) - ranged DoT DPS.
	--==============================================================================

	-- Interrupt (E). Geen eigen kick -> via Felhunter (Spell Lock). Command Demon proct de pet-cast.
	["Spell Lock"] = { role = "interrupt", priority = 1, specs = { 265, 267 } }, -- InterruptAbilities [19647] kind=interrupt pri=1 (Felhunter)
	["Call Felhunter"] = { role = "interrupt", priority = 2, specs = { 265, 267 } }, -- InterruptAbilities [212619] interrupt pri=2 (summon+kick)

	-- Builders (DoT-opbouw / shard-generatie).
	["Agony"] = { category = "main_rotation", priority = 1, specs = { 265 } }, -- SpellArchetypes [980] ranged; kern-DoT + shard-generatie
	["Corruption"] = { category = "main_rotation", priority = 2, specs = { 265 } }, -- SpellArchetypes [172] ranged; kern-DoT
	["Wither"] = { category = "main_rotation", priority = 2, specs = { 265 } }, -- SpellArchetypes ranged; Corruption-vervanger bij Hellcaller
	["Unstable Affliction"] = { category = "main_rotation", priority = 3, specs = { 265 } }, -- SpellArchetypes ranged; ST shard-spender-DoT
	["Haunt"] = { category = "main_rotation", priority = 4, specs = { 265 } }, -- SpellArchetypes [48181] ranged; cooldown-DoT (damage-amp)
	["Drain Soul"] = { category = "main_rotation", priority = 5, specs = { 265 } }, -- SpellArchetypes ranged; ST-filler/execute-kanaal

	-- Spenders (Soul Shard-dump).
	["Malefic Rapture"] = { category = "spender", priority = 1, specs = { 265 } }, -- SpellArchetypes [1254057] ranged; hoofd-shard-spender
	["Malefic Grasp"] = { category = "spender", priority = 2, specs = { 265 } }, -- SpellArchetypes [1261153] ranged; kanaal-spender-variant

	-- AoE-tweeling (Shift+N).
	["Seed of Corruption"] = { category = "spender", priority = 3, bindKey = "Shift+4", specs = { 265 } }, -- SpellArchetypes [27243] ranged; AoE-spender (AoE-slot, Shift-tweeling van Malefic Rapture slot 4)

	-- Cooldowns.
	["Summon Darkglare"] = { role = "cooldown_bar", priority = 1, specs = { 265 } }, -- F1; SpellDB/Archetypes [205180] grootste burst-CD (extendt DoTs)
	["Soul Rot"] = { category = "cooldown", priority = 2, specs = { 265 } }, -- SpellArchetypes [325640] ranged; burst-DoT-cooldown (ook Diabolist)
	["Phantom Singularity"] = { category = "cooldown", priority = 3, specs = { 265 } }, -- SpellArchetypes [205179] ranged; AoE-DoT-cooldown (talent)
	["Vile Taint"] = { category = "cooldown", priority = 4, specs = { 265 } }, -- SpellArchetypes [386931] ranged; AoE-DoT-cooldown (talent)
	["Malevolence"] = { role = "cooldown_bar", priority = 2, specs = { 265 } }, -- SpellArchetypes [446285] ranged; Hellcaller-hoofd-CD (Shift+F1)

	--==============================================================================
	-- DEMONOLOGY (spec 266) - pet/demon-DPS.
	--==============================================================================

	-- Interrupt (E). Geen eigen kick -> via Felguard (Axe Toss).
	["Axe Toss"] = { role = "interrupt", priority = 1, specs = { 266 } }, -- InterruptAbilities [89766] kind=cc mech=12 (stun, Felguard-interrupt)

	-- Builders (shard-generatie / Demonic Core).
	["Shadow Bolt"] = { category = "main_rotation", priority = 1, specs = { 266 } }, -- SpellArchetypes [686] ranged; shard-generatie-filler
	["Demonbolt"] = { category = "main_rotation", priority = 2, specs = { 266 } }, -- SpellArchetypes [264178] ranged; Demonic-Core-proc-builder
	["Call Dreadstalkers"] = { category = "main_rotation", priority = 3, specs = { 266 } }, -- SpellArchetypes [104316] ranged; kern-cooldown-pets

	-- Spenders (shard-dump / pet-summon).
	["Hand of Gul'dan"] = { category = "spender", priority = 1, specs = { 266 } }, -- SpellArchetypes [86040] ranged; hoofd-shard-spender (Wild Imps)
	["Summon Vilefiend"] = { category = "cooldown", priority = 2, specs = { 266 } }, -- SpellArchetypes [264119]; ~45s cooldown-pet-summon (CD, geen spambare shard-dump)
	["Grimoire: Felguard"] = { category = "spender", priority = 3, specs = { 266 } }, -- SpellArchetypes [111898]; extra-Felguard-cooldown (talent)

	-- AoE-tweeling (Shift+N).
	["Implosion"] = { category = "spender", priority = 4, bindKey = "Shift+4", specs = { 266 } }, -- SpellArchetypes [196278] ranged; Wild-Imp-AoE-detonatie (AoE-slot, Shift-tweeling van Hand of Gul'dan slot 4)

	-- DoT / extra.
	["Doom"] = { category = "main_rotation", priority = 4, specs = { 266 } }, -- SpellArchetypes [460555] ranged; AoE-DoT (talent)

	-- Cooldowns.
	["Summon Demonic Tyrant"] = { role = "cooldown_bar", priority = 1, specs = { 266 } }, -- F1; SpellArchetypes [265187] grootste burst-CD (buft alle demons)

	--==============================================================================
	-- DESTRUCTION (spec 267) - direct-damage ranged DPS.
	-- (Spell Lock / Call Felhunter interrupt = gedeeld met Affliction, hierboven specs={265,267}.)
	--==============================================================================

	-- Builders (Ember-generatie / DoT).
	["Incinerate"] = { category = "main_rotation", priority = 1, specs = { 267 } }, -- SpellArchetypes [29722] ranged; Ember-generatie-filler
	["Immolate"] = { category = "main_rotation", priority = 2, specs = { 267 } }, -- SpellArchetypes [348] ranged; DoT (on-target houden)
	["Conflagrate"] = { category = "main_rotation", priority = 3, specs = { 267 } }, -- SpellArchetypes [17962] ranged; charge-builder (Backdraft)

	-- Spenders (Soul Shard / Ember-dump).
	["Chaos Bolt"] = { category = "spender", priority = 1, specs = { 267 } }, -- SpellArchetypes [116858] ranged; hoofd-shard-spender (ST-nuke)
	["Shadowburn"] = { category = "spender", priority = 2, specs = { 267 } }, -- SpellArchetypes [17877] ranged; execute-spender (shard-efficient)

	-- AoE-tweeling (Shift+N).
	["Rain of Fire"] = { category = "spender", priority = 3, bindKey = "Shift+4", specs = { 267 } }, -- SpellArchetypes [5740] ranged; AoE-shard-spender (AoE-slot, Shift-tweeling van Chaos Bolt slot 4)

	-- Cleave / extra.
	["Havoc"] = { category = "utility", priority = 6, specs = { 267 } }, -- SpellArchetypes [194831] ranged; cleave-target-tag (dupliceert single-target-schade)
	["Soul Fire"] = { category = "main_rotation", priority = 4, specs = { 267 } }, -- SpellArchetypes [6353] ranged; mini-cooldown-builder (talent)

	-- Burst-cooldown (F1). Alleen de grote summon hoort in het F1-burst-cluster.
	["Summon Infernal"] = { role = "cooldown_bar", priority = 1, specs = { 267 } }, -- F1; SpellArchetypes [157898] grootste burst-CD (Meteor + haste)

	-- Korte rotatie-CD's (op-CD gecast, geen F1-burst-slot).
	["Cataclysm"] = { category = "main_rotation", priority = 5, specs = { 267 } }, -- SpellArchetypes [152108] ranged; korte AoE-Immolate-applicator (~30s), rotatie op-CD, geen F1-burst (talent)
	["Channel Demonfire"] = { category = "main_rotation", priority = 6, specs = { 267 } }, -- SpellArchetypes [196448] ranged; korte kanaal-CD (~25s), rotatie op-CD, geen F1-burst
	["Dimensional Rift"] = { category = "main_rotation", priority = 7, specs = { 267 } }, -- SpellArchetypes [387976]; korte rotatie-CD (~45s), op-CD-filler, geen F1-burst (talent)
}
