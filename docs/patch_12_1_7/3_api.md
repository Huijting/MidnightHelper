# 12.1.7 - addon-techniek: wat kan MH breken of veranderen?

Speuropdracht 3 van 5, gemaakt 15 nov 2026. Alleen gelezen, niets in code veranderd.

## Bronnen (alles vandaag opgehaald)

- **A. Gethe/wow-ui-source**, branch `live` = 12.1.5 (70783, commit 4 nov 2026) tegen branch `ptr` = 12.1.7 (70892,
  commit 12 nov 2026). Twee vergelijkingen:
  - de API-documentatie (`Blizzard_APIDocumentationGenerated`): 156 bestanden anders. Uitvoer van `apidiff.py`
    (eerder vandaag in deze sessie gedraaid): `<scratchpad>/apidiff_out.txt`.
  - alle UI-bestanden (`Interface/`, zonder de API-docs): 1895 bestanden anders. Door mij gedraaid met
    `uisrc_tree_diff.py`: lijst in `<scratchpad>/uisrc_tree_list.txt`, diffs in `<scratchpad>/uisrc_tree_diff.txt`.
- **B. Ketho/BlizzardInterfaceResources**, `live` = 12.1.5 (70448, 22 okt) tegen `ptr` = 12.1.7 (70892, 14 nov):
  lijsten van globale functies, events, CVars, frames, enums. Let op: hun `live` is een oudere 12.1.5-build dan bij A,
  dus een paar verschillen kunnen al in een 12.1.5-hotfix zitten.
