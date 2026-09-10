# Spec 38 — Het Account-overzicht moet leesbaar worden

**Van:** ONDERZOEK-sessie, 10 sep 2026
**Aanleiding:** Rob, met een screenshot van het tabblad *Account snapshot* (`account`):
*"ik vind dit er niet uitzien. Er moet een betere oplossing komen. Zeker aan het einde, waar al die
lijnen bijna door elkaar heen lopen."*
**Bron:** twee agenten (code-diagnose en ontwerp), daarna door mij nagemeten in de code.
Tags: **G** = gemeten in de code, **A** = afgeleid.
**Bestand:** `Modules/AltOverview.lua` (BOUW-terrein).

---

## 1. Wat er mis is — nagemeten

### 1a. De lijnen die door elkaar lopen: de Shards-cel mag afbreken (G)
`AnchorThreeNumericCells` (`AltOverview.lua:865-886`) geeft de drie getalcellen alleen een breedte en
een `CENTER`-anker. **Geen `SetWordWrap(false)`, geen `SetMaxLines(1)`.** De Shards-kolom is
**62 px** (70 in de/fr, `:25-33`), de rij **17 px** (`:39`).
"201 (354/600)" is 13 tekens en past niet in 62 px (A: ~65–70 px bij het standaardfont), dus WoW
breekt hem over twee regels. Twee regels gecentreerd in een rij van 17 px steken boven én onder
uit — dat is precies wat Rob ziet. Bij een grotere tekstschaal breekt zelfs "19 (0/600)" (A).

### 1b. Een echte bug: "(—/0)" is een verkeerd getal (G)
```lua
-- AltOverview.lua:323-324
if weeklyStale and weekly == 0 then
    return string.format(ns:L("ALT_SHARDS_CELL_STALE_FMT"), total)
```
Het formaat is `"%d (—/%d)"` (`enUS.lua:2293`): **twee** plaatshouders, **één** waarde. De
`weeklyMax` staat als parameter klaar (`:316`) en wordt niet meegegeven. Daarom staat er op de
drie relog-rijen "0 (—/0)" waar "/600" hoort. (Waarom WoW daar 0 invult in plaats van een fout te
gooien is A — het screenshot laat in elk geval de /0 zien.)

### 1c. De rest (G, tenzij anders vermeld)
- **Beroepen afgekapt:** naam, "(you)", level, ilvl én vijf beroepen delen één niet-afbrekende
  string in de Character-kolom (~267 px bij het standaardvenster, A). Afgekapt op 44 **bytes**
  (`:351`), naam op 26 bytes (`:544`) — byte-telling kan een ü of é doormidden knippen (A).
- **"W0 D0 R0" heeft geen kopje.** Het betekent: Great Vault-plekken vrij in World / Dungeons /
  Raids (`ALT_VAULT_ROW_FMT`, `enUS.lua:2303`). Nergens uitgelegd op het scherm.
- **De kolom "2121 / 0"** is *Undercoins / Untainted Mana-Crystals* (kop "Under / Mana").
- **De kop scrollt mee weg** met de rijen, en er is **geen scrollbalk**.
- **Lage alts** (Lv11, Lv15, Lv82) staan tussen de rest met tekst "(relog)" en een rij nullen.
- **In andere talen wordt het erger.** `fill()` in `Translations2026.lua:44` vervangt een waarde
  die gelijk is aan het Engels (G — dit is nieuwer dan wat CLAUDE.md erover zegt). Daardoor wordt
  de badge in het Duits "(neu einloggen)" en in het Frans "(reconnexion)", en de vault-cel
  "M%d D%d R%d" in fr/es en "Mu%d Ma%d R%d" in ptBR (A: gelezen in de packs, niet in het spel).

### 1d. Wat er al is maar niemand ziet (G)
- Een **volledige tooltip per rij** (level, ilvl, keys, catalyst, alle beroepen, beroeps-weeklies,
  shards, vault per plek, laatst bijgewerkt, relog-waarschuwing) — `:1431-1594`.
