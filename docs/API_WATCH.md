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

- [2026-09-11] ✅ **Geen relevante API-wijzigingen (4–11 sep). 0 × [MOET GEFIKST].** Enige nieuws
  sinds de 10-sep-run is de hotfix van 10 sep; die is content, geen API. Alles via `web_fetch_exa`
  met cache-buster, plus WebSearch + Blue Tracker als tegenlezing.
  - **GEMETEN — beide `/API changes`-pagina's onveranderd.** `prop=revisions` op pageids
    679840+705933: `Patch 12.1.0/API changes` (679840) nog steeds **revid 6860164,
    2026-09-05T00:39:06Z, 102421 bytes** (comment "12.1.0 (69587)"); `Patch 12.1.5/API changes`
    (705933) nog steeds **revid 6863733, 2026-09-06T17:08:08Z, 25227 bytes** ("/* Deprecated API */").
    Identiek aan de 10-sep-meting — geen oudere kopie teruggekregen, dus geen cache-val. De 12.1.0-
    diff (5 sep) is 6 dagen oud, de 12.1.5-diff (6 sep) 5 dagen — beide binnen 7 dagen maar
    ongewijzigd en al eerder volledig getoetst; niets nieuws erin.
  - **GEMETEN — geen nieuwere `/API changes`-pagina.** `prop=revisions` op de titels
    `Patch 12.2.0/API changes` én `Patch 12.1.7/API changes`: beide **`missing`**. 12.2.0 bestaat
    nog steeds niet.
  - **GEMETEN — `list=recentchanges` (ns 0, 50 stuks, cache-busted).** Nieuwste bewerkingen t/m
    **2026-09-11T04:55Z** zijn **uitsluitend content**: tier-handschoenen/-gauntlets/-riemen
    (Forgotten/Wayward/Lost/Fallen/Fiery/Cursed/Crackling Conqueror/Protector/Vanquisher), caches
    (Cache of (Heroic) Innovation), Freya's (Heroic) Gift. **Geen `/API changes`-, `Structure `- of
    `Enum.`-pagina** in de batch.
  - **Hotfixes: nieuwste sectie 10 september 2026** (nieuw sinds de 10-sep-run, die 9 sep als
    nieuwste zag). **Geen cache-val:** Blue Tracker spiegelt exact dezelfde datum
    (`bluetracker.gg/wow/topic/us-en/2336376-world-of-warcraft-midnight-hotfixes-september-10`),
    WebSearch bevestigt 10 sep. Secties van 10 sep, volledig gelezen: Classes (DK/Hunter/Mage/
    Paladin/Rogue/Shaman), Delves, Dungeons and Raids, Player versus Player, Prey, The Burning
    Crusade Classic. **Geen UI-, addon-, API- of secure-frame-sectie.**
  - **De enige addon-nabije regel van 10 sep is Cooldown-Manager-content, en die RAAKT ONS NIET.**
    Letterlijk: "Rogue — Both versions of Thistle Tea can now be tracked in the Cooldown Manager."
    Dat is Blizzards eigen CDM (`C_CooldownViewer`/`CooldownViewer`-frames), geen Lua-API-wijziging.
    **[RAAKT ONS NIET] — GEMETEN vandaag:** grep `CooldownViewer|CooldownManager|C_CooldownViewer|
    Blizzard_CooldownViewer` over de hele addon (`docs` uitgesloten) geeft **0 bestanden**;
    "Cooldown Manager" als tekst komt alléén in de vier wachter-docs voor, niet in code.
    🔴 **Positieve controle in dezelfde run, zelfde vorm:** grep `C_Spell|GetSpellCooldown` over
    `Modules/*.lua` geeft **228 treffers in 41 bestanden**. Het patroon vindt dus wél wat er is; de
    nul hierboven is een echte nul.
  - **Forum: geen nieuwe topics sinds 9 sep, geen blue post.** **GEMETEN** aan de categorie-JSON
    (`order=created`, cache-buster): `primary_groups` én `flair_groups` zijn **leeg** — geen van de
    getoonde deelnemers heeft een Blizzard-groep (trust levels 0–3). Nieuwst aangemaakte topics nog
    steeds *Double Icons* (**2346299**, 9 sep, ElvUI-dubbelicoon) en *Talent Swap Macro Problems*
    (**2346279**, 9 sep, `/loadoutindex`-macro) — beide gewone spelershulp, geen API-feit, geen
    dev-antwoord. Niets nieuwers dan de 10-sep-run zag.
    - ✅ **Het openstaande *Duration Bars*-punt (2345637) blijft dicht.** Na vier dagen nog steeds
      **1 post, 0 reacties, 18 views**, zonder dev-antwoord en zonder tweede-speler-bevestiging.
      Eén onbevestigde melding is geen API-feit. Al op 10 sep als [RAAKT ONS NIET] gemeten (MH heeft
      geen duration-/castbar-code); geen reden dat te heropenen.
    - *Addons api restrictions* (**2343904**) **ongewijzigd**: 10 posts, laatste 2026-09-05T17:29:55Z,
      geen blue.
  - **Staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`,
    `GetItemCooldown`→`ns.GetItemCooldownSafe`) zijn deze run **niet** opnieuw getoetst en blijven
    staan zoals op 2/6/7/9/10 sep gemeten. Geen open actiepunt aan de addon-/API-kant.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op 679840+705933 én op titels `Patch 12.2.0`/`Patch 12.1.7`;
    `list=recentchanges` ns 0); `news.blizzard.com/en-us/article/24296142`;
    `us.forums.blizzard.com` categorie-JSON 35 `order=created`; WebSearch + Blue Tracker als
    tegenlezing op de hotfix-datum. ⚠️ Directe `WebFetch` op warcraft.wiki.gg / news.blizzard.com
    blijft geblokkeerd; alles liep via Exa. 📌 De wiki-API antwoordt op `nocache` met
    "Unrecognized parameter: nocache." — onschadelijk, juist het bewijs dat de URL per dag verschilt.

- [2026-09-12] ✅ **Geen relevante API-wijzigingen (5–12 sep). 0 × [MOET GEFIKST].** Geen hotfix
  sinds 10 sep, geen bewerkte `/API changes`-pagina sinds 6 sep, geen blue post. Wél één echte
  verandering in een openstaand punt: het *Duration Bars*-topic heeft na vijf dagen een tweede
  melder gekregen. Alles via `web_fetch_exa` met cache-buster (`?nocache=20260912`), plus WebSearch
  als tegenlezing.
  - **GEMETEN — beide `/API changes`-pagina's onveranderd, derde dag op rij.** `prop=revisions` op
    pageids 679840+705933: `Patch 12.1.0/API changes` nog steeds **revid 6860164,
    2026-09-05T00:39:06Z, 102421 bytes**; `Patch 12.1.5/API changes` nog steeds **revid 6863733,
    2026-09-06T17:08:08Z, 25227 bytes**. Byte-identiek aan de metingen van 10 en 11 sep — geen
    oudere kopie teruggekregen, dus geen cache-val. ⚠️ De 12.1.0-diff (5 sep) is vandaag **7 dagen**
    oud en valt hiermee uit het venster; hij is op 2/5/6/7/9/10 sep volledig getoetst en er is
    sindsdien niets bij gekomen.
  - **GEMETEN — er bestaat geen nieuwere `/API changes`-pagina.** `Patch 12.1.6`, `Patch 12.1.7` en
    `Patch 12.2.0` zijn alledrie **`missing`**. Tegenlezing met `list=search` (`intitle:"API
    changes"`, `srsort=last_edit_desc`, 15 stuks van 138 treffers): de nieuwst *bewerkte* zijn
    12.1.5 (6 sep), 11.0.2 (6 sep), 12.1.0 (5 sep) en `API change summaries` (4 sep). **Niets binnen
    7 dagen dat deze wachter niet al gelezen heeft.**
  - **GEMETEN — de kernpagina's staan stil en vallen buiten het venster:** `World of Warcraft API`
    **2026-09-04T22:38:05Z** (871833 bytes, comment "12.1.5 (69594)"), `Secret Values`
    **2026-09-04T11:56:18Z**, `Patch 12.1.5` **2026-09-03T23:11:42Z**, `Secure Execution and
    Tainting` **2026-02-15**. `AddOn changes` en `Events/Complete list` bestaan niet onder die naam
    (`missing`) — dat is een eigenschap van de titel, geen leegte in de wiki.
  - **GEMETEN — `list=recentchanges` (ns 0, 50 stuks, cache-busted).** Nieuwste bewerking
    **2026-09-12T03:37:59Z**, dus nieuwer dan de 04:55Z van 11 sep: geen cache-val. Inhoud
    **uitsluitend content**: Stormrider's Wristguards, de Orgrimmar-set, Scouting Missives, Tier
    set/Tier 1–3, Heroic: Worlds Ahead, Lady La-La's Medallion, Thistle Tea (2). **Geen
    `/API changes`-, `Structure `- of `Enum.`-pagina in de batch.** ⚠️ De 50 stuks dekken maar
    ~1,5 uur (01:59–03:37Z); de dekking over de rest van de week komt van de `list=search`
    hierboven, niet hiervan. Dat verschil stond er tot nu toe niet bij.
  - **Hotfixes: nieuwste sectie nog steeds 10 september 2026.** `news.blizzard.com/en-us/article/
    24296142` met cache-buster: secties 10 sep, 9 sep, 4 sep — **geen 11- of 12-sep-sectie**.
    WebSearch bevestigt dat onafhankelijk (nieuwste treffers 10 en 9 sep, ook op Blue Tracker; geen
    hotfixpost van 11 sep). Geen UI-, addon-, API- of secure-frame-sectie in wat er staat.
  - ⏳ **NIEUW: het *Duration Bars*-topic (2345637) heeft een tweede post. Dat verandert de status,
    niet de conclusie.** Op **2026-09-12T01:12:43Z** schrijft een tweede speler (Tumble, trust level
    2, geen blue): *"I was having this issue and came looking for answers. After finding this post,
    I found another that had a suggestion for a fix. ... If you take your character underwater, and
    then edit ui and turn them on and save and exit, they appear and work as they should."* Vier
    runs lang was dit **één onbevestigde melding**; het is nu een **tweede bevestiging plus een
    workaround**. **Het is nog steeds geen API-wijziging:** een clientbug in Blizzards eigen Edit
    Mode, geen wijziging aan een Lua-API, en nog altijd geen dev-antwoord.
    - **[RAAKT ONS NIET] voor de instelling zelf — GEMETEN vandaag:** grep
      `DurationBar|Duration Bars|durationBars|ArcheologyDigsite` over `*.{lua,xml,toc}` geeft
      **0 treffers in 0 bestanden**; de woorden komen alleen in dit logboek voor.
    - **[AL AFGEDEKT] voor de Edit-Mode-kant — en die is vandaag pas onderzocht.** De vorige runs
      stopten bij "MH heeft geen duration-/castbar-code" en keken daarmee langs het punt heen: de
      instelling die niet bewaard wordt is een **Edit Mode account setting**, en MH raakt Edit Mode
      wél aan — **19 × `C_EditMode` in 2 bestanden** (`Modules/EditModeBackup.lua` 16×,
      `Modules/BarInventory.lua` 3×). Alles is afgedekt: `EditModeBackup.lua:60` weigert als
      `C_EditMode.GetLayouts` ontbreekt, `EditModeBackup.lua:63` wacht tot
      `EditModeManagerFrame.accountSettings` er is, `BarInventory.lua:363` doet
      `if C_EditMode and C_EditMode.GetLayouts then`, `BarInventory.lua:316` vraagt alleen
      `type(C_EditMode[fn]) == "function"`, en **10 aanroepen staan in een `pcall`**. De module is
      bovendien met opzet read-only (`EditModeBackup.lua:14`, met de reden erbij). MH kan dus geen
      layout stukmaken en kan deze bug niet veroorzaken. Geen actiepunt.
    - 🔴 **Positieve controle in dezelfde run, dezelfde scope:** dezelfde grep-vorm op `C_EditMode`
      over `*.{lua,xml,toc}` geeft **19 treffers in 2 bestanden**. Het patroon vindt dus wél wat er
      is; de nul hierboven is een echte nul.
  - **Forum: één nieuw topic, geen API-feit, geen blue post.** *Cannot see the rain in game*
    (**2346840**, aangemaakt 2026-09-11T14:44:22Z, 5 posts, 20 views) — CVars, graphics settings en
    een herinstallatie, geen addon-API. **GEMETEN** aan de categorie-JSON (`order=created`,
    cache-buster): `primary_groups` én `flair_groups` zijn **leeg**, dus geen van de getoonde
    deelnemers heeft een Blizzard-groep (trust levels 0–3). *Addons api restrictions* (**2343904**)
    **ongewijzigd**: 10 posts, laatste 2026-09-05T17:29:55Z, geen blue.
  - **Staande 12.1.0-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→`C_Navigation`,
    AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`,
    `GetItemCooldown`→`ns.GetItemCooldownSafe`) zijn deze run **niet** opnieuw getoetst en blijven
    staan zoals op 2/6/7/9/10 sep gemeten. Geen open actiepunt aan de addon-/API-kant.
  - ✅ **`(forced update)` is weer langsgekomen en is weer géén force-push** — afgehandeld met het
    recept van 11 sep, niet opnieuw als vondst gemeld. `git pull --rebase` bracht de checkout van
    een **detached HEAD** naar `main` op **bab0c09** met de regel
    `+ cda339b...bab0c09 main -> origin/main (forced update)`. **GEMETEN:**
    `git rev-parse --is-shallow-repository` = **`true`**, en na `git fetch --deepen 200` geeft
    `git merge-base --is-ancestor cda339b HEAD` **exit 0** — `cda339b` is gewoon een voorouder. Het
    recept werkt; het kostte drie commando's. Werkboom schoon, geen van de vier wachter-bestanden
    gewijzigd-maar-ongecommit.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op pageids 679840+705933 én op de titels `Patch 12.1.6`/`12.1.7`/`12.2.0`,
    `Secret values`/`Secret Values`/`Taint`/`Secure Execution and Tainting`/`AddOn changes`/
    `World of Warcraft API`/`Events/Complete list`/`Patch 12.1.5`; `list=search` op
    `intitle:"API changes"` met `last_edit_desc`; `list=recentchanges` ns 0, 50 stuks);
    `news.blizzard.com/en-us/article/24296142`; `us.forums.blizzard.com` categorie-JSON 35 op
    `order=created` plus topic-JSON `2345637`; WebSearch als tegenlezing op de hotfixdatum.
    ⚠️ Directe `WebFetch` op warcraft.wiki.gg / news.blizzard.com blijft **EGRESS_BLOCKED**; alles
    liep via Exa. 📌 De wiki-API antwoordt op `nocache` met "Unrecognized parameter: nocache." —
    onschadelijk, en juist het bewijs dat de URL-string per dag verschilt.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Het verdiepen van de clone hierboven is puur
    lezen.
- [2026-09-13] ✅ **Geen relevante API-wijzigingen (6–13 sep). 0 × [MOET GEFIKST].** Geen hotfix
  sinds 10 sep, geen bewerkte `/API changes`-pagina sinds 6 sep, geen blue post. Twee dingen zijn
  wél nieuw: **Patch 12.2.0 "Eclipse" heeft een wiki-pagina** (roadmap, niet mijn terrein) en een
  **correctie op de bronnenlijst van de vorige runs** (`Events` bestaat wél). Alles via
  `web_fetch_exa` met cache-buster (`?nocache=20260913`), plus WebSearch als tegenlezing.
  - **GEMETEN — beide `/API changes`-pagina's onveranderd, vierde dag op rij.** `prop=revisions` op
    pageids 679840+705933: `Patch 12.1.0/API changes` nog steeds **revid 6860164,
    2026-09-05T00:39:06Z, 102421 bytes**; `Patch 12.1.5/API changes` nog steeds **revid 6863733,
    2026-09-06T17:08:08Z, 25227 bytes**. Byte-identiek aan 10, 11 en 12 sep. ⚠️ De 12.1.5-bewerking
    (6 sep) is vandaag **7 dagen** oud en valt hiermee als laatste uit het venster; hij is op 6/7 sep
    volledig getoetst. **Vanaf nu staat er geen enkel wiki-item meer binnen de 7 dagen** — de
    12.1.0-/12.1.5-bevindingen hieronder zijn daarmee historie, geen openstaand werk.
  - 🆕 **NIEUW, maar NIET MIJN TERREIN: `Patch 12.2.0` "Eclipse" heeft een wiki-pagina gekregen.**
    pageid **706990**, laatste bewerking **2026-09-12T23:40:16Z**, **833 bytes**, plus een redirect
    `Patch 12.2` aangemaakt **2026-09-13T01:20:59Z**. Letterlijk uit de wikitext: `Release = Winter
    2026/2027`, highlights *"New zone: The Mantle Vault · New dungeon: Thraegar's Stand · New lair:
    The Gearhold · New raid: The Worldcore · Legendary caster blade · New delves · Forsaken, night
    elf, and troll paladins · Housing updates"*, en in de patchbox `Prev = 12.1.7`, `Next = 12.2.5`.
    Dat is **content/roadmap → de PTR-wachter** (`docs/PTR_12.1_WATCH.md`); ik noteer het hier alleen
    omdat er nu een nieuwe `/API changes`-pagina kán ontstaan om op te letten. **GEMETEN vandaag:
    `Patch 12.1.6/API changes`, `Patch 12.1.7/API changes` en `Patch 12.2.0/API changes` zijn alle
    drie nog steeds `missing`.**
  - 📌 **CORRECTIE op de bronnenlijst van 11 en 12 sep: `Events` bestáát wél.** Die runs schreven dat
    `Events/Complete list` `missing` was en noemden dat "een eigenschap van de titel". Dat klopte,
    maar de conclusie was te mager: **de pagina heet gewoon `Events`** — pageid **304884**, laatste
    bewerking **2026-09-04T22:53:30Z**, **117345 bytes**. Vandaag voor het eerst tegen de juiste
    titel gemeten en daarmee binnen de vaste ronde opgenomen. Hij staat stil en valt buiten het
    7-dagenvenster. ⚠️ Dit is precies de val uit [[silence-is-not-absence]]: mijn zoekterm was fout,
    niet de wiki.
  - **GEMETEN — er is geen nieuwere `/API changes`-pagina.** `list=search` (`intitle:"API changes"`,
    `srsort=last_edit_desc`, 15 van 138 treffers): nieuwst *bewerkt* zijn 12.1.5 (6 sep), 11.0.2
    (6 sep), 12.1.0 (5 sep) en `API change summaries` (4 sep). **Niets binnen 7 dagen dat deze
    wachter niet al gelezen heeft.**
  - **GEMETEN — de kernpagina's staan stil, alle buiten het venster:** `World of Warcraft API`
    **2026-09-04T22:38:05Z** (871833 bytes, comment "12.1.5 (69594)"), `Events`
    **2026-09-04T22:53:30Z**, `Secret Values` **2026-09-04T11:56:18Z**, `Patch 12.1.5`
    **2026-09-03T23:11:42Z**, `Patch 12.1.0` **2026-08-24T17:50:03Z**, `Secure Execution and
    Tainting` **2026-02-15T17:17:51Z**.
  - **GEMETEN — `list=recentchanges` (ns 0, 50 stuks, cache-busted).** Nieuwste bewerking
    **2026-09-13T03:38:24Z**, dus nieuwer dan de 03:37:59Z van gisteren: geen cache-val. Inhoud
    **uitsluitend content**: Warcraft III / Reforged-patchpagina's (incl. een nieuwe
    `Warcraft III/Patch 3.0.0`), `Warcraft client builds`, Pandaria-NPC's, `Logo`, `War of Light and
    Shadow`, en de `Patch 12.2`-redirect hierboven. **Geen `/API changes`-, `Structure `- of
    `Enum.`-pagina in de batch.** ⚠️ De 50 stuks dekken maar ~3,2 uur (00:25–03:38Z); de dekking over
    de rest van de week komt van de `list=search` hierboven, niet hiervan.
  - **Hotfixes: nieuwste sectie nog steeds 10 september 2026 — derde dag op rij.**
    `news.blizzard.com/en-us/article/24296142` met cache-buster: secties **10 sep, 9 sep, 4 sep,
    3 sep**, géén 11-, 12- of 13-sep-sectie. Inhoud is class tuning, Delves, dungeons/raids, PvP,
    Prey en TBC Classic — **geen UI-, addon-, API- of secure-frame-sectie**. ⚠️ Dit is **gelijk aan**,
    niet ouder dan, wat mijn logboek gisteren noemde, dus geen cache-val; dat de `recentchanges`
    hierboven wél nieuwer was dan gisteren bevestigt onafhankelijk dat Exa mij vandaag verse pagina's
    gaf. WebSearch als tegenlezing geeft alleen **oudere** treffers (9 en 3 sep, Blue Tracker en
    bluetracker.gg) — indexeringsachterstand bij de zoekmachine, geen tegenspraak.
  - **Forum: één nieuw topic sinds gisteren, geen API-feit, geen blue post.** *How do i change how
    loot is looted into a bag?* (**2347002**, aangemaakt **2026-09-12T06:22:46Z**, 3 posts, 25 views)
    — vraag over de richting waarin loot in de tas wordt gezet, beantwoord door spelers. Een
    client-instelling, geen API-wijziging. **GEMETEN** aan de categorie-JSON (`order=created`,
    cache-buster): `primary_groups` én `flair_groups` zijn **leeg**, dus geen van de getoonde
    deelnemers heeft een Blizzard-groep (trust levels 0–3).
    - **Toch getoetst, want het kost één grep — [RAAKT ONS NIET].** `SetInsertItemsLeftToRight`,
      `SetSortBagsRightToLeft` en `GetInsertItemsLeftToRight` geven samen **0 treffers** over
      `*.lua`/`*.xml`/`*.toc` (zonder `docs/`): MH raakt de loot-/tasvolgorde nergens aan.
    - **[AL AFGEDEKT] voor de tas-API die MH wél gebruikt.** `C_Container`: **22 treffers in 6
      bestanden**, alleen lezend en overal geguard — `Modules/DelveItemsPopup.lua:285` (plus `pcall`
      op 287/290/292 en een tweede guard op 567), `Modules/Openables.lua:77` en `:231`,
      `Modules/BagUpgrade.lua:48`, `Core.lua:2524`, `Modules/AtalUtekProbe.lua:563-565`.
    - 🔴 **Positieve controle in dezelfde run, dezelfde scope:** dezelfde grep-vorm op `C_Timer` over
      `*.lua`/`*.xml`/`*.toc` geeft **86 bestanden**. Het patroon vindt dus wél wat er is; de nul
      hierboven is een echte nul.
  - **Twee lopende topics ongewijzigd.** *Duration Bars setting not saving* (**2345637**): nog steeds
    **2 posts**, laatste **2026-09-12T01:12:43Z**, nog altijd geen dev-antwoord — op 12 sep volledig
    getoetst ([RAAKT ONS NIET] voor de instelling zelf, [AL AFGEDEKT] voor de Edit-Mode-kant, 19 ×
    `C_EditMode` in 2 bestanden, alles geguard of in `pcall`), vandaag niet opnieuw gemeten.
    *Addons api restrictions* (**2343904**): **10 posts**, laatste **2026-09-05T17:29:55Z**, geen
    blue.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per unit-token,
    `TimedSignalMap`) zijn deze run **niet** opnieuw getoetst en blijven staan zoals op 2/6/7/9/10 sep
    gemeten. Geen open actiepunt aan de addon-/API-kant.
  - ⚠️ **Gezien maar NIET gemeten:** de WebSearch-samenvatting beweerde terloops dat "September 12-13,
    2026" BlizzCon was. Dat is een uitspraak van de zoekmachine-samenvatting, geen bron die ik gelezen
    heb, en het is hoe dan ook content/roadmap → PTR-wachter. De nieuwe 12.2.0-pagina past er wel bij.
  - ✅ **`(forced update)` opnieuw langsgekomen, opnieuw géén force-push — nu in de andere richting.**
    De sessie startte op een **detached HEAD** (`2fe81cd`) terwijl de lokale `main`-ref nog op
    `cda339b` stond; `git fetch origin main` gaf `+ cda339b...2fe81cd main -> origin/main (forced
    update)`. **GEMETEN:** `git rev-parse --is-shallow-repository` = **`true`**;
    `merge-base --is-ancestor cda339b HEAD` gaf eerst **exit 1**, en ná `git fetch --deepen 200`
    **exit 0** — `cda339b` is gewoon een voorouder van `2fe81cd`. Opgelost met `git checkout main` +
    `git reset --hard origin/main`; niets verloren. ⚠️ **Nieuw t.o.v. 11/12 sep:** de ancestry-check
    *faalt* zolang de clone ondiep is, dus `--deepen` is geen extra zekerheid maar een noodzakelijke
    stap van het recept. Werkboom schoon; geen van de vier wachter-bestanden gewijzigd-maar-ongecommit.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op pageids 679840+705933 én op de titels `Patch 12.1.6`/`12.1.7`/`12.2.0`
    `/API changes`, `World of Warcraft API`/`Secret Values`/`Secure Execution and Tainting`/
    `Patch 12.1.5`/`Patch 12.1.0`/`Events`, en `Patch 12.2.0`; `action=parse&prop=wikitext` op
    `Patch 12.2.0`; `list=search` op `intitle:"API changes"` met `last_edit_desc`;
    `list=recentchanges` ns 0, 50 stuks); `news.blizzard.com/en-us/article/24296142`;
    `us.forums.blizzard.com` categorie-JSON 35 op `order=created`; WebSearch (2×) als tegenlezing op
    de hotfixdatum en op 12.1.5-API-nieuws. ⚠️ Directe `WebFetch` op warcraft.wiki.gg /
    news.blizzard.com blijft **EGRESS_BLOCKED**; alles liep via Exa. 📌 De wiki-API antwoordt op
    `nocache` met "Unrecognized parameter: nocache." — onschadelijk, en juist het bewijs dat de
    URL-string per dag verschilt.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Het verdiepen van de clone hierboven is puur
    lezen.

- [2026-09-14] ✅ **Geen relevante API-wijzigingen (7–14 sep). 0 × [MOET GEFIKST].** Geen hotfix sinds
  10 sep, geen bewerkte `/API changes`-pagina sinds 6 sep, geen blue post, geen nieuw forumtopic.
  Het enige nieuws van vandaag is groot maar niet van mij: **BlizzCon 2026 (12–13 sep) heeft
  `World of Warcraft: Forever` aangekondigd en 12.2 "Eclipse" bevestigd** — content/roadmap, dus
  PTR-wachter. Ik heb er wél de API-kant van gemeten, want een nieuwe client kán een nieuwe
  `/API changes`-pagina betekenen: die bestaat nog niet. Alles via `web_fetch_exa` met cache-buster
  (`?nocache=20260914`), plus WebSearch als tegenlezing.
  - **GEMETEN — beide `/API changes`-pagina's onveranderd, vijfde dag op rij.** `prop=revisions` op
    pageids 679840+705933: `Patch 12.1.0/API changes` nog steeds **revid 6860164,
    2026-09-05T00:39:06Z, 102421 bytes** (user `Ketho`, comment "12.1.0 (69587)");
    `Patch 12.1.5/API changes` nog steeds **revid 6863733, 2026-09-06T17:08:08Z, 25227 bytes**
    (`/* Deprecated API */`). Byte-identiek aan 10 t/m 13 sep. **Er staat nog altijd geen enkel
    wiki-item binnen het 7-dagenvenster**; de 12.1.0-/12.1.5-bevindingen uit sep zijn historie,
    geen openstaand werk.
  - 🆕 **NIEUW, NIET MIJN TERREIN, maar de API-kant is gemeten: `World of Warcraft: Forever`.**
    Wikipagina **pageid 706932**, laatst bewerkt **2026-09-14T03:35:06Z**, **7311 bytes**. Letterlijk
    uit de wikitext: *"announced at BlizzCon 2026 and will release on 4 November 2026"*, *"referred
    to as Classic+"*, *"does not exist in the same continuity as modern World of Warcraft"*. Blizzards
    eigen ceremonie-artikel (`news.blizzard.com/en-us/article/24301453`) noemt het *"our new, third
    World of Warcraft experience alongside Modern and Classic"*, met **Beta vanaf 17 september** en
    launch **4 november 2026**, en bevestigt **Eclipse (12.2)** als *"World of Warcraft's next major
    update"*. Inhoud, zones, races, raids → **PTR-wachter** (`docs/PTR_12.1_WATCH.md`).
    - **GEMETEN — er is géén addon-/API-documentatie bij:** dat hele ceremonie-artikel bevat **geen
      UI-, addon-, API- of secure-frame-sectie**; `Patch 12.1.6/API changes`, `Patch 12.1.7/API
      changes` en `Patch 12.2.0/API changes` zijn alle drie nog steeds **`missing`**; en
      `intitle:"Planned API changes"` geeft **precies 1 treffer in de hele wiki** —
      `Patch 12.0.0/Planned API changes`, laatst bewerkt **2026-06-17T06:42:29Z**, ruim buiten het
      venster. ⚠️ **Gezien maar NIET zelf gelezen:** een WebSearch-samenvatting stelde dat Blizzard
      "no addon details, no API notes, no addon folder path" voor Forever heeft gepubliceerd. Dat
      dekt mijn eigen meting, maar de bron is een samenvatting (deels een boostshop-blog) —
      **MEASURED (via search, niet zelf gelezen)**, niet als feit te citeren.
    - **[RAAKT ONS NIET] voor de addon — MH is retail-only en vertakt nergens per client.**
      `MidnightHelper.toc:1` is `## Interface: 120007, 120100`; een Vanilla-client krijgt de addon
      dus niet eens te zien. **GEMETEN:** `WOW_PROJECT_ID`/`WOW_PROJECT_MAINLINE`/
      `WOW_PROJECT_CLASSIC` over `*.lua`/`*.xml`/`*.toc` (zonder `docs/`, `tools/`) geeft **1
      bestand, 3 treffers, alle in geleende code en alle geguard**: `Libs/LibDBIcon-1.0.lua:533`,
      `:572`, `:607`, steeds als `if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then`. **Nul treffers in
      onze eigen bestanden.** 📌 Zou Rob ooit een Forever-versie willen, dan is dat nieuw werk
      (eigen `.toc`, eigen Interface-nummer) en geen migratie van bestaande code — maar er is
      vandaag **geen enkel API-feit** om dat op te baseren.
    - 🔴 **Positieve controle in dezelfde run, dezelfde scope:** dezelfde grep-vorm op `GetBuildInfo`
      geeft **10+ treffers** (o.a. `Modules/SeasonTransition.lua:22`, `Modules/PtrProbe.lua:86`,
      `Modules/InterruptScore.lua:31`) en op `C_Timer` **85 bestanden**. Het patroon vindt dus wél
      wat er is; de nul hierboven is een echte nul.
  - **GEMETEN — er is geen nieuwere `/API changes`-pagina.** `list=search` (`intitle:"API changes"`,
    `srsort=last_edit_desc`, 15 van **138** treffers): nieuwst *bewerkt* zijn 12.1.5 (6 sep), 11.0.2
    (6 sep), 12.1.0 (5 sep) en `API change summaries` (4 sep). **Niets binnen 7 dagen dat deze
    wachter niet al gelezen heeft.**
  - **GEMETEN — de kernpagina's staan alle stil, alle buiten het venster:** `World of Warcraft API`
    **2026-09-04T22:38:05Z** (871833 bytes, "12.1.5 (69594)"), `Events` **2026-09-04T22:53:30Z**,
    `Secret Values` **2026-09-04T11:56:18Z**, `Patch 12.1.5` **2026-09-03T23:11:42Z**,
    `Patch 12.1.0` **2026-08-24T17:50:03Z**, `Secure Execution and Tainting` **2026-02-15T17:17:51Z**.
    Alle zes byte-identiek aan gisteren.
  - **GEMETEN — `list=recentchanges` (ns 0, 50 stuks, cache-busted).** Nieuwste bewerking
    **2026-09-14T03:35:17Z**, dus nieuwer dan de 03:38:24Z van gisteren: **geen cache-val**. Inhoud
    **uitsluitend content**, en bijna allemaal BlizzCon-nasleep: `World of Warcraft: Forever`,
    `World of Warcraft: Forever Collector's Edition`, `Skyborne (playable)`, de nieuwe mounts
    `Cerulean Prideclaw` en `Veteran Adventurer's Loyal Companion`, `Blizzcon Guide`,
    `Warcraft III Reforged: Forsaken Kingdom`, plus quest- en NPC-pagina's. **Geen `/API changes`-,
    `Structure `- of `Enum.`-pagina in de batch.** ⚠️ De 50 stuks dekken maar ~1,8 uur
    (01:48–03:35Z); de dekking over de rest van de week komt van de `list=search` hierboven.
  - **Hotfixes: nieuwste sectie nog steeds 10 september 2026 — vierde dag op rij.**
    `news.blizzard.com/en-us/article/24296142` met cache-buster: secties **10 sep, 9 sep, 4 sep,
    3 sep**, géén 11- t/m 14-sep-sectie. Inhoud is class tuning, Delves, dungeons/raids, PvP, Prey en
    TBC Classic — **geen UI-, addon-, API- of secure-frame-sectie**. ⚠️ Dit is **gelijk aan**, niet
    ouder dan, wat mijn logboek gisteren noemde, dus geen cache-val; de `recentchanges` hierboven was
    wél nieuwer dan gisteren en bevestigt onafhankelijk dat Exa mij vandaag verse pagina's gaf.
  - **Forum: géén nieuw topic sinds gisteren, geen API-feit, geen blue post.** Nieuwste topic is nog
    steeds *How do i change how loot is looted into a bag?* (**2347002**, aangemaakt
    **2026-09-12T06:22:46Z**), nu **4 posts** (was 3) en 40 views; de nieuwe post is
    **2026-09-13T18:02:23Z** van een speler. Op 13 sep al getoetst ([RAAKT ONS NIET] voor de
    loot-/tasvolgorde-API, [AL AFGEDEKT] voor het `C_Container`-gebruik) — vandaag niet opnieuw
    gemeten. **GEMETEN** aan de categorie-JSON (`order=created`, cache-buster): `primary_groups` én
    `flair_groups` zijn **leeg**, dus geen Blizzard-groep onder de deelnemers (trust levels 0–3).
  - **Twee lopende topics ongewijzigd.** *Duration Bars setting not saving* (**2345637**): nog steeds
    **2 posts**, laatste **2026-09-12T01:12:43Z**, nog altijd geen dev-antwoord — op 12 sep volledig
    getoetst ([RAAKT ONS NIET] / [AL AFGEDEKT], `C_EditMode` overal geguard of in `pcall`).
    *Addons api restrictions* (**2343904**): nog steeds **10 posts**, laatste
    **2026-09-05T17:29:55Z**, geen blue.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per unit-token,
    `TimedSignalMap`, `CreateFrameWithOptions`) zijn deze run **niet** opnieuw getoetst en blijven
    staan zoals op 2/6/7/9/10 sep gemeten. Geen open actiepunt aan de addon-/API-kant.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op pageids 679840+705933 én op de titels `Patch 12.1.6`/`12.1.7`/`12.2.0`
    `/API changes`, `World of Warcraft API`/`Secret Values`/`Events`/`Secure Execution and Tainting`
    en `World of Warcraft: Forever`/`Patch 12.2.0`/`Patch 12.1.5`/`Patch 12.1.0`;
    `action=parse&prop=wikitext` op `World of Warcraft: Forever`; `list=search` op
    `intitle:"API changes"` én op `intitle:"Planned API changes"`, beide `last_edit_desc`;
    `list=recentchanges` ns 0, 50 stuks); `news.blizzard.com/en-us/article/24296142` (hotfixes) en
    `/24301453` (BlizzCon-ceremonie); `us.forums.blizzard.com` categorie-JSON 35 op `order=created`;
    WebSearch (2×) als tegenlezing op 12.1.5-API-nieuws en op de BlizzCon-aankondiging. ⚠️ Directe
    `WebFetch` op warcraft.wiki.gg / news.blizzard.com blijft **EGRESS_BLOCKED**; alles liep via Exa.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang schoon; geen van de
    vier wachter-bestanden stond gewijzigd-maar-ongecommit. ⚠️ `git pull --rebase origin main` gaf
    opnieuw een `(forced update)`-regel (`+ cda339b...f28cc0d main -> origin/main`) gevolgd door
    **`Already up to date.`** — dit is de bekende ondiepe-clone-ruis van 11/12/13 sep, geen
    force-push: de rebase had niets te doen en er is niets verloren.
