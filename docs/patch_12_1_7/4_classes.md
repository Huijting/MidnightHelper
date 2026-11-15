# 12.1.7: klassen en spells (speuropdracht 4 van 5)

Gemaakt op 15 nov 2026. Alleen gelezen, niets in de code veranderd.
Vergeleken: **live 12.1.5.70783** (4 nov) tegen **PTR 12.1.7.70892** (12 nov). Bron: Blizzards eigen DB2-tabellen via
wago.tools (`tools/gamedata.py`, cache). Bij elke bewering staat **GEMETEN** (gezien in een bron met naam en datum) of
**AFGELEID** (beredeneerd).

## Kort

1. **Geen enkele klasse-spell verandert in 12.1.7.** Geen talent erbij, geen talent eraf, geen nieuwe naam, geen andere
   cooldown, lading, cast-tijd, duur, bereik, kosten of dispel-type. Ook de getallen in de effecten zijn gelijk. Er zijn
   maar vier kleine uitzonderingen, en die raken MH niet (zie "Per klasse"). GEMETEN (DB2 70783 tegen 70892).
2. **Alle 1053 spell-id's van MH bestaan nog op de PTR en heten hetzelfde.** Er valt er geen een weg. GEMETEN
   (`Modules/SelftestData.lua`, lijst R + B).
3. **Geen speelkaart- of toetsregel wordt fout door 12.1.7**, voor zover de data nu laat zien. AFGELEID uit punt 1 en 2.
4. **Blizzard heeft nog geen klassenotities voor 12.1.7 gepost.** De ontwikkelnotities van 15, 22 en 29 okt hebben geen
   kopje Classes. Op het forum vragen spelers erom (29 okt tot 13 nov), zonder antwoord van Blizzard. GEMETEN.
5. **Let op bij datamining-sites.** Wat MMO-Champion in PTR-build 70668 als "Spell Changes" toonde (Regrowth, Swiftmend,
   Explosive Shot enz.), is de **live-hotfix van 27 okt**. Die staat ook in live-build 70688 en is dus al live.
   GEMETEN (DB2 van beide builds en Blizzards bericht van 23 okt).

## Hoe ik gemeten heb, en waarom ik het geloof

- Tabellen live tegen PTR: SpellName, Spell (tekst), SpellEffect (alle kolommen), SpellCooldowns, SpellCategories +
  SpellCategory (ladingen), SpellMisc (cast-tijd, duur, bereik), SpellPower (kosten), SpellAuraOptions (stapels, proc),
  de talentbomen (TraitDefinition, TraitNodeEntry, TraitNode, TraitNodeXTraitNodeEntry, TraitTreeLoadout, TraitSubTree,
  TraitCond, SpecSetMember), SpecializationSpells en ChrSpecialization. Gekeken naar: alle MH-id's, alle 3615 spells in
  de talentbomen, alle 491/494 basis-spells per spec, en **alle spells met een spelersklasse** (SpellClassOptions), dus
  ook PvP-talenten en de spells die een knop aanroept.
- **Controle 1:** 6603 Auto Attack staat in beide builds. GEMETEN.
- **Controle 2, de belangrijkste:** hetzelfde script op twee live-builds rond de hotfix van 27 okt (12.1.5.70575 tegen
  12.1.5.70688) vindt die hele hotfix terug: Regrowth 8936 (coëfficiënt 5,36 → 5,90), Verdancy, Improved Swiftmend
  (30 → 40), Trick Shots (75 → 85), Explosive Shot 212431, Volley, Feral, Fire, Subtlety, Unstable Affliction, Rain of
  Fire, plus de PvP-getallen. Het script ziet dus klasse-wijzigingen als ze er zijn. GEMETEN.
- **Grens 1:** wago geeft de bestanden van een build. Een hotfix die later komt, zie ik waarschijnlijk niet. Bewijs: de
  hotfix van 27 okt staat niet in de data van 70575, hoewel die build toen live was. AFGELEID.
- **Grens 2:** de PTR is niet af. Blizzard kan klassenwijzigingen nog sturen voor 1/2 dec. Wat de server zelf regelt
  (niet in DB2), zie ik niet. AFGELEID.

## Per klasse

