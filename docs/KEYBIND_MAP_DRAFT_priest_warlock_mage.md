# Keybind-maps (v6 toegepast) — CONCEPT: Priest, Warlock, Mage (Arcane/Fire)

> ⚠️ **Update 2026-07-02 (ná dit draft):** F2/F3/F4 zijn **heal-ankers** geworden
> (F2 = snelle combat-heal, F3 = out-of-combat-heal, F4 = recuperate/HoT). Utility-slots
> zijn nu F/R/T/X + overflow. Alle F2–F4-toewijzingen hieronder herzien bij het encoderen.

Standaard: `docs/KEYBIND_STANDARD_v6.md`. Kit + spell-ID's: web-research (Wowhead/Icy Veins/
Method, Midnight 12.0.5–12.0.7, juli 2026). **Dit is een CONCEPT — nog niet in-game bevestigd.**

**Labels:** ✅ = alleen in-game bevestigd (Rob/Cisca) — dat is hier **nog niet gebeurd**, daarom
staat er in dit doc **geen enkele ✅** · 🟡 web-bron gevonden maar (nog) niet addon-/in-game-
bevestigd · 🟢 door addon-data bevestigd (met bronvermelding) · ⚠️ ID onbekend of vermoedelijk fout —
in-game dumpen. **Niets is hier verzonnen** (never-lie): bij twijfel staat 🟡 of ⚠️, nooit een gok
zonder label.

Ankers (alle specs, verplaatsen nooit — zie §3 standaard, niet per spec herhaald): **E**=interrupt ·
**Q**=movement · **Z**=kleine def · **C**=grote def · **V**=dispel/CC · **F1**=grote cooldown ·
**Shift+E**=racial · **Ctrl+F1**=trinket · **Alt+C**=potion. Overflow = zelfde toets, volgende
modifier (**Shift→Ctrl→Alt**).

**Healers (Disc/Holy):** single-target heals staan **niet** op toetsen — die gaan via mouseover /
Click Cast Bindings (§6 standaard). De heal-cooldowns en AoE-heal-spenders die wél vaak bewust
getimed worden (Radiance, Holy Word: Sanctify/Serenity, Rapture, Barrier…) staan wel op de
builder/spender/F1-sloten, net als bij DPS.

---

## 🙏 Discipline Priest

**Interrupt:** Discipline heeft **geen** interrupt-spell (bevestigd, meerdere bronnen incl.
Blizzard-forums-discussie). Regel uit de standaard: E blijft utility totdat er een interrupt komt.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Penance | 47540 🟢 | Builder (kern-ability, heal of damage) — 🟢 (addon-data: ClassCodex Priest\guide.lua {47540}) |
| **2** | Power Word: Shield | 17 🟢 | Builder (Atonement-applicator) — 🟢 (addon-data: JustAC SpellCategories.lua [17]) |
| **3** | Shadow Word: Pain | 589 🟢 | Builder (DoT, Atonement-applicator) — 🟢 (addon-data: JustAC SpellArchetypes.lua [589]) |
| **4** | Power Word: Radiance | 194509 🟢 | Spender (AoE-heal/Atonement, 5 targets) — 🟢 (addon-data: JustAC SpellCategories.lua [194509]) |
| **5** | Shadow Word: Death | 32379 🟢 | Spender (execute) — 🟢 (addon-data: JustAC SpellArchetypes.lua [32379]) |
| **Shift+2** | Mind Blast | 8092 🟢 | AoE/burst-tweeling (builder-variant) — 🟢 (addon-data: JustAC SpellArchetypes.lua [8092]) |
| **Shift+4** | Evangelism | 472433 🟢 | AoE-cooldown-tweeling (instant Radiance-enabler) — 🟢 (addon-data: ClassCodex Priest\guide.lua {472433}) |
| **E** | *(geen interrupt)* Mind Control | 605 🟢 | Utility (E blijft vrij tot interrupt bestaat) — 🟢 (addon-data: JustAC SpellCategories.lua [605]) |
| **Q** | Fade | 586 🟢 | Movement (+ kleine DR via talent) — 🟢 (addon-data: JustAC SpellCategories.lua [586]) |
| **Z** | Desperate Prayer | 19236 🟢 | Kleine defensive — 🟢 (addon-data: JustAC SpellCategories.lua [19236]) |
| **C** | Power Word: Barrier | 62618 🟢 | Grote defensive (raid-DR) — 🟢 (addon-data: JustAC SpellCategories.lua [62618]) |
| **Shift+C** | Pain Suppression | 33206 🟢 | Grote defensive (tank-external) — 🟢 (addon-data: JustAC SpellCategories.lua [33206]) |
| **V** | Psychic Scream | 8122 🟢 | CC (fear) — 🟢 (addon-data: JustAC InterruptAbilities.lua [8122]) |
| **Shift+V** | Purify | 527 🟢 | Dispel — 🟢 (addon-data: JustAC SpellCategories.lua [527]) |
| **F1** | Rapture | 47536 🟢 | Grote cooldown (heal-enabler) — 🟢 (addon-data: JustAC SpellCategories.lua [47536]) |
| **Shift+F1** | Ultimate Penitence | 421453 🟢 | Grote cooldown (burst) — 🟢 (addon-data: JustAC SpellCategories.lua [421453]) |
| **F** | Shadowfiend | 34433 🟢 | Utility (pet/Insanity) — 🟢 (addon-data: ExwindCore ThingsToMantain [34433]) |
| **R** | Power Infusion | 10060 🟢 | Utility (haste-cooldown) — 🟢 (addon-data: JustAC SpellCategories.lua [10060]) |
| **T** | Mass Dispel | 32375 🟢 | Utility — 🟢 (addon-data: ExwindCore ThingsToMantain [32375]) |
| **X** | Leap of Faith | 73325 🟢 | Utility (pull) — 🟢 (addon-data: JustAC SpellCategories.lua [73325]) |
| **F2** | Shackle Horror | 9484 🟢 | Dispel/CC (extra) — 🟢 (addon-data: ExwindCore ThingsToMantain [9484]) |