- **C. wago.tools DB2** `GlobalStrings`, build 12.1.7.70892 (via `run gamedata`).
- **D. MH-code**, gegrept in `Modules\`, `Core.lua`, `UI.lua`, `Addons\` en de `.toc`. Elke lege grep had in dezelfde
  run een zoekterm die wel raakte (positieve controle).

`<scratchpad>` = `C:\Users\RobHu\AppData\Local\Temp\claude\E--World-of-Warcraft--retail--Interface-AddOns\f5f259a6-b38e-526f-86e4-08d1f38cb4f3\scratchpad`.

## Kort: de vijf punten die ertoe doen

| # | Wat | Risico |
|---|-----|--------|
| 2 | Edit Mode krijgt een 3e preset (Gamepad). Eigen indelingen schuiven een plek op. MH telt goed mee, maar EEN opgeslagen nummer (`keyBlockPresetBack.preset`) telt niet mee. | midden |
| 7 | "Simple Keybinds": nieuwe optie die Ctrl+1, Shift+1 enz. UITzet. Raakt precies wat `/mh apply` en KeyBlock zetten. Waar hij aan staat is niet gemeten. | midden (onzeker) |
| 6 | De vaste bars-string in `BarPreset.lua` is niet getest op 12.1.7 (en ook niet op 12.1.5). | midden |
| 9 | Blizzard ontkoppelt een toets nu met `"NONE"` in plaats van `nil`. MH gebruikt nog `nil`. | laag-midden |
| 5 | Blizzard rekent de plek van de onderste balken anders uit. Kan KeyBlock-blokken iets verschuiven. | laag-midden |

De rest is laag: MH gebruikt geen enkele verdwenen functie, event, frame of CVar (punt 19).

---

## 1. Edit Mode-systeemnummers (bekend, bevestigd)

- **GEMETEN (A, ptr-doc regel 752-783):** `Enum.EditModeSystem` loopt nu tot 31. 26 = MainActionBarEndCap (de
  griffioenen), 27 = GroupFinder (het "oog"), 28 = LossOfControl (was 26), 29 = SwingTimer, 30 = GamepadMainActionBar,
  31 = GamepadInfoHud. Onveranderd: 0 ActionBar, 5 ExtraAbilities, 13 MicroMenu, 14 Bags, 15 StatusTrackingBar,
  20 CooldownViewer.
- **MH (D):** vaste nummers in `Modules\EditModeBackup.lua:257` (0), `:651` (5), `:1382` en `:1385` (20),
  `Modules\BarInventory.lua:377` (0). Die kloppen nog. `EditModeBackup.lua:1245` (13, 14, 26, 15) draait alleen op
  Forever (`ns.IS_FOREVER`), en de opmerking op `:1240-1241` zegt al "opnieuw nakijken als 12.1.7 live gaat".
- **Risico:** laag op retail.
- **Test op de PTR:** `/dump Enum.EditModeSystem.LossOfControl` (verwacht 28) en `/dump Enum.EditModeSystem.CooldownViewer` (verwacht 20).

## 2. Een derde Edit Mode-preset: "Gamepad"

- **GEMETEN (A, `EditModeManagerConstantsDocumentation`):** `Enum.EditModePresetLayouts` heeft nu Modern 0, Classic 1,
  **Gamepad 2**.
- **GEMETEN (A, `Blizzard_EditMode/Shared/EditModePresetLayoutsManager.lua`):** als `EDIT_MODE_GAMEPAD_SYSTEM_MAP`
  bestaat, komt er een derde preset bij. **GEMETEN (A, `Blizzard_EditMode/Mainline/EditModePresetLayouts.lua`):** die
  map wordt op Mainline gemaakt, en die file laadt bij game type `standard` (`Blizzard_EditMode.toc`).
- **AFGELEID:** op retail 12.1.7 geeft `EditModePresetLayoutManager:GetCopyOfPresetLayouts()` dus 3 presets in plaats
  van 2. Blizzards eigen menu telt eerst de presets en dan de eigen indelingen. Een eigen indeling die nu nummer 3 is,
  wordt dan nummer 4.
- **MH (D):** MH telt de presets elke keer opnieuw: `EditModeBackup.lua:294-303` (`PresetCount`), `:874-941`,
  `ForeverLayoutCarry.lua:45-51`, `BarInventory.lua:366-372`. Dat gaat goed.
  **Maar:** `EditModeBackup.lua:947` bewaart `keyBlockPresetBack[spec].preset = active`, een vast nummer van voor de
  patch, en `:1022` zet dat nummer later terug met `C_EditMode.SetActiveLayout(back.preset)` zonder te kijken of
  `presetName` nog klopt. Gaat alleen mis als de bron een gedeelde (account-)indeling was (`:883-889`), want dan is het
  nummer 3 of hoger. Nummer 3 wordt na de patch de Gamepad-preset. De melding op `:1057` noemt dan wel de goede naam.
  `editModeBarsUndo.savedIndex` (`:517`, `:1274`) telt zonder presets en heeft hier geen last van.
- **Risico:** midden, alleen voor spelers die KeyBlock op een account-indeling gebruikten en na de patch "terug" doen.
- **Test op de PTR:** `/dump #EditModePresetLayoutManager:GetCopyOfPresetLayouts()` (verwacht 3). Met een eigen indeling
  actief: `/dump C_EditMode.GetLayouts().activeLayout` en vergelijk met live (verwacht 1 hoger). Kijk of Blizzard bij
  het inloggen dezelfde eigen indeling actief houdt.

## 3. Indelingen krijgen `interfaceStyle`, en een paar Blizzard-functies verhuizen

- **GEMETEN (A, `EditModeManagerDocumentation`):** een indeling heeft een nieuw veld `interfaceStyle`
  (`Enum.InputDeviceInterfaceType`: Mkb 0, Gamepad 1; leeg = muis en toetsenbord). Nieuw: `C_EditMode.GetEditModeDefaultLayout()`.
  `Constants.EditModeLayoutConsts` heet nu `EditModeLayoutConsts_Mainline`.
- **GEMETEN (A, `Shared/EditModeManager.lua`):** `ReconcileWithModern` bestaat nog. `ReconcileLayoutsWithModern` heet nu
  `ReconcileLayouts`. De velden `EditModeManagerFrame.modernSystemMap` en `.modernSystems` zijn weg.
  `EditModeManagerFrame:GetBottomActionBars()` is verhuisd naar `EditModeUtil.GetBottomActionBars()`. Het menu toont
  presets alleen als hun `interfaceStyle` past bij wat je gebruikt.
