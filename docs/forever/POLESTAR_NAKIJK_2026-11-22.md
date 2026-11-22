# Polestar-weetjes in de class-quests nagekeken (22 nov 2026)

Rob via sparring, letterlijk: *"Misschien is dat wel slim, ouderwetjes nakijken."* (spraak: oude weetjes). Alleen onderzoek:
geen code, data of commentaar gewijzigd, 5.8.0 staat zoals het stond. Niets in het spel gezien. mh-research, daarna de
hoofdpunten nagemeten door de bouwchat.

## Eindoordeel van de bouwchat (gaat vóór de tabel eronder)

**55 feiten: 36 bevestigd, 3 tegengesproken, 1 betwist, 15 zonder andere bron.** "Bevestigd" is bevestigd in een bron, niet
in het spel; bij 10 van de 36 is dat helemaal AFGELEID (R1, R3, R4, R7, S9, M2, M3, M6, M8, W8).

- **R12, tegengesproken:** de Eye of Bhossca wacht op 78307, MH op 78261 (GEMETEN in AllTheThings, dat is één bron; dat het
  spel hem anders weigert is AFGELEID).
- **R14, tegengesproken:** vóór de Eye komt eerst brief 614 van C (GEMETEN in AllTheThings + MailTemplate).
- **M21, tegengesproken als afkoeltijd:** de Cantation heeft 10 seconden (GEMETEN ItemEffect 97868, item 7308), MH zegt
  5 minuten. Of de rift zelf een wachttijd heeft is NIET gemeten.
- **M1, van tegengesproken naar BETWIST:** alleen een rassenlijst van AllTheThings spreekt het tegen, en zulke lijsten wijken
  vaak af van de questcache (1524 gelijk, 522 anders). Alleen commentaar, een speler merkt niets. Om dezelfde reden zijn R1
  en M3 zwak bevestigd.
- **R11, zwaarder dan "geen andere bron":** dat level 23 klopt blijft zonder bron, maar ook deze keten begint met een
  uitnodigingsbrief (GEMETEN MailTemplate 612). MH stuurt er nu zonder brief heen; dat er dan niets ligt is AFGELEID.
- **Poisons (buiten de module), door de bouwchat:** 2842 staat niet in de trainerlijst van What's Training (GEMETEN, controle
  1766 Kick wel). Dat steunt "niet van de trainer"; of die lijst compleet is, is niet gemeten.

Voorstel, wacht op Robs keuze: R12; een wachttekst bij R14 en R11; de getallen weg bij M21, R10 en W3; commentaar M1 en S6.
De rasroutes zonder bron (R2, M5, M10, M11, M12, M14, W7) laten staan en testen. De bijvangst B1-B4 is niet nagemeten.

---

## Onderzoek van mh-research (Engels, ongewijzigd)

Research only. Nothing in the repo or the game was changed and nothing was seen in game.
Subject: `Modules/ForeverClassQuests.lua` lines 742, 814, 828, 1005, 1051, 1070, 1420, 1546, 1552, plus facts that the
named docs of 17/18 Nov show resting on Polestar. CQ = that module, EN = `Locales/enUS.lua`.

## Result

| part | facts | CONFIRMED | CONTRADICTED | NO OTHER SOURCE |
|---|--:|--:|--:|--:|
| Rogue (742, 814, 828) | 15 | 10 | 2 | 3 |
| Shaman (1005, 1051, 1070) | 9 | 8 | 0 | 1 |
| Mage (1420, 1546, 1552) | 23 | 13 | 2 | 8 |
| Warlock (doc only, no comment names Polestar) | 8 | 5 | 0 | 3 |
| **Total** | **55** | **36** | **4** | **15** |

"Confirmed" does not mean seen in game. MEASURED = the source says it. DERIVED = reasoned from what the source says.

Contradicted: R12 (wrong prerequisite), R14 (letter step missing), M1 (wrong comment, no player effect), M21 (cooldown text).

## Source keys

- **CACHE <id>**: `E:\World of Warcraft\_forever_\Cache\WDB\enUS\questcache.wdb`, header build 71037, 2132 records. Record
  body as int32: [2] quest level, [4] minimum level, [17] reward spell, [24] start item, [110]+[111] race mask; the texts
  follow from byte 460.
