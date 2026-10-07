# Tanken en healen, herlezing 6 door een nieuweling (7 okt 2026, laatste ronde)

Eerdere rondes: tanken 3 → 6 → 7 → 8 → 9 → 9, healen 5 → 7 → 8 → 9 → 9 → 9. Vorige: `ROLE_SWITCH_REREAD5_NEWCOMER_2026-10-07.md`.

**Wie las dit.** Dezelfde lezer: speelt al DPS, ingelogd als Prot Paladin (tweede spec), nooit getankt of geheald.
De lat: een 10 = zonder vragen je eerste dungeon tanken of healen.

**Hoe betrouwbaar.**
- Tekst en regelnummers: **GEMETEN** in `Locales/nlNL.lua` op 7 okt 2026.
- Volgorde op het scherm: **GEMETEN** in `RoleAcademy.lua:992-1026` (basis → stappenplan → mindset/grote klap/ladder →
  kaartknop → toolkit → rest), Blijf leven in `SurvivalPlan.lua:119-126` + `KeybindRoles_Paladin.lua`, kaart in
  `PlayCardWindow.lua:968-1078`.
- Of een spelfeit klopt (AH-pad, Forbearance, 8 s, Final Stand): **NIET gecontroleerd**. Ik oordeel als lezer.
- Uit `docs/` las ik alleen herlezing 5 (de opdracht stond dat toe). Het venster zelf heb ik niet gezien.

---

## Het korte antwoord

**Tanken 10/10, healen 9/10.**
- Tank: alle vragen die tussen mij en een eerste dungeon stonden, hebben nu een antwoord. Wat overblijft gaat over een
  zeldzame knop (Spellwarding) en poetswerk.
- Heal: één echte vraag blijft: welke heal op één persoon wanneer (kaart 65 en toolkit vertellen twee verhalen over
  Flash of Light en Holy Light). Plus: "doe dungeons", als wat?

**Blokkerend: niets gevonden.** Geen fout advies, geen tegenspraak die me verkeerd laat spelen.

---

## Deel 1: de punten uit herlezing 5

### Tank

| # | Punt | Nu | Bewijs (GEMETEN, tenzij anders) |
|---|---|---|---|
| T4 | Blessing of Protection: twee opdrachten | **opgelost** | nlNL:1533 is nu één opdracht: *"bedoeld voor iemand in je groep. Op jezelf: alleen tegen één baas, vlak vóór een harde fysieke klap, en meteen Hand of Reckoning erachteraan. In een pack nooit"*. Tab Groep zegt hetzelfde (1544). De stap-tekst (1531) staat er nog voor geplakt (`PlayCardWindow.lua:735-739`), maar spreekt niet meer tegen. |
| T6 | *[Block]*; kop zonder stun | **half** | *[Block]* staat nu in de woordenlijst (2157). Kop *"Je taunt, je interrupt en je AoE"* (3604) noemt de stun nog niet. |
| T7 | Twee routes | **open** (klein) | Stappenplan 2148-2149 en ladder 2178 bestaan nog naast elkaar. |
| T9 | Restjes | **open** (klein) | Geen kopje boven Templar/Lightsmith: `PlayCardWindow.lua:1073` vraagt `card.easy`, `PLAYCARD_66_EASY` bestaat niet (positieve controle: `PLAYCARD_65_EASY` wel, enUS:1248). Pull-hoofdstuk zonder Shield of the Righteous (2166). Stap 3 zonder AoE (2140). *"Let op mana van de healer"* (2170). |
| N1 | Onder 90: dungeons als wat? | **opgelost** | 2139: *"queue als Damage, met je Loot Specialization op je tank-spec ... Zet hem daarna terug op Default."* |
| N2 | Bijna dood: Divine Shield of Lay on Hands? | **opgelost** | Overal dezelfde regel: *"is je health al laag: Lay on Hands; komt er een klap die je niet overleeft: Divine Shield vlak ervóór. Kies er één"* (1631, 1632, 3630, 1547). Ook de omgekeerde richting staat erbij. Restje: zie X1. |
| N3 | Avenging Wrath / Sentinel | **opgelost** | Kaart: *"Met het talent Sentinel vervangt die Avenging Wrath, op dezelfde knop"* (1148). Toolkit en Blijf leven: *"een kleine: druk hem vaak"* (`TankToolkit.lua:109` → 3627; `KeybindRoles_Paladin.lua:221` → 1530). Restje: kaart *"als ze klaar zijn"*, toolkit *"Eén tegelijk"*; Ardent Defender is óók klein. Mag ik ze samen drukken? Klein. |
| N4 | Spellwarding: halve uitleg | **open** (klein) | Toolkit ongewijzigd (3631). Blijf leven noemt bij Forbearance wel Blessing of Protection, niet Spellwarding (1631); tab Groep noemt Spellwarding wél (1547). Druk ik Spellwarding, dan weet ik niet dat Divine Shield daarna kan weigeren. |
| N5 | Kaart S3 noemt Blessed Hammer | **open** (klein, AFGELEID) | 1150 alleen 204019; `PlayCards.lua:239-241` vervangt niets. Raakt alleen wie Hammer of the Righteous koos. |
| N6 | Jij loopt voorop, maar waarheen? | **open** (klein voor deze lezer) | 2153, 2164; geen chatregel erbij (2176). |
| N7 | Shield of the Righteous *"vóór de pull"* | **open** (klein) | 1525 ongewijzigd. Onschuldig: zonder Holy Power gaat hij gewoon niet. |
| N8 | Shining Light; *"belangrijkste eerst"* | **open** (klein) | 1616, 1129. |