- **MH (D):** MH roept `EditModeManagerFrame.ReconcileWithModern` aan in `EditModeBackup.lua:535-536`, `:614-615`,
  `:1074-1075`, `:1443-1444`. Die bestaat nog. De verdwenen namen gebruikt MH niet (grep: 0 treffers).
- **AFGELEID:** `ReconcileWithModern` op een gamepad-indeling zou die omzetten naar muis-systemen. Alleen voor
  gamepad-spelers.
- **Risico:** laag.
- **Test op de PTR:** KeyBlock "eigen indeling maken" en daarna "terug": geen Lua-fout, indeling blijft heel.

## 4. Edit Mode-accountinstellingen hernummerd

- **GEMETEN (A):** `Enum.EditModeAccountSetting`: nieuw ShowGroupFinder = 35, ShowLossOfControl 35 -> 36, nieuw
  ShowSwingTimer = 37. `Enum.EditModeMicroMenuSetting.EyeSize` heet nu `DeprecatedEyeSize`.
- **MH (D):** geen gebruik van `Enum.EditModeAccountSetting`, `EyeSize` of accountinstellingen per nummer. MH kijkt
  alleen of `EditModeManagerFrame.accountSettings` bestaat (`EditModeBackup.lua:63`, `BarInventory.lua:319-320`).
- **Risico:** laag.

## 5. De onderste actiebalken worden anders neergezet

- **GEMETEN (A, `Shared/EditModeManager.lua` en `Standard/EditModePresetLayoutConstants.lua`):**
  `UpdateBottomActionBarPositions` is herschreven. Op retail (standard) blijft de hoogte 45 (`MAIN_ACTION_BAR_OFFSET_Y = 45`),
  maar de x-positie komt nu van de breedte van de eerste zichtbare balk. `MAIN_ACTION_BAR_DEFAULT_OFFSET_Y` en
  `BOTTOM_ACTION_BARS_INITIAL_OFFSET_Y` bestaan niet meer.
- **MH (D):** MH gebruikt die globals niet (grep: 0). MH zet balken via indelingen met eigen ankers
  (`EditModeBackup.lua:648`, `KeyBlock.lua:917`).
- **AFGELEID:** balken die op "standaardpositie" staan kunnen een paar pixels verschuiven. Balken die KeyBlock zelf
  verankert niet.
- **Risico:** laag-midden.
- **Test op de PTR:** KeyBlock-indeling toepassen, screenshot naast dezelfde op live.

## 6. De vaste bars-string in BarPreset

- **GEMETEN (D):** `Modules\BarPreset.lua:76` zegt `validOn = { 120100, 120007 }`. Op 120105 (12.1.5) en 120107 (12.1.7)
  geeft MH dus al de waarschuwing "niet getest op deze patch". De string (`:47-53`) verwijst naar systeem 0 en balknamen.
- **AFGELEID:** of Blizzards indeling-string op 12.1.7 nog versie `2` is, is niet gemeten. Er zijn wel systemen bij
  gekomen (punt 1) en een veld (punt 3).
- **Risico:** midden (een functie die waarschuwt, of in het slechtste geval niet goed leest).
- **Test op de PTR:** zelfde Hunter-indeling exporteren, byte voor byte vergelijken met `PRESET_1207`. Gelijk, dan 120105
  en 120107 aan `validOn` toevoegen.

## 7. "Simple Keybinds" (nieuw) - raakt Ctrl/Shift/Alt-toetsen

- **GEMETEN (B, CVars):** nieuwe CVar `simpleKeybinds`, standaard 0: "Allow Shift, Ctrl, and Alt to be bound as
  standalone keys. Only available if the associated game rule is active."
- **GEMETEN (C, GlobalStrings 12.1.7.70892):**
  - 60097 `SETTINGS_SIMPLE_KEYBINDS` = "Simple Keybinds"
  - 60098 `SETTINGS_SIMPLE_KEYBINDS_TOOLTIP` = "Disables modifier keybinds like Ctrl+1, but allows binding Ctrl, Shift,
    and Alt as standalone keys. Warning: Keybinding some modifiers can conflict with core functionality."
  - 60099 `SETTINGS_SIMPLE_KEYBIND_WARNING` = "Binding to this key will conflict with certain UI actions like interacting
    with share links in chat."
