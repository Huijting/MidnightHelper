# Openables.lua - onafhankelijke controle (18 nov 2026)

Bestand: `MidnightHelper/Modules/Openables.lua` (722 regels, helemaal gelezen). Repo niet aangeraakt, geen git.

Bronnen:
- **UI-bron Forever**: Gethe/wow-ui-source, branch `forever`, commit 3d8abb1 "1.60.1 (70959)" van 17 nov 2026 = dezelfde build als Rob.
  Gelezen: ContainerDocumentation, ItemDocumentation, TooltipInfo(Shared)Documentation, BagIndexConstants,
  SecureTemplates.lua, SecureStateDriver.lua, ChatFrameUtil.lua, Mainline/ContainerFrame.lua, TooltipDataHandler.lua.
- **DB2 Forever** build 1.60.1.70959 via `run gamedata` (18 nov): GlobalStrings, ItemSparse, Spell.
- **Wowhead Forever-tooltips** via `run gamedata item` (18 nov).
- **Kandidaten, geen bewijs**: Syndicator en Baganator in `_forever_\Interface\AddOns`.
- **Oude versie**: de PTR-kopie van 10 okt. `diff` met de huidige versie laat precies de blokken van 18 nov zien, verder niets (GEMETEN).

Kort: **ik vond geen harde FOUT.** Wel 4 risico's die het repareren waard zijn (R1 t/m R4 hieronder).

---

## 1. `hasLoot` in Forever

- **OK - het veld bestaat.** GEMETEN: ContainerDocumentation (Forever) noemt `hasLoot`, type bool, Nilable=false.
- **Waarvoor gebruikt Blizzard het?** GEMETEN: in Mainline/ContainerFrame.lua (Forever) betekent het "dit item kun je
  openen om te looten". Het wordt gebruikt bij de autoloot-klik (r. 1685-1691) en bij de gamepad-actie "Open" (r. 3185-3195).
  Over lockboxes op slot staat er niets in de documentatie.
- **Waarvoor is het true?** Dat is AFGELEID: de client zelf heb ik niet gemeten. Het bewijs:
  - GEMETEN: ItemSparse `Flags_0` heeft bit 0x4 bij de clam 5523 én bij de lockboxes 16882, 16885 en 4632. Die drie
    zijn allemaal op slot (LockID 5 of 599).
  - GEMETEN: bit 0x4 staat NIET aan bij de tassen 856, 4496 en 5571 (Flags_0 = 0).
  - GEMETEN: bij 40 van de 554 items die een quest starten staat bit 0x4 ook niet aan.
  - Kandidaat: Syndicator `LockedCheck` (CheckItem.lua:916-933) eist eerst `hasLoot` en kijkt daarna of er een regel
    `LOCKED` is. De makers gaan er dus van uit dat een lockbox op slot `hasLoot = true` heeft.
  - Wat ik daaruit afleid: true voor clams en lockboxes (ook op slot); false voor lege tassen en quest-starters.
- **Gevolg voor de code (r. 266):** OK in het normale geval. SlotKind geeft bij een doos op slot eerst "locked" terug,
  en daarom slaat r. 266 de `hasLoot`-terugval over.
- **R1 RISICO (AFGELEID):** soms valt een doos op slot tóch via `hasLoot` in de lijst, met kind "openable". Dat kan op twee manieren:
  (a) de tooltip is nog niet geladen, dan zijn er geen regels en geeft SlotKind nil. Dat is tijdelijk: GET_ITEM_INFO_RECEIVED
  en BAG_UPDATE scannen opnieuw.
  (b) er komt een rode regel vóór "Locked". Dan geeft r. 104-105 al eerder `nil` terug. Volgens de Wowhead-tooltip komt
  "Locked" direct na "Item Level", dus waarschijnlijk vóór elke "Requires"-regel.
  Algemener: `hasLoot` gaat óm het rode-vereiste-filter heen. Een container met een rode eis die geen level-eis is
  (beroep, reputatie) komt toch in de lijst. Dat was al zo vóór 18 nov.

## 2. `ITEM_OPENABLE` en `LOCKED`

