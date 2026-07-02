# Keybind-maps (v6 toegepast, CONCEPT) — Warrior, Death Knight, Demon Hunter, Evoker

> ⚠️ **Update 2026-07-02 (ná dit draft):** F2/F3/F4 zijn **heal-ankers** geworden
> (F2 = snelle combat-heal, F3 = out-of-combat-heal, F4 = recuperate/HoT). Utility-slots
> zijn nu F/R/T/X + overflow. Alle F2–F4-toewijzingen hieronder herzien bij het encoderen.

Standaard: `docs/KEYBIND_STANDARD_v6.md`. Kit + spell-ID's: web-research (Wowhead/Icy Veins/Method,
Midnight 12.0.5–12.0.7, juli 2026). **Dit is een DRAFT — nog NIET in-game bevestigd.**

**Labels:** 🟡 = web-bron gevonden maar onbevestigd (in-game dumpen om te bevestigen) ·
⚠️ = ID onbekend — in-game dumpen. Er staat hier bewust **geen ✅** — dat label is voorbehouden
aan specs die Rob/Cisca al met eigen tooltips hebben gecheckt (zie `KEYBIND_MAP_frost-mage_enh-shaman.md`).
Deze 11 specs zijn dat nog niet.

Ankers (alle specs, verplaatsen nooit): **E**=interrupt · **Q**=movement · **Z**=kleine def ·
**C**=grote def · **V**=dispel/CC · **F1**=grote cooldown · **Shift+E**=racial · **Ctrl+F1**=trinket ·
**Alt+C**=potion. Racial/trinket/potion zijn generiek en worden hieronder niet per spec herhaald.
Overflow = zelfde toets, volgende modifier (**Shift→Ctrl→Alt**). Geen G. AoE = Shift-tweeling van
de bijbehorende ST-knop.

---

## ⚔️ Warrior — Arms

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Mortal Strike | 12294 🟢 (addon-data: JustAC SpellArchetypes.lua — "Mortal Strike"; ClassCodex Warrior/guide.lua) | Builder (kernrotatie) |
| **2** | Overpower | 7384 🟢 (addon-data: JustAC SpellArchetypes.lua — "Overpower"; ClassCodex guide.lua) | Builder |
| **3** | Rend | 772 🟢 (addon-data: JustAC SpellArchetypes.lua — "Rend"; ClassCodex guide.lua) | Builder (DoT) |
| **4** | Execute | 163201 🟢 (addon-data: ClassCodex Warrior/guide.lua — "{163201}") | Spender (execute-fase) |
| **5** | Slam | 1464 🟢 (addon-data: JustAC SpellArchetypes.lua — "Slam"; ClassCodex guide.lua) | Spender (filler) |
| **Shift+1** | Sweeping Strikes | 260708 🟢 (addon-data: ClassCodex Warrior/guide.lua — "{260708}") | AoE (Shift-tweeling van Mortal Strike) |
| **Shift+4** | Cleave | 845 🟢 (addon-data: JustAC SpellArchetypes.lua — "Cleave"; ClassCodex guide.lua) | AoE (Shift-tweeling van Execute) |
| **E** | Pummel | 6552 🟢 (addon-data: JustAC InterruptAbilities.lua — "Pummel"; BliZzi_Interrupts, Interrupt_CCAndCD_Tracker) | Interrupt |
| **Q** | Heroic Leap | 6544 🟢 (addon-data: JustAC SpellDB.lua WARRIOR_1 = {100, 6544}) | Movement |
| **Shift+Q** | Charge | 100 🟢 (addon-data: JustAC SpellDB.lua WARRIOR_1; ClassCodex guide.lua) | Movement (extra gap-closer) |
| **Z** | Ignore Pain | 190456 🟢 (addon-data: JustAC SpellCategories.lua — "Ignore Pain"; ClassCodex guide.lua) | Kleine defensive |
| **C** | Die by the Sword | 118038 🟢 (addon-data: JustAC, BliZzi_Interrupts, ExwindCore/LibOpenRaid — draft-ID 236385 was fout, 118038 bevestigd in 6+ bronnen incl. Midnight-specifiek bestand) | Grote defensive (talent-alt. van Ignore Pain-tweede) |
| **Shift+C** | Spell Reflection | 23920 🟢 (addon-data: JustAC SpellCategories.lua — "Spell Reflection"; Interrupt_CCAndCD_Tracker) | Defensive (extra) |
| **V** | Intimidating Shout | 5246 🟢 (addon-data: JustAC InterruptAbilities.lua — "Intimidating Shout") | CC |
| **Shift+V** | Berserker Rage | 18499 🟡 | CC-immuniteit — *geen addon-data* |
| **F1** | Colossus Smash | 167105 🟢 (addon-data: JustAC SpellArchetypes.lua — "Colossus Smash"; ClassCodex guide.lua) | Grote cooldown (burst-opener) |
| **Shift+F1** | Avatar | 107574 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua; ClassCodex guide.lua) | Major cooldown (extra) |
| **Ctrl+F1** *(let op)* | Bladestorm / Ravager / Demolish (hero-tree-afhankelijk) | 227847 🟢 (ClassCodex guide.lua) / 228920 🟢 (JustAC SpellArchetypes.lua — "Ravager") / 436358 🟢 (ClassCodex guide.lua) | Major cooldown — **conflicteert met trinket-anker, in-game herzien** |
| **F** | Battle Shout | 6673 🟢 (addon-data: MissingClassBuff Data.lua — "Battle Shout") | Utility (raid-buff) |
| **R** | Victory Rush / Impending Victory | 34428 🟢 (JustAC SpellCategories.lua — "Victory Rush") / 202168 🟢 (JustAC SpellCategories.lua — "Impending Victory") | Utility (heal-filler, talent-afhankelijk) |
| **T** | Hamstring | 1715 🟢 (addon-data: JustAC SpellArchetypes.lua — "Hamstring") | Utility (slow) |
| **X** | Rallying Cry | 97462 🟢 (addon-data: JustAC SpellCategories.lua — "Rallying Cry") | Utility (groeps-defensive) |
| **F2** | Wrecking Throw | 384110 ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft 394354 voor "Wrecking Throw", niet 384110 — draft-ID vermoedelijk fout) | Utility (anti-shield/immuniteit) |
| **F3** | Storm Bolt | 132169 🟢 (addon-data: JustAC SpellCategories.lua — "Storm Bolt") | Utility/CC (talent, Slayer) |

~23 binds. **Let op:** Ctrl+F1 wordt hier tijdelijk gebruikt voor de derde major-CD (Bladestorm/
Ravager/Demolish) omdat die slot normaal het trinket-anker is — bij het coderen in
`KeybindingData.lua` heroverwegen (evt. naar Shift+C of eigen slot, trinket blijft Ctrl+F1).
🟢 **Challenging Shout = 1161 / Disrupting Shout = 386071** (addon-data: ExwindCore/LibOpenRaid
`ThingsToMantain_Midnight.lua`) — **maar beide zijn Protection-only** (specs={73} in de bron, geen
Arms-vermelding). Voor Arms dus geen losse knop; dit bevestigt het vermoeden dat ze niet meer
bij Arms horen, i.p.v. onbekend-ID.

