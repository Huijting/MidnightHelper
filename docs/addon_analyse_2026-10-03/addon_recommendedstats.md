# RecommendedStats — analyse (2026-10-03)

Pad: `E:\World of Warcraft\_retail_\Interface\AddOns\RecommendedStats\`
Alles hieronder is **STRIKT READ-ONLY** gelezen. Niets gewijzigd, niets verwijderd, geen git.

Elke bewering is gemarkeerd:
- **GEMETEN** = ik heb het in hun code gelezen (met bestand:regel).
- **AFGELEID** = mijn gevolgtrekking.

Huisregel: een andere addon levert **kandidaten**, nooit bewijs over een game-API. Waar hun code een
spelfeit suggereert, staat erbij dat het **niet tegen de client geverifieerd** is.

---

## 0. Bestandslijst en TOC

**GEMETEN** — `RecommendedStats.toc` (42 regels):
- regel 1: `## Interface: 120100` (12.1.0)
- regel 5: `## Author: CtrlShift_Zed`
- regel 6: `## Version: 2026-10-03` (versie = een datum, geen semver)
- regel 9-10: `## SavedVariables: RecommendedStatsDB` + `## SavedVariablesPerCharacter: RecommendedStatsDBChar`
- regel 11: `## X-License: MIT`
- regel 12: `## X-Wago-ID: 56ndvpG9`
- regel 14-41: laadorde = Libs → Locale (enUS, zhTW, ruRU) → Data (10 bestanden) → Core.lua → Talents.lua → 10 UI-bestanden.
- **GEEN** `## Dependencies`, `## OptionalDeps`, `## LoadOnDemand`.

**GEMETEN** — in de map staan ook mee-geleverd:
- `RecommendedStats_v2.0.0-2026-09-30.zip` (436 KB) — een complete oudere release **binnen** de
  geïnstalleerde map. Slordig; kost schijf en zit in elke backup/upload.
- `icon.tga` (192 KB) — gebruikt als `## IconTexture` (toc:8) en als minimap-icoon
  (`UI/MinimapButton.lua:21`).

**GEMETEN** — datagrootte: `Data/TalentsScoped.lua` 2,06 MB, `Data/BiS.lua` 962 KB,
`Data/Rotation.lua` 542 KB, `Data/Talents.lua` 269 KB. Totaal ~3,9 MB Lua-data.
**AFGELEID** — dat is veel geheugen en parse-tijd bij elke `/reload`; zie §6.

---

## 1. LICENTIE — gevonden, maar zwak onderbouwd

**GEMETEN** — de **enige** licentievermelding in de hele addon staat op één regel:

```
RecommendedStats.toc:11:## X-License: MIT
```

**GEMETEN** — ik heb op `MIT|Copyright|copyright|License|LICENSE|licence` gegrepd over de hele
addonmap. Er is precies **één** hit, die toc-regel. Dus:
- **geen** `LICENSE`/`COPYING`-bestand (ook niet in de Glob-lijst van de map);
- **geen** copyright-header in Core.lua, Talents.lua, of enig UI-/Data-/Locale-bestand;
- **geen** copyrightregel in de meegeleverde libs (zie §1b).

**AFGELEID** — de claim "MIT" is dus **bevestigd als bedoeling van de auteur** (hij zet het zelf in
de TOC, wat CurseForge/Wago als licentieveld uitlezen), maar er is **geen** MIT-tekst en **geen**
copyrighthouder-regel in de levering.

### Wat dat voor hergebruik betekent

MIT eist letterlijk dat "the above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software". **AFGELEID** — die notice bestáát hier niet, dus
je kunt hem ook niet meekopiëren. Praktisch:

- **Veilig genoeg** bij hergebruik van een routine: zet in het eigen bestand een regel als
  `-- Adapted from RecommendedStats (c) CtrlShift_Zed, MIT (## X-License: MIT in its .toc)`
  plus de volledige MIT-tekst in MH's eigen `THIRD_PARTY.md`/`LICENSE`-sectie.
- **Beter**: auteur één keer vragen om een echte `LICENSE` in zijn repo. Dan is het zwart op wit.
- **Voorkeur blijft**: techniek léren, niet code kopiëren. Dat is bij álle vijf kandidaten hieronder
  realistisch, want geen van de routines is lang.

### Kandidaten die écht de moeite waard zijn

| Wat | Waar (GEMETEN) | Oordeel |
|---|---|---|
| **Talent-exportstring decoder** (6-bits base64, bitniveau) | `Talents.lua:34-79` (`Take` + `RS:DecodeLoadout`) | **Beste kandidaat.** Compact, los te trekken, geen afhankelijkheden. Attributie: regel zoals hierboven + MIT-tekst. Formaat gedocumenteerd op `Talents.lua:19-27` — maar dat is hún meting tegen Raider.IO, **niet tegen de client geverifieerd**. |
| **Item-link met bonusIDs bouwen** + nette hyperlink terugbouwen | `BiSWindow.lua:546-551` (`BuildItemLink`), `:559-564` (`BuildDecoratedLink`) | Techniek overnemen, niet de code. Het veldformaat verwijst naar Wowpedia (`:544-545`), niet naar een meting. |
| **Enchant-waarde meten via diff** (`item:<id>:<enchantID>` min `item:<id>`) | `BiSWindow.lua:287-329` | Slimme truc, techniek waard. Hun comment zegt dat `enchant:<id>`-hyperlinks **niet** werken — kandidaat-feit, ongeverifieerd. |
| **Talentboom tekenen uit `posX/posY`** incl. hero-tree centreren op de grootste X-gap | `TalentsWindow.lua:218-427`, gapX op `:311-327` | Techniek. Bevat twee live-gerapporteerde bugfixes (`:292-304`) die je anders zelf tegenkomt. |
| **Secret-value-discipline** (zie §4) | `Core.lua:360-405`, `BiSWindow.lua:243-253` | Alleen als bevestiging van MH's eigen regels. Geen code nodig. |

### 1b. Meegeleverde libraries (niet regel-voor-regel gelezen)

**GEMETEN** — `Libs/Libs.xml` laadt in deze orde:

| Library | Versie (GEMETEN) | Bestand:regel |
|---|---|---|
| LibStub | minor **2** | `Libs/LibStub/LibStub.lua:3` |
| CallbackHandler-1.0 | minor **8** | `Libs/CallbackHandler-1.0/CallbackHandler-1.0.lua:2` |
| LibDataBroker-1.1 | minor **4** | `Libs/LibDataBroker-1.1/LibDataBroker-1.1.lua:5` |
| LibDBIcon-1.0 | minor **55** | `Libs/LibDBIcon-1.0/LibDBIcon-1.0.lua:9` |

