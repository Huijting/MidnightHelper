# 12.1 API-audit — de volledige diff tegen de code

> 🔴 **GEMETEN OP LIVE 12.1, 13 aug 2026 — DE HOOFDCLAIM VAN DIT DOCUMENT IS FOUT.**
>
> `/mh api12` op Robs eigen client, interface 120100:
>
>     GetWeaponEnchantInfo                        = function
>     C_PaperDollInfo.GetTemporaryEnchantmentInfo = function
>
> **`GetWeaponEnchantInfo` is niet verwijderd.** Hij bestaat gewoon. Er is dus geen
> stille bug, geen Shaman die te horen krijgt dat zijn wapen kaal is, en geen reden om
> `MissingBuff.lua` en `ConsumableReadyCheck.lua` aan te raken. De migratie
> (`WeaponEnchant.lua`) is daarom **niet** ingebracht.
>
> De nieuwe call bestaat wél, dus dat deel van de diff klopt — 12.1 heeft hem
> toegevoegd, niet de oude vervangen. Migreren mag ooit, maar dan als keuze en niet als
> reparatie: `GetTemporaryEnchantmentInfo` werkt per slot en heeft dus andere semantiek,
> en dat soort verandering hoort niet in MissingBuff, waar een verkeerd antwoord een
> valse beschuldiging is.
>
> ⚠️ **Lees de rest van dit document met die uitslag in gedachten.** De methode
> (Ketho-diff) is goed en de andere bevindingen zijn plausibel, maar dit was de enige
> die als dringend werd gebracht én de enige die gecontroleerd is — en hij hield geen
> stand. Wat hieronder staat is een kandidatenlijst tot de client iets anders zegt.
> Deze addon kreeg er dit weekend al vier die niet klopten: Valeera's poisons,
> Theremis' coords, DBM's Kroluk-placeholder en HandyNotes' quest-band.

**13 aug 2026.** Rob vroeg om de 143 nieuwe globals systematisch tegen de 196
modules te leggen in plaats van steekproefsgewijs. Dit is het resultaat, en het is
niet uit een changelog overgeschreven: de lijsten komen uit
`Ketho/BlizzardInterfaceResources`, tag `12.0.7` tegen tag `12.1.0`, en de
signatures uit Blizzards eigen gegenereerde docs in `Gethe/wow-ui-source` op 12.1.0.

    GlobalAPI        19 verwijderd   143 toegevoegd
    ScriptObjectAPI   0 verwijderd     6 toegevoegd
    Events            2 verwijderd    43 toegevoegd

## ~~Wat MH raakt — één ding, en het maakte geen geluid~~ WEERLEGD

~~Van de 19 verwijderde globals roept MH er precies **één** aan: `GetWeaponEnchantInfo`.~~

De client zegt van niet (zie boven). De redenering eronder blijft wél de moeite waard,
want hij beschrijft een echt gevaar: MH roept die functie op drie plekken aan, alle drie
achter `if GetWeaponEnchantInfo then`, en `MissingBuff.WeaponEnchant()` geeft
`false, false` als hij ontbreekt. Zou hij ooit écht verdwijnen, dan is dat geen stilte
maar een stellige bewering dat je wapen kaal is.

⏭️ **Dus dit is wat er dan moet gebeuren, en pas dan:** de drie aanroepen achter één deur
zetten met drie antwoorden (`niet te lezen` / `leeg` / `wel`), waarbij "niet te lezen"
zwijgt in plaats van beschuldigt. Dat ontwerp staat al uitgeschreven in
`WeaponEnchant.lua` in Robs Downloads; het wacht op een aanleiding die er nu niet is.

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
