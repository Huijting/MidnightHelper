# What's Training? — bekeken voor Forever (7 nov 2026)

Rob, 7 nov: *"begin eens met whats training, bekijk het goed en wat kunnen wij er van leren / gebruiken / bouwen"*.
Alleen bekeken: **niets geïnstalleerd** in `_forever_`, niets in MH veranderd.

## Wat het is

- **What's Training?** van Fusionpit (TOC-auteur "Sveng"), CurseForge 324944, 10,8 mln downloads, flavors Classic, TBC
  en Forever. Laatste update 5 nov 2026. Bron gelezen: `github.com/fusionpit/WhatsTraining`, master, gekloond 7 nov
  (`--depth 1`, scratchpad `dl_whatstraining/`).
- 🟢 **Licentie MIT** (GEMETEN: GitHub `license.spdx_id` = MIT, en het `LICENSE`-bestand zelf). Dus leren, data en
  code overnemen mag, mét de copyright-regel erbij. (Anders dan Friend Finder.)
- Er is een tweede, losse addon **"What's Training ? (Forever)"** van Zerkaa (CF `whats-training-forever`, 89k
  downloads, laatste update 3 okt). Niet gedownload, licentie niet bekeken. Zijn changelog zegt dat Aimed Shot op
  level 28 komt; Fusionpit én ons eigen onderzoek zeggen 20 (rank 2 = 28). Dus Zerkaa's data is niet beter.
- Wat het doet (GEMETEN in de code): een tab in het spellboek en `/wt` (een los venster) met per class alle
  trainer-spells, ingedeeld in *Available now / Missing requirements / Next level / Not yet / Needs talent / Ignored /
  Known*. Prijs met reputatiekorting per hoofdstad, weapon masters per stad, Hunter-petskills en Warlock-grimoires,
  een beroepen-tab (recepten van trainer, drops, quests), LibDataBroker, en een publieke `WT_API` voor andere addons.

## Wat we gemeten hebben: hun lijst tegen de onze

Scratch-scripts `wt_compare.py` en `wt_levels.py` (scratchpad 7 nov), namen via de Forever-`SpellName.csv` van wago
(positieve controle: 465 = Devotion Aura).

- 🟢 **Per spell-ID: 1358 van de 1359 levels zijn gelijk** aan onze onderzoeksbestanden
  (`FOREVER_<CLASS>_2026-11-06.md`, `FOREVER_DRUID_SPELLS_2026-11-05.md`), over alle 9 classes. Het ene verschil is
  geen fout: Holy Light 635 is bij ons level 1 (start-spell Human/Dwarf), bij WT level 2 (de Undead-quest). Dit is een
  **tweede, onafhankelijke bron** voor onze tabellen; tot nu toe hadden we DB2 + Wowhead + Zygor.
- Wat wij hebben en WT niet (157 rijen): talents, boeken/drops op 60, start-spells, racials. Allemaal verklaard; WT
  toont die bewust niet aan de trainer.
- Wat WT heeft en wij niet: passieven (Parry, Dual Wield, Mail/Plate, Tactical Mastery, Detect Traps, Safe Fall),
  Hunter-petskills, Rogue-gifjes (recepten, geen toets), en de **class-mounts** (Summon Warhorse/Charger 40/60,
  Felsteed/Dreadsteed 40/60). Die mounts lieten wij al bewust weg (Mounts-skill-line, zie
  `FOREVER_PALADIN_2026-11-06.md:417` en `FOREVER_WARLOCK_2026-11-06.md:399`). Open vraag blijft: staan ze in het
  spellboek? Dat ziet Rob op level 40.
- ⚠️ Kleine twijfel, niet uitgezocht: Prayer of Fortitude 21562 (48) en Lightwell 724 (40) staan bij ons als
  "acq 0" (trainer of iets anders), maar WT zet ze niet bij de trainer. In Classic: PoF R1 trainer, Lightwell talent.

## Wat we ervan kunnen leren

