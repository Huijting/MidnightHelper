# Onafhankelijke controle optie A — `Modules/ForeverQuestHint.lua` (18 nov 2026)

Gecontroleerd: de werkboom van `ForeverQuestHint.lua` zoals hij op 18 nov ~21:00 op schijf stond (nog niet gecommit),
plus `PickupUpgrade.lua`, `ForeverMainStats.lua`, `ForeverBlock.lua` (alleen `Known`/`KnownId`) en de locale-regels.
Niets in de repo gewijzigd. Regelnummers hieronder = die werkboom.

## Hoe ik gemeten heb

| Bron | Wat | Datum/build |
|---|---|---|
| Offline test `qh_check.lua` (van de bouwchat) | 18 gevallen, 0 mismatches | gedraaid 18 nov |
| Eigen test `qh_check2.lua` + `qh_check2.py` (scratchpad) | 36 gevallen tegen de repo-module: 16 bevindingen, 0 Lua-fouten | gedraaid 18 nov |
| Eigen gepatchte kopie `scratchpad/patched/Modules/ForeverQuestHint.lua` | alle reparaties hieronder toegepast en gedraaid: 34 van 36 goed (rest = bewust niet gepatcht) | gedraaid 18 nov |
| wago DB2 via `run gamedata` (`wowf`) | GlobalStrings (10 talen), SpellName, SkillLineAbility, SkillRaceClassInfo, SpellEffect, Talent | build 1.60.1.70959 |
| Blizzards eigen UI-bron van Forever: GitHub `Gethe/wow-ui-source`, branch `forever`, commit `3d8abb1` "1.60.1 (70959)" | API-documentatie + FrameXML (gedownload naar `scratchpad/wowui_forever/`, alleen gelezen) | 17 nov 2026 |
| Wowhead Forever tooltip-JSON | spells 674, 413031, 1300344, 768, 5487, 9634 | 18 nov 2026 |

Opnieuw draaien: `scratch qh_check2.py` (repo), `scratch qh_check2.py patched` (mijn kopie),
`scratch qh_check2.py patched qh_check.lua` (hun 18 gevallen tegen mijn kopie).

Let op: de offline test draait op de lokale `lua.exe` = Lua 5.4.6 (GEMETEN), niet op WoW's Lua 5.1. Mijn reparaties
gebruiken alleen wat 5.1 ook heeft (AFGELEID); Robs `/reload` blijft de echte syntaxcheck.

Niet te meten vanaf hier (geen client): of de wapentooltip in Forever echt de regel "(x damage per second)" als
`leftText` heeft, of `GetItemStats` de DPS-sleutel vult, en of de/fr/es/ru een decimale komma tonen. Zie "Test voor Rob".

Eerlijk gemeld: ik heb één keer `git status --short` gedraaid (alleen lezen). Dat mocht volgens mijn eigen regel niet.
Er is niets veranderd.

---

## FOUTEN (met bewijs)

### F1 — FOUT: schild of off-hand-ding "beter" dan je off-hand-WAPEN (dual wield)
- **Bewijs (GEMETEN, qh_check2 A1/A2):** Warrior met Dual Wield, 1H (dps 10) + 1H (dps 8). Schild zonder stats, 100 armor →
  `MH: +100 Armor over what you wear (more armor, no stat difference).` Je raakt je tweede wapen kwijt en MH noemt het beter.
- **Oorzaak:** `DeltaDps` (r. 364-375) geeft `nil` zodra het NIEUWE item geen DPS heeft. Dan telt DPS niet mee.
- **Dit bestond al vóór optie A**, maar "schilden/off-hand-dingen" hoorde bij de bedoeling, en het gat zit er nog.
- **Reparatie** `Modules/ForeverQuestHint.lua:364-375` (getest: A1/A2/E1 worden "silent", controles J1-J7 blijven goed):
```lua
local function DeltaDps(stats, worn, main)
	if not Physical(main) then
		return nil
	end
	local new = stats and stats.DPS
	local old = worn and worn.link and worn.dps or nil
	if not new then
		-- a shield or off-hand item in the place of a weapon (or a weapon whose DPS cannot be read): you lose that damage
		return old and -old or nil
	end
	if worn and worn.link then
		if not worn.dps then
			return nil
		end
		return new - worn.dps
	end
	return new
end
```
- Dezelfde reparatie dicht ook **R3** (nieuw wapen met onleesbare DPS werd op stats alleen "beter", qh_check2 E1).