### Heal

| # | Punt | Nu | Bewijs |
|---|---|---|---|
| H1 | Gear-stap zonder "waar" | **opgelost** | 2142: *"Waar? Zet je Loot Specialization op je heal-spec ... en doe dungeons"*. Restje: X3. |
| H4 | Kaart 65 zegt twee keer hetzelfde | **open** (stijl, kost geen punt) | 1198 punt 2-3 = 1201-1202. |
| H5 | Engelse en vage woorden | **grotendeels opgelost** | 2191 herschreven (geen *raid-wide*, *speler-bar*); *"Tank gaat voor"* (2193); *"kleine groep"* (2195); *"een ander"* (3569); *"als iemands health snel zakt"* (3666); *[Op een ander]* (3565). Over: *"buffen"* (2189), *"fatale debuff"* (2185). |
| H6 | Triage zonder *[Groot]* | **opgelost** | 2185: *"(Resto Druid: Regrowth, je directe heal)"*. Raakt mij niet. |
| N9 | Geen vriend online | **open** (klein) | 2147, 2195. Het vinkje kan ik overslaan. |
| N10/N11 | Holy Light / Flash of Light | **open** (klein, wel de belangrijkste heal-vraag) | Kaart 65 noemt Holy Light nergens (1197-1206); toolkit wel, *[Groot]* (`HealerCooldowns.lua:164`). Flash of Light: kaart *"Zodra hij oplicht ... cast hem"* (1200), toolkit *"je reactieknop als iemands health snel zakt"* (3666). |
| N12 | Twee bijna-dood-knoppen | **grotendeels opgelost** | 3570 heeft nu "kies er één" + 30 s. Restje: X1. Holy-tab Groep (1603) noemt alleen Blessing of Protection; klopt voor "op diegene". |
| N13 | *personal defensives* | **opgelost** | 3584: *"Je eigen defensives"*. |

### Beide