- **GEMETEN (A):** het vinkje staat alleen in Instellingen -> Toetsen als `C_GameRules.IsGameRuleActive(Enum.GameRule.AllowSimpleKeybindOption)`
  waar is (regel 230; `Blizzard_SettingsDefinitions_Frame/Keybindings.lua:324-326`). Met het vinkje aan mag je Shift,
  Ctrl of Alt los vastleggen (`Blizzard_Settings_Shared/Blizzard_Keybindings.lua:95`) en toont Blizzard een waarschuwing.
  Verder komt de CVar alleen voor in `Blizzard_GameTooltip/WoWHack/` (Talebound).
- **Wat het precies doet (GEMETEN, Blizzards eigen tekst):** combinaties zoals Ctrl+1 werken dan NIET meer; Ctrl, Shift
  en Alt worden losse toetsen. Hoe de client dat uitvoert zit niet in de Lua (AFGELEID: in de client zelf).
- **MH (D):** KeyBlock zet 38 combinaties zoals `ALT-1` en `SHIFT-1` (`Modules\KeyBlock.lua:28-39`); `/mh apply` zet
  "Shift+1" om naar `SHIFT-1` (`Modules\ApplyLayout.lua:256`). MH kent de CVar niet (grep `simpleKeybinds`: 0).
- **NIET GEMETEN:** in welke spelmodus de game rule aan staat. Omdat het enige andere gebruik in een WoWHack-map zit,
  is Talebound het meest waarschijnlijk (AFGELEID). Daar laadt MH niet (punt 22).
- **Risico:** laag als het alleen Talebound is; hoog als het ook in gewoon retail aan kan. Daarom: midden (onzeker).
- **Test op de PTR:** op een gewone retail-char: `/dump C_GameRules.IsGameRuleActive(Enum.GameRule.AllowSimpleKeybindOption)`
  en `/dump GetCVar("simpleKeybinds")`, en kijk of "Simple Keybinds" in Instellingen -> Toetsen staat. Staat hij er,
  zet hem aan en druk een MH-toets als Shift+1.
- **Idee (spelers kiezen):** als de CVar aan staat, laat `/mh apply` en KeyBlock dat zeggen voordat ze combinaties zetten.

## 8. Account-toetsen kunnen uit staan per spelmodus

- **GEMETEN (A):** nieuw `C_GameRules.IsAccountKeyBindingsEnabled()`. Is die onwaar, dan zet Blizzard de toetsen altijd
  op "alleen dit karakter" en verbergt het vinkje (`Blizzard_SettingsDefinitions_Frame/Keybindings.lua:288`,
  `Blizzard_QuickKeybind/QuickKeybind.lua:124`). Nieuwe game rule `ContentSetAccountKeyBindings` = 210 (B, LuaEnum).
- **MH (D):** MH slaat op met `SaveBindings(GetCurrentBindingSet())`: `ApplyLayout.lua:1225`, `:1325`, `:1698`;
  `KeyBlock.lua:1245`, `:1330`, `:1540`; `BarEightKeys.lua:348`. `KeybindSchema.lua:584-605` leest de set. MH schrijft
  dus altijd naar de set die actief is.
- **Risico:** laag.

## 9. Toets ontkoppelen: Blizzard gebruikt nu "NONE"

- **GEMETEN (A, `Blizzard_Settings_Shared/Blizzard_Keybindings.lua`):** op live ontkoppelt het toetsenscherm met
  `SetBinding(key, nil, context)`; op de PTR met `SetBinding(key, "NONE", context)`, en het kijkt of dat lukte.
- **GEMETEN (B, GlobalAPI):** `SetBinding` en `SaveBindings` zijn niet verdwenen. Ze staan niet in de API-docs, dus
  hun precieze gedrag is daar niet te meten.
