# Spec 36 — MH-schermen bereikbaar vanaf een Stream Dock / macropad

**Van:** ONDERZOEK-sessie, 9 sep 2026
**Aanleiding:** Rob heeft een **Stream Dock** (Mirabox-familie; model dat hij noemt: "MTSVI",
niet geverifieerd) en wil per knop één MH-scherm openen.
**Vervangt niet, maar concretiseert:** het geheugenbriefje `keypad-window-shortcuts`.

---

## 0. De harde randvoorwaarde

Een Stream Dock kan **twee** dingen die WoW bereiken:

1. een **toetsaanslag** sturen (eventueel met Ctrl/Alt/Shift), en
2. **tekst typen** in het venster dat focus heeft.

Meer niet. Er is geen API van de deck naar de client. Dus élke oplossing loopt via
**een keybinding** of via **een slash-commando dat via de chatregel wordt getypt**.

---

## 1. GEMETEN stand op 9 sep 2026

### 1a. Keybindings — er zijn er drie

`Bindings.xml` (wordt door de client automatisch geladen; staat terecht **niet** in de `.toc`):

| Binding | Default |
|---|---|
| `MIDNIGHTHELPER_TOGGLEMAIN` | **ALT-M** |
| `MIDNIGHTHELPER_SKIPNODE` | — |
| `MIDNIGHTHELPER_CLEARROUTE` | — |
| `CLICK MidnightHelperHealPotion:LeftButton` | — |
| `CLICK MidnightHelperCombatPotion:LeftButton` | — |

**Er is geen enkele binding die een specifiek scherm opent.** ALT-M opent het hoofdvenster op
de tab waar je hem het laatst achterliet (`UI.lua:3411`, `SelectTab(ns.uiSelectedTab or "home")`).

### 1b. Slash-commando's — vier schermen, van de 25

`SLASH_MIDNIGHTHELPER1/2 = "/mh", "/midnight"` (`Core.lua:741-742`). De handler loopt van
`Core.lua:847` tot het einde van het bestand (2982) en eindigt met:

```lua
if msg ~= "" then
    ... UNKNOWN_COMMAND ...
    return
end
```

**GEMETEN: er is géén fallback die een onbekend argument als tab-id behandelt.** `/mh rares`
zegt vandaag "onbekend commando".

Wat wél een scherm opent:

| Commando | Opent |
|---|---|
| `/mh` (leeg) | hoofdvenster, laatste tab |
| `/mh codex` \| `wiki` \| `handbook` | Codex |
| `/mh settings` | native Blizzard-opties (valt terug op de Settings-tab) |
| `/mh coach` \| `delve` \| `delves` | Delve Coach (eigen venster) |

In `Core.lua` staan slechts **2** `SelectTab(`-aanroepen (regels 2567 en 2585) — precies wat het
geheugenbriefje op 8 sep al vaststelde.

### 1c. Er zijn 25 top-level tabs

`UI.lua:1928` `TAB_DEFS`: starthere, dungeons, codex, home, delves, account, rares, achievements,
mounts, tradingpost, raids, world, events, delvelog, enchants, tier, omnium, smcguide, currency,
guide, toolslaunch, toolbox, addons, settings (+ aliassen voor reference, professions, macros,
consumables, academy, profoverview, profacademy).

`ns.SelectTab(id)` bestaat en accepteert die ids én de aliassen (`UI.lua:3624`).

**Conclusie: 21 van de 25 schermen zijn vandaag op geen enkele manier vanaf een knop te openen.**

---

## 2. Wat er gebouwd moet worden

### Stap 1 — `/mh <tab>` fallback  🟢 klein, doet meteen alles

Vlak vóór de `UNKNOWN_COMMAND`-tak in `Core.lua`:

```lua
-- /mh <tab-id> — open dat scherm rechtstreeks. Bedoeld voor macropads/Stream Decks,
-- die één regel tekst kunnen sturen. Onbekende ids vallen door naar UNKNOWN_COMMAND.
if ns.IsKnownTab and ns.IsKnownTab(msg) then
    if ns.ShowMainUI then ns:ShowMainUI() end
    ns.SelectTab(msg)
    return
end
```

Randvoorwaarden:
- `ns.IsKnownTab` moet **de aliassen meenemen** (dezelfde tabel die `SelectTab` gebruikt),
  anders werkt `/mh macros` niet terwijl `SelectTab("macros")` dat wél doet.
