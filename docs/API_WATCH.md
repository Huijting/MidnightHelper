# API_WATCH.md — dagelijkse API-wachter

Dit is het logboek van de **API-wachter**: de addon- en API-kant (Lua-API, secure/restricted
frames, taint, secret values, addon-secties van patch notes/hotfixes) — niet game-content.
Zelfde vorm als `docs/PTR_12.1_WATCH.md`: nieuwe regels **onderaan**, nooit iets overschrijven.
Elke regel: `- [JJJJ-MM-DD]` + emoji + vette kop, met de code-toetsing erin
([RAAKT ONS NIET] / [AL AFGEDEKT] / [MOET GEFIKST], met bestand:regel).
---

- [2026-08-18] 🚀 **Patch 12.1 "Curse of Ula'tek" is live (11 aug NA / 12 aug EU); Season 2 opent vandaag.** Hierdoor is de héle 12.1-PTR-API nu retail — de items hieronder zijn PTR-wijzigingen die vanaf nu daadwerkelijk gelden. Bron: Blizzard patch notes + blizzardwatch, 11 aug 2026. **[AL AFGEDEKT]** MidnightHelper.toc:1 vermeldt al `## Interface: 120007, 120100`, en de addon is op live 12.1 getest (ApiProbe.lua / PotionButton.lua:24, 13 aug 2026). Geen actie nodig; dit is de context waaronder de rest gelezen moet worden.

- [2026-08-18] ❌ **Verwijderde/hernoemde functies & events in 12.1.** `C_UnitAuras.TriggerPrivateAuraShowDispelType`, `C_PingSecure.SendPing`/`GetTargetWorldPing`/`GetTargetWorldPingAndSend`, `C_Ping.GetContextualPingTypeForUnit`, `C_DyeColor.GetDyeColorForItem(Location)`, `C_RecruitAFriend.IsEnabled`, `C_HousingUI.IsInsideOwnHouse` (→ `IsInsideOwnedHouse`), event `BATTLETAG_INVITE_SHOW`, global `UIParent_ManageFramePositions`, `FrameScript.SetTableSecurityOption`, `C_HousingBlueprint.IsImportAvailable`/`IsExportAvailable`. Bron: danderbot 12.1-diff (snapshot 20 jun 2026, nu live). **[RAAKT ONS NIET]** geen treffers in de code (grep over de hele addon, `.git`/`docs`/`tools`/`dist` uitgesloten).

- [2026-08-18] 🔁 **`AddPrivateAuraAnchorArgs` veld hernoemd: `showCountdownFrame` → `showCooldownFrame`** (+ nieuwe `showCooldownEdge`/`showDispelIcon`), doorgegeven aan `C_UnitAuras.AddPrivateAuraAnchor`. Stille breuk: oude sleutel wordt genegeerd, swipe verdwijnt zonder fout. Bron: danderbot 12.1-diff. **[RAAKT ONS NIET]** geen treffer op `AddPrivateAuraAnchor` of `showCountdownFrame` in de code.

- [2026-08-18] 🎛️ **`Enum.EditModeUnitFrameSetting.IconSize` verwijderd, gesplitst in `BuffIconSize`/`DebuffIconSize`.** Bron: danderbot 12.1-diff. **[RAAKT ONS NIET]** geen treffer op `EditModeUnitFrameSetting`.

- [2026-08-18] 🔒 **Nieuw secure aura-systeem: AuraContainer/AuraButton + `AddAuraFrame`/`AddAuraFilter`.** Opt-in widgets waarmee addons auras "veilig" tonen zonder de onderliggende data te lezen. Bron: danderbot 12.1-diff + Wowhead/Icy Veins (jun 2026). **[RAAKT ONS NIET]** geen treffer op `AddAuraFrame`/`AddAuraFilter`/`AuraContainer`/`AuraButton`; de addon leest auras via `C_UnitAuras` + `issecretvalue`, niet via dit systeem.

- [2026-08-18] 🧩 **Forbidden Aspects / `HasAnyForbiddenAspects(...)` (nieuwe securitylaag achter aura-buttons).** DandersFrames 5.1.2 meldt dat op live 12.1 de `type="click"`-ACTION-delegatie breekt doordat Blizzards check (SecureTemplates.lua:564) de mouse-button-STRING i.p.v. de button meegeeft. Bron: danderbot 12.1-diff + DandersFrames-notitie (13 aug 2026). **[AL AFGEDEKT]** ApiProbe.lua:372-373 probet beide spellingen (enkelvoud + meervoud); PotionButton.lua:31-34 legt vast dat wij een `CLICK <frame>:LeftButton`-BINDING gebruiken, niet `type="click"`-delegatie, dus die specifieke break raakt ons niet. Op 13 aug bevestigd werkend in-game.

- [2026-08-18] ⚠️ **Secret-value / UnitAura-uitrol — engine-gedrag, niet zichtbaar in een source-diff.** Danderbot waarschuwt expliciet dat de UnitAura secret-value-wijzigingen en aura-button-protecties over meerdere builds uitrollen en buiten de diff vallen; nu 12.1 live is, is dit het hoogste risico. **[AL AFGEDEKT]** `issecretvalue`-guards staan in 36 codebestanden (o.a. Auras.lua, MissingBuff.lua, DispelHelper.lua, PartyTargets.lua), conform de conventie in CLAUDE.md. Geen concrete breuk gevonden; blijft in het oog. Als een aura-scherm na 12.1 leeg blijkt, is dit de eerste verdachte.

- [2026-08-19] ✅ **Hotfixes 13/14/17 aug 2026 bevatten géén UI/API/addon-secties.** Alleen classes, Delves, items, quests, PvP, professions — puur content, geen Lua-API of secure-frame-wijzigingen. Bron: news.blizzard.com hotfixes 13/14/17 aug 2026. **[RAAKT ONS NIET]** niets te toetsen.

- [2026-08-19] 🧭 **`C_SuperTrack.GetNextWaypointForMap` verwijderd en verplaatst naar `C_Navigation.GetNextWaypointForMap`.** Bron: Warcraft Wiki Patch 12.1.0/API changes (live sinds 11 aug, binnen 7 dagen). **[AL AFGEDEKT]** de verwijderde functie wordt nergens in echte code aangeroepen; EventProbe.lua:119-121 documenteert de verhuizing letterlijk en probet beide namespaces (EventProbe.lua:131-133). NativeArrow.lua:26 en alle echte `C_SuperTrack`-calls gebruiken enkel `SetSuperTrackedUserWaypoint` / `SetSuperTrackedQuestID` / `GetSuperTrackedQuestID` (Core.lua:703, UI.lua:1051, CampaignLeadIn.lua:330-433, CurrencyGuide.lua:145, DelveTipMarkup.lua:516, OmniumFolio.lua:287, TierSet.lua:96), elk achter `if C_SuperTrack and C_SuperTrack.X then` + pcall.

- [2026-08-19] 🔤 **Global `UIParentLoadAddOn` hernoemd naar `LoadAddOnWithErrorHandling`.** Bron: Warcraft Wiki Patch 12.1.0/API changes. **[AL AFGEDEKT]** Core.lua:79 `local fn = _G.LoadAddOnWithErrorHandling or _G.UIParentLoadAddOn` — nieuwe naam eerst, oude als fallback; comment Core.lua:68-70 legt de migratie vast.

- [2026-08-19] 🔊 **`C_UnitAuras.AddPrivateAuraAppliedSound` / `RemovePrivateAuraAppliedSound` verwijderd** (hernoemd naar `AddAuraSound` / `RemoveAuraSound`); nieuw o.a. `CancelAuraByInstanceID`, `SetHiddenGroupBuffs`, `GetGroupBuffVisualAlerts`. Bron: Warcraft Wiki Patch 12.1.0/API changes. **[RAAKT ONS NIET]** geen treffer op een van deze namen in de code.

- [2026-08-19] 🔒 **Verscherping van het secret-value-item van 18 aug: UnitAura-toegang via index/slot/auraInstanceID geeft nu een Lua-ERROR (niet enkel nil/secret) zolang auras secret zijn; toegang via spellID/naam blijft werken.** Dit is scherper dan de formulering van 18 aug ("return full secrets or nil"). Bron: Warcraft Wiki Patch 12.1.0/API changes (secret-value-sectie). **[AL AFGEDEKT]** Auras.lua vangt elke index-scan in pcall: :165 en :204 `pcall(get, unit, i, filter)`, en behandelt `not ok` expliciet als "de API weigerde, onbekend" → nil/false (:166-167, :205-207) i.p.v. als "afwezig". `spellId` wordt geguard met `Secret()` (:173). `HasPlayerAura` leest per spellID (:159). De nieuwe error is precies wat de pcall opvangt; geen kale index-call gevonden.

- [2026-08-20] ✅ **Geen relevante API-wijzigingen.** Hotfix 18 aug 2026 gecontroleerd — enkel Classes/Delves/Dungeons/Items/PvP/Professions/Quests, géén UI/API/addon-sectie (aanvulling op de 13/14/17-regel van 19 aug). Warcraft Wiki Patch 12.1.0/API changes: nieuwste gedateerde build nog steeds PTR 8 / Build 69111 (4 aug 2026) — buiten het 7-daagse venster, niets nieuws sinds. Blizzard UI/Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen. De aura-/secret-value-items (C_UnitAuras, AuraContainer, secret-uitrol) staan al hierboven (18–19 aug) en zijn ongewijzigd. **[RAAKT ONS NIET]** niets nieuws te toetsen. Het enige openstaande actiepunt blijft de onbevestigde MissingBuff.lua:185 uit de 19-aug-regel.

- [2026-08-20] ✅ **Dat laatste actiepunt is AF, en de watcher draaide op een oudere lezing.** `HealerInGroup()` in `MissingBuff.lua` staat sinds 19 aug (release 3.1.0) op `pcall(UnitGroupRolesAssigned, u)` mét `ns.IsSecretValue`-guard vóór de vergelijking — zie de kop erboven, die ook uitlegt waaróm het hier strenger moet dan bij de zustermodule: dit vraagt naar ándere groepsleden, niet naar de speler. **[AL AFGEDEKT]** Geen kale aanroep meer in het bestand. Deze regel staat er zodat het punt niet elke dag opnieuw als openstaand terugkomt.

- [2026-08-19] 🧩 **Meer Unit*-APIs geven een secret value wanneer de unit-identiteit secret is: `UnitClass`, `UnitClassBase`, `UnitRace`, `UnitSex`, `UnitGroupRolesAssigned`, `UnitIsPVP`, `GetInspectSpecialization` e.a.** Bron: Warcraft Wiki Patch 12.1.0/API changes. **[grotendeels AL AFGEDEKT]** `UnitClass("player")` is veilig (player-identiteit wordt nooit secret) en wordt overal zo gebruikt (o.a. MissingBuff.lua:195, VaultAdvisor.lua:229, KeybindAutoMap.lua:229); `UnitGroupRolesAssigned` staat via pcall in DelveCuriosAdvisor.lua:58-59 en EncounterJournalSidePanel.lua:121-122, en via een Ask-wrapper in PartyTargets.lua:397/572. **[MOET GEFIKST — onbevestigd risico]** MissingBuff.lua:185 roept `UnitGroupRolesAssigned(u)` KAAL aan op elk groepslid en vergelijkt `== "HEALER"` binnen een `if`, zonder pcall of secret-guard — afwijkend van de zustermodules. Als de rol van een groepslid in 12.1 ooit secret is, gooit die `if` een "secret value in a conditional"-error en breekt `HealerInGroup()`. ⚠️ Ik kan NIET bevestigen dat party-rollen ooit secret worden (party-identiteit is normaal niet secret), dus dit is misschien nooit triggerbaar. Voorgestelde lijn: dezelfde pcall/secret-guard als DelveCuriosAdvisor.lua:58-59. Rob beslist; niet blind fixen.

- [2026-08-21] ✅ **Geen relevante API-wijzigingen.** Warcraft Wiki Patch 12.1.0/API changes: nieuwste gedateerde build nog steeds PTR 8 / Build 69111 (4 aug 2026) — ongewijzigd sinds de 20-aug-run, ver buiten het 7-daagse venster. Er bestaat nog géén `Patch_12.1.5/API_changes`-pagina (gecontroleerd; niet gevonden). Hotfixes 19 en 20 aug 2026 (nieuw sinds de vorige run) volledig gelezen: enkel Classes/Delves/Dungeons&Raids/Items/PvP/Professions/Quests/Treasures/Omnium Folio/Prey — géén UI-, API-, Addon- of secure-frame-sectie. Blizzard UI/Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen. Bron: warcraft.wiki.gg/Patch_12.1.0/API_changes, news.blizzard.com hotfixes 19+20 aug 2026, US UI-and-Macro-forum. **[RAAKT ONS NIET]** niets nieuws te toetsen. Het enige openstaande punt blijft ongewijzigd: het onbevestigde risico op MissingBuff.lua:185 (`UnitGroupRolesAssigned(u)` kaal op groepsleden) uit de 19-aug-regel hierboven — Rob beslist, niet blind fixen.

- [2026-08-22] ✅ **Geen relevante API-wijzigingen.** Warcraft Wiki Patch 12.1.0/API changes: nieuwste gedateerde build nog steeds PTR 8 / Build 69111 (4 aug 2026) — ongewijzigd, ver buiten het 7-daagse venster. Nog géén `Patch_12.1.5/API_changes`-pagina (gecontroleerd; niet gevonden). Hotfix 21 aug 2026 (nieuw sinds de 21-aug-run, die t/m 20 aug dekte) volledig gelezen: enkel Delves/Dungeons&Raids/Housing/Items/Prey — géén UI-, API-, Addon- of secure-frame-sectie. Blizzard UI/Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen. Bron: warcraft.wiki.gg/Patch_12.1.0/API_changes, news.blizzard.com hotfixes 21 aug 2026, US UI-and-Macro-forum. **[RAAKT ONS NIET]** niets nieuws te toetsen.

- [2026-08-22] ❌ **CORRECTIE op de slotregels van 20 én 21 aug: er is GÉÉN openstaand [MOET GEFIKST]-punt meer.** De 19-aug-regel flagde `MissingBuff.lua:185` (`UnitGroupRolesAssigned(u)` kaal op groepsleden) als onbevestigd risico. De 20-aug-regel meldde al dat het AF was, maar de scanpassen van 20 én 21 aug bleven het daarna toch als "enige openstaande punt" noemen — dat is stale. Vandaag in de code geverifieerd: `HealerInGroup()` staat op MissingBuff.lua:203-207 met `local ok, role = pcall(UnitGroupRolesAssigned, u)` en `if ok and not (ns.IsSecretValue and ns.IsSecretValue(role)) and role == "HEALER"` — pcall + secret-guard vóór de vergelijking, geen kale aanroep meer. Comment MissingBuff.lua:183-198 legt vast waaróm (zusterpatroon van DelveCuriosAdvisor.lua:52). **[AL AFGEDEKT]** MissingBuff.lua:203-207. Er zijn op dit moment geen open actiepunten aan de addon-/API-kant.

- [2026-08-23] ✅ **Geen relevante API-wijzigingen.** Warcraft Wiki Patch 12.1.0/API changes: nieuwste gedateerde build nog steeds PTR 8 / Build 69111 (4 aug 2026) — ongewijzigd sinds de vorige runs, ver buiten het 7-daagse venster. Nog géén `Patch_12.1.5/API_changes`- of `Patch_12.2.0/API_changes`-pagina (gecontroleerd; niet gevonden). Sinds de 22-aug-run is er géén nieuwe hotfix verschenen: de laatste blijft 21 aug 2026 (gepubliceerd 22 aug), al gelezen in de vorige run — 22 en 23 aug (weekend) leverden geen post op. Blizzard UI/Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen (zoekresultaten leverden enkel oude threads uit 2022–2023). Bron: warcraft.wiki.gg/Patch_12.1.0/API_changes, news.blizzard.com hotfixes (t/m 21 aug 2026), US UI-and-Macro-forum. **[RAAKT ONS NIET]** niets nieuws te toetsen. Geen open actiepunten aan de addon-/API-kant.

- [2026-08-24] ✅ **Geen relevante API-wijzigingen.** Warcraft Wiki Patch 12.1.0/API changes: nieuwste gedateerde build nog steeds PTR 8 / Build 69111 (4 aug 2026) — ongewijzigd sinds de vorige runs, ver buiten het 7-daagse venster. Nog géén `Patch_12.1.5/API_changes`- of `Patch_12.2.0/API_changes`-pagina (gecontroleerd; niet gevonden). Géén nieuwe hotfix sinds de 23-aug-run: de laatste blijft 21 aug 2026 (al gelezen), 22–24 aug leverden geen post op. Blizzard UI/Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen (zoekresultaten enkel oude threads uit 2022–2024). De 12.1-PTR-dev-notes met "map coordinates in base UI" en class tuning dateren van 21 juli 2026 — ruim buiten het venster, en het is een additieve UI-optie (World Map → coördinaten van speler/cursor, shift-klik kopieert een slash-commando), geen Lua-API- of secure-frame-breuk. Bron: warcraft.wiki.gg/Patch_12.1.0/API_changes, news.blizzard.com/bluetracker hotfixes (t/m 21 aug 2026), wowhead.com/icy-veins PTR-dev-notes (21 jul 2026), US UI-and-Macro-forum. **[RAAKT ONS NIET]** niets nieuws te toetsen. Geen open actiepunten aan de addon-/API-kant; de staande 12.1-items (C_UnitAuras secret-reads, `GetNextWaypointForMap`-verhuizing, AuraContainer/AuraButton) staan hierboven (18–19 aug) en zijn ongewijzigd afgedekt.

- [2026-08-24] 🔁 **AANVULLING op het AuraContainer-item van 18 aug — "[RAAKT ONS NIET]" was juist over breuk en misleidend over relevantie.** Die regel concludeerde terecht dat wij dit systeem niet gebruiken en er dus niets van breekt. Wat er niet bij stond: het is in 12.1 **de enige manier waarop een addon groeps-dispels nog kan tónen**. Gemeten aan een draaiend voorbeeld (HexBreak 0.6.12 Beta, GPL-3, tijdelijk geïnstalleerd 24 aug): `C_AddOns.LoadAddOn("Blizzard_AuraContainer")` → `AuraUtil.IsValidFilterString("HARMFUL|RAID")` → `CustomAuraContainerTemplate` per tegel → `SetUnit` / `AddAuraSlot` / `SetEnabled` / `UpdateAllAuras`. De addon krijgt de aura-inhoud nooit te zien; Blizzard tekent hem. **[RAAKT ONS WEL — maar als kans, niet als risico]** geen actie nodig; vastgelegd omdat "raakt ons niet" anders gelezen wordt als "niet interessant".

