# Combat Safety — plan (concept, 2026-07-04)

Nieuwe on-screen combat-helper voor Midnight Helper, geïnspireerd op **TargetedSpells**
en **GTFO** (beide geïnspecteerd). Doel: in **Delves/solo/dungeons** waarschuwen voor
(a) een gevaarlijke cast die op JOU gericht is, en (b) dat je in een schadelijk
grondeffect staat — **zonder** GTFO's onhoudbare handmatige spell-database.

Rob's keuze (04-07): **eerst mockup/plan**; alarm-stijl = **visueel (icoon/gloed) +
tekst-cue ("MOVE!")**, **geen geluid** (geluid blijft optioneel/uit).

Mockup: `docs/mockups/combatsafety_mockup.html` (openen in browser).

---

## Kerninzicht uit de inspectie

Moderne WoW-API's leveren de "moeilijke data" gratis — geen database bijhouden:

| Wat we willen weten | API (verifiëren vóór encoderen) |
|---|---|
| Is deze cast belangrijk/gevaarlijk? | `C_Spell.IsSpellImportant(spellID)` |
| Is die cast op MIJ gericht? | `PlayerIsSpellTarget(unit, "player")` |
| Doelnaam/-klasse van de cast | `UnitSpellTargetName(unit)` / `UnitSpellTargetClass(unit)` |
| Cast-info + resterende tijd | `UnitCastingInfo` / `UnitChannelInfo` |
| Gescript grondeffect (Blizzard speelt geluid) | `C_UnitAuras.AddPrivateAuraAppliedSound{…}` + `AuraIsPrivate(spellID)` |

> **Never-lie:** bovenstaande API-namen komen uit de TargetedSpells/GTFO-code, maar zijn
> nog niet zelf in-game gedumpt. Vóór encoderen 1× verifiëren (macro/`/dump` of
> warcraft.wiki.gg). Rob's `/reload` = finale check.

**Bewust NIET overnemen:** GTFO's ~6.500-entry spell-database (32 files, per expansion).
Onhoudbaar en tegen never-lie. We leunen op Blizzard-API + een generieke tick-detector.

---

## Feature A — "Gevaarlijke cast op JOU"  · complexiteit: LAAG

**Gedrag:** een vijand start een cast die (1) `IsSpellImportant` is én (2) op de speler
gericht is → toon een icoon met rode gloed, spellnaam, "gericht op JOU", en een
aftel-swipe tot inslag. Bij inslag/eind: korte "MOVE!"-flits (optioneel).

**Techniek:**
- Events: `UNIT_SPELLCAST_START`, `_CHANNEL_START`, `_STOP`, `_INTERRUPTED`,
  `NAME_PLATE_UNIT_ADDED/REMOVED` (bron-units zijn `nameplateN`).
- Detectie per nameplate-cast: `IsSpellImportant(spellID)` en `PlayerIsSpellTarget(unit,"player")`.
- Aftellen via de cast-duration (engine-cooldown, niet handmatig OnUpdate — zie TargetedSpells).
- **CVar-afhankelijkheid:** off-screen casters geven pas cast-info met
  `nameplateShowOffscreen=1`. TargetedSpells zet dit zelf. → Beslissen: overnemen (met
  nette opt-out) of alleen on-screen casts tonen. Voorstel: **alleen aanzetten als de
  gebruiker de feature aanzet**, met uitleg in de tooltip.
- UI: hergebruik het patroon van de Missing-Buff-reminder (versleepbaar niet-secure frame,
  positie in `MidnightHelperDB`). Geen secure knop nodig — dit is puur informatief.

**Open beslissingen:** interruptbaar-kleur (groen/rood) tonen? Meerdere gelijktijdige
casts stacken of alleen de gevaarlijkste?

## Feature B — "Je staat in de stront" (GTFO-light)  · complexiteit: MIDDEN

**Gedrag:** je neemt herhaald schade uit een grondeffect → grote "MOVE!"-flits (en/of
icoon) tot je eruit stapt.