### F2 — FOUT: reden zegt "no stat difference" terwijl er Stamina-verschil staat; en minder Stamina + 0,1 DPS = "beter"
- **Bewijs (GEMETEN, qh_check2 C1/C2):**
  - `MH: -2 Stamina, +1.0 damage per second over what you wear (more damage per second, no stat difference).`
  - `MH: +3 Stamina, +1.0 damage per second over what you wear (more damage per second, no stat difference).`
- **Oorzaak:** `Explain` r. 345-346 kiest `FQH_WHY_DPS` bij `ds == 0` ook als `dsta ~= 0`. En `IsBetter` r. 394-396 geeft
  `true` bij meer DPS zonder naar Stamina te kijken. De eigen kopregel zegt "with equal stats, more DPS is better".
  Minder Stamina + meer DPS is ook gemengd (AFGELEID uit Robs regel "gemengd = MH zwijgt"; hij noemde alleen stats hoger/DPS lager).
- **Reparatie 1** `ForeverQuestHint.lua:343-349` — de `elseif` weg (dan valt +Stamina in de bestaande zin "main stats for a …"):
```lua
	if row.ds == 0 and row.dsta == 0 then
		why = (row.ddps and row.ddps >= 0.05) and ns:L("FQH_WHY_DPS") or ns:L("FQH_WHY_ARMOR")
	else
		why = ns:L("FQH_WHY_MAIN_FMT"):format(ClassName(token))
	end
```
- **Reparatie 2** `ForeverQuestHint.lua:394-396`:
```lua
	if dd and dd > 0 then
		return row.dsta >= 0 -- more DPS but less Stamina = mixed too: silent
	end
```
- Getest: C1 → silent; C2 → `+3 Stamina, +1.0 damage per second … (main stats for a Paladin)`. Geen locale-wijziging nodig.

### F3 — FOUT: tweehander tegenover TWEE wapens telt je off-hand-wapen niet mee ("+4.0 damage per second" klopt niet)
- **Bewijs (GEMETEN, qh_check2 D1; ook hun eigen geval 17 "…same dps"):** je draagt 10 + 10 dps, tweehander 14 dps, stats gelijk →
  `MH: +4.0 damage per second over what you wear (more damage per second, no stat difference).`
- **Oorzaak:** `Sum` r. 267 zet `dps = a.dps` (alleen main hand). Bij leeg main hand + schild wordt `dps` nil en telt DPS helemaal niet (D2).
- Hoeveel een off-hand-wapen in Forever echt bijdraagt is NIET gemeten. Voorzichtig = volledig meetellen: dan zwijgt MH
  tenzij de tweehander beide samen verslaat.
- **Reparatie** `ForeverQuestHint.lua:267-268`:
```lua
	-- DPS of both hands together: an empty main hand does 0; a second weapon counts in full (how much an off-hand
	-- weapon really adds in Forever is not measured, so a two-hander is only called "more DPS" when it beats both).
	local dps
	if not a.link then
		dps = b.dps or 0
	elseif a.dps then
		dps = a.dps + (b.dps or 0)
	end
	return { s = a.s + b.s, sta = a.sta + b.sta, arm = a.arm + b.arm, dps = dps, stats = stats,
		link = a.link or b.link, slot = a.slot, equipLoc = a.equipLoc }
```
- ⚠️ Gevolg voor hun test: geval 17 ("hunter, 1H+1H worn: 2H agi9 vs both (agi8), same dps") wordt dan "silent".
  Dat is een keuze: verwachting aanpassen, of die tweehander > 20 dps geven.

### F4 — FOUT: questbeloning — van twee betere wapens kiest MH de eerste, niet die met meer DPS
- **Bewijs (GEMETEN, qh_check2 G1):** A = +1.0 dps, B = +5.0 dps, stats gelijk → `Take reward A …`.
- **Oorzaak:** de keuze van `best` in `Decide` (r. 439-440) kijkt naar ds/dsta/darm, niet naar ddps.
- **Reparatie:** nieuwe functie vóór `Decide` (r. 400) en r. 438-443 vervangen. Getest (G1 → B).
```lua
--- Is reward row a a better pick than row b? The same order as IsBetter: main stats, then DPS, Stamina, armor.
local function Outranks(a, b)
	if a.ds ~= b.ds then
		return a.ds > b.ds
	end
	local da, db = a.ddps or 0, b.ddps or 0
	if math.abs(da - db) >= 0.05 then
		return da > db
	end
	if a.dsta ~= b.dsta then
		return a.dsta > b.dsta
	end
	return a.darm > b.darm
end
```
```lua
			if IsBetter(row) and (not best or Outranks(row, best)) then
				best = row
			end
```
  (r. 444 `row.worn = worn` staat er dubbel; de tweede kan weg.)

