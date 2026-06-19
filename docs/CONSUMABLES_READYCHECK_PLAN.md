# MidnightHelper — Consumables-check bij dungeon-entry

**Feasibility-analyse + implementatievoorstel** · WoW Retail (~patch 12.0.7) · juni 2026

> **Status:** de projectmap is intussen gelezen (`E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper`). De algemene API-analyse (§1–§5) staat los van de code; §6 en §7 zijn nu **concreet afgestemd op de bestaande MidnightHelper-structuur, codestijl en bestaande modules**.

---

## Korte conclusie

Wat je betrouwbaar kunt detecteren splitst zich in drie niveaus:

1. **Eigen personage — volledig.** Tassen (aanwezigheid van flasks/potions/runes) én actieve buffs zijn beide leesbaar via de standaard-API.
2. **Groepsleden — alleen actieve buffs.** Je kunt via aura-inspectie zien of een groepslid een flask-/phial-buff, augment rune-buff, of weapon/food buff *actief* heeft. Je kunt **niet** in hun tassen kijken — dat staat de API principieel niet toe.
3. **Groepsleden — tas-inhoud alleen via addon-comms.** Wil je weten of een groepslid de consumables *bij zich heeft* (maar nog niet gebruikt), dan kan dat uitsluitend als dat groepslid óók MidnightHelper draait en zijn eigen tas-data deelt via een addon-to-addon kanaal (`C_ChatInfo.SendAddonMessage`).

Kortom: "heeft het gebruikt?" is voor de hele groep haalbaar met pure aura-inspectie. "Heeft het bij zich?" is voor jezelf triviaal, maar voor anderen alleen mogelijk met een coöperatief comms-protocol.

---

## 1. Eigen personage — volledig zichtbaar

### Tassen (heeft de speler het bij zich?)
De eenvoudigste en meest robuuste route is `C_Item.GetItemCount(itemID, includeBank, includeUses, includeReagentBank)` — die geeft direct het totale aantal van een item in de tassen terug, zonder dat je per slot hoeft te itereren. Voor een check "heb ik minimaal 1 flask?" is dit ideaal.

Wil je per-slot detail (bijv. exacte stacks of een specifiek tasvak), dan itereer je over de containers:

```lua
for bag = 0, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
    for slot = 1, C_Container.GetContainerNumSlots(bag) do
        local info = C_Container.GetContainerItemInfo(bag, slot)
        if info and info.itemID then
            -- info.itemID, info.stackCount, info.hyperlink
        end
    end
end
```

Voor de meeste checks volstaat `GetItemCount`. Aandachtspunt: bagged item-counts zijn pas betrouwbaar nadat `BAG_UPDATE_DELAYED` is gevuurd (na laden / na zone-change kan er kort vertraging zijn).

### Buffs (heeft de speler het gebruikt/actief?)
Voor de eigen actieve effecten:

```lua
local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellID)  -- nil = niet actief
-- of generiek, ook voor de speler:
local aura = C_UnitAuras.GetAuraDataBySpellName("player", buffName, "HELPFUL")
```

Hiermee detecteer je een actieve flask/phial-buff, augment rune-buff, weapon enhancement en food-buff. `aura.expirationTime` geeft je bovendien de resterende duur — handig om te waarschuwen als een buff bijna afloopt vóór een pull.

---

## 2. Groepsleden — alleen actieve buffs (aura-inspectie)

Dit is de cruciale beperking. **Je kunt niet in de tassen van andere spelers kijken** — er bestaat geen API die de inventory van een ander unit-token blootlegt. Dat is een bewuste keuze van Blizzard (privacy/anti-cheat).

Wat je wél kunt: de **actieve auras** van elk groepslid uitlezen. Aura-data is publiek voor units die je kunt targeten (`party1`–`party4`, `raid1`–`raid40`, of via naam/GUID-resolutie). Bevestigd via Warcraft Wiki: `C_UnitAuras.GetAuraDataBySlot` / `GetAuraSlots` werken op elk unit in je groep, en dit wordt in de praktijk door diverse addons gebruikt om buffs op groepsleden (zoals tank-cooldowns) te detecteren.