**GEMETEN** — `Libs/Libs.xml:6-8`: "Sourced verbatim from Questie/Questie's Libs/ folder … do not
hand-edit; replace the whole file wholesale when updating."
**AFGELEID** — deze libs hebben hun **eigen** licenties (LibStub publiek domein, de andere Ace-/
LDB-achtige voorwaarden). De MIT-claim van de addon dekt ze **niet**. Als MH ooit iets hieruit zou
willen: ga naar de upstream-repo, niet naar deze kopie.

---

## 2. Wat de addon voor de speler doet (functie voor functie)

**GEMETEN** — vier schermen, allemaal bereikbaar vanaf één gedeeld venster met vier gelijke
kopknoppen: Stats, BiS, Talents, Rotation (`UI/CharacterPanel.lua:528-550`).

### 2a. Tab "Stats" — jouw secundaire stats tegen de top-spelers
- Vier rijen: Haste, Crit, Mastery, Versatility (`CharacterPanel.lua:562-564`).
- Per rij: huidige waarde (rating **én** percentage), het doel, een balk met een streepje op het
  doel, en een verdict-label (`Render()`, `:668-782`).
- Verdict: **"Too low"** (rood), **"On target"** (groen, binnen 0,5 procentpunt), **"Over · fine"**
  (blauw) — `Core.lua:374`, kleuren `CharacterPanel.lua:83-88`.
- Tweede, dimmer streepje = het **90e-percentiel** van de top-spelers ("tot hier is nog normaal"),
  `CharacterPanel.lua:286-289` + `:731-743`.
- Keuze Raid / Mythic+ via dropdown; een keuze zonder data wordt grijs gemaakt
  (`:401-422` met `RS:HasDataFor`, `Core.lua:281-289`).
- Vier rijdichtheden: Default / Small / Medium / Large (`:51-59`, `:342-386`). Large zet er een
  "+X.X% vanaf doel"-regel bij.
- Prioriteitsregel ("Haste > Crit > ...") boven de voetregel, met tooltip die zegt hoe het berekend
  is (`:580-596`, `:652-665`).
- Hover op een rij = "sinds je inlogde ben je hier +/- X" (`:311-318`, data uit `Core.lua:341-352`).
- Voetregel: "X van Y spelers · patch Z · bijgewerkt op datum", amber als de data oud is of de
  steekproef klein (`:467-483`).

### 2b. Tab "BiS" — 16 slots met het item dat de top draagt
- 16 slots, cosmetische slots bewust weggelaten (`BiSWindow.lua:54-60`).
- Per rij: icoon met kwaliteitsrand, **stip** (groen = jij hebt precies dit item, geel = runner-up
  óf jouw item is minstens even hoog ilvl, rood = mist), slotnaam, enchant- en gem-icoontjes,
  itemnaam, de eigen rating van het item, "NEW"-tag als de keuze de laatste 7 dagen wijzigde, en
  het percentage topspelers dat dit draagt (`:566-689`, stip-logica `:586-599`).
- Shift-klik linkt het item in chat, Dress-Up-klik toont het in de kleedkamer (`:463-470`) — leest
  de eigen modified-click-instellingen van de speler, niet hardgecodeerde Shift/Ctrl.
- Kopregel: "X spelers", met amber waarschuwing als het BiS-setje **niet** uit Mythic-clears komt
  (`:719-730`).
- Tier-set-regel (2pc/4pc) — **maar** `Data/TierSet.lua:2` is `= {}`, dus deze regel is vandaag
  altijd verborgen. **GEMETEN.**

### 2c. Venster "Talents" — de echte build van een topspeler, getekend
- Eigen venster, ~928×510 px (`TalentsWindow.lua:151`), want de boom past niet in het paneel.
- Eigen Raid/Mythic+-schakelaar plus een dropdown met **per dungeon** (M+) of **per baas** (Raid)
  (`:509-552`, lijst uit `RS:GetTalentEntries`, `Talents.lua:117-130`).
- Toont klasse-, spec- en hero-boom met de echte spelcoördinaten; gekozen nodes goud, de rest grijs
  en ontzadigd (`:361-364`), verbindingslijnen aan/uit (`:411-426`).
- Tooltip per node: het echte spell-tooltip + "gekozen door X% (n van N)" + per keuze-optie het
  percentage (`:163-184`).
- Knop kopieert de **import-string** van de best passende échte build (`:554-561`).
- Belangrijk ontwerpbesluit: **de build is een echte speler-build, geen samengestelde
  meerderheids-build** — "would risk breaking choice nodes and point caps" (`Talents.lua:161-164`).
  Scoring: per node +pick-rate als de build hem heeft, +(1−pick-rate) als niet (`Talents.lua:191-199`).

### 2d. Venster "Rotation" — hoe de top je spec speelt
- Vier kolommen: Opener, Mid Rotation, Filler, When to use CDs (`RotationWindow.lua:38-43`).
- Per hero-talentboom, met schakelaar; kan ook per raidbaas (dropdown) (`:544-568`).
- Spell-ID's uit de data, namen/iconen/tooltips uit de client in de taal van de speler
  (`:7-9`, `:38-42`).
- Toont ook procs: welke knop de proc geeft, welke hem opmaakt, hoeveel stacks
  (data-vorm `Data/Rotation.lua:3`, veld `procs={{buff=,from=,by=,perFight=,up=}}`).
- **GEMETEN**, `:10-11`: "A static reference, not a combat helper: it reads nothing about the fight
  in progress, so it has nothing to do with Secret Values." — dit is bewust géén rotatiehelper.

### 2e. Randzaken
- **Minimap-knop** via LibDataBroker + LibDBIcon (`MinimapButton.lua:16-63`); links = panelen aan/uit,
  rechts = opties. Detecteert een dubbele installatie en print een duidelijke waarschuwing
  (`:53-61`).
- **Optiepaneel** onder Esc → Options → AddOns (`OptionsPanel.lua:247-256`): venster vast/los,
  tabs aan/uit, minimap aan/uit, **kleurenblind-modus**, rijgrootte, skin (Default/Class/Custom
  met colorpicker), skin exporteren/importeren, en een disclaimer.
