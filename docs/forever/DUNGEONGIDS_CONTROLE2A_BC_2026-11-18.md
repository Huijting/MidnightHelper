# Tweede controle bazengids Forever stap 2a, deel B + C (18 nov 2026)

Gecontroleerd: `dg2a_B.lua` (Uldaman 70, Zul'Farrak 209, Maraudon 349) en `dg2a_C.lua` (City of Dalaran 2959,
The Drowned City 2970, Krol'dok Stronghold 3039, Alcaz Prison 2994). Code niet bekeken (niet mijn deel). Repo niet
aangeraakt, `probe_job.txt` niet aangeraakt. De `_notes.md` pas gelezen nadat dit oordeel klaar was (onderaan).
G = GEMETEN (gezien in een genoemde bron met datum), A = AFGELEID.

## Uitkomst

**0 FOUT, 12 RISICO.** De id's, namen en buit kloppen allemaal (G). De risico's gaan over: een ontbrekende stap
(Fel Ancient), een tip die niet past bij hoe de klap werkt (Gahz'rilla), namen per taal (npc-naam is niet de
DB2-naam), volgorde/woordkeus in Alcaz, en een reeks zinnen die (bijna) letterlijk uit een gids komen.

## Wat ik zelf heb nagemeten en wat klopt (G, 18 nov 2026)

- **DB2 DungeonEncounter** (wago.tools, Forever 1.60.1.70959), alle 7 maps in een query: 49 rijen. Elke `encounter`
  hoort bij de juiste baas en map. OrderIndex klopt met wat de kop-commentaren zeggen (Dalaran: Anomaly 0 ... Lyn 6000,
  Atrexis 7000, Mana Wraith 8000, Shade 9000; Alcaz: Wrex 0, Ca'zass 500, Katerina 625, Questioner 750, Blazeroar 1000;
  Krol'dok 1000-5000; Drowned 0-6000; Maraudon Gizlock 1500, ook in Classic Era 1.15.9.70576).
- **Namen per taal uit DB2** (deDE, frFR, esES, esMX, ptBR, ruRU): alle 49 `names` in beide bestanden zijn gelijk aan
  DB2 (elke taal apart opgevraagd), behalve waar het bestand bewust WHT gebruikt (encName en bazen zonder DB2-rij).
- **WHT npc** (nether.wowhead.com/forever, 18 nov 2026): alle npc-id's geven de juiste naam (B: 32, C: 36 incl.
  staging-kopieen, extraNpc's 6907/6908/7797/255707/260274). Rare/Elite-labels kloppen. Alle WHT-namen per taal voor
  encName-bazen en bazen zonder DB2-rij (Arcanic Enigma, Deathless Marrow, War Handler Ashka, Overlord Mugg, Bossman
  Toof, Umbra, Gill, Braxton, Kroog, Sergeant Bly, Zerillis, Sandarr, Dustwraith, Meshlok) = data, ook esMX.
- **Buit**: alle 22 items via de volledige tooltip (`scratch dg_items.py`): naam, slot, wapentype, stats en "Dropped by"
  kloppen met `boss`. Main Hand/One-Hand/Off Hand goed benoemd (9419 Main Hand mace, 9467/17752 One-Hand dagger, 17738
  Off Hand fist, 274998 Main Hand dagger). Rollen passen bij de stats (A).
- **Zarmok-spin = bloeding** (G): DB2 SpellEffect 1280011 "Rending Whirl": aura 3 (periodic damage), EffectMechanic 15
  (bleed). De regel "his spin makes everyone around him bleed" klopt dus.
- **Inhoud**: per baas tegen minstens een Forever-bron gelegd (lijst onderaan). Bevestigd o.a.: Lyn-oproeping
  (blauw kristal = IV 18 okt "a blue crystal sitting on top of a table"), Shade-portaal via Archmage Modera
  "at the bottom level of the Violet Citadel" (IV), Unstable Sentinel 25 yards (IV + WH 9 nov), Mana Devourer bij de
  Violet Hold (IV + WH), Glowing Pearls na Var'Taka en Dreadrise (WH 14 nov + WT), Primeval via alle Undying Offerings
  (WH + IV 17 nov), Krol'dok-route en Toof-brug (WT), Questioner-sleutel voor de gevangene (WT + MOBU), Theka-vorm
  immuun voor fysiek + shadow (HP + CQ 07 nov), Bly/Weegli (HP + CQ), Archaedas-altaar met vier Stone Keepers
  (Classic: wow-pro 2006, Wowhead Classic-commentaar, cmangos #2058; geen Forever-bron spreekt het tegen).

## RISICO's (met reparatie)

### R1. Namen per taal: npc-naam is soms niet de DB2-encounternaam (G)
Wat de speler op het naamplaatje ziet, is de npc-naam. WHT (18 nov) geeft voor deze bazen een andere naam dan DB2:
- **C, nieuw:** Krol'dok **Nar'gurk deDE**: npc 258964 deDE = **"Nar'guk"** (WHT, vers opgehaald), DB2 3449 deDE =
  "Nar'gurk". Alle andere talen gelijk. Niet in de C-notes.
- **B** (staat al in de B-notes, ik vond hetzelfde los daarvan): frFR 7 (Ancien Gardien des pierres, Galgann
  Firehammer, Grimlok, Sorcier-docteur Zum'rah, Nekrum Mâchetripes, Noxxion, Artisan Gizlock) en ruRU 6 (Древний
  Хранитель Камня, Гидромант Велрата, Темный жрец Шезз'зиз, Вождь Укорз Песчаная Плешь, Селебрас Проклятый, Сель).
- Forever `Creature` DB2 heeft maar 189 rijen en geen van deze id's (G), dus de client-naam is niet uit DB2 te halen.
  FDJ (`Content_Verified.lua`, audit 11 nov) mengt beide: deDE "Nar'guk", ruRU "Сель"/"Селебрас", maar frFR "Noxcion".
- **Reparatie:** de bouwchat kiest één regel en past die overal toe. Mijn voorstel (A): het naamplaatje telt
  (Robs regel "clientnaam wint"), dus deDE 3449 = "Nar'guk"; voor B dezelfde keuze, of per baas een `measure`
  ("which name does a frFR/ruRU client show?"). Zeker weten kan alleen op een frFR/ruRU/deDE-client.

### R2. Fel Ancient: een stap ontbreekt (wat moet je doen)
Data: "Stands in the middle of the city behind a mana barrier; talk to the npc next to it to open it."
Bronnen: CQ Dalaran (Updated 07 Nov 2026): "waits behind a magic barrier in the middle of the city with Suffused
Treants in front of it. Kill the treants, then talk to Magus Fansy Goodbringer just south of the barrier".
wowforever.be (geen datum): "among Suffused Treants ... Magus Fansy Goodbringer on the east side takes it down".
ForG (forg.gg, "Reviewed Nov 9"): "Kill the Suffused Treants in front of the barrier ... talk to the mage NPC".
WH (9 nov) en WFA noemen alleen het praten. Of de treants een voorwaarde zijn of alleen in de weg staan: niet gemeten.
De kant (zuid/oost) verschilt per bron, dus geen kant noemen.
**Nieuwe tekst:** `"Stands in the middle of the city behind a mana barrier: kill the treants in front of it, then talk to the mage beside it."`

### R3. Gahz'rilla: de tip past niet bij een klap omhoog
Data does: "His slam throws everyone near him high into the air; the fall hurts." Tip: "Fight him with a wall behind
you, so nobody is thrown far."
- G: DB2 SpellEffect 689227 (spell 11902 Gahz'rilla Slam, Forever): Effect 98 (knockback), EffectBasePointsF 350,
  EffectMiscValue_0 20. A: in de gangbare server-formule is dat 35 omhoog en 2 opzij, dus vooral recht omhoog (de
  does-regel klopt). Een muur achter je helpt niet tegen een val; "so nobody is thrown far" klopt dan niet.
- Bronnen: CQ ZF (07 Nov): "knocks everyone near him into the air ... the tank's back to a wall". HP (hearthproof, geen
  datum): "throws them a long way. Fight him against a wall, or in the water". MOB ZF: "the entrance to the boss room
  is an archway, and if you tank the boss in the archway" (plafond houdt de worp tegen).
- **Reparatie (kies):** (a) minimaal, 2x CQ+HP: `"Tank him with your back to a wall and keep the healer at range."`
  (b) beter passend bij de klap, 1x MOB + 1x HP: `"Fight him under the arch at the entrance or in the water: the roof or the water spares you the fall."`

### R4. Alcaz: de Questioner staat als derde, maar de tip zegt "als laatste"
WH Alcaz (Updated 2026/11/15): "WARNING: Do NOT kill this boss before clearing out the rest of the dungeon first!"
WT Alcaz (geen datum): Questioner "on your way out ... making him the real final boss"; WT-volgorde Ca'zass, Wrex,
Katerina, Zarla/Blazeroar, Questioner. apocanow (13 nov): de gevangene geeft de quest alleen als de Questioner nog leeft.
**Reparatie:** Questioner achter Blazeroar zetten (volgorde Ca'zass, Wrex, Katerina, Blazeroar, Questioner). Tekst kan blijven.

### R5. Alcaz Wrex: "opens the stairs"
Data: "Drops the keyring that opens the stairs to the lower floor." CQ (08 Nov): "opens the locked door to the lower
floor"; apocanow: "the Maximum Security Door"; WT: "explore the dungeon's right side that starts with its doors locked"
(ook de deur van de Questioner zit volgens WT dicht). FDJ zegt "trap" (C-notes), dus niet zeker fout.
**Nieuwe tekst:** `"Drops the keyring that opens the locked door to the lower floor."`

### R6. Alcaz Katerina: "jumps on" en een extra bron
- Data: "Jumps on a random player and stabs them." WT Alcaz: "She'll teleport behind random players to backstab them";
  MOBU (16 nov): "teleports behind ranged players and backstabs them"; WH (15 nov): "Grievous Garrote" op een willekeurige
  speler, bloedt door "until they are healed to above 90% HP".
  **Nieuwe tekst:** `"Appears behind a random player and stabs them."`
- WT Alcaz is een bron die deel C niet gebruikte. WT: "Deal with the ads first, then fight Katerina" -> de tip
  ("Chaplains first") heeft dan 2 bronnen (WH + WT): `one` mag `false`. WT zegt ook "she doesn't deal a lot of damage":
  samen met WH en MOBU spreken nu drie bronnen de vuur-meting van CQ tegen (de `measure` kan blijven, maar weegt licht).

### R7. Drowned Dreadrise: "the second Glowing Pearl"
Var'Taka en Dreadrise staan aan weerszijden van het midden (apocanow 13 nov, WT); de volgorde is vrij. Wie Dreadrise
eerst doet, klikt daar de eerste parel.
**Nieuwe tekst:** `"After him, click the other Glowing Pearl."`

### R8. Drowned Umbra: kill-volgorde ontbreekt
WH (14 nov): "Focus the boss down fast and then take care of the remaining adds". WFA: "Kill Umbra first; the pack is
easier once he is down." IV (17 nov): de murlocs zijn het moeilijkste deel (dat staat al in de tip).
**Nieuwe tip:** `"Let the tank hold every murloc and kill Umbra first; the murlocs are the real danger."`

### R9. Maraudon Celebras: wat moet je doen voor de scepter
Data: "Afterwards Celebras the Redeemed makes the Scepter of Celebras from the rod and the diamond: a shortcut to Earth
Song Falls." Dat gebeurt alleen als je met hem praat, met de quest Legends of Maraudon (van Cavindra, buiten de
dungeon) en daarna zijn ritueel-quest (wowf.io, geen datum: "Talk to him with the Celebrian Rod and the Celebrian
Diamond to finish Legends of Maraudon, then stay with him through the ritual"; Zockify: start bij Cavindra buiten).
**Nieuwe tekst:** `"Afterwards talk to Celebras the Redeemed: with the quest from Cavindra outside, he makes the Scepter of Celebras from the rod and the diamond, a shortcut to Earth Song Falls."`

### R10. Maraudon: deel van Celebras
`part = "Poison Falls"`. CQ (15 Nov): "Celebras waits at the north end of Earth Song Falls". FDJ `Core/Journal.lua`
r.717: Celebras op floor 2 (uiMapID 281), samen met Landslide/Gizlock/Rotgrip/Theradras. wowforever.be en wowf.io-tekst:
Poison Falls. De labels zijn eigen labels, dus niet fout; wel twijfel. Geen reparatie nodig, eventueel een `measure`.

### R11. Zinnen te dicht bij de bron (letterlijk of bijna)
Letterlijk (L) of bijna (B). Allemaal kort en algemeen, maar Rob wil foutloos:
| Waar | Data | Bron | Nieuwe tekst |
|---|---|---|---|
| ZF Theka does 1 | "area damage pulls them all in" | HP letterlijk (L) | `"Stands among many scarabs; any area attack brings the whole swarm."` |
| ZF Theka tip | "players with fire, frost, nature, arcane or holy damage finish him" | HP "those players finish him" (B) | `"Pull him away from the scarabs; when he changes form, let the fire, frost, nature, arcane and holy damage dealers end it."` |
| ZF Antu'sul does 1+2 | "the fight starts as soon as you come near his cave" / "and they stay after he dies" | HP "The fight starts as you near his cave" (B) / HP letterlijk (L) | `"Waits in a side basin full of basilisks; he attacks as soon as you get close to his cave."` / `"Keeps calling elite basilisks; they do not vanish when he dies."` |
| ZF Zum'rah tip | "Break the ward at once" | HP letterlijk (L) | `"Destroy the ward right away; save your interrupts for his group shadow bolts and his heal."` |
| ZF Velratha tip | "pull her alone and interrupt her heals" | CQ letterlijk (L) | `"Wait for her walk, fight her on her own and stop every heal."` |
| ZF Sezz'ziz tip | "Interrupt every heal he casts." | HP "interrupt every heal Sezz'ziz casts" (B) | `"Stop each of his heals with an interrupt."` |
| Mara Noxxion tip | "Kill the small copies fast so he comes back." | CQ "Kill the spawns fast and he comes back." (B) | `"The faster the small copies die, the sooner he is back."` |
| Mara Vyletongue tip | "move back onto him after every teleport" | WFBE "Move back onto him after every blink." (B) | `"Stay close together near the tank, and run back to him each time he teleports away."` |
| Mara Gizlock tip | "everyone else stands behind him in melee range" | WFBE "stands behind him in melee range" (L) | `"Tank turns him away; everyone else stays close behind him."` |
| Mara Rotgrip does 1 | "in the lake below the princess" | CQ "in the lake below the Princess" (L) | `"A big crocodile in the water under the princess's platform; clear the hydras there first."` |
| Krol'dok Grox tip | "Clear a spot while he walks away, then pull him there." | WT "Clear out an arena when he's away, then pull him." (B) | `"Use the time he walks away to clear a place, then bring him there."` |

### R12. Kleine woordkeuze en aanvullingen (laag)
- Dalaran Atrexis tip "Pull two of the necromancers near him first" is dubbelzinnig (naar hem toe of bij hem weg?).
  WFA: "Pull a couple of the necromancers away from his patrol and kill them before you pull the boss."
  **Nieuw:** `"First pull two of his necromancers away from him and kill them; hold area attacks until the tank has the skeletons."`
- Krol'dok Ashka: de fear (weggelaten als "alleen GGA") staat ook bij gametruth.com (13 nov 2026: "room if a wolf
  fears someone"). Of gametruth onafhankelijk is: niet nagegaan. Mag erbij, hoeft niet.
- Krol'dok Toof: het gevecht start als je de twee Krol'dok Centurions bij de eerste brug aanvalt (WT; gametruth).
  Eventueel: `"The fight starts when you attack the two centurions at the first bridge: brutes keep coming while you cross."`
- `optional`: HP noemt Antu'sul "OPTIONAL", wowforeverguides (upd. 11 nov) de Obsidian Sentinel. In de data is
  `optional` alleen voor gevechten met een voorwaarde (gong, Tome, Bly, verborgen kamer). Dat is een keuze; houd hem
  gelijk met stap 1.

## Niet gemeten / open (eerlijk)
- Of de vier "wat moet je doen"-stappen (treants, parels, sleutelbos, altaren) in Forever precies zo werken: alleen
  in het spel. Archaedas-altaar: alleen Classic-bronnen, geen Forever-bron spreekt het tegen.
- R3: de betekenis van BasePoints/MiscValue bij Effect 98 is A (server-formule), niet in de client gemeten.
- Wowhead Forever-gidsen voor Uldaman/ZF/Maraudon heb ik niet gelezen (Exa geeft alleen titel). IV Alcaz en IV
  Krol'dok-dungeongids bestaan niet (zoals de C-notes zeggen).
- Gizlock-deel (measure): DB2 OrderIndex 1500 is in Classic Era hetzelfde (G), dus beslist niets. FDJ zet hem op floor 2
  (= Earth Song Falls-kaart); CQ (15 nov) en wowforever.be zeggen paars. Blijft `measure`.

## Gebruikte bronnen (gelezen 18 nov 2026)
DB2 wago.tools Forever 1.60.1.70959 (DungeonEncounter 7 talen, SpellName, SpellEffect, Creature) + Classic Era
1.15.9.70576; WHT nether.wowhead.com/forever (npc 7 talen, items volledig). IV Dalaran (Oct 18, 2026), IV Drowned
(Nov 17, 2026); WH Dalaran (Riyani, 2026/11/09) + WH-nieuws Lyn (2026-10-11), WH Drowned (Jurdi, 2026/11/14), WH Alcaz
(Jurdi, 2026/11/15); CQ Dalaran (07 Nov), ZF (07 Nov), Maraudon (15 Nov), Alcaz (08 Nov); WT Uldaman, Krol'dok, Alcaz,
Drowned (geen datum); HP hearthproof ZF (geen datum, na 4 nov); MOB ZF; wowf.io Dalaran/Maraudon; wowforever.be
Dalaran/Maraudon; WFA wowforeveraddon Dalaran/Drowned/Krol'dok/Maraudon; CX wowforevercodex (9 okt); ForG ("Reviewed
Nov 9"); apocanow Krol'dok/Alcaz/Drowned (13 nov); gametruth Krol'dok (13 nov); GGA (7 nov); AW azeroth.wiki Uldaman;
wowforeverguides Uldaman (upd. 11 nov); Classic: wow-pro Uldaman (2006), cmangos #2058, Wowhead Classic zone 1337;
FDJ `Core/Journal.lua` en `Localization/Content_Verified.lua` (alleen als feitenbron naast een tweede bron).

## Na mijn oordeel: de `_notes.md` gelezen
- **B-notes**: hadden de frFR/ruRU-naamkwestie al (R1, ik vond hem los daarvan ook). Verder niets wat ik mis dat de
  tekst verandert (Gni'kiv "Dropped by Baelog 2.63%" bij Wowhead heb ik niet zelf nagekeken; de tekst volgt terecht de kist).
  De notes missen R3 (klap omhoog), R9 (Celebras-quest) en de letterlijke zinnen (R11).
- **C-notes**: noemen de Questioner-volgorde al als optie (R4). Ze hebben iets dat ik niet nakeek: Krol'dok
  `MapDifficulty` MaxPlayers 10 (geen tekstpunt). Ze missen: deDE "Nar'guk" (R1), de treants bij de Fel Ancient (R2),
  WT Alcaz als extra bron (R6), en de woordkeus bij Wrex/Katerina/parel/Umbra (R5-R8).