```lua
-- Loop over alle helpful auras van een unit
local function HasBuffFromList(unit, spellIDSet)
    local i = 1
    while true do
        local data = C_UnitAuras.GetAuraDataByIndex(unit, i, "HELPFUL")
        if not data then break end
        if spellIDSet[data.spellId] then
            return true, data.expirationTime
        end
        i = i + 1
    end
    return false
end
```

Concreet detecteerbaar per groepslid:

| Consumable | Buff actief detecteerbaar? | Tas-aanwezigheid detecteerbaar? |
|---|---|---|
| Flask / Phial | ✅ ja (aura) | ❌ niet zonder comms |
| Augment Rune | ✅ ja (aura) | ❌ niet zonder comms |
| Combat Potion (pre-pot / tijdens pull) | ⚠️ alleen tijdens de korte buff-duur | ❌ niet zonder comms |
| Healthstone | ❌ geen buff — is een item, geen aura | ❌ niet zonder comms |
| Healing Potion | ❌ idem (instant heal, geen blijvende aura) | ❌ niet zonder comms |
| Weapon-/Food-buff | ✅ ja (aura) | ❌ niet zonder comms |

Belangrijke nuances:

- **Combat potions** geven een buff van ~25–30 sec. Op het moment van dungeon-entry zal niemand die actief hebben (je pot pas bij de pull). "Heeft een combat potion bij zich" is dus *alleen* via comms te checken; "gebruikt nu" alleen tijdens een pull.
- **Healthstones en healing potions geven geen aura.** Hun aanwezigheid is enkel via comms (zie §4) vast te stellen. Een Healthstone "gebruikt" detecteer je hooguit via combat-log events op het moment zelf, niet als status bij entry.
- **Spec-aware**: een phial/flask kan per expansion meerdere spell-IDs hebben (rank 1/2/3, verschillende phials). Je moet een **set van geldige spell-IDs** onderhouden, niet één ID. Dit is de belangrijkste onderhoudslast (zie §6).
- **Naam vs. spellID**: filter op `spellId` (numeriek, taalonafhankelijk), nooit op buff-naam, anders breekt het op niet-Engelse clients.

---

## 3. Relevante events / triggers

| Event | Wanneer | Gebruik in deze feature |
|---|---|---|
| `PLAYER_ENTERING_WORLD` | bij laden / na elke zone-/instance-load | Basistrigger; detecteer of de nieuwe zone een dungeon/instance is |
| `ZONE_CHANGED_NEW_AREA` | bij betreden nieuwe zone | Aanvullende trigger voor open-world → instance overgangen |
| `CHALLENGE_MODE_START` | start van een Mythic+ keystone-run | Ideaal moment voor de "iedereen ready?"-check vlak vóór de timer |
| `ENCOUNTER_START` | begin van een boss-encounter | Per-boss her-check (is flask nog actief? pre-pot gezet?) |
| `GROUP_ROSTER_UPDATE` | groepssamenstelling wijzigt | Herbouw de te-controleren lijst van units; (re)broadcast comms-handshake |
| `UNIT_AURA` (unit-filtered) | aura van een unit verandert | Live bijwerken van buff-status zonder pollen |
| `BAG_UPDATE_DELAYED` | tas-inhoud gewijzigd (gedebounced) | Eigen tas-telling verversen vóór broadcast |

**Aanbevolen primaire trigger:** bepaal via `IsInInstance()` (geeft `inInstance, instanceType` — let op `instanceType == "party"` voor dungeons) bij `PLAYER_ENTERING_WORLD`/`ZONE_CHANGED_NEW_AREA` of je in een dungeon zit. Voor M+ is `CHALLENGE_MODE_START` de scherpste "pre-pull"-trigger. Gebruik daarnaast een kleine timer-delay (1–2 sec) ná de zone-load zodat aura-data en roster volledig gevuld zijn.

---

## 4. Tas-data van groepsleden — via addon-comms (optioneel, coöperatief)

Dit is de enige manier om "heeft groepslid X de flask/rune/healthstone *bij zich*" te weten. Het werkt alleen als het andere groepslid **ook MidnightHelper draait**.

**Mechaniek:**