- **OK (enUS, GEMETEN)** in Forever GlobalStrings:
  - 10665 `LOCKED` = "Locked"
  - 10666 `ITEM_OPENABLE` = "<Right Click to Open>"
  - deDE: "Verschlossen" / "<Zum Öffnen rechtsklicken>"
  - frFR: "Verrouillé(e)" / "<Clic droit pour ouvrir>"
- **OK (GEMETEN, Wowhead Forever enUS):** "Locked" staat als eigen regel bij 16882, 16885 en 4632. Bij die drie staat
  géén "<Right Click to Open>". Clam 5523 heeft wél "<Right Click to Open>".
- **OK, de opbouw:** de vergelijking op r. 101 staat vóór het rode-regel-filter en geeft altijd "locked" terug. Ook als
  "<Right Click to Open>" boven "Locked" zou staan, wint "locked".
- **RISICO, andere talen (niet in de client gemeten):** in enUS hebben minstens 9 tags de tekst "Locked" (LOCKED,
  CAMERA_LOCKED, GLYPH_LOCKED, TALENT_TREE_LOCKED, PET_STABLE_SLOT_LOCKED, REALM_LOCKED, PET_JOURNAL_READONLY,
  JAILERS_TOWER_REWARD_LOCKED, DELVES_CURIO_LOCKED; GEMETEN). Welke tag de C++-tooltip gebruikt, staat niet in de UI-bron.
  In het Frans verschillen ze wél: `LOCKED` = "Verrouillé(e)", de andere zeven = "Verrouillé" (GEMETEN). Wowhead frFR
  toont "Verrouillé". Maar Wowhead schrijft ook "<Clic Droit pour Ouvrir>", met andere hoofdletters dan ITEM_OPENABLE.
  Wowhead gebruikt dus eigen teksten en bewijst niets. Kandidaat: Syndicator en Baganator vergelijken ook `== LOCKED`.
  Als de Franse client "Verrouillé" toont, werkt r. 101 in het Frans nooit. Dan zie je het oude gedrag: de doos staat
  in de lijst en de klik zegt dat het item op slot zit. Gevaarlijk is dat niet, maar de wijziging van 18 nov werkt daar dan niet.
  esES, esMX, ptBR, itIT, ruRU, koKR en zh heb ik niet gemeten.

## 3. Secure knop

- **OK (GEMETEN, Forever SecureTemplates.lua r. 418-439):** `type="item"` bestaat.
  Met `item="item:<id>"` gaat het zo: `SecureCmdItemParse` vindt geen "tas vak"-patroon, dan volgt
  `SecureCmdUseItem` → `C_Item.UseItemByName("item:<id>")` (ChatFrameUtil.lua r. 1212-1236).
  Let op: is het item uitrustbaar, dan doet dezelfde actie `EquipItemByName` (r. 433-434). Een tas mag dus nooit in de
  lijst komen. Dat gebeurt ook niet: zie punt 5.
- **OK (GEMETEN, SecureStateDriver.lua r. 95-117):** in combat geeft `"[combat] hide; nil"` een Hide.
  Buiten combat geeft "nil" géén Show of Hide; de addon regelt het zelf.
  PLAYER_REGEN_DISABLED zet de timer op 0 (r. 142-143 en 193), dus de knop verdwijnt binnen één frame.
- **OK (GEMETEN, r. 724 en 787-789):** loslaten gebruikt het attribuut `typerelease`. Dat is nil, dus één klik =
  hooguit één keer gebruiken, ook met "AnyUp"+"AnyDown".
- **Klik in combat:** dat kan alleen in dat ene frame vóór het verbergen. Dan loopt de secure actie en beslist het spel
  zelf; daar zit geen taint in. Of een container in combat open mag in Forever, heb ik niet gemeten.
- **OK:** attributen worden alleen buiten combat gezet (r. 370), en `Show` ook (na de return op r. 561).
- **R2 RISICO (AFGELEID), r. 554-557:** `frame:Hide()` staat daar zonder combat-check. Dat gaat mis bij `/mh open off`, of bij de
  schakelaar in SettingsDefs.lua:494 en ForeverOverview.lua:1192, als je hem in combat omzet. Hide op een beschermd
  frame in combat geeft dan waarschijnlijk ADDON_ACTION_BLOCKED, ook al is de knop al verborgen. Dat heb ik niet gemeten.
  Oplossing: daar ook `InCombatLockdown()` checken en het uitzetten doen bij PLAYER_REGEN_ENABLED.