- **MH (D):** MH ontkoppelt met `SetBinding(key)` (zonder opdracht) in `ApplyLayout.lua:1274` en `KeyBlock.lua:1283`.
- **AFGELEID:** waarom Blizzard dit veranderde is onbekend. Mogelijk betekent `nil` nu "terug naar standaard" in plaats
  van "leeg".
- **Risico:** laag-midden.
- **Test op de PTR:** `/mh apply`, dan ongedaan maken, dan uitloggen en weer in. Is de toets weer leeg, of staat er een
  Blizzard-standaardtoets?

## 10. Klein bij toetsen

- **GEMETEN (A):** `Enum.BindingContext` 9 heet nu `GamepadModeInGameCore` (was een gereserveerde plek). MH gebruikt
  geen BindingContext (D). Risico laag.

## 11. Loss of Control (bekend, bevestigd)

- **GEMETEN (A):** `C_LossOfControl.GetActiveLossOfControlData` krijgt `SecretWhenLossOfControlRestricted`; dat
  betekent "altijd secret, behalve voor een PvP-toeschouwer of -commentator". `...DataByUnit` gaat van "secret als het
  niet de speler is" naar ook altijd secret.
- **MH (D):** 0 treffers op `C_LossOfControl` en `LOSS_OF_CONTROL` (in dezelfde grep wel treffers op `C_UnitAuras`).
- **Risico:** laag.

## 12. C_UnitAuras: welke functie verloor NeverSecret

- **GEMETEN (A, ptr-doc regel 494-507):** het is `C_UnitAuras.GetUnitAuras`; het argument `unit` heeft geen
  `NeverSecret` meer. De functie erboven (regel 482, geeft `auraInstanceIDs` terug; dus AFGELEID `GetUnitAuraInstanceIDs`)
  houdt het wel. Verder alleen extra uitleg
  bij de groepsbuff-functies; `HIDDEN_GROUP_BUFF_LIST_SIZE` gaat van 32 naar 128.
- **MH (D):** MH gebruikt `GetUnitAuras` niet. Wel `GetAuraSlots` (o.a. `ActionPrompt.lua:409`, `DispelHelper.lua:373`),
  `GetAuraDataByIndex` (o.a. `Auras.lua:180`), `GetUnitAuraInstanceIDs` (`Auras.lua:455`, `PtrProbe.lua:306`),
  `GetPlayerAuraBySpellID` (o.a. `MissingBuff.lua:10`). Die zijn niet veranderd.
- **Risico:** laag.

## 13. C_Spell

- **GEMETEN (A):** `C_Spell.IsSpellCrowdControl` accepteert een secret spell-ID alleen nog van onbesmette (Blizzard-)code.
  Het is de enige secret-wijziging in `SpellDocumentation`.
- **MH (D):** MH gebruikt `IsSpellCrowdControl` niet. `IsSpellImportant` (`CombatSafety.lua:446`, `:596`, `:875`) is
  niet veranderd.
- **Risico:** laag.

## 14. GetFrameStrata kan secret worden

- **GEMETEN (A):** nieuw `Enum.SecretAspect.FrameStrata`. `GetFrameStrata` kan een secret teruggeven als de laag ooit met
  een secret is gezet; `SetFrameStrata` neemt nu een secret aan van onbesmette code.
- **MH (D):** MH leest de laag van zijn eigen frames: `UI.lua:2289`, `Addons\Guide.lua:854-926`,
  `KeyboardLayoutPrototype.lua:1504`, `:1533`, `PartyTargets.lua:646-670`.
- **AFGELEID:** MH zet zelf nooit een secret laag, dus komt er nooit een secret terug.
- **Risico:** laag.

## 15. StaticPopup

- **GEMETEN (A, `Blizzard_StaticPopup/StaticPopup.lua`, `SharedTemplates.lua`):** nieuw `OnEscape`, `ShouldHideOnEscape`,
  `hasConfirmationEditBox`, `skipGamepadAutoFocus`, en `PopupEventManager` (meldingen PopupOpened/PopupClosed). Bij Escape
  wordt `OnEscape` aangeroepen in plaats van `OnCancel` als het bestaat. `hideOnEscape` werkt nog.