- **Skin-deelcode** `RSSKIN1:CUSTOM:RRGGBB` (`SkinShare.lua:12-55`).
- **What's New-popup**, één keer per echte feature-release, drie entries: skins (2026-08-27),
  scoped talents (2026-09-22), rotation (2026-09-30) (`WhatsNew.lua:11-40`).
- **Rating-nudge** naar CurseForge na 5 échte logins, één keer ooit (`RatingNudge.lua:11-36`).
- **Slash** `/rs` met `raid`, `mythicplus`/`m+`, `resetpos`, `talents`, `rotation`, `options`,
  `skin export`, `skin import` (`Core.lua:590-629`).
- **Chatmelding** zodra er verse data is geland, één keer per nieuwe datum (`Core.lua:238-248`).

---

## 3. Hoe het technisch werkt

### 3a. Events — volledige lijst (GEMETEN)

| Event | Waar |
|---|---|
| `PLAYER_ENTERING_WORLD` | `Core.lua:571-574`, `UI/WhatsNew.lua:134`, `UI/RatingNudge.lua:35` |
| `PLAYER_SPECIALIZATION_CHANGED` | `Core.lua:571-574`, `UI/TalentsWindow.lua:598`, `UI/RotationWindow.lua:619` |
| `PLAYER_EQUIPMENT_CHANGED` | `Core.lua:571-574` |
| `COMBAT_RATING_UPDATE` | `Core.lua:571-574` |
| `TRAIT_CONFIG_UPDATED` | `UI/RotationWindow.lua:620` |
| `PLAYER_LOGIN` | alleen in de lib: `Libs/LibDBIcon-1.0/LibDBIcon-1.0.lua:352` |

Dat is alles. **GEMETEN** via grep op `RegisterEvent` over de hele map. Geen CLEU, geen
`UNIT_AURA`, geen `UNIT_SPELLCAST_*`.

**GEMETEN** `Core.lua:575-587`: één handler voor alle vier; alleen bij `PLAYER_ENTERING_WORLD`
worden `SyncVisibility`, de data-ping en de login-teller gedaan, waarbij de login-teller alleen
oploopt als `isInitialLogin` (2e argument) waar is — dus **niet** bij `/reload`.

### 3b. Klasse / spec / talenten detecteren

**GEMETEN**:
- Klasse: `UnitClass("player")`, token uit het 2e returnveld (`Core.lua:47`).
- Spec: `GetSpecialization()` + `GetSpecializationInfo(idx)` (`Core.lua:64-67`). **Niet**
  `C_SpecializationInfo.*`. **AFGELEID + ongeverifieerd tegen de client**: of de oude globale
  `GetSpecialization` in 12.1 nog bestaat is hier niet te bewijzen; hun code gebruikt hem wél in een
  live-geïnstalleerde 12.1-addon, dus het is een sterke **kandidaat**, geen bewijs.
- Spec-ID → token-tabel met alle 40 specs, inclusief `[1480] = "DEVOURER"` (`Core.lua:49-63`,
  Devourer op regel 61).
- Sleutelvorm: `KLASSE_SPEC_CONTENT`, bijv. `PALADIN_PROTECTION_RAID` (`Core.lua:256-260`), plus een
  spec-only sleutel voor rotatie (`:263-267`).
- Talentboom: `C_ClassTalents.GetActiveConfigID()`, `C_ClassTalents.GetTraitTreeForSpec(specID)`,
  met terugval op `C_Traits.GetConfigInfo(configID).treeIDs[1]`, dan
  `C_Traits.GetTreeNodes(treeID)` (`Talents.lua:84-102`).
- Node-detail: `C_Traits.GetNodeInfo`, `GetEntryInfo`, `GetDefinitionInfo`, `GetSubTreeInfo`
  (`TalentsWindow.lua:46-60`, `:228-243`).
- Hero-tree: `C_ClassTalents.GetActiveHeroTalentSpec()` (`RotationWindow.lua:67-68`).
- Spellnaam: `C_Spell.GetSpellName` met terugval op `GetSpellInfo` (`TalentsWindow.lua:38-42`).

### 3c. Stats lezen — welke API's precies

**GEMETEN** `Core.lua:22-29` (percentages):
```
haste       = GetHaste()
crit        = GetCritChance()
mastery     = GetMasteryEffect()
versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
```
**GEMETEN** `Core.lua:36-45` (ruwe ratings): `GetCombatRating(...)` met
`CR_HASTE_MELEE`, `CR_CRIT_MELEE`, `CR_MASTERY`, `CR_VERSATILITY_DAMAGE_DONE`.

**GEMETEN** — `UnitStat` komt **nergens** voor; `C_PaperDollInfo` komt **nergens** voor (grep over
de hele map, nul hits). Equipped gear wordt gelezen met `GetInventoryItemID("player", slot)`,
`GetInventoryItemLink` en `GetDetailedItemLevelInfo` (`BiSWindow.lua:587-595`, `:529-531`), via een
hardgecodeerde slot-ID-tabel (`:91-96`) in plaats van de `INVSLOT_*`-globals.

**GEMETEN, en dit is het interessantste comment in de hele addon** — `Core.lua:7-21` is een lang
"wat we probeerden en waarom het fout was":
> ze hebben eerst `GetCombatRatingBonus` gebruikt om "itemisatie-only" percentages te krijgen; een
> live `/dump GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)` gaf **2,31%** terwijl het
> karakterscherm op hetzelfde moment **8,31%** liet zien. Conclusie in hun code: `GetCombatRatingBonus`
> is **niet** het totaal, dus terug naar `GetHaste()/GetCritChance()/GetMasteryEffect()`.

**AFGELEID** — dit is voor MH een **kandidaat-feit** om zelf na te meten, niet bewijs. Maar het is
een nuttige waarschuwing: `GetCombatRatingBonus ≠ karakterscherm`. Let op de inconsistentie: zij
gebruiken voor versatility **alsnog** `GetCombatRatingBonus` (`Core.lua:27`), terwijl hun eigen
comment zegt dat die getter 2,31 i.p.v. 8,31 gaf. **AFGELEID** — dat ziet uit als een vergeten
regel, en het verklaart mogelijk de vreemd lage versatility-doelen in §5.

Item-stats: `C_Item.GetItemStats(itemLink)` met een **tooltip-scan als terugval**
(`BiSWindow.lua:184-221`). Hun comment `:179-183` zegt dat een **gem** zijn rating helemaal niet via
`GetItemStats` prijsgeeft — **kandidaat, ongeverifieerd**.

