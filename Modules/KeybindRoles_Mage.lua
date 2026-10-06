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
	                                            Ice Lance 30455, Glacial Spike, Arcane Missiles 5143,
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
	["Counterspell"] = { id = 2139, role = "interrupt", priority = 1, survival = "interrupt", survivalOrder = 1 }, -- InterruptAbilities.lua [2139] kind=interrupt pri=1

	-- Movement (Q). Blink = baseline; Shimmer = talent-vervanger (Shift+Q / 2e charge-variant).
	-- Card: one of the two shows (the name lookup dedupes a replaced Blink).
	["Blink"] = { survivalId = { [62] = 1953, [63] = 1953, [64] = 1953 }, role = "utility_primary", priority = 1, survival = "escape", survivalOrder = 1 }, -- SpellCategories UTILITY [1953]; GapCloser
	["Shimmer"] = { id = 212653, role = "utility_primary", priority = 2, survival = "escape", survivalOrder = 2 }, -- SpellCategories UTILITY [212653]; GapCloser (talent)
	-- Ice Floes removed 17 Sep: gone in Midnight (audit, BRON Icy Veins Frost 12.1).

	-- Grote defensive (C). Ice Block = full immunity, baseline alle specs (DEFENSIVE [45438]).
	-- Card: the emergency button, first in "big" but after Alter Time (small) on the card.
	["Ice Block"] = { role = "defensive_3", priority = 1, id = 45438, survival = "big", survivalOrder = 1 }, -- C; baseline
	-- EXPLICIET ID, gemeten 4 aug: de NAAM "Ice Block" lost op naar spell 414658, die Rob
	-- niet heeft -- een naamgenoot wint de lookup. Zijn echte Ice Block is 45438 (tooltip in
	-- zijn talentboom, en DPS_DEFENSIVES gebruikt hetzelfde id). Zonder dit veld viel de
	-- sterkste defensive van de klasse van de overlevingskaart, als "je hebt hem niet".

	-- Extra defensives (category="defensive"; overflow-slots).
	["Alter Time"] = { id = 342245, category = "defensive", priority = 2, survival = "small", survivalOrder = 1 }, -- Frost Shift+Z; DEFENSIVE [342245] (reset HP/pos)
	-- Card: NOT a defensive any more (damage reduction removed in Midnight, audit BRON) -> escape, aggro drop.
	["Greater Invisibility"] = { id = 110959, category = "defensive", priority = 3, survival = "escape", survivalOrder = 4, survivalNote = "SURVIVAL_NOTE_AGGRO" }, -- [110959]; def + threatdrop. GEEN specs-lijst: het is een MAGE-klassentalent, dus alle drie.
	-- Stond hier als specs={62,63}, en drie geinstalleerde bronnen zeggen zelfs Arcane-only
	-- (BliZzi PartyCooldowns spec=MAGE_ARCANE; LibOpenRaid Dragonflight en MIDNIGHT allebei
	-- specs={62}). Rob liet 4 aug zijn talentboom zien op een FROST mage: Greater Invisibility
	-- rank 1/1, in de klassenboom, "Replaces Invisibility". Waarneming wint van drie tabellen.
	-- Die "replaces" is ook waarom SurvivalPlan op IsPlayerSpell filtert: wie deze heeft,
	-- heeft Invisibility [66] NIET, en beide tonen zou een knop noemen die er niet is.

	-- Dispel / CC (V). Frost Nova (root) + Polymorph (CC) baseline; Remove Curse = dispel;
	-- Ring of Frost = AoE-CC; Dragon's Breath = cone-disorient.
	["Frost Nova"] = { id = 122, category = "dispel_cc", priority = 1, survival = "escape", survivalOrder = 3 }, -- CROWD_CONTROL [122]; baseline root
	["Polymorph"] = { id = 118, category = "dispel_cc", priority = 2 }, -- CROWD_CONTROL [118]; baseline CC
	["Remove Curse"] = { id = 475, category = "dispel_cc", priority = 3 }, -- UTILITY [475]; baseline curse-dispel
	["Ring of Frost"] = { id = 113724, category = "dispel_cc", priority = 4 }, -- CROWD_CONTROL [113724]; AoE-CC (talent)

	-- Utility. Spellsteal (F) = enemy-buff-steal; Mirror Image = DPS/utility-clones (NOOIT heal);
	-- Time Warp = raid-haste; Invisibility = OOC-utility/threatdrop; Slow = ranged snare.
	-- ⚠️ PRIORITEIT 6 -> 5, 7 aug 2026. Toen Dragon's Breath's spec-grendel wegging pakte
	-- die `Shift+X` voor Spellsteals neus weg (5 slaat 6) en werd Spellsteal naar een
	-- duimknop geduwd. Rob, die deze klasse speelt: Spellsteal is voor een goede speler
	-- onmisbaar, Dragon's Breath is op Frost bijvangst van de heldenboom. Hij gaat voor.
	["Spellsteal"] = { id = 30449, category = "dispel_cc", priority = 5 }, -- [30449]; offensieve dispel (steelt enemy-buff) -> dispel_cc, geen zuivere utility
	-- Card: off. No damage reduction in Midnight (audit BRON); Arcane's Refractive Images is a talent the card cannot see.
	["Mirror Image"] = { id = 55342, category = "defensive", priority = 5, survival = "small", survivalOrder = 2, survivalRequires = 1309497 }, -- card: alleen MET Refractive Images 1309497 (Method/IV 12.1, 3 okt 2026), elke spec die hem heeft; 4 okt GEMETEN: Rob's Frost heeft hem niet (false) en kreeg Mirror Image toch op de Arcane-kaart -- [55342]; damage-reduction + threatdrop CD/def (BliZzi PartyCooldowns cat=DEF affects=self); functioneel defensive, NOOIT heal/spender
	["Time Warp"] = { id = 80353, category = "utility", priority = 2 }, -- UTILITY [80353]; raid-haste (baseline)
	-- Card: off since 17 Sep (was escape). You fade after 3 s, too slow to get away in a fight (audit TWIJFEL).
	["Invisibility"] = { id = 66, category = "utility", priority = 4 }, -- UTILITY [66]; OOC-utility/threatdrop (baseline)
	["Slow Fall"] = { id = 130, category = "utility", priority = 9 }, -- UTILITY [130]; val-utility, bewust laatste prioriteit (buiten combat)

	--==============================================================================
	-- ARCANE (spec 62) - ranged DPS. Builder = Arcane Blast; spenders = Arcane Barrage /
	-- Arcane Missiles; Arcane Orb = charge-builder; AoE = Arcane Explosion.
	--==============================================================================

	["Arcane Blast"] = { id = 30451, category = "main_rotation", priority = 1, specs = { 62 } }, -- SpellArchetypes [30451] ranged; kern-builder (Arcane Charges)
	["Arcane Orb"] = { id = 153626, category = "main_rotation", priority = 2, specs = { 62 } }, -- charge-builder / AoE-opener
	["Arcane Missiles"] = { id = 5143, category = "main_rotation", priority = 3, specs = { 62 } }, -- [5143] the button (7268 = the hidden damage spell; mh-research 3 Oct 2026); Clearcasting-spender-filler
	["Arcane Barrage"] = { id = 44425, category = "spender", priority = 1, specs = { 62 } }, -- SpellArchetypes [44425] ranged; Arcane-Charge-spender
    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): ["Nether Tempest"] = { category = "main_rotation", priority = 4, specs = { 62 } }, -- SpellArchetypes [114923] ranged; DoT (talent)
	["Supernova"] = { id = 157980, category = "main_rotation", priority = 5, specs = { 62, 63, 64 }, blockAs = { [63] = { category = "dispel_cc", priority = 6 }, [64] = { category = "dispel_cc", priority = 6 } } }, -- SpellArchetypes [157980] ranged; utility-nuke (talent)
	-- ⚠️ SPEC-GRENDEL WEG, 7 aug 2026. Stond op `specs = { 62 }`, maar Arcane Explosion is
	-- een baseline mage-spell: Robs FROST mage kent hem, en de spellbook-scan slaat
	-- off-spec-regels over, dus dat is echt van zijn eigen spec. Met de grendel erop viel
	-- hij bij hem in de "unclassified"-lijst en kreeg hij nooit een toets.
	-- De `bindKey = "Shift+1"` ging mee weg: op Frost zit Frozen Orb daar al, en twee
	-- wensen op dezelfde toets binnen één spec is precies wat lint-controle [11] afvangt.
	-- Zonder wens zoekt hij per spec zelf een vrije rotatie-plek.
	["Arcane Explosion"] = { id = 1449, category = "main_rotation", priority = 6 }, -- SpellArchetypes [1449] melee; baseline PBAoE
	["Prismatic Barrier"] = { id = 235450, role = "defensive_1", priority = 1, specs = { 62 }, survival = "keepup", survivalOrder = 1 }, -- Z; DEFENSIVE [235450] (kleine def, magic-absorb)
	["Arcane Surge"] = { id = 365350, blockQ = { [62] = true }, role = "cooldown_bar", priority = 1, specs = { 62 } }, -- F1; SpellArchetypes [365350]; Arcane grootste burst-CD
	["Touch of the Magi"] = { id = 321507, category = "cooldown", priority = 2, specs = { 62 } }, -- extra CD; burst-window-opener
	["Presence of Mind"] = { id = 205025, category = "utility", priority = 5, specs = { 62 } }, -- guide.lua; instant-cast-CD (geen movement -> utility)
	["Evocation"] = { id = 12051, category = "utility", priority = 6, specs = { 62 } }, -- guide.lua; mana-regen-channel

	--==============================================================================
	-- FIRE (spec 63) - ranged DPS. Builder = Fireball; spender = Pyroblast; Fire Blast =
	-- crit-guarantee; Scorch = execute/move-filler; AoE = Flamestrike.
	--==============================================================================

	["Fireball"] = { id = 133, category = "main_rotation", priority = 1, specs = { 63 } }, -- SpellArchetypes [133] ranged; kern-builder (Heating Up)
	["Fire Blast"] = { id = 108853, category = "main_rotation", priority = 2, specs = { 63 } }, -- SpellArchetypes [13341] ranged; instant crit (Hot Streak)
	["Scorch"] = { id = 2948, category = "main_rotation", priority = 3, specs = { 63 } }, -- SpellArchetypes [2948] ranged; execute/move-filler
	["Pyroblast"] = { id = 11366, category = "spender", priority = 1, specs = { 63 } }, -- SpellArchetypes [11366] ranged; Hot-Streak-spender
	-- Phoenix Flames removed 17 Sep: gone in Midnight (audit, BRON Method Fire intro + Wowhead pre-patch).
    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): ["Living Bomb"] = { category = "main_rotation", priority = 5, specs = { 63 } }, -- SpellArchetypes [44461] ranged; AoE-DoT (talent)
	["Flamestrike"] = { id = 2120, category = "spender", priority = 2, bindKey = "Shift+4", specs = { 63 } }, -- SpellArchetypes [2120] ranged; AoE-Hot-Streak-spender (AoE-slot)
	-- ⚠️ SPEC-GRENDEL WEG, 7 aug 2026 — zelfde reden als Arcane Explosion hierboven. Stond
	-- op 63, maar Robs Frost mage heeft hem (Frostfire-heldenboom) en kreeg dus geen toets.
	["Dragon's Breath"] = { id = 31661, category = "dispel_cc", priority = 6 }, -- InterruptAbilities [31661] kind=cc pri=2; PBAoE-disorient (achter Spellsteal, zie daar)
	["Blazing Barrier"] = { id = 235313, role = "defensive_1", priority = 1, specs = { 63 }, survival = "keepup", survivalOrder = 1 }, -- Z; DEFENSIVE [235313] (kleine def + reflect)
    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): ["Cauterize"] = { id = 86949, category = "defensive", priority = 4, specs = { 63 } }, -- Fire passieve-cheat-death-talent; defensive-overflow. Card: off (passive, not a button)
	["Combustion"] = { id = 190319, blockQ = { [63] = true }, role = "cooldown_bar", priority = 1, specs = { 63 } }, -- F1; Fire grootste burst-CD
	["Meteor"] = { id = 153561, category = "cooldown", priority = 2, specs = { 63 } }, -- guide.lua / SpellArchetypes [351140] ranged; extra CD (talent, ook Frost)

	--==============================================================================
	-- FROST (spec 64) - ranged DPS. LEIDEND uit KeybindingData.lua (frost_mage), toetsen/rollen
	-- exact overgenomen. Builder = Frostbolt; Flurry (Brain Freeze); Ice Lance (Shatter);
	-- Ray of Frost (channel-CD). AoE = Frozen Orb/Blizzard/Cone of Cold op de Shift-laag.
	-- Kleine def Z = Ice Barrier. F1 was Icy Veins (removed 17 Sep); Ray of Frost is now the
	-- big cooldown but stays main_rotation here until the lead moves it (moving it moves binds).
	--==============================================================================

	["Frostbolt"] = { id = 116, category = "main_rotation", priority = 1, specs = { 64 } }, -- KeybindingData "1" [116]; kern-builder (Fingers of Frost / Icicles)
	["Flurry"] = { id = 44614, category = "main_rotation", priority = 2, specs = { 64 } }, -- KeybindingData "2" [44614]; Brain-Freeze-proc, Winter's Chill
	["Ray of Frost"] = { id = 205021, blockQ = { [64] = true }, category = "main_rotation", priority = 3, specs = { 64 } }, -- KeybindingData "3" [205021]; channel-nuke damage-knop (talent) -> main_rotation, geen cooldown
	["Ice Lance"] = { id = 30455, category = "main_rotation", priority = 4, specs = { 64 } }, -- KeybindingData "4" [30455]; Shatter-spender (instant)
	-- Glacial Spike removed 17 Sep: no longer a spell, it changes Frostbolt (audit, BRON Icy Veins Frost 12.1).
	["Frozen Orb"] = { id = 84714, category = "main_rotation", priority = 2, bindKey = "Shift+1", specs = { 64 } }, -- KeybindingData "Shift+1" [84714]; AoE + Fingers-of-Frost-CD (AoE-slot)
	["Blizzard"] = { id = 190356, category = "main_rotation", priority = 5, bindKey = "Shift+2", specs = { 64 } }, -- KeybindingData "Shift+2" [190356]; ground-AoE
	["Cone of Cold"] = { id = 120, category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 64 } }, -- KeybindingData "Shift+3" [120]; PBAoE-frost
	-- Comet Storm removed 17 Sep: no longer a spell, it changes Ray of Frost (audit, BRON Icy Veins Frost 12.1).
	["Ice Barrier"] = { id = 11426, role = "defensive_1", priority = 1, specs = { 64 }, survival = "keepup", survivalOrder = 1 }, -- KeybindingData "Z" [11426]; kleine def (absorb)
	-- Card: after Ice Block — it resets Ice Block/Ice Cold and Ice Barrier (audit BRON Icy Veins Frost).
	-- 17 Sep 2026, GEMETEN in Robs client: C_Spell.GetSpellInfo("Cold Snap") is nil (he has not
	-- talented it, and a name only resolves from your own spellbook), while 235219 answers
	-- "Cold Snap". Without the id the card said "no spell found" for every mage, talented or not.
	["Cold Snap"] = { id = 235219, category = "cooldown", priority = 3, specs = { 64 }, survival = "big", survivalOrder = 2 }, -- KeybindingData "X" [235219]; reset-CD (Ice Block/Barrier/Nova/Cone of Cold) -> cooldown, geen utility
	-- Icy Veins removed 17 Sep: "Icy Veins has been removed, and our main cooldown is now Ray of Frost" (audit, BRON Icy Veins Frost 12.1).

    -- Gap round 5 Oct 2026 (Rob: "ja doe maar"): castable 12.1 spells that had no entry.
    ["Arcane Intellect"] = { id = 1459, category = "utility", priority = 8, specs = { 62, 63, 64 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): baseline SLA 904; SBA step in all 3 specs; Icy Veins 'keep this active'. File header skips
    ["Frostfire Bolt"] = { id = 431044, category = "main_rotation", priority = 1, specs = { 64, 63 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): Frostfire hero n94636: TraitDefinition OverridesSpellID 116 -> takes Frostbolt's button (m
    ["Arcane Pulse"] = { id = 1241462, category = "main_rotation", priority = 6, specs = { 62 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): Arcane node n102439: OverridesSpellID 1449 -> takes Arcane Explosion's button (main_rotati
    ["Ice Cold"] = { id = 414658, role = "defensive_3", priority = 1, specs = { 62, 63, 64 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): class node n62085 (not a choice): replaces Ice Block (aura 332) - same slot as Ice Block; 
    ["Ice Nova"] = { id = 157997, category = "main_rotation", priority = 6, specs = { 64 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): same node; on Frost mirror Cone of Cold (main_rotation 6, bindKey Shift+3)
    ["Mass Invisibility"] = { id = 414664, category = "utility", priority = 7, specs = { 62, 63, 64 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): class node n62092; Wowhead live; Icy Veins class actives
}
