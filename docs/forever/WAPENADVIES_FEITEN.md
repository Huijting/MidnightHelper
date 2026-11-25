# Wapenadvies Forever — register van beweringen, bronnen en meetpunten

Gemaakt 25 nov 2026 door de bouwchat. Rob (via Sparring): *"Zorg er ook voor dat in onze controlerondes elke dag
gecontroleerd wordt of er wijzigingen zijn die hier invloed op hebben."* en *"En dat bedoel ik natuurlijk bij patch notes
en dat soort dingen allemaal."* "Hier" = het blok "Which weapon?" voor alle 9 classes (`Modules/ForeverWeapons.lua`,
`ns.ForeverWeaponAdvice`, CLASS_LINES; teksten `FWADV_*` in `Locales/enUS.lua` + 7 vertalingen), de wapenregel per richting
(`Modules/ForeverDirection.lua` GUIDE, teksten `FDIRB_W_*`) en de stats-zinnen (`Modules/ForeverMainStats.lua`
`lead`/`armor`/`equal`, tekst in `Modules/ForeverDoNow.lua` StatSentence, `FDONOW_STAT*`).

De wachters lezen dit bestand via `docs/WATCHER_FOREVER.md` (sectie "Weapon advice"). Een treffer = één regel in hun eigen
bestand; NIETS automatisch aanpassen. De bouwchat werkt dit register bij als een bewering verandert.

Status: **GEMETEN** = in DB2 of de client gemeten; **BRON** = Blizzard-tekst (artikel, hotfix, dev notes); **GIDS** = alleen
spelersgidsen; 🟠 **BETWIST** / **NIET GEMETEN** = de wachter let hier extra op.

## Gedeeld (alle classes)

| bewering in de spelertekst | waar | bron / meetpunt | status |
|---|---|---|---|
| Een wapenskill leer je vanaf level 1 voor 10 silver; Polearms vanaf 20 (1 gold) | "still learn"-regel (`KnownAndLearn`), `WEAPONS` in ForeverWeapons.lua | DB2 SkillRaceClassInfo (MinLevel), spelersrapport voor de prijs | GEMETEN (level) / GIDS (prijs) |
| Welke class welk wapen mag | `WEAPONS.classes` (ForeverWeapons.lua), SKILL-masks in AltProfTip.lua | DB2 SkillRaceClassInfo ClassMask | GEMETEN |
| Dual Wield Warrior/Hunter 20, Rogue 10; geen Dual Wield voor Shaman/Paladin | FWADV_WAR_3, _HUN_8, _ROG_2, _SHA_1, _PAL_5 | SkillRaceClassInfo (spell 674) | GEMETEN |
| Mail 40 (Hunter, Shaman), Plate 40 (Warrior, Paladin) | FWADV_SHA_8; ARMOR in ForeverDirection.lua | SkillRaceClassInfo 413/414 MinLevel | GEMETEN |
| Ras geeft geen wapenbonus meer | FWADV_WAR_7 | SpellName 20597 "Ruthless" (Human), 20574 "Savage" (Orc) | GEMETEN |
| Leraren per kant en wat ze leren | TRAINERS (ForeverWeapons.lua) | Wowhead-pins + Zygor (plek), Warcraft Tavern + gossip (wat) | GIDS (wat ze leren); Sayoc + Staves BETWIST |
| Twee-hand-DPS ≈ 1,3× één-hand bij gelijk ilvl | FWADV_TWOHAND_FMT | DB2 ItemDamageTwoHand/OneHand | GEMETEN |
| C_Item.GetItemStats geeft spell power (ITEM_MOD_SPELL_POWER_SHORT); de kale GetItemStats is nil | ForeverQuestHint.lua Stats() → `SPELL`, gewicht `spellW` in ForeverMainStats.lua | GEMETEN door Rob 25 nov: `/dump C_Item.GetItemStats("item:9513")` (Ley Staff) = Intellect 1, Spirit 1, SPELL_POWER 2, DPS 5.34. DB2 ItemSparse heeft voor 9513 GEEN spell power-rij (de client maakt hem) | GEMETEN |
| Healing-only = ITEM_MOD_SPELL_HEALING_DONE_SHORT, damage-helft = ITEM_MOD_SPELL_DAMAGE_DONE_SHORT, één school = ITEM_MOD_<SCHOOL>_DAMAGE_DONE_SHORT, mp5 = ITEM_MOD_MANA_REGENERATION_SHORT; type 45 op leer = echte spell power | Stats() → HEAL / SDMG / school / MP5; SpellValue (healers: SPELL+HEAL+½ mp5; damage: SPELL+SDMG+scholen van de spec); `schools` in ForeverMainStats | GEMETEN door Rob 25 nov (7049, 19395, 2231, 2311); de andere scholen GEMETEN in GlobalStrings 71091 | GEMETEN (welke school bij welke spec en het mp5-gewicht: AFGELEID) |
| 🟠 Caster-wapens ~74% DPS (staven), ~66% (daggers) | FWADV_STAFF_FMT, FWADV_CAST_1 | ItemSparse Flags_4 0x100 + 120 staven/31 daggers op Wowhead; hotfix 17 nov (Kaivax, thread 2403040) "74 Spell Power from Weapon damage" | BRON + steekproef; DB2-tabel ItemDamage*Caster zegt iets anders → let op |

