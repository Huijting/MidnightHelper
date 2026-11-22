# Talents-knop en "action blocked" op MultiBarBottomRight (Forever 1.60.1.71037, 22 nov 2026)

Fout (GEMETEN, Robs BugGrabber, sessie 335, 1x): `AddOn 'MidnightHelper' tried to call the protected function
'MultiBarBottomRight:SetPointBase()'`, vanuit PetActionBar Update > UpdateVisibility > UpdateBottomActionBarPositions.
Rob: geklikt op Talents sinds de reload, en hij ging in gevecht. Nadoen lukte daarna niet (*"allebei nee en reload gedaan"*).

**Uitslag: ja, de knop kán dit veroorzaken, de code past precies op de fout. Dat hij het hier deed is AFGELEID.**

## De keten (elke stap gelezen in Blizzards Forever-bron, Gethe-spiegel branch forever)

1. `ns.ForeverOpenTalents` roept vanuit addoncode `PlayerSpellsUtil.ToggleClassTalentFrame` aan → `TrySetTab` (schrijft
   het tabblad) → `ShowUIPanel`.
2. `PlayerSpellsFrame:OnShow` leest dat tabblad (`UpdateTabs`) en roept daarna `MultiActionBar_ShowAllGrids` aan. Dat de
   besmetting hier meegaat is AFGELEID (zo werkt taint: lezen van een waarde die een addon schreef).
3. `SetShowGrid` → `UpdateVisibility` → `EditModeManagerFrame:UpdateBottomActionBarPositions`. Buiten gevecht mag dat.
   In Forever is `ACTION_BARS_RELATIVE_TO_BASE_POSITIONING = true`: de balken hangen aan MainActionBar, dus
   `SetPointOverride` schrijft `bar.snappedToFrame`, nu besmet. Dat blijft tot een /reload.
4. In gevecht verandert de petbalk → dezelfde functie, schoon gestart: `ClearAllPointsBase` mag nog, daarna leest
   `ClearFrameSnap` `self.snappedToFrame` → besmet → de eerstvolgende beschermde aanroep is `SetPointBase` → geblokkeerd.
   Dat verklaart waarom juist SetPointBase in de fout staat en niet ClearAllPointsBase.

Er is dus meer nodig dan een klik: later, in gevecht, moet de petbalk de balken opnieuw plaatsen. Een proef zonder die
verandering bewijst niets.

## Wat het niet bewijst

- MH heeft meer wegen naar die balken (indeling overzetten, toetsenblok, `SetActionBarToggles`), alle na een klik. Niet
  uitgesloten. Robs taint.log (09:20-09:21) heeft geen blocked-regel.
- CharacterForever kreeg 9 nov dezelfde fout (3x, zelfde stack). Zijn eigen commentaar (Navigation.lua:63-70,
  Embedded.lua:612-615) beschrijft dit probleem bij het talentvenster; hij klikt nu Blizzards eigen micro-knop.

## Reikwijdte

- v5.7.0 (GEMETEN, git grep op de tag): dezelfde functie, via de knop bij de talentregel in het overzicht.
- main sinds c4223dc: ook de knop in Do this now, dus vaker geklikt.

## Opties (Rob kiest via sparring; nog niets veranderd)

- **A (advies nu):** knop weg op beide plekken; de gouden regel blijft en zegt met welke toets Talents opengaat
  (`GetBindingKey("TOGGLETALENTS")`). MH raakt het venster dan niet meer aan. Klein; nieuwe tekst in 7 talen.
- **B:** een beveiligde knop die Blizzards eigen talentknop aanklikt. Houdt één klik, maar mag in gevecht niet bewegen of
  verbergen en moet los van het venster hangen. Meer werk, en eerst in het spel bewijzen.
- **C:** laten. De fout kan dan terugkomen; een /reload haalt hem weg.