```lua
C_ChatInfo.RegisterAddonMessagePrefix("MHCons")   -- prefix max 16 tekens, eenmalig

-- Versturen (payload max 255 bytes per bericht):
C_ChatInfo.SendAddonMessage("MHCons", payload, "PARTY")   -- of "INSTANCE_CHAT"/"RAID"

-- Ontvangen:
frame:RegisterEvent("CHAT_MSG_ADDON")
-- args: prefix, message, channel, sender
```

**Protocol-schets (handshake + status):**

1. Bij dungeon-entry / `GROUP_ROSTER_UPDATE` stuurt elke client een `HELLO`-bericht met addon-versie. Zo weet je wie meedoet.
2. Elke deelnemende client broadcast zijn **eigen** tas-status, bijv. compact: `STATUS:flask=1;aug=1;hs=1;cpot=2;hpot=3` (alleen aanwezigheidsbool of count, géén item-namen nodig).
3. Elke client combineert binnenkomende `STATUS`-berichten met zijn lokale aura-inspectie (§2) tot één overzicht.
4. Niet-deelnemers (geen MidnightHelper) toon je als "tas onbekend — alleen buff-status zichtbaar".

**Aandachtspunten comms:**

- **Throttling:** addon-berichten worden bij overmatig verkeer gedropt door de server. Gebruik **ChatThrottleLib** (de facto standaard, bundelt in addons als Ace3) of een eigen send-queue. Stuur niet onnodig vaak — alleen bij entry, roster-change en op verzoek.
- **Kanaalkeuze:** in een instance is `"INSTANCE_CHAT"` betrouwbaarder dan `"PARTY"`. Buiten instances `"PARTY"`/`"RAID"`.
- **Vertrouwen:** comms-data is "self-reported" — een speler kan in theorie liegen. Voor een vriendschappelijke helper is dat geen probleem; vermeld het hooguit. Buff-status (§2) is daarentegen niet te faken.
- **Versie-compat:** neem een protocol-versienummer op in elk bericht, zodat oudere clients netjes degraderen.

---

## 5. Hoe ziet de check er praktisch uit?

Stroom bij betreden van een dungeon:

```
PLAYER_ENTERING_WORLD / ZONE_CHANGED_NEW_AREA
        │
        ▼
IsInInstance() == dungeon?  ──nee──►  niets doen
        │ ja
        ▼
wacht 1–2s (data settle)
        │
        ├─► Eigen check:
        │      • GetItemCount(flask/rune/hs/pots) → bij zich?
        │      • GetPlayerAuraBySpellID(flask/rune) → actief?
        │
        ├─► Per groepslid (party1..N):
        │      • aura-scan → flask/rune-buff actief?  (betrouwbaar)
        │      • combineer met eventuele STATUS-comms → tas bekend?
        │
        └─► (indien comms aan) broadcast eigen STATUS + verzamel anderen
        │
        ▼
Toon overzicht: per speler ✅/❌/❓ voor
   [Flask actief] [Rune actief] [Flask in tas] [Rune in tas] [HS in tas] [Pots in tas]
```

UI-voorstel: een compacte, opvouwbare regel-per-speler tabel die alleen verschijnt bij dungeon-entry (auto-hide na X sec of na een pull). Kleurcodering: groen = ok, rood = ontbreekt/niet actief, grijs `❓` = onbekend (geen comms-data van die speler). Eventueel een optionele party-chat melding "X mist een flask" — maar dat alleen op expliciete opt-in, want ongevraagde "consumable police"-berichten worden in groepen slecht ontvangen.

---

## 6. Concreet voorstel — afgestemd op de bestaande MidnightHelper-code

De codebase heeft al **bijna alle bouwstenen** die deze feature nodig heeft. Het voorstel is dus vooral *samenstellen van bestaande patronen*, niet vanaf nul bouwen.

### Wat al bestaat en herbruikbaar is

