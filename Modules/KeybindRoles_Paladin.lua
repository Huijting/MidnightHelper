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

	STAY ALIVE CARD (17 Sep 2026). `survival`, `survivalOrder`, `survivalNote` and `survivalId` feed
	only Modules/SurvivalPlan.lua; the key fields above them are untouched. Every tag follows
	docs/audit_2026-09-17/audit_paladin_warrior_dk.md (Icy Veins 12.1 + wago.tools 12.1.0.69814).
	Left OFF the card on purpose: Blessing of Sacrifice (ally only, the damage lands on you), Holy
	Bulwark (a toggle with Sacred Weapon), Guardian of Ancient Kings on Ret/Holy (Prot only).
	Removed 17 Sep, gone from the 12.1 trees (W-TREE): Shield of Vengeance (now cast by Divine
	Protection), Tyr's Deliverance and Avenging Crusader (passive changes to Avenging Wrath),
	Bestow Faith, Light's Hammer, Barrier of Faith, Bastion of Light.
]]

ns.KeybindRoleClassifier.PALADIN = {

	--==============================================================================
	-- CLASS-BASELINE (geen specs = alle 3 specs: Holy 65 / Prot 66 / Ret 70)
	--==============================================================================

	-- Interrupt (E). Rebuke is spellbook-baseline; BliZzi assigneert 'm actief aan Prot/Ret,
	-- Holy noKick, maar de spell is leerbaar door alle Paladins -> baseline.
	-- specs since 5 Oct 2026: Holy lost Rebuke in Midnight (Method 12.1 Holy talents; Blizzard alpha note,
	-- via mh-research). In the game it never matched for Holy anyway; this keeps the site's standard block
	-- (tools/keyblock_specs.lua, which assumes every listed spell is known) from showing it on E.
	["Rebuke"] = { id = 96231, role = "interrupt", priority = 1, specs = { 66, 70 }, survival = "interrupt", survivalOrder = 1 }, -- InterruptAbilities.lua [96231] kind=interrupt pri=1

	-- Movement (Q). Divine Steed = enige class-brede mobility (SpellCategories UTILITY [190784]).
	["Divine Steed"] = { id = 190784, role = "utility_primary", priority = 1, survival = "escape", survivalOrder = 1 }, -- Q; baseline movement

	-- Kleine defensive (Z). Divine Shield = persoonlijke immunity (SpellCategories DEFENSIVE [642]).
	-- Card: 8 s immunity on a 5 min cooldown with Forbearance — the LAST big button, not a keep-up.
	["Divine Shield"] = { id = 642, role = "defensive_1", priority = 1, survival = "big", survivalOrder = 5, survivalNote = { [65] = "SURVIVAL_NOTE_FORBEARANCE", [66] = "SURVIVAL_NOTE_FORBEARANCE_TANK", [70] = "SURVIVAL_NOTE_FORBEARANCE" } }, -- Z; baseline (642). Prot: + "enemies leave you" (newcomer re-read 3, T2; Method/Icy Veins in FACTS4)

	-- Grote defensive (C). Guardian of Ancient Kings (SpellCategories DEFENSIVE [86659]). Prot only (W-TREE 790).
	["Guardian of Ancient Kings"] = { id = 86659, role = "defensive_3", priority = 1, specs = { 66 }, survival = "big", survivalOrder = 1 }, -- C; Prot (86659)

	-- Extra defensives (category="defensive"; overflow-slots). Allen SpellCategories DEFENSIVE.
	-- Divine Protection: 403876 is the Ret spell, Holy owns 498 (W-SPEC); the card asks per spec.
	-- 3 Oct 2026: not Prot. Protection has no Divine Protection in 12.1 (absent from Icy Veins' full
	-- 12.1 spell list, positive control Crusader Strike on the same page; play-card audit 3 Oct).
	["Divine Protection"] = { id = 403876, category = "defensive", priority = 2, specs = { 65, 70 }, survival = "small", survivalOrder = 1, survivalId = { [65] = 498 } }, -- DEFENSIVE [403876] (kleine DR)
	["Blessing of Protection"] = { id = 1022, category = "defensive", priority = 3, survival = "big", survivalOrder = 4, survivalNote = { [65] = "SURVIVAL_NOTE_PHYSICAL", [66] = "SURVIVAL_NOTE_PHYSICAL_TANK", [70] = "SURVIVAL_NOTE_PHYSICAL" } }, -- DEFENSIVE [1022] (fysieke immunity, op ally/self). Prot: the Group tab says "not on a tank" — one answer now (re-read 3, T2)
	["Blessing of Sacrifice"] = { id = 6940, category = "defensive", priority = 4 }, -- DEFENSIVE [6940] (external DR-transfer); NOT on the card: ally only
	["Blessing of Spellwarding"] = { id = 204018, category = "defensive", priority = 5, survivalSpecs = { 66 }, survival = "big", survivalOrder = 3, survivalNote = "SURVIVAL_NOTE_MAGIC", specs = { 66 } }, -- DEFENSIVE [204018] (magic immunity, talent)

	-- Dispel / CC (V). Cleanse=dispel; Hammer of Justice/Blinding Light/Repentance=CC/stun.
	["Cleanse"] = { id = 4987, category = "dispel_cc", priority = 1, specs = { 65 } }, -- SpellCategories HEALING [4987] (poison/disease/magic dispel)
	["Cleanse Toxins"] = { id = 213644, category = "dispel_cc", priority = 2 }, -- SpellCategories UTILITY [213644] (Prot/Ret dispel-variant)
	["Hammer of Justice"] = { id = 853, category = "dispel_cc", priority = 3, alsoStop = "stun" }, -- CROWD_CONTROL [853]; JustAC InterruptAbilities [853] kind=cc mech=12 (stun-interrupt) → Spec 08 alsoStop
	["Blinding Light"] = { id = 115750, category = "dispel_cc", priority = 4 }, -- CROWD_CONTROL [115750] (AoE disorient; castbare id per JustAC SpellCooldowns/SpellCategories, 105421 = effect)
    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): ["Repentance"] = { id = 20066, category = "dispel_cc", priority = 5 }, -- CROWD_CONTROL [20066] (incapacitate, talent)
	["Turn Evil"] = { id = 10326, category = "dispel_cc", priority = 6 }, -- CROWD_CONTROL [10326] (fear undead/demon)
	["Blessing of Freedom"] = { id = 1044, category = "dispel_cc", priority = 7 }, -- UTILITY [1044] (root/snare-cleanse op ally/self)

	-- Self-heals (F2 = heal_quick snelle combat-heal; F3 = heal_ooc out-of-combat).
	-- Word of Glory = instant Holy-Power-noodheal, baseline alle specs (SpellCategories HEALING [85673]).
	["Word of Glory"] = { id = 85673, role = "heal_quick", priority = 1, blockAs = { [65] = { category = "spender", priority = 1, bindKey = "4" } }, survival = "heal", survivalOrder = 1, survivalNote = { [66] = "SURVIVAL_NOTE_WOG_PROT" } }, -- F2; baseline (85673) instant self-heal. Prot note 3 Oct 2026: same Holy Power as Shield of the Righteous; free with Shining Light (Icy Veins "Active Mitigation", 21 Sep; Method 3 Sep)
	-- Lay on Hands = full heal on a 10 min cooldown with Forbearance (W-CD 600) — after Word of Glory.
	["Lay on Hands"] = { id = 633, role = "heal_ooc", priority = 1, survival = "heal", survivalOrder = 2, survivalNote = "SURVIVAL_NOTE_LAST_RESORT" }, -- F3; baseline (633)

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
	-- 5 Oct 2026 (Rob: healers DPS too, "ik volg jouw advies"): Holy Shock is heal OR damage (IV Holy 12.1),
	-- so it leaves click-cast and takes the main button. Talent over Crusader Strike 35395 (wago
	-- TraitDefinition 107539, build 12.1.5.70077, via mh-research): the book may report 35395, so the name
	-- matches too. bindKey "1" so a tie with Judgment never decides by spellbook order.
	["Holy Shock"] = { id = 20473, category = "main_rotation", priority = 1, bindKey = "1", specs = { 65 } },
	-- Holy's own Shield of the Righteous (wago SpecializationSpells: spec 65, overrides 53600): a damage
	-- Holy Power spender for Holy, active mitigation for Prot (that entry is below). Matches ONLY by id.
	["Shield of the Righteous (Holy)"] = { id = 415091, category = "spender", priority = 3, specs = { 65 } },
	["Flash of Light"] = { id = 19750, category = "main_rotation", priority = 1, bindKey = "2", specs = { 65, 66, 70 }, blockAs = { [66] = { role = "heal_ooc", priority = 2 }, [70] = { role = "heal_ooc", priority = 2 } } }, -- HEALING [19750]; snelle ST-heal (instant bij Infusion of Light)
	["Holy Light"] = { id = 82326, category = "main_rotation", priority = 1, bindKey = "3", specs = { 65 } }, -- HEALING [82326]; grote (dure) ST-filler-heal
	-- Beacons = buff-op-target (kies doelwit) -> ook click_cast/mouseover.
	["Beacon of Light"] = { id = 53563, category = "raid_heal", priority = 1, bindKey = "Shift+1", specs = { 65 } }, -- HEALING [53563]; beacon-plaatsing op target
	["Beacon of Faith"] = { id = 156910, category = "utility", priority = 1, specs = { 65 } }, -- HEALING [156910]; tweede beacon-op-target (talent)
	-- Raid/AoE-heals BLIJVEN op toetsen.
	["Light of Dawn"] = { id = 85222, category = "raid_heal", priority = 1, bindKey = "Shift+4", specs = { 65 } }, -- HEALING [85222]; AoE-heal-spender (AoE-slot)
	["Holy Prism"] = { id = 114165, category = "cooldown", priority = 3, specs = { 65 } }, -- HEALING [114165]; AoE-heal/damage
	["Beacon of Virtue"] = { id = 200025, excludes = "Beacon of Light", category = "raid_heal", priority = 1, bindKey = "Shift+1", specs = { 65 } }, -- HEALING [200025]; multi-beacon-AoE (talent)
	-- Heal-cooldowns: grootste = cooldown_bar, rest category="cooldown".
	["Divine Toll"] = { id = 375576, category = "cooldown", priority = 2, specs = { 65, 66, 70 } }, -- [375576] instant Holy-Power-burst; baseline-CD op alle 3 specs (Holy heal / Prot / Ret). Eén entry: dubbele-key zou anders 2 specs verliezen.
	["Aura Mastery"] = { id = 31821, category = "cooldown", priority = 4, specs = { 65 } }, -- HEALING [31821]; raid-defensive-CD (F1-familie)

	--==============================================================================
	-- PROTECTION (spec 66) - tank.
	--==============================================================================

	["Judgment"] = { id = 20271, category = "main_rotation", priority = 1, specs = { 65, 66, 70 } }, -- 65 since 5 Oct 2026 (IV Holy 12.1; Holy's version 275773, wago) -- SpellArchetypes [20271] ranged builder; Prot 1 / Ret builder
	["Avenger's Shield"] = { id = 31935, category = "main_rotation", priority = 2, specs = { 66 }, alsoStop = "silence" }, -- InterruptAbilities [31935] kind=interrupt pri2 (silences); rotational builder; alsoStop → Spec 08 cross-list (stays on 2)
	["Hammer of the Righteous"] = { id = 53595, category = "main_rotation", priority = 3, specs = { 66 } }, -- AoE-cleave builder. 7 Oct 2026: was 88263 (SpellArchetypes), which is the hammer's AoE effect, not the button; the button is 53595 (wago SpellName 12.1.0.69933, docs/ROLE_SWITCH_FACTS4_2026-10-07.md), so an id match missed it on every client
	["Blessed Hammer"] = { id = 204019, category = "main_rotation", priority = 3, specs = { 66 } }, -- SpellArchetypes [204019]; talent-alternatief voor Hammer of the Righteous
	--- ⚠️ BLIJFT `{ 66 }`, EN DAT IS EEN GEMETEN BESLUIT — 7 sep 2026. Robs Ret meldde deze spell
	--- als `unclassified`, en omdat onze scan off-spec regels overslaat leek dat te bewijzen dat
	--- een Ret hem heeft. De tooltip op die Ret zegt iets anders: **"Requires Shield" staat er in
	--- het ROOD** — een onvervulde eis. Een Ret draagt een tweehander, dus de knop staat in zijn
	--- boek en is niet te casten.
	---
	--- 🔴 DE BREDERE LES, en die geldt voor de hele migratie: **"staat in de actieve spellbook"
	--- is niet "kan gebruikt worden".** Er is een derde soort gat naast *niet getalenteerd* en
	--- *hernoemd*: **bekend maar geblokkeerd door uitrusting.** `ReadKnownActiveSpells` ziet dat
	--- verschil niet en kan het ook niet zien — de eis zit in de tooltip, niet in de spellbook-rij.
	--- Een `unclassified`-melding is dus een AANWIJZING om te kijken, nooit op zichzelf een bewijs
	--- dat onze data een gat heeft.
	-- Holy (65) too since 6 Oct 2026, on block D only (Rob: "laat ze maar op de D blok staan, je weet nooit"). Survival
	-- stays Prot's: as a table keyed by spec, so Holy's Stay alive card does not gain it.
	["Shield of the Righteous"] = { id = 53600, category = "defensive", priority = 1, specs = { 66, 65 }, survival = { [66] = "keepup" }, survivalOrder = 1,
		blockAs = { [65] = { onlyD = true } } }, -- card: active mitigation you keep rolling (IV-ProtPal) -- SpellArchetypes [53600] melee; verbruikt Holy Power maar is ACTIEVE MITIGATION (block+DR), functioneel defensive, geen damage-spender
	["Consecration"] = { id = 26573, category = "main_rotation", priority = 4, specs = { 65, 66 }, survivalSpecs = { 66 }, survival = "keepup", survivalOrder = 2, survivalNote = "SURVIVAL_NOTE_GROUND" }, -- guide.lua Prot-rotatie; [26573] castbare id (JustAC SpellCooldowns); ground-AoE, on-cooldown houden; card 5 Oct 2026 (Rob): "Stay in your Consecration" = less damage via Sanctuary (IV Easy Mode 21 Sep)
	-- 3 Oct 2026: Prot dropped. Icy Veins' 12.1 spell list (10 Aug): "Hammer of Wrath is now a passive
	-- ability. While you have Avenging Wrath active Hammer of Wrath will replace Judgment" — no own button.
	["Hammer of Wrath"] = { id = 24275, category = "spender", priority = 2, specs = { 70 } }, -- SpellArchetypes [24275] ranged; execute-spender (Ret)
	--- 🔴 STOND OP `{ 66 }` EN DAT WAS ONZE FOUT, NIET DIE VAN HET SPEL — 7 sep 2026.
	--- Robs Ret-paladin (lvl 70) meldde `Hand of Reckoning` als `unclassified`. Dat is geen
	--- lekkage uit een Prot-tabblad: `ReadKnownActiveSpells` slaat off-spec skill lines expliciet
	--- over (`offSpecID` en `shouldHide`, regel 157/166 in KeybindAutoMap.lua), dus wat er in de
	--- lijst staat is de ACTIEVE spellbook van die spec.
	---
	--- 📌 Rob, toen ik schreef dat een Ret hem misschien niet nodig heeft: *"waarom zouden we ze
	--- niet nodig hebben???"* Terecht — dat was een mening in de vorm van een reden. Elke paladin
	--- heeft deze knop, en een DPS gebruikt hem juist wél: een losse mob oppakken, of overnemen
	--- als de tank ligt. `{ 66, 70 }` is nu gemeten in twee dumps; **65 (Holy) is NIET gemeten**
	--- en blijft er daarom af — heeft een Holy hem, dan meldt `/mh binds` dat vanzelf.
	["Hand of Reckoning"] = { id = 62124, category = "taunt", priority = 1, specs = { 66, 70, 65 }, blockAs = { [65] = { onlyD = true } } }, -- Holy: block D only (Rob, 6 Oct 2026) -- [62124] taunt (JustAC SpellCooldowns/SpellCategories); F, eigen kaart
	["Ardent Defender"] = { id = 31850, category = "defensive", priority = 2, specs = { 66 }, survival = "small", survivalOrder = 2 }, -- DEFENSIVE [31850]; 90 s (W-CD), the smaller one next to Guardian

	-- Lightsmith (hero-talent) - twee echte knoppen die tot 7 sep 2026 nergens gedekt waren en
	-- daarom als `unclassified` terugkwamen op Robs Prot Paladin.
	--
	-- ✅ De ID's zijn GEMETEN, uit Robs eigen client (`scannedIds` in de automap-dump, 7 sep):
	--    Holy Bulwark 432459 · Rite of Sanctification 433568.
	--
	-- ⚠️ De CATEGORIE en PRIORITEIT zijn een KEUZE, geen meting - Rob mag ze omgooien. Holy
	-- Bulwark staat als `defensive` achter Shield of the Righteous (1) en Ardent Defender (2)
	-- omdat Method hem in de Prot-prioriteitslijst zet, dus hij gedraagt zich als een knop die
	-- je in het gevecht gebruikt. Rite of Sanctification staat als `utility`: hij hoort bij de
	-- Lightsmith-build maar niet in een rotatie.
	--
	-- ⚠️ GEEN `bindKey`: de allocator kiest, zoals bij vrijwel elke entry hier. Zelf een toets
	-- prikken zou een conflict kunnen maken dat pas in-game opvalt.
	--
	-- 📌 `specs = { 66 }` en niet ruimer, want 66 is wat gemeten is. Of Holy (65) deze knoppen
	-- ook heeft is NIET gecontroleerd; heeft een Holy-paladin ze wel, dan komen ze bij hem als
	-- `unclassified` in `/mh binds` te staan en horen we het vanzelf. Dat is precies waarvoor
	-- die teller gebouwd is - een gat dat zichzelf meldt is beter dan een gok die dat niet doet.
	-- 📌 3 Oct 2026: Sacred Weapon (432472) has NO entry of its own, on purpose. Icy Veins (12.1): "This
	-- ability rotates Holy Bulwark and Sacred Weapon. You start with 2 charges … It will start the
	-- cycle as Holy Bulwark." It is ONE button (Method calls it Holy Armaments); a second entry would
	-- ask the allocator for a second key. AFGELEID that the slot reads 432459 while on Holy Bulwark.
	["Holy Bulwark"] = { id = 432459, category = "defensive", priority = 3, specs = { 65, 66 }, blockAs = { [65] = { category = "cooldown", priority = 3 } } }, -- [432459] gemeten in Robs client; Lightsmith, staat in Methods prioriteitslijst
	["Rite of Sanctification"] = { id = 433568, category = "utility", priority = 1, specs = { 66 } }, -- [433568] gemeten in Robs client; Lightsmith-build

	--==============================================================================
	-- RETRIBUTION (spec 70) - melee DPS.
	--==============================================================================

	["Crusader Strike"] = { id = 35395, category = "main_rotation", priority = 1, specs = { 70 } }, -- SpellArchetypes [35395] melee; Holy-Power-builder
	["Blade of Justice"] = { id = 184575, category = "main_rotation", priority = 3, specs = { 70 } }, -- SpellArchetypes [184575] ranged; builder
	["Templar's Verdict"] = { id = 224266, category = "spender", priority = 1, specs = { 70 } }, -- SpellArchetypes [224266] ranged; Holy-Power-spender (ST)
	["Final Verdict"] = { id = 383328, category = "spender", priority = 1, specs = { 70 } }, -- SpellArchetypes [383328]; Templar's-Verdict-vervanger (talent)
	["Divine Storm"] = { id = 53385, category = "spender", priority = 2, bindKey = "Shift+4", specs = { 70 } }, -- SpellArchetypes [53385] melee; AoE-spender (AoE-slot)
	["Wake of Ashes"] = { id = 255937, category = "cooldown", priority = 2, specs = { 70 } }, -- SpellArchetypes [255937] melee; Ret burst-cooldown
	-- Divine Toll staat als één gedeelde baseline-entry bij Holy (specs {65,66,70}); geen aparte Ret-entry (dubbele table-key).

	--==============================================================================
	-- GROOTSTE COOLDOWN (F1) + extra CD's - baseline waar mogelijk.
	--==============================================================================

	-- Avenging Wrath = grootste offensieve/heal-CD, baseline alle specs (BliZzi OffensiveCDAlert +
	-- guide.lua). F1 = cooldown_bar. (Holy kan Avenging Crusader als vervanger talenten - zie boven.)
	["Avenging Wrath"] = { blockQ = { [65] = true, [66] = true, [70] = true }, id = 31884, role = "cooldown_bar", priority = 1 }, -- F1; baseline (31884) grote CD
	-- Sentinel (Prot/Ret cooldown) - SpellCategories/SpellCooldowns [389539]. NB: de "hero-Templar-lijn"-
	-- duiding is onbevestigd (review F1.4); het id 389539 is wél addon-geverifieerd.
	-- 17 Sep 2026: Prot only (W-TREE 790, not on IV-Ret); up to 30% less damage taken (IV-ProtPal).
	-- 7 Oct 2026 (docs/ROLE_SWITCH_FACTS6_2026-10-07.md): Sentinel REPLACES Avenging Wrath on the bar (DB2 69933), and
	-- Method/Icy Veins press it on cooldown. It was "big" (keep it) here while card 66 said "press it when ready": now
	-- "small" (press it often), so the card, the Stay-alive tab and the toolkit say one thing.
	["Sentinel"] = { blockQ = { [66] = true }, id = 389539, category = "cooldown", priority = 4, specs = { 66 }, survival = "small", survivalOrder = 2 },

    -- Gap round 5 Oct 2026 (Rob: "ja doe maar"): castable 12.1 spells that had no entry.
    ["Execution Sentence"] = { id = 343527, category = "cooldown", priority = 1, specs = { 70 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): DB2 Ret node 109373; DB2 AssistedCombatStep Ret has it (rank 2, right after Avenging Wrath
    ["Eternal Flame"] = { id = 156322, role = "heal_quick", priority = 1, specs = { 65, 70 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): Herald of the Sun node 95095 (65,70); TraitDefinition overrides Word of Glory 85673. IV Ho
}
