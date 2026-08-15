# Codex-herontwerp — Robs vier punten

Rob, 15 aug 2026, na het lezen van het nieuwe Vaults-artikel:

> *"ik moet eerlijk zeggen dat ik de hele codex niet echt overzichtelijk en makkelijk is,
> misschien omdat er teveel info over alles instaat, de vault staat bv bij ritual en void
> ?!? , dat moet toch beter kunnen, alle 12.* bij en door elkaar ??"*

Gevraagd waar het vooral in zit, koos hij **alle vier** de opties. Dat is geen aanpassing
meer maar een herontwerp, en het is niet op een releasedag te doen.

⚠️ **Dit is een plan, geen opdracht om vandaag te bouwen.** Wat hieronder al gedaan is,
staat als ✅.

---

## ✅ Al gedaan op 15 aug

- **De Vaults staan niet meer bij "Void & Rituals".** Nieuwe categorie `coiledisle` —
  een *plek*, geen patchnummer. Spelers zoeken op "waar ga ik heen"; een lade met "12.1"
  erop is achterhaald zodra 12.2 bestaat.
- **De kop noemt geen seizoen meer.** Stond in alle zeven talen als "Season 1 handbook",
  en drie talen vertaalden het woord ("Saison 1", "Temporada 1") — één anker vond dus maar
  de helft. Season 2 opent 18 aug; over drie dagen was die zin aantoonbaar onwaar geweest.

---

## 1. Artikelen zijn te lang

Het Vaults-artikel is nu tien alinea's in één blok. Het beantwoordt "wat is het", "hoe kom
ik binnen", "wat is de currency", "waar gaan de munten heen", "wat zijn de Discoveries",
"waar liggen twaalf gedenktekens" en "hoe zit het met de rares" — zeven vragen in één scherm.

**Richting:** één artikel = één vraag. Korte artikelen die naar elkaar verwijzen, in plaats
van één lang artikel dat alles afdekt. De Discoveries en de gedenkteken-route zijn duidelijk
eigen artikelen.

⚠️ Niet blind opknippen. Een lezer die drie keer moet doorklikken voor één antwoord heeft
het niet beter. De test is of elk artikel op zichzelf een vraag beantwoordt die iemand
daadwerkelijk stelt.

## 2. Te veel categorieën / verkeerde indeling

Er zijn er negen. `world` ("Void & Rituals") was er één met negen artikelen uit drie
patches — de naam dekte een derde van de inhoud en verstopte de rest. Dat is gerepareerd
voor de Vaults, maar Turbulent Timeways, Prey Hunts, Rares, Showdowns en Ritual Renown
zitten er nog steeds samen in.

**Richting:** elke categorie krijgt een naam die de héle inhoud dekt, of hij wordt gesplitst.
Als een naam niet te vinden is, is de categorie verkeerd getrokken.

## 3. Season 1 en Season 2 lopen door elkaar

De kop is gerepareerd, maar een sweep over `Locales/` vond nog tientallen plekken:
`DungeonGuide` (rotatie, badges), `MythicPlus` ("Mythic+ — Season 1"), `ConsumablesNotes`,
`RaidTips`, `MACROS_CONSUMABLES_SUBTITLE`, `INFO_DRAWER_BODY_CONSUMABLES`.

Er staat al scaffolding: `MPLUS_AFFIX_UNMEASURED` zegt eerlijk dat Season 2 de affixen
veranderde en dat wij ze niet gemeten hebben. Dat is het juiste patroon — zeggen wat je
niet weet in plaats van een S1-lijst als actueel presenteren.

**Richting:** vóór 18 aug alles langs waar een seizoensnummer *als feit* staat. Wat S1-only
is en blijft, hoort achter de bestaande seizoenspoort weg te vouwen. Wat nog niet gemeten
is, zegt dat.

⚠️ Dit is het enige punt met een **harde datum**. 18 augustus.

## 4. Je vindt niet terug wat je zoekt

Rob zelf, in dezelfde sessie: *"inmiddels ben ik kwijt waar ik allemaal naar moet kijken"* —
over de addon én over onze eigen takenlijst.

**Richting:** de zoekfunctie prominenter, of een startpagina die naar artikelen wijst in
plaats van naar categorieën. Er ís al een zoekindex (die op 12 aug gerepareerd is toen
bleek dat mounts, raids en toolslaunch er niet in zaten).

---

## Volgorde als dit opgepakt wordt

1. **Punt 3 eerst** — die heeft een deadline en is het minst ontwerpwerk.
2. Dan **punt 2**, want de indeling bepaalt waar de opgeknipte artikelen heen gaan.
3. Dan **punt 1**, het opknippen zelf.
4. **Punt 4** als laatste — pas zinvol als de rest klopt.

Niet in één release. En niet zonder Robs oordeel per stap: hij is de enige die ziet of het
schérm rustiger wordt, en dat is het hele doel.
