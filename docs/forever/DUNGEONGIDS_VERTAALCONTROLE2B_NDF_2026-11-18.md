# Vertaalcontrole bazengids stap 2b: nlNL, deDE, frFR (controleur NDF, 18 nov 2026)

Gecontroleerd: alle 445 sleutels in scope (438 `FDG_` van ST, BRD, DIRE, BRS, BMAW, SHAPER, SCHOLO, STRAT + 7 `FDGP_`
EAST/NORTH/WEST/LOWER/UPPER/MAIN_GATE/SERVICE_GATE) in `Locales\enUS.lua` (r. 5861-6305) tegen `nlNL.lua`
(r. 5448-5892), `ForeverClassQuests_deDE.lua` (r. 515-959) en `ForeverClassQuests_frFR.lua` (r. 517-961), repo zoals
op 18 nov 2026 gelezen. Elk bestand: 438 + 7 treffers met dezelfde regex (G). Repo niet aangeraakt, `probe_job.txt`
niet gebruikt. G = GEMETEN (bron + build genoemd), A = AFGELEID. Plus de extra klus: oude bazennamen uit
`dg2_plate_changes.tsv` in ALLE `FDG_*`-regels.

Verbeterde regels: `dg2y_nlNL.txt` (2), `dg2y_deDE.txt` (6), `dg2y_frFR.txt` (7). Formaat nagemeten: 15/15 regels
voldoen aan `^\tFDG_\w+ = "[^"]*",$` (G).

## Telling

| Taal | FOUT | RISICO met fix | RISICO zonder fix |
|---|---|---|---|
| nlNL | 0 | 2 | 0 |
| deDE | 1 | 5 | 3 |
| frFR | 0 | 7 | 3 |

## deDE

- **FOUT `FDG_DIRE_L5`** — "Zauberdurchschlagskraft" is geen clientwoord. GlobalStrings Forever 1.60.1.70959 deDE:
  `ITEM_MOD_SPELL_PENETRATION_SHORT` = "Zauberdurchdringung" (G). Ter vergelijking retail 12.1.5.70961: "Zauberdurchschlag"
  (G). Geen van beide is "…skraft". frFR "pénétration des sorts" klopt wel (G: Forever frFR "Pénétration des sorts").
  Fix: "Zauberwirker mit Stoff (+16 Intelligenz, Zauberdurchdringung)".
- **RISICO `FDG_STRAT_6_D1`** — "Crusaders' Square" bleef Engels, maar de kaartnaam is meetbaar: UiMapGroupMember 536
  "Crusader's Square" = deDE "Kreuzzüglerplatz" (G, RETAIL 12.1.5.70961; Forever heeft die tabel niet bij wago: HTTP 400,
  G vandaag). De vertaler gebruikte uit DEZELFDE tabel wel "Schwarzfausthalle" (527) en "Arbeitszimmer des Direktors"
  (535) (G, beide gelijk aan de tekst). Fix: "Erscheint auf dem Kreuzzüglerplatz, …".
- **RISICO (taal) `FDG_STRAT_2_D1`** — "Rauchwarenladen": *Rauchwaren* betekent in het Duits vooral pelzwaren (bontwerk);
  als "tabakswaren" is het spreektaal (A). EN "smoke shop" met een tabaksdoos. Fix: "Im Tabakladen links vom Haupttor; …".
- **RISICO `FDG_BRS_13_D3`** — "benutzen einen Pfahl": de client noemt de smid-questspiezen "Pike" (G: ItemSparse Forever
  deDE 12847 "Seelenbefleckte Pike", 12848 "Blutbefleckte Pike"; en 12533 "Beschlagene Pike" in `BRS_6_D1`). Welke van
  de twee op Goraluk hoort: niet gemeten (A); allebei "Pike". Fix: "… benutzen eine Pike an seiner Leiche."
- **RISICO (taal) `FDG_BRS_11_T`** — "Brennt die Kerkermeister … nieder" is letterlijk "in brand steken" (EN-gamerslang
  "burn down" = snel doden). Fix: "Erledigt die Kerkermeister schnell mit Flächenangriffen; …". (Zelfde punt in nlNL/frFR.)