- **Sorteren** door op de koppen Keys, Shards en Under/Mana te klikken, plus een sorteerknop met
  6 volgordes.
- **Vier filters** (relog nodig / heeft keys / shards onder de cap / Dundun) — alleen bereikbaar
  door op regels in het "This week"-blok erboven te klikken. De filterknop-teksten
  `ALT_SNAPSHOT_FILTER_STALE`/`_KEYS` bestaan in zeven talen en worden **nergens** gebruikt.

📌 Dat is het terugkerende patroon uit [[mh-already-contains-it]]: de uitleg zit er al, alleen
op een plek waar niemand kijkt.

---

### 1e. Vertalingen: drie soorten fout in deze ene tabel (G, gelezen in de packs)
De twee agenten spraken elkaar hier tegen; nagemeten. `fill()` (`Translations2026.lua:44`) vervangt
elke packwaarde die **gelijk is aan het Engels**. De packs hebben de Engelse waarde, dus:
- **Vault-letters:** fr en es tonen `M%d D%d R%d` (`Translations2026.lua:5768`, `:6176`), ptBR
  `Mu%d Ma%d R%d` (`:6591`). de/it/nl houden `W D R`. Zelfde kolom, vier verschillende codes —
  en in geen enkele taal uitgelegd.
- **Relog-badge:** de → "(neu einloggen)", fr → "(reconnexion)" — twee keer zo lang als "(relog)",
  in een naamcel die al te vol is.
- 🔴 **"Under" vertaald als voorzetsel.** De kop `ALT_COL_UNDER_MANA` is "Unter / Mana" (de),
  "Sous / Mana" (fr), "Bajo / Maná" (es), "Menos / Mana" (ptBR). *Under* is hier de afkorting van
  **Undercoins**, een currency-naam — geen "onder". Staat zo in de packs zelf (`deDE.lua:732`,
  `frFR.lua:680`, `esES.lua:681`, `ptBR.lua:682`).
📌 De structurele oplossing voor alle drie staat in §2: **kop = Blizzards eigen currency-icoon, naam
in de tooltip uit `C_CurrencyInfo`**. Dan toont de kop wat de client van déze speler zelf zegt, en
kan deze klasse fouten niet meer voorkomen.

---

## 2. Ontwerp

### 2a. Hoe anderen het doen (G, bronnen in het agentverslag)
Method Alt Manager en AlterEgo zetten **één kolom per karakter** (120–130 px). Dat komt uit de
Mythic+-hoek: veel dingen, weinig karakters. **Bij Rob passen er dan ~4 van zijn 10 in beeld.**
WeeklyKnowledge, Great Vault List en MH zelf doen **één rij per karakter** — dat blijft dus.
Wat de goede overnemen: getallen rechts uitgelijnd, **nooit afbreken**, een tooltip op élke kop,
groen als het af is, een grijze "–" voor leeg, lage alts apart te zetten of te verbergen, en
Blizzards eigen Great Vault als beeld: 3 rijen × 3 plekken.

### 2b. Tabelregels die hier gelden (A, algemene UX-bronnen)
Eén regel per cel · kop blijft staan bij scrollen · kolommen met de minste waarde vallen als eerste
weg bij een smal venster · kleur betekent hooguit drie dingen (groen = af, amber = aandacht, grijs =
n.v.t.) en **nooit kleur alleen** (WoW heeft een kleurenblindmodus) · een begrensd getal als balkje,
het exacte getal in de tooltip.

### 2c. Optie A — kleine reparatie binnen de huidige opzet (klein)
```
Character                          Vault   Keys  Shards      Week   [coin]  [kristal]
Redisch (you)          90 · 279   CLAIM!     2      19       0/600    2121         0
Earthshammy            90 · 294      1/9     5     201     354/600      62        35
Iceicebaby             90 · 302      0/9     1     681   600/600 ✓    1429         0
Warlockie ◷            82 · 126       —      0       0          —        0         0   (gedimd)
```
Beroepen **uit de rij** (staan al in de tooltip) · Vault krijgt een kop en toont "1/9" · Shards
gesplitst in *wallet* en *deze week* · de ×-knop alleen bij hover · "(relog)" wordt een gedimde rij
met een klokje waarvan de tooltip zegt waarom en wat je moet doen.