### F5 — FOUT (tekst beweert iets dat niet is nagekeken): "None of these is better" terwijl één beloning geen oordeel kreeg
- **Bewijs (GEMETEN, qh_check2 G2):** Paladin met tweehander; beloningen: schild (+5 Strength) en een cloth robe →
  `None of these is better for you than what you wear. reward cloth robe sells for the most (900c).`
  Het schild kreeg `Worn() == nil` ("no fair comparison"), maar de zin zegt dat niets beter is en wijst naar verkopen.
- **Reparatie** `ForeverQuestHint.lua`: r. 410 `local rows, best, bestMoney, unsure = {}, nil, nil, false`; de `end` van het
  `if worn then`-blok (r. 445) krijgt een `elseif` ervoor; en vóór de verkoop-tak (r. 464) een nieuwe `if unsure`:
```lua
		elseif row.usable and SLOTS[equipLoc] and main then
			unsure, row.noCompare = true, true -- gear you can wear, but no fair comparison: MH has no verdict on it
		end
```
```lua
	if unsure then
		-- "None of these is better" would be a claim MH did not check for that reward: say nothing
		return nil, "a reward without a fair comparison (two-hander worn, or an off-hand weapon you cannot hold): no sell advice"
	end
```
- Getest: G2 → geen hint, reden zichtbaar via `/mh questhint`. Een echte upgrade ernaast wordt nog gewoon getoond.

---

## RISICO'S

### R1 — Dual wield met wapens zonder stats: "zwakste hand" is altijd de main hand (gemiste tip)
- **Bewijs (GEMETEN, B1):** Rogue, main hand dps 10, off-hand dps 5, nieuw 1H dps 8 → `not better (… dps -2.0)`. Het is +3 voor de off-hand.
- **Oorzaak:** r. 290-293 kiest de zwakste op stats/Stamina/armor. Zonder stats is alles gelijk → main hand. Geen fout advies, wel stil.
- **Reparatie** `ForeverQuestHint.lua:290-293` (getest):
```lua
		local weaker = mh
		if oh.s < mh.s or (oh.s == mh.s and (oh.sta < mh.sta or (oh.sta == mh.sta and (oh.arm < mh.arm
			or (oh.arm == mh.arm and (oh.dps or 0) < (mh.dps or 0)))))) then
			weaker = oh -- same stats (most low-level weapons have none): the one with less DPS is the weaker
		end
```

### R2 — Dual wield + LEGE off-hand: een 1H wordt met je main hand vergeleken (bewuste keuze in hun test, wel inconsequent)
- **Bewijs (GEMETEN, B2 en hun geval 13):** Rogue met Dual Wield, off-hand leeg, 1H dps 8 → stil. Een off-hand-wapen
  (`INVTYPE_WEAPONOFFHAND`) in dezelfde situatie → wél "beter" (hun geval 14). Twee soorten wapen, twee antwoorden.
- **Voorstel (keuze voor Rob/bouwchat)** `ForeverQuestHint.lua:287-289` (getest; hun geval 13 wordt dan "better"):
```lua
		if not oh.link then
			return (mh.link and oh) or mh -- you can dual wield and that hand is empty: it fills the empty hand
		end
		if not OFFHAND_WEAPON[oh.equipLoc] then
			return mh -- a shield or an off-hand item: it would go in the main hand
		end
```

### R3 — DPS van het nieuwe wapen onleesbaar → DPS telt stil niet mee
- **Bewijs (GEMETEN, E1):** nieuw wapen zonder leesbare DPS-regel, +4 Strength, gedragen dps 10 → "better". Opgelost door F1.

### R4 — `CanDualWield` leunt op een omweg en op een verouderde functie
- **GEMETEN (Blizzard-bron 70959):** `IsPlayerSpell` bestaat in Forever alleen nog als noodalias in
  `Blizzard_DeprecatedSpellBook/Deprecated_SpellBook.lua:11`, achter `GetCVarBool("loadDeprecationFallbacks")`. De alias roept
  `C_SpellBook.IsSpellKnown(spellID, Player)` aan. `C_SpellBook.IsSpellKnown` en `FindSpellBookSlotForSpell` staan in
  `SpellBookDocumentation.lua` (r. 738, 73).