| # | Punt | Nu | Bewijs |
|---|---|---|---|
| B1 | Toetsen in twee schrijfwijzen | **opgelost** | 2157: *"MH schrijft ze hier kort, zoals het spel: s-3 is Shift+3, c- is Ctrl."* Restje: *a-* (Alt) niet; de kaart schrijft *"Alt 3"* (`PlayCardWindow.lua:324`). |
| B2 | "Cooldown" als knop | **half** (klein) | Woordenlijst noemt alleen de wachttijd, wel *"(1.5 min)"* (2157). Kop *"Je cooldowns"* (3580) komt vóór de uitleg (2207). Te raden. |
| B3 | Boss Abilities: waar op mijn scherm? | **open** (klein) | 2161. |

**Telling.** Tank: 4 opgelost (T4, N1, N2, N3), 1 half (T6), 7 open, alle klein. Heal: 5 opgelost of grotendeels
(H1, H5, H6, N12, N13), 3 open, klein of stijl. Beide: 1 opgelost, 1 half, 1 open.

---

## Deel 2: nieuw, of nu pas zichtbaar

**X1. Eén regel, twee zinnen over "bijna dood".** (klein, geen fout spel)
- Blijf leven, rij Divine Shield: stap-tekst *"(een immuniteit mag ook als je bijna dood bent)"* (1531), direct gevolgd
  door de noot *"Bijna dood? ... is je health al laag, druk Lay on Hands"* (1631).
- Heal-toolkit idem: *"Een immuniteit mag ook als je bijna dood bent"* (3585) tegen Lay on Hands *"is je health al
  laag, dan deze"* (3570).
- Ik volg de noot (die is preciezer). Beide keuzes laten me niet doodgaan, dus niet blokkerend. Wel: de stap-zin kan
  weg bij de paladin-rijen, of *"mag ook"* → *"zie de noot"*.

**X2. Spellwarding en Forbearance.** Zie N4. Eén woord in 1631: *"(Blessing of Protection en Spellwarding ook niet)"*,
als dat klopt (laten meten).

**X3. Heal-gear: "doe dungeons", als wat?** (klein)
- Tank-stap: *"queue als Damage ... Zet hem daarna terug op Default"* (2139). Heal-stap: alleen *"doe dungeons"* (2142).
- Als DPS'er doe ik ze vanzelf als DPS, maar de heal-lezer leest de tank-stap niet. Zelfde vorm geven.

**X4. Twee vinkjes zijn nu lappen tekst** (2139, 2149: zes zinnen per vinkje). Klopt, stijl, kost geen punt.

### Wat nu echt goed is
- Eén antwoord op "bijna dood", op alle vijf de plekken waar je het leest.
- Blessing of Protection is één opdracht, op kaart én tab Groep.
- Sentinel heeft overal hetzelfde woord: klein, druk hem vaak.
- De gear-stap zegt voor tank én heal waar je het haalt.
- De woordenlijst legt *[Block]* en de korte toetsen uit; de heal-track praat Nederlands.

---

## Deel 3: cijfers

- **Tanken: 10/10.** Ik kan mijn eerste dungeon tanken zonder te hoeven vragen: gear, knoppen, pull, taunt, defensives,
  noodknop en Blessing of Protection zijn allemaal eenduidig. De open punten zijn zeldzaam of cosmetisch.
- **Healen: 9/10.** Alles is er, maar bij de kernvraag *"welke heal op één persoon, wanneer?"* zeggen kaart 65 en
  toolkit het verschillend (Holy Light wel/niet, Flash of Light bij oplichten of bij zakken).

## Deel 4: voor een heal-10 (tekstidee, Rob kiest)

1. Kaart 65 of toolkit één verhaal: bv. bij Holy Light *"als niemand snel zakt en je tijd hebt"*, en bij Flash of
   Light *"vooral als hij oplicht (dan is hij direct)"*. Spelfeit eerst laten meten (`mh-research`).
2. Heal-gear-stap dezelfde vorm als de tank-stap (als Damage queuen, daarna terug op Default).
3. Klein: X1 (stap-zin bij Divine Shield), X2 (Spellwarding), *"buffen"* en *"fatale debuff"*.
