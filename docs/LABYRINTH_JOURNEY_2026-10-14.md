# The Labyrinth of Kindo'jan Journey (major faction 2836): research for an explainer card

Researched 14 Oct 2026 for Midnight Helper. EU live 12.1.5, build 12.1.5.70391.
Labels: **MEASURED** (GEMETEN) means seen in a named, dated source. **DERIVED** (AFGELEID) means reasoned from measured facts.
Nothing under `MidnightHelper/docs/` was read. No addon files were changed.

## Sources used

| Key | Source | Date / build |
|---|---|---|
| W-DB2 | wago.tools DB2 CSV + table view (RenownRewards, Covenant, Faction, CurrencyTypes, Spell, SpellName, SpellEffect, SpellAuraOptions, SpellMisc, SpellDuration, ItemSparse, ItemEffect, ItemXItemEffect, CharTitles, Achievement, CriteriaTree), read in the built-in browser | build **12.1.5.70391**, read 14 Oct 2026 |
| W-HF | wago.tools hotfix list, search "Kindo'jan" (58 rows, builds 70077 and 70391) | read 14 Oct 2026 |
| WH-G | Wowhead, "The Labyrinth of Kindo'jan Patch 12.1.5 Megadelve Guide" (Sinzhu) | published 3 Oct 2026, updated 13 Oct 2026 |
| IV | Icy Veins, "Labyrinth of Kindo'jan Guide" (Gogogadgetkat) | published 10 Oct 2026, updated 12 Oct 2026 |
| BLZ | Blizzard, 12.1.5 Content Update Notes | 1 Oct 2026 |
| MTH | Method.gg, Labyrinth of Kindo'jan Delve Guide + Sturdy Chest guide (Roguery) | 10 Oct 2026 |
| WH-Q | Wowhead quest page 93784 "A Gnawing Void of Curiosity" | read 14 Oct 2026 |
| WH-D | Wowhead, "Midnight Delves Season 2" guide (Paryah); also wowcarry.com (24 Aug 2026) and accountshark.net (10 Aug 2026) | 20 Mar 2026 (WH-D) |
| ZYG | Local Zygor files, `E:\World of Warcraft\_retail_\Interface\AddOns\ZygorGuidesViewer` | files present 14 Oct 2026 |

ZYG has only the intro quest chain (quests 98831 to 98836) and the chamber scenarios. It has no renown data and none of the reward names. That empty result proves nothing.

---

## 1. The track itself