- [2026-09-15] ✅ **Geen relevante API-wijzigingen (8–15 sep). 0 × [MOET GEFIKST].** Geen hotfix
  sinds 10 sep, geen wiki-bewerking aan enige API-pagina binnen het venster, geen blue post. Wat er
  wél nieuw is, is **één forumtopic dat een API-restrictie noemt** — getoetst aan de code en
  [AL AFGEDEKT]. Details, met per bron de meting:
  - 🧩 **NIEUW TOPIC, GETOETST — *MSBT or Nothing* (`2349553`, aangemaakt 2026-09-14T22:45:18Z,
    1 post, 5 views, geen dev-antwoord).** Letterlijk: *"When the new API rework that came out and
    killed MSBT, which still has been bugging the crap out of me, has anyone else just not played
    with numbers on their screen anymore?"* en *"Will this ever be allowed to be used in addons
    again or is it too code based in the API that it cant move to another source?"*
    - ⚠️ **Dit is GEEN nieuw API-feit.** Het is een speler die naar de bestaande
      `COMBAT_LOG_EVENT_UNFILTERED`-restrictie uit 12.0 verwijst; er staat geen datum, geen versie
      en geen bron bij. **MEASURED (via search, niet zelf gelezen):** een tegenlezing bevestigt
      dezelfde oorzaak — SCT-addons lekken andermans schade en *"this cannot be fixed until
      Blizzard eases the restrictions of `COMBAT_LOG_EVENT_UNFILTERED`"*. Geen aankondiging dat er
      iets aan verandert. Ik tel het daarom **niet** als wijziging, maar wel als toets, omdat het
      precies de API raakt waar één van onze modules op leunt.
    - **[AL AFGEDEKT]** `Modules/Retrospective.lua` is de enige module die het event registreert, en
      hij doet het defensief: `DoClogRegistration()` (`Retrospective.lua:570-596`) registreert
      alleen in dungeons/raids (`inTrackedInstance()`), **leest de registratie synchroon terug** met
      `clog:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED")` (`:596`) in plaats van te geloven dat
      hij gelukt is, kent een `MAX_CLOG_ATTEMPTS`-pogingencap, een `CLEUProvenClosedThisBuild()`-
      kortsluiting en `StandDownCLEU()` (`:569`, `:619`) dat het event weer afmeldt. Het comment op
      `:53-119` beschrijft de restrictie in Blizzards eigen bewoording. Bovendien staat de
      afzonderlijke uitleg in `Modules/InterruptScore.lua:325` — *"Midnight refuses
      `COMBAT_LOG_EVENT_UNFILTERED` to every addon — measured"* — en `InterruptScore.lua:373` legt
      uit dat de interrupt-attributie het event helemáál niet nodig heeft. Er is `/mh death` als
      diagnose, dus correct zwijgen is van kapot te onderscheiden. Geen actie.
    - **GEMETEN — wij hebben geen floating-combat-text-pad.** Dezelfde grep over de addon (zonder
      `.git`, `docs`, `tools`, `dist`) op `COMBAT_TEXT_UPDATE`, `SHOW_COMBAT_TEXT`,
      `FloatingCombatText` en `CombatText_` geeft **nul treffers**. 🔴 **Positieve controle in
      dezelfde run, dezelfde scope en dezelfde grep-vorm:** `COMBAT_LOG_EVENT_UNFILTERED` geeft
      **13 treffers in 3 bestanden** (`Retrospective.lua`, `InterruptScore.lua`,
      `EventProbe.lua:31`). Het patroon vindt dus wél wat er is; de nul hierboven is een echte nul.
      Wat MSBT sloopt, kan bij ons geen scherm-element raken dat niet bestaat.
  - 🧩 **Tweede nieuw topic, [RAAKT ONS NIET] — *New AddOn: ChromaChat for easier chat
    reading/tracking* (`2349301`, 2026-09-14T17:44:29Z, 1 post).** Een addon-aankondiging over
    kleuren in de chat, geen API-bewering, geen dev-antwoord. Eén regel, klaar.
  - **Forum: geen blue post.** **GEMETEN** aan de categorie-JSON 35 (`order=created`, cache-buster):
    `primary_groups` én `flair_groups` zijn **leeg**, dus geen Blizzard-groep onder de deelnemers
    (trust levels 0–3). *How do i change how loot is looted into a bag?* (`2347002`) groeide van 4
    naar **5 posts** (laatste 2026-09-15T02:06:59Z, speler); op 13 sep al getoetst
    ([RAAKT ONS NIET] / [AL AFGEDEKT] voor `C_Container`) — vandaag niet opnieuw gemeten.
    *Duration Bars setting not saving* (`2345637`) en *Addons api restrictions* (`2343904`) zijn
    ongewijzigd en buiten het venster.
  - **GEMETEN — geen enkele API-pagina bewerkt binnen 7 dagen.** `prop=revisions`, cache-busted:
    `World of Warcraft API` **2026-09-04T22:38:05Z** (871833 bytes, comment "12.1.5 (69594)"),
    `Events` **2026-09-04T22:53:30Z**, `Secret Values` **2026-09-04T11:56:18Z**,
    `Secure Execution and Tainting` **2026-02-15T17:17:51Z**, `Patch 12.1.5` **2026-09-03T23:11:42Z**,
    `Patch 12.1.0` **2026-08-24T17:50:03Z**, `Patch 12.1.0/API changes` **2026-09-05T00:39:06Z**,
    `Patch 12.1.5/API changes` **2026-09-06T17:08:08Z**. Alle acht byte-identiek aan gisteren en
    alle acht **buiten** het 8–15-sep-venster. `Patch 12.1.6/API changes` en
    `Patch 12.2.0/API changes` bestaan nog steeds **niet** (`"missing": true`).
  - **GEMETEN — er is geen nieuwere `/API changes`-pagina.** `list=search`
    (`intitle:"API changes"`, `srsort=last_edit_desc`, 15 van **138** treffers): nieuwst *bewerkt*
    zijn 12.1.5 (**6 sep**), 11.0.2 (**6 sep**), 12.1.0 (**5 sep**) en `API change summaries`
    (**4 sep**). De nieuwste is negen dagen oud — **niets binnen 7 dagen**.
  - **GEMETEN — geen cache-val.** `list=recentchanges` (ns 0, 50 stuks, cache-busted): nieuwste
    bewerking **2026-09-15T03:32:39Z**, bijna een etmaal nieuwer dan wat mijn logboek gisteren
    noemde (**2026-09-14T03:35:17Z**), dus verse data en geen cache. Inhoud **uitsluitend content**: de Shen'dorei
    Peacekeeper-transmogset (9 nieuwe itempagina's, itemIDs 271733–271743), storm worgs, quests
    (*And Stay Dead!*, *Going for the Crown*), `World of Warcraft: Forever`. **Geen
    `/API changes`-, `Structure `- of `Enum.`-pagina in de batch.** ⚠️ De 50 stuks dekken maar
    ~3,5 uur (00:04–03:32Z); de dekking over de rest van de week komt van de `list=search` hierboven.
  - **Hotfixes: nieuwste sectie nog steeds 10 september 2026 — vijfde dag op rij.**
    `news.blizzard.com/en-us/article/24296142` met cache-buster: secties **10 sep, 9 sep, 4 sep,
    3 sep, 2 sep**, géén 11- t/m 15-sep-sectie. Inhoud is class tuning, Delves, Dungeons and Raids,
    PvP, Prey en TBC Classic — **geen UI-, addon-, API- of secure-frame-sectie**. ⚠️ Dit is **gelijk
    aan**, niet ouder dan, wat mijn logboek gisteren noemde, dus geen cache-val; de `recentchanges`
    en de twee nieuwe forumtopics hierboven bevestigen onafhankelijk dat Exa mij vandaag verse
    pagina's gaf.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per unit-token,
    `TimedSignalMap`, `CreateFrameWithOptions`) zijn deze run **niet** opnieuw getoetst en blijven
    staan zoals op 2/6/7/9/10 sep gemeten. Een WebSearch als tegenlezing op 12.1.5-API-nieuws gaf
    exact diezelfde twee punten (castbar-ID's per unit-token, `TimedSignalMap`) en niets nieuwers.
    Geen open actiepunt aan de addon-/API-kant.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op de acht titels hierboven plus `Patch 12.1.6`/`12.2.0` `/API changes`;
    `list=search` op `intitle:"API changes"`, `last_edit_desc`; `list=recentchanges` ns 0, 50 stuks);
    `news.blizzard.com/en-us/article/24296142` (hotfixes); `us.forums.blizzard.com` categorie-JSON 35
    op `order=created` én de topic-JSON van `2349553`; WebSearch (2×) als tegenlezing op
    12.1.5-API-nieuws en op de MSBT-claim. ⚠️ Directe `WebFetch` op warcraft.wiki.gg /
    news.blizzard.com blijft **EGRESS_BLOCKED**; alles liep via Exa.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang schoon; geen van de
    vier wachter-bestanden stond gewijzigd-maar-ongecommit. ⚠️ De sessie startte met een
    **detached HEAD** op `72d8b70` terwijl `main` 50 commits achterliep; `git checkout main` +
    `git pull --rebase origin main` zette main weer op `72d8b70`. De pull gaf opnieuw een
    `(forced update)`-regel (`+ cda339b...72d8b70 main -> origin/main`) — dit is de bekende
    ondiepe-clone-ruis van 11/12/13/14 sep, geen force-push: er is niets verloren.
- [2026-09-16] ✅ **Geen relevante API-wijzigingen (9–16 sep). 0 × [MOET GEFIKST].** Er is voor het
  eerst in zes dagen een **nieuwe hotfix-sectie (15 september 2026)**, maar die heeft geen UI-,
  addon-, API- of secure-frame-regel. Verder één nieuw forumtopic binnen het venster, getoetst aan de
  code en [RAAKT ONS NIET]. Details, met per bron de meting:
  - **Hotfixes: nieuwe sectie 15 september 2026 — GEEN UI-/addon-/API-regel.**
    `news.blizzard.com/en-us/article/24296142` met cache-buster gaf als titel *"Hotfixes:
    September 15, 2026"*; secties nu **15 sep, 10 sep, 9 sep, 4 sep, 3 sep, 2 sep**. ⚠️ Dit is
    **nieuwer** dan wat mijn logboek gisteren noemde (nieuwste sectie was 10 sep), dus verse pagina
    en geen cache-val. De 15-sep-sectie bestaat uit **Classes** (Hunter/Paladin/Priest-fixes),
    **Dungeons and Raids** (The Venomous Abyss, The Coiled Altar, Ula'tek — tuning), **Items**,
    **Quests** en **The Coiled Isle**. Geen enkele kop over User Interface, Accessibility, AddOns,
    macro's of secure frames. **Niets aan de API-kant om te toetsen.**
    - 📌 **Eén regel is wél een contentfeit, en die is niet van mij:** *"Curse Surges now rotate
      every 30 minutes (was 45 minutes)."* Dat hoort bij `docs/CONTENT_WATCH.md` (wat de addon
      *beweert*), niet bij deze wachter. **Wel één keer gemeten zodat niemand het hoeft te zoeken:**
      de addon noemt **nergens een tijdsinterval** bij Curse Surges. `[Cc]urse ?[Ss]urge` geeft
      buiten `docs/` drie bestanden — `Modules/AtalUtekProbe.lua`, `Locales/Codex.lua` (7×, één per
      taal, alle in de vorm *"ghostly allies at Curse Surges"*) en `site/coiled-isle.html` — en een
      tweede grep op `45 min|45-min|45 minut|elke 45|every 45` (case-insensitive, hele repo) treft
      **alleen** `docs/PTR_12.1_WATCH.md`, `docs/PTR_12.0.7_DATA.md` en
      `docs/PROPOSAL_ONMISBAAR.md` — dus geen enkele string die de speler ziet. Er valt hier voor de
      content-wachter niets te repareren; ik laat het bij deze aantekening.
  - 🧩 **NIEUW TOPIC, GETOETST — *Target on click-down instead of click-release?* (`2349816`,
    aangemaakt 2026-09-15T04:24:18Z, 2 posts, 14 views, geen dev-antwoord).** De vraag, letterlijk:
    *"Is it possible, without installing custom raidframes & party frames, to target people when the
    mouse clicks down instead of when the click releases?"* Het enige antwoord, van een speler
    (`Elvenbane`, trust level 2, `staff: false`, `moderator: false`, `admin: false`): *"Can't even do
    it with addons. I'd recommend enabling the mouseover casting feature instead, then you don't need
    to click at all."*
    - ⚠️ **Dit is GEEN API-feit en GEEN wijziging.** Het is een spelersbewering over Blizzards eigen
      raid-frames, zonder datum, versie of bron, en zonder blue-bevestiging. Ik tel het **niet** als
      wijziging, maar wel als toets, omdat het precies de mechaniek noemt waar onze klikbare-in-combat
      knoppen op leunen.
    - **[RAAKT ONS NIET] — het gaat over een andere mechaniek dan de onze.** De bewering betreft
      *unit targeting* op Blizzards raid-/party-frames. Wij hebben geen unit-frame-pad: een grep over
      de **hele addon** (zonder `docs/`) op `RegisterUnitWatch`, `SecureUnitButtonTemplate` en
      `type="target"` geeft **nul treffers**. Onze secure buttons zijn
      `type="macro"`/`type="worldmarker"`-knoppen die een spell of een marker uitvoeren, niet iets
      dat een unit target.
    - 🔴 **Positieve controle in dezelfde run, dezelfde scope, dezelfde grep-vorm:**
      `RegisterForClicks` geeft **29 treffers in 20 bestanden** — waarvan één de documentatieregel
      `CLAUDE.md:344` is, dus **28 in 19 codebestanden** — waarvan **12** de gedocumenteerde
      `("AnyUp", "AnyDown")`-vorm gebruiken (`Modules/MissingBuff.lua:678`, `FastMark.lua:94`,
      `Openables.lua:385`, `PotionButton.lua:110`, `PartyTargets.lua:1512`,
      `ConsumableReadyBoard.lua:464` en `:500`, `Delves.lua:3951`/`:4034`/`:4053`,
      `DelveItemsPopup.lua:1041`, `DelveItemBrokers.lua:104`). Het patroon vindt dus wél wat er is;
      de nul hierboven is een echte nul. **En er is geen bron die zegt dat `AnyDown` op een
      `SecureActionButtonTemplate` veranderd is** — niet op de wiki (alle API-pagina's ongewijzigd,
      zie hieronder) en niet in dit topic. Geen actie.
  - **Forum: geen blue post.** **GEMETEN** aan de categorie-JSON 35 (`order=created`, cache-buster):
    `primary_groups` én `flair_groups` zijn **leeg**, dus geen Blizzard-groep onder de deelnemers
    (trust levels 0–3). *Duration Bars setting not saving* (`2345637`) groeide van 2 naar **3 posts**
    (laatste 2026-09-15T09:25:46Z); **gemeten aan `/raw/2345637/3`** is die derde post een bedankje
    van de OP (*"Oh my god, I love you!"*) met een spelers-workaround — je karakter onder water
    laten gaan zodat de bars verschijnen en dán in Edit Mode bewaren. **Geen API-feit, geen
    dev-antwoord**; het topic is op 12 sep al volledig getoetst ([RAAKT ONS NIET] / [AL AFGEDEKT],
    `C_EditMode` overal geguard of in `pcall`) en ik toets het niet opnieuw. *MSBT or Nothing*
    (`2349553`) en *ChromaChat* (`2349301`) zijn ongewijzigd op 1 post en op 15 sep al getoetst.
    *How do i change how loot is looted into a bag?* (`2347002`) staat nog op **5 posts** (laatste
    2026-09-15T02:06:59Z), ongewijzigd sinds gisteren. *Addons api restrictions* (`2343904`) is uit
    de eerste pagina op `order=created` gezakt en ligt buiten het venster.
  - **GEMETEN — geen enkele API-pagina bewerkt binnen 7 dagen.** `prop=revisions`, cache-busted, alle
    acht **byte-identiek** aan gisteren en alle acht **buiten** het 9–16-sep-venster:
    `World of Warcraft API` **2026-09-04T22:38:05Z** (871833 bytes, comment "12.1.5 (69594)"),
    `Events` **2026-09-04T22:53:30Z** (117345 bytes), `Secret Values` **2026-09-04T11:56:18Z**
    (30685 bytes), `Secure Execution and Tainting` **2026-02-15T17:17:51Z** (9636 bytes),
    `Patch 12.1.5` **2026-09-03T23:11:42Z**, `Patch 12.1.0` **2026-08-24T17:50:03Z**,
    `Patch 12.1.0/API changes` **2026-09-05T00:39:06Z** (102421 bytes),
    `Patch 12.1.5/API changes` **2026-09-06T17:08:08Z** (25227 bytes). `Patch 12.1.6/API changes` en
    `Patch 12.2.0/API changes` bestaan nog steeds **niet** (`"missing": true`).
  - **GEMETEN — er is geen nieuwere `/API changes`-pagina.** `list=search`
    (`intitle:"API changes"`, `srsort=last_edit_desc`, 12 van **138** treffers): nieuwst *bewerkt*
    zijn 12.1.5 (**6 sep**), 11.0.2 (**6 sep**), 12.1.0 (**5 sep**) en `API change summaries`
    (**4 sep**). De nieuwste is **tien dagen** oud — niets binnen 7 dagen.
  - **GEMETEN — geen cache-val op de wiki.** `list=recentchanges` (ns 0, 50 stuks, cache-busted):
    nieuwste bewerking **2026-09-16T03:29:59Z**, bijna een etmaal nieuwer dan wat mijn logboek
    gisteren noemde (**2026-09-15T03:32:39Z**), dus verse data. Inhoud **uitsluitend content**:
    wolven/worgs (Spirit Worg, Frostwolf Bloodhound, Den Mother Ylva, Rayder), quests (*Be Raptor*,
    *Beasts of the Apocalypse!*, *Beating Them Back!*), items en een Mastery-update voor Mistweaver.
    **Geen `/API changes`-, `Structure `- of `Enum.`-pagina in de batch.** ⚠️ De 50 stuks dekken maar
    ~2,3 uur (01:10–03:29Z); de dekking over de rest van de week komt van de `list=search` hierboven.
  - **Tegenlezing met WebSearch (2×) — niets nieuws.** Een zoekvraag op *"12.1.6 PTR API changes
    addon secure frames September 2026"* en één op *"Midnight addon API breaking change secret values
    taint September 2026"* leverden **uitsluitend al bekende 12.0.x-/12.1.0-punten** op
    (AuraContainer/AuraButton + Forbidden Partition/ForbiddenAspect, Group Buffs via `C_UnitAuras`,
    `SetCooldown` met secret values → `SetCooldownFromDurationObject` uit 12.0.1, de
    `SimulateMouse`-beperking uit 12.0.7). **MEASURED (via search, niet zelf gelezen):** er is geen
    aanwijzing voor een 12.1.6-PTR-build, wat klopt met de ontbrekende wiki-pagina hierboven.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per unit-token,
    `TimedSignalMap`, `CreateFrameWithOptions`, de `COMBAT_LOG_EVENT_UNFILTERED`-restrictie) zijn
    deze run **niet** opnieuw getoetst en blijven staan zoals op 2/6/7/9/10/15 sep gemeten. Geen open
    actiepunt aan de addon-/API-kant.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op de acht titels hierboven plus `Patch 12.1.6`/`12.2.0` `/API changes`;
    `list=search` op `intitle:"API changes"`, `last_edit_desc`; `list=recentchanges` ns 0, 50 stuks);
    `news.blizzard.com/en-us/article/24296142` (hotfixes); `us.forums.blizzard.com` categorie-JSON 35
    op `order=created` (2×, met verschillende buster) plus de topic-JSON van `2349816` en `2345637`
    en `/raw/2345637/3`; WebSearch (2×) als tegenlezing. ⚠️ Directe `WebFetch` op warcraft.wiki.gg /
    news.blizzard.com blijft **EGRESS_BLOCKED**; alles liep via Exa. 📌 De wiki-API antwoordt met
    `"Unrecognized parameter: nocache"` — dat is een waarschuwing van MediaWiki, niet een fout: de
    buster hoort ook niet bij MediaWiki te werken maar bij de cache vóór hem, en de verse
    `recentchanges`-tijdstempel hierboven bewijst dat hij zijn werk doet.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang schoon; geen van de
    vier wachter-bestanden stond gewijzigd-maar-ongecommit. ⚠️ De sessie startte opnieuw met een
    **detached HEAD** (op `1c02256`, 50 commits vóór `main`); `git checkout main` gaf de bekende
    *"you are leaving 50 commits behind"*-waarschuwing. Dat is de ondiepe-clone-ruis van
    11/12/13/14/15 sep, geen verlies — `origin/main` heeft die commits.
- [2026-09-17] ✅ **Geen relevante API-wijzigingen (10–17 sep). 0 × [MOET GEFIKST].** Voor het eerst
  sinds 5 sep is er een wiki-pagina **binnen het venster bewerkt** — `Patch 12.1.5`, op 16 sep, van
  11445 naar 16242 bytes. Ik heb de diff gelezen: hij is vrijwel geheel **class tuning**, plus
  **één** nieuwe regel in de UI-sectie, en die is een Blizzard-*instelling*, geen Lua-API. Alle drie
  de addon-nabije regels zijn aan de code getoetst. Details, met per bron de meting:
  - 🆕 **`Patch 12.1.5` (wiki) bewerkt binnen het venster — GEMETEN.** `prop=revisions&rvlimit=8`,
    cache-busted: twee bewerkingen op **16 sep** (`6876266`, Dark T Zeratul, 2026-09-16T04:10:52Z,
    16244 bytes; `6876301`, Mordecay, 2026-09-16T06:00:57Z, 16242 bytes), boven op de vorige van
    **2026-09-03T23:11:42Z** (11445 bytes) die mijn logboek tot gisteren noemde. ⚠️ Dit is dus
    **nieuwer** dan wat ik gisteren had, geen cache-val. De volledige diff `6858016 → 6876301` is
    gelezen via `action=compare`.
    - **Inhoud, letterlijk:** nieuwe class-secties voor **Druid** (Restoration, Nature's Bounty
      redesign), **Evoker** (Preservation), **Mage** (Arcane + Frost + Hero Talents), **Priest**
      (Discipline, Holy), **Rogue** (Outlaw, Subtlety) en uitbreidingen bij **Demon Hunter** en
      **Warrior**; plus één raidtest-regel (*"Kith'ix raid testing starts September 16"*). **Geen
      enkele regel over de Lua-API, secure frames, taint of secret values.**
    - 🧩 **[RAAKT ONS NIET] — de enige nieuwe UI-regel.** Letterlijk: *"Added a new setting called
      "Pulse Your Health" under the Combat Audio Alerts section of the Audio Assist settings. This
      setting allows the player to specify a health percentage below which a looping sound will be
      played. The sound gets progressively more aggressive as their health gets lower"*. Dat is een
      **instelling in Blizzards eigen Audio Assist**, geen API en geen CVar die wij lezen. Grep over
      de hele addon (zonder `docs/`) op `AudioAssist|Audio Assist|PulseYourHealth|Pulse Your Health`:
      **nul treffers**. De twee andere UI-regels op de pagina (raid frame dispel overlay pulse,
      `#showtooltip` in de ping alert) staan **ongewijzigd** in de diff en zijn niet nieuw.
    - 🧩 **[RAAKT ONS NIET] — *"Splinterstorm is now trackable in the Cooldown Manager as a Buff."***
      (Mage → Hero Talents → Spellslinger.) Wij hebben **geen Cooldown-Manager-pad**: grep op
      `C_CooldownViewer|CooldownViewer|CooldownManager|Cooldown Manager` geeft **nul treffers**.
      🔴 **Positieve controle in dezelfde run, dezelfde scope, dezelfde grep-vorm en hetzelfde
      glob-filter:** `C_Timer|InCombatLockdown` geeft **477 treffers in 103 bestanden**
      (`UI.lua` 10×, `Modules/NativeArrow.lua` 6×, `Modules/ConsumableReadyBoard.lua` 5×, …). Het
      patroon en het filter vinden dus wél wat er is; de nul hierboven is een echte nul. 📌 Dit is
      bovendien dezelfde soort **content**fix als "Dark Simulacrum can now be tracked through the
      Cooldown Manager" (19 aug) — een spell die Blizzard aan zijn eigen lijst toevoegt.
    - 🧩 **[AL AFGEDEKT] — *"Several Arcane spells have been added to the Spell Density system for
      additional visibility options for non-Mage players."*** (Mage → Arcane.) Dit verandert **welke
      spell-effecten** het systeem meetelt, niet de CVar en niet een API. Wij raken het systeem één
      keer aan: `Modules/FpsPanel.lua:52` heeft de rij
      `{ "graphicsSpellDensity", "raidGraphicsSpellDensity", "FPS_SPELLDENS", { "SPELL_DENSITY" } }`.
      Die wordt gelezen via `Read()` op `Modules/FpsPanel.lua:97-99`:
      `local getter = (C_CVar and C_CVar.GetCVar) or _G.GetCVar` met daarna een
      `type(getter) ~= "function"`-afbreking — dubbel geguard. Het label komt uit
      `LabelFor()` (`:60-76`), dat per global een `type(v) == "string"`-controle doet en terugvalt op
      onze eigen key. Niets om te repareren.
  - 📌 **Eén correctie op de pagina, en die is NIET van mij.** De Warrior-regel *"Execute damage
    increased by 100 %"* is vervangen door *"Execute damage increased by 30 %"*, en de regel
    *"Execute no longer consumes additional Rage for additional damage"* is **weggehaald**, met een
    dev-note: *"Last week's changes to Execute were not sufficient … so we're restoring Execute to
    it's previous functionality with a damage boost in 12.1.5, and are refocusing on 12.2 and 13.0"*.
    Hard-regel 3 zegt: noem een correctie expliciet, dus hier staat hij. ⚠️ **Niet gemeten tegen de
    code** — class tuning is het terrein van `docs/CONTENT_WATCH.md` (wat de addon *beweert*), niet
    van deze wachter.
  - **GEMETEN — geen enkele API-pagina bewerkt binnen 7 dagen.** `prop=revisions`, cache-busted; de
    acht titels, alle **buiten** het 10–17-sep-venster en op `Patch 12.1.5` na alle **byte-identiek**
    aan gisteren: `World of Warcraft API` **2026-09-04T22:38:05Z** (871833 bytes, comment
    "12.1.5 (69594)"), `Events` **2026-09-04T22:53:30Z** (117345 bytes), `Secret Values`
    **2026-09-04T11:56:18Z** (30685 bytes), `Secure Execution and Tainting` **2026-02-15T17:17:51Z**
    (9636 bytes), `Patch 12.1.0` **2026-08-24T17:50:03Z** (130520 bytes),
    `Patch 12.1.0/API changes` **2026-09-05T00:39:06Z** (102421 bytes),
    `Patch 12.1.5/API changes` **2026-09-06T17:08:08Z** (25227 bytes, comment "/* Deprecated API */").
    De achtste, `Patch 12.1.5`, is de bewerkte hierboven. `Patch 12.1.6/API changes` en
    `Patch 12.2.0/API changes` bestaan nog steeds **niet** (`"missing": true`). 📌 De
    **`/API changes`-pagina van 12.1.5 is dus níét meegegroeid** met de patchnotitie-pagina — wat
    klopt met wat de diff laat zien: er zat geen API-regel in.
  - **GEMETEN — er is geen nieuwere `/API changes`-pagina.** `list=search`
    (`intitle:"API changes"`, `srsort=last_edit_desc`, 12 van **138** treffers): nieuwst *bewerkt*
    zijn 12.1.5 (**6 sep**), 11.0.2 (**6 sep**), 12.1.0 (**5 sep**) en `API change summaries`
    (**4 sep**). De nieuwste is **elf dagen** oud — niets binnen 7 dagen.
  - **GEMETEN — geen cache-val op de wiki.** `list=recentchanges` (ns 0, 50 stuks, cache-busted):
    nieuwste bewerking **2026-09-17T03:33:09Z**, ruim een etmaal nieuwer dan wat mijn logboek
    gisteren noemde (**2026-09-16T03:29:59Z**), dus verse data. Inhoud **uitsluitend content**:
    Warcraft III-unitpagina's (Blademaster, Far Seer, Spirit Walker, Grunt, Peon, …), de
    *Warcraft Forever Collection* en de Skyborne-packs, `Twilight's Blade`, `Console Orb`, en
    trivia bij `Bladestorm`/`Bestial Wrath`/`Steady Shot`. **Geen `/API changes`-, `Structure `- of
    `Enum.`-pagina in de batch.** ⚠️ De 50 stuks dekken maar ~5 uur (22:37–03:33Z); de dekking over
    de rest van de week komt van de `list=search` hierboven.
  - **Hotfixes: nieuwste sectie nog steeds 15 september 2026.**
    `news.blizzard.com/en-us/article/24296142` met cache-buster gaf als titel *"Hotfixes:
    September 15, 2026"*; secties **15 sep, 10 sep, 9 sep, 4 sep, 3 sep, 2 sep**. ⚠️ Dit is **gelijk
    aan**, niet ouder dan, wat mijn logboek gisteren noemde, dus geen cache-val; de verse
    `recentchanges`-tijdstempel hierboven bevestigt onafhankelijk dat Exa mij vandaag verse pagina's
    gaf. Geen 16- of 17-sep-sectie. **Geen UI-, addon-, API- of secure-frame-kop** in de hele post.
  - **Forum: geen blue post, geen nieuw topic.** **GEMETEN** aan de categorie-JSON 35
    (`order=created`, cache-buster): `primary_groups` én `flair_groups` zijn **leeg**, dus geen
    Blizzard-groep onder de deelnemers (trust levels 0–3). Nieuwste topic is nog steeds *Target on
    click-down instead of click-release?* (`2349816`, aangemaakt 2026-09-15T04:24:18Z), **ongewijzigd
    op 2 posts** (laatste 2026-09-15T07:09:17Z; alleen de views liepen van 14 naar 20) en gisteren al
    volledig getoetst — [RAAKT ONS NIET], geen unit-frame-pad bij ons. *MSBT or Nothing* (`2349553`)
    staat nog op 1 post. Omdat de lijst op **aanmaakdatum** gesorteerd is en het nieuwste item van
    15 sep is, is er **niets nieuws aangemaakt** in de laatste twee dagen.
  - **Tegenlezing met WebSearch — één treffer nagelopen, buiten het venster én al getoetst.** De
    zoekvraag *"WoW 12.1.5 PTR API changes addon secure frames taint September 2026"* leverde als
    enige concrete claim een **Codex-review op PR `zol-wow/QUI#871`**: *"The updated vendored API
    marks Cooldown:Clear, SetCooldown, and SetCooldownFromDurationObject as protected, but this path
    invokes them from addon code on cooldowns parented to SecureActionButtonTemplate buttons."*
    - ⚠️ **GEMETEN dat dit oud is:** de PR is `created 2026-09-03T20:38:02Z`, `merged
      2026-09-03T21:30:07Z` — **veertien dagen**, dus per hard-regel 1 **geen vondst van vandaag**.
      Het is bovendien de review-bot van een ánder addon, geen Blizzard-bron.
    - **[AL AFGEDEKT], en deze run opnieuw in de code gemeten in plaats van uit mijn eigen
      aantekening geciteerd.** Onze enige `SetCooldown` staat op `Modules/CombatSafety.lua:701`
      (`f._cd:SetCooldown(GetTime(), 8)`, cosmetische preview-swipe) en
      `SetCooldownFromDurationObject` op `:598-601`, achter `if duration and
      f._cd.SetCooldownFromDurationObject then`. Het cooldown-frame maken we zelf op `:184`:
      `CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")`. **De hele voorouderketen is
      gemeten:** `f` is `CreateFrame("Button", "MidnightHelperCombatSafety", UIParent)` op `:114`, en
      een grep op `CreateFrame\(|SecureActionButtonTemplate|SetParent` over het hele bestand geeft
      **zeven** treffers (`:114`, `:160`, `:184`, `:276`, `:314`, `:323`, `:860`) — **geen enkele
      `SecureActionButtonTemplate` en geen enkele `SetParent`**. De keten is dus
      `UIParent → f → cd`, nergens protected. Het scenario uit die review (cooldown ónder een
      `SecureActionButtonTemplate`-knop) bestaat bij ons niet. Dit bevestigt de conclusie van
      `API_WATCH.md:378-383`; ik heb hem nagemeten, niet overgeschreven.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per unit-token,
    `TimedSignalMap`, `CreateFrameWithOptions`, de `COMBAT_LOG_EVENT_UNFILTERED`-restrictie) zijn
    deze run **niet** opnieuw getoetst — op het Cooldown-item hierboven na — en blijven staan zoals
    op 2/6/7/9/10/15 sep gemeten. Geen open actiepunt aan de addon-/API-kant.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op de acht titels plus `Patch 12.1.6`/`12.2.0` `/API changes`; `rvlimit=8` op
    `Patch 12.1.5`; `action=compare` `6858016→6876301`; `list=search` op `intitle:"API changes"`,
    `last_edit_desc`; `list=recentchanges` ns 0, 50 stuks); `news.blizzard.com/en-us/article/24296142`
    (hotfixes); `us.forums.blizzard.com` categorie-JSON 35 op `order=created`;
    `github.com/zol-wow/QUI/pull/871`; WebSearch (1×) als tegenlezing. ⚠️ Directe `WebFetch` op
    warcraft.wiki.gg / news.blizzard.com blijft **EGRESS_BLOCKED**; alles liep via Exa. 📌 De
    wiki-API antwoordt opnieuw met `"Unrecognized parameter: nocache"` — een MediaWiki-waarschuwing,
    geen fout: de buster hoort bij de cache vóór MediaWiki, en de verse `recentchanges`-tijdstempel
    hierboven bewijst dat hij werkt.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang **schoon**; geen van
    de vier wachter-bestanden stond gewijzigd-maar-ongecommit. ⚠️ De sessie startte opnieuw met een
    **detached HEAD**, nu op `7fb6fbc` met de waarschuwing *"you are leaving 74 commits behind"*;
    `main` stond op `be28b43` en `pull --rebase` bracht hem met een gewone **fast-forward**
    (`be28b43..7fb6fbc`, 40 bestanden) op dezelfde commit. 📌 **Anders dan 11 t/m 15 sep was er
    géén `(forced update)`-regel.** `docs/API_WATCH.md` zat **niet** in die 40 bestanden, dus er
    heeft sinds mijn vorige regel niemand anders in dit logboek geschreven.