### 3d. Waar het aan Blizzards UI hangt

**GEMETEN** — er is **geen enkele** `hooksecurefunc` in de hele addon (grep: nul hits buiten de libs,
en ook daar niet).

Er zijn precies twee hooks, en het zijn `HookScript`'s op een gewoon frame:
```
UI/CharacterPanel.lua:866: CharacterFrame:HookScript("OnShow", function() RS:SyncVisibility() end)
UI/CharacterPanel.lua:867: CharacterFrame:HookScript("OnHide", function() RS:SyncVisibility() end)
```
**GEMETEN** `CharacterPanel.lua:502-514`: het paneel hangt aan **UIParent**, niet aan CharacterFrame,
en dockt alleen *naast* het karakterscherm (`SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 6, -4)`).
Het comment noemt expliciet dat reskins zoals Chonky Character Sheet en MyCharacterSheet anders het
paneel meesleuren.

**GEMETEN** `TalentsWindow.lua:7-9`: "Deliberately does not touch Blizzard's talent frame (no tab
injection), so it can't taint it or collide with other addons that extend it."
**GEMETEN** `BiSWindow.lua:6-7`: "Item links + hover tooltip only, no tooltip rewriting (12.x taint
hazard flagged in scope.md)."

**GEMETEN** — eigen scan-tooltip in plaats van `GameTooltip` misbruiken:
`BiSWindow.lua:174-175` maakt `RecommendedStatsEnchantScanTooltip`.

**GEMETEN** — vier frames in `UISpecialFrames` (Escape sluit ze): `CharacterPanel.lua:520`,
`TalentsWindow.lua:490`, `RotationWindow.lua:517`, `CopyPopup.lua:27`.

**GEMETEN** — moderne dropdowns: `CreateFrame("DropdownButton", …, "WowStyle1DropdownTemplate")` +
`SetupMenu` + `root:CreateRadio` (`CharacterPanel.lua:402-421`, `OptionsPanel.lua:37-53`,
`TalentsWindow.lua:529-552`, `RotationWindow.lua:544-568`). Instellingen via
`Settings.RegisterCanvasLayoutCategory` + `Settings.RegisterAddOnCategory`
(`OptionsPanel.lua:247-248`). Colorpicker via `ColorPickerFrame:SetupColorPickerAndShow`
(`OptionsPanel.lua:197`).

**GEMETEN, nuttig voor MH** — `OptionsPanel.lua:251-256`: `Settings.OpenToCategory` wordt **twee
keer** aangeroepen, met als comment dat Blizzards settings-frame de eerste aanroep per sessie negeert.
**AFGELEID** — bekende workaround; MH kan dit vergelijken met zijn eigen optie-opener.

### 3e. SavedVariables — volledige indeling (GEMETEN)

**Account-wide `RecommendedStatsDB`** (toc:9):

| Key | Waarde | Bron |
|---|---|---|
| `content` | "RAID"/"MYTHICPLUS" | `Core.lua:71` |
| `attachMode` | "ATTACHED"/"FREE" | `Core.lua:86` |
| `showStats`, `showBiS` | bool | `Core.lua:108`, `:96` |
| `statsSize` | "DEFAULT"/"SMALL"/"MEDIUM"/"LARGE" | `Core.lua:122` |
| `colorblindMode` | bool | `Core.lua:139` |
| `showMinimapIcon` | bool | `Core.lua:150` |
| `skin`, `customColor` | "DEFAULT"/"CLASS"/"CUSTOM", `{r,g,b}` | `Core.lua:185`, `:190` |
| `lastSeenDataUpdate` | "YYYY-MM-DD" | `Core.lua:235` |
| `panelsShown` | bool | `Core.lua:444` |
| `activeTab` | "STATS"/"BIS" | `Core.lua:467` |
| `loginCount` | getal | `Core.lua:567` |
| `lastSeenAnnouncement` | id-string | `WhatsNew.lua:48` |
| `ratingNudgeShown` | bool | `RatingNudge.lua:16` |
| `talentsContent` | "RAID"/"MYTHICPLUS" | `TalentsWindow.lua:93` |
| `talentsScope[content]` | slug | `TalentsWindow.lua:113-114` |
| `rotationBoss` | encounter-id | `RotationWindow.lua:95` |
| *(legacy)* `panelPos`, `minimapAngle` | worden éénmalig gemigreerd en genild | `Core.lua:512-518`, `MinimapButton.lua:45-51` |

**Per character `RecommendedStatsDBChar`** (toc:10):

| Key | Waarde | Bron |
|---|---|---|
| `panelPos`, `talentsPos`, `rotationPos` | `{point=, x=, y=}` | `Core.lua:529-551` |
| `minimapIcon` | `{minimapPos=, hide=}` — LibDBIcon schrijft hier zelf in | `MinimapButton.lua:39-63` |
| `trend[specToken]` | `{haste=, crit=, mastery=, versatility=, date=}` | `Core.lua:415-418` |

**AFGELEID, en een goed idee** — posities **per character**, voorkeuren **account-wide**, met een
eenmalige migratie voor beide (`Core.lua:505-518`, `MinimapButton.lua:42-51`). Precies de scheiding
die MH ook wil; het migratiepatroon (kopieer, dan nil in de oude tabel) is kort en overneembaar.

### 3f. Timers en loops

**GEMETEN** — **geen enkele** `OnUpdate` in addoncode. De twee hits zitten in de library
(`LibDBIcon-1.0.lua:215`, `:228`).
**GEMETEN** — drie `C_Timer.After`, allemaal eenmalig:
- `TalentsWindow.lua:600` — 0,5 s na `PLAYER_SPECIALIZATION_CHANGED` (config is nog niet klaar).
- `RotationWindow.lua:624` — 0,5 s, idem.
- `RotationWindow.lua:497` — 0,6 s, één keer opnieuw tekenen als een spellnaam nog niet geladen was,
  beschermd met `frame.retried` zodat het geen lus wordt.

**AFGELEID** — netjes. Geen pollers, geen tickers.

---

## 4. 12.x secret values, combat lockdown, protected frames

### 4a. Secret values — hier wordt het serieus genomen (GEMETEN)

**GEMETEN** `Core.lua:360-371`: ze noemen de vlag bij naam —
"Blizzard's Secret Values system (Patch 12.0+) marks these getters **SecretWhenUnitStatsRestricted**:
while inside an instance and/or in combat, `c` becomes an opaque value addon code cannot subtract or
compare". Bij `issecretvalue(c)` wordt een vijfde toestand `state = "secret"` gezet, mét `delta = nil`.

