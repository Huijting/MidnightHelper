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

	STAY ALIVE CARD (17 Sep 2026). `survival`, `survivalOrder`, `survivalNote` and `survivalId` feed
	only Modules/SurvivalPlan.lua; the key fields above them are untouched. Every tag follows
	docs/audit_2026-09-17/audit_mage_warlock_priest.md (Method + Icy Veins 12.1).
	Card: keepup = the spec's barrier; small = Alter Time; big = Ice Block/Ice Cold, then Cold Snap
	(Frost: it only helps once Ice Block/Barrier are spent); escape = Blink/Shimmer, Frost Nova,
	Greater Invisibility (aggro drop); interrupt = Counterspell.
	Left OFF the card on purpose: Mirror Image (no damage reduction in Midnight; only Arcane's
	Refractive Images talent brings some back, and the card cannot see that talent), Invisibility
	(3 s delay, poor escape in a fight), Cauterize (passive), Dragon's Breath (crowd control; the
	audit only derives it as an escape).
	Removed 17 Sep, gone in Midnight (audit, BRON Icy Veins Frost 12.1 / Method Fire intro /
	Wowhead pre-patch): Icy Veins (Frost's big cooldown is now Ray of Frost), Ice Floes, Phoenix
	Flames, and Glacial Spike / Comet Storm (no longer spells; they change Frostbolt / Ray of Frost).
	Modules/KeybindingData.lua (frost_mage) dropped the same three on 17 Sep.
]]

