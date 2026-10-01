# Patch 12.1.5 — afvinklijst

**Live:** 13 okt (VS) / **14 okt (EU)**, met het wekelijkse onderhoud. Bron: news.blizzard.com, gelezen door de
PTR-wachter op 30 sep (`PTR_12.1_WATCH.md:475`). Laatste PTR-build: **70077** ("PTR Changes 4", 29 sep).
Gemaakt 1 okt 2026 op Robs vraag ("Wisten we dit en/of moeten we er wat mee?" → "Ja doe maar"), uit de vier
wachter-logs + `NEXT_SESSION.md`; de kernpunten zijn daarna door mij nagecontroleerd (TOC-regel, 120105,
Codex-zin, het 6/13/20-okt-schema). GEMETEN = in bron of code gezien; AFGELEID = redenering.

## In het kort (voor Rob)

1. **Vóór 14 okt: de addon mag niet kapot.** Bijna alles is al afgedekt. Open: het versienummer in de TOC
   (één regel) en één controle op de testserver.
2. **In de patchweek: de uitleg bijwerken** — Labyrinth-delve, raid Kith'ix, Aqir Invasion, Keystone Myth,
   de nieuwe upgrades.
3. **20 okt: de crest cap verdwijnt** → één Codex-zin wordt dan onwaar.

---

## A. MOET vóór 14 okt (anders fout of foutmelding op patchdag)

| # | Wat | Status | Wie |
|---|---|---|---|
| A1 | **TOC: `120105` toevoegen** aan `## Interface: 120007, 120100` (`MidnightHelper.toc:1`). Zonder heet de addon "verouderd" (AFGELEID; `API_WATCH.md:709` noemt het "compat-nummer, geen API-breuk"). | ✅ in de code sinds 1 okt (Rob: "Zet die 120105 er maar alvast in") en ✅ uitgebracht in **4.4.0** (1 okt) | ik |
| A2 | `GetItemCooldown` verdwijnt → alles loopt via `ns.GetItemCooldownSafe` (`Delves.lua:349-360`). | ✅ gerepareerd 5 sep (`0de3443`); in de client nog nooit met `/dump` bevestigd | Rob (PTR) |
| A3 | `tostring` op secret values kon crashen. | ✅ afgedekt (`DundunShrine.lua`, `c4ba893`; overige aanroepen achter leesbaarheidscheck) — GEMETEN | — |
| A4 | **Auras opsommen in combat geeft een fout** ("Auras cannot be accessed when secret while tainted"). Overal in `pcall` → geen Lua-fout, maar dispel/purge-prompts zwijgen in combat. GEMETEN op build 69594 (`NEXT_SESSION.md:6746`). | ⚠️ ontwerp-gat; hermeten op 70077 | Rob (PTR) |
| A5 | `SetCooldown`/`Clear` op beschermde frames geblokkeerd. | ✅ niet geraakt (eigen frame, `CombatSafety.lua`) — GEMETEN | — |
| A6 | Castbar-ID per unit token, hoofdletters tellen. | ✅ niet geraakt (alleen kleine letters; 0 hits hoofdletters, controle 387) — GEMETEN | — |
| A7 | Tien `Blizzard_Deprecated*`-terugvallers weg. | ✅ geen van die functies gebruikt (grep + controle) — GEMETEN | — |
| A8 | Nieuwe standaard-keybinds op de PTR (Y, B/Shift-B). | ❓ alleen relevant als ze live gaan; raakt hooguit LayoutWizard/KeybindExport — AFGELEID | live checken |

**Eén PTR-sessie voor Rob (± 10 minuten), het liefst in de week van 6 okt:** `tools/copy_to_ptr.bat` (eigen
stap), inloggen op de 12.1.5-PTR, `/mh ptr` laten lopen en één keer een dungeon-pull in combat. Dat settelt A2,
A4 en of de addon zonder "verouderd" laadt. `/reload` + BugSack = de test.

## B. Patchweek: wat MH moet gaan uitleggen

Geen enkel 12.1.5-ID is al in de client bevestigd; alles hieronder zijn kandidaten. **Pas bouwen als het live
is** — dan pas kan het spel ze laten zien.

