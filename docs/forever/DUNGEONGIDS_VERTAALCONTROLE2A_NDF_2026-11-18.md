# Vertaalcontrole bazengids stap 2a: nlNL, deDE, frFR (controleur NDF, 18 nov 2026)

Gecontroleerd: alle 349 sleutels in scope (`FDG_` GNOMER, RFK, SM, RFD, ULDA, ZF, MARA, DAL, DROWN, KROL, ALCAZ + 8 `FDGP_`)
in `Locales\enUS.lua` tegen `nlNL.lua`, `ForeverClassQuests_deDE.lua`, `ForeverClassQuests_frFR.lua` (repo zoals op
18 nov 2026 gelezen; elk bestand 349 treffers met dezelfde regex, G). Repo niet aangeraakt, `probe_job.txt` niet gebruikt.
G = GEMETEN (bron + build genoemd), A = AFGELEID.

Verbeterde regels: `dg2x_nlNL.txt` (1), `dg2x_deDE.txt` (7), `dg2x_frFR.txt` (9). Formaat nagemeten: 17/17 regels
voldoen aan `^\tFDG_\w+ = "[^"]*",$` (G).

## Telling

| Taal | FOUT | RISICO met fix | RISICO zonder fix |
|---|---|---|---|
| nlNL | 0 | 1 | 1 |
| deDE | 3 | 4 (2 regels Zauberschutz = optioneel) | 3 |
| frFR | 1 | 8 (2 regels Garde = optioneel) | 2 |

## deDE

