# De 18 oude open punten nagelopen (6 nov 2026)

Rob: *"Ja, 1 tot en met 5"* (punt 5 = de lijst onderaan `docs/NEXT_SESSION.md` opruimen). mh-sweep (Haiku) las elke
sectie in `docs/NEXT_SESSION_ARCHIVE.md` en zocht het bewijs in code en docs. De drie die af zijn heb ik zelf nagelezen
en in `KNOWN_DONE` (`tools/split_handoff.py`) gezet: de lijst is nu 15. De rest is alleen gelezen, niet zelf nagemeten.

## Af (zelf nagelezen) → uit de lijst

| Kop | Bewijs |
|---|---|
| EIS VOOR DE VOLGENDE UPDATE (23 okt) | `docs/CURSEFORGE_4.11.2.md:7-19`, "New on midnighthelper.com: Your talents" met DPS, tanks en healers |
| 7 sep — binnen in de kamer wijst de pijl terug naar de deur | archief r. 2049: Rob 16 okt "boog → orb → portaal werkt, ook vanuit binnen" |
| MORGEN — vier dingen, in deze volgorde | archief: punt 1 "9 sep … band B reset wekelijks", punt 2 "7 sep — de sniffer heeft gevangen", punt 3 AF 7 sep, punt 4 ingehaald door 3.9.0 |

## Nog open (volgens mh-sweep; niet zelf nagemeten)

| Kop | Wat er nog open is |
|---|---|
| OPEN na 28 okt | Rob-tests: venster A na een echte Labyrinth-run, Delve Log/melding na een echte delve, AH-aantal. Kindo'jan-melding (Rob: "film hem"). |
| OPEN na 26 okt | Vooral Rob-tests; meetplan "Internal auction error" zonder uitkomst. |
| OPEN na 23 okt | `{SPELL}`-tags voor Radiant Glory 458359, Voidtouched 407430, Dark Energy 451018, Dream Simulacrum 1241669 (0 treffers op 458359/1241669; enUS.lua:1697 gebruikt 255937). Amani Headhunter, Er'inye, Delver's HQ: clientcheck. |
| VOLGENDE CHAT EERST (16 okt) | Antorus, SW→Silvermoon-portaal, Turbulent Timeways VI (wacht op 12.1.7 live); Omnium-rune, Talebound: onbekend. |
| 16 okt — MORGEN EERST | Antorus deels (`MountRunData.lua:387`), TT VI, Legion-Dalaran ontbreekt. |
| Venom Lancer Ori'kassi | De surge-cyclus is niet gemeten. |
| 9 sep — weekly-vinkjes | Turn-in-log bestaat (`ResetRoutine.lua:1880`); de bevestigende meting is niet gevonden. |
| 30 aug — onaangeleerde recepten | Of spec-takken recepten afschermen: onbekend. |
| 29 aug — SMC-pin zet TWEE waypoints | Geen bewijs dat het opgelost is; niet opnieuw gemeten. |
| ROB-VERZOEK 19 aug | Het algemene idee (per baas spell-soort kruisen met wat de speler kan) is niet gebouwd. |
| 19 aug — EU-seizoensstart | ⚠️ Tegenstrijdige notities over quest 96466: `Delves.lua:225` "wrong id" vs `AtalUtekProbe.lua:187-195` "exists (MEASURED 19 aug)". |
| OPEN, raakt alle vertaalwerk | `Locales/deDE.lua:19` heeft nog de bovenste `GetLocale()`-afkap; "tabel in een functie" niet gebouwd. |
| MORGENVROEG — twee dingen | Windcaller-coördinaten nog "Unverified" (`TravelPlan.lua:98`, `:123`). |
| De grootste openstaande vraag (11 aug) | Een overzicht dat zichzelf uit de code maakt: niet gevonden. |
| Wacht op Rob | Details!-profielstring en de profession-reset 12.1: bij Rob. |

Bijvangst van mh-sweep: het archief staat niet overal strikt nieuwste-eerst (r. 11133, 7 sep, staat onder r. 9774, 6 sep).