**ST-heals (mouseover/Click Cast, niet op toetsen):** Flash Heal 2061 🟢, Power Word: Shield 17 🟢,
Power Word: Radiance 194509 🟢 (addon-data: JustAC SpellCategories.lua).

**⚠️ Onzeker/nog te dumpen:** Void Shield (Apex-talent-upgrade van PWS) — spell-ID wisselt tussen
bronnen (1253828 / 1253593 / 1292224 gezien), **niet betrouwbaar vast te stellen** → ⚠️ ID
onbekend, in-game dumpen als je Master the Darkness speelt.

---

## 🙏 Holy Priest

**Interrupt:** Holy heeft **geen** interrupt-spell (zelfde bevestiging als Discipline).

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Flash Heal | 2061 🟢 | Builder (heal) — 🟢 (addon-data: JustAC SpellCategories.lua [2061]) |
| **2** | Smite | 585 🟢 | Builder/filler (damage, voedt Holy Word: Chastise) — 🟢 (addon-data: JustAC SpellArchetypes.lua [585]) |
| **3** | Prayer of Mending | 33076 🟢 | Builder (bouncing heal) — 🟢 (addon-data: JustAC SpellCategories.lua [33076]) |
| **4** | Holy Word: Serenity | 2050 🟢 | Spender (grote ST-heal) — 🟢 (addon-data: JustAC SpellCategories.lua [2050]) |
| **5** | Holy Word: Sanctify | 34861 🟢 | Spender (grote AoE-heal, 5 targets) — 🟢 (addon-data: JustAC SpellCategories.lua [34861]) |
| **Shift+3** | Prayer of Healing | 596 🟢 | AoE-tweeling (4 targets) — 🟢 (addon-data: JustAC SpellCategories.lua [596]) |
| **Shift+4** | Renew | 139 🟢 | HoT-tweeling — 🟢 (addon-data: JustAC SpellCategories.lua [139]) |
| **E** | *(geen interrupt)* Mind Control | 605 🟢 | Utility (E blijft vrij tot interrupt bestaat) — 🟢 (addon-data: JustAC SpellCategories.lua [605]) |
| **Q** | Fade | 586 🟢 | Movement (+ kleine DR via talent) — 🟢 (addon-data: JustAC SpellCategories.lua [586]) |
| **Z** | Desperate Prayer | 19236 🟢 | Kleine defensive — 🟢 (addon-data: JustAC SpellCategories.lua [19236]) |
| **C** | Guardian Spirit | 47788 🟢 | Grote defensive (cheat death) — 🟢 (addon-data: ExwindCore ThingsToMantain [47788]) |
| **Shift+C** | Power Word: Shield | 17 🟢 | Defensive (extra, absorb) — 🟢 (addon-data: JustAC SpellCategories.lua [17]) |
| **V** | Psychic Scream | 8122 🟢 | CC (fear) — 🟢 (addon-data: JustAC InterruptAbilities.lua [8122]) |
| **Shift+V** | Purify | 527 🟢 | Dispel — 🟢 (addon-data: JustAC SpellCategories.lua [527]) |
| **F1** | Apotheosis | 200183 🟢 | Grote cooldown (reset Holy Words) — 🟢 (addon-data: JustAC SpellCategories.lua [200183]) |
| **Shift+F1** | Divine Hymn | 64843 🟢 | Grote cooldown (raid-heal) — 🟢 (addon-data: JustAC SpellCategories.lua [64843]) |
| **F** | Holy Word: Chastise | 88625 🟢 | Utility (damage/CC) — 🟢 (addon-data: JustAC SpellCategories.lua [88625]) |
| **R** | Power Infusion | 10060 🟢 | Utility (haste-cooldown) — 🟢 (addon-data: JustAC SpellCategories.lua [10060]) |
| **T** | Mass Dispel | 32375 🟢 | Utility — 🟢 (addon-data: ExwindCore ThingsToMantain [32375]) |
| **X** | Leap of Faith | 73325 🟢 | Utility (pull) — 🟢 (addon-data: JustAC SpellCategories.lua [73325]) |
| **F2** | Power Word: Life | 373481 🟡 | Utility (execute-heal-cooldown, <35%) — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **F3** | Symbol of Hope | 64901 🟢 | Utility (mana/CD-reductie) — 🟢 (addon-data: ExwindCore ThingsToMantain [64901]) |

**ST-heals (mouseover/Click Cast, niet op toetsen):** Flash Heal 2061 🟢 (staat hierboven ook als
"builder"-heal, mag ook puur mouseover), Heal 2060 🟢, Holy Word: Serenity 2050 🟢 (addon-data: JustAC SpellCategories.lua).

**⚠️ Onzeker/nog te dumpen:** Circle of Healing (204883) en Holy Word: Salvation (265202) kwamen
niet eenduidig voor in de gelezen actuele Midnight Holy-talentboom-pagina — mogelijk niet
(meer) standaard aanwezig. **Niet opgenomen in de tabel**, ⚠️ dumpen of navragen als je ze
wél getalenteerd ziet staan.

---

## 🌑 Shadow Priest

