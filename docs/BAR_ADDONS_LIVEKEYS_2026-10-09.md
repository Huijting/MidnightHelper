# LiveKeys voor Bartender4 en ElvUI — onderzoek 9 okt 2026 (mh-research)

Rob vroeg het na `/mh presses`: LiveKeys (`Modules/LiveKeys.lua`) leest alleen Blizzards eigen balken, dus spelers met
een balk-addon zien "not on a key". NIETS gebouwd; Rob kiest.

## Conclusie
**Kan met één kleine aanvulling in `CommandSlots()` (AFGELEID: ~30-50 regels).** Beide addons maken knoppen met
LibActionButton (LAB); elke LAB-knop zegt zelf welk binding-commando hij heeft en welke slot hij NU toont (ook na
pagina-wissel). Rob heeft geen van beide → testen alleen bij iemand die ze heeft (beta/Cisca).
GEMETEN: Bartender4 en ElvUI staan niet in `AddOns\` (positieve controle: DBM-Core wel gevonden). Broncode van GitHub,
vastgepind: Bartender4 `8339c74`, LAB `bc1da7a` (MINOR 168), ElvUI `e63dc05`.

## Bartender4
- **Toets:** bars 1,3,4,5,6,13,14,15 hergebruiken Blizzards namen (`ACTIONBUTTON%d`, `MULTIACTIONBAR1BUTTON%d` …;
  ActionBars.lua:105-114) en sturen die toets via `SetOverrideBindingClick` naar `BT4ButtonN` (r. 279-290).
  `GetBindingKey("ACTIONBUTTON1")` blijft dus werken. Bars 2 en 7-10: `CLICK BT4Button<n>:Keybind` (n 13-24, 73-120;
  Bindings_Mainline.xml). Handigst: `button:GetBindingAction()` (LAB:1841-1843). GEMETEN in broncode, niet in client.
- **Slot:** `btn._state_type == "action"` + `btn._state_action` (LAB:1913-1915), bijgewerkt bij pagina-wissel, ook in
  combat. Met een knop-offset klopt Blizzards vaste slot NIET meer.
- **Herkennen:** `_G.Bartender4`, `_G["BT4Button"..n]`; uitgezette bar: `bar.disabled` / `btn.header.disabled`.
- ⚠️ BT4 zet Blizzards knoppen stil (HideBlizzard.lua:29-40) → `ActionButton1:GetAttribute("action")`, waar MH nu de slot
  vandaan haalt, volgt de pagina waarschijnlijk niet meer (AFGELEID).

## ElvUI (ActionBars-module)
- **Toets:** bar1 `ACTIONBUTTON`, bar3/4/5/6 `MULTIACTIONBAR3/4/2/1BUTTON`, bar13-15 `MULTIACTIONBAR5/6/7BUTTON`,
  bar2 en 7-10 eigen namen `ELVUIBAR2BUTTON`, `ELVUIBAR7..10BUTTON` (ActionBars.lua:87-100). `button.keyBoundTarget`;
  `GetBindingKey(keyBoundTarget)` werkt (r. 632-642).
- **Slot:** zoals BT4 (`_state_type`/`_state_action`); in ElvUI's LAB-fork is `self.action` nil i.p.v. 0 (LAB-ElvUI:2202).
- **Herkennen:** `_G.ElvUI`, `ElvUI[1].private.actionbar.enable`, `E:GetModule("ActionBars").Initialized`; knoppen
  `ElvUI_Bar<id>Button<i>`. ⚠️ Eigen bibliotheeknaam `"LibActionButton-1.0-ElvUI"`: LibStub("LibActionButton-1.0") ziet ze niet.

## Valkuilen 12.x
- Alleen LEZEN (velden, GetAttribute, GetBindingAction). Nooit SetAttribute, bindings of hooks → geen taint.
- Secret: LAB behandelt alleen GetActionCount als secret; slots niet (AFGELEID). Houd de `issecretvalue`-guard (LiveKeys.lua:96).
- Lezen buiten combat volstaat (zoals nu).
- Gedeelde LAB-registry: ook knoppen van andere addons (CMC-flyouts); zonder toets vallen ze vanzelf af.
- Druïde-paging: alleen de huidige pagina, zoals nu bij Blizzard.

## Plan als Rob ja zegt
1. Lokale functie in LiveKeys.lua: doorloop `LibStub(m,true):GetAllButtons()` voor beide bibliotheeknamen; zet per knop
   `config.keyBoundTarget` én `"CLICK "..naam..":"..config.keyBoundClickButton` → `tonumber(_state_action)` (alleen
   `_state_type=="action"` en niet `header.disabled`); lege toestand claimt het commando met nil.
2. Aanroepen NA `ns.MH_CommandSlotMap()` (LAB wint). `ns.MH_CommandSlotMap` zelf NIET aanpassen (ApplyLayout,
   KeybindSchema, BarInventory gebruiken hem).
3. `/mh playkeys` noemt de bron (Blizzard / BT4 / ElvUI).
4. Open: een BT4-bar die bij het laden uit staat maar een Blizzard-binding heeft — waar gaat die toets heen? Niet gemeten.

## Meten in het spel (tester mét BT4 of ElvUI)
1. `/run local b=BT4Button13 local c=b and b:GetBindingAction() print(c, c and GetBindingKey(c), b and b._state_type, b and b._state_action, b and b:GetAttribute("action"))` (ElvUI: `ElvUI_Bar2Button1`)
2. `/run local a=GetBindingAction("1",true) local n=a:match("^CLICK (.-):") local f=n and _G[n] print(a, f and f._state_type, f and f._state_action, ActionButton1:GetAttribute("action"))` (druïde zonder vorm én in kattenvorm)
3. `/run for _,m in ipairs({"LibActionButton-1.0","LibActionButton-1.0-ElvUI"}) do local l=LibStub(m,true) local n=0 if l then for _ in pairs(l:GetAllButtons()) do n=n+1 end end print(m,l and n) end`
4. `/run C_Timer.After(5,function() local b=BT4Button1 or ElvUI_Bar1Button1 local s=b._state_action print(InCombatLockdown(), s, issecretvalue and issecretvalue(s), GetActionInfo(s)) end)`
5. `/run local E=ElvUI and ElvUI[1] print(E and E.private.actionbar.enable, E and E:GetModule("ActionBars").Initialized)`
