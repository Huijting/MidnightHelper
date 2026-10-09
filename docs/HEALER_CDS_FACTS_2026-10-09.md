# Healer-cooldowns: wat ontbreekt in 12.1 (feitenrapport 9 okt 2026)

Voor `Modules/HealerCooldowns.lua` -> `ns.HEALER_COOLDOWNS`. Alleen gelezen, niets aan code veranderd.

## Bronnen

- **[DB2]** wago.tools, live build **12.1.0.69933** (`/api/builds`: `wow` = 12.1.0.69933, aangemaakt 2026-09-22),
  gelezen op 9 okt 2026. Tabellen: `TraitDefinition` -> `TraitNodeEntry` -> `TraitNodeXTraitNodeEntry` -> `TraitNode`
  (boom), `SpecializationSpells`, `SkillLineAbility`, `PvpTalent`, `SpellCooldowns`, `SpellCategories`/`SpellCategory`.
  Actieve klassebomen volgens `SkillLineXTraitTree`: Paladin 790, Druid 793, Priest 795, Shaman 786, Monk 1000,
  Evoker 872. De bomen 701, 781, 1033 en 1034 hangen aan geen klasse: dat zijn oude bomen die DB2 bewaart.
- **[IV]** Icy Veins 12.1, "Spell List and Glossary" per spec (bijgewerkt 10 aug 2026, Mistweaver 12 aug) en de
  pagina's "Rotation, Cooldowns" van Holy Paladin en Resto Druid (10 aug 2026).
- **[WH]** Wowhead, Holy Priest Midnight pre-patch gids en Resto Shaman rotatiegids (Midnight); Method Holy Priest 12.1.
- **[MP]** mechanicalpriest.com: de pagina's voor patch 12.0.1 en 11.1.0. warcraft.wiki.gg "Holy Word: Salvation".

Positieve controles (DB2, dezelfde run): Pain Suppression 33206 -> node 795:82587. Penance 47540 ->
SpecializationSpells spec 256. Prayer of Mending 33076 -> spec 257. Lay on Hands -> SkillLineAbility 800.
Emerald Communion 370960 -> PvpTalent spec 1468. Mijn zoekpatronen vinden dus wat er wél is.

Een spell telt hieronder als **"niet leerbaar in 12.1"** als hij geen node heeft in de actieve klasseboom, en ook niet
voorkomt in SpecializationSpells, SkillLineAbility of PvpTalent. Hij staat dan wel nog in SpellName en SpellCooldowns.

## De vijf kandidaten

| kandidaat | ID | uitkomst | status |
|---|---|---|---|
| Rapture (Disc) | 47536 | **Bestaat niet meer.** DB2: geen TraitDefinition, geen spec-, skill- of PvP-regel. SpellCooldowns heeft nog wel 90 s. IV Disc 12.1 noemt hem niet bij de actieve spreuken. | GEMETEN [DB2] [IV] |
| Spirit Shell (Disc) | 109964 | **Bestaat niet meer.** Zelfde patroon als Rapture: DB2 heeft alleen nog een cd van 90 s. | GEMETEN [DB2] [IV] |
| Symbol of Hope (Holy) | 64901 | **Verwijderd in 12.0.1.** DB2: niet leerbaar, ook niet voor Disc. In de removed-lijsten van [MP] 12.0.1, [WH] pre-patch en Method 12.1. AccountShark beweert dat hij "nog op Disc bestaat"; DB2 spreekt dat tegen. | GEMETEN [DB2] [MP] [WH] |
| Flourish (Druid) | 197721 | **Nu passief.** Talentnode 793:82053, maar geen cooldown in DB2. [IV] noemt hem bij de passives: hij verlengt je HoTs met 10 s als je Tranquility cast. Geen knop, dus geen rij. | GEMETEN [DB2] [IV] |
| Grove Guardians (Druid) | 102693 | **De knop is weg.** 102693 (3 ladingen x 20 s) is niet leerbaar. Het talent is nu 1226140 (node 793:82043, geen cd). [IV]: hij roept vanzelf een Treant op bij Wild Growth en Swiftmend. Geen rij. | GEMETEN [DB2] [IV] |

## Fout in de huidige tabel

