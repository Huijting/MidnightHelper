local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

--[[
	Naam->rol-classifier voor MAGE (WoW Midnight, addon Midnight Helper, v6-keybind-standaard).
	VERVANGT de oude incomplete draft-versie (ns.KeybindRoleClassifier.MAGE in
	Modules/KeybindRoles_PriestWarlockMage.lua, dekte alleen Arcane/Fire deels). Deze module is
	de complete, autoritatieve bron voor Mage; laadt na de gedeelde module en overschrijft MAGE
	volledig.

	NEVER-LIE. Rollen zijn AFGELEID uit addon-data onder Interface\AddOns\, niet gegokt:
	  - MidnightHelper\Modules\KeybindingData.lua (blok frost_mage) -> LEIDEND voor Frost (64):
	    toetsen/rollen exact overgenomen (interrupt E, movement Q, kleine def Z=Ice Barrier,
	    grote def C=Ice Block, dispel/CC V=Frost Nova + Shift+V=Remove Curse, Shift+Z=Alter Time,
	    F1=Icy Veins, F=Spellsteal, R=Mirror Image, AoE op Shift-laag).
	  - JustAC\Data\InterruptAbilities.lua   -> Counterspell [2139] kind=interrupt pri=1;
	                                            Dragon's Breath [31661] kind=cc pri=2.
	  - JustAC\Data\SpellCategories.lua      -> DEFENSIVE: Ice Block [45438], Ice Barrier [11426],
	                                            Blazing Barrier [235313], Prismatic Barrier [235450],
	                                            Alter Time [342245], Greater Invisibility [110959].
	                                            CROWD_CONTROL: Polymorph [118], Frost Nova [122],
	                                            Ring of Frost [113724], Dragon's Breath [31661].
	                                            UTILITY: Invisibility [66], Time Warp [80353],
	                                            Spellsteal [30449], Remove Curse [475],
	                                            Ice Floes [108839], Blink [1953], Shimmer [212653].
	                                            Mirror Image [55342] = expliciet GEMARKEERD als
	                                            DPS-cooldown, NIET defensive (nooit als heal).
	  - JustAC\Data\SpellArchetypes.lua      -> damage-builders/spenders per spec (Frostbolt 116,
	                                            Fireball 133, Arcane Blast 30451, Pyroblast 11366,
	                                            Ice Lance 30455, Glacial Spike, Arcane Missiles 7268,
	                                            Arcane Barrage 44425, Nether Tempest 114923,
	                                            Supernova 157980, Living Bomb 44461, Phoenix Flames
	                                            257542, Blizzard 190357, Frozen Orb 84721, etc.).
	  - JustAC\DefensiveEngine.lua / GapCloserEngine.lua -> defensieve resp. movement-engine
	                                            (Ice Barrier/Blazing/Prismatic/Ice Block/Alter Time
	                                            resp. Blink/Shimmer/Ice Floes).
	  - ClassCodex\Data\Mage\guide.lua       -> spec-rotatie-context (Frostfire hero, Scorch,
	                                            Presence of Mind, Evocation, Meteor).
	  - docs\KEYBIND_MAP_DRAFT_priest_warlock_mage.md -> cross-ref.

	Mage heeft GEEN dedicated self-heal -> heal_quick (F2) en heal_ooc (F3) blijven LEEG (niet
	geforceerd). Mirror Image is NOOIT een heal.

	Sleutel = EXACTE spell-NAAM; de addon matcht dit tegen de live spellbook. `specs={id}` maakt
	een entry spec-specifiek; geen `specs` = class-baseline (op alle 3 specs beschikbaar).
	Baseline (alle 3 specs): Counterspell, Blink, Ice Block, Frost Nova, Polymorph, Remove Curse,
	Spellsteal, Mirror Image, Time Warp, Invisibility.
	specID's: Arcane=62, Fire=63, Frost=64.

	Rol-vocab (roles): interrupt, utility_primary, utility_secondary, mobility, defensive_1,
	defensive_2, defensive_3, defensive_4, cooldown_bar, heal_quick, heal_ooc.
	Categorie-vocab (categories): main_rotation, spender, utility, dispel_cc, cooldown, defensive.

	Slots (v6): interrupt=E, movement=Q, kleine def=Z, grote def=C, dispel/CC=V, grootste CD=F1,
	heal_quick=F2, heal_ooc=F3, AoE=Shift+N. NIET opgenomen: Recuperate (F4/heal_sustain), racial,
	trinket, potion, buffs (Arcane Intellect) en zuivere passieven.
]]