- **RISICO (betekenis) `FDG_SCHOLO_9_D3`** — "Je weniger Gesundheit er hat, desto wütender wird er" = geleidelijk. Het
  is één enrage (achtergrond `dg2b_F.lua` src: "moment: WH/WT(C) 50%, CQ onder de helft", G gelezen) en de tip zegt zelf
  "für seinen Wutanfall". Fix: "Wenn seine Gesundheit sinkt, bekommt er einen Wutanfall und schlägt viel härter zu."
- RISICO zonder fix: (1) du + ihr in één zin (`ST_3_T`, `BRD_6_T`, `BRD_12_T`, `BRS_10_T`, `BRS_12_T`, `BRS_15_T`,
  `DIRE_18_T`, `SCHOLO_6_T`, `SCHOLO_12_T`, `STRAT_16_T`, `STRAT_19_T`): zelfde patroon als stap 1/2a (ihr voor
  groepsopdrachten), niet fout. (2) `DIRE_12_D2` "mit Mizzle der Gewiefte": naamplaatje onverbogen na "mit" (keuze B). (3)
  `SCHOLO_L3` "Schultern" (client INVTYPE_SHOULDER "Schulter", G); zelfde als `ZF_L2` in 2a.

## frFR

- **RISICO `FDG_STRAT_6_D1`** — "Crusaders' Square" bleef Engels; UiMapGroupMember 536 frFR = "Place des Croisés" (G,
  RETAIL 12.1.5.70961; Forever geen tabel, G). Vertaler gebruikte uit dezelfde tabel "Salle de Main-Noire" (527) en
  "Bureau du proviseur" (535) (G). Fix: "Apparaît sur la Place des Croisés …".
- **RISICO (taal) `FDG_BRD_4_D1`** — "En entrant dans l’arène, la porte se ferme derrière toi": gérondif met een ander
  onderwerp (de deur gaat niet naar binnen). Fix: "Quand tu entres dans l’arène, la porte se ferme derrière toi ; …".
- **RISICO (taal) `FDG_BRS_17_D3`** — "Met sa cible en feu" is geen gangbaar Frans ("mettre le feu à", "enflammer").
  Fix: "Enflamme sa cible et la fait paniquer, donc un second tank doit le reprendre."
- **RISICO (taal/betekenis) `FDG_SHAPER_4_T`** — "ou soigne malgré lui" = "of heal ondanks hem" (lui = de baas of het
  gif?). EN "heal through it". Fix: "Retire vite le poison, ou compense-le avec des soins."
- **RISICO (taal) `FDG_BRS_11_T`** — "Brûlez les geôliers" letterlijk (zie deDE). Fix: "Tuez vite les geôliers avec des
  attaques de zone ; …".
- **RISICO (taal) `FDG_SCHOLO_2_T`** — "Garde l’œil sur" → vaste uitdrukking is "garder un œil sur". Fix in dg2y.
- **RISICO (betekenis) `FDG_SCHOLO_9_D3`** — "Plus sa vie baisse, plus il s’enrage" = geleidelijk (zie deDE). Fix:
  "Quand sa vie baisse, il devient enragé et frappe beaucoup plus fort."
- RISICO zonder fix: (1) tu + vous in één zin (`ST_3_T`, `BRD_4_T`, `BRD_6_T`, `BRD_12_T`, `BRS_10_T`, `BRS_12_T`,
  `BRS_15_T`, `DIRE_18_T`, `SCHOLO_6_T`, `SCHOLO_12_T`, `STRAT_16_T`, `STRAT_19_T`): zelfde patroon als stap 1/2a. (2)
  `STRAT_1_D2` "des traits de givre et des arcanes" (netter: "et d’arcanes"), te begrijpen. (3) Naamplaatjes zonder
  lidwoord ("parle à Vieil Ecorcefer", "à Soldat Rocknot", "avec Princesse Moira"): keuze B.