- **Holy Word: Salvation 265202 (spec 257, regel 150) bestaat niet meer.** Hij is verwijderd in patch 11.1.0
  (25 feb 2025): warcraft.wiki.gg, [MP] 11.1.0, Icy Veins class changes en [WH]. DB2 12.1.0.69933 heeft nog
  TraitDefinition 108747, maar die hangt aan geen enkele node. SpellCooldowns heeft nog 720 s.
  [IV] Holy 12.1 noemt hem niet. — GEMETEN.
  - Gevolg (AFGELEID uit de code): `GetTopRaidCooldown(257)` geeft nu Salvation terug, want dat is de eerste
    `when == "raid"`. Na het schrappen wordt het Divine Hymn. `/mh healcds` en de Academy tonen hem nu aan Holy Priests.
  - Zo is hij er waarschijnlijk in gekomen (AFGELEID): `JustAC/Data/SpellCooldowns.lua` (build 69875) heeft
    `[265202]=720000`. DB2 bewaart verwijderde spells, en de module haalt zijn cd's uit dat bestand. Daar staan
    ook Holy Avenger 105809 (ook zonder node) en Emerald Communion in.

## Wat écht ontbreekt (DB2 + gids)

| spec | spell | ID | cd (DB2) | talent? | kind/when (voorstel) | status |
|---|---|---|---|---|---|---|
| Resto Druid 105 | Innervate | 29166 | 180 s | talent, node 793:82244 | util / often | ID, cd, node GEMETEN [DB2]. [IV] 12.1: geeft 25% van je max mana terug, cd 3 min; gebruik hem zo vaak mogelijk, de eerste rond 75% mana, meestal op jezelf. "often" past beter dan "mana", want de tekst van "mana" zegt *"the group's mana"* (AFGELEID) |
| Holy Paladin 65 | Avenging Crusader | 216331 | 60 s | talent 394088 (TraitDefinition 107573, VisibleSpellID 216331), **keuzenode met Avenging Wrath** (790:81584, Type 2) | heal / often | GEMETEN [DB2]. [IV]: vervangt Avenging Wrath, "much shorter cooldown". kind/when AFGELEID, net als bij Avenging Wrath |
| Mistweaver 270 | Restoral | 388615 | 180 s (1 lading) | **keuzenode met Revival** (1000:101131, Type 2) | heal / raid | GEMETEN [DB2] [IV]: werkt als Revival, maar zonder Magic-dispel. Na Revival zetten, dan blijft Revival de top-cd |
| Preservation 1468 | Zephyr | 374227 | 120 s | klassetalent, node 872:93346 | mitig / raid | GEMETEN [DB2]. [IV]: jij en de 4 dichtstbijzijnde bondgenoten krijgen 20% minder AoE-schade. kind/when AFGELEID (zelfde soort knop als Aura Mastery) |

Optioneel: ID, cd en node zijn gemeten, maar het zijn geen "grote" cd's.

| spec | spell | ID | cd | opmerking |
|---|---|---|---|---|
| 270 | Celestial Conduit | 443028 | 90 s | Alleen voor de hero-boom **Conduit of the Celestials** (node 1000:110067, subtree 64). Een Master of Harmony-speler ziet hem anders onterecht, want de module filtert niet op IsPlayerSpell. [IV]: groepsheal plus schade, 90 s. GEMETEN |
| 105 | Nature's Swiftness | 132158 | 60 s | Node 793:82050. [IV] zet hem bij de "Important Cooldowns" (spotheal). GEMETEN |
| 1468 | Tip the Scales | 370553 | 120 s | Node 872:93350. [IV]: "Use Tip the Scales as often as possible". GEMETEN |

**Niets ontbreekt** bij Disc 256, Holy 257 en Resto Shaman 264.
- 264: [WH] Midnight zegt dat Resto drie grote cd's heeft (Spirit Link, plus Healing Tide en Ascendance op één
  keuzenode). Die drie staan er al. Mana Tide 16191, Ancestral Guidance 108281, Earthen Wall 198838,
  Ancestral Protection 207399 en Cloudburst 157153 hebben alleen nodes in de losse bomen 1033/1034 en niet in
  Shaman-boom 786. — GEMETEN [DB2]. Mana Tide staat ook in de removed-lijst van [IV] Midnight.
