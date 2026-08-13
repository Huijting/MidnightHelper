# 12.1 API-audit — de volledige diff tegen de code

> ⚠️ **NOG NIET TEGEN DE CLIENT GEMETEN, 13 aug 2026.** Dit document komt uit een
> chat-sessie die de Ketho-diff las; het is dus een kandidatenlijst, geen meting — en
> deze addon heeft er al vier keer een gehad die niet klopte (Valeera's poisons,
> Theremis' coords, DBM's Kroluk-placeholder, HandyNotes' quest-band).
>
> **De load-bearing claim is dat `GetWeaponEnchantInfo` verwijderd is.** Het bewijs op
> deze machine wijst de andere kant op: niets roept `C_PaperDollInfo.GetTemporaryEnchantmentInfo`
> aan, terwijl Details — bijgewerkt voor 12.1 op 12 aug — `GetWeaponEnchantInfo` nog
> gewoon gebruikt, in `ThingsToMantain_Midnight.lua`.
>
> `/mh api12` vraagt nu allebei de namen aan de client. **De migratie
> (`WeaponEnchant.lua`) wacht op die uitslag** — hij ligt klaar in Robs Downloads en is
> bewust niet ingebracht, want migreren op een onbevestigde premisse is precies hoe je
> een werkende functie vervangt door een die niet bestaat.

**13 aug 2026.** Rob vroeg om de 143 nieuwe globals systematisch tegen de 196
modules te leggen in plaats van steekproefsgewijs. Dit is het resultaat, en het is
niet uit een changelog overgeschreven: de lijsten komen uit
`Ketho/BlizzardInterfaceResources`, tag `12.0.7` tegen tag `12.1.0`, en de
signatures uit Blizzards eigen gegenereerde docs in `Gethe/wow-ui-source` op 12.1.0.

    GlobalAPI        19 verwijderd   143 toegevoegd
    ScriptObjectAPI   0 verwijderd     6 toegevoegd
    Events            2 verwijderd    43 toegevoegd

## Wat MH raakt — één ding, en het maakte geen geluid

Van de 19 verwijderde globals roept MH er precies **één** aan: `GetWeaponEnchantInfo`,
in `MissingBuff.lua` en tweemaal in `ConsumableReadyCheck.lua`. Alle drie stonden
achter `if GetWeaponEnchantInfo then`, dus er komt geen foutmelding — de addon zou
iedereen stil zijn gaan vertellen dat zijn wapen kaal is. Gemigreerd naar
`Modules/WeaponEnchant.lua` (`C_PaperDollInfo.GetTemporaryEnchantmentInfo`, per slot,
met de oude call als terugval voor 12.0.7-clients).

`C_SuperTrack.GetNextWaypointForMap` staat ook in de verwijderd-lijst, maar alleen
in een MH-commentaar. **En dat commentaar had een open vraag die nu beantwoord is:**
verhuist de hele namespace of één functie? Eén functie. `C_Navigation` heeft er zeven,
`C_SuperTrack` houdt er twintig, en de drie die MH op zestien plekken gebruikt staan
er alle drie nog. NativeArrow is veilig — gemeten, niet aangenomen.

Verder nul treffers op de andere 17, en de vier gewijzigde signatures die MH zou
kunnen raken (`SendMacroPing`, `ForceUpdateAction`, `GetSpellTexture`, `PlaySound`)
zijn allemaal additief of niet in gebruik.

## Nieuw en direct bruikbaar (namespaces die MH al gebruikt, aanroepen: 0)

- `C_CVar.AreCVarsLoaded`
- `C_DelvesUI.GetFlavorNodeForCompanion`
- `C_DelvesUI.GetFlavorNodeNameForCompanion`
- `C_DelvesUI.HasActiveLFGLair`
- `C_DelvesUI.HasActiveLair`
- `C_DelvesUI.IsInLair`
- `C_Item.DoesItemMatchSpellItemCondition`
- `C_PetJournal.GetPetInfoTableBySpeciesID`
- `C_SpecializationInfo.GetInspectSpecialization`
- `C_Spell.GetLastCategoryCooldownSource`
- `C_Spell.GetSpellDescriptionForItemLocation`
- `C_Spell.TargetSpellChecksItemCondition`
- `C_UnitAuras.AddAuraSound`
- `C_UnitAuras.CancelAuraByInstanceID`
- `C_UnitAuras.GetGroupBuffVisualAlerts`
- `C_UnitAuras.GetHiddenGroupBuffs`
- `C_UnitAuras.RemoveAuraSound`
- `C_UnitAuras.SetGroupBuffVisualAlerts`
- `C_UnitAuras.SetHiddenGroupBuffs`

De drie die er echt toe doen: `C_DelvesUI.IsInLair` / `HasActiveLair` /
`HasActiveLFGLair` (TideboundGrottoCoach detecteert nu niets via API), en
`C_UnitAuras.GetHiddenGroupBuffs` / `SetHiddenGroupBuffs` naast
`C_CooldownViewer.GetGroupBuffItems` — dat is `/mh gbuffs` en MissingBuff, maar dan
met Blizzards eigen lijst in plaats van de onze.

## Verwijderde events

- `BATTLETAG_INVITE_SHOW` — geen treffers in MH
- `HOUSING_LAYOUT_NUM_FLOORS_CHANGED` — geen treffers in MH

## Zelf herhalen bij 12.1.5

    git clone --filter=blob:none --no-checkout https://github.com/Ketho/BlizzardInterfaceResources.git
    git show 12.0.7:Resources/GlobalAPI.lua  /  git show 12.1.0:Resources/GlobalAPI.lua

Diff de twee lijsten, grep elke verwijderde naam over de addon. Kost tien minuten en
vervangt het lezen van een samenvatting die de Deprecated-sectie kan afkappen — wat
op 19 juli precies gebeurde.
