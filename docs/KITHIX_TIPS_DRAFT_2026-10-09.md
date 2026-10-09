# Kith'ix — bossvenster-tips, CONCEPT (9 okt 2026)

> Niets hiervan zit in de addon. Geen bestand in `Locales/` of `Modules/` aangeraakt, niets gecommit.
> Enige bron: `docs/PATCH_12_1_5_TACTICS_DRAFT_2026-10-08.md` §2 (plus één eigen blik in DBM, zie onder).
> Vorm en sleutels kopiëren `RAID_BOSS_ULATEK_*` in `Locales/RaidTips.lua`.

## Hoe stevig is elke regel?

Labels zoals in het concept: **W** = DB2 70077, **DBM** = `Kithix.lua`, **WGE-K** = één gids (worstguidesever, 4 okt).

> ⚠️ **9 okt, bij het inbouwen:** lint-check [19] vond dat DBM **1303257 (Suffocation), 1304046 (Overwhelming Fear) en
> 1304040 (Mindsting)** alleen als *aura* kent, niet als waarschuwing. Die drie staan in de addon daarom als gewone
> naam zonder link. "STEVIG" hieronder betekende "staat in DBM", niet "DBM waarschuwt ervoor".

### STEVIG — mechaniek in DB2 én in de DBM-module (alleen deze krijgen een `{SPELL:id}`-link)

| spell | ID | gebruikt in |
|---|---|---|
| Voidswarm | 1301511 | STEPS |
| Suffocating Darkness | 1302951 | STEPS, HEALER |
| Suffocation | 1303257 | STEPS |
| Extinguish | 1304424 | STEPS, HEALER |
| Abyssal Grasp | 1303406 | HEALER (⚠️ DBM gebruikt dit ID voor Divine Radiance, zie nameetlijst) |
| Unspeakable Horrors → Overwhelming Fear | 1304045 → 1304046 | STEPS, HEALER |
| Twisted Appendage | 1303681 | STEPS |
| Dark Devastation | 1304930 | TANK |
| Mindsting | 1304040 | STEPS (Heroic/Mythic) |
| Eightfold Eclipse | 1301479 | STEPS |
| Null Gate | 1308873 | STEPS, TANK |
| Negation | 1318467 | TANK |

Ook stevig (W): de getallen — Light's Embrace −90% / Mythic −80%, 8 s; Divine Radiance-stun 8 s; Exhausted +10% per stapel;
Devastated 25 s; Abyssal Grasp 9 s (Heroic 8 s); Nullify dodelijk bij 6 (Normal), 5 (Heroic), 3 (Mythic); fase 2 op 25%;
Bomber Beetle ontploft na 30 s of bij aanraking; Null Gate-markering 5 s; Negation 8 s (Mythic 12 s, stapelt).

### MIDDEL — mechaniek alleen in DB2 (W), niet in DBM → in de tekst als **naam zonder link**

Refulgent Bulwark (1302952), Light's Embrace (1304508/1304526), Divine Radiance (1303169), Exhausted (1307662),
Commanding Presence (1305008), Bomber Beetle / Fixate (1302295) / Gut Reaction (1302117) / Digestive Juices (1302319),
Venomous Hulk (Venom Roar 1302884), Voidscar (1304950), Incubation/Mindstingers (1307407), Eclipse Fragments (1308674),
Lost Refulgence (1308675), Stygian Howl (1301110), Last Light (1305427), Luminous Grace (1305428), Nullify (1308875),
Nullshards (1308881), Explosive Restabilization (1318472).
De meeste *tips* daarbij zijn AFGELEID uit de mechaniek (concept: "de tip achter een mechaniek is meestal AFGELEID").

### ZWAK — alleen één gids (WGE-K) of eigen afleiding

