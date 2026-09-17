local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- =====================================================================
-- PRIEST keybind-role classifier (WoW Midnight, Midnight Helper v6)
-- =====================================================================
-- Naam -> rol/categorie. Gekoppeld op EXACTE spell-NAAM (niet ID).
-- Afgeleid uit addon-data (never-lie):
--   JustAC\Data\InterruptAbilities.lua  (Silence 15487, Psychic Scream 8122,
--                                        Psychic Horror 64044)
--   JustAC\Data\SpellCategories.lua      (Fade 586, Desperate Prayer 19236,
--                                        Pain Suppression 33206, Dispersion 47585,
--                                        Power Word: Barrier 62618, Flash Heal 2061,
--                                        Shadow Mend 186263, Purify 527,
--                                        Mass Dispel 32375, Leap of Faith 73325,
--                                        Power Infusion 10060, Mind Control 605, ...)
--   JustAC\Data\SpellArchetypes.lua      (SW:Pain 589, Vampiric Touch 34914,
--                                        Mind Blast 8092, SW:Death 32379,
--                                        SW:Madness 335467, Mind Flay 15407,
--                                        Void Volley 1242173, Voidform 194249,
--                                        Void Torrent 263165)
--   ClassCodex\Data\Priest\guide.lua     (Penance 47540, Evangelism 472433,
--                                        Flash Heal 2061, Prayer of Healing 596)
--   ExwindCore ThingsToMantain / LibOpenRaid (Shadowfiend 34433, Mindbender 200174,
--                                        Mass Dispel 32375, Shackle Horror 9484,
--                                        Guardian Spirit 47788, Symbol of Hope 64901)
--   Cross-ref: docs\KEYBIND_MAP_DRAFT_priest_warlock_mage.md
--
-- specID's: Discipline 256, Holy 257, Shadow 258.
-- Geen specs = baseline (alle 3 priester-specs).
-- Alleen ASCII; geen ID's als key.
--
-- Rol-toewijzing (v6-standaard):
--   interrupt (E)         : Silence (alleen Shadow). Disc/Holy hebben GEEN kick ->
--                           E blijft utility (Mind Control).
--   utility_primary (Q)   : Fade (movement/threat-drop, baseline).
--   defensive_1 (Z)       : Power Word: Shield (kleine self-def, baseline).
--   defensive_3 (C)       : grote def -> Pain Suppression / Power Word: Barrier (Disc),
--                           Guardian Spirit (Holy), Dispersion (Shadow).
--   heal_quick (F2)       : Desperate Prayer (persoonlijke noodheal, baseline).
--   cooldown_bar (F1)     : grootste burst/heal-CD -> Ultimate Penitence (Disc),
--                           Apotheosis (Holy), Voidform (Shadow). Extra CD's via
--                           category "cooldown".
--
-- Healers (Disc 256, Holy 257) - v6 sectie 6: single-target-heals + ST-HoTs/shields
--   (Flash Heal/Heal/Renew/Shadow Mend/Holy Word: Serenity/Prayer of Mending) hebben
--   role = "click_cast" (GEEN toets; via mouseover/click-cast op raidframes).
--   Raid/AoE/smart-heals BLIJVEN op toetsen (main_rotation/spender): Power Word:
--   Radiance (Disc), Prayer of Healing / Holy Word: Sanctify / Circle of Healing /
--   Halo (Holy). Heal-COOLDOWNS op cooldown-slots: Rapture/Spirit Shell/Ultimate
--   Penitence (Disc), Divine Hymn / Holy Word: Salvation / Symbol of Hope (Holy).
--   Disc doet damage voor Atonement -> Smite/Penance/Mind Blast/SW:Pain BLIJVEN
--   main_rotation. Guardian Spirit (Holy) / PW:Barrier (Disc) blijven defensives.
--   Shadow (258) is DPS: volledige rotatie op builders/spenders.
--
-- STAY ALIVE CARD (17 Sep 2026). `survival`, `survivalOrder`, `survivalNote` and
-- `survivalId` feed only Modules/SurvivalPlan.lua; the key fields are untouched.
-- Every tag follows docs/audit_2026-09-17/audit_mage_warlock_priest.md (Method +
-- Icy Veins 12.1).
-- Card: small = Fade (Translucent Image), Power Word: Shield (Disc/Shadow);
--   big = Pain Suppression (Disc) / Guardian Spirit (Holy), both self-cast, or
--   Dispersion (Shadow); heal = Desperate Prayer, then Vampiric Embrace (Shadow);
--   escape = Angelic Feather; interrupt = Silence (Shadow).
-- Left OFF on purpose: Power Word: Barrier (a raid ground circle, and Method says
--   most Discs skip it for Ultimate Penitence), Psychic Scream (crowd control).
-- Removed 17 Sep, gone or passive in Midnight (audit, BRON Icy Veins Holy/Disc/
--   Shadow 12.1): Heal, Renew, Symbol of Hope, Spirit Shell, Shadow Mend (now a
--   passive Flash Heal upgrade), Shadowfiend and Mindbender (now passive).
-- Specs changed: Power Word: Shield {256,257,258} -> {256,258} (removed for Holy).
-- Kept although the audit doubts it: Power Word: Life (one site says class-wide),
--   Rapture, Holy Word: Salvation.