- [2026-09-18] ✅ **Geen relevante API-wijzigingen (11–18 sep). 0 × [MOET GEFIKST].** Drie dingen
  ván vandaag of gisteren, geen ervan een API-wijziging: de **hotfixes van 17 sep**, een **nieuw
  forumtopic over `/cancelaura`** dat ons wél op een plek raakt waar ik het niet kan meten, en zes
  **wiki-pagina's over `CustomAuraContainer`** die alleen zijn omgedoopt. Per bron de meting:
  - 🆕 **Hotfixes: September 17, 2026 — GEMETEN, en de enige UI-regel raakt ons niet.**
    `news.blizzard.com/en-us/article/24296142` met cache-buster gaf als titel *"Hotfixes: September
    17, 2026"*, **nieuwer** dan wat mijn logboek gisteren noemde (*"September 15"*), dus geen
    cache-val. Onafhankelijk bevestigd op de wiki: `Hotfixes` rev `6877795` (Dark T Zeratul,
    2026-09-18T00:35:08Z, `/* September 2026 */`, 343770 → 345203 bytes) en de diff
    `6876255→6877795` gelezen. **Geen UI-, addon-, API- of secure-frame-kop**; de secties zijn
    *Dungeons and Raids* en *Player versus Player*.
    - 🧩 **[RAAKT ONS NIET] — de enige regel die de UI noemt.** Letterlijk, als developer's note
      onder Ruby Life Pools: *"A known side-effect of this change is that these creatures will no
      longer display their contribution towards enemy forces on their tooltip in the default UI."*
      Dat is een **weergave in Blizzards eigen tooltip**, geen Lua-API. Grep over de addon (zonder
      `docs/`, `tools/`, `dist/`) op `enemy forces|EnemyForces`: **nul treffers**. 🔴 **Positieve
      controle in dezelfde run, dezelfde scope en dezelfde grep-vorm:** dezelfde alternatie bevatte
      ook `ScenarioCriteria|GetCriteriaInfo|C_ScenarioInfo` en die gaf **40+ treffers** in o.a.
      `Modules/DelveCoach.lua:1730`, `Modules/Knowledge.lua:457`,
      `Modules/DelveBossShowcase.lua:1409`, `Modules/RitualBossCoach.lua:274`. Het patroon vindt dus
      wél wat er is; de nul is een echte nul. Wij lezen scenario-**criteria** voor Delves, nooit een
      enemy-forces-percentage uit een mob-tooltip. 📌 De rest van deze hotfix (PvP-rating-inflatie,
      `Font of Venomous Rage` −50% in PvP, Coiled Altar-tuning) is **content** en dus voor
      `CONTENT_WATCH.md`, niet voor mij.
  - 🆕 **Nieuw forumtopic binnen het venster: *"Cancel auras not working"* — [RAAKT ONS NIET] voor
    de gemelde spells, mét één open vraag die ik van hieruit niet kan beantwoorden.**
    `us.forums.blizzard.com/en/wow/t/2351797`, aangemaakt **2026-09-17T10:11:58Z**, 2 posts (laatste
    2026-09-17T19:09:38Z). Letterlijk: *"Did they change something with cancenl aura macros? I've
    disabled addons and what not … /cancelaura Subterfuge  /cancelaura Shadow Dance"*. Het antwoord
    (Bahz, trust level 3): *"I remember reading somewhere that some things were losing the ability to
    /cancelaura. I don't remember the list"*, met een link naar het Rogue-topic *Cant cancel Dance
    anymore?* (`2338541`).
    - ⚠️ **GEEN Blizzard-bron. GEMETEN:** beide posts in `2351797` hebben `"staff":false`,
      `"admin":false`, `"moderator":false`, en de categorie-JSON 35 heeft lege `primary_groups` én
      `flair_groups`. Het gelinkte Rogue-topic is `created 2026-08-19T03:47:40Z` — **30 dagen**, dus
      per hard-regel 1 geen vondst van vandaag. ⚠️ Van dat topic (32 posts) heb ik post 1 en post 13
      gelezen, beide spelers; ik heb **niet** gemeten of er verderop een blue post staat.
    - 🧩 **[RAAKT ONS NIET] voor de gemelde spells.** Grep op `Subterfuge`: **nul treffers**. In
      dezelfde run, dezelfde scope en dezelfde alternatie gaf `Shadow Dance` **3** treffers
      (`Modules/KeybindRoles_Rogue.lua:110` als `cooldown_bar`-entry, `:100`/`:101` in commentaar, en
      `Modules/DpsToolkit.lua:60` in commentaar) — **geen daarvan is een macro**, dus de nul is een
      echte nul en wij cancelen die twee auras nergens.
    - ⚠️ **WEL RAAKT HET ONS ELDERS, EN DAT KAN IK NIET METEN.** Wij zetten `/cancelaura` **acht
      keer** in `Modules/TeamMacrosData.lua`, in vijf spells: `Hover` (`:170`, Evoker *Hover
      Cancel*), `Aspect of the Turtle` (`:247` *Turtle Cancel*, `:314` *Shot without breaking Rapid
      Fire*), `Ice Block` (`:354`, `:382`, `:402`, drie Mage-specs *Ice Block Cancel*) en
      `Divine Shield` (`:471`, `:508`, Paladin *Bubble Cancel*). Of een aura te cancelen is, is een
      **server-side spell-flag** — niet in Lua te zien, en er staat niets over op de
      `/API changes`-pagina's die ik vandaag gelezen heb. 🔴 **Ik weet dus niet of deze vijf nog
      werken, en ik ga het niet raden.** Dit is **geen [MOET GEFIKST]**: er is niets gemeten kapot,
      en er is geen migratie te verzinnen (er is niets om naartoe te migreren — een macro werkt of
      hij doet stil niets). **De client beslist:** één in-game test volstaat, `Ice Block Cancel` is
      de makkelijkste — tweede klik moet het blok opheffen. Doet hij stil niets, dan is dat het
      symptoom en dán is het een echte vondst. 📌 Precies de vorm van *"een klik die stil niets doet
      is van buiten hetzelfde als kapot"* (CLAUDE.md, 3 sep).
  - 🆕 **Zes wiki-pagina's `Structure CustomAuraContainer*DefaultOptions` bewerkt vandaag — GEMETEN
    dat het een naamswijziging is en géén API-wijziging.** `list=recentchanges` gaf zes edits van
    P3lim tussen **2026-09-18T03:30:04Z en 03:30:25Z** (Slot, ProcessAuraPolicy,
    ItemEnchantmentLayout, ItemEnchantment, GroupLayout, Group) plus zes log-regels om 03:13 met de
    comment *"correcting script"*. `prop=revisions` op `Structure CustomAuraContainerSlotDefaultOptions`
    legt het uit: rev `6877899` is *"P3lim renamed page [[FrameXML types/CustomAuraContainerSlotDefaultOptions]]
    to [[Structure CustomAuraContainerSlotDefaultOptions]]: correcting script"* — **zelfde grootte,
    1272 bytes**. De diff `6877899→6877920` die ik las bevat precies twee dingen: `{{framexmltype}}`
    → `{{wowapitype}}`, en een weggehaalde regel `<!--dummy test-->`. **De veldentabel is
    onveranderd sinds de bot-upload van 23 aug** (rev `6841403`). Dit is wiki-onderhoud.
    - 🧩 **[AL AFGEDEKT] als er ooit wél iets verandert.** Wij gebruiken deze template echt:
      `Modules/PartyTargets.lua:326` doet `local okC, c = pcall(CreateFrame, "AuraContainer", nil,
      panel, "CustomAuraContainerTemplate")`, met `pcall(C_AddOns.LoadAddOn,
      "Blizzard_AuraContainer")` op `:314`, een foutmelding in `glowUnavailable` op `:328` en een
      capability-check op `:348` (*"AuraContainer is missing SetUnit/AddAuraSlot/SetEnabled"*). Een
      verdwenen template of een ontbrekende methode wordt dus opgevangen en gemeld, niet gegooid.
  - **GEMETEN — geen enkele `/API changes`-pagina binnen het venster bewerkt.** `prop=revisions` op
    acht titels: `Patch 12.1.5/API changes` **2026-09-06T17:08:08Z** (25227 bytes),
    `Patch 12.1.0/API changes` **2026-09-05T00:39:06Z** (102421), `API change summaries`
    **2026-09-04T13:49:28Z**, `Patch 12.0.7/API changes` **2026-08-04T04:34:26Z**;
    `Patch 12.1.6/API changes` en `Patch 12.2.0/API changes` zijn nog steeds `"missing":true`.
    Tegengelezen met `list=search` (`intitle:"API changes"`, `srsort=last_edit_desc`, 10 van **138**
    treffers): nieuwst bewerkt zijn 12.1.5 (6 sep), 11.0.2 (6 sep), 12.1.0 (5 sep) en de summaries
    (4 sep) — **twaalf dagen** oud, niets binnen 7 dagen.
  - ⚠️ **`Patch 12.1.0` (de patchpagina, niet de API-pagina) is wél binnen het venster bewerkt, en
    het is niets.** Twee edits: `6877240` (Zeal, 2026-09-17T04:04:17Z, *"Updated latest version and
    date"*) en `6877692` (Dark T Zeratul, 2026-09-17T22:48:20Z). Diff `6841965→6877692` gelezen: de
    infobox (`|Latest = September 12, 2026`, `|Version = 69214`,
    `|Latestv = {{API_LatestBuild|midnight}}`) plus één link-hernoeming
    (`Nature's Splendor (druid talent)` → `Nature's Splendor (Dragonflight)`). **Geen API- of
    UI-regel.**
  - **GEMETEN — geen cache-val.** `list=recentchanges` (ns 0, 50 stuks, cache-busted): nieuwste
    bewerking **2026-09-18T03:30:25Z**, ruim een etmaal nieuwer dan wat mijn logboek gisteren noemde
    (**2026-09-17T03:33:09Z**). De rest van de batch is content (Skyborne-NPC's op `Zephras Isle`,
    alchemie-recepten, druid-talenten) plus de `Hotfixes`- en `Alpha and beta`-pagina's. ⚠️ De 50
    stuks dekken maar ~1 uur (02:23–03:30Z); de dekking over de week komt van de `list=search` en de
    `prop=revisions` hierboven.
  - **Forum, verder dan het ene nieuwe topic:** *Target on click-down instead of click-release?*
    (`2349816`, 15 sep) staat nog op 2 posts en is gisteren al getoetst; *MSBT or Nothing*
    (`2349553`, 14 sep) nog op 1 post. De lijst is op **aanmaakdatum** gesorteerd en `2351797` is de
    nieuwste, dus daarnaast is er niets nieuws aangemaakt.
  - **Tegenlezing met WebSearch — niets binnen het venster.** *"WoW addon API change taint secure
    frames cancelaura September 17 2026"* gaf alleen tijdloze pagina's (*Secure Execution and
    Tainting*, oude `/API changes`-pagina's). ⚠️ De samenvatting beweerde er wél bij dat *"Patch
    12.1.5 was released on August 28, 2026"*. **Dat heb ik op geen enkele pagina gelezen**, het
    spreekt de wiki zelf tegen (de `Patch 12.1.5`-pagina is nog een stub van 16 kB en zijn
    API-pagina staat nog als aanstaand), en ik neem het dus **niet** over. Label: claim van het
    zoekmodel, ongeverifieerd.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per unit-token,
    `TimedSignalMap`, `CreateFrameWithOptions`, de `COMBAT_LOG_EVENT_UNFILTERED`-restrictie) zijn
    deze run **niet** opnieuw getoetst, op het AuraContainer-item hierboven na, en blijven staan
    zoals op 2/6/7/9/10/15/17 sep gemeten. Geen open actiepunt aan de addon-/API-kant.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op de acht `/API changes`-titels plus `Patch 12.1.0`, `Patch 12.1.5`,
    `Hotfixes` en `Structure CustomAuraContainerSlotDefaultOptions`; `action=compare` op
    `6841965→6877692`, `6877899→6877920` en `6876255→6877795`; `list=search`; `list=recentchanges`
    ns 0, 2×50 stuks); `news.blizzard.com/en-us/article/24296142`; `us.forums.blizzard.com`
    categorie-JSON 35 op `order=created` plus de topic-JSON van `2351797` en `2338541`; WebSearch
    (1×) als tegenlezing. ⚠️ De eerste poging op het hotfix-artikel faalde met
    **`CRAWL_LIVECRAWL_TIMEOUT`**; een tweede poging met een andere cache-buster lukte direct — een
    time-out is dus geen bewijs dat er niets staat. ⚠️ Directe `WebFetch` op warcraft.wiki.gg /
    news.blizzard.com blijft **EGRESS_BLOCKED**; alles liep via Exa. 📌 De wiki-API antwoordt
    opnieuw met `"Unrecognized parameter: nocache"` — een MediaWiki-waarschuwing, geen fout: de
    buster hoort bij de cache vóór MediaWiki, en de verse `recentchanges`-tijdstempel bewijst dat
    hij werkt.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang **schoon**; geen van
    de vier wachter-bestanden stond gewijzigd-maar-ongecommit. ⚠️ Opnieuw een **detached HEAD**, nu
    op `69774fa` (*"you are leaving 54 commits behind"*), met `main` achterop op `be28b43`;
    `pull --rebase origin main` gaf — net als 11 t/m 15 sep, anders dan gisteren — een
    **`(forced update)`**-regel (`be28b43...69774fa`) en landde op diezelfde `69774fa`. In die 72
    gewijzigde bestanden zit `docs/API_WATCH.md` wél, maar dat is **mijn eigen regel van gisteren**:
    de laatste commit op dit bestand is `11f9aa1` (*"API watch 17 Sep: …"*, Thu Sep 17 03:39:20 2026
    +0000). Er heeft dus niemand anders in dit logboek geschreven.

- [2026-09-19] 🔁 **Eén échte API-regel bijgekomen (12–19 sep): `MouseIsOver` is verhuisd naar
  `InputUtil.IsMouseOver`. 0 × [MOET GEFIKST].** Voor het eerst sinds 10 sep staat er weer een
  nieuwe regel op een `/API changes`-pagina, en er is daarnaast een tweede addon-zijdig item: de
  wiki heeft vandaag het **gedrag van `AllowLoadGameType`** in `TOC format` aangescherpt. Beide
  raken ons niet, maar beide zijn gemeten en niet aangenomen.
  - 🔁 **[RAAKT ONS NIET] — `MouseIsOver` → `InputUtil.IsMouseOver`, nieuw op de 12.1.0-pagina.**
    `Patch 12.1.0/API changes` rev `6878058` (Ketho, **2026-09-18T13:00:08Z**, 102421 → 102492
    bytes, lege comment). De diff `6860164→6878058` (gelezen via `action=compare`) bevat precies
    twee dingen, letterlijk geciteerd:
    - toegevoegd: `* {{api|MouseIsOver}} has been moved to {{tlygo|InputUtil.IsMouseOver}}.`
    - gewijzigd: `* {{api|UIParentLoadAddOn}} has been` ~~`renamed to`~~ → `moved to`
      `{{tlygo|LoadAddOnWithErrorHandling}}.`
    ⚠️ **Dit is een CORRECTIE op onze eigen aantekening van 18 aug**, die deze verhuizing als
    *"renamed"* noteerde; de wiki noemt het nu *"moved to"*. Zelfde `{{tlygo}}`-template als bij
    `MouseIsOver`, dus vermoedelijk dezelfde mechaniek (global weg, functie leeft voort in een
    namespace-tabel). 📌 De vorige revisie van die pagina dateerde van **2026-09-05T00:39:06Z**
    (`6860164`, comment *"12.1.0 (69587)"*), dus dit is de eerste inhoudelijke wijziging in twee
    weken — geen cache-artefact.
    - 🧩 **[RAAKT ONS NIET] — gemeten, mét positieve controle in dezelfde run en dezelfde scope.**
      Grep over de addon (`docs/`, `tools/`, `dist/`, `.git/` uitgesloten) op de alternatie
      `MouseIsOver|InputUtil|LoadAddOnWithErrorHandling`: **nul** treffers op `MouseIsOver` en
      **nul** op `InputUtil`, terwijl dezelfde grep `LoadAddOnWithErrorHandling` **wél** vond in
      `Core.lua:68` (comment) en `Core.lua:79`. Het patroon vindt dus wat er is; de nul is een
      echte nul.
    - ✅ **[AL AFGEDEKT] voor het gecorrigeerde item.** `Core.lua:79` doet
      `local fn = _G.LoadAddOnWithErrorHandling or _G.UIParentLoadAddOn` — een `or`-fallback die
      werkt of de oude naam nu hernoemd of verhuisd is. ⚠️ Wel staat in de comment op
      `Core.lua:68` nog *"12.1 renames `UIParentLoadAddOn` to `LoadAddOnWithErrorHandling`"*; dat
      woord klopt sinds gisteren niet meer met de bron. **Geen actiepunt** (de code gedraagt zich
      goed), hooguit een woordje als Rob dat bestand toch aanraakt.
    - ⚠️ **Verwar het niet met `Region:IsMouseOver()`, dat is iets anders en blijft.** Gemeten:
      wij gebruiken de **widget-methode** op drie plekken — `UI.lua:2038`,
      `Modules/AltOverview.lua:1545` en `:1856`, alle drie als `<frame>:IsMouseOver()`. De
      verhuisde functie is de **global** `MouseIsOver(frame)`; een methode op een widget is geen
      global en wordt hier niet genoemd. 🔴 Ik heb **niet** gemeten dat de widget-methode
      ongemoeid blijft — er staat er alleen niets over op de pagina. Wordt dit ooit wél een
      probleem, dan is `Modules/DelveCoach.lua:684` de plek om mee te kijken: daar staat
      `local focus = GetMouseFocus and GetMouseFocus()`, al netjes achter een guard.
  - 📄 **[RAAKT ONS NIET] — `TOC format` vandaag driemaal bewerkt: `AllowLoadGameType` faalt
    OPEN bij een onbekend game type.** `warcraft.wiki.gg/wiki/TOC format` revs `6878832`
    (2026-09-19T02:54:23Z), `6878834` (03:09:16Z) en `6878841` (03:35:28Z), alle drie van Zeal,
    26478 → 26970 bytes. Diff `6877637→6878841` gelezen; de toegevoegde zin staat er twee keer,
    bij de per-regel-conditional én bij de directive, letterlijk: *"If at least 1 game type is
    specified, but the client doesn't recognise ''any'' of the game types in the condition, the
    condition will still be satisfied."* Daarnaast is de rij `[ExcludeLoadGameType ...]` van een
    eigen omschrijving voorzien (stond onder een `rowspan` van de rij erboven).
    ⚠️ **Dit is wiki-documentatie van bestaand clientgedrag, geen aangekondigde API-wijziging** —
    er staat geen build of patch bij, alleen *"Added for files in 11.1.5. Added for metadata in
    12.0.7."*. Ik weet dus **niet** of het gedrag nieuw is of alleen nu pas opgeschreven.
    - 🧩 **Gemeten, mét positieve controle:** `MidnightHelper.toc` is het **enige** `.toc`-bestand
      in de repo (`ls *.toc`), en een grep over `*.toc` op
      `AllowLoad|ExcludeLoad|## Interface|OnlyBetaAndPTR` gaf **precies één** treffer:
      `MidnightHelper.toc:1` (`## Interface: 120007, 120100`). Dus het patroon werkt en er staat
      geen enkele `AllowLoad*`/`ExcludeLoad*`-directive in ons `.toc`. Aanvullend: `grep "\["` op
      dat bestand geeft **nul** regels, dus ook geen per-regel-conditionals. Wij kunnen hier niet
      door geraakt worden.
  - 🔁 **`/cancelaura`-topic van gisteren: twee nieuwe posts, GEEN nieuwe informatie — het punt
    blijft open en is GEEN nieuwe vondst.** `us.forums.blizzard.com/en/wow/t/2351797` staat nu op
    **4 posts** (was 2), laatste **2026-09-18T08:34:12Z**. Post 3 (dan, `"staff":false`,
    2026-09-18T04:11:57Z): *"Its not the cancel laura. Its Blizzard removed the ability to cancel
    Dance."* Post 4 (de topicstarter, 08:34Z): *"was this recent?"* — onbeantwoord. **Nog steeds
    geen Blizzard-bron**: alle vier de posts hebben `"staff":false`, `"admin":false`,
    `"moderator":false`. Onze acht `/cancelaura`-regels in `Modules/TeamMacrosData.lua` (`:170`,
    `:247`, `:314`, `:354`, `:382`, `:402`, `:471`, `:508`) staan dus nog precies zoals gisteren
    beschreven: **niet gemeten kapot, niet te meten van hieruit, en er is niets om naartoe te
    migreren.** De client beslist; `Ice Block Cancel` blijft de makkelijkste test.
  - **GEMETEN — de rest van de `/API changes`-pagina's is stil.** `prop=revisions` op acht titels:
    `Patch 12.1.5/API changes` **2026-09-06T17:08:08Z**, `API change summaries`
    **2026-09-04T13:49:28Z**, `Patch 12.0.7/API changes` **2026-08-04T04:34:26Z**;
    `Patch 12.1.6/API changes`, `Patch 12.1.7/API changes` en `Patch 12.2.0/API changes` zijn nog
    steeds `"missing":true`. Tegengelezen met `list=search` (`intitle:"API changes"`,
    `srsort=last_edit_desc`, 10 van **139** treffers, was 138): binnen het venster staat er naast
    12.1.0 nog één, **`Patch 1.60.1/API changes` (2026-09-18T14:34:36Z)** — dat is **Classic
    Anniversary**, niet Retail, en dus niet ons terrein.
  - **GEMETEN — geen nieuwe hotfix, en geen cache-val.** `news.blizzard.com/en-us/article/24296142`
    met cache-buster geeft nog altijd titel *"Hotfixes: September 17, 2026"* — **even oud** als
    wat mijn logboek gisteren noemde, niet ouder, dus dit is echt de laatste en niet een cache.
    De wiki bevestigt het onafhankelijk: `Hotfixes` staat nog op rev `6877795`
    (2026-09-18T00:35:08Z, 345203 bytes), precies de revisie die ik gisteren las. ⚠️ Eerste poging
    faalde met **`CRAWL_NOT_FOUND`** op het `…/blog/24296142`-pad; met `…/article/…` lukte het
    direct — een mislukte fetch is dus opnieuw geen bewijs dat er niets staat.
  - **GEMETEN — recentchanges is vers.** `list=recentchanges` (ns 0, 50 stuks, cache-busted):
    nieuwste bewerking **2026-09-19T03:35:28Z**, ruim een etmaal nieuwer dan wat mijn logboek
    gisteren noemde (**2026-09-18T03:30:25Z**). Buiten de drie `TOC format`-edits hierboven is de
    hele batch content (NPC's, zones, `Skyborne (playable)`, `Kirin Tor`, `Earthen Ring`) en dus
    voor `CONTENT_WATCH.md`.
  - **Forum, verder dan `2351797`:** de categorie-JSON is op **aanmaakdatum** gesorteerd en
    `2351797` (17 sep) is nog steeds de nieuwste — er is sinds gisteren **geen enkel nieuw topic**
    aangemaakt in UI and Macro. *Target on click-down instead of click-release?* (`2349816`,
    15 sep) staat nog op 2 posts; *MSBT or Nothing* (`2349553`, 14 sep) nog op 1.
  - **Tegenlezing met WebSearch — niets binnen het venster.** *"WoW addon API change September 18
    2026 MouseIsOver InputUtil taint secure frames"* gaf alleen tijdloze pagina's (*Secure
    Execution and Tainting*, oude `/API changes`-pagina's, een forumtopic uit 2020). ⚠️ De
    samenvatting beweerde er wél bij dat Blizzard op **16 sep 2026** zou hebben aangekondigd dat
    *"WoW Forever runs on Mainline's UI architecture and shares the vast majority of APIs
    available in 12.1.5"*. **Dat heb ik op geen enkele pagina zelf gelezen** en ik neem het dus
    **niet** over. Label: claim van het zoekmodel, ongeverifieerd. 📌 Als het waar is, hoort het
    bij de PTR/roadmap-wachter, niet bij mij.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per
    unit-token, `TimedSignalMap`, `CreateFrameWithOptions`, de
    `COMBAT_LOG_EVENT_UNFILTERED`-restrictie) zijn deze run **niet** opnieuw getoetst en blijven
    staan zoals op 2/6/7/9/10/15/17/18 sep gemeten. Geen open actiepunt aan de addon-/API-kant.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op de acht `/API changes`-titels plus `Hotfixes`, en apart met `rvlimit=5`
    op `Patch 12.1.0/API changes`; `action=compare` op `6860164→6878058` en `6877637→6878841`;
    `list=search`; `list=recentchanges` ns 0, 50 stuks); `news.blizzard.com/en-us/article/24296142`;
    `us.forums.blizzard.com` categorie-JSON 35 op `order=created` plus de topic-JSON van `2351797`;
    WebSearch (1×) als tegenlezing. ⚠️ Directe `WebFetch` op warcraft.wiki.gg / news.blizzard.com
    blijft **EGRESS_BLOCKED**; alles liep via Exa. 📌 De wiki-API antwoordt opnieuw met
    `"Unrecognized parameter: nocache"` — een MediaWiki-waarschuwing, geen fout: de buster hoort bij
    de cache vóór MediaWiki, en de verse `recentchanges`-tijdstempel bewijst dat hij werkt.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang **schoon**; geen van
    de vier wachter-bestanden stond gewijzigd-maar-ongecommit. ⚠️ Opnieuw een **detached HEAD**, nu
    op `c9f6bf3`; `pull --rebase origin main` gaf net als de afgelopen dagen een
    **`(forced update)`**-regel (`be28b43...c9f6bf3`) en daarna *"Already up to date"*. De laatste
    commit op dit bestand is `523171c` (*"API watch 18 Sep: …"*) — mijn eigen regel van gisteren, dus
    er heeft niemand anders in dit logboek geschreven.

- [2026-09-20] ✅ **Geen relevante API-wijzigingen (13–20 sep). 0 × [MOET GEFIKST].** Alle vier de
  bronnen staan exact zoals ik ze gisteren achterliet: geen enkele `/API changes`-pagina is
  aangeraakt, `TOC format` is stil sinds de drie edits van gisterochtend, er is geen nieuwe
  hotfix, en er is geen nieuw forumtopic of zelfs maar één nieuwe post. De nieuwe regel van
  gisteren (`MouseIsOver` → `InputUtil.IsMouseOver`) is **niet** opnieuw gemeld; wel opnieuw
  gemeten, omdat Rob na mijn run van gisteren nog code heeft gepusht.
  - **GEMETEN — de `/API changes`-pagina's zijn onveranderd.** `prop=revisions` op acht titels:
    `Patch 12.1.0/API changes` staat nog op rev **`6878058`** (Ketho, 2026-09-18T13:00:08Z,
    102492 bytes) — **exact de revisie die ik gisteren las**, dus de regel van gisteren is nog
    steeds de nieuwste. `Patch 12.1.5/API changes` **2026-09-06T17:08:08Z**, `API change
    summaries` **2026-09-04T13:49:28Z**, `Patch 12.0.7/API changes` **2026-08-04T04:34:26Z**;
    `Patch 12.1.6/…`, `12.1.7/…` en `12.2.0/API changes` nog altijd `"missing":true`.
    Tegengelezen met `list=search` (`intitle:"API changes"`, `srsort=last_edit_desc`, 10 van
    **139** treffers — hetzelfde totaal als gisteren): binnen het 7-daagse venster staan alleen
    12.1.0 (18 sep) en `Patch 1.60.1/API changes` (2026-09-18T14:34:36Z), en die laatste is
    **Classic Anniversary**, niet Retail.
  - **GEMETEN — `TOC format` is stil.** Nog steeds rev **`6878841`** (Zeal, 2026-09-19T03:35:28Z,
    26970 bytes), de laatste van de drie edits die ik gisteren al gelezen en getoetst heb. Geen
    vierde edit, dus niets nieuws over `AllowLoadGameType`.
  - **GEMETEN — geen nieuwe hotfix, en geen cache-val.** Drie onafhankelijke controles wijzen
    dezelfde kant op: (1) `news.blizzard.com/en-us/article/24296142` met cache-buster geeft titel
    *"Hotfixes: September 17, 2026"* — **even oud** als gisteren, niet ouder; (2) de wiki-pagina
    `Hotfixes` staat nog op rev `6877795` (2026-09-18T00:35:08Z, 345203 bytes), precies de
    revisie van gisteren; (3) een Exa-zoekopdracht naar een hotfix van 18 of 19 sep levert
    **niets nieuwers** op dan die van 17 sep (wel drie spiegels ervan: Wowheads Blue Tracker,
    `arctium.io/blue-posts/780` en een mmos.com-artikel van 18 sep). ⚠️ De index
    `news.blizzard.com/en-us/wow` faalde met **`CRAWL_NOT_FOUND`**; dat is opnieuw geen bewijs
    dat er niets staat, vandaar de drie andere controles.
  - **GEMETEN — recentchanges is vers, dus dit is geen cache.** `list=recentchanges` (ns 0, 50
    stuks, cache-busted): nieuwste bewerking **2026-09-20T02:57:36Z**, ruim een etmaal nieuwer
    dan wat mijn logboek gisteren noemde (2026-09-19T03:35:28Z). De hele batch is content
    (Tortollan-questitems op `Gnarldor Isle`, `Special Assignment`, WC3-pagina's, NPC's) en dus
    voor `CONTENT_WATCH.md`, niet voor mij.
  - **Forum: nul nieuwe topics én nul nieuwe posts sinds gisteren.** *Cancel auras not working*
    (`2351797`, 17 sep) is nog steeds het nieuwste topic en staat nog steeds op **4 posts**, met
    de laatste post op **2026-09-18T08:34:12Z** — identiek aan wat ik gisteren noteerde. Ook
    *Target on click-down instead of click-release?* (`2349816`, 2 posts) en *MSBT or Nothing*
    (`2349553`, 1 post) zijn onveranderd. Er is dus nog steeds **geen Blizzard-reactie** op de
    `/cancelaura`-klacht; onze acht `/cancelaura`-regels in `Modules/TeamMacrosData.lua` (`:170`,
    `:247`, `:314`, `:354`, `:382`, `:402`, `:471`, `:508`) blijven **niet gemeten kapot en niet
    te meten van hieruit**. De client beslist; `Ice Block Cancel` blijft de makkelijkste test.
  - 🔁 **HERMETEN, want de code is veranderd: `MouseIsOver`/`InputUtil` blijft [RAAKT ONS NIET].**
    Rob heeft ná mijn run van gisteren nog twee commits gepusht — `6f3e0da` (19 sep 11:49, nieuw
    bestand `Modules/PlayCards.lua`, 105 regels) en `6725ad3` (19 sep 20:43, `KeybindSchema.lua`
    plus vier `KeybindRoles_*`). Nieuwe code kan een gemeten nul ongeldig maken, dus dezelfde
    grep opnieuw gedraaid over de hele addon (`docs/`, `tools/`, `dist/`, `.git/` uitgesloten):
    **nul** treffers op `MouseIsOver`, **nul** op `InputUtil`. Positieve controle in dezelfde run
    en dezelfde scope: hetzelfde patroon vindt wél `LoadAddOnWithErrorHandling` op `Core.lua:68`
    (comment) en `Core.lua:79`, en `GetMouseFocus` op `Modules/DelveCoach.lua:684`. Het patroon
    werkt dus; de nul is een echte nul.
  - ✅ **[AL AFGEDEKT] blijft staan voor `UIParentLoadAddOn`.** `Core.lua:79` doet nog steeds
    `local fn = _G.LoadAddOnWithErrorHandling or _G.UIParentLoadAddOn`. 📌 De comment op
    `Core.lua:68` zegt nog altijd *"renames"* waar de wiki sinds 18 sep *"moved to"* schrijft —
    **geen actiepunt**, alleen een woordje voor als Rob dat bestand toch aanraakt. Dit is dezelfde
    opmerking als gisteren en geen nieuwe bevinding.
  - 🧩 **Nieuw bestand `Modules/PlayCards.lua` getoetst tegen de staande 12.1.0/12.1.5-lijst:
    [RAAKT ONS NIET].** Grep op `C_UnitAuras|C_SuperTrack|GetNextWaypointForMap|GetItemCooldown|
    GetWeaponEnchantInfo|SecureActionButtonTemplate|issecretvalue|CreateFrame|UnitCastingInfo|
    SetCooldown` over dat bestand: **nul** treffers. Positieve controle, tweeledig: dezelfde
    alternatie geeft over `Modules/` **844** treffers in **135** bestanden (o.a.
    `ConsumableReadyCheck.lua` 14×, `WorldContent.lua` 6×), en een grep op `function|local` over
    `PlayCards.lua` zelf geeft **16** treffers — het bestand is dus leesbaar én het patroon vindt
    wat er is. Het nieuwe kaartje raakt geen enkele API van de deprecation-lijst.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per
    unit-token, `TimedSignalMap`, `CreateFrameWithOptions`, de
    `COMBAT_LOG_EVENT_UNFILTERED`-restrictie) zijn deze run **niet** één voor één opnieuw
    getoetst en blijven staan zoals op 2/6/7/9/10/15/17/18/19 sep gemeten. Geen open actiepunt
    aan de addon-/API-kant.
  - **Tegenlezing met WebSearch — niets binnen het venster.** *"WoW 12.1.5 API changes addon
    taint secure frames September 19 2026"* gaf alleen pagina's die ik al ken (de
    `/API changes`-reeks, *Secure Execution and Tainting*, een danderbot-diff van 12.1.0) en vatte
    daaruit precies de vier 12.1.5-punten samen die sinds 6 sep in dit logboek staan
    (`SetCooldown`/`Clear` vanuit tainted code, castbar-ID's per unit-token,
    `CreateFrameWithOptions`, `TimedSignalMap`). **Geen enkel nieuw item.**
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op acht `/API changes`-titels plus `Hotfixes` en `TOC format`;
    `list=search`; `list=recentchanges` ns 0, 50 stuks); `news.blizzard.com/en-us/article/24296142`;
    `us.forums.blizzard.com` categorie-JSON 35 op `order=created`; `web_search_exa` (1×) op nieuwe
    hotfixes; `WebSearch` (1×) als tegenlezing. ⚠️ Directe `WebFetch` op warcraft.wiki.gg /
    news.blizzard.com blijft **EGRESS_BLOCKED**; alles liep via Exa. 📌 De wiki-API antwoordt
    opnieuw met `"Unrecognized parameter: nocache"` — een MediaWiki-waarschuwing, geen fout: de
    buster hoort bij de cache vóór MediaWiki, en de verse `recentchanges`-tijdstempel van vanochtend
    bewijst dat hij werkt.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang **schoon**; geen
    van de vier wachter-bestanden stond gewijzigd-maar-ongecommit. ⚠️ Opnieuw een **detached
    HEAD**, nu op `6725ad3`; `pull --rebase origin main` gaf net als de afgelopen dagen een
    **`(forced update)`**-regel (`be28b43...6725ad3`) en daarna *"Already up to date"*. De laatste
    commit op dit bestand is mijn eigen regel van gisteren; er heeft niemand anders in dit logboek
    geschreven.