**Interrupt:** Shadow heeft wél een interrupt — **Silence**.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Shadow Word: Pain | 589 🟢 | Builder (DoT) — 🟢 (addon-data: JustAC SpellArchetypes.lua [589]) |
| **2** | Vampiric Touch | 34914 🟢 | Builder (DoT + self-heal) — 🟢 (addon-data: JustAC SpellArchetypes.lua [34914]) |
| **3** | Mind Blast | 8092 🟢 | Builder (Insanity-generator) — 🟢 (addon-data: JustAC SpellArchetypes.lua [8092]) |
| **4** | Shadow Word: Madness | 335467 🟢 | Spender (Insanity-finisher) — 🟢 (addon-data: JustAC SpellArchetypes.lua [335467]) |
| **5** | Shadow Word: Death | 32379 🟢 | Spender (execute) — 🟢 (addon-data: JustAC SpellArchetypes.lua [32379]) |
| **Shift+3** | Void Bolt / Void Volley | 1242173 🟢 | AoE/burst-tweeling (spender tijdens Voidform) — 🟢 (addon-data: JustAC SpellArchetypes.lua — "Void Volley") |
| **Shift+1** | Mind Flay | 15407 🟢 | AoE/filler-tweeling (channeled, Insanity-generator) — 🟢 (addon-data: JustAC SpellArchetypes.lua [15407]) |
| **E** | Silence | 15487 🟢 | Interrupt — 🟢 (addon-data: JustAC InterruptAbilities.lua [15487]) |
| **Q** | Fade | 586 🟢 | Movement (+ kleine DR via talent) — 🟢 (addon-data: JustAC SpellCategories.lua [586]) |
| **Z** | Desperate Prayer | 19236 🟢 | Kleine defensive — 🟢 (addon-data: JustAC SpellCategories.lua [19236]) |
| **C** | Dispersion | 47585 🟢 | Grote defensive (panic-button) — 🟢 (addon-data: JustAC SpellCategories.lua [47585]) |
| **V** | Psychic Scream | 8122 🟢 | CC (fear) — 🟢 (addon-data: JustAC InterruptAbilities.lua [8122]) |
| **Shift+V** | Shackle Horror | 9484 🟢 | Dispel/CC (extra) — 🟢 (addon-data: ExwindCore ThingsToMantain [9484]) |
| **F1** | Voidform | 194249 🟢 | Grote cooldown (burst, geeft Void Bolt-toegang) — 🟢 (addon-data: JustAC SpellArchetypes.lua + ExwindCore ExwindCDDB.lua — "Voidform") |
| **Shift+F1** | Void Torrent | 263165 🟢 | Grote cooldown (Voidweaver key talent) — 🟢 (addon-data: JustAC SpellArchetypes.lua [263165]) |
| **F** | Shadowfiend / Mindbender | 34433 🟢 / 200174 🟢 | Utility (pet/Insanity — Mindbender indien getalenteerd; 🟢 Shadowfiend: ExwindCore ThingsToMantain [34433]; 🟢 Mindbender: ExwindCore LibOpenRaid ThingsToMantain_Midnight.lua — "Mindbender" spec 258) |
| **R** | Power Infusion | 10060 🟢 | Utility (haste-cooldown) — 🟢 (addon-data: JustAC SpellCategories.lua [10060]) |
| **T** | Mass Dispel | 32375 🟢 | Utility — 🟢 (addon-data: ExwindCore ThingsToMantain [32375]) |
| **X** | Leap of Faith | 73325 🟢 | Utility (pull) — 🟢 (addon-data: JustAC SpellCategories.lua [73325]) |

**⚠️ Onzeker/nog te dumpen:**
- **Voidform** (F1): 🟢 bevestigd (JustAC SpellArchetypes.lua [194249]=Voidform, ExwindCore
  ExwindCDDB.lua [194249]="Voidform" class=5/spec 258). Kanttekening: 228260 is de *cast*-spell
  (Void Eruption) die de Voidform-buff 194249 geeft — JustAC SpellDB.lua mapt `[228260] = 194249`.
  Draft-ID 194249 (de buff/form) is dus correct.
- **Void Bolt/Void Volley** (Shift+3): 🟢 bevestigd (JustAC SpellArchetypes.lua [1242173]="Void
  Volley"). Kanttekening: het klassieke *Void Bolt* heeft in JustAC nog eigen ID's (205448/
  343355/1264177) — de draft gebruikt de Midnight-variant Void Volley 1242173, die klopt.
- **Mindbender** (F, indien getalenteerd i.p.v. Shadowfiend): 🟢 bevestigd (ExwindCore LibOpenRaid
  ThingsToMantain_Midnight.lua [200174] class="PRIEST" spec 258 = Mindbender). Draft-ID 200174
  correct; 123040 is een oudere variant, addon gebruikt 200174.
- **Halo** (niet in tabel opgenomen — AoE-damage-talent): twee tegenstrijdige web-ID's gezien
  (120644 vs 120517). Addon-data lost dit op: ExwindCore LibOpenRaid ThingsToMantain_Midnight.lua
  [120517] class="PRIEST" spec {256,257,258} = Halo, en JustAC SpellCategories.lua [120517] "Halo
  (heal)". Dus **120517** is de addon-bevestigde ID (🟢) — 120644 was de foute web-variant. Alleen
  relevant als je Halo speelt en een extra utility-slot (F2) nodig hebt.
- **Vampiric Embrace**: niet teruggevonden in de hoofdtekst van de actuele Shadow-abilities-
  pagina → mogelijk niet meer aanwezig, **niet opgenomen**, ⚠️ navragen/dumpen indien je hem
  wél in je spellbook ziet.

---

## 😈 Affliction Warlock

