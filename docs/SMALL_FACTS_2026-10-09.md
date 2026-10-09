# Kleine feiten, 9 okt 2026: Barkskin-cooldown en Earth Elemental / Primordial Bond

Onderzoek door mh-research (alleen lezen). Live build: **12.1.0.69933**. wago.tools is gelezen in het browservenster, met
`build=12.1.0.69933` in de URL. Wowhead toont zelf "LIVE 12.1.0". Alles is gelezen op 9 okt 2026.
GEMETEN = met eigen ogen gezien in de genoemde bron. AFGELEID = zelf beredeneerd.

## 1. Barkskin (22812)

| # | Bewering | Status | Bron |
|---|---|---|---|
| B1 | De basis-cooldown is **60 s** (`SpellCooldowns` rij 1385: RecoveryTime 60000, CategoryRecoveryTime 0). Op de PTR (12.1.5.70077) is dat hetzelfde. | GEMETEN | wago SpellCooldowns 12.1.0.69933 en 12.1.5.70077 |
| B2 | Wowhead (live) zegt ook "1 min cooldown". | GEMETEN | wowhead.com/spell=22812 |
| B3 | **Guardian krijgt 45 s.** De spec-passive *Guardian Druid* (137010) heeft effect 9: ADD_FLAT_MODIFIER, Cooldown (11), −15000 ms, class mask_1 = 262144. Barkskin heeft precies dat mask (SpellClassOptions: set 7, mask_1 262144). Wowhead noemt dit effect "Modifies Cooldown −15 seconds: Barkskin". | GEMETEN | wago SpellEffect ID 1013111 en SpellClassOptions 1768 (12.1.0.69933); wowhead spell=137010 |
| B4 | Het Guardian-talent **Survival of the Fittest** (203965) haalt er nog 12% af (ADD_PCT_MODIFIER, Cooldown, −12, zelfde mask). Het is een talent (TraitDefinition 108215); Wowhead zegt "Requires level 45 (Guardian)". | GEMETEN | wago SpellEffect 300978 en TraitDefinition (12.1.0.69933); wowhead spell=203965 |
| B5 | Met dat talent is de cooldown voor Guardian ongeveer 40 s: (60 − 15) × 0,88 = 39,6. Icy Veins schrijft voor Guardian "a 40-60s cooldown", en dat past daarbij. | AFGELEID (som). IV-citaat GEMETEN | IV Guardian Rotation 12.1, bijgewerkt 10 aug 2026 |
| B6 | **Resto heeft in PvE géén verlaging.** De nieuwe spec-passive *Restoration Druid* (1256995) raakt Barkskin alleen via MOD_FLAT_PVP_MULTIPLIER (aura 646, −10). Dat werkt alleen in PvP. Er is geen Cooldown-modifier. | GEMETEN | wago SpellEffect 1315889 (12.1.0.69933); wowhead spell=1256995 |
| B7 | Balance en Feral hebben ook geen cooldown-modifier. Wowhead "Modified by (22)" bij Barkskin noemt alleen Guardian Druid en Restoration Druid als spec-passive. Starfall staat er alleen in door een cast-while-moving-effect met mask −1 op alles. De andere talenten raken de duur of de sterkte, niet de cooldown: Improved Barkskin +4 s, Ursoc's Endurance +2 s, Oakskin en Reinforced Fur −10 extra DR, Ward of the Forest −40% duur. | GEMETEN | wowhead "Modified by" bij 22812; wago SpellEffect van 327993, 393611, 449191, 393618, 1250923 |
| B8 | Ik heb ook gezocht naar modifiers die via een spell label werken (aura 218/219 met Cooldown op Barkskins labels 21/16/292/930/1284). Die zijn er niet. Positieve controle: label 930 gaf wél 1 rij terug. Label 1284 gaf een lege body terug, en dat bewijst niets. | GEMETEN (behalve 1284) | wago SpellLabel en SpellEffect csv |
| B9 | Waar komt "45 s" in de audit van 17 sep vandaan? Het infovak van warcraft.wiki.gg zegt "45 sec cooldown" zonder spec erbij, met de regel "Hotfix (2023-04-10): Cooldown reduced to 45 seconds". De DB2 legt die 45 s alleen bij Guardian, via de spec-passive. | Wiki-tekst GEMETEN; dat de audit deze tekst gebruikte is AFGELEID | warcraft.wiki.gg/wiki/Barkskin |