| Bestaand | Wat het levert voor deze feature |
|---|---|
| `ns.ConsumablesWowheadByClassSpec[CLASS][specIndex]` (`Modules/ConsumablesWowheadData.lua`) | **De item-ID-lijsten staan er al** — per class/spec met `flask.best/alternates`, `combatPotion`, `healingPotion`, `augmentRune`, `feast`, `personalFood`. Hiermee weet je exact welke item-IDs als "de juiste consumable" tellen → direct bruikbaar voor de tas-check via `C_Item.GetItemCount`. |
| `Modules/GearEnchantCheck.lua` | Bijna 1-op-1 het sjabloon: read-only `player`-scan, per-slot ✅/❌-rapport, `BuildReportLines`, paneel + `/mh`-commando, kopieerbalk, taint-veilig. De consumables-check is hetzelfde patroon, maar dan op tassen + auras i.p.v. enchant-slots. |
| `Modules/DelveShareSync.lua` / `RitualShareSync.lua` | **Het complete addon-comms-recept** staat er al: `PREFIX` (≤16), `PROTO`-versie, `RegisterAddonMessagePrefix` in `pcall`, `lastSeen`-dedupe, kanalen `PARTY`/`RAID`/`INSTANCE_CHAT`, self-whisper-testmodus, `|`-payload, en de regel "stuur nooit markup over de draad". Kopieer dit patroon voor een nieuwe `MHCons`-prefix. |
| `Modules/DungeonLiveCoach.lua` | Levert de entry-/encounter-triggers (`ENCOUNTER_START/END`, `PLAYER_REGEN_ENABLED`-queue), de `ENCOUNTERS`-tabel, en de combat-share-queue. Plus het boss-venster (`ns.BossWindowOnEncounter`) waar een consumables-overzicht aan vastgeklikt kan worden. |
| `ns.GetSpellLinkMarkup` / `ns.GetItemLinkMarkup`, `ns.panels[...]`, `ns:L(...)`, debug-guard `/mh debug` | UI-, link- en localisatie-helpers — direct gebruiken. |

### Wat nieuw moet (de enige echte toevoeging)

Eén nieuw datatabelletje: **flask/phial- en augment-rune-item → buff-spellID**. De bestaande data kent alleen item-IDs (voor tas + AH), maar voor "is de buff *actief*?" heb je de bijbehorende aura-`spellId` nodig. Dit is klein maar **patch-gevoelig**, dus isoleren — net zoals `ConsumablesWowheadData.lua` door een script uit JSON wordt gegenereerd. Koppel dit aan de bestaande `data/consumables_wowhead.json`-pipeline en aan `mh-daily-bluepost-check`, zodat een patch-bump op één plek landt.

### Voorgestelde nieuwe module: `Modules/ConsumableReadyCheck.lua`

Volgt exact de stijl van `GearEnchantCheck.lua` en `DungeonLiveCoach.lua`:

```lua
local _, ns = ...
-- 1) Eigen check (taint-veilig, read-only):
--    flask/rune/pots aanwezig?  → C_Item.GetItemCount(itemID) over ConsumablesWowheadByClassSpec
--    flask/rune actief?         → C_UnitAuras.GetPlayerAuraBySpellID(buffSpellID)  (nieuwe map)
-- 2) Groepscheck:
--    buff actief per party1..N  → loop C_UnitAuras.GetAuraDataByIndex(unit, i, "HELPFUL")
--    (tas van anderen: alleen via comms, zie ConsumableReadyComms)
-- 3) BuildReportLines(map) → ✅/❌/❓ per speler, hergebruik van het EnchantCheck-rapportpatroon
```

Triggers via een eigen event-frame (zoals GearEnchantCheck): `PLAYER_ENTERING_WORLD` + `ZONE_CHANGED_NEW_AREA` met `IsInInstance()`-filter (`instanceType == "party"`), `CHALLENGE_MODE_START` als scherpe M+ pre-pull-trigger, `GROUP_ROSTER_UPDATE` voor de roster-lijst, `UNIT_AURA` voor live buff-updates. Net als in `GearEnchantCheck` een korte `C_Timer.After(1–2, ...)` ná de zone-load zodat aura/roster gevuld zijn.

### Voorgestelde comms-module: `Modules/ConsumableReadyComms.lua`

Kloon van `DelveShareSync.lua` met `PREFIX = "MHCons"`, eigen `PROTO`, `lastSeen`-dedupe en self-whisper-testmodus. Elke MH-client broadcast zijn **eigen** compacte tas-status (`STATUS:flask=1;aug=1;hs=1;cpot=2;hpot=3`) bij entry/`GROUP_ROSTER_UPDATE`; ontvangers vullen daarmee de `❓ tas onbekend` van groepsleden in. Feature-flag in `ns.db.ui` (zelfde patroon als `dungeonLiveTips`), default aan.