- ⚠️ Zet het **ná** alle bestaande takken. `settings`, `codex`, `delves` hebben al eigen gedrag
  (native opties, codex-zoeker, coach-venster) en dat moet voorgaan.
- 🔴 Nieuw commando ⇒ ook in `ns.MH_COMMANDS` (`Modules/CommandList.lua`) **en** in
  `NavSearch.lua`, anders is het onvindbaar — zie [[mh-already-contains-it]].
- Eén regel in `/mh help`: *"/mh <schermnaam> — open dat scherm meteen"*, met de lijst.

Hiermee kan een Stream Dock via de tekst-actie élk van de 25 schermen openen.

### Stap 2 — zes instelbare keybind-sloten  🟡 het echte antwoord voor een deck

Waarom niet 25 vaste bindings: dat zijn 25 regels in Blizzards Keybindings-scherm voor
**iedereen**, terwijl dit volgens Rob zelf *"een gadget voor freaks"* is.

Voorstel: **zes** vaste regels in `Bindings.xml`:

```
MIDNIGHTHELPER_QUICK1 .. MIDNIGHTHELPER_QUICK6
```

- Elk slot wijst naar een scherm dat de speler in de MH-instellingen kiest (dropdown met de
  25 tab-labels). Standaard leeg = doet niets, kost niemand iets.
- Label in het keybind-scherm: *"Snelknop 1 (Rares)"* — dus mét het gekozen scherm erin, zodat
  het scherm zichzelf uitlegt. Kan via `_G.BINDING_NAME_*` bij het laden en na elke wijziging.
- Voordeel boven de tekstroute: **geen chatregel**, werkt in gevecht, geen timing.

### Stap 3 — documentatie 🟢

Eén Codex-artikel of een blok in de Guide-tab: *"MH op een Stream Deck / macropad"*, met de
valkuilen uit §3 hieronder. Dit is ook goed CurseForge-materiaal (zie
[[SPEC_31_COMMUNITY_REACH]] — een addon die aan streamdeck-gebruikers denkt, wordt gedeeld).

---

## 3. Valkuilen aan de Stream-Dock-kant (extern gevonden, 9 sep 2026)

| Valkuil | Wat er gebeurt | Oplossing |
|---|---|---|
| **WoW draait als administrator, de deck-software niet** | Windows UIPI laat een proces met minder rechten geen invoer sturen naar een proces met meer rechten. De knop doet niets, zonder foutmelding. | Deck-software óók als administrator laten starten (rechtsklik op de .exe → Eigenschappen → Compatibiliteit). ⛔ **Niet** `EnableLUA` op 0 zetten, ook al staat dat in de Mirabox-FAQ — dat schakelt UAC voor het hele systeem uit. |
| **F13–F24** | Meerdere Blizzard-forumdraden: WoW herkent F13–F24 op Windows niet en je kunt ze niet eens in het keybind-scherm aanklikken. Bronnen zijn 2019; niet hermeten op 12.1. | Niet op bouwen. Gebruik `CTRL-ALT-SHIFT-<toets>`; die combinatie druk je nooit per ongeluk. |
| **Tekst-actie te snel** | De chatregel is nog niet open als de eerste tekens aankomen. | Operation Flow: `Enter` → wacht 150 ms → tekst → `Enter`. |
| **Focus** | De deck typt in het venster dat focus heeft. Alt-tab weg = de tekst landt ergens anders. | Niets aan te doen; wel vermelden. |

---

## 4. Wat Rob zelf moet uitzoeken (10 seconden per stuk)

1. Stuurt zijn Stream Dock **drie modifiers tegelijk** (Ctrl+Alt+Shift+toets)? Testen in het
   keybind-scherm van WoW.
2. Accepteert WoW **F13** op zijn client? Keybind-scherm openen, een vak aanklikken, F13 sturen.
   Als het werkt is dat een schat aan vrije toetsen, maar reken er niet op.
3. Welk model deck het precies is (aantal knoppen bepaalt de indeling).

---

## 5. Volgorde

1. **Stap 1** — kleine wijziging, ontsluit alle 25 schermen, ook voor mensen zonder deck
   (WoW-macro `/mh rares` op een barslot doet het dan ook).
2. **Stap 3** — het artikel; kost bijna niets en is precies MH's lijn (uitleggen).
3. **Stap 2** — alleen als Rob de tekstroute in de praktijk te traag vindt.