ns.KeybindRoleClassifier.MAGE = {

	--==============================================================================
	-- CLASS-BASELINE (geen specs = alle 3 specs: Arcane 62 / Fire 63 / Frost 64)
	--==============================================================================

	-- Interrupt (E). Counterspell = enige mage-interrupt (InterruptAbilities [2139]).
	["Counterspell"] = { role = "interrupt", priority = 1, survival = "interrupt", survivalOrder = 1 }, -- InterruptAbilities.lua [2139] kind=interrupt pri=1

	-- Movement (Q). Blink = baseline; Shimmer = talent-vervanger (Shift+Q / 2e charge-variant).
	-- Card: one of the two shows (the name lookup dedupes a replaced Blink).
	["Blink"] = { role = "utility_primary", priority = 1, survival = "escape", survivalOrder = 1 }, -- SpellCategories UTILITY [1953]; GapCloser
	["Shimmer"] = { role = "utility_primary", priority = 2, survival = "escape", survivalOrder = 2 }, -- SpellCategories UTILITY [212653]; GapCloser (talent)
	-- Ice Floes removed 17 Sep: gone in Midnight (audit, BRON Icy Veins Frost 12.1).

	-- Grote defensive (C). Ice Block = full immunity, baseline alle specs (DEFENSIVE [45438]).
	-- Card: the emergency button, first in "big" but after Alter Time (small) on the card.
	["Ice Block"] = { role = "defensive_3", priority = 1, id = 45438, survival = "big", survivalOrder = 1 }, -- C; baseline
	-- EXPLICIET ID, gemeten 4 aug: de NAAM "Ice Block" lost op naar spell 414658, die Rob
	-- niet heeft -- een naamgenoot wint de lookup. Zijn echte Ice Block is 45438 (tooltip in
	-- zijn talentboom, en DPS_DEFENSIVES gebruikt hetzelfde id). Zonder dit veld viel de
	-- sterkste defensive van de klasse van de overlevingskaart, als "je hebt hem niet".

	-- Extra defensives (category="defensive"; overflow-slots).
	["Alter Time"] = { category = "defensive", priority = 2, survival = "small", survivalOrder = 1 }, -- Frost Shift+Z; DEFENSIVE [342245] (reset HP/pos)
	-- Card: NOT a defensive any more (damage reduction removed in Midnight, audit BRON) -> escape, aggro drop.
	["Greater Invisibility"] = { category = "defensive", priority = 3, survival = "escape", survivalOrder = 4, survivalNote = "SURVIVAL_NOTE_AGGRO" }, -- [110959]; def + threatdrop. GEEN specs-lijst: het is een MAGE-klassentalent, dus alle drie.
	-- Stond hier als specs={62,63}, en drie geinstalleerde bronnen zeggen zelfs Arcane-only
	-- (BliZzi PartyCooldowns spec=MAGE_ARCANE; LibOpenRaid Dragonflight en MIDNIGHT allebei
	-- specs={62}). Rob liet 4 aug zijn talentboom zien op een FROST mage: Greater Invisibility
	-- rank 1/1, in de klassenboom, "Replaces Invisibility". Waarneming wint van drie tabellen.
	-- Die "replaces" is ook waarom SurvivalPlan op IsPlayerSpell filtert: wie deze heeft,
	-- heeft Invisibility [66] NIET, en beide tonen zou een knop noemen die er niet is.

	-- Dispel / CC (V). Frost Nova (root) + Polymorph (CC) baseline; Remove Curse = dispel;
	-- Ring of Frost = AoE-CC; Dragon's Breath = cone-disorient.
	["Frost Nova"] = { category = "dispel_cc", priority = 1, survival = "escape", survivalOrder = 3 }, -- CROWD_CONTROL [122]; baseline root
	["Polymorph"] = { category = "dispel_cc", priority = 2 }, -- CROWD_CONTROL [118]; baseline CC
	["Remove Curse"] = { category = "dispel_cc", priority = 3 }, -- UTILITY [475]; baseline curse-dispel
	["Ring of Frost"] = { category = "dispel_cc", priority = 4 }, -- CROWD_CONTROL [113724]; AoE-CC (talent)

	-- Utility. Spellsteal (F) = enemy-buff-steal; Mirror Image = DPS/utility-clones (NOOIT heal);
	-- Time Warp = raid-haste; Invisibility = OOC-utility/threatdrop; Slow = ranged snare.
	-- ⚠️ PRIORITEIT 6 -> 5, 7 aug 2026. Toen Dragon's Breath's spec-grendel wegging pakte
	-- die `Shift+X` voor Spellsteals neus weg (5 slaat 6) en werd Spellsteal naar een
	-- duimknop geduwd. Rob, die deze klasse speelt: Spellsteal is voor een goede speler
	-- onmisbaar, Dragon's Breath is op Frost bijvangst van de heldenboom. Hij gaat voor.
	["Spellsteal"] = { category = "dispel_cc", priority = 5 }, -- [30449]; offensieve dispel (steelt enemy-buff) -> dispel_cc, geen zuivere utility
	-- Card: off. No damage reduction in Midnight (audit BRON); Arcane's Refractive Images is a talent the card cannot see.
	["Mirror Image"] = { category = "defensive", priority = 5 }, -- [55342]; damage-reduction + threatdrop CD/def (BliZzi PartyCooldowns cat=DEF affects=self); functioneel defensive, NOOIT heal/spender
	["Time Warp"] = { category = "utility", priority = 2 }, -- UTILITY [80353]; raid-haste (baseline)
	-- Card: off since 17 Sep (was escape). You fade after 3 s, too slow to get away in a fight (audit TWIJFEL).
	["Invisibility"] = { category = "utility", priority = 4 }, -- UTILITY [66]; OOC-utility/threatdrop (baseline)
	["Slow Fall"] = { category = "utility", priority = 9 }, -- UTILITY [130]; val-utility, bewust laatste prioriteit (buiten combat)

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
	-- ⚠️ SPEC-GRENDEL WEG, 7 aug 2026. Stond op `specs = { 62 }`, maar Arcane Explosion is
	-- een baseline mage-spell: Robs FROST mage kent hem, en de spellbook-scan slaat
	-- off-spec-regels over, dus dat is echt van zijn eigen spec. Met de grendel erop viel
	-- hij bij hem in de "unclassified"-lijst en kreeg hij nooit een toets.
	-- De `bindKey = "Shift+1"` ging mee weg: op Frost zit Frozen Orb daar al, en twee
	-- wensen op dezelfde toets binnen één spec is precies wat lint-controle [11] afvangt.
	-- Zonder wens zoekt hij per spec zelf een vrije rotatie-plek.
	["Arcane Explosion"] = { category = "main_rotation", priority = 6 }, -- SpellArchetypes [1449] melee; baseline PBAoE
	["Prismatic Barrier"] = { role = "defensive_1", priority = 1, specs = { 62 }, survival = "keepup", survivalOrder = 1 }, -- Z; DEFENSIVE [235450] (kleine def, magic-absorb)
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
	-- Phoenix Flames removed 17 Sep: gone in Midnight (audit, BRON Method Fire intro + Wowhead pre-patch).
	["Living Bomb"] = { category = "main_rotation", priority = 5, specs = { 63 } }, -- SpellArchetypes [44461] ranged; AoE-DoT (talent)
	["Flamestrike"] = { category = "spender", priority = 2, bindKey = "Shift+4", specs = { 63 } }, -- SpellArchetypes [2120] ranged; AoE-Hot-Streak-spender (AoE-slot)
	-- ⚠️ SPEC-GRENDEL WEG, 7 aug 2026 — zelfde reden als Arcane Explosion hierboven. Stond
	-- op 63, maar Robs Frost mage heeft hem (Frostfire-heldenboom) en kreeg dus geen toets.
	["Dragon's Breath"] = { category = "dispel_cc", priority = 6 }, -- InterruptAbilities [31661] kind=cc pri=2; PBAoE-disorient (achter Spellsteal, zie daar)
	["Blazing Barrier"] = { role = "defensive_1", priority = 1, specs = { 63 }, survival = "keepup", survivalOrder = 1 }, -- Z; DEFENSIVE [235313] (kleine def + reflect)
	["Cauterize"] = { category = "defensive", priority = 4, specs = { 63 } }, -- Fire passieve-cheat-death-talent; defensive-overflow. Card: off (passive, not a button)
	["Combustion"] = { role = "cooldown_bar", priority = 1, specs = { 63 } }, -- F1; Fire grootste burst-CD
	["Meteor"] = { category = "cooldown", priority = 2, specs = { 63 } }, -- guide.lua / SpellArchetypes [351140] ranged; extra CD (talent, ook Frost)

	--==============================================================================
	-- FROST (spec 64) - ranged DPS. LEIDEND uit KeybindingData.lua (frost_mage), toetsen/rollen
	-- exact overgenomen. Builder = Frostbolt; Flurry (Brain Freeze); Ice Lance (Shatter);
	-- Ray of Frost (channel-CD). AoE = Frozen Orb/Blizzard/Cone of Cold op de Shift-laag.
	-- Kleine def Z = Ice Barrier. F1 was Icy Veins (removed 17 Sep); Ray of Frost is now the
	-- big cooldown but stays main_rotation here until the lead moves it (moving it moves binds).
	--==============================================================================

	["Frostbolt"] = { category = "main_rotation", priority = 1, specs = { 64 } }, -- KeybindingData "1" [116]; kern-builder (Fingers of Frost / Icicles)
	["Flurry"] = { category = "main_rotation", priority = 2, specs = { 64 } }, -- KeybindingData "2" [44614]; Brain-Freeze-proc, Winter's Chill
	["Ray of Frost"] = { category = "main_rotation", priority = 3, specs = { 64 } }, -- KeybindingData "3" [205021]; channel-nuke damage-knop (talent) -> main_rotation, geen cooldown
	["Ice Lance"] = { category = "main_rotation", priority = 4, specs = { 64 } }, -- KeybindingData "4" [30455]; Shatter-spender (instant)
	-- Glacial Spike removed 17 Sep: no longer a spell, it changes Frostbolt (audit, BRON Icy Veins Frost 12.1).
	["Frozen Orb"] = { category = "main_rotation", priority = 2, bindKey = "Shift+1", specs = { 64 } }, -- KeybindingData "Shift+1" [84714]; AoE + Fingers-of-Frost-CD (AoE-slot)
	["Blizzard"] = { category = "main_rotation", priority = 5, bindKey = "Shift+2", specs = { 64 } }, -- KeybindingData "Shift+2" [190356]; ground-AoE
	["Cone of Cold"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 64 } }, -- KeybindingData "Shift+3" [120]; PBAoE-frost
	-- Comet Storm removed 17 Sep: no longer a spell, it changes Ray of Frost (audit, BRON Icy Veins Frost 12.1).
	["Ice Barrier"] = { role = "defensive_1", priority = 1, specs = { 64 }, survival = "keepup", survivalOrder = 1 }, -- KeybindingData "Z" [11426]; kleine def (absorb)
	-- Card: after Ice Block — it resets Ice Block/Ice Cold and Ice Barrier (audit BRON Icy Veins Frost).
	-- 17 Sep 2026, GEMETEN in Robs client: C_Spell.GetSpellInfo("Cold Snap") is nil (he has not
	-- talented it, and a name only resolves from your own spellbook), while 235219 answers
	-- "Cold Snap". Without the id the card said "no spell found" for every mage, talented or not.
	["Cold Snap"] = { id = 235219, category = "cooldown", priority = 3, specs = { 64 }, survival = "big", survivalOrder = 2 }, -- KeybindingData "X" [235219]; reset-CD (Ice Block/Barrier/Nova/Cone of Cold) -> cooldown, geen utility
	-- Icy Veins removed 17 Sep: "Icy Veins has been removed, and our main cooldown is now Ray of Frost" (audit, BRON Icy Veins Frost 12.1).
}