### 2d. Optie B — echte herziening (middel) ← aanbevolen, **ná** A
```
     Character               Lv  ilvl  Great Vault    [key] [shard]  This week       [coin] [kris]
───────────────────────────────────────────────────── (kop blijft staan) ─────────────────────────
▶ ◆ Redisch                  90   279  ■■□ ■□□ □□□      2      19   ░░░░░░░░░░   0    2121      0
  ◆ Earthshammy              90   294  ■□□ ▣□□ □□□      5     201   ██████░░░░ 354    62     35
  ◆ Iceicebaby               90   302  □□□ □□□ □□□      1     681   ██████████ ✓    1429      0
▸ Levelende karakters (3) — nog geen Great Vault-voortgang
■ vrij  ▣ bezig  □ dicht  ·  Wijs een karakter aan voor wat er deze week nog openstaat
```
- **Great Vault als drie groepjes van drie blokjes**, net als Blizzards eigen venster. Een beginner
  herkent het meteen, en er is geen letter meer die in elke taal anders heet.
- **Klasse-icoon + naam in klassekleur**, realm alleen in de tooltip. Vraagt één nieuw opgeslagen
  veld (`classFile`); oude rijen hebben pas een icoon nadat dat karakter weer inlogt.
- **"This week" als balkje** met het getal ernaast, ✓ bij de cap.
- **Levelende karakters ingeklapt** onder één regel — bepaald uit de opgeslagen data (alle drie de
  vault-categorieën onbeschikbaar), **geen** vaste levelgrens. Het huidige karakter wordt nooit verstopt.
- Bij een smal venster valt eerst Kristallen weg, dan Undercoins, dan ilvl — alle drie staan nog in
  de rij-tooltip.
- **Het uitlegdeel, MH's sterkte:** één legendaregel onder de tabel, elke kop-tooltip beantwoordt
  *wat is het / waarom doet het ertoe / wanneer reset het*, en de rij-tooltip begint met **de
  volgende stap** ("Dungeons: volgende plek bij 1/4") uit data die MH al opslaat.

### 2e. Wat niet mag breken (G)
- `db.charCurrencies[guid]`: velden alleen **toevoegen**, nooit hernoemen of weghalen. De opgeslagen
  sorteersleutels in `db.ui.accountSnapshot` blijven werken.
- De functies die het "This week"-blok aanroept (`MhToggleAccountSnapshotWeeklyFilter`,
  `MhAccountEntryIsStale`, `MhGetEffectiveShardsWeekly`, `MhAccountEntryShardsBelowCap`,
  `MhAccountEntryDundunIncomplete`, `:835-860`, `:1671-1685`) en "Show all (n)" — dat telt de
  ingeklapte groep mee.
- De ×-knop: bevestigingsvenster, huidig karakter onverwijderbaar, GUID-controles (`:1021-1060`).
- De reset-dag-puls op de vault (`:1407-1430`), de regel *manaflux nil ≠ 0* in de tooltip (`:1450`),
  meegroeien met MH's tekstschaal (`RowH()`), verversen bij taalwissel.
- Na elke enUS-wijziging: `check_drift.py`.

---

## 3. Snelle reparaties (klein, los van het ontwerp)

1. **`SetWordWrap(false)` + `SetMaxLines(1)`** op de drie getalcellen en de vault-cel
   (`:872-885`, `:909`). Dit alleen stopt het door elkaar lopen.
2. **`:324` repareren:** `weeklyMax` meegeven — of voor relog-rijen alleen het grijze totaal tonen.
3. **Kop boven de Vault-kolom** met een uitleg-tooltip: *W = World, D = Dungeons, R = Raids*.
4. **`ROW_H` 17 → 20**, en de afkappingen op `:351`/`:544` per teken in plaats van per byte.