| Klasse | MH-bestand (toetsen) | MH-id's van deze klasse | Talenten live/PTR | Wat verandert in 12.1.7 | |
|---|---|---|---|---|---|
| Warrior | `KeybindRoles_Warrior.lua` | 36, 0 veranderd | 341 / 341 | niets | GEMETEN |
| Paladin | `KeybindRoles_Paladin.lua` | 38, 0 veranderd | 265 / 265 | niets voor spelers (zie onder) | GEMETEN |
| Hunter | `KeybindRoles_Hunter.lua` | 33, 0 veranderd | 238 / 238 | alleen tekst van Blood Fletching (zie onder) | GEMETEN |
| Rogue | `KeybindRoles_Rogue.lua` | 45, 0 veranderd | 241 / 241 | niets | GEMETEN |
| Priest | `KeybindRoles_Priest.lua` | 39, 0 veranderd | 252 / 252 | niets | GEMETEN |
| Death Knight | `KeybindRoles_DeathKnight.lua` | 37, 0 veranderd | 224 / 224 | niets | GEMETEN |
| Shaman | `KeybindRoles_Shaman.lua` | 47, 0 veranderd | 319 / 319 | Resto: de vaste spec-passive (zie onder) | GEMETEN |
| Mage | `KeybindRoles_Mage.lua` | 37, 0 veranderd | 238 / 238 | Fire: PvP-talent Glass Cannon (zie onder) | GEMETEN |
| Warlock | `KeybindRoles_Warlock.lua` | 36, 0 veranderd | 327 / 327 | niets | GEMETEN |
| Monk | `KeybindRoles_Monk.lua` | 41, 0 veranderd | 357 / 357 | Mistweaver: de vaste spec-passive (zie onder) | GEMETEN |
| Druid | `KeybindRoles_Druid.lua` | 56, 0 veranderd | 327 / 327 | niets | GEMETEN |
| Demon Hunter | `KeybindRoles_DemonHunter.lua` | 40, 0 veranderd | 232 / 232 | niets | GEMETEN |
| Evoker | `KeybindRoles_Evoker.lua` | 35, 0 veranderd | 256 / 256 | niets | GEMETEN |

Ook de hero-talentbomen van de klassen zijn gelijk: er komt geen hero-boom bij of af. GEMETEN.
De rassen-spells (`KeybindRoles_Racials.lua`) vallen onder "geen klasse" hieronder: ook die veranderen niet. GEMETEN.

De vier kleine uitzonderingen, met de ruwe cijfers:

- **Hunter, Marksmanship: Blood Fletching 1319011.** Alleen de tekst: "bleed damage" wordt "Bleed damage". Geen getal
  anders. MH gebruikt dit id niet. GEMETEN.
- **Mage, Fire: Glass Cannon 390428.** Dit is een **PvP-talent** (PvpTalent 5495, spec 63). Effect 1 gaat van 25 naar 20.
  De tekst zegt: "Fireball, Scorch, and Ignite damage is increased by $s1%". Dus waarschijnlijk 25% → 20%. MH gebruikt
  dit id niet. Getal GEMETEN, betekenis AFGELEID.
- **Monk, Mistweaver: de vaste passive 428200.** Effect 12 (index 11), een -32 op label 3448, dat is Celestial Conduit
  443039. Alleen het soort aanpassing verandert (MiscValue 6 → 0). Dit effect kwam erbij met de hotfix van 27 okt; de
  PvP-notities noemden toen "Mistweaver Conduit". Wat het precies doet: AFGELEID, niet zeker. MH gebruikt 428200 en 443039
  niet. Cijfers GEMETEN.
- **Shaman, Restoration: de vaste passive 1256945.** Twee +20-effecten (index 15 en 16) wisselen van doel. Index 15 gold
  live voor label 7096 (Healing Surge 447415, Chain Heal 447433, Healing Wave 1223391) en geldt op de PTR voor de
  Healing Stream-familie (Healing Stream 5672 en 273847, Healing Stream Totem 52042, Poison Cleansing, Stormstream
  Totem). Index 16 houdt alleen label 7443 (Stormswell 1268684). Ook deze effecten kwamen met de hotfix van 27 okt
  ("Resto Shaman totems" bij PvP). AFGELEID: een correctie van die PvP-buff. Cijfers GEMETEN. MH gebruikt deze id's niet.

Nieuwe spells met een spelersklasse op de PTR, maar geen klasse-spells om te spelen (GEMETEN; doel AFGELEID):
- Paladin-set: **1286661 Storyteller's Borrowed Power**, "Ask Li Li to greatly heal and cleanse your current target so you
  can focus on the story." Hoort bij de nieuwe Lorewalking-verhalen.
- Mage-set: **1285931 Teleport to Dalaran [DNT]** en **1292908 teleport (DNT)**. Interne spells, vermoedelijk voor het
  Jaina-verhaal.
- Hunter-set: **1328528 [DNT]**, zonder tekst.

## De MH-spell-id's naast de PTR gelegd