---

## ⚔️ Warrior — Fury

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Bloodthirst | 23881 🟢 (addon-data: JustAC SpellArchetypes.lua — "Bloodthirst"; RangeReferences.lua) | Builder (kernrotatie) |
| **2** | Raging Blow | 85288 🟢 (addon-data: JustAC RangeReferences.lua — "Raging Blow") | Builder |
| **3** | Rampage | 184367 🟢 (addon-data: ClassCodex Warrior/guide.lua — "{184367}") | Builder/Spender (Enrage-trigger) |
| **4** | Execute | 163201 🟢 (addon-data: ClassCodex Warrior/guide.lua) | Spender (execute-fase) |
| **Shift+1** | Whirlwind | 190411 🟢 (addon-data: ClassCodex Warrior/guide.lua — "{190411}") | AoE (Shift-tweeling van Bloodthirst) |
| **Shift+3** | Thunder Clap | 6343 🟢 (addon-data: JustAC SpellArchetypes.lua — "Thunder Clap"; CooldownCompanion; ClassCodex) | AoE-builder (Mountain Thane) |
| **Shift+4** | Thunder Blast | 435607 🟢 (addon-data: ClassCodex Warrior/guide.lua — "{435607}") | AoE-spender (Mountain Thane, proc) |
| **E** | Pummel | 6552 🟢 (addon-data: JustAC InterruptAbilities.lua; BliZzi_Interrupts) | Interrupt |
| **Q** | Heroic Leap | 6544 🟢 (addon-data: JustAC SpellDB.lua WARRIOR_1) | Movement |
| **Shift+Q** | Charge | 100 🟢 (addon-data: JustAC SpellDB.lua; ClassCodex guide.lua) | Movement (extra gap-closer) |
| **Z** | Enraged Regeneration | 184364 🟢 (addon-data: JustAC SpellCategories.lua — "Enraged Regeneration"; Interrupt_CCAndCD_Tracker) | Kleine defensive |
| **C** | Spell Reflection | 23920 🟢 (addon-data: JustAC SpellCategories.lua; Interrupt_CCAndCD_Tracker) | Grote defensive (enige beschikbaar) |
| **V** | Intimidating Shout | 5246 🟢 (addon-data: JustAC InterruptAbilities.lua) | CC |
| **Shift+V** | Berserker Rage | 18499 🟡 | CC-immuniteit — *geen addon-data* |
| **F1** | Recklessness | 1719 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua — cat="Ofensivos", spec=72) | Grote cooldown (burst) |
| **Shift+F1** | Avatar | 107574 🟢 (addon-data: Interrupt_CCAndCD_Tracker; ClassCodex guide.lua) | Major cooldown (extra) |
| **Ctrl+F1** *(let op, zie Arms)* | Bladestorm | 227847 🟢 (addon-data: ClassCodex Warrior/guide.lua) | Major cooldown (Slayer) |
| **F** | Battle Shout | 6673 🟢 (addon-data: MissingClassBuff Data.lua) | Utility (raid-buff) |
| **R** | Victory Rush / Impending Victory | 34428 🟢 / 202168 🟢 (addon-data: JustAC SpellCategories.lua) | Utility (heal-filler) |
| **T** | Hamstring | 1715 🟢 (addon-data: JustAC SpellArchetypes.lua) | Utility (slow) |
| **X** | Rallying Cry | 97462 🟢 (addon-data: JustAC SpellCategories.lua) | Utility (groeps-defensive) |
| **F2** | Wrecking Throw | 384110 ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft 394354 voor "Wrecking Throw", niet 384110 — draft-ID vermoedelijk fout) | Utility (anti-shield) |
| **F3** | Odyn's Fury | 205545 ⚠️ (addon-data: JustAC gebruikt 205546 en 385060-reeks voor "Odyn's Fury", niet 205545 — draft-ID vermoedelijk fout) | Major cooldown (extra, indien getalenteerd) |
| **F4** | Storm Bolt | 132169 🟢 (addon-data: JustAC SpellCategories.lua — "Storm Bolt") | Utility/CC (talent) |

~23 binds. Fury heeft maar één "grote" defensive (Spell Reflection) — geen aparte Z/C-split zoals
andere specs; Enraged Regeneration op Z als self-heal-vangnet. Zelfde Ctrl+F1-kanttekening als Arms.

---

## 🛡️ Warrior — Protection

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Shield Slam | 23922 🟢 (addon-data: JustAC SpellArchetypes.lua — "Shield Slam"; RangeReferences.lua; ClassCodex guide.lua) | Builder (kernrotatie) |
| **2** | Revenge | 6572 🟢 (addon-data: JustAC SpellArchetypes.lua — "Revenge"; RangeReferences.lua; ClassCodex guide.lua) | Builder |
| **3** | Thunder Clap | 6343 🟢 (addon-data: JustAC SpellArchetypes.lua; CooldownCompanion; ClassCodex) | Builder (AoE-hoofdknop, staat ook op Shift-tweeling) |
| **4** | Execute | 163201 🟢 (addon-data: ClassCodex Warrior/guide.lua) | Spender (execute-fase) |
| **Shift+1** | Demoralizing Shout | 1160 🟡 | AoE / rage-generator — *geen addon-data* |
| **Shift+3** | Thunder Blast | 435607 🟢 (addon-data: ClassCodex Warrior/guide.lua) | AoE-spender (Mountain Thane, proc; Shift-tweeling van Thunder Clap) |
| **E** | Pummel | 6552 🟢 (addon-data: JustAC InterruptAbilities.lua; BliZzi_Interrupts) | Interrupt |
| **Q** | Heroic Leap | 6544 🟢 (addon-data: JustAC SpellDB.lua WARRIOR_1) | Movement |
| **Shift+Q** | Charge | 100 🟢 (addon-data: JustAC SpellDB.lua; ClassCodex guide.lua) | Movement (extra) |
| **Ctrl+Q** | Shield Charge | 385952 ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft 385954 voor "Shield Charge", niet 385952 — draft-ID vermoedelijk fout) | Movement (extra gap-closer, overflow) |
| **Z** | Shield Block | 2565 🟢 (addon-data: JustAC SpellDB.lua WARRIOR_3 — "Shield Block") | Kleine defensive (mitigatie) |
| **Shift+Z** | Ignore Pain | 190456 🟢 (addon-data: JustAC SpellCategories.lua; ClassCodex guide.lua) | Kleine defensive (extra) |
| **C** | Shield Wall | 871 🟢 (addon-data: JustAC SpellCategories.lua — "Shield Wall"; Interrupt_CCAndCD_Tracker) | Grote defensive (triggert Last Stand-effect automatisch, 12975 🟢 (JustAC SpellCategories.lua — "Last Stand") passief) |
| **Shift+C** | Spell Reflection | 23920 🟢 (addon-data: JustAC SpellCategories.lua; Interrupt_CCAndCD_Tracker) | Defensive (extra) |
| **V** | Intimidating Shout | 5246 🟢 (addon-data: JustAC InterruptAbilities.lua) | CC |
| **Shift+V** | Berserker Rage | 18499 🟡 | CC-immuniteit — *geen addon-data* |
| **F1** | Avatar | 107574 🟢 (addon-data: Interrupt_CCAndCD_Tracker; ClassCodex guide.lua) | Grote cooldown (burst) |
| **Shift+F1** | Champion's Spear | 376079 ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft 376080 voor "Champion's Spear", niet 376079 — draft-ID vermoedelijk fout) | Major cooldown (extra) |
| **Ctrl+F1** *(let op, zie Arms)* | Ravager / Demolish (hero-tree) | 228920 🟢 (JustAC SpellArchetypes.lua — "Ravager") / 436358 🟢 (ClassCodex guide.lua) | Major cooldown |
| **F** | Taunt | 355 🟢 (addon-data: JustAC SpellCategories.lua — "Taunt (Warrior)") | Utility (threat) |
| **R** | Battle Shout | 6673 🟢 (addon-data: MissingClassBuff Data.lua) | Utility (raid-buff) |
| **T** | Hamstring | 1715 🟢 (addon-data: JustAC SpellArchetypes.lua) | Utility (slow) |
| **X** | Rallying Cry | 97462 🟢 (addon-data: JustAC SpellCategories.lua) | Utility (groeps-defensive) |
| **F2** | Wrecking Throw | 384110 ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft 394354 voor "Wrecking Throw", niet 384110 — draft-ID vermoedelijk fout) | Utility (anti-shield) |
| **F3** | Shattering Throw | 64382 ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft 372399/394352 voor "Shattering Throw", niet 64382 — draft-ID vermoedelijk fout) | Utility (anti-immuniteit) |