**Interrupt:** Warlock heeft geen eigen kick — interrupt loopt via de pet (Felhunter: Spell Lock).

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Agony | 980 🟢 | Builder (DoT, shard-generatie) — 🟢 (addon-data: JustAC SpellArchetypes.lua [980]) |
| **2** | Unstable Affliction | 316099 🟡 | Builder/spender (ST shard-spender, vaak on-CD) — 🟡 (geen addon bevat dit ID; web-onbevestigd) |
| **3** | Haunt | 48181 🟢 | Builder (cooldown-DoT, on cooldown) — 🟢 (addon-data: JustAC SpellArchetypes.lua [48181]) |
| **4** | Malefic Grasp | 1261149 🟡 | Spender (kanaal, dumpt shards) — 🟡 (geen addon bevat dit ID; JustAC heeft 1261153 voor variant — ⚠️ mogelijk fout, in-game dumpen) |
| **5** | Drain Soul | 388667 🟡 | Spender (ST-filler/execute) — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **Shift+1** | Seed of Corruption | 27243 🟢 | AoE-tweeling (spender) — 🟢 (addon-data: JustAC SpellArchetypes.lua [27243]) |
| **Shift+2** | Corruption / Wither | 172 🟢 / 445465 🟢 | AoE-tweeling (DoT — Wither bij Hellcaller) — 🟢 (addon-data: JustAC RangeReferences.lua [172] / SpellArchetypes.lua [445465]) |
| **Shift+5** | Dark Harvest | 1257052 🟢 | Burst-tweeling (~40s CD) — 🟢 (addon-data: ClassCodex Warlock\guide.lua {1257052}) |
| **E** | Spell Lock (Felhunter) | 19647 🟢 | Interrupt (via pet, Command Demon 212619 om te procen) — 🟢 (addon-data: BliZzi_Interrupts Core\Data.lua — "Spell Lock" spellID=19647; Command Demon 212619 🟢 JustAC SpellCategories.lua) |
| **Q** | Burning Rush | 111400 🟢 | Movement — 🟢 (addon-data: JustAC SpellCategories.lua [111400]) |
| **Shift+Q** | Demonic Circle: Teleport | 48020 🟡 | Movement (extra, teleport naar Circle 48018 🟡) — 🟡 (geen addon bevat 48020/48018; web-onbevestigd) |
| **Z** | Drain Life | 234153 🟢 | Kleine defensive — 🟢 (addon-data: JustAC SpellArchetypes.lua [234153]) |
| **Shift+Z** | Dark Pact | 108416 🟢 | Defensive (extra, hp-shield) — 🟢 (addon-data: JustAC SpellCategories.lua [108416]) |
| **C** | Unending Resolve | 104773 🟢 | Grote defensive (panic-button) — 🟢 (addon-data: JustAC SpellCategories.lua [104773]) |
| **V** | Fear | 5782 🟡 | CC — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **Shift+V** | Mortal Coil | 6789 🟢 | CC/heal (fear + 20% hp) — 🟢 (addon-data: JustAC SpellCategories.lua [6789]) |
| **F1** | Summon Darkglare | 205180 🟢 | Grote cooldown (burst) — 🟢 (addon-data: JustAC SpellDB.lua [205180]) |
| **Shift+F1** | Malevolence (Hellcaller) | 442726 🟢 | Grote cooldown (Hellcaller-specifiek) — 🟢 (addon-data: ClassCodex Warlock\guide.lua {442726}) |
| **F** | Healthstone | 6262 🟡 | Utility — 🟡 (geen addon bevat dit ID; web-onbevestigd) |
| **R** | Banish | 710 🟢 | Utility/CC — 🟢 (addon-data: JustAC SpellCategories.lua [710]) |
| **T** | Howl of Terror | 5484 🟢 | AoE-CC — 🟢 (addon-data: JustAC SpellCategories.lua [5484]) |
| **X** | Demonic Gateway | 111771 🟢 | Utility (raid-mobility) — 🟢 (addon-data: JustAC SpellCategories.lua [111771]) |
| **F2** | Soulstone | 693 🟡 (cast) | Utility (battle-res) — 🟡 (geen addon bevat dit ID; web-onbevestigd) |

**Spell Lock (19647):** 🟢 bevestigd via addon-data — BliZzi_Interrupts Core\Data.lua
(`spellID=19647, name="Spell Lock"`), ActionSounds InterruptDetector.lua ([19647]=Spell Lock).
Command Demon 212619 = "Call Felhunter" (Interrupt_CCAndCD_Tracker Spells.lua mapt
`[212619] = 19647`), consistent met draft.

---

## 😈 Demonology Warlock