- **GEMETEN (MH-code):** `ns.ForeverKnownSpell` (`ForeverBlock.lua:113`) verwacht een Engelse NAAM. Met het getal 674 werkt hij
  alleen omdat `C_Spell.GetSpellInfo(674)` elk bestaand id teruggeeft; het antwoord komt dan volledig van
  `FindSpellBookSlotForSpell` ("staat Dual Wield zichtbaar in het spellbook").
- **Niet gemeten:** of Dual Wield zichtbaar in het Forever-spellbook staat, en of `loadDeprecationFallbacks` op Robs client aan
  staat (Config.wtf noemt de CVar niet). Staan beide verkeerd, dan kan geen enkele class "twee wapens", en zwijgt MH over elk off-hand-wapen
  (GEMETEN offline, K1).
- **Reparatie** `ForeverQuestHint.lua:241`, als eerste blok in `CanDualWield` (getest, K1/K2):
```lua
	-- the client's own answer first (C_SpellBook.IsSpellKnown: documented in Forever 1.60.1.70959)
	if C_SpellBook and C_SpellBook.IsSpellKnown then
		local ok, k = pcall(C_SpellBook.IsSpellKnown, DUAL_WIELD)
		if ok and k == true then
			return true
		end
	end
```
- **Bijvangst, zelfde oorzaak:** `ForeverBlock.lua:101` `ipairs({ IsPlayerSpell, IsSpellKnown })` stopt bij de eerste `nil`.
  Zonder de aliassen probeert `KnownId` dus niets (AFGELEID uit Lua-regels). Dat raakt `MainFor()` → `later.talent`
  (Champion of the Light, Careful Aim) op niet-Engelse clients. Zelfde middel: eerst `C_SpellBook.IsSpellKnown`.

### R5 — Er is een tweede "Dual Wield"-spell: 1300344
- **GEMETEN (DB2 70959):** `SpellEffect Effect=40` (Dual Wield) zit op 674 én 1300344. 413031 "Dual Wield" leert alleen 674 aan.
  Wie 1300344 krijgt is NIET gevonden (SkillLineAbility: geen rij, met 674 als positieve controle in dezelfde run; Talent
  `SpellRank_0`: geen rij, controle 13715 raakte wel).
- Voorstel: `local DUAL_WIELD = { 674, 1300344 }` en beide proberen. Valt nu veilig uit (stil), niet fout.

### R6 — Voor wie telt wapen-DPS? Hunter, Druid, ranged
- `Physical(main)` = Strength of Agility in de lijst. Dat is waar voor Hunter en Druid (kat).
- **Hunter (GEMETEN offline, I1):** tweehander +10 Agility, −5 melee-dps → stil. Een Hunter schiet (rol "ranged" in
  `ForeverMainStats.lua:106`); melee-dps is voor hem bijzaak. Gemiste tip, geen fout advies.
- **Druid in vorm:** of wapen-DPS in Cat/Bear Form meetelt in Forever is NIET gemeten (de tooltips van 768/5487/9634 zeggen er niets over).
  In Classic telt het niet (AFGELEID, niet voor Forever bewezen). Dan zou "meer DPS = beter" voor een kat niets betekenen.
- Voorstel (keuze, niet getest): DPS alleen laten tellen in de handen voor Warrior/Rogue/Paladin/Shaman, alleen in slot 18
  voor Hunter, en voor Druid niet tot het gemeten is.

### R7 — Getal lezen boven de 1000 dps
- **GEMETEN offline (F8/F9/F10):** "1.234,5" wordt 1,2345; "1 234,5" (Franse spatie) wordt niet gelezen.
  "12,5", "12.5" en "1,234.5" gaan goed (F1-F7, F12-F13).
- In Forever speelt dit pas bij wapens ≥ 1000 dps (AFGELEID: komt daar niet voor). Klein. **Reparatie** `ForeverQuestHint.lua:147-153` (getest):
```lua
					-- "12,5" / "12.5" / "1,234.5" / "1.234,5": the LAST separator, followed by one or two digits, is the
					-- decimal mark; every other separator is a thousands mark
					local int, frac = n:match("^(.*)[,%.](%d%d?)$")
					if int then
						n = int:gsub("[,%.]", "") .. "." .. frac
					else
						n = n:gsub("[,%.]", "")
					end
					return tonumber(n)
```