~24 binds. 🟢 **Challenging Shout = 1161** en **Disrupting Shout = 386071** (addon-data:
ExwindCore/LibOpenRaid `ThingsToMantain_Midnight.lua`, expliciet specs={73}=Protection, cooldown
120s resp. 90s). Kandidaat-slot: beide zijn "shout"-utility, passen op overflow (bv. Shift+F of F2)
— **welke toets in-game bevestigen**, ID's zelf zijn nu bekend.
Last Stand (12975) is géén losse knop meer in Midnight — passief effect van Shield Wall.

---

## 🩸 Death Knight — Blood

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Heart Strike | 206930 🟢 (addon-data: JustAC SpellArchetypes.lua — "Heart Strike"; RangeReferences.lua; ClassCodex) | Builder (kernrotatie) |
| **2** | Marrowrend | 195182 🟢 (addon-data: JustAC SpellArchetypes.lua — "Marrowrend"; ClassCodex guide.lua) | Builder (Bone Shield-onderhoud) |
| **3** | Death's Caress | 195292 🟢 (addon-data: JustAC SpellArchetypes.lua — "Death's Caress"; ClassCodex) | Builder (ranged tag) |
| **4** | Death Strike | 49998 🟢 (addon-data: JustAC SpellArchetypes.lua — "Death Strike"; RangeReferences.lua) | Spender/kleine-def-hybride (zie ook Z) |
| **Shift+1** | Blood Boil | 50842 🟢 (addon-data: JustAC SpellArchetypes.lua — "Blood Boil"; ClassCodex) | AoE (Shift-tweeling van Heart Strike) |
| **Shift+2** | Death and Decay | 43265 🟢 (addon-data: ClassCodex DeathKnight/guide.lua — "{43265}"; JustAC gebruikt variant-IDs 52212/203166) | AoE-grondeffect |
| **E** | Mind Freeze | 47528 🟢 (addon-data: JustAC InterruptAbilities.lua — "Mind Freeze"; BliZzi_Interrupts, Interrupt_CCAndCD_Tracker, CooldownCompanion) | Interrupt |
| **Q** | Death's Advance | 48265 🟢 (addon-data: JustAC RangeReferences.lua — "Death's Advance (DK)") | Movement |
| **Shift+Q** | Wraith Walk | 212552 🟢 (addon-data: JustAC RangeReferences.lua — "Wraith Walk (DK)") | Movement (talent-alternatief) |
| **Z** | Death Strike | 49998 🟢 (addon-data: JustAC SpellArchetypes.lua) | Kleine defensive (zelfde knop als spender — resource-afhankelijk) |
| **Shift+Z** | Lichborne | 49039 🟢 (addon-data: JustAC RangeReferences.lua — "Lichborne") | Defensive (CC-immuniteit, extra) |
| **C** | Icebound Fortitude | 48792 🟢 (addon-data: JustAC RangeReferences.lua; Interrupt_CCAndCD_Tracker) | Grote defensive |
| **Shift+C** | Vampiric Blood | 55233 🟢 (addon-data: JustAC RangeReferences.lua; Interrupt_CCAndCD_Tracker) | Grote defensive (extra) |
| **V** | Death Grip | 49576 🟢 (addon-data: JustAC RangeReferences.lua — "Death Grip"; ClassCodex) | CC / threat-tool |
| **F1** | Dancing Rune Weapon | 49028 🟢 (addon-data: JustAC RangeReferences.lua — "Dancing Rune Weapon (Blood)"; ClassCodex) | Grote cooldown (burst/mitigatie) |
| **Shift+F1** | Consumption | 1263824 🟢 (addon-data: ClassCodex DeathKnight/guide.lua — "{1263824}"; oude 205223 niet aanwezig, 1263825 is empowered variant) | Major cooldown (talent) |
| **F** | Dark Command | 56222 🟢 (addon-data: JustAC RangeReferences.lua — "Dark Command (DK)") | Utility (taunt) |
| **R** | Anti-Magic Shell | 48707 🟢 (addon-data: JustAC RangeReferences.lua; Interrupt_CCAndCD_Tracker) | Utility (magische mitigatie) |
| **T** | Raise Dead | 46585 🟢 (addon-data: ExwindCore/LibOpenRaid `ThingsToMantain_Midnight.lua`, specs={250,251,252}; niet in de 8 addons van deze check) | Utility (pet) |
| **X** | Death Pact | 48743 🟢 (addon-data: JustAC RangeReferences.lua — "Death Pact") | Utility/defensive (talent, situationeel) |

~19 binds. **Let op:** Death Strike staat op zowel spender (4) als kleine-defensive-anker (Z) — dit
is inherent aan Blood's design (heal is de mitigatie); in de UI/macro-laag kun je overwegen ze te
dupliceren i.p.v. echt dezelfde toets, maar functioneel is het dezelfde spell dus 1 bind volstaat.
Rune Tap komt niet meer voor in de huidige Midnight-kit (button-bloat-reductie, bevestigd door
afwezigheid in bron). Bone Shield (195181) is een passieve buff, geen keybind nodig.

---

