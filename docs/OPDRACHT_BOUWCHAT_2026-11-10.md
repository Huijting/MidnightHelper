# Opdracht voor de bouwchat — het plan uitvoeren, stap voor stap (10 nov 2026)

Van: de cloud-sessie "Midnight Helpen brainstorm". Rob keurde het plan goed op 10 nov (avond): *"het klopt allemaal,
volgorde is goed"*, en zei ja op deze opdracht.

Het hele plan: `docs/PLAN_WERKWIJZE_2026-11-10.md`. De ideeënlijst: `docs/IDEEEN.md`.
Beide staan op de tak `claude/midnight-helpen-brainstorm-d18bs9`, nog niet op `main`.

## Eerst lezen

- Je bouwt **één stap tegelijk**. Na elke stap: aan Rob laten zien, zijn ja afwachten, dan de volgende.
- Niets hiervan is een release. Geen versie ophogen, geen tag.
- De regel van het plan: **elk bestand heeft één schrijver.** Jij schrijft in de addon-repo. De site-chat niet.
- Alles wat je bouwt krijgt een proef die bewijst dat het een bekende fout ook echt vindt. Een controle die niets
  vindt, bewijst niets zonder die proef.
- Wat hier als feit staat, komt uit het plan. Meet het zelf na in de bron voor je erop bouwt.

## Stap 0 — de tak naar main halen

- Haal `docs/PLAN_WERKWIJZE_2026-11-10.md`, `docs/IDEEEN.md` en dit bestand naar `main`.
- `docs/NEXT_SESSION.md` is op de tak ook gewijzigd (een blok bovenaan). Neem dat blok over met de hand; de rest van
  dat bestand is van jou. Het zit dicht bij de grens van 1500 regels: splits eerst als dat nodig is.

## Stap 1 — het prikbord (deel 5 van het plan)

Maak `docs/SITE_SEIN.md`. Jij schrijft, de site-chat leest het bij elke start. Nieuwste regel bovenaan.

Per regel, in deze vorm (de site-chat vroeg om precies deze velden):

```
## <datum> — <korte naam>
- Tag + commit:   v… / <hash>   (of: geen tag)
- Status:         alleen op main / getagd / staat op CurseForge
- Mag op de site: ja / nee      (+ Robs go, letterlijk, als die er is)
- Speler ziet:    één of twee zinnen
- Knoplabels:     als Locales-sleutel, niet overgetypt
- Commando's:     /mh …
- Spel:           Midnight / Forever / allebei
```

De drie vaste woorden bij Status, overal hetzelfde:

1. **alleen op main** — gebouwd, niet uit.
2. **getagd** — de release loopt.
3. **staat op CurseForge** — spelers hebben het. Alleen dan mag de site het als "nieuw" melden.

Te doen:

1. Maak het bestand met een korte kop die de vorm en de drie woorden uitlegt.
2. Vul de eerste regels: de laatste release, en wat er sindsdien op `main` staat en nog niet uit is. Meet beide zelf
   (tag, commits, de CurseForge-pagina); neem ze niet over uit een aantekening.
3. Zet in `docs/RELEASE_CHECKLIST.md` bij het "seintje aan de site-chat": schrijf de regel in `SITE_SEIN.md`. Het
   losse bericht mag blijven als extra, maar het bestand is de afspraak.
4. Zet in je eigen ochtendronde: lees het vragenbestand van de site-chat. Zij stelden `drafts/BOUW_VRAAG.md` in de
   site-repo voor; dat bestand maken zíj. Bestaat het nog niet, meld dat dan gewoon.
5. Werk `docs/NEXT_SESSION.md` bij in dezelfde commit.

Klaar als: het bestand staat op `main`, de eerste regels kloppen met wat je gemeten hebt, en Rob het gezien heeft.

## Stap 2 — drie controles (deel 2 van het plan: C3, C5, C1)

In deze volgorde, van klein naar groot. Elk als controle in `tools/lint_addon.py` of als eigen script via de voordeur
(`_probe.py`), zodat GitHub ze bij elke push draait.

- **C3 — klopt de release-tekst?** Elk knoplabel en elk `/mh`-commando in `RELEASE_NOTES.md` moet in Locales of in
  de code bestaan. Aanleiding: op 3 nov noemde de release-tekst een "Skip"-knop die niet bestaat (gemeld door de
  site-chat). Proef: laat de controle die fout van 3 nov terugvinden in de tekst van toen.
- **C5 — is elk onderdeel vindbaar?** Elk venster heeft een commando in de lijst en een plek in de zoekbalk.
  `check_command_list` doet hier al een deel van; kijk eerst wat die precies dekt.
- **C1 — bestaat het event?** Elke naam in een `RegisterEvent` tegen Blizzards eigen lijst. Bron: de map
  `Blizzard_APIDocumentationGenerated` in `Gethe/wow-ui-source` op GitHub (events staan er als `LiteralName`).
  GEMETEN vanuit de cloud op 10 nov: bereikbaar, build 12.1.5.70783. Niet gemeten: of de PTR en Forever er als eigen
  tak in staan, en of élk event in die lijst staat. Proef: `LEARNED_SPELL_IN_TAB` (de fout van 8 aug) moet rood worden.
  ⚠️ Een event dat niet in de lijst staat is een kandidaat, geen bewijs. Meld het als "nakijken", niet als "fout",
  tot gemeten is hoe compleet de lijst is.

Klaar als: elke controle zijn proef haalt, de huidige code schoon is of de meldingen aan Rob zijn voorgelegd, en
GitHub ze draait.

## Daarna (alleen noemen, nog niet bouwen)

De rest van de volgorde staat in het plan: C2 en C4 (speldata), de vijfde wachter en de ideeën-wachter, de recepten,
`/mh selftest`, het nep-spel, regels worden controles. Voor C2 en C4 in de cloud bestaat sinds 10 nov de omgeving
"Midnight Helper" met `wago.tools` en `nether.wowhead.com` toegelaten.

## Niet doen

- Niets in de site-repo schrijven.
- Geen idee uit `docs/IDEEEN.md` bouwen zonder Robs ja op die regel.
- Geen controle "groen" noemen zonder dat zijn proef gedraaid heeft.