**Interrupt:** via pet — Felguard heeft **Axe Toss**. Addon-data levert ID: **119914** (player-facing cast) / **89766** (pet-cast-event).

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Shadow Bolt | 686 🟢 | Builder (shard-generatie) — 🟢 (addon-data: JustAC SpellArchetypes.lua [686]) |
| **2** | Demonbolt | 264178 🟢 | Builder (met Demonic Core-procs) — 🟢 (addon-data: JustAC SpellArchetypes.lua [264178]) |
| **3** | Call Dreadstalkers | 104316 🟢 | Builder (cooldown, kern van rotatie) — 🟢 (addon-data: JustAC SpellArchetypes.lua [104316]) |
| **4** | Hand of Gul'dan | 105174 🟢 | Spender (shard-spender) — 🟢 (addon-data: JustAC SpellArchetypes.lua [105174]) |
| **5** | Summon Vilefiend | 1251778 🟡 ⚠️ | Spender/cooldown-pet — ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft **264119** voor "Summon Vilefiend"; draft-ID 1251778 vermoedelijk fout → in-game dumpen) |
| **Shift+4** | Implosion | 196277 🟢 | AoE-tweeling (Imp-consumptie, cap 6) — 🟢 (addon-data: JustAC SpellArchetypes.lua [196277]) |
| **Shift+3** | Power Siphon | 264130 🟢 | Builder-support-tweeling (indien Inner Demons) — 🟢 (addon-data: ClassCodex Warlock\guide.lua {264130}) |
| **E** | Axe Toss (Felguard) | 119914 🟢 (player-facing) / 89766 (pet-cast) | Interrupt (via pet) — 🟢 (addon-data: BliZzi_Interrupts Core\Data.lua — "Axe Toss" spellID=119914; ActionSounds InterruptDetector.lua [119914]=Axe Toss, [89766]=Axe Toss pet cast) |
| **Q** | Burning Rush | 111400 🟢 | Movement — 🟢 (addon-data: JustAC SpellCategories.lua [111400]) |
| **Shift+Q** | Demonic Circle: Teleport | 48020 🟡 | Movement (extra) — 🟡 (geen addon bevat dit ID; web-onbevestigd) |
| **Z** | Drain Life | 234153 🟢 | Kleine defensive — 🟢 (addon-data: JustAC SpellArchetypes.lua [234153]) |
| **Shift+Z** | Dark Pact | 108416 🟢 | Defensive (extra) — 🟢 (addon-data: JustAC SpellCategories.lua [108416]) |
| **C** | Unending Resolve | 104773 🟢 | Grote defensive (panic-button) — 🟢 (addon-data: JustAC SpellCategories.lua [104773]) |
| **V** | Fear | 5782 🟡 | CC — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **Shift+V** | Mortal Coil | 6789 🟢 | CC/heal — 🟢 (addon-data: JustAC SpellCategories.lua [6789]) |
| **F1** | Summon Demonic Tyrant | 265187 🟢 | Grote cooldown (burst, kern-cooldown) — 🟢 (addon-data: JustAC SpellDB.lua [265187]) |
| **F** | Healthstone | 6262 🟡 | Utility — 🟡 (geen addon bevat dit ID; web-onbevestigd) |
| **R** | Banish | 710 🟢 | Utility/CC — 🟢 (addon-data: JustAC SpellCategories.lua [710]) |
| **T** | Doom | 460551 🟡 ⚠️ | AoE-DoT (talent-afhankelijk) — ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft **460555** met commentaar "Doom" — 1 cijfer verschil met draft-ID 460551; niet class-specifiek gelabeld, dus draft-ID vermoedelijk fout of variant → in-game dumpen) |
| **X** | Demonic Gateway | 111771 🟢 | Utility (raid-mobility) — 🟢 (addon-data: JustAC SpellCategories.lua [111771]) |
| **F2** | Soulstone | 693 🟡 (cast) | Utility (battle-res) — 🟡 (geen addon bevat dit ID; web-onbevestigd) |

**⚠️ Onzeker/nog te dumpen:**
- **Axe Toss** (E, interrupt): 🟢 addon-data gevonden — **119914** (player-facing Axe Toss) en
  **89766** (Felguard pet-cast-event). Bronnen: BliZzi_Interrupts Core\Data.lua (spellID=119914,
  name="Axe Toss"; mapt `[89766] = 119914`), ActionSounds InterruptDetector.lua, ExwindCore
  LibOpenRaid. Voor een keybind/macro is **119914** de player-facing ID. Nog wél in-game te
  bevestigen (✅ voorbehouden) maar niet langer "onbekend".
- **Summon Vilefiend** (5): 🟡→⚠️ draft-ID **1251778** niet gevonden in addons. JustAC
  SpellArchetypes.lua heeft wél **264119** ("Summon Vilefiend"). Draft-ID vermoedelijk fout →
  in-game dumpen.
- **Demonic Circle voor Demonology**: 48018/48020 zijn **niet** in de addon-data teruggevonden
  (blijven 🟡, web-only). Eén bron noemde bovendien 268358 i.p.v. 48018 — mogelijk guide-
  inconsistentie. Tabel houdt 48018/48020 aan (web-bron), maar géén addon bevestigt ze → in-game
  dumpen. 268358 **niet gebruikt** totdat bevestigd.
- **Doom** (T): ⚠️ draft-ID **460551** niet gevonden in addons. JustAC SpellArchetypes.lua heeft
  wél **460555** ("Doom") — 1 cijfer verschil, niet class-specifiek gelabeld. Draft-ID vermoedelijk
  fout (typo?) of een variant → in-game dumpen. Alleen relevant als getalenteerd.

---

## 😈 Destruction Warlock