- **FOUT `FDG_ULDA_6_D1`** — "Shadowforge Geologists" bleef Engels, maar de client heeft een naam: npc 7030 deDE =
  "Geologe der Schattenschmiede" (G: WHT Forever --locale deDE, 18 nov 2026; enUS-controle 7030 = "Shadowforge
  Geologist"). Fix: "Ein Feuer-Zauberwirker mit Geologen der Schattenschmiede als Helfern."
- **FOUT (taal) `FDG_DAL_2_D1`** — "wenn du den Foliant von Dalaran ... benutzt": *Foliant* is een zwak naamwoord,
  accusatief = *den Folianten* (A, Duitse grammatica). De pack verbuigt het zelf in de volgende regel (`DAL_2_D2`: "Den
  Folianten ... aus dem Schwarzen Folianten"). Clientnaam "Foliant von Dalaran" (G: ItemSparse 275989 deDE, Forever
  1.60.1.70959) blijft herkenbaar.
- **FOUT (taal) `FDG_MARA_3_D3`** — "Lässt den Celebriandiamant fallen": zelfde zwakke verbuiging, *den
  Celebriandiamanten*; `MARA_4_D3` zegt zelf "dem Diamanten". Clientnaam "Celebriandiamant" (G: item 17703 deDE).
- **RISICO `FDG_SM_10_D2`** — "kann sich vor allem Schaden schützen" leest ook als "kan zich vooral tegen schade
  beschermen" (*vor allem* = vooral). Fix: "vor jeglichem Schaden" (= EN "from all harm").
- **RISICO `FDG_DAL_8_T`** — "Wer ihn verlässt, setzt ihn zurück": twee keer *ihn* (Raum en baas), leest als "wie
  hem verlaat". Fix: "Verlässt jemand den Raum, wird der Boss zurückgesetzt."
- **RISICO, optioneel `FDG_ZF_5_D2` + `FDG_ZF_5_T`** — EN zegt alleen "a ward"; het naamplaatje in de client is
  "Zauberschutz von Zum'rah" (G: npc 7785 deDE). De vertaling zegt "Schutzzauber". Fix: "Zauberschutz" (zelfde woord
  als de client). Geen fout als jullie het laten.
- RISICO zonder fix: `FDG_ZF_L2` "Schultern" (client-slotwoord INVTYPE_SHOULDER = "Schulter", G; EN zegt zelf
  "shoulders"). `FDG_KROL_6_T` mengt du + ihr in één zin ("Setz CC ... und verteilt euch"); zo ook frFR, en stap 1
  gebruikt "Verteilt euch." voor de groep (G: `FDG_STOCKS_3_T`). `FDG_DROWN_4_D1` "Der Kampf ist an einem Altar"
  is spreektaal, niet fout.
- Aanspreekvorm: du, plus ihr bij groepsopdrachten (verteilt euch, bleibt zusammen, legt fest) — gelijk aan stap 1 (G).

## frFR

- **FOUT `FDG_ULDA_6_D1`** — "Shadowforge Geologists" bleef Engels; npc 7030 frFR = "Géologue Ombreforge" (G: WHT
  Forever --locale frFR). Fix: "Un lanceur de sorts de feu, avec des Géologues Ombreforge comme assistants."
- **RISICO (taal) `FDG_SM_1_T`** — "Attire seulement lui et ..." is geen goed Frans. Fix: "N’attire que lui et ...".
- **RISICO (taal) `FDG_SM_2_T`** — "courir dans de nouveaux monstres" is een anglicisme (*run into*). Fix: "tomber sur
  de nouveaux monstres".
- **RISICO (betekenis) `FDG_ZF_6_D2`** — "montent ensemble avec la dernière vague" = "met de laatste golf mee"; EN zegt
  dat zij ZELF de laatste golf zijn ("as the last wave"). Fix: "montent ensemble, en dernière vague."
- **RISICO (betekenis) `FDG_RFK_1_D1`** — "surtout utile pour" = "vooral nuttig"; EN "mostly needed". Fix: "surtout
  nécessaire pour".
- **RISICO `FDG_ULDA_1_D3`** — "Laisse tomber La Hampe de Tsol": hoofdletter-lidwoord midden in de zin. Clientnaam is
  "La Hampe de Tsol" (G: item 7741 frFR); dezelfde pack schrijft bij "La Clé écarlate" (G: item 7146 frFR) gewoon
  "la Clé écarlate" (`SM_7_D3`). Fix: "la Hampe de Tsol".
- **RISICO `FDG_GNOMER_2_D1`** — "Hall des engrenages"; client = "Hall des Engrenages" (G, maar alleen RETAIL 12.1.5.70961
  UiMapGroupMember 516/1150; Forever heeft die tabel niet bij wago: HTTP 400, en AreaTable Forever geeft 0 rijen op
  "Gears" terwijl "Ambermill" in dezelfde ronde wel 1 rij gaf). Fix: hoofdletter E.
- **RISICO, optioneel `FDG_ZF_5_D2` + `FDG_ZF_5_T`** — EN "a ward"; client-naamplaatje frFR = "Garde de Zum'rah"
  (G: npc 7785 frFR). Vertaling zegt "une protection". Fix gebruikt "Garde de Zum'rah". Geen fout als jullie het laten.
- RISICO zonder fix: `FDG_DAL_4_D1` "près du fort Pourpre" (client retail "Fort Pourpre"; kleine letter bij het
  soortwoord is gewone Franse typografie, dus laten). `FDG_ZF_4_T` "d’arcane ou du sacré" mengt vormen, wel te begrijpen.
- Aanspreekvorm: tu, plus vous bij groepsopdrachten (dispersez-vous, restez groupés, choisissez) — dezelfde 7 regels
  als deDE, en stap 1 doet het ook ("Dispersez-vous.", G: `FDG_STOCKS_3_T`).

## nlNL

- **RISICO `FDG_GNOMER_1_D2`** — "zijn huisdier Chomper": de nlNL-pack zegt in speltaal overal "pet" (G: o.a.
  `PETTAUNT_WARN_TITLE`, `SURVIVAL_NOTE_PET`, `GROUP_NOTE_*`). Fix: "zijn pet Chomper".
- RISICO zonder fix: `FDGP_POISON_FALLS` bleef "Poison Falls" terwijl Orange/Purple side vertaald zijn ("Oranje kant",
  "Paarse kant"). Geen clientnaam (notes B, G); voor nlNL is een Engelse plaatsnaam verdedigbaar. Laten of vertalen =
  smaak.
- Geen "spreuk(en)" in nlNL (G: 0 treffers, positieve controle `stopt hun spells` in dezelfde grep wel gevonden).
  Spelnamen Engels en gelijk aan enUS (Glowing Pearl, Undying Offering, Scarlet Key, Shaft of Tsol, ...). Item-rollen
  volgen stap 1 ("Strength-melee", "Agility-gebruiker", "Strength-mail-drager").

## Alle talen

- Geen recht `"` in de tekst (G: regex op interne quotes = 0; positieve controle `KEYBLOCK_LAYOUT_DONE_FMT` wel gevonden).
- Geen markup in scope (G: `|c`, `|r`, `%s`, `%d` = 0; positieve controle `FDG_FROM_FMT` in alle 4 bestanden gevonden).
- Main Hand ≠ One-Hand klopt overal: `KROL_L1`, `SM_L12`, `ULDA_L1` = Waffenhand / main droite / main-hand (G:
  INVTYPE_WEAPONMAINHAND deDE "Waffenhand", frFR "Main droite"); `RFD_L2`, `ZF_L3`, `MARA_L2` = Einhand / à une main.
  Off-hand = Schildhand / main gauche (stat_words.txt). Overige slot/stat-woorden G in GlobalStrings Forever 1.60.1.70959
  (Hals/Cou, Kopf/Tête, Verteidigung/Défense, Parieren/parade, Angriffskraft, Naturwiderstand/Résistance à la Nature).

## Nagemeten namen (G, 18 nov 2026; deDE én frFR elk dezelfde lijst, ruim 25 per taal)

Bron A = WHT Forever tooltip (`run gamedata npc|item ... --game forever --locale xxXX`, nether.wowhead.com/forever);
bron B = wago DB2 Forever build 1.60.1.70959; bron R = wago DB2 RETAIL 12.1.5.70961 (alleen waar Forever niets heeft).
Alle namen hieronder staan zo in de vertaling (✓), behalve waar FOUT/RISICO staat.

- npc (A), enUS-id eerst gecontroleerd: 7998 Emi Shortfuse (deDE / frFR: Sprengmeisterin Emi Shortfuse / Maître-dynamiteur
  Emi Shortfuse), 6215 Chomper (Mümmler / Mâchouilleur), 4438 Razorfen Spearhide (Speerbalg von Razorfen / Lanceur de
  Tranchebauge), 6575 Scarlet Trainee (Scharlachroter Lehrling / Jeune recrue écarlate), 8516 Belnistrasz, 7607 Weegli
  Blastfuse (Weegli Lunte / Weegli Blastfuse), 7274 Sandfury Executioner (Henker der Sandfury / Bourreau Sandfury),
  13716 Celebras the Redeemed (Celebras der Erlöste / Celebras le Racheté), 13697 Cavindra, 7797 Ruuzlu, 6906 Baelog,
  6907 Eric, 6908 Olaf, 255707 Zarla Ober ([Zarla Ober] = placeholder, Engels blijft), 7030 Shadowforge Geologist
  (FOUT), 269475 Mana Phantom (Manaphantom / Fantôme de mana), 255262 Alcaz Chaplain (Kaplan von Alcaz / Chapelain
  d'Alcaz), 270910 Brinescale Priestess ([Brinescale Priestess] = placeholder, Engels blijft: goed), 263899 Undying
  Offering (Unvergängliche Opfergabe / Offrande éternelle), 269127 Image of Archmage Modera (Erzmagierin Modera /
  l'archimage Modera), 7785 Ward of Zum'rah (RISICO). Id's 270910, 263899, 269475 komen uit Zygor Forever-gidsen.
- item (A / B): 6893 Werkstattschlüssel / Clé d'atelier, 7146 Der scharlachrote Schlüssel / La Clé écarlate,
  7741 Der Schaft von Tsol / La Hampe de Tsol, 7740 Gni'kiv-Medaillon / Médaillon de Gni'kiv, 7733 Stab der Prähistorie /
  Bâton de la préhistoire, 9240 Schlaghammer von Zul'Farrak / Marteau de Zul'Farrak, 8548 Wünschel-mato-Rute / Bâtonnet
  divino-matic, 17702 Celebriangriff / Bâtonnet de Celebras, 17703 Celebriandiamant / Diamant de Celebras, 17191 Szepter
  von Celebras / Sceptre de Celebras (tooltip: "Fällen des irdenen Gesangs" / "chutes de Chanteterre"),
  B ItemSparse 275989 Foliant von Dalaran / Tome de Dalaran, 276561 Schwarzer Foliant / Tome noir.
- plekken: B AreaTable 47 Hinterland / Les Hinterlands, 209 Burg Shadowfang / Donjon d'Ombrecroc, 233 Ambermill /
  Moulin-de-l'Ambre. B GroupFinderActivity 805/827/828/829: Friedhof, Waffenkammer, Kathedrale, Bibliothek /
  cimetière, armurerie, cathédrale, bibliothèque. R AreaTable 4567/4619: Die Violette Festung, Die Violette Zitadelle /
  Fort Pourpre, Citadelle Pourpre (Forever AreaTable heeft geen "Violet"-rij: 0 rijen, positieve controle Ambermill = 1).
  R UiMapGroupMember 516: Die Halle der Zahnräder / Hall des Engrenages.
- bazen (B DungeonEncounter Forever): MapID 70+209 deDE en 70+209+129 frFR: alle namen gelijk aan het `names`-veld en
  aan de korte vormen in de tekst (Ironaya, Grimelok, Gahz’rilla, Sezz’ziz, Pestegueule, ...).

Niet te meten, Engels gebleven (goed volgens de brief): "Angry Tomes" (DAL_6_D2), "Glowing Pearl" (DROWN_2_D3/3_D3).