## Druid

| bewering | waar | bron / meetpunt | status |
|---|---|---|---|
| In Bear/Cat/Dire Bear doen je aanvallen de DPS van je wapen; snelheid zet de vorm (Cat 1.0 s, Bear 2.5 s) | FWADV_FORM_FMT, _PRE_FMT | Blizzard Class Deep Dive Hunter & Druid 30 sep 2026; DB2 SpellShapeshiftForm | BRON + GEMETEN |
| Wapen-enchants, weightstones en procs werken in een vorm | (comment ForeverWeapons.lua) | deep dive 30 sep | BRON |
| Bear Form 10, Cat Form 20 | FWADV_FORM_FMT (levelgrenzen in de code) | SpellLevels (5487, 768) | GEMETEN |
| Strength 2 AP; Agility alleen AP in Cat Form | FWADV_STATS_FMT / _LOW_FMT | ChrClasses; GlobalStrings DRUID_AGILITY_TOOLTIP | GEMETEN |
| Bear Form +180% armor van items | FWADV_BEAR_FMT | deep dive / DB2 | GEMETEN |
| In een vorm sla je met skill Feral Combat (2554) | (niet in tekst) | gidsen | GIDS |

## Warrior

| bewering | waar | bron / meetpunt | status |
|---|---|---|---|
| Mortal Strike, Overpower, Slam voegen één wapenslag toe → langzaam wapen | FWADV_WAR_2 | deep dive Warrior; spells 12294/7384/1464 | BRON |
| Shield Bash/Block/Slam alleen met schild; Shield Slam schaalt met block value, Revenge met AP | FWADV_WAR_4 | SpellEquippedItems (72, 2565, 23922) | GEMETEN (schild-eis) / BRON (schaal) |
| 🟠 Rage per wapensnelheid; crits extra | FWADV_WAR_5 | deep dive | BRON; percentage BETWIST (75% vs 100%) → niet genoemd |
| Weaponmaster: axe/polearm crit, mace/staff armor, sword extra aanval | FWADV_WAR_7 | talent 12281 | BRON (Talent-tabel DB2 is verouderd) |
| Tank-stats: Stamina, Armor, Agility (geen "weapon DPS first" meer voor tanks, Fable 25 nov) | TANK.WARRIOR (ForeverMainStats.lua) | Icy Veins Prot 4 nov, wowhandbook | GIDS |

## Paladin

