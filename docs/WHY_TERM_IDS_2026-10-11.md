# Plain-text game names in PLAYCARD_*_W* / _WAOE / _TERMS → `{SPELL:id}`

Scope: all 257 `PLAYCARD_<spec>_W1..W5/WAOE/TERMS` lines in `Locales/enUS.lua`. Count MEASURED twice: Grep counted 257,
and the extraction script also counted 257. Resources and the skip list from the brief are left out.

## Sources (all fetched 11 Oct 2026, all build 12.1.0.69933 = live)
- **W-SN**: wago.tools DB2 `SpellName` CSV, enUS + `&locale=deDE` + `&locale=frFR` (curl works; no browser needed).
- **W-TD / W-SS / W-SLA / W-SLS**: wago `TraitDefinition`, `SpecializationSpells`, `SkillLineAbility`, `SpellLearnSpell`.
- **SC-TR**: SimC `midnight` `engine/dbc/generated/trait_data.inc` (header "wow build 12.1.0.69933"). This gives the spec,
  row/col and choice index for each talent. **SC-SS**: `specialization_spells.inc`. **SC-D**: `SpellDataDump/<class>.txt`
  ("12.1.0.69933 Live, hotfix 2026-10-07").
- Hero-tree names: wago `TraitSubTree` enUS/deDE.

## How to read the table
- **M** = MEASURED. The ID, its exact enUS name and how the player gets it (talent tree + spec, spec passive, or learned
  through another talent) were all seen in the sources above.
- **I** = INFERRED.
- 🔴 **For every row: whether `IsPlayerSpell`/`C_SpellBook.IsSpellKnown` really returns true for that ID is INFERRED.**
  No client was run. Talent and spec-passive IDs normally count as known, but check in the game with
  `/dump IsPlayerSpell(id)` on the right spec. Do this first for the TEST rows.
- Advice: **USE** = swap in as is. **USE\*** = swap, but rewrite the sentence (plural or grammar). **KEEP** = keep the
  plain text, because there is no ID the player knows (a buff or override only). **TEST** = check in the game first.
- "apex sN" = stage N of a row-11 apex node. Each stage is a separate entry with its own spell (SC-TR `select_idx`).
  Whether stage 1 stays "known" after you buy stage 2/3 is INFERRED.