- [2026-09-21] ✅ **Geen relevante API-wijzigingen (14–21 sep). 0 × [MOET GEFIKST].** Geen enkele
  `/API changes`-pagina is aangeraakt, `TOC format` is stil, en er is voor de **vierde dag** geen
  nieuwe hotfix-sectie sinds 17 sep. Wél **twee nieuwe forumtopics** — de eerste die dit logboek
  sinds 17 sep ziet — maar het zijn allebei gebruikersvragen zonder Blizzard-reactie en zonder
  API-claim. Ik heb ze tóch aan de code getoetst, omdat Rob vannacht `Modules/FastMark.lua` heeft
  uitgebreid en één van de twee precies daarover gaat.
  - **GEMETEN — de `/API changes`-pagina's zijn onveranderd.** `prop=revisions` op acht titels:
    `Patch 12.1.0/API changes` staat nog op rev **`6878058`** (Ketho, 2026-09-18T13:00:08Z,
    102492 bytes), `Patch 12.1.5/API changes` op rev **`6863733`** (2026-09-06T17:08:08Z, 25227
    bytes), `API change summaries` op rev `6859728` (2026-09-04T13:49:28Z), `Patch 12.0.7/API
    changes` op rev `6794100` (2026-08-04T04:34:26Z); `Patch 12.1.6/…`, `12.1.7/…` en
    `12.2.0/API changes` nog altijd `"missing":true`. Tegengelezen met `list=search`
    (`intitle:"API changes"`, `srsort=last_edit_desc`, 10 van **139** treffers — hetzelfde totaal
    als gisteren): binnen het 7-daagse venster staan nog steeds alleen 12.1.0 (18 sep) en
    `Patch 1.60.1/API changes` (2026-09-18T14:34:36Z), en die laatste is **Classic Anniversary**,
    niet Retail.
  - **GEMETEN — `TOC format` is stil.** Nog steeds rev **`6878841`** (Zeal, 2026-09-19T03:35:28Z,
    26970 bytes), de laatste van de drie edits van 19 sep. Geen vierde edit, dus niets nieuws over
    `AllowLoadGameType`.
  - **GEMETEN — vierde dag zonder nieuwe hotfix, en geen cache-val.** Drie onafhankelijke
    controles: (1) `news.blizzard.com/en-us/article/24296142` mét cache-buster geeft titel
    *"Hotfixes: September 17, 2026"* — **even oud** als gisteren, niet ouder; (2) de wiki-pagina
    `Hotfixes` staat nog op rev `6877795` (Dark T Zeratul, 2026-09-18T00:35:08Z, 345203 bytes),
    precies de revisie van gisteren; (3) een Exa-zoekopdracht naar een hotfix van 18–21 sep levert
    **niets nieuwers** dan die van 17 sep (wel de bekende spiegels: `arctium.io/blue-posts/780`,
    een pubt.io-kopie). 📌 Niets in de 17-sep-lijst raakt de UI-/addon-kant: het zijn Ruby Life
    Pools-threat, Venomous Abyss-tuning en PvP-rating-inflatie. Eén regel noemt de **default UI**
    (*"these creatures will no longer display their contribution towards enemy forces on their
    tooltip"*), maar dat is een tooltip-inhoudswijziging, geen API-wijziging — en het is
    CONTENT_WATCH-terrein.
  - **GEMETEN — recentchanges is vers, dus dit is geen cache.** `list=recentchanges` (ns 0, 50
    stuks, cache-busted): nieuwste bewerking **2026-09-21T03:33:47Z**, ruim een etmaal nieuwer dan
    wat mijn logboek gisteren noemde (2026-09-20T02:57:36Z). De hele batch is content
    (Westfall-quests, NPC's, WC3-pagina's, `Skyborne`, `Gorgonna`) en dus voor `CONTENT_WATCH.md`,
    niet voor mij.
  - 🆕 **Forum — nieuw topic *Default in game commands* (`2356245`, aangemaakt
    2026-09-20T20:07:34Z, 2 posts): [AL AFGEDEKT].** Vraag van Sakiri: *"is there a built in pull
    or break timer, or do you absolutely need an addon for this? I know ready check is doable
    without it."* Antwoord van Elvenbane (20:30:47Z), letterlijk en volledig: `/countdown ##`.
    **Geen API-wijziging, geen Blizzard-reactie** — maar het raakt precies wat Rob vannacht heeft
    gebouwd, dus getoetst: de nieuwe knop *Pull timer* in `Modules/FastMark.lua` zit achter
    `if not (C_PartyInfo and C_PartyInfo.DoCountdown) then return end` (`:415`), annuleert met
    `C_PartyInfo.DoCountdown(0)` op rechtsklik (`:419`), en de diagnose print *"countdown …
    MISSING"* als de functie ontbreekt (`:487`, `:490`). Dat is de namespace-route naar dezelfde
    ingebouwde functie die `/countdown` aanroept; wij verzinnen er niets bij. Geen actiepunt.
  - 🆕 **Forum — nieuw topic *Does Classic Era not have a LUA errors toggle?* (`2355798`,
    aangemaakt 2026-09-20T07:43:56Z, 2 posts): [RAAKT ONS NIET].** Gaat over de CVar
    `scriptErrors` in **Classic Era**; Fizzlemizz antwoordt (17:21:31Z) *"`scriptErrors` is
    there."* MH is Retail-only (`## Interface: 120007, 120100`) en gebruikt die CVar sowieso niet:
    **nul** treffers op `scriptErrors` over de hele addon (`--include=*.lua,*.xml,*.toc`, `docs/`
    uitgesloten). Positieve controle in dezelfde run en dezelfde scope: het patroon `CVar` vindt
    wél `Modules/FpsPanel.lua:97` en `:106` (`C_CVar.GetCVar` / `GetCVarDefault` met
    `or _G.…`-fallback) en `Modules/DevShots.lua:333`, `:371`–`:373`. De nul is een echte nul.
  - **Forum — *Target on click-down instead of click-release?* (`2349816`) is van 2 naar 4 posts
    gegaan, zonder API-inhoud.** Post 3 (de OP, 2026-09-20T07:51:07Z): hij heeft het opgelost met
    **Grid2 + Clique**, *"targeting is now functioning on click instead of on release"*. Post 4
    (15:00:25Z) is *"Fascinating. Glad you found something that works for you!"*. Post 2 is om
    15:00:33Z bewerkt — een doorhaling van *"Can't even do it with addons."* Geen Blizzard-reactie
    en geen claim over `RegisterForClicks` of de secure-kant; dus niets te toetsen.
  - **Forum — *Cancel auras not working* (`2351797`) onveranderd op 4 posts**, laatste post nog
    steeds **2026-09-18T08:34:12Z**, identiek aan wat ik gisteren noteerde. Nog steeds **geen
    Blizzard-reactie**; onze acht `/cancelaura`-regels in `Modules/TeamMacrosData.lua` (`:170`,
    `:247`, `:314`, `:354`, `:382`, `:402`, `:471`, `:508`) blijven **niet gemeten kapot en niet
    te meten van hieruit**. De client beslist; `Ice Block Cancel` blijft de makkelijkste test.
  - 🔁 **HERMETEN, want de code is veranderd: `MouseIsOver`/`InputUtil` blijft [RAAKT ONS NIET].**
    Rob pushte vannacht twee commits, allebei op `Modules/FastMark.lua`: `45cd9fe` (2026-09-20
    23:57:58 +0200) en `a9116e5` (2026-09-21 00:03:15 +0200, *ready check, role check and a pull
    timer*). Nieuwe code kan een gemeten nul ongeldig maken, dus dezelfde grep opnieuw over de hele
    addon (`--include=*.lua`, `docs/` en `tools/` uitgesloten): **nul** treffers op `MouseIsOver`,
    **nul** op `InputUtil`. Positieve controle in dezelfde run en dezelfde scope: hetzelfde patroon
    vindt wél `GetItemCooldown` (`Modules/Delves.lua:349`–`:360`, `Modules/DelveItemsPopup.lua:278`),
    `GetWeaponEnchantInfo` (`Modules/MissingBuff.lua:78`, `Modules/ConsumableReadyCheck.lua:734`)
    en `C_SuperTrack.GetNextWaypointForMap` (`Modules/EventProbe.lua:119`). Het patroon werkt dus;
    de nul is een echte nul.
  - 🧩 **`Modules/FastMark.lua` (533 regels, twee verse commits) getoetst tegen de staande
    12.1.0-/12.1.5-lijst: [RAAKT ONS NIET].** Grep op `MouseIsOver|InputUtil|GetItemCooldown|
    GetWeaponEnchantInfo|GetNextWaypointForMap|UntrustedScriptExecution|SetCooldown` over dat ene
    bestand: **0** treffers. Positieve controle op hetzelfde bestand:
    `CreateFrame|SecureActionButtonTemplate|InCombatLockdown|RegisterStateDriver` geeft **10**
    treffers. Het bestand is dus leesbaar voor het patroon en de nul is echt. De drie nieuwe
    groepsknoppen raken geen enkele API van de deprecation-lijst.
  - ✅ **[AL AFGEDEKT] blijft staan voor `UIParentLoadAddOn`.** `Core.lua:79` doet nog steeds
    `local fn = _G.LoadAddOnWithErrorHandling or _G.UIParentLoadAddOn`. 📌 De comment op
    `Core.lua:68` zegt nog altijd *"renames"* waar de wiki sinds 18 sep *"moved to"* schrijft —
    **geen actiepunt**, alleen een woordje voor als Rob dat bestand toch aanraakt. Dezelfde
    opmerking als 19 en 20 sep, geen nieuwe bevinding.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, AuraContainer/AuraButton, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per
    unit-token, `TimedSignalMap`, `CreateFrameWithOptions`, de
    `COMBAT_LOG_EVENT_UNFILTERED`-restrictie) zijn deze run **niet** één voor één opnieuw getoetst
    en blijven staan zoals op 2/6/7/9/10/15/17/18/19/20 sep gemeten. Geen open actiepunt aan de
    addon-/API-kant.
  - **Tegenlezing met WebSearch — niets binnen het venster.** *"WoW 12.1.5 API changes addon taint
    secure frames deprecated September 21 2026"* gaf alleen pagina's die ik al ken (de
    `/API changes`-reeks, *Secure Execution and Tainting*, een WoWUIBugs-wiki) en vatte daaruit
    precies de bekende 12.1.5-punten samen: `SetCooldown`/`Clear` vanuit tainted code, castbar-ID's
    per unit-token, `TimedSignalMap`, de nieuwe `table.*`-functies en `C_Weather`. Alle vijf staan
    al sinds 4 en 7 sep in dit logboek (regels 390–395 en 694–695). **Geen enkel nieuw item.**
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op negen titels incl. `Hotfixes` en `TOC format`; `list=search`;
    `list=recentchanges` ns 0, 50 stuks); `news.blizzard.com/en-us/article/24296142`;
    `us.forums.blizzard.com` categorie-JSON 35 op `order=created` plus de topic-JSON's `2356245`,
    `2355798` en `2349816`; `web_search_exa` (1×) op nieuwe hotfixes; `WebSearch` (1×) als
    tegenlezing. ⚠️ Directe `WebFetch` op warcraft.wiki.gg / news.blizzard.com is vandaag **niet
    opnieuw geprobeerd** — dat stond de afgelopen weken steevast op `EGRESS_BLOCKED` en alles liep
    hoe dan ook via Exa; ik meld het als aanname, niet als meting van vandaag. 📌 De wiki-API
    antwoordt opnieuw met `"Unrecognized parameter: nocache"` — een MediaWiki-waarschuwing, geen
    fout: de buster hoort bij de cache vóór MediaWiki, en de verse `recentchanges`-tijdstempel van
    vanochtend bewijst dat hij werkt.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang **schoon**; geen
    van de vier wachter-bestanden stond gewijzigd-maar-ongecommit. ⚠️ Opnieuw een **detached
    HEAD**, nu op `a9116e5`, en `fetch origin main` gaf net als de afgelopen dagen een
    **`(forced update)`**-regel (`be28b43...a9116e5`). De laatste commit op dit logboek is mijn
    eigen regel van gisteren; er heeft niemand anders in dit logboek geschreven.
- [2026-09-22] 🆕 **Er is een TWEEDE 12.1.5-changeslijst (build 69848) en die is vannacht op de
  wiki gezet. 1 × [MOET GEFIKST]** — en dat punt komt niet uit Blizzards lijst zelf maar uit het
  toetsen ervan aan onze code. Na vijf stille dagen is dit de eerste run met echte inhoud: de
  `12.1.5/API changes`-pagina groeide van **25227 naar 29966 bytes** (+4739) en er kwam ook een
  **nieuwe hotfix (21 sep)**.
  - **GEMETEN — welke pagina's bewogen.** `prop=revisions` op negen titels, cache-busted:
    `Patch 12.1.5/API changes` staat nu op rev **`6882829`** (Ketho, 2026-09-22T02:38:03Z, 29966
    bytes; `parentid` `6882828`, dus **twee** edits vannacht) — was `6863733` van 6 sep.
    `Patch 12.1.0/API changes` op rev **`6882827`** (Ketho, 2026-09-22T02:35:00Z, **102493** bytes,
    was 102492). `Hotfixes` op rev **`6882796`** (Dark T Zeratul, 2026-09-22T00:56:19Z, 346276
    bytes, was 345203). Onveranderd: `API change summaries` (`6859728`), `Patch 12.0.7/API
    changes` (`6794100`), `TOC format` (**`6878841`**, Zeal, 19 sep — vierde dag stil, dus nog
    niets nieuws over `AllowLoadGameType`); `Patch 12.1.6/…`, `12.1.7/…` en `12.2.0/API changes`
    nog altijd `"missing":true`.
  - ⚠️ **De 12.1.0-edit is 1 byte en raakt ons niet.** `action=compare` `6878058`→`6882827` geeft
    één gewijzigd blok rond regel 359: een lege regel bij een `----` vóór de kop `===2026-07-23===`.
    Geen inhoud. **[RAAKT ONS NIET]**, en genoemd zodat een bewogen revisie niet als "misschien iets"
    blijft hangen.
  - 📅 **DATERING, want dit is het randje van het 7-daagse venster.** De nieuwe sectie op de
    12.1.5-pagina heet `===2026-09-16===` en linkt naar het WoW-dev-Discord-kanaal; de
    meegekopieerde Bluepost staat op **poster=Linxy, date=Sep 16, 2026 1:09 am**. De build zelf is
    **69848 van Sep 14** (de pagina's `#description2` ging van `69594 Aug 28` naar `69848 Sep 14`).
    Dus: de **build is 8 dagen oud en daarmee bùiten het venster**, de **publicatie is 6 dagen oud
    en erbinnen**, en de **wiki-bewerking is van vandaag**. Ik neem het mee op de publicatiedatum
    en zeg dat er hardop bij. 📌 Tegengelezen met `WebSearch`: die bevestigt build 69848 en
    dev notes van **15 sep** (MMO-Champion, Wowhead, Icy Veins) — één dag eerder dan de Bluepost op
    de wiki. Welke van de twee klopt is van hieruit niet te meten; beide datums vallen binnen het
    venster, dus het verandert niets aan de conclusie. Dat de zoekmachine zélf niets over
    `UnitFrameUtil` vond, maakt de wiki-pagina hier de **enige** bron — en die heb ik via
    `action=compare` letterlijk gelezen, niet als samenvatting.
  - 🔴 **[MOET GEFIKST] — `Modules/DundunShrine.lua:731` doet `tostring(aura.name)` zonder
    `issecretvalue`-poortje, en de nieuwe lijst zegt dat dát kon crashen.** Letterlijk uit de
    12.1.5-sectie: *"Fixed an issue that could cause some APIs, like tostring and dumpobject, to
    crash when passed secret objects."* Een **fix in 12.1.5** betekent dat het op de **live
    12.1.0-client waar Rob op speelt nog stuk is**. De regel luidt
    `out.bountifulAura = "PRESENT: " .. tostring(aura.name)`, met `aura` uit
    `pcall(C_UnitAuras.GetPlayerAuraBySpellID, 430253)` op `:726` — de `pcall` dekt de **aanroep**,
    niet de `tostring` erna, en een client-crash vangt een `pcall` hoe dan ook niet.
    ⚠️ **Wat dit wél en niet is.** Hetzelfde bestand gebruikt het poortje op **drie** andere
    plekken (`:83`, `:665`, `:675`, alle drie `if issecretvalue and issecretvalue(x)`), en vijf
    zusterplekken elders ook: `Modules/Auras.lua:719`–`:721`, `Modules/DispelCapture.lua:345`,
    `:497`, `:575` (`(aura.name ~= nil and not isSecret(aura.name)) and tostring(aura.name) or "?"`)
    en `Modules/AccessibleAlerts.lua:227`. Dit is dus **geen nieuwe API-migratie maar één gemiste
    toepassing van ons eigen patroon** — de fix is die ene regel dezelfde vorm geven, en ik verzin
    er niets bij.
    ⚠️ **Wat ik NIET gemeten heb:** of de aura van de **speler zelf** ooit secret wordt. `CLAUDE.md`
    zegt *"Other units' aura `spellId`/tooltip `leftText` can be secret"*, wat suggereert van niet,
    maar `C_Secrets.ShouldAurasBeSecret` is een clientvlag en ik kan hier geen client vragen. Dus:
    de **inconsistentie is gemeten**, het **daadwerkelijk afgaan is afgeleid**. Eén `/mh` op de
    Dundun-scan in restricted content settelt het; tot dan is de guard hoe dan ook goedkoper dan de
    vraag.
  - ✅ **[AL AFGEDEKT] — de andere `tostring`-op-een-secret-plekken.** `Modules/DispelHelper.lua:587`
    (`(dn ~= nil and not isSecret(dn)) and tostring(dn) or "SECRET"`), `Modules/Auras.lua:606`
    (`... and not Secret(sid)) and tostring(sid) or "secret"`), `:719`–`:721` en
    `Modules/AccessibleAlerts.lua:227` hebben alle vier het poortje vóór de `tostring`.
    `Modules/DispelCapture.lua:247`/`:250` zien er kaal uit maar zitten achter de
    readability-classificatie `sName == "read"` / `sDispel == "read"` (`:245`–`:252`) — dat is
    hetzelfde poortje, één laag eerder. `Modules/PartyTargets.lua:531` is een schijnvondst:
    `c.spellID` komt uit `tonumber(id)` op `:599`, dus het is een getal of `nil`.
  - ✅ **[RAAKT ONS NIET] — de drie ECHTE verwijderingen in deze build.** De Global-API-tabel gaat
    van *Added 75 / Removed 1* naar *Added 81 / Removed 4*. De drie nieuwe removals zijn alle drie
    `C_PvP`-Training-Grounds-namen die **gesplitst** zijn in een Arena- en een BG-variant:
    `C_PvP.GetRandomTrainingGroundRewards` → `…ArenaRewards` + `…BGRewards`,
    `C_PvP.HasRandomTrainingGroundWinToday` → `…ArenaWinToday` + `…BGWinToday`, en
    `C_PvP.JoinRandomTrainingGroundBattleground` → `C_PvP.JoinRandomTrainingGroundBG`. MH raakt
    `C_PvP` **nergens** aan: **nul** treffers op `C_PvP\.` en op `TrainingGround` over de hele
    addon (`--include=*.lua,*.xml,*.toc`, `docs/`, `tools/` en `dist/` uitgesloten). Positieve
    controle in dezelfde run en dezelfde scope: `issecretvalue|C_UnitAuras|InCombatLockdown|
    CreateFrame` geeft **977** treffers. De nul is een echte nul.
  - ✅ **[RAAKT ONS NIET] — negen andere nieuwe namen, allemaal nul treffers** in diezelfde scope
    met diezelfde positieve controle: `C_UnitAuras.AddAuraSound` (en dus ook z'n nieuwe optionele
    `throttleSeconds`), `sourceGUID` (*"now secret when the unit's identity is secret"*, en de
    bron zegt letterlijk **Damage Meter APIs** — `C_DamageMeter`/`DamageMeter`: ook nul; MH's enige
    combat-log-lezer is `Modules/Retrospective.lua:242`, `CombatLogGetCurrentEventInfo()`, en die
    staat niet op de lijst), `UnitFrameUtil` (incl. `UpdateUnitPvPIndicator` en
    `GetUnitPvPIndicatorDisplayInfo`), `C_ClassColor`/`GetClassColor` (de nieuwe optionele
    tint-kleur), `GetPlayerInfoByGUID` (geeft nu ook het level terug — puur additief), `UIFrameFlash`
    (de chat-tab-flash-verhuizing naar `ChatFrameUtil.StartFlash` c.s.), `ChatFrameUtil`,
    `CombatAudioAlertUtil` (de nieuwe *"Pulse Your Health"*-instelling) en `GetTextureMetatable`.
  - ✅ **[RAAKT ONS NIET] — de drie herstelde CVars en de nameplate-hitbox.** *"The following CVars,
    removed in Midnight, have been restored: nameplateMotionSpeed, nameplateBottomInset, and
    nameplateTopInset"*: **nul** treffers op alle drie. En *"Addons now get an additional one-frame
    window to adjust the hitbox of an enemy nameplate if a `UNIT_CLASSIFICATION_CHANGED` event
    arrives after the nameplate was already created"* gaat over **hitboxen**, en die raken wij niet
    aan. Wat wij wél met nameplates doen staat in `Modules/Rares.lua`: een skull-texture erop via
    `C_NamePlate.GetNamePlateForUnit` (`:910`, `:920`) en `GetNamePlates` (`:934`), met het poortje
    `if ... not (C_NamePlate and C_NamePlate.GetNamePlateForUnit)` op `:907` en `:917` — dus
    **[AL AFGEDEKT]** voor de aanroepen zelf.
    📌 **Eén open observatie, geen actiepunt en geen gok.** Wij herevalueren alleen op
    `NAME_PLATE_UNIT_ADDED` / `_REMOVED` (`Modules/Rares.lua:959`–`:965`) en registreren
    `UNIT_CLASSIFICATION_CHANGED` **nergens** (nul treffers). Of een rare zijn classificatie kan
    wijzigen *nadat* z'n nameplate al bestaat — het geval waar Blizzard nu een extra frame voor
    geeft — weet ik niet, en ik ga het niet aannemen. Zou het kunnen, dan mist zo'n rare z'n skull
    tot de plate hergebruikt wordt. Te meten met `/mh` naast een rare, niet van hieruit.
  - 🧩 **[AL AFGEDEKT] — de Aura-Container-wijzigingen raken precies de velden die wij níét
    gebruiken.** De nieuwe sectie noemt vier dingen: de `includeSpellIDs`-fix (*"such as Sated,
    could also allow unrelated auras through"*), de `ProcessAura`-policy-fix (`ProcessAuraType.None`),
    twee nieuwe `CustomAuraButton`-animatietriggers (`AddAuraShownAnimation`,
    `AddAuraAssignedAnimation`) en *"CustomAuraButton animations now apply secret aspects for
    VertexColor and TexCoord to target objects"*. Onze enige container zit in
    `Modules/PartyTargets.lua:326`–`:361` en gebruikt **geen** van die vijf namen: het is
    `AddAuraSlot(c, "mhPartyDispel", DISPEL_FILTER, { initializeFrame = PaintDispelSlot })` op
    `:354` — een **filterstring** (gevalideerd met `AuraUtil.IsValidFilterString` op `:321`) plus
    eigen artwork, geen `includeSpellIDs`, geen policy en geen animaties. **Nul** treffers op
    `includeSpellIDs|ProcessAura|CustomAuraButton|AddAura(Shown|Assigned)Animation`; de positieve
    controle op hetzelfde patroon vindt wél `AuraContainer` en `AddAuraSlot` in datzelfde bestand.
    Ook **[RAAKT ONS NIET]**: *"Fixed a bug where RaidWarning frames could retain secret aspects on
    their fontstrings after being returned to the pool"* — wij gebruiken alleen de **soundkit**
    `SOUNDKIT.RAID_WARNING` (`Modules/AccessibleAlerts.lua:110`–`:111`), geen `RaidNotice`- of
    `RaidWarningFrame`-frame (nul treffers op beide).
  - 📌 **Suggestie voor Rob, geen bevinding: `Modules/PtrProbe.lua` loopt achter op deze build.**
    `ADDED_GLOBALS` (`:128`–`:146`) en `WATCH_TABLES` (`:159`) zijn geschreven voor build 69594 en
    kennen geen van de 69848-namen (`UnitFrameUtil`, `CombatAudioAlertUtil`, `ChatFrameUtil`,
    `GetTextureMetatable`, `C_ClassColor`). Het bestand zegt zelf op `:126`–`:127` dat het bijhoudt
    *"what became available, so a future feature is chosen from what exists rather than from a
    guess"* — dat doel verwatert stil als de lijst niet meegroeit. **Ik raak het niet aan** (één
    bestand per run), maar het is één regel werk als Rob dat bestand toch opent. ⚠️ En
    `:131`–`:137` heeft nog altijd z'n open vraag: niemand heeft `GetItemCooldown` óf
    `C_Item.GetItemCooldown` op een 12.1.5-client gezien.
  - 🩹 **GEMETEN — nieuwe hotfix (21 sep), en niets ervan is API.** De cache-val is uitgesloten met
    twéé onafhankelijke controles die **nieuwer** zijn dan mijn eigen regel van gisteren: (1)
    `news.blizzard.com/en-us/article/24296142` mét cache-buster geeft nu titel *"Hotfixes:
    September 21, 2026"* (gisteren: *"…September 17…"*); (2) de wiki-`Hotfixes`-diff `6877795`→
    `6882796` voegt een kop `===September 21===` toe en hernoemt de Postlink van *"Hotfixes:
    September 1-17"* naar *"…September 1-21"*. Inhoud: twee Evoker-fixes (`Unravel` /
    `Fire Breath` / `Tip the Scales`), `Lindormi's Guidance` in Den of Nalorakk en Altar of Fangs,
    drie The Coiled Altar-fixes en drie Ula'tek-regels (*"Stone Venom damage reduced by 40%"*,
    *"Boiling Venom on Mythic difficulty is now an Important Aura"*). Allemaal tuning en
    encounter-gedrag → **CONTENT_WATCH-terrein**, niet het mijne. ⚠️ Eén regel grenst eraan:
    *"Boiling Venom … is now an Important Aura"* is een **data-vlag op een boss-aura**, geen
    API-wijziging; wij lezen geen important-aura-vlag (nul treffers op `ImportantAura|IsImportant`).
    📌 **Wat er NIET in staat:** de 12.1.5-lijst belooft *"Fixed a bug that could cause the
    right-click unit menu to incorrectly show battle-pet options for a distant player. This is
    pending a hotfix to 12.1.0 as well."* Die hotfix staat **niet** in de 21-sep-lijst. Raakt ons
    niet (wij bouwen geen unit-menu), maar het is een aangekondigde 12.1.0-hotfix die nog open is.
  - 🗣️ **Forum — twee nieuwe topics, geen van beide met API-inhoud en geen Blizzard-reactie.**
    (1) *Way to hide minions and minor nameplates?* (`2357458`, aangemaakt 2026-09-22T01:27:01Z,
    **1** post): gingerbread wil *"hide the enemy nameplates of minions and minor creatures UNLESS
    in combat"* en is van Plater af. Nul antwoorden. **[RAAKT ONS NIET]** — het raakt nameplates,
    waar wij wél werken, maar er staat geen enkele API-claim in en het gaat over zichtbaarheid van
    plates, niet over de skull die wij erop zetten.
    (2) *UI Audio Bug* (`2356609`, aangemaakt 2026-09-21T05:02:24Z, 2 posts): OpticX76 had stille
    UI-audio na een crash en vond de oorzaak zelf, letterlijk: *"the floating platforms in
    Silvermoon cause audio bugs"* — op de zwevende platformen valt de audio weg, op de grond bij de
    bank komt hij terug, *"I tested it 3x"*. Elvenbane (11:55:50Z): *"First I've heard of that bug."*
    **Geen API-wijziging**, dus **[RAAKT ONS NIET]** op mijn terrein. 📌 Wel één regel waard omdat
    het onze eigen zwijg-modules raakt: `Modules/AccessibleAlerts.lua:110`–`:111` doet
    `pcall(PlaySound, SOUNDKIT.RAID_WARNING, "Master")`. Is dit een clientbug, dan is een alert op
    zo'n platform **onhoorbaar zonder dat er iets kapot is** — precies de klasse "correct zwijgen
    versus stuk" die `/mh`-diagnoses moeten kunnen onderscheiden. Onbevestigd door Blizzard; ik
    meld het als observatie, niet als feit over ons.
  - **Forum — de vier bekende topics, onveranderd.** *Default in game commands* (`2356245`) nog op
    2 posts, *Does Classic Era not have a LUA errors toggle?* (`2355798`) op 2, *Cancel auras not
    working* (`2351797`) nog steeds op 4 met laatste post **2026-09-18T08:34:12Z** en nog altijd
    **geen Blizzard-reactie** (onze acht `/cancelaura`-regels in `Modules/TeamMacrosData.lua` blijven
    dus niet-gemeten en van hieruit niet te meten), *Target on click-down…* (`2349816`) op 4 met
    laatste post 2026-09-20T15:00:25Z. *MSBT or Nothing* (`2349553`, 14 sep) valt bùiten het venster
    en is nog steeds 1 post.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, `UntrustedScriptExecution` op AuraButtons, `GetWeaponEnchantInfo`,
    `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per unit-token, `TimedSignalMap`,
    `CreateFrameWithOptions`, de `COMBAT_LOG_EVENT_UNFILTERED`-restrictie) zijn deze run **niet**
    één voor één opnieuw getoetst en blijven staan zoals eerder gemeten. `UIParentLoadAddOn` blijft
    **[AL AFGEDEKT]**: `Core.lua:79` doet nog steeds
    `local fn = _G.LoadAddOnWithErrorHandling or _G.UIParentLoadAddOn`.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op negen titels; `action=compare` 3×: 12.1.5, 12.1.0 en `Hotfixes`);
    `news.blizzard.com/en-us/article/24296142`; `us.forums.blizzard.com` categorie-JSON 35
    (`order=created` én kaal) plus de topic-JSON's `2357458` en `2356609`; `WebSearch` 1× als
    tegenlezing. ⚠️ Directe `WebFetch` op warcraft.wiki.gg / news.blizzard.com is vandaag **niet**
    opnieuw geprobeerd — dat stond wekenlang op `EGRESS_BLOCKED` en alles liep via Exa; aanname,
    geen meting van vandaag. 📌 De wiki-API waarschuwt opnieuw *"Unrecognized parameter: nocache"* —
    een MediaWiki-waarschuwing, geen fout: de buster hoort bij de cache vóór MediaWiki, en dat hij
    werkt blijkt eruit dat drie revisies van **vannacht** terugkomen die mijn logboek gisteren nog
    niet kende.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang **schoon**; geen
    van de vier wachter-bestanden stond gewijzigd-maar-ongecommit. ⚠️ Opnieuw een **detached
    HEAD**, nu op `68490e9`. De laatste commit op dit logboek is mijn eigen regel van gisteren; er
    heeft niemand anders in dit logboek geschreven.
- [2026-09-23] 🆕 **12.1.5 PTR Changes 3 (build 69952) staat sinds vannacht op de wiki, en er
  kwam een grote hotfix (22 sep). 0 × [MOET GEFIKST].** Het punt van gisteren is bovendien
  **dicht**: `Modules/DundunShrine.lua` heeft het `issecretvalue`-poortje gekregen.
  - ✅ **GEMETEN — het [MOET GEFIKST] van 22 sep is opgelost.** `grep "tostring(aura.name)"` over
    de hele addon geeft nu **nul** treffers; positieve controle in dezelfde run: `grep
    bountifulAura` geeft wél vier treffers in datzelfde bestand (`:727`, `:729`, `:738`, `:740`),
    dus het patroon en de reikwijdte deugen. `DundunShrine.lua:734`–`:738` leest nu
    `local name = aura.name` / `if issecretvalue and issecretvalue(name) then name = "SECRET" end`
    / `out.bountifulAura = "PRESENT: " .. tostring(name)`, met een comment dat naar deze wachter
    verwijst. Commit `c4ba893` *"DundunShrine scan: gate the aura name before tostring"*.
    📌 Ik meld dit één keer en haal het daarna niet meer op.
  - **GEMETEN — welke pagina's bewogen** (`prop=revisions` op negen titels, cache-busted):
    `Patch 12.1.5/API changes` nu rev **`6884498`** (Ketho, 2026-09-23T02:56:59Z, **34494** bytes,
    was 29966 op `6882829`; samenvatting `/* 2026-09-22 */`, `parentid` `6884497` → opnieuw twee
    edits in één nacht). `Hotfixes` rev **`6884263`** (Dark T Zeratul, 2026-09-23T00:27:59Z,
    **363185** bytes, was 346276). `API change summaries` rev **`6883777`** (Ketho,
    2026-09-22T14:00:22Z, 7280 bytes, was 6859728). Onveranderd: `Patch 12.1.0/API changes`
    (`6882827`), `Patch 12.0.7/API changes` (`6794100`), `TOC format` (`6878841`, Zeal, 19 sep —
    vijfde dag stil, dus nog steeds niets nieuws over `AllowLoadGameType`). `Patch 12.1.6/…`,
    `12.1.7/…` en `12.2.0/API changes` nog altijd `"missing":true`.
  - 🔒 **Cache-val uitgesloten.** Alle drie de nieuwste dingen die ik zie zijn **nieuwer** dan wat
    mijn eigen regel van gisteren noemde: wiki-rev `6884498` (23 sep 02:56) > `6882829` (22 sep
    02:38), `Hotfixes` `6884263` (23 sep 00:27) > `6882796` (22 sep 00:56), en het nieuwste
    forumtopic is van 22 sep 18:25 tegen 22 sep 01:27 gisteren.
  - 📅 **DATERING.** De nieuwe wiki-sectie heet `===2026-09-22===` en draagt de titel
    *"Midnight 12.1.5 PTR Changes 3"* (Build **69952**), met een link naar het WoW-dev-Discord.
    `#description2` ging van `12.1.5 (69848) Sep 14 2026` naar `12.1.5 (**69952**) Sep 21 2026`.
    Dus: build 2 dagen oud, publicatie 1 dag oud, wiki-bewerking van vannacht — **ruim binnen het
    venster**. ⚠️ Dit is **PTR-materiaal**: niets hiervan staat op de live 12.1.0-client waar Rob
    op speelt. Het is vooruitkijken naar wat breekt, niet wat nu stuk is.
  - 🧩 **Wat er inhoudelijk bij kwam, letterlijk geciteerd, en wat het voor ons betekent:**
    - *"The {{api|GetArenaOpponentSpec}} API now returns secrets."* → **[RAAKT ONS NIET]**. Nul
      treffers op `GetArenaOpponentSpec` in de hele addon; de 30+ `arena`-treffers die een kale
      grep geeft zijn allemaal **contentnamen** (Voidscar Arena, Arena Champion-delve,
      `DELVE_STORY_ARENA_CHAMPION`), geen API. Wij bouwen geen arena-unitframes.
    - *"`UnitFrameUtil` library introduced in the last PTR build has been expanded with APIs for
      raid role icons and arena opponent specs. It has also been moved to shared code, making it
      available in Classic."* Nieuw daarin: `GetArenaOpponentSpecDisplayInfo`,
      `UpdateArenaOpponentSpecDisplay`, `UpdateArenaOpponentSpecDisplayName`,
      `GetUnitRoleIconDisplayInfo`, `UpdateUnitFrameRoleIcon`, plus een optionele `textureMap`-tabel
      op álle display-API's. → **[RAAKT ONS NIET]**: nul treffers op `UnitFrameUtil`. 📌 Wel het
      noteren waard als **richting**: Blizzard levert secret-veilige vervangers per onderdeel van
      een unitframe. Raken wij ooit een rolicoon of spec-icoon aan, dan is dít de deur.
    - *"Added {{api|C_UnitAuras.GetRefreshCarryOverDuration}}, a secret-aware API returning how much
      of an aura's remaining duration would carry over on refresh. `AuraContainerUtil.GetPandemicWindow`
      now uses this internally…"* → **[RAAKT ONS NIET]**: nul treffers op
      `GetRefreshCarryOverDuration` en op `GetPandemicWindow`. (Positieve controle in dezelfde run:
      `C_UnitAuras` geeft 70 treffers over 13 bestanden, dus de grep zoekt écht in de Lua.)
    - **CVars: 5 → 12 toegevoegd.** Teruggezet zijn `nameplateMotionSpeed`, `nameplateBottomInset`
      en `nameplateTopInset` (*"The following CVars, removed in Midnight, have been restored"*);
      nieuw zijn `CAAPulsePlayerHealthPercent` / `CAAPulsePlayerHealthVolume` (*"Play a looping
      pulse sound once the player's health is below X percent"*), `winePlatformTTS` en het commando
      `dumpSmallAlloc`. → **[AL AFGEDEKT]** voor het enige stukje dat ons raakt: wij zetten maar
      twee CVars, `Modules/DevShots.lua:333-334` en `:372-373`, allebei
      `if SetCVar then pcall(SetCVar, "screenshotFormat", …)`. Lezen gaat via
      `Modules/FpsPanel.lua:97` met `(C_CVar and C_CVar.GetCVar) or _G.GetCVar`. Geen enkele
      nameplate-CVar komt bij ons voor.
    - 🔊 **`winePlatformTTS` is het enige item dat ons gedrag kan verklaren.** Omschrijving:
      *"Use Windows TTS on Wine. Disabled by default as it can cause crashes."* Wij spreken wél:
      `Modules/InterruptScore.lua:70`–`:80` doet `C_VoiceChat.SpeakText` achter
      `if not (C_VoiceChat and C_VoiceChat.SpeakText) then return` plus een `pcall`. →
      **[AL AFGEDEKT]** (het breekt niet), maar met een staart die hierheen hoort: op een
      Mac/Linux-client via Wine staat TTS straks **standaard uit**, dus onze interrupt-stem zwijgt
      zonder dat er iets kapot is. Dat is precies de klasse *"correct zwijgen versus stuk"* uit
      CLAUDE.md. Of dit ook op de live 12.1.0-client al zo is: **niet gemeten**, de CVar staat
      alleen op de 12.1.5-lijst.
    - 📌 **`CAAPulsePlayerHealthPercent/Volume` raakt ons niet in code** (nul treffers op
      `CAAPulse`, `lowHealth`, `LOW_HEALTH`), maar Blizzard bouwt hiermee zelf een
      lage-levens-audiowaarschuwing. Dat grenst aan `Modules/AccessibleAlerts.lua`. Geen actie,
      wel iets om te weten vóór we ooit zoiets zelf maken.
    - **De rest van de 12.1.5-diff is opmaak**, geen inhoud: dezelfde zinnen van build 69848 kregen
      `<code>`-, `{{api}}`- en `{{tlygo}}`-opmaak. Eén daarvan is de regel waarop gisteren het
      [MOET GEFIKST] rustte (*"Fixed an issue that could cause some APIs, like tostring and
      dumpobject, to crash when passed secret objects"*) — die staat er **ongewijzigd**, dus de
      bewering van gisteren is niet stilletjes herzien.
  - 🩹 **Hotfix 22 sep: GEMETEN dat er géén UI-, addon- of API-sectie in zit.** Ik heb niet de diff
    maar de **hele sectie** gelezen (`action=parse&prop=wikitext&section=2`, 16895 bytes, van
    `===September 22===` tot en met Warrior/Arms). De koppen zijn exact: `;Classes`,
    `;Dungeons and Raids`, `;Housing`, `;Items`, `;Player versus Player` — **geen** `;User Interface`,
    geen `;Accessibility`, geen API-regel. Inhoud is klassentuning (DK, DH, Druid, Evoker, Hunter,
    Mage, Monk, Paladin, Priest, Rogue, Warrior), twee crowd-control-fixes (Altar of Fangs' *Laced
    Edge*, Temple of Sethraliss' *Slither Strike*), acht item-aanpassingen en een grote PvP-lijst.
    → **CONTENT_WATCH-terrein**, niet het mijne. ⚠️ Eén regel grenst eraan, net als gisteren:
    *"[[Deathmark]] now shows as a large aura on raid frames"* — een **weergavevlag op een aura**
    in Blizzards eigen raidframes, geen API. Wij lezen zo'n vlag niet (nul treffers op
    `largeAura|IsLargeAura`). 📌 De Postlink op de wiki heet nu *"Hotfixes: September 1-22"*
    (was *"…1-21"*).
  - 🌐 **Nieuw op de wiki, maar niet van ons: `Patch 1.60.1/API changes`.** De edit op
    `API change summaries` (`6883777`, samenvatting *"forever"*) voegt één tabel toe met de kop
    `|+ Forever` en daaronder `[[Patch 1.60.1/API changes|1.60.1]]`. Dat is **WoW Forever**, niet
    Retail. → **[RAAKT ONS NIET]**: `MidnightHelper.toc` is Retail-only (`## Interface: 120007,
    120100`). Genoemd zodat een toekomstige run niet schrikt van een API-changes-pagina met een
    1.x-nummer.
  - 🗣️ **Forum — één nieuw topic, en één bestaand topic dat een echte claim kreeg.**
    (1) *Cast On Target Macro / Addon - On a Unit, Not a Party/Raid/Target Frame* (`2358144`,
    aangemaakt 2026-09-22T18:25:49Z, 2 posts). Sarjin wil *"Cast a spell, on the target (model) -
    where my mouse is - on the unit and not a 'frame'"* voor **WoW Forever**. Elvenbane:
    *"If you're using Blizz click casting, enabling nameplates should be all you need. If you're
    using Clique you'll need to add those combos to the nameplate frames."* Geen API-claim, geen
    Blizzard-reactie. **[RAAKT ONS NIET]**.
    (2) *Way to hide minions and minor nameplates?* (`2357458`) groeide van 1 naar **3** posts.
    Bahz (2026-09-22T18:06:33Z) geeft een CVar-macro
    `/run local t=1-GetCVar("nameplateShowEnemyMinions")SetCVar("nameplateShowEnemyMinions",t)SetCVar("nameplateShowEnemyMinus",t)`
    en zegt erbij: *"Blizz broke some things in combat, so toggling the Minor nameplates while in
    combat fails to trigger (not sure about Minions as I wasn't in an area to test)."* → dit is een
    **onbevestigde spelersmelding** over `SetCVar` in combat, geen Blizzard-woord. Voor ons
    **[AL AFGEDEKT]**: onze enige twee `SetCVar`-aanroepen staan in `Modules/DevShots.lua:333-334`
    en `:372-373`, achter `if SetCVar then` + `pcall`, en zetten `screenshotFormat` — geen
    nameplate-CVar en geen combat-pad. ⚠️ Als de melding klopt, is *"CVar-schrijven faalt stil in
    combat"* wel een breder risico; ik kan het van hieruit niet meten en claim het dus niet.
  - **Forum — de bekende topics, onveranderd.** *UI Audio Bug* (`2356609`) nog op 2 posts,
    *Default in game commands* (`2356245`) op 2, *Does Classic Era not have a LUA errors toggle?*
    (`2355798`) op 2, *Cancel auras not working* (`2351797`) nog steeds op 4 met laatste post
    **2026-09-18T08:34:12Z** en nog altijd **geen Blizzard-reactie** (onze acht `/cancelaura`-regels
    in `Modules/TeamMacrosData.lua` blijven dus niet-gemeten), *Target on click-down…* (`2349816`)
    op 4 met laatste post 2026-09-20T15:00:25Z.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, `MouseIsOver`→`C_UI`, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per
    unit-token, `TimedSignalMap`, `CreateFrameWithOptions`, de `COMBAT_LOG_EVENT_UNFILTERED`-
    restrictie) zijn deze run **niet** één voor één opnieuw getoetst en blijven staan zoals eerder
    gemeten. Nog altijd open uit de 12.1.5-lijst: *"Fixed a bug that could cause the right-click
    unit menu to incorrectly show battle-pet options for a distant player. This is pending a hotfix
    to 12.1.0 as well."* — die hotfix staat **ook niet** in de 22-sep-lijst (raakt ons niet, wij
    bouwen geen unit-menu).
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op negen titels; `action=compare` 3×: 12.1.5, `Hotfixes`, `API change
    summaries`; `action=parse` 2×: `prop=sections` en `prop=wikitext&section=2`);
    `us.forums.blizzard.com` categorie-JSON 35 (`order=created`) plus de topic-JSON's `2358144` en
    `2357458`. ⚠️ **GEMETEN vandaag, niet aangenomen:** directe `WebFetch` op
    `news.blizzard.com/en-us/article/24296142` geeft opnieuw `EGRESS_BLOCKED`. De hotfixtekst komt
    daarom van de wiki, die de Blizzard-post letterlijk overneemt — een **spiegel**, niet Blizzards
    eigen pagina. 📌 De wiki-API waarschuwt weer *"Unrecognized parameter: nocache"*; dat is een
    MediaWiki-waarschuwing en geen fout, en dat de buster werkt blijkt uit de revisies van
    vannacht die mijn logboek gisteren nog niet kende.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang schoon, op branch
    `main` en gelijk met `origin/main`; geen van de vier wachter-bestanden stond
    gewijzigd-maar-ongecommit.