**GEMETEN** `Core.lua:384-385`: ruwe rating wordt **apart** op geheimheid gecontroleerd, en die check
moet **vóór** de deling short-circuiten:
```lua
local rSecret = r and issecretvalue and issecretvalue(r)
local ratingPerPercent = (r and not rSecret and c ~= 0) and (r / c) or nil
```
**GEMETEN** `BiSWindow.lua:243-253` — zelfde patroon, mét het comment dat ze de volgorde **live**
fout hadden: `rating > 0` vóór de secret-check zette de hele call al in taint.

**GEMETEN** — in de UI gaat een secret value alleen naar wat zij "sanctioned sinks" noemen:
- `SetFormattedText` (`CharacterPanel.lua:685-696`, `:751-766`),
- `StatusBar:SetMinMaxValues` + `SetValue` (`CharacterPanel.lua:717-736`).
**GEMETEN** `CharacterPanel.lua:726-734`: in de secret-toestand wordt `stat.current` expliciet
**buiten** de `math.max`/`math.ceil` gehouden, want dat is géén sanctioned sink.

**GEMETEN** — de speler ziet dan "Can't compare here" (`Locale/enUS.lua:42`), met de balk en het
percentage nog wél gevuld. **AFGELEID** — dat is nette UX voor de MH-regel "nil = onleesbaar ≠ afwezig":
ze tonen de meting en onthouden zich van het oordeel.

**GEMETEN** `Core.lua:409-419`: de "sinds je inlogde"-baseline wordt **alleen** weggeschreven als
álle vier stats in die ronde niet-secret waren (`allNonSecretThisRun`), en maar één keer per sessie.
**AFGELEID** — dat is exact de "stilte is geen afwezigheid"-discipline: nooit een baseline bewaren
waar stilletjes een stat uit ontbreekt.

**AFGELEID, ongeverifieerd tegen de client** — de concrete claims ("`GetCombatRating` is
secret-restricted in combat/instances", "`GetHaste/GetCritChance/GetMasteryEffect` zijn
SecretWhenUnitStatsRestricted") zijn hún meting. Voor MH zijn dit **kandidaten** die zelf gemeten
moeten worden.

### 4b. Combat lockdown — wordt NIET gecontroleerd (GEMETEN)

**GEMETEN** — `InCombatLockdown` komt **nul keer** voor in de hele addon. Idem `IsProtected`,
`SecureHandler*`, `SecureActionButtonTemplate`, `RegisterUnitWatch`, `SetAttribute`.

**AFGELEID** — dat is hier **waarschijnlijk ook niet nodig**: de addon maakt alleen gewone
`Frame`/`Button`/`StatusBar`/`EditBox`/`FontString`-objecten en raakt geen actiebalken of
protected frames aan. Combat lockdown slaat op protected frames; die zijn er niet.
**AFGELEID, wel een restrisico** — `Settings.OpenToCategory` (`OptionsPanel.lua:254-255`) en het
openen van eigen vensters tijdens gevecht kunnen in principe met Blizzards eigen
UIParent-panelmanagement botsen. Niet gemeten, laag risico.

### 4c. Taintgevoelige oppervlakken: wat ze bewust NIET doen

**GEMETEN** — expliciet vermeden, elk met een comment:
- geen tab-injectie in Blizzards talentvenster (`TalentsWindow.lua:7-9`);
- geen tooltip-herschrijving (`BiSWindow.lua:6-7`);
- geen `hooksecurefunc` (grep);
- eigen scan-tooltip i.p.v. `GameTooltip` (`BiSWindow.lua:174`);
- eigen venster op `UIParent` i.p.v. kind-frame van CharacterFrame (`CharacterPanel.lua:502-506`).

**AFGELEID** — dit is voor een addon die aan het karakterscherm plakt een opvallend voorzichtig
ontwerp. Als MH ooit iets naast het karakterscherm wil: dit is het model.

---

## 5. Waar de statdata vandaan komt, en hoe vers die is

### 5a. Herkomst — expliciet en controleerbaar (GEMETEN)

**GEMETEN** `Data/Meta.lua` (9 regels, volledig):
```lua
-- GENERATED 2026-10-03 - do not hand-edit
RecommendedStatsData_Meta = {
    ["schema"] = 1, ["updated"] = "2026-10-03", ["gamePatch"] = "12.1.0",
    ["sampleSize"] = 20, ["source"] = "raider.io + Battle.net API",
}
```
**GEMETEN** — elk `Data/*.lua` begint met `-- GENERATED <datum> - do not hand-edit`.

**GEMETEN** — de generator heet **RecommendedStatsNode** en wordt met bestandsnaam genoemd in de
comments: `src/talents.js` (`Talents.lua:6`), `src/bnet.js` + `extractGear`/`extractStats`
(`Core.lua:17-18`, `BiSWindow.lua:15-16`), `aggregate.js` (`Core.lua:276-280`, `BiSWindow.lua:17`),
`src/bloodmallet.js` (`CharacterPanel.lua:45-46`, `:117-119`), `bisHistory.js` (`BiSWindow.lua:20`),
`config.js` + `tierSetItemIDs` (`BiSWindow.lua:492`), `dropStaleGear` (`BiSWindow.lua:705`),
`config.minSampleForStatWeights` (`CharacterPanel.lua:578-579`).
**AFGELEID** — die Node-repo zit **niet** in deze levering; de provenance is dus goed
gedocumenteerd maar niet na te rekenen vanuit de addon.

**GEMETEN** — dus **géén** hardgecodeerde "stat priority per spec" van een gids-site. Alles is een
**meting van echte top-spelers** (top 20) via Raider.IO + de Battle.net-API. De prioriteitsregel is
expliciet **géén** sim: `CharacterPanel.lua:647-651` — "a variance-based rank ORDER (how tightly top
players converge on each stat), **not** a true simulated per-player marginal value".

**GEMETEN** — stat-weights zijn allemaal **negatief** (`Data/StatWeights.lua:4-38`, bijv. Enh M+
haste −0,0792, vers −0,4123). **AFGELEID** — het zijn dus varianties/spreidingsmaten die alleen als
**rangorde** bedoeld zijn; als absolute "waarde per punt" zijn ze zinloos. Prima dat de tooltip dat
zegt, maar een speler die de getallen zou zien, zou ze misverstaan.

### 5b. Changelog en bronverwijzing