Lijst: `ns.SELFTEST_IDS.spell` in `Modules/SelftestData.lua`, R + B samen = **1053 id's**. GEMETEN.
- Weg op de PTR: **0**. Andere naam: **0**. GEMETEN.
- 520 id's horen bij een klasse: **0 veranderd**. GEMETEN.
- 533 id's horen bij geen klasse (bazen, rassen, items, overig): **7 veranderd**, allemaal spells van bazen. GEMETEN.

| Id | Spell | Wat verandert (PTR) | Waar in MH | Gevolg voor MH |
|---|---|---|---|---|
| 1286922 | Icebound Flames | tekst: "Scrollsage Iku" → "Scrollsage Epu" | `Locales/RaidTips.lua`, `RAID_BOSS_LOSTEXPLORERS_HEALER` | geen: MH zegt al "Epu" (Engelse blok, regel 59). GEMETEN |
| 1295854 | Shredding Shards | tekst: Iku → Epu | `RAID_BOSS_LOSTEXPLORERS_TANK` | geen: MH zegt al "Epu" (regel 60). GEMETEN |
| 1291759 | Shell Spin | tekst: "First Mate Nama" → "First Mate Nema" | `RAID_BOSS_LOSTEXPLORERS_DPS` | geen: MH zegt al "Nema" (regel 58). GEMETEN |
| 1296092 | Mighty Thud | tekst: Nama → Nema | `RAID_BOSS_LOSTEXPLORERS_STEPS` (regel 53, en in de andere talen) | geen: MH zegt al "Nema, {SPELL:1296092}". GEMETEN |
| 1303406 | Abyssal Grasp | tekst: "any players this effect is not removed from" → "any players who still have this effect" | `RAID_BOSS_KITHIX_HEALER` | geen: zelfde betekenis. AFGELEID |
| 1318467 | Negation | tekst: een komma erbij ("Upon expiration, their form...") | `RAID_BOSS_KITHIX_TANK` | geen. GEMETEN |
| 1286441 | Spiritcackle | de Mythic-uitzondering van effect 2 (Dummy, waarde 2) valt weg; Mythic krijgt nu ook 1 | `RAID_BOSS_COILEDALTAR_STEPS` ("Kill the {SPELL:1286441} adds and interrupt their fear") | tip blijft kloppen. Wat die "2" telde, weet ik niet. Wijziging GEMETEN, gevolg AFGELEID |

**Welke speelkaart- of toetsregel wordt fout?** Geen gevonden. De toetsindelingen (`KeybindRoles_*.lua`), de
"zo speel je"-kaarten (`PlayCards.lua`, `PlayCardWindow.lua`, 685 `PLAYCARD_*`-sleutels in enUS), de heal-cooldowns
(`HealerCooldowns.lua`), de buff-melding (`MissingBuff.lua`), de dispel-hulp (`DispelHelper.lua`) en de interrupts
(`InterruptMacros.lua`, `InterruptMacrosData.lua`, `InterruptScore.lua`) wijzen naar id's uit die ene lijst, en daarvan
verandert geen klasse-spell. Ook geen klasse-spell zonder MH-id krijgt een andere naam (0 van alle spells met een
spelersklasse), dus een spellnaam in een kaarttekst wordt ook niet oud. GEMETEN.
⚠️ Wat ik **niet** gecontroleerd heb: of de getallen in MH vóór 12.1.7 al klopten. Ik heb alleen gemeten dat 12.1.7 ze
niet verandert.

## Nieuw op de PTR, niet voor gewone klassen: Talebound

- In DB2 krijgt klasse 15 **"Traveler"** (bestandsnaam `TRAVELER`) vier specs: 1492 Traveler, 1496 **Witch**, 1497
  **Slayer**, 1498 **Inquisitor**. Op live had klasse 15 nog geen specs. GEMETEN.
- Talebound is een losse spelmodus met eigen personages. Je kiest daar Witch, Slayer of Inquisitor; je gewone personage
  gaat er niet in. GEMETEN (Wowhead-gids "Talebound - Standalone Game Mode in Patch 12.1.7"; warcraft.wiki.gg "Talebound";
  Talebound Wiki 9 nov 2026).
- `MidnightHelper.toc` zegt `## AllowLoadGameType: standard`. Als Talebound een ander speltype is, laadt MH daar dus niet.
  AFGELEID, niet gemeten. **Test voor Rob op de PTR:** maak een Talebound-personage en typ `/mh`. Reageert MH?
- Laadt MH daar toch, dan geeft `UnitClass("player")` vermoedelijk `TRAVELER`. De drie plekken die ik las, zoeken per
  klasse in een tabel en geven dan niets terug: `MissingBuff.lua:248-256`, `HealerCooldowns.lua:324-327`,
  `KeybindAutoMap.lua:312-313`. AFGELEID; de tientallen andere plekken met `UnitClass` heb ik niet gelezen.