- [2026-09-24] ✅ **Geen relevante API-wijzigingen (17–24 sep). 0 × [MOET GEFIKST].** Eén ding
  bewoog vannacht: de wiki-`Hotfixes`-pagina kreeg de **hotfixlijst van 23 september**. Die is
  volledig klassen- en content-werk; geen `;User Interface`-sectie, geen API-regel. Op de
  API-pagina's zelf gebeurde vandaag **niets**.
  - **GEMETEN — welke pagina's bewogen** (`prop=revisions` op negen titels, cache-busted):
    alleen `Hotfixes`, nu rev **`6885563`** (Dark T Zeratul, 2026-09-24T00:56:02Z, **363781**
    bytes, was 363185 op `6884263`; samenvatting `/* September 2026 */`). **Onveranderd sinds
    gisteren:** `Patch 12.1.5/API changes` (`6884498`, Ketho, 23 sep 02:56 — eerste stille nacht
    sinds build 69952), `Patch 12.1.0/API changes` (`6882827`), `Patch 12.0.7/API changes`
    (`6794100`), `API change summaries` (`6883777`), `TOC format` (`6878841`, Zeal, 19 sep —
    **zesde** dag stil, dus nog steeds niets nieuws over `AllowLoadGameType`). `Patch 12.1.6/…`,
    `12.1.7/…` en `12.2.0/API changes` nog altijd `"missing":true`.
  - 🔒 **Cache-val uitgesloten.** Het nieuwste dat ik zie is **nieuwer** dan wat mijn eigen regel
    van gisteren noemde: `Hotfixes` `6885563` (24 sep 00:56) > `6884263` (23 sep 00:27), en het
    nieuwste forumtopic is van 23 sep 14:46 tegen 22 sep 18:25 gisteren. Dat `12.1.5/API changes`
    níét bewoog is dus een echte stille nacht en geen oude snapshot.
  - 📰 **De hotfix van 23 sep, letterlijk uit de diff.** De Postlink ging van
    *"Hotfixes: September 1-22"* naar *"Hotfixes: September 1-**23**"*. De nieuwe sectie
    `===September 23===` heeft precies **twee** koppen — `;Classes` en `;Delves` — en drie regels:
    - *"Resolved an issue with [[Blightfall]] doing less damage as more time passes since the
      plague was applied."* (Death Knight, Unholy)
    - *"Fixed an issue that caused PvP adjustments to Windwalker's [[Celestial Conduit]] and
      [[Flurry Strikes]] to apply in PvE as well."* (Monk, Windwalker)
    - *"Fixed issue where [[Valeera Sanguinar (delves)|Valeera]] becomes unable to change talents
      and gain abilities after a faction change. Players experiencing this will need to enter a
      delve on the affected character, then leave the delve, and then log out to correct the
      issue."* (Delves)
    → **Geen `;User Interface`, geen `;Accessibility`, geen API-regel.** Klassen- en
    Delve-inhoud is **CONTENT_WATCH-terrein**, niet het mijne.
  - 🗡️ **De Valeera-regel raakt onze code niet, en dat is gemeten.** `Modules/ValeeraProgress.lua`
    noemt **nul** keer `talent` of `faction change` (positieve controle in dezelfde run:
    `grep -c Valeera` op dat bestand geeft **14**, en `\btalent` over heel `Modules/` geeft **201**
    treffers — patroon én reikwijdte deugen dus, de combinatie bestaat gewoon niet).
    → **[RAAKT ONS NIET]** voor de API-kant. ⚠️ Of de addon ergens *bewéért* dat Valeera altijd
    talenten kan wisselen, is een inhoudsvraag; die laat ik expliciet aan `CONTENT_WATCH.md`.
  - 🗣️ **Forum — één nieuw topic, geen enkele API-claim, geen Blizzard-reactie.**
    *Help with Addon* (`2359076`, aangemaakt 2026-09-23T14:46:47Z, **1** post). Wraither16 mist een
    tooltip-addon die bij mouseover op een mount de drop-locatie toonde: *"Ever since the new UI
    changes, this no longer works."* Geen API-naam, geen foutmelding, geen blue post — dit is een
    zoekvraag naar een addon, geen melding van een breuk. **[RAAKT ONS NIET]** als API-bevinding.
    📌 Wel even nagekeken omdat het over tooltips gaat: onze **enige** twee tooltip-hooks zijn
    `Modules/DelveBossShowcase.lua:1112` + `:1170`/`:1175` en `Modules/LootUpgrade.lua:68`, alle
    vier `TooltipDataProcessor.AddTooltipPostCall` achter
    `if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and
    Enum.TooltipDataType then` plus `pcall` → **[AL AFGEDEKT]** als dat systeem ooit schuift.
    Nul treffers op `GameTooltip:HookScript` en `OnTooltipSetUnit`; wij haken nergens op
    mount-tooltips.
  - **Forum — de bekende topics, allemaal onveranderd.** *Way to hide minions and minor
    nameplates?* (`2357458`) nog op 3 posts (laatste 2026-09-22T19:07:02Z), *Cast On Target Macro…*
    (`2358144`) op 2, *UI Audio Bug* (`2356609`) op 2, *Does Classic Era not have a LUA errors
    toggle?* (`2355798`) op 2, *Cancel auras not working* (`2351797`) nog steeds op 4 met laatste
    post **2026-09-18T08:34:12Z** en nog altijd **geen Blizzard-reactie** (onze acht
    `/cancelaura`-regels in `Modules/TeamMacrosData.lua` blijven dus niet-gemeten). De
    `SetCVar`-in-combat-melding van Bahz (22 sep) kreeg **geen** bevestiging en blijft een
    onbevestigde spelersmelding.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, `MouseIsOver`→`C_UI`, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per
    unit-token, `TimedSignalMap`, `CreateFrameWithOptions`, de `COMBAT_LOG_EVENT_UNFILTERED`-
    restrictie, `GetArenaOpponentSpec`/`UnitFrameUtil`/`GetRefreshCarryOverDuration` uit build
    69952) zijn deze run **niet** één voor één opnieuw getoetst en blijven staan zoals eerder
    gemeten. Nog altijd open uit de 12.1.5-lijst: de aangekondigde hotfix voor het right-click
    unit-menu dat battle-pet-opties toont bij een verre speler — die staat **ook niet** in de
    23-sep-lijst (raakt ons niet, wij bouwen geen unit-menu).
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op negen titels; `action=compare` 1×: `Hotfixes` `6884263`→`6885563`);
    `us.forums.blizzard.com` categorie-JSON 35 (zowel `order=created` als `order=activity`) plus
    de topic-JSON `2359076`. ⚠️ **Niet zelf gelezen:** Blizzards eigen hotfixartikel op
    `news.blizzard.com` blijft `EGRESS_BLOCKED`; de hotfixtekst komt uit de wiki, die de post
    letterlijk overneemt — een **spiegel**, niet de bron. 📌 De wiki-API waarschuwt weer
    *"Unrecognized parameter: nocache"*; dat is een MediaWiki-waarschuwing en geen fout, en dat de
    buster werkt blijkt uit de `Hotfixes`-revisie van vannacht die mijn logboek gisteren nog niet
    kende.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Werkboom was bij aanvang schoon, op branch
    `main` en gelijk met `origin/main`; geen van de vier wachter-bestanden stond
    gewijzigd-maar-ongecommit.
- [2026-09-25] ✅ **Geen relevante API-wijzigingen (18–25 sep). 0 × [MOET GEFIKST].** Vannacht
  bewogen voor het eerst sinds dagen **beide** API-pagina's — `Patch 12.1.0/API changes` en
  `Patch 12.1.5/API changes`, binnen 21 seconden van elkaar — en er staat **geen enkele API-regel**
  in de diff. Ketho haalde op beide alleen de `TOC:`-regel uit het `{{#description2:}}`-sjabloon en
  zette een ontbrekende accolade terug; op 12.1.5 kortte hij daarbij twee `Bluepost`-datums in.
  📌 **Dit is precies de val die deze wachter moet zien: een bewogen revisie-ID is geen veranderde
  API.** Had ik "de API-pagina is bijgewerkt" gemeld, dan had er vandaag onterecht nieuws gestaan.
  - **GEMETEN — byte-voor-byte via de REST-diff** (`rest.php/v1/revision/<van>/compare/<naar>`,
    cache-busted):
    - `Patch 12.1.0/API changes`: `6882827` (102493 b) → `6886718` (102480) → `6886719` (102481),
      beide Ketho, 2026-09-25T01:45:38Z en 01:45:50Z, **zonder samenvatting**. Netto **−12 bytes**.
      De diff raakt alléén regel 2: `TOC: 120100}}` verwijderd, en `…(Curse of Ula’tek)}` → `}}`.
      **Alle 21 sectiekoppen staan er nog** (Resources t/m Deprecated API), met hun offset uniform
      −13 en daarna +1 verschoven — geen sectie toegevoegd, geen sectie weg.
    - `Patch 12.1.5/API changes`: `6884498` → `6886717` (34466 b, 01:45:29Z). `TOC: 120105}}` weg
      uit `{{#description2:}}`, plus `|date=Sep 3, 2026 6:42 pm` → `|date=Sep 3, 2026` en
      `|date=Sep 16, 2026 1:09 am` → `|date=Sep 15, 2026` (dus ook een dag terug, vermoedelijk een
      tijdzonecorrectie op dezelfde post — de `|link=` erachter is onveranderd). **Geen regel in
      `Consolidated changes`, geen nieuwe `Bluepost`, geen nieuw item.**
    ℹ️ Dat 12.1.0 op TOC `120100` staat en 12.1.5 op `120105` is dus **niet** nieuw en niet
    gewijzigd — dat stond al in mijn regel van 6 sep. `MidnightHelper.toc:1` declareert nog steeds
    `## Interface: 120007, 120100`; **[RAAKT ONS NIET]**.
  - 📰 **De hotfixes van 24 september staan erop, en er is géén `;User Interface`.** `Hotfixes` rev
    **`6886643`** (Dark T Zeratul, 2026-09-25T00:42:51Z, 364493 b, was `6885563`/363781). De
    Postlink ging van *"Hotfixes: September 1-23"* naar *"1-**24**"*. De nieuwe sectie
    `===September 24===` heeft precies twee koppen:
    - `;Delves` — *"In the [[Shadow Enclave]] delve variant "Infiltrate and Ameliorate", Oddball
      "Ingredient" now teleport to one of several points in the play space if dropped into the
      pit."*
    - `;Player versus Player` — *"Developers' notes: We've added a few more adjustments to our
      prior changes to movement speed reduction effects."*: Hunter `Wing Clip` verlaagt nu 40% in
      PvP, `Improved Snaring` verhoogt dat met 10%, Mage Arcane `Chrono Shift` (PvP Talent) 30%
      (was 50%), Paladin `Consecrated Ground` 20% (was 50%).
    → **[RAAKT ONS NIET]** als API-bevinding: klassen- en Delve-inhoud is CONTENT_WATCH-terrein.
    GEMETEN over `*.lua` buiten `docs/`, `tools/` en `dist/`: `Wing Clip` 0, `Improved Snaring` 0,
    `Chrono Shift` 0, `Consecrated Ground` 0, `Oddball` 0 treffers. **Positieve controle in dezelfde
    run en op dezelfde reikwijdte:** `Blessing of Freedom` 3, `Hunter's Mark` 21, `Arcane Explosion`
    7 — patroon én reikwijdte deugen, die vier spells staan er gewoon niet in.
  - 🍲 **Eén ding door naar `CONTENT_WATCH.md`, niet naar mij.** De addon beschrijft die
    ingrediënten-stap wél, in zeven talen: `Locales/DelveTips.lua:36` (enUS) zegt *"Infiltrate and
    Ameliorate: sabotage 4 cauldrons by adding odd ingredients. Some ingredients sit up high: use
    the jumping mushrooms."*, met dezelfde regel in it/nl/de/fr (en de es/pt-varianten in hetzelfde
    bestand). Of die tekst na deze hotfix nog klopt — wat er nu gebeurt als een ingrediënt in de pit
    valt — is een **inhoudsvraag**. Ik meld hem door en repareer niets.
  - 🗣️ **Forum: twee topics gebumpt na middernacht, geen van beide met een API-claim in zijn
    onderwerp.** *ONLY show characters on a specific realm?* (`1911888`, 8 posts, laatste
    2026-09-25T03:21:52Z door JerrodOwex) — een vraag uit aug 2024 over het
    personageselectiescherm, waarvan post 2 (Fizzlemizz, 2024) *"Not at this time."* zegt. En *New
    AddOn: ChromaChat for easier chat reading/tracking* (`2349301`, 3 posts, laatste
    2026-09-25T01:18:25Z) — een addon-aankondiging over chatkleuren, class-color-regels en
    mention-sounds. In beide staat **geen Blizzard-reactie**: geen `community-manager` of
    `cs-support-sse` onder de posters.
    ⚠️ **NIET GEMETEN: de tekst van de nieuwste post in deze twee threads.** Discourse gaf op
    `/t/<id>/<n>.json` én `/t/<id>/last.json` telkens de thread vanaf post 1 terug, en binnen mijn
    tekenlimiet kwam het laatste bericht niet in beeld. Wat ik wél gemeten heb: auteur, tijdstip,
    aantal posts, en de eerste posts. Een API-breuk zou hier dus in principe onopgemerkt kunnen
    blijven; de onderwerpen maken dat onwaarschijnlijk, maar dat is een oordeel en geen meting.
  - **Onveranderd sinds gisteren:** `TOC format` (`6878841`, Zeal, 19 sep — **zevende** stille dag,
    dus nog steeds niets nieuws over `AllowLoadGameType`), `API change summaries` (`6883777`,
    22 sep), `Patch 12.0.7/API changes` (`6794100`, 4 aug). `Patch 12.1.6/…`, `12.1.7/…` en
    `12.2.0/API changes` nog altijd `"missing":true`. Geen nieuw topic in forumcategorie 35 sinds
    `2359076` (23 sep 14:46) — die staat nog op 1 post.
  - 🔒 **Cache-val uitgesloten.** Het nieuwste dat ik zie is nieuwer dan wat mijn eigen regel van
    gisteren noemde: `Hotfixes` `6886643` (25 sep 00:42) > `6885563` (24 sep 00:56), en de nieuwste
    forumactiviteit is 25 sep 03:21 tegen 23 sep 14:46 gisteren. Dat `TOC format` en `API change
    summaries` níét bewogen is dus echt en geen oude snapshot.
  - **Staande 12.1.0-/12.1.5-items** (C_UnitAuras secret-reads, `GetNextWaypointForMap`→
    `C_Navigation`, `MouseIsOver`→`C_UI`, `UntrustedScriptExecution` op AuraButtons,
    `GetWeaponEnchantInfo`, `GetItemCooldown`→`ns.GetItemCooldownSafe`, castbar-ID's per
    unit-token, `TimedSignalMap`, `CreateFrameWithOptions`, de `COMBAT_LOG_EVENT_UNFILTERED`-
    restrictie, `GetArenaOpponentSpec`/`UnitFrameUtil`/`GetRefreshCarryOverDuration` uit build
    69952) zijn deze run **niet** één voor één opnieuw getoetst en blijven staan zoals eerder
    gemeten. Ook onveranderd: de acht `/cancelaura`-regels in `Modules/TeamMacrosData.lua` blijven
    niet-gemeten zolang topic `2351797` (laatste post 18 sep) zonder Blizzard-reactie blijft.
  - **Bronnen, alle met cache-buster via `web_fetch_exa`:** `warcraft.wiki.gg/api.php`
    (`prop=revisions` op negen titels, plus `rvlimit=10` op `Patch 12.1.0/API changes`;
    `action=compare` 1× voor 12.1.5), `warcraft.wiki.gg/rest.php/v1/revision/…/compare/…` (3×),
    `us.forums.blizzard.com` categorie-JSON 35 (`order=created` én `order=activity`) en drie
    topic-JSON's. ⚠️ **Niet zelf gelezen:** `news.blizzard.com` blijft `EGRESS_BLOCKED`; de
    hotfixtekst komt uit de wiki, die de post letterlijk overneemt — een **spiegel**, niet de bron.
    📌 **Nieuw gereedschap, en het is beter dan wat ik had:** `action=compare` op `api.php` faalde
    twee keer op de grote 12.1.0-diff (`CRAWL_UNKNOWN_ERROR`, dan `CRAWL_UNEXPECTED_CONTENT_TYPE`),
    maar `rest.php/v1/revision/<van>/compare/<naar>` werkte wél en geeft bovendien de **sectielijst
    van vóór en ná** mee. Daarmee is "geen sectie toegevoegd" te *meten* in plaats van te hopen —
    precies wat er vandaag nodig was. De wiki-API blijft *"Unrecognized parameter: nocache"*
    waarschuwen; dat is een MediaWiki-waarschuwing, geen fout.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** ⚠️ De werkmap stond bij aanvang in
    **detached HEAD** op `b6fe103` met een schone boom, terwijl de lokale `main`-ref nog op
    `f32c136` stond en `origin/main` niet vers was — `git rev-parse` liet drie verschillende commits
    zien. Na `git fetch origin main` bleek `b6fe103` exact `origin/main`: geen verloren werk, alleen
    een achterlopende ref. `main` bijgezet en daarop gecommit. Geen van de vier wachter-bestanden
    stond gewijzigd-maar-ongecommit.
- [2026-09-26] 🧩 **Eén échte addon-kant-wijziging (19–26 sep): de wiki documenteert sinds
  gisteravond een nieuw client-specifiek TOC-achtervoegsel `AddonName_Standard.toc`, toegeschreven
  aan 12.1.5. 0 × [MOET GEFIKST].** Dit is precies het soort ding dat deze wachter moet vangen —
  het raakt hoe de client een addon *laadt*, niet wat er in het spel gebeurt — maar het raakt
  Midnight Helper niet, en dat is **gemeten**, niet gehoopt.
  - 🆕 **GEMETEN — vier edits van `Zeal` op `TOC format`, gisteravond binnen zes minuten**
    (`api.php`, `prop=revisions`, `rvlimit=12`, cache-busted):
    - `6887877` 2026-09-25T19:36:36Z (26984 b) — *"/\* Per-file variables \*/ Expanded description
      for variables within meta-data"*
    - `6887878` 19:38:02Z (26936 b) — *"/\* Per-file variables \*/ Reworded to reduce duplicate
      statements"*
    - `6887882` 19:39:47Z (27001 b) — *"/\* Modern \*/ Added Standard TOC suffix"*
    - `6887886` 19:42:12Z (27066 b) — *"/\* Client-specific TOC files \*/ Readded Standard suffix"*
    Ouder was `6878841` (19 sep 03:35), de revisie die mijn regel van gisteren als "stil sinds
    19 sep" noemde. Netto **+96 bytes**.
  - **GEMETEN — de REST-diff `6878841 → 6887886`** (`rest.php/v1/revision/<van>/compare/<naar>`)
    raakt precies drie plekken, en **alle 52 sectiekoppen staan er nog** (Rules t/m References, in
    dezelfde volgorde): geen sectie toegevoegd, geen sectie weg. De koppen vóór de eerste wijziging
    staan op een identieke offset (`Rules` 424 … `Per-file variables` 7983), daarna schuift alles
    mee: `Client-specific TOC files` 9806 → 9772 (−34), `AddOns list formatting` 12681 → 12712
    (+31), en vanaf `Forever` 24722 → 24818 (+96, het netto-saldo).
    1. In de tabel onder `== Client-specific TOC files ==` staat nu de regel
       `| standard || … || {{LatestPatchInfo|expansion=}} excluding [[Plunderstorm]], [[Talebound]]
       and other Modern modes. || AddonName _Standard.toc`. De sectietekst zelf (letterlijk
       opgehaald via `action=parse&section=9`) blijft zeggen: *"The WoW client first searches for
       the special file names as shown below, and if none are found, uses AddonName.toc"*, met
       daarbij *"Note that comma-delimited interface versions or per-file conditional loading
       directives should be preferred over the use of client-specific TOC files where possible."*
    2. Onder `=== Modern ===` in `== Patch changes ==` is toegevoegd:
       `* {{Patch 12.1.5|note=Added _Standard TOC suffix.}}`
    3. Onder `== Per-file variables ==` zijn twee zinnen samengevoegd tot één:
       *"TOC files support the use of variable expansions in the form [Variable] within file
       references **and metadata**. The following variables are currently supported by the client."*
       (was: *"Variables of the form [Variable] can be used within file references. …"*). De
       **uitbreiding naar metadata** is de inhoudelijke wijziging; de tabel eronder is onveranderd.
  - 🔁 **DIT IS EEN CORRECTIE OP EERDERE INFO, en ik zeg dat er expliciet bij.** Hetzelfde
    `_Standard`-achtervoegsel stond er al eens en is op **17 sep 21:20** door dezelfde editor
    verwijderd met de samenvatting *"Removed invalid Standard suffix."* (`6877634`). Gisteravond is
    het **teruggezet** (*"Readded Standard suffix"*). Wie alleen de huidige pagina leest, ziet die
    heen-en-weer niet.
    ⚠️ **En let op de herkomst: dit is een wiki-editor, geen Blizzard-bron.** In de diff staat
    **geen** `Bluepost`, geen bronverwijzing en geen build-nummer; de toeschrijving aan 12.1.5 is
    Zeals eigen `{{Patch 12.1.5|note=}}`. `WebSearch` op `_Standard`-TOC leverde **niets** buiten de
    wiki op — geen patch note, geen forumpost, geen Wowhead-artikel. Behandel het dus als
    **AFGELEID uit datamining door een derde**, niet als een aangekondigde API.
  - ✅ **[RAAKT ONS NIET] — toetsing aan de code, met positieve controle in dezelfde run.**
    - `find . -name "*.toc"` (buiten `.git`) geeft **exact één** bestand: `MidnightHelper.toc`. Er
      is dus geen enkel achtervoegselbestand om mee te botsen, en de pagina zegt zelf dat de client
      dan `AddonName.toc` gebruikt.
    - `grep -rn "_Standard"` over `*.lua`, `*.toc`, `*.ps1`, `*.pkgmeta`, `*.yml`: **0 treffers**.
      Idem `_Mainline`: 0. **Positieve controle op dezelfde reikwijdte:** `grep -rn "AddOns"` over
      diezelfde bestandstypen vindt wél `MidnightHelper.toc:12`, `tools/sync_to_wow.ps1:3`,
      `tools/package.ps1:22` en `tools/Crop-Shots.ps1:28` — patroon én scope deugen.
    - `.pkgmeta:8` zegt `enable-toc-creation: no`, met op regel 7 de uitleg *"We ship a
      hand-maintained .toc and use no embedded libraries' nolib stripping."* De packager genereert
      dus ook geen achtervoegselbestanden achter onze rug om.
    - `MidnightHelper.toc:1` is nog steeds `## Interface: 120007, 120100` — comma-delimited, precies
      de vorm die de wiki aanbeveelt boven client-specifieke TOC-bestanden.
    - De **metadata**-uitbreiding van `[Variable]` raakt ons evenmin: `grep -n "\[[A-Za-z]*\]"` over
      `MidnightHelper.toc` geeft **0 treffers**. **Positieve controle:** dezelfde scope telt 17
      `## `-directives (`Interface`, `Title`, `Version`, `Author`, `Category`, `Notes` + vijf
      `Notes-<taal>`, `IconTexture`, `SavedVariables`, `AddonCompartmentFunc`, `X-Curse-Project-ID`,
      `X-Wago-ID`, `X-Website`, `X-License`) — we gebruiken simpelweg geen variabele-expansies.
    📌 Conclusie: dit is een **kans**, geen breuk. Wil Rob ooit een aparte build voor Plunderstorm
    of Talebound, dan is `_Standard` het haakje. Nu niet nodig, en ik stel het niet voor.
  - 🔇 **`AllowLoadGameType` heeft NIET bewogen — en dat is het punt dat hier al acht dagen open
    staat.** De vier nieuwe revisies raken de sectie niet; de laatste inhoudelijke edit eraan blijft
    `6878834` (19 sep 03:09, *"Added note about behaviour of unrecognised game types"*). Onze `.toc`
    gebruikt hem hoe dan ook niet: één grep over `MidnightHelper.toc` naar `AllowLoad`,
    `OnlyBetaAndPTR`, `LoadFirst`, `LoadManagers`, `LoadWith` en `UseSecureEnvironment` samen geeft
    **0 treffers**, met de
    17-directives-telling hierboven als positieve controle. **[RAAKT ONS NIET]**, en dat blijft zo
    tot wij zelf zo'n directive toevoegen.
  - 📰 **Geen nieuwe hotfixpost sinds gisteren.** `Hotfixes` staat onveranderd op rev **`6886643`**
    (Dark T Zeratul, 2026-09-25T00:42:51Z, 364493 b) — exact de revisie die mijn regel van gisteren
    al noemde, dus de hotfixes van 24 sep zijn nog steeds de laatste. Geen `;User Interface`-kop
    bijgekomen.
  - **Onveranderd sinds gisteren, alle drie byte-voor-byte bevestigd:** `Patch 12.1.0/API changes`
    (`6886719`, 102481 b, 25 sep 01:45), `Patch 12.1.5/API changes` (`6886717`, 34466 b, 25 sep
    01:45), `Patch 12.0.7/API changes` (`6794100`, 4 aug), `API change summaries` (`6883777`,
    22 sep). `Patch 12.1.6/API changes`, `12.1.7/…` en `12.2.0/API changes` blijven `"missing":true`.
  - 🗣️ **Forum: niets bewogen in 24 uur.** Nieuwste topic in categorie 35 is nog altijd
    `2359076` *Help with Addon* (23 sep 14:46, 1 post); de nieuwste activiteit buiten de vastgepinde
    topics is nog steeds *ONLY show characters on a specific realm?* (`1911888`, 25 sep 03:21) en
    *New AddOn: ChromaChat…* (`2349301`, 25 sep 01:18) — beide gisteren al gemeld, beide nog zonder
    `community-manager`- of `cs-support-sse`-poster. Geen nieuwe blue post.
  - 🔒 **Cache-val uitgesloten, en deze keer met een harde ondergrens.** Het nieuwste dat ik zie
    (`6887886`, 25 sep 19:42) is **nieuwer** dan álles wat mijn regel van gisteren noemde
    (`6886643`, 25 sep 00:42). Dat `Hotfixes` en beide API-pagina's níét bewogen, is dus een echte
    stilte en geen oude snapshot — dezelfde fetch die de stilte meldt, levert elders nieuws.
  - ⚠️ **NIET GELEZEN, en dat is geen "niets gevonden":**
    - `news.blizzard.com` blijft `EGRESS_BLOCKED`. De hotfixinfo hierboven komt van de wiki, die de
      post letterlijk overneemt — een **spiegel**, niet de bron.
    - `wowhead.com/blue-tracker` gaf **twee keer** `CRAWL_UNKNOWN_ERROR` (met verschillende
      cache-busters), dus de gebruikelijke tweede spiegel ontbrak vandaag volledig. Een blue post
      van gisteravond die de wiki nog niet heeft opgepikt, zou ik daardoor gemist kunnen hebben.
    - Directe `curl` naar `us.forums.blizzard.com` faalt in deze sessie op de proxy
      (`CONNECT tunnel failed, response 403`); alle forumdata komt via `web_fetch_exa`.
  - **Bronnen, alle met cache-buster:** `warcraft.wiki.gg/api.php` — `prop=revisions` op negen
    titels, `rvlimit=12` op `TOC format`, en `action=parse&section=9&prop=wikitext` voor de
    letterlijke sectietekst; `warcraft.wiki.gg/rest.php/v1/revision/6878841/compare/6887886`;
    `us.forums.blizzard.com` categorie-JSON 35 (`order=activity` én `order=created`); `WebSearch`.
    ℹ️ `rvlimit=12` faalde één keer op `CRAWL_UNEXPECTED_CONTENT_TYPE` en de REST-diff één keer op
    `CRAWL_UNKNOWN_ERROR`; beide lukten bij de tweede poging met een andere cache-buster. De
    wiki-API blijft *"Unrecognized parameter: nocache"* waarschuwen — een MediaWiki-waarschuwing,
    geen fout.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** ⚠️ De werkmap stond **opnieuw** in detached
    HEAD, nu op `d5f6722`, terwijl de lokale `main`-ref op `f32c136` bleef staan. Na `git fetch
    origin main` bleek `d5f6722` exact `origin/main` (Robs 4.1.0-werk van gisteren): geen verloren
    werk. `main` bijgezet en daarop gecommit. 📌 Dit is de **tweede** dag op rij; het lijkt hoe deze
    cloud-sessie de repo uitcheckt, niet iets wat Rob doet. Geen van de vier wachter-bestanden stond
    gewijzigd-maar-ongecommit.