**Interrupt:** via pet — meestal Felhunter (Spell Lock), zelfde als Affliction.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Incinerate | 29722 🟢 | Builder/filler — 🟢 (addon-data: JustAC SpellArchetypes.lua [29722]) |
| **2** | Immolate / Wither | 348 🟢 / 445465 🟢 | Builder (DoT — Wither bij Hellcaller) — 🟢 (addon-data: JustAC SpellArchetypes.lua [348] / [445465]) |
| **3** | Conflagrate | 17962 🟢 | Builder (charges) — 🟢 (addon-data: JustAC SpellArchetypes.lua [17962]) |
| **4** | Chaos Bolt | 116858 🟢 | Spender (hoofdspender) — 🟢 (addon-data: JustAC SpellArchetypes.lua [116858]) |
| **5** | Shadowburn | 17877 🟢 | Spender (execute, shard-efficiënt) — 🟢 (addon-data: JustAC SpellArchetypes.lua [17877]) |
| **Shift+1** | Rain of Fire | 5740 🟢 | AoE-tweeling (spender) — 🟢 (addon-data: JustAC SpellArchetypes.lua [5740]) |
| **Shift+2** | Havoc | 80240 🟡 | AoE/cleave-tweeling (talent) — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **Shift+3** | Soulfire | 265321 🟡 | Builder/pre-cast-tweeling (mini-cooldown) — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **E** | Spell Lock (Felhunter) | 19647 🟢 | Interrupt (via pet) — 🟢 (addon-data: BliZzi_Interrupts Core\Data.lua — "Spell Lock" spellID=19647) |
| **Q** | Burning Rush | 111400 🟢 | Movement — 🟢 (addon-data: JustAC SpellCategories.lua [111400]) |
| **Shift+Q** | Demonic Circle: Teleport | 48020 🟡 | Movement (extra) — 🟡 (geen addon bevat dit ID; web-onbevestigd) |
| **Z** | Drain Life | 234153 🟢 | Kleine defensive — 🟢 (addon-data: JustAC SpellArchetypes.lua [234153]) |
| **Shift+Z** | Dark Pact | 108416 🟢 | Defensive (extra) — 🟢 (addon-data: JustAC SpellCategories.lua [108416]) |
| **C** | Unending Resolve | 104773 🟢 | Grote defensive (panic-button) — 🟢 (addon-data: JustAC SpellCategories.lua [104773]) |
| **V** | Fear | 5782 🟡 | CC — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **F1** | Summon Infernal | 1122 🟢 | Grote cooldown (hoofdcooldown) — 🟢 (addon-data: JustAC SpellDB.lua [1122]) |
| **Shift+F1** | Malevolence (Hellcaller) | 430014 🟢 | Grote cooldown (Hellcaller-specifiek, ander ID dan Affliction's) — 🟢 (addon-data: ClassCodex Warlock\guide.lua {430014}) |
| **F** | Healthstone | 6262 🟡 | Utility — 🟡 (geen addon bevat dit ID; web-onbevestigd) |
| **R** | Banish | 710 🟢 | Utility/CC — 🟢 (addon-data: JustAC SpellCategories.lua [710]) |
| **T** | Diabolic Ritual (Diabolist) | 428514 🟡 | Cooldown-systeem (indien Diabolist-tree) — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **X** | Demonic Gateway | 111771 🟢 | Utility (raid-mobility) — 🟢 (addon-data: JustAC SpellCategories.lua [111771]) |
| **F2** | Soulstone | 693 🟡 (cast) | Utility (battle-res) — 🟡 (geen addon bevat dit ID; web-onbevestigd) |

**Spell Lock (19647):** 🟢 bevestigd via addon-data (BliZzi_Interrupts Core\Data.lua), zelfde als Affliction.

---

## 🔮 Arcane Mage

Ankers gedeeld met Frost (zelfde class tree): E=Counterspell 2139 🟢, Q=Blink 1953 🟢
(of Shimmer 212653 🟢), C=Ice Block 45438 🟢, V=Frost Nova 122 🟢, Shift+V=Remove Curse 475 🟢
(addon-data: JustAC SpellCategories.lua + Interrupt_CCAndCD_Tracker). **Let op:** Mass Barrier is
in Midnight volledig verwijderd (niet meer beschikbaar als groepsdefensive) — bevestigd via
meerdere bronnen.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Arcane Blast | 30451 🟢 | Builder (ST-filler) — 🟢 (addon-data: JustAC SpellArchetypes.lua [30451]) |
| **2** | Arcane Orb | 153626 🟢 | Builder (Spellslinger/Orb Mastery) — 🟢 (addon-data: JustAC SpellArchetypes.lua [153626]) |
| **3** | Arcane Missiles | 5143 🟡 | Builder (Clearcasting-proc) — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **4** | Arcane Barrage | 44425 🟢 | Spender (dumpt Arcane Charges) — 🟢 (addon-data: JustAC SpellArchetypes.lua [44425]) |
| **Shift+1** | Arcane Explosion | 1449 🟢 | AoE-tweeling (baseline) — 🟢 (addon-data: JustAC SpellArchetypes.lua [1449]) |
| **Shift+2** | Arcane Pulse | 1243460 🟢 | AoE-tweeling (talent, vervangt Explosion) — 🟢 (addon-data: JustAC SpellArchetypes.lua — "Arcane Pulse"; ClassCodex Mage guide.lua) |
| **E** | Counterspell | 2139 🟢 | Interrupt — 🟢 (addon-data: JustAC SpellCategories.lua [2139]) |
| **Q** | Blink | 1953 🟢 | Movement — 🟢 (addon-data: JustAC SpellCategories.lua [1953]) |
| **Shift+Q** | Shimmer | 212653 🟢 | Movement (extra) — 🟢 (addon-data: JustAC SpellCategories.lua [212653]) |
| **Z** | Prismatic Barrier | 235450 🟢 | Kleine defensive (Arcane's eigen barrier) — 🟢 (addon-data: JustAC/Interrupt_CCAndCD_Tracker [235450]) |
| **C** | Ice Block | 45438 🟢 | Grote defensive (immune) — 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua [45438]) |
| **V** | Frost Nova | 122 🟢 | CC (root) — 🟢 (addon-data: JustAC SpellArchetypes.lua [122]) |
| **Shift+V** | Remove Curse | 475 🟢 | Dispel (curse) — 🟢 (addon-data: JustAC SpellCategories.lua [475]) |
| **F1** | Arcane Surge | 365350 🟢 | Grote cooldown (burst) — 🟢 (addon-data: JustAC SpellArchetypes.lua [365350]) |
| **Shift+F1** | Touch of the Magi | 321507 🟢 | Grote cooldown (bread & butter) — 🟢 (addon-data: JustAC SpellArchetypes.lua [321507]) |
| **F** | Spellsteal | 30449 🟢 | Utility (purge/steal) — 🟢 (addon-data: JustAC SpellCategories.lua [30449]) |
| **R** | Presence of Mind | 205025 🟢 | Utility (instant Arcane Blast) — 🟢 (addon-data: ClassCodex Mage guide.lua {205025}) |
| **T** | Evocation | 12051 🟢 | Utility (manaherstel) — 🟢 (addon-data: ExwindCore ThingsToMantain_Midnight.lua [12051] MAGE; ClassCodex guide.lua {12051}) |
| **X** | Dragon's Breath | 31661 🟡 | CC (extra, disorient — talent-keuze t.o.v. Supernova) — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **F2** | Mirror Image | 55342 🟢 | Utility — 🟢 (addon-data: BliZzi_Interrupts [55342]) |

**Arcane Pulse (1243460):** 🟢 bevestigd via addon-data (JustAC SpellArchetypes.lua
[1243460]="Arcane Pulse"; ClassCodex Data\Mage\guide.lua verwijst herhaaldelijk naar {1243460}).
Alleen relevant als je die AoE-talent speelt i.p.v. baseline Arcane Explosion.

---

## 🔥 Fire Mage

Ankers gedeeld met Frost/Arcane: E=Counterspell 2139 🟢, Q=Blink 1953 🟢, C=Ice Block 45438 🟢,
V=Frost Nova 122 🟢, Shift+V=Remove Curse 475 🟢 (addon-data: JustAC SpellCategories.lua +
Interrupt_CCAndCD_Tracker).

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Fireball | 133 🟢 | Builder (ST-filler) — 🟢 (addon-data: JustAC SpellArchetypes.lua [133]) |
| **2** | Fire Blast | 319836 🟢 (baseline) / 108853 🟢 (getalenteerd) | Builder (Heating Up → Hot Streak) — 🟢 (addon-data: JustAC SpellArchetypes.lua [319836] / [108853]) |
| **3** | Scorch | 2948 🟢 | Builder/execute-filler (<30%, ook mobility-cast) — 🟢 (addon-data: JustAC SpellArchetypes.lua [2948]) |
| **4** | Pyroblast | 11366 🟡 | Spender (bij Hot Streak) — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **Shift+4** | Flamestrike | 2120 🟢 | AoE-tweeling (spender, 4+ targets) — 🟢 (addon-data: JustAC SpellArchetypes.lua [2120]) |
| **E** | Counterspell | 2139 🟢 | Interrupt — 🟢 (addon-data: JustAC SpellCategories.lua [2139]) |
| **Q** | Blink | 1953 🟢 | Movement — 🟢 (addon-data: JustAC SpellCategories.lua [1953]) |
| **Shift+Q** | Shimmer | 212653 🟢 | Movement (extra) — 🟢 (addon-data: JustAC SpellCategories.lua [212653]) |
| **Z** | Blazing Barrier | 235313 🟢 | Kleine defensive (Fire's eigen barrier) — 🟢 (addon-data: ExwindCore ThingsToMantain [235313]) |
| **C** | Ice Block | 45438 🟢 | Grote defensive (immune) — 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua [45438]) |
| **Shift+C** | Cauterize | 86949 🟡 | Defensive (extra, talent — cheat death) — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **V** | Frost Nova | 122 🟢 | CC (root) — 🟢 (addon-data: JustAC SpellArchetypes.lua [122]) |
| **Shift+V** | Remove Curse | 475 🟢 | Dispel (curse) — 🟢 (addon-data: JustAC SpellCategories.lua [475]) |
| **F1** | Combustion | 190319 🟢 | Grote cooldown (enige major cooldown) — 🟢 (addon-data: JustAC SpellDB.lua MAGE_2 {190319}) |
| **Shift+F1** | Meteor | 153561 🟢 | Grote cooldown (AoE-burst, samen met Combustion) — 🟢 (addon-data: ClassCodex Mage guide.lua {153561}) |
| **F** | Spellsteal | 30449 🟢 | Utility (purge/steal) — 🟢 (addon-data: JustAC SpellCategories.lua [30449]) |
| **R** | Time Warp | 80353 🟢 | Utility (raid-haste, Bloodlust-variant) — 🟢 (addon-data: JustAC SpellCategories.lua [80353]) |
| **T** | Dragon's Breath | 31661 🟡 | CC (disorient) — 🟡 (geen addon bevat dit ID; web-onbevestigd, in-game dumpen) |
| **F2** | Mirror Image | 55342 🟢 | Utility — 🟢 (addon-data: BliZzi_Interrupts [55342]) |

**⚠️ Onzeker/nog te dumpen:** Fire Blast heeft twee ID's in omloop (319836 baseline / 108853
getalenteerd) — in-game tooltip toont normaliter één actieve versie afhankelijk van talentkeuze;
dump beide om te zien welke jouw addon ziet.