## ❄️ Death Knight — Frost

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Obliterate | 49020 🟢 (addon-data: JustAC SpellArchetypes.lua — "Obliterate"; ClassCodex) | Builder (kernrotatie) |
| **2** | Empower Rune Weapon | 47568 🟢 (addon-data: JustAC SpellArchetypes.lua — "Empower Rune Weapon"; ClassCodex) | Builder/resource-cooldown |
| **3** | Remorseless Winter | 196770 ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft alleen 196771 voor "Remorseless Winter", niet 196770 — draft-ID mogelijk fout; 196770 kan de cast-ID zijn t.o.v. 196771 grond-effect, in-game bevestigen) | Builder (rotationeel, AoE-grond) |
| **4** | Frost Strike | 49143 🟢 (addon-data: JustAC SpellArchetypes.lua — "Frost Strike"; ClassCodex) | Spender (RP-dump) |
| **Shift+1** | Howling Blast | 49184 🟢 (addon-data: JustAC SpellArchetypes.lua — "Howling Blast"; ClassCodex) | AoE (Shift-tweeling van Obliterate) |
| **Shift+1 (alt.)** | Frostscythe | 207230 🟢 (addon-data: JustAC SpellArchetypes.lua — "Frostscythe"; ClassCodex) | AoE-builder-alternatief (talent, vervangt Howling Blast) |
| **Shift+4** | Glacial Advance | 194913 🟢 (addon-data: JustAC SpellArchetypes.lua — "Glacial Advance"; ClassCodex; varianten 195975/232752 ook aanwezig) | AoE-spender (Shift-tweeling van Frost Strike) |
| **E** | Mind Freeze | 47528 🟢 (addon-data: JustAC InterruptAbilities.lua; BliZzi_Interrupts, Interrupt_CCAndCD_Tracker) | Interrupt |
| **Q** | Death's Advance | 48265 🟢 (addon-data: JustAC RangeReferences.lua) | Movement |
| **Shift+Q** | Wraith Walk | 212552 🟢 (addon-data: JustAC RangeReferences.lua) | Movement (talent-alternatief) |
| **Z** | Death Strike | 49998 🟢 (addon-data: JustAC SpellArchetypes.lua) | Kleine defensive |
| **Shift+Z** | Lichborne | 49039 🟢 (addon-data: JustAC RangeReferences.lua) | Defensive (extra) |
| **C** | Icebound Fortitude | 48792 🟢 (addon-data: JustAC RangeReferences.lua; Interrupt_CCAndCD_Tracker) | Grote defensive |
| **Shift+C** | Death Pact | 48743 🟢 (addon-data: JustAC RangeReferences.lua) | Defensive (extra, talent) |
| **V** | Death Grip | 49576 🟢 (addon-data: JustAC RangeReferences.lua; ClassCodex) | CC / gap-closer op vijand |
| **Shift+V** | Chains of Ice | 45524 🟢 (addon-data: JustAC SpellArchetypes.lua — "Chains of Ice") | CC (slow) |
| **F1** | Pillar of Frost | 51271 🟢 (addon-data: ClassCodex DeathKnight/guide.lua — "{51271}") | Grote cooldown (burst) |
| **Shift+F1** | Frostwyrm's Fury | 279302 🟢 (addon-data: ClassCodex DeathKnight/guide.lua — "{279302}") | Major cooldown (extra) |
| **Ctrl+F1** *(let op, zie Warrior)* | Breath of Sindragosa | 1249658 🟢 (addon-data: ExwindCore/LibOpenRaid `ThingsToMantain_Midnight.lua`, expliciet spec=251 Frost, cd 90s/dur 5s) | Major cooldown |
| **F** | Dark Command | 56222 🟢 (addon-data: JustAC RangeReferences.lua — "Dark Command (DK)") | Utility (taunt) |
| **R** | Anti-Magic Shell | 48707 🟢 (addon-data: JustAC RangeReferences.lua; Interrupt_CCAndCD_Tracker) | Utility (magische mitigatie) |
| **T** | Raise Dead | 46585 🟢 (addon-data: ExwindCore/LibOpenRaid `ThingsToMantain_Midnight.lua`, specs={250,251,252}; niet in de 8 addons van deze check) | Utility (pet) |

~21 binds. 🟢 **Breath of Sindragosa = 1249658** bevestigd via ExwindCore/LibOpenRaid's
Midnight-specifieke bestand (`ThingsToMantain_Midnight.lua`, spec 251/Frost, cd 90s, dur 5s).
**Let op — resterende twijfel:** JustAC's `CLASS_BURST_TRIGGER_DEFAULTS` gebruikt nog het oudere
**152279** in zijn burst-cooldown-lijst (mogelijk een niet-bijgewerkte referentie in die addon).
Omdat ExwindCore's bestand expliciet "Midnight" heet en spec-getagged is, weegt dat zwaarder,
maar dump in-game ter bevestiging welke van de twee daadwerkelijk cast.

---

## 🧟 Death Knight — Unholy

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Festering Strike | 85948 🟢 (addon-data: JustAC SpellArchetypes.lua — "Festering Strike"; ClassCodex) | Builder (kernrotatie, wounds) |
| **2** | Scourge Strike | 55090 🟢 (addon-data: JustAC SpellArchetypes.lua — "Scourge Strike"; ClassCodex) | Builder/Spender |
| **3** | Dark Transformation | 63560 ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft alleen variant 344955 voor "Dark Transformation", niet 63560; 63560 = pet-cast, 344955 = damage-component — in-game bevestigen) | Builder/pet-cooldown |
| **4** | Death Coil | 47541 🟢 (addon-data: JustAC SpellArchetypes.lua — "Death Coil"; ClassCodex) | Spender (RP-dump) |
| **Shift+1** | Death and Decay | 43265 🟢 (addon-data: ClassCodex DeathKnight/guide.lua; JustAC gebruikt variant 52212/203166) | AoE-grondeffect |
| **Shift+4** | Epidemic | 207317 🟢 (addon-data: JustAC SpellArchetypes.lua — "Epidemic"; ClassCodex) | AoE-spender (Shift-tweeling van Death Coil) |
| **E** | Mind Freeze | 47528 🟢 (addon-data: JustAC InterruptAbilities.lua; BliZzi_Interrupts, Interrupt_CCAndCD_Tracker) | Interrupt |
| **Q** | Death's Advance | 48265 🟢 (addon-data: JustAC RangeReferences.lua) | Movement |
| **Z** | Death Strike | 49998 🟢 (addon-data: JustAC SpellArchetypes.lua) | Kleine defensive |
| **Shift+Z** | Lichborne | 49039 🟢 (addon-data: JustAC RangeReferences.lua) | Defensive (extra) |
| **C** | Icebound Fortitude | 48792 🟢 (addon-data: JustAC RangeReferences.lua; Interrupt_CCAndCD_Tracker) | Grote defensive |
| **Shift+C** | Anti-Magic Shell | 48707 🟢 (addon-data: JustAC RangeReferences.lua; Interrupt_CCAndCD_Tracker) | Defensive (extra, magisch) |
| **V** | Death Grip | 49576 🟢 (addon-data: JustAC RangeReferences.lua; ClassCodex) | CC / gap-closer |
| **Shift+V** | Chains of Ice | 45524 🟢 (addon-data: JustAC SpellArchetypes.lua) | CC (slow) |
| **F1** | Army of the Dead | 42650 🟢 (addon-data: JustAC SpellArchetypes.lua — "Army of the Dead"; ClassCodex) | Grote cooldown (burst-opener) |
| **Shift+F1** | Summon Gargoyle | 49206 🟡 | Major cooldown — *geen addon-data* |
| **F** | Raise Dead | 46585 🟢 (addon-data: ExwindCore/LibOpenRaid `ThingsToMantain_Midnight.lua`, specs={250,251,252} — zelfde ID voor alle 3 specs, ook JustAC `DEATHKNIGHT_3 = {46584, 46585}` pet-rez-lijst) | Utility (pet) |
| **R** | Dark Command | 56222 🟢 (addon-data: JustAC RangeReferences.lua — "Dark Command (DK)") | Utility (taunt, class-baseline) |