- [2026-09-27] 🧩 **Twee échte addon-kant-wijzigingen (20–27 sep), beide op `TOC format` en beide
  gisteren: `ExcludeLoadGameType` is nu een volwaardig gedocumenteerde directive (toegeschreven aan
  12.0.0), en `AllowLoadGameType` blijkt game types **case-insensitive** te vergelijken. 0 ×
  [MOET GEFIKST].** Na de `_Standard`-drukte van eergisteren is dezelfde pagina gisteren elf keer
  bewerkt; dit zijn de twee wijzigingen die iets nieuws zéggen, de andere negen zijn opmaak.
  - 🆕 **GEMETEN — elf revisies op `TOC format`, 26 sep 15:34–18:57, door `Ketho` en `Zeal`**
    (`api.php`, `prop=revisions`, `rvlimit=10`, cache-busted; 27081 → 27396 b, netto **+315**).
    De twee inhoudelijke: `6889069` 18:53:34Z *"/\* Modern \*/ Added ExcludeLoadGameType for
    12.0.0"* en `6889060` 18:36:53Z *"/\* AllowLoadGameType \*/ Changed ambox to inline"*, met
    `6889062` (Ketho, 18:40:53Z, *"/\* ExcludeLoadGameType \*/"*) ertussen. Ouder was `6887886`
    (25 sep 19:42), precies de revisie die mijn regel van gisteren als eindpunt noemde.
    ℹ️ De REST-diff (`rest.php/v1/revision/<van>/compare/<naar>`) gaf **twee keer**
    `CRAWL_UNKNOWN_ERROR`, met verschillende cache-busters; `api.php?action=compare` werkte wel en
    is de bron van de citaten hieronder.
  - 1️⃣ **`ExcludeLoadGameType` heeft nu een eigen sectie én een patch-toeschrijving.** GEMETEN via
    `action=parse&prop=sections`: hij staat als **9.7** (`index=28`, byteoffset 19316) onder
    `== Loading conditions ==`, direct na `AllowLoadGameType` (9.6). De sectietekst is letterlijk
    opgehaald en luidt volledig: *"===ExcludeLoadGameType ===  Similar to AllowLoadGameType, but
    prevents loading this addon on specific game types."* In `== Patch changes ==` → `=== Modern ===`
    is toegevoegd: `* {{Patch 12.0.0|note=Added <code>ExcludeLoadGameType</code> metadata field and
    per-file conditional directive.}}`, boven de al bestaande 12.0.7-regel.
    - 🔁 **DIT IS EEN CORRECTIE OP MIJN EIGEN REGEL VAN 19 SEP, en ik zeg dat er expliciet bij.**
      Toen stond `ExcludeLoadGameType` alleen als tabelrij met de versienoot *"Added for files in
      11.1.5. Added for metadata in 12.0.7."* (zie de regel van 2026-09-19 hierboven). Nu
      schrijft de patch-lijst **12.0.0** voor zowel het metadata-veld als de per-file directive.
      Dat is dus **11.1.5/12.0.7 → 12.0.0**. 🔴 Ik weet **niet** welke van de twee klopt: beide
      zijn toeschrijvingen van dezelfde wiki-editors, er staat geen build, geen `Bluepost` en geen
      bronverwijzing bij, en de 12.0.7-regel (*"Added support for per-metadata conditional
      directives"*) is níét weggehaald. Behandel het als **AFGELEID uit datamining door derden**.
    - ✅ **[RAAKT ONS NIET] — gemeten, mét positieve controle op dezelfde reikwijdte.** Één grep
      over de hele addon (buiten `.git`, `docs`, `tools`, `dist`) op
      `ExcludeLoadGameType|AllowLoadGameType|GameType` geeft **0 treffers** (exitcode 1).
      **Positieve controle:** `grep '^## '` op `MidnightHelper.toc` vindt wél **17** directives
      (regels 2–18: `Title`, `Version`, `Author`, `Category`, `Notes` + vijf `Notes-<taal>`,
      `IconTexture`, `SavedVariables`, `AddonCompartmentFunc`, `X-Website`, `X-License`,
      `X-Curse-Project-ID`, `X-Wago-ID`) — patroon én scope deugen. ⚠️ **Let op voor volgende
      runs:** regel 1 (`## Interface: 120007, 120100`) matcht `^## ` **niet**, omdat er een
      UTF-8 BOM voor staat; die regel heeft een eigen grep nodig. `find . -name '*.toc'` geeft nog
      steeds **precies één** bestand: `MidnightHelper.toc`.
  - 2️⃣ **`AllowLoadGameType` vergelijkt game types case-insensitive — dat is het nieuwe feit, en
    het sluit het punt dat hier sinds 19 sep open stond.** De omschrijving is herschreven naar,
    letterlijk: *"Restricts loading this addon to ''case-insensitive'' game types. Multiple values
    may be supplied, delimited by commas. Note that game modes may be restricted to disallow
    loading of insecure addons."* De fails-open-zin is **niet** veranderd van betekenis maar naar
    een waarschuwingsblok verplaatst en heeft er één woord bij gekregen: *"If at least 1 game type
    is specified, but the client doesn't **(yet)** recognize ''any'' of the game types in the
    condition, the condition will still be satisfied."* De tabel met 12 game types (`standard`,
    `mists`, `cata`, `wrath`, `tbc`, `camelot`, `vanilla`, `plunderstorm`, `wowlabs`, `wowhack`,
    `mainline`, `classic`) is inhoudelijk onveranderd; `wowhack` heeft een schoonheidsfoutje
    gekregen (`<code>wowhack </code>`, met spatie).
    ✅ **[RAAKT ONS NIET]** — zelfde meting en zelfde positieve controle als hierboven; wij hebben
    geen enkele `AllowLoad*`/`ExcludeLoad*`-directive. 📌 Hiermee is de open aantekening van 19 sep
    (*"faalt OPEN bij een onbekend game type"*) afgehandeld: de bewering staat er nog, nu als
    waarschuwing, en er is één feit bijgekomen. **Ik laat dit punt hierna rusten.**
  - 📄 **[RAAKT ONS NIET] — twee opmaakwijzigingen die alleen tellen omdat mijn eigen regels ernaar
    verwijzen.** (a) De sectie `== Per-file variables ==` heet nu `== TOC variables ==`
    (`index=8`, byteoffset 8014); de body is woord-voor-woord dezelfde als gisteren, inclusief de
    *"within file references and metadata"* die ik toen als de inhoudelijke wijziging meldde. Wie
    mijn regel van 26 sep leest en naar `Per-file variables` zoekt, vindt die sectie dus niet
    meer — hij is niet weg, hij is herdoopt. (b) In `== Interface version ==` is het
    meerdere-flavors-voorbeeld omgezet van flavor-trefwoorden naar **mapnamen**: van
    `{{API LatestInterface}}, {{API LatestInterface| classic}}, {{API LatestInterface| wrath-titan}},
    {{API LatestInterface| tbc}}, {{API LatestInterface| vanilla}}` naar
    `{{API LatestInterface |_retail_}}, {{API LatestInterface| _classic_}},
    {{API LatestInterface| _classic_titan_}}, {{API LatestInterface| _anniversary_}},
    {{API LatestInterface| _classic_era_}}`. ⚠️ Dit is een **wiki-template-argument**, geen
    clientwijziging: het voorbeeld rendert hetzelfde soort regel als altijd. Onze
    `MidnightHelper.toc:1` blijft `## Interface: 120007, 120100` — comma-delimited, precies wat de
    pagina aanbeveelt. GEMETEN: `_retail_` komt in de repo alleen voor in
    `tools/sync_to_wow.ps1:3` en `tools/Crop-Shots.ps1:28`, beide buiten de zip.
  - 🗣️ **Forum: twee nieuwe topics, beide van gisteren, beide van spelers, geen blue post.**
    - `2362999` *WoW Forever Addons* (26 sep 14:37:40Z, 1 post) — welke addons werken op de WoW
      Forever-beta. Geen API-inhoud.
    - `2362846` *Raid markers over character areWAY too big* (26 sep 09:37:28Z, 2 posts) —
      ⚠️ **dit klinkt als ons terrein maar is het niet, en daarom noem ik het.** De vraag gaat over
      de **grootte** van Blizzards eigen raid-marker-icoon boven je hoofd: *"Can we have an in-game
      option to scale down the raid markers over our characters heads?"* Geen API, geen
      `SetRaidTarget`, geen taint — een wens voor een instelling. Het enige antwoord (`Elvenbane`,
      12:43:36Z, `"staff":false`): *"You'd be better off submitting it via the in-game tool. Blizz
      isn't known to frequent these forums."* **Raakt `Modules/FastMark.lua` niet:** die zet
      markers via `/tm N`, en de icoongrootte in de wereld is geen addon-API.
    - **Geen `community-manager`- of `cs-support-sse`-post in categorie 35.** GEMETEN: de enige
      blue-accounts in de lijst (`Kaivax`, `Vrakthris`) hangen aan de vier **vastgepinde** topics,
      waarvan de nieuwste activiteit *UI Add-On Development Policy* is op **28 aug 19:54** en dan
      nog door een speler (`Atheren`).
  - 🔇 **Gelezen en onveranderd — byte-voor-byte dezelfde revisies als gisteren:** `Hotfixes`
    (`6886643`, Dark T Zeratul, 25 sep 00:42:51Z, 364493 b), `Patch 12.1.0/API changes`
    (`6886719`, 102481 b, 25 sep 01:45), `Patch 12.1.5/API changes` (`6886717`, 34466 b, 25 sep
    01:45), `Patch 12.0.7/API changes` (`6794100`, 4 aug), `API change summaries` (`6883777`,
    22 sep). `Patch 12.1.6/API changes`, `12.1.7/…` en `12.2.0/API changes` blijven `"missing":true`.
    Er is dus **geen nieuwe hotfixpost**: die van 24 sep is nog de laatste, en dat is onafhankelijk
    bevestigd — `WebSearch` op news.blizzard.com/wowhead/icy-veins vindt als nieuwste
    *"Hotfixes: September 24, 2026"* (artikel 24296142) en niets van 25, 26 of 27 sep. **AFGELEID
    (via search, pagina zelf niet gelezen.)**
  - 🔁 **Geen nieuwe 12.1.5-API-items, en ik heb het tegen mijn eigen logboek getoetst in plaats van
    tegen mijn geheugen.** `WebSearch` op *"12.1.5 addon API changes taint secure frames"* vatte de
    12.1.5-pagina samen met `SetCooldown`-taint, unieke castbar-ID's per unit token,
    `TimedSignalMap`, `CreateFrameWithOptions`, `UnitFrameUtil`/`UpdateUnitPvPIndicator` en
    `C_Intl`. **GEMETEN dat dit allemaal al in dit bestand staat** (`grep -c` in
    `docs/API_WATCH.md`: `TimedSignalMap` 20×, `SetCooldown` 18×, `CreateFrameWithOptions` 17×,
    `UnitFrameUtil` 7×, `C_Intl` 2×, `UpdateUnitPvPIndicator` 1×) — de pagina is sinds 25 sep niet
    bewogen, dus dit is een samenvatting van oud nieuws en **geen nieuwe vondst**. 📌 Precies
    hierom telt de grep tegen het eigen logboek: een zoekmachine presenteert een week oude pagina
    even zelfverzekerd als een verse.
  - 🔒 **Cache-val uitgesloten, met een harde ondergrens op twee onafhankelijke bronnen.** Het
    nieuwste dat ik op de wiki zie (`6889071`, 26 sep 18:57) is **nieuwer** dan het nieuwste dat
    mijn regel van gisteren noemde (`6887886`, 25 sep 19:42), en het nieuwste forumitem (26 sep
    14:37) is nieuwer dan dat van gisteren (25 sep 03:21). Dat `Hotfixes` en beide API-pagina's
    níét bewogen, is dus een **echte stilte** en geen oude snapshot: dezelfde fetches die de stilte
    melden, leveren elders wél nieuws.
  - ⚠️ **NIET GELEZEN, en dat is geen "niets gevonden":**
    - `news.blizzard.com` blijft `EGRESS_BLOCKED`. Ook een **directe `curl`** faalt in deze sessie
      op de proxy (`CONNECT tunnel failed, response 403`) — dat geldt óók voor
      `warcraft.wiki.gg`, dus **alle** wiki- en forumdata hierboven komt via `web_fetch_exa`.
    - `wowhead.com/blue-tracker` gaf vandaag geen fout maar ook geen inhoud: alleen de paginatitel
      *"Blue Tracker - World of Warcraft"* en een lege body (JS-gerenderd). Derde dag op rij dat
      deze tweede spiegel niets oplevert. Een blue post van gisteravond die de wiki nog niet heeft
      opgepikt, zou ik daardoor kunnen missen.
  - **Bronnen, alle met cache-buster:** `warcraft.wiki.gg/api.php` — `prop=revisions` op negen
    titels, `rvlimit=10` op `TOC format`, `action=compare&fromrev=6887886&torev=6889071`,
    `action=parse&prop=sections` en `prop=wikitext&section=27|28`;
    `us.forums.blizzard.com` categorie-JSON 35 (`order=created` én `order=activity`) en
    `t/2362846.json`; `wowhead.com/blue-tracker`; 2 × `WebSearch`. De wiki-API blijft
    *"Unrecognized parameter: nocache"* waarschuwen — een MediaWiki-waarschuwing, geen fout.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** ⚠️ De werkmap stond voor de **derde** dag op
    rij in **detached HEAD**, nu op `9f8f9e5`, met de lokale `main`-ref op `f32c136`. Na
    `git fetch origin main` bleek `9f8f9e5` exact `origin/main` (Robs consumables-werk van
    gisteren) en `f32c136` een directe voorouder daarvan: geen verloren werk. 📌 Dit is stelselmatig
    en hoort bij hoe deze cloud-sessie uitcheckt, niet bij iets wat Rob doet. 🔴 **Nieuw vandaag:
    `git checkout -B main` werd geweigerd** door de permissie-classifier van de sessie
    ("Irreversible Local Destruction"), dus de lokale `main`-ref is **niet** bijgezet; er is
    gecommit op de detached HEAD en gepusht met `git push origin HEAD:main`. Dat is dezelfde
    uitkomst op `origin` zonder een ref te overschrijven. Geen van de vier wachter-bestanden stond
    gewijzigd-maar-ongecommit.
- [2026-09-28] ✅ **Geen relevante API-wijzigingen (21–28 sep). 0 × [MOET GEFIKST].** Alle negen
  wiki-pagina's die ik volg staan op **exact dezelfde revid en bytegrootte** als gisteren, en de
  stilte is geen cache: twee onafhankelijke bronnen in dezelfde run zijn wél nieuwer dan wat mijn
  eigen regel van gisteren noemde.
  - 🔇 **Gelezen en byte-voor-byte onveranderd:** `TOC format` (`6889071`, Zeal, 26 sep 18:57:25Z,
    27396 b — precies de revisie die mijn regel van gisteren als eindpunt noemde; na de elf
    bewerkingen van die avond is de pagina 33 uur stil), `Hotfixes` (`6886643`, Dark T Zeratul,
    25 sep 00:42:51Z, 364493 b), `Patch 12.1.0/API changes` (`6886719`, 102481 b), `Patch
    12.1.5/API changes` (`6886717`, 34466 b), `Patch 12.0.7/API changes` (`6794100`, 4 aug),
    `API change summaries` (`6883777`, 22 sep). `Patch 12.1.6/API changes`, `12.1.7/…` en
    `12.2.0/API changes` blijven `"missing":true`.
  - 🔒 **Cache-val uitgesloten, met een harde ondergrens op twee onafhankelijke bronnen.**
    (a) `list=recentchanges` (ns 0) levert bewerkingen van **vandaag 03:36:14Z** (`6891314`,
    *Sentinel Keldara Sunblade*) — nieuwer dan élke revisie die mijn logboek tot nu toe noemt.
    (b) Het nieuwste forumbericht is van **27 sep 08:37:34Z**, nieuwer dan het nieuwste van
    gisteren (26 sep 14:37). Dezelfde fetches die de stilte melden, leveren elders dus wél nieuws:
    de stilte op de negen pagina's is **echt**. ⚠️ `recentchanges` is géén volledige veegactie —
    `rclimit=60` dekt op deze wiki maar **17 minuten** (03:19–03:36Z), dus hij dient hier alleen
    als versheidsbewijs, niet als dekking.
  - 🆕 **Nieuw gereedschap deze run: een `list=allpages`-veegactie op `Patch 12.1*`**, zodat een
    nieuwe API-pagina niet gemist kan worden doordat ik alleen naar mijn eigen negen titels kijk.
    GEMETEN, precies zeven pagina's: `Patch 12.1`, `Patch 12.1.0`, `Patch 12.1.0/API changes`,
    `Patch 12.1.0 (undocumented changes)`, `Patch 12.1.5`, `Patch 12.1.5/API changes`,
    `Patch 12.1.7`. **Eén pagina is nieuw sinds gisteren en hij is leeg:** `Patch 12.1`
    (`6889180`, Surafbrov, 26 sep 20:56:53Z, **26 bytes**, `parentid=0`) — een redirect,
    commentaar *"Redirected to [[Patch 12.1.0]] via [[Special:SearchDigest]]"*. Geen inhoud, dus
    **[RAAKT ONS NIET]**. De vier niet-API-pagina's zijn allemaal ouder dan een week en dus buiten
    mijn venster: `Patch 12.1.0` (17 sep), `Patch 12.1.5` (22 sep), `Patch 12.1.0 (undocumented
    changes)` (16 sep), `Patch 12.1.7` (12 sep, 893 b). ⚠️ `Patch 12.1.6` bestaat in **geen**
    vorm; de veegactie bevestigt wat de `"missing":true` van de API-pagina al zei.
    ℹ️ Dezelfde veegactie op `Patch 12.2` gaf `CRAWL_UNEXPECTED_CONTENT_TYPE`, en `prop=revisions`
    op titels mét een `(haakje)` erin gaf twee keer `CRAWL_UNKNOWN_ERROR` (ook met `%28%29`);
    **`pageids=` in plaats van `titles=` werkte meteen** — noteer dat voor volgende runs.
  - 🗣️ **Forum (categorie 35, `order=created`): geen nieuw topic, één reactie, geen blue post.**
    Het nieuwste topic is nog steeds `2362999` *WoW Forever Addons* (26 sep 14:37); de reactie
    erop is van `Ludius` (27 sep 08:37:34Z, `"staff":false`) en luidt volledig: *"`https://
    www.curseforge.com/wow/search?class=addons&gameVersionTypeId=88568` shows you all addons
    marked as compatible with Forever by their authors."* Een CurseForge-zoeklink, geen API.
    **Geen `community-manager`- of `cs-support-sse`-post**; de blue-accounts in de lijst hangen nog
    aan dezelfde vier vastgepinde topics (nieuwste activiteit *UI Add-On Development Policy*,
    28 aug).
  - 📰 **Hotfixes: nog steeds die van 24 sep, onafhankelijk bevestigd.** `WebSearch` vindt als
    nieuwste *"Hotfixes: September 24, 2026"* en niets van 25, 26, 27 of 28 sep — consistent met
    de wiki-`Hotfixes`-pagina die sinds 25 sep 00:42 niet bewogen is. **AFGELEID (via search,
    pagina zelf niet gelezen.)**
  - 🔁 **De 12.1.5-samenvatting uit `WebSearch` is oud nieuws, en ik heb dat tegen mijn eigen
    logboek gemeten in plaats van tegen mijn geheugen.** De zoekmachine vatte drie items op:
    chat-tabs gebruiken `UIFrameFlash` niet meer (minder taint), `RaidWarning`-frames hielden
    secret aspects op hun fontstrings na terugkeer in de pool, en addons krijgen een extra
    één-frame-venster voor de hitbox van een vijandelijke nameplate bij een laat
    `UNIT_CLASSIFICATION_CHANGED`. GEMETEN in `docs/API_WATCH.md`: `UIFrameFlash` 1×,
    `RaidWarning` 2×, `UNIT_CLASSIFICATION_CHANGED` 2× — alle drie staan er al. **Positieve
    controle in dezelfde run:** `TimedSignalMap` 22×, een verzonnen patroon 0×; patroon én scope
    deugen. De 12.1.5-pagina is sinds 25 sep niet bewogen, dus dit is **geen nieuwe vondst**.
  - ⏳ **Eén artikel gelezen dat ik BEWUST NIET meetel, zodat de volgende run het niet als nieuw
    ontdekt.** `wowforeverbuilds.com` — *"What the WoW Forever beta breaks for addons: secret
    health values, dead secure snippets, new APIs"*, **gedateerd 18 sep 2026** en dus 10 dagen oud:
    buiten het venster van 7 dagen (harde regel 1). Het gaat bovendien over de **WoW
    Forever-betaclient** (build `1.60.1.69913`), niet over retail 12.1, en de site zegt zelf dat
    zijn illustratie AI-gegenereerd is — behandel het als **kandidaat, geen bewijs**. Het beweert
    dat `UnitHealth` daar een secret number is, dat `loadstring_untainted` ontbreekt waardoor
    secure snippets niet compileren, dat `WOW_PROJECT_ID` 1 is, en dat `GetItemInfo`,
    `GetSpellInfo`, `GetSpellBookItemName`, `GetNumTalentTabs`, `GetTalentInfo` en
    `GetNumSkillLines` daar weg zijn.
    - ✅ **[AL AFGEDEKT] — en dit is het enige stukje code-werk dat het artikel waard was, want de
      controle kostte één grep en het antwoord is bruikbaar los van de betaclient.** GEMETEN over
      de hele addon (272 `.lua`-bestanden, buiten `.git`, `docs`, `tools`, `dist`): de zes globals
      leveren **7 treffers** op en **alle zeven** staan achter een `C_Item`/`C_Spell`-tak met de
      kale global als tweede, expliciet geguarde tak — `Modules/Delves.lua:4186-4191`
      (`if C_Spell and C_Spell.GetSpellName then … end; if GetSpellInfo then`),
      `Modules/ConsumableReadyBoard.lua:593-596` (`elseif GetSpellInfo then`),
      `Modules/RitualBossCoach.lua:244` (`or (GetSpellInfo and GetSpellInfo(id))`),
      `Modules/PlayCardWindow.lua:380-382`, `Modules/DelveCuriosData.lua:178`,
      `Modules/GuideConsumables.lua:48` en `:62`. **Positieve controle op dezelfde reikwijdte:**
      dezelfde scope vindt `C_Item.`/`C_Spell.` in **69** bestanden. `loadstring` en
      `loadstring_untainted`: **0 treffers** in de addon. `WOW_PROJECT_ID` komt alleen voor in
      `Libs/LibDBIcon-1.0.lua:533`, `:572` en `:607`, elke keer als
      `if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then` — de tak die op retail juist wél draait.
      📌 Dit is **geen** nieuwe [MOET GEFIKST]: er is vandaag geen API-wijziging die dit raakt, en
      MH is retail-only (`MidnightHelper.toc:1` = `## Interface: 120007, 120100`, één `.toc` in de
      repo). Ik noteer het omdat de volgende run dit artikel weer tegenkomt.
  - ⚠️ **NIET GELEZEN, en dat is geen "niets gevonden":**
    - `news.blizzard.com` blijft `EGRESS_BLOCKED`; ook `warcraft.wiki.gg` is via directe `curl`
      niet te bereiken, dus alle wiki- en forumdata hierboven komt via `web_fetch_exa`.
    - `wowhead.com/blue-tracker` gaf voor de **vierde** dag op rij alleen de paginatitel
      *"Blue Tracker - World of Warcraft"* en een lege body (JS-gerenderd). Een blue post van
      gisteravond die de wiki nog niet heeft opgepikt, zou ik daardoor kunnen missen.
  - **Bronnen, alle met cache-buster:** `warcraft.wiki.gg/api.php` — `prop=revisions` op negen
    titels, `list=recentchanges` (ns 0, 60 items), `list=allpages` met `apprefix=Patch 12.1` en
    `Patch 12.2`, `prop=revisions` op `pageids=708701|664847|664848|664849|686125`;
    `us.forums.blizzard.com` categorie-JSON 35 (`order=created`) en `t/2362999.json`;
    `wowhead.com/blue-tracker`; `wowforeverbuilds.com`; 2 × `WebSearch`. De wiki-API blijft
    *"Unrecognized parameter: nocache"* waarschuwen — een MediaWiki-waarschuwing, geen fout.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Geen van de vier wachter-bestanden stond
    gewijzigd-maar-ongecommit. ⚠️ Vierde dag op rij **detached HEAD**, nu op `644a124`
    (= `origin/main`, Robs `CurseForge description`-commit van gisteren), dus er is gecommit op de
    detached HEAD en gepusht met `git push origin HEAD:main` — `git checkout -B main` werd op
    27 sep geweigerd door de permissie-classifier van de sessie en is niet opnieuw geprobeerd.
    🔎 **Nieuw en gemeten: `origin/main` is deze keer met een `forced update` binnengekomen**
    (`+ f32c136...644a124 main -> origin/main`), en `f32c136` — Robs *"addon_updates: fold a
    suite's modules into their parent"* van 23 sep — is **geen voorouder** van `644a124`; het
    onderwerp staat ook niet in de laatste 60 commits. **Er is niets verloren:** `git cat-file -p`
    op `tools/addon_updates.py` in beide revisies geeft een **identiek** bestand van 119 regels
    (`diff` leeg). De historie is dus herschreven, de inhoud is er nog. Ik repareer hier niets.