| bewering | waar | bron / meetpunt | status |
|---|---|---|---|
| Seal of Command gaat af op sommige slagen met een deel van je wapenschade → langzaam wapen ("~7×/min" weg, 25 nov Fable: niet in Blizzard/DB2) | FWADV_PAL_2, _PAL_3 | gidsen | GIDS |
| Tank-stats: Stamina, dan spell damage (vergroot Holy damage en dus threat) | FWADV_PAL_6; TANK.PALADIN, BY_TREE.PALADIN[2] (`spell`) | Blizzard hotfix-thread 2403040, post 12, 17 nov 2026: "We are leaning more into Paladin tanks favoring Spell Power as their primary stat for dealing damage" | BRON (lost "Prot Intellect" op) |
| Ret: Champion of the Light maakt Intellect tot spell damage | FWADV_PAL_6 | talent 1311084 (SpellName GEMETEN) | BRON |
| Seal of Fury (vanaf 10) voegt Holy damage per slag toe → snel wapen; schildbel en Holy Shield alleen met schild | FWADV_PAL_4 | deep dive 7 okt; SpellEquippedItems 20925 | BRON + GEMETEN (schild-eis) |
| Geen staves/daggers/fist/ranged/wands, geen twee wapens | FWADV_PAL_5 | SkillRaceClassInfo | GEMETEN |
| Two-Handed Weapon Specialization verlaagt threat met tweehander | FWADV_PAL_7 | gidsen / talent 20111 | GIDS |
| Eerste libram vraagt level 20 | FWADV_PAL_8 | onderzoek (een item) | 🟠 NIET GEMETEN welke |

## Shaman

| bewering | waar | bron / meetpunt | status |
|---|---|---|---|
| Strength altijd eerst voor Enhancement | FWADV_SHA_5; BY_TREE.SHAMAN[2] | Blizzard blue post 6 nov; hotfix 10 nov (Mental Dexterity) | BRON |
| 🟠 Two-Handed Axes/Maces zonder talent: leer ze bij een weapon master | FWADV_SHA_2 | onderzoek; waar talent 16269 komt NIET gemeten | NIET GEMETEN |
| Geen Dual Wield voor een Shaman | FWADV_SHA_1 | talentboom + trainerlijst; let op: SkillRaceClassInfo rij 2455 (Dual Wield, Shaman) bestaat WEL, een overblijfsel (ook in Era) | BRON (DB2-rij misleidend) |
| Relic-Totem ≠ Earth/Fire/Water/Air Totem uit de class quests (die in de tas houden) | FWADV_SHA_8 | ItemSparse 5175-5178 | GEMETEN (items) |
| Wapenbuffs Rockbiter 1, Flametongue 10, Frostbrand 20, Windfury 30; 60 min | FWADV_SHA_4 | onderzoek / SpellLevels | BRON (levels uit onderzoek) |
| Resto: Intellect boven Spirit | BY_TREE.SHAMAN[3] | 6 gidsen | GIDS |
| Totem of Charged Flames uit de Fire-quest op 10 | FWADV_SHA_8 | ItemSparse 263412 | GEMETEN (item) / BRON (quest) |

## Hunter

| bewering | waar | bron / meetpunt | status |
|---|---|---|---|
| Schoten vragen bow/gun/crossbow, geen thrown | FWADV_HUN_1 | SpellEquippedItems mask 262156 | GEMETEN |
| Geen maces | FWADV_HUN_6 | SkillRaceClassInfo | GEMETEN |
| 🟠 Ammo wordt verbruikt; quiver/pouch +10% | FWADV_HUN_4 | Beta Dev Notes 24 sep ("not correctly consuming ammunition … corrected") en 16 okt; Wowhead-tooltips | BRON; ammo-gedrag was eerder kapot → let op |
| Betere ammo op 10, 25, 40; schoten niet binnen 8 yards | FWADV_HUN_4, _HUN_5 | DB2 (ammo-levels), tooltips (8-35 yd) | GEMETEN / BRON |
| Strider Kick: talent, op z'n vroegst 30; Survival-lead: ranged-DPS onder 30, melee-DPS vanaf 30 | FWADV_HUN_8; BY_TREE.HUNTER[3] lead "survival" | GEMETEN door Sparring (Fable 25 nov) | GEMETEN |
| Careful Aim maakt Intellect tot AP | FWADV_HUN_9; FOREVER_MAIN_STATS.HUNTER.later | talent 1223984 | BRON |

## Rogue