> **Belangrijke nuance op de combat-gotcha uit `DungeonLiveCoach`:** die queue bestaat omdat **`C_ChatInfo.SendChatMessage`** (zichtbare chat) in combat door Blizzard wordt geblokkeerd (12.x). **`C_ChatInfo.SendAddonMessage`** (verborgen addon-comms — wat `DelveShareSync` gebruikt) valt *niet* onder die lockdown en mag wél in combat. Onze STATUS-broadcast gebruikt `SendAddonMessage` en heeft de queue dus niet nodig. Te verifiëren op de PTR, maar dit is consistent met dat `DelveShareSync` géén combat-guard heeft.

### UI-integratie

Twee opties, beide passend bij de bestaande opzet:

1. **Eigen tab/paneel** (`ns.panels["ready"]` o.i.d.) volgens het `BuildGearEnchantPanel`-patroon — een statisch overzicht dat je altijd kunt openen.
2. **Aanklikken bij het boss-/dungeon-venster** via `ns.BossWindowOnEncounter` — een compacte ✅/❌/❓-regel-per-speler die kort verschijnt bij dungeon-entry en auto-hide na een pull. Dit sluit het beste aan op "bij het betreden van een dungeon".

Aanbeveling: begin met optie 1 (snel, herbruikt EnchantCheck-paneel volledig), voeg optie 2 toe in een latere fase.

### Fasering

- **Fase 1 — eigen check + groep-buffstatus (geen comms).** Hergebruikt `ConsumablesWowheadByClassSpec` + het EnchantCheck-paneelpatroon + de nieuwe buff-spellID-map. Dekt al "heeft iedereen z'n flask/rune *aan*?". Hoge waarde, laag risico.
- **Fase 2 — tas-aanwezigheid via comms.** Kloon `DelveShareSync` → `MHCons`. Voegt healthstone/potion-voorraad van mede-MH-gebruikers toe.
- **Fase 3 — polish.** Per-boss her-checks via `ENCOUNTER_START` (in `DungeonLiveCoach` inhaken), buff-bijna-verlopen-waarschuwing (`aura.expirationTime`), pre-pot reminder, opt-in party-chat melding (via de bestaande combat-veilige share-queue).

---

## 7. Codestijl-regels om te respecteren (uit `.cursorrules`)

- **Namespace:** elk bestand `local addonName, ns = ...`; alles op `ns`, nooit een globale addon-tabel; `ns` niet hernoemen.
- **Moderne API + guards:** `C_AddOns.*`, `C_Item.*`, `C_UnitAuras.*`, `C_ChatInfo.*`; elke onzekere call in `pcall`; nooit aannemen dat een API bestaat (`if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then ...`).
- **Change discipline:** één ding tegelijk, geen brede refactors, geen herformattering buiten het gewijzigde blok, geen hernoemen van bestaande functies/frames. **`.toc` niet aanraken tenzij Rob er expliciet om vraagt** — ook niet voor load-order van een nieuwe module (Rob beheert de `.toc`). Voorstel: nieuwe modulebestanden aanmaken en Rob vragen ze zelf in de `.toc` te zetten.
- **Debug:** geen kale `return` in refresh-functies zonder debug-print onder `ns.db.ui.debug`.
- **Frame-naming:** `MidnightHelper<Module><Purpose>` voor named frames.
- **Localisatie:** `nlNL` houdt WoW-termen Engels (*Flask*, *Phial*, *Augment Rune*, *Healthstone*); alleen volzin-shell-tekst vertalen. Nieuwe strings in `Locales/enUS.lua` + `nlNL.lua` (en bij twijfel dezelfde Engelse string in beide).
- **Commit-discipline:** na elke afgeronde wijziging Rob herinneren te committen in GitHub Desktop.

> Geen code geschreven — dit is bewust eerst de analyse + het voorstel. Zeg het woord en ik bouw Fase 1 (`Modules/ConsumableReadyCheck.lua`) in deze stijl, inclusief de nieuwe buff-spellID-map, en lever de `.toc`-regel die je er zelf bij kunt zetten.
