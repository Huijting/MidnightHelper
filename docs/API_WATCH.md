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
