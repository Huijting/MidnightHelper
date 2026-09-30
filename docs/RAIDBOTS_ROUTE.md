# Raidbots-route voor de Armory — plan (30 sep 2026)

Rob, 30 sep: *"zet de Raidbots-route op de ideeënlijst, en begin maar met uitwerken, vind Raidbots dit oke ??"*

## Waarom

Onze Armory weegt stats met voorbeeldgewichten. Dat kan geen trinket-effecten, sets of embellishments
waarderen; op 30 sep wisselde hij Robs Lost Idol (alleen effect) voor een zwakkere trinket met Strength. Sinds
die dag slaat de site effect-items over, eerlijk maar beperkt. Raidbots **Top Gear** simuleert echt en beantwoordt
precies "wat is de beste set uit mijn tassen", inclusief effecten.

## Vindt Raidbots het goed? (onderzocht 30 sep, agent + bronnen)

- GEMETEN, raidbots.com/tou: verbiedt **geautomatiseerde** toegang (bots, scrapers). Over linken of over tekst die
  een ander hulpmiddel maakte staat niets. AFGELEID: een speler die zelf plakt is gewoon browsergebruik → toegestaan.
- GEMETEN, raidbots.com/developers: nodigt andere sites uit om te **linken** (met URL-parameters die een karakter
  vooraf invullen) en vraagt bij rapporten "link to the original report on Raidbots".
- GEMETEN, support-artikel 74 (bijgewerkt 16 aug 2026): gratis gebruikers hebben sinds augustus een limiet,
  "a handful of bigger sims (Droptimizer, Top Gear) per hour". Uitgelogd: per IP-adres.
- GEMETEN: andere addons doen hetzelfde voor andere sim-sites (WowSims Exporter, Voidsim). Geen uitspraak van
  Raidbots voor of tegen.
- 📌 **Advies: vraag het ze gewoon** — kost weinig. support.raidbots.com → *Contact Us*, of hun Discord.
  Conceptbericht onderaan. Rob stuurt het zelf (berichten namens Rob verstuur ik niet).

## De SimulationCraft-addon

- GEMETEN: licentie **The Unlicense** (publiek domein) — lezen én overnemen mag juridisch.
- GEMETEN: bijgehouden voor 12.1 (release 12.1.0-04, 21 aug 2026: ingebouwde talent-export). Elke patch komen er
  velden bij (`content_tuning`, `redirected_base_stats`, bonus rolls, catalyst).
- GEMETEN: de wiki-docs zijn deels verouderd; voor `# head=`-tasregels, `gem_id`, `enchant_id`, `crafting_quality`
  is de `core.lua` van de addon de echte referentie. Elke `/simc`-uitvoer eindigt op `# Checksum:` — of Raidbots
  die eist is onbekend.
- Robs installatie: de SimC-addon staat er niet (GEMETEN, AddOns-map).

## Drie opties

| | Wat | Werk (AFGELEID) | Onderhoud | Kwaliteit |
|---|---|---|---|---|
| **A** | MH maakt niets zelf. Site + MH zeggen: *"installeer SimulationCraft, typ /simc, plak op Raidbots Top Gear"*, met link. Heeft de speler SimC, dan kan MH een knop tonen die `/simc` opent. | een paar uur | vrijwel nul — SimC houdt het formaat bij | zo goed als Raidbots |
| **B** | MH schrijft zelf SimC-tekst (`/mh export raidbots`), op basis van de SimC-addon (Unlicense). | een dag of twee | **elke patch**: nieuwe velden volgen, anders klopt de sim stil niet | zo goed als Raidbots, zolang we bijblijven |
| **C** | Niets met Raidbots; onze Armory blijft alleen stats. | 0 | 0 | beperkt |

**Advies: A.** Het antwoord is even goed als B, maar het formaat-onderhoud blijft bij de mensen die dat al elke
patch doen. B lijkt aantrekkelijk ("geen extra addon nodig"), maar een SimC-tekst die één nieuw veld mist geeft
een sim die klopt-maar-niet-helemaal, en dat merkt niemand — precies het soort stilte waar deze repo tegen
waarschuwt. B kan later alsnog, als spelers de extra addon echt een drempel vinden.

## Als Rob A kiest — wat er gebouwd wordt

1. **Site (Armory, Best set-tab):** een blok *"Want the exact answer, trinket effects included?"* → 3 stappen
   (SimulationCraft installeren · `/simc` · plakken op Raidbots Top Gear) + knop naar
   `https://www.raidbots.com/simbot/topgear`. Vertaald via de i18n-pijplijn.
2. **MH:** bij `/mh export` een regel in het venster: heb je SimulationCraft geladen → *"Voor het precieze
   antwoord: /simc → Raidbots Top Gear"*; zo niet → dezelfde tip met *"installeer SimulationCraft"*. Controle via
   `C_AddOns.IsAddOnLoaded("Simulationcraft")` (naam VERIFY).
3. Bij elk effect-item op de site (de *"Its effect can't be scored here"*-regel) dezelfde link.

## Conceptbericht aan Raidbots (Rob verstuurt het zelf, als hij wil)

> Hi! I make a free WoW addon, Midnight Helper, and a small gear page (midnighthelper.com/armory) that gives a
> quick stat-weight overview. For the exact answer I'd like to point players to Raidbots Top Gear: "install the
> SimulationCraft addon, type /simc, paste it on Raidbots". Just a plain link, no automation, no API. Is that
> okay with you, and is there anything you'd like us to do (wording, link format, attribution)? Thanks!