### R8 — Kosten per hover zijn ruim verdubbeld
- **GEMETEN offline (H1):** één ring = 8× `C_TooltipInfo.GetHyperlink` (nieuw item 2, main hand 2, twee ringslots 4).
  **GEMETEN (Blizzard-bron):** `GameTooltip_OnUpdate` roept `owner:UpdateTooltip()` op een timer aan, dus dit herhaalt zolang je hovert.
- **Reparatie (getest: 8 → 3):** DPS alleen lezen voor wapens, en het main-hand-wapen alleen ophalen voor hand-items.
```lua
local WEAPON_LOC = { INVTYPE_WEAPON = true, INVTYPE_2HWEAPON = true, INVTYPE_WEAPONMAINHAND = true,
	INVTYPE_WEAPONOFFHAND = true, INVTYPE_RANGED = true, INVTYPE_RANGEDRIGHT = true, INVTYPE_THROWN = true }
-- Stats(link, equipLoc):   out.DPS = WEAPON_LOC[equipLoc] and Dps(link, t) or nil
-- WornSlot: eerst  local _, _, loc = ItemInfo(link)  dan  Stats(link, loc)
-- Decide r. 431 en ForeverGearTipText r. 638:  Stats(link, equipLoc)
-- Worn r. 277-278:
	local first = SLOTS[equipLoc][1]
	local mh = (first == 16 or first == 17) and WornSlot(16, main, stamTie) or nil
	local twoHanderWorn = mh ~= nil and mh.equipLoc == "INVTYPE_2HWEAPON"
```

### R9 — `/mh questhint` laat DPS en "geen eerlijke vergelijking" niet zien
- **GEMETEN offline:** de regel per beloning print `gain=nil/nil/nil` voor het schild en nergens de DPS. De tooltip-kant (`/mh geartip`) doet het wel goed.
- **Reparatie** `ForeverQuestHint.lua:577-579` (getest):
```lua
		print(("  %d %s usable=%s slot=%s main=%s stam=%s armor=%s gain=%s/%s/%s dps=%s sells=%s%s"):format(r.i,
			r.link or r.name, tostring(r.usable), tostring(r.equipLoc), tostring(r.s), tostring(r.sta),
			tostring(r.stats and r.stats.ARMOR), tostring(r.ds), tostring(r.dsta), tostring(r.darm),
			r.ddps and ("%+.1f"):format(r.ddps) or "n/a", tostring(r.sell),
			r.noCompare and " NO FAIR COMPARISON (two-hander worn / no dual wield)" or ""))
```

### R10 — klein
- `ForeverQuestHint.lua:130`: `v > 0` staat vóór `issecretvalue(v)`. Vergelijken met een secret gooit een fout. Item-stats zijn niet secret (AFGELEID); volgorde omdraaien kost niets: `type(v) == "number" and not (issecretvalue and issecretvalue(v)) and v > 0`.
- De tooltipregel zegt "over what you wear" ook als het slot leeg is (bestond al; de quest-hint heeft `FQH_TAKE_EMPTY_FMT`).
- MH toont "+2.5" met een punt; de/fr/es/ru-clients tonen waarschijnlijk een komma (AFGELEID). Cosmetisch.

---

## Wat klopt (nagekeken)

**Logica per geval (GEMETEN offline, tenzij anders vermeld)**
- 1H terwijl je een tweehander draagt → vergeleken met de tweehander, niet met de lege off-hand. Goed.
- Class zonder Dual Wield → 1H alleen tegen main hand; off-hand-wapen → geen oordeel. Goed.
- Schild / off-hand-ding terwijl je een tweehander draagt → geen oordeel. Goed.
- `INVTYPE_WEAPONMAINHAND` → main hand. `INVTYPE_RANGED/RANGEDRIGHT/THROWN/RELIC` → slot 18. Ringen/trinkets → de zwakste van twee. Goed.
- Lege hand = 0 dps, "+15.0 damage per second". Goed.
- Caster (geen Strength/Agility in de lijst): DPS telt niet. Goed.
- Stats hoger + DPS lager = stil. Goed.