1. **"Dispel Overwhelming Fear alleen op spelers die ver weg staan"** — WGE-K. (HEALER)
2. **"Bloodlust in fase 2"** — WGE-K; burst-moment zelf AFGELEID. (DPS)
3. **"Wissel af met fragmenten vangen"** — WGE-K, AFGELEID. (DPS)
4. **"Andere tank taunt bij Negation"** — AFGELEID, WGE-K zegt hetzelfde. (TANK, QUICK_TANK)
5. **"Gemarkeerd door Null Gate: loop weg van de anderen"** — AFGELEID, WGE-K zegt hetzelfde. (STEPS, QUICK)
6. **"Burn in de 8 s stun na Divine Radiance"** — AFGELEID (stun zelf is W). (STEPS, DPS, QUICK_DPS)
7. **"Laat bombers niet vlak na elkaar knallen"** — journaaltekst zegt "heavy damage" bij snel na elkaar; de tip is een kleine afleiding. (STEPS, HEALER, QUICK)

Bewust **weggelaten**: "interrupt de Voidweaver" (WGE-K; geen interrupt-vlag in het journaal, concept zegt: niet zonder test),
en de Commanding Presence-waarde op Normal/Heroic (geen eigen DB2-rij; tekst zegt alleen "far less", met "up to 90% on Mythic").

## Op patchdag nameten (13/14 okt)

1. **DBM-module laadt?** `DBM-Lairs-Midnight\UnbindingofKithix\Kithix.lua` — regel 1 is `if DBM:GetTOC() < 120105 then return end`.
   Zelf gelezen 9 okt: `NewMod(2896, …, 1324)`, `SetCreatureID(267861)`, `SetEncounterID(3513)`. Op 12.1.5 kijken of hij laadt
   en of er een nieuwere revisie is (deze is 14 sep).
2. **Alle 13 gelinkte ID's** hierboven: renderen de `{SPELL:id}`-links op de 12.1.5-client met de juiste naam?
3. **1303406**: DB2 = Abyssal Grasp, maar DBM hangt er Divine Radiance-waarschuwingen aan. Toont de link "Abyssal Grasp"?
4. **1304434** (DBM "verify ID", algemene Fixate) — niet gebruikt; journaal zegt 1302295 voor de Bomber Beetle.
5. **NPC 259664 (BigWigs) of 267861 (DBM)** — alleen nodig voor een 3D-model / `seedCreatureId`.
6. **Nullify-stapels** (6/5/3) — mythic-store.com zei "4"; DB2 per difficulty is de bron, maar in het spel zien.
7. **Voidscar / Eclipse Fragments: Heroic + Mythic** (journaal) of alleen Mythic (WGE-K)?
8. **De zwakke tips 1–7** hierboven tegen DBM's waarschuwingen en een tweede gids leggen.

## Waar het moet komen

**Locale-tekst** — `Locales/RaidTips.lua`:
- **enUS**: in het `merge(ns._mhLocales and ns._mhLocales.enUS, { … })`-blok, direct ná `RAID_BOSS_ULATEK_DPS` (nu regel 100).
- **nlNL**: in het `merge(ns._mhLocales and ns._mhLocales.nlNL, { … })`-blok, direct ná `RAID_BOSS_ULATEK_DPS` (nu regel 414).
- De andere vijf talen staan in **hetzelfde bestand** (eigen `merge`-blokken), niet in `Translations2026.lua`. Zonder die blokken valt `ns:L` terug op enUS.

**Code** (buiten deze opdracht, alleen ter info — niet aangeraakt):
- `Modules/RaidCoachData.lua`, tabel `TIPS` (r. 113–172): één regel erbij, na `ulatek`:
  `kithix = { steps = "RAID_BOSS_KITHIX_STEPS", tank = "RAID_BOSS_KITHIX_TANK", healer = "RAID_BOSS_KITHIX_HEALER", dps = "RAID_BOSS_KITHIX_DPS" },`
  De QUICK-sleutels worden automatisch gevonden via het patroon `^(RAID_BOSS_[A-Z]+)_STEPS$` (r. 185) — `KITHIX` past daarin.