| Onderwerp | Wat we weten (bron) | Raakt in MH | Nu in MH |
|---|---|---|---|
| **Labyrinth of Kindo'jan** — megadelve, solo/duo, met Valeera, kost Coffer Keys | 9 kamers, Tier 11-solo-uitdaging (`PTR_12.1_WATCH.md:475`); kamernamen build 69594 (:379); handschoen-upgrades tot ilvl 334 (:384); kandidaat-achievements o.a. "Let Me Solo Him: Kindo'Jan" (mount Loa-Blessed Wayfarer) | delve-coach, `ValeeraProgress.lua`, achievements, Codex | niets |
| **The Unbinding of Kith'ix** — raid met één baas (Lady Liadrin erbij) | Story/Normal/Heroic/Mythic, Mythic 15-25 (:475); Mythic-loot Myth 3/6 = ilvl 324 (:438) | raid-tips, vault/gear-advies, achievements | niets |
| **Keystone Myth** keert terug | "Midnight Keystone: Season 2" bij M+-rating 3600 (S1 was 3400) | M+/mijlpalen | niets |
| **Verhaalcampagne** "The Promise of Tomorrow" (eindbaas Kith'ix) | :375 | `CampaignLeadIn.lua`, weekplanner | niets |
| **Aqir Invasion** — 10 min per uur in Eversong of Zul'Aman, 8 affixen, 6 scenario's | kandidaat-achievements (:379) | evenementen/timers (zoals Curse Surge), achievements | niets |
| **Voidcore/Venomstone-schema** | **week 6 okt:** extra Nebulous Voidcore bij Orin Straylight (Silvermoon), quest 97945-kandidaat, 10× Elementary Voidcore Shard (`PTR_12.0.7_DATA.md:720-726`); **week 13 okt:** quest "Ancient Depths, Ancient Venom"; **week 20 okt:** crest cap **permanent weg** | `VaultAdvisor.lua` (Voidcore-regel), crest-pagina's, Codex | alleen de Vault-Voidcore-regel |
| Glory of the Wartorn Hero: 3 deel-achievements vervallen als eis | :447 | `Achievements.lua` | niets |

🔴 **20 okt — wordt onwaar:** `Locales/Codex.lua:105` (`CODEX_CUR_DAWN_BODY`) zegt over de crest cap *"It goes up
every week."* — in 7 talen. Dat moet in de patchweek mee (+ `check_drift --mark`). `CurrencyAccount` en
`DawncrestGuide` lezen de cap live uit de client en zouden zich zelf moeten aanpassen (AFGELEID — open vraag C5).

## C. Alleen in de client / op de PTR te beantwoorden

1. Laadt MH met alleen `120100` op 12.1.5 zonder "verouderde addons laden"? (wordt moot zodra A1 erin zit)
2. `/mh ptr` op 70077: bestaat `C_Item.GetItemCooldown`, is de kale globale weg; treedt de aura-weigering (A4)
   nog op, en wanneer?
3. Definitieve ID's: Labyrinth-achievements (ook de "[DNT]"-naam), Kith'ix journal/encounter-ID's, Aqir
   Invasion-event en affixen, questID "Ancient Depths, Ancient Venom", currencyID Venomstone. Voidcore-currency
   **3418 of 3513** is nog steeds niet beslist.
4. Is Mythic Kith'ix bij launch nog Myth 3/6, en echt flex 15-25?
5. Na 20 okt: leest `maxQuantity` van crests 0 of nil? Toont MH dan "geen cap" goed?
6. Gaan de nieuwe standaard-keybinds live?
7. Telt de extra Voidcore van Orin (6 okt) mee in de bestaande bonus-roll-regel van `VaultAdvisor`, of krijgt hij
   een eigen regel?

## Tijdlijn

| Wanneer | Wat |
|---|---|
| **nu – 5 okt** | A1 in de code; release met 120105 klaarzetten |
| **week 6 okt** | Rob: PTR-sessie (A2/A4/C1/C2). Release mét 120105 vóór 13 okt (Robs "go"). Orin-Voidcore live → C7 |
| **13/14 okt** | patch live → de ochtendwachters lezen de patch notes; content-wachter zegt "alle kaarten checken" |
| **14–20 okt** | B: delve-coach Labyrinth, Kith'ix-tips, Aqir Invasion, Keystone Myth, campagne — elk pas na meten in de client |
| **20/21 okt** | crest cap weg → Codex-zin + C5 |