~17 binds — kleinste DK-kit, want Unholy's kernrotatie leunt sterk op pet/DoT-onderhoud i.p.v.
extra losse knoppen. 🟢 **Raise Dead (Unholy) = 46585** — addon-data (ExwindCore Midnight-bestand)
bevestigt dat alle 3 DK-specs dezelfde ID gebruiken (46585); JustAC's pet-rez-lijst noemt ook
nog 46584 (permanente ghoul-variant) als mogelijk alternatief — als de in-game tooltip een ander
ID toont, is dat de reden.

---

## 😈 Demon Hunter — Havoc

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Chaos Strike / Annihilation (Meta) | 162794 🟢 (JustAC SpellArchetypes.lua — "Chaos Strike") / 201427 🟢 (JustAC SpellArchetypes.lua — "Annihilation") | Builder/Spender ST |
| **2** | Immolation Aura | 258920 🟢 (addon-data: JustAC SpellArchetypes.lua — "Immolation Aura" cast; ClassCodex) | Builder (AoE + defensief-utility) |
| **3** | Eye Beam | 198013 🟢 (addon-data: JustAC SpellArchetypes.lua — "Eye Beam"; ClassCodex) | Builder/offensieve cooldown |
| **4** | Throw Glaive | 185123 🟢 (addon-data: JustAC SpellArchetypes.lua — "Throw Glaive"; ClassCodex) | Spender (ranged filler) |
| **Shift+1** | Blade Dance / Death Sweep (Meta) | 188499 🟢 (JustAC SpellArchetypes.lua — "Blade Dance") / 210152 🟢 (JustAC SpellArchetypes.lua — "Death Sweep") | AoE (Shift-tweeling van Chaos Strike) |
| **E** | Disrupt | 183752 🟢 (addon-data: JustAC InterruptAbilities.lua; BliZzi_Interrupts, Interrupt_CCAndCD_Tracker) | Interrupt |
| **Q** | Fel Rush | 195072 🟢 (addon-data: ClassCodex DemonHunter/guide.lua — "{195072}") | Movement |
| **Shift+Q** | Vengeful Retreat | 198793 🟢 (addon-data: ClassCodex DemonHunter/guide.lua — "{198793}") | Movement (extra, backwards) |
| **Ctrl+Q** | Felblade | 232893 🟢 (addon-data: JustAC RangeReferences.lua — "Felblade (DH)"; ClassCodex) | Movement/builder (gap-closer, overflow) |
| **Z** | Blur | 198589 🟢 (addon-data: JustAC SpellCategories.lua — "Blur") | Kleine defensive |
| **C** | Darkness | 196718 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua — cat="Defensivos", DEMONHUNTER) | Grote defensive |
| **V** | Chaos Nova | 179057 🟢 (addon-data: JustAC SpellCategories.lua / InterruptAbilities.lua — "Chaos Nova") | CC (AoE stun) |
| **Shift+V** | Sigil of Misery | 207684 🟢 (addon-data: JustAC SpellCategories.lua — "Sigil of Misery") | CC (fear, extra) |
| **F1** | Metamorphosis | 191427 🟢 (addon-data: ClassCodex DemonHunter/guide.lua — "{191427}") | Grote cooldown (burst-vorm) |
| **Shift+F1** | The Hunt | 370965 🟢 (addon-data: ClassCodex DemonHunter/guide.lua — "{370965}") | Major cooldown (extra) |
| **F** | Imprison | 217832 🟢 (addon-data: JustAC SpellCategories.lua — "Imprison") | Utility (CC/cage) |
| **R** | Torment | 185245 🟢 (addon-data: JustAC SpellCategories.lua — "Torment (DH)") | Utility (taunt) |
| **T** | Consume Magic | 278326 🟡 | Utility (offensieve dispel) — *geen addon-data* |

~18 binds. **Let op:** Glaive Tempest is in Midnight geautomatiseerd via Blade Dance (button-bloat-
reductie) — geen eigen knop meer nodig, bevestigd door web-bronnen.

---

## 😈 Demon Hunter — Vengeance

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Fracture | 263642 🟢 (addon-data: JustAC SpellArchetypes.lua — "Fracture"; ClassCodex) | Builder (fury + soul fragments) |
| **2** | Immolation Aura | 258920 🟢 (addon-data: JustAC SpellArchetypes.lua — "Immolation Aura"; ClassCodex) | Builder (AoE + threat) |
| **3** | Sigil of Flame | 204596 🟢 (addon-data: ClassCodex DemonHunter/guide.lua — "{204596}"; JustAC gebruikt variant 204598) | Builder/threat (AoE) |
| **4** | Soul Cleave | 228477 🟢 (addon-data: JustAC SpellArchetypes.lua / RangeReferences.lua — "Soul Cleave" cast; 228478 = damage-component) | Spender (heal + damage) |
| **Shift+4** | Spirit Bomb | 247454 🟢 (addon-data: ClassCodex DemonHunter/guide.lua — "{247454}"; JustAC gebruikt varianten 218677/247455) | AoE-spender (Shift-tweeling van Soul Cleave) |
| **E** | Disrupt | 183752 🟢 (addon-data: JustAC InterruptAbilities.lua; BliZzi_Interrupts, Interrupt_CCAndCD_Tracker) | Interrupt |
| **Q** | Infernal Strike | 189110 🟢 (addon-data: ClassCodex DemonHunter/guide.lua — "{189110}") | Movement |
| **Shift+Q** | Vengeful Retreat | 198793 🟢 (addon-data: ClassCodex DemonHunter/guide.lua) | Movement (extra) |
| **Ctrl+Q** | Felblade | 232893 🟢 (addon-data: JustAC RangeReferences.lua; ClassCodex) | Movement/builder (overflow) |
| **Z** | Demon Spikes | 203720 🟢 (addon-data: JustAC SpellCategories.lua — "Demon Spikes") | Kleine defensive (mitigatie) |
| **C** | Fiery Brand | 204021 🟢 (addon-data: JustAC SpellArchetypes.lua / SpellCategories.lua — "Fiery Brand"; ClassCodex) | Grote defensive |
| **Shift+C** | Fel Devastation | 212084 🟢 (addon-data: JustAC SpellArchetypes.lua — "Fel Devastation"; ClassCodex) | Defensive/major cooldown (heal + AoE damage) |
| **V** | Sigil of Misery | 207684 🟢 (addon-data: JustAC SpellCategories.lua — "Sigil of Misery") | CC (fear) |
| **Shift+V** | Sigil of Chains | 202138 🟢 (addon-data: JustAC SpellCategories.lua — "Sigil of Chains (DH)") | CC (pull) |
| **Ctrl+V** | Chaos Nova | 179057 🟢 (addon-data: JustAC SpellCategories.lua / InterruptAbilities.lua) | CC (talent, overflow) |
| **F1** | Metamorphosis (Vengeance) | 187827 🟢 (addon-data: JustAC SpellCategories.lua — "Metamorphosis (Vengeance)"; ClassCodex) | Grote cooldown (burst/mitigatie) |
| **Shift+F1** | Sigil of Spite | 390163 🟢 (addon-data: ClassCodex DemonHunter/guide.lua — "{390163}"; JustAC gebruikt variant 389860) | Major cooldown (souls/burst, extra) |
| **F** | Torment | 185245 🟢 (addon-data: JustAC SpellCategories.lua — "Torment (DH)") | Utility (taunt) |
| **R** | Imprison | 217832 🟢 (addon-data: JustAC SpellCategories.lua — "Imprison") | Utility (CC/cage) |
| **T** | Consume Magic | 278326 🟡 | Utility (offensieve dispel) — *geen addon-data* |
| **X** | Throw Glaive | 204157 🟢 (addon-data: ClassCodex DemonHunter/guide.lua — "{204157}") | Utility (threat/pull, tank-variant) |

