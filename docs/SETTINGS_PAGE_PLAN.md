# Plan: Settings-tab in Midnight Helper — "Mission Control"

Robs opdracht (12 jun): de settings-pagina ín MH zelf inbouwen, met een
"super gave spectaculaire look". Dit plan beschrijft wat we hebben, wat het
wordt, hoe het eruitziet en in welke fasen we bouwen. Besluiten voor Rob
staan onderaan.

---

## 1. Wat we nú hebben (inventaris)

**Broker-minimap-paneeltje** (klein, functioneel, verstopt):
taalkeuze, guide-zichtbaarheid, compact mode, open-bij-login,
rare-alert aan/uit + "alleen tijdens hunt", open-main, reset.

**Alleen via slash/gestures (onzichtbaar voor gebruikers):**
live boss-tips bij pull (/mh livetips), toast-positie (slepen),
boss-venster schaal/breedte/positie (shift+scroll/grip/slepen),
rare-alert-geluid (db-veld, geen UI), debug (/mh debug).

**Probleem:** de helft van onze beste features heeft geen zichtbare knop,
en het Broker-paneel is een lijstje checkboxes zonder uitstraling — niet
passend bij wat MH inmiddels is.

---

## 2. Het concept: "Mission Control"

Een volwaardige **Settings-tab in de sidebar** (sectie TOOLS, boven
"Addons"), opgebouwd als commandocentrum in MH-huisstijl:

```
┌──────────────────────────────────────────────────────────────┐
│  ⚙ SETTINGS                    [zoekbalk: vind een instelling]│
│                                                              │
│  ╔═ EYECATCHER-STRIP ════════════════════════════════════╗  │
│  ║ 3D-model (roterend, void-paars belicht) + MH-versie    ║  │
│  ║ + één regel: "57 downloads · 6 talen · never lie"      ║  │
│  ╚════════════════════════════════════════════════════════╝  │
│                                                              │
│  [🌍 Algemeen] [🔔 Meldingen] [🗡 Dungeon] [🤝 Delen] [🛠 Geavanceerd]
│   (categorie-knoppen, actieve gloeit goud)                   │
│                                                              │
│  ┌─ CARD ───────────────────────────────────────────────┐   │
│  │ ◉ Rare-meldingen                          [TEST 🔊]  │   │
│  │   Popup + geluid zodra een rare in de buurt is.       │   │
│  │   ▸ Alleen tijdens een rare-hunt          [○──]      │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────┘
```

### De spektakel-ingrediënten (allemaal haalbaar in WoW-UI)

1. **Eyecatcher-strip met levend 3D-model** — een PlayerModel met langzame
   rotatie (OnUpdate → SetFacing += 0.003). Kandidaten: de actieve world
   boss (we hebben de creature-IDs!), de dungeon-van-de-week-eindboss, of
   rouleren per bezoek. Clip-container (les van vandaag) zodat niets
   uitsteekt.
2. **Void-parallax-achtergrond** — twee gelaagde getilede texturen
   (Blizzards eigen void/sterren-assets) waarvan de bovenste traag
   verschuift via SetTexCoord-animatie in OnUpdate. Subtiel, geen disco.
3. **Categorie-knoppen met goud-gloed** — actieve categorie krijgt een
   pulserende glow (alpha-animatie via AnimationGroup, geen OnUpdate-spam).
4. **Moderne toggles** — eigen switch-look (rail + schuifknopje, goud =
   aan, grijs = uit) i.p.v. kale UICheckButtons; valt terug op checkbox
   als de texturen tegenvallen.
5. **LIVE previews** — dit maakt 'm écht gaaf én nuttig:
   - "Test"-knop bij rare-melding → vuurt de toast met het laatst geleerde
     model + geluid (bestaande TestRareAlert).
   - "Test"-knop bij shard-cap → bestaande TestShardCapAlert.
   - "Voorbeeld"-knop bij toast-positie → toont een sleepbare
     voorbeeld-toast ("sleep mij!") die de positie meteen opslaat.
   - Boss-venster-kaart → "Open voorbeeld" (ShowDungeonBossWindow) +
     schaal-slider die live meeschaalt.
6. **Settings-zoekbalk** — typ "geluid" of "boss" en alleen matchende
   cards blijven staan (we hebben al zoek-infra + gecureerde keywords als
   patroon in de codebase).

### Categorie-indeling (voorstel)

| Categorie | Inhoud |
|---|---|
| 🌍 **Algemeen** | Taal (6 vlag-knoppen), open bij login, compact mode, guide-zichtbaarheid |
| 🔔 **Meldingen** | Rare-alert (aan/uit · geluid · alleen-tijdens-hunt · TEST), shard-cap (aan/uit · TEST), toast-positie (voorbeeld-toast + reset-knop) |
| 🗡 **Dungeon Coach** | Boss-stappen in chat bij pull, boss-venster auto-open, venster-schaal (slider, 0.7-1.8) + positie-reset, model-zijpaneel standaard aan/uit |
| 🤝 **Delen** | Delve/ritual/boss-share gedrag (nu informatief; toggles zodra fase 5-sync landt) |
| 🛠 **Geavanceerd** | Keybind-verwijzing (Blizzard-menu), debugmodus, per-onderdeel data-reset (toast-positie, geleerde rare-IDs, venster-layout), versie-info |

### Technische aanpak (hergebruik, geen nieuwbouw)

- Nieuwe `Modules/SettingsPage.lua` + sidebar-entry; rendering op de
  bewezen push/Relayout-engine (DungeonGuide-patroon, incl. de
  EditBox/hoogte-lessen).
- Elke toggle schrijft naar de **bestaande** `ns.db.ui`-velden via de
  bestaande setters (SetRareAlertEnabled, SetRareAlertOnlyWhileRouting,
  ToggleDungeonLiveTips → nieuwe Set-variant, etc.) — geen dubbele
  waarheid.
- Het Broker-paneel wordt een mini-versie: taal + "Open Settings"-knop
  (of vervalt — besluit Rob).
- Locale-keys netjes ×6 vanaf dag één (we kennen het riedeltje).

### Fasering

- **F1 — Skelet (1 sessie):** tab + categorieknoppen + cards voor alle
  BESTAANDE toggles (migratie Broker-functionaliteit), zoekbalk.
- **F2 — Zichtbaar maken wat verstopt was:** livetips-toggle,
  bosswin-auto-open, geluid-toggles, schaal-slider, alle TEST/voorbeeld-
  knoppen.
- **F3 — Het spektakel:** eyecatcher-model, parallax-achtergrond,
  goud-gloed, toggle-switch-look.
- **F4 — Opruimen:** Broker-paneel afslanken, /mh-testcommando's blijven
  bestaan maar verdwijnen uit alle gebruikersdocumentatie (Robs besluit
  van vandaag — al doorgevoerd in de CF-teksten).

### Open besluiten voor Rob

1. Eyecatcher-model: world boss van de week, dungeon-eindboss, of
   rouleren?
2. Broker-minimap-paneel: mini-versie houden of helemaal vervangen?
3. Schaal-bediening boss-venster: slider in settings ALS extra naast
   shift+scroll (voorstel: ja, beide).
4. "Geavanceerd" zichtbaar voor iedereen of achter een uitklapje?
5. Naam van de tab: "Settings", "Instellingen" (gelokaliseerd) — voorstel:
   gelokaliseerd, zoals alle tabs.