| Fact | Value | Label / source |
|---|---|---|
| Faction | 2836 "The Labyrinth of Kindo'jan", parent faction 2698 "Midnight" | MEASURED, W-DB2 Faction |
| Renown track ID (RenownRewards.CovenantID) | 55, internal name "[DNT] 12.1.5 Labyrinth Season 2" | MEASURED, W-DB2 Covenant |
| Renown-level currency | 3536 "Renown - Season 2 Labyrinth", MaxQty **9** | MEASURED, W-DB2 CurrencyTypes |
| Progress currency | 3537 "Kindo'jan's Labyrinth Journey", described as "Grants Kindo'jan's Labyrinth Journey progress." | MEASURED, W-DB2 CurrencyTypes |
| **Max rank** | **9** | MEASURED: currency MaxQty 9, and the highest RenownRewards level for track 55 is 9. For all 26 renown tracks in this build, MaxQty matches the highest reward level, so the rule holds. |
| **Points per rank** | **2100** (Faction.ReputationMax_0 = 2100) | MEASURED, W-DB2. Matches Rob's in-game 900 / 2100. WH-G also says 2100 for each of the 9 ranks. |
| Flat per rank? | Yes | DERIVED: the client stores one threshold per renown faction. For comparison, other Midnight renowns use 2500 and the Delves journeys use 4200. WH-G says "each requiring 2100". |
| Total from rank 1 to 9 | 8 × 2100 = **16,800** progress | DERIVED (assumes rank 1 = start, which is what Rob's window shows) |
| Anything after rank 9? | No paragon (ParagonFactionID = 0) | MEASURED, W-DB2 Faction. DERIVED: no repeatable reward after rank 9. |
| Seasonal | Internal names say "Season 2" (track and currency) | MEASURED (names). DERIVED: probably a Season 2 track like the Delves journeys. Nothing says what happens to it in a later season. |
| Hotfixes | No RenownRewards hotfix found that contains "Kindo'jan" | MEASURED, W-HF. Caveat: the rank 2 and rank 4 rows do not contain that word, so a hotfix to them would not show up in this search. |

---

## 2. Every rank and its reward

All names and descriptions: MEASURED, W-DB2 RenownRewards (CovenantID 55), build 70391. Every row has Flags = 8 and ItemID/SpellID/MountID/TitleID = 0 unless noted.

| Rank | RR ID | Name (enUS) | Type | IDs | What it does (plain) |
|---|---|---|---|---|---|
| 1 | 1924 | **Ancient Curios** | loot unlock | SpellID field 454473 (see note A) | In a Labyrinth run on **Tier 8 or higher**, Bountiful Coffers and "Hidden Troves" can now drop **rank 5 curios**. |
| 2 | 2050 | **Lock, Key, and Mask** | Labyrinth content unlock | none | The Labyrinth now hides a **locked door**, the **Keeper of the Key** (kill him for the key) and three **Elemental Hexmasks** (fire, frost and lightning helpers that follow you for the rest of the run). **It does NOT open the loa-sealed rooms.** |
| 3 | 1927 | **Akil'zon's Favor** | door unlock | none | You can now pass **Akil'zon's Seals** (sealed doors). The Sturdy Chests behind them hold **Akil'zon's Swiftness** (permanent) and the glove enchant **Falco Strikes**. **It is not a buff for one room.** |
| 4 | 2049 | **Spirited Away** | travel unlock | none | **Kinduru** (the spirit at the exit) can now fly you to chambers you already completed. Toast: "Flightmaster Kinduru Unlocked". |
| 5 | 1929 | **Jan'alai's Favor** | door unlock | none | Opens **Jan'alai's Seals**. The chests behind them hold the glove enchant **Heat Wave**. |
| 6 | 2048 | **Loa-Spiritual Conduits** | in-run buff unlock | none | **Spiritual Conduits** now appear in the Labyrinth. Clicking one gives the whole party a strong 2-minute boost. |
| 7 | 1928 | **Nalorakk's Favor** | door unlock | none | Opens **Nalorakk's Seals**. The chests behind them hold **Nalorakk's Ferocity** (permanent) and the glove enchant **Ursine's Ironhide**. |
| 8 | 2047 | **Delve-O-Bot 7001: The Labyrinth of Kindo'jan Software Update Chip** | toy upgrade (vendor) | ItemID **286558**; RR Field_12_0_0_63534_016 = 1 | You can **buy** the chip from **Telemancer Astrandis in Silvermoon City**. It adds the Labyrinth to the **Delve-O-Bot 7001** toy (item 230850). See note B. |
| 9 | 1926 | **Halazzi's Favor** | door unlock + title | CharTitlesID field = 0 (see note C) | You get the title **"<name> of the Labyrinth"**. It also opens **Halazzi's Seals**. The chests behind them hold **Halazzi's Shroud** (permanent) and the glove enchant **Eye of the Lynx**. |

### What sits behind the loa seals (ranks 3, 5, 7, 9)

| Thing | ID | What it does | Label / source |
|---|---|---|---|
| Akil'zon's Swiftness (rank 3) | spell 1313862 (aura 1313937) | Permanent. Each chamber you complete in a run gives a stack of **+3% movement speed**. | MEASURED, W-DB2: description "stacking movement speed for every labyrinth chamber completed"; SpellEffect 1313937 = MOD_INCREASE_SPEED 3; aura max stack 100. DERIVED: with 9 chambers per run, the practical maximum is 9 stacks (27%). WH-G also says "3% per Chamber cleared in a run". |
| Nalorakk's Ferocity (rank 7) | spell 1313875 (aura 1313938) | Permanent. Each chamber you complete in a run gives a stack of **+3% primary stat**. | MEASURED, W-DB2: SpellEffect 1313938 = MOD_TOTAL_STAT_PERCENTAGE 3. DERIVED: practical maximum 9 stacks, as above. |
| Halazzi's Shroud (rank 9) | spell 1314367 (aura 1314390) | Permanent. **Cheat death once** while inside the Labyrinth. | MEASURED, W-DB2 description. "Once per run": WH-G (MEASURED there). |
| Ancient Hash'ey Battle Art: Falco Strikes (rank 3) | item **280563** → spell 1314402 | Glove enchant that works **in any delve**. It sometimes strikes a nearby enemy for Nature damage, with a **20%** chance to strike again. Not used up when you use it. | MEASURED, W-DB2 (description; SpellEffect 1315100 value 20). Epic, required level 90. |
| Battle Art: Heat Wave (rank 5) | item **283996** → spell 1315083 | Glove enchant for any delve. It sometimes sets you on fire for **20 s**, dealing Fire damage split between nearby enemies. | MEASURED, W-DB2 (duration 20000 ms) |
| Battle Art: Ursine's Ironhide (rank 7) | item **283997** → spell 1315082 | Glove enchant for any delve. It sometimes gives you a **15 s** shield. | MEASURED, W-DB2 (duration 15000 ms) |
| Battle Art: Eye of the Lynx (rank 9) | item **283998** → spell 1315084 | Glove enchant for any delve. It sometimes gives you and a random nearby ally **Haste and Leech for 15 s**. | MEASURED, W-DB2. WH-G says Valeera can be that ally. |
| Glove enchant item-level cap | all four Battle Arts | "Cannot be applied to items higher than level $ecix" | MEASURED (the text exists). The actual cap value was not resolved. |
| Toys / transmog behind the seals | Feathers of Akil'zon (r3), Rite of Jan'alai's Flame (r5), Nalorakk's Strength Charm (r7), Trail of Halazzi (r9); Loa-Touched Spine, Hexdrinker's Shoulders (r3), Loa-Touched Deltoid (r5), Loa-Touched Visage (r9) | cosmetics | MEASURED in WH-G and IV only. Item IDs were not checked in DB2. |
| Sealed rooms | Akil'zon ×3 (Chamber of Rites, Cave Towers, Akil'zon's Roost), Jan'alai ×2 (Halazzi's Lair, Jan'alai's Refuge), Nalorakk ×2 (Reliquary, Nalorakk's Rest), Halazzi ×2 (Halazzi's Lair, Catacombs) | 2 to 3 chests each | MEASURED, WH-G and MTH (they agree on the 9 rooms) |

### Rank 6: the four Spiritual Conduits

MEASURED, W-DB2 spells 1314332, 1314346, 1314350, 1314353. All four last **120 s** and are party-wide area auras (effect 65). Spell 1314910 says four of them can be found per Labyrinth.

| Conduit | Effect |
|---|---|
| Spiritual Wind (Akil'zon) | "combat speed greatly increased", base value **25** (WH-G says +25% speed for attacks, casts and cooldowns) |
| Spiritual Earth (Nalorakk) | **−50% damage taken** |
| Spiritual Fire (Jan'alai) | burns nearby enemies every **2.5 s** |
| Spiritual Mist (Halazzi) | **executes non-boss enemies below 20% health** |

Each conduit has two more effects with values 20 and 5 (auras 171 and 61). DERIVED and not checked: probably movement speed and model size.

### Rank 2 details

- Archaic Amani Key, spell 1319902: "Use it to unlock a hidden door concealed within the Labyrinth." MEASURED, W-DB2.
- Hexmask familiars: Fiery 1308804, Frozen 1308967, Thundering 1308968. MEASURED, W-DB2.
- WH-G (MEASURED there) says each run has 5 fixed spawn points: 3 are Hexmasks, 1 is the Locked Room and 1 is empty. The Locked Room holds Mislaid Curiosity and Mislaid Treasure chests that give boons for the run.
- IV (MEASURED there) says the **Fiery Hexmask can melt the ice wall** to the hidden Flooded Chamber (5 chests). DB2 has spell 1307495 "12.1.5 Labyrinth - Breakable - Ice Wall" (MEASURED). That the Fiery Hexmask breaks it is DERIVED from IV.

---

## 3. How you earn Journey progress

| Source | Amount | Label / source |
|---|---|---|
| Weekly Delves turn-in **"A Gnawing Void of Curiosity"** (quest **93784**, Weekly, ends at Naleidea Rivergleam, Silvermoon) | **2000** Labyrinth Journey | MEASURED in WH-G (3/13 Oct). The WH-Q page itself lists only Undercoin and Voidlight Marl, not the Journey progress. DB2 has a hidden currency 3592 "12.1.5 Labyrinth - Personal Tracker - S2 Weekly Turn-In (Hidden)" (MEASURED). DERIVED: there is a separate per-character weekly tracker for the Labyrinth part of the turn-in. |
| Kindo'jan's chest (**Ancestral Bounty**), after a Tier 8+ boss kill | **500** Labyrinth Journey (+300 Delve Journey) | MEASURED in WH-G and IV (they agree) |
| **Ancient / Sturdy Chests** (one-time; **44** in total) | "substantial bonus", no number given | MEASURED (text only) in WH-G and IV. The 44 count is MEASURED in W-DB2: achievement 63717 criteria tree 233000 has Amount 44 and 44 children. |
| **Mislaid Treasure** chests (random spawns, repeatable) | "smaller amount", no number given | MEASURED (text only), WH-G |
| End-of-run treasure room chests | "Journey progress (both Delve and Labyrinth)", no number given | MEASURED (text only), WH-G |
| Per chamber or per boss directly | **Not found** in any source | Unknown. DB2 has a spell 1309409 "Labyrinth's Journey EXP" with a LOOT effect (treasure 143018). DERIVED: progress comes as loot from chests and containers, not as a per-kill reward. |
| **Bonus event "Sign of the Explorer"** (spell 471521, the Delves bonus event) | **+25%** Labyrinth Journey progress (also +25% Delver's Journey, Undercoin and companion XP) | MEASURED, W-DB2: SpellEffect MOD_REPUTATION_GAIN 25 on faction 2836, and the description names "The Labyrinth of Kindo'jan Journey" |
| **"Winds of Mysterious Fortune"** reputation boost (spell 1228236, +50% reputation) | **does NOT apply** | MEASURED, W-DB2: effect 3 = −50 for faction 2836, which cancels the +50. The tooltip says "except for ... The Labyrinth of Kindo'jan Journey". |
| Weekly cap | None found | MEASURED: currency 3537 MaxEarnablePerWeek = 0 and 3536 MaxEarnablePerWeek = 0. DERIVED: no hard weekly cap on progress, but the 2000 from the weekly quest is once a week. |
| Catch-up mechanic | None found for the Labyrinth | BLZ lists catch-up only for **Prey**. An empty result proves nothing. |

Speed estimate: WH-G says you "should be able to finish this Journey in only a few full runs of the Labyrinth if you take the time to explore" (MEASURED there). DERIVED from the weekly quest alone: about 1 rank per week (2000 of 2100).

## 4. Account-wide (Warband) or per character?

- **Not stated directly by any source found.** BLZ, WH-G, IV and MTH say only that the **Labyrinth unlock** (intro chain) is Warband-wide (MEASURED in WH-G and IV).
- **DERIVED, strong:** currency 3537 has exactly the same flags (Flags_0 = 0x240000A) as the Season 2 **Delver's Journey** currency 3483 (faction 2796). Faction 2836 has the same faction Flags (70) as 2796 Delves S2 and 2808 Preyhunter's Journey (all MEASURED, W-DB2). WH-D (and two Aug 2026 guides) say the Season 2 Delver's Journey is **Warband-bound**. So the Labyrinth Journey is **very likely Warband-wide**.
- Checking in game would settle it. On an alt, `C_MajorFactions.GetMajorFactionRenownInfo(2836)` should show the same level and progress as on Rob's main. `C_Reputation.IsAccountWideReputation(2836)` may also exist, but that API name is from memory and not checked against the client.

---

## 5. What a player should know (for the card)

1. **The ranks change the Labyrinth itself.** Most ranks open new things inside it: a locked room, masks, sealed rooms, flights and conduits. Only ranks 3, 5, 7 and 9 give permanent power, and they do it through chests in the sealed rooms. (MEASURED, W-DB2 descriptions)
2. **After ranks 3, 5, 7 and 9, go back to the sealed rooms.** The one-time chests hold the permanent upgrades, the glove enchants, toys and transmog. WH-G says unlooted Ancient Chests show on your map for rooms you can enter (MEASURED there). The sealed rooms keep spawning Mislaid Curiosities (boons) every run (WH-G, IV).
3. **Glove enchants work in every delve**, not only the Labyrinth. They are not used up, so you can reuse them on new gloves. There is an item-level cap. (MEASURED, W-DB2 text)
4. **Rank 1 only matters on Tier 8+.** Below Tier 8, no rank 5 curios drop from this unlock. (MEASURED, W-DB2)
5. **Rank 2 makes every run richer.** Kill the Keeper of the Key, open the locked room, and collect up to 3 Hexmask helpers. The Fiery one can melt the ice wall to the Flooded Chamber (IV).
6. **Rank 6 conduits:** there are four per run and they last 2 minutes. Use them when you find them (WH-G advice). Saving one makes little sense because the buff is short. (DERIVED from the 120 s duration)
7. **Rank 8 needs the Delve-O-Bot 7001 toy** (item 230850, "get a ride to a random Bountiful Delve", MEASURED, W-DB2). The chip only adds the Labyrinth as a destination.
8. **The weekly Delves turn-in counts double.** "A Gnawing Void of Curiosity" gives 2000 Labyrinth progress on top of its normal rewards (WH-G).
9. **Play during the Delves bonus week** ("Sign of the Explorer") for +25% Journey progress. The "Winds of Mysterious Fortune" reputation boost does nothing for this track. (MEASURED, W-DB2)
10. **Max rank 9, then it stops.** There is no paragon cache. (MEASURED, W-DB2)
11. Not a Journey reward, but useful: **Kinduru's Spiriting Quill** (toy from the intro chain) ends your run and teleports the party to the treasure room (spell 1320854, MEASURED, W-DB2). Progress inside a run is **not saved** if you leave (WH-G, IV).

---

## 6. Disagreements and oddities

| # | What | Data says | Others say | Verdict |
|---|---|---|---|---|
| A | Rank 1 SpellID 454473 | "Airship: Wings 05 - Lantern Wing" | n/a | DERIVED: placeholder. The same SpellID sits on the rank 1 rows of the TWW Delves S1, S2 and S3 tracks (Delver's Dirigible schematic). Ignore it. |
| B | Rank 8 item | RR ItemID = **286558** "Delve-O-Bot 7001: **The Labyrinth of Kindo'jan** Software Update Chip" (item effect: "adding The Labyrinth of Kindo'jan to its destination matrix") | The RR **description** (and IV) says you can buy the "Delve-O-Bot 7001: **Midnight** Software Update Chip". That is item 275936, the Delves S2 rank 7 reward. | DERIVED: copy error in Blizzard's text. Expect the vendor to sell 286558. Use 286558 on the card. |
| B2 | Rank 8 label | Name = "Delve-O-Bot 7001: ... Software Update Chip" | **WH-G table labels rank 8 "Ancient Curios"** | WH-G is wrong; this is a table copy error. |
| C | Rank 9 title | RR CharTitlesID = 0, but the description says the title "of the Labyrinth" is granted. CharTitles **1353** "%s of the Labyrinth" exists. No achievement awards it. | IV says "of the Labyrinth"; WH-G leaves the title name blank. | DERIVED: the server grants the title at rank 9. The title ID is 1353 (MEASURED that it exists). |
| D | Number of hidden chests | Achievement 63717 needs **44** (MEASURED, W-DB2) | WH-G: 44 (20 free + 19 sealed + 5 Flooded Chamber). MTH: "all 30 Sturdy Chests". | 44 is correct; MTH is outdated. |
| E | Chest name | Achievement and RR text: "**Sturdy** Chests" | WH-G and IV: "Ancient Chests" | Same chests. Use the client name "Sturdy Chest" on the card. DERIVED: some guides use the older delve name. |
| F | frFR toast typo | frFR toasts for ranks 3, 7 and 9 say "**seaux**" (buckets) instead of "sceaux" | n/a | MEASURED. This is Blizzard's own string. Copy it exactly if the card quotes toasts, or use the Name field instead. |

---

## 7. Client names (localized), MEASURED in W-DB2 build 70391

### Faction name

| enUS | deDE | frFR | esES | esMX | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| The Labyrinth of Kindo'jan | Das Labyrinth von Kindo'jan | Le labyrinthe de Kindo’jan | El laberinto de Kindo'jan | El Laberinto de Kindo'jan | O Labirinto de Kindo'jan | Labirinto di Kindo'jan | Лабиринт Киндо'джана |

Note: frFR uses the typographic apostrophe (’).

### Rank names (RenownRewards.Name_lang)

| R | enUS | deDE | frFR | esES | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| 1 | Ancient Curios | Antike Kuriositäten | Bibelots antiques | Bibelots ancestrales | Badulaques Ancestrais | Reperti Antichi | Древние диковинки |
| 2 | Lock, Key, and Mask | Schloss, Schlüssel und Maske | Verrou, clé et masque | Enmascarado a cal y canto | Fechadura, chave e máscara | Lucchetto, Chiave e Maschera | Замок, ключ и маска |
| 3 | Akil'zon's Favor | Akil'zons Gunst | Faveur d’Akil’zon | Favor de Akil'zon | Favorecimento de Akil'zon | Favore di Akil'zon | Благосклонность Акил'зон |
| 4 | Spirited Away | Entgeistert | Voyage spirituel | Desgarro de alma | Subtração Espiritual | Scomparsa Spiritica | Мистическое путешествие |
| 5 | Jan'alai's Favor | Jan'alais Gunst | Faveur de Jan’alai | Favor de Jan'alai | Favorecimento de Jan'alai | Favore di Jan'alai | Благосклонность Джан'алай |
| 6 | Loa-Spiritual Conduits | Spirituelle Leitungen der Loa | Conduits spirituels des Loas | Conductos espirituales loa | Conduítes Espirituais dos Loas | Condotti Spirituali dei Loa | Мистические проводники лоа |
| 7 | Nalorakk's Favor | Nalorakks Gunst | Faveur de Nalorakk | Favor de Nalorakk | Favorecimento de Nalorakk | Favore di Nalorakk | Благосклонность Налоракка |
| 8 | Delve-O-Bot 7001: The Labyrinth of Kindo'jan Software Update Chip | Tiefenbot 7001: Softwareupdate-Chip im Labyrinth von Kindo'jan | Puce de Méca-Gouffre 7001 : mise à jour logicielle du labyrinthe de Kindo’jan | Profundibot 7001: Chip de actualización de El laberinto de Kindo'jan | Imersobô 7001: Chip de Atualização de Software do Labirinto de Kindo'jan | Scorribot 7001: Chip di Aggiornamento del Software del Labirinto di Kindo'jan | Вылазкобот-7001: чип Лабиринта Киндо'джана для обновления ПО |
| 9 | Halazzi's Favor | Halazzis Gunst | Faveur d’Halazzi | Favor de Halazzi | Favorecimento de Halazzi | Favore di Halazzi | Благосклонность Халаззи |

esMX (for reference; MH does not ship it): 1 Singularidades antiguas, 2 Cerraduras, llaves y máscaras, 3 El favor de Akil'zon, 4 Desaparecido, 5 El favor de Jan'alai, 6 Conductos espirituales de los loa, 7 El favor de Nalorakk, 8 Chip de actualización de software de El Laberinto de Kindo'jan para Abism-O-bot 7001, 9 El favor de Halazzi.

### Toast lines (RenownRewards.ToastDescription_lang)

| R | enUS | deDE | frFR | esES | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| 1 | Discover Rank 5 Curios | Entdeckt Kuriositäten auf Rang 5 | Bibelots de rang 5 à découvrir | Descubre bibelots de rango 5 | Descubra Badulaques de Grau 5 | Scopri Reperti di grado 5 | Вы можете находить диковинки 5-го уровня |
| 2 | Lock, Key, and Masks Hidden Within | Schloss, Schlüssel und Masken darin versteckt | Verrou, clé et masques bien cachés | Algo se oculta: enmascarado a cal y canto | Fechadura, chave e máscaras escondidas | Lucchetto, Chiave e Maschere nascoste | Внутри спрятаны замок, ключ и маски |
| 3 | Access to Akil'zon Labyrinth Seals | Zugang zu Akil'zons Siegeln im Labyrinth | Accès aux seaux du labyrinthe d’Akil’zon | Accede a los sellos del laberinto de Akil'zon | Acesso aos Selos de Akil'zon no Labirinto | Accesso ai Sigilli del Labirinto di Akil'zon | Доступ к печатям Акил'зон в Лабиринте |
| 4 | Flightmaster Kinduru Unlocked | Flugmeister Kinduru freigeschaltet | Maître de vol Kinduru débloqué | Maestro de vuelo Kinduru desbloqueado | Mestre de Voo Kinduru desbloqueado | Maestro di Volo Kinduru sbloccato | Открыт распорядитель полетов Киндуру |
| 5 | Access to Jan'alai Labyrinth Seals | Zugang zu Jan'alais Siegeln im Labyrinth | Accès aux sceaux du labyrinthe de Jan’alai | Accede a los sellos del laberinto de Jan'alai | Acesso aos Selos de Jan'alai no Labirinto | Accesso ai Sigilli del Labirinto di Jan'alai | Доступ к печатям Джан'алай в Лабиринте |
| 6 | Spiritual Conduits Unlocked | Spirituelle Leitungen freigeschaltet | Conduits spirituels débloqués | Conductos espirituales desbloqueados | Conduítes Espirituais desbloqueados | Condotti Spirituali sbloccati | Открыты мистические проводники |
| 7 | Access to Nalorakk Labyrinth Seals | Zugang zu Nalorakks Siegeln im Labyrinth | Accès aux seaux du labyrinthe de Nalorakk | Accede a los sellos del laberinto de Nalorakk | Acesso aos Selos de Nalorakk no Labirinto | Accesso ai Sigilli del Labirinto di Nalorakk | Доступ к печатям Налоракка в Лабиринте |
| 8 | Toy Upgrade Available | Aufwertung für Spielzeug verfügbar | Amélioration de jouet disponible | Mejora de juguete disponible | Aprimoramento de brinquedo disponível | Potenziamento del giocattolo disponibile | Доступно улучшение игрушки |
| 9 | Access to Halazzi Labyrinth Seals | Zugang zu Halazzis Siegeln im Labyrinth | Accès aux seaux du labyrinthe d’Halazzi | Accede a los sellos del laberinto de Halazzi | Acesso aos Selos de Halazzi no Labirinto | Accesso ai Sigilli del Labirinto di Halazzi | Доступ к печатям Халаззи в Лабиринте |

### Title (CharTitles 1353)

enUS "%s of the Labyrinth" · deDE "%s vom Labyrinth" · frFR "%s du labyrinthe" · esES "%s del laberinto" · ptBR "%s do Labirinto" · itIT "%s del Labirinto" · ruRU "%s из Лабиринта"

### Permanent upgrades (SpellName)

| | enUS | deDE | frFR | esES | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| 1313862 | Akil'zon's Swiftness | Akil'zons Schnelligkeit | Rapidité d’Akil’zon | Presteza de Akil'zon | Rapidez de Akil'zon | Rapidità di Akil'zon | Стремительность Акил'зон |
| 1313875 | Nalorakk's Ferocity | Nalorakks Wildheit | Férocité de Nalorakk | Ferocidad de Nalorakk | Ferocidade de Nalorakk | Ferocia di Nalorakk | Свирепость Налоракка |
| 1314367 | Halazzi's Shroud | Halazzis Schleier | Voile d’Halazzi | Sudario de Halazzi | Mortalha de Halazzi | Manto di Halazzi | Покров Халаззи |

### Glove enchants (ItemSparse)

| Item | enUS | deDE | frFR | esES | ptBR | itIT | ruRU |
|---|---|---|---|---|---|---|---|
| 280563 | Ancient Hash'ey Battle Art: Falco Strikes | Uralte Kampfkunst der Hash'ey: Falkenschläge | Art martial ancestral hash’ey : Frappes du faucon | Arte de combate ancestral hash'ey: Golpes de halcón | Arte de Batalha Hash'ey Antiga: Golpes de Falco | Arte Bellica Antica dell'Hash'ey: Colpi del Falco | Древнее боевое искусство хаш'эй: удары сокола |
| 283996 | Ancient Hash'ey Battle Art: Heat Wave | Uralte Kampfkunst der Hash'ey: Hitzewelle | Art martial ancestral hash’ey : Vague de chaleur | Arte de combate ancestral hash'ey: Ola de calor | Arte de Batalha Hash'ey Antiga: Onda de Calor | Arte Bellica Antica dell'Hash'ey: Ondata di Calore | Древнее боевое искусство хаш'эй: волна жара |
| 283997 | Ancient Hash'ey Battle Art: Ursine's Ironhide | Uralte Kampfkunst der Hash'ey: Eisenhaut des Bären | Art martial ancestral hash’ey : Cuiracier ursin | Arte de combate ancestral hash'ey: Piel férrea del ursino | Arte de Batalha Hash'ey Antiga: Couro de Ferro Ursino | Arte Bellica Antica dell'Hash'ey: Pellegrama dell'Orso | Древнее боевое искусство хаш'эй: медвежья железная шкура |
| 283998 | Ancient Hash'ey Battle Art: Eye of the Lynx | Uralte Kampfkunst der Hash'ey: Luchsauge | Art martial ancestral hash’ey : Œil de lynx | Arte de combate ancestral hash'ey: Ojo del lince | Arte de Batalha Hash'ey Antiga: Olho do Lince | Arte Bellica Antica dell'Hash'ey: Occhio della Lince | Древнее боевое искусство хаш'эй: глаз рыси |

---

## 8. Still open (cannot be settled from data or guides)

1. **Exact progress per Sturdy Chest, Mislaid Treasure and treasure-room run.** No source gives numbers; the amounts are server-side (treasure 143018). In game: note the progress (900/2100 now) before and after one run.
2. **Warband-wide or not.** Strongly DERIVED as Warband-wide (section 4). Settle it with the alt check.
3. **Is the weekly quest's 2000 per character or per Warband?** The hidden "Personal Tracker" currency 3592 suggests per character (DERIVED). Not confirmed.
4. **Spirited Away scope.** The data says "previously completed chambers". Guides (expcarry, WGE) read it as chambers completed during the current run. Not confirmed in game.
5. **Glove enchant item-level cap value** ($ecix) was not resolved.