~21 binds. 🟡 Sigil of Misery-ID is matig zeker (bevestigd via Method-macropagina, niet direct
Wowhead spell-page fetch) — als extra check waard bij in-game dumpen.

---

## 🐉 Evoker — Devastation

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Living Flame | 361469 🟢 (addon-data: JustAC SpellCategories.lua / MissingClassBuff Data.lua — "Living Flame"; ClassCodex) | Builder (filler) |
| **2** | Azure Strike | 362969 🟢 (addon-data: JustAC SpellArchetypes.lua / RangeReferences.lua — "Azure Strike"; ClassCodex) | Builder (filler AoE-capable) |
| **3** | Fire Breath | 357208 🟢 (addon-data: ClassCodex Evoker/guide.lua + JustAC SpellCategories.lua — "357208 is Fire Breath"; archetype heeft cleave-variant 357209) | Builder/rotationeel (empower) |
| **4** | Disintegrate | 356995 🟢 (addon-data: JustAC SpellArchetypes.lua — "Disintegrate"; ClassCodex) | Spender |
| **5** | Eternity Surge | 359073 🟢 (addon-data: ClassCodex Evoker/guide.lua — "{359073}") | Spender (empower, ST-piercing) |
| **Shift+2** | Azure Sweep | 1265867 🟢 (addon-data: ClassCodex Evoker/guide.lua — "{1265867}"; JustAC gebruikt variant 1265872) | AoE (Shift-tweeling van Azure Strike) |
| **Shift+4** | Pyre | 357211 🟢 (addon-data: JustAC SpellArchetypes.lua — "Pyre"; ClassCodex; archetype heeft ook variant 357212) | AoE (Shift-tweeling van Disintegrate) |
| **Shift+5** | Firestorm | 368847 🟡 | AoE (extra, proc-based) — *geen addon-data* |
| **E** | Quell | 351338 🟢 (addon-data: JustAC InterruptAbilities.lua; BliZzi_Interrupts, Interrupt_CCAndCD_Tracker, MissingClassBuff) | Interrupt |
| **Q** | Hover | 358267 🟢 (addon-data: JustAC SpellCategories.lua — "Hover (Evoker)"; ClassCodex) | Movement |
| **Shift+Q** | Deep Breath | 357210 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua — EVOKER; ClassCodex) | Movement (extra, ook major cooldown) |
| **Z** | Obsidian Scales | 363916 🟢 (addon-data: JustAC SpellCategories.lua; Interrupt_CCAndCD_Tracker) | Kleine defensive |
| **Shift+Z** | Renewing Blaze | 374348 🟢 (addon-data: JustAC SpellCategories.lua — "Renewing Blaze") | Defensive (extra, self-heal) |
| **C** | Zephyr | 374227 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua — cat="Defensivos", EVOKER) | Grote defensive |
| **V** | Sleep Walk | 360806 🟢 (addon-data: JustAC SpellCategories.lua — "Sleep Walk") | CC |
| **Shift+V** | Expunge | 365585 🟢 (addon-data: JustAC SpellCategories.lua — "Expunge (Evoker)") | Dispel |
| **Ctrl+V** | Cauterizing Flame | 374251 🟢 (addon-data: JustAC SpellCategories.lua — "Cauterizing Flame (Evoker)") | Dispel (extra, overflow) |
| **F1** | Dragonrage | 375087 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua — spec=1467; ClassCodex) | Grote cooldown (burst) |
| **Shift+F1** | Fury of the Aspects | 390386 🟢 (addon-data: JustAC SpellCategories.lua — "Fury of the Aspects (Evoker)") | Major cooldown (groeps-Bloodlust, extra) |
| **F** | Verdant Embrace | 360995 🟢 (addon-data: JustAC SpellCategories.lua — "Verdant Embrace"; ClassCodex) | Utility (heal/mobility) |
| **R** | Blessing of the Bronze | 364342 🟢 (addon-data: MissingClassBuff Data.lua — "Blessing of the Bronze") | Utility (raid-buff) |
| **T** | Landslide | 358385 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua — cat="CCs", EVOKER) | Utility/CC (root) |
| **X** | Tail Swipe | 368970 🟡 | Utility/CC (racial-ish knockback) — *geen addon-data* |
| **F2** | Tip the Scales | 370553 🟢 (addon-data: ClassCodex Evoker/guide.lua — "{370553}") | Utility (empower-modifier) |
| **F3** | Oppressing Roar | 372048 🟢 (addon-data: JustAC SpellCategories.lua; Interrupt_CCAndCD_Tracker) | Utility (fear-immuniteit groep) |

~24 binds. ⚠️ **"Shattering Star" (enkelvoud)** niet gevonden als losse spell — alleen het talent
"Shattering Stars" (1265802 🟡) bevestigd; niet opgenomen als losse knop, in-game dumpen indien
een aparte castbare versie bestaat.

---

