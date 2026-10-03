# Naloop-lijst — hele addon nog één keer nalopen (opgesteld 2 okt 2026)

Rob wil alles wat verouderd of fout kan zijn nog een keer laten nalopen. Hieronder alle onderdelen met feiten, in
volgorde van belang voor de speler. **Rob kiest** wat er gebeurt en in welke volgorde.

## Meetbasis (2 okt, Robs plan-meter)

| ronde | wat | sessie | week | Fable-pot |
|---|---|---|---|---|
| raid, Opus xhigh | 17 bazen, 3,46M tokens | +28% | +3% | — |
| dungeons, Fable xhigh | 5 dungeons = 17 bazen, ±1,2M tokens | +45% | +5% | +11% |

GEMETEN: dezelfde 17 bazen kostten op **Fable meer** dan op Opus: ±2,6% sessie per baas tegen ±1,65%, en Fable
raakt de week óók. AFGELEID: voor een naloopronde is **Opus xhigh goedkoper**; Fable is alleen nuttig als Opus' week
op is. Voorbehoud: de meter telt alle chats samen; er kunnen andere chats tegelijk gelopen hebben.

Schattingen hieronder: **1 baas of 1 vergelijkbaar onderdeel op Opus xhigh ≈ 1,65% sessie** (AFGELEID uit de
raid-ronde). Een sessie is 100%, dus ±60 eenheden per sessievenster als je niets anders doet.

## De lijst (belangrijkste eerst)

| # | onderdeel | waar | waarom het kan schuiven | helpers | sessie (Opus) |
|---|---|---|---|---|---|
| 1 | **Valuta & crests** (crest cap 20 okt!) | `DawncrestData.lua`, `DawncrestGuide.lua`, `CurrencyGuide.lua`, Codex-valuta | caps veranderen per week/seizoensfase; 20 okt cap-wijziging | 1 | ±3% |
| 2 | **Great Vault-advies** | `VaultAdvisor*.lua`, `VaultReminder.lua` | ilvl-tracks en sloteisen per seizoen | 1 | ±3% |
| 3 | **Delves (14) + Valeera** | `DelveTips.lua`, `DelveTipsData.lua`, `DelveCurios*.lua`, `ValeeraProgress.lua` | 12.1 veranderde bazen, curios en tiers | 4 (3-4 delves elk) + 1 Valeera | ±25% |
| 4 | **8 overige dungeons** (29 bazen) | `DungeonTips.lua` | journal 12.1 (zie Nalorakk: 12.0-tekst) | 8 (1 per dungeon) | ±48% |
| 5 | **Ritual-bazen (3)** | `RitualTips.lua`, `RitualCoachData.lua` | nog nooit op xhigh | 1 | ±5% |
| 6 | **Gidsen / Codex (±38 hoofdstukken)** | `Codex.lua`, `MidnightCodexData.lua`, `StartHere.lua` | seizoensfeiten, oude 12.0.7-hoofdstukken | 4 (±10 hoofdstukken elk) | ±10% |
| 7 | **40 speelkaarten** | `PlayCards.lua` + locale | talent/rotatie-wijzigingen per patch | 4 (10 specs elk) | ±15% |
| 8 | **Beroepencursus** | `ProfessionAcademy*.lua`, `ProfessionGuided*.lua`, `ProfessionsGuideData.lua` | KP-bronnen en recepten per seizoen | 2 | ±6% |
| 9 | **Achievements** | `AchievementsData.lua` | criteria-ID's, meta's van S2 | 1 | ±3% |
| 10 | **12.1.5-checklist** | `docs/PTR_12.1_WATCH.md` → wat MH raakt | komt nog; pas zinvol als de patchdatum vaststaat | 1 | ±3% |
| 11 | **Tier set, consumables, enchants** | `TierSetData.lua`, `ConsumablesWowheadData.lua`, `GearEnchantCheck.lua` | S2-items | 1 | ±3% |
| 12 | **Wereld: rares, events, world boss, showdowns, folio** | `Rares.lua`, `EventInfoData.lua`, `WorldBoss.lua`, `ShowdownsData.lua`, `OmniumFolioData.lua` | rotaties, tijden | 1 | ±3% |
| 13 | **Keybind-rollen (40 specs)** | `KeybindRoles_*.lua` | spell-ID's na talentwijzigingen (lint #20: 178 entries zonder id) | 2 | ±6% |

**Totaal alles:** ±31 helpers, ±130% sessie op Opus = ±2 sessievensters. AFGELEID, niet gemeten.

## Al gedaan (2 okt)

- Raid: 17 bazen, korte tips (ochtend). Lange tips: helpers lopen (middag).
- M+-dungeons S2: 8 van 8 nagelopen (5 erin enUS/nlNL; MR, KR, DN wachten op Robs ja + vertalingen).
- ✅ 3 okt: delves + Valeera (#3) en de 8 overige dungeons (#4, korte + lange tips, 7 talen).
- ✅ 3 okt middag: #1 valuta & crests en #2 Great Vault (teksten + code; 3 meetpunten op de TESTLIJST).
- ✅ 3 okt avond: #7 speelkaarten (alle 40 nu nagelopen), #9 achievements, #11 tier/consumables/enchants, #12 wereld.
  Open: #10 (12.1.5, komt 13/14 okt).
- ✅ 3 okt laat: #13 keybind-rollen — Rob koos **alleen "Stay alive"** (136 getagde rijen: 122 klopt, 6 fout, 8 onzeker,
  5 ontbreekt; gerepareerd). De rest van de keybind-rollen (Layout-tab) bewust niet nagelopen.
- ✅ 3 okt avond: #8 beroepencursus (21 teksten, 7 talen; Dundun-valuta, boekprijzen, wizard-weekly, routes).
  Meetpunten (currency-ids, weekvoortgang) open.
- ✅ 3 okt avond: #6 Codex (±45 hoofdstukken, 28 teksten, 7 talen; Howling Ridge). Alleen de 3 beroepen-HOOFDSTUKKEN;
  #8 beroepencursus nog open.
- ✅ 3 okt avond: #5 Ritual Sites (bazen + uitleg + code; 20 teksten, 7 talen). NB: de bestanden heten
  `Locales/RitualTips.lua`, `RitualCoachData.lua`, `RitualSites.lua`, `RitualBossCoach.lua`, `DaggerspineCoach.lua`.

## Voorstel volgorde (Rob kiest)

1. **Vóór 20 okt:** #1 valuta/crests en #2 Vault (klein, raakt iedere speler elke week).
2. **Daarna:** #3 delves + Valeera (de meest gebruikte coach).
3. **Dan:** #4 overige dungeons en #5 ritual.
4. **Rustig erbij:** #6-#13.