- **DB2 <table>**: wago.tools, build 1.60.1.71037. MailTemplate read live from
  https://wago.tools/db2/MailTemplate/csv?build=1.60.1.71037 (112 rows), the others from the gamedata cache.
- **ATT <file>:<line>**: AllTheThings copy, `<scratchpad>\att_forever_data\contrib\db\forever\...\<file>.lua.txt`.
- **ZY-A / ZY-H / ZY-C :<line>**: `ZygorGuidesViewerForever\Guides-Forever\Leveling\ZygorLeveling{Alliance,Horde,Common}CLASSIC.lua`.
  **ZY-DH**: `...\Dungeons\ZygorDungeonHordeCLASSIC.lua`. Ids, conditions, places and order only. The line numbers differ
  from the 17 Nov docs: the installed guides changed since then.
- **TEXT :<line>**: Blizzard's quest words in `Spoken_Quests\Data\QuestText.lua`.
- **SP :<line>**: `Spoken_Quests\Data\Compendium.lua` (races, prev, ender). Shown only as context, see "Independence".
- **WH**: https://nether.wowhead.com/forever/tooltip/<quest|npc|object>/<id>, read 22 Nov 2026.
- **WIKI**: https://warcraft.wiki.gg/wiki/The_Eye_of_Bhossca, last edited 17 Apr 2024 (Season of Discovery, older than
  Forever and Polestar, so support only).

## Rogue