**Advies:** Guardian (TANK_COOLDOWNS) = **45**, en dat klopt al. Resto (HEALER_DEFENSIVES) = **60**, dus daar staat nu een fout.
Balance en Feral (DPS_DEFENSIVES) = **60**, en dat klopt al.
- HEALER_DEFENSIVES komt echt op het scherm. `RoleAcademy.lua:607-612` toont "(45s)" achter Barkskin voor Resto. GEMETEN in de code.
- DPS_DEFENSIVES wordt nergens getoond (`RoleAcademy.lua:878-880`). GEMETEN.
- De kaart-tekst noemt geen getal. In `enUS.lua` staat Barkskin alleen in PLAYCARD_104_S3, als `{SPELL:22812}`, zonder seconden. GEMETEN met grep; dezelfde grep vond wel de Modules-regels, dus het patroon werkt.

## 2. Earth Elemental (198103) en Primordial Bond (1279819)

| # | Bewering | Status | Bron |
|---|---|---|---|
| E1 | Earth Elemental: cooldown **3 min** (RecoveryTime 180000), GCD 1,5 s, duur **30 s** (188616 / 198103 DurationIndex 9 = 30000 ms). | GEMETEN | wago SpellCooldowns 22785, SpellMisc, SpellDuration (12.1.0.69933); wowhead spell=198103 |
| E2 | De tooltip hangt af van het talent. **Zónder 1279819:** "to protect you and your allies, generating high threat and taunting enemies periodically". **Mét 1279819:** "to protect you, increasing your maximum health by $381755s1%". | GEMETEN | wago Spell 198103, Description_lang |
| E3 | **Wat Primordial Bond doet (1279819):** "Your Earth Elemental no longer taunts nearby enemies or generates threat and instead increases your maximum health by 15% while active." Het is een talent (TraitDefinition 132698) in de **class-boom**, dus voor alle drie de specs (Wowhead: "Talents Shaman"). | GEMETEN | wago Spell en TraitDefinition (12.1.0.69933); wowhead "Modified by" bij 198103 |
| E4 | De 15% is echt: 381755 heeft effect aura 133 (MOD_INCREASE_HEALTH_PERCENT) met waarde **15**. | GEMETEN | wago SpellEffect 1012791 |
| E5 | Geen enkel talent verkort de cooldown. De andere modifiers: Everlasting Elements (462867, Elemental) +20% duur, en Primal Elementalist (117013, Elemental) maakt hem sterker. Op Wowhead "Modified by (4)" staat verder alleen een oude Anima Power. | GEMETEN | wowhead "Modified by" bij 198103; wago Spell en SpellEffect 462867 |
| E6 | Zonder Bond taunt hij vijanden die **niet** op een tank-spec mikken (Wowhead Enh, bijgewerkt 12 aug 2026). Hij taunt **geen bazen** (IV Resto M+ Tips 12.1). | GEMETEN (de gidstekst) | Wowhead Enh Abilities/Talents; IV Resto M+ Tips |
| E7 | De gidsen noemen hem alleen een **persoonlijke defensive met Bond**. Method Ele Talents (bijgewerkt 1 sep 2026, onder "Defensive Talents"): met Primordial Bond +15% max health voor 30 s, maar dan taunt hij niet meer. IV Resto Healing Guide (2 sep 2026): "Astral Shift and Earth Elemental **with Primordial Bond** are good defensive options". IV Resto Rotation (10 aug 2026): zonder Bond is hij voor DPS of om de tank te ontlasten; Bond maakt er "a personal defensive" van. | GEMETEN | method.gg/guides/elemental-shaman/talents; icy-veins Resto Healing Guide en Rotation |
| E8 | Let op verouderde bronnen. IV Resto M+ Tips noemt nog "1 minute on a 5-minute cooldown", en IV Resto Spell List (12.0.7) noemt "a full minute". Allebei fout: in de DB2 is het 30 s en 3 min. | GEMETEN | zie E1 |
| E9 | **Antwoord:** ja. Alleen mét Primordial Bond is Earth Elemental een echte knop "vóór de hardste klap" (+15% max HP). Zonder Bond verlaagt hij geen schade. Hij is dan een taunt-pet voor gewone vijanden die niet op de tank zitten, en niet voor bazen. Dat is een noodknop als de tank sterft of als je solo speelt, maar geen "big one". | AFGELEID uit E2-E7 | — |