---

## Samenvatting onzekerheden (alle 8 specs)

> **Volledige addon-cross-check uitgevoerd (2026-07-02):** de vroegere ✅-labels waren onterecht
> (nooit in-game bevestigd) en zijn allemaal teruggezet naar 🟡; vervolgens is **elk** draft-ID
> gekruist met de 8 addon-spell-tabellen (ClassCodex, JustAC, CDPulse, CooldownCompanion,
> Interrupt_CCAndCD_Tracker, BliZzi_Interrupts, TargetedSpells, MissingClassBuff — plus
> ExwindCore/LibOpenRaid & ActionSounds). 🟢 = een addon bevat de draft-ID mét matchende naam
> (bron per regel vermeld). 🟡 = geen addon bevat het ID (web-only). ⚠️ = addon heeft een ander ID
> voor dezelfde naam (draft vermoedelijk fout). **Er staat geen enkele ✅ meer in dit doc** — ✅
> blijft strikt voorbehouden aan in-game bevestiging door Rob/Cisca.

| Spec | ⚠️ vermoedelijk foute ID (addon-ID) | 🟡 zonder addon-data (blijft web-only) | 🟢 addon-bevestigd |
|------|------------------------|-----------------------|--------------------|
| Discipline Priest | — | — | alle 21 tabel-ID's |
| Holy Priest | — | Power Word: Life 373481 | alle overige (22) |
| Shadow Priest | — | — | alle tabel-ID's (incl. Voidform 194249, Void Volley 1242173, Mindbender 200174) |
| Affliction Warlock | Malefic Grasp 1261149 (JustAC heeft 1261153) | Unstable Affliction 316099, Drain Soul 388667, Demonic Circle:TP 48020/48018, Fear 5782, Healthstone 6262, Soulstone 693 | Spell Lock 19647 + rest |
| Demonology Warlock | Summon Vilefiend 1251778 (addon 264119), Doom 460551 (addon 460555) | Demonic Circle:TP 48020, Fear 5782, Healthstone 6262, Soulstone 693 | Axe Toss 119914 + rest |
| Destruction Warlock | — | Havoc 80240, Soulfire 265321, Demonic Circle:TP 48020, Fear 5782, Healthstone 6262, Soulstone 693, Diabolic Ritual 428514 | Spell Lock 19647 + rest |
| Arcane Mage | — | Arcane Missiles 5143, Dragon's Breath 31661 | Arcane Pulse 1243460 + rest |
| Fire Mage | — | Pyroblast 11366, Cauterize 86949, Dragon's Breath 31661 | Fire Blast 319836/108853 + rest |

