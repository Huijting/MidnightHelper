# Ritual Sites — referentie voor Midnight Helper

**Status:** alleen documentatie; nog niet verwerkt in de addon.  
**Aangemaakt:** 2026-06-02 (user-overzicht, beginner-vriendelijk NL)  
**Morgen:** samen bepalen waar dit in MH past (Codex, Void & Rituals-tab, tooltips, vault-hints, …).

---

## Bestaande MH-aansluitpunten (nu in code)

| Plek | Huidige inhoud (kort) |
|------|------------------------|
| Tab **Void & Rituals** | `Modules/VoidAssaults.lua` — live site, Field Accolades, TomTom |
| **Midnight Codex** | `CODEX_RITUAL_*` / `ritual_sites` in `Locales/Codex.lua`, `MidnightCodexData.lua` |
| **SMC City Guide** | checklist-pin naar Ritual-tab (context) |

Dit document vult die plekken aan met **Tier / Challenges / loot / Great Vault**-uitleg.

---

## Wat zijn Ritual Sites?

Ritual Sites zijn een soort mini-dungeons op de wereldkaart van de Midnight uitbreiding. Je kunt ze alleen doen, of gezellig samen met vrienden. Het doel? Een ritueel verstoren, monsters verslaan en vette paarse uitrusting (gear) verdienen!

---

## Stap 1: De start (Tier 1)

Als je voor het eerst naar een Ritual Site vliegt, begin je op **Tier 1** (Level 1).

- Dit is de makkelijkste stand.
- De monsters hebben weinig levens en doen bijna geen pijn.
- Je loopt naar binnen, verslaat de eindbaas en je bent klaar.

---

## Stap 2: Wat zijn Challenges? (Vanaf Tier 2)

Als je Tier 1 haalt, speel je **Tier 2** vrij. Vanaf nu wordt het spelletje leuker én moeilijker door **Challenges** (uitdagingen).

**Wat is een Challenge?**  
Dit is een extra pestkop-regel die de dungeon moeilijker maakt. Bijvoorbeeld:

- er vallen paarse meteorieten uit de lucht die je moet ontwijken, of
- monsters laten een plas vergif achter als ze doodgaan.

**Hoe werkt het?**  
Voordat je de dungeon start, klik je op een **altaar**. Daar vink je de Challenges aan die jij aandurft.

---

## Stap 3: De levels omhoog (De Ladder)

Elk level dat je omhooggaat, eist dat je **méér Challenges tegelijk** aanzet. Dit is de trap die je oploopt:

| Tier | Verplichte Challenges | Opmerking |
|------|------------------------|-----------|
| **Tier 1** | 0 Challenges | Super makkelijk |
| **Tier 2** | 1 Challenge | — |
| **Tier 3** | 1 Challenge | Monsters zijn wel iets sterker |
| **Tier 4** | 2 Challenges tegelijk | (voorbeeld uit spelersessie) |
| **Tier 5** | 4 Challenges tegelijk | Allermoeilijkste stand |

---

## Stap 4: Wat krijg je als beloning? (De Loot!)

Waarom zou je het jezelf zo moeilijk maken? Omdat de beloningen steeds beter worden! Je krijgt twee soorten beloningen:

### 1. Direct na de dungeon (Munten en Kisten)

- Elke keer dat je wint, krijg je paarse munten (**Field Accolades**).
- Hoe hoger de **Tier**, hoe meer munten je krijgt.
- Met deze munten loop je naar de **winkel (vendor) in Silvermoon City**. Daar kun je zelf sterke wapens en pantsers van kopen.

### 2. De Great Vault (De wekelijkse schatkist)

- Als je minimaal **één Ritual Site** hebt gedaan, mag je de **woensdag** daarna een gratis cadeau ophalen uit de **Great Vault** (de grote schatkist in de hoofdstad).
- **Tier 4 gehaald?** → Champion item in de vault (**ilvl 263**) — heel sterk.
- **Tier 5 gehaald?** → Hero item in de vault (**ilvl 269**) — absolute top-gear.

---

## Samenvatting voor de beginner

1. Kies je level (**Tier**).
2. Zet de extra pestkop-regels (**Challenges**) aan bij de start (altaar).
3. Overleef de dungeon en versla de baas.
4. Pak je munten, ga naar **Silvermoon City** voor gear, en vergeet op woensdag je grote wekelijkse schatkist niet te openen!

---

## Open punten voor MH-integratie (morgen)

- [ ] Waar tonen: alleen Codex, of ook **Void & Rituals** + Home / vault-regel?
- [ ] Tier-ladder + vault-ilvl (263 / 269) — statisch of live uit API?
- [ ] Challenges: alleen uitleg, of later lijst per site?
- [ ] NL-only bron → EN/DE/FR/ES/PT vertalen voor Codex?
- [ ] Koppeling **Field Accolades** weekly cap (bestaat al op tab) expliciet maken in tekst
