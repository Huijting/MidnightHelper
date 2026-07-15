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

ns.KeybindRoleClassifier.PRIEST = {

	-- -----------------------------------------------------------------
	-- BASELINE (alle 3 specs: 256, 257, 258)
	-- -----------------------------------------------------------------
	["Fade"] = { role = "utility_primary", priority = 1 },                       -- Q: threat-drop/movement, kleine DR via talent
	["Angelic Feather"] = { role = "mobility", priority = 1 },                   -- R: canonieke Priest-movement (JustAC SpellCooldowns 121536, 3 charges); baseline alle specs
	["Power Word: Shield"] = { role = "defensive_1", priority = 1, specs = { 256, 257, 258 } }, -- Z: self-shield, alle 3 specs (Disc perst 'm ook als atonement-builder; één table-key -> op Z voor iedereen)
	["Desperate Prayer"] = { role = "heal_quick", priority = 1 },                -- F2: persoonlijke noodheal (GEEN defensive -> heal-slot)
	["Psychic Scream"] = { category = "dispel_cc", priority = 1 },               -- V: AoE-fear (CC)
	["Mass Dispel"] = { category = "dispel_cc", priority = 3 },                  -- T: enemy-magic dispel / raid-dispel
	["Leap of Faith"] = { category = "utility", priority = 4 },                  -- X: ally-pull
	["Power Infusion"] = { role = "cooldown_bar", priority = 2 },                -- F1-familie: haste-burst-CD (self/ally)
	["Mind Control"] = { role = "utility_secondary", priority = 2 },             -- E-utility (Disc/Holy hebben geen interrupt)
	["Levitate"] = { category = "utility", priority = 6 },                       -- out-of-combat mobility-utility
	["Shadowfiend"] = { category = "cooldown", priority = 1, specs = { 256, 258 } }, -- burst/mana-CD (pet); Holy heeft geen Shadowfiend

	-- -----------------------------------------------------------------
	-- DISCIPLINE (256) - healer
	-- -----------------------------------------------------------------
	-- Damage/atonement-rotatie (builders/spenders die je actief drukt):
	["Shadow Word: Pain"] = { category = "main_rotation", priority = 3, specs = { 256, 258 } }, -- DoT/Atonement (Shadow 1)
	["Power Word: Radiance"] = { category = "raid_heal", priority = 1, specs = { 256 } },         -- AoE-atonement (getimed spender)
	["Shadow Word: Death"] = { category = "spender", priority = 2, specs = { 256, 258 } },      -- execute
	["Mind Blast"] = { category = "main_rotation", priority = 2, specs = { 256, 258 } },        -- burst-builder (Disc/Shadow)
	["Evangelism"] = { category = "cooldown", priority = 3, bindKey = "Shift+4", specs = { 256 } }, -- atonement-verleng-CD
	-- Defensives:
	["Power Word: Barrier"] = { role = "defensive_3", priority = 1, specs = { 256 } },          -- C: raid-DR
	["Pain Suppression"] = { category = "defensive", priority = 2, specs = { 256 } },           -- Shift+C: tank-external
	["Purify"] = { category = "dispel_cc", priority = 2, specs = { 256, 257 } },                -- Shift+V: friendly-dispel
	-- Cooldowns (raid-heal-enablers / burst) - grote raid-saves op cooldown-slots:
	["Rapture"] = { category = "cooldown", priority = 1, specs = { 256 } },                     -- heal-enabler-CD (raid-save)
	["Spirit Shell"] = { category = "cooldown", priority = 2, specs = { 256 } },                -- absorb-raid-CD
	["Ultimate Penitence"] = { role = "cooldown_bar", priority = 1, specs = { 256 } },          -- F1: grootste heal-CD

	-- Penance: Disc drukt Penance-DAMAGE actief voor Atonement -> BLIJFT main_rotation (haar rotatie).
	-- De heal-toepassing loopt via mouseover/click-cast op hetzelfde spell, geen aparte toets.
	["Penance"] = { category = "main_rotation", priority = 1, specs = { 256 } },                -- damage-Penance (Atonement-rotatie); heal via mouseover/click-cast
	-- ST-heals + ST-HoTs (click-cast op raidframes, GEEN toets - v6 sectie 6):
	["Shadow Mend"] = { role = "click_cast", priority = 1, specs = { 256, 257 } },              -- ST-heal (click-cast); Shadow (258) gebruikt het nauwelijks -> uitgesloten
	["Renew"] = { role = "click_cast", priority = 1, specs = { 256, 257 } },                    -- ST-HoT (click-cast)

	-- -----------------------------------------------------------------
	-- HOLY (257) - healer
	-- -----------------------------------------------------------------
	["Smite"] = { category = "main_rotation", priority = 2, specs = { 257 } },                  -- filler-damage (voedt Chastise)
	["Holy Word: Chastise"] = { role = "utility_secondary", priority = 1, specs = { 257 } },    -- F: damage/CC
	-- Defensives:
	["Guardian Spirit"] = { role = "defensive_3", priority = 1, specs = { 257 } },              -- C: cheat-death external
	-- Cooldowns (grote raid-saves op cooldown-slots):
	["Apotheosis"] = { role = "cooldown_bar", priority = 1, specs = { 257 } },                  -- F1: reset Holy Words (grootste heal-CD)
	["Divine Hymn"] = { category = "cooldown", priority = 2, specs = { 257 } },                 -- Shift+F1: raid-heal-CD
	["Holy Word: Salvation"] = { category = "cooldown", priority = 3, specs = { 257 } },        -- grote raid-save-CD (combineert Holy Words)
	["Symbol of Hope"] = { category = "cooldown", priority = 4, specs = { 257 } },              -- mana/CD-regen raid-CD
	-- Holy self/low-hp heal (naast Flash Heal): niet vereist als apart heal-anker, blijft utility.
	["Power Word: Life"] = { category = "utility", priority = 5, specs = { 257 } },             -- execute-heal (<35%), utility-slot
	-- Raid/AoE/smart-heals - BLIJVEN op toetsen (v6 sectie 6):
	["Prayer of Healing"] = { category = "raid_heal", priority = 1, specs = { 257 } },      -- AoE-groepsheal (toets)
	["Holy Word: Sanctify"] = { category = "raid_heal", priority = 2, specs = { 257 } },    -- AoE-grondheal (toets)
	["Circle of Healing"] = { category = "raid_heal", priority = 3, specs = { 257 } },      -- smart-AoE-heal (toets)
	["Halo"] = { category = "raid_heal", priority = 4, specs = { 257 } },                   -- AoE dmg/heal-puls (toets)
	-- ST-heals + ST-HoTs (click-cast op raidframes, GEEN toets - v6 sectie 6):
	["Heal"] = { role = "click_cast", priority = 1, specs = { 257 } },                          -- efficiente ST-heal (click-cast)
	["Holy Word: Serenity"] = { role = "click_cast", priority = 1, specs = { 257 } },           -- ST-burst-heal (click-cast)
	["Prayer of Mending"] = { role = "click_cast", priority = 1, specs = { 257 } },             -- bouncing ST-heal (click-cast)
	-- (Flash Heal / Shadow Mend / Renew = gedeelde healer-click_cast, zie Disc-blok + onderaan.)

	-- -----------------------------------------------------------------
	-- SHADOW (258) - DPS: volledige rotatie op builders/spenders
	-- -----------------------------------------------------------------
	["Vampiric Touch"] = { category = "main_rotation", priority = 2, specs = { 258 } },         -- DoT + self-heal
	["Shadow Word: Madness"] = { category = "spender", priority = 1, specs = { 258 } }, -- Insanity-spender
	["Mind Flay"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 258 } }, -- filler (AoE-tweeling Shift+1)
	["Void Bolt"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 258 } }, -- Voidform-builder
	["Void Volley"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 258 } }, -- alternatief (talent)
	["Silence"] = { role = "interrupt", priority = 1, specs = { 258 } }, -- E: interrupt + silence
	["Dispersion"] = { role = "defensive_3", priority = 1, specs = { 258 } }, -- C: grote defensive
	["Void Eruption"] = { role = "cooldown_bar", priority = 1, specs = { 258 } }, -- F1: burst-CD (castbare knop = Void Eruption 228260; "Voidform" 194249 is de resulterende buff, dus naam-match faalde)
	["Void Torrent"] = { category = "cooldown", priority = 2, specs = { 258 } }, -- extra burst-CD (channel)
	["Mindbender"] = { category = "cooldown", priority = 1, specs = { 258 } }, -- pet burst-CD (alt. Shadowfiend)

	-- Gedeelde healer-click_cast (Disc + Holy):
	["Flash Heal"] = { role = "click_cast", priority = 1, specs = { 256, 257 } }, -- snelle ST-heal (click-cast)
}