**GEMETEN** — geen `CHANGELOG.md`. De feature-geschiedenis staat als drie entries in
`UI/WhatsNew.lua:11-40` (2026-08-27 skins, 2026-09-22 scoped talents, 2026-09-30 rotation).
**GEMETEN** — de enige URL in de addon is de CurseForge-pagina:
`UI/RatingNudge.lua:12` → `https://www.curseforge.com/wow/addons/recommended-stats`.
**GEMETEN** — bugrapporten zijn in de comments **gedateerd**, met klasse en spec:
`TalentsWindow.lua:248` ("reported 2026-09-26 on a Holy Paladin's M+ builds"),
`:299-301` ("reported 2026-09-22 on a Death Knight San'Layn build"),
`:543-544` ("reported 2026-09-22"), `Talents.lua:19` ("checked offline … 2026-09-21"),
`Core.lua:8` ("Reverted 2026-09-09"), `Core.lua:17` ("fixed 2026-09-16 on the Node side").
**AFGELEID** — ongebruikelijk goede code-archeologie. Dit is de kwaliteit die MH's eigen
`docs/`-handoff nastreeft.

### 5c. Hoe oud/stale is het echt?

**GEMETEN**:
- `Data/Meta.lua:4` → `updated = "2026-10-03"` = **vandaag**. Stat-doelen, BiS, talenten, samples
  zijn dus 0 dagen oud.
- `Data/Rotation.lua:1` + `:44-47` → rotatiedata `updated = "2026-09-30"`, patch 12.1.0 = 3 dagen.
- De meegeleverde zip heet `v2.0.0-2026-09-30`.
- Stale-drempel in de code: `STALE_DATA_DAYS = 10` (`Core.lua:308`), dan kleurt de voetregel amber
  en komt er een waarschuwing bij (`CharacterPanel.lua:473`, `:477-483`).

**GEMETEN** — **geen 11.x-resten**. Grep op `Dawncrest|Mistcrest|Undermine|Liberation|Nerub|Dornogal|Khaz Algar|11\.x`
gaf nul inhoudelijke hits (alleen toevallige getallen als `hasteHigh = 11.71`). De woorden
"Dawncrest" en "Mistcrest" komen **nergens** voor.

**GEMETEN** — de content-lijsten zijn Midnight-tijdperk (`Data/TalentsScoped.lua:41567-41640`):
- 8 dungeons: Altar of Fangs, Den of Nalorakk, Kings' Rest, Murder Row, Ruby Life Pools,
  Temple of Sethraliss, The Blinding Vale, Voidscar Arena.
- 9 raidbazen: Nek'zali the Soulcoiler, Entombed Sentinels, The Lost Explorers,
  Vashnik the Malignant, Sszorak, The Twin Fangs, The Coiled Altar, Ula'tek, Nymrissa Wavecaller.
- `BiSWindow.lua:127` noemt in een voorbeeld ook `"the-tidebound-grotto"`.

**AFGELEID** — dit is één samenhangende, actuele Midnight-seizoenset. Welk seizoensnummer dat is,
zegt de addon **nergens**; er staat alleen `gamePatch = "12.1.0"`. Niet te bepalen uit deze data.

### 5d. Dekking: alle 40 specs, inclusief Devourer (1480) — JA

**GEMETEN**:
- `Data/StatTargets.lua`: **80 sleutels** = 40 specs × {RAID, MYTHICPLUS}.
- `Data/SampleSize.lua`: **80 sleutels** (regels 3-82).
- `Data/RaidDifficulty.lua`: **40 sleutels** (regels 3-42), alle 40 op `"mythic"`.
- Demon Hunter **Devourer** is overal aanwezig:
  - `Core.lua:61` → `[1480] = "DEVOURER"`
  - `Data/StatTargets.lua:783` (`DEMONHUNTER_DEVOURER_MYTHICPLUS`) en `:793` (`..._RAID`)
  - `Data/BiS.lua:35519` en `:35947`
  - `Data/SampleSize.lua:81-82` (beide 20)
  - `Data/RaidDifficulty.lua:42` (`"mythic"`)
  - ook in `Data/StatWeights.lua`, `Data/Talents.lua`, `Data/TalentsScoped.lua` (grep: 2 hits elk).
- Steekproefgrootte: 76 van 80 sleutels op 20/20. Vier lager: `WARRIOR_FURY_RAID` 19,
  `ROGUE_SUBTLETY_RAID` 15, `WARLOCK_DESTRUCTION_RAID` 18 (`SampleSize.lua:16,42,50`).

**AFGELEID** — Devourer-dekking is dus volledig en met volle steekproef. Dat is opvallend snel voor
een splinternieuwe spec.

### 5e. Vier concrete datazwaktes

1. **Versatility-doel is 21× exact `1.87`** (`Data/StatTargets.lua`, grep-count 21 van 80 sleutels),
   bij volkomen verschillende specs — Enhancement M+ én RAID, Devourer M+, enz. **GEMETEN.**
   **AFGELEID** — een identieke waarde tot op twee decimalen over 21 ongerelateerde specs is geen
   meting; dat is een vloer, een default of een pijplijnartefact. In combinatie met §3c (versatility
   is de enige stat die nog via `GetCombatRatingBonus` gelezen wordt, de getter die hun eigen comment
   als "2,31 vs 8,31" afserveert) is dit waarschijnlijk dezelfde bug aan twee kanten. Elke "Over ·
   fine" op versatility is dus verdacht.
2. **Mastery in twee verschillende eenheden.** Mistweaver M+ `mastery = 730.81` tegenover RAID
   `368.8` (`StatTargets.lua:28`, `:38`), terwijl Prot Paladin op `21.33`/`23.85` staat (`:48`, `:58`).
   **GEMETEN.** **AFGELEID** — een factor-2-verschil tussen M+ en Raid voor dezelfde spec is geen
   speelstijlverschil; en de balk schaalt daarop mee (`CharacterPanel.lua:732-734` rondt naar de
   volgende 100, dus een 0-800%-balk). Oordeel over Mistweaver-mastery is hier niet te vertrouwen.
3. **`Data/TierSet.lua:2` is leeg** (`RecommendedStatsData_TierSet = {}`), dus de 2pc/4pc-regel die
   `BiSWindow.lua:732-740` kan tonen staat vandaag altijd uit. **GEMETEN.** Feature zonder data.