| bewering | waar | bron / meetpunt | status |
|---|---|---|---|
| Axes leren in Forever | FWADV_ROG_1 | deep dive Rogue & Warlock 7 okt | BRON |
| Shank vanaf 24, mist niet, geeft Energy | FWADV_ROG_2 | Beta Dev Notes 3 nov | BRON |
| Backstab/Ambush: dagger in main hand, van achteren | FWADV_ROG_4 | SpellEquippedItems (53, 8676) | GEMETEN |
| Mutilate (vanaf 40) vraagt twee daggers | FWADV_ROG_4 | deep dive 7 okt; Beta Dev Notes rij 7 | BRON; level 🟠 NIET GEMETEN |
| Hack and Slash per wapensoort | FWADV_ROG_5 | DB2 13960 | GEMETEN |
| Gif vanaf 20 (class-quest), 30 min, charges | FWADV_ROG_6 | deep dive 7 okt; DB2 ProcChance; warcraft.wiki 5 nov | BRON |
| Throw is één item, geen stapel | FWADV_ROG_7 | onderzoek | BRON |

## Mage / Priest / Warlock

| bewering | waar | bron / meetpunt | status |
|---|---|---|---|
| Wand krijgt GEEN spell damage | FWADV_MAG_5, CAST_1 | Blizzard dev notes 24 sep (Kaivax, thread 2360696); DB2 coefficient 0 | BRON + GEMETEN; Icy Veins Frost zegt anders → let op |
| Wand: 0,5 s stilstaan na bewegen | FWADV_CAST_4 | dev notes 16 okt | BRON |
| Wand Specialization 2 rangen 13/25% (Arcane, Discipline); Warlock heeft er geen | FWADV_MAG_5, _PRI_5, _WLK_5 | DB2 trees 1112/1114/1116 | GEMETEN |
| Eerste wand via Enchanting: Novice's Practice Wand (1), Lesser Magic Wand (5) | FWADV_CAST_6 | ItemSparse 247789, 11287 | GEMETEN |
| Create Firestone 28, Create Spellstone 36, op het wapen | FWADV_WLK_7 | SpellLevels 6366, 2362 | GEMETEN |
| Life Tap schaalt met Spirit | FWADV_WLK_7; BY_TREE.WARLOCK[1] | onderzoek + tweede check | BRON |
| ✅ Warlock: spell damage, dan Intellect = Spirit; Stamina geen hoofdstat (alleen bij gelijkspel) — keuze (a), Rob 25 nov: *"Ik volg jouw advies."* | FOREVER_MAIN_STATS.WARLOCK, BY_TREE.WARLOCK[1]/[2]/[3]; FWADV_WLK_7 | dev notes 3 nov (demon 2 HP per Stamina, was 7,5); Life Tap 1454 + Blizzard 24 sep/7 okt; gidsen spell power eerst | BRON + Robs keuze (gesloten) |
| Groene regel in de eigen clienttekst (voorbeeldgetal 12) | FWADV_CAST_2 (token `<GF:TOOLTIP_ITEM_STAT_SPELL_POWER_INCREASE>`) | GlobalStrings 71091 (enUS + ruRU GEMETEN) | GEMETEN |
| Mage-scrolls (imbue) 1 uur, meestal staf, soms dagger | FWADV_MAG_7 | ItemSparse 274947 Scroll of Imbue Lesser Flame (level 5) | GEMETEN (item) / BRON |
| Druid zonder richting: Strength en Agility even zwaar | FOREVER_MAIN_STATS.DRUID | ChrClasses (2 AP per Str, 0 per Agi; Agi alleen AP in Cat Form, 20) | GEMETEN |

## Trefwoorden voor de wachter

weapon, wand, staff, dagger, shield, off-hand, two-hand, dual wield, polearm, form, Bear Form, Cat Form, Dire Bear, Rage,
ammo, arrows, bullets, quiver, poison, imbue, Rockbiter, Flametongue, Frostbrand, Windfury, Seal, Seal of Command, Seal of
Fury, Holy Shield, Judgement, Weaponmaster, Hack and Slash, Wand Specialization, Shank, Mutilate, Backstab, Ambush,
Stormstrike, Raptor Strike, Mongoose Bite, Strider Kick, Careful Aim, Mental Dexterity, Life Tap, Firestone, Spellstone,
spell power, spell damage, caster, attack power, Strength, Agility, weapon skill, weapon master.