- Eén naam botst: de Slayer heeft een eigen **Explosive Shot (1253574)**, niet die van de Hunter (212431). Alleen een
  probleem als een module op naam zoekt. AFGELEID.
- Nieuwe talentbomen 1160 tot 1261, met deelbomen Ardenweald, Revendreth, Stormsong en Val'sharah (boom 1256) en Energy,
  Mana, Health en Omni (boom 1163). Geen ervan hoort bij een spelers-spec. GEMETEN. Waar ze voor zijn: AFGELEID, waarschijnlijk
  Talebound.

## Al live, dus niet van 12.1.7 (hotfix 27 okt)

Staat in live-build 70688 (31 okt) en in PTR-build 70668 (29 okt), en in Blizzards bericht "Class Tuning Incoming -
October 27" (23 okt). GEMETEN:
Feral (spec-aura 70 → 78), Fire (spec-aura 23 → 29), Subtlety (29 → 19, Fazed 7% → 5%), Regrowth +10%, Verdancy +60%,
Improved Swiftmend 30% → 40%, Trick Shots 75% → 85%, Explosive Shot +10%, Volley +10%, Unstable Affliction +20%,
Rain of Fire +20%, plus PvP-getallen. In hetzelfde buildpaar kreeg **Deathmark 360194** (een MH-id) dispel-type 11 → 0.
In de enUS-tekst van MH staat bij Trick Shots en Swiftmend geen percentage. GEMETEN (zoekpatroon raakte 3 regels met die
namen, geen enkele met een %).

## Bijvangst buiten klassen (voor de andere speuropdrachten)

- **Omnium Folio:** twee nieuwe runes op de PTR: **1324888 Rune of Empowerment** en **1324904 Rune of Critical Mass**
  (plus hulpspells, o.a. 1325089 tot 1325566). Live heeft ze niet. GEMETEN (SpellName 70783 tegen 70892). Blizzard
  noemt ook twee extra Motes of Omnial Inquiry. GEMETEN (ontwikkelnotities 15 okt). `Modules/OmniumFolio.lua` regel 3
  zegt dat het rune-overzicht 5 rijen toont. Of dat moet groeien, heb ik niet uitgezocht.
- **API:** de server- en spawn-delen van GUID's (ook cast-GUID's) worden "in a future build of 12.1.7" vervangen door
  waarden die alleen binnen één sessie gelijk blijven. GEMETEN (warcraft.wiki.gg, Patch 12.1.7/API changes). MH gebruikt
  een cast-GUID alleen als event-argument binnen een sessie (`InterruptEventProbe.lua:56-62`). Dat blijft werken.
  AFGELEID.

## Open, en hoe het later opnieuw te meten

- Blizzard stuurt klassewijzigingen soms laat. Meet bij elke nieuwe PTR-build en op releasedag opnieuw.
- Het script staat (buiten de repo) in de scratchpad:
  `C:\Users\RobHu\AppData\Local\Temp\claude\E--World-of-Warcraft--retail--Interface-AddOns\f5f259a6-b38e-526f-86e4-08d1f38cb4f3\scratchpad\t4_diff.py`.
  Job-regel: `scratch t4_diff.py <live-build> <ptr-build>`. Eerst de controle draaien:
  `scratch t4_diff.py 12.1.5.70575 12.1.5.70688` moet de hotfix van 27 okt laten zien.
- Hotfixes na een build zie ik waarschijnlijk niet in wago (zie "Grens 1").

## Bronnen

- wago.tools DB2-CSV, builds 12.1.5.70575, 12.1.5.70688, 12.1.5.70783, 12.1.7.70493, 12.1.7.70668, 12.1.7.70740,
  12.1.7.70892 (gelezen 15 nov 2026, via `tools/gamedata.py`).
- Blizzard, "Midnight: Echoes of the Worldcore PTR Development Notes" (Linxy; 15, 22 en 29 okt 2026), via bluetracker.gg,
  seramate.com en arctium.io.
- Blizzard-forum, "Where are the class/spec changes?" (29 okt tot 13 nov 2026), geen blauw antwoord.
- Blizzard-forum, "Class Tuning Incoming - October 27" (Linxy, 23 okt 2026); Wowhead en Icy Veins over die hotfix (28 okt 2026).
- MMO-Champion, "Patch 12.1.7 PTR - Build 70668".
- thewowdb.com, "Retail PTR Patch 12.1.7 build 70892" (12 nov 2026): 137 spells, Talebound en Winter Veil.
- warcraft.wiki.gg, "Patch 12.1.7/API changes" en "Talebound".
- Wowhead, "Talebound - Standalone Game Mode in Patch 12.1.7"; Talebound Wiki, "Getting started" (9 nov 2026).
