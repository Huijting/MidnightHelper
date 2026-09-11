# Spec 39 — Currencies: wat je characters hebben, en wat je ermee moet doen

**11 sep 2026.** Robs idee van die ochtend: *"Currency's, hebben wij die ook allemaal in een overzicht
zodat we weten wat onze characters hebben, en dan gaat het wel om nuttige currency's, maar
belangrijker, kunnen we van daar uit ook zien wat we er mee kunnen of misschien wel moeten doen?"*
Rob keurde het voorstel goed (*"ga je gang met jouw voorstellen"*) terwijl WoW dicht was voor
ComfyUI. **Gebouwd, nog niet in het spel gezien.**

## Wat er was (GEMETEN vóór het bouwen)

- `Modules/CurrencyGuide.lua` (tabblad Currencies): waar verdien je het en waar geef je het uit,
  met het live saldo van **alleen het huidige character**. De tekst is van 15 jun en noemde **geen
  enkele Season 2-currency**.
- `db.charCurrencies` bewaarde per character vijf currencies: keys, shards, Undercoins, Mana
  Crystals en Manaflux.
- Het blok *This week* gaf al twee adviesregels voor het hele account (keys, Catalyst charges).

## Wat er gebouwd is

1. **`Modules/CurrencyAccount.lua`**: het blok **"Your characters"** bovenaan de Currencies-tab,
   met negen rijen: Restored Coffer Key 3028, Coffer Key Shards 3310, Venomblight Manaflux 3465,
   Undercoin 2803, Untainted Mana-Crystals 3356, Corrosive Coin 3448, Voidlight Marl 3316, Field
   Accolade 3405, en Crests als één rij met vijf tiers in de tooltip. Per rij zie je het icoon, de
   naam van de client, het accounttotaal en één adviesregel. De tooltip toont elk character.
2. **Opslag:** `SaveCurrentSnapshot` schrijft een nieuw veld `cur = { [id] = { q, w, t } }` (saldo,
   deze week verdiend, totaal verdiend). Er komt alleen iets bij. Een record zonder `cur` staat als
   *"not seen yet"*, niet als 0.
3. **Advies alleen waar het spel een reden geeft:**
   - **Vol:** saldo ≥ `maxQuantity` van de client. Voor Manaflux geldt een terugval op 8, dezelfde
     waarde als AltOverview.
   - **Season-maximum bereikt:** `useTotalEarnedForMaxQty` en `totalEarned` ≥ `maxQuantity`.
   - **Anders:** een "waarvoor"-regel, `CURACC_USE_*`.
   - Of je iets tussen characters kunt verplaatsen, zegt de tooltip alleen als
     `isAccountTransferable` waar is, omdat de bronnen elkaar tegenspreken.
4. **`/mh curscan`** print de ruwe velden per currency en bewaart ze in `ns.db.curScan`.
5. **De gids zelf:** Marens Season 1-caches (*"Champion 75 / Hero 500"*) bestaan niet meer. De zin
   zegt nu dat ze in Season 2 Veteran-gear verkoopt, voor 500 willekeurig of 750 met een gekozen
   slot. Dat staat in alle 7 talen, gemarkeerd in `check_drift`.

## Bronnen voor de "waarvoor"-regels (onderzoeksagent, 11 sep; niet in de client gemeten)

| regel | bron | zekerheid |
|---|---|---|
| Keys: Bountiful Coffer, tot 4 Bountiful delves per dag | Wowhead Season 2 Delves-gids (bijgewerkt 19 aug); Blizzard "Season 2 is Now Live" (18 aug) | hoog |
| Shards: 100 → 1 key, gaat vanzelf bij het binnengaan van een delve; weekcap 600 | warcraft.wiki.gg Coffer_Key_Shards; Wowhead-gids 19 aug; MH mat 600 zelf | hoog |
| Undercoin: Naleidea Rivergleam (Delver's HQ, 2 keys/week vanaf rank 6), Zah'ran na Tier 6+ (Champion) | Wowhead-gids 19 aug; Icy Veins Delver's HQ (1 aug, van vóór live) | middel |
| Mana Crystals: Hero-gear bij Zah'ran vanaf rank 9 | Wowhead-nieuws 10 apr (Season 1) + Delves-gids 19 aug | middel; de caps van Season 2 zijn onbekend |
| Manaflux: 1 charge = 1 stuk bij de Catalyst, per character, stopt bij 8 | Icy Veins Catalyst (11 aug); Wowhead-tooltip; wow-tracker (4 sep) | hoog |
| Corrosive Coin: Er'inye (Altar-punten), Skull of Er'inye (mount/pets/cosmetics); **geen** Gifts, want die kosten Souls | Wowhead Vaults-gids (7 aug); Method-vendorgids | hoog |
| Marl: Renown QM's + nieuw Jan'sari the Watchful (Zul'jarra's Forces, Coiled Isle) | Blizzard 6 aug; Icy Veins Zul'jarra's Forces; Blizzard Watch 20 aug | hoog |
| Accolade: Maren → Veteran-caches 500/750; Triam → cosmetics | warcraft.wiki.gg Field_Accolade; Icy Veins (15 aug) | middel-hoog |
| Crests: 20 per stap, elke crest alleen op zijn eigen track | Wowhead (13 aug); Icy Veins (11 aug) | hoog |

## Open, niet gebouwd

- 🔎 **De crest-vendor:** MH schrijft "Cuzoth", Wowhead "Cuzolth". Rob kan het in het spel lezen.
- 🔎 **De Codex-teksten over currencies** (`Locales/Codex.lua`, `CODEX_CUR_*_BODY`) zijn vaag en van
  vóór Season 2. Bij Mana Crystals staat letterlijk *"check current patch notes"*. Bij Accolades
  staat een weekcap die geen bron noemt; `/mh curscan` beslist dat.
- 💡 **`C_CurrencyInfo.FetchCurrencyDataFromAccountCharacters(id)`** (na
  `RequestCurrencyDataForAccountCharacters`) geeft per character een saldo, zonder dat je op dat
  character hoeft in te loggen. Dat werkt alleen voor verplaatsbare currencies, en in 12.x mogelijk
  alleen zonder taint. **Niet in de client getest.** Het kan het gat *"not seen yet"* dichten.
- 💡 **Manaflux** heeft `rechargingCycleDurationMS`, waarmee we kunnen tonen wanneer de volgende
  charge komt.
