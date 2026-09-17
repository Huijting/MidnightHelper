# Audit klassenadvies — Mage, Warlock, Priest (12.1, 17 sep 2026)

Alleen gelezen, niets gewijzigd. Per regel: **BRON** = bevestigd door een genoemde, actuele (Midnight/12.1) gids; **AFGELEID** = mijn redenering over de code of over bronnen die het niet letterlijk zeggen.

## Hoe de kaart wordt opgebouwd (GEMETEN in de code)

- Kaart = `ns.GetSurvivalPlan()` (`Modules/SurvivalPlan.lua:300`), alleen getoond op de **DPS-track** van de Academy (`RoleAcademy.lua:722-727`), voor de **actieve** spec. Een Disc/Holy-priest die de DPS-track opent, ziet dus ook een kaart.
- Stappen: `defensive_1` → "keep this up, put it on BEFORE you pull"; `defensive_2/3/4` + `category="defensive"` → "when your health drops fast"; `heal_*` + `selfheal` → "to heal yourself"; `mobility` + `survival="escape"` → "to get away"; `interrupt` → "when it is casting something" (`SurvivalPlan.lua:75-84`, teksten `enUS.lua:810-814`).
- Binnen een stap: sorteren op `priority`, bij gelijke waarde **alfabetisch op key** (`SurvivalPlan.lua:351-357`).
- Filter: `IsPlayerSpell`/`IsSpellKnown` op het basis-id; **passieve talenten komen daar ook doorheen** (AFGELEID).
- DPS-cooldownlijst: `ns.DPS_COOLDOWNS` wordt gefilterd met `IsPlayerSpell`, maar **alleen op de eigen actieve spec**; bij een preview van een andere spec wordt alles getoond (`RoleAcademy.lua:636-654`).
- `ns.DPS_DEFENSIVES` wordt sinds 5 aug **niet meer getoond** (`RoleAcademy.lua:667-679`); hieronder staat het wel, maar met lage prioriteit.
- Healer-toolkit (`HEALER_CORE_HEALS`, `HEALER_COOLDOWNS`, `HEALER_DEFENSIVES`) wordt **zonder enig bekend-filter** getoond (`RoleAcademy.lua:468-505`). Verwijderde spells staan daar dus gewoon op het scherm.

Belangrijkste bronnen:
- Method 12.1: https://www.method.gg/guides/frost-mage/playstyle-and-rotation · …/fire-mage/… · …/arcane-mage/… · …/affliction-warlock/… · …/demonology-warlock/… · …/destruction-warlock/… · …/discipline-priest/… · …/holy-priest/… · …/shadow-priest/…
- Icy Veins 12.1: https://www.icy-veins.com/wow/frost-mage-pve-dps-guide · …/fire-mage-pve-dps-guide · …/frost-mage-pve-dps-spell-summary · …/affliction-warlock-pve-dps-guide · …/demonology-warlock-pve-dps-guide · …/destruction-warlock-pve-dps-guide · …/discipline-priest-pve-healing-guide · …/holy-priest-pve-healing-guide · …/shadow-priest-pve-dps-guide · …/shadow-priest-pve-dps-easy-mode
- Method Fire intro (lijst met verwijderde spells): https://www.method.gg/guides/fire-mage/introduction
- Wowhead Fire pre-patch: https://www.wowhead.com/guide/classes/mage/fire/midnight-pre-patch
- Maxroll Frost M+ 12.0.1: https://maxroll.gg/wow/class-guides/frost-mage-mythic-plus-guide
- Kandidaat-cd's: `JustAC/Data/SpellCooldowns.lua` (gegenereerd uit clientbuild 12.1.0.69382). Dat is een kandidaat, geen bewijs: een verwijderde spell kan in de DB2 blijven staan.
- ⚠️ azerlogs.com zegt dat Ice Block in Midnight "geen immuniteit meer" is. Dat spreekt Method én Icy Veins 12.1 tegen, en de site oogt automatisch gegenereerd. Ik heb hem **niet** als bron gebruikt.

