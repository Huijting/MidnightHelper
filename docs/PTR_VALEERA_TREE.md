# Valeera's companion trait tree — measured on the 12.1 PTR

**Captured 2026-07-27 from build 120100 (RC 68914) via `/mh valeera save`.**
Companion 2, tree **1223**, config 6499116, **49 nodes**.

## ⚠️ The poison spell ids we had on file were STALE

The Poisons node is **110784**, a choice of three. Measured on this build:

| Poison | spellID | entryID |
|---|---|---|
| Soulthirst Venom | 1250826 | 137812 |
| Poison of the Forgotten Master | 1249934 | 137801 |
| Bloodcrypt Toxin | 1251120 | 137790 |

Earlier notes carried **1248517 / 1251113 / 1251862** for these. Those do not match
what the client reports now — an earlier PTR build, or simply wrong. Use the table
above and re-measure before shipping, because ids on a PTR can still move.

## How to capture this again

Open Valeera's window at a repair post FIRST, then `/mh valeera save`, then `/reload`.
The order matters: a reload clears the configuration frame, and without that frame the
trait tree reads as 0. The probe records its own failure reason now, so a miss can be
read off disk instead of guessed at.

## Notes for the advisor

Nodes ending in `[0/70]` are the three "Uncrowned's" progression tracks (Bloody Ledger
1260258, Alchemical Codex 1261073, Playbook of Subterfuge 1261076) — 70 ranks each, so
they are tracks, not picks, and should not be advised like a one-of-three choice.

Three entries resolved no name (spells 1248746, 452363, 472094). Not invented here:
they are recorded as unnamed rather than guessed at.

```
companion 2 — tree 1223, config 6499116, build 120100, 49 nodes

node 110784    [1/1]
    Soulthirst Venom                       entry 137812   spell 1250826
    Poison of the Forgotten Master         entry 137801   spell 1249934
    Bloodcrypt Toxin                       entry 137790   spell 1251120
node 110785   (no named entries)  [0/1]
node 110786   (no named entries)  [0/1]
node 110787    [0/1]
    No Witnesses                           entry 137787   spell 1249946
node 110788    [0/1]
    Dagger to the Throat                   entry 137798   spell 1249933
node 110789    [0/1]
    Cheap Shot                             entry 137809   spell 1249942
node 110790    [0/1]
    Assassinate                            entry 137820   spell 1249943
node 110791    [0/1]
    Unrelenting                            entry 137745   spell 1249646
node 110792    [0/1]
    Blood Contract                         entry 137756   spell 1249932
node 110793    [0/1]
    Killing Spree                          entry 137767   spell 1249937
node 110794    [0/1]
    Rupture                                entry 137777   spell 1249804
node 110795    [0/1]
    Fan of Knives                          entry 137788   spell 1249931
node 110796    [0/1]
    Stealth                                entry 137799   spell 1252005
node 110797    [0/70]
    Uncrowned's Bloody Ledger              entry 137810   spell 1260258
node 110798    [0/1]
    Tools of the Trade                     entry 137821   spell 1251603
node 110799    [0/1]
    (unnamed)                              entry 137746   spell 1248746
node 110800    [0/1]
    Jagged Caltrops                        entry 137757   spell 1272346
node 110801    [0/1]
    Masterful Feint                        entry 137768   spell 1284726
node 110802    [0/1]
    Cloak of Darkness                      entry 137811   spell 1250825
node 110803    [0/1]
    Pain Killer                            entry 137736   spell 1250823
node 110804    [0/1]
    Crimson Vial Fumes                     entry 137747   spell 1250822
node 110805    [0/1]
    Shadow Veil                            entry 137737   spell 1250833
node 110806    [0/1]
    Vampiric Reaping                       entry 137748   spell 1250821
node 110807    [0/1]
    Killing Spree                          entry 137759   spell 1249937
node 110808    [0/1]
    Blood Contract                         entry 137770   spell 1249932
node 110809    [0/1]
    Fan of Knives                          entry 137780   spell 1249931
node 110810    [0/1]
    Rupture                                entry 137791   spell 1249804
node 110811    [0/1]
    Stealth                                entry 137802   spell 1252005
node 110812    [0/70]
    Uncrowned's Alchemical Codex           entry 137813   spell 1261073
node 110813    [0/1]
    Tools of the Trade                     entry 137738   spell 1251603
node 110814    [0/1]
    (unnamed)                              entry 137749   spell 452363
node 110815    [0/1]
    Cheap Shot                             entry 137760   spell 1249942
node 110816    [0/1]
    Masterful Feint                        entry 137771   spell 1284726
node 110817   (no named entries)  [1/1]
node 110818    [0/1]
    Blood-Stained Blades                   entry 137781   spell 1251122
node 110819    [0/1]
    Attack from the Shadows                entry 137792   spell 1251121
node 110820    [0/1]
    Poison Cloud                           entry 137803   spell 1251123
node 110821    [0/1]
    Your First Mistake                     entry 137814   spell 1251119
node 110822    [0/1]
    Scar of Kathra'natir                   entry 137739   spell 1251118
node 110823    [0/1]
    Killing Spree                          entry 137750   spell 1249937
node 110824    [0/1]
    Blood Contract                         entry 137761   spell 1249932
node 110825    [0/1]
    Fan of Knives                          entry 137772   spell 1249931
node 110826    [0/1]
    Rupture                                entry 137782   spell 1249804
node 110827    [0/1]
    Stealth                                entry 137793   spell 1252005
node 110828    [0/70]
    Uncrowned's Playbook of Subterfuge     entry 137804   spell 1261076
node 110829    [0/1]
    Tools of the Trade                     entry 137815   spell 1251603
node 110830    [0/1]
    (unnamed)                              entry 137740   spell 472094
node 110831    [0/1]
    Dagger to the Throat                   entry 137751   spell 1249933
node 110832    [0/1]
    Masterful Feint                        entry 137762   spell 1284726
```