- **R3 RISICO (AFGELEID), r. 374-375: hetzelfde itemID.** `UseItemByName("item:16885")` kiest zelf welk vak het pakt.
  Stel: een rogue heeft twee Heavy Junkboxes, één opengepikt en één nog op slot. MH biedt de opengepikte aan, maar de
  klik kan de doos op slot pakken. Dan krijg je "Item is locked." (ERR_ITEM_LOCKED, GEMETEN) en gaat er niets open,
  ook niet bij opnieuw klikken. Welk vak de client kiest, heb ik niet gemeten.
  Opties voor Rob:
  (a) in Forever het attribuut "tas vak" gebruiken. Dat wordt `C_Container.UseContainerItem`, GEMETEN in
      SecureCmdUseItem. Het bezwaar uit r. 369 ("het vak loopt leeg") wordt kleiner, want BAG_UPDATE_DELAYED bouwt de
      lijst toch opnieuw.
  (b) alleen "tas vak" gebruiken als er van hetzelfde itemID ook een doos op slot in je tassen zit.

## 4. Midnight (retail) ongewijzigd

- **OK:** de diff met de kopie van 10 okt bevat alleen de 18-nov-blokken (GEMETEN).
- **OK:** in retail is `ns.IS_FOREVER` false (Core.lua:58, interface 16000-19999), dus r. 101 slaat over. SlotKind
  geeft daar nooit "locked", dus r. 269-272 doet niets. De tellers kosten vrijwel niets en veranderen geen gedrag.
- **OK, maar overbodig - r. 328-330:** `ns.db.ui` is in beide spellen altijd een tabel. Dat komt door MergeDefaults
  (Core.lua:186, 313-325, 418), en Core.lua laadt in beide tocs. Dat heb ik in de code gelezen, niet in de client gemeten.
  Het commentaar "Forever's saved table may not have `ui` yet" klopt dus waarschijnlijk niet. De regels kunnen geen kwaad.
- **OK, /mh open:** dit is ook in retail nieuw. Vroeger kwam "open" bij UNKNOWN_COMMAND terecht (Core.lua:4424-4428).
  Geen enkele andere handler in Core.lua matcht "open"; dat heb ik met grep op "open" nagelopen. "/mh openables" matcht
  niet, want er moet een spatie na "open" komen.
- **Opmerking, geen nieuwe fout:** in retail komen lockboxes op slot nog steeds via `hasLoot` in de lijst. Dat is
  bewust zo gelaten ("Midnight's list stays exactly as it was").

## 5. Forever-gevallen

- **Quest-items die een quest starten - OK, niet aangeboden.** Ze matchen geen enkel patroon. Bij de 40 gemeten
  quest-starters staat bit 0x4 niet aan (GEMETEN).
- **Lege tassen - OK, niet aangeboden.** De 3 gemeten tassen hebben Flags_0 = 0 (GEMETEN) en geen "<Right Click to Open>".
  Dat is belangrijk, want de secure actie zou een tas uitrusten (punt 3).
- **Sleutels - OK.** Ze matchen niets. De Keyring is tas -1 en wordt niet gescand (GEMETEN, BagIndexConstants).
  Tassen 0 t/m 5 kloppen met Forever: 5 = ReagentBag.
- **Clams - OK** (GEMETEN, 5523 via Wowhead plus bit 0x4).
- **Lockboxes en juwelendozen voor de rogue - OK zolang ze op slot zijn** (niet aangeboden, `/mh open` telt ze).
  Na Pick Lock worden ze wel aangeboden, maar dan geldt R3.
- **Items met een cooldown:** daar wordt niet op gecheckt. De klik geeft dan alleen de melding "not ready". Klein risico.
- **Level-eis - OK.** `select(5, C_Item.GetItemInfo())` = itemMinLevel (GEMETEN, ItemDocumentation r. 642). Is de
  item-info nog niet binnen, dan staat het item heel even in de lijst, tot GET_ITEM_INFO_RECEIVED komt.