- [2026-08-24] 🔴 **HARDE GRENS, uit datzelfde voorbeeld: `UntrustedScriptExecution` op AuraButtons.** HexBreak's eigen commentaar (Core.lua:1905-1911): *"12.1 applies UntrustedScriptExecution to AuraButtons. Addon-installed OnShow/OnHide handlers therefore cannot be used as a reliable self-alert trigger while auras are secret."* Een automatisch geluid of alarm vereist volgens hem een spell-ID-registratie via `C_UnitAuras.AddAuraSound`, en die kan niet wildcarden over "elke dispelbare aura". Bevestigd door zijn changelog: in **0.6.11** is het hele Priority-Target-systeem verwijderd (PRIO-balk, P1/P2/P3-nameplates, raidmarkers, macro, keybinds, `Bindings.xml`) en in 0.6.12 nog steeds afwezig. **[RAAKT ONS — ROADMAP]** je kunt groeps-dispels tonen maar niet lezen, dus geen prioriteit, geen alarm, geen uitleg. Zie `docs/NEXT_SESSION.md`: de geplande groeps-dispelhelper is in deze vorm niet te bouwen. Onze eigen `DispelHelper.lua` (alléén je eigen debuffs, school uit `dispelName`) valt hier buiten en blijft geldig. 🔴 **Die laatste conclusie is op 25 aug achterhaald — zie de correctie onderaan.**

- [2026-08-25] ✅ **Geen relevante API-wijzigingen.** Warcraft Wiki Patch 12.1.0/API changes: nieuwste gedateerde build nog steeds PTR 8 / Build 69111 (4 aug 2026), consolidated tot 12.1.0 (69283) van 11 aug — ongewijzigd sinds de vorige runs, ver buiten het 7-daagse venster. Nog géén `Patch_12.1.5/API_changes`- noch `Patch_12.2.0/API_changes`-pagina (beide vandaag gecontroleerd; leeg/niet gevonden). Géén nieuwe hotfix sinds de 21-aug-post: 22–25 aug leverden geen nieuwe hotfix op (Aug 18/19/20/21 vandaag nogmaals volledig doorgelezen — enkel Classes/Delves/Dungeons&Raids/Housing/Items/PvP/Professions/Quests/Treasures/Omnium Folio/Prey, géén UI-, API-, Addon- of secure-frame-sectie; het enige addon-nabije item, "Dark Simulacrum can now be tracked through the Cooldown Manager" (19 aug), is een Blizzard-content-fix, geen Lua-API-wijziging). Blizzard UI/Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen. Bron: warcraft.wiki.gg/Patch_12.1.0/API_changes, news.blizzard.com hotfixes (t/m 21 aug 2026), US UI-and-Macro-forum. **[RAAKT ONS NIET]** niets nieuws te toetsen. Geen open actiepunten aan de addon-/API-kant; de staande 12.1-items (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons) staan hierboven (18–24 aug) en zijn ongewijzigd afgedekt.

- [2026-08-26] ✅ **Geen relevante API-wijzigingen.** Warcraft Wiki Patch 12.1.0/API changes: nieuwste gedateerde build nog steeds PTR 8 / Build 69111 (4 aug 2026) — ongewijzigd sinds de vorige runs, ver buiten het 7-daagse venster (geverifieerd: de laatste `### 2026-…`-sectie op de pagina is 2026-08-04). Nog géén `Patch_12.1.5/API_changes`- noch `Patch_12.2.0/API_changes`-pagina (beide vandaag gecontroleerd; 12.1.5 komt leeg terug, 12.2.0 bestaat niet). Nieuwe hotfix sinds de 25-aug-run: **Hotfixes 25 aug 2026** volledig gelezen — top-secties enkel Classes/Delves/Housing/Prey/Quests/Items, géén UI-, API-, Addon- of secure-frame-sectie. De enige addon-nabije regels zijn twee Cooldown-Manager-CONTENTfixes ("Dark Simulacrum can now be tracked through the Cooldown Manager"; "Soul Harvester: Shadow Bolt/Hand of Gul'dan waren uitgeschakeld in de cooldown manager") — Blizzard-content, geen Lua-API-wijziging. Blizzard UI/Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen (zoekresultaten enkel oude unit-frame-/addon-aanraders). Bron: warcraft.wiki.gg/Patch_12.1.0/API_changes, news.blizzard.com/article/24296142 hotfixes 25 aug 2026, US UI-and-Macro-forum. **[RAAKT ONS NIET]** niets nieuws te toetsen. Geen open actiepunten aan de addon-/API-kant; de staande 12.1-items (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons) staan hierboven (18–24 aug) en zijn ongewijzigd afgedekt.

- [2026-08-26] 🔴 **CORRECTIE op het item van 24 aug: "de geplande groeps-dispelhelper is in deze vorm niet te bouwen" was fout, en hij staat inmiddels in de addon.** Op 25 aug is hij gebouwd in `Modules/PartyTargets.lua` en Rob heeft hem in-game bevestigd: Remove Curse (475) en Spellsteal (30449) vuren allebei vanaf een groepsrij. De rij is in twee secure knoppen gesplitst — links het groepslid (rechtsklik = dispel), rechts diens doelwit (rechtsklik = purge) — met de spell-ID uit `GetPlayerDispelIcon()`/`GetPlayerPurgeIcon()`.

  **Waarom de conclusie fout was, want dat is het bruikbare deel.** De redenering klopte voor de bouw die voor de hand lag: lezen wát er te dispellen valt, dat wegen, en er iets over zeggen. Dat kan inderdaad niet. Maar de speler hoeft dat niet van óns te horen — hij hoeft alleen te kunnen klikken, en een knop die per spell-ID cast heeft de aura-inhoud helemaal niet nodig. De grens zat om het *lezen*, niet om het *helpen*, en wij hadden het hele idee achter de grens geschoven.

  **Wat wél binnen de grens van 24 aug valt en dus overeind blijft:** geen prioriteit, geen geluid, geen alarm, geen uitleg over wát er op iemand staat. De rode gloed die we erbij bouwden is dan ook geen uitzondering maar de bevestiging: Blizzard tekent hem in een `CustomAuraContainerTemplate` op filter `HARMFUL|RAID` en wij hangen er alleen stilstaande kunst op. ⚠️ Die gloed is **nog nooit zien oplichten** — `/mh glow` meldt de machinerie, niet het resultaat. ✅ **Achterhaald diezelfde avond: hij vuurt.** Maisara Caverns, Holy Priest — onze rij voor Shuja Grimaxe lichtte op, tegelijk met HexBreak en niet voor de anderen. Het filter discrimineert dus echt. Dat hij drie builds lang onleesbaar bleef lag aan **frame level**: het aura-vakje tekende ónder de achtergrond van ons eigen paneel, dus alleen de 2px die eroverheen stak was zichtbaar. Nu gelijkgetrokken met HexBreak (`Core.lua:1856-1859`: `SetAllPoints()` zonder argument + `SetFrameLevel(ouder + 8)`); de nieuwe versie is zelf nog niet in het wild gezien.

- [2026-08-27] ✅ **Geen relevante API-wijzigingen.** Warcraft Wiki Patch 12.1.0/API changes: nieuwste gedateerde build nog steeds PTR 8 / Build 69111 (4 aug 2026) — ongewijzigd sinds de vorige runs, ver buiten het 7-daagse venster (geverifieerd: de laatste `### 2026-…`-sectie op de pagina is 2026-08-04, "Rise of the mouse"). Nog géén `Patch_12.1.5/API_changes`- noch `Patch_12.2.0/API_changes`-pagina (beide vandaag gecontroleerd; 12.1.5 komt leeg terug, 12.2.0 bestaat niet). Nieuwe hotfix sinds de 26-aug-run: **Hotfixes 26 aug 2026** volledig gelezen — top-secties enkel Classes (Demon Hunter/Paladin/Priest/Shaman/Warrior)/Delves/Dungeons&Raids (The Venemous Abyss)/Items and Rewards/PvP, géén UI-, API-, Addon- of secure-frame-sectie. De addon-nabije regels zijn onveranderd content: "Dark Simulacrum can now be tracked through the Cooldown Manager" en de Soul-Harvester-cooldown-manager-fix (beide al in de 25/26-aug-regels) plus "Tainted Strike"/"Defiling Taint" — spell-/debuff-namen, geen Lua-`taint`. Blizzard UI/Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen (zoekresultaten enkel oude threads uit 2022–2024). Bron: warcraft.wiki.gg/Patch_12.1.0/API_changes, news.blizzard.com/article/24296142 hotfixes 26 aug 2026, US UI-and-Macro-forum. **[RAAKT ONS NIET]** niets nieuws te toetsen. Geen open actiepunten aan de addon-/API-kant; de staande 12.1-items (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons) staan hierboven (18–26 aug) en zijn ongewijzigd afgedekt.

- [2026-08-28] ✅ **Geen relevante API-wijzigingen deze week (21–28 aug).** De hotfixes van
  20/21/25/26 aug (bluetracker/wowhead) bevatten geen addon-, UI-, Lua-, macro-, secure-frame-
  of taint-secties — alleen class balance, encounters, Delves, items, quests, professions,
  housing. De pagina *Patch 12.1.0/API changes* is niet ververst binnen 7 dagen: de
  geconsolideerde diff staat op "12.0.7 (68256) → 12.1.0 (69283) **Aug 11 2026**" en de laatste
  PTR-changes-post is **PTR 8, 4 aug 2026 (Build 69111)**. Alles op die pagina valt dus buiten
  het venster. Geen nieuw item om te melden.

- [2026-08-28] 🧭 **Eerste run — baseline-toetsing van de zwaarste staande 12.1.0-items (allemaal
  vóór 21 aug gepubliceerd; geen nieuws, ter geruststelling).** De hoog-risico 12.1.0-wijzigingen
  die MH raken zijn stuk voor stuk al in de code afgedekt:
  - **`C_SuperTrack.GetNextWaypointForMap` verwijderd → `C_Navigation.GetNextWaypointForMap`**
    (Global API, ~11 aug). **[AL AFGEDEKT]** — MH roept de verwijderde functie niet aan; alle
    C_SuperTrack-aanroepen zijn `SetSuperTrackedUserWaypoint` / `SetSuperTrackedQuestID` /
    `GetSuperTrackedQuestID`, elk achter `if C_SuperTrack and C_SuperTrack.X then` + `pcall`
    (`Core.lua:716`, `UI.lua:1133`, `CurrencyGuide.lua:145`, `DelveTipMarkup.lua:628`,
    `OmniumFolio.lua:287`, `TierSet.lua:96`, `CampaignLeadIn.lua:330`). Al gedocumenteerd in
    `EventProbe.lua:119`.
  - **AuraContainer/AuraButton-model; `AddAuraFrame` en `SecureAuraHeaderTemplate` verwijderd**
    (aura-secrecy, PTR 3–7). **[AL AFGEDEKT]** — MH gebruikt geen `SecureAuraHeaderTemplate` en
    geen `AddAuraFrame`; `PartyTargets.lua:293` maakt al een
    `CreateFrame("AuraContainer", ..., "CustomAuraContainerTemplate")` (achter `pcall`, met
    capability-check op `SetUnit/AddAuraSlot/SetEnabled` op regel 315).
  - **`C_UnitAuras.GetUnitAuras` / `GetUnitAuraInstanceIDs` geven secret vector; aura-toegang via
    index/slot/instanceID error't wanneer auras secret zijn.** **[AL AFGEDEKT]** — dit is precies
    het secret-value-model waar MH omheen gebouwd is; `Auras.lua:468` nil-checkt
    `UA.GetUnitAuraInstanceIDs` vóór gebruik, `EventProbe.lua:141` sondeert de set.
  - **`C_UnitAuras.AddPrivateAuraAppliedSound` / `RemovePrivateAuraAppliedSound` /
    `TriggerPrivateAuraShowDispelType` verwijderd.** **[RAAKT ONS NIET]** — nergens aangeroepen.
  - **`UIParentLoadAddOn` → `LoadAddOnWithErrorHandling`.** **[AL AFGEDEKT]** —
    `Core.lua:79` doet `_G.LoadAddOnWithErrorHandling or _G.UIParentLoadAddOn`.
  - **`GetInventorySlotInfo` verwijderd (global).** **[RAAKT ONS NIET]** — niet aangeroepen.
  - **`getglobal`/`setglobal` deprecated.** **[RAAKT ONS NIET]** — niet gebruikt.

- [2026-08-28] 🔁 **Correctie op een oudere claim: `GetWeaponEnchantInfo` is NIET verwijderd.**
  De 12.1.0-diff die de wachter tegenkwam noemt `GetWeaponEnchantInfo` bij de verwijderde
  globals. Dat klopt niet met de client: MH heeft dit op **live 12.1** getest en beide functies
  bestaan — de oude `GetWeaponEnchantInfo` én de nieuwe `C_PaperDollInfo.GetTemporaryEnchantmentInfo`
  (12.1 heeft de nieuwe *toegevoegd*, niets vervangen). Zie `ApiProbe.lua:345-347`. MH gebruikt de
  oude in `ConsumableReadyCheck.lua:734/795` en `MissingBuff.lua:78/81`, alle achter
  `if GetWeaponEnchantInfo then` + `pcall`. **[AL AFGEDEKT]** — geen stille breuk. (Mocht de client
  hem ooit tóch laten vallen, dan is de migratiedoel `C_PaperDollInfo.GetTemporaryEnchantmentInfo`
  al bekend en aanwezig.)

- [2026-08-28] ➕ **Aanvulling op de eerste 28-aug-regel: óók de hotfix van 27 aug gedekt.** Die
  regel las de hotfixes t/m 26 aug; sindsdien is er één nieuwe. **Hotfixes 27 aug 2026** volledig
  gelezen — enkel class-tuning (Demon Hunter: Blur PvP→PvE-terugdraai; Evoker Flameshaper:
  Lifecinders-tekst; Evoker Preservation: Emerald-Communion-visual-loop) plus Delves/Dungeons&Raids/
  Items/PvP. Géén UI-, API-, Addon- of secure-frame-sectie; "Tainted Strike"/"Defiling Taint" zijn
  Death-Knight-spell-/debuff-namen, geen Lua-`taint`. Bron: bluetracker.gg /
  news.blizzard.com/article/24296142, 27 aug 2026. **[RAAKT ONS NIET]** niets te toetsen. Het venster
  21–28 aug is hiermee volledig gedekt: geen enkele nieuwe API-/secure-frame-wijziging.

- [2026-08-29] ✅ **Geen relevante API-wijzigingen deze week (22–29 aug).** *Patch 12.1.0/API
  changes* is niet ververst binnen 7 dagen: laatste gedateerde PTR-sectie nog steeds **2026-08-04
  (PTR 8, Build 69111)** en de geconsolideerde diff nog steeds "12.0.7 (68256) → 12.1.0 (69283)
  **Aug 11 2026**" — beide buiten het venster (geverifieerd op de opgehaalde pagina, regels 154/515/531).
  Nog géén `Patch_12.1.5/` noch `Patch_12.2.0/API_changes`-pagina; datamine-zoek levert enkel
  oude 12.1-PTR-builds op (t/m 69111), niets nieuws. Hotfixes: nieuwste gepubliceerde lijst is nog
  steeds **27 aug 2026** (al gedekt in de 28-aug-regel); géén lijst van 28 of 29 aug. Blizzard
  US UI-and-Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen (resultaten
  enkel oude threads 2022–2026-03). Bron: warcraft.wiki.gg/Patch_12.1.0/API_changes;
  news.blizzard.com/article/24296142; us.forums.blizzard.com UI-and-Macro. **[RAAKT ONS NIET]**
  niets nieuws te toetsen. De staande 12.1.0-items (C_UnitAuras secret-reads,
  `GetNextWaypointForMap`→`C_Navigation`, AuraContainer/AuraGroup/AuraButton, `GetWeaponEnchantInfo`)
  staan hierboven (18–28 aug) en zijn ongewijzigd afgedekt; geen open actiepunt aan de addon-kant.

- [2026-08-30] ✅ **Geen relevante API-wijzigingen deze week (23–30 aug).** *Patch 12.1.0/API
  changes* is niet ververst binnen 7 dagen: laatste gedateerde PTR-sectie nog steeds **2026-08-04
  (PTR 8, Build 69111)**, geconsolideerde diff nog "12.0.7 (68256) → 12.1.0 (69283) **Aug 11
  2026**" — beide ruim buiten het venster. Nog géén `Patch_12.1.5/` noch `Patch_12.2.0/API_changes`-
  pagina (gecontroleerd; 12.1.5 leeg, 12.2.0 bestaat niet). Hotfixes: nieuwste gepubliceerde lijst
  is nog steeds **27 aug 2026** (al gedekt in de 28-aug-regel); géén lijst van 28/29/30 aug. Blizzard
  US UI-and-Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen. Bron:
  warcraft.wiki.gg/Patch_12.1.0/API_changes; news.blizzard.com/article/24296142;
  us.forums.blizzard.com UI-and-Macro. **[RAAKT ONS NIET]** niets nieuws te toetsen. Geen open
  actiepunt aan de addon-/API-kant; de staande 12.1.0-items (C_UnitAuras secret-reads,
  `GetNextWaypointForMap`→`C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op
  AuraButtons, `GetWeaponEnchantInfo`) staan hierboven (18–28 aug) en zijn ongewijzigd afgedekt.

- [2026-08-30] ℹ️ **Ter info, GEEN nieuw item: het "12.1.5 PTR staat op de Battle.net-launcher"-
  bericht is buiten het venster.** Dook op in de zoekresultaten maar Wowhead dateert het op ~13 aug
  2026 (commentaren 13–18 aug) — ouder dan 7 dagen, dus per regel 1 genegeerd. Belangrijker: er is
  nog steeds **geen client-build en dus geen datamining** van 12.1.5, en geen API-changes-pagina.
  Zodra die build er is, wordt dit het eerste dat weer telt; nu nog niets om te melden of te toetsen.

- [2026-08-31] ✅ **Geen relevante API-wijzigingen deze week (24–31 aug).** *Patch 12.1.0/API
  changes* niet ververst binnen 7 dagen: laatste gedateerde PTR-sectie nog steeds **2026-08-04
  (PTR 8, Build 69111)** (opgehaalde pagina, TOC-regel 154 + Build-regel 515), geconsolideerde
  diff nog "12.0.7 (68256) → 12.1.0 (69283) **Aug 11 2026**" (regel 531) — beide ruim buiten het
  venster. `Patch_12.1.5/API_changes` bestaat nog steeds niet (redlink "page does not exist",
  regel 140); `Patch_12.2.0` evenmin. Hotfixes: nieuwste gepubliceerde lijst is nog steeds
  **27 aug 2026** (article 24296142, al gedekt in de 28-aug-regel); géén lijst van 28/29/30/31 aug.
  Blizzard US UI-and-Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen
  (resultaten enkel oude threads 2022–2024 + Wowpedia *Secure Execution and Tainting*, laatst
  bewerkt **29 jul 2026** — buiten venster). 12.1.5 PTR nog altijd zónder client-build en dus
  zonder datamining; het "op de Battle.net-launcher"-bericht blijft ~13 aug (buiten venster). Bron:
  warcraft.wiki.gg/Patch_12.1.0/API_changes; news.blizzard.com/article/24296142;
  us.forums.blizzard.com UI-and-Macro. **[RAAKT ONS NIET]** niets nieuws te toetsen. Geen open
  actiepunt aan de addon-/API-kant; de staande 12.1.0-items (C_UnitAuras secret-reads,
  `GetNextWaypointForMap`→`C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op
  AuraButtons, `GetWeaponEnchantInfo`) staan hierboven (18–28 aug) en zijn ongewijzigd afgedekt.