- Gecontroleerd en goed: "Fusilliers cramoisis" lijkt een spelfout maar is precies de client (npc 11054 frFR "Fusillier
  cramoisi", G). "horions" (BRD_2_D2) = WoW-Frans voor shocks (A).

## nlNL

- **RISICO (betekenis) `FDG_STRAT_10_D2`** — EN "he **may** turn to someone else"; nlNL "dan richt hij zich een tijdje op
  iemand anders" maakt het zeker. deDE ("vielleicht") en frFR ("il peut") hebben het wel. Fix: "… dan kan hij zich een
  tijdje op iemand anders richten."
- **RISICO (taal) `FDG_BRS_11_T`** — "Brand de cipiers neer" leest als "steek ze in brand". Fix: "Dood de cipiers snel met
  area attacks; healers en ranged blijven weg van hem."
- Geen "spreuk(en)" in alle `FDG_`/`FDGP_`-regels (G: 0; positieve controle: 27 regels met "spells" in dezelfde soort
  grep). Spelnamen Engels en gelijk aan enUS (Egg of Hakkar, Hakkari Bloodkeeper, Old Ironbark, Mizzle the Crafty,
  Omokk's Head, Soulbound Keepsake, Key to the City, Dead Man's Plea, …). FDGP Engels = enUS-clientnaam (G:
  GroupFinderActivity Forever enUS 813-816/1603: "Dire Maul (East)", "Stratholme (Main Gate)", "Stratholme (Service Gate)").

## Naamplaatje-klus (`dg2_plate_changes.tsv`, alle `FDG_*`-regels)

- deDE: 0 oude namen gevonden. Gezocht (regex, ook delen/verbogen): Grünhaut, Pein, Krümel, Rotkralle, Silberlein,
  Grüntal, Tiefenzorn, Alter/Alten Serra, Klingenflanke, Schönufer, Weißsträhne, Nar'gurk, Kapitän, Handlanger,
  Hochinquisitorin (G). Positieve controle: "Whitemane" in `FDG_SM_11_T` gevonden (= de dg2n-regel staat erin).
- frFR: 0 oude namen. Gezocht: Châtiment, Rethiltripe, Printeval, Furie-du-fond, Disperseur, Thermojoncteur, Malépine,
  Déchaîné, Vislar, Hérode, Blanchetête, gardien en pierre, Martel-de-Feu, Grimelok, Féticheur, Mâchentrailles, Noxcion,
  Kadenaz, Bricoleur (G). Positieve controle: Thermaplugg (`GNOMER_6_D1`), Whitemane (`SM_11_T`), Grimlok (`ULDA_7_T`)
  gevonden = de drie dg2n-regels staan in de repo.
- nlNL: niet van toepassing (de lijst heeft geen nlNL; nlNL gebruikt de enUS-namen).
- Alle `FDG_`-regels staan alleen in de 8 genoemde locale-bestanden (G: grep over alle `.lua` in de addon).

## Alle drie

- Geen recht `"` in de tekst (G: 0 FDG-regels; dezelfde regex vindt 121/7/5 andere regels met een `"` erin = positieve
  controle). Geen markup in scope (G: alleen `FDG_FROM_FMT` met `%s`, buiten scope = positieve controle).
- Main Hand ≠ One-Hand klopt overal: `DIRE_L1`, `DIRE_L7`, `BRS_L5` = Waffenhand / main droite / main-hand; `ST_L3`,
  `DIRE_L2`, `STRAT_L2`, `STRAT_L5`, `SCHOLO_L2` = Einhand / à une main / one-hand (G: Forever GlobalStrings
  INVTYPE_WEAPONMAINHAND "Waffenhand"/"Main droite", INVTYPE_WEAPON "Einhändig"/"À une main").
- Stat- en slotwoorden (G, GlobalStrings Forever 1.60.1.70959): Zaubermacht/Puissance des sorts, Beweglichkeit/Agilité,
  Stärke/Force, Intelligenz, Ausdauer/Endurance, Rüstung/armure, Schmuck/Bijou, Verteidigung/Défense, Ausweichen/esquive,
  Schildhand. Item-rollen volgen de stap-1-vorm ("Brustteil aus Platte", "Klassen mit Beweglichkeit", "plastron en
  plaques", "classes à Agilité").
- Getallen, richtingen (zes schreinen), "Optional/Optioneel/Facultatif" (16 regels), "A rare" (10 regels), eerst/laatst
  en wie-doet-wat: regel voor regel gelijk aan enUS (A, gelezen).
- FDGP (G): deDE Ost/Nord/West = GroupFinderActivity 813-815 "Düsterbruch (Ost/West/Nord)"; "Untere/Obere
  Blackrockspitze" = 812/837 (let op: LFGDungeons 31/43 zegt "Untere/Obere Schwarzfelsspitze", maar Map 229 =
  "Blackrockspitze" en de groepzoeker zegt Blackrockspitze: de vertaling volgt de groepzoeker, goed); "Haupttor" = 816,
  "Dienstbotentor" = 1603. frFR Est/Nord/Ouest = LFGDungeons 33/35/37 "Haches-Tripes - Est/Ouest/Nord"; "Bas/Sommet du
  pic Rochenoire" = 812/837; "Porte principale"/"Porte de service" = 816/1603 ("porte principale", "porte de service").
- Niet te meten, Engels gebleven (goed volgens de brief): Pit of Refuse, East/West Garrison, Shrine of Thaurissan, Black
  Anvil, Black Vault, Hall of Crafting, Dark Iron Highway, Manufactory, Grim Guzzler, Summoners' Tomb, Imperial Seat,
  Scarlet Bastion, Slaughter Square, Slaughter House, Archival/Titan Panel, Tor'Rel. Bewijs (G): AreaTable Forever 0 rijen
  op "Guzzler"/"Refuse" en op ParentAreaID 1584/1583/2017/2057/1477 (alleen "The Maul UNUSED"), terwijl "Ambermill" in
  dezelfde tabel 1 rij geeft; retail AreaTable onder die ouders alleen "Halls of Binding" en de twee Strat-poorten;
  retail UiMapGroupMember heeft van deze plekken alleen Crusader's Square (zie RISICO hierboven).
- Zijopmerking buiten mijn talen (G): de retail-kaartnaam is "Crusader's Square" (UiMapGroupMember 536 enUS), enUS/nlNL
  schrijven "Crusaders' Square" (`STRAT_6_D1`). Forever niet te meten; ter beslissing aan de bouwchat.

## Nagemeten namen (G, 18 nov 2026; deDE en frFR elk dezelfde lijst, ruim 25 per taal)

Bron A = Wowhead Forever tooltip (`run gamedata npc|item|quest|object … --game forever --locale xxXX`,
nether.wowhead.com/forever); bron B = wago DB2 Forever build 1.60.1.70959; bron R = wago DB2 RETAIL 12.1.5.70961.
Alle namen hieronder staan zo in de vertaling (✓), behalve waar FOUT/RISICO staat. enUS-id's eerst gecontroleerd.

- npc (A), 22: 5711 Ogom der Elende / Ogom le Misérable, 8438 Blutbewahrer der Hakkari / Garde de sang Hakkar'i,
  9042 Verek, 9503 Gefreiter Rocknot / Soldat Rocknot, 9039 Un'rel / Tragi'rel (EN Doom'rel), 9956 Flammenbewahrer der
  Schattenschmiede / Gardien des flammes Ombreforge, 11491 Eisenborke der Große / Vieil Ecorcefer, 14349 Pimgib,
  14353 Mizzle der Gewiefte / Mizzle l'Ingénieux, 14308 Ferra, 10799 Warosh, 10339 Gyth, 10683 Krähenhorstbrutwächter /
  Démolisseur de la colonie, 10814 Chromatische Elitewache / Garde d'élite chromatique, 14861 Blutdiener von Kirtonos /
  Régisseuse sanglante de Kirtonos, 11082 Kurier von Stratholme / Messager de Stratholme, 11054 Scharlachroter
  Scharfschütze / Fusillier cramoisi, 10812 Oberster Kreuzzügler Dathrohan / Grand croisé Dathrohan, 10399
  Thuzadinakolyth / Acolyte Thuzadin, 10917 Aurius, 11033 Smokey LaRue, 11216 Eva Sarkhoff.
- bazen-naamplaatjes (A), 12: 5721 Traumsense / Fauche-rêve, 5720 Wirker / Tisserand, 5709 Eranikus' Schemen / Ombre
  d'Eranikus, 9319 Hundemeister Grebmar / Maître-chien Grebmar, 9476 Wachmann Stahlgriff / Sentinelle Doomgrip, 11490
  Zevrim Dornhuf / Zevrim Thornhoof, 10596 Mutter Glimmernetz / Matriarche Couveuse, 10268 Gizrul der Geifernde / Gizrul
  l'esclavagiste, 10508 Ras Frostraunen / Ras Murmegivre, 10436 Baroness Anastari / Baronne Anastari, 247207 Behemoth des
  Schwarzschlunds / Béhémoth noiregueule, 9502 Phalanx / Phalange. Alle gelijk aan het `names`-veld.
- item (B ItemSparse), 27: 3829 Frostöl / Huile glaciale, 10465 Ei von Hakkar / Oeuf d'Hakkar, 11000 Schlüssel zur
  Schattenschmiede / Clé ombreforge, 11140 Gefängniszellenschlüssel / Clé de la prison, 11184-11188 Blauer/Grüner/Roter/
  Gelber Machtkristall / Cristal de puissance bleu/vert/rouge/jaune, 11309 Das Herz des Berges / Le Coeur de la montagne,
  12324 Geschmiedetes Siegel des Aufstiegs / Sceau d'ascension forgé (12344 zelf = placeholder "[Seal of Ascension]" in
  A; "Siegel des Aufstiegs"/"Sceau d'ascension" dus A), 12382 Schlüssel zur Stadt / Clé de la ville, 12533 Beschlagene
  Pike / Pique de fortune, 12534 Omokks Kopf / Tête d'Omokk, 12845 Medaillon des Glaubens / Médaillon de foi, 13523 Das
  Blut Unschuldiger / Sang des innocents, 13704 Skelettschlüssel / Clé squelette, 13873 Schlüssel zum Vorführraum / Clé
  de la Chambre des visions, 15994 Thoriumapparat / Rouage en thorium, 18249 Mondsichelschlüssel / Clé en croissant,
  18258 Ogeranzug der Gordok / Tenue d'ogre gordok, 18594 Mächtige Zephyriumladung / Puissante charge d'hydroglycérine,
  10999 Ironfel / Souillefer, 13752 Seelengebund. Andenken / Souvenir lié, 13725 Krastinovs Tasche der Schrecken / Sac
  des horreurs de Krastinov, 12847/12848 Seelen-/Blutbefleckte Pike / Pique tachée d'âme/de sang.
- quest (A), 3: 5505 Der Schlüssel zur Scholomance / La clé de Scholomance, 4771 Dämmerungstrickfalle / Le gambit de
  l'aube (questtekst bevestigt ook "Vorführraum"/"Chambre des visions"), 8945 Die letzte Bitte eines toten Mannes / La
  supplique du mort.
- object (A), 5: 160836 Reliktkasten / Coffre aux reliques, 161495 Geheimsafe / Coffre secret, 169243 Truhe der Sieben /
  Coffre des sept, 175245 Vater Flamme / Flamme du père, 173232 Schmiedekunstpläne / Plans de forgeron.
- plekken: R UiMapGroupMember 527 Schwarzfausthalle / Salle de Main-Noire, 535 Arbeitszimmer des Direktors / Bureau du
  proviseur, 536 Kreuzzüglerplatz / Place des Croisés (RISICO). B Map 229 deDE "Blackrockspitze", 230 "Blackrocktiefen".