| key(s) | plain | ID | enUS SpellName (exact) | kind | M/I | deDE / frFR | advice / note |
|---|---|---|---|---|---|---|---|
| 66_W1 | Hammer of Wrath | 1241288 | Hammer of Wrath | class talent r1c6 (free for Ret 70) | M | Hammer des Zorns / Marteau de courroux | USE. Its tooltip: "During Avenging Wrath, Judgment is empowered into Hammer of Wrath" (SC-D). See side finding 1 |
| 62_W2 | Clearcasting | 79684 | Clearcasting | spec passive Arcane (W-SS 62, SC-SS) | M | Freizaubern / Idées claires | USE |
| 62_W2,W3,W4,TERMS | Arcane Salvo | 384452 | Arcane Salvo | Arcane talent r2c5 | M | Arkansalve / Salve arcanique | USE. The stack buff is 1242974 (also "Arcane Salvo"); not used, because it is not known |
| 62_WAOE | Arcane Pulse | 1241462 | Arcane Pulse | Arcane talent r4c2, replaces Arcane Explosion 1449 | M | Arkaner Puls / Impulsion arcanique | USE |
| 63_W1..W5,WAOE,TERMS | Hot Streak | 195283 | Hot Streak | spec passive Fire (W-SS 63) | M | Kampfeshitze / Bonne série | USE. The buff 48108 is "Hot Streak!" (with "!"). It is no talent or spec spell, so it is probably not known (I) |
| 63_W2,W3,TERMS | Heating Up | 48107 | Heating Up | buff only | M (data) / I (not known) | Aufwärmen / Réchauffement | KEEP. There is no talent or passive with this name |
| 63_W4 | Pyroclasm | 269650 | Pyroclasm | Fire talent r10c5 | M | Pyroklasmus / Pyroclasme | USE |
| 63_WAOE | Fuel the Fire | 416094 | Fuel the Fire | Fire talent r3c6 (hidden passive) | M | Öl ins Feuer / Alimenter le feu | USE |
| 64_W2,W5 | Brain Freeze | 190447 | Brain Freeze | Frost talent r5c1 | M | Hirnfrost / Gel mental | USE |
| 64_W3,W5 | Fingers of Frost | 112965 | Fingers of Frost | Frost talent r2c5 | M | Eisige Finger / Doigts de givre | USE |
| 64_W2..W5,TERMS | Freezing | 1221389 | Freezing | debuff only (20 stacks) | M (data) / I | Eingefroren / Gel | KEEP. There is no known spell with this name |
| 64_WAOE | Freezing Rain | 270233 | Freezing Rain | Frost talent r6c6 | M | Gefrierender Regen / Pluie glaciale | USE |
| 65_W2 | Infusion of Light | 53576 | Infusion of Light | Holy talent r2c4 | M | Lichtinfusion / Imprégnation de lumière | USE |
| 71_TERMS | Anger Management | 152278 | Anger Management | class talent r10c1 | M | Aggressionsmanagement / Maîtrise de la rage | USE |
| 72_W2,W3,WAOE,TERMS | Enraged | 184361 | Enrage | spec passive Fury (W-SS 72) | M | Wutanfall / Enrager | USE\*. The name is the noun "Enrage" and the sentence says "Enraged". frFR is a verb ("Enrager"). Reword to "gives you {Enrage}", or KEEP |
| 72_W3 | Reckless Abandon | 396749 | Reckless Abandon | Fury talent r10c4 | M | Waghalsigkeit / Fougue téméraire | USE |
| 72_W3 | Bloodbath | 335096 | Bloodbath | override of Bloodthirst (flag "Spellcast Override In Spellbook") | M (data) / I | Blutbad / Bain de sang | KEEP or TEST. Not a talent, spec spell or skill-line spell, so likely grey outside Recklessness |
| 72_W3 | Crushing Blow | 335097 | Crushing Blow | override of Raging Blow | M (data) / I | Schmetterschlag / Coup écrasant | KEEP or TEST (same as Bloodbath) |
| 72_W4 | Sudden Death | 29725 | Sudden Death | Fury talent r3c2 (SC-TR entry 112301 / def 117306, spec 72) | M | Plötzlicher Tod / Mort subite | USE. Arms and Prot use the same 29725. warrior.md named 280721; that ID is in no talent tree. See side finding 2 |
| 102_W2 | Eclipse | 1239669 | Eclipse | Balance talent r1c4 | M | Finsternis / Éclipse | USE. The card already uses it in S3 |
| 102_W1 | Eclipses (plural) | 1239669 | Eclipse | as above | M | as above | USE\*. Rewrite to the singular, or KEEP |
| 102_W5,TERMS | Solar Eclipse | 1233346 | Solar Eclipse | override button. W-SLS: learned through 1239669 | M (data) / I | Sonnenfinsternis / Éclipse solaire | TEST. It has a learn row, so it may count as known |
| 102_TERMS | Lunar Eclipse | 1233272 | Lunar Eclipse | override button. No learn row found | M (data) / I | Mondfinsternis / Éclipse lunaire | TEST/KEEP. It may be grey while Solar is gold |
| 103_W5 | Clearcasting (Feral) | — (talent 16864) | Omen of Clarity | Feral talent r2c3. The Feral buff 135700 "Clearcasting" is not known | M | Omen der Klarsicht / Augure de clarté (buff: Freizaubern / Idées claires) | KEEP. There is no known spell named "Clearcasting" for Feral; 16864 reads "Omen of Clarity" |
| 104_W2 | Scintillating Moonlight | 238049 | Scintillating Moonlight | Guardian talent r5c7 (2 ranks) | M | Funkelndes Mondlicht / Clair de lune scintillant | USE |
| 104_W4 | Ursoc's Fury | 377210 | Ursoc's Fury | Guardian talent r8c1 | M | Ursocs Zorn / Fureur d’Ursoc | USE |
| 105_W1 | Lifetreading | 1217941 | Lifetreading | Resto talent r6c3 (replaces Efflorescence) | M | Lebensschreiter / Marche-vie | USE |
| 105_W4 | Master Shapeshifter | 289237 | Master Shapeshifter | Resto talent r9c1, choice 200 | M | Meisterlicher Gestaltwandler / Maître changeforme | USE |
| 105_WAOE | Abundance | 207383 | Abundance | Resto talent r9c8 | M | Überfluss / Abondance | USE |
| 250_W2 | Ossuary | 219786 | Ossuary | Blood talent r4c2 | M | Ossuarium / Ossuaire | USE |
| 250_WAOE | Blood Plague | 55078 | Blood Plague | debuff. It has a DK `SkillLineAbility` row (AcquireMethod 0) | M (data) / I | Blutseuche / Peste de sang | TEST. It may count as known through the skill line; if not, KEEP |
| 250_WAOE | Hemostasis | 273946 | Hemostasis | Blood talent r5c5 | M | Hämostase / Hémostase | USE |
| 251_W1,W2,W3,WAOE | Killing Machine | 51128 | Killing Machine | Frost DK talent r3c2 | M | Tötungsmaschine / Machine à tuer | USE |
| 251_W1,W2,W3 | Rime | 59057 | Rime | spec passive Frost DK (W-SS 251) | M | Raureif / Frimas | USE |
| 252_W1,W2 | Commander of the Dead | 390259 | Commander of the Dead | Unholy talent r9c6 | M | Kommandant der Toten / Commandant des morts | USE |
| 252_W2 | Dread Plague | 1240996 | Dread Plague | debuff only | M (data) / I | Schreckensseuche / Peste d’effroi | KEEP |
| 252_W3 | Sudden Doom | 49530 | Sudden Doom | Unholy talent r2c5 | M | Hereinbrechende Verdammnis / Malédiction soudaine | USE |
| 252_WAOE | Cycle of Death | 1290864 | Cycle of Death | Unholy talent r6c2 | M | Kreislauf des Todes / Cycle de la mort | USE |
| 253_W2,W4 | Kill Command | 34026 | Kill Command | BM talent r1c4 (already on the card) | M | Tötungsbefehl / Ordre de tuer | USE. In W2, "two Kill Commands" = USE\* (plural) |
| 253_W2 | Nature's Ally | 1273126 | Nature's Ally | BM apex s3 (r11c4, idx 300); s1 = 1273043 | M | Verbündeter der Natur / Allié de la nature | USE. The effect the card describes (next Kill Command +dmg) is stage 3, per hunter.md (DB2 1273126/1276720). Use 1273043 if you want gold from stage 1 |
| 253_W4 | Killer Cobra | 199532 | Killer Cobra | BM talent r9c6 | M | Abgerichtete Kobra / Cobra tueur | USE |
| 253_WAOE | Wild Thrash | 1264359 | Wild Thrash | BM talent r4c2 (already on the card) | M | Wildes Hauen / Rossée sauvage | USE |
| 254_W1 | Unstable Trigger | 473520 | Unstable Trigger | MM talent r6c5, choice 200 | M | Instabiler Auslöser / Déclencheur instable | USE |
| 254_W3 | Bulletstorm | 389019 | Bulletstorm | MM talent r9c3, choice 200 | M | Kugelkanonade / Pluie de balles | USE |
| 254_W3,W4,TERMS | Aimed Shot | 19434 | Aimed Shot | MM talent r1c4 (already on the card) | M | Gezielter Schuss / Visée | USE |
| 254_WAOE | Multi-Shot | 257620 | Multi-Shot | spec spell MM (W-SS 254) (already on the card) | M | Mehrfachschuss / Flèches multiples | USE |
| 254_TERMS | Precise Shots | 260240 | Precise Shots | MM talent r2c5 | M | Präzise Schüsse / Tirs précis | USE |
| 255_W1,W2,W4,TERMS | Tip of the Spear | 260285 | Tip of the Spear | Survival talent r3c5 | M | Speerspitze / Pointe de la lance | USE |
| 255_W1 | Twin Fangs | 1272139 | Twin Fangs | Survival talent r9c3 | M | Doppelfangzahn / Doubles crocs | USE |
| 255_W1 | Takedown | 1250646 | Takedown | Survival talent r8c4 (already on the card) | M | Ausschalten / Plaquage au sol | USE |
| 255_W2,TERMS | Primal Surge | 1272154 | Primal Surge | Survival talent r6c6 | M | Urtümliche Woge / Afflux primordial | USE |
| 255_W2 | Kill Commands | 259489 | Kill Command | Survival talent r1c4 (replaces Steady Shot) | M | Tötungsbefehl / Ordre de tuer | USE\* (plural) |
| 255_W4 | Raptor Swipe | 1259003 | Raptor Swipe | Survival apex s1 (r11c4, idx 100); s2 1259017, s3 1259019 | M | Raptorhieb / Lacération du raptor | USE. Stage 1 is the one that adds Raptor Swipe |
| 255_WAOE | Wildfire Bomb | 259495 | Wildfire Bomb | Survival talent r2c3 (already on the card) | M | Lauffeuerbombe / Bombe de feu de brousse | USE |
| 255_WAOE | Boomstick | 1261193 | Boomstick | Survival talent r4c4 (already on the card) | M | Schrotbüchse / Bâton-boum | USE |
| 255_WAOE | Lethal Calibration | 1262409 | Lethal Calibration | Survival talent r10c5 | M | Tödliche Kalibrierung / Calibrage fatal | USE |
| 257_W3,W4 | Surge of Light | 109186 | Surge of Light | priest class talent r4c2 | M | Woge des Lichts / Vague de Lumière | USE |
| 257_WAOE,TERMS | Holy Words | — | (no row) | group name, not a spell | M (0 SpellName rows for "Holy Words"/"Holy Word") | — | KEEP |
| 258_WAOE | Psychic Link | 199484 | Psychic Link | Shadow talent r2c3 | M | Psychische Verbindung / Lien psychique | USE |
| 259_W2 | Venomous Wounds | 79134 | Venomous Wounds | Assassination talent r7c4 | M | Vergiftende Wunden / Blessures venimeuses | USE |
| 259_W3 | Seal Fate | 14190 | Seal Fate | Assassination talent r4c3 | M | Schicksal besiegeln / Destin scellé | USE |
| 260_W1 | Improved Adrenaline Rush | 395422 | Improved Adrenaline Rush | Outlaw talent r7c5 | M | Verbesserter Adrenalinrausch / Poussée d’adrénaline améliorée | USE |
| 260_W1, 261_W2 | Supercharger | 470347 | Supercharger | rogue class talent r9c4 | M | Superlader / Surchargeur | USE |
| 260_W2 | Double Trouble | 1214934 | Double Trouble | Roll the Bones buff only | M (data) / I | Ärger im Doppelpack / Double peine | KEEP |
| 260_W2 | One of a Kind | 1214933 | One of a Kind | Roll the Bones buff only | M (data) / I | Einzigartig / Unique en son genre | KEEP |
| 260_W4 | Fan the Hammer | 381846 | Fan the Hammer | Outlaw talent r9c7 | M | Aus der Hüfte / Moulinet au marteau | USE |
| 260_WAOE | Deft Maneuvers | 381878 | Deft Maneuvers | Outlaw talent r4c7 | M | Geschickte Manöver / Manœuvres habiles | USE |
| 261_W3 | Premeditation | 343160 | Premeditation | Sub talent r3c2 | M | Konzentration / Préméditation | USE |
| 261_W4,TERMS | Shadow Techniques | 196912 | Shadow Techniques | spec passive Sub (W-SS 261) | M | Schattentechniken / Techniques des Ombres | USE |
| 263_W1..W4,TERMS | Maelstrom Weapon | 187880 | Maelstrom Weapon | Enh talent r1c4 | M | Waffe des Mahlstroms / Arme du Maelström | USE |
| 263_W1 | Windstrike | 115356 | Windstrike | override of Stormstrike in Ascendance. Shaman `SkillLineAbility` row (AcquireMethod 3) | M (data) / I | Windschlag / Frappevent | TEST. Probably grey outside Ascendance |
| 263_W2 | Flame Shock | 470411 | Flame Shock | shaman `SkillLineAbility` (AcquireMethod 2). SC-TR: Voltaic Blaze for 263 and 262 replaces 470411 | M | Flammenschock / Horion de flamme | USE. This is the ID the 262/264 cards already use. Note: 188389 reads "Horion de flamme**s**" in frFR |
| 263_W2 | Fire Novas | 1260666 | Fire Nova | Enh talent r7c6 ("Voltaic Blaze … chance to cause a Fire Nova") | M | Feuernova / Nova de feu | KEEP (or USE\*). The sentence credits the tier set, not this talent, so it would wrongly show grey for players without the talent. The name is also plural |
| 264_W2,TERMS (+W1 "Stormstream") | Stormstream Totem | 1267016 | Stormstream Totem | Resto Sham apex s1 (r11c4, idx 100); s3 1267120 = "Nature's/Ancestral Swiftness grants a use" | M | Totem der Sturmflut / Totem de flux tempétueux | USE (W1 = USE\*: "the {…} version"). The TERMS clause about Swiftness is stage 3: use 1267120 there if you want grey until stage 3 |
| 266_W4 | Demonic Cores | 267102 | Demonic Core | passive. W-SLS: learned through the Demoniac talent 426115 (Demo r2c3) | M | Dämonischer Kern / Cœur démoniaque | USE\* (plural). It is already on the card |
| 577_W1 | Eternal Hunt | 1270898 | Eternal Hunt | Havoc apex s1 (r11c3) = "The Hunt empowers your next Eye Beam" | M | Ewigwährende Jagd / Traque éternelle | USE |
| 1467_W1,W3,W4,TERMS | Essence Burst (Dev) | 359565 | Essence Burst | passive. W-SLS: learned through the Ruby Essence Burst 376872 / Azure Essence Burst 375721 talents (Dev) | M | Essenzexplosion / Explosion d’essence | USE (TEST once) |
| 1467_W1 | Animosity | 375797 | Animosity | Dev talent r5c4 | M | Animosität / Animosité | USE |
| 1468_W3,W5 | Essence Burst (Pres) | 369297 | Essence Burst | Pres talent r3c4 | M | Essenzexplosion / Explosion d’essence | USE |
| 1473_W4,W5 | Essence Burst (Aug) | 396187 | Essence Burst | Aug talent r2c5 | M | Essenzexplosion / Explosion d’essence | USE |
| 1468_W1,W3,W4,WAOE,TERMS | Echo / Echoes | 364343 | Echo | Pres talent r1c4 (already on the card) | M | Echo / Écho | USE. "Echoes" in W3 = USE\* |
| 1468_W2,W4 | Merithra's Blessing | 1256577 | Merithra's Blessing | Pres apex, lowest stage (idx 200); idx 400 = 1256689 "Dream Breath … chance to grant" | M | Merithras Segen / Bénédiction de Mérithra | USE. W2 (Dream Breath lights it) matches 1256689. The heal you cast is probably 1256581 "(desc=Green)" (I) |
| 1473_W2 | Fate Mirror | 412774 | Fate Mirror | Aug talent r7c6 | M | Schicksalsspiegel / Miroir de destin | USE |
| 1473_W3 | Duplicate | 1259173 | Duplicate | Aug apex s1 (r11c4) = "Breath of Eons summons a version of you" | M | Duplikat / Duplication | USE |
| 262_W1, 264_TERMS | Farseer | — | (no SpellName row) | hero tree: `TraitSubTree` 56 (also 72, 75) | M | Scharfseher / — | KEEP as a spell token. A localized name exists in `TraitSubTree`, but `{SPELL:}` cannot read it |
| 265_W3 | Soul Harvester | — | (no SpellName row) | hero tree: `TraitSubTree` 57 | M | Seelenernter / — | KEEP (as Farseer) |