1. **De TOC kan ook anders.** WT heeft één `WhatsTraining.toc` met `## Interface: 20506, 16001, 11509` en per regel
   `[AllowLoadGameType camelot]` / `[ExcludeLoadGameType classic]`, plus `Classes\[Game]\…` in de paden. Wij hebben
   een aparte `MidnightHelper_Camelot.toc` (plan `PLAN_FOREVER_RELEASE_2026-11-06.md`). Advies: ons plan houden. Het
   werkt al bij Rob, de packager kent `_Camelot`, en op 12.1.7 vervalt het uitklappen van `[Game]` in TOC's
   (API_WATCH: wiki Patch_12.1.7, "TOC directives no longer expand variables"). Voor een retail-TOC dus geen goed idee.
   AFGELEID: of `AllowLoadGameType` zelf op 12.1.7 blijft werken, is niet gemeten.
2. **Spell-data laden zonder taint.** `Cache.lua:32-54` gebruikt bewust geen `Spell:ContinueOnSpellLoad`, want
   Blizzards gedeelde listener draait alle callbacks in één lus samen met spellboek en actiebalken. WT heeft een eigen
   frame op `SPELL_DATA_LOAD_RESULT`. MH gebruikt `ContinueOnSpellLoad` nergens (GEMETEN: 0 treffers; positieve
   controle `CreateFrame` 797). Goed om te weten als we het ooit nodig hebben.
3. **Reputatiekorting in Forever** (`Pricing.lua:54`, WT's eigen meting op build 70205): Friendly = volle prijs,
   Honored = 10% korting, Revered/Exalted niet gecontroleerd. Grimoires: overal volle prijs (WT denkt: een Forever-bug).
   AFGELEID voor ons (hun meting, niet de onze). Kan in "Before you start" van How you play.
4. **Race-afhankelijke class-quests** staan per ras met quest-ID in `Classes/Camelot/QuestSpells.lua` (bv. Warrior
   Defensive Stance/Taunt/Sunder per ras-gebied, Paladin Holy Light voor Undead, rassen 95/96 = de nieuwe rassen).
   Goede extra bron om onze How you play-zinnen over quests na te lopen.

## Wat we kunnen gebruiken of bouwen (Rob kiest; niets gebouwd)

- **A. "Nieuw bij de trainer" in MH-stijl.** Bij elke level-up één regel: *"Level 10: Lay on Hands — leer hem bij je
  trainer, hij komt op Q."* Dat kan WT niet: het weet niets van toetsen. Dat is precies MH's kracht (uitleggen +
  toetsen). Data: een kleine naam→level-tabel, gemaakt uit onze onderzoeksbestanden (nu door WT bevestigd), of
  `GetSpellLevelLearned` als dat in Forever bestaat (niet gemeten). Melding zichtbaar in het blok zelf, niet alleen in
  de chat (CLAUDE.md: "chat is een record, geen antwoord").
- **B. Samenwerken als WT geïnstalleerd is** (optioneel, klein). `WT_API.GetSpells()` geeft per spell de status
  `AVAILABLE`; het toetsenblok-venster kan zeggen *"3 spells klaar bij de trainer"*. En `WT_API.RegisterWaypointProvider`
  laat WT's "route naar de trainer" onze pijl gebruiken als TomTom er niet is (`NativeArrow.lua` laadt op Forever,
  GEMETEN in de Camelot-TOC; of de pijl daar goed tekent: AFGELEID, niet getest).
- **C. Trainer-route.** WT heeft weapon masters per stad met coördinaten (`Classes/Camelot/WeaponSkills.lua`), geen
  class-trainers; die heeft Rob al via HandyNotes_ClassTrainers. Laag nut.
- **D. Gewoon installeren.** Voor Rob zelf het snelst: WT doet wat het doet goed, en MH hoeft het niet na te bouwen.
  Dan is A + B de MH-laag erbovenop. ⚠️ Niet via de CurseForge-app in `_forever_` als dat MH raakt; WT zelf mag wel.