- Emerald Communion 370960 is in 12.1 alleen een PvP-talent (PvpTalent 5718, spec 1468). Dat bevestigt het
  commentaar in de module. — GEMETEN.
- Avenging Crusader wordt na het casten Crusader Strike (aura 332 -> 1279187); [IV] zegt hetzelfde. — GEMETEN.

## Bijvangst: bestaande rijen nagemeten (DB2 12.1.0.69933)

Alle overige 27 rijen bestaan en hun `cd` klopt. Dat zijn Avenging Wrath 120, Divine Toll 60, Aura Mastery 180,
BoSac 120, LoH 600, Tranquility 180, ToL 180, Convoke 120, Ironbark 90, Rewind 240, Dream Flight 120, Stasis 90,
Time Dilation 60, Revival 180, Chi-Ji 120, Yu'lon 120, Life Cocoon 120, Ultimate Penitence 240, Barrier 180,
Pain Suppression 180, **Evangelism 90**, PI 120, Hymn 180, Apotheosis 120, Guardian Spirit 180, HTT 180,
SLT 180 en Ascendance 180. — GEMETEN.
- Evangelism 90 s is daarmee bevestigd. Het commentaar "cd unconfirmed" kan weg.
- Keuzenodes (Type 2, GEMETEN): Barrier/Ultimate Penitence (795:82564), ToL/Convoke (793:82064),
  Dream Flight/Stasis (872:93267) en Healing Tide/Ascendance (786:81032). De tabel toont beide kanten. Dat is al
  zo afgesproken, maar een speler heeft er maar één van.
- [IV] Holy Paladin 12.1: bij Lightsmith vervangt Holy Armaments de keuze Divine Toll/Holy Prism (gids, niet in DB2
  nagemeten).
- Barkskin 22812 (HEALER_DEFENSIVES, staat daar als 45 s): DB2 geeft als basis **60 s**, [IV] zegt "1-minute
  cooldown". Waar 45 vandaan komt, heb ik niet gemeten. Misschien een talent.
- `HEALCD_WHEN_EMERG` noemt Divine Shield en past dus alleen bij Lay on Hands. Gebruik "emerg" niet voor andere specs.

## Plak-klaar Lua (alleen GEMETEN ID's en cd's; kind/when = AFGELEID volgens de conventie)

```lua
	-- Holy Paladin (65): toevoegen na Avenging Wrath
		{ id = 216331, cd = 60, kind = "heal", when = "often" }, -- Avenging Crusader (choice node with Avenging Wrath; talent 394088)

	-- Restoration Druid (105): toevoegen
		{ id = 29166, cd = 180, kind = "util", when = "often" }, -- Innervate (restores 25% of max mana in 12.1)
		-- optioneel: { id = 132158, cd = 60, kind = "heal", when = "often" }, -- Nature's Swiftness

	-- Preservation Evoker (1468): toevoegen
		{ id = 374227, cd = 120, kind = "mitig", when = "raid" }, -- Zephyr (you + 4 nearest allies take less AoE damage)
		-- optioneel: { id = 370553, cd = 120, kind = "util", when = "often" }, -- Tip the Scales

	-- Mistweaver Monk (270): toevoegen DIRECT NA Revival (dan blijft Revival de top-raid-cd)
		{ id = 388615, cd = 180, kind = "heal", when = "raid" }, -- Restoral (choice node with Revival; no Magic dispel)
		-- optioneel: { id = 443028, cd = 90, kind = "heal", when = "raid" }, -- Celestial Conduit (hero: Conduit of the Celestials only)

	-- Holy Priest (257): VERWIJDEREN
		-- { id = 265202, cd = 720, kind = "heal", when = "raid" }, -- Holy Word: Salvation: removed in 11.1.0, no talent node in 12.1.0.69933

	-- Discipline Priest (256), Restoration Shaman (264): geen wijziging
```

Niet gemeten: of `IsPlayerSpell(216331)` in de client true geeft zodra je het talent 394088 kiest. Een `/run` van Rob
met Avenging Crusader gekozen beslist dat.