## 🐉 Evoker — Preservation (healer — ST-heals via mouseover/Click Cast, zie §6)

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Dream Breath | 355936 🟢 (addon-data: ClassCodex Evoker/guide.lua — "{355936}") | "Builder" — raid-AoE-heal (kernrotatie) |
| **2** | Temporal Anomaly | 373861 🟢 (addon-data: ClassCodex Evoker/guide.lua — "{373861}") | "Builder" — raid-AoE-heal, Echo-generator |
| **3** | Echo | 364343 🟢 (addon-data: JustAC SpellArchetypes.lua — "Echo"; ClassCodex) | Builder (Essence-mechaniek, geen ST-heal-toewijzing) |
| **4** | Emerald Blossom | 355913 🟢 (addon-data: JustAC SpellArchetypes.lua / SpellCategories.lua — "Emerald Blossom"; archetype heeft ook variant 373766) | Spender (AoE-heal) |
| **5** | Living Flame | 361469 🟢 (addon-data: JustAC SpellCategories.lua / MissingClassBuff; ClassCodex) | Spender/damage (dual-purpose heal+dps) |
| **Shift+4** | Fire Breath | 357208 🟢 (addon-data: ClassCodex + JustAC SpellCategories.lua; archetype cleave-variant 357209) | AoE (damage/heal-hybride, empower) |
| **E** | Quell | 351338 🟢 (addon-data: JustAC InterruptAbilities.lua; BliZzi_Interrupts, Interrupt_CCAndCD_Tracker) | Interrupt |
| **Q** | Hover | 358267 🟢 (addon-data: JustAC SpellCategories.lua; ClassCodex) | Movement |
| **Shift+Q** | Deep Breath | 357210 🟢 (addon-data: Interrupt_CCAndCD_Tracker; ClassCodex) | Movement (extra) |
| **Z** | Obsidian Scales | 363916 🟢 (addon-data: JustAC SpellCategories.lua; Interrupt_CCAndCD_Tracker) | Kleine defensive |
| **Shift+Z** | Time Dilation | 357170 🟢 (addon-data: JustAC SpellCategories.lua; Interrupt_CCAndCD_Tracker — spec=1468) | Defensive (extra, external) |
| **C** | Rewind | 363534 🟢 (addon-data: JustAC SpellCategories.lua; Interrupt_CCAndCD_Tracker — spec=1468) | Grote heal-cooldown (panic) |
| **Shift+C** | Zephyr | 374227 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua — EVOKER) | Grote defensive (extra) |
| **V** | Sleep Walk | 360806 🟢 (addon-data: JustAC SpellCategories.lua — "Sleep Walk") | CC |
| **Shift+V** | Expunge | 365585 🟢 (addon-data: JustAC SpellCategories.lua) | Dispel |
| **Ctrl+V** | Cauterizing Flame | 374251 🟢 (addon-data: JustAC SpellCategories.lua) | Dispel (extra, overflow) |
| **F1** | Dream Flight | 359816 🟡 | Grote heal-cooldown (burst-raid-heal) — *geen addon-data* |
| **Shift+F1** | Stasis | 370537 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua — spec=1468) | Major cooldown (extra, banked heals) |
| **F** | Blessing of the Bronze | 364342 🟢 (addon-data: MissingClassBuff Data.lua) | Utility (raid-buff) |
| **R** | Source of Magic | 369459 🟢 (addon-data: MissingClassBuff Data.lua — "source of magic") | Utility (mana-support) |
| **T** | Landslide | 358385 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua) | Utility/CC |
| **X** | Renewing Blaze | 374348 🟢 (addon-data: JustAC SpellCategories.lua) | Utility/defensive (self-heal) |

**ST-heals — géén toets, via mouseover/Click Cast Bindings (§6):**

| Ability | ID | Notitie |
|---------|----|---------|
| Reversion | 367364 🟡 | Click-cast/mouseover — *geen addon-data* |
| Verdant Embrace | 360995 🟢 (addon-data: JustAC SpellCategories.lua — "Verdant Embrace") | Heeft ook mobility-component — advies: evalueren of dit tóch een toets verdient i.p.v. puur mouseover |

~21 combat-binds + 2 click-cast-only. ⚠️ Merithra's Blessing (apex-talent, 1256577 🟡 met
node-varianten 1256682/1256689) — geen aparte actieve knop, informatief vermeld.

---

## 🐉 Evoker — Augmentation (support/buff-spec)

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Ebon Might | 395152 🟢 (addon-data: JustAC SpellCategories.lua — "Ebon Might (Augmentation buff)"; ClassCodex) | "Builder" — kernbuff (hoofdrotatie) |
| **2** | Prescience | 409311 🟢 (addon-data: JustAC SpellCategories.lua — "Prescience"; ClassCodex) | "Builder" — kernbuff (manual target-buff) |
| **3** | Living Flame | 361469 🟢 (addon-data: JustAC SpellCategories.lua / MissingClassBuff; ClassCodex) | Builder (filler) |
| **4** | Eruption | 395160 🟢 (addon-data: JustAC SpellArchetypes.lua — "Eruption"; ClassCodex) | Spender (Essence, vervangt Disintegrate) |
| **5** | Upheaval | 396286 ⚠️ (addon-data: JustAC SpellArchetypes.lua heeft 396288 voor "Upheaval", niet 396286 — draft-ID mogelijk fout; 396286 kan cast-ID zijn t.o.v. 396288 impact — in-game bevestigen) | Spender/AoE-CC (empower) |
| **Shift+3** | Azure Strike | 362969 🟢 (addon-data: JustAC SpellArchetypes.lua; ClassCodex) | AoE (Shift-tweeling van Living Flame) |
| **Shift+4** | Fire Breath | 357208 🟢 (addon-data: ClassCodex + JustAC SpellCategories.lua; archetype cleave-variant 357209) | AoE/rotationeel (empower, Shift-tweeling van Eruption) |
| **E** | Quell | 351338 🟢 (addon-data: JustAC InterruptAbilities.lua; BliZzi_Interrupts, Interrupt_CCAndCD_Tracker) | Interrupt |
| **Q** | Hover | 358267 🟢 (addon-data: JustAC SpellCategories.lua; ClassCodex) | Movement |
| **Shift+Q** | Deep Breath | 357210 🟢 (addon-data: Interrupt_CCAndCD_Tracker; ClassCodex) | Movement (baseline, vaak vervangen door Breath of Eons) |
| **Z** | Obsidian Scales | 363916 🟢 (addon-data: JustAC SpellCategories.lua; Interrupt_CCAndCD_Tracker) | Kleine defensive |
| **Shift+Z** | Renewing Blaze | 374348 🟢 (addon-data: JustAC SpellCategories.lua) | Defensive (extra) |
| **C** | Zephyr | 374227 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua — EVOKER) | Grote defensive |
| **Shift+C** | Defy Fate | 404195 🟡 | Grote defensive (extra, cheat-death) — *geen addon-data* |
| **V** | Sleep Walk | 360806 🟢 (addon-data: JustAC SpellCategories.lua) | CC |
| **Shift+V** | Expunge | 365585 🟢 (addon-data: JustAC SpellCategories.lua) | Dispel |
| **Ctrl+V** | Cauterizing Flame | 374251 🟢 (addon-data: JustAC SpellCategories.lua) | Dispel (extra, overflow) |
| **F1** | Breath of Eons | 403631 🟢 (addon-data: Interrupt_CCAndCD_Tracker Spells.lua — spec=1473; ClassCodex) — Scalecommander-variant 442204 🟡 onbevestigd | Grote cooldown (burst) |
| **Shift+F1** | Fury of the Aspects | 390386 🟢 (addon-data: JustAC SpellCategories.lua) | Major cooldown (groeps-Bloodlust, extra) |
| **F** | Blessing of the Bronze | 364342 🟢 (addon-data: MissingClassBuff Data.lua) | Utility (raid-buff) |
| **R** | Blistering Scales | 360827 🟢 (addon-data: JustAC SpellCategories.lua — "Blistering Scales (Augmentation)"; ClassCodex; archetype variant 360828) | Utility (ally-defensive-buff) |
| **T** | Time Skip | 404977 🟢 (addon-data: ClassCodex Evoker/guide.lua — "{404977}") | Utility (cooldown-reset support) |
| **X** | Bestow Weyrnstone | 408233 🟡 | Utility — *geen addon-data* |
| **F2** | Tip the Scales | 370553 🟢 (addon-data: ClassCodex Evoker/guide.lua) | Utility (empower-modifier) |