**Techniek — twee sporen die elkaar aanvullen:**
1. **Private auras (Blizzard-native):** registreer per instance/encounter de relevante
   spell-ID's met `AddPrivateAuraAppliedSound`; Blizzard speelt zelf het geluid.
   - Voordeel: dekt gescripte boss/delve-mechanics exact, geen combat-log-werk.
   - Nadeel: werkt alléén voor spells die Blizzard als private aura markeert; en het is
     puur geluid (Rob koos geen geluid → **standaard uit**, wel als optie). Vergt tóch
     een kleine per-content-lijst → alleen doen als het onderhoud licht blijft.
2. **Generieke tick-detector (geen lijst):** luister op `COMBAT_LOG_EVENT_UNFILTERED`,
   filter `destGUID == UnitGUID("player")` + `SPELL_PERIODIC_DAMAGE`/`SPELL_DAMAGE`.
   Als dezelfde `spellID` **≥3× binnen 2s** op mij tikt → "ik blijf in een effect staan"
   → visuele "MOVE!"-cue. Dooft zodra de ticks stoppen.
   - Voordeel: **geen database**, self-scaling.
   - Tuning: tick-drempel, tijdvenster, en HP%-drempel (zie hieronder).

**Ruisonderdrukking (uit GTFO):**
- **HP%-drempel:** alleen alarmeren als `damage / UnitHealthMax("player") ≥ X%`
  (default ~2%) → geen vals alarm bij verwaarloosbare tikjes; schaalt met gear/level.
- **Throttle:** globale cooldown (bv. 1× per 1–2s) tegen spam-flikkeren.

---

## Gedeeld: gating, settings, thema

- **Context-gating (uit TargetedSpells):** aan/uit per content-type — voorstel default
  **aan in Delve + dungeon + raid**, **uit in de open wereld** (anders constant ruis).
  Via `IsInInstance()` / `GetInstanceInfo()`.
- **Settings:** losse toggles onder een nieuw kopje "Combat Safety" op de Settings-pagina
  (zelfde `AddToggle`-patroon als `SET_MBUFF_*`): Feature A aan/uit, Feature B aan/uit,
  "MOVE!"-tekst aan/uit, geluid aan/uit (default uit), HP%-slider.
- **Thema:** goud/rood, consistent met de rest; versleepbare frames met opgeslagen positie.
- **Nieuwe module:** `Modules/CombatSafety.lua` (+ data-loze; evt. `CombatSafetyData.lua`
  alleen als we tóch een mini private-aura-lijst per delve willen). Registreren in `.toc`.
- **Locale:** `CS_*`-keys in `enUS.lua` + `nlNL.lua`; settings-strings in `SettingsPage.lua`;
  vertalingen via `Translations2026.lua` voor de/fr/es/pt/it.

---

## Voorstel bouw-volgorde

1. **Feature A** (laag, grootste "wauw", meteen bruikbaar in elke Delve). In-game test Rob.
2. Bevalt A → **Feature B, spoor 2** (generieke tick-detector + HP% + throttle).
3. Optioneel later: **Feature B, spoor 1** (private-aura-geluid) als we een lichte
   per-content-lijst acceptabel vinden.
4. Pas als Rob "af" zegt: versie-bump + changelog + CF (Beta eerst, Cisca-test).

## Te verifiëren vóór encoderen (never-lie)
- Bestaan + gedrag van `C_Spell.IsSpellImportant`, `PlayerIsSpellTarget`,
  `UnitSpellTargetName`, `C_UnitAuras.AddPrivateAuraAppliedSound`, `AuraIsPrivate` op
  12.0.7 (dump in-game / wiki).
- Of `nameplateShowOffscreen` echt nodig is voor de cast-cue, en hoe we dat netjes
  opt-in maken.
- Tick-drempels (3×/2s) en HP%-default in de praktijk (Delve-test).