ns.KeybindRoleClassifier.MAGE = {

	--==============================================================================
	-- CLASS-BASELINE (geen specs = alle 3 specs: Arcane 62 / Fire 63 / Frost 64)
	--==============================================================================

	-- Interrupt (E). Counterspell = enige mage-interrupt (InterruptAbilities [2139]).
	["Counterspell"] = { role = "interrupt", priority = 1 }, -- InterruptAbilities.lua [2139] kind=interrupt pri=1

	-- Movement (Q). Blink = baseline; Shimmer = talent-vervanger (Shift+Q / 2e charge-variant).
	["Blink"] = { role = "utility_primary", priority = 1 }, -- SpellCategories UTILITY [1953]; GapCloser
	["Shimmer"] = { role = "utility_primary", priority = 2 }, -- SpellCategories UTILITY [212653]; GapCloser (talent)
	["Ice Floes"] = { role = "utility_secondary", priority = 2 }, -- SpellCategories UTILITY [108839]; cast-while-moving (talent)

	-- Grote defensive (C). Ice Block = full immunity, baseline alle specs (DEFENSIVE [45438]).
	["Ice Block"] = { role = "defensive_3", priority = 1 }, -- C; baseline (45438)

	-- Extra defensives (category="defensive"; overflow-slots).
	["Alter Time"] = { category = "defensive", priority = 2 }, -- Frost Shift+Z; DEFENSIVE [342245] (reset HP/pos)
	["Greater Invisibility"] = { category = "defensive", priority = 3, specs = { 62, 63 } }, -- DEFENSIVE [110959] (Arcane/Fire; def+threatdrop)

	-- Dispel / CC (V). Frost Nova (root) + Polymorph (CC) baseline; Remove Curse = dispel;
	-- Ring of Frost = AoE-CC. Dragon's Breath (Fire) staat spec-specifiek onder Fire.
	["Frost Nova"] = { category = "dispel_cc", priority = 1 }, -- CROWD_CONTROL [122]; baseline root
	["Polymorph"] = { category = "dispel_cc", priority = 2 }, -- CROWD_CONTROL [118]; baseline CC
	["Remove Curse"] = { category = "dispel_cc", priority = 3 }, -- UTILITY [475]; baseline curse-dispel
	["Ring of Frost"] = { category = "dispel_cc", priority = 4 }, -- CROWD_CONTROL [113724]; AoE-CC (talent)

	-- Utility. Spellsteal (F) = enemy-buff-steal; Mirror Image = DPS/utility-clones (NOOIT heal);
	-- Time Warp = raid-haste; Invisibility = OOC-utility/threatdrop; Slow = ranged snare.
	["Spellsteal"] = { category = "dispel_cc", priority = 6 }, -- [30449]; offensieve dispel (steelt enemy-buff) -> dispel_cc, geen zuivere utility
	["Mirror Image"] = { category = "defensive", priority = 5 }, -- [55342]; damage-reduction + threatdrop CD/def (BliZzi PartyCooldowns cat=DEF affects=self); functioneel defensive, NOOIT heal/spender
	["Time Warp"] = { category = "utility", priority = 2 }, -- UTILITY [80353]; raid-haste (baseline)
	["Invisibility"] = { category = "utility", priority = 4 }, -- UTILITY [66]; OOC-utility/threatdrop (baseline)

	--==============================================================================
	-- ARCANE (spec 62) - ranged DPS. Builder = Arcane Blast; spenders = Arcane Barrage /
	-- Arcane Missiles; Arcane Orb = charge-builder; AoE = Arcane Explosion.
	--==============================================================================

	["Arcane Blast"] = { category = "main_rotation", priority = 1, specs = { 62 } }, -- SpellArchetypes [30451] ranged; kern-builder (Arcane Charges)
	["Arcane Orb"] = { category = "main_rotation", priority = 2, specs = { 62 } }, -- charge-builder / AoE-opener
	["Arcane Missiles"] = { category = "main_rotation", priority = 3, specs = { 62 } }, -- SpellArchetypes [7268] ranged; Clearcasting-spender-filler
	["Arcane Barrage"] = { category = "spender", priority = 1, specs = { 62 } }, -- SpellArchetypes [44425] ranged; Arcane-Charge-spender
	["Nether Tempest"] = { category = "main_rotation", priority = 4, specs = { 62 } }, -- SpellArchetypes [114923] ranged; DoT (talent)
	["Supernova"] = { category = "main_rotation", priority = 5, specs = { 62 } }, -- SpellArchetypes [157980] ranged; utility-nuke (talent)
	["Arcane Explosion"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 62 } }, -- SpellArchetypes [1449] melee; AoE-slot
	["Prismatic Barrier"] = { role = "defensive_1", priority = 1, specs = { 62 } }, -- Z; DEFENSIVE [235450] (kleine def, magic-absorb)
	["Arcane Surge"] = { role = "cooldown_bar", priority = 1, specs = { 62 } }, -- F1; SpellArchetypes [365350]; Arcane grootste burst-CD
	["Touch of the Magi"] = { category = "cooldown", priority = 2, specs = { 62 } }, -- extra CD; burst-window-opener
	["Presence of Mind"] = { category = "utility", priority = 5, specs = { 62 } }, -- guide.lua; instant-cast-CD (geen movement -> utility)
	["Evocation"] = { category = "utility", priority = 6, specs = { 62 } }, -- guide.lua; mana-regen-channel

	--==============================================================================
	-- FIRE (spec 63) - ranged DPS. Builder = Fireball; spender = Pyroblast; Fire Blast =
	-- crit-guarantee; Scorch = execute/move-filler; AoE = Flamestrike.
	--==============================================================================

	["Fireball"] = { category = "main_rotation", priority = 1, specs = { 63 } }, -- SpellArchetypes [133] ranged; kern-builder (Heating Up)
	["Fire Blast"] = { category = "main_rotation", priority = 2, specs = { 63 } }, -- SpellArchetypes [13341] ranged; instant crit (Hot Streak)
	["Scorch"] = { category = "main_rotation", priority = 3, specs = { 63 } }, -- SpellArchetypes [2948] ranged; execute/move-filler
	["Pyroblast"] = { category = "spender", priority = 1, specs = { 63 } }, -- SpellArchetypes [11366] ranged; Hot-Streak-spender
	["Phoenix Flames"] = { category = "main_rotation", priority = 4, specs = { 63 } }, -- SpellArchetypes [257542] ranged; charge-builder/cleave
	["Living Bomb"] = { category = "main_rotation", priority = 5, specs = { 63 } }, -- SpellArchetypes [44461] ranged; AoE-DoT (talent)
	["Flamestrike"] = { category = "spender", priority = 2, bindKey = "Shift+4", specs = { 63 } }, -- SpellArchetypes [2120] ranged; AoE-Hot-Streak-spender (AoE-slot)
	["Dragon's Breath"] = { category = "dispel_cc", priority = 5, specs = { 63 } }, -- InterruptAbilities [31661] kind=cc pri=2; PBAoE-disorient (Fire)
	["Blazing Barrier"] = { role = "defensive_1", priority = 1, specs = { 63 } }, -- Z; DEFENSIVE [235313] (kleine def + reflect)
	["Cauterize"] = { category = "defensive", priority = 4, specs = { 63 } }, -- Fire passieve-cheat-death-talent; defensive-overflow
	["Combustion"] = { role = "cooldown_bar", priority = 1, specs = { 63 } }, -- F1; Fire grootste burst-CD
	["Meteor"] = { category = "cooldown", priority = 2, specs = { 63 } }, -- guide.lua / SpellArchetypes [351140] ranged; extra CD (talent, ook Frost)

	--==============================================================================
	-- FROST (spec 64) - ranged DPS. LEIDEND uit KeybindingData.lua (frost_mage), toetsen/rollen
	-- exact overgenomen. Builder = Frostbolt; Flurry (Brain Freeze); Ice Lance (Shatter);
	-- Ray of Frost (channel-CD); Glacial Spike (finisher). AoE = Frozen Orb/Blizzard/Cone of
	-- Cold/Comet Storm op de Shift-laag. Kleine def Z = Ice Barrier. F1 = Icy Veins.
	--==============================================================================

	["Frostbolt"] = { category = "main_rotation", priority = 1, specs = { 64 } }, -- KeybindingData "1" [116]; kern-builder (Fingers of Frost / Icicles)
	["Flurry"] = { category = "main_rotation", priority = 2, specs = { 64 } }, -- KeybindingData "2" [44614]; Brain-Freeze-proc, Winter's Chill
	["Ray of Frost"] = { category = "main_rotation", priority = 3, specs = { 64 } }, -- KeybindingData "3" [205021]; channel-nuke damage-knop (talent) -> main_rotation, geen cooldown
	["Ice Lance"] = { category = "main_rotation", priority = 4, specs = { 64 } }, -- KeybindingData "4" [30455]; Shatter-spender (instant)
	["Glacial Spike"] = { category = "spender", priority = 1, specs = { 64 } }, -- KeybindingData "5" [199786]; Icicle-finisher (talent)
	["Frozen Orb"] = { category = "main_rotation", priority = 2, bindKey = "Shift+1", specs = { 64 } }, -- KeybindingData "Shift+1" [84714]; AoE + Fingers-of-Frost-CD (AoE-slot)
	["Blizzard"] = { category = "main_rotation", priority = 5, bindKey = "Shift+2", specs = { 64 } }, -- KeybindingData "Shift+2" [190356]; ground-AoE
	["Cone of Cold"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 64 } }, -- KeybindingData "Shift+3" [120]; PBAoE-frost
	["Comet Storm"] = { category = "spender", priority = 2, bindKey = "Shift+4", specs = { 64 } }, -- KeybindingData "Shift+4" [153595]; AoE-spender (talent)
	["Ice Barrier"] = { role = "defensive_1", priority = 1, specs = { 64 } }, -- KeybindingData "Z" [11426]; kleine def (absorb)
	["Cold Snap"] = { category = "cooldown", priority = 3, specs = { 64 } }, -- KeybindingData "X" [235219]; reset-CD (Ice Block/Barrier/Nova/Cone of Cold) -> cooldown, geen utility
	["Icy Veins"] = { role = "cooldown_bar", priority = 1, specs = { 64 } }, -- KeybindingData "F1" [12472]; Frost grootste burst-CD
}