**Outside scope, but in the example list** (they occur only in `_HERO*`/`_MISTAKE` lines, MEASURED with Grep):

| key(s) | plain | ID | enUS name | kind | M/I | deDE / frFR |
|---|---|---|---|---|---|---|
| 259_HERO1, 261_MISTAKE, 261_HERO1 | Darkest Night | 457058 | Darkest Night | Deathstalker hero talent (259, 261) | M | Dunkelste Nacht / Nuit noire |
| 260_HERO1, 261_HERO2 | Coup de Grace | 441423 | Coup de Grace | Trickster hero talent (260, 261). The button override is 441776 | M | Gnadenstoß / Achèvement |
| 260_HERO1 | Unseen Blade | 441146 | Unseen Blade | Trickster hero talent, free node | M | Ungesehene Klinge / Lame invisible |

## Side findings
1. **70_W4 uses `{SPELL:24275}` (Hammer of Wrath).** 24275 is not in the 12.1 trait data and not a spec spell. The 12.1
   talent is **1241288** (class r1c6, free for Ret) (M). 24275 does have a paladin `SkillLineAbility` row
   (AcquireMethod 3). What that value means is not established, so it is unclear whether 24275 counts as "known"
   (I). TEST: `/dump IsPlayerSpell(24275), IsPlayerSpell(1241288)` on Ret.
2. **Fury Sudden Death:** warrior.md gives 280721. The 12.1 Fury talent entry points to **29725** (SC-TR line with
   spec 72, row 3 col 2) (M). 280721 is a hidden passive that appears in no talent tree (M). Use 29725.
3. **Plural after a token** ("Kill Commands", "Demonic Cores", "Fire Novas", "Echoes", "Eclipses") becomes
   e.g. "Tötungsbefehls" in German (I). Other card lines already do this (`{SPELL:774}s`, `{SPELL:356995}s`,
   `{SPELL:55090}s`). Rewrite those sentences when you swap.
4. **KEEP rows** (Heating Up, Freezing, Bloodbath, Crushing Blow, Dread Plague, Double Trouble, One of a Kind, Feral
   Clearcasting, Holy Words, hero-tree names). The only way to show a localized name without a false grey is a token
   that skips the known-check, for example a buff ID with no grey. That is a code decision for the build chat. The
   localized names are already in the table, so the IDs are ready if that token ever exists.