---

## MAGE — gedeeld

Kaart (AFGELEID uit de classifier):
- Arcane: Prismatic Barrier → Ice Block/Ice Cold → Alter Time → Greater Invisibility → Mirror Image → Blink/Shimmer → Frost Nova → (Invisibility, weggefilterd als je Greater Invisibility hebt) → Counterspell
- Fire: Blazing Barrier → Ice Block/Ice Cold → Alter Time → Greater Invisibility → **Cauterize** → Mirror Image → ontsnappen → Counterspell
- Frost: Ice Barrier → Ice Block/Ice Cold → Alter Time → Greater Invisibility → Mirror Image → ontsnappen → Counterspell

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Prismatic / Blazing / Ice Barrier | 235450 / 235313 / 11426 | keepup (defensive_1), per spec | OK (BRON) | Klopt: een schild op een korte cooldown dat je vóór de schade opzet. In 12.1 krijgt Fire een 2e charge (Improved Blazing Barrier), Frost via Glacial Bulwark. Cd 30 s (25 s met Barrier Diffusion). | Method Frost/Fire/Arcane; Icy Veins Fire 12.1 |
| Ice Block (→ Ice Cold) | 45438 (→ 414658) | hurts (defensive_3, prio 1); DPS_DEF cd 240 | OK, volgorde FOUT (AFGELEID) | Ice Block = immuniteit, Ice Cold = 70% minder schade. Dit is de noodknop en hoort **achteraan** in "hurts", niet vooraan. Cd: basis 240 s volgens JustAC en Icy Veins (3 min met Winter's Protection); Method schrijft "3 min by default" → TWIJFEL over de basiswaarde. | Method; Icy Veins spell summary |
| Alter Time | 342245 | hurts (category defensive, prio 2), cd 60 | OK (BRON) | Klopt. Voor beginners moeilijk; Temporal Realignment (passief, activeert op 24% HP) is voor hen vaak beter. | Method; Icy Veins Frost 12.1 |
| Greater Invisibility | 110959 | hurts (category defensive, prio 3); DPS_DEF [62] cd 120 | **FOUT (BRON)** | In Midnight is het schadereductie-deel **verwijderd**. Het is nu alleen een aggro-drop/hulpmiddel en hoort niet onder "when your health drops fast". Hooguit onder "to get away". | Method Fire; Icy Veins Frost ("no longer provides a damage reduction"); Maxroll |
| Mirror Image | 55342 | hurts (category defensive, prio 5) | **FOUT voor Fire/Frost (BRON)**; TWIJFEL voor Arcane | Geen schadereductie meer; de kopieën duren 15 s. Alleen Arcane met het talent Refractive Images maakt er weer een defensive van (30% uitgesmeerd over tijd). | Icy Veins Frost; Method Fire; Method Arcane (Refractive Images) |
| Cauterize (Fire) | — | hurts (category defensive, prio 4) | **FOUT (AFGELEID)** | Een **passieve** cheat-death. Hij bestaat nog (Icy Veins Fire 12.1), maar is geen knop. Omdat het bekend-filter passieven doorlaat, noemt de kaart hem als iets om in te drukken. | Icy Veins Fire 12.1 |
| Blink / Shimmer | 1953 / 212653 | escape (survival-tag) | OK (BRON) | Klopt. Shimmer heeft in Midnight een langere cooldown. | Icy Veins Frost |
| Frost Nova | 122 | escape (survival-tag) | OK (AFGELEID) | Wortelt vijanden rondom je; prima als ontsnapping. | Icy Veins Fire spell summary |
| Invisibility | 66 | escape (survival-tag) | TWIJFEL (AFGELEID) | Word je pas na 3 s onzichtbaar, dan werkt het in een gevecht slecht als ontsnapping. Als aggro-drop is het wel zinvol. | Icy Veins Fire spell summary |
| Counterspell | 2139 | interrupt | OK (BRON) | Klopt. | Icy Veins Fire spell summary |

Ontbreekt (Mage):
- **Temporal Realignment** (passief, heelt je automatisch als Alter Time klaarstaat) — hoeft geen knop te zijn, wel een uitleg. BRON: Icy Veins Frost.
- **Cold Snap** (Frost; keuzeknoop tegenover Glacial Bulwark) reset Ice Barrier en Ice Cold/Ice Block, cd 5 min. Staat als `category="cooldown"` en komt dus niet op de kaart. BRON: Icy Veins Frost, Overgear.
- **Dragon's Breath** (Fire) als ontsnapping/stop — staat als `dispel_cc`, niet op de kaart. AFGELEID.
- Mass Barrier is **terecht** afwezig: verwijderd (BRON Maxroll, Method Fire).

### Arcane (62) — DPS-cooldowns
| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Arcane Surge | 365350 | cd 90 | OK (BRON) | 1,5 min | Method Arcane |
| Touch of the Magi | 321507 | cd 45 | OK (BRON) | 45 s | Method Arcane |
| Arcane Orb | 153626 | cd 20 | OK (AFGELEID, JustAC 20 s) | — | JustAC |
| Shifting Power | 314791 | cd 60 | **FOUT (BRON)** | **Verwijderd** in Midnight. Weghalen. | Method Fire intro; Maxroll Frost; Overgear |

### Fire (63) — DPS-cooldowns
| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Combustion | 190319 | cd 120 | TWIJFEL (BRON) | Basis 120 s, met **Kindling** vast 60 s. Method noemt het "a static 1 minute cooldown"; Kindling pakt vrijwel iedereen. Toon 60 s of noem beide. | Method Fire intro + playstyle; Wowhead pre-patch |
| Meteor | 153561 | cd 45 | OK (BRON bestaat; cd AFGELEID uit JustAC) | — | Method Fire |
| Living Bomb | 44457 | cd 30 | TWIJFEL (AFGELEID) | Geen enkele 12.1-gids noemt hem; een forumpost zegt "we went from Living Bomb … to ignite builds". Waarschijnlijk verdwenen. In-game nagaan. | Blizzard-forum 12.0.1 |

Classifier Fire: **Phoenix Flames** (`KeybindRoles_Mage.lua:143`) is **verwijderd** (BRON Method Fire intro, Wowhead pre-patch).

### Frost (64) — DPS-cooldowns
| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Icy Veins | 12472 | cd 120, **eerste regel** | **FOUT (BRON)** | "Icy Veins has been removed, and our main cooldown is now Ray of Frost." Weghalen uit DPS_COOLDOWNS en uit de classifier (`KeybindRoles_Mage.lua:172`, `cooldown_bar`/F1). | Icy Veins Frost 12.1; Overgear |
| Frozen Orb | 84714 | cd 60 | OK (BRON) | — | Overgear; Icy Veins Frost |
| Ray of Frost | 205021 | cd 60 | OK (BRON), moet de hoofd-cooldown zijn | Nu dé grote cooldown; 2 charges via het Apex-talent. Hoort bovenaan, en in de classifier als `cooldown_bar`. | Icy Veins Frost; Method Frost |
| Ice Nova | 157997 | cd 25 | TWIJFEL | Geen 12.1-gids noemt hem. Het filter verbergt hem als je hem niet hebt. | — |

Classifier Frost, verder: **Ice Floes** (`:71`) verwijderd (BRON Icy Veins Frost); **Glacial Spike** (`:165`) en **Comet Storm** (`:169`) zijn geen losse spells meer, ze veranderen Frostbolt resp. Ray of Frost (BRON Icy Veins Frost). Coldest Snap is verwijderd; Method noemt hem nog, maar dat is een verouderde regel (BRON Icy Veins Frost).

---

## WARLOCK — gedeeld

Kaart (AFGELEID): **Dark Pact** (keepup) → **Fear** (hurts) → Unending Resolve (hurts) → Drain Life (heal) → Healthstone (heal, zie hieronder) → *geen ontsnapping* → Spell Lock + Call Felhunter (Affliction/Destruction) of Axe Toss (Demonology).
Fear en Unending Resolve hebben allebei prioriteit 1 en worden dan alfabetisch gesorteerd, dus **Fear staat bovenaan de "health drops fast"-regels**.

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Dark Pact | 108416 | keepup (defensive_1); cd 60 | TWIJFEL (BRON) | Geen schild dat je ophoudt. Hij offert 20% van je **huidige** HP voor een schild van 200% daarvan; druk hem bij hoge HP, vlak vóór de schade. "Put it on before you pull" klopt half, "keep this up" niet. Cd 60 s (45 s met Frequent Donor). | Method Affliction/Destruction/Demonology |
| **Fear** | 118699 | **hurts (role defensive_2)** | **FOUT (AFGELEID)** | Een crowd-control op één doelwit, geen defensive. De rol is alleen gebruikt om hem op toets X te krijgen (`KeybindSchema.lua:112`), maar daardoor staat hij op de overlevingskaart. Weghalen van de kaart. | — |
| Unending Resolve | 104773 | hurts (defensive_3); cd 180 | OK (BRON) | 25% minder schade, 8 s, 3 min (40% met Strength of Will; 2:15 met Dark Accord). De grote knop, hoort achteraan. | Method Affliction/Demonology |
| Drain Life | 234153 | heal (heal_quick) | OK (BRON) | Geen cooldown, maar je moet stilstaan. | Method Destruction |
| Healthstone | (naam) | heal (heal_ooc) | TWIJFEL (AFGELEID) | Een item, geen spell. Een naam-lookup geeft waarschijnlijk 6262 terug, en `IsPlayerSpell` zegt daarop vermoedelijk nee → onzichtbaar. Voor warlocks is het met **Pact of Gluttony** (Demonic Healthstone, 452930) een in-combat knop met 1 min cooldown. Het label "ooc" is fout; Method noemt hem "one of the abilities you should always be seeking to use first". | Method Destruction/Affliction |
| Spell Lock / Call Felhunter | 19647 / 212619 | interrupt (265, 267) | OK / TWIJFEL | Spell Lock via de Felhunter klopt (BRON Icy Veins Affliction). Call Felhunter wordt in geen enkele 12.1-gids genoemd. Spell Lock is een **pet**-spell; of de naam-lookup hem voor de speler vindt, is niet gemeten. | Icy Veins Affliction/Destruction |
| Axe Toss (Demo) | 89766 | interrupt | OK (BRON) | Felguard-onderbreking/stun. Let op: Grimoire: Fel Ravager heeft sinds 12.0.5 **Devour Magic** in plaats van Spell Lock. | Icy Veins Demonology (12.0.5-notes) |

Ontbreekt (alle drie de specs):
- **Mortal Coil** (6789) — heelt je voor 20% (25% met Improved Mortal Coil), cd 45 s. Hoort bij "to heal yourself", maar staat als `dispel_cc` (`KeybindRoles_Warlock.lua:78`). BRON: Method Affliction/Destruction/Demonology.
- **Demonic Circle: Teleport** en **Burning Rush** — de ontsnapping van de klasse. Ze staan als `utility_primary` zonder `survival="escape"` (`:67-68`), dus de stap "to get away" ontbreekt helemaal. BRON: Method Demonology/Destruction; azerlogs noemt het ook.
- **Soulburn**-combinaties (Healthstone/Drain Life) — gevorderd, optioneel. BRON: Method.
- Health Funnel is terecht afwezig: verwijderd (BRON Icy Veins).

### Affliction (265) — DPS-cooldowns
| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Summon Darkglare | 205180 | cd 120 | OK (spell BRON; cd AFGELEID uit JustAC) | Nu een versterking op één doelwit (geen DoT-verlenging meer). | Icy Veins Affliction; Method |
| Soul Rot | 325640 | cd 60 | **FOUT (BRON)** | Verwijderd | Icy Veins Affliction: "Soul Rot, Vile Taint and Phantom Singularity have been removed" |
| Vile Taint | 278350 | cd 30 | **FOUT (BRON)** | Verwijderd (en de classifier noemt id 386931, de DpsToolkit 278350: inconsistent) | idem |
| Phantom Singularity | 205179 | cd 45 | **FOUT (BRON)** | Verwijderd | idem |
| — ontbreekt: **Dark Harvest** | ? | — | ONTBREEKT (BRON) | Nieuwe cooldown van 1 min. Id niet geverifieerd. | Icy Veins Affliction; Method |
| — ontbreekt: **Malevolence** (Hellcaller) | 446285 (kandidaat) | — | ONTBREEKT (BRON) | Hellcaller-cooldown, ook voor Destruction | Method Affliction/Destruction |

Classifier Affliction: **Malefic Rapture** (`:110`) verwijderd (BRON Icy Veins); Soul Rot/Phantom Singularity/Vile Taint (`:118-120`) verwijderd (BRON).

### Demonology (266) — DPS-cooldowns
| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Summon Demonic Tyrant | 265187 | cd 60 | OK spell (BRON), cd TWIJFEL | Herontworpen (schaalt met Imps/Dreadstalkers). Een cd van 60 s komt alleen uit JustAC. | Icy Veins Demonology |
| Grimoire: Felguard | 111898 | cd 120 | **FOUT (BRON)** | "Grimoire: Felguard has been removed." Vervangen door een keuze tussen Grimoire: Imp Lord en Grimoire: Fel Ravager. | Icy Veins Demonology |
| Call Dreadstalkers | 104316 | cd 20 | OK (BRON) | — | Method Demonology |
| Summon Vilefiend | 264119 | cd 25 | **FOUT (BRON)** | "not a separate spell anymore but … attached to Summon Dreadstalkers". Ook in de classifier (`:137`, daar staat nog "~45s"). | Icy Veins Demonology |
| — ontbreekt: **Summon Doomguard** | ? | — | ONTBREEKT (BRON) | Nu een echte cooldown | Icy Veins Demonology; Method opener |

### Destruction (267) — DPS-cooldowns
| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Summon Infernal | 1122 | cd 120 | OK (BRON) | 2 min basis, 90 s met Inferno. De classifier-commentaar noemt 157898; dat is onschuldig (lookup op naam), maar wel inconsistent. | Method Destruction |
| Channel Demonfire | 196447 | cd 25 | TWIJFEL | Geen 12.1-gids noemt hem. Het filter verbergt hem als je hem niet hebt. | — |
| Cataclysm | 152108 | cd 30 | OK (spell BRON; cd AFGELEID) | Bestaat nog (Lake of Fire ondersteunt hem) | Icy Veins Destruction |
| — ontbreekt: Malevolence (Hellcaller), Soul Fire / Dimensional Rift (keuzeknoop) | | | ONTBREEKT (BRON) | | Method / Icy Veins Destruction |

---

## PRIEST

### Shadow (258)
Kaart (AFGELEID): Power Word: Shield (keepup) → Dispersion (hurts) → Desperate Prayer (heal) → Angelic Feather (escape) → Silence (interrupt).

| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Power Word: Shield | 17 | keepup (defensive_1) | TWIJFEL (BRON) | Icy Veins noemt het "one of your last resort spells"; Method zegt "the occasional Power Word: Shield". Geen schild om op te houden. | Icy Veins Shadow easy mode; Method Shadow |
| Dispersion | 47585 | hurts (defensive_3) | OK (BRON) | De grote noodknop; baseline voor Shadow. Cd 120 s (JustAC); `DPS_DEFENSIVES` heeft geen cd. | Icy Veins Shadow; Method |
| Desperate Prayer | 19236 | heal (heal_quick), cd 90 | OK (BRON) | Nu een talent in de klassenboom | Icy Veins Shadow |
| Angelic Feather | 121536 | escape (mobility) | OK (BRON) | Enige mobiliteit van de priest | Method Disc |
| Silence | 15487 | interrupt | OK (BRON) | Baseline voor Shadow (level 26), cd 30 s | Icy Veins Shadow; Maxroll |

Ontbreekt (Shadow):
- **Fade + Translucent Image** — 10% minder schade, "use it early and often", cd 30 s. Staat als `utility_primary` zonder survival-tag (`KeybindRoles_Priest.lua:61`). BRON: Icy Veins Shadow easy mode; Method Shadow.
- **Vampiric Embrace** — baseline, groepsheal/zelfheal. Staat als `category="cooldown"` (`:147`). BRON: Icy Veins Shadow.
- **Flash Heal + Protective Light** (10% minder schade op jezelf). BRON: Icy Veins easy mode.

DPS-cooldowns [258]:
| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Voidform | 228260 | cd 120 | OK (spell BRON; cd AFGELEID) | "Cast Voidform on cooldown" | Icy Veins easy mode |
| Dark Ascension | 391109 | cd 60 | **FOUT (BRON)** | "Dark Ascension has been removed" | Icy Veins Shadow |
| Power Infusion | 10060 | cd 120 | OK (BRON) | — | Icy Veins |
| Void Torrent | 263165 | cd 30 | OK maar talent (BRON) | Alleen voor Voidweaver | Icy Veins Shadow |
| — ontbreekt: Halo (Archon, 1 min) | | | ONTBREEKT (BRON) | | Icy Veins Shadow |

Classifier Shadow: **Mindbender** (`:183`) en **Shadowfiend** (`:81`, specs 256/258) zijn nu **passief** (BRON Icy Veins Shadow + Disc). `DPS_DEFENSIVES[258]` Dispersion zonder cd (klein).

### Discipline (256)
Kaart (AFGELEID): Power Word: Shield (keepup) → **Power Word: Barrier** (hurts, prio 1) → Pain Suppression (hurts, prio 2) → Desperate Prayer (heal) → Angelic Feather (escape) → geen interrupt (klopt).

| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Power Word: Shield | 17 | keepup | OK (AFGELEID) | Voor Disc een rotatieknop; als zelfschild vóór de schade prima | Method Disc |
| Power Word: Barrier | 62618 | hurts (defensive_3, prio 1) | TWIJFEL (BRON) | Een grondcirkel voor de hele raid (20% minder schade), 3 min. Method: neem hem alleen als je er veel waarde uit haalt, want Ultimate Penitence is meestal beter. Niet de eerste persoonlijke knop voor een beginner. | Method Disc |
| Pain Suppression | 33206 | hurts (category defensive) | OK (BRON) | "don't be afraid to use it selfishly"; 50% minder schade, 3 min, extra charge met talent | Method Disc |
| Desperate Prayer | 19236 | heal | OK (BRON) | Icy Veins: "our primary defensive cooldown" | Icy Veins Disc |

Ontbreekt (Disc): **Fade + Translucent Image**, **Flash Heal + Protective Light** (BRON Method Disc, Icy Veins Disc).

Healer-toolkit [256] (getoond **zonder** filter):
| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Ultimate Penitence | 421453 | cd 240, heal/flow | OK (BRON) | "massive 4-minute cooldown" | Method Disc |
| Power Word: Barrier | 62618 | cd 180, mitig/raid | OK (BRON) | — | Method Disc |
| Pain Suppression | 33206 | cd 180, ext | OK (BRON) | — | Method Disc |
| Evangelism | 472433 | cd 90, heal/**flow**, commentaar "extends atonement" | **FOUT in uitleg (BRON)** | Herontworpen: cast direct Power Word: Radiance en maakt je volgende 2 Radiance-casts instant; verlengt **niets** meer. Het is een ramp-knop vóór raidschade → when = "raid". Cd niet geverifieerd. | Method Disc; Icy Veins Disc |
| Power Infusion | 10060 | util | OK | — | Method |
| core: Power Word: Shield | 17 | shield | OK | — | — |
| core: **Shadow Mend** | 186263 | fast | **FOUT (BRON)** | 12.1: "updated to be a passive upgrade to Flash Heal". Toon **Flash Heal** (2061) en noem Shadow Mend als upgrade. | Icy Veins Disc 12.1 |
| core: Power Word: Radiance | 194509 | aoe | OK | — | Method Disc |
| core ontbreekt | | | ONTBREEKT (BRON) | **Penance**, **Flash Heal**, **Plea** (vervangt Renew voor Disc) | Icy Veins Disc; Method Disc |
| defensives: alleen Desperate Prayer | 19236 | cd 90 | ONVOLLEDIG (BRON) | + Fade/Translucent Image, + Pain Suppression op jezelf | Method Disc |

Classifier Disc: **Spirit Shell** (`:98`) is al sinds Dragonflight weg (JustAC `SpellCategories.lua:105`, AFGELEID); **Rapture** (`:97`) wordt door geen enkele 12.1-gids genoemd → TWIJFEL; **Shadow Mend** click_cast (`:105`) is nu passief; **Renew** (`:106`) is voor Disc vervangen door Plea (BRON).

### Holy (257)
Kaart (AFGELEID): **Power Word: Shield** (keepup) → Guardian Spirit (hurts) → Desperate Prayer (heal) → Angelic Feather (escape).

| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Power Word: Shield | 17 | keepup, `specs={256,257,258}` | **FOUT (BRON)** | Icy Veins Holy: "removed … Power Word: Shield, Power Word: Life, Divine Star, Divine Word". Het filter verbergt hem waarschijnlijk (AFGELEID), maar de data beweert het wel. | Icy Veins Holy 12.1 |
| Guardian Spirit | 47788 | hurts (defensive_3) | OK (BRON) | Een cheat-death die ook op jezelf kan; Divine Hymn geeft je hem in 12.1 zelfs automatisch. Cd 3 min (1 min met Guardian Angel). | Method Holy; Icy Veins Holy |
| Desperate Prayer | 19236 | heal | OK (BRON) | — | Method Holy |

Ontbreekt (Holy): Fade + Translucent Image, Flash Heal + Protective Light, Angelic Bulwark en Restitution (passief; uitleg, geen knop). BRON: Method Holy, Icy Veins Holy.

Healer-toolkit [257] (zonder filter):
| spell | id | addon | oordeel | moet zijn | bron |
|---|---|---|---|---|---|
| Holy Word: Salvation | 265202 | cd 720 | TWIJFEL | Geen enkele 12.1-gids (Method, Icy Veins) noemt hem nog; alleen Apotheosis en Divine Hymn heten de cooldowns. In-game nagaan. | Method Holy; Icy Veins Holy |
| Divine Hymn | 64843 | cd 180 | OK (BRON) | 2 min met Seraphic Crescendo; geeft nu ook Guardian Spirit | Method Holy |
| Apotheosis | 200183 | cd 120 | OK (spell BRON; cd AFGELEID) | — | Method Holy |
| Guardian Spirit | 47788 | cd 180 | OK (BRON) | — | Method Holy |
| Power Infusion | 10060 | | OK | — | Method Holy |
| core: Flash Heal | 2061 | | OK | — | — |
| core: **Heal** | 2060 | big | **FOUT (BRON)** | Verwijderd | Icy Veins Holy ("Notable talents that have been removed include Renew, Heal, Lightwell, Shadowfiend, and Symbol of Hope") |
| core: **Renew** | 139 | hot | **FOUT (BRON)** | Verwijderd als knop (Lasting Words legt hem nog passief) | idem; Method Holy |
| core: Prayer of Mending / Prayer of Healing | 33076 / 596 | | OK (BRON) | — | Method Holy |
| core ontbreekt | | | ONTBREEKT (BRON) | **Holy Word: Serenity**, **Holy Word: Sanctify**, Halo (Archon) | Method Holy |

Classifier Holy: **Heal** (`:128`), **Symbol of Hope** (`:119`), **Power Word: Life** (`:121`) verwijderd (BRON Icy Veins Holy; één andere site zegt dat Power Word: Life klassenbreed is → licht TWIJFEL); Renew (`:106`) verwijderd.

---

## Structurele oorzaken

1. **Toetsrollen worden als overlevingsadvies gelezen.** `SurvivalPlan.lua:76-78` zet elke `defensive_2/3/4` en elke `category="defensive"` onder "when your health drops fast". `defensive_N` is een **toetsplek** (`KeybindSchema.lua:111-113`: Z/X/C), geen soort spell. Daarom belandt Fear (`KeybindRoles_Warlock.lua:77`), dat alleen op X moest komen, op de overlevingskaart. Hetzelfde patroon als de Paladin-bug.
2. **`defensive_1` = "keep this up" is alleen waar voor mage-barrières.** Voor Dark Pact (`Warlock.lua:71`) en Power Word: Shield (`Priest.lua:63`) klopt het niet. De uitleg hoort per spell te zijn (`survival`-tag), niet per toetsplek (`SurvivalPlan.lua:33-35` kiest hier bewust anders).
3. **`priority` betekent "wie krijgt de toets", niet "wat druk je eerst".** De kaart sorteert erop (`SurvivalPlan.lua:351-357`). Gevolg: Ice Block (prio 1) staat vóór Alter Time; Fear en Unending Resolve (beide prio 1) staan alfabetisch, dus Fear eerst; Power Word: Barrier vóór Pain Suppression. Een aparte `survivalOrder` zou dit oplossen.
4. **Passieve talenten halen het bekend-filter.** `IsPlayerSpell` is ook waar voor passieven (`SurvivalPlan.lua:166-179`) → Cauterize (`Mage.lua:150`) staat er als knop. Een check met `C_Spell.IsSpellPassive` ontbreekt.
5. **De stap "to get away" komt alleen van de rol `mobility` of een handmatige tag** (`SurvivalPlan.lua:81`). Warlock heeft geen van beide → geen ontsnapping. Ook Mortal Coil (`Warlock.lua:78`), Fade (`Priest.lua:61`) en Vampiric Embrace (`Priest.lua:147`) missen een `survival`-tag.
6. **De classifiers en toolkits zijn nooit langs de Midnight-snoei gehaald.** De bronnen in de koppen zijn addon-data (JustAC, ClassCodex, LibOpenRaid), niet de 12.x-gidsen (`Mage.lua:11-39`, `Warlock.lua:9-39`, `Priest.lua:8-27`, `DpsToolkit.lua:7-10`, `HealerCooldowns.lua:7-11`). JustAC's cooldowntabel komt uit de client-DB2, en daar blijven verwijderde spells in staan. Dat is precies het "kandidaat, geen bewijs"-probleem uit CLAUDE.md. Verwijderd maar nog aanwezig: Icy Veins, Ice Floes, Phoenix Flames, Shifting Power, Soul Rot/Vile Taint/Phantom Singularity, Malefic Rapture, Grimoire: Felguard, Summon Vilefiend, Dark Ascension, Heal, Renew, Symbol of Hope, Spirit Shell, en Shadowfiend/Mindbender als knop. Greater Invisibility en Mirror Image staan nog als defensive terwijl hun schadereductie weg is.
7. **De healer-toolkit filtert niet** (`RoleAcademy.lua:468-505`, tegenover het filter voor DPS op `:636-654`). Verwijderde Heal/Renew/Shadow Mend staan daardoor echt op het scherm. Omgekeerd verbergt het DPS-filter een fout id **stil** op de eigen spec, en toont het alles bij een preview. Een verkeerde regel valt zo nooit op (vgl. [[silence-is-not-absence]]).
8. **Cooldowns zijn basiswaarden.** Talenten die bijna iedereen neemt (Combustion 60 s met Kindling, Summon Infernal 90 s met Inferno, Ice Block 3 min met Winter's Protection) staan er niet in. Er is ook geen veld om dat te zeggen.
9. **Het commentaar belooft te veel.** `SurvivalPlan.lua:11-13` zegt "verified against JustAC and ClassCodex" en `:20-21` "already checked". Voor spelinhoud is dat geen verificatie, en het wekt vertrouwen dat de data niet verdient.