**Wat MH nu zegt**, allemaal GEMETEN in de code:
- `KeybindRoles_Shaman.lua:81-82`: `survival = "big", survivalOrder = 2`, voor 262/263/264. Er is geen `survivalRequires` en geen `survivalNote`. Het commentaar zegt "an emergency tank on a 3 min cooldown".
- Op de kaart wordt dat `SURVIVAL_STEP_BIG` (`enUS.lua:1596`): "a big one: press it just before the hardest hit you see coming". Dat staat bij **iedere** Shaman, met of zonder Bond. **Zonder Bond klopt het niet** (E9).
- Er is geen locale-tekst over Earth Elemental: grep op `198103|Earth Elemental` in `Locales/` geeft 0 treffers. Dezelfde grep vond wel de Modules-regels.
- Earth Elemental staat **niet** in HealerCooldowns, DpsToolkit of TankToolkit. GEMETEN.
- Het mechanisme om dit op te lossen bestaat al: `SurvivalPlan.lua:434-443` (`survivalRequires` + `IsPlayerSpell`). Mirror Image gebruikt het al (`KeybindRoles_Mage.lua:123`).

## Voorstel per bestand:regel

1. `Modules/HealerCooldowns.lua:243`
   oud: `[105] = { { id = 22812, cd = 45 } }, -- Resto Druid: Barkskin`
   nieuw: `[105] = { { id = 22812, cd = 60 } }, -- Resto Druid: Barkskin (60 s; the 45 s is Guardian's spec passive 137010 only, wago 12.1.0.69933, 9 Oct 2026)`
2. `Modules/HealerCooldowns.lua:109` (commentaar)
   oud: `... Divine Protection is 498, Barkskin 45 s.`
   nieuw: `... Divine Protection is 498. Barkskin: 60 s for Resto (9 Oct 2026: the 45 s from 17 Sep is Guardian-only).`
3. `Modules/TankToolkit.lua:120`: **waarde 45 blijft.** Alleen het commentaar aanvullen:
   `-- Barkskin: 60 s base - 15 s Guardian spec passive 137010 = 45; Survival of the Fittest 203965 -12% (~40 s)`
4. `Modules/TankToolkit.lua:102` (commentaar): `Barkskin is 45 s` → `Barkskin is 45 s for Guardian (60 base)`.
5. `Modules/DpsToolkit.lua:97-98`: **niets doen.** 60 klopt voor Balance en Feral.
6. `Modules/KeybindRoles_Druid.lua:104` (commentaar): `Barkskin is a small 45 s button` → `Barkskin is a small button (60 s; 45 s for Guardian)`.
   `:243` (commentaar): `card: 8 s on 45 s` → `card: 8 s on 60 s (45 s Guardian)`.
7. `Modules/KeybindRoles_Shaman.lua:82`: voeg toe `survivalRequires = 1279819`, dus
   `["Earth Elemental"] = { id = 198103, category = "defensive", priority = 4, specs = { 262, 263, 264 }, survival = "big", survivalOrder = 2, survivalRequires = 1279819 },`
   `:81` (commentaar): `Card: an emergency tank on a 3 min cooldown (WH-spell 198103)` →
   `Card: only WITH Primordial Bond 1279819 (+15% max health for 30 s, no taunt; wago 12.1.0.69933, Method/IV 12.1). Without it, it is a taunt pet for non-boss enemies, not damage reduction.`
   `:33` (commentaar): `big = Astral Shift, then Earth Elemental` → `big = Astral Shift, then Earth Elemental (only with Primordial Bond)`.
   - De sleutel (Z) en `specs` blijven zoals ze zijn. Alleen de kaartregel valt weg als je het talent niet hebt.
   - **Een andere keuze, voor Rob.** Laat hem zonder Bond tóch op de kaart staan, met een eigen zin ("taunts enemies that are not on your tank; not bosses"). Dat kan nu nog niet: `survivalNote` werkt per spec, niet per talent. Daar is nieuwe code voor nodig.
   - Te testen door Rob: zie je hem op de overlevingskaart van een Shaman mét en zonder Primordial Bond? Dat `IsPlayerSpell(1279819)` true geeft als je het talent hebt, is AFGELEID. Het is niet gemeten; bij Mirror Image is alleen het false-geval gemeten.
8. `Modules/KeybindingData.lua:256` (lage prio): `-- tooltip checken` → `-- 3 min / 30 s; taunt pet, or +15% max health with Primordial Bond 1279819 (wago 12.1.0.69933)`.