- **MH (D):** 61 StaticPopup-plekken in 15 bestanden; alle MH-dialogen gebruiken alleen `hideOnEscape` (o.a.
  `KeyBlock.lua:1592`, `SettingsPage.lua:953`, `FirstRun.lua:59`). Geen `OnEscape`, `ShouldHideOnEscape` of
  `hasConfirmationEditBox`.
- **Risico:** laag.

## 16. Settings-API

- **GEMETEN (A, `Blizzard_Settings_Shared`):** alleen toevoegingen: `Settings.InitDropdown` krijgt een optioneel 5e
  argument, `FinalizeCommit` een `uiReload`-argument, en veel gamepad-navigatie. Niets verwijderd of hernoemd.
- **MH (D):** `Modules\SettingsPage.lua` - geen breuk verwacht.
- **Risico:** laag.

## 17. Naamplaten

- **GEMETEN (A, `Blizzard_NamePlates.lua`):** `NamePlateConstants.NAMEPLATE_WIDTH` heet nu `NAME_PLATE_WIDTH`,
  `CLASSIC_NAMEPLATE_WIDTH` heet `CLASSIC_NAME_PLATE_WIDTH`, `CLASSIC_CAST_BAR_ICON_HEIGHT` is weg; er komt een
  level-aanduiding bij. De `C_NamePlate`-API-doc is niet veranderd (staat niet tussen de 156).
- **MH (D):** alleen `C_NamePlate.GetNamePlateForUnit` en `GetNamePlates` (`Rares.lua:919-946`,
  `ForeverTrainer.lua:1400-1531`). Geen `NamePlateConstants`.
- **Risico:** laag.

## 18. Unit frames en actiebalken: Blizzard ruimt op

- **GEMETEN (A):** Blizzard voegt hun `_Mainline.toc` en `_Classic.toc` samen tot een toc per addon met
  `AllowLoadGameType`-regels. De XP/reputatiebalk verhuist van `Blizzard_ActionBar` naar een nieuwe addon
  `Blizzard_StatusTrackingBar`. `ComboFrame` is weg op Mainline.
- **GEMETEN (B, Frames):** verdwenen frames: `AccountStoreFrame`, `ComboFrame`, `FullscreenAccountStoreContainer`,
  `MasterLooterFrame`, `GameKioskSessionStartedDialog`, `KioskModeSplash`.
- **MH (D):** geen van die frames (grep: 0). `MainStatusTrackingBarContainer` komt alleen als naam voor in de Forever-tak
  (`EditModeBackup.lua:1260`).
- **Risico:** laag.

## 19. Verdwenen functies en events

- **GEMETEN (B, GlobalAPI en Events; A, SecureTransfer):** weg zijn `AbandonSkill` (nu `C_SkillInfo.AbandonSkill`),
  `BNSetBlocked`, `C_CatalogShop.ConfirmHousingPurchase`, `C_PaperDollInfo.CanCursorCanGoInSlot` (nu `CursorCanGoInSlot`),
  `GetPetFoodTypes`, `SetBarSlotFromIntro`, `C_TransmogOutfitInfo.GetWeaponOptionsForSlot` en
  `SetViewedWeaponOptionForSlot`, `C_SecureTransfer.GetMailInfo`. Events weg: `EXTERNAL_EVENT_LAUNCH_URL_FAILED`,
  `PET_SPELL_POWER_UPDATE` (nu `PET_STATS_UPDATE`), `SECURE_TRANSFER_CONFIRM_HOUSING_PURCHASE`,
  `VIEWED_TRANSMOG_OUTFIT_SLOT_WEAPON_OPTION_CHANGED`. Ook de Housing-frame-API's `HousingFixturePointFrameAPI` en
  `HousingLayoutPinFrameAPI`.
- **MH (D):** 0 treffers op al deze namen (dezelfde zoekvraag met `PLAYER_ENTERING_WORLD` erbij gaf 150 treffers in 88
  bestanden).
- **Risico:** laag.