ns.KeybindRoleClassifier.PRIEST = {

	-- -----------------------------------------------------------------
	-- BASELINE (alle 3 specs: 256, 257, 258)
	-- -----------------------------------------------------------------
	["Fade"] = { role = "utility_primary", priority = 1, survival = "small", survivalOrder = 1 }, -- Q: threat-drop/movement, kleine DR via talent (card: "early and often", Icy Veins)
	["Angelic Feather"] = { role = "mobility", priority = 1, survival = "escape", survivalOrder = 1 }, -- R: canonieke Priest-movement (JustAC SpellCooldowns 121536, 3 charges); baseline alle specs
	-- 17 Sep: Holy (257) dropped, "removed … Power Word: Shield" (audit, BRON Icy Veins Holy 12.1).
	-- Card: small, a shield before the hit, not a keep-up.
	["Power Word: Shield"] = { role = "defensive_1", priority = 1, specs = { 256, 258 }, survival = "small", survivalOrder = 2 }, -- Z: self-shield (Disc perst 'm ook als atonement-builder)
	["Desperate Prayer"] = { role = "heal_quick", priority = 1, survival = "heal", survivalOrder = 1 }, -- F2: persoonlijke noodheal (GEEN defensive -> heal-slot)
	["Psychic Scream"] = { category = "dispel_cc", priority = 1 },               -- V: AoE-fear (CC)
	["Mass Dispel"] = { category = "dispel_cc", priority = 3 },                  -- T: enemy-magic dispel / raid-dispel
	-- ✅ 7 sep 2026 — ID's GEMETEN in Robs eigen spellbook (`ns.db.autoMapDump.scannedIds`,
	-- Shadow Priest), niet van het web. Positieve controle in dezelfde uitlezing: 228260 kwam
	-- terug als `Voidform`, wat meteen de hernoem-reparatie van 6 sep in de client bevestigt.
	-- ⚠️ Deze drie staan BASELINE op grond van redenering, niet van meting: alleen Shadow is
	-- gemeten. Ze zijn klassenbreed omdat het dat soort spells zijn (een klassenbuff, de oude
	-- offensieve dispel, en een klassieke Priest-CC), niet omdat iemand Disc of Holy heeft
	-- opengeslagen. Blijkt er één spec-gebonden, dan is dat één `specs =` erbij.
	["Dispel Magic"] = { id = 528, category = "dispel_cc", priority = 4 },       -- offensieve magic-dispel; wij hadden Mass Dispel wél en deze niet
	["Shackle Horror"] = { id = 9484, category = "dispel_cc", priority = 5 },    -- 📌 stond sinds dag 1 in het bronnen-commentaar op :25, nooit als entry
	["Power Word: Fortitude"] = { id = 21562, category = "utility", priority = 7 }, -- klassenbuff
	["Leap of Faith"] = { category = "utility", priority = 4 },                  -- X: ally-pull
	["Power Infusion"] = { role = "cooldown_bar", priority = 2 },                -- F1-familie: haste-burst-CD (self/ally)
	["Mind Control"] = { role = "utility_secondary", priority = 2 },             -- E-utility (Disc/Holy hebben geen interrupt)
	["Levitate"] = { category = "utility", priority = 6 },                       -- out-of-combat mobility-utility
	-- Shadowfiend removed 17 Sep: passive now for Disc and Shadow, gone for Holy (audit, BRON Icy Veins Shadow/Disc/Holy 12.1).

	-- -----------------------------------------------------------------
	-- DISCIPLINE (256) - healer
	-- -----------------------------------------------------------------
	-- Damage/atonement-rotatie (builders/spenders die je actief drukt):
	["Shadow Word: Pain"] = { category = "main_rotation", priority = 3, specs = { 256, 258 } }, -- DoT/Atonement (Shadow 1)
	["Power Word: Radiance"] = { category = "raid_heal", priority = 1, specs = { 256 } },         -- AoE-atonement (getimed spender)
	["Shadow Word: Death"] = { category = "spender", priority = 2, specs = { 256, 258 } },      -- execute
	["Mind Blast"] = { category = "main_rotation", priority = 2, specs = { 256, 258 } },        -- burst-builder (Disc/Shadow)
	["Evangelism"] = { category = "cooldown", priority = 3, bindKey = "Shift+4", specs = { 256 } }, -- ramp-CD: casts Power Word: Radiance (12.1 no longer extends Atonement, audit)
	-- Defensives:
	["Power Word: Barrier"] = { role = "defensive_3", priority = 1, specs = { 256 } },          -- C: raid-DR. Card: off (raid ground circle, not a personal button)
	["Pain Suppression"] = { category = "defensive", priority = 2, specs = { 256 }, survival = "big", survivalOrder = 1, survivalNote = "SURVIVAL_NOTE_SELF_CAST" }, -- Shift+C: tank-external; "use it selfishly" (Method Disc)
	["Purify"] = { category = "dispel_cc", priority = 2, specs = { 256, 257 } },                -- Shift+V: friendly-dispel
	-- Cooldowns (raid-heal-enablers / burst) - grote raid-saves op cooldown-slots:
	["Rapture"] = { category = "cooldown", priority = 1, specs = { 256 } },                     -- heal-enabler-CD (raid-save)
	-- Spirit Shell removed 17 Sep: gone since Dragonflight (audit).
	["Ultimate Penitence"] = { role = "cooldown_bar", priority = 1, specs = { 256 } },          -- F1: grootste heal-CD

	-- Penance: Disc drukt Penance-DAMAGE actief voor Atonement -> BLIJFT main_rotation (haar rotatie).
	-- De heal-toepassing loopt via mouseover/click-cast op hetzelfde spell, geen aparte toets.
	["Penance"] = { category = "main_rotation", priority = 1, specs = { 256 } },                -- damage-Penance (Atonement-rotatie); heal via mouseover/click-cast
	-- ST-heals + ST-HoTs (click-cast op raidframes, GEEN toets - v6 sectie 6):
	-- Shadow Mend removed 17 Sep: "a passive upgrade to Flash Heal" (audit, BRON Icy Veins Disc 12.1).
	-- Renew removed 17 Sep: Plea replaces it for Disc, removed for Holy (audit, BRON Icy Veins Disc/Holy 12.1).

	-- -----------------------------------------------------------------
	-- HOLY (257) - healer
	-- -----------------------------------------------------------------
	["Smite"] = { category = "main_rotation", priority = 2, specs = { 257 } },                  -- filler-damage (voedt Chastise)
	["Holy Word: Chastise"] = { role = "utility_secondary", priority = 1, specs = { 257 } },    -- F: damage/CC
	-- Defensives:
	["Guardian Spirit"] = { role = "defensive_3", priority = 1, specs = { 257 }, survival = "big", survivalOrder = 1, survivalNote = "SURVIVAL_NOTE_SELF_CAST" }, -- C: cheat-death external, also on yourself (Method Holy)
	-- Cooldowns (grote raid-saves op cooldown-slots):
	["Apotheosis"] = { role = "cooldown_bar", priority = 1, specs = { 257 } },                  -- F1: reset Holy Words (grootste heal-CD)
	["Divine Hymn"] = { category = "cooldown", priority = 2, specs = { 257 } },                 -- Shift+F1: raid-heal-CD
	["Holy Word: Salvation"] = { category = "cooldown", priority = 3, specs = { 257 } },        -- grote raid-save-CD (combineert Holy Words)
	-- Symbol of Hope removed 17 Sep (audit, BRON Icy Veins Holy 12.1).
	-- Holy self/low-hp heal (naast Flash Heal): niet vereist als apart heal-anker, blijft utility.
	["Power Word: Life"] = { category = "utility", priority = 5, specs = { 257 } },             -- execute-heal (<35%), utility-slot
	-- Raid/AoE/smart-heals - BLIJVEN op toetsen (v6 sectie 6):
	["Prayer of Healing"] = { category = "raid_heal", priority = 1, specs = { 257 } },      -- AoE-groepsheal (toets)
	["Holy Word: Sanctify"] = { category = "raid_heal", priority = 2, specs = { 257 } },    -- AoE-grondheal (toets)
	["Circle of Healing"] = { category = "raid_heal", priority = 3, specs = { 257 } },      -- smart-AoE-heal (toets)
	["Halo"] = { category = "raid_heal", priority = 4, specs = { 257 } },                   -- AoE dmg/heal-puls (toets)
	-- ST-heals + ST-HoTs (click-cast op raidframes, GEEN toets - v6 sectie 6):
	-- Heal removed 17 Sep (audit, BRON Icy Veins Holy 12.1).
	["Holy Word: Serenity"] = { role = "click_cast", priority = 1, specs = { 257 } },           -- ST-burst-heal (click-cast)
	["Prayer of Mending"] = { role = "click_cast", priority = 1, specs = { 257 } },             -- bouncing ST-heal (click-cast)
	-- (Flash Heal = gedeelde healer-click_cast, zie onderaan.)

	-- -----------------------------------------------------------------
	-- SHADOW (258) - DPS: volledige rotatie op builders/spenders
	-- -----------------------------------------------------------------
	["Vampiric Touch"] = { category = "main_rotation", priority = 2, specs = { 258 } },         -- DoT + self-heal
	-- 🔴 Tentacle Slam was de grootste omissie van Spec 32 §1c: Method gebruikt hem als
	-- AoE-motor om Vampiric Touch op 6-12 doelen te krijgen, en wij kenden hem niet.
	-- Priority 3 = een kale cijfertoets; Shift+1 en Shift+3 zijn al bezet door Mind Flay en
	-- Void Volley, dus de AoE-tweeling-plek was er niet meer.
	["Tentacle Slam"] = { id = 1227280, category = "main_rotation", priority = 3, specs = { 258 } },
	-- Purify Disease krijgt bewust priority 2, dezelfde plek die `Purify` (527) hierboven voor
	-- Disc en Holy heeft: dezelfde reflex op dezelfde toets, welke spec je ook speelt. Dat is
	-- waar het v6-schema voor bestaat, en hier viel het gratis op zijn plek.
	["Purify Disease"] = { id = 213634, category = "dispel_cc", priority = 2, specs = { 258 } },
	["Shadowform"] = { id = 232698, category = "utility", priority = 8, specs = { 258 } },      -- de stance zelf
	["Vampiric Embrace"] = { id = 15286, category = "cooldown", priority = 3, specs = { 258 }, survival = "heal", survivalOrder = 2, survivalNote = "SURVIVAL_NOTE_DAMAGE_HEALS" }, -- groeps-heal-CD; heals you from your damage (Icy Veins Shadow)
	-- ⚠️ `Cantrips` (255661) staat WEL in Robs spellbook en is hier bewust NIET toegevoegd.
	-- Spec 32 §1c zegt het zelf: onbekend wat het in 12.1 doet. Een entry zonder rol is een
	-- gok met een toets eraan, en die kost een echte knop.
	["Shadow Word: Madness"] = { category = "spender", priority = 1, specs = { 258 } }, -- Insanity-spender
	["Mind Flay"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 258 } }, -- filler (AoE-tweeling Shift+1)
	-- ⚠️ Void Bolt is HIER WEGGEHAALD op 7 aug 2026: hij bestaat niet meer. Void Volley
	-- (1242173) heeft zijn plek in Voidform overgenomen -- "instead of granting access to
	-- Void Bolt, Voidform now gives you access to Void Volley, which does not refresh
	-- DoTs" (warcraftpriests.github.io/bookofshadows, Midnight-alpha). Method's rotatie
	-- noemt Void Volley wel en Void Bolt nergens. Het was dus geen alternatief maar de
	-- opvolger, en de "botsing" om Shift+3 was een dode spell tegen een levende.
	-- ⚠️ Niet verwarren met Void BLAST (450405), een andere spell die naast Void Volley
	-- bestaat in de Voidweaver-build.
	["Void Volley"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 258 } }, -- Voidform-spender
	["Silence"] = { role = "interrupt", priority = 1, specs = { 258 }, survival = "interrupt", survivalOrder = 1 }, -- E: interrupt + silence
	["Dispersion"] = { role = "defensive_3", priority = 1, specs = { 258 }, survival = "big", survivalOrder = 1 }, -- C: grote defensive
	-- 🔴 HERNOEMD, NIET VERDWENEN — gerepareerd 6 sep 2026 (Spec 32 §1c).
	-- De aantekening van 7 aug had het net omgekeerd: het ID (228260) klopte, de NAAM niet.
	-- 12.0.0 heeft "Void Eruption" hernoemd naar "Voidform" (Warcraft Wiki: *"renamed to
	-- Voidform ... to reduce confusion between the ability name and active effect"*), en de
	-- lookup gaat op naam. Robs spellbook kent 228260 als `Voidform` en kent geen
	-- `Void Eruption`; JustAC (SpellCooldowns :646, SimcRotations :622) en BliZzi_Interrupts
	-- schrijven inmiddels óók "Voidform" bij 228260, terwijl oudere addons daar nog de oude
	-- naam hebben staan. Dat verschil ís de hernoeming.
	--
	-- ⚠️ Het faalde STIL, en op twee manieren tegelijk. In het spel bleef F1 niet leeg:
	-- Power Infusion (priority 2) schoof er stilletjes in, dus het scherm zag er goed uit
	-- terwijl de grootste burst-knop van de spec nergens stond. En het cheat-sheet drukte
	-- `Void Eruption` af op F1 — een naam die niemand meer in zijn spellbook kan vinden.
	-- Zie [[silence-is-not-absence]].
	--
	-- 📌 Daarom draagt hij nu een `id`: een hernoeming had dan niets gebroken, en het getal
	-- stond al op deze regel in het commentaar.
	["Voidform"] = { id = 228260, role = "cooldown_bar", priority = 1, specs = { 258 } }, -- F1: burst-CD
	["Void Torrent"] = { category = "cooldown", priority = 2, specs = { 258 } }, -- extra burst-CD (channel)
	-- Mindbender removed 17 Sep: passive now (audit, BRON Icy Veins Shadow 12.1).

	-- Gedeelde healer-click_cast (Disc + Holy):
	["Flash Heal"] = { role = "click_cast", priority = 1, specs = { 256, 257 } }, -- snelle ST-heal (click-cast)
}