- [2026-09-01] ✅ **Geen relevante API-wijzigingen deze week (25 aug–1 sep).** *Patch 12.1.0/API
  changes* niet ververst binnen 7 dagen: laatste gedateerde PTR-sectie nog steeds 2026-08-04
  (PTR 8, Build 69111); geconsolideerde diff nog "12.0.7 → 12.1.0, 11 aug 2026" — beide buiten het
  venster. `Patch_12.1.1`/`12.1.2`/`12.1.5`/`12.2.0` API-changes-pagina's bestaan nog steeds niet
  (websearch 1 sep). Hotfixes: nieuwste gepubliceerde lijst is **27 aug 2026** (article 24296142);
  de enige UI-regel daarin is content — "Groups for the Housewarming housing quest are now found in
  the Questing section of the Premade Group Finder" (26 aug) — geen API-/secure-/taint-item. Géén
  hotfixlijst van 28 aug–1 sep. Blizzard US UI-and-Macro-forum: geen nieuwe API-/taint-/secure-
  frame-thread binnen 7 dagen (websearch gaf enkel oude threads 2022–2026-02 + Wowpedia *Secure
  Execution and Tainting*, buiten venster). 12.1.5 PTR nog altijd zónder client-build en dus zonder
  datamining. Bron: warcraft.wiki.gg/Patch_12.1.0/API_changes; news.blizzard.com/article/24296142
  (hotfixes 26–27 aug); us.forums.blizzard.com UI-and-Macro. **[RAAKT ONS NIET]** niets nieuws te
  toetsen. Geen open actiepunt aan de addon-/API-kant; de staande 12.1.0-items hierboven zijn
  ongewijzigd afgedekt.