## 20. C_ActionBar

- **GEMETEN (A):** veel zoekfuncties krijgen een optioneel argument `setToSearch` (`Enum.ActionBarSet`: None, Mkb,
  Gamepad, All; standaard All). Nieuw o.a. `IsHighestSpellRank`, `EnterActionButton`, event
  `ACTION_COMBAT_ACTION_RANGE_CHECK_UPDATE`.
- **MH (D):** MH gebruikt `C_ActionBar.IsAssistedCombatAction` (`ApplyLayout.lua:317-322`, `BarInventory.lua:178-183`,
  `LiveKeys.lua:143`, `KeybindExport.lua:58-62`, `KeybindSchema.lua:516-531`, `KeyBlock.lua:520-523`): niet veranderd.
  `IsHighestSpellRank` staat alleen in `ForeverRanks.lua:665`, en dat bestand stopt op retail (`ForeverRanks.lua:25`).
- **Risico:** laag.

## 21. Forever-herkenning blijft goed

- **GEMETEN (D):** `ns.IS_FOREVER` komt van het toc-nummer (16000-19999), `Core.lua:58`.
- **GEMETEN (A, B):** retail 12.1.7 krijgt veel "Classic"-functies (vaardigheden, huisdier-humeur, munitie,
  spell-rangen, `GetGameType`). Omdat MH op het nummer kijkt en niet op of een functie bestaat, raakt dit MH niet.
  `SpellbookDump.lua:58` gebruikt `IsSpellBookItemLowRank` als die er is; dat is alleen een diagnose.
- **Risico:** laag.

## 22. Talebound en spelmodi

- **GEMETEN (A, `Blizzard_EditMode.toc`):** Blizzard gebruikt de game types `standard`, `wowhack`, `camelot`, `mists`,
  `classic`, `plunderstorm`, `wrath`, `cata`.
- **GEMETEN (D):** `MidnightHelper.toc:3` = `## AllowLoadGameType: standard`. Dus MH laadt niet in `wowhack` (AFGELEID uit
  de regel; bekend uit eerder onderzoek dat Talebound = wowhack).
- **GEMETEN (A, Delves-docs):** nieuw `Enum.TieredEntranceType.Tale = 6`, `C_DelvesUI.HasActiveTale`,
  `IsPartyLeaderInTaleInstance`, `RequestClearActiveTale`, event `TALE_RUN_CLEAR_RESULT`, en vlag
  `TieredEntranceTierFlag.DisableTraitSystem = 2`.
- **AFGELEID:** een Tale lijkt een ingang zoals een delve. Niet bekend of het spel dan midden in een sessie van game type
  wisselt. Als een delve-tier de companion-talenten uitzet (`DisableTraitSystem`), kan het curio-advies van MH
  (`DelveCuriosAdvisor.lua`) daar niet kloppen.
- **Nieuw en handig (GEMETEN, A `BuildDocumentation`):** `GetGameType()` en `GetGameFamily()` geven de game type zoals de
  toc die gebruikt. Kan in een MH-diagnose.
- **Risico:** laag.
- **Test op de PTR:** in en uit een Tale gaan met MH aan; daar `/run print(GetGameType(), C_AddOns.IsAddOnLoaded("MidnightHelper"))`.

## 23. Wapen-enchant: imbue gaat voor

- **GEMETEN (A, `PaperDollInfoDocumentation`):** de tekst bij de tijdelijke-enchant-functies zegt nu "Imbue enchants
  take priority over temporary enchants". Nieuw `C_Item.GetWeaponEnchantInfo(weaponSlot)` geeft een LIJST, met
  `Enum.ItemEnchantType` (None, Permanent, Temporary, Imbue).
- **GEMETEN (B):** de oude globale `GetWeaponEnchantInfo` is niet verdwenen.
- **MH (D):** `ConsumableReadyCheck.lua:843-844` en `:905-906`, `MissingBuff.lua:78-81`, `ForeverBuffs.lua:226`.
- **AFGELEID:** als een wapen een imbue en een olie heeft, kan de oude functie de imbue melden. Of dat voor de oude
  globale functie ook geldt, is niet gemeten.