| id, file:line | what the addon does | verdict and evidence | what a player notices | advice |
|---|---|---|---|---|
| R1 CQ:814-818 | Treats 2205/2206 as open to a High Order Skyborne | CONFIRMED (DERIVED): ATT elwynn forest:1450 and stormwind city:1398 say ALLIANCE_ONLY. That this constant includes High Order follows from 92481 and 93791, where CACHE has exactly the five Alliance races. Classic-derived field. | If wrong: Keryn offers nothing. | Keep. |
| R2 CQ:814-818 | Sends a Skyborne rogue on the Human route (Keryn in Goldshire first) | NO OTHER SOURCE for the route. ZY-A:975 has it in the Human starter guide only; ZY-C (Skyborne 1-13) has no step for 2205. | If wrong: an arrow to Goldshire at levels 10-20 for nothing. If taken out: no Blade of Cunning line for this race. | Test: High Order rogue of 10+ at Keryn 917. Is 2205 offered? Then at Shaw without it: is 2206 refused? |
| R3 CQ:828-830 | 1859 is for Orc only | CONFIRMED (DERIVED): Blizzard's accept text of 1859 (TEXT:6865) expects "an orc by your description", with no race placeholder. Disputed: ATT durotar:1365 says ORC and TROLL; ZY-H:3767 has no race condition. SP:1481 says Orc, not counted. | If wrong: a Troll skips a pointer he could have taken. No wrong trip. | Keep. Test: Troll rogue of 10 at Kaplak 3170. |
| R4 CQ:828, 830 | A Troll takes 1963 without 1859 | CONFIRMED (DERIVED): ATT durotar:1365 marks 1859 `isBreadcrumb = true`; ATT orgrimmar:754 gives 1963 to ORC and TROLL. | If wrong: Therzok offers nothing. | Keep. Test: the same Troll at Therzok without 1859. |
| R5 CQ:829-830 | 1963 and 1858 are the Orc and Troll route | CONFIRMED (MEASURED): ATT orgrimmar:754 and :770. May be the same Classic dataset as Questie. | If wrong: wrong route. | Keep. |
| R6 CQ:764, 807-811 | Therzok 6446 gives and takes 1963, then 1858, at Orgrimmar 42.74,53.54 | CONFIRMED (MEASURED): ZY-H:4193, 5267, 5268, 5292; ATT orgrimmar:754/770 (qg 6446, 42.74,53.52, order 1859, 1963, 1858). | If wrong: wrong arrow. | Keep. |
| R7 CQ:829-830 | No Orgrimmar Blade route for a Windshaper | CONFIRMED (DERIVED): ATT lists only ORC and TROLL on 1859, 1963, 1858. The Undead route's races were not re-read. | If wrong: a Windshaper rogue gets no hint. | Keep. |
| R8 CQ:778, 879-890 | Horn 78261 then 78307, Eye 78676 then 78699, all at the Dead Drop (object 410369, Silverpine 47.1,71.1) | CONFIRMED (MEASURED): ATT silverpine forest:743, 762, 708, 722; WH quest and object tooltips; DB2 QuestV2 has all four. | If wrong: wrong arrow. | Keep. |
| R9 CQ:878, 884, 889 | The hand-in quests come after a letter from C | CONFIRMED (MEASURED): DB2 MailTemplate 613 (Horn payment at the same dead drop) and 615 (Eye payment). | If taken out: sent back to an empty Dead Drop. | Keep. |
| R10 CQ:878, EN:7371 | Says the letter takes "a quarter of an hour up to two hours" | NO OTHER SOURCE: the mail texts, ATT and WIKI give no time; one web search found none. | If wrong: waits, or gives up, at the wrong moment. If taken out: nothing lost. | Smallest fix: drop the two times. Test: note hand-in time and mail time. |
| R11 CQ:879 | The Horn chain opens at level 23 | NO OTHER SOURCE as a minimum. ATT silverpine:743 has no level; 23 is only the quest level in the 17 Nov doc. DB2 MailTemplate 612 shows that this job, too, starts with an invitation letter. | If wrong: the hint is early or late, possibly before any letter. | Test: rogue of 20-23, note the level and place where letter 612 arrives, and whether the Dead Drop offers 78261 without it. |
| R12 CQ:886 | `needs = 78261` for the Eye | **CONTRADICTED. Must be 78307.** MEASURED: ATT silverpine:708 `sourceQuest = 78307`, with "after completing The Horn". Support: DB2 MailTemplate 614 is the follow-up to that job; WIKI names the Horn as previous. | Horn handed in but payment 78307 not collected, level 34-40: the payment line has aged out (more than 10 levels past 23, CQ:3059) and the addon sends you to get the Eye, which is not offered. | Smallest fix: `needs = 78307`. Test: rogue of 30+ between the two hand-ins. |
| R13 CQ:886 | The Eye opens at level 30 | CONFIRMED (MEASURED): ATT silverpine:708 description says level 30 for the letter, next to a quest minimum of 25; WIKI says 30. | If taken out (25): five levels early. | Keep. |
| R14 CQ:888 | At 30 says "get the quest" at the Dead Drop at once | **CONTRADICTED. A letter comes first.** MEASURED: ATT silverpine:708 (reach 30, enter a major city, get C's letter, then pick up); DB2 MailTemplate 614 is that letter; WIKI says the quest shows after reading it. DERIVED: no letter, no pickup. | Can travel to Silverpine and find an empty Dead Drop. | Smallest fix: an `e.wait` on 78676 ("at 30 visit a major city and read C's letter"). Test: rogue of 30 that stays out of cities and checks the Dead Drop first. |
| R15 CQ:797 | Shadowfang Keep entrance 44.8,67.8 (doc: Polestar only) | CONFIRMED (MEASURED): DB2 Map 33 corpse entrance converted with UiMapAssignment gives 44.72,67.77. | If wrong: wrong arrow. | Keep. |

## Shaman

| id, file:line | what the addon does | verdict and evidence | what a player notices | advice |
|---|---|---|---|---|
| S1 CQ:1005-1011 | Windshaper earth chain opens at 3 | CONFIRMED (MEASURED): CACHE 92466, 92467, 92468 minimum 3; ATT zephras isle:324/335/343 agree. The first quest 92484 has minimum 2, covered by the note at CQ:2010. Questie is not used. | If taken out (4): one level late for Stoneskin Totem. | Keep. The comment can cite the client cache. |
| S2 CQ:1005, 979 | The other earth chains open at 4 | CONFIRMED (MEASURED): CACHE 94373 minimum 4; ATT durotar:38 (1516) level 4. | If wrong: hint at the wrong level. | Keep. |
| S3 CQ:1051, 1059 | 94502 is handed in at the Forgotten Shrine, not at Norric | CONFIRMED (MEASURED place, DERIVED object): ZY-A:22239 turns in at Westfall 45.53,59.93, which is the shrine (WH object 619896 at 45.6,59.9); ATT westfall:88 starts the next quest at that object; CACHE 94502 description says put the items on the shrine. The log summary's "Return to Norric" is the end of the whole chain (94505): this settles the conflict in VOORWAARDEN:143. | If it were Norric: a wasted trip. If taken out: a wrong trip from Westfall to Loch Modan. | Keep. A dwarf shaman hand-in would settle it for good. |
| S4 CQ:1060 | 94503 starts at the shrine | CONFIRMED (MEASURED): ATT westfall:88 provider object 619896; ZY-A:22240. | If wrong: no quest where the arrow points. | Keep. |
| S5 CQ:946, 1060-1061 | Spirit 5895 beside the shrine takes 94503 and gives 94505 (46.3,59.3) | CONFIRMED (MEASURED): ZY-A:22244-22245 npc 5895 at 46.42,59.16; CACHE 94503 says speak to it in Westfall. WH 5895 lists only Silverpine spawns (incomplete); ATT gives 94505 that Silverpine place too. | If wrong: arrow a few yards off. | Keep. |
| S6 CQ:1051 | "The spirit appears after a while" (comment only) | NO OTHER SOURCE for the delay. Blizzard's text (CACHE 94502) says only that the ritual calls the spirit. | Nothing: no text shows it. | Drop the words, or time it in game. |
| S7 CQ:1053-1058 | Route 94494 to 94501 (doc line 183: "Spoken + Wowhead + Polestar") | CONFIRMED (MEASURED): ZY-A:22188-22229 has every quest, giver, receiver and the order; CACHE texts of each quest; ATT givers and order, minimum 20. | If wrong: wrong trips. | Keep. |
| S8 CQ:1070-1072 | Elemental Mastery opens at 50 | CONFIRMED (MEASURED): ATT alterac mountains:321 (8410) and :510 (8412) level 50; ZY-DH:8213 offers it at ding 50. | If wrong: two levels early. | Keep. The comment can cite ATT and Zygor. |
| S9 CQ:1071 | Zygor's 52 is pace, not a gate | CONFIRMED (DERIVED): the same Zygor addon uses 50 (ZY-DH:8213) and 52 (ZY-H:26317); ATT says 50. | As S8. | Keep. |

## Mage

| id, file:line | what the addon does | verdict and evidence | what a player notices | advice |
|---|---|---|---|---|
| M1 CQ:1546 | Says 1860 is for Human and Gnome only | **CONTRADICTED. It is an optional Alliance pointer.** MEASURED: ATT elwynn forest:1509 `races = ALLIANCE_ONLY`, `isBreadcrumb = true`. SP:1482 has the Alliance mask with High Order, not counted. | Nothing: the route skips it anyway. | Smallest fix: the comment. |
| M2 CQ:1551 | Jennea gives 1861 without 1860 | CONFIRMED (DERIVED): ATT elwynn:1509 marks 1860 a breadcrumb. ATT lists it as 1861's source, which for a breadcrumb is not a gate. | If wrong: Jennea offers nothing. | Keep. Test: High Order mage of 10 at Jennea without 1860. |
| M3 CQ:1551 | A Skyborne may take 1861 | CONFIRMED (DERIVED): ATT stormwind city:1201 ALLIANCE_ONLY (see R1). | If wrong: a useless trip. | Keep. Same test. |
| M4 CQ:1547-1550 | Wand first on Zephras: 93791 then 93797, level 10 | CONFIRMED (MEASURED): CACHE 93791/93797 minimum 10, Alliance five; ZY-C:1128-1139 and :1245; ATT zephras:1149, :282. | If taken out: the island's own quest is missed. | Keep. |
| M5 CQ:1545, 1551 | Then routes a Skyborne to Mirror Lake in Stormwind | NO OTHER SOURCE for this as the race's route: ZY-C has no 1861, ZY-A:23469 does not say Skyborne. | An arrow to Stormwind at 10-20. If taken out: no staff or orb line for this race. | Keep, test with M2. |
| M6 CQ:1547-1551 | Wand and staff/orb can both be done | CONFIRMED (DERIVED): DB2 QuestV2 gives 93797 its own completion bit 67651; only 1861 and 1880 share 1473. Server exclusions are not visible there. | If wrong: second line stays up until 20. | Keep. |
| M7 CQ:1552-1553 | 1883 is a pointer from Uthel'nay in Orgrimmar to Un'Thuwa | CONFIRMED (MEASURED): ATT durotar:1204 breadcrumb, givers 7311 and 3049; ZY-H:25337, 25342. | If wrong: wrong arrow. | Keep. |
| M8 CQ:1554 | 1884 can be taken without 1883 | CONFIRMED (DERIVED): the same breadcrumb flag. | If wrong: Un'Thuwa offers nothing. | Keep. Test: Troll mage of 10 at Un'Thuwa. |
| M9 CQ:1501, 1554 | A Troll gets 1884 from Un'Thuwa 5880, Durotar 56.31,75.11 | CONFIRMED (MEASURED): ATT durotar:984 TROLL listed, qg 5880; ZY-H:25343, 25355. | If wrong: wrong arrow. | Keep. |
| M10 CQ:1553 | An Orc walks 1883 then 1884 | NO OTHER SOURCE. ATT durotar:1204/984 lists only UNDEAD and TROLL (against; possibly a Classic list from before Orc mages). Zygor has no race condition. SP gives all Horde, not counted. | If wrong: Uthel'nay offers nothing, line shows 10-20. If taken out: no line for Orc mages. | Test: Orc mage of 10 at Uthel'nay and at Un'Thuwa. |
| M11 CQ:1560 | Skyborne walks the robe chain from Zaldimar at 15 | NO OTHER SOURCE, and two against: ATT stormwind:1291/1021/1136 HUMAN and GNOME; ZY-A:23485/23490 starts only Gnome and Human. | If wrong: refused at Goldshire, hint up to level 25. If taken out: no hint for a quest that may be open. | Test: High Order mage of 15 at Zaldimar, then at Jennea. Until then a choice for the owner. |
| M12 CQ:1564 | Skyborne walks the garment chain from Jennea at 26 | NO OTHER SOURCE. ATT is mixed: 1939 (stormwind:949) and 1940 HUMAN and GNOME, 1938 and 1942 ALLIANCE_ONLY. | If wrong: Jennea offers no 1939, hint up to 36. | Test: High Order mage of 26 at Jennea, then at Andromath without 1939. |
| M13 CQ:1562 | Orc may do the robe chain from Uthel'nay at 15 | CONFIRMED (MEASURED): ATT undercity:526, 408, 279, 632 all HORDE_ONLY, giver 7311 included; ZY-H:25362. | If wrong: a useless trip. | Keep. |
| M14 CQ:1566 | Orc may do the garment chain at 26 (no race limit) | NO OTHER SOURCE, one against: ATT orgrimmar:654, 852, 529 and the barrens:1606 say UNDEAD and TROLL. Zygor has no race condition. | If wrong: sent to Undercity for nothing, up to 36. | Test: Orc mage of 26 at Anastasia 4568. |
| M15 EN:7544 | The Exorcism has a timer | CONFIRMED (MEASURED): TEXT:7020, the demon returns if you take too long. The addon gives no number. | If taken out: no warning. | Keep. |
| M16 EN:7546 | Mana Surges have a timer | CONFIRMED (MEASURED): TEXT:7030, before the rift closes. No number in the addon. | As M15. | Keep. |
| M17 EN:7554 | Krellian at 41.0,53.1 | CONFIRMED (MEASURED): WH npc 8408 spawns 40.4-41.6, 52.4-53.8. | If wrong: wrong place in the text. | Keep. |
| M18 EN:7555 | Polymorph a Spitelash, wait a few seconds for clones | CONFIRMED (MEASURED): WH quest 9364; TEXT:19416. | If taken out: confusion. | Keep. |
| M19 EN:7555 | "Not in a raid group" | NO OTHER SOURCE: tooltip and quest text are silent. | If wrong: a needless limit. If taken out: possibly no credit in a raid group. | Test: one clone kill in a raid group. |
| M20 CQ:1458-1459 | Lydros is reached through the Dire Maul West door | NO OTHER SOURCE for the wing. ATT dire maul:187 and ZY-A:23827 confirm giver 14368 inside Dire Maul, without a map place. | If wrong: at the wrong door. | Keep, test: walk in by West and note where he stands. |
| M21 EN:7516-7517 | "The Cantation works once every 5 minutes" (Polestar or a Zygor tip, MAGE doc:670) | **CONTRADICTED as an item cooldown: 10 seconds.** MEASURED: DB2 ItemEffect 97868 (item 7308, spell 9095) CoolDownMSec 10000. The spell needs the focus "Mana Rift Disturbance" (183). Whether the rift has its own timer: not measured. | Waits five minutes between coffers for nothing. | Smallest fix: drop "once every 5 minutes". Test: use it twice, read the cooldown. |
| M22 EN:7510, 7512, 7515, 7518, 7522 | Details: Leper Gnomes at the hut, huts on the main Echo Isle, scroll behind the trainer (Horde), crates in Silver Stream, Carrion Recluses | CONFIRMED (MEASURED): TEXT:6886, 6904, 7042, 6942, 6956. "Drop it most" is DERIVED from the text naming that spider. | If taken out: less help. | Keep. |
| M23 EN:7511, 7516, 7517, 7538, 7541, 7547 | Details: bough does not sparkle, best in the cellar, the bridge, ten seconds at the bramble, the left shelf, Savage Owlbeasts drop it most | NO OTHER SOURCE in what was read (quest texts, DB2; Zygor notes may not be read). Origin is mixed: Polestar or Zygor tips. | If wrong: searches in the wrong spot or waits a little. | Keep as tips, check while playing each step. |

## Warlock (doc-marked, no code comment names Polestar)

| id, file:line | what the addon does | verdict and evidence | what a player notices | advice |
|---|---|---|---|---|
| W1 EN:7268 | Unlit Torch, light at a campfire, burns 5 minutes, fire as distraction | CONFIRMED (MEASURED): DB2 190307 needs focus 4 "Cooking Fire"; 190308 Burning Torch DurationInInventory 300, "fiery distractions", Torch Toss. | If taken out: stuck at the house. | Keep. |
| W2 EN:7268 | Table outside, cart, two archaeologists run, figurine upstairs, fire at Zoram Strand | NO OTHER SOURCE: TEXT:19481 names only the house; no DB2 row found for the cart (name search, no positive control). | If wrong: stuck. If taken out: also stuck. | Keep, test: do 65602 once. |
| W3 EN:7273 | Scarf drops "about 1 in 20" | NO OTHER SOURCE. | If wrong: wrong expectation. If taken out: nothing lost. | Drop the number, or count kills. |
| W4 CQ:304, EN:7273 | Scarf is farmed at Fallen Sky Lake | CONFIRMED (MEASURED lake, DERIVED mobs): TEXT:19487 names the lake and its bog beasts. | If wrong: wrong lake. | Keep. |
| W5 CQ:291-293, 447, 461, 469 | Incubus bindings use the same circles as voidwalker and succubus in each city | CONFIRMED (MEASURED): DB2 SpellCastingRequirements + SpellFocusObject. Figurine = Heartswood Core = 83 Stormwind; Scarf = Dogran's Pendant = 203 Orgrimmar; Lovers' Hearts = Pure Hearts = 43 Undercity. | If wrong: wrong arrow. | Keep. |
| W6 CQ:393, spell 23161 | 7631 teaches Dreadsteed | CONFIRMED (MEASURED text, DERIVED id): TEXT:13910 teaches the summon; DB2 SpellEffect 23160 teaches 23161. | If wrong: chain ends at the wrong moment. | Keep. |
| W7 CQ:484-487 | One 7562 trainer per race: Spackle, Jubahl, Kurgul, Martha | NO OTHER SOURCE for the race split. ATT burning steppes:271 has givers 6382 and 5520 without races; ZY-A:24989 Spackle, ZY-H:26808 Kurgul for the whole faction; Martha only in older docs. | If wrong: a longer trip, or no quest at Martha. | Keep as a choice. Test: Undead warlock of 60 at Martha. |
| W8 CQ:439-469 | You can do succubus and incubus both | CONFIRMED (DERIVED): ATT branches 1738 and 65602 both from 1716 (the barrens:1208, stormwind:1981), 1508 and 65601 both from 1507, no altQuests between the branches; QuestV2 bits differ. | If wrong: second chain stays shown for good (spell chain). | Keep. |

## Method

1. Read the nine lines, their code and the engine (MyChains, Ready, Step, NowSkip), the named docs and POLESTAR_DATA.
2. Split each line into facts. From the docs only facts that are built and that the doc gives Polestar (alone, or as
   "Polestar and Zygor tips") were added.
3. Four read-only scripts through the front door: pf_dump.py, pf_more.py, pf_last.py, pf_focus.py (all in this scratchpad).
   No Polestar or FlowUp file, page or repository was opened.
4. Race masks: bit number = ChrRaces.PlayableRaceBit of build 71037 (Human 0, Orc 1, Dwarf 2, Night Elf 3, Undead 4,
   Tauren 5, Gnome 6, Troll 7, High Order 32, Windshaper 33). Only bits of races in CharBaseInfo are read; other bits are
   ignored, so 0xb1354c4d/0x55155555 reads as the five Alliance races.
5. Cost: about 65 tool calls, over the target of 50.

### Independence

- POLESTAR_DATA names Polestar's inputs: player recordings, GPL data (forever-db), Questie, EG Link, unnamed websites.
  Because the websites are unnamed, a shared origin with Wowhead cannot be excluded. Wowhead is used here only for texts
  and spawns, next to other evidence except M17.
- Spoken's Compendium header says races, classes and prev come partly from Efficient Games' data (CC BY 4.0). POLESTAR_DATA
  lists EG Link (CC BY 4.0, quest facts). That they are the same publisher is DERIVED from name and licence. So Spoken's
  races, prev and ender confirm nothing here. Its QuestText is used as Blizzard's words (92484 is word for word the cache).
- Questie, ForeverQuestLog, questing.wiki's Questie records, azeroth.wiki, the Codex and ForeverDB are not used to confirm.
- AllTheThings: 183 files searched, 0 hits for Polestar or Questie (control in the same run: isBreadcrumb in 45 files,
  ALLIANCE_ONLY in 103; the one "fficient" hit is the word "insufficient"). Its Classic quests, Zygor's and Questie's may
  share one Classic dataset. Its new Forever rows (timeline ADDED_1_60_1) are less exposed to that.

### Controls

- Cache fields: 92479 Human, 98576 Orc, 3092 Tauren, 94003/94006 both Skyborne match Spoken and ATT; minimums 2
  (92481/92482/92483) and 10 (94003) match ATT.
- How reliable database race masks are, against the cache: Spoken 798 same / 441 different; ATT 1524 / 522. For Classic
  ids Spoken 301/380 and ATT 300/375 (many are "every race" in the cache where the databases say one faction). Of 14
  cached Classic quests with a narrow ATT race list, 11 keep it and 3 are open to every race. So M10-M14 cannot be settled
  from a Classic race list.
- Zygor: 54 files, 3227 quest ids parsed; the 94502 route was found in the same run in which rogue 78xxx gave none.
- Wowhead tooltips: npc 233 gave Farmer Saldean in the same run.
- Entrance conversion: exact for Shadowfang. The corpse entrance of Scarlet Monastery, Dire Maul and Uldaman differs
  from a door pin, so this is no general door measurement.

### By-catch (not counted)

- B1 CQ:971-972: Zygor now has an Alliance "Shaman Class Quests" guide (ZY-A:22099). Red waterskin 74.62,62.36 (:22211)
  against ours 68.6,60.6; blue 34.24,47.72 (:22220) against 32.7,50.6. Our values are "guide only"; by the coordinate rule
  Zygor wins. The header at CQ:909 and :951 is stale.
- B2 CQ:446: ATT stormwind:1981 gives 65602 to Gakin 6122, the code to Takar. TEXT:19481's road north into Ashenvale fits
  Takar (DERIVED). Test at both.
- B3 CQ:1593: ATT dustwallow marsh:323 makes 1951 the source of 1948, the code says 1947. Test at Tabetha.
- B4 CQ:1563: neither ATT nor Zygor lists Cain Firesong as giver of 1959 (17 Nov: azeroth.wiki and Polestar).
- B5 CQ:424: CACHE 1485 is open to every race, minimum 1, and teaches through 7763 (Summon Imp): the Troll imp route is fine.

### Not checked

- Anything in game. The client cache holds no rogue quest of this list and none of the Classic mage quests, so their
  minimums and masks are not client-measured.
- Server prerequisites and class masks: not in DB2 or cache. QuestV2CliTask for 71037 returned HTTP 400.
- Wowhead page infoboxes: one page fetched (forever/quest=1861), it showed no level, race or prerequisite.
- Poisons "not from the trainer" (ForeverTrainer.lua:40, ROGUE doc:56, Polestar only): outside this module, not re-checked.
- Polestar claims that were not built: level 16 pointers excluding each other, Felsteed after felhunter, a Lago variant of
  Seeking Strahad, 1939 skipped, teleports without quests, Water Totem "in your bags".
- Zygor notes and texts (not allowed), other languages' strings, and the docs of the other classes.
- Empty DB2 name and BroadcastText searches (cart, Xelthos) and the empty SpellCooldowns lookup had no positive control:
  they prove nothing.