- [2026-09-02] ✅ **Geen relevante API-wijzigingen deze week (26 aug–2 sep).** *Patch 12.1.0/API
  changes* niet ververst binnen 7 dagen: laatste gedateerde PTR-sectie nog steeds **2026-08-04
  (PTR 8, Build 69111)**, geconsolideerde diff nog "12.0.7 (68256) → 12.1.0 (69283) **Aug 11
  2026**" — beide ruim buiten het venster (geverifieerd op de opgehaalde pagina, TOC t/m regel 154
  + Consolidated-regel 531). `Category:API_patch_changes` opgehaald: nieuwste bestaande pagina is
  nog steeds **Patch 12.1.0**; `12.1.1`/`12.1.2`/`12.1.5`/`12.2.0` bestaan niet. Blizzard US
  UI-and-Macro-forum: geen nieuwe API-/taint-/secure-frame-thread binnen 7 dagen (websearch enkel
  oude threads 2022–2024 + Wowpedia *Secure Execution and Tainting*, buiten venster). 12.1.5 PTR
  nog altijd zónder client-build/datamining. Bron: warcraft.wiki.gg/Patch_12.1.0/API_changes +
  Category:API_patch_changes; news.blizzard.com/article/24296142; us.forums.blizzard.com
  UI-and-Macro. **[RAAKT ONS NIET]** niets nieuws te toetsen. Positieve controle van de grep in
  dezelfde run: `C_UnitAuras` (8 bestanden), `issecretvalue` (41 bestanden),
  `C_Navigation.GetNextWaypointForMap` (EventProbe.lua:120/133) vinden zoals verwacht treffers, dus
  een leeg nieuw-item-resultaat is echt leeg en geen kapotte grep. Geen open actiepunt; de staande
  12.1.0-items (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
  AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`) zijn
  ongewijzigd afgedekt.

- [2026-09-02] 📌 **CORRECTIE op de 1-sep-regel: er zijn wél nieuwe hotfixes (31 aug + 1 sep), maar
  géén ervan raakt de API-/addon-kant.** De regel van 1 sep meldde "nieuwste gepubliceerde lijst is
  27 aug" en "géén hotfixlijst van 28 aug–1 sep". Dat is inmiddels achterhaald: het rollende artikel
  24296142 draagt nu **Hotfixes: September 1, 2026** met dagsecties voor 1 sep én 31 aug. Beide
  volledig gelezen — enkel Classes/Delves/Dungeons&Raids/Items/PvP/Quests/Omnium Folio. De enige
  "User Interface"-regel is de **31-aug**-content: "Groups for the Housewarming housing quest are now
  found in the Questing section of the Premade Group Finder (was the Custom section)" — een
  group-finder-categorie, geen Lua-API-, secure-frame- of taint-wijziging. "Tainted Strike"/"Defiling
  Taint" (Avatar-encounter) zijn ability-/debuff-namen, geen Lua-`taint`. Bron:
  news.blizzard.com/article/24296142 (hotfixes 31 aug + 1 sep 2026). **[RAAKT ONS NIET]** niets te
  toetsen aan de addon-kant.

- [2026-09-02] ✅ **Geen relevante API-wijzigingen (26 aug–2 sep).** Derde regel van vandaag: dit is
  de eerste run van deze wachter *in de cloud* (05:30-schema), naast de twee regels die er vanochtend
  al stonden. Wat er nieuw in zit, is de meetmethode en vier nooit eerder getoetste 12.1.0-items —
  géén nieuws.
  - **GEMETEN, revisiegeschiedenis i.p.v. paginatekst.** `warcraft.wiki.gg/api.php?action=query&`
    `prop=revisions&titles=Patch 12.1.0/API changes` geeft als laatste bewerking
    **2026-08-15T09:07:23Z** (Ketho, `/* Global API */`); daarvóór 13 aug 16:53 `/* Events */` en
    13 aug 15:24 `/* Consolidated changes */ 12.1.0 (69283)`. Dat is **18 dagen oud**, ruim buiten
    het venster. Dit is harder én goedkoper dan de tekstlezing van de vorige dagen: de pagina zégt
    zelf wanneer ze voor het laatst veranderde. Aanbevolen voor volgende runs.
  - **GEMETEN: geen nieuwere API-changes-pagina.** `list=allpages&apprefix=Patch 12.` geeft 19
    pagina's; de nieuwste `/API changes` is nog steeds **Patch 12.1.0** (pageid 679840).
    `Patch 12.1.5` (664848) en `Patch 12.1.7` (664849) bestaan wél als patch-stub, maar zónder
    `/API changes`-subpagina. *AFGELEID, niet gemeten:* hun pageids liggen naast die van
    `Patch 12.1.0` (664847), dus het zijn vermoedelijk oude stubs en geen nieuws — de inhoud van
    12.1.7 is hoe dan ook PTR-wachter-terrein, niet het mijne.
  - **Hotfixes:** artikel 24296142 draagt nog steeds **Hotfixes: September 1, 2026** en de nieuwste
    dagsectie is 1 sep (volledig gelezen: Classes/Delves/Dungeons&Raids/Items/PvP). Géén 2-sep-lijst.
    Al afgehandeld in de correctie-regel hierboven; niet herhaald.
  - **Blizzard US UI-and-Macro-forum:** categorie-JSON (`/c/guides/ui-macro/35/l/latest.json`)
    gelezen. Binnen 7 dagen enkel spelerstopics: *Flag Carrier Orb Carrier Frame* (2 sep),
    *ATT and ToolTip Integration* (1 sep), *Macro that ignores Mouseover Cast setting* (1 sep),
    *UI Feedback: … Hide Icon on the CDM* (1 sep), *I need a new unit frames addon* (gebumpt 1 sep),
    *Is there already a WeakAuras replacement with the 12.1 API changes?* (gebumpt 31 aug).
    **Geen blue post**: de enige topics met `community-manager`-flair zijn de vastgezette uit 2018,
    en de laatste post in *UI Add-On Development Policy* (28 aug 19:54 UTC) is van een speler
    (Atheren, trust_level 2), niet van Blizzard.
  - 🔴 **Methodewaarschuwing — bijna in de RINGOFGLORY-val gelopen.** Mijn eerste forumzoekopdracht
    (`search.json?q=#guides-ui-macro after:2026-08-25`) gaf **0 posts**. De positieve controle met
    dezelfde slug over een venster van twee maanden gaf óók 0 → de slug was fout. Met `#ui-macro`
    vindt precies dezelfde query wél posts. Was ik bij het eerste lege resultaat gestopt, dan had
    hier "geen forumactiviteit" gestaan terwijl er zes topics liepen.
  - ⚠️ **Egress:** WebFetch is vandaag geblokkeerd voor warcraft.wiki.gg, news.blizzard.com,
    worldofwarcraft.blizzard.com, wowhead.com, us.forums.blizzard.com én danderbot.github.io. Alle
    metingen hierboven liepen via de **Exa-connector** (`web_fetch_exa`), die deze domeinen wél
    bereikt. Dus: gelezen op de bron zelf, niet "via search". Volgende run: meteen Exa gebruiken.
  - **Vier 12.1.0-notities die dit logboek nooit had getoetst** (geen nieuws — een gat in de
    dekking, vandaag gedicht):
    - `CanAccessObject` → `FrameScriptObject:CanBeAccessedInContext` — **[RAAKT ONS NIET]**, 0 treffers.
    - `VectorGraphics` / SVG-textures — **[RAAKT ONS NIET]**, 0 treffers (ook `.svg` niet).
    - De `[Bootstrap]`-TOC-directive voor Load-on-Demand — **[RAAKT ONS NIET]**, 0 treffers in de `.toc`.
    - `C_Roleset.ApplyRolesetFilters` + `Frame:SetOnUpdateMode` — **[AL AFGEDEKT]**: uitsluitend in
      `Modules/ApiProbe.lua`, en daar achter `if type(C_Roleset) == "table"` (regel 41 en 177) met
      `pcall` om elke aanroep (regel 180); `SetOnUpdateMode` wordt alleen op *bestaan* bevraagd
      (`probe[m]`, regel 372/374) en nooit aangeroepen. Geen productiegebruik.
    - *AFGELEID, niet gemeten:* onze 28 `OnUpdate`-handlers in 18 bestanden blijven werken omdat de
      blue post `RunWhenVisible` de **default** noemt. Dat is een citaat uit die post, niet iets dat
      ik in de client heb gemeten.
  - **Positieve controle in dezelfde run:** dezelfde grep die 0 treffers gaf voor `CanAccessObject`
    en `getglobal` vond wél `LoadAddOnWithErrorHandling` (`Core.lua:79`), en de tweede grep
    (`C_UnitAuras|issecretvalue|GetNextWaypointForMap|C_Navigation|AuraContainer|AuraButton`) gaf
    130 treffers in 44 bestanden. De lege uitkomsten zijn dus echt leeg en geen kapotte grep.
  - **0 × [MOET GEFIKST].** Geen open actiepunt aan de addon-/API-kant; de staande 12.1.0-items
    (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`, AuraContainer/AuraButton,
    `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`) zijn ongewijzigd afgedekt.

- [2026-09-03] ✅ **Geen relevante API-wijzigingen (27 aug–3 sep).** Niets gevonden dat de code
  raakt; **0 × [MOET GEFIKST]**. Wat er wél in zit is één methodefout die deze run bijna had
  laten liegen — zie het rode punt onderaan.
  - 🔴 **METHODE — Exa serveert een VEROUDERDE KOPIE, en dat is niet te zien aan de uitvoer.**
    Mijn eerste `web_fetch_exa` op `news.blizzard.com/en-us/article/24296142` gaf een pagina met
    als titel **"Hotfixes: August 27, 2026"** en als nieuwste dagsectie 27 aug. Diezelfde fetch op
    de forum-JSON gaf een lijst waarvan het nieuwste niet-vastgezette topic op **27 aug** stond.
    Beide zijn **ouder dan wat de run van gisteren al gelezen had** (die zag 1 sep-hotfixes en
    topics van 1–2 sep) — dus geen "er is niets bijgekomen", maar een cache van ~een week oud.
    **De oplossing: hang een uniek query-argument aan de URL** (`?nocache=20260903`). Dezelfde
    twee URL's gaven daarmee onmiddellijk **"Hotfixes: September 2, 2026"** en forumtopics van
    2 en 3 sep. ⚠️ Zonder dat had hier gestaan "niets sinds 27 aug", terwijl er 2-sep-hotfixes én
    twee nieuwe forumtopics waren. Dit is dezelfde soort fout als de RINGOFGLORY-val: een leeg/oud
    resultaat dat er gezond uitziet. **Volgende runs: ALTIJD een cache-buster achter elke Exa-URL.**
    📌 `WebFetch` blijft geen alternatief — `us.forums.blizzard.com` gaf vandaag opnieuw
    `EGRESS_BLOCKED`.
  - **GEMETEN — wiki, revisiegeschiedenis.** `Patch 12.1.0/API changes` (pageid 679840) staat nog
    steeds op **2026-08-15T09:07:23Z** (Ketho, `/* Global API */`), ongewijzigd t.o.v. gisteren en
    **19 dagen oud**: ruim buiten het 7-dagenvenster.
  - **GEMETEN — geen nieuwere API-changes-pagina.** `list=allpages&apprefix=Patch 12.` geeft
    onveranderd **19 pagina's**; de nieuwste `/API changes` is nog altijd 12.1.0. `Patch 12.1.5`
    en `Patch 12.1.7` bestaan als stub **zonder** `/API changes`-subpagina.
  - **NIEUWE METING — `list=recentchanges` (ns 0, 27 aug → nu) i.p.v. alleen de patchpagina.**
    Dit vangt API-documentatie die *buiten* de patchpagina wordt bijgewerkt. Binnen het venster
    zijn precies **vijf** API-pagina's aangeraakt, alle door Ketho:
    `Structure CalendarTime`, `Structure ConduitCollectionData`, `Structure AppearanceSourceInfo`,
    `Structure TraitOutEdgeInfo` (3 sep) en `Enum.UIWidgetScale` (2 sep).
    **Drie diffs zelf gelezen** (`action=compare&torelative=prev`): het is een
    **sjabloonmigratie**, geen API-wijziging — `<font color="green">10.2.6</font>` wordt
    `{{apiname.added|10.2.6}}`, en het enum-type verhuist van de typekolom naar de omschrijving
    (`{{apitype|Enum.TraitEdgeType}}` → `{{apitype|number}}` + `[[Enum.TraitEdgeType]]`).
    **[RAAKT ONS NIET]** — geen veldnaam, signature of gedrag veranderd.
    *Niet gemeten:* de diffs van `CalendarTime` en `ConduitCollectionData` heb ik niet opgehaald;
    ze passen in hetzelfde patroon maar dat is **afgeleid**. Wij gebruiken geen `C_Calendar` en
    geen conduit-API (grep: 0 treffers).
    ⚠️ Voor wie dit nadoet: de wiki-API weigert `rvlimit` bij meerdere `titles` tegelijk
    (`invalidparammix`) — één titel per query.
  - **[AL AFGEDEKT] voor de twee namespaces die deze wiki-pagina's beschrijven**, mocht daar ooit
    wél iets veranderen: elke `C_Traits`-aanroep zit achter een bestaanscontrole *en* een `pcall`
    — `Modules/DelveCuriosAdvisor.lua:137` en `:143` (`if not C_Traits.GetConfigIDByTreeID or not
    C_Traits.GetNodeInfo ... then return`), `:1125`, en `Modules/ProfessionAcademy.lua:592`, `:607`,
    `:615`, `:1037`, `:1187`. `C_UIWidgetManager` idem in `Modules/Knowledge.lua:401` en `:414`.
  - **Hotfixes (na cache-buster gelezen): nieuwste sectie is 2 september 2026.** Volledig gelezen:
    Classes (Druid/Warlock/Warrior), Dungeons and Raids (Ula'tek), Items (Catalyst),
    Player versus Player. **Geen Lua-API-, secure-frame-, taint- of addon-sectie.**
    Eén UI-nabije regel, letterlijk: *"Bladestorm now displays as an important aura on
    nameplates."* Dat is een **vlag op spell-data**, geen API-wijziging. **[RAAKT ONS NIET]:**
    onze enige nameplate-code is `C_NamePlate` in `Modules/Rares.lua:598`, `:601`, `:608`, `:611`,
    `:619`, `:625`, allemaal achter `if ... and C_NamePlate and C_NamePlate.Get... then`; wij
    lezen geen `nameplateShowAll`/`nameplateShowPersonal` (0 treffers).
  - **`Patch 12.1.0 (undocumented changes)`** is 3 sep 00:35 bewerkt, commentaar `/* Items */` —
    inhoud, geen API. Valt bovendien onder de contentwachter, niet onder mij.
  - **Blizzard US UI-and-Macro-forum, vers opgehaald.** Nieuw binnen het venster en nog niet in dit
    logboek: *Addons api restrictions* (2 sep, 9 posts) en *Details! issues since early this week*
    (3 sep). Het eerste topic heb ik **helemaal gelezen**: een speler (Jazzmend, trust_level 0)
    vraagt om live performance-tracking; de antwoorden komen van Elvenbane en Fizzlemizz, beide
    trust_level 2. **Geen blue post, geen nieuw feit** — alleen de bekende speleruitleg dat
    Blizzard live-aansturing niet meer wil. De overige topics binnen 7 dagen (*Flag Carrier Orb
    Carrier Frame*, *ATT and ToolTip Integration*, *Macro that ignores Mouseover Cast setting*,
    *UI Feedback: … CDM*, *WeakAuras replacement*, *Wrong colors for nameplates*, *Addon API:
    Rendering Cached Offline Player Models*) stonden er gisteren al of zijn spelersvragen.
    **Geen enkele `community-manager`-post in de categorie binnen 7 dagen**; de laatste post in
    *UI Add-On Development Policy* is nog steeds 28 aug 19:54 UTC van Atheren (trust_level 2).
  - **Positieve controle in dezelfde run.** De grep-alternatie
    `nameplateShowAll|nameplateShowPersonal|isBossAura|isHarmful|C_NamePlate` gaf 0 treffers voor
    de eerste vier maar **wél 6 voor `C_NamePlate`**; de tweede
    (`TraitOutEdgeInfo|GetNodeInfo|C_Traits|AppearanceSourceInfo|C_Calendar|UIWidget|ConduitCollection`)
    gaf 40+ treffers met `C_Traits`/`C_UIWidgetManager` erin en **0** voor `C_Calendar`,
    `ConduitCollection` en `AppearanceSourceInfo`. De lege uitkomsten zijn dus echt leeg.
  - **0 × [MOET GEFIKST].** De staande 12.1.0-items (C_UnitAuras secret-reads,
    `GetNextWaypointForMap`→`C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution`
    op AuraButtons, `GetWeaponEnchantInfo`) zijn niet opnieuw getoetst en blijven staan zoals op
    2 sep gemeten — geen nieuwe informatie erover deze week.

- [2026-09-04] 🔴 **`Patch 12.1.5/API changes` is vannacht aangemaakt — 118 toevoegingen, 16
  verwijderingen, build 69594.** Voor het eerst sinds 15 aug is er een nieuwe API-changes-pagina.
  📌 **CORRECTIE op de regel van gisteren.** Die zei: *"`Patch 12.1.5` en `Patch 12.1.7` bestaan als
  stub **zonder** `/API changes`-subpagina."* Dat klopte op 3 sep en klopt vandaag niet meer:
  pageid **705933**, aangemaakt **2026-09-04T02:41:48Z** door Ketho, bron een blue post van
  **3 sep** ("Midnight 12.1.5 PTR Changes 1", build **69594**). 12.1.7 is nog wél een lege stub.
  **GEMETEN:** de wikitext van de pagina zelf gelezen (`prop=revisions&rvprop=content`), geen
  samenvatting en geen zoekresultaat.
  ⚠️ **12.1.5 is PTR, niet live.** De addon draait op 12.1.0 (`## Interface: 120007, 120100`), dus
  hieronder breekt vandaag niets bij Rob. **0 × [MOET GEFIKST].** Dit is de lijst om vóór
  12.1.5-live langs te lopen, niet vanochtend.
  - **Tellingen, GEMETEN uit de tabellen zelf:** Global API +75 / −1 · FrameXML +10 / −15 ·
    ScriptObjects +30 · Widgets +2 · Events +1 (`WEATHER_CHANGED`) · CVars +6.
  - **[RAAKT ONS NIET] — de 15 verwijderde FrameXML-globals.** `Clamp`, `CountTable`,
    `GetKeysArray`, `GetValuesArray`, `Lerp`, `RoundToSignificantDigits`, `Round`, `Saturate`,
    `Sign`, `StringContains`, `TableIsEmpty`, `tContains`, `tDeleteItem`, `tIndexOf`,
    `tUnorderedRemove` verhuizen van Lua naar native code; op één na staan ze allemaal wéér in de
    Global-API-Added-lijst, dus met alias. Grep over de addon: **0 treffers voor alle vijftien**, en
    ook 0 voor `C_TableUtil` — dat is de énige verwijderde global (`C_TableUtil.FindIndexedMismatch`).
    ⚠️ **De uitzondering is `StringContains`: die staat wél bij Removed en NIET bij Added**, terwijl
    de blue post letterlijk zegt *"aliases for the existing names have been retained to prevent addon
    breakage"*. Dat is een tegenspraak binnen dezelfde bron. Ik weet niet welke van de twee klopt en
    verzin geen migratie; de nieuwe naam is `string.contains`. Voor ons maakt het niets uit (0
    treffers), maar wie het elders leest moet dit weten.
  - **[AL AFGEDEKT] — CustomAuraContainer / CustomAuraButton, mét een breaking signature-wijziging.**
    `AddDispelTypeTexture` en `AddPandemicRegion` geven **geen index meer terug**, en
    `RemoveDispelTypeTexture`/`RemovePandemicRegion` nemen nu een **region-referentie** in plaats van
    een index; dezelfde region twee keer toevoegen gooit voortaan een error. **Wij gebruiken die vier
    nergens** (0 treffers). Onze enige container staat op `Modules/PartyTargets.lua:326`
    (`pcall(CreateFrame, "AuraContainer", nil, panel, "CustomAuraContainerTemplate")`) en gebruikt
    alleen `SetUnit`/`AddAuraSlot`/`SetEnabled`/`UpdateAllAuras` — alle drie de eerste achter een
    expliciete bestaanscontrole op `:347` en stuk voor stuk in een `pcall`. Nieuw en optioneel
    (`SetCasterName`, `minApplications` in `SetApplicationBar`, `SetAuraGroupEnabled`,
    `SetAuraSlotEnabled`, `SetItemEnchantmentEnabled`, `SetEditModePreviewEnabled`): 0 treffers.
  - **[AL AFGEDEKT] — *"SetCooldown en Clear kunnen niet meer vanuit tainted code als het
    cooldown-frame zelf protected is."*** Onze enige `SetCooldown` staat op
    `Modules/CombatSafety.lua:701`, op `f._cd`, en dát frame maken we zelf:
    `CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")` op `:184`. Een eigen frame is niet
    protected, dus de nieuwe regel raakt het niet. `SetCooldownFromDurationObject` (`:598-601`) zit
    bovendien in een `pcall`.
  - **[AL AFGEDEKT] — castbar-ID's zijn nu uniek per unit-token.** Blizzard waarschuwt dat addons ze
    niet meer kunnen gebruiken om units te vergelijken, én dat **hoofdletters meetellen**: een
    `UnitCastingInfo`-query op `"PLAYER"` geeft een andere castbar-ID dan op `"player"`.
    `Modules/ActionPrompt.lua:262` en `:270` lezen de ID uitsluitend als *aanwezigheidstest*
    ("cast er iets?" — `:277`), op één enkel token, en dat token is `"target"` in kleine letters.
    Grep op hoofdletter-tokens over de hele addon: **0 treffers**.
  - **[RAAKT ONS NIET] — de nieuwe namespaces en helpers.** `C_Weather` (+ event `WEATHER_CHANGED`),
    `C_Intl` (29 functies voor Unicode/i18n), `CreateFrameWithOptions`, `TimedSignalMap` +
    `C_Timer.NewTimedSignalMap`, `ScriptRegion:SetRoundLayoutToNearestPixel`,
    `PixelUtil.SetRoundLayoutToNearestPixelRecursively`, `C_UnitAuras.GetAuraCasterGUID`,
    `GetScriptBucketThrottleLimits`: allemaal toevoegingen, geen ervan in gebruik (0 treffers op
    `C_Weather`, `C_Intl`, `PixelUtil`, `EnumerateFrames`, `GetScriptBucketThrottleLimits`).
  - **[RAAKT ONS NIET] — de tooltip-wijzigingen.** M+ enemy-forces-regels krijgen een eigen
    lijntype `Enum.TooltipDataLineType.UnitCriteriaProgress`, en aura-tooltips kunnen de caster
    tonen (nieuwe CVar `tooltipShowAuraCasterNames`, default 0). Onze ~30 `C_TooltipInfo`-aanroepen
    zijn allemaal item/POI/hyperlink (`GetInventoryItem`, `GetItemByID`, `GetBagItem`,
    `GetHyperlink`, `GetAreaPOIInfo`) — géén unit-aura's en géén scenario-criteria.
    `TooltipDataLineType` en `UnitCriteriaProgress` komen nergens in de addon voor.
  - ⚠️ **[AL AFGEDEKT, mét één open vraag] — tien `Blizzard_Deprecated*`-addons worden verwijderd:**
    CurrencyScript, Glue, ItemScript, ItemSocketInfo, LFG, PetInfo, PvpScript, SoundScript,
    TradeInfo, WorldElapsedTimerTypes. Wij hebben **0 treffers op `Blizzard_Deprecated`** in de Lua
    én in de `.toc`, en geen `RequiredDeps`/`OptionalDeps`. Onze eigen aantekening
    (`docs/SESSION_NOTES.md:3731`) zegt dat de oude global `SendChatMessage` op 12.x via
    **Blizzard_DeprecatedChatInfo** loopt — die staat **niet** in de verwijderlijst, en we roepen
    sowieso eerst `C_ChatInfo.SendChatMessage` aan met de global alleen als fallback
    (`Modules/Comms.lua:72-75` en `:136-139`).
    🔴 **NIET GEMETEN, en dit is het enige punt dat 12.1.5-live nog kan bijten:** wélke functies er
    precies ín die tien addons zitten. Ik heb `wow-ui-source` niet gelezen en de consolidated-tabel
    noemt maar één verwijderde global, dus de tabel dekt dit misschien niet. De kandidaat die
    opvalt is de kale global **`SocketInventoryItem`** (`Modules/GearEnchantCheck.lua:886-891`, ook
    genoemd op `:419`) — de naam lijkt op `Blizzard_DeprecatedItemSocketInfo`, maar dat is
    **AFGELEID uit de naam, niet gecontroleerd**. Hij is wél afgedekt tegen een Lua-fout:
    `if not slotId or not SocketInventoryItem then return end` gevolgd door `pcall`. Het gevolg zou
    dus geen error zijn maar een **knop die stil niets doet** — precies het patroon dat Rob op 3 sep
    aanwees ("zet de uitleg in dezelfde kamer als de knop"). Te settelen met één `/dump
    SocketInventoryItem` in de 12.1.5-PTR-client; niet met een gok.
  - **Positieve controle in dezelfde run.** De alternatie
    `StringContains|CountTable|tContains|tIndexOf|C_TableUtil|CreateFrame|InCombatLockdown` gaf
    **770 treffers in 134 bestanden** — allemaal van `CreateFrame`/`InCombatLockdown`, de vijf
    andere termen nul. Idem bij de unit-tokens: de hoofdletter-variant gaf 0, dezelfde patroonvorm
    met `"player"|"target"` erbij gaf **334 treffers in 84 bestanden**. De lege uitkomsten hierboven
    zijn dus echt leeg en geen kapotte grep.

- [2026-09-04] ✅ **Hotfixes en forum: niets voor de API-kant.**
  - **Hotfixes, nieuwste sectie 3 september 2026** — één dag nieuwer dan wat hier gisteren stond,
    dus geen cache. Volledig gelezen: Achievements, Classes (Priest/Shaman), Dungeons and Raids
    (Ruby Life Pools, The Venomous Abyss), Items, Quests. **Geen Lua-API-, secure-frame-, taint- of
    addon-sectie.** Niets erin raakt code; de inhoudelijke kant is voor de contentwachter.
  - **Blizzard US UI-and-Macro-forum, vers opgehaald.** De nieuwste topics zijn *Details! issues
    since early this week* (3 sep) en *Addons api restrictions* (2 sep) — **beide stonden gisteren al
    in dit logboek**. Niets nieuws binnen het venster, en **geen enkele `community-manager`-post in
    de categorie binnen 7 dagen**: de laatste post in *UI Add-On Development Policy* is onveranderd
    28 aug 19:54 UTC van Atheren (trust_level 2).
  - **De 12.1.0-pagina staat stil.** `Patch 12.1.0/API changes` (pageid 679840) nog altijd
    `2026-08-15T09:07:23Z` (Ketho, `/* Global API */`) — 20 dagen oud, ruim buiten het venster.
  - 📌 **METHODE, voor de volgende run: de cache-buster werkt, maar de wiki klaagt erover.** Elke
    `nocache=`-URL levert er `{"warnings":{"main":{"*":"Unrecognized parameter: nocache."}}}` bij.
    Dat is **geen fout**: MediaWiki negeert het argument en Exa ziet een andere URL. Niet
    "repareren" door hem weg te laten — vandaag bewees hij zich meteen, want de recentchanges-query
    mét buster gaf wijzigingen van 4 sep 03:23 UTC, nog geen half uur oud.
  - **De staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`)
    zijn deze run niet opnieuw getoetst en blijven staan zoals op 2 sep gemeten.

- [2026-09-05] 🔴 **[MOET GEFIKST] — `GetItemCooldown` verdwijnt in 12.1.5 en wij roepen hem drie
  keer KAAL aan.** De 12.1.5-pagina heeft vannacht een sectie **Deprecated API** gekregen (8 edits
  van Ketho tussen **2026-09-05T00:55:48Z** en **01:16:17Z**, revids 6860171→6860177) en die
  beantwoordt precies de open vraag die hier gisteren stond: *wélke functies zitten er ín de tien
  `Blizzard_Deprecated*`-addons die 12.1.5 verwijdert.* **GEMETEN:** de diff zelf gelezen via
  `action=compare&fromrev=6859839&torev=6860177`, geen samenvatting en geen zoekresultaat.
  ⚠️ **12.1.5 is PTR, niet live.** De addon draait op 12.1.0, dus dit breekt vandaag niets bij Rob.
  Het is het enige punt uit deze hele wachterreeks dat op 12.1.5-live wél een Lua-fout geeft.
  - 🔴 **De drie kale aanroepen.** `Modules/Delves.lua:1518`, `Modules/Delves.lua:1686` (beide
    `local hsStartTime = GetItemCooldown(6948)` — hearthstone-cooldown in het reis-popup) en
    `Modules/DelveItemsPopup.lua:275` (`local start, duration, enabled = GetItemCooldown(itemID)`).
    Geen van de drie heeft een `if`-guard, een `or`-fallback of een `pcall`. Verdwijnt de global,
    dan is dit "attempt to call a nil value", niet stil-niets-doen.
    📌 **De migratie is GECITEERD, niet verzonnen:** de bron schrijft letterlijk
    `GetItemCooldown = C_Item.GetItemCooldown`. Ik heb `C_Item.GetItemCooldown` niet in een client
    geverifieerd; dat is één `/dump` waard voor er iets verandert.
    ⚠️ `DelveItemsPopup.lua:270-302` heeft ná die regel wél een complete `C_Container`-terugval,
    maar die wordt nooit bereikt omdat de fout op `:275` valt. Een fallback achter de crash is geen
    fallback.
  - **[AL AFGEDEKT] — de andere zeven ItemScript-globals die we gebruiken.** Allemaal `C_Item`
    eerst, kale global alleen als tweede tak: `GetItemInfo`/`GetItemQualityColor`/`GetItemIcon` in
    `Modules/GuideConsumables.lua:42-53`, `:59-70`, `:85-92`; `GetItemInfo`/`GetItemIcon` in
    `Modules/DelveCuriosData.lua:172-183` en `:192-203`; `GetItemCount` in
    `Modules/DelveItemsPopup.lua:589-608` (via `rawget(_G,…)` + `pcall`) en
    `Modules/DelveItemBrokers.lua:42-59`; `IsUsableItem` achter
    `if type(IsUsableItem) ~= "function"` op `Modules/DelveItemsPopup.lua:324`; `GetItemGem` achter
    `if not (link and GetItemGem)` op `Modules/GearEnchantCheck.lua:502`; `PickupItem` achter
    `C_Item.PickupItem` met `elseif PickupItem then` op `Modules/ApplyLayout.lua:1293-1297` en
    `:1588-1591`.
  - ⚠️ **Eén afdekking is schijn, GEMETEN maar géén API-bevinding.**
    `Modules/DelveItemBrokers.lua:42` is `local function GetItemCount(...)`, en de "global fallback"
    op `:52-53` roept daardoor **zichzelf** aan (Lua bindt de naam vóór de body). Hij zit in een
    `pcall`, dus het is geen crash maar een stack overflow die stil `0` teruggeeft. Raakt ons pas
    als `C_Item.GetItemCount` ooit wegvalt — die blijft. Melden, niet repareren.
  - ✅ **CORRECTIE/afgesloten: `SocketInventoryItem` zit NIET in `Blizzard_DeprecatedItemSocketInfo`.**
    Gisteren stond hier dat de naamgelijkenis verdacht was maar **AFGELEID uit de naam, niet
    gecontroleerd**. De nu gepubliceerde lijst voor dat addon telt dertien functies —
    `CloseSocketInfo`, `GetSocketItemInfo`, `GetNumSockets`, `GetExistingSocketInfo`,
    `GetExistingSocketLink`, `GetNewSocketInfo`, `GetNewSocketLink`, `ClickSocketButton`,
    `AcceptSockets`, `GetSocketTypes`, `GetSocketItemRefundable`, `GetSocketItemBoundTradeable`,
    `HasBoundGemProposed` — en `SocketInventoryItem` staat er niet tussen. Onze aanroep
    (`Modules/GearEnchantCheck.lua:886` + `pcall` op `:891`) en de probe in
    `Modules/PtrProbe.lua:111/138/673` blijven zoals ze zijn. **Wat deze bron niet zegt:** of de
    global ergens ánders vandaan komt; hij zegt alleen dát dit addon hem niet bevat.
  - **[RAAKT ONS NIET] — de overige acht deprecated addons, 0 treffers.** CurrencyScript
    (`GetCoinIcon`, `GetCoinText`, `GetCoinTextureString`), Glue (`IsOnGlueScreen`), ItemSocketInfo
    (13 namen, zie boven), LFG (`C_LFGInfo.IsPremadeGroupEnabled`,
    `C_LFGList.GetSearchResultMemberInfo`), PetInfo (`PetAssistMode`, `GetPetTalentTree`),
    PvpScript (`IsSubZonePVPPOI`, `GetZonePVPInfo`, `TogglePVP`, `SetPVP`), SoundScript
    (`PlayVocalErrorSoundID`), TradeInfo (`PickupTradeMoney`). Ons enige `C_LFGInfo`-gebruik is
    `IsInLFGFollowerDungeon`, achter een guard + `pcall` op `Modules/DungeonBossWindow.lua:1588` en
    `Modules/Retrospective.lua:220`.
    ⚠️ **De sectie dekt negen van de tien addons.** `Blizzard_DeprecatedWorldElapsedTimerTypes`
    heeft géén functielijst gekregen. Ik weet niet of dat betekent "bevat geen globals" of "nog niet
    ingevuld"; niet aannemen dat het leeg is.
  - **Positieve controle in dezelfde run.** De patroonvorm `(^|[^.\w])(…)\s*\(` gaf voor de 25
    namen van de acht andere addons **0** treffers; dezelfde alternatie mét `InCombatLockdown`
    erbij gaf **118 treffers in 38 bestanden**. De lege uitkomst is dus echt leeg. En de
    ItemScript-alternatie (45 namen) gaf 35 treffers in 8 bestanden — dat patroon vindt wél wat er
    is. ⚠️ Let op: `SocketInventoryItem` gaf 0 op dít patroon omdat wij hem via `pcall` aanroepen
    en niet met een haakje erachter; een losse grep vond hem wél op vijf plaatsen.

- [2026-09-05] ⚠️ **`Patch 12.1.0/API changes` is voor het eerst sinds 15 aug bijgewerkt — build
  69283 → 69587.** Revid 6860164, **2026-09-05T00:39:06Z**, Ketho, samenvatting `12.1.0 (69587)`.
  De consolidated-regel luidt nu `12.0.7 (68256) → 12.1.0 (69587) Aug 27 2026` (was `69283 Aug 11
  2026`). **GEMETEN uit de diff:** de hele wijziging is **twee toegevoegde** Global API-regels en
  **niets verwijderds of gewijzigds**: `C_LFGInfo.IsInMatchmadeRaidWithoutRoleRequirements` en
  `UnitIsPlayerControlledOrGroupMember`. **[RAAKT ONS NIET]** — 0 treffers op beide (positieve
  controle: `C_LFGInfo` zelf geeft wél 4 treffers, zie hierboven).
  📌 Dit is de pagina van de patch waarop Rob nú speelt. Dat hij na drie weken stilstand beweegt is
  het opmerkelijke; de inhoud van deze ene bewerking is dat niet.

- [2026-09-05] ✅ **Hotfixes en forum: niets voor de API-kant.**
  - **Hotfixes, nieuwste sectie 4 september 2026** — één dag nieuwer dan wat hier gisteren stond,
    dus geen cache. Volledig gelezen: Classes (Druid Balance, Shaman Enhancement), Dungeons and
    Raid (The Venomous Abyss), Housing (Vacation Season), Items. **Geen Lua-API-, secure-frame-,
    taint- of addon-sectie.** De enige regel die een addon-woord bevat — *"Stellar Amplification can
    now be tracked in the Cooldown Manager"* — is spell-data, geen API; die hoort bij de
    contentwachter.
  - **Blizzard US UI-and-Macro-forum, vers opgehaald.** Nieuwste topics: *Cast bar addon?* (4 sep,
    spelersvraag) en *Details! issues since early this week* (3 sep, stond hier gisteren al). Niets
    binnen het venster dat over de API gaat, en **geen enkele `community-manager`-post in de
    categorie binnen 7 dagen**: de laatste post in *UI Add-On Development Policy* is onveranderd
    **2026-08-28T19:54:53Z** van Atheren (trust_level 2).

- [2026-09-05] ✅ **Tweede run van vandaag — verificatiepas, niets nieuws sinds de drie 05-sep-regels
  hierboven.** De substantie van vandaag (de `GetItemCooldown`-`[MOET GEFIKST]`, de 12.1.0-bump naar
  build 69587, hotfixes t/m 4 sep + forum) stond er al; deze pas heeft die claims onafhankelijk
  hertoetst tegen de live bronnen en de code i.p.v. ze uit de eigen aantekening over te schrijven.
  Alles klopt en er is niets nieuwers. **0 × nieuw [MOET GEFIKST].**
  - **GEMETEN — geen cache-val.** Alle Exa-fetches mét `?nocache=20260905b/c/d`. `Patch 12.1.5/API
    changes` (pageid 705933): nieuwste revisie nog steeds **6860177, 2026-09-05T01:16:17Z**
    (`/* Deprecated API */`, Ketho) — identiek aan wat de eerste run vanochtend zag, dus geen oudere
    kopie teruggekregen. `Patch 12.1.0/API changes` (679840): nog steeds **6860164,
    2026-09-05T00:39:06Z** (`12.1.0 (69587)`). Hotfix-artikel 24296142: nieuwste sectie **4 sep 2026**
    (Druid/Shaman, Venomous Abyss, Housing, Items) — géén Lua-API-/secure-/taint-/addon-sectie; nog
    geen 5-sep-lijst. Deze drie zijn de nieuwste die de bron heeft, niet ouder dan het logboek gisteren
    — dus geen cache.
  - **GEMETEN — `list=recentchanges` (ns 0, cache-busted).** De 30 nieuwste ns-0-bewerkingen (t/m
    2026-09-05T05:52Z) raken **uitsluitend content**: items (PvP-insignia's), quests, NPC's,
    hotfix-archief. **Geen `/API changes`-, `Structure `- of `Enum.`-pagina** binnen de batch; het
    eerder deze week gemelde Structure-template-migratiepatroon (RAAKT ONS NIET) is niet verdergegaan.
  - **[MOET GEFIKST — carry-over, ONAFHANKELIJK HERMETEN, niet uit de aantekening geciteerd]**
    `GetItemCooldown` verdwijnt in 12.1.5 (Deprecated-API-sectie, migratie *gecitéérd*
    `GetItemCooldown = C_Item.GetItemCooldown`). Grep in de code vandaag: drie kale aanroepen zonder
    guard/fallback/pcall — `Modules/Delves.lua:1518`, `Modules/Delves.lua:1686` (`GetItemCooldown(6948)`)
    en `Modules/DelveItemsPopup.lua:275` (`local start, duration, enabled = GetItemCooldown(itemID)`,
    context :270-281 zelf gelezen: geen guard vóór de call). ⚠️ **12.1.5 is PTR; de addon draait op
    12.1.0 (`## Interface: 120007, 120100`), dus dit breekt vandaag niets bij Rob** — het is het punt
    om vóór 12.1.5-live langs te lopen. `C_Item.GetItemCooldown` is één `/dump` waard vóór er iets
    verandert; niet blind fixen.
  - **Forum, GEMETEN uit de topic-list.** Kaivax (`community-manager`) dook op in de deelnemerslijst,
    maar hij is enkel **OP van de vastgezette** topics (*UI Add-On Development Policy*, *Welcome*,
    *FAQ*); de laatste post in de Policy-thread is onveranderd **2026-08-28T19:54:53Z (Atheren,
    trust_level 2)**. Nieuwste niet-vastgezette topic is nog steeds *Cast bar addon?* (4 sep). **Geen
    blue post en geen nieuw API-topic binnen 7 dagen.** (Bijna-val ontweken: de eerste — op activiteit
    gesorteerde — respons zette een CM in de users-array; de op *created* gesorteerde respons deed dat
    niet, wat bevestigt dat het om een gebumpte oude thread ging, niet een nieuwe post.)
  - **Positieve controle in dezelfde run.** `grep GetItemCooldown` gaf de drie treffers hierboven
    (patroon vindt dus wél wat er is); de recentchanges-scan op `API changes`/`Structure`/`Enum.` gaf
    binnen het venster 0 — echt leeg, geen kapotte query.
  - **Staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`) deze
    run niet opnieuw getoetst; ongewijzigd afgedekt zoals op 2 sep gemeten. Bron:
    warcraft.wiki.gg/api.php (revisions + recentchanges); news.blizzard.com/article/24296142;
    us.forums.blizzard.com UI-and-Macro.
  - ✅ **[NAGEKOMEN, door de sessie i.p.v. door de wachter] Het `GetItemCooldown`-punt hierboven is
    diezelfde dag opgelost** (`0de3443`), ná de meting van deze run. Alle drie de plekken die de
    wachter noemt gaan nu door `ns.GetItemCooldownSafe` (`Delves.lua:341`): `C_Item.GetItemCooldown`
    eerst, dan de kale global, allebei in een `pcall`, en `nil` als geen van beide bestaat.
    ⚠️ **`C_Item.GetItemCooldown` is nog steeds NIET in een client gezien** — de migratie is
    geciteerd, niet gemeten. `C_Item` staat in `WATCH_TABLES` van `/mh ptr`, dus één run op de
    12.1.5-PTR settelt het.
    📌 Deze regel staat hier omdat de wachter zijn eigen bevinding niet kan afsluiten: hij meet de
    wereld, niet onze commits. Zonder deze aanvulling leest de ochtendronde morgen een openstaand
    `[MOET GEFIKST]` dat al af is — precies de val die CLAUDE.md beschrijft.
  - **NIET GEMETEN:** `bluetracker.gg` gaf `CRAWL_LIVECRAWL_TIMEOUT` en `wowhead.com/blue-tracker`
    kwam leeg terug. De hotfixes zijn daarom rechtstreeks van `news.blizzard.com` gelezen (mét
    `?nocache=20260905`), niet via een spiegel.
  - **De staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`)
    zijn deze run niet opnieuw getoetst en blijven staan zoals op 2 sep gemeten.

- [2026-09-06] ✅ **Geen relevante API-wijzigingen. De twee wiki-bewerkingen sinds gisteren zijn
  puur cosmetisch, en de open vraag van gisteren is dicht.** 0 × nieuw [MOET GEFIKST].
  - **GEMETEN uit de diffs zelf** (warcraft.wiki.gg/api.php `action=compare`, cache-busted), niet
    uit een samenvatting. `Patch 12.1.5/API changes` kreeg na wat de run van gisteren zag
    (revid 6860177) nog twee bewerkingen, allebei van Ketho:
    - **revid 6862510, 2026-09-05T13:08:59Z, `/* Deprecated API */`** — zet in de
      deprecated-tabel de tien addon-namen **vet** (`''' … '''`). **Geen enkele functienaam
      toegevoegd, verwijderd of gewijzigd**; de diff is regel voor regel dezelfde tekst met
      apostrofs eromheen.
    - **revid 6862562, 2026-09-05T15:10:35Z, `/* Blue posts */`** — repareert één kapotte link:
      `Blizzard_DeprecatedWorldElapsedTimerTypes` wees naar het **pad van
      `Blizzard_DeprecatedCurrencyScript`** en wijst nu naar
      `.../Blizzard_DeprecatedWorldElapsedTimerTypes/Deprecated_WorldElapsedTimerTypes.lua`.
      Ook hier geen inhoudelijke wijziging.
  - ✅ **AFGESLOTEN — de open vraag van gisteren over `Blizzard_DeprecatedWorldElapsedTimerTypes`.**
    Gisteren stond hier letterlijk *"Ik weet niet of dat betekent 'bevat geen globals' of 'nog niet
    ingevuld'; niet aannemen dat het leeg is."* Nu **GEMETEN** door het bestand zélf te lezen
    (`raw.githubusercontent.com/Gethe/wow-ui-source`, branch `12.1.0`, cache-busted): het bevat
    **nul functies**. Alleen drie constanten, achter
    `if not GetCVarBool("loadDeprecationFallbacks") then return end`:
    `LE_WORLD_ELAPSED_TIMER_TYPE_NONE`, `_CHALLENGE_MODE` en `_PROVING_GROUND`, gelijkgesteld aan
    `Enum.WorldElapsedTimerTypes.None/.ChallengeMode/.ProvingGround`.
    **[RAAKT ONS NIET]** — 0 treffers op die drie namen in de addon. Onze enige treffer op dit
    onderwerp is de **string** `"Blizzard_DeprecatedWorldElapsedTimerTypes"` in
    `Modules/PtrProbe.lua:120`, een lijst met addon-namen die de probe opsomt — geen aanroep.
    **Positieve controle in dezelfde run:** dezelfde alternatie mét `InCombatLockdown` erbij gaf
    **186** treffers, zonder die term **0**. De lege uitkomst is dus echt leeg.
  - **`Patch 12.1.0/API changes` onveranderd** — nieuwste revisie nog steeds **6860164,
    2026-09-05T00:39:06Z** (`12.1.0 (69587)`), dezelfde die gisteren gemeld is.
  - **Geen nieuwe `/API changes`-pagina.** Wiki-zoekopdracht `intitle:"API changes"` gesorteerd op
    aanmaakdatum: de nieuwste is nog steeds **12.1.5**; er bestaat nog geen 12.2.0-pagina.
  - **Hotfixes: nieuwste sectie nog steeds 4 september 2026** — er is nog geen 5- of 6-sep-lijst.
    Volledig gelezen: Classes (Druid Balance, Shaman Enhancement), Dungeons and Raid (The Venomous
    Abyss), Housing, Items. **Geen Lua-API-, secure-frame-, taint- of addon-sectie.**
    ⚠️ **Dit is even oud als wat hier gisteren stond, niet ouder** — dus geen cache-val, maar het
    bewijst niets op zichzelf, en daarom **onafhankelijk bevestigd via WebSearch**: die kent
    artikelen voor 1, 2, 3 en 4 sep en géén voor 5 sep.
  - **Blizzard US UI-and-Macro-forum: geen nieuw topic sinds 4 sep en geen blue post binnen 7
    dagen.** Op `order=created` opgehaald is *Cast bar addon?* (**2026-09-04T23:37:25Z**) nog steeds
    het nieuwste topic, en er staat **geen `community-manager`** in de deelnemerslijst van de
    categorie. Wel activiteit in *Addons api restrictions* (aangemaakt 2026-09-02, laatste post
    **2026-09-05T17:29:55Z**, 10 posts) — de titel is precies ons terrein, dus **de thread is
    gelezen**: het is een spelersdiscussie over performance-tracking (antwoorden verwijzen naar
    `/combatlog`, Warcraftlogs en WoWAnalyzer). **Geen dev-antwoord, geen API-feit, niets te
    melden.**
  - ✅ **HET `GetItemCooldown`-[MOET GEFIKST] VAN 5 SEP IS DICHT — hier hermeten, niet uit de
    aantekening geciteerd.** `grep GetItemCooldown` over de addon geeft vandaag **geen enkele kale
    aanroep** meer: `Modules/Delves.lua:1767`, `Modules/Delves.lua:1935` en
    `Modules/DelveItemsPopup.lua:278` gaan alle drie door `ns.GetItemCooldownSafe`
    (`Modules/Delves.lua:341`, `C_Item.GetItemCooldown` eerst, dan `rawget(_G,…)`, beide in een
    `pcall`). De overige treffers zijn commentaar (`Delves.lua:319-332`, `DelveItemsPopup.lua:275`,
    `PtrProbe.lua:131-137`) en de naam-string op `PtrProbe.lua:137`.
    ⚠️ **Wat hier open blijft:** `C_Item.GetItemCooldown` is nog steeds **niet in een client
    gezien** — de migratie is geciteerd, niet gemeten. Eén run van `/mh ptr` op de 12.1.5-PTR
    settelt het.
  - **Staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`)
    zijn ook deze run niet opnieuw getoetst en blijven staan zoals op 2 sep gemeten.
  - **Bronnen, alle met cache-buster opgehaald:** `warcraft.wiki.gg/api.php` (`prop=revisions`,
    `action=compare`, `list=search`, `list=recentchanges`);
    `raw.githubusercontent.com/Gethe/wow-ui-source` @ `12.1.0`;
    `news.blizzard.com/en-us/article/24296142`; `us.forums.blizzard.com` categorie-JSON 35 op
    `order=created` + topic 2343904. **NIET GEPROBEERD:** de bluetracker-spiegel — niet nodig,
    news.blizzard.com kwam vers binnen en is bovendien via WebSearch tegengelezen.

- [2026-09-07] 📋 **Nieuw sinds gisteren: de `Patch 12.1.5/API changes`-pagina is uitgebreid met
  een volledige API-samenvatting (PTR, Build 69594; dev-notes Linxy 3 sep). Dit is de addon-/
  API-kant, dus getoetst — géén enkel item raakt ons vandaag. 0 × [MOET GEFIKST].**
  ⚠️ **KADER: 12.1.5 is PTR, er is nog geen live client-build in Robs spel.** Niets hiervan breekt
  nu; dit is vooruitkijken. De content-/roadmap-kant van 12.1.5 is PTR-wachter-terrein — ik meld
  hier uitsluitend wat de *code* kan breken.
  - **GEMETEN, revisiegeschiedenis i.p.v. paginatekst** (`warcraft.wiki.gg/api.php`,
    `prop=revisions`, cache-busted). `Patch 12.1.5/API changes` kreeg sinds de 6-sep-run één nieuwe
    bewerking: **revid 6863733, 2026-09-06T17:08:08Z, `/* Deprecated API */`** (Ketho). De diff
    (`action=compare` 6862562→6863733) is **puur cosmetisch**: de rode ambox-kop veranderde van
    *"The following deprecations have been removed"* naar *"The following deprecation fallbacks have
    been removed"* — geen enkele functienaam toegevoegd, verwijderd of gewijzigd; de tabel eronder
    is byte-gelijk. De inhoudelijke API-samenvatting zelf stond er al sinds 5 sep (binnen venster),
    maar was in dit logboek nog niet per item aan de code getoetst — dat gebeurt hieronder.
  - **AuraContainer/AuraButton: `AddDispelTypeTexture` en `AddPandemicRegion` geven geen index meer
    terug; de bijbehorende `Remove*` nemen nu een region-referentie i.p.v. een index; tweemaal
    dezelfde region toevoegen gooit nu een error.** **[RAAKT ONS NIET]** — GEMETEN:
    `Modules/PartyTargets.lua:326-361` maakt precies één `CustomAuraContainer` en roept daarop
    alléén `SetUnit`/`AddAuraSlot`/`SetEnabled` aan (+ `SetPoint`/`SetHeight`/`Show`). De vier
    gewijzigde API's komen in de héle addon uitsluitend voor in `Modules/PtrProbe.lua:402-403`, een
    *capability-probelijst* (`frame[m] == nil`), nooit als aanroep op de container. Positieve
    controle: de grep vond de namen wél waar ze staan (PtrProbe), dus het lege container-call-
    resultaat is echt leeg. `PtrProbe.lua:386-389` documenteerde deze 12.1.5-wijziging al vooraf.
  - **AddOn Security: `Cooldown:SetCooldown` en `:Clear` kunnen niet meer vanuit getainte code
    aangeroepen worden wanneer het cooldown-frame zélf protected is.** **[AL AFGEDEKT]** — GEMETEN:
    MH's enige `SetCooldown`-doel is `f._cd` (`Modules/CombatSafety.lua:184`, `:598`, `:700-701`),
    een `Cooldown` geparent aan `f = CreateFrame("Button", "MidnightHelperCombatSafety", UIParent)`
    (`CombatSafety.lua:114`) — een **kale, niet-secure Button**; er staat nergens een
    `SecureActionButtonTemplate` in de module. Het cooldown-frame is dus niet protected, dus de
    voorwaarde van de nieuwe restrictie treedt nooit in werking.
  - **AddOn Security: castbar-ID's zijn nu uniek per unit-token; `UnitCastingInfo("PLAYER")` geeft
    een ander castbar-ID dan `("player")`.** **[RAAKT ONS NIET]** — GEMETEN: MH leest
    `UnitCastingInfo`/`UnitChannelInfo` uitsluitend voor naam/texture/spellID/`notInterruptible`
    (`ActionPrompt.lua:262/270`, `CombatSafety.lua:411-416/529-563/811-815`,
    `RitualBossCoach.lua:215-216`) en gebruikt het castbar-ID **nooit** om units te vergelijken;
    alle aanroepen gebruiken bovendien kleine-letter-tokens (`"target"`, `"unit"`). De wijziging
    mikt op addons die castbar-ID's over tokens heen cachten om units te matchen — dat doet MH niet.
  - **Nieuwe Lua-util-functies** (`math.clamp/round/lerp/…`, `string.contains/startswith/…`,
    `table.contains/keys/…`) en **nieuwe additieve script-object-API's** (`CreateFrameWithOptions`,
    `TimedSignalMap`, `roundLayoutToNearestPixel`/`SetRoundLayoutToNearestPixel`). **[RAAKT ONS
    NIET]** — additief; voor de util-functies zijn aliassen op de bestaande namen behouden "to
    prevent addon breakage", en de script-object-API's zijn nieuw (niets verwijderd). MH roept ze
    niet aan.
  - **Deprecations: de deprecated *fallback-addons* zijn verwijderd** (Blizzard_Deprecated
    CurrencyScript/Glue/ItemScript/ItemSocketInfo/LFG/PetInfo/PvpScript/SoundScript/
    WorldElapsedTimerTypes e.a. — de `loadDeprecationFallbacks`-gated shims voor oude globals).
    **[grotendeels AL AFGEDEKT — één deel NIET VOLLEDIG MEETBAAR vanaf hier]**:
    `Blizzard_DeprecatedWorldElapsedTimerTypes` is op 6 sep al gemeten als [RAAKT ONS NIET] (0
    functie-treffers), en MH draait op moderne `C_*`-namespaces. ⚠️ **Wat ik NIET kan meten:** een
    volledige per-functie-audit van álle verwijderde shims vereist de exacte functienamen die erin
    zaten, en die staan niet op de wiki-pagina (alleen de addon-namen). Dit settelt in één run met
    `/mh ptr` op de 12.1.5-PTR-client; `PtrProbe.lua:120/131-137` somt deze addon-namen al op als
    probe-doel. Ik gok hier geen functienamen bij — dat is precies de val die CLAUDE.md verbiedt.
  - ℹ️ **Ter info, geen actiepunt:** 12.1.5 draagt `TOC: 120105`. `MidnightHelper.toc` declareert nu
    `120007, 120100`; bij een live 12.1.5 wil je die waarschijnlijk bijwerken, maar dat is een
    compat-nummer (out-of-date-waarschuwing), geen API-breuk, en het is release-/PTR-terrein.

- [2026-09-07] ✅ **Voor de rest géén relevante API-wijzigingen (31 aug–7 sep).**
  - **`Patch 12.1.0/API changes` onveranderd** — nieuwste revisie nog steeds **6860164,
    2026-09-05T00:39:06Z** (`12.1.0 (69587)`), dezelfde die 5+6 sep al gemeld is. Geen nieuwe
    `/API changes`-pagina boven 12.1.5 (wiki-zoek `intitle:"API changes"` op aanmaakdatum: nieuwste
    is 12.1.5; 12.2.0 bestaat niet).
  - **Hotfixes: nieuwste sectie nog steeds 4 september 2026** — geen 5/6/7-sep-lijst. Volledig
    gelezen: Classes (Druid Balance, Shaman Enhancement), The Venomous Abyss, Housing, Items. **Geen
    Lua-API-, secure-frame-, taint- of addon-sectie;** de enige UI-nabije regel is content
    ("Stellar Amplification can now be tracked in the Cooldown Manager"). **Onafhankelijk bevestigd
    via WebSearch:** die kent artikelen t/m 4 sep en géén voor 5/6/7 sep (geen cache-val).
  - **Blizzard US UI-and-Macro-forum: geen blue post en geen nieuw API-topic binnen 7 dagen.**
    🔴 **Bijna-val ontweken:** de op *activiteit* gesorteerde categorie-JSON zette **Kaivax**
    (community-manager) in de users-array — precies de "gebumpte oude thread"-val uit eerdere runs.
    Positieve tegencontrole: `search.json?q=#ui-macro @Kaivax after:2026-08-25` geeft **0 posts** →
    Kaivax heeft hier de laatste ~2 weken niets geplaatst. De recente topics zijn allemaal
    spelershulp (Counterspell-macro, `#showtooltip`-macro's, "please make it so that healbot can
    show debuffs again" in de lopende *Addons api restrictions*-thread, topic 2343904, post #10 op
    5 sep). Geen dev-antwoord, geen API-feit.
  - **Positieve controle in dezelfde run:** de greps op `AddDispelTypeTexture` (→ PtrProbe),
    `UnitCastingInfo` (→ 6 bestanden) en `SetCooldown` (→ CombatSafety) vonden allemaal wat er is,
    dus de lege *aanroep*-resultaten hierboven zijn echt leeg, geen kapotte grep.
  - **Staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`,
    `GetItemCooldown`→`ns.GetItemCooldownSafe`) deze run niet opnieuw getoetst; ongewijzigd afgedekt
    zoals op 2/6 sep gemeten.
  - **Bronnen, alle cache-busted:** `warcraft.wiki.gg/api.php` (`prop=revisions`, `action=compare`,
    `action=parse&prop=wikitext`, `list=search`); `news.blizzard.com/en-us/article/24296142`
    (hotfixes 4 sep) + WebSearch-tegencontrole; `us.forums.blizzard.com` categorie-JSON 35 +
    `search.json` (`#ui-macro`, `#ui-macro @Kaivax`).

- [2026-09-07] ✅ **Geen relevante API-wijzigingen. 0 × [MOET GEFIKST].** De enige bewerking sinds
  gisteren is een woordwijziging in de waarschuwingsbalk van de 12.1.5-pagina; geen enkele
  functienaam toegevoegd, verwijderd of gewijzigd. Wel is één openstaande vraag van 5–6 sep vandaag
  **dichtgemeten**.
  - ✅ **AFGESLOTEN — `C_Item.GetItemCooldown` BESTAAT, en al op 12.1.0 waar Rob nú op speelt.**
    Sinds 5 sep stond hier: *"de migratie is GECITEERD, niet gemeten; `C_Item.GetItemCooldown` is
    niet in een client geverifieerd."* Nu **GEMETEN** in Blizzards eigen gegenereerde
    API-documentatie — `raw.githubusercontent.com/Gethe/wow-ui-source`, branch **`12.1.0`**,
    `Interface/AddOns/Blizzard_APIDocumentationGenerated/ItemDocumentation.lua`. Dat bestand
    declareert `Namespace = "C_Item"` (regel 5) en bevat op **regel 412** `Name = "GetItemCooldown"`
    met `SecretArguments = "AllowedWhenUntainted"`, één argument (`itemInfo`) en **drie** returns:
    `startTimeSeconds`, `durationSeconds`, `enableCooldownTimer`.
    📌 Die drie komen exact overeen met wat wij uitpakken op `Modules/DelveItemsPopup.lua:278`
    (`local start, duration, enabled = ns.GetItemCooldownSafe(itemID)`), en `ns.GetItemCooldownSafe`
    (`Modules/Delves.lua:341-355`) roept de `C_Item`-vorm als eerste aan. De fix van 6 sep is dus
    niet alleen syntactisch veilig maar landt ook op een functie die er vandaag écht is.
    ⚠️ **Wat dit NIET is:** een `/dump` in de client. Het is het documentatiebestand dat mét die
    build wordt gegenereerd — sterk bewijs, maar nog steeds papier. Wie het helemaal dicht wil,
    draait één keer `/mh ptr`; noodzakelijk is dat niet meer.
    📌 **MELDEN, NIET REPAREREN:** de comment op `Modules/Delves.lua:332` zegt nog steeds *"has NOT
    been verified in a client"*. Die regel is per vandaag achterhaald. Ik raak geen code aan — dit
    is één zin voor Rob als hij dat bestand toch opent.
  - **De enige wiki-bewerking sinds gisteren: revid 6863733, 2026-09-06T17:08:08Z, Ketho,
    `/* Deprecated API */`, 25218 → 25227 bytes (+9).** **GEMETEN** via
    `action=compare&fromrev=6862562&torev=6863733`, de diff zelf gelezen. Eén regel gewijzigd, de
    `ambox`-waarschuwing bovenaan de Deprecated-API-tabel:
    was *"The following deprecations have been removed."*, is nu
    ***"The following deprecation fallbacks have been removed."***
    **[RAAKT ONS NIET]** als API-feit — er is geen naam bijgekomen of weggegaan.
    📌 Wel de moeite waard omdat het de **scope aanscherpt**: wat 12.1.5 weghaalt zijn de
    *deprecation fallbacks* — de globale aliassen die naar de nieuwe namespace wezen — en niet de
    functionaliteit zelf. Dat is precies de vorm van het `GetItemCooldown`-geval: de global valt
    weg, `C_Item.GetItemCooldown` blijft. Onze lezing van 5 sep klopte dus, en staat nu ook zo in
    de bron.
  - **`Patch 12.1.0/API changes` onveranderd** — nieuwste revisie nog steeds **6860164,
    2026-09-05T00:39:06Z** (`12.1.0 (69587)`), dezelfde die 5 en 6 sep gemeld is.
  - **Geen nieuwe `/API changes`-pagina.** Wiki-zoekopdracht `intitle:"API changes"` gesorteerd op
    aanmaakdatum: **12.1.5** (pageid 705933) is nog altijd de nieuwst aangemaakte; er bestaat nog
    geen 12.2.0-pagina. Geen nieuw PTR-build-nummer op de 12.1.5-pagina (nog steeds 69594).
  - **Hotfixes: nieuwste sectie nog steeds 4 september 2026.** ⚠️ **Even oud als wat hier gisteren
    stond, niet ouder — dus geen cache-val**, en toch **onafhankelijk tegengelezen**: WebSearch kent
    artikelen voor 1, 2, 3 en 4 sep en géén voor 5, 6 of 7 sep. Het artikel zelf (cache-buster
    `?nocache=20260907`) opent met "Hotfixes: September 4, 2026". Volledig gelezen t/m 1 sep:
    Classes, Dungeons and Raid, Housing, Items, Achievements, Quests, PvP. **Geen Lua-API-,
    secure-frame-, taint- of addon-sectie in enige sectie binnen het venster.**
  - **Blizzard US UI-and-Macro-forum: twee nieuwe topics, allebei spelers-macrohulp, geen blue
    post.** Opgehaald op `order=created` met cache-buster.
    - *My health pot macro stopped working* (**2026-09-07T01:38:58Z**, 1 post, 0 reacties). Gelezen:
      `#showtooltip` / `/use Healthstone` / `/use Potent Healing Potion` zou "stoppen bij de
      Healthstone-regel". **Geen dev-antwoord en geen tweede melding**, dus dit is net zo goed een
      lege tas als een gedragswijziging — ik tel het níét als bevinding. Wel de moeite waard om
      morgen terug te kijken of er een antwoord onder staat; `/use` op meerdere items in één macro
      is precies het soort ding dat stil verandert.
    - *Trying for a intrrupt macro but wont work need help* (**2026-09-06T07:07:50Z**, 3 posts).
      Gelezen: `/cast [@focus,…]`-conditionals, gewone macrohulp, geen API-feit.
    - **Geen enkele `community-manager`-post in de categorie binnen 7 dagen** — GEMETEN aan de
      categorie-JSON: `primary_groups` en `flair_groups` zijn allebei leeg en geen van de 46
      deelnemers heeft een Blizzard-groep; trust levels 0–3.
  - **Staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`)
    zijn ook deze run niet opnieuw getoetst en blijven staan zoals op 2 sep gemeten.
  - **Positieve controle in dezelfde run.** Ik beweer hierboven nergens een léég zoekresultaat over
    de addon — de enige grep die ertoe doet, `GetItemCooldown` over `*.lua`/`*.toc`, geeft **17
    treffers in 3 bestanden** en bevestigt dat de fix van 6 sep staat: `Delves.lua:1767` en `:1935`
    en `DelveItemsPopup.lua:278` gaan alle drie door `ns.GetItemCooldownSafe`, de rest is commentaar
    plus de naam-string op `PtrProbe.lua:137`. In het documentatiebestand was de positieve controle
    `GetItemCount` (regel 429) en `GetItemInfo` (regel 604) — het patroon vindt dus wél wat er is.
  - **Bronnen, alle met cache-buster opgehaald:** `warcraft.wiki.gg/api.php` (`prop=revisions` op
    pageids 705933 en 679840, `action=compare&fromrev=6862562&torev=6863733`, `list=search`,
    `list=recentchanges`); `raw.githubusercontent.com/Gethe/wow-ui-source` @ `12.1.0`
    (`ItemDocumentation.lua`, HTTP 200, 43162 bytes); `news.blizzard.com/en-us/article/24296142`;
    `us.forums.blizzard.com` categorie-JSON 35 op `order=created`; WebSearch als tegenlezing op de
    hotfixes en op 12.1.5-PTR-API-nieuws. **NIET GEPROBEERD:** de bluetracker-spiegel — niet nodig,
    news.blizzard.com kwam vers binnen. ⚠️ **Directe `curl` naar warcraft.wiki.gg blijft geblokkeerd**
    (`CONNECT tunnel failed, 403`); `raw.githubusercontent.com` werkt wél via `curl` en dat is nieuw
    gereedschap voor deze wachter — zo is de meting hierboven gedaan.

- [2026-09-08] ✅ **Geen relevante API-wijzigingen. 0 × [MOET GEFIKST].** Beide `/API changes`-
  pagina's staan op exact dezelfde revisie als gisteren, de hotfixes zijn nog steeds die van 4 sep,
  en het forum leverde één nieuw topic zonder API-feit. De enige beweging in API-land is een
  **herformulering van één zin** op een type-pagina — en die bevestigt juist wat we op 7 sep gemeten
  hebben. Twee openstaande punten van gisteren zijn vandaag dicht.
  - ℹ️ **`API types/ItemInfo` bewerkt op 7 sep — herformulering, geen feit. [RAAKT ONS NIET] als
    API-wijziging, wél een bevestiging.** **GEMETEN** via `action=compare&fromrev=6849222&
    torev=6864595`, de diff zelf gelezen. Drie bewerkingen op **2026-09-07** (05:40:51, 10:24:36,
    10:24:43, alle door Ketho, alle 7051 bytes). Netto verandert er precies één zin:
    was *"ItemInfo refers to an Item ID, Item GUID, ItemLink or name"*,
    is nu *"ItemInfo refers to an Item ID, ItemLink, ItemGUID or name"* — dezelfde vier vormen,
    andere volgorde, `Item GUID` → `ItemGUID`. Geen naam toegevoegd of verwijderd.
    📌 Toch de moeite waard omdat `ItemInfo` het **argumenttype van `C_Item.GetItemCooldown`** is
    uit het item van 5–7 sep: de pagina zegt dat een **Item ID** een geldige `ItemInfo` is, en dat
    is precies wat wij doorgeven. **[AL AFGEDEKT]** — `ns.GetItemCooldownSafe`
    (`Modules/Delves.lua:349-359`) doet `tonumber(itemID)` en roept aan achter
    `if C_Item and C_Item.GetItemCooldown then` + `pcall` (`Delves.lua:354-355`); aanroepers zijn
    `Delves.lua:1775` en `:1943` (beide `6948`) en `Modules/DelveItemsPopup.lua:278`.
  - ✅ **De doorgeefzin van gisteren is opgevolgd — door iemand anders, niet door mij.** Op 7 sep
    stond hier dat de comment op `Modules/Delves.lua:332` nog *"has NOT been verified in a client"*
    zei. **GEMETEN in het bestand vandaag:** die tekst is weg; `Delves.lua:336-343` draagt nu de
    meting van 7 sep (`wow-ui-source` branch `12.1.0`, `ItemDocumentation.lua` regel 412) mét de
    kanttekening dat het gegenereerde documentatie is en geen `/dump`. Punt dicht. Ik heb geen code
    aangeraakt.
  - ✅ **De openstaande forumvraag van gisteren is dicht, en het was géén API-feit.**
    *My health pot macro stopped working* (topic **2345569**) heeft nu 3 posts, laatste
    **2026-09-08T02:48:29Z**. Volledig gelezen: een medespeler stelde een andere macro voor
    (`/use [known:386689] item:224464; item:5512` + `/use item:258138`), de OP antwoordt
    *"Thank you, that worked."* **Geen dev-antwoord, geen aangetoonde gedragswijziging** — de
    kapotte versie noemde items op naam, de werkende versie op `item:`-ID. Ik tel dit **niet** als
    bevinding en sluit het punt van gisteren.
  - **Eén nieuw forumtopic, geen API-feit:** *Duration Bars setting not saving* (topic **2345637**,
    **2026-09-07T09:16:58Z**, 1 post, 0 reacties). Volledig gelezen: de Edit Mode-optie Duration
    Bars (en Archaeology bars) laat zich account-wide niet bewaren — opslaan kan pas na een andere
    wijziging en is na een reload weer weg; Quartz verwijderd en cache geleegd hielp niet.
    **Geen dev-antwoord en één enkele melding**, dus dit is net zo goed een kapotte installatie als
    een client-bug — ik tel het niet mee. **[RAAKT ONS NIET]** voor MH: onze enige Edit
    Mode-aanraking loopt via `ns.MH_EditMode*` (`Core.lua:1636-1676`,
    `Modules/BarPreset.lua:162-166`) en gaat over **action bars**, niet over duration- of
    castbars; `Modules/BarInventory.lua:316-322` doet alleen een aanwezigheidsrapport op
    `C_EditMode`/`EditModeManagerFrame`/`Enum.EditModeActionBarSetting`. Morgen terugkijken of er
    alsnog een blue post onder komt.
  - **Beide `/API changes`-pagina's onveranderd t.o.v. gisteren.** **GEMETEN** via `prop=revisions`:
    `Patch 12.1.0/API changes` (pageid 679840) nog steeds **revid 6860164, 2026-09-05T00:39:06Z**;
    `Patch 12.1.5/API changes` (pageid 705933) nog steeds **revid 6863733, 2026-09-06T17:08:08Z**.
    Geen nieuwe `/API changes`-pagina: `intitle:"API changes"` op aanmaakdatum geeft **12.1.5** als
    nieuwste (138 hits); **12.2.0 bestaat niet**.
  - **Wat er verder in API-land bewoog: ouder dan gisteren of allang gemeld.** Wiki-zoek
    `intitle:/API/` gesorteerd op laatste bewerking geeft binnen het venster alleen
    `API types/ItemInfo` (hierboven), `Patch 11.0.2/API changes` (6 sep, oude patch),
    `API getglobal` + `API setglobal` (beide **2026-09-06T02:11–02:12**), en `Events`,
    `ScriptObject API`, `Widget API`, `World of Warcraft API` (alle 4 sep, al gedekt).
    `getglobal`/`setglobal` staan hier sinds 18 aug als **[RAAKT ONS NIET]** (regel 98) en dat is
    vandaag **opnieuw GEMETEN**: `grep -E "getglobal|setglobal"` over `*.lua`/`*.toc` geeft
    **0 treffers**.
  - 🔴 **Positieve tegencontrole in dezelfde run en dezelfde vorm** (want een leeg zoekresultaat
    bewijst niets): hetzelfde `grep -rc --include=*.lua --include=*.toc -E` op
    `CreateFrame|InCombatLockdown` geeft **2 in `Core.lua`** en **24 in `Modules/Delves.lua`**. Het
    patroon vindt dus wél wat er is; de nul hierboven is een echte nul.
  - **Hotfixes: nieuwste sectie nog steeds 4 september 2026.** ⚠️ Even oud als wat hier gisteren
    stond, **niet ouder** — dus geen cache-val — en tóch **onafhankelijk tegengelezen**: WebSearch
    kent artikelen t/m 4 sep en géén voor 5, 6, 7 of 8 sep. Artikel `24296142` (cache-buster
    `?nocache=20260908`) opent met "Hotfixes: September 4, 2026". Secties 2, 3 en 4 sep volledig
    gelezen: Classes, Dungeons and Raid(s), Housing, Items, Achievements, Quests. **Geen Lua-API-,
    secure-frame-, taint- of addon-sectie binnen het venster.**
  - **Blizzard US UI-and-Macro-forum: geen blue post binnen 7 dagen.** **GEMETEN** aan de
    categorie-JSON (`order=created`, cache-buster): `primary_groups` en `flair_groups` zijn allebei
    leeg en geen van de 46 getoonde deelnemers heeft een Blizzard-groep (trust levels 0–3). Topics
    binnen het venster, allemaal spelershulp: Duration Bars (2345637) en health-pot-macro (2345569)
    hierboven, *Trying for a intrrupt macro* (2345310, 6 sep), *Cast bar addon?* (2344882, 4 sep),
    *Details! issues since early this week* (2344196, laatste post 5 sep), *Addons api restrictions*
    (2343904, laatste post 5 sep — **ongewijzigd sinds gisteren**).
  - **De 12.1.5-lijst niet opnieuw geopend, wel tegengelezen.** Een WebSearch naar 12.1.5-API-nieuws
    leverde enkel een samenvatting van diezelfde wiki-pagina op: `SetCooldown`/`Clear` niet meer
    aanroepbaar vanuit tainted code op een protected cooldown-frame, castbar-ID's uniek per
    unit-token, `roundLayoutToNearestPixel`/`SetRoundLayoutToNearestPixel`, en de nieuwe
    `math.*`/`string.*`/`table.*`-utils. **Alle vier al getoetst en gelogd op 5–6 sep**
    (regels 384–393 en 686–695). Niets nieuws, en dus hier niet opnieuw als nieuws opgevoerd.
  - **Staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`,
    `GetItemCooldown`→`ns.GetItemCooldownSafe`) zijn deze run niet opnieuw getoetst en blijven staan
    zoals op 2/6/7 sep gemeten.
  - **Bronnen, alle met cache-buster opgehaald:** `warcraft.wiki.gg/api.php` (`prop=revisions` op
    pageids 679840, 705933 en 596633 én op de titels `Secret values`/`Taint`/`Patch 12.1.5`/
    `AddOn changes`; `list=search` op `intitle:"API changes"` en `intitle:/API/`;
    `list=recentchanges`; `action=compare&fromrev=6849222&torev=6864595`);
    `news.blizzard.com/en-us/article/24296142`; `us.forums.blizzard.com` categorie-JSON 35 op
    `order=created` plus `t/2345569.json` en `t/2345637.json`; WebSearch als tegenlezing op de
    hotfixes en op 12.1.5. **NIET GEPROBEERD:** de bluetracker-spiegel — niet nodig, de bronnen
    kwamen vers binnen.
    ⚠️ **`WebFetch` op `warcraft.wiki.gg` is nog steeds EGRESS_BLOCKED**; alles hierboven liep via
    `web_fetch_exa`, dat de wiki-API wél bereikt.
    📌 **Nieuwe val genoteerd, voor de volgende run:** `prop=revisions` met `rvlimit` op méér dan
    één pageid geeft `invalidparammix` — een foutobject dat er níét als "niets gevonden" uitziet,
    maar wel nul revisies oplevert. Laat `rvlimit` weg zodra je meerdere pagina's opvraagt.
  - ⚠️ **Repo-observatie, geen API-feit:** `origin/main` was vanochtend **force-pushed** — de pull
    meldde `+ bfa77f2...c16a392 main -> origin/main (forced update)` en de lokale `main` week
    50 commits af. Ik heb alleen mijn eigen checkout gelijkgetrokken (`reset --hard origin/main`,
    werkboom was schoon) en verder niets aangeraakt. Als Rob dit niet zelf gedaan heeft, is het het
    natrekken waard.

- [2026-09-09] ✅ **Geen relevante API-wijzigingen. 0 × [MOET GEFIKST].** Er is sinds gisteren
  **nul beweging** in API-land: beide `/API changes`-pagina's staan op dezelfde revisie, de
  hotfixes zijn nog steeds die van 4 sep, en het UI-and-Macro-forum kreeg geen enkel nieuw topic.
  Dit is de derde stille dag op rij en dat is het volledige antwoord, geen halve meting.
  - **Beide `/API changes`-pagina's onveranderd t.o.v. 8 sep.** **GEMETEN** via `prop=revisions`
    (zonder `rvlimit`, zie de val van gisteren): `Patch 12.1.0/API changes` (pageid 679840) nog
    steeds **revid 6860164, 2026-09-05T00:39:06Z**, 102421 bytes; `Patch 12.1.5/API changes`
    (pageid 705933) nog steeds **revid 6863733, 2026-09-06T17:08:08Z**, 25227 bytes.
  - **Geen nieuwe `/API changes`-pagina.** `intitle:"API changes"` op aanmaakdatum: **12.1.5** nog
    altijd de nieuwst aangemaakte (138 hits); **12.2.0 bestaat nog steeds niet** (`prop=revisions`
    op de titel `Patch 12.2.0` geeft `missing`).
  - **Geen enkele API-pagina bewerkt sinds 7 sep.** `intitle:/API/` op laatste bewerking geeft als
    nieuwste nog steeds `API types/ItemInfo` (**2026-09-07T10:24:43Z**) — het item dat hier
    gisteren al staat. Daarnaast `list=recentchanges` (ns 0, t/m 7 sep, 40 wijzigingen gelezen):
    **geen enkele API-, secure-frame- of taint-pagina**; alles is content (items, Coiled Isle NPC's,
    Tortollan-coördinaten, een nieuwe pagina *WoW's 22nd Anniversary*). Ook `Secret Values`
    (laatste bewerking 2026-02-07), `Taint` (2010) en `UI escape sequences` (2026-07-25) liggen
    alle drie ver buiten het venster.
  - **Hotfixes: nieuwste sectie nog steeds 4 september 2026.** ⚠️ Even oud als gisteren, **niet
    ouder** — dus geen cache-val — en tóch **onafhankelijk tegengelezen**: WebSearch kent artikelen
    t/m 4 sep en géén voor 5 t/m 8 sep. Artikel `24296142` (cache-buster `?nocache=20260909`) opent
    met "Hotfixes: September 4, 2026". Secties 2, 3 en 4 sep opnieuw gelezen: Classes, Dungeons and
    Raid(s), Housing, Items, Achievements, Quests. **Geen Lua-API-, secure-frame-, taint- of
    addon-sectie binnen het venster.** 📌 Let op een zoekartefact: WebSearch geeft voor dezelfde
    article-id `24296142` óók titels "September 3" en "September 2" terug — dat is de zoekindex die
    oude snapshots van hetzelfde doorlopende artikel bewaart, geen tweede artikel.
  - **Blizzard US UI-and-Macro-forum: geen nieuw topic en geen blue post binnen 7 dagen.**
    **GEMETEN** aan de categorie-JSON (`order=created`, cache-buster): nieuwst aangemaakte topic is
    nog steeds *Duration Bars setting not saving* (**2345637, 2026-09-07T09:16:58Z**), en
    `primary_groups` en `flair_groups` zijn allebei leeg — geen van de 46 getoonde deelnemers heeft
    een Blizzard-groep (trust levels 0–3).
    - ⏳ **Het openstaande punt van gisteren blijft precies zo open:** *Duration Bars* staat nog
      altijd op **1 post, 0 reacties, 13 views**, dus nog steeds één enkele melding zonder
      dev-antwoord. Ik tel het nog steeds **niet** mee. **[RAAKT ONS NIET]** blijft staan zoals op
      8 sep gemeten (`Core.lua:1636-1676`, `Modules/BarPreset.lua:162-166`,
      `Modules/BarInventory.lua:316-322` — allemaal action bars, geen duration- of castbars).
      Sluit dit punt als er over een paar dagen nog steeds niets onder staat; een enkele melding
      die niemand bevestigt is geen bevinding.
    - *Addons api restrictions* (2343904) **ongewijzigd**: nog steeds 10 posts, laatste
      2026-09-05T17:29:55Z, geen blue.
  - **De 12.1.5-lijst tegengelezen, en de tegenlezing leverde niets nieuws op.** Een WebSearch naar
    12.1.5-PTR-API-nieuws gaf **`TimedSignalMap`** prominent terug alsof het nieuw was; het staat
    hier al sinds **5 sep** (regels 391-392) en is op 6 sep als **[RAAKT ONS NIET]** afgedaan
    (regel 695), net als castbar-ID's per unit-token, `roundLayoutToNearestPixel` en de nieuwe
    `table.*`-functies. **Niet opnieuw als nieuws opgevoerd.**
  - 🔴 **Positieve controle in dezelfde run.** Ik doe hierboven geen enkele bewering over een leeg
    zoekresultaat in de addon-code, maar heb er tóch één standing item mee opnieuw gemeten in
    plaats van het op papier over te nemen: `grep -E "GetNextWaypointForMap|C_Navigation"` over
    `*.lua` geeft **4 treffers in 1 bestand**, alle in `Modules/EventProbe.lua:119-133`. De
    migratie-comment (`:119-120`) staat er nog letterlijk, en de twee namen staan er als **strings
    in een probe-tabel**, niet als aanroep. **[AL AFGEDEKT]**, nu gemeten en niet geciteerd.
  - **Staande 12.1.0-items** (C_UnitAuras secret-reads, AuraContainer/AuraButton,
    `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`,
    `GetItemCooldown`→`ns.GetItemCooldownSafe`) zijn deze run niet opnieuw getoetst en blijven
    staan zoals op 2/6/7 sep gemeten. `GetNextWaypointForMap` is vandaag wél opnieuw gemeten
    (hierboven).
  - **Bronnen, alle met cache-buster opgehaald:** `warcraft.wiki.gg/api.php` (`prop=revisions` op
    pageids 679840 en 705933 én op de titels `Secret values`/`Taint`/`AddOn changes`/
    `Patch 12.1.5`/`Patch 12.2.0`/`UI escape sequences`; `list=search` op `intitle:"API changes"`
    en `intitle:/API/`; `list=recentchanges` ns 0 t/m 7 sep); `news.blizzard.com/en-us/article/
    24296142`; `us.forums.blizzard.com` categorie-JSON 35 op `order=created`; WebSearch als
    tegenlezing op de hotfixes en op 12.1.5-PTR-API-nieuws. **NIET GEPROBEERD:** de
    bluetracker-spiegel — niet nodig, alles kwam vers binnen. ⚠️ `WebFetch` op `warcraft.wiki.gg`
    blijft EGRESS_BLOCKED; alles liep via `web_fetch_exa`.
    📌 **Kleine aantekening bij de cache-buster:** de wiki-API antwoordt op elke onbekende
    parameter met `{"warnings":{"main":{"*":"Unrecognized parameter: nocache."}}}`. Dat is
    **onschadelijk** — de query wordt gewoon uitgevoerd — en het is juist het bewijs dat de URL een
    andere string is dan gisteren, dus dat Exa's cache omzeild is. Niet "repareren" door de
    parameter weg te laten.
  - ✅ **Repo-observatie van gisteren: geen vervolg.** De force-push van 8 sep heeft zich niet
    herhaald. `git pull --rebase origin main` gaf vanochtend **"Already up to date"**, werkboom
    schoon, en `git rev-list --count HEAD` staat op **50** — dezelfde 50 commits als waar de
    geforceerde historie gisteren op uitkwam. Stabiel dus; het blijft de moeite waard dat Rob
    bevestigt dat hij die force-push zelf gedaan heeft.

- [2026-09-10] ✅ **Geen relevante API-wijzigingen. 0 × [MOET GEFIKST].** Er zijn na drie stille
  dagen **nieuwe hotfixes** (9 sep) — die zijn dus gelezen en niet overgeslagen — maar er zit
  **geen Lua-API-, secure-frame-, taint- of addon-sectie** in. Wiki en forum staan stil.
  - 🔴 **Hotfixes: nieuwste sectie is nu 9 september 2026 — NIEUWER dan gisteren, dus geen
    cache-val.** Gisteren stond hier 4 sep als nieuwste; vandaag opent artikel `24296142`
    (cache-buster `?nocache=20260910`) met "Hotfixes: September 9, 2026". **Onafhankelijk
    tegengelezen** met WebSearch, die dezelfde datum kent, plus een Blue Tracker-spiegel
    (`wowhead.com/blue-tracker/news/us/hotfixes-september-9-2026-…-24296142`).
    **Secties van 9 sep, volledig gelezen:** Achievements, Classes, Delves, Dungeons and Raids,
    Items, Player versus Player, Prey, The Burning Crusade Classic. **Geen UI-, addon- of
    API-sectie.**
    - ⚠️ **Eerlijkheidshalve één gat in deze meting:** de WebSearch-samenvatting noemt twee
      9 sep-regels die ik in de opgehaalde pagina **niet heb teruggezien** ("Midnight World
      Quests rewarding Adventurer Crests" en een Dread/Virulent Plague Erupt-fix). Beide zijn
      **content, geen API**, dus ze veranderen niets aan de uitkomst hier — maar ik meld het
      liever dan dat ik doe alsof de paginalezing compleet was. Dit is stof voor de
      content-wachter, niet voor mij.
  - **De enige 9 sep-regels die tegen API-land aanschuren zijn Cooldown Manager-regels, en die
    RAKEN ONS NIET.** Letterlijk: "Fixed an issue where Flash Heal could not be tracked on the
    Cooldown Manager for Discipline and Shadow specializations", plus vier Warrior-regels
    ("Rend is now able to be tracked in the Cooldown Manager", en de Venomous Abyss 2-/4-set
    buffs). Dat is Blizzards eigen CDM (`C_CooldownViewer`/`CooldownViewer`-frames).
    **[RAAKT ONS NIET] — GEMETEN vandaag:** `grep -rlE "CooldownViewer|CooldownManager|
    C_CooldownViewer|CooldownViewerSetting"` over alle `*.lua`/`*.xml`/`*.toc` geeft **0 bestanden
    met treffers, op 270 gescande bestanden**, `Modules/HealerCooldowns.lua` inbegrepen — dat
    bestand doet zijn eigen cooldowns via `C_Spell`, niet via de CDM.
    - 🔴 **Positieve controle in dezelfde run, zelfde patroonvorm en dezelfde reikwijdte** (want
      een nul bewijst niets): hetzelfde `grep -rlE` op `GetSpellCooldown|C_Spell` over dezelfde
      270 bestanden geeft **41 bestanden met treffers** (o.a. `Modules/ApplyLayout.lua`,
      `Modules/SurvivalPlan.lua`, `Modules/AtalUtekProbe.lua`). Het patroon vindt dus wél wat er
      is; de nul hierboven is een echte nul.
  - **"Soft Underbelly is now an account-wide achievement" (9 sep) — [RAAKT ONS NIET] op de
    API-kant, en de rest is niet mijn terrein.** Wij dragen dat achievement wél hardcoded
    (`Modules/AchievementsData.lua:173`, `achievementID = 62601`), maar dit is een **flag op de
    data, geen API-wijziging**: dezelfde calls geven voortaan de account-wide stand terug.
    **GEMETEN** dat elke achievement-call bij ons afgedekt is: `Modules/Achievements.lua:72-73`
    en `:148-149` staan achter `if … and GetAchievementCriteriaInfoByID then` **plus** een
    `pcall`; `:1490`, `:1518` en `:1574` achter `if not (GetAchievementNumCriteria and
    GetAchievementCriteriaInfo) then return`; `:158`, `:1532`, `:1581` en `:1605` achter
    `if GetAchievementInfo then`. Geen kale aanroep. ⚠️ **Of onze tékst nu iets onwaars beweert**
    (bijvoorbeeld dat het per personage bijgehouden wordt) **heb ik NIET gemeten** — dat is de
    vraag van `docs/CONTENT_WATCH.md`, en ik laat hem daar liggen in plaats van hem half te
    beantwoorden.
  - **Beide `/API changes`-pagina's onveranderd t.o.v. 8 én 9 sep.** **GEMETEN** via
    `prop=revisions` (zonder `rvlimit`): `Patch 12.1.0/API changes` (pageid 679840) nog steeds
    **revid 6860164, 2026-09-05T00:39:06Z**, 102421 bytes, comment "12.1.0 (69587)";
    `Patch 12.1.5/API changes` (pageid 705933) nog steeds **revid 6863733, 2026-09-06T17:08:08Z**,
    25227 bytes, comment "/* Deprecated API */". Vierde dag zonder beweging.
  - **Geen nieuwe `/API changes`-pagina, en 12.2.0 bestaat nog steeds niet.**
    `intitle:"API changes"` op aanmaakdatum: **12.1.5** nog altijd de nieuwst aangemaakte
    (138 hits, ongewijzigd). `prop=revisions` op de titels `Patch 12.2.0` en `AddOn changes`
    geeft voor allebei `missing`.
  - **Geen enkele API-pagina bewerkt sinds 7 sep.** `intitle:/API/` op laatste bewerking geeft als
    nieuwste nog steeds `API types/ItemInfo` (**2026-09-07T10:24:43Z**) — al twee dagen hier
    gelogd. `list=recentchanges` (ns 0, 50 wijzigingen t/m **2026-09-10T03:38Z**) is **volledig
    content**: uitsluitend item- en appearance-pagina's (Drake Racer's Azure-set,
    Sky-Captain's Masquerade, Flask of Conquest, Orgrimmar/Stormwind Set). **Geen API-,
    secure-frame- of taint-pagina.** Ook `Secret values` (laatste bewerking **2026-02-07**),
    `Taint` (**2010-11-25**) en `UI escape sequences` (**2026-07-25**) liggen alle drie ver
    buiten het venster van 7 dagen.
  - **Blizzard US UI-and-Macro-forum: twee nieuwe topics, geen blue post.** **GEMETEN** aan de
    categorie-JSON (`order=created`, cache-buster): `primary_groups` en `flair_groups` zijn
    allebei leeg — geen van de 46 getoonde deelnemers heeft een Blizzard-groep (trust levels 0–3).
    Nieuw sinds gisteren, beide **9 sep** en beide gewone spelershulp: *Double Icons* (**2346299**,
    2026-09-09T19:09:08Z, 3 posts — dubbele quest-iconen bij iemand met ElvUI) en *Talent Swap
    Macro Problems* (**2346279**, 2026-09-09T17:25:20Z, 3 posts — een `/loadoutindex`-macro met
    `[known:1247055]` die op een mage niet doet wat hij op een paladin doet). **Geen dev-antwoord,
    geen aangetoonde gedragswijziging in de client** — ik tel geen van beide als bevinding.
    - ✅ **Het openstaande punt van 7-9 sep gaat DICHT, en niet omdat ik het beu ben.**
      *Duration Bars setting not saving* (**2345637**) staat na drie dagen nog steeds op **1 post,
      0 reacties, 14 views**, zonder dev-antwoord en zonder één bevestiging door een tweede
      speler. Eén onbevestigde melding is geen API-feit; zo is hij hier op 8 sep ook binnengekomen.
      **[RAAKT ONS NIET] opnieuw GEMETEN vandaag** in plaats van van 8 sep overgeschreven:
      `grep -rnE "DurationBar|Duration Bars|CastingBarFrame|castbar|CastBar"` over `*.lua`/`*.xml`
      geeft **5 treffers, alle vijf commentaar en géén frame** —
      `Modules/InterruptScore.lua:367` (verwijzing naar `oUF/elements/castbar.lua` in een ándere
      addon), `Modules/PtrProbe.lua:219` (onze eigen aantekening over de 12.1.5-castbar-ID's) en
      `Modules/MissingBuff.lua:728` + `Modules/KeybindRoles_Paladin.lua:68,131`, waar "castbare"
      gewoon **het Nederlandse woord** is en niets met een castbar te maken heeft.
      📌 Positieve controle in dezelfde vorm: hetzelfde `grep -rnE` op
      `MH_EditMode|EditModeManagerFrame|C_EditMode` geeft wél treffers
      (`Modules/LayoutWizard.lua:392-399`, `Modules/BarInventory.lua:316-320`). MH heeft dus geen
      duration- of castbar-code, en dat is een echte nul.
    - *Addons api restrictions* (**2343904**) **ongewijzigd**: nog steeds 10 posts, laatste
      2026-09-05T17:29:55Z, geen blue.
  - ⚠️ **De tegenlezing probeerde me iets ouds als nieuws te verkopen, en dat is niet gebeurd.**
    Een WebSearch naar 12.1.5-API-nieuws gaf **`CreateFrameWithOptions`** terug als "a new frame
    creation API", naast de `SetCooldown`/`Clear`-taintregel en de castbar-ID's-per-unit-token.
    Alle drie staan hier al: `CreateFrameWithOptions` sinds **5 sep** (regel 391) en opnieuw op
    **6 sep** (regel 694), de andere twee eveneens op 5-6 sep. **Niet opnieuw als nieuws
    opgevoerd.** Het staat bij ons trouwens alleen als **string in een probe-tabel**
    (`Modules/PtrProbe.lua:129`), niet als aanroep.
  - **Staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`,
    `GetItemCooldown`→`ns.GetItemCooldownSafe`) zijn deze run **niet** opnieuw getoetst en blijven
    staan zoals op 2/6/7/9 sep gemeten.
  - **Bronnen, alle met cache-buster opgehaald:** `warcraft.wiki.gg/api.php` (`prop=revisions` op
    pageids 679840+705933 én op de titels `Secret values`/`Taint`/`Patch 12.2.0`/`AddOn changes`/
    `UI escape sequences`; `list=search` op `intitle:"API changes"` en `intitle:/API/`;
    `list=recentchanges` ns 0, 50 stuks); `news.blizzard.com/en-us/article/24296142`;
    `us.forums.blizzard.com` categorie-JSON 35 op `order=created`; WebSearch als tegenlezing op
    zowel de hotfixes als 12.1.5, mét Blue Tracker als spiegelbevestiging van de hotfix-datum.
    ⚠️ `WebFetch` op `warcraft.wiki.gg` en `news.blizzard.com` blijft **EGRESS_BLOCKED**; alles
    liep via `web_fetch_exa`, dat beide wél bereikt.
    📌 De wiki-API antwoordt op `nocache` met `"Unrecognized parameter: nocache."` — **onschadelijk
    en juist het bewijs** dat de URL-string per dag verschilt. Niet "repareren".
  - ✅ **Repo: rustig.** `git pull --rebase origin main` gaf "Already up to date" op **b0e8f11**,
    werkboom schoon. Geen force-push, geen herhaling van 8 sep. Ik heb alleen dit bestand
    aangeraakt.

- [2026-09-10] ✅ **Tweede run van vandaag — verificatiepas, niets nieuws sinds de 10-sep-regel
  hierboven. 0 × [MOET GEFIKST].** De volledige eerste run stond er al; deze pas heeft die claims
  **onafhankelijk hertoetst tegen de live bronnen en de code** in plaats van ze uit de eigen
  aantekening over te schrijven. Alles klopt en er is niets nieuwers.
  - **GEMETEN — beide `/API changes`-pagina's onveranderd.** `prop=revisions` (zonder `rvlimit`):
    `Patch 12.1.0/API changes` (pageid 679840) nog steeds **revid 6860164, 2026-09-05T00:39:06Z**,
    102421 bytes; `Patch 12.1.5/API changes` (pageid 705933) nog steeds **revid 6863733,
    2026-09-06T17:08:08Z**, 25227 bytes. Identiek aan wat de eerste run zag — geen oudere kopie
    teruggekregen, dus geen cache-val. Geen nieuwe `/API changes`-pagina; `Patch 12.2.0` geeft
    `missing`.
  - **GEMETEN — `list=recentchanges` (ns 0, cache-busted).** De 40 nieuwste ns-0-bewerkingen
    (t/m **2026-09-10T04:54Z**) zijn **uitsluitend content**: Venerated-/Mystic-crafting-items,
    NPC's (Ramja Skyspinner, Lasan Skyhorn), zones (Splintertree Post). **Geen `/API changes`-,
    `Structure `- of `Enum.`-pagina** in de batch.
  - **Hotfixes: nieuwste sectie 9 september 2026**, dezelfde als de eerste run — niet ouder, dus
    geen cache — en tóch tegengelezen: WebSearch + Blue Tracker-spiegel
    (`wowhead.com/blue-tracker/...hotfixes-september-9-2026-...-24296142`) bevestigen 9 sep als
    nieuwste, géén 10 sep. Content-only (Achievements/Classes/Delves/Dungeons&Raids/Items/PvP/
    Prey/TBC Classic); de enige addon-nabije regels zijn Cooldown-Manager-content, **[RAAKT ONS
    NIET]**.
  - **Forum: geen beweging sinds de eerste run.** Nieuwst aangemaakte topics blijven *Double Icons*
    (**2346299**) en *Talent Swap Macro Problems* (**2346279**), beide 9 sep, beide gewone
    spelershulp zonder API-feit. `primary_groups`/`flair_groups` leeg — **geen blue post binnen 7
    dagen**. *Duration Bars* (**2345637**) nog steeds 1 post / 0 reacties.
  - **[AL AFGEDEKT] — carry-over `GetItemCooldown`, ONAFHANKELIJK HERMETEN (positieve controle,
    niet geciteerd).** `grep GetItemCooldown` over `*.lua` geeft treffers in drie bestanden: alle
    drie de aanroepers — `Modules/Delves.lua:1775`, `:1943` en `Modules/DelveItemsPopup.lua:278` —
    gaan via `ns.GetItemCooldownSafe`, dat `C_Item.GetItemCooldown` eerst probeert achter
    `if C_Item and C_Item.GetItemCooldown then` + `pcall` (`Delves.lua:354-355`) met de kale global
    als fallback (`:360`). **Geen nieuwe kale aanroep**; de fix van 6 sep staat. Het patroon vindt
    wél wat er is (17 treffers), dus de meting is echt.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op 679840+705933 en op titels `Patch 2.2.0`/`Patch 12.2.0`; `list=search`
    `intitle:"API changes"`; `list=recentchanges` ns 0); `news.blizzard.com/en-us/article/24296142`;
    `us.forums.blizzard.com` categorie-JSON 35 `order=created`; WebSearch + Blue Tracker als
    tegenlezing op de hotfix-datum. ⚠️ Directe `WebFetch` op warcraft.wiki.gg / news.blizzard.com
    blijft EGRESS_BLOCKED; alles liep via Exa.

- [2026-09-11] ✅ **Geen relevante API-wijzigingen. 0 × [MOET GEFIKST].** Er is wél een **nieuwe
  hotfix-sectie (10 sep)** — gelezen, niet overgeslagen — maar er zit geen API-, secure-frame- of
  taintwijziging in. 🔴 **De substantie van vandaag is een CORRECTIE op onze eigen aantekeningen van
  8 en 9 sep: de "force-push op `origin/main`" heeft NOOIT bestaan.** Zie het laatste punt; dat
  haalt een openstaand "Rob moet dit natrekken" weg.
  - **Hotfixes: nieuwste sectie nu `Hotfixes: September 10, 2026`** (was gisteren 9 sep), gelezen op
    `news.blizzard.com/en-us/article/24296142?nocache=20260911`. **Niet ouder dan ons eigen logboek,
    dus geen cacheval**, en tegengelezen met WebSearch: Blue Tracker voert *"World of Warcraft:
    Midnight Hotfixes - 10 September"* (us-en 2336376, eu-en 625785) als eigen topic op. Inhoud is
    volledig content: Classes, Delves, Dungeons and Raids, PvP, Prey, TBC Classic.
    - **De enige addon-nabije regel is opnieuw een Cooldown Manager-regel, en die RAAKT ONS NIET.**
      Letterlijk, onder Rogue: *"Both versions of Thistle Tea can now be tracked in the Cooldown
      Manager."* Dat is Blizzards eigen CDM (`C_CooldownViewer`/`CooldownViewer`-frames).
      **[RAAKT ONS NIET] — GEMETEN vandaag, niet van 10 sep overgeschreven:**
      `CooldownViewer|CooldownManager|C_CooldownViewer|CooldownViewerSetting|Thistle Tea` over alle
      `*.lua`/`*.xml`/`*.toc` geeft **0 bestanden met treffers op 270 gescande bestanden**.
      - 🔴 **Positieve controle in dezelfde run, dezelfde patroonvorm, dezelfde reikwijdte:**
        `GetSpellCooldown|C_Spell` over exact diezelfde 270 bestanden geeft **230 treffers in 42
        bestanden** (o.a. `Core.lua:2`, `Modules/HealerCooldowns.lua:3`,
        `Modules/ConsumableReadyBoard.lua:4`). Het patroon vindt dus wél wat er is; de nul hierboven
        is een echte nul. 📌 En het laat meteen zien waaróm: `HealerCooldowns.lua` doet zijn
        cooldowns via `C_Spell`, niet via de CDM.
    - **De Prey-regel over aura's is GETOETST en [RAAKT ONS NIET].** Letterlijk: *"The buff from
      Afflicted and Tormented Souls is no longer removed on death, by entering a battleground or
      arena, or by switching specializations, and cannot be accidentally removed by the player."*
      Dat is gedrag van een aura, dus het schuurt tegen mijn terrein aan. **GEMETEN:**
      `Afflicted|Tormented|Preyhunter|Ral'kala` over `*.lua`/`*.xml`/`*.toc` geeft **4 treffers en
      geen enkele aura-lezing** — `Modules/Profession.lua:187` is *"Lightbloom Afflicted Hide"*, een
      **skinning-node** (een substring-valse-positief, precies het soort dat hier eerder is
      misgegaan), en `Modules/Delves.lua:253,258` + `Modules/MountProgress.lua:134` zijn commentaar
      over Preyhunter's Journey-renown. Wij volgen die buffs nergens.
    - ⚠️ **Eén 10-sep-regel is voor de content-wachter en die LAAT IK DAAR LIGGEN**, in plaats van
      hem half te beantwoorden: *"Explorer's League Supplies and the Abandoned Restoration Stone
      will now appear in the Twilight Crypts delve variant 'Loosed Loa.'"* Wij dragen Delve-tips, dus
      of onze tekst hierover iets onwaars beweert is een echte vraag — maar het is een
      **content-wijziging, geen API-wijziging**, en ik heb het **niet gemeten**. Stof voor
      `docs/CONTENT_WATCH.md`.
  - **Beide `/API changes`-pagina's onveranderd t.o.v. 8, 9 én 10 sep. GEMETEN** via
    `prop=revisions` (zonder `rvlimit`): `Patch 12.1.0/API changes` (pageid 679840) nog steeds
    **revid 6860164, 2026-09-05T00:39:06Z**, 102421 bytes, comment "12.1.0 (69587)", user Ketho;
    `Patch 12.1.5/API changes` (pageid 705933) nog steeds **revid 6863733, 2026-09-06T17:08:08Z**,
    25227 bytes, comment "/* Deprecated API */". Vijfde dag zonder beweging.
  - **Geen nieuwe `/API changes`-pagina, en 12.2.0 bestaat nog steeds niet.**
    `intitle:"API changes"` op aanmaakdatum: **138 hits, ongewijzigd**, met 12.1.5 nog altijd de
    nieuwst aangemaakte. `prop=revisions` op de titels `Patch 12.2.0` en `AddOn changes` geeft voor
    beide `missing`.
  - **Geen enkele API-pagina bewerkt sinds 7 sep.** `intitle:/API/` op laatste bewerking (374 hits)
    geeft als nieuwste nog steeds `API types/ItemInfo` (**2026-09-07T10:24:43Z**) — al drie dagen
    hier gelogd, dus **geen nieuws**. Daarna `Patch 12.1.5/API changes` (6 sep),
    `Patch 11.0.2/API changes` (6 sep), `API getglobal`/`API setglobal` (6 sep). `Secret values`
    (**2026-02-07**) en `Taint` (**2010-11-25**) liggen ver buiten het venster van 7 dagen.
  - **`list=recentchanges` (ns 0, 50 wijzigingen t/m 2026-09-11T03:34:32Z) is volledig content.**
    Nieuwer dan het venster van gisteren (t/m 10 sep 04:54Z), **dus geen cache**. Uitsluitend
    voedsel-/feast-items (Sweet-And-Sour Skewers, Hearty Puffer Plate, Loa's Gathering), vissen,
    glyphs, PvP-items (Primal Combatant's Medallion of Adaptation), `Dundun (delves)` en de pagina
    `Blizzard Entertainment`. **Geen API-, secure-frame- of taintpagina, en geen `Structure `- of
    `Enum.`-pagina.**
  - **Blizzard US UI-and-Macro-forum: geen nieuw topic sinds 9 sep, en geen blue post. GEMETEN** aan
    de categorie-JSON (`order=created`, cache-buster): `primary_groups` en `flair_groups` zijn
    **allebei leeg** — geen van de 46 getoonde deelnemers heeft een Blizzard-groep (trust levels
    0–3). Nieuwst aangemaakt blijven *Double Icons* (**2346299**, 2026-09-09T19:09:08Z) en *Talent
    Swap Macro Problems* (**2346279**, 2026-09-09T17:25:20Z), beide gewone spelershulp zonder
    API-feit. *Addons api restrictions* (**2343904**) **ongewijzigd**: nog steeds 10 posts, laatste
    2026-09-05T17:29:55Z, geen blue. *Duration Bars setting not saving* (**2345637**) blijft op
    **1 post, 0 reacties** (views 14 → 18) — blijft dicht, zoals op 10 sep vastgelegd.
  - **Staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`,
    `GetItemCooldown`→`ns.GetItemCooldownSafe`) zijn deze run **niet** opnieuw getoetst en blijven
    staan zoals op 2/6/7/9/10 sep gemeten.
  - 🔴 **CORRECTIE OP 8 EN 9 SEP — er is NOOIT een force-push op `origin/main` geweest. Het was een
    leesfout van mij, veroorzaakt door een SHALLOW CLONE, en hij stond hier drie dagen als feit.**
    Op 8 sep staat (regel 915-919): *"`origin/main` was vanochtend **force-pushed** — de pull meldde
    `+ bfa77f2...c16a392 main -> origin/main (forced update)` en de lokale `main` week 50 commits
    af"*, met de vraag of Rob het zelf gedaan had; 9 sep (regel 990-994) hield die vraag open.
    **Vandaag kwam exact dezelfde melding terug** (`+ cda339b...4e899eb main -> FETCH_HEAD (forced
    update)`), en die is nu tot de bodem uitgemeten:
    - **GEMETEN dat de werkmap een shallow clone is:** `.git/shallow` bestaat en
      `git rev-parse --is-shallow-repository` geeft **true**, met bij het begin van de run
      **precies 50** bereikbare commits. 📌 Dáár komt die "50 commits divergentie" vandaan: het is
      niet een afwijking maar **de diepte van de clone zelf** — dat die twee getallen gelijk waren,
      had het weggevertje moeten zijn.
    - **GEMETEN waarom het op een herschreven historie lijkt:** vóór verdiepen gaf
      `git merge-base HEAD cda339b` **lege uitvoer** (géén gemeenschappelijke voorouder) en telden
      `HEAD..cda339b` én `cda339b..HEAD` **beide 50** — elk "de hele zichtbare historie van de
      andere kant". Achter een graft kán git de samenhang niet zien, en het resultaat is van een
      echte force-push niet te onderscheiden.
    - **GEMETEN dat de historie gewoon lineair is, na `git fetch --deepen`** (alleen lezen, niets
      herschreven): `cda339b` ("Confirm the search entry…", 9 sep 00:06) is **een gewone voorouder
      van HEAD, 75 commits terug**. En de twee commits uit de 8-sep-melding zijn dat ook:
      **`c16a392`** ("Known is not usable: a third kind of gap", 7 sep 22:41) staat **106 commits**
      terug en **`bfa77f2`** ("docs: API watch, 1 September — still nothing to test against", 1 sep
      09:14) staat **357 commits** terug. Beide op dezelfde lijn, `bfa77f2` vóór `c16a392`. Dat is
      main die van 1 sep naar 7 sep **vooruit** liep, niets anders.
    - ✅ **Dus: geen verloren commits, geen herschreven main, en Rob hoeft niets na te trekken.**
      Het open punt van 8/9 sep gaat hiermee **dicht**. ⚠️ **En de les is breder dan git:**
      `(forced update)` is hier een **eigenschap van de omgeving**, niet van de repo — precies
      zoals een lege grep een eigenschap van het patroon kan zijn in plaats van van de code. Zie
      `[[silence-is-not-absence]]`: ik heb een gereedschapsartefact als gebeurtenis gemeld, en dat
      drie dagen laten staan.
    - 📌 **Voor de volgende run:** komt `(forced update)` weer voorbij, meld het dan **niet** als
      force-push. Draai eerst `git rev-parse --is-shallow-repository`; is die `true`, dan
      `git fetch --deepen 600 origin main` en pas daarna `git merge-base --is-ancestor <oud> HEAD`.
      Is dat exit 0, dan is er niets gebeurd.
  - **Bronnen, alle met cache-buster opgehaald:** `warcraft.wiki.gg/api.php` (`prop=revisions` op
    pageids 679840+705933 én op de titels `Patch 12.2.0`/`Patch 12.1.5/API changes`/`Secret values`/
    `Taint`/`AddOn changes`; `list=search` op `intitle:"API changes"` (create_timestamp_desc) en
    `intitle:/API/` (last_edit_desc); `list=recentchanges` ns 0, 50 stuks);
    `news.blizzard.com/en-us/article/24296142`; `us.forums.blizzard.com` categorie-JSON 35 op
    `order=created`; WebSearch als tegenlezing op de hotfixdatum, mét Blue Tracker als spiegel.
    ⚠️ `WebFetch` op `warcraft.wiki.gg` en `news.blizzard.com` blijft **EGRESS_BLOCKED**; alles liep
    via `web_fetch_exa`, dat beide wél bereikt. 📌 De wiki-API antwoordt op `nocache` met
    `"Unrecognized parameter: nocache."` — **onschadelijk en juist het bewijs** dat de URL-string per
    dag verschilt. Niet "repareren".
  - ✅ **Repo: ik heb alleen dit bestand aangeraakt.** `git pull --rebase origin main` bracht de
    checkout van een **detached HEAD** naar `main` op **4e899eb**, werkboom schoon, geen van de vier
    wachter-bestanden gewijzigd-maar-ongecommit. Het verdiepen van de clone hierboven is puur lezen.
