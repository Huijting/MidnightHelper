# PTR 12.0.7 — data nog te verzamelen (Rob, in-game)

## 🔴 RELEASE BEVESTIGD: 16 JUNI 2026 (Wowhead-news; web-check 11 juni)

→ Bij release: `120005` uit de TOC (zie RELEASE_CHECKLIST); Showdowns-code
activeert vanzelf via de ≥120007-gate.

## Web-research 11 juni (Wowhead news 381787 + gidsen) — nieuw bevestigd

- **HWT aanbevolen ilvl 274** + extra modifiers (o.a. rondzwervende elites);
  géén unlock-vereiste (bevestigt PTR-bevinding §6).
- **Flow:** Riftblade Maella (Silvermoon) start de questlijn → **portaal in
  Voidstorm, subzone Howling Reach** (Voidstorm uiMapID = **2405**, Zygor-
  zonetabel; exacte portaal-coords nog dumpen) → moeilijkheidskeuze
  Normal/Heroic bij het portaal.
- **Rotatie = wekelijks** ("Each area rotates weekly, available for one week
  at a time") → open punt §7 beantwoord; VoidAssaults-weekly-patroon
  herbruikbaar. ✅
- **Beloningen:** rares droppen "Lost Armaments" → Champion 1/6 (Normal) /
  Champion 4/6 (Heroic) warband-gear; world boss → Champion (N) / Hero (H)
  item; Showdown-weekly → Riftstalker's Cache (275690 ✓) + vault World-rij ✓.
- **Decimus** (nieuwe NPC): quest gekoppeld aan HWT-bosses → **Myth-track
  gear**. ⬜ Quest-ID dumpen op PTR/live.
- **Toy "Lightveil Recall Beacon"** — recall naar Umbral Base Camp, 15 min
  CD, vroeg in de questlijn → mooie Codex/info-tip.
- **Vendors Umbral Base Camp:** Fieldsmith Ventem (Response Team-transmogset;
  30/60 Field Accolades + 300/500 **Voidlight Marl**) en Zuronar <Lightveil
  Artificer> (wapens + housing decor). ✅ CORRECTIE (Rob, 12 jun): Voidlight
  Marl is GEEN nieuwe valuta — het is de bestaande Midnight-renown-munt
  (warband-transferable; MH trackt hem al: AltOverview-snapshot +
  RitualCoachData "2nd currency confirmed"). De 12.0.7-vendors prijzen er
  alleen óók in. → Codex/hint-kandidaat: "je bestaande Marl-voorraad is
  vanaf 16 juni te besteden bij de nieuwe Umbral Base Camp-vendors
  (transmog 300-500 per stuk)".
- Drop-quest **95069 "Torn Twilight Missive"** (drop bij de actieve ritual
  site, inleveren Silvermoon; Rob 12 jun) beloont o.a. Voidlight Marl —
  leuke lore-breadcrumb (Ger'lok/Broken Throne), geen verdere addon-actie.
- **Omnium Folio:** Mote of Omnial Inquiry komt uit weekly "Seeking
  Knowledge" (week 1 = 96410 ✓); 5 keuze-nodes over 5 weken; **Folio-weekly
  is warband/account-breed** — 1× per account per week volstaat →
  checklist-semantiek: account-regel, géén per-char regel!
- Val-flavor: ijswereld, Pertinax zit in de "Void Acropolis"; Naigtal:
  Hal'hadar-ethereals met Mana-Forge.
- Achievement "Showdown Success: Val" = **62880** (PTR-tak); quest-ID van
  "Showdown on Val" zelf nog steeds niet via web vindbaar (nether-tooltip
  96718 leeg) → blijft PTR/live-dump (§2).
- Let op (Zygor-events-guide): "Imperator Pertinax npc 252308" in een
  Eversong-scenario is een ándere Pertinax dan world boss 263670.

Reeds geverifieerd (Wowhead/Blizzard, juni 2026):

| Wat | ID |
|---|---|
| Naigtal zone | 16943 (Wowhead-zone; uiMapID nog nodig) |
| Val zone | 16900 (idem) |
| Nexus-Captain Leth'ir (world boss Naigtal) | npc 263843, killquest 96472 |
| Imperator Pertinax (world boss Val) | npc 263670 |
| Rotmire (Sporefall) | npc 254176, raid zone 16279 |
| Omnium Folio week 1-quest "Seeking Knowledge" | quest 96410 |
| Field Accolade | currency 3405 (bestaand) |
| Spawn of Vyranoth (Timeways-mount) | item 258884, achievement 61463 |
| Darkspear Dash | event 1793 (27-28 juni) |
| API | TOC 120007; `GetInstanceInfo()` ret11 `hasWorldTier`; `Enum.TieredEntranceType.WorldTier`; geen C_WeeklyRewards-wijzigingen |

## Nog nodig — run dit op de PTR

**1. uiMapID van Naigtal en Val** (voor waypoints/zone-detectie)
Sta in de zone en run:
```
/dump C_Map.GetBestMapForUnit("player")
```
Noteer per zone (en eventueel per verdieping/subzone).
- ✅ **Naigtal = uiMapID 2600** (gemeten in Umbral Base Camp, PTR 6 juni 2026)
- ⬜ Val = ? (volgende rotatie, of check of het vaste Silvermoon-portaal een keuze biedt)
- ✅ Vast Silvermoon-portaal = **2393, 47.93, 48.09** (exact midden; zelfde verdieping als de quest-hub in de Bazaar, iets verderop — PTR 7 juni)

**2. Showdown weekly quest-IDs** ("Showdown on Naigtal" / "Showdown on Val", + evt. Heroic-variant)
Pak de weekly aan en run:
```
/run for i=1,C_QuestLog.GetNumQuestLogEntries() do local q=C_QuestLog.GetInfo(i) if q and not q.isHeader then print(q.questID, q.title) end end
```
Zoek de Showdown-regels in de chat.
- ✅ **"Showdown on Naigtal" = quest 96717** (PTR, 6 juni 2026)
- ✅ Zijquest "Surveying the Mana-Bog" = quest 96054 (Naigtal)
- ⬜ "Showdown on Val" = ? (volgende rotatie)
- ⬜ Heroic-variant weekly = ? (bestaat die als aparte quest?)
- ✅ Na de weekly: Maella biedt "So Much More To Do" → keuzedialoog "Unity against the Void": **Disruptions Continue** (WQ's/events) óf **Dangerous Enemies** (rares/overseers/elites) — vervolg-weekly naar keuze. ⬜ Quest-IDs van beide opties: kies er één en run de questlog-dump.

**3. Rare NPC-IDs Naigtal/Val** (Interminable Uarn, Indomitable Mk. XII, Glacial Broodmother, The Horror Below, + wat je verder tegenkomt)
- ✅ Naigtal: **Voidwarped Sporebat = npc 265698** (PTR 6 juni)
- ✅ Naigtal: **Indomitable Mk XII = npc 264571** (PTR 6 juni — stond op de research-lijst)
- ✅ Naigtal: **Lomelith = npc 263955** (PTR 6 juni)
- ✅ Naigtal: **Slaipaan = npc 264576** (PTR 6 juni)
- ✅ Naigtal: **Interminable Uarn = npc 263947** (PTR 6 juni — stond op de research-lijst)
- ✅ Naigtal: **Swalewing Matriarch = npc 263954** (PTR 6 juni)
- ✅ Naigtal: **Warbringer Thal'kuur = npc 267422** (PTR 7 juni)
- ✅ Naigtal: **Auredar's Chassis = npc 264569** (PTR 7 juni)
Target de rare en run:
```
/run local g=UnitGUID("target") print(g and select(6,strsplit("-",g)), UnitName("target"))
```

**3b. Voor opname in Rares.lua zijn per rare ook nodig (entry-vorm
`{ questId, mapID, x, y, naam }`):**
- **Coords:** sta bij de rare en run
  `/run local m=C_Map.GetBestMapForUnit("player") local p=C_Map.GetPlayerMapPosition(m,"player") print(m, ("%.1f, %.1f"):format(p.x*100, p.y*100))`
- **Kill-quest-ID (flipt bij kill, reset dagelijks/wekelijks?):** scan vóór
  en direct ná de kill een blok rond de bekende 12.0.7-quest-reeks:
  `/run local n=0 for i=96000,97000 do if C_QuestLog.IsQuestFlaggedCompleted(i) then n=n+1 end end print("flags true:", n)` —
  beter: noteer per kill welke ID erbij komt met
  `/run MH_T=MH_T or {} for i=96000,97000 do local f=C_QuestLog.IsQuestFlaggedCompleted(i) if f and not MH_T[i] then MH_T[i]=true print("NIEUW:",i) end end`
  (eerste run = baseline vullen, na de kill nogmaals = print het nieuwe ID).
- Verzamelde npc-IDs (8) staan hierboven ✅; met coords + questIds erbij
  gaan ze in Rares.lua (build-gate ≥120007).

**4. Riftstalker's Cache item-ID**
- ✅ **Riftstalker's Cache = item 275690**; weekly turn-in verhoogde de Great Vault World-rij (type 6) — Blizzard-claim bevestigd (PTR 6 juni) — shift-klik het item in de chat of run met het item in je tas:
```
/run for b=0,4 do for s=1,C_Container.GetContainerNumSlots(b) do local i=C_Container.GetContainerItemInfo(b,s) if i and i.hyperlink and i.hyperlink:find("Riftstalker") then print(i.itemID, i.hyperlink) end end end
```

**5. Mote of Omnial Inquiry** — zelfde bagscan, zoekterm "Omnial". Check ook of het een currency is:
```
/dump C_CurrencyInfo.GetCurrencyInfo(3405)
```
(en kijk in je currency-tab of er een nieuwe Omnium-valuta staat — hover + `/dump GameTooltip:GetPrimaryTooltipData()`)

**6. Heroic World Tier status** — klopt het dat er géén unlock-vereiste meer is? En:
```
/dump select(11, GetInstanceInfo())
```
in een Showdown-zone (verwacht: `hasWorldTier = true`).
- ✅ **`hasWorldTier = true` bevestigd in Naigtal** (PTR, 6 juni 2026)
- ✅ Geen unlock-vereiste: portaal bood direct twee opties (Normal / Heroic World Tier) op een verse PTR-kopie

**7. Portaalrotatie** — ✅ **wekelijks** (Blizzard-blog via Wowhead, 11 juni): "Each area rotates weekly, becoming available for one week at a time" → VoidAssaults-weekly-aanpak herbruikbaar.

**8. Sporefall Great Vault** — telt een Rotmire-kill mee in de bestaande Raids-rij? Na een kill:
```
/dump C_WeeklyRewards.GetActivities(3)
```

## Wat hiermee gebouwd wordt

- `VoidAssaults.lua`/`WorldContent.lua`: Showdowns-sectie (actieve zone-detectie via weekly quest-flag, zelfde patroon als 12.0.5 Void Assaults) — nodig: 1, 2, 7
- `WorldBoss.lua`: Leth'ir/Pertinax-entries — nodig: 1, 2 (kill-quests per boss: 96472 bekend, Pertinax + Heroic-varianten nodig)
- `Rares.lua`: nieuwe zone-rares — nodig: 1, 3
- `AccountWeeklyChecklist`: Folio-mote (⚠ account/warband-breed — 1 regel voor het hele account!) + Showdown-weekly — nodig: 2, 5
- Codex-artikelen: al geschreven (geen IDs nodig) ✔
