# Plan: live voorbeeld bij de instellingen (3 nov 2026)

Rob, 3 nov 2026, na een screenshot van MF Nameplates 1.2.5 (Designer: links onderwerpen, midden een live naamplaatje,
rechts de instellingen van het aangeklikte stuk, onderaan knoppen als *Target / Casting / Kick ready* die een toestand
nadoen): *"Yeah, maak maar een plan"*. 🔴 MF heeft geen open licentie: alleen ideeën, eigen code.

**Stand:** stap 1 en 2 gebouwd op 3 nov (Rob: *"Stap 1 en 2"*), niet in het spel getest (testlijst "3 nov (3)").
De koppeling is nagelopen in de code: 17 instellingen, 9 tests. Stap 3 en de losse dingen wachten.

## Waarom niet gewoon MF's opbouw

MF heeft één ding om te laten zien (een naamplaatje), dus één groot voorbeeld in het midden past. MH's instellingen gaan
over tientallen losse dingen op verschillende plekken: een pijl in de wereld, een icoon midden op het scherm, een melding
bovenaan, een paneel naast je groep. Eén canvas in het midden zou die allemaal moeten nabouwen, en een nagebouwd
voorbeeld dat anders is dan het echte ding is erger dan geen voorbeeld (regel in CLAUDE.md: *"de test moet door dezelfde
deur als het spel"*). Dus: **het echte ding laten zien, op zijn echte plek**.

## Wat er al is (GEMETEN 3 nov in de code)

MH heeft al testfuncties die het echte ding tonen, maar alleen via `/mh`-commando's of losse knoppen elders:

| test | wat hij laat zien |
|---|---|
| `ns.PreviewNativeArrow(sec)` (NativeArrow.lua:875) | de route-pijl, N seconden; de pijl-grootte doet dit al vanzelf |
| `ns.TestCombatSafety()` (CombatSafety.lua:709) | waarschuwings-icoon + balken, aan/uit, sleepbaar |
| `ns.PreviewActionPromptSound()` (ActionPrompt.lua:364) | het geluid van de actie-melding; de geluidskeuze doet dit al vanzelf |
| `ns.ShowAccessibleAlertTest()` (AccessibleAlerts.lua:117) | de grote melding |
| `ns.TestRareAlert(arg)` (Rares.lua:3279) | de rare-melding + geluid |
| `ns.TestShardCapAlert()` (ShardCapAlert.lua:114) | de shard-limiet-melding |
| `ns.TestRunScorecard()` (RunScorecard.lua:186) | scorecard + melding na een delve |
| `ns.ConsumableReadyTest()` (ConsumableReadyComms.lua:186) | de consumable-check |
| `ns.TestZoneLevelToast()` (ZoneLevelGate.lua:285) | de te-laag-level-melding |
| `ns.TogglePartyTargetsSoloTest()` (PartyTargets.lua:1895) | het party-targets-paneel |
| `ns.RunDispelTest(arg)` (DispelTest.lua:207) | de dispel-melding |
| `ns.PreviewMilestoneToast()` (Milestones.lua:244) | een mijlpaal-melding |

⚠️ Welke test bij welke instelling hoort, is AFGELEID uit de namen. Bij het bouwen per paar in de code nalopen.

## De stappen

### Stap 1 — een "laat zien"-knopje op de regel (aanbevolen eerst)
- In `SettingsDefs.lua` krijgt een instelling een veld `preview = function() … end` dat de bestaande test aanroept.
- *All settings* tekent op zo'n regel een klein oog-knopje (▶/👁 als tekst-icoon, geen emoji). Klik = het echte ding
  verschijnt op zijn echte plek. Tooltip zegt wat je gaat zien.
- Regels zonder test krijgen niets (geen lege knop).
- Ook in de zoekbalk: een instelling met een voorbeeld kan dat als tweede actie hebben (later, als het past).

### Stap 2 — vanzelf laten zien bij veranderen
- Voor dingen die je ziet terwijl je schuift (grootte, schaal, aan/uit van een paneel): na een verandering het voorbeeld
  kort tonen, zoals de pijl-grootte nu al doet (`PreviewNativeArrow(3)`). Alleen waar dat niet stoort.

### Stap 3 — toestanden nadoen (de "Target / Casting"-knoppen van MF), alleen waar het zin heeft
- Bv. bij de waarschuwing voor gevaarlijke casts: "icoon", "icoon + balken", "alleen belangrijke". Pas na stap 1-2
  bekijken of het echt iets toevoegt.

### Klein, los mee te nemen (uit dezelfde screenshot)
- Een voetregel onder *All settings*: *"Ctrl+klik: terug naar aanbevolen · wijzigingen werken meteen"* (MF heeft zo'n regel
  onderaan het voorbeeld; bij ons staat Ctrl+klik nu alleen in de tooltip).
- Een knop **"Dit blok terug naar aanbevolen"** per sectie (MF: *Reset part*). Kan nu: elke instelling kent zijn `rec`.

## Bij elke stap mee
Vertalingen in 8 packs + `locale_probe`, syntax + lint, `docs/TESTLIJST.md`, `NEXT_SESSION.md`, site-hoofdpagina,
changelog-regel bij de volgende versie.