4. **Hun eigen code waarschuwt dat de doelen scheef kunnen staan.** `Core.lua:19-21`:
   "RecommendedStatsData_Targets stays on old itemization-only numbers until the next real
   (non-mock) `npm run build` + publish." **GEMETEN.** **AFGELEID** — met `updated = "2026-10-03"`
   is dat vermoedelijk inmiddels opgelost, maar de addon kan dat zelf niet vertellen: er is geen
   veld dat zegt wélke aggregatie-versie de doelen bouwde. De voetregel is daarmee minder
   betrouwbaar dan hij eruitziet.

---

## 6. Localisatie

**GEMETEN** — drie talen, één vlakke tabel `RecommendedStats_Locale`:

| Bestand | Guard | Aantal `L.`-sleutels | Vertaler |
|---|---|---|---|
| `Locale/enUS.lua` | geen (basis) | **178** | — |
| `Locale/zhTW.lua` | `:5` `if GetLocale() ~= "zhTW" then return end` | **179** | `:2` BlueNightSky (三皈依-暗影之月@TW) |
| `Locale/ruRU.lua` | `:13` `if GetLocale() ~= "ruRU" then return end` | **178** | `:4` ZamestoTV |

**GEMETEN** — laadorde in de TOC (regels 16-18): enUS **eerst**, dan zhTW, dan ruRU. Elke
vertaling overschrijft alleen zijn eigen sleutels, dus **de fallback is automatisch enUS** per
ontbrekende sleutel. Het patroon staat als instructie in `enUS.lua:5-11`.

**AFGELEID** — met 178/179 tegenover 178 zijn ruRU en zhTW in de praktijk **volledig** vertaald, geen
gaten. (zhTW heeft er één meer omdat het `L.ROTATION_BUTTON` apart zet, `zhTW.lua:17`.)
**AFGELEID** — anders dan bij MH (zie `locale-packs-gated-by-client`) is hier **geen** eigen
taalkeuze: `GetLocale()` beslist, dus Rob kan op een Engelse client de vertalingen niet zien. Zelfde
beperking die MH heeft.

### Drie echte localisatiegaten (GEMETEN)

1. **`BiSWindow.lua:298`** — `text:match("^Enchanted: (.+)$")`. Hardgecodeerd Engels. Op een Duitse
   of Franse client zegt de tooltipregel iets anders, dus de enchantnaam komt nooit door en er wordt
   teruggevallen op het generieke label (`:644`).
2. **`BiSWindow.lua:195`** — `text:match("^%+(%d+) (.+)$")`. Het "+56 Haste"-formaat; de statnaam
   wordt wél via `L` teruggezocht (`:163-170`, slim), maar het `+getal `-voorvoegsel en de
   woordorde zijn een Engelse aanname.
3. **`CharacterPanel.lua:753`, `:758`, `:763`** — het woord `target` staat **letterlijk** in de
   format-strings van de SMALL/MEDIUM-regel, niet in `L`. Die ene regel blijft dus Engels in zhTW en
   ruRU, terwijl de rest vertaald is.

**AFGELEID** — nummer 1 en 2 zijn gestructureerd op te lossen met `ENCHANTED_TOOLTIP_LINE` /
`ITEM_MOD_*`-GlobalStrings uit de client zelf. Dat is precies de wago.tools-GlobalStrings-aanpak die
in MH's geheugen staat als de hardste bron.

---

## 7. Kwaliteit en risico

### Wat goed is

1. **Taint-risico actief geminimaliseerd.** Geen `hooksecurefunc`, geen tab-injectie, geen
   tooltip-rewrite, eigen scan-tooltip, eigen venster op UIParent. Zie §4c met regelnummers.
   **AFGELEID** — het reële taintrisico is hier **laag** voor een addon die naast het karakterscherm
   leeft. De twee `HookScript`'s op `CharacterFrame` (`CharacterPanel.lua:866-867`) zijn de enige
   aanhechting en `HookScript` op een niet-protected frame is de veilige variant.
2. **Secret-value-discipline op het niveau dat MH ook aanhoudt** (§4a), inclusief de les dat de
   secret-check vóór de vergelijking moet short-circuiten (`BiSWindow.lua:243-253`).
3. **Degradeert naar een waarschuwing, niet naar een leugen.** Lege sleutel → "no data" en de
   dropdownkeuze wordt grijs (`Core.lua:281-289`); schema-mismatch → "update de addon"
   (`Core.lua:269-272`, `CharacterPanel.lua:634-635`); data >10 dagen oud → amber (`Core.lua:308-313`);
   kleine steekproef → amber en "X van 20" i.p.v. "top 20" (`Core.lua:322-333`,
   `CharacterPanel.lua:467-475`); BiS niet uit Mythic → amber (`BiSWindow.lua:719-723`).
4. **Kleurenblind-modus**, met de reden erbij dat Unicode-driehoekjes tofu-blokjes worden in
   FRIZQT__.ttf (`Locale/enUS.lua:44-51`) en dat Blizzards ready-check-textures bewust gekozen zijn
   omdat die al bestaan (`BiSWindow.lua:108-115`). **AFGELEID** — direct bruikbaar voor MH: de
   `[v] [=] [^] [?]`-glyphs zijn een veilige, fontonafhankelijke oplossing.
5. **CJK-fontval** vermeden door het font**pad** van `GameFontNormal` te lezen i.p.v.
   `Fonts\FRIZQT__.ttf` te hardcoden (`CharacterPanel.lua:219-227`). **AFGELEID** — dit is een
   concrete bug die MH ook kan hebben; waard om te controleren.
6. **Dubbele-installatie-detectie** met een leesbare chatmelding i.p.v. een Lua-error
   (`MinimapButton.lua:53-61`). **AFGELEID** — goed idee, MH kan hetzelfde voor zijn eigen LDB-naam.
7. **Afgeleide hoogte i.p.v. gesynchroniseerde constante.** `RS:GetBisContentHeight()`
   (`BiSWindow.lua:82-84`) wordt door `CharacterPanel.lua:77-79` gebruikt, met het comment dat een
   handmatig gekopieerde constante al één keer uit sync liep.

### Wat fragiel is