**Totaal na volledige cross-check:** alle vroegere ✅ (~186 stuks) → 🟡 teruggezet, daarna gekruist.
Ruwweg **~70 ID's opgewaardeerd naar 🟢** (met bron per regel). **3 vermoedelijk foute ID's (⚠️):**
Summon Vilefiend 1251778 (addon 264119), Doom 460551 (addon 460555), Malefic Grasp 1261149 (addon-
variant 1261153). **~22 ID's blijven 🟡** (geen addon-dekking — vooral pure builders/spenders,
Fear/Healthstone/Soulstone en de Demonic-Circle-familie; verwacht, die staan zelden in de
gedekte categorieën interrupt/dispel/defensive/cooldown/raid-buff). Niet-in-tabel-⚠️-gevallen:
Void Shield (Disc, ID wisselt per bron — blijft ⚠️), Circle of Healing / HW: Salvation (Holy, niet
opgenomen), Vampiric Embrace (Shadow, niet opgenomen). **Halo** (Shadow, niet in tabel) is nu wél
addon-bevestigd: 120517 (ExwindCore Midnight PRIEST + JustAC). ✅ blijft voorbehouden aan in-game
bevestiging door Rob/Cisca — daarom staat er hier nergens ✅.

---

## Bronnen (research, alle 8 specs)

**Priest:**
- https://www.wowhead.com/guide/classes/priest/shadow/abilities-talents-pve-dps
- https://www.wowhead.com/guide/classes/priest/discipline/abilities-talents-pve-healer
- https://www.wowhead.com/guide/classes/priest/holy/abilities-talents-pve-healer
- https://www.wowhead.com/guide/classes/priest/holy/rotation-cooldowns-pve-healer
- https://www.wowhead.com/guide/classes/priest/discipline/talent-builds-pve-healer
- https://www.icy-veins.com/wow/discipline-priest-pve-healing-rotation-cooldowns-abilities
- https://www.icy-veins.com/wow/shadow-priest-pve-dps-spell-summary
- https://www.icy-veins.com/wow/discipline-priest-pve-healing-spec-builds-talents
- https://www.icy-veins.com/wow/holy-priest-pve-healing-spec-builds-talents
- https://www.method.gg/guides/discipline-priest
- https://www.method.gg/guides/holy-priest
- https://www.wowhead.com/spell=47536/rapture
- https://www.wowhead.com/spell=62618/power-word-barrier
- https://www.wowhead.com/spell=1253828/void-shield
- https://wowcarry.com/blog/wow/key-interrupts-in-midnight-season-1-mythic
- https://us.forums.blizzard.com/en/wow/t/can-priests-get-access-to-an-interrupt-in-midnight-pretty-please/2157066

**Warlock:**
- https://www.method.gg/guides/affliction-warlock/talents
- https://www.method.gg/guides/affliction-warlock/playstyle-and-rotation
- https://www.method.gg/guides/demonology-warlock/talents
- https://www.method.gg/guides/demonology-warlock/playstyle-and-rotation
- https://www.method.gg/guides/destruction-warlock/talents
- https://www.method.gg/guides/destruction-warlock/playstyle-and-rotation
- https://www.icy-veins.com/wow/demonology-warlock-pve-dps-spec-builds-talents
- https://www.icy-veins.com/wow/midnight-expansion-guide
- Diverse https://www.wowhead.com/spell=NUMMER losse spell-pagina's (Fear, Banish, Curse of
  Tongues/Weakness, pet-summons, etc. — zie individuele ID's hierboven)

**Mage:**
- https://www.wowhead.com/guide/classes/mage/arcane/abilities-talents-pve-dps
- https://www.wowhead.com/guide/classes/mage/fire/abilities-talents-pve-dps
- https://www.wowhead.com/guide/classes/mage/fire/rotation-cooldowns-pve-dps
- https://www.wowhead.com/guide/classes/mage/arcane/rotation-cooldowns-pve-dps
- https://www.wowhead.com/guide/classes/mage/arcane/talent-builds-pve-dps
- https://www.wowhead.com/guide/classes/mage/fire/talent-builds-pve-dps
- https://www.icy-veins.com/wow/arcane-mage-pve-dps-rotation-cooldowns-abilities
- https://www.icy-veins.com/wow/fire-mage-pve-dps-rotation-cooldowns-abilities

---

## Volgende stap

Zelfde als bij Frost/Enhancement: dit is een **concept**, klaar voor Rob/Cisca om in-game te
bevestigen (tooltips dumpen, vooral de ⚠️- en 🟡-regels). Daarna pas encoderen in
`Modules/KeybindingData.lua` — en ook daar geldt de openstaande vraag of het datamodel al
generiek genoeg is voor Priest/Warlock/Mage of dat er (net als bij Mage/Shaman) een kleine
generalisatie nodig is. Geen bestanden buiten dit concept-document zijn aangepast.