- **R4 RISICO, andere taal:** "use:", "open to", "collect %d", "teaches you", "this appearance" en "knowledge" zijn Engels.
  GEMETEN: `ITEM_SPELL_TRIGGER_ONUSE` = "Benutzen:" in deDE en "Utiliser :" in frFR. Op die clients werken deze takken
  nooit. Dan valt er alleen iets weg (er wordt niets verkeerds aangeboden), maar het gedrag verschilt per taal.
  Kandidaat voor een test zonder taal: in Forever bestaat `Enum.TooltipDataLineType.ItemSpellTriggerLearn` (38), ook
  ErrorLine (41) en UsageRequirement (43) (GEMETEN, TooltipInfoSharedDocumentation). Of een recept-regel echt type 38
  heeft, heb ik niet gemeten.
- **"learn" hoort erbij in Forever.** GEMETEN, Wowhead Forever: 728 Recipe: Westfall Stew = "Use: Teaches you how to cook
  Westfall Stew." en 2553 = "Use: Teaches you how to make an Elixir of Minor Agility."
  Een rode "Requires Cooking (75)" filtert het recept goed weg.
  Bijeffect (AFGELEID): de recept-tooltip bevat ook de tooltip van het gemaakte item, met "Requires Level 5". Is je
  level te laag, dan staat die regel in het rood en verdwijnt het recept, ook al kun je het wel leren. Dan valt er
  alleen iets weg. Dit werkt alleen op een Engelse client.
- **"knowledge" doet niets in Forever, en kan ook geen kwaad.** GEMETEN: geen enkele Forever-spellbeschrijving (9
  stuks) en geen enkele item-flavortekst (72 stuks) met "knowledge" bevat ook "read" of "study".
  Een verborgen zwakte (r. 129-130): er is geen "use:"-eis, en "read" matcht ook "already", "ready" en "thread". In de
  Forever-data heb ik geen geval gevonden.

## 6. Overige punten

- **RISICO prestaties (r. 651-699):** elke GET_ITEM_INFO_RECEIVED en ITEM_LOCK_CHANGED start een volledige scan.
  Dat is hooguit eens per 0,3 s, dus maximaal ~3 scans per seconde. In Forever staan Auctionator, Baganator, Syndicator
  en Pawn (GEMETEN in de map); die vragen veel items op. Hoe lang één scan duurt, heb ik niet gemeten.
  Mogelijke oplossing: bij GET_ITEM_INFO_RECEIVED alleen scannen als het itemID in je tassen zit.
- **Klein (r. 251-252):** `SlotKind` bouwt ook voor lege vakken een tooltip. Overslaan als `info == nil`.
- **Klein (r. 266):** eerst `IsSecret`, dan de waarheidstest is veiliger. Voor je eigen tassen speelt het niet.
- **Cosmetisch (r. 711):** "%d to open now" telt ook learn-items en items die door de cap geblokkeerd zijn.
- **Nil-fouten:** geen gevonden in de nieuwe code. `CrestCapBlock` doet in Forever niets, want DawncrestData.lua staat
  niet in de Camelot-toc (GEMETEN; Openables.lua staat er wel, r. 168).
  `leftText` en `leftColor` bestaan in Forever (GEMETEN, TooltipDataHandler.lua r. 339-340).

## Niet gemeten (kan alleen in de client)

1. De echte waarde van `hasLoot` bij een doos op slot. Test: `/dump C_Container.GetContainerItemInfo(tas, vak).hasLoot`.
2. De precieze tekst en plaats van de "Locked"-regel in de client, vooral in het Duits en Frans. Test:
   `/dump C_TooltipInfo.GetBagItem(tas, vak).lines`. Daarmee zie je ook of er een rode regel vóór "Locked" staat.
3. Welk vak `UseItemByName` kiest als er twee items met hetzelfde ID zijn (R3).
4. Of `Hide()` in combat op een al verborgen beschermd frame een blokkade-melding geeft (R2).
5. Of je in Forever een container in combat mag openen.
6. Het line-type van een "Teaches you"-regel (38?), en hoe lang één scan duurt.