1. **Performance: BiS hertekent 16 rijen bij elke `COMBAT_RATING_UPDATE`, óók onzichtbaar.**
   **GEMETEN** — `Core.lua:572` registreert `COMBAT_RATING_UPDATE`; `Core.lua:424-427` roept álle
   listeners aan; `BiSWindow.lua:691-695` stopt alleen als `page` nog **nil** is — dus zodra de
   speler het venster één keer heeft geopend, loopt `Render()` voortaan altijd, ook als de tab op
   "Stats" staat of het paneel verborgen is. Per ronde: `RatingConversion()` (4× `GetCombatRating`
   + 4 percentage-getters, `:231-256`), en per rij `GetInventoryItemID` + `GetInventoryItemLink` +
   `GetDetailedItemLevelInfo` + `ItemRatings` (die bij een gem **een tooltip-scan over alle regels**
   doet, `:184-201`) + tot twee `ContinueOnItemLoad`-callbacks.
   **AFGELEID** — `COMBAT_RATING_UPDATE` vuurt in gevecht bij elke proc/buff die rating verandert.
   Dit is het meest waarschijnlijke prestatieprobleem in de addon. De fix is één regel: in
   `Render()` ook op `page:IsShown()` / de actieve tab testen. Voor MH: dit is precies de val die
   het "één listener-lijst"-patroon oplevert — de dispatcher weet niet wie zichtbaar is.
   *(Deels gemitigeerd: `enchantInfoCache` op `BiSWindow.lua:304` cachet enchants; items/gems niet.)*
2. **Globale datatabellen worden zonder nil-guard geïndexeerd.** **GEMETEN** `Core.lua:345`
   (`RecommendedStatsData_Targets[key]`) en `BiSWindow.lua:703` (`RecommendedStatsData_BiS[key]`).
   `RS:SchemaOK()` controleert alleen `_Meta`. **AFGELEID** — als één `Data/*.lua` niet laadt (corrupt,
   te groot, afgekapte download) krijgt de speler een Lua-error i.p.v. het nette "no data".
3. **~3,9 MB Lua-data, altijd volledig geladen.** **GEMETEN** — geen `LoadOnDemand`, geen splitsing
   per klasse. **AFGELEID** — 80 sleutels aan BiS en 40 specs aan talent- en rotatiedata worden
   ingelezen om er twee te gebruiken. Een per-klasse-split zou >95% van de parse-tijd en het
   geheugen schelen. Voor MH relevant als er ooit per-spec-datapacks komen.
4. **Drie nieuwe UI-API's met "verify this" erbij, zonder fallback.** **GEMETEN** —
   `CharacterPanel.lua:22-26` ("Verify the template name resolves in your client … verify it
   actually dims/blocks the click"), `BiSWindow.lua:147-151` ("⚠ VERIFY these exact key names live"),
   `OptionsPanel.lua:193-194` (`SetupColorPickerAndShow`). **AFGELEID** — eerlijk van de auteur, maar
   een `⚠ VERIFY` die blijft staan is een open vraag die aan de speler wordt doorgegeven.
5. **Eigen vensters op strata `DIALOG` + `SetToplevel(true)`** (`TalentsWindow.lua:483-484`,
   `RotationWindow.lua:510-511`) en de copy-popup op `FULLSCREEN_DIALOG` (`CopyPopup.lua:20`).
   **GEMETEN** — er staat zelfs een tegenstrijdig comment: `CopyPopup.lua:18` zegt dat het
   talentvenster `FULLSCREEN_DIALOG` is, terwijl dat `DIALOG` is. **AFGELEID** — cosmetisch, maar
   `SetToplevel` op `DIALOG` kan met andere addons om de voorgrond vechten.
6. **De tooltip-scan-truc hangt aan Engelse tekst** — zie §6, punten 1 en 2.
7. **Een openlijk niet-begrepen bug blijft in de code staan.** **GEMETEN** `TalentsWindow.lua:246-255`:
   de terugval voor het kiezen van de hero-tree tekende een Lightsmith-build als Herald of the Sun
   (gerapporteerd 2026-09-26); de oorzaak staat er als "**Suspected cause (unverified)**: a node reads
   back tagged with the sub-tree active on the VIEWING character's own config rather than the
   build's". **AFGELEID** — een echt interessant kandidaat-API-feit over `C_Traits`, en voor MH een
   waarschuwing: `C_Traits`-node-info kan de **kijker** reflecteren, niet de **geladen build**. Zelf
   meten voordat je erop bouwt.
8. **`RecommendedStatsDBChar` wordt op file-load-niveau aangeraakt** (`Core.lua:511-518`,
   `MinimapButton.lua:39-51`). **AFGELEID** — werkt omdat SavedVariables al geladen zijn voordat de
   Lua loopt, maar het is afhankelijk van die laadorde en niet van een `ADDON_LOADED`-guard.

### Wat ik NIET kon vaststellen

- Of enig game-API-feit in hun comments klopt. Alles in §3c, §4a en punt 7 hierboven is **kandidaat,
  ongeverifieerd tegen de client**. Een grep over een andere addon is geen verificatie.
- Welk Midnight-**seizoen** de data beslaat. Er staat alleen `gamePatch = "12.1.0"` (`Meta.lua:5`).
- Of de aggregatie-fix van `Core.lua:17-21` daadwerkelijk in de data van 2026-10-03 zit. Geen veld
  dat dat zegt.
- Wat er in `RecommendedStats_v2.0.0-2026-09-30.zip` zit — bewust niet uitgepakt (read-only, en de
  opdracht zei hem te negeren).

---

## 8. Drie dingen die MH hiervan kan gebruiken

1. **De kleurenblind-aanpak** (`[v] [=] [^] [?]`-glyphs + Blizzards ready-check-textures) met de
   onderbouwing waarom Unicode-vormen niet kunnen. Techniek, geen code: `Locale/enUS.lua:44-51`,
   `BiSWindow.lua:108-115`. Sluit aan op "spelers kiezen, niet wij" — het is een schakelaar.
2. **De CJK-fontval**: lees het fontpad van `GameFontNormal`, hardcode nooit `FRIZQT__.ttf`
   (`CharacterPanel.lua:219-227`). Dit is iets om in MH's eigen UI na te **meten**, niet aan te nemen.
3. **De talent-exportstring-decoder** (`Talents.lua:34-79`) als MH ooit builds wil inlezen/vergelijken.
   Dit is de enige plek waar kopiëren echt tijd scheelt — en dan mét attributie (zie §1) én met het
   formaat zelf tegen de client nagemeten, want hun formaatdocumentatie is tegen Raider.IO getoetst,
   niet tegen WoW.

**Niet overnemen**: hun listener-dispatcher zonder zichtbaarheidscheck (risico 1), en hun
versatility-lezing via `GetCombatRatingBonus` (§3c + §5e-1).