~23 binds. **Let op:** Ebon Might/Prescience zijn geen klassieke "builders" maar de kern van
Augmentation's supportrotatie — hier bewust op 1/2 gezet omdat ze qua *frequentie* (elke GCD-cyclus)
overeenkomen met een builder-slot. "Black Attunement" bestaat niet meer als losse naam — vervangen
door passief "Might of the Black Dragonflight" (441705 🟡, geen keybind nodig).

---

## ⚠️ Class-brede onzekerheden (bijgewerkt na addon-data-check 2026-07-02)

- **Warrior:** Challenging Shout (1161) en Disrupting Shout (386071) 🟢 gevonden via addon-data
  (ExwindCore/LibOpenRaid Midnight-bestand) — **maar Protection-only**, niet Arms. Toets nog
  te bepalen (overflow-slot).
- **Death Knight (Frost):** Breath of Sindragosa 🟢 **1249658** (ExwindCore Midnight-bestand,
  spec-getagged) — JustAC's oudere 152279-referentie is vermoedelijk stale; in-game bevestigen
  blijft aanbevolen gezien de resterende bron-inconsistentie.
- **Death Knight (Unholy):** Raise Dead 🟢 **46585** (zelfde ID als Blood/Frost, bevestigd via
  addon-data).
- **Evoker (alle specs):** "Time Stop" niet gevonden als bestaande Evoker-ability in Midnight —
  waarschijnlijk niet (meer) aanwezig; §3-anker C is elders ingevuld (Zephyr/Rewind). Geen
  addon-data gevonden die dit tegenspreekt.
- **Evoker Devastation:** "Shattering Star" enkelvoud niet gevonden, alleen talent "Shattering
  Stars" (1265802) bevestigd. Geen addon-data gevonden voor een aparte "Shattering Star"-cast.

## Algemene kanttekening — Ctrl+F1-conflict (Warrior)

Bij Arms/Fury/Protection Warrior is een derde grote cooldown (Bladestorm/Ravager/Demolish)
tijdelijk op **Ctrl+F1** gezet, wat normaal het **trinket-anker** is (§3 v6-standaard). Dit is een
bewuste afwijking om geen ID te verzinnen voor een niet-bestaande slot — bij het coderen in
`Modules/KeybindingData.lua` moet dit herzien worden (bv. eigen Shift+C/Shift+X-slot i.p.v.
het trinket-anker overschrijven). Racial/trinket/potion-ankers zelf zijn hier niet opnieuw
ingevuld — die blijven Shift+E / Ctrl+F1 / Alt+C zoals de standaard voorschrijft.

---

## Bronnen (research, alle Midnight 12.0.5–12.0.7, juli 2026)

**Warrior:**
- https://www.icy-veins.com/wow/arms-warrior-pve-dps-rotation-cooldowns-abilities
- https://www.icy-veins.com/wow/fury-warrior-pve-dps-rotation-cooldowns-abilities
- https://www.icy-veins.com/wow/protection-warrior-pve-tank-rotation-cooldowns-abilities
- https://www.icy-veins.com/wow/arms-warrior-pve-dps-spell-summary
- https://www.icy-veins.com/wow/fury-warrior-pve-dps-spell-summary
- https://www.icy-veins.com/wow/protection-warrior-pve-tank-spell-summary
- Wowhead spell-pagina's (individueel per ID, zie boven), o.a. wowhead.com/spell=12294,
  167105, 227847, 184367, 23922, 871, 12975 (Last Stand — bevestigt passief-status)

**Death Knight:**
- https://www.wowhead.com/guide/classes/death-knight/blood/abilities-talents-pve-tank
- https://www.wowhead.com/guide/classes/death-knight/frost/abilities-talents-pve-dps
- https://www.icy-veins.com/wow/unholy-death-knight-pve-dps-spell-summary
- https://www.icy-veins.com/wow/blood-death-knight-pve-tank-spell-summary
- Wowhead spell-pagina's, o.a. spell=49998, 48792, 55233, 47528, 49028, 50842, 206930, 195182,
  49576, 43265, 205223/1263824 (Consumption, twee versies), 47568, 49020, 49143, 51271, 196770,
  152279/1249658 (Breath of Sindragosa, conflict), 85948, 55090, 207317, 42650, 63560, 49206

**Demon Hunter:**
- https://www.wowhead.com/guide/classes/demon-hunter/havoc/abilities-talents-pve-dps
- https://www.wowhead.com/guide/classes/demon-hunter/vengeance/abilities-talents-pve-tank
- https://www.icy-veins.com/wow/havoc-demon-hunter-pve-dps-spell-summary
- https://www.icy-veins.com/wow/vengeance-demon-hunter-pve-tank-spell-summary
- https://www.method.gg/guides/havoc-demon-hunter/interface-and-macros
- https://www.method.gg/guides/vengeance-demon-hunter/interface-and-macros
- https://www.icy-veins.com/wow/news/wows-midnight-pre-patch-2-changes-what-every-class-can-do/
  (button-bloat-context: Glaive Tempest geautomatiseerd, Netherwalk samengevoegd met Blur)

**Evoker:**
- https://www.wowhead.com/guide/classes/evoker/devastation/rotation-cooldowns-pve-dps
- https://www.wowhead.com/guide/classes/evoker/devastation/abilities-talents-pve-dps
- https://www.wowhead.com/guide/classes/evoker/preservation/rotation-cooldowns-pve-healer
- https://www.wowhead.com/guide/classes/evoker/preservation/abilities-talents-pve-healer
- https://www.wowhead.com/guide/classes/evoker/augmentation/abilities-talents-pve-dps
- https://www.wowhead.com/spell=351338/quell
- https://www.icy-veins.com/wow/devastation-evoker-pve-dps-spell-summary
- https://www.icy-veins.com/wow/augmentation-evoker-pve-dps-spell-summary
- https://www.icy-veins.com/wow/preservation-evoker-pve-healing-rotation-cooldowns-abilities

**Algemeen (button-bloat-context, ook gebruikt in v6-standaard):**
- https://www.turtlebeach.com/blog/world-of-warcraft-midnight-aiming-to-reduce-button-bloat-for-all-40-specs

---

## Volgende stap

Alle 11 specs zijn 🟡 (web-gevonden, onbevestigd) — **geen enkele ✅** in dit document. Voordat dit
naar `Modules/KeybindingData.lua` gaat: Rob/Cisca moeten per spec in-game de tooltips/spellbook
dumpen en elke ID bevestigen (zelfde werkwijze als bij Frost Mage/Enhancement Shaman). Prioriteer
de specs die Rob/Cisca daadwerkelijk spelen. Herzie ook het Ctrl+F1-conflict bij de drie Warrior-
specs (zie kanttekening hierboven) vóór het coderen.