- Daar ontbreekt ook nog een **raid-blok** voor The Unbinding of Kith'ix (journalInstanceID **1324**, boss `encounterID = 2896` volgens
  dezelfde conventie als de andere raids = DBM's `NewMod`-eerste-argument). Niet geschreven: dat is code.
- ⚠️ Krijgt dat raid-blok `season = 2`, dan zet `Modules/RaidGuide.lua:67` er `RAID_PRERELEASE_NOTE` boven ("Rewritten on 15 Sep from DBM's
  current encounter mods…"). Dat klopt voor Kith'ix niet. Eigen notitie of geen `season = 2` — Rob/bouwchat beslist.

---

## enUS — plak-klaar

```lua
	-- The Unbinding of Kith'ix (12.1.5) — CONCEPT 9 Oct 2026 from DB2 70077 + DBM Kithix.lua; not yet seen in game.
	RAID_BOSS_KITHIX_STEPS = "• |cffffd100Kill the aqir before Kith'ix reaches 100 energy.|r Then {SPELL:1302951} closes in: stand inside Liadrin's Refulgent Bulwark, or {SPELL:1303257} stops you attacking, slows you and hurts you. Aqir still alive go into a frenzy and hit the whole raid.|n• {SPELL:1301511} opens portals that bring the aqir. Pull them away from the boss: near him they take far less damage. Stay out of the Venomous Hulk's frontal cone.|n• Before every {SPELL:1304424}, pick up a Light's Embrace: 90% less Shadow damage for 8 seconds (80% on Mythic). Extinguish removes it.|n• After the darkness, Liadrin's Divine Radiance stuns Kith'ix for 8 seconds: burn him. Then she is Exhausted: her Bulwark gets weaker and each next {SPELL:1302951} hits 10% harder, so a long phase 1 gets heavier.|n• {SPELL:1304045}: after 6 seconds you are feared ({SPELL:1304046}). When it ends or is dispelled you scream, and the farther away others stand, the less it hurts them. Spread out.|n• Bomber Beetles chase a player and blow up after 30 seconds or on touch, hitting everyone. Blasts close together hit hard, so never let two go off right after each other. Dodge {SPELL:1303681}.|n• Phase 2 at 25%: Stygian Howl stuns the raid, Kith'ix eats his own adds and starts {SPELL:1301479}. After the last eclipse the whole raid dies, so it is a race. Liadrin's Last Light heals everyone to full and raises your damage and healing until the end.|n• {SPELL:1308873} marks a player for 5 seconds, then a gate opens where they stand. Marked? Move away from the others. Gates and their Nullshards give Nullify stacks; too many kill you (6 on Normal, 5 on Heroic, 3 on Mythic).|n• On Heroic and Mythic: dead aqir release Mindstingers that stun a player ({SPELL:1304040}). Dark Devastation leaves a Voidscar that hurts and knocks back on touch. During the darkness these turn into Eclipse Fragments that drift to Liadrin: catch them before they reach her, or the raid is hit and the Bulwark shrinks.",
	RAID_BOSS_KITHIX_QUICK_DPS = "Kill the aqir first, then burn the boss in the 8-second stun and in phase 2.",
	RAID_BOSS_KITHIX_QUICK_HEALER = "Heal off Abyssal Grasp fast, and save cooldowns for Extinguish and the darkness: each one hits harder than the last.",
	RAID_BOSS_KITHIX_QUICK_TANK = "Swap after every Dark Devastation and pull the aqir off the boss; in phase 2, with Negation on you, walk into a Null Gate while the other tank taunts.",
	RAID_BOSS_KITHIX_QUICK = "Darkness: Kill the aqir before the boss's energy is full, then stand in Liadrin's Bulwark. Before Extinguish, pick up a Light's Embrace.|nSpread: Feared, or marked by a Null Gate? Move away from the others. Never let two Bomber Beetles blow up right after each other.|nPhase 2 (25%): Use everything now: after the eighth eclipse the raid dies. Stay off the gates and the shards.",
	RAID_BOSS_KITHIX_TANK = "• {SPELL:1304930} stacks Devastated on you: much more damage taken for 25 seconds. Swap after each one.|n• Pull the aqir away from Kith'ix: near him they take far less damage (up to 90% less on Mythic).|n• Phase 2: when {SPELL:1318467} runs out you die (8 seconds; 12 and stacking on Mythic). Walk into a {SPELL:1308873} gate to clear it; the blast also clears nearby gates and shards. The other tank taunts.",
	RAID_BOSS_KITHIX_HEALER = "• {SPELL:1303406} is a heal absorb: heal it off within 9 seconds (8 on Heroic), or the player is pulled into the darkness.|n• Plan cooldowns for {SPELL:1304424}, which also strips Light's Embrace, and for every {SPELL:1302951}: Liadrin gets Exhausted, so each one hits 10% harder.|n• Every Bomber Beetle blast gives everyone a stack of Digestive Juices, so blasts close together hurt. Dispel {SPELL:1304046} only on players who stand far from the others.",
	RAID_BOSS_KITHIX_DPS = "• Aqir first: every one still alive when the darkness comes goes into a frenzy.|n• Burn windows: the 8-second stun after Divine Radiance, and phase 2 under Luminous Grace. Bloodlust in phase 2.|n• On Heroic and Mythic: catch Eclipse Fragments before they reach Liadrin. Each one you touch stacks a DoT on you, so take turns.",
```

## nlNL — plak-klaar

```lua
	-- The Unbinding of Kith'ix (12.1.5) — CONCEPT 9 okt 2026 uit DB2 70077 + DBM Kithix.lua; nog niet in het spel gezien.
	RAID_BOSS_KITHIX_STEPS = "• |cffffd100Dood de aqir voordat Kith'ix 100 energie heeft.|r Dan sluit {SPELL:1302951} zich: ga in Liadrins Refulgent Bulwark staan, anders kun je door {SPELL:1303257} niet aanvallen, loop je trager en krijg je schade. Aqir die dan nog leven, gaan razen en raken de hele raid.|n• {SPELL:1301511} opent portalen waar de aqir uit komen. Trek ze weg bij de baas: dicht bij hem nemen ze veel minder schade. Blijf uit de frontale kegel van de Venomous Hulk.|n• Pak vóór elke {SPELL:1304424} een Light's Embrace: 90% minder Shadow-schade, 8 seconden lang (80% op Mythic). Extinguish haalt hem weg.|n• Na de duisternis stunt Liadrins Divine Radiance Kith'ix 8 seconden: burn hem dan. Daarna is ze Exhausted: haar Bulwark wordt zwakker en elke volgende {SPELL:1302951} raakt 10% harder, dus een lange fase 1 wordt steeds zwaarder.|n• {SPELL:1304045}: na 6 seconden ben je bang ({SPELL:1304046}). Als het afloopt of wordt gedispeld, schreeuw je, en hoe verder de anderen staan, hoe minder pijn het hun doet. Ga uit elkaar.|n• Bomber Beetles achtervolgen een speler en ontploffen na 30 seconden of bij aanraking; dat raakt iedereen. Vlak na elkaar doen ze veel schade, dus laat er nooit twee kort na elkaar knallen. Ontwijk {SPELL:1303681}.|n• Fase 2 op 25%: Stygian Howl stunt de raid, Kith'ix slokt zijn eigen adds op en begint {SPELL:1301479}. Na de laatste eclips is de hele raid dood, dus het is een race. Liadrins Last Light healt iedereen vol en geeft je tot het eind meer schade en healing.|n• {SPELL:1308873} markeert een speler 5 seconden, daarna gaat er op zijn plek een poort open. Gemarkeerd? Ga weg van de anderen. Poorten en hun Nullshards geven Nullify-stapels; te veel is je dood (6 op Normal, 5 op Heroic, 3 op Mythic).|n• Op Heroic en Mythic: dode aqir laten Mindstingers los die een speler stunnen ({SPELL:1304040}). Dark Devastation laat een Voidscar achter die schade doet en je wegslaat als je hem raakt. Tijdens de duisternis worden die Eclipse Fragments die naar Liadrin drijven: vang ze op voordat ze bij haar zijn, anders wordt de raid geraakt en krimpt de Bulwark.",
	RAID_BOSS_KITHIX_QUICK_DPS = "Dood eerst de aqir, en burn de baas in de stun van 8 seconden en in fase 2.",
	RAID_BOSS_KITHIX_QUICK_HEALER = "Heal Abyssal Grasp snel weg, en bewaar cooldowns voor Extinguish en de duisternis: die raakt elke keer harder.",
	RAID_BOSS_KITHIX_QUICK_TANK = "Wissel na elke Dark Devastation en trek de aqir weg bij de baas; heb je in fase 2 Negation, loop dan een Null Gate in terwijl de andere tank taunt.",
	RAID_BOSS_KITHIX_QUICK = "Duisternis: Dood de aqir voordat de energie van de baas vol is, en ga dan in Liadrins Bulwark staan. Pak vóór Extinguish een Light's Embrace.|nUit elkaar: Bang gemaakt, of gemarkeerd door een Null Gate? Ga weg van de anderen. Laat nooit twee Bomber Beetles kort na elkaar ontploffen.|nFase 2 (25%): Gooi nu alles erin: na de achtste eclips is de raid dood. Blijf van de poorten en de scherven af.",
	RAID_BOSS_KITHIX_TANK = "• {SPELL:1304930} zet Devastated op je: 25 seconden lang veel meer schade. Wissel na elke keer.|n• Trek de aqir weg bij Kith'ix: dicht bij hem nemen ze veel minder schade (tot 90% minder op Mythic).|n• Fase 2: loopt {SPELL:1318467} af, dan ga je dood (8 seconden; op Mythic 12 en stapelend). Loop een {SPELL:1308873}-poort in om hem weg te halen; de ontploffing ruimt ook poorten en scherven in de buurt op. De andere tank taunt.",
	RAID_BOSS_KITHIX_HEALER = "• {SPELL:1303406} is een heal absorb: heal hem binnen 9 seconden weg (8 op Heroic), anders wordt de speler de duisternis in getrokken.|n• Plan cooldowns voor {SPELL:1304424}, die ook Light's Embrace weghaalt, en voor elke {SPELL:1302951}: Liadrin raakt Exhausted, dus elke keer raakt hij 10% harder.|n• Elke ontploffende Bomber Beetle geeft iedereen een stapel Digestive Juices, dus kort na elkaar doet het pijn. Dispel {SPELL:1304046} alleen bij spelers die ver van de anderen staan.",
	RAID_BOSS_KITHIX_DPS = "• Eerst de aqir: elke aqir die nog leeft als de duisternis komt, gaat razen.|n• Burn-momenten: de stun van 8 seconden na Divine Radiance, en fase 2 onder Luminous Grace. Bloodlust in fase 2.|n• Op Heroic en Mythic: vang Eclipse Fragments op voordat ze bij Liadrin zijn. Elk fragment dat je raakt geeft je een stapelende DoT, dus wissel af.",
```

## Telling

8 sleutels × 2 talen = 16 strings (STEPS, QUICK, QUICK_TANK, QUICK_HEALER, QUICK_DPS, TANK, HEALER, DPS).
Markup gecontroleerd: één `|cffffd100…|r`-paar in elke STEPS, `|n` tussen bullets/regels, 13 verschillende `{SPELL:id}`'s, alle uit de STEVIG-tabel.