**Nil-paden en crashes**
- `Worn()` kan `nil` geven; alle drie de aanroepers vangen dat op: `Decide` (r. 429-430), `ns.ForeverGearTipText` (r. 634-637),
  `PickupUpgrade.lua:133-136` (krijgt `nil, why`). GEMETEN in de code.
- 36 + 18 offline gevallen, 0 Lua-fouten. De DPS-patronen bouwen zonder fout in alle 10 Forever-talen (zie onder).

**API's en globals in Forever (GEMETEN, Blizzard-bron 1.60.1.70959, tenzij anders vermeld)**
- `C_Item.GetItemStats` (ItemDocumentation.lua:1004, "MayReturnNothing" → de nil-check in `Stats` is nodig en staat er),
  `C_Item.GetItemInfo` (:626), `C_TooltipInfo.GetHyperlink` (TooltipInfoDocumentation.lua:337).
- `TooltipDataProcessor.AddTooltipPostCall` (Blizzard_SharedXMLGame/Tooltip/TooltipDataHandler.lua:199; in de .toc zonder voorwaarde geladen).
- `INVSLOT_MAINHAND/OFFHAND/RANGED` = 16/17/18 (Blizzard_FrameXMLBase/Constants.lua:151-153); `CharacterRangedSlot` bestaat (Camelot/PaperDollFrame.xml:868).
- `DPS_TEMPLATE` (GlobalStrings 12672) en `ITEM_MOD_DAMAGE_PER_SECOND_SHORT` (19881) bestaan — DB2 70959.
- `IsPlayerSpell`: alleen als noodalias (zie R4).

**Dual Wield per class en level (GEMETEN, DB2 70959)**
- Spell 674 "Dual Wield", skill 118. `SkillRaceClassInfo`: Rogue vanaf level 10; Warrior en Hunter vanaf 20; Shaman heeft een rij (level 0),
  hoe hij het krijgt is niet gevonden. MH's eigen `ForeverTrainerData.lua` zegt hetzelfde (10/20/20, id 674).
- Het komt van de trainer, dus "kent de speler de spell" is de juiste vraag (een levelcheck zou fout zijn).

**DPS-regel in andere talen (GEMETEN, GlobalStrings 70959)**

| Taal | DPS_TEMPLATE | ITEM_MOD_DAMAGE_PER_SECOND_SHORT |
|---|---|---|
| enUS | `(%s damage per second)` | damage per second |
| deDE | `(%s Schaden pro Sekunde)` | Schaden pro Sekunde |
| frFR | `(%s dégâts par seconde)` | dégâts par seconde |
| esES | `(%s daño por segundo)` | daño por segundo |
| esMX | `(%s p. de daño por segundo)` | daño por segundo |
| ptBR | `(%s de dano por segundo)` | dano por segundo |
| ruRU | `(%s ед. урона в секунду)` | к урону в секунду |
| koKR / zhCN / zhTW | `(초당 공격력 %s)` / `（每秒伤害%s）` / `（每秒傷害%s）` | — |
| itIT | Engels (Forever heeft geen Italiaanse tekst) | Engels |

Overal een gewone `%s`, nergens `%1$s`: het patroon in `Dps()` kan dus niet stuklopen. "12,5" en "12.5" worden beide goed gelezen (F1-F6).

**Teksten `FQH_WHY_DPS` (GEMETEN in de bestanden, clientwoord tegen de tabel hierboven)**
- enUS:5117, nlNL:4298, ruRU:6372, Translations2026 de:20527 / fr:20667 / es:20807 / pt:20947 — elk in het juiste `fill`-blok, één keer.
- Elk gebruikt het clientwoord voor "damage per second". nlNL houdt het Engels. esMX heeft geen eigen regel nodig (zelfde woord). Geen itIT nodig.
- De zin zelf is alleen onwaar in de gevallen van F2; met die code-reparatie hoeft er geen tekst te veranderen.

---

## Test voor Rob (wat de client moet bevestigen)
1. Strength/Agility-character, hover een wapen dat NIET beter is, dan `/mh geartip`. Verwacht: `not better (… dps -3.2)` met een getal.
   Staat er `dps n/a`, dan leest MH de DPS-regel niet (tooltipvorm of `GetItemStats` anders dan aangenomen).
2. Rogue of Warrior mét Dual Wield, off-hand-wapen in de tas: geen "no fair comparison" in `/mh geartip`.
   Staat dat er wel, dan herkent `CanDualWield` de spell niet (R4).
