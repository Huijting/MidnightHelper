# Plan — "Midnight Helper Forever" (5 nov 2026)

Rob, 5 nov, terwijl hij WoW Forever speelt met EllesmereUI: *"is het niet slimmer om daar een afgeslankte versie van
voor te maken … we hebben al een hele engine"* → *"Ja, uitzoeken"*. **Alleen onderzoek, niets gebouwd.**
Twee helpers: mh-sweep (indeling van MH) en mh-research (wat Forever kan). Hun hoofdpunten heb ik zelf nagelezen
(staat erbij). Niets in de Forever-client zelf gezien.

## Wat vaststaat

| bewering | hoe | bron |
|---|---|---|
| MH staat niet in `E:\World of Warcraft\_forever_\Interface\AddOns\` | GEMETEN (zelf) | Glob 5 nov |
| MH's TOC heeft geen 16001 (alleen 120007-120107) | GEMETEN (zelf) | `MidnightHelper.toc:1` |
| Forever = Interface **16001**, speltype `camelot` | GEMETEN (zelf) | `EllesmereUIForeverEssentials_Camelot.toc:1-2` (`## AllowLoadGameType: camelot`) |
| Een tweede TOC `<naam>_Camelot.toc` in dezelfde map laadt alleen op Forever | GEMETEN (zelf, voorbeeld EllesmereUI) + wiki TOC_format (5 nov) | idem |
| EllesmereUI-balken gebruiken gewone action-slots | GEMETEN (zelf) | `EUI_ActionBars_Bars.lua:357` `SetAttribute("action", slot)` |
| MH leest specs al via `C_SpecializationInfo` (die bestaat op Forever; de oude globale `GetSpecialization` niet) | GEMETEN (zelf) | `Core.lua:47-63`; Forever-kant: Blizzards UI-bron (branch `forever`, 4 nov) |
| Forever heeft **één spec per class**, ID's 1482-1491 (Mage 1482 … Warrior 1491) | GEMETEN in EllesmereUI (zelf gelezen), niet in Blizzard-data | `EllesmereUI_Presets.lua:180-184` |
| Spells hebben **ranks**: elke rank een eigen spell-ID met dezelfde naam | GEMETEN (zelf, EllesmereUI's code) | `EllesmereUIForeverEssentials_Uprank.lua:22-39` |
| PlaceAction / PickupAction / SetBinding / SaveBindings / C_Spell.PickupSpell / C_SpellBook bestaan; slots 1-180 | mh-research: wiki-dump (beta, 25 sep) + EllesmereUI | AFGELEID dat ze op live hetzelfde doen |
| Wegwijzers (C_Map.SetUserWaypoint, C_SuperTrack), Edit Mode, secret values: zijn er | mh-research, idem | — |
| Geen inhoud voor Delves, Mythic+, Vault, Encounter Journal, ExtraActionButton | mh-research (EllesmereUI-commentaar + Blizzard-TOC's) | de API-namen bestaan wél → poort op "is dit Forever", niet op `if C_X then` |
| Instellingen die niet terugkomen na inloggen | alleen beta-meldingen (sep) | **onbekend op live** |

## MH in vier stapels (mh-sweep, 315 bestanden in de TOC)

- **Motor — 50:** Core, UI, Config, talen, venster/pop-ups, zoekbalk, pijl, instellingen, Home.
- **Algemeen — 145:** toetsen en balken (toetsenblok, `/mh apply`, macro's), consumables, groep- en combat-hulp,
  gear, mounts, beroepen, reizen. Plus ~20 meet-probes die in Forever niet mee hoeven.
- **Alleen Midnight — 69:** delves, Valeera, Labyrinth, rituals, vault, M+, raids/dungeons van nu, seizoen,
  rares/schatten, Codex.
- **Alleen data — 51**, grotendeels voor Midnight.

**Goed nieuws (zelf nagekeken):** de motor roept de Midnight-onderdelen niet blind aan. Bij de aanroepen die ik zelf
nakeek staat steeds een `if ns.X then` ervoor (o.a. `UI.lua:1584`, `:1610`, `:1619`). Dus: Midnight-bestanden weglaten
uit de Forever-TOC geeft waarschijnlijk geen foutmeldingen. AFGELEID: niet élke aanroep is nagekeken.

**Het toetsenblok:** de spell-lijsten (`KeybindRoles_*.lua`) gaan per spell-NAAM, met daarbij voor welke retail-spec
(bv. Warrior Arms 71). `KeybindSpecID()` (`KeybindAutoMap.lua:266-293`) zou op Forever spec 1491 krijgen. Die staat in
geen enkele lijst. Wat er dan gebeurt, weet ik niet zeker. Spells die MH niet kent, gaan volgens `KeyBlock.lua:377-379`
naar een vrije Alt-plek op blok D. Maar als geen enkele spell in een lijst staat, stopt `Build()` al eerder
(`KeyBlock.lua:373`: lege lijst → geen blok). Dus: óf een blok zonder vaste betekenis per plek, óf helemaal geen blok. Voor een echt blok moeten
we per Forever-class een lijst maken: 9 classes (geen DK, Monk, DH, Evoker), spells uit vanilla, plus de ranks.

## Mijn advies

Eén code, twee TOC's: `MidnightHelper_Camelot.toc` in dezelfde map, met als titel *"Midnight Helper Forever"*. Niet
kopiëren: een kopie loopt na een paar weken uit elkaar.

**Stap 1 — laadt de motor? (klein)**
- Forever-TOC met alleen de motor + toetsen/balken + pijl. Alles van Midnight blijft eruit.
- Home moet anders: die is nu vol Midnight-blokken (die zwijgen dan, maar wat blijft er over?). Eerste versie:
  Home toont alleen wat er in Forever is.
- MH moet in de Forever-map komen. De repo staat in de retail-map, dus: een kopieerscript zoals
  `copy_to_ptr.bat`, of een koppeling (junction) naar dezelfde map. **Rob kiest.**
- Test: Rob doet `/reload` in Forever, BugSack leeg, `/mh` opent.

**Stap 2 — het toetsenblok voor Forever (groter)**
- Eerst meten in de client: per class je spellboek naar `ns.db` schrijven (namen, ID's, ranks). Rob logt per class in
  (hij heeft er misschien maar één of twee).
- Dan per class een lijst: welke spell op welke vaste plek. Ranks: altijd de hoogste, en bij een nieuwe rank schuift
  EllesmereUI hem al door (die optie staat bij hem standaard uit, `Uprank.lua:13`).

**Stap 3 — later: uitleggen.** Blizzard legt in Forever bewust niets uit (geen Dungeon Journal). Uitleggen is waar MH
goed in is ([[mh-market-position]]). Maar Zygor Forever en "WoW Forever Builds" doen al dungeons en talenten. Eerst
stap 1 en 2.

## Wat Rob moet kiezen

1. Doen we stap 1?
2. Hoe komt MH in de Forever-map: kopieerscript of koppeling?
3. Welke class speel je in Forever? Dan beginnen we stap 2 met die.
4. CurseForge: hetzelfde project met een Forever-bestand, of later? **Weet ik niet** of CF dat zo kan (niet nagekeken).