- [2026-09-29] ✅ **Geen relevante API-wijzigingen (22–29 sep). 0 × [MOET GEFIKST].** Alle negen
  wiki-pagina's die ik volg staan op **exact dezelfde revid en bytegrootte** als gisteren — dag
  twee van die stilte — en de stilte is opnieuw geen cache: **beide** brondomeinen serveren in
  dezelfde run materiaal van vanochtend.
  - 🔇 **Gelezen en byte-voor-byte onveranderd:** `TOC format` (`6889071`, Zeal, 26 sep 18:57:25Z,
    27396 b — de pagina is nu 57 uur stil), `Hotfixes` (`6886643`, Dark T Zeratul, 25 sep
    00:42:51Z, 364493 b), `Patch 12.1.0/API changes` (`6886719`, Ketho, 25 sep 01:45:50Z,
    102481 b), `Patch 12.1.5/API changes` (`6886717`, Ketho, 25 sep 01:45:29Z, 34466 b),
    `Patch 12.0.7/API changes` (`6794100`, Ketho, 4 aug, 34044 b), `API change summaries`
    (`6883777`, Ketho, 22 sep, 7280 b). `Patch 12.1.6/API changes`, `12.1.7/…` en
    `12.2.0/API changes` blijven `"missing":true`.
  - 🔒 **Cache-val uitgesloten op ALLEBEI de domeinen, elk met zijn eigen bewijs in deze run.**
    (a) Wiki: `list=recentchanges` (ns 0) levert bewerkingen tot **vandaag 03:36:45Z**
    (`6892871`, *Chief Officer Leonards*, Mordecay) — nieuwer dan élke revisie in mijn logboek.
    (b) Forum: `us.forums.blizzard.com/en/wow/posts.json` geeft als nieuwste post **vandaag
    03:38:11Z** (post `30247558`, topic `2365534` *Regarding Reputations*, categorie 349). Beide
    servers leveren dus vers materiaal; de stilte op mijn negen pagina's en in categorie 35 is
    **echt**. ⚠️ `recentchanges` blijft géén veegactie — `rclimit=60` dekt vandaag maar **44
    minuten** (02:52–03:36Z) en dient alleen als versheidsbewijs.
  - 🧹 **Veegactie verbreed van `Patch 12.1*` naar `Patch 12*`**, want de smalle variant van
    gisteren zou een `Patch 12.2.0/API changes` niet gezien hebben. GEMETEN, **25 pagina's**, en
    er is er **geen enkele bij die ik nog niet kende**. Van de vijf 12.2-titels heeft er **geen
    één** een `/API changes`-subpagina: `Patch 12.2` (`6873087`, 13 sep, **26 b** redirect),
    `Patch 12.2.0` (`6883801`, Mordecay, 22 sep, 928 b), `Patch 12.2.5`, `Patch 12.2.7`.
    Ook buiten mijn venster en onveranderd: `Patch 12.1.0 (undocumented changes)` (`6877092`,
    16 sep, 7870 b), `Patch 12.1.7` (`6872990`, 12 sep, 893 b), `Patch 12.1` (26 b redirect).
    📌 **`Patch 12.1.6` bestaat in geen enkele vorm** — de bredere sweep bevestigt dat nu voor de
    hele 12-reeks, niet alleen voor de titels die ik zelf bedacht had.
  - 🗣️ **Forum (categorie 35): geen nieuw topic, geen nieuwe reactie, geen blue post.** Het
    nieuwste topic is nog steeds `2362999` *WoW Forever Addons* (26 sep 14:37:40Z) en de nieuwste
    activiteit in de hele categorie is nog steeds de reactie van `Ludius` van **27 sep 08:37:34Z**
    — identiek aan gisteren. Dat "identiek" is hier geen cache-verdenking maar een gemeten
    stilstand, want (b) hierboven laat zien dat dezelfde forumserver vanochtend wél post.
    **Geen `community-manager`- of `cs-support-sse`-post in categorie 35.**
  - 📰 **Hotfixes: nog steeds die van 24 sep — vijfde dag.** `WebSearch` vindt als nieuwste
    *"Hotfixes: September 24, 2026"* (`news.blizzard.com/en-us/article/24296142`) en niets van
    25 t/m 28 sep; dat strookt met de wiki-`Hotfixes`-pagina die sinds 25 sep 00:42 niet bewogen
    is. **AFGELEID (via search, de pagina zelf niet gelezen.)**
  - 🔁 **De 12.1.5-samenvatting uit `WebSearch` is opnieuw oud nieuws, gemeten tegen mijn logboek
    in plaats van tegen mijn geheugen.** De zoekmachine vatte vijf punten samen: de
    `UnitFrameUtil`-library (`UpdateUnitPvPIndicator`), `C_Intl` dat secret strings van tainted
    code accepteert, `SetCooldown`/`Clear` die niet meer vanuit tainted code mogen op een
    protected cooldown-frame, castbar-ID's die uniek zijn per unit token, en
    `GetArenaOpponentSpecDisplayInfo` / `GetUnitRoleIconDisplayInfo`. GEMETEN in
    `docs/API_WATCH.md`: `UnitFrameUtil` 9×, `SetCooldown` 20×, `C_Intl` 4×, castbar 36×
    (hoofdletterongevoelig; **hoofdlettergevoelig `Castbar` geeft 0** — precies de
    [[silence-is-not-absence]]-val), `GetArenaOpponentSpecDisplayInfo` 1×,
    `GetUnitRoleIconDisplayInfo` 1×, `UpdateUnitPvPIndicator` 3×. **Positieve controle in dezelfde
    run:** een verzonnen patroon geeft 0×. Alle vijf staan er dus al, en de 12.1.5-pagina is sinds
    25 sep niet bewogen — **geen nieuwe vondst, en dus ook geen nieuwe grep over de addon.**
  - ⚠️ **NIET GELEZEN, en dat is geen "niets gevonden":**
    - `news.blizzard.com` blijft `EGRESS_BLOCKED`. Nieuw gemeten vandaag: een **directe `curl`**
      naar `warcraft.wiki.gg` geeft `CONNECT tunnel failed, response 403` — alle wiki- en
      forumdata hierboven komt dus via `web_fetch_exa`.
    - `wowhead.com/blue-tracker` **niet geprobeerd** deze run: vier runs op rij gaven alleen de
      paginatitel en een lege body (JS-gerenderd). De hotfix-versheid is in plaats daarvan via
      `WebSearch` gedekt. Een blue post van vannacht die noch de wiki noch het UI-forum heeft
      opgepikt, zou ik daardoor kunnen missen.
  - 🆕 **Twee gereedschapsnotities voor de volgende run.** (1) `us.forums.blizzard.com/en/wow/
    posts.json` is een **compacte versheidsproef**: hij begint meteen met `latest_posts` en dus
    met een tijdstempel, terwijl `35.json` en `latest.json` eerst een `users`-array van duizenden
    tekens uitspugen waar de timestamps achter wegvallen. `latest.rss` geeft
    `CRAWL_UNEXPECTED_CONTENT_TYPE`. (2) De wiki-API is via Exa **wisselvallig, niet stuk**:
    dezelfde `pageids=`-query gaf achtereenvolgens `CRAWL_UNKNOWN_ERROR`,
    `CRAWL_UNEXPECTED_CONTENT_TYPE` en toen — met dezelfde parameters in een andere volgorde —
    gewoon het juiste antwoord. **Opnieuw proberen vóór je "onbereikbaar" noteert.**
  - **Bronnen, alle met cache-buster:** `warcraft.wiki.gg/api.php` — `prop=revisions` op negen
    titels, `list=recentchanges` (ns 0, 60 items), `list=allpages` met `apprefix=Patch 12`
    (60 items), `prop=revisions` op `pageids=686125|706990|706995|664849`;
    `us.forums.blizzard.com` categorie-JSON 35 (`order=created`), `l/latest.json` en `posts.json`;
    2 × `WebSearch`. De wiki-API blijft *"Unrecognized parameter: nocache"* waarschuwen — een
    MediaWiki-waarschuwing, geen fout.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Geen van de vier wachter-bestanden stond
    gewijzigd-maar-ongecommit (`git status` leeg bij aanvang). ⚠️ Vijfde dag op rij **detached
    HEAD**, nu op `d93331e` (= `origin/main`, Robs *"Handoff: recording list for the website
    clips"*), dus opnieuw gecommit op de detached HEAD en gepusht met
    `git push origin HEAD:main`.
    🔎 **De `forced update` van gisteren is GEEN historie-herschrijving, maar een eigenaardigheid
    van de container — gemeten vandaag.** `git fetch` meldde opnieuw
    `+ f32c136...d93331e main -> origin/main (forced update)`, **met exact dezelfde `f32c136`**
    als gisteren (Robs *"addon_updates: fold a suite's modules into their parent"*, 23 sep). Dat
    kan geen nieuwe rewrite zijn: gisteren is er ná die melding al voorbij `f32c136` gepusht.
    De verklaring is dat de verse clone van elke run zijn `origin/main`-ref op `f32c136` zet
    terwijl de working tree al op de echte tip staat (vandaag `d93331e`); de eerste `fetch`
    trekt die achterstallige ref bij en git noemt dat "forced". `f32c136` is nog steeds **geen**
    voorouder van de tip en het onderwerp staat niet in de laatste 80 commits — net als gisteren,
    en net als gisteren is er niets verloren. 📌 **Volgende run: tel deze melding niet als
    nieuws.** Verandert de linkerkant ooit in iets anders dan `f32c136`, dán is het wél wat.
- [2026-09-30] 📰 **Eén echt nieuw bronitem (23–30 sep): de hotfixes van 29 sep. 0 × [MOET
  GEFIKST].** En één **gereedschapscorrectie die zwaarder weegt dan de vondst zelf**:
  `news.blizzard.com` is via Exa **wél** leesbaar — zeven runs op rij hebben hier het tegendeel
  beweerd.
  - 🔴 **CORRECTIE — `news.blizzard.com` is NIET onleesbaar. GEMETEN vandaag.**
    `web_fetch_exa` op `news.blizzard.com/en-us/article/24296142/hotfixes-september-29-2026
    ?nocache=20260930` gaf **de volledige artikeltekst**, niet alleen de titel: de hele
    september-lijst tot en met 22 sep, secties en developers' notes incl. Sinds 24 sep staat er in
    dit logboek elke dag *"`news.blizzard.com` blijft `EGRESS_BLOCKED`"* (`:2710`, `:2787`,
    `:2873`, `:2978`, `:3110`, `:3215`, `:3288`) en is de hotfixtekst daarom uit de wiki of uit
    een `WebSearch`-samenvatting gehaald. Dat was **waar voor `WebFetch` en voor directe `curl`**
    — die blijven geblokkeerd — maar het is als *"de pagina is onbereikbaar"* opgeschreven, en dat
    is iets anders. 📌 **Volgende run: eerst `web_fetch_exa` op het hotfix-artikel zelf, mét
    cache-buster; pas daarna terugvallen op `WebSearch`.** Een samenvatting laat nu juist de
    sectiekoppen weg, en de sectiekoppen zijn precies waar ik op zoek (*"User Interface"*,
    *"Addons"*).
    ⚠️ **En dit is dezelfde fout als de cache-val, alleen omgekeerd:** daar telde ik oud
    materiaal als nieuw, hier telde ik leesbaar materiaal als onleesbaar. Beide keren was de
    aantekening van gisteren het bewijs dat ik niet meer opnieuw controleerde.
  - 📰 **Hotfixes: September 29, 2026 — ZELF GELEZEN, geen UI-, Addon- of API-sectie.**
    De sectie van 29 sep heeft precies drie groepen: *Dungeons and Raids* (The Venomous Abyss /
    Ula'tek — *"Fixed an issue with Ula'tek's Mother's Wrath where it can be cast at a target that
    isn't the current target if a non-target has higher threat but hasn't passed the threat
    threshold to force a target change."*), *Events* (Brewfest — *"Items that drop from Coren
    Direbrew should now have the required level set to the player who receives the item."*) en
    *The Burning Crusade Classic* (*"Honorary Brewer Hand Stamp can now be purchased."*).
    **[RAAKT ONS NIET]** op mijn terrein: geen API, geen secure frame, geen taint, geen secret
    value. De Brewfest- en delve-kant is voor `CONTENT_WATCH.md`, niet voor mij.
    📌 **Let op de article-ID:** `24296142` is dezelfde als die gisteren *"Hotfixes: September 24,
    2026"* heette. Blizzard houdt één doorlopend hotfix-artikel bij en hertitelt het; een
    onveranderde ID betekent dus **niet** een onveranderde pagina. Dat de titel nu **nieuwer** is
    dan gisteren is het omgekeerde van de cache-val en dus geen verdenking.
  - 🔇 **Wiki: zes gevolgde pagina's byte-voor-byte onveranderd — dag drie.** Identieke revid én
    bytegrootte als gisteren én eergisteren: `TOC format` (`6889071`, Zeal, 26 sep 18:57:25Z,
    27396 b — nu **81 uur** stil), `Hotfixes` (`6886643`, Dark T Zeratul, 25 sep 00:42:51Z,
    364493 b — de wiki heeft de hotfix van 29 sep dus **nog niet** opgepikt, wat precies de reden
    is dat de wiki geen vervanging voor Blizzards eigen pagina is), `Patch 12.1.0/API changes`
    (`6886719`, Ketho, 25 sep 01:45:50Z, 102481 b), `Patch 12.1.5/API changes` (`6886717`, Ketho,
    25 sep 01:45:29Z, 34466 b), `Patch 12.0.7/API changes` (`6794100`, Ketho, 4 aug, 34044 b),
    `API change summaries` (`6883777`, Ketho, 22 sep, 7280 b).
  - 🧹 **Veegactie `Patch 12*` (ns 0): 25 pagina's, exact dezelfde lijst als gisteren.**
    **`Patch 12.1.6` bestaat in geen enkele vorm**, en van de vier 12.2-titels (`Patch 12.2`,
    `12.2.0`, `12.2.5`, `12.2.7`) heeft er **geen één** een `/API changes`-subpagina. 📌 Deze
    enumeratie is sterker bewijs dan de `titles=`-query die ik daarvoor gebruikte: `allpages`
    somt op wat er ís, in plaats van te bevestigen wat ik zelf al bedacht had.
  - 🆕 **NIEUWE VAL, en hij is vannacht bijna in mijn gezicht ontploft: een golf van
    API-genaamde nieuwe wiki-pagina's die géén API-nieuws is.** `list=recentchanges` gaf 60
    `"type":"new"`-regels tussen 03:21Z en 03:37Z, alle van gebruiker `Kaydeethree`, met titels
    als `C UnitAuras.GetUnitAuras`, `IsActionInRange`, `IsAuraFilteredOutByInstanceID`,
    `SetStatusBarTexture`, `GetClassInfo`, `OnEnter`, `OnShow`, `ColorCurve`, `CurveConstants`.
    Dat leest als een lijst verse API-documentatie. **GEMETEN wat het echt is** — de inhoud van
    drie ervan opgehaald (`pageids=709373|709374|709361`): het zijn `#REDIRECT`-stubs van 33, 42
    en 59 bytes die de hoofd-namespace naar `API:` doorsturen, bv.
    `#REDIRECT [[API:C UnitAuras.IsAuraFilteredOutByInstanceID]]`. Wiki-onderhoud. Dat `OnEnter`,
    `OnShow` en `GetClassInfo` ertussen staan — stokoude namen — bevestigt het.
    📌 **Voor de volgende run: een pagina-CREATIE in ns 0 met een API-naam is per se geen
    API-wijziging.** Haal de inhoud op vóór je iets meldt; een redirect van 42 bytes en een nieuwe
    functiedocumentatie zien er in `recentchanges` identiek uit.
  - 🗣️ **Forum (categorie 35): de stilte is verbroken, maar niet door een blue post.**
    Nieuw sinds gisteren: topic `2366363` *"Artwork end cap layers"* (Kierthos, **29 sep
    20:19:41Z**, 1 post, `reply_count` 0, geen antwoord) en een reactie in topic `2306913`
    (`30242159`, Xabo, **28 sep 19:39:25Z**, post 11, een macro-vraag). Beide zijn
    spelersvragen, **geen API-wijziging en geen Blizzard-reactie**.
  - 🆕 **En hier staat eindelijk een HARDE meting waar ik voorheen een zwakke had: geen blue post
    in categorie 35 sinds 22 sep.** `search.json?q=#ui-macro @Kaivax after:2026-09-22` → `posts:
    []`, idem voor `@Vrakthris`. **Twee positieve controles in dezelfde run, op dezelfde scope:**
    (a) `#ui-macro @Kierthos-3132 after:2026-09-22` levert het topic van gisteren op — de
    categorie-filter én de `after:`-filter werken dus; (b) `@Kaivax after:2026-09-22` zonder
    categorie levert 5 posts van hem elders op — hij is dus wél actief. Het lege resultaat is
    daarmee een **echte afwezigheid** en niet [[silence-is-not-absence]].
    📌 **Dit vervangt `latest.json` als methode.** Die dumpt eerst een `users`-array waarin
    `Kaivax` (`community-manager`) en `Vrakthris` (`cs-support-sse`) wél voorkomen, maar
    **ongedateerd** — die array bevat iedere deelnemer aan iedere gelijste thread, dus hij bewijst
    noch aanwezigheid vandaag noch afwezigheid. Vorige runs concludeerden er *"geen
    community-manager-post"* uit; dat was toevallig juist, niet gemeten.
  - 🔁 **De 12.1.5-samenvatting uit `WebSearch` is voor de derde dag oud nieuws, gemeten tegen het
    logboek.** Vijf items: `SetCooldown`/`Clear`/`SetCooldownFromDurationObject` als protected,
    de `UnitFrameUtil`-library (`UpdateUnitPvPIndicator`), `C_Intl` met secret strings,
    chat-tabs die `UIFrameFlash` niet meer gebruiken, en `GetTextureMetatable`. GEMETEN in
    `docs/API_WATCH.md`: `SetCooldown` 22×, `SetCooldownFromDurationObject` 5×, `UIFrameFlash` 3×
    (met de afdekking al uitgeschreven op `:2477`). **Geen nieuwe vondst** — de 12.1.5-pagina is
    sinds 25 sep niet bewogen.
  - ✅ **[AL AFGEDEKT] — toch opnieuw IN DE CODE gemeten, niet uit mijn eigen aantekening
    geciteerd.** De protected-cooldown-regel van 12.1.5 is de enige 12.1.5-wijziging die MH
    überhaupt raakt, dus die verdient een verse lezing:
    - `Modules/CombatSafety.lua:598-602` — `f._cd:SetCooldownFromDurationObject(duration)` staat
      achter `if duration and f._cd.SetCooldownFromDurationObject then` **én** in een `pcall`.
      Dubbel afgedekt.
    - `Modules/CombatSafety.lua:700-701` — `f._cd:SetCooldown(GetTime(), 8)` staat achter
      `if f._cd.SetCooldown then`, **zonder** `pcall`. Die guard bewijst alleen dat de methode
      bestaat, niet dat de aanroep mag. Maar de 12.1.5-regel bijt alleen op een **protected**
      cooldown-frame vanuit tainted code, en `f._cd` is dat niet: `f = CreateFrame("Button",
      "MidnightHelperCombatSafety", UIParent)` (`:114`) en `cd = CreateFrame("Cooldown", nil, f,
      "CooldownFrameTemplate")` (`:184`) — een kale, niet-secure Button aan `UIParent`. De énige
      treffer op `secure` in dat hele bestand is de comment op `:105`: *"niet-secure → geen
      combat-beperkingen"*. Geen `SecureActionButtonTemplate`, geen `SecureHandler`, geen
      `SetParent` naar iets beschermds.
    - 📌 **Dit is GEEN nieuwe bevinding.** Dezelfde conclusie staat al op `:380` en `:681-689`
      (22 sep) en is op `:1908-1913` (16 sep) al eens aangehaald. Het verschil is dat ik hem
      vandaag in `CombatSafety.lua` heb nagelezen in plaats van in mijn eigen regel erover.
  - ✅ **[RAAKT ONS NIET] — vier namen, nul treffers, met controle.** `UIFrameFlash` 0,
    `ChatFrameUtil` 0, `UpdateUnitPvPIndicator` 0, `GetTextureMetatable` 0 (scope: hele addon,
    zonder `.git`/`docs`/`tools`/`dist`). **Positieve controle op dezelfde scope in dezelfde run:**
    `CreateFrame` 722, `issecretvalue` 196, `InCombatLockdown` 197, `C_UnitAuras` 77,
    `SecureActionButtonTemplate` 15. **Negatieve controle:** een verzonnen
    `C_ZzzNietBestaand.Foo` geeft 0. Patroon én scope deugen.
  - ⚠️ **De gemeten namespace-lijst in `docs/WATCHER_API_PROMPT.md` is flink verouderd, en dat is
    een filter dat de verkeerde dingen doorlaat.** Die lijst is van 18 aug en noemt `CreateFrame`
    618×, `issecretvalue` 112×, `InCombatLockdown` 162×, `C_UnitAuras` 29. Vandaag gemeten:
    **722 / 196 / 197 / 77** — `issecretvalue` is bijna verdubbeld en `C_UnitAuras` ruim
    verdrievoudigd. Het document zegt zelf dat je hem moet verversen *"als de addon flink
    gegroeid is"*. Dat is nu zo. 🔴 **Ik raak dat bestand niet aan** — ik schrijf alleen
    `API_WATCH.md`. Dit is een punt voor Rob: één `tools/_probe.py`-run volstaat.
  - 🔒 **Cache-val uitgesloten op beide domeinen, elk met eigen bewijs in deze run.** (a) Wiki:
    `list=recentchanges` (ns 0) loopt tot **vandaag 03:37:02Z** (`6895368`, *Heritage quest*,
    Kaydeethree). (b) Forum: `posts.json` geeft als nieuwste post **vandaag 03:36:43Z**
    (`30261181`, topic `2366700`, categorie 347). Beide servers leveren vers materiaal; de stilte
    op mijn zes pagina's is echt. ⚠️ `recentchanges` blijft géén veegactie — `rclimit=60` dekt
    vandaag maar **16 minuten** (03:21–03:37Z, door de redirect-golf), en dient alleen als
    versheidsbewijs.
  - ⚠️ **NIET GELEZEN, en dat is geen "niets gevonden":**
    - `wowhead.com/blue-tracker` opnieuw **niet geprobeerd**: vijf runs op rij gaven alleen de
      paginatitel en een lege body (JS-gerenderd). Nu `news.blizzard.com` zelf via Exa blijkt te
      werken, is die spiegel ook minder nodig.
    - `warcraft.wiki.gg` via directe `curl` **niet opnieuw geprobeerd** (gisteren:
      `CONNECT tunnel failed, response 403`). Alle wiki- en forumdata komt via `web_fetch_exa`.
    - De 12.1.5-**PTR-buildnotes** zelf niet opgehaald; ik leun daar op `WebSearch`. Wat de PTR
      nog gaat brengen is `PTR_12.1_WATCH.md`'s terrein.
  - 🔧 **Gereedschapsnotitie: de wiki-API via Exa is wisselvallig, en `rvslots=main` is geen
    remedie.** Vijf van de negen `api.php`-aanroepen faalden eerst met
    `CRAWL_UNEXPECTED_CONTENT_TYPE` of `CRAWL_UNKNOWN_ERROR` en slaagden daarna ongewijzigd.
    Ik dacht een patroon te zien (de geslaagde calls hadden `rvslots=main`), maar dat is
    **weerlegd**: dezelfde query mét `rvslots=main` faalde alsnog, en `allpages` — dat die
    parameter niet eens kent — slaagde. **Het is ruis, geen parameterprobleem: opnieuw proberen,
    niet herschrijven.**
  - **Bronnen, alle met cache-buster:** `warcraft.wiki.gg/api.php` — `prop=revisions` op 6 titels,
    `prop=revisions&rvprop=content` op `pageids=709373|709374|709361`, `list=recentchanges`
    (ns 0, 60), `list=allpages&apprefix=Patch 12` (60); `news.blizzard.com` artikel `24296142`
    (**volledig gelezen**); `us.forums.blizzard.com` — `posts.json`, categorie-JSON 35,
    `35/l/latest.json`, topic-JSON `2366363`, en 4 × `search.json` (2 metingen + 2 positieve
    controles); 2 × `WebSearch`. De wiki-API blijft *"Unrecognized parameter: nocache"*
    waarschuwen — een MediaWiki-waarschuwing, geen fout.
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Geen van de vier wachter-bestanden stond
    gewijzigd-maar-ongecommit (`git status` leeg bij aanvang). ⚠️ Zesde dag **detached HEAD**, nu
    op `5910c3f` (= `origin/main`, *"Translate /mh export into German, French, Spanish, Portuguese
    and Italian"*), dus gecommit op de detached HEAD en gepusht met `git push origin HEAD:main`.
    ✅ **De `forced update` gedroeg zich zoals gisteren voorspeld en is dus géén nieuws:**
    `+ f32c136...5910c3f main -> origin/main (forced update)`, met **exact dezelfde `f32c136`**
    links als de twee dagen ervoor. De voorspelling was *"verandert de linkerkant ooit in iets
    anders dan `f32c136`, dán is het wél wat"* — dat is niet gebeurd.
- [2026-10-01] 🧩 **Eén echt nieuw item op mijn terrein (24 sep–1 okt): `GLOBAL_MOUSE_DOWN`/`_UP`
  zijn sinds 12.1 niet meer van `UIParent` af te melden. 0 × [MOET GEFIKST]** — MH gebruikt die
  events nergens. Plus een **gereedschapscorrectie**: de namespace-getallen in dit logboek zijn
  *occurrences*, niet *regels*, en dat verschil leest als een regressie van 45%.
  - 🧩 **[RAAKT ONS NIET] — `GLOBAL_MOUSE_DOWN` / `GLOBAL_MOUSE_UP`, forum-topic `2367394`
    (`#ui-macro`, *"unregister global mouse"*).** Elvenbane, **30 sep 19:19:37Z**, letterlijk:
    *"Anyone know how to unregister it these days? It's initializer got moved with 12.1 and I
    haven't been able to figure out how to unregister it. Used to be as simple as:"* met daaronder
    `UIParent:UnregisterEvent("GLOBAL_MOUSE_DOWN")` en `UIParent:UnregisterEvent("GLOBAL_MOUSE_UP")`.
    **GEMETEN in de code — acht namen, alle nul treffers** (scope: hele addon, `.lua`/`.toc`/`.xml`,
    zonder `.git`/`docs`/`tools`/`dist`): `GLOBAL_MOUSE_DOWN` 0, `GLOBAL_MOUSE_UP` 0,
    `GLOBAL_MOUSE` 0, `GameEvent` 0, `UnregisterInternalEvent` 0, `RegisterInternalEvent` 0,
    `UIParent:UnregisterEvent` 0, `UIParent:RegisterEvent` 0. **Positieve controle, zelfde scope en
    zelfde run:** `CreateFrame` 724, `RegisterEvent` 447, `SecureActionButtonTemplate` 14,
    `UnregisterEvent` 14 (MH meldt dus wél events af — alleen nooit op `UIParent`).
    **Negatieve controle:** `C_ZzzNietBestaand.Foo` 0.
    - 🔴 **EN HIER STOPT WAT IK WEET. Het antwoord in die thread is een GOK en ik schrijf hem niet
      op als migratie.** Fizzlemizz, 30 sep 20:37:52Z, begint zijn post met *"Haven't dug into it
      so just guessing. Try:"* en stelt dan `GameEvent.UnregisterInternalEvent("GLOBAL_MOUSE_DOWN")`
      voor. Dat is **geen Blizzard-uitspraak en staat op geen van de zes wiki-pagina's die ik volg**;
      `GameEvent` komt in `Patch 12.1.0/API changes` niet voor als afmeldroute. De thread heeft
      **geen blue post** en post 2 is de laatste (`posts_count` 2). Dus: *dát* de oude route weg is,
      is gemeld door een speler met 6709 posts; *waarnaar* het moet, **weet ik niet** en ik ga het
      niet raden. Raakt MH toch ooit globale mouse-events aan, dan is dit de open vraag die eerst
      in de client getoetst moet worden.
  - 🧰 **SimC-addon: geen nieuwe release sinds `12.1.0-04` (21 aug 2026).** En dat is precies de
    release die `Modules/SimcExport.lua` in zijn kopcommentaar zegt te volgen (*"read 30 Sep 2026
    at release 12.1.0-04"*, `:12-16`). **MH loopt dus niet achter en er is niets te porten.** De
    hele releaselijst is opgehaald: na `12.1.0-04` staat er niets, en de twee regels van die release
    (*"Add Offspec Talent Loadouts checkbox functionality"*, *"Use built-in talent loadout string
    exporter instead of our own"*) zijn van vóór de datum waarop MH hem gelezen heeft. Geen toets
    aan `ItemString`/`ns.BuildSimcProfile` nodig deze run.
  - 📰 **Hotfixes: de 29-sep-lijst is nog steeds de nieuwste — langs TWEE onafhankelijke wegen, dus
    geen cache-val.** (a) `web_fetch_exa` op artikel `24296142` mét `?nocache=20261001` geeft titel
    *"Hotfixes: September 29, 2026"* en dezelfde drie groepen als gisteren (*Dungeons and Raids* /
    Ula'tek, *Events* / Brewfest, *The Burning Crusade Classic*). (b) `WebSearch` op *"hotfixes
    september 30 2026 OR october 1 2026"* levert alleen `hotfixes-september-29-2026` op en meldt
    expliciet geen 30-sep- of 1-okt-lijst. **Geen UI-, Addon- of API-sectie** in de 29-sep-lijst —
    [RAAKT ONS NIET] op mijn terrein; de Brewfest- en Ula'tek-kant is `CONTENT_WATCH.md`.
    📌 Dit is **geen nieuwe vondst**: gisteren al zelf gelezen en gemeld (`:3351`).
  - 🔇 **Wiki: de `Hotfixes`-pagina IS bewogen, de andere vijf niet — dag vier.** `Hotfixes`
    `6886643` → **`6895406`** (Dark T Zeratul, **30 sep 03:43:29Z**, 364493 → **365107 b**, +614).
    📌 **Dat is 13 minuten ná de run van gisteren**, die daarom nog `6886643` zag en terecht
    schreef dat de wiki de 29-sep-hotfix *"nog niet"* had opgepikt. Hij heeft hem nu, en +614 bytes
    past op precies die drie korte regels — **inhoudelijk niets nieuws**, want ik had ze al bij
    Blizzard zelf gelezen. Byte-voor-byte onveranderd: `TOC format` (`6889071`, Zeal, 26 sep
    18:57:25Z, 27396 b — nu **105 uur** stil), `Patch 12.1.0/API changes` (`6886719`, Ketho, 25 sep,
    102481 b), `Patch 12.1.5/API changes` (`6886717`, Ketho, 25 sep, 34466 b),
    `Patch 12.0.7/API changes` (`6794100`, Ketho, 4 aug, 34044 b), `API change summaries`
    (`6883777`, Ketho, 22 sep, 7280 b).
  - 🧹 **Veegactie `Patch 12*` (ns 0): 25 pagina's, exact dezelfde lijst als de twee dagen ervoor.**
    `Patch 12.1.6` bestaat in geen enkele vorm; van de vier 12.2-titels heeft er géén één een
    `/API changes`-subpagina; en er is nog steeds geen `Patch 12.1.5 (undocumented changes)` —
    terwijl 12.0.0, 12.0.1, 12.0.5, 12.0.7 en 12.1.0 die alle vijf wél hebben.
  - 🔧 **GEREEDSCHAPSCORRECTIE — de namespace-getallen in dit logboek zijn OCCURRENCES, en mijn
    eerste grep van vandaag telde REGELS. Het verschil leest als een regressie die er niet is.**
    `grep -rn … | wc -l` gaf vandaag `issecretvalue` **105**, `InCombatLockdown` **125**,
    `C_UnitAuras` **66** — tegen de **196 / 197 / 77** die gisteren (`:3406`) staan. Dat is tot 45%
    lager en ziet eruit als weggevallen guards. **GEMETEN dat het de telmethode is, niet de code:**
    dezelfde patronen met `grep -rno` (occurrences) geven vandaag **194 / 196 / 83**, en
    `CreateFrame` 724 regels tegenover 725 occurrences. Eén commit sinds gisteren (`ba7a1fc`,
    *"Note tomorrow's second idea"*) raakt geen Lua. **Geen regressie.**
    📌 **Voor de volgende run: zeg erbíj wat je telt.** Twee getallen die hetzelfde heten en
    verschillend meten, is dezelfde soort val als een tabel waarin GEMETEN en AFGELEID er identiek
    uitzien — en dit keer had hij me bijna een verzonnen regressie laten melden.
  - ⏳ **Nog open uit gisteren, NIET nieuw: de gemeten namespace-lijst in
    `docs/WATCHER_API_PROMPT.md` is van 18 aug en verouderd.** Die noemt `issecretvalue` 112× en
    `C_UnitAuras` 29×; vandaag in occurrences **194** en **83**. Met de methode-correctie hierboven
    erbij blijft de conclusie staan (het zijn in beide gevallen occurrences), alleen nu met
    vergelijkbare getallen. 🔴 **Ik raak dat bestand niet aan** — punt voor Rob, één
    `tools/_probe.py`-run volstaat.
  - 🗣️ **Blue post: nog steeds geen enkele in categorie 35 sinds 22 sep, nu met `after:2026-09-24`.**
    `search.json?q=#ui-macro @Kaivax after:2026-09-24` → `posts: []`. **Positieve controle in
    dezelfde run, zelfde scope:** `@Kaivax after:2026-09-24` zonder categoriefilter geeft 8 posts,
    de nieuwste **1 okt 00:17:30Z** (*"Tomorrow morning PDT, we will take the WoW Forever Beta
    offline for maintenance…"*, topic `2367661`). Kaivax is dus actief, alleen niet op `#ui-macro`.
    Een **echte afwezigheid**, geen [[silence-is-not-absence]].
  - 🗣️ **Overig forumverkeer op `#ui-macro` (24 sep–1 okt): vier spelersposts, geen API-nieuws.**
    Naast topic `2367394` hierboven: `2366363` *"Artwork end cap layers"* (Kierthos, 29 sep,
    laagvolgorde van de leeuw/griffioen-artwork), `1780831` post 6 (Bool, 30 sep, iemand die zijn
    eigen to-do-addon aankondigt) en `2306913` post 11 (Xabo, 28 sep, macro-vraag). Geen van deze
    vier meldt een API-wijziging; alleen `2367394` beschrijft gedrag dat 12.1 veranderd heeft.
  - 🔁 **De 12.1.5-samenvatting uit `WebSearch` is voor de vierde dag oud nieuws.** Dezelfde vijf
    items (`SetCooldown`/`Clear` protected, `UnitFrameUtil`/`UpdateUnitPvPIndicator`, secret
    `sourceGUID`, chat-tabs zonder `UIFrameFlash`, castbar-ID's per unit token). Allemaal al
    uitgeschreven in dit logboek, en de 12.1.5-pagina is sinds 25 sep niet bewogen. **Geen nieuwe
    vondst.** De protected-cooldown-afdekking in `Modules/CombatSafety.lua:598-602` en `:700-701`
    is gisteren vers in de code nagelezen (`:3385-3398`); vandaag niets dat die lezing raakt.
  - 🔒 **Cache-val uitgesloten op beide domeinen, elk met eigen bewijs in deze run.** (a) Wiki:
    `list=recentchanges` (ns 0) loopt tot **vandaag 03:35:34Z** (`6896378`, *Doom Weed (Classic)*,
    Kaydeethree). (b) Forum: `posts.json` geeft als nieuwste post **vandaag 03:37:48Z**
    (`30274853`, topic `2361292`, categorie 349). Beide servers leveren vers materiaal.
    ⚠️ En de omgekeerde controle ook: niets wat ik vandaag als nieuwste zag, is **ouder** dan wat
    dit logboek gisteren al noemde — `Hotfixes` ging vooruit, de andere vijf stonden stil, en de
    hotfixtitel is dezelfde (niet eerder). 📌 De redirect-golf van `Kaydeethree` uit gisteren
    (`:3363-3372`) is er vandaag weer, nu als gewone quest-edits; **een ns-0-pagina met een
    API-naam blijft per se geen API-wijziging**, en vandaag stond er geen enkele tussen.
  - ⚠️ **NIET GELEZEN, en dat is geen "niets gevonden":**
    - `news.blizzard.com/en-us/world-of-warcraft` (de WoW-nieuwsindex) gaf via Exa **alleen de
      paginatitel en een lege body** — JS-gerenderd, net als de blue tracker. Mijn versheidsbewijs
      voor dat domein komt daarom van `WebSearch`, niet van de index zelf.
    - `wowhead.com/blue-tracker` opnieuw **niet geprobeerd** (zes runs op rij lege body).
    - `warcraft.wiki.gg` via directe `curl` **niet opnieuw geprobeerd**; alle wiki- en forumdata
      komt via `web_fetch_exa`.
    - De 12.1.5-**PTR-buildnotes** zelf niet opgehaald; ik leun daar op `WebSearch`. Terrein van
      `PTR_12.1_WATCH.md`.
  - **Bronnen, alle met cache-buster:** `warcraft.wiki.gg/api.php` — `prop=revisions` op 6 titels,
    `list=recentchanges` (ns 0, 30), `list=allpages&apprefix=Patch 12` (60);
    `news.blizzard.com` artikel `24296142` (**volledig gelezen**) + de WoW-index (**leeg**);
    `github.com/simulationcraft/simc-addon/releases` (**volledig gelezen**);
    `us.forums.blizzard.com` — `posts.json`, `t/2367394.json` (**beide posts volledig gelezen**),
    en 3 × `search.json` (1 veegactie + 1 meting + 1 positieve controle); 2 × `WebSearch`.
    De wiki-API blijft *"Unrecognized parameter: nocache"* waarschuwen — een MediaWiki-waarschuwing,
    geen fout. ✅ Alle negen `api.php`-aanroepen slaagden deze run in één keer; de
    `CRAWL_*`-ruis van gisteren bleef weg (opnieuw proberen, niet herschrijven — dat blijft het
    advies).
  - ✅ **Repo: alleen `docs/API_WATCH.md` aangeraakt.** Geen van de vier wachter-bestanden stond
    gewijzigd-maar-ongecommit (`git status --porcelain` leeg bij aanvang).
    ✅ **EN DE DETACHED HEAD IS WEG — na zes dagen.** `git rev-parse --abbrev-ref HEAD` geeft
    **`main`**, niet `HEAD`, met `ba7a1fc` als top (*"Note tomorrow's second idea: ask players what
    they use"*). Dus een gewone `pull --rebase` + `push origin main`, en geen `HEAD:main`-truc meer
    nodig. 📌 Of de `forced update` van de afgelopen drie dagen daarmee ook verdwijnt, blijkt pas
    bij de push die ná dit blok komt; die uitkomst staat in het slotbericht van deze run en, als er
    iets bijzonders aan is, morgen hier.
- [2026-10-02] ✅ **Geen relevante API-wijzigingen.** Eén bronitem is écht nieuw sinds gisteren — de
  hotfixlijst van **1 okt** — maar die heeft geen UI-, Addon- of API-sectie. Alle zes de
  wiki-API-pagina's staan byte-voor-byte stil, en de acht forumposts in `#ui-macro` sinds 24 sep
  stonden alle acht al in dit logboek. **Geen enkel [MOET GEFIKST].**
  - 📰 **[RAAKT ONS NIET] — `Hotfixes: October 1, 2026` (news.blizzard.com, artikel `24296142`).**
    Volledig gelezen mét `?nocache=20261002`. De nieuwe 1-okt-sectie bevat drie regels: Druid/Feral
    (*"Fixed an issue that could cause Rampant Ferocity to trigger incorrectly against a single
    target"*), Hunter/Survival (*"Wildfire Bomb's periodic damage increased by 20%"*, met de
    developers' note dat de tuning van de week van 22 sep *"did not properly increase the periodic
    damage of an untalented variant"*) en The Venomous Abyss/Ula'tek (*"Fixed an issue where the
    Venomous Heart would sometimes melee a player"*). **Geen UI-, Addon- of API-sectie, en geen
    enkele API-naam** — class tuning en een raid-fix. Dat is terrein van `CONTENT_WATCH.md`, niet
    het mijne.
    ✅ **En dit is de correctie op gisteren, expliciet:** gisteren stond hier dat *"de 29-sep-lijst
    nog steeds de nieuwste"* was (`:3507`). Dat was toen waar; vandaag geeft **dezelfde article-ID**
    de titel *"Hotfixes: October 1, 2026"*. De lijst is dus vooruit gegaan, niet achteruit.
  - 🔇 **Wiki: vijf van de zes gevolgde pagina's byte-voor-byte onveranderd; alleen `Hotfixes`
    bewoog.** `Hotfixes` `6895406` → **`6897455`** (Dark T Zeratul, **2 okt 00:25:50Z**,
    365107 → **365799 b**, +692, comment `/* September 2026 */`). Dat is de 1-okt-lijst die ik
    hierboven al bij Blizzard zelf gelezen had — **inhoudelijk niets nieuws**. Onveranderd:
    `Patch 12.1.0/API changes` (`6886719`, Ketho, 25 sep, 102481 b), `Patch 12.1.5/API changes`
    (`6886717`, Ketho, 25 sep, 34466 b), `Patch 12.0.7/API changes` (`6794100`, Ketho, 4 aug,
    34044 b), `API change summaries` (`6883777`, Ketho, 22 sep, 7280 b), `TOC format` (`6889071`,
    Zeal, 26 sep 18:57:25Z, 27396 b — nu **129 uur** stil). 📌 De twee 12.1.x-API-pagina's staan
    sinds 25 sep stil; dat is vandaag precies de rand van het 7-dagenvenster en het stond al
    uitgeschreven in dit logboek, dus **geen nieuwe vondst**.
  - 🧩 **[RAAKT ONS NIET] — forumcategorie 35 (`#ui-macro`): acht posts sinds 24 sep, alle acht al
    bekend.** Gemeten met `search.json?q=#ui-macro after:2026-09-24`: topics `2367394`
    (*Unregister Global Mouse*, 30 sep), `2366363` (*Artwork end cap layers*, 29 sep), `1780831`
    (*account-wide to-do list*, 30 sep), `2306913` (*Cant make macros*, 28 sep), `2362999`
    (*WoW Forever Addons*, 26 sep), `2362846` (*Raid markers … WAY too big*, 26 sep), `1911888`
    (*ONLY show characters on a specific realm?*, 25 sep), `2349301` (*ChromaChat*, 24 sep).
    **Alle acht staan al in dit logboek** (geteld: 4/3/2/4/2/4/—/4 treffers op hun topic-ID), en
    `2367394` kreeg géén nieuwe reactie (`posts_count` 2, `last_posted_at` 30 sep 20:37:52Z).
    ✅ **Het `GLOBAL_MOUSE`-item van gisteren opnieuw gemeten en nog steeds nul:**
    `GLOBAL_MOUSE_DOWN` **0** bestanden, `GameEvent` **0**, `UnregisterInternalEvent` **0**
    (scope: hele addon zonder `.git`/`docs`/`tools`/`dist`). Blijft [RAAKT ONS NIET].
  - 🧰 **SimC-addon: geen nieuwe release sinds `12.1.0-04` (21 aug 2026).** Hele releaselijst
    opgehaald mét cache-buster; na `12.1.0-04` staat er niets. En dat is exact de release die
    `Modules/SimcExport.lua:12-16` in zijn kopcommentaar zegt te volgen (*"read 30 Sep 2026 at
    release 12.1.0-04"*). **MH loopt niet achter; er is niets te porten**, dus geen toets aan
    `ItemString` (`Modules/SimcExport.lua:234`) of `ns.BuildSimcProfile` (`:424`) nodig deze run.
  - 🧹 **Veegactie `Patch 12*` (ns 0): 25 pagina's, exact dezelfde lijst als de dagen ervoor.**
    `Patch 12.1.6` bestaat in geen enkele vorm; van de vier 12.2-titels (`Patch 12.2`, `12.2.0`,
    `12.2.5`, `12.2.7`) heeft er géén één een `/API changes`-subpagina — `Patch 12.2.0/API changes`
    geeft nog altijd `"missing":true`; en er is nog steeds geen `Patch 12.1.5 (undocumented
    changes)`, terwijl 12.0.0, 12.0.1, 12.0.5, 12.0.7 en 12.1.0 die alle vijf wél hebben.
  - 🔒 **Cache-val uitgesloten op beide domeinen, met eigen bewijs in deze run.** (a) Wiki:
    `list=recentchanges` (ns 0) loopt tot **vandaag 03:39:41Z** (*Commander Louis Philips*,
    Kaamara). (b) Forum: `posts.json` geeft als nieuwste post **vandaag 03:39:39Z** (`30297485`,
    topic `2359874`). Beide servers leveren vers materiaal.
    ⚠️ **En de omgekeerde controle:** niets wat ik vandaag als nieuwste zag is **ouder** dan wat dit
    logboek gisteren noemde — de hotfixtitel ging van *29 sep* naar *1 okt* en `Hotfixes` van
    `6895406` naar `6897455`; de vijf andere wikipagina's stonden stil op dezelfde revid's.
  - ✅ **Positieve controle, zelfde scope als mijn nul-beweringen** (verplicht, want een lege grep
    bewijst niets): `C_UnitAuras` **12** bestanden, `issecretvalue` **54**,
    `SecureActionButtonTemplate` **11** — alle drie niet-nul, dus het patroon en de scope werken.
  - ⚠️ **NIET GELEZEN, en dat is geen "niets gevonden":**
    - `warcraft.wiki.gg` en `us.forums.blizzard.com` via directe `curl` **niet bruikbaar**: de
      agent-proxy geeft `CONNECT tunnel failed, response 403` (gemeten deze run). Alle wiki- en
      forumdata komt daarom via `web_fetch_exa`.
    - De categoriepagina `c/guides/ui-macro/35.json` zelf gaf via Exa **alleen de `users`-array**
      binnen de tekenlimiet; de topiclijst komt daarom uit `search.json`, niet uit de categorie-JSON.
    - `wowhead.com/blue-tracker` opnieuw **niet geprobeerd** (zeven runs op rij lege body).
    - De 12.1.5-**PTR-buildnotes** niet opgehaald; terrein van `PTR_12.1_WATCH.md`.
  - 🔧 **Repo-staat: `HEAD` stond weer detached, nu hersteld.** Bij aanvang gaf
    `git rev-parse --abbrev-ref HEAD` **`HEAD`** in plaats van `main`, op commit `7f9369d` — maar
    **exact gelijk aan `origin/main`**, dus er was niets kwijt en de working tree was schoon
    (`git status --porcelain` leeg). Opgelost met `git checkout -B main origin/main`. 📌 Gisteren
    was de detached head juist weg; hij is dus **terug**, en de oorzaak zit niet in deze wachter.
    ✅ Geen van de vier wachter-bestanden stond gewijzigd-maar-ongecommit.
  - ⏳ **Nog open uit eerdere runs, NIET nieuw: de gemeten namespace-lijst in
    `docs/WATCHER_API_PROMPT.md` is van 18 aug en verouderd.** Die noemt `issecretvalue` 112× en
    `C_UnitAuras` 29×; vandaag **GEMETEN als occurrences** (`grep -rno`, zelfde scope):
    `issecretvalue` **198**, `InCombatLockdown` **201**, `C_UnitAuras` **83**, `CreateFrame` **741**,
    `C_Secrets` **27**, `C_SuperTrack` **29**. 🔴 **Ik raak dat bestand niet aan** — punt voor Rob,
    één `tools/_probe.py`-run volstaat.
    📌 **En de meetmethode staat er bewust bij** (occurrences, niet regels): dat verschil liet
    gisteren bijna een verzonnen regressie melden.
- [2026-10-03] 🧩 **Eén echt nieuw item op mijn terrein (26 sep–3 okt), en het is een antwoord in
  plaats van een vraag: de 12.1-migratie van `GLOBAL_MOUSE_DOWN`/`_UP` is nu BEVESTIGD werkend.
  0 × [MOET GEFIKST].** Alle zes de wiki-API-pagina's staan byte-voor-byte stil, de hotfixlijst
  staat nog op 1 okt, en SimC heeft geen nieuwe release. Twee nieuwe forumtopics van 2 okt zijn
  geen API.
  - 🧩 **[RAAKT ONS NIET] — `GameEvent.UnregisterInternalEvent("GLOBAL_MOUSE_DOWN")` WERKT; dit is
    de opvolging van mijn item van 1 okt (`:3475`), niet een herhaling ervan.** Topic `2367394`
    (*Unregister Global Mouse*, `#ui-macro`) ging van **2 naar 3 posts**; de nieuwe post is van
    **vandaag 03:05:47Z**. Post 2 (Fizzle) was een gok — letterlijk *"Haven't dug into it so just
    guessing. Try: `GameEvent.UnregisterInternalEvent("GLOBAL_MOUSE_DOWN")`"* — en post 3 is
    Elvenbane's uitkomst: *"Nevermind, that worked but how the game functions when it's
    unregistered has changed."*
    📌 **Wat hier feitelijk vaststaat** (en niet meer dan dat): het oude
    `UIParent:UnregisterEvent("GLOBAL_MOUSE_DOWN")` is in 12.1 vervangen door
    `GameEvent.UnregisterInternalEvent("GLOBAL_MOUSE_DOWN")`, gemeten door de melder zelf in de
    client. ⚠️ **Wat NIET vaststaat: wát er veranderd is aan het gedrag na unregisteren.** Hij
    zegt alleen dát het anders is, niet hoe. Ik verzin daar niets bij.
    ✅ **Toets aan de code — opnieuw gemeten, zelfde scope** (hele addon zonder
    `.git`/`docs`/`tools`/`dist`): `GLOBAL_MOUSE_DOWN` **0** bestanden, `GLOBAL_MOUSE_UP` **0**,
    `GameEvent` **0**, `UnregisterInternalEvent` **0**. **En de scherpere controle die ik 1 okt
    níét gedaan had:** de riskante vórm is niet de eventnaam maar het aanraken van `UIParent`'s
    eigen registratie, en ook die staat op nul — `UIParent:RegisterEvent` **0** treffers,
    `UIParent:UnregisterEvent` **0** treffers. MH unregistert uitsluitend op zijn **eigen** frames,
    en alleen deze acht events: `UNIT_AURA` (2×), `PLAYER_REGEN_ENABLED` (2×),
    `ITEM_DATA_LOAD_RESULT` (2×), `COMBAT_LOG_EVENT_UNFILTERED` (2×), `ADDON_LOADED` (2×),
    `UNIT_SPELLCAST_SUCCEEDED`, `UNIT_SPELLCAST_START`, `PLAYER_ENTERING_WORLD`. Geen enkele
    daarvan loopt via `GameEvent`. **Blijft [RAAKT ONS NIET], nu op twee manieren gemeten.**
  - 🧩 **[RAAKT ONS NIET] — topic `2370149` (*Forever beta: macro for warrior talents*, 2 okt
    20:02Z): `/cast Charge` pakt de verkeerde rang.** Melder gebruikt `[noknown:1310317]` en lost
    het op met `/cast Charge(Rank 1)`, met zijn eigen conclusie *"this is clearly a bug as it
    should only cast your highest rank learned"*. ⚠️ **Classic/«Forever»-beta, geen Retail**
    (melder zit op Grobbulus, `classic:true`), en rang-syntax bestaat niet in Retail. Toets:
    `noknown` **0** bestanden, `(Rank ` **1** treffer en die is een comment over obelisk-rangen
    (`Modules/RitualCoach.lua:19`), geen macrotekst. Positieve controle dat de scope klopt:
    `macrotext` **6** bestanden.
  - 🔇 **[RAAKT ONS NIET] — topic `2370136` (*RaiderIO app now has ads in it*, 2 okt 19:52Z).**
    Komt in de `#ui-macro`-zoekopdracht naar boven maar gaat over de **desktop-app** van RaiderIO,
    niet over de Lua-API of een addon. Geen API-naam in de post. Eén regel, klaar.
  - 🔇 **Wiki: alle zes gevolgde pagina's byte-voor-byte onveranderd sinds gisteren.** `Hotfixes`
    `6897455` (Dark T Zeratul, 2 okt 00:25:50Z, 365799 b), `Patch 12.1.0/API changes` `6886719`
    (Ketho, 25 sep, 102481 b), `Patch 12.1.5/API changes` `6886717` (Ketho, 25 sep, 34466 b),
    `Patch 12.0.7/API changes` `6794100` (Ketho, 4 aug, 34044 b), `API change summaries` `6883777`
    (Ketho, 22 sep, 7280 b), `TOC format` `6889071` (Zeal, 26 sep 18:57:25Z, 27396 b — nu **153
    uur** stil). 📌 **De twee 12.1.x-API-pagina's zijn vandaag 8 dagen stil en vallen dus BUITEN
    mijn 7-dagenvenster.** Dat is precies waarom ik ze hieronder niet als vondst opvoer.
  - 📰 **Hotfixes: niets nieuws, en dat is iets anders dan een cache.** `news.blizzard.com`
    artikel `24296142` geeft mét `?nocache=20261003` nog altijd de titel **`Hotfixes: October 1,
    2026`** met exact de drie regels die ik gisteren al volledig gelezen heb (Druid/Feral *Rampant
    Ferocity*, Hunter/Survival *Wildfire Bomb* +20%, The Venomous Abyss/Ula'tek *Venomous Heart*).
    ⚠️ **Dezelfde titel als gisteren is níét de cache-val** — die val is een titel die **ouder** is
    dan wat dit logboek al noemde. Hier is hij **gelijk**, en de wiki bevestigt het onafhankelijk:
    de `Hotfixes`-pagina staat op dezelfde revid `6897455` als gisteren. Twee bronnen die
    onafhankelijk zeggen "niets na 1 okt" is bewijs; één bron die hetzelfde zegt was dat niet.
  - 🧰 **SimC-addon: geen nieuwe release sinds `12.1.0-04` (21 aug 2026).** Hele releaselijst
    opgehaald mét cache-buster; na `12.1.0-04` staat er niets nieuwer. Dat is exact de release die
    `Modules/SimcExport.lua:12-16` in zijn kopcommentaar zegt te volgen (*"read 30 Sep 2026 at
    release 12.1.0-04"*, gemeten in het bestand deze run). **MH loopt niet achter**, dus geen toets
    aan `ItemString` (`Modules/SimcExport.lua:234`) of `ns.BuildSimcProfile` (`:424`) nodig.
  - 🧹 **Veegactie `Patch 12*` (ns 0): 25 pagina's, exact dezelfde lijst als gisteren.**
    `Patch 12.1.6` bestaat in geen enkele vorm; `Patch 12.1.7` bestaat wél als pagina maar heeft
    géén `/API changes`-subpagina; van de vier 12.2-titels (`Patch 12.2`, `12.2.0`, `12.2.5`,
    `12.2.7`) heeft er géén één een `/API changes`; en er is nog steeds geen `Patch 12.1.5
    (undocumented changes)`, terwijl 12.0.0, 12.0.1, 12.0.5, 12.0.7 en 12.1.0 die alle vijf wél
    hebben.
  - 🔎 **Twee WebSearch-rondes gedaan als onafhankelijke kruiscontrole, en ze leverden binnen het
    venster niets op.** Wat terugkwam (SetCooldown niet meer aanroepbaar vanuit tainted code als
    het cooldown-frame protected is, castbar-ID's uniek per unit token, `AuraContainer`/
    `AuraButton`, `UnitFrameUtil`, `roundLayoutToNearestPixel`, `math.clamp`/`round`/`lerp`) komt
    **allemaal van de `Patch 12.1.5/API changes`-pagina en is van 3 sep of eerder** — een maand
    oud. ⚠️ **Dat voer ik dus NIET op als vondst van vandaag.** Een magere dag aanvullen met oudere
    items is precies de fout die harde regel 2 verbiedt. Gelezen, gedateerd, afgelegd.
  - 🔒 **Cache-val uitgesloten op beide domeinen, met eigen bewijs in deze run.** (a) Wiki:
    `list=recentchanges` (ns 0) loopt tot **vandaag 03:34:33Z** (*Grand Apothecary Putress*, X59).
    (b) Forum: `posts.json` geeft als nieuwste post **vandaag 03:38:47Z** (`30313966`, topic
    `2370478`). ✅ **En het sterkste bewijs is de vondst zelf:** de nieuwe post in `2367394` is van
    **vandaag 03:05:47Z** — materiaal dat gisteren nog niet bestond, dus de server levert vers.
    ⚠️ **Omgekeerde controle:** niets wat ik vandaag als nieuwste zag is **ouder** dan wat dit
    logboek gisteren noemde. Hotfixtitel gelijk (1 okt), zes wiki-revid's gelijk, forumtopic
    `2367394` vooruit (2 → 3 posts).
  - ✅ **Positieve controle, zelfde scope als mijn nul-beweringen** (verplicht, want een lege grep
    bewijst niets): `C_UnitAuras` **12** bestanden, `issecretvalue` **54**,
    `SecureActionButtonTemplate` **11**, `UnregisterEvent` **10**, `RegisterEvent` **113**,
    `macrotext` **6** — alle zes niet-nul. 📌 **`UnregisterEvent` 10 is hier de belangrijkste**:
    hij bewijst dat het patroon waarmee ik `UIParent:UnregisterEvent` op **0** zette, in deze scope
    wél degelijk treffers kan vinden.
  - ⚠️ **NIET GELEZEN, en dat is geen "niets gevonden":**
    - `warcraft.wiki.gg` en `us.forums.blizzard.com` niet via directe `curl`: de agent-proxy
      weigert de CONNECT-tunnel (403). Alle wiki- en forumdata komt via `web_fetch_exa`.
    - De categoriepagina `c/guides/ui-macro/35.json` opnieuw niet bruikbaar binnen de tekenlimiet;
      de topiclijst komt uit `search.json?q=#ui-macro after:<datum>`.
    - `wowhead.com/blue-tracker` opnieuw **niet geprobeerd** (acht runs op rij lege body).
    - De 12.1.5-**PTR-buildnotes** niet opgehaald; terrein van `PTR_12.1_WATCH.md`.
    - ⚠️ De `?nocache=`-parameter geeft op `api.php` een `"Unrecognized parameter: nocache"`-warning.
      Dat is **onschadelijk** (MediaWiki negeert hem, de query draait gewoon) en hij doet zijn werk
      nog steeds, want hij maakt de URL uniek voor Exa's eigen cache. Vers materiaal is hierboven
      onafhankelijk aangetoond.
  - 🔧 **Repo-staat: `HEAD` stond voor de derde dag op rij detached, nu hersteld — en vandaag was
    hij ÁCHTER.** Bij aanvang gaf `git rev-parse --abbrev-ref HEAD` **`HEAD`** op commit
    `db61bf6`, terwijl `origin/main` nog op `ba7a1fc` stond; na `git fetch origin main` bleek
    `ba7a1fc..db61bf6` juist een **fast-forward van de remote** te zijn, dus `db61bf6` was het
    nieuwere en `git merge-base --is-ancestor db61bf6 origin/main` gaf YES. Er was dus niets kwijt,
    de working tree was schoon (`git status --porcelain` leeg) en `git checkout -B main origin/main`
    heeft het rechtgezet. 📌 **Drie dagen op rij detached (1, 2 en 3 okt) is geen incident meer maar
    een patroon van de omgeving, niet van deze wachter** — het staat hier zodat Rob het als zodanig
    kan zien. ✅ Geen van de vier wachter-bestanden stond gewijzigd-maar-ongecommit.
  - ⏳ **Nog open uit eerdere runs, NIET nieuw: de gemeten namespace-lijst in
    `docs/WATCHER_API_PROMPT.md` is van 18 aug en verouderd.** Die noemt `issecretvalue` 112× en
    `C_UnitAuras` 29×; vandaag **GEMETEN als occurrences** (`grep -rno`, zelfde scope, gelijk aan
    gisteren): `issecretvalue` **198**, `InCombatLockdown` **201**, `C_UnitAuras` **83**,
    `CreateFrame` **741**, `C_Secrets` **27**, `C_SuperTrack` **29**. 🔴 **Ik raak dat bestand niet
    aan** — punt voor Rob, één `tools/_probe.py`-run volstaat.
- [2026-10-04] 🧩 **Eén echt nieuw item op mijn terrein (27 sep–4 okt): de wikipagina `TOC format` —
  die ons manifest-formaat definieert — is vannacht grondig HERSCHREVEN. 0 × [MOET GEFIKST].** Vier
  regels uit die herschrijving zijn toetsbaar aan onze `.toc`; alle vier komen uit op [RAAKT ONS
  NIET]. De vijf andere gevolgde wikipagina's staan byte-voor-byte stil, de hotfixlijst staat nog op
  1 okt, en SimC heeft geen nieuwe release.
  - 🧩 **[RAAKT ONS NIET] — `TOC format` ging van revid `6889071` (26 sep 18:57:25Z, 27396 b) naar
    `6899537` (vandaag 03:22:38Z, 25788 b), in negen revisies van **Zeal** op 3 en 4 okt.** De
    laatste draagt als bewerkingssamenvatting letterlijk *"Copied in changes from User:P3lim/TOC"*;
    de pagina is herordend (secties `Rules`, `Naming`, `Conditional directives`, `TOC variables`
    opnieuw ingedeeld) en netto 1608 bytes korter.
    🔴 **DIT IS EEN DOCUMENTATIE-HERSCHRIJVING, GEEN GEMETEN CLIENT-WIJZIGING, en ik voer het ook
    niet op als zoiets.** Nergens in de nieuwe tekst staat dat gedrag in 12.1.x veranderd is; de
    enige versie-annotaties in de nieuwe conditie-tabel zijn historisch — *"Added for files in
    11.1.5. Added for metadata in 12.0.7"* — en dus van ruim vóór mijn venster. Wat er wél is: de
    pagina bevat nu vier regels die je hard aan een `.toc` kunt houden, en die heb ik alle vier
    gemeten.
    ⚠️ **Wat ik NIET weet: of die regels nieuw zijn in de CLIENT of alleen nieuw op de PAGINA.** De
    diff bewijst uitsluitend het tweede. Ik verzin daar geen client-wijziging bij.
    - **(a) De 1024-tekenregel.** Nieuw op de pagina: *"The game reads up to the first 1024
      characters of each line only."* met daaronder *"Any additional characters are silently
      ignored."* → **GEMETEN in `MidnightHelper.toc`:** de langste regel is **171 tekens** (regel 8,
      `## Notes-frFR`), daarna 169 (regel 11, `## Notes-itIT`) en 157 (regel 10). Ruim een factor
      vijf onder de grens, en het gevaarlijke woord hier is *silently* — dit is precies het soort
      fout dat geen foutmelding geeft. **Niets te doen.**
    - **(b) De aangescherpte waarschuwing bij `[AllowLoadGameType ...]`** (revid `6899326`, 3 okt
      23:10:51Z, samenvatting *"Changed allowloadgametype unrecognised behaviour description to
      match warning for non-conditional directive"*): *"If at least 1 game type is specified and
      none of the game types in the condition are recognized by the client, the condition will be
      satisfied. For this reason, you should additionally use `[ExcludeLoadGameType ...]` to exclude
      game types that are not universally recognized yet."* → **GEMETEN:** `MidnightHelper.toc`
      bevat **nul** conditional directives — geen `AllowLoad`, `AllowLoadGameType`,
      `ExcludeLoadGameType`, `LoadIntoEnvironment` of `Bootstrap`. Sterker: het bestand bevat **nul
      rechte haken** in zijn geheel.
    - **(c) De `[Game]`-TOC-variabele kreeg een voorbehoud bij `Camelot`** (revid `6899282`, 3 okt
      22:12:57Z, samenvatting *"Added note about camelot change"*): de voetnoot zegt *"The Camelot
      variable may change before launch."* → **GEMETEN:** MH gebruikt **geen enkele** TOC-variabele
      (`[Game]`, `[Build]`, `[TextLocale]`, `[Flavor]`, `[Expansion]`: alle nul). ⚠️ Dit is
      bovendien WoW *Forever*-terrein, niet Retail.
    - **(d) Client-specifieke TOC-bestanden met familie-suffixen** zijn opnieuw beschreven, inclusief
      de voorrangsregel dat `AddOnName_Standard.toc` wint van `AddOnName_Mainline.toc`, plus de
      nieuwe aanbeveling *"Comma-delimited interface versions or conditional directives should be
      preferred over the use of game type specific TOC files where possible."* → **GEMETEN:** de
      repo bevat **precies één** `.toc` (`MidnightHelper.toc`), zonder suffix — en MH doet al wat
      daar wordt aanbevolen, namelijk komma-gescheiden interface-versies.
  - 📌 **Terzijde, GEMETEN terwijl ik toch in dat bestand zat, en NADRUKKELIJK géén actiepunt:**
    `MidnightHelper.toc` begint met een UTF-8 **BOM**. De eerste acht bytes zijn
    `ef bb bf 23 23 20 49 6e`, dus op schijf staat er `<BOM>## Interface: 120007, 120100, 120105`.
    ⚠️ **Dat hij onschadelijk is, is AFGELEID en niet GEMETEN:** MH draait live op 4.5.0 en zou als
    *out of date* in de addonlijst verschijnen als de client die regel niet las, maar ik heb het niet
    in een client getest en de nieuwe wikitekst zegt er niets over (hij noemt alleen *whitespace*
    vóór `#`). **Niet aanraken op mijn gezag** — ik meld het omdat het er staat, niet omdat het stuk
    is.
  - 📌 **En een stille afwijking in `CLAUDE.md` zelf, GEMETEN vandaag:** daar staat dat de `.toc`
    *"`## Interface: 120007, 120100`"* declareert, maar het bestand zegt inmiddels
    **`120007, 120100, 120105`** — er is een derde versie (12.1.5) bij gekomen. 🔴 **Ik raak dat
    bestand niet aan**; punt voor Rob, één regel werk.
  - 🔇 **[RAAKT ONS NIET] — één forumpost binnen het venster die nog niet in dit logboek stond:
    topic `2276297` (*Changing an item icon*), post 2 van helojumper, 3 okt 17:06:27Z.** De
    oorspronkelijke vraag is van 20 maart en valt buiten het venster; de nieuwe post is een klacht
    zonder enige API-inhoud: *"It is horrific, how many issues Blizzards creates that force you to
    use more addons to play their game. They could not even foresee using a different color for the
    icons."* Geen API-naam, niets te greppen.
    ✅ **De andere treffers van `#ui-macro` sinds 27 sep staan hier al in** — op topic-id
    gecontroleerd, niet op titel: `2367394` (9×), `2366363` (4×), `2306913` (3×), `1780831` (2×),
    plus `2370149` en `2370136` die ik gisteren zelf heb afgehandeld.
  - 🧰 **SimC-addon: geen nieuwe release sinds `12.1.0-04` (21 aug 2026).** De hele releaselijst mét
    cache-buster opgehaald; bovenaan staat `12.1.0-04`, daaronder `12.1.0-03` (20 aug). **GEMETEN in
    de code deze run, niet geciteerd uit mijn eigen aantekening:** `Modules/SimcExport.lua:12-16`
    zegt in het kopcommentaar *"read 30 Sep 2026 at release 12.1.0-04"*. **MH loopt dus niet
    achter**, en een toets aan `ItemString` (`Modules/SimcExport.lua:234`) of `ns.BuildSimcProfile`
    (`Modules/SimcExport.lua:424`) is deze week niet nodig.
  - 📰 **Hotfixes: niets na 1 okt, en dat is op twee ONAFHANKELIJKE manieren vastgesteld.**
    `news.blizzard.com` artikel `24296142` geeft mét `?nocache=20261004` nog altijd de titel
    **`Hotfixes: October 1, 2026`**, met exact de drie regels die ik eerder al volledig gelezen heb
    (Druid/Feral *Rampant Ferocity*, Hunter/Survival *Wildfire Bomb* +20%, The Venomous Abyss /
    Ula'tek *Venomous Heart*). Daarnaast staat de wikipagina `Hotfixes` nog op dezelfde revid
    `6897455`. ⚠️ **Een gelijke titel is niet de cache-val** — die val is een titel die *ouder* is
    dan wat dit logboek al noemde. Twee bronnen die onafhankelijk "niets na 1 okt" zeggen is bewijs;
    één bron die dat zegt was dat niet.
  - 🔇 **Wiki: vijf van de zes gevolgde pagina's byte-voor-byte onveranderd.** `Hotfixes` `6897455`
    (Dark T Zeratul, 2 okt 00:25:50Z, 365799 b), `Patch 12.1.0/API changes` `6886719` (Ketho, 25 sep
    01:45:50Z, 102481 b), `Patch 12.1.5/API changes` `6886717` (Ketho, 25 sep 01:45:29Z, 34466 b),
    `Patch 12.0.7/API changes` `6794100` (Ketho, 4 aug, 34044 b), `API change summaries` `6883777`
    (Ketho, 22 sep, 7280 b). 📌 **De twee 12.1.x-API-pagina's zijn vandaag negen dagen stil en vallen
    dus BUITEN mijn 7-dagenvenster** — daarom voer ik ze niet als vondst op.
  - 🔎 **Eén WebSearch-ronde als onafhankelijke kruiscontrole, en die leverde binnen het venster
    niets op.** Wat terugkwam (aura's niet meer direct leesbaar in 12.1, secret values bij cooldown-
    en unitdata, taint-cascades bij `SecureHandlerStateTemplate`-actionbars, de nieuwe
    `UnitFrameUtil`-library met `UpdateUnitPvPIndicator`) staat allemaal op `Patch 12.1.5/API
    changes` en is van 3 sep of eerder — een maand oud. Het enige forumtopic dat bovenkwam,
    `2333938`, is eveneens oud. ⚠️ **Dat voer ik dus NIET op als vondst van vandaag**; harde regel 2
    verbiedt een magere dag aanvullen met oudere items. Gelezen, gedateerd, afgelegd.
  - 🔒 **Cache-val uitgesloten op beide domeinen, met eigen bewijs in deze run.** (a) Wiki:
    `list=recentchanges` (ns 0) loopt tot **vandaag 03:35:31Z** (*Conversing With the Depths*,
    SirWeltschmerz). (b) Forum: `posts.json` geeft als nieuwste post **vandaag 03:38:56Z**
    (`30325899`, topic `2371628`). ✅ **En het sterkste bewijs is de vondst zelf:** revisie `6899537`
    van `TOC format` is van **vandaag 03:22:38Z** — materiaal dat gisteren nog niet bestond, dus de
    server levert vers. ⚠️ **Omgekeerde controle:** niets wat ik vandaag als nieuwste zag is *ouder*
    dan wat dit logboek gisteren noemde — hotfixtitel gelijk (1 okt), vijf wiki-revid's gelijk,
    `TOC format` vooruit (`6889071` → `6899537`), forum vooruit (`30313966` → `30325899`).
  - ✅ **Positieve controle, zelfde scope als mijn nul-beweringen** (verplicht, want een lege grep
    bewijst niets). Mijn nullen gaan hier over één bestand, `MidnightHelper.toc`, dus daar meet ik
    ook de controle: `## Interface:` **1** treffer, `## `-directives **18**, opgesomde bestanden
    **279** waarvan **0** ontbreken op schijf. En de haakjes-grep die (b) en (c) op nul zette vindt
    er **11** in `Modules/NativeArrow.lua` — het patroon kán dus treffers vinden.
    🔴 **En ik ben er deze run zelf één keer ingelopen, wat precies bewijst waarom deze stap
    bestaat:** `grep -c "^## Interface" MidnightHelper.toc` gaf **0**. Niet omdat de regel ontbreekt,
    maar omdat de BOM tussen regelbegin en `##` staat. Zonder positieve controle had hier gestaan dat
    MH geen `## Interface` declareert.
  - ⚠️ **NIET GELEZEN, en dat is geen "niets gevonden":**
    - `warcraft.wiki.gg` en `us.forums.blizzard.com` **niet via directe `curl` geprobeerd** deze run;
      ik ben meteen op `web_fetch_exa` ingestoken op grond van de meting van eerdere runs (agent-proxy
      weigert de CONNECT-tunnel met 403). Alle wiki- en forumdata komt dus via Exa.
    - De categoriepagina `c/guides/ui-macro/35.json` opnieuw niet geprobeerd; de topiclijst komt uit
      `search.json?q=#ui-macro after:2026-09-27`.
    - `wowhead.com/blue-tracker` opnieuw **niet geprobeerd** (negen runs op rij lege body).
    - De 12.1.5-**PTR-buildnotes** niet opgehaald; terrein van `PTR_12.1_WATCH.md`.
    - De volledige nieuwe tekst van `TOC format` is **niet integraal** gelezen: ik heb de diff
      `6889071` → `6899537` gelezen plus twee losse revisie-diffs. Een regel die in beide versies
      identiek staat maar die ik nooit eerder toetste, zou ik zo kunnen missen.
    - ⚠️ De `?nocache=`-parameter geeft op `api.php` een `"Unrecognized parameter: nocache"`-warning.
      Onschadelijk (MediaWiki negeert hem, de query draait), en hij doet zijn werk nog steeds omdat
      hij de URL uniek maakt voor Exa's eigen cache. Vers materiaal is hierboven onafhankelijk
      aangetoond.
  - 🔧 **Repo-staat: `HEAD` stond voor de VIERDE dag op rij detached, nu hersteld — en de "forced
    update" bij het fetchen was vals alarm, wat ik hier expliciet neerzet zodat niemand er morgen
    van schrikt.** Bij aanvang: `git rev-parse --abbrev-ref HEAD` gaf **`HEAD`** op `0f39f26`,
    `git status --porcelain` leeg, geen van de vier wachter-bestanden gewijzigd-maar-ongecommit.
    `git fetch origin main` meldde **`+ ba7a1fc...0f39f26 main (forced update)`**, en daarna gaf
    `git merge-base ba7a1fc origin/main` **niets** terwijl beide kanten precies **50** commits
    toonden — wat eruitziet als een herschreven `main` waar 50 commits (inclusief *Release 4.3.0*)
    uit verdwenen zijn. 🔴 **Dat is het NIET.** GEMETEN: `.git/shallow` bestaat, met 2 grafts — dit
    is een **shallow clone van diepte 50**, en "50 commits aan beide kanten zonder merge-base" is
    exact wat een afgekapte historie oplevert. `ba7a1fc` is via de GitHub-API opgevraagd en bestaat
    gewoon (Rob, 30 sep 21:38:32Z, *"Note tomorrow's second idea"*), en de `.toc` staat inmiddels op
    **4.5.0** — dus `main` is normaal vooruitgelopen en er is niets kwijt. `git checkout -B main
    origin/main` heeft de detached HEAD rechtgezet. 📌 **Vier dagen op rij detached is een patroon
    van de omgeving, niet van deze wachter.**
  - ⏳ **Nog open uit eerdere runs, NIET nieuw: de gemeten namespace-lijst in
    `docs/WATCHER_API_PROMPT.md` is van 18 aug en verouderd.** Die noemt `issecretvalue` 112× en
    `C_UnitAuras` 29×; vandaag **GEMETEN als occurrences** (`grep -rno`, hele addon zonder
    `.git`/`docs`/`tools`/`dist`): `issecretvalue` **196**, `InCombatLockdown` **198**, `C_UnitAuras`
    **83**, `CreateFrame` **741**, `C_Secrets` **26**, `C_SuperTrack` **29**. 🔴 **Ik raak dat bestand
    niet aan** — punt voor Rob, één `tools/_probe.py`-run volstaat.
    📌 **Drie van die zes zijn sinds gisteren GEDAALD** (`issecretvalue` 198 → 196, `InCombatLockdown`
    201 → 198, `C_Secrets` 27 → 26) door Robs commits van 3 okt. Dat is geen bevinding, maar wel het
    bewijs dat deze getallen elke run opnieuw gemeten horen te worden in plaats van overgeschreven
    uit de regel van gisteren — wat ik vandaag bijna deed.
- [2026-10-05] 🧩 **Eén echt nieuw item op mijn terrein (28 sep–5 okt): `TOC format` is voor de
  TWEEDE nacht op rij herschreven, en deze keer zit er een expliciete CORRECTIE in — de regel die
  bepaalt wanneer een addon *out of date* heet. 0 × [MOET GEFIKST].** Vier toetsbare punten, alle
  vier [RAAKT ONS NIET]. De vijf andere gevolgde wikipagina's staan byte-voor-byte stil, de
  hotfixlijst staat nog op 1 okt, en SimC heeft geen nieuwe release.
  - 🔄 **[RAAKT ONS NIET] — CORRECTIE, en ik zet hem vooraan omdat harde regel 3 dat eist: de
    `Interface`-regel HEETTE EERST "lager dan de client" en IS NU "matcht de client niet".** Revid
    `6900516` (vandaag 04 okt 20:56:46Z), bewerkingssamenvatting letterlijk *"Corrected interface
    version matching behaviour"*. Letterlijk, uit `action=parse&section=6` van de huidige revisie
    (dus niet uit de diff, want die splitst woorden):
    - **oud:** *"If an addon has a lower interface version than the client's, or it doesn't specify
      this directive, the addon is classified as out of date."* — met daaronder een zichtbare
      HTML-commentaarregel `<!-- TODO: Test if lower only is strictly true, or if it's some other
      behaviour -->`.
    - **nieuw:** *"If an addon doesn't set an interface version that matches the client's, then it's
      classified as out-of-date."* — en die TODO is **weg**, dus de schrijver beschouwt het als
      uitgezocht.
    📌 **Het verschil dat telt:** de oude tekst liet ruimte voor "een hoger nummer is ook goed", de
    nieuwe zegt dat er een **exacte treffer** in de lijst moet staan.
    → **GEMETEN, beide kanten in dezelfde run:** `{{API LatestInterface}}` expandeert op de wiki naar
    **`120100`** (via `action=expandtemplates`; `{{API LatestVersion}}` geeft `12.1.0`), en
    `MidnightHelper.toc:1` declareert **`## Interface: 120007, 120100, 120105`**. `120100` zit er
    dus in → MH matcht → **niet** out of date. **Niets te doen.**
    ⚠️ **Wat dit wél betekent voor later, en het is een punt voor Rob en niet voor mij:** als "exact
    matchen" waar is, dan houdt het vooruit-gezette **`120105`** MH níét actueel op een volgende
    12.1.x-client — elk nieuw live interfacenummer moet er zelf bij. Dat is precies het soort fout
    dat *stil* is: de addon werkt, hij staat alleen rood in de addonlijst. 🔴 **Ik raak
    `docs/RELEASE_CHECKLIST.md` niet aan**; als dat ergens hoort te staan, is dat Robs beslissing.
    ⚠️ **En het blijft een WIKI-bewering, geen gemeten client-gedrag.** De samenvatting zegt
    *corrected*, maar niemand heeft hier een client getoond; de pagina citeert ook geen test. Ik
    verzin daar geen client-wijziging bij.
  - 🧩 **[RAAKT ONS NIET] — `AddonCompartmentFunc` kreeg een voorwaarde erbij** (revid `6900433`,
    4 okt 19:29:03Z, samenvatting *"Added condition for when it's required"*). Oud: *"This directive
    is '''required''' to show the addon in the addon compartment dropdown."* Nieuw: idem, maar met
    **`when using automatic registration`** erachter. → **GEMETEN:** `MidnightHelper.toc:14` zet
    `## AddonCompartmentFunc: MidnightHelper_OnAddonCompartmentClick`, en die global bestaat op
    `Modules/Broker.lua:16`. MH gebruikt dus precies de automatische weg die de directive vereist.
    **Niets te doen.**
  - 🧩 **[RAAKT ONS NIET] — de "mag meerdere keren"-regel is van één algemene zin uitgesplitst naar
    notes per directive** (revid `6900470`, 4 okt 19:51:24Z). De sectie-intro luidde *"If a directive
    is specified multiple times, the last one … will be used."* en luidt nu *"**Generally**, if a
    directive is specified multiple times, the last one … will be used. Directives that have
    exceptions to this rule are noted."* Die uitzondering staat nu bij `Dependencies`, `LoadWith`,
    `LoadManagers`, `AllowLoadGameType`, `ExcludeLoadGameType`, `SavedVariables` en
    `SavedVariablesPerCharacter`, telkens als *"This directive may be specified multiple times, with
    later instances appending to the list."* → **GEMETEN:** `MidnightHelper.toc` bevat **18**
    `##`-directives en **elk precies één keer** (geteld met `uniq -c`: alle achttien op 1). De enige
    directive uit dat rijtje die MH heeft is `SavedVariables`, op regel 13, één keer. Er valt dus
    niets te stapelen en niets te verliezen. **Niets te doen.**
  - 🧩 **[RAAKT ONS NIET] — conditional directives opnieuw: nu mét de claim dat álle actieve game
    types ze ondersteunen** (revid `6900068`, 4 okt 15:33:43Z, samenvatting *"Update patch changes -
    confirmed all active game types support all directives from 12.0.7 or newer"*), plus een nieuw
    voorbeeld `ForeverOnly.lua [AllowLoadGameType camelot][ExcludeLoadGameType standard, classic]`.
    → **GEMETEN, opnieuw vandaag en niet overgeschreven uit de regel van gisteren:**
    `MidnightHelper.toc` bevat **nul** conditional directives en **nul rechte haken** in zijn geheel.
    **Niets te doen.**
  - ⚠️ **Eén nieuwe wikiregel is KAPOT GESCHREVEN, en ik noteer dat zodat een volgende run er geen
    betekenis in zoekt.** Bij `AllowAddOnTableAccess` staat sinds `6900470`: *"If this is set to
    `1`, and further instances of it will be ignored."* Dat is geen zin — de oude tekst zei *"If
    this is set to `1` it cannot be turned off later in the file."* Vermoedelijk is er bij het
    opsplitsen een halve zin blijven staan. **GEMETEN:** MH gebruikt `AllowAddOnTableAccess` niet.
    [RAAKT ONS NIET], en de bewering zelf is onbruikbaar tot iemand hem repareert.
  - 📌 **Terzijde, GEMETEN maar NADRUKKELIJK géén bevinding van vandaag en géén actiepunt: MH heeft
    twéé wegen naar de addon compartment.** De nieuwe woorden *"when using automatic registration"*
    maken dat onderscheid voor het eerst expliciet, dus ik heb het nageslagen. Naast de directive
    bestaat de handmatige weg in `Libs/LibDBIcon-1.0.lua:637` (`lib:AddButtonToCompartment`), die
    afgaat als `db.showInCompartment` waar is (`LibDBIcon-1.0.lua:312`) — en dat zet LibDBIcon zélf,
    uit zijn eigen rechtsklikmenu (`LibDBIcon-1.0.lua:642`). **GEMETEN:** MH roept
    `AddButtonToCompartment` nérgens zelf aan (nul call-sites buiten `Libs/`), zet
    `showInCompartment` nergens, en registreert alleen `iconLib:Register(addonName, obj, db)` op
    `Modules/Broker.lua:455`.
    ⚠️ **Of een speler die dat vinkje aanzet dan twee regels in de compartment krijgt, is AFGELEID en
    NIET GEMETEN** — dat vergt een client, en ik heb er geen. Ik meld het omdat het bestaat, niet
    omdat het stuk is. Het is bovendien bestaand LibDBIcon-gedrag en niet iets dat deze week
    veranderd is.
  - 🔇 **[RAAKT ONS NIET] — één forumpost binnen het venster die nog niet in dit logboek stond:
    topic `1989252` (*Group lead badge missing from raid frames*), post 2 van Brytallica, 4 okt
    22:28:59Z.** Volledige inhoud: *"I have the same issue. Can't find a way to fix it without a
    mod."* De openingspost is van **21 okt 2024** (Nuck) en valt ruim buiten het venster; de nieuwe
    post bevat geen enkele API-naam en niets om te greppen.
    ✅ **De andere `#ui-macro`-treffers sinds 28 sep staan hier al in** — op topic-id gecontroleerd,
    niet op titel: `2276297`, `2367394`, `2366363`, `1780831`, `2370149`, `2370136`.
  - 🧰 **SimC-addon: geen nieuwe release sinds `12.1.0-04` (gepubliceerd 21 aug 2026 23:15:56Z).**
    Opgehaald via `api.github.com/repos/simulationcraft/simc-addon/releases` mét cache-buster;
    bovenaan `12.1.0-04`, daaronder `12.1.0-03` (20 aug). **GEMETEN in de code deze run:**
    `Modules/SimcExport.lua:12-16` zegt in het kopcommentaar *"read 30 Sep 2026 at release
    12.1.0-04"* — MH loopt dus niet achter, en een toets aan `ItemString` of `ns.BuildSimcProfile` is
    deze week niet nodig.
    📌 Terzijde: de **GitHub-MCP-tool weigert deze repo** (*"not configured for this session.
    Allowed repositories: huijting/midnighthelper"*), dus dit loopt noodzakelijk via Exa op de
    publieke API. Dat werkt; het staat hier zodat niemand morgen opnieuw op die muur loopt.
  - 📰 **Hotfixes: niets na 1 okt, op twee ONAFHANKELIJKE manieren vastgesteld.** `news.blizzard.com`
    artikel `24296142` geeft mét `?nocache=20261005` nog altijd de titel **`Hotfixes: October 1,
    2026`** met exact de drie al eerder gelezen regels (Druid/Feral *Rampant Ferocity*,
    Hunter/Survival *Wildfire Bomb* +20%, The Venomous Abyss / Ula'tek *Venomous Heart*); daarnaast
    staat de wikipagina `Hotfixes` nog op dezelfde revid `6897455` (Dark T Zeratul, 2 okt
    00:25:50Z, 365799 b). ⚠️ Een **gelijke** titel is niet de cache-val; die val is een titel die
    *ouder* is dan wat dit logboek al noemde.
  - 🔇 **Wiki: vijf van de zes gevolgde pagina's byte-voor-byte onveranderd t.o.v. gisteren.**
    `Patch 12.1.0/API changes` `6886719` (Ketho, 25 sep, 102481 b), `Patch 12.1.5/API changes`
    `6886717` (Ketho, 25 sep, 34466 b), `Patch 12.0.7/API changes` `6794100` (Ketho, 4 aug, 34044 b),
    `API change summaries` `6883777` (Ketho, 22 sep, 7280 b), `Hotfixes` `6897455`. 📌 **De twee
    12.1.x-API-pagina's zijn nu tien dagen stil en vallen dus BUITEN mijn 7-dagenvenster** — daarom
    voer ik ze niet als vondst op.
  - 🔎 **Eén WebSearch-ronde als onafhankelijke kruiscontrole, binnen het venster nul.** Wat
    terugkwam — Forbidden Aspects / `UntrustedScriptExecution`, AuraButtons die *forbidden* worden
    zodra aura's secret zijn, de nieuwe `AuraContainer`/`AuraButton`-widgets, en `SetCooldown`/`Clear`
    die in 12.1.5 niet meer vanuit tainted code mogen als het cooldown-frame protected is — staat
    allemaal op `Patch 12.1.0/API changes` of `Patch 12.1.5/API changes` en is van 3 sep of eerder.
    ⚠️ **Dat voer ik dus NIET op als vondst van vandaag**; harde regel 2 verbiedt een magere dag
    aanvullen met oudere items. Gelezen, gedateerd, afgelegd.
  - ⚠️ **NIET GELEZEN, en dat is geen "niets gevonden":**
    - `warcraft.wiki.gg` **wél via directe `curl` geprobeerd** deze run, anders dan de vorige keren:
      de agent-proxy weigert de CONNECT-tunnel met **403** (`curl: (56) CONNECT tunnel failed`).
      Daarmee is de aanname van eerdere runs nu gemeten in plaats van overgenomen. Alle wiki-, forum-
      en GitHub-data komt dus via Exa.
    - De categoriepagina `c/guides/ui-macro/35.json` opnieuw niet geprobeerd; de topiclijst komt uit
      `search.json?q=#ui-macro after:2026-09-28`.
    - `wowhead.com/blue-tracker` opnieuw **niet geprobeerd** (tien runs op rij lege body).
    - De 12.1.5-**PTR-buildnotes** niet opgehaald; terrein van `PTR_12.1_WATCH.md`.
    - De interfacenummers **per game type** uit de tabel in de `Interface`-sectie zijn niet
      opgelost: `action=expandtemplates` geeft op `{{LatestPatchInfo|interface=…}}` alleen de
      onverwerkte `#switch`-body terug. Voor Standard was dat niet nodig — `{{API LatestInterface}}`
      gaf rechtstreeks `120100` — maar voor Beta/Test heb ik dus géén nummer.
    - ⚠️ De `?nocache=`-parameter geeft op `api.php` een `"Unrecognized parameter: nocache"`-warning.
      Onschadelijk (MediaWiki negeert hem, de query draait) en hij doet zijn werk nog steeds omdat
      hij de URL uniek maakt voor Exa's eigen cache. Vers materiaal is hierboven onafhankelijk
      aangetoond: `TOC format` kwam met **zeventien** nieuwe revisies boven die gisteren nog niet
      bestonden.
  - ⏳ **Nog open uit eerdere runs, NIET nieuw — en alle drie met vandaag opnieuw gemeten cijfers:**
    - De namespace-lijst in `docs/WATCHER_API_PROMPT.md` is van 18 aug en verouderd. **GEMETEN
      vandaag** (`grep -rno`, hele addon zonder `.git`/`docs`/`tools`/`dist`): `issecretvalue`
      **196**, `InCombatLockdown` **198**, `C_UnitAuras` **83**, `CreateFrame` **741**, `C_Secrets`
      **26**, `C_SuperTrack` **29**. 📌 **Alle zes exact gelijk aan gisteren** — er is dus sinds Robs
      commits van 3 okt geen code bijgekomen die deze namen raakt. 🔴 Ik raak dat bestand niet aan.
    - `CLAUDE.md` zegt dat de `.toc` *"`## Interface: 120007, 120100`"* declareert; **GEMETEN** staat
      er `120007, 120100, 120105`. Dat punt is vandaag extra relevant geworden door de
      `Interface`-correctie hierboven. 🔴 Ik raak dat bestand niet aan.
    - `MidnightHelper.toc` begint met een UTF-8 **BOM** (`ef bb bf`). Onschadelijkheid blijft
      AFGELEID, niet gemeten.
  - 🔧 **Repo-staat: `HEAD` stond voor de VIJFDE dag op rij detached, nu hersteld — en de "forced
    update" was wéér vals alarm.** Bij aanvang `git rev-parse --abbrev-ref HEAD` → **`HEAD`** op
    `0f39f26`, `git status --porcelain` leeg, geen van de vier wachter-bestanden
    gewijzigd-maar-ongecommit. `git fetch origin main` meldde
    **`+ ba7a1fc...1a1d608 main (forced update)`**; `.git/shallow` bestaat, dus dat is de bekende
    afgekapte-historie-illusie van een shallow clone en niet een herschreven `main`.
    `git checkout -B main origin/main` heeft het rechtgezet. 📌 **Vijf dagen op rij is geen incident
    meer maar een eigenschap van de omgeving** — wie hier ooit iets automatiseert, moet er dus niet
    op rekenen dat de werkmap op een branch staat.