- **Risico:** laag.
- **Test op de PTR:** Shaman met alleen een imbue en geen olie: zegt de MH-readycheck "olie in orde"?

## 24. CVars

- **GEMETEN (B, CVars):** weg zijn o.a. `SSAOType`, `useShadowMapping`, `volumeFogDisable*`, `volumeFogUse16BitTexture`,
  `lastLaunchedExternalEventURL`, `KioskCharacterTemplateSet`. Nieuw o.a. `graphicsLightMode`, `raidGraphicsLightMode`,
  `simpleKeybinds`, `showSwingTimer`, `ShowAllSpellRanks`. **GEMETEN (A):** nieuw `C_CVar.SetTempCVar` en `RemoveTempCVar`.
- **MH (D):** MH leest of zet `screenshotFormat` (`DevShots.lua:393-433`), `nameplateShowFriendlyNpcs`
  (`ForeverTrainer.lua:1305`, `:1470`), `AutoPushSpellToActionBar` (`KeyBlock.lua:497`, `:1125-1128`, `:1333`) en de
  `graphics*`/`raidGraphics*`-lijst (`FpsPanel.lua:41-53`). Geen daarvan is weg.
- **Idee:** `SetTempCVar` kan DevShots helpen (tijdelijk png, zonder het op te slaan).
- **Risico:** laag.

## 25. Tassen en bank

- **GEMETEN (A):** `Enum.BagIndex`: karakterbank-tabs 7-9 erbij, `AccountBankTab_1` gaat van 12 naar 15, account-tabs
  6-9 erbij. Tassen 0-5 blijven gelijk.
- **MH (D):** MH loopt alleen tassen 0-5 af (`Core.lua:3496`, `AtalUtekProbe.lua:570`, `DelveItemsPopup.lua:286`, `:571`,
  `GearExport.lua:628`) en gebruikt geen `Enum.BagIndex` of `AccountBankTab`.
- **Risico:** laag.

## 26. Interfacenummer

- **NIET ZELF GEMETEN:** dat 12.1.7 interfacenummer 120107 heeft, komt uit MH zelf (`MidnightHelper.toc:1`,
  `EditModeBackup.lua:155`) en CLAUDE.md. Blizzards eigen toc-bestanden in bron A hebben geen `## Interface`-regel om
  het mee te controleren.
- **Test op de PTR:** `/dump select(4, GetBuildInfo())` (verwacht 120107).

---

## Wat ik niet kon meten

- In welke spelmodi `AllowSimpleKeybindOption` (punt 7) en `ContentSetAccountKeyBindings` (punt 8) aan staan. Dat zit op
  de server.
- Of de client het nummer van je actieve indeling ophoogt nu er een derde preset is (punt 2). De Lua laat het zien, de
  client niet.
- Of Blizzards indeling-string op 12.1.7 van versie verandert (punt 6).
- Wat `SetBinding(key)` zonder opdracht nu precies doet (punt 9).
- Niets uit `docs/` gelezen; eerdere MH-notities over 12.1.7 zijn dus niet naast dit verslag gelegd.

## Testlijst voor de PTR (kort)

1. `/dump Enum.EditModeSystem.LossOfControl` -> 28.
2. `/dump #EditModePresetLayoutManager:GetCopyOfPresetLayouts()` -> 3; `activeLayout` met eigen indeling naast live.
3. Instellingen -> Toetsen: staat "Simple Keybinds" er? `/dump C_GameRules.IsGameRuleActive(Enum.GameRule.AllowSimpleKeybindOption)`.
4. `/mh apply`, ongedaan maken, relog: toets leeg?
5. BarPreset-string opnieuw exporteren en vergelijken.
6. KeyBlock toepassen: screenshot naast live.
7. In een Tale: `/run print(GetGameType(), C_AddOns.IsAddOnLoaded("MidnightHelper"))`.
8. Shaman-imbue zonder olie: readycheck.
9. `/dump select(4, GetBuildInfo())` -> 120107.
