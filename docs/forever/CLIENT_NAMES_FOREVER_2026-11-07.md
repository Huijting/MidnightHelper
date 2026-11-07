# WoW Forever client names, measured per locale (7 Nov 2026)

For translating MH's Forever texts (`Modules/ForeverHowToPlay.lua`, `ForeverLayoutCarry.lua`, `ForeverQuestHint.lua`).
Rob's rule: in de/fr/es/esMX/pt/it/ru every game name is the name THAT client shows, measured in Blizzard data.
Written by mh-research on 7 Nov 2026. Nothing in this file is translated by hand.

## Legend (read first)

- **Every cell that does not say NOT FOUND is MEASURED** (GEMETEN, 7 Nov 2026): it is the exact string from the
  source named in its row. A cell with two values separated by ` / ` means different ranks of the spell carry
  different names in that client; both are measured, the spell ids are in brackets (details in section 5).
- **NOT FOUND** = not in the data. For itIT this is the case in every row, because Forever ships no Italian client
  (section 1).
- **Build:** all wago.tools DB2 data is product `wowf` build **1.60.1.70862** (wago, created 2026-11-07 04:43). That is
  the build Rob has installed: `E:\World of Warcraft\.build.info`, product `wowf`, Version 1.60.1.70862, build key
  5ada954223f7… (same build_config as wago lists for 70862) (GEMETEN). Earlier MH research used 1.60.1.70790; for
  all 1274 spell ids used in section 4e, in all 7 locales (8918 comparisons), the names in 70790 and 70862 are
  identical: 0 differences (GEMETEN).
- **Source codes in the spell tables (section 4e):**
  - `SN` = wago DB2 `SpellName.Name_lang`, build 1.60.1.70862.
  - `T<n>` = the name was compared over n spell ids: every id that MH's `Modules/ForeverTrainerData.lua` lists as a
    trainer rank for that English name, plus any lower-numbered id with the same name in `SkillLineAbility` (the rank-1
    start or quest spell, which the trainer list leaves out). GEMETEN: all 1349 trainer ids exist in SpellName 70862
    and in SkillLineAbility 70862. Which id is "the" rank 1 is AFGELEID from the id order.
  - `S<n>` = no trainer rank; the n ids with that exact enUS name that `SkillLineAbility` 70862 links to a skill line.
  - `A1` = only one id has that enUS name, and it is not in SkillLineAbility (an aura or a passive).
  - `L1` = Lightning Mastery, restricted to spell 16166 (see section 5).
  - `RV` = rank variants: the ranks do not all carry the same name in at least one locale (section 5).
  - `+Pal`, `+Pri` … = the same name is also used in that class's text (only shown where my class lists overlap).
  - The `spell id` column is the lowest id of the compared set (normally rank 1). Unflagged rows have one name over
    all compared ids, so any of them gives the same string.
- **Positive controls (GEMETEN):** wago serves Italian for retail (`SpellName` id 17 itIT = "Parola del Potere: Scudo"),
  so an English itIT answer for Forever is a real absence, not a broken query. Wowhead Forever tooltips (dataEnv 16)
  return the same strings as DB2 70862 for spells 585, 591, 1464 and 20154 in all six languages; this is the check on
  the second source used for quest titles.

## 1. Which locales does Forever ship? (GEMETEN)

**enUS, deDE, esES, esMX, frFR, ruRU, koKR, ptBR, zhTW, zhCN. No itIT.**

- Blizzard's own launcher config for product `wowf`: product_config `0d21f2f209a32c57f8c9b838cb35fd0a` (the
  product_config of every wowf build from 1.60.1.70753 to 1.60.1.70862 on wago `/api/builds`), read from
  `us.cdn.blizzard.com/tpr/configs/data/0d/21/0d21f2f209a32c57f8c9b838cb35fd0a` on 7 Nov 2026. It contains
  `"supported_locales":["enUS","deDE","esES","esMX","frFR","ruRU","koKR","ptBR","zhTW","zhCN"]` and the same list as
  `display_locales` (CN region: zhCN only). "itIT" does not occur in the file.
- The DB2 data agrees: SpellName and GlobalStrings 70862 in itIT are **byte-identical to enUS** (SpellName 851003 bytes
  both; GlobalStrings 1983305 bytes both). deDE, frFR, esES, esMX, ptBR, ruRU, koKR, zhCN and zhTW each have their own
  strings. Classic Era 1.15.9.70576 has the same pattern (itIT = enUS), so this is a classic-client trait.
- Wowhead Forever (locale "it") also returns English for every Forever quest and spell tried.
- So for MH: an itIT player cannot exist on Forever (AFGELEID from the supported list). An itIT pack for Forever texts
  has no client names to use; keep it English or skip it. A ruRU and a ptBR client do exist.
- Side note, not measured by me: a Blizzard EU forum thread (eu.forums.blizzard.com/en/wow/t/638126) has players
  reporting ruRU-client problems with name reservation and rulesets at Forever launch. User reports only.

## 2. Method

1. Names collected by reading the three files in full (7 Nov 2026). `ForeverLayoutCarry.lua` and
   `ForeverQuestHint.lua` show no spell names to the player; they show UI words (Edit Mode, Modern, Classic, Action Bars,
   Settings, the five stats, Armor) and the class name (`LOCALIZED_CLASS_NAMES_MALE`, which the client fills itself).
   Names that appear only in code comments (Snow Boots, Mental Dexterity, Careful Aim) are left out.
2. Spells: full `SpellName` CSV per locale from wago (build 1.60.1.70862), matched on the exact enUS name; all 346
   English spell names in the text were found in enUS (positive check: 346 of 346).
3. Items: `ItemSparse.Display_lang`; classes `ChrClasses`; races `ChrRaces`; creature types `CreatureType`; demon names
   `CreatureFamily`; weapon words `ItemSubClass`; UI words `GlobalStrings`; the "Rank 1" under a spell name
   `Spell.NameSubtext_lang`. All build 1.60.1.70862.
4. Quest titles: DB2 has no quest-title table, so these come from **Wowhead Forever** (second source):
   `nether.wowhead.com/tooltip/quest/<id>?dataEnv=16&locale=<n>`, with Wowhead's own locale map (measured from its page
   script: de=3, fr=2, es=6 = esES, mx=11 = esMX, pt=8, it=9, ru=7). That es = esES and mx = esMX is confirmed by spell
   585: Wowhead es "Acometida" = DB2 esES, Wowhead mx "Punición" = DB2 esMX.
5. Caveat: whether wago's CSV export includes hotfixes is not known to me (wago has a "Use Hotfixes" switch). A
   hotfixed name would differ in the client. AFGELEID risk, small.

## 3. Surprises

1. **No Italian client** (section 1).
2. **Ranks of one spell can have different names in one client.** 17 names. Examples: deDE Smite is "Heilige Pein" at
   rank 1 (585) and "Göttliche Pein" from rank 2 (591, level 6) on; ruRU Slam rank 1 (1240193, level 20) is
   "Мощный удар", ranks 2-5 are "Сокрушение"; ptBR Arcane Intellect rank 1 is "Inteligência Arcana", ranks 2-5
   "Intelecto Arcano"; deDE Revive rank 1 "Wiederbelebung", ranks 2-5 "Wiederbeleben"; deDE Demoralizing Shout rank 1
   "Demoralisierender Ruf", ranks 2-5 "Demoralisierungsruf". AFGELEID consequence for MH: a key that casts by name
   (`/cast <name>`) needs the name of the rank the player knows, and a text that names the spell may show a name the
   player no longer sees after the next trainer visit. Check how MH's key block resolves names before relying on one
   string.
3. **Retail names and retail ids do not carry over.** Of the 346 representative spell ids, 160 do not exist in retail
   12.1.5.70783 SpellName, 22 exist with a different English name (Blizzard reused the id), and 97 have at least one
   locale that differs from retail (GEMETEN). So MH's retail locale packs and `docs/CLIENT_NAMES_2026-10-20.md` must not
   be reused for Forever. See section 7.
4. **frFR in Forever often drops the accent on a capital E**, where retail has it: Moonfire "Eclat lunaire", Thorns
   "Epines", Frostbolt "Eclair de givre", Lightning Bolt "Eclair", Flash of Light "Eclair lumineux", Barkskin "Ecorce",
   Cleanse "Epuration", Evocation, Evasion, Starshards "Eclats stellaires", Vampiric Embrace "Etreinte vampirique",
   CreatureType Elemental "Elémentaire". Other frFR names in the same data do have it ("Éclair de givrefeu",
   "Éclair déconcertant", "Éolide de l’Ordre suprême"). Copy exactly.
5. **Two kinds of apostrophe** in frFR: ' (U+0027) and ’ (U+2019), sometimes inside one spell: Bane of Agony rank 1
   "Plaie d'agonie", ranks 2-6 "Plaie d’agonie". 11 cells in this file use ’. String matching must treat them as
   different characters.
6. **Hidden characters:** ruRU Seal of the Crusader "Печать воина Cвета" has a **Latin C (U+0043)** in "Cвета", in all
   6 ranks. frFR Shadow Word: Pain and Shadow Word: Death have a **no-break space (U+00A0)** before the colon; Power
   Word: Shield and Power Word: Fortitude have a normal space there. In this file the no-break space is written as a
   normal space with a note in the cell.
7. **"Rank" has two different words.** The line under a spell name (`Spell.NameSubtext_lang`) is "Rang 1" (deDE,
   frFR), "Rango 1" (esES, esMX), "Grau 1" (ptBR), "Уровень 1" (ruRU). The GlobalString `RANK` is a different word in
   frFR ("Grade"), ptBR ("Posto") and ruRU ("Звание"). For "Rank 1, Rank 2" in the spell sense, use the subtext row.
8. **esES/esMX Flash Powder and Blinding Powder cross over:** esES Flash Powder = "Partículas cegadoras", esMX Blinding
   Powder = "Partículas cegadoras"; esMX Flash Powder = "Pólvora cegadora", esES Blinding Powder = "Polvo cegador".
9. **Lightning Mastery** (Shaman 40 talent, key Q) is spell 16166 = the old Elemental Mastery id, renamed. The tier-5
   passive talent's ranks 2-5 (16579-16582) are also called "Lightning Mastery" in enUS but carry other names in
   deDE/esES/ruRU, and its rank 1 (16578) is "Elemental Alacrity" (GEMETEN, Talent table 573 and 721).
10. Some Forever names are the same word as English in that language: deDE/frFR "Blizzard", "Inferno" in five
    languages, frFR "Charge", "Rupture", "Silence", "Corruption", "Poisons", "Sprint", "Evasion", "Evocation", deDE and
    frFR "Riposte", es/pt "Garrote". These are measured, not left untranslated.

## 4. Tables

### 4a. UI words (GlobalStrings, Spell subtext, ItemSubClass)

| English | id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Rank 1 (spell subtext) | Spell 585 NameSubtext | Rang 1 | Rang 1 | Rango 1 | Rango 1 | Grau 1 | NOT FOUND | Уровень 1 | Spell.NameSubtext_lang 70862 (same pattern on 591, 1459, 5176) |
| Rank (UI word) | GS RANK | Rang | Grade | Rango | Rango | Posto | NOT FOUND | Звание | GlobalStrings 70862 |
| Mana | GS MANA | Mana | Mana | Maná | Maná | Mana | NOT FOUND | Мана | GlobalStrings 70862 |
| Rage | GS RAGE | Wut | Rage | Ira | Ira | Raiva | NOT FOUND | Ярость | GlobalStrings 70862 |
| Energy | GS ENERGY | Energie | Énergie | Energía | Energía | Energia | NOT FOUND | Энергия | GlobalStrings 70862 |
| Combo Points | GS COMBO_POINTS_POWER | Combopunkte | Points de combo | Puntos de combo | Puntos de combo | Pontos de Combo | NOT FOUND | Длина серии приемов | GlobalStrings 70862 |
| Strength | GS SPELL_STAT1_NAME | Stärke | Force | Fuerza | Fuerza | Força | NOT FOUND | Сила | GlobalStrings 70862 |
| Agility | GS SPELL_STAT2_NAME | Beweglichkeit | Agilité | Agilidad | Agilidad | Agilidade | NOT FOUND | Ловкость | GlobalStrings 70862 |
| Stamina | GS SPELL_STAT3_NAME | Ausdauer | Endurance | Aguante | Aguante | Vigor | NOT FOUND | Выносливость | GlobalStrings 70862 |
| Intellect | GS SPELL_STAT4_NAME | Intelligenz | Intelligence | Inteligencia | Intelecto | Intelecto | NOT FOUND | Интеллект | GlobalStrings 70862 |
| Spirit | GS SPELL_STAT5_NAME | Willenskraft | Esprit | Espíritu | Espíritu | Espírito | NOT FOUND | Дух | GlobalStrings 70862 |
| Strength (item line) | GS ITEM_MOD_STRENGTH_SHORT | Stärke | Force | fuerza | Fuerza | Força | NOT FOUND | к силе | GlobalStrings 70862 |
| Agility (item line) | GS ITEM_MOD_AGILITY_SHORT | Beweglichkeit | Agilité | agilidad | Agilidad | Agilidade | NOT FOUND | к ловкости | GlobalStrings 70862 |
| Stamina (item line) | GS ITEM_MOD_STAMINA_SHORT | Ausdauer | Endurance | aguante | Aguante | Vigor | NOT FOUND | к выносливости | GlobalStrings 70862 |
| Intellect (item line) | GS ITEM_MOD_INTELLECT_SHORT | Intelligenz | Intelligence | intelecto | Intelecto | Intelecto | NOT FOUND | к интеллекту | GlobalStrings 70862 |
| Spirit (item line) | GS ITEM_MOD_SPIRIT_SHORT | Willenskraft | Esprit | espíritu | Espíritu | Espírito | NOT FOUND | к духу | GlobalStrings 70862 |
| Armor | GS ARMOR | Rüstung | Armure | Armadura | Armadura | Armadura | NOT FOUND | Броня | GlobalStrings 70862 |
| Armor (stat table) | GS RESISTANCE0_NAME | Rüstung | Armure | armadura | Armadura | Armadura | NOT FOUND | Броня | GlobalStrings 70862 |
| %s Armor (tooltip) | GS ARMOR_TEMPLATE | %s Rüstung | Armure : %s | %s armadura | %s p. de armadura | %s de Armadura | NOT FOUND | Броня: %s | GlobalStrings 70862 |
| cooldown (tooltip, sec) | GS SPELL_RECAST_TIME_SEC | %.2g Sek. Abklingzeit | %.2g s de recharge | Reutilización: %.2g s | Tiempo de reutilización de %.2g s | Recarga de %.2g s | NOT FOUND | Восстановление: %.2g сек. | GlobalStrings 70862 |
| cooldown (tooltip, min) | GS SPELL_RECAST_TIME_MIN | %.2g Min. Abklingzeit | %.2g min de recharge | Reutilización: %.2g min | Tiempo de reutilización de %.2g m | Recarga de %.2g min | NOT FOUND | Восстановление: %.2g мин. | GlobalStrings 70862 |
| XP | GS XP | EP | PX | PE | PE | EXP | NOT FOUND | Опыт | GlobalStrings 70862 |
| Talents | GS TALENTS | Talente | Talents | Talentos | Talentos | Talentos | NOT FOUND | Таланты | GlobalStrings 70862 |
| Spellbook | GS SPELLBOOK | Zauberbuch | Grimoire | Hechizos | Hechizos | Grimório | NOT FOUND | Заклинания | GlobalStrings 70862 |
| Pet | GS PET | Begleiter | Fam. | Mascota | Mascota | Ajudante | NOT FOUND | Питомец | GlobalStrings 70862 |
| Pet Bar | GS HUD_EDIT_MODE_PET_ACTION_BAR_LABEL | Haustierbalken | Barre du familier | Barra de mascotas | Barra de mascota | Barra de ajudante | NOT FOUND | Панель питомца | GlobalStrings 70862 (Edit Mode label) |
| Totem Bar | GS HUD_EDIT_MODE_TOTEM_ACTION_BAR_LABEL | Totemleiste | Barre de totems | Barra de tótems | Barra de tótems | Barra de totens | NOT FOUND | Панель тотемов | GlobalStrings 70862 (same text as TUTORIAL_TITLE47) |
| Trinket | GS INVTYPE_TRINKET | Schmuck | Bijou | Alhaja | Abalorio | Berloque | NOT FOUND | Аксессуар | GlobalStrings 70862 |
| Alliance | GS FACTION_ALLIANCE | Allianz | Alliance | Alianza | Alianza | Aliança | NOT FOUND | Альянс | GlobalStrings 70862 |
| Horde | GS FACTION_HORDE | Horde | Horde | Horda | Horda | Horda | NOT FOUND | Орда | GlobalStrings 70862 |
| Edit Mode | GS HUD_EDIT_MODE_MENU | Bearbeitungsmodus | Mode Édition | Modo edición | Modo de edición | Modo de edição | NOT FOUND | Редактировать | GlobalStrings 70862 |
| Modern (layout preset) | GS LAYOUT_STYLE_MODERN | Modern | Moderne | Moderno | Moderno | Moderno | NOT FOUND | Современный | GlobalStrings 70862 |
| Classic (layout preset) | GS LAYOUT_STYLE_CLASSIC | Klassisch | Classique | Clásico | Clásico | Clássico | NOT FOUND | Классический | GlobalStrings 70862 |
| Action Bars | GS ACTIONBARS_LABEL | Aktionsleisten | Barres d’actions | Barras de acción | Barras de acción | Barras de ação | NOT FOUND | Панели команд | GlobalStrings 70862 |
| Settings | GS SETTINGS | Optionen | Réglages | Configuración | Configuración | Configurações | NOT FOUND | Параметры | GlobalStrings 70862 |
| Options | GS GAMEOPTIONS_MENU | Optionen | Options | Opciones | Opciones | Opções | NOT FOUND | Настройки | GlobalStrings 70862 |
| Potions | ISC 0/1 | Tränke | Potions | Pociones | Pociones | Poções | NOT FOUND | Зелья | ItemSubClass.DisplayName_lang 70862 |
| Dagger | ISC 2/15 | Dolch | Dague | Daga | Daga | Adaga | NOT FOUND | Кинжал | ItemSubClass.DisplayName_lang 70862 |
| Bow | ISC 2/2 | Bogen | Arc | Arco | Arco | Arco | NOT FOUND | Лук | ItemSubClass.DisplayName_lang 70862 |
| Gun | ISC 2/3 | Schusswaffe | Arme à feu | Arma de fuego | Arma de fuego | Arma de fogo | NOT FOUND | Огнестрельное | ItemSubClass.DisplayName_lang 70862 |
| Crossbow | ISC 2/18 | Armbrust | Arbalète | Ballesta | Ballesta | Besta | NOT FOUND | Арбалет | ItemSubClass.DisplayName_lang 70862 |
| Thrown | ISC 2/16 | Wurfwaffe | Armes de jet | Arma arrojadiza | Arma arrojadiza | Arremesso | NOT FOUND | Метательное | ItemSubClass.DisplayName_lang 70862 |
| Wand | ISC 2/19 | Zauberstab | Baguette | Varita | Varita | Varinha | NOT FOUND | Жезл | ItemSubClass.DisplayName_lang 70862 |
| Wands | ISC 2/19 | Zauberstäbe | Baguettes | Varitas | Varitas | Varinhas | NOT FOUND | Жезлы | ItemSubClass.VerboseName_lang 70862 |
| Shield | ISC 4/6 | Schild | Bouclier | Escudo | Escudo | Escudo | NOT FOUND | Щит | ItemSubClass.DisplayName_lang 70862 |

Notes: the `ITEM_MOD_*_SHORT` strings are what `ForeverQuestHint.lua` already reads from the client, so that module
needs no translation for them; esES writes them in lower case and ruRU as "к силе", because they are built for a
"+5 …" line. Which of `SETTINGS` and `GAMEOPTIONS_MENU` the Forever game menu shows, and whether the Settings panel's
action bar page is titled with `ACTIONBARS_LABEL`, is not measured (AFGELEID candidates).

### 4b. Classes, races, creature types, demons

| English | id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Warrior | ChrClasses 1 | Krieger (f: Kriegerin) | Guerrier (f: Guerrière) | Guerrero (f: Guerrera) | Guerrero (f: Guerrera) | Guerreiro (f: Guerreira) | NOT FOUND | Воин | ChrClasses.Name_lang (+female) 70862 |
| Paladin | ChrClasses 2 | Paladin | Paladin | Paladín | Paladín | Paladino (f: Paladina) | NOT FOUND | Паладин | ChrClasses.Name_lang (+female) 70862 |
| Hunter | ChrClasses 3 | Jäger (f: Jägerin) | Chasseur (f: Chasseresse) | Cazador (f: Cazadora) | Cazador (f: Cazadora) | Caçador (f: Caçadora) | NOT FOUND | Охотник (f: Охотница) | ChrClasses.Name_lang (+female) 70862 |
| Rogue | ChrClasses 4 | Schurke (f: Schurkin) | Voleur (f: Voleuse) | Pícaro (f: Pícara) | Pícaro (f: Pícara) | Ladino (f: Ladina) | NOT FOUND | Разбойник (f: Разбойница) | ChrClasses.Name_lang (+female) 70862 |
| Priest | ChrClasses 5 | Priester (f: Priesterin) | Prêtre (f: Prêtresse) | Sacerdote (f: Sacerdotisa) | Sacerdote (f: Sacerdotisa) | Sacerdote (f: Sacerdotisa) | NOT FOUND | Жрец (f: Жрица) | ChrClasses.Name_lang (+female) 70862 |
| Shaman | ChrClasses 7 | Schamane (f: Schamanin) | Chaman (f: Chamane) | Chamán | Chamán | Xamã | NOT FOUND | Шаман (f: Шаманка) | ChrClasses.Name_lang (+female) 70862 |
| Mage | ChrClasses 8 | Magier (f: Magierin) | Mage | Mago (f: Maga) | Mago (f: Maga) | Mago (f: Maga) | NOT FOUND | Маг | ChrClasses.Name_lang (+female) 70862 |
| Warlock | ChrClasses 9 | Hexenmeister (f: Hexenmeisterin) | Démoniste | Brujo (f: Bruja) | Brujo (f: Bruja) | Bruxo (f: Bruxa) | NOT FOUND | Чернокнижник (f: Чернокнижница) | ChrClasses.Name_lang (+female) 70862 |
| Druid | ChrClasses 11 | Druide (f: Druidin) | Druide (f: Druidesse) | Druida | Druida | Druida (f: Druidesa) | NOT FOUND | Друид | ChrClasses.Name_lang (+female) 70862 |
| Human | ChrRaces 1 | Mensch | Humain | Humano (f: Humana) | Humano (f: Humana) | Humano (f: Humana) | NOT FOUND | Человек | ChrRaces.Name_lang (+female) 70862 |
| Orc | ChrRaces 2 | Orc | Orc | Orco (f: Orca) | Orco | Orc (f: Orquisa) | NOT FOUND | Орк (f: Орчиха) | ChrRaces.Name_lang (+female) 70862 |
| Dwarf | ChrRaces 3 | Zwerg (f: Zwergin) | Nain | Enano (f: Enana) | Enano (f: Enana) | Anão (f: Anã) | NOT FOUND | Дворф (f: Дворфийка) | ChrRaces.Name_lang (+female) 70862 |
| Night Elf | ChrRaces 4 | Nachtelf (f: Nachtelfe) | Elfe de la nuit | Elfo de la noche (f: Elfa de la noche) | Elfo de la noche (f: Elfa de la noche) | Elfo Noturno (f: Elfa Noturna) | NOT FOUND | Ночной эльф (f: Ночная эльфийка) | ChrRaces.Name_lang (+female) 70862 |
| Undead | ChrRaces 5 | Untoter (f: Untote) | Mort-vivant | No-muerto (f: No-muerta) | No-muerto (f: No-muerta) | Morto-vivo (f: Morta-viva) | NOT FOUND | Нежить | ChrRaces.Name_lang (+female) 70862 |
| Tauren | ChrRaces 6 | Tauren | Tauren | Tauren | Tauren | Tauren (f: Taurena) | NOT FOUND | Таурен (f: Тауренка) | ChrRaces.Name_lang (+female) 70862 |
| Gnome | ChrRaces 7 | Gnom | Gnome | Gnomo (f: Gnoma) | Gnomo (f: Gnoma) | Gnomo (f: Gnomida) | NOT FOUND | Гном (f: Гномка) | ChrRaces.Name_lang (+female) 70862 |
| Troll | ChrRaces 8 | Troll | Troll | Trol | Trol | Troll (f: Trolesa) | NOT FOUND | Тролль | ChrRaces.Name_lang (+female) 70862 |
| High Order Skyborne | ChrRaces 95 | Himmelsgeborener des Hohen Ordens (f: Himmelsgeborene des Hohen Ordens) | Éolide de l’Ordre suprême | Cielonato de la Orden Eminente (f: Cielonata de la Orden Eminente) | Cielonato de la Suma Orden (f: Cielonata de la Suma Orden) | Celonato da Alta Ordem (f: Celonata da Alta Ordem) | NOT FOUND | Небеснорожденный из Высшего ордена (f: Небеснорожденная из Высшего ордена) | ChrRaces.Name_lang (+female) 70862 |
| Skyborne (plain word) | ChrRaces 95/96 | Himmelsgeborener | éolide | cielonato | cielonato | celonato | NOT FOUND | небеснорожденный | ChrRaces.Name_lowercase_lang 70862 (95 and 96 equal) |
| Beast | CreatureType 1 | Wildtier | Bête | Bestia | Bestia | Fera | NOT FOUND | Животное | CreatureType.Name_lang 70862 |
| Demon | CreatureType 3 | Dämon | Démon | Demonio | Demonio | Demônio | NOT FOUND | Демон | CreatureType.Name_lang 70862 |
| Elemental | CreatureType 4 | Elementar | Elémentaire | Elemental | Elemental | Elemental | NOT FOUND | Элементаль | CreatureType.Name_lang 70862 |
| Undead | CreatureType 6 | Untoter | Mort-vivant | No-muerto | No-muerto | Morto-vivo | NOT FOUND | Нежить | CreatureType.Name_lang 70862 |
| Humanoid | CreatureType 7 | Humanoid | Humanoïde | Humanoide | Humanoide | Humanoide | NOT FOUND | Гуманоид | CreatureType.Name_lang 70862 |
| Totem | CreatureType 11 | Totem | Totem | Tótem | Tótem | Totem | NOT FOUND | Тотем | CreatureType.Name_lang 70862 |
| Imp | CreatureFamily 23 | Wichtel | Diablotin | Diablillo | Diablillo | Diabrete | NOT FOUND | Бес | CreatureFamily.Name_lang 70862 |
| Voidwalker | CreatureFamily 16 | Leerwandler | Marcheur du Vide | Abisario | Abisario | Emissário do Caos | NOT FOUND | Демон Бездны | CreatureFamily.Name_lang 70862 |
| Succubus | CreatureFamily 17 | Sukkubus | Succube | Súcubo | Súcubo | Súcubo | NOT FOUND | Суккуб | CreatureFamily.Name_lang 70862 |
| Incubus | CreatureFamily 302 | Inkubus | Incube | Íncubo | Íncubo | Íncubo | NOT FOUND | Инкуб | CreatureFamily.Name_lang 70862 |
| Felhunter | CreatureFamily 15 | Teufelsjäger | Chasseur corrompu | Manáfago | Manáfago | Caçador Vil | NOT FOUND | Охотник Скверны | CreatureFamily.Name_lang 70862 |

Note: Windshaper Skyborne (ChrRaces 96) exists too; the text only names High Order Skyborne and plain "Skyborne".

### 4c. Items

| English | id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Soul Shard | item 6265 | Seelensplitter | Fragment d'âme | Fragmento de alma | Fragmento de alma | Estilhaço de Alma | NOT FOUND | Осколок души | ItemSparse.Display_lang 70862 |
| Minor Healthstone | item 5512 | Schwacher Gesundheitsstein | Pierre de soins mineure | Piedra de salud menor | Piedra de salud menor | Pedra de Vida Menor | NOT FOUND | Крошечный камень здоровья | ItemSparse.Display_lang 70862 |
| Lesser Healthstone | item 5511 | Geringer Gesundheitsstein | Pierre de soins inférieure | Piedra de salud inferior | Piedra de salud inferior | Pedra de Vida Inferior | NOT FOUND | Малый камень здоровья | ItemSparse.Display_lang 70862 |
| Healthstone | item 5509 | Gesundheitsstein | Pierre de soins | Piedra de salud | Piedra de salud | Pedra de Vida | NOT FOUND | Камень здоровья | ItemSparse.Display_lang 70862 |
| Greater Healthstone | item 5510 | Großer Gesundheitsstein | Pierre de soins supérieure | Piedra superior de salud | Piedra de salud superior | Pedra de Vida Maior | NOT FOUND | Большой камень здоровья | ItemSparse.Display_lang 70862 |
| Major Healthstone | item 9421 | Erheblicher Gesundheitsstein | Pierre de soins majeure | Piedra de salud sublime | Piedra de salud sublime | Pedra de Vida Elevada | NOT FOUND | Крупный камень здоровья | ItemSparse.Display_lang 70862 |
| Minor Soulstone | item 5232 | Schwacher Seelenstein | Pierre d'âme mineure | Piedra de alma menor | Piedra de alma menor | Pedra da Alma Menor | NOT FOUND | Крошечный камень души | ItemSparse.Display_lang 70862 |
| Lesser Soulstone | item 16892 | Geringer Seelenstein | Pierre d'âme inférieure | Piedra de alma inferior | Piedra de alma inferior | Pedra da Alma Inferior | NOT FOUND | Малый камень души | ItemSparse.Display_lang 70862 |
| Soulstone | item 16893 | Seelenstein | Pierre d'âme | Piedra de alma | Piedra de alma | Pedra da Alma | NOT FOUND | Камень души | ItemSparse.Display_lang 70862 |
| Greater Soulstone | item 16895 | Großer Seelenstein | Pierre d'âme supérieure | Piedra de alma superior | Piedra de alma superior | Pedra da Alma Maior | NOT FOUND | Большой камень души | ItemSparse.Display_lang 70862 |
| Major Soulstone | item 16896 | Erheblicher Seelenstein | Pierre d'âme majeure | Piedra de alma sublime | Piedra de alma sublime | Pedra da Alma Elevada | NOT FOUND | Крупный камень души | ItemSparse.Display_lang 70862 |
| Flash Powder | item 5140 | Blitzstrahlpulver | Poudre éclipsante | Partículas cegadoras | Pólvora cegadora | Pó de Clarão | NOT FOUND | Воспламеняющийся порошок | ItemSparse.Display_lang 70862 |
| Blinding Powder | item 5530 | Blendungspulver | Poudre aveuglante | Polvo cegador | Partículas cegadoras | Pó Cegante | NOT FOUND | Ослепляющий порошок | ItemSparse.Display_lang 70862 |
| Light Feather | item 17056 | Leichte Feder | Plume légère | Pluma ligera | Pluma ligera | Pluma | NOT FOUND | Легкое перышко | ItemSparse.Display_lang 70862 |
| Holy Candle | item 17028 | Heilige Kerze | Bougie sanctifiée | Vela sagrada | Vela Sagrada | Vela Sagrada | NOT FOUND | Святая свеча | ItemSparse.Display_lang 70862 |
| Infernal Stone | item 5565 | Höllenstein | Pierre infernale | Piedra infernal | Piedra infernal | Pedra Infernal | NOT FOUND | Камень инфернала | ItemSparse.Display_lang 70862 |
| Earth Totem | item 5175 | Erdtotem | Totem de terre | Tótem de tierra | Tótem de tierra | Totem da Terra | NOT FOUND | Тотем земли | ItemSparse.Display_lang 70862 |
| Fire Totem | item 5176 | Feuertotem | Totem de feu | Tótem de Fuego | Tótem de fuego | Totem do Fogo | NOT FOUND | Тотем огня | ItemSparse.Display_lang 70862 |
| Water Totem | item 5177 | Wassertotem | Totem d'eau | Tótem de agua | Tótem de agua | Totem da Água | NOT FOUND | Тотем воды | ItemSparse.Display_lang 70862 |
| Air Totem | item 5178 | Lufttotem | Totem d'air | Tótem de aire | Tótem de aire | Totem do Ar | NOT FOUND | Тотем воздуха | ItemSparse.Display_lang 70862 |

Notes: the item ids were found by exact enUS name in ItemSparse 70862. The text says only "healthstone" and "Soulstone";
which of the five sizes a player holds depends on the rank of Create Healthstone/Soulstone. ItemSparse 70862 also has
"Twisted Earth/Fire/Water/Air Totem" (274044-274047); which totem item the Forever class quests give is not measured
(the text does not name them).

### 4d. Quest titles (SECOND SOURCE: Wowhead Forever, dataEnv 16, read 7 Nov 2026)

| English | quest id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Rediscovering the Light | quest 90902 | Das Licht wiederentdecken | Redécouverte de la Lumière | Redescubriendo la Luz | Redescubrimiento de la Luz | Redescobrindo a Luz | NOT FOUND | Возвращение к Свету | Wowhead Forever tooltip (Wowhead "patch 1.60.1"; exact build not shown) |
| The Affray | quest 1719 | Der Ringkampf | La Dispute | La Reyerta | La Reyerta | A contenda | NOT FOUND | Побоище | Wowhead Forever tooltip |
| The Stolen Tome | quest 1598 | Der gestohlene Foliant | Le Tome dérobé | El libro robado | El libro robado | Ladrão que rouba ladrão... | NOT FOUND | Украденная книга | Wowhead Forever tooltip |
| Beginnings | quest 1599 | Anfänge | Les débuts | Novato | Novato | Primeiros passos | NOT FOUND | В начале славных дел | Wowhead Forever tooltip |
| Vile Familiars (Warlock, from Ruzan) | quest 1485 | Üble Familiare | Les vils quasits | Familiares viles | Familiares viles | Familiares Vis | NOT FOUND | Злобные фамильяры | Wowhead Forever tooltip |
| Vile Familiars (Warlock, from Ruzan) | quest 1499 | Üble Familiare | Les vils quasits | Familiares viles | Familiares viles | Familiares torpes | NOT FOUND | Злобные фамильяры | Wowhead Forever tooltip |
| Piercing the Veil | quest 1470 | Der zerrissene Schleier | Lever le voile | Descubrir el misterio | Descubrir el misterio | Perfurando o véu | NOT FOUND | Приоткрывая завесу | Wowhead Forever tooltip |

Notes: quest ids from Wowhead's Forever quest list (exact-name search, 7 Nov 2026). There are three Forever quests
called "Vile Familiars": 792 (no class, Zureetha Fargaze), 1485 and 1499 (both reqclass Warlock, races Orc, Undead,
Troll, start NPC Ruzan). They differ only in ptBR. Which of 1485/1499 is the Summon Imp quest is not measured.
"Ladrão que rouba ladrão..." ends in three ASCII dots (measured). Wowhead it = English for all seven.

### 4e. Spells, per class (wago DB2 SpellName 1.60.1.70862)

The COMMON section names no spells. Shared names have one row, under the class where they first appear in my lists:
Shadowmeld (Druid; also in the Rogue and Priest texts), War Stomp (Druid; also Shaman), Shoot (Mage, the wand Shoot
5019; also Priest and Warlock), Throw (Warrior; also Rogue), Blood Fury (Rogue; also Warlock), Stoneform (Priest; also
Shaman), Cure Disease (Priest; also Shaman).

#### Druid

| English | spell id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Wrath | 5176 | Zorn | Colère | Cólera | Cólera | Ira | NOT FOUND | Гнев | SN T8 |
| Moonfire | 8921 | Mondfeuer | Eclat lunaire | Fuegolunar | Fuego lunar | Fogo Lunar | NOT FOUND | Лунный огонь | SN T10 |
| Healing Touch | 5185 | Heilende Berührung | Toucher guérisseur | Toque curativo | Toque de sanación | Toque de Cura | NOT FOUND | Целительное прикосновение | SN T10 |
| Rejuvenation | 774 | Verjüngung | Récupération | Rejuvenecimiento | Rejuvenecimiento | Rejuvenescer | NOT FOUND | Омоложение | SN T10 |
| Mark of the Wild | 1126 | Mal der Wildnis | Marque du fauve | Marca de lo salvaje | Marca de lo Salvaje | Marca do Indomado | NOT FOUND | Знак дикой природы | SN T7 |
| Thorns | 467 | Dornen | Epines | Espinas | Espinas | Espinhos | NOT FOUND | Шипы | SN T6 |
| Entangling Roots | 339 | Wucherwurzeln | Sarments | Enredaderas | Raíces enredadoras | Raízes Enredantes | NOT FOUND | Гнев деревьев | SN T6 |
| Nature's Grasp | 16689 | Griff der Natur | Emprise de la nature | Gracia de la naturaleza | Trabazón con la Naturaleza | Enredamento | NOT FOUND | Природный захват | SN T6 |
| Shadowmeld | 20580 | Schattenmimik | Camouflage dans l'ombre | Fusión de las Sombras | Fusión de las Sombras | Fusão Sombria | NOT FOUND | Слиться с тенью | SN S1 |
| War Stomp | 20549 | Kriegsdonner | Choc martial | Pisotón de guerra | Pisotón de guerra | Pisada de Guerra | NOT FOUND | Громовая поступь | SN S1 |
| Bear Form | 5487 | Bärengestalt | Forme d’ours | Forma de oso | Forma de oso | Forma de Urso | NOT FOUND | Облик медведя | SN S1 |
| Maul | 6807 | Zermalmen | Mutiler | Machaque | Magullar | Malho | NOT FOUND | Трепка | SN T7 |
| Growl | 1853 | Knurren | Grondement | Bramido | Bramido | Rosnar | NOT FOUND | Рык | SN S15 |
| Demoralizing Roar | 99 | Demoralisierendes Gebrüll | Rugissement démoralisant | Clamor desmoralizador | Rugido desmoralizador | Rugido Desmoralizante | NOT FOUND | Устрашающий рев | SN T5 |
| Regrowth | 8936 | Nachwachsen | Rétablissement | Recrecimiento | Recrecimiento | Recrescimento | NOT FOUND | Восстановление | SN T9 |
| Revive | 437138 | Wiederbelebung (437138) / Wiederbeleben (1237948, 1237949 +2) | Ressusciter | Revivir | Revivir | Reviver | NOT FOUND | Оживление | SN T5 RV |
| Aquatic Form | 1066 | Wassergestalt | Forme aquatique | Forma acuática | Forma acuática | Forma Aquática | NOT FOUND | Водный облик | SN S1 |
| Faerie Fire | 770 | Feenfeuer | Lucioles | Fuego feérico | Fuego feérico | Fogo Feérico | NOT FOUND | Волшебный огонь | SN T4 |
| Hibernate | 2637 | Winterschlaf | Hibernation | Hibernar | Hibernar | Hibernar | NOT FOUND | Спячка | SN T3 |
| Cat Form | 768 | Katzengestalt | Forme de félin | Forma felina | Forma felina | Forma de Felino | NOT FOUND | Облик кошки | SN S1 |
| Claw | 1082 | Klaue | Griffe | Zarpa | Zarpa | Garra | NOT FOUND | Когти | SN T13 |
| Rip | 1079 | Zerfetzen | Déchirure | Destripar | Destripar | Rasgar | NOT FOUND | Разорвать | SN T6 |
| Prowl | 5215 | Schleichen | Rôder | Acechar | Acechar | Espreitar | NOT FOUND | Крадущийся зверь | SN T3 |
| Starfire | 2912 | Sternenfeuer | Feu stellaire | Fuego estelar | Fuego estelar | Fogo Estelar | NOT FOUND | Звездный огонь | SN T6 |
| Rebirth | 20484 | Wiedergeburt | Renaissance | Renacer | Renacer | Renascimento | NOT FOUND | Возрождение | SN T5 |
| Travel Form | 783 | Reisegestalt | Forme de voyage | Forma de viaje | Forma de viaje | Forma de Viagem | NOT FOUND | Походный облик | SN T1 |
| Tranquility | 740 | Gelassenheit | Tranquillité | Tranquilidad | Tranquilidad | Tranquilidade | NOT FOUND | Спокойствие | SN T4 |
| Dire Bear Form | 9634 | Terrorbärengestalt | Forme d’ours redoutable | Forma de oso nefasto | Forma de oso temible | Forma de Urso Hediondo | NOT FOUND | Облик лютого медведя | SN T1 |
| Innervate | 29166 | Anregen | Innervation | Enervar | Estimular | Avivar | NOT FOUND | Озарение | SN T1 |
| Barkskin | 22812 | Baumrinde | Ecorce | Pielcorteza | Piel de corteza | Pele de Árvore | NOT FOUND | Дубовая кожа | SN T1 |
| Moonkin Form | 24858 | Moonkingestalt | Forme de sélénien | Forma de lechúcico lunar | Forma de lechúcico lunar | Forma de Luniscante | NOT FOUND | Облик лунного совуха | SN S1 |

#### Paladin

| English | spell id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Seal of Righteousness | 20154 | Siegel der Rechtschaffenheit | Sceau de piété | Sello de rectitud | Sello de Rectitud (20154) / Sello de rectitud (20287, 20288 +5) | Selo da Retidão | NOT FOUND | Печать праведности | SN T8 RV |
| Seal of the Crusader | 20162 | Siegel des Kreuzfahrers | Sceau du Croisé | Sello del Cruzado | Sello del cruzado | Selo do Cruzado | NOT FOUND | Печать воина Cвета [the C is Latin U+0043, all 6 ranks] | SN T6 |
| Seal of Fury | 20163 | Siegel des Furors | Sceau de fureur | Sello de furia | Sello de furia | Selo da Fúria | NOT FOUND | Печать ярости | SN T7 |
| Seal of Command | 20375 | Siegel des Befehls | Sceau d'autorité | Sello de orden | Sello de orden | Selo de Comando | NOT FOUND | Печать повиновения | SN T5 |
| Seal of Justice | 20164 | Siegel der Gerechtigkeit | Sceau de justice | Sello de justicia | Sello de Justicia | Selo da Justiça | NOT FOUND | Печать справедливости | SN T1 |
| Seal of Light | 20165 | Siegel des Lichts | Sceau de lumière | Sello de luz | Sello de Luz | Selo da Luz | NOT FOUND | Печать Света | SN T4 |
| Seal of Wisdom | 20166 | Siegel der Weisheit | Sceau de sagesse | Sello de sabiduría | Sello de sabiduría | Selo da Sabedoria | NOT FOUND | Печать мудрости | SN T3 |
| Devotion Aura | 465 | Aura der Hingabe | Aura de dévotion | Aura de devoción | Aura de devoción | Aura de Devoção | NOT FOUND | Аура благочестия | SN T7 |
| Retribution Aura | 7294 | Aura der Vergeltung | Aura de vindicte | Aura de castigo | Aura de reprensión | Aura da Retribuição | NOT FOUND | Аура воздаяния | SN T5 |
| Concentration Aura | 19746 | Aura der Konzentration | Aura de concentration | Aura de concentración | Aura de concentración | Aura de Concentração | NOT FOUND | Аура сосредоточенности | SN T1 |
| Holy Light | 635 | Heiliges Licht | Lumière sacrée | Luz Sagrada | Luz Sagrada | Luz Sagrada | NOT FOUND | Свет небес | SN T8 |
| Judgement | 20271 | Richturteil | Jugement | Sentencia | Sentencia | Julgamento | NOT FOUND | Правосудие | SN T1 |
| Blessing of Might | 19740 | Segen der Macht | Bénédiction de puissance | Bendición del poderío | Bendición de poderío | Bênção do Poder | NOT FOUND | Благословение могущества | SN T6 |
| Holy Strike | 678 | Heiliger Stoß | Frappe sacrée | Golpe Sagrado | Golpe Sagrado | Golpe Sagrado | NOT FOUND | Священный удар | SN T8 |
| Divine Protection | 498 | Göttlicher Schutz | Protection divine | Protección divina | Protección divina | Proteção Divina | NOT FOUND | Божественная защита | SN T2 |
| Hammer of Justice | 853 | Hammer der Gerechtigkeit | Marteau de la justice | Martillo de justicia | Martillo de Justicia (853) / Martillo de justicia (5588, 5589, 10308) | Martelo da Justiça | NOT FOUND | Молот правосудия | SN T4 RV |
| Purify | 1152 | Läutern | Purification | Purificar | Purificar | Purificar | NOT FOUND | Омовение | SN T1 |
| Lay on Hands | 633 | Handauflegung | Imposition des mains | Imposición de manos | Imposición de manos | Impor as Mãos | NOT FOUND | Возложение рук | SN T3 |
| Blessing of Protection | 1022 | Segen des Schutzes | Bénédiction de protection | Bendición de Protección | Bendición de protección | Bênção de Proteção | NOT FOUND | Благословение защиты | SN T3 |
| Redemption | 7328 | Erlösung | Rédemption | Redención | Redención | Redenção | NOT FOUND | Искупление | SN T5 |
| Blessing of Wisdom | 19742 | Segen der Weisheit | Bénédiction de sagesse | Bendición de Sabiduría | Bendición de sabiduría | Bênção de Sabedoria | NOT FOUND | Благословение мудрости | SN T5 |
| Blessing of Freedom | 1044 | Segen der Freiheit | Bénédiction de liberté | Bendición de Libertad | Bendición de libertad | Bênção da Liberdade | NOT FOUND | Благословение свободы | SN T1 |
| Consecration | 20116 | Weihe | Consécration | Consagración | Consagración | Consagração | NOT FOUND | Освящение | SN T5 |
| Exorcism | 879 | Exorzismus | Exorcisme | Exorcismo | Exorcismo | Exorcismo | NOT FOUND | Экзорцизм | SN T6 |
| Flash of Light | 19750 | Lichtblitz | Eclair lumineux | Destello de Luz | Destello de Luz | Clarão de Luz | NOT FOUND | Вспышка Света | SN T6 |
| Blessing of Kings | 20217 | Segen der Könige | Bénédiction des rois | Bendición de los Reyes | Bendición de reyes | Bênção dos Reis | NOT FOUND | Благословение королей | SN T1 |
| Divine Intervention | 19752 | Göttliches Eingreifen | Intervention divine | Intervención divina | Intervención divina | Intervenção Divina | NOT FOUND | Божественное вмешательство | SN T1 |
| Divine Shield | 642 | Gottesschild | Bouclier divin | Escudo divino | Escudo divino | Escudo Divino | NOT FOUND | Божественный щит | SN T2 |
| Cleanse | 4987 | Reinigung des Glaubens | Epuration | Purgación | Limpiar | Purificação | NOT FOUND | Очищение | SN T1 |
| Hammer of Wrath | 24239 | Hammer des Zorns | Marteau de courroux | Martillo de cólera | Martillo de cólera | Martelo da Ira | NOT FOUND | Молот гнева | SN T3 |
| Greater Blessing of Might | 25782 | Großer Segen der Macht | Bénédiction de puissance supérieure | Bendición superior de poderío | Bendición de poderío superior | Bênção Maior de Poder | NOT FOUND | Великое благословение могущества | SN T2 |
| Greater Blessing of Wisdom | 25894 | Großer Segen der Weisheit | Bénédiction de sagesse supérieure | Bendición superior de sabiduría | Bendición de sabiduría superior | Bênção Maior de Sabedoria | NOT FOUND | Великое благословение мудрости | SN T2 |
| Greater Blessing of Kings | 25898 | Großer Segen der Könige | Bénédiction des rois supérieure | Bendición superior de reyes | Bendición de reyes superior | Bênção Maior dos Reis | NOT FOUND | Великое благословение королей | SN T1 |
| Turn Undead | 2878 | Untote vertreiben | Renvoi des morts-vivants | Ahuyentar a no-muerto | Ahuyentar no-muertos | Esconjurar Morto-vivo | NOT FOUND | Изгнание нежити | SN T3 |
| Forbearance | 25771 | Vorahnung | Longanimité | Paciencia | Abstinencia | Abstinência | NOT FOUND | Воздержанность | SN A1 |

#### Mage

| English | spell id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Fireball | 133 | Feuerball | Boule de feu | Bola de Fuego | Bola de Fuego | Bola de Fogo | NOT FOUND | Огненный шар | SN T11 |
| Frost Armor | 168 | Frostrüstung | Armure de givre | Armadura de Escarcha | Armadura de Escarcha | Armadura Gélida | NOT FOUND | Морозный доспех | SN T3 |
| Arcane Intellect | 1459 | Arkane Intelligenz | Intelligence des arcanes | Intelecto Arcano | Intelecto Arcano | Inteligência Arcana (1459) / Intelecto Arcano (1460, 1461 +2) | NOT FOUND | Чародейский интеллект | SN T5 RV |
| Shoot (wand) | 5019 | Schießen | Tir | Disparar | Disparar | Atirar | NOT FOUND | Выстрел | SN S1 +Pri/Wlk |
| Frostfire Bolt | 401502 | Frostfeuerblitz | Éclair de givrefeu | Descarga de Pirofrío | Descarga de Pirofrío (401502) / Descarga de pirofrío (1237312, 1237313) | Seta de Fogofrio | NOT FOUND | Стрела ледяного огня | SN T3 RV |
| Frostbolt | 116 | Frostblitz | Eclair de givre | Descarga de Escarcha | Descarga de Escarcha | Seta de Gelo | NOT FOUND | Ледяная стрела | SN T10 |
| Fire Blast | 2136 | Feuerschlag | Trait de feu | Explosión de Fuego | Explosión de Fuego | Impacto de Fogo | NOT FOUND | Огненный взрыв | SN T7 |
| Arcane Missiles | 5143 | Arkane Geschosse | Projectiles des arcanes | Misiles Arcanos | Misiles Arcanos | Mísseis Arcanos | NOT FOUND | Чародейские снаряды | SN T7 |
| Polymorph | 118 | Verwandlung | Métamorphose | Polimorfia | Polimorfia | Polimorfia | NOT FOUND | Превращение | SN T4 |
| Frost Nova | 122 | Frostnova | Nova de givre | Nova de Escarcha | Nova de Escarcha | Nova Congelante | NOT FOUND | Кольцо льда | SN T4 |
| Conjure Water | 5504 | Wasser herbeizaubern | Invocation d'eau | Conjurar agua | Crear agua | Conjurar Água | NOT FOUND | Сотворение воды | SN T6 |
| Conjure Food | 587 | Essen herbeizaubern | Invocation de nourriture | Conjurar comida | Crear comida | Conjurar Comida | NOT FOUND | Сотворение пищи | SN T6 |
| Slow Fall | 130 | Langsamer Fall | Chute lente | Caída lenta | Caída lenta | Queda Lenta | NOT FOUND | Замедленное падение | SN T1 |
| Arcane Explosion | 1449 | Arkane Explosion | Explosion des arcanes | Deflagración Arcana | Deflagración Arcana | Explosão Arcana | NOT FOUND | Чародейский взрыв | SN T6 |
| Flamestrike | 2120 | Flammenstoß | Choc de flammes | Fogonazo | Fogonazo | Golpe Flamejante | NOT FOUND | Огненный столб | SN T6 |
| Remove Lesser Curse | 475 | Geringen Fluch aufheben | Délivrance de la malédiction mineure | Deshacer maldición inferior | Eliminar maldición inferior | Remover Maldição Inferior | NOT FOUND | Снятие малого проклятия | SN T1 |
| Blink | 1953 | Blinzeln | Transfert | Traslación | Traslación | Lampejo | NOT FOUND | Скачок | SN T1 |
| Blizzard | 10 | Blizzard | Blizzard | Ventisca | Ventisca | Nevasca | NOT FOUND | Снежная буря | SN T6 |
| Evocation | 12051 | Hervorrufung | Evocation | Evocación | Evocación | Evocação | NOT FOUND | Прилив сил | SN T1 |
| Mana Shield | 1463 | Manaschild | Bouclier de mana | Escudo de maná | Escudo de maná | Escudo de Mana | NOT FOUND | Щит маны | SN T6 |
| Fire Ward | 543 | Feuerzauberschutz | Gardien de feu | Custodia de Fuego | Resguardo contra el Fuego | Proteção contra Fogo | NOT FOUND | Защита от огня | SN T5 |
| Scorch | 2948 | Versengen | Brûlure | Chamuscar | Agostar | Calcinar | NOT FOUND | Ожог | SN T7 |
| Frost Ward | 6143 | Frostzauberschutz | Gardien de givre | Custodia de Escarcha | Resguardo contra la Escarcha | Proteção contra Gelo | NOT FOUND | Защита от магии льда | SN T4 |
| Counterspell | 2139 | Gegenzauber | Contresort | Contrahechizo | Contrahechizo | Contrafeitiço | NOT FOUND | Антимагия | SN T1 |
| Cone of Cold | 120 | Kältekegel | Cône de froid | Cono de frío | Cono de frío | Cone de Frio | NOT FOUND | Конус холода | SN T5 |
| Ice Armor | 7302 | Eisrüstung | Armure de glace | Armadura de hielo | Armadura de hielo | Armadura de Gelo | NOT FOUND | Ледяной доспех | SN T4 |
| Pyroblast | 11366 | Pyroschlag | Explosion pyrotechnique | Piroexplosión | Piroexplosión | Ignimpacto | NOT FOUND | Огненная глыба | SN T8 |
| Ice Lance | 400640 | Eislanze | Javelot de glace | Lanza de hielo | Lanza de hielo | Lança de Gelo | NOT FOUND | Ледяное копье | SN T5 |
| Arcane Blast | 400574 | Arkanschlag | Déflagration des arcanes | Explosión Arcana | Explosión Arcana | Impacto Arcano | NOT FOUND | Чародейская вспышка | SN T5 |
| Ice Block | 11958 | Eisblock | Bloc de glace | Bloqueo de hielo | Bloque de hielo | Bloco de Gelo | NOT FOUND | Ледяная глыба | SN S1 |
| Mage Armor | 6117 | Magische Rüstung | Armure du mage | Armadura de mago | Armadura de mago | Armadura de Mago | NOT FOUND | Магический доспех | SN T3 |

#### Hunter

| English | spell id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Auto Shot | 75 | Automatischer Schuss | Tir automatique | Tiro automático | Disparo automático | Tiro Automático | NOT FOUND | Автоматическая стрельба | SN S1 |
| Raptor Strike | 2973 | Raptorstoß | Attaque du raptor | Golpe de raptor | Golpe de raptor | Golpe do Raptor | NOT FOUND | Удар ящера | SN T8 |
| Serpent Sting | 1978 | Schlangenbiss | Morsure de serpent | Aguijón de serpiente | Picadura de serpiente | Picada de Serpente | NOT FOUND | Укус змеи | SN T8 |
| Aspect of the Monkey | 13163 | Aspekt des Affen | Aspect du singe | Aspecto del mono | Aspecto del mono | Aspecto do Macaco | NOT FOUND | Дух обезьяны | SN T1 |
| Arcane Shot | 3044 | Arkaner Schuss | Tir des arcanes | Tiro Arcano | Disparo Arcano | Tiro Arcano | NOT FOUND | Чародейский выстрел | SN T8 |
| Hunter's Mark | 1130 | Mal des Jägers | Marque du chasseur | Marca del cazador | Marca del cazador | Marca do Caçador | NOT FOUND | Метка охотника | SN T4 |
| Concussive Shot | 5116 | Erschütternder Schuss | Trait de choc | Disparo de concusión | Disparo de conmoción | Tiro de Concussão | NOT FOUND | Шокирующий выстрел | SN T1 |
| Aspect of the Hawk | 13165 | Aspekt des Falken | Aspect du faucon | Aspecto del halcón | Aspecto del halcón | Aspecto do Falcão | NOT FOUND | Дух ястреба | SN T6 |
| Tame Beast | 1515 | Wildtier zähmen | Apprivoise une bête | Domesticar bestia | Domesticar bestia | Domar Fera | NOT FOUND | Приручение зверя | SN S3 |
| Call Pet | 883 | Tier rufen | Appel du familier | Llamar a mascota | Llamar a mascota | Chamar Ajudante | NOT FOUND | Призыв питомца | SN S1 |
| Revive Pet | 982 | Tier wiederbeleben | Ressusciter le familier | Revivir mascota | Revivir mascota | Reviver Ajudante | NOT FOUND | Воскрешение питомца | SN S1 |
| Feed Pet | 6991 | Tier füttern | Nourrir le familier | Alimentar mascota | Alimentar mascota | Alimentar Ajudante | NOT FOUND | Кормление питомца | SN S1 |
| Dismiss Pet | 2641 | Tier freigeben | Renvoyer le familier | Retirar mascota | Retirar mascota | Dispensar Ajudante | NOT FOUND | Прогнать питомца | SN S1 |
| Scare Beast | 1513 | Wildtier ängstigen | Effrayer une bête | Bestia temible | Asustar bestia | Assustar Fera | NOT FOUND | Отпугивание зверя | SN T3 |
| Distracting Shot | 14274 | Ablenkender Schuss | Trait provocateur | Disparo de distracción | Disparo de distracción | Tiro Distrativo | NOT FOUND | Отвлекающий выстрел | SN T6 |
| Mend Pet | 136 | Tier heilen | Guérison du familier | Sanar mascota | Aliviar mascota | Curar Ajudante | NOT FOUND | Лечение питомца | SN T7 |
| Wing Clip | 2974 | Zurechtstutzen | Coupure d'ailes | Cortar alas | Cortar alas | Cortar Asas | NOT FOUND | Подрезать крылья | SN T3 |
| Immolation Trap | 13795 | Feuerbrandfalle | Piège d'Immolation | Trampa de inmolación | Trampa de inmolación | Armadilha Imolante | NOT FOUND | Обжигающая ловушка | SN T5 |
| Mongoose Bite | 1495 | Mungobiss | Morsure de la mangouste | Mordedura de mangosta | Mordedura de mangosta | Mordida de Mangusto | NOT FOUND | Укус мангуста | SN T4 |
| Multi-Shot | 2643 | Mehrfachschuss | Flèches multiples | Multidisparo | Multidisparo | Tiro Múltiplo | NOT FOUND | Залп | SN T1 |
| Aimed Shot | 19434 | Gezielter Schuss | Visée | Tiro de puntería | Disparo de puntería | Tiro Certo | NOT FOUND | Прицельный выстрел | SN T6 |
| Aspect of the Cheetah | 5118 | Aspekt des Geparden | Aspect du guépard | Aspecto del guepardo | Aspecto del guepardo | Aspecto do Guepardo | NOT FOUND | Дух гепарда | SN T1 |
| Disengage | 781 | Rückzug | Désengagement | Separación | Separación | Desvencilhar | NOT FOUND | Отрыв | SN T3 |
| Freezing Trap | 1499 | Eiskältefalle | Piège givrant | Trampa congelante | Trampa congelante | Armadilha Congelante | NOT FOUND | Замораживающая ловушка | SN T3 |
| Rapid Fire | 3045 | Schnellfeuer | Tir rapide | Fuego rápido | Fuego rápido | Tiro Rápido | NOT FOUND | Быстрая стрельба | SN T1 |
| Feign Death | 5384 | Totstellen | Feindre la mort | Fingir muerte | Fingir muerte | Fingir de Morto | NOT FOUND | Притвориться мертвым | SN T1 |
| Aspect of the Beast | 13161 | Aspekt des Wildtiers | Aspect de la bête | Aspecto de la bestia | Aspecto de la bestia | Aspecto da Fera | NOT FOUND | Дух зверя | SN T4 |
| Explosive Trap | 13812 | Sprengfalle | Piège explosif | Trampa explosiva | Trampa explosiva | Armadilha Explosiva | NOT FOUND | Взрывная ловушка | SN T4 |

#### Warrior

| English | spell id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Victory Rush | 402927 | Siegesrausch | Ivresse de la victoire | Ataque de la victoria | Ataque de la victoria | Ímpeto da Vitória | NOT FOUND | Победный раж | SN T1 |
| Battle Stance | 2457 | Kampfhaltung | Posture de combat | Actitud de batalla | Actitud de batalla | Postura de Batalha | NOT FOUND | Боевая стойка | SN S1 |
| Defensive Stance | 71 | Verteidigungshaltung | Posture défensive | Actitud defensiva | Actitud defensiva | Postura de Defesa | NOT FOUND | Оборонительная стойка | SN S1 |
| Berserker Stance | 2458 | Berserkerhaltung | Posture berserker | Actitud rabiosa | Actitud rabiosa | Postura de Berserker | NOT FOUND | Стойка берсерка | SN S1 |
| Pummel | 6552 | Zuschlagen | Volée de coups | Zurrar | Zurrar | Murro | NOT FOUND | Зуботычина | SN T2 |
| Intercept | 20252 | Abfangen | Interception | Interceptar | Interceptar | Interceptar | NOT FOUND | Перехват | SN T3 |
| Tactical Mastery | 1310185 | Taktiker | Maîtrise tactique | Maestría táctica | Maestría táctica | Proficiência Tática | NOT FOUND | Тактическое превосходство | SN T1 |
| Taunt | 355 | Spott | Provocation | Irritar | Provocar | Provocar | NOT FOUND | Провокация | SN S1 |
| Heroic Strike | 78 | Heldenhafter Stoß | Frappe héroïque | Golpe heroico | Golpe heroico | Golpe Heroico | NOT FOUND | Удар героя | SN T8 |
| Battle Shout | 5242 | Schlachtruf | Cri de guerre | Grito de guerra | Grito de batalla | Brado de Batalha | NOT FOUND | Боевой крик | SN T6 |
| Charge | 100 | Sturmangriff | Charge | Embestir | Cargar | Investida | NOT FOUND | Рывок | SN T3 |
| Rend | 772 | Verwunden | Pourfendre | Desgarrar | Desgarrar | Dilacerar | NOT FOUND | Кровопускание | SN T7 |
| Thunder Clap | 6343 | Donnerknall | Coup de tonnerre | Trueno | Atronar | Trovoada | NOT FOUND | Удар грома | SN T6 |
| Hamstring | 1715 | Kniesehne | Brise-genou | Seccionar | Seccionar | Cortar Tendão | NOT FOUND | Подрезать сухожилия | SN T3 |
| Bloodrage | 2687 | Blutrausch | Rage sanguinaire | Sanguinario | Ira sangrienta | Fúria Sanguinária | NOT FOUND | Кровавая ярость | SN T1 |
| Sunder Armor | 7386 | Rüstung zerreißen | Fracasser armure | Hender armadura | Hender armadura | Fender Armadura | NOT FOUND | Раскол брони | SN T5 |
| Shoot Bow | 2480 | Bogenschuss | Tir à l'arc | Disparar arco | Disparar arco | Disparar Arco | NOT FOUND | Выстрел из лука | SN S1 |
| Shoot Gun | 7918 | Schusswaffe abfeuern | Tir avec une arme à feu | Disparar arma de fuego | Disparar arma de fuego | Disparar Pistola | NOT FOUND | Выстрел из ружья | SN S1 |
| Shoot Crossbow | 7919 | Armbrust abschießen | Tir à l’arbalète | Disparar ballesta | Disparar ballesta | Disparar Besta | NOT FOUND | Выстрел из арбалета | SN S1 |
| Throw | 2764 | Werfen | Lancer | Lanzar | Lanzar | Lançar | NOT FOUND | Бросок | SN S1 +Rog |
| Overpower | 7384 | Überwältigen | Fulgurance | Abrumar | Abrumar | Subjugar | NOT FOUND | Превосходство | SN T4 |
| Shield Bash | 72 | Schildhieb | Coup de bouclier | Azote de escudo | Azote de escudo | Trombada com Escudo | NOT FOUND | Удар щитом | SN T3 |
| Revenge | 6572 | Rache | Vengeance | Revancha | Revancha | Revanche | NOT FOUND | Реванш | SN T5 |
| Demoralizing Shout | 1160 | Demoralisierender Ruf (1160) / Demoralisierungsruf (6190, 11554 +2) | Cri démoralisant | Grito desmoralizador | Grito desmoralizador | Brado Desmoralizador | NOT FOUND | Деморализующий крик | SN T5 RV |
| Mocking Blow | 694 | Spöttischer Schlag | Coup railleur | Falsa arremetida | Falsa arremetida | Golpe Zombeteiro | NOT FOUND | Дразнящий удар | SN T5 |
| Shield Block | 2565 | Schildblock | Maîtrise du blocage | Bloquear con escudo | Bloqueo con escudo | Levantar Escudo | NOT FOUND | Блок щитом | SN T1 |
| Disarm | 676 | Entwaffnen | Désarmement | Desactivar | Desarmar | Desarmar | NOT FOUND | Разоружение | SN T1 |
| Cleave | 845 | Spalten | Enchaînement | Mellar | Rajar | Cutilada | NOT FOUND | Рассекающий удар | SN T5 |
| Slam | 1464 | Zerschmettern | Heurtoir | Embate | Embate | Batida | NOT FOUND | Сокрушение (1464, 8820 +2) / Мощный удар (1240193) | SN T5 RV |
| Retaliation | 20230 | Gegenschlag | Représailles | Represalias | Represalias | Retaliação | NOT FOUND | Возмездие | SN T1 |
| Intimidating Shout | 5246 | Drohruf | Cri d’intimidation | Grito intimidador | Grito intimidador | Brado Intimidador | NOT FOUND | Устрашающий крик | SN T1 |
| Execute | 5308 | Hinrichten | Exécution | Ejecutar | Ejecutar | Executar | NOT FOUND | Казнь | SN T5 |
| Challenging Shout | 1161 | Herausforderungsruf | Cri de défi | Grito desafiante | Grito desafiante | Brado Desafiador | NOT FOUND | Вызывающий крик | SN T1 |
| Shield Wall | 871 | Schildwall | Mur protecteur | Muro de escudo | Muro de escudo | Muralha de Escudos | NOT FOUND | Глухая оборона | SN T1 |
| Berserker Rage | 18499 | Berserkerwut | Rage berserker | Ira rabiosa | Ira rabiosa | Raiva Incontrolada | NOT FOUND | Ярость берсерка | SN T1 |
| Whirlwind | 1680 | Wirbelwind | Tourbillon | Huracán | Torbellino | Redemoinho | NOT FOUND | Вихрь | SN T1 |
| Recklessness | 1719 | Tollkühnheit | Témérité | Temeridad | Temeridad | Temeridade | NOT FOUND | Безрассудство | SN T1 |
| Last Stand | 12975 | Letztes Gefecht | Dernier rempart | Última posición | Última carga | Último Recurso | NOT FOUND | Ни шагу назад | SN S2 |
| Piercing Howl | 12323 | Durchdringendes Heulen | Hurlement perçant | Aullido penetrante | Aullido perforador | Uivo Perfurante | NOT FOUND | Пронзительный вой | SN S1 |
| Spearing Strike | 1310222 | Aufspießender Stoß | Frappe transperçante | Lanzazo | Golpe de lanza | Golpe Lanceador | NOT FOUND | Пробивающий удар | SN S1 |
| Reckless Swings | 1329555 | Tollkühne Schwünge | Frappes téméraires | Golpes temerarios | Golpes temerarios | Golpes Imprudentes | NOT FOUND | Безрассудные удары | SN S1 |
| Sweeping Strikes | 12292 | Weitreichende Stöße | Attaques circulaires | Golpes de barrido | Golpes de barrido | Golpes a Esmo | NOT FOUND | Размашистые удары | SN S2 |
| Death Wish | 12328 | Todeswunsch | Souhait mortel | Deseo de la Muerte | Deseo de muerte | Desejo de Matar | NOT FOUND | Инстинкт смерти | SN S1 |
| Concussion Blow | 12809 | Erschütternder Schlag | Bourrasque | Golpe de concusión | Arremetida de conmoción | Pancada de Concussão | NOT FOUND | Оглушающий удар | SN S1 |
| Mortal Strike | 12294 | Tödlicher Stoß | Frappe mortelle | Golpe mortal | Golpe mortal | Golpe Mortal | NOT FOUND | Смертельный удар | SN T4 |
| Bloodthirst | 23881 | Blutdurst | Sanguinaire | Sed de sangre | Sed de sangre | Sede de Sangue | NOT FOUND | Кровожадность | SN T4 |
| Shield Slam | 23922 | Schildschlag | Heurt de bouclier | Embate con escudo | Embate con escudo | Escudada | NOT FOUND | Сокрушение щитом | SN T4 |
| Vanguard | 1310317 | Frontkämpfer | Avant-garde | Vanguardia | Vanguardia | Vanguarda | NOT FOUND | Авангард | SN A1 |

#### Rogue

| English | spell id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Stealth | 1784 | Verstohlenheit | Camouflage | Sigilo | Sigilo | Furtividade | NOT FOUND | Незаметность | SN T4 |
| Garrote | 703 | Erdrosseln | Garrot | Garrote | Garrote | Garrote | NOT FOUND | Гаррота | SN T6 |
| Ambush | 8676 | Hinterhalt | Embuscade | Emboscada | Emboscada | Emboscar | NOT FOUND | Внезапный удар | SN T6 |
| Cheap Shot | 1833 | Fieser Trick | Coup bas | Golpe bajo | Golpe bajo | Golpe Baixo | NOT FOUND | Подлый трюк | SN T1 |
| Sap | 2070 | Kopfnuss | Assommer | Zapar | Porrazo | Aturdir | NOT FOUND | Ошеломление | SN T3 |
| Pick Pocket | 921 | Taschendiebstahl | Vol à la tire | Robar | Robar | Bater Carteira | NOT FOUND | Обшаривание карманов | SN T1 |
| Sinister Strike | 1752 | Finsterer Stoß | Attaque pernicieuse | Golpe siniestro | Golpe siniestro | Golpe Sinistro | NOT FOUND | Коварный удар | SN T8 |
| Eviscerate | 2098 | Ausweiden | Eviscération | Eviscerar | Eviscerar | Eviscerar | NOT FOUND | Потрошение | SN T8 |
| Slice and Dice | 5171 | Zerhäckseln | Débiter | Hacer picadillo | Hacer picadillo | Retalhar | NOT FOUND | Мясорубка | SN T2 |
| Rupture | 1943 | Blutung | Rupture | Ruptura | Ruptura | Ruptura | NOT FOUND | Рваная рана | SN T6 |
| Backstab | 53 | Meucheln | Attaque sournoise | Puñalada | Puñalada | Punhalada pelas Costas | NOT FOUND | Удар в спину | SN T8 |
| Gouge | 1776 | Solarplexus | Suriner | Incapacitación | Gubia | Esfaquear | NOT FOUND | Парализующий удар | SN T5 |
| Evasion | 5277 | Entrinnen | Evasion | Evasión | Evasión | Evasão | NOT FOUND | Ускользание | SN T1 |
| Sprint | 2983 | Sprinten | Sprint | Correr | Sprint | Disparada | NOT FOUND | Спринт | SN T3 |
| Cannibalize | 20577 | Kannibalismus | Cannibalisme | Canibalizar | Canibalismo | Canibalizar | NOT FOUND | Каннибализм | SN S1 |
| Rapid Regeneration | 1260270 | Rasche Regeneration | Régénération rapide | Regeneración rápida | Regeneración rápida | Regeneração Rápida | NOT FOUND | Быстрая регенерация | SN S1 |
| Read Leyline | 1259705 | Leylinie lesen | Lecture des lignes telluriques | Leer línea Ley | Leer línea ley | Ler Meridiano | NOT FOUND | Чтение силовой линии | SN S1 |
| Blood Fury | 20572 | Kochendes Blut | Fureur sanguinaire | Furia sangrienta | Furia sangrienta | Fúria Sangrenta | NOT FOUND | Кровавое неистовство | SN S1 +Wlk |
| Kick | 1766 | Tritt | Coup de pied | Patada | Patada | Chute | NOT FOUND | Пинок | SN T4 |
| Expose Armor | 8647 | Rüstung schwächen | Exposer l'armure | Exponer armadura | Exponer armadura | Expor Armadura | NOT FOUND | Ослабление доспеха | SN T5 |
| Feint | 1966 | Finte | Feinte | Amago | Amago | Finta | NOT FOUND | Ложный выпад | SN T4 |
| Pick Lock | 1804 | Schloss knacken | Crochetage | Ganzúa | Forzar cerradura | Abrir Fechadura | NOT FOUND | Взлом замка | SN T1 |
| Poisons | 2842 | Gifte | Poisons | Venenos | Venenos | Venenos | NOT FOUND | Яды | SN S1 |
| Distract | 1725 | Ablenken | Distraction | Distraer | Distraer | Distração | NOT FOUND | Отвлечение | SN T1 |
| Vanish | 1856 | Verschwinden | Disparition | Esfumar | Esfumarse | Sumir | NOT FOUND | Исчезновение | SN T2 |
| Shank | 1329283 | Scharfe Klinge | Surin | Apuñalar | Punzar | Estocar | NOT FOUND | Подлый удар | SN T2 |
| Kidney Shot | 408 | Nierenhieb | Aiguillon perfide | Golpe a los riñones | Golpe en los riñones | Golpe no Rim | NOT FOUND | Удар по почкам | SN T2 |
| Disarm Trap | 1842 | Falle entschärfen | Désarmement de piège | Desactivar trampa | Desactivar trampa | Desarmar Armadilha | NOT FOUND | Обезвреживание ловушки | SN T1 |
| Blind | 2094 | Blenden | Cécité | Ceguera | Ceguera | Cegar | NOT FOUND | Ослепление | SN T1 |
| Riposte | 14251 | Riposte | Riposte | Estocada | Contestación | Ripostar | NOT FOUND | Ответный удар | SN S1 |
| Premeditation | 14183 | Konzentration | Préméditation | Premeditación | Premeditación | Premeditação | NOT FOUND | Умысел | SN S1 |
| Cold Blood | 14177 | Kaltblütigkeit | Sang froid | Sangre fría | Sangre fría | Sangue Frio | NOT FOUND | Хладнокровие | SN S1 |
| Ghostly Strike | 14278 | Geisterhafter Stoß | Frappe fantomatique | Golpe fantasmal | Golpe fantasmal | Golpe Fantasmagórico | NOT FOUND | Призрачный удар | SN S1 |
| Blade Flurry | 13877 | Klingenwirbel | Déluge de lames | Ráfaga con espada | Aluvión de acero | Rajada de Lâminas | NOT FOUND | Шквал клинков | SN S1 |
| Preparation | 14185 | Vorbereitung | Préparation | Preparación | Preparación | Preparação | NOT FOUND | Подготовка | SN S1 |
| Hemorrhage | 16511 | Blutsturz | Hémorragie | Hemorragia | Hemorragia | Hemorragia | NOT FOUND | Кровоизлияние | SN S1 |
| Mutilate | 399956 | Verstümmeln | Estropier | Mutilar | Mutilar | Mutilar | NOT FOUND | Расправа | SN T5 |
| Adrenaline Rush | 13750 | Adrenalinrausch | Poussée d'adrénaline | Subidón de adrenalina | Subidón de adrenalina | Adrenalina | NOT FOUND | Выброс адреналина | SN S1 |
| Death Mark | 1316709 | Todesmal | Marque de mort | Marca de muerte (1316709) / Marca de la muerte (1325756, 1325757, 1325758) | Marca mortal | Marca da Morte | NOT FOUND | Метка смерти | SN T4 RV |

#### Priest

| English | spell id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Shadowform | 15473 | Schattengestalt | Forme d'Ombre | Forma de las Sombras | Forma de las Sombras | Forma de Sombra | NOT FOUND | Облик Тьмы | SN S1 |
| Desperate Prayer | 13908 | Verzweifeltes Gebet | Prière du désespoir | Rezo desesperado | Rezo desesperado | Prece Desesperada | NOT FOUND | Молитва отчаяния | SN T7 |
| Chastise | 1277331 | Züchtigung | Châtiment | Castigar | Castigar | Castigar | NOT FOUND | Воздаяние | SN T5 |
| Divine Grace | 1277370 | Göttliche Anmut | Grâce divine | Gracia divina | Gracia divina | Graça Divina | NOT FOUND | Божественное покровительство | SN T7 |
| Feedback | 13896 | Rückkopplung | Réaction | Rebote | Rebote | Ciclo Elétrico | NOT FOUND | Ответная реакция | SN T5 |
| Starshards | 10797 | Sternensplitter | Eclats stellaires | Fragmentos estelares | Fragmentos estelares | Fragmentos Estelares | NOT FOUND | Звездные осколки | SN T7 |
| Elune's Grace | 2651 | Elunes Anmut | Grâce d'Elune | Gracia de Elune | Gracia de Elune | A graça de Eluna | NOT FOUND | Благодать Элуны | SN S1 |
| Touch of Weakness | 2652 | Berührung der Schwäche | Toucher de faiblesse | Toque de debilidad | Toque de debilidad | Toque de Fraqueza | NOT FOUND | Прикосновение слабости | SN T12 |
| Dark Sacrifice | 1277324 | Dunkles Opfer | Sombre sacrifice | Sacrificio oscuro | Sacrificio oscuro | Sacrifício Sombrio | NOT FOUND | Темная жертва | SN T5 |
| Hex of Weakness | 9035 | Verhexung der Schwäche | Maléfice de faiblesse | Maleficio de debilidad | Maleficio de debilidad | Bagata da Fraqueza | NOT FOUND | Обессиливающий сглаз | SN T6 |
| Shadowguard | 18137 | Schattenschild | Garde de l'ombre | Guardia de las Sombras | Guardia de las Sombras | Guarda Sombrio | NOT FOUND | Страж Тьмы | SN T6 |
| Confounding Flash | 1277455 | Verwirrender Lichtblitz | Éclair déconcertant | Destello desconcertante | Destello desconcertante | Clarão Desconcertante | NOT FOUND | Ошарашивающая вспышка | SN S1 |
| Contingency Plan | 1277462 | Notfallplan | Plan d’urgence | Plan de contingencia | Plan de contingencia | Plano de Contingência | NOT FOUND | Запасной план | SN T5 |
| Smite | 585 | Heilige Pein (585) / Göttliche Pein (591, 598 +5) | Châtiment | Acometida | Punición | Punição | NOT FOUND | Кара | SN T8 RV |
| Lesser Heal | 2050 | Geringes Heilen | Soins inférieurs | Curación inferior | Sanación inferior | Cura Inferior | NOT FOUND | Малое исцеление | SN T3 |
| Heal | 2054 | Heilen | Soins | Curar | Sanar | Cura | NOT FOUND | Исцеление | SN T4 |
| Greater Heal | 2060 | Große Heilung | Soins supérieurs | Curación superior | Sanación superior | Cura Maior | NOT FOUND | Великое исцеление | SN T4 |
| Power Word: Fortitude | 1243 | Machtwort: Seelenstärke | Mot de pouvoir : Robustesse | Palabra de poder: entereza | Palabra de poder: entereza | Palavra de Poder: Fortitude | NOT FOUND | Слово силы: Стойкость | SN T6 |
| Shadow Word: Pain | 589 | Schattenwort: Schmerz | Mot de l'ombre : Douleur [space before ':' is NBSP U+00A0] | Palabra de las Sombras: Dolor | Palabra de las Sombras: dolor | Palavra Sombria: Dor | NOT FOUND | Слово Тьмы: Боль | SN T8 |
| Power Word: Shield | 17 | Machtwort: Schild | Mot de pouvoir : Bouclier | Palabra de poder: escudo | Palabra de poder: escudo | Palavra de Poder: Escudo | NOT FOUND | Слово силы: Щит | SN T10 |
| Fade | 586 | Verblassen | Oubli | Desvanecer | Desvanecerse | Desvanecer | NOT FOUND | Уход в тень | SN T6 |
| Renew | 139 | Erneuerung | Rénovation | Renovar | Renovar | Renovar | NOT FOUND | Обновление | SN T9 |
| Mind Blast | 8092 | Gedankenschlag | Attaque mentale | Explosión mental | Explosión mental | Impacto Mental | NOT FOUND | Взрыв разума | SN T9 |
| Resurrection | 2006 | Auferstehung | Résurrection | Resurrección | Resurrección | Ressurreição | NOT FOUND | Воскрешение | SN T5 |
| Stoneform | 20594 | Steingestalt | Forme de pierre | Petraforma | Forma de piedra | Forma de Pedra | NOT FOUND | Каменная форма | SN S1 +Sha |
| Inner Fire | 588 | Inneres Feuer | Feu intérieur | Fuego interno | Fuego interno | Fogo Interior | NOT FOUND | Внутренний огонь | SN T6 |
| Cure Disease | 528 | Krankheit heilen | Guérison des maladies | Curar enfermedad | Curar enfermedad | Curar Doença | NOT FOUND | Излечение болезни | SN T2 +Sha |
| Psychic Scream | 8122 | Psychischer Schrei | Cri psychique | Alarido psíquico | Alarido psíquico | Grito Psíquico | NOT FOUND | Ментальный крик | SN T4 |
| Dispel Magic | 527 | Magiebannung | Dissipation de la magie | Disipar magia | Disipar magia | Dissipar Magia | NOT FOUND | Рассеивание заклинаний | SN T2 |
| Flash Heal | 2061 | Blitzheilung | Soins rapides | Destello curativo | Sanación relámpago | Cura Célere | NOT FOUND | Быстрое исцеление | SN T7 |
| Holy Fire | 14914 | Heiliges Feuer | Flammes sacrées | Fuego Sagrado | Fuego Sagrado | Fogo Sagrado | NOT FOUND | Священный огонь | SN T8 |
| Shackle Undead | 9484 | Untote fesseln | Entraves des morts-vivants | Encadenar no-muerto | Encadenar no-muerto | Agrilhoar Morto-vivo | NOT FOUND | Сковывание нежити | SN T3 |
| Devouring Plague | 2944 | Verschlingende Seuche | Peste dévorante | Peste devoradora | Peste devoradora | Peste Devoradora | NOT FOUND | Всепожирающая чума | SN T6 |
| Fear Ward | 6346 | Furchtzauberschutz | Gardien de peur | Custodia de miedo | Resguardo de miedo | Proteção contra Medo | NOT FOUND | Защита от страха | SN T1 |
| Prayer of Healing | 596 | Gebet der Heilung | Prière de soins | Rezo de curación | Rezo de sanación | Prece de Cura | NOT FOUND | Молитва исцеления | SN T4 |
| Mind Control | 605 | Gedankenkontrolle | Contrôle mental | Control mental | Control mental | Controle Mental | NOT FOUND | Контроль над разумом | SN T3 |
| Shadow Word: Death | 401955 | Schattenwort: Tod | Mot de l’ombre : Mort [space before ':' is NBSP U+00A0] | Palabra de las Sombras: muerte | Palabra de las Sombras: muerte | Palavra Sombria: Morte | NOT FOUND | Слово Тьмы: Смерть | SN T5 |
| Abolish Disease | 552 | Krankheit aufheben | Abolir maladie | Suprimir enfermedad | Suprimir enfermedad | Abolir Doença | NOT FOUND | Снятие болезни | SN T1 |
| Levitate | 1706 | Levitieren | Lévitation | Levitar | Levitar | Levitar | NOT FOUND | Левитация | SN T1 |
| Prayer of Fortitude | 21562 | Gebet der Seelenstärke | Prière de robustesse | Rezo de entereza | Rezo de entereza | Prece da Fortitude | NOT FOUND | Молитва стойкости | SN S2 |
| Mind Flay | 15407 | Gedankenschinden | Fouet mental | Despelleje mental | Tortura mental | Açoite Mental | NOT FOUND | Пытка разума | SN T6 |
| Holy Nova | 15237 | Heilige Nova | Nova sacrée | Nova Sagrada | Nova Sagrada | Nova Sagrada | NOT FOUND | Кольцо Света | SN T6 |
| Inner Focus | 14751 | Innerer Fokus | Focalisation améliorée | Enfoque interno | Enfoque interno | Concentração Interior | NOT FOUND | Внутреннее сосредоточение | SN S1 |
| Vampiric Embrace | 15286 | Vampirumarmung | Etreinte vampirique | Unirse a vampírica | Abrazo vampírico | Abraço Vampírico | NOT FOUND | Объятия вампира | SN S1 |
| Penance | 402174 | Sühne | Pénitence | Penitencia | Penitencia | Penitência | NOT FOUND | Исповедь | SN T6 |
| Silence | 15487 | Stille | Silence | Silencio | Silencio | Silêncio | NOT FOUND | Молчание | SN S1 |
| Power Infusion | 10060 | Seele der Macht | Infusion de puissance | Infusión de poder | Infusión de poder | Infusão de Poder | NOT FOUND | Придание сил | SN S1 |
| Prayer of Mending | 401859 | Gebet der Besserung | Prière de guérison | Rezo de alivio | Rezo de alivio | Prece da Recomposição | NOT FOUND | Молитва восстановления | SN T4 |

#### Shaman

| English | spell id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Ghost Wolf | 2645 | Geisterwolf | Loup fantôme | Lobo fantasmal | Lobo fantasmal | Lobo Fantasma | NOT FOUND | Призрачный волк | SN T1 |
| Stoneskin Totem | 8071 | Totem der Steinhaut | Totem de Peau de pierre | Tótem piel de piedra | Tótem Piel de piedra | Totem Litopele | NOT FOUND | Тотем каменной кожи | SN T6 |
| Earthbind Totem | 2484 | Totem der Erdbindung | Totem de lien terrestre | Tótem Nexo Terrestre | Tótem Nexo Terrestre | Totem de Prisão Terrena | NOT FOUND | Тотем оков земли | SN T1 |
| Stoneclaw Totem | 5730 | Totem der Steinklaue | Totem de Griffes de pierre | Tótem Garra de piedra | Tótem Garra de piedra | Totem da Garra de Pedra | NOT FOUND | Тотем каменного когтя | SN T6 |
| Strength of Earth Totem | 8075 | Totem der Erdstärke | Totem de Force de la Terre | Tótem Fuerza de la tierra | Tótem Fuerza de la tierra | Totem da Força da Terra | NOT FOUND | Тотем силы земли | SN T4 |
| Searing Totem | 3599 | Totem der Verbrennung | Totem incendiaire | Tótem abrasador | Tótem abrasador | Totem Calcinante | NOT FOUND | Опаляющий тотем | SN T6 |
| Tremor Totem | 8143 | Totem des Erdstoßes | Totem de Séisme | Tótem de tremor | Tótem de tremor | Totem Sísmico | NOT FOUND | Тотем трепета | SN T1 |
| Call of the Elements | 66842 | Ruf der Elemente | Appel des éléments | Llamada de los elementos | Llamada de los elementos | Chamado dos Elementos | NOT FOUND | Зов Стихий | SN T1 |
| Call of the Ancestors | 66843 | Ruf der Urahnen | Appel des ancêtres | Llamada de los ancestros | Llamada de los ancestros | Chamado dos Antepassados | NOT FOUND | Зов Предков | SN T1 |
| Call of the Spirits | 66844 | Ruf der Geister | Appel des esprits | Llamada de los espíritus | Llamada de los espíritus | Chamado dos Espíritos | NOT FOUND | Зов Духов | SN T1 |
| Totemic Call | 437009 | Totemischer Ruf | Appel totémique | Llamada totémica | Llamado totémico | Chamado Totêmico | NOT FOUND | Зов тотемов | SN T1 |
| Totemic Recall | 36936 | Totemischer Rückruf | Rappel totémique | Regreso totémico | Regreso totémico | Revocação Totêmica | NOT FOUND | Возвращение тотемов | SN T1 |
| Rockbiter Weapon | 8017 | Waffe des Felsbeißers | Arme Croque-roc | Arma comerrocas | Arma Muerdepiedras | Arma Trinca-pedra | NOT FOUND | Оружие Камнедробителя | SN T7 |
| Flametongue Weapon | 8024 | Waffe der Flammenzunge | Arme Langue de feu | Arma lengua de Fuego | Arma Lengua de Fuego | Arma de Labaredas | NOT FOUND | Оружие языка пламени | SN T6 |
| Frostbrand Weapon | 8033 | Waffe des Frostbrands | Arme de givre | Arma Estigma de Escarcha | Arma Estigma de Escarcha | Arma da Marca Gélida | NOT FOUND | Оружие ледяного клейма | SN T5 |
| Windfury Weapon | 8232 | Waffe des Windzorns | Arme Furie-des-vents | Arma tótem Viento Furioso | Arma Viento Furioso | Arma de Fúria dos Ventos | NOT FOUND | Оружие неистовства ветра | SN T4 |
| Lightning Bolt | 403 | Blitzschlag | Eclair | Descarga de relámpagos | Descarga de relámpagos | Raio | NOT FOUND | Молния | SN T10 |
| Healing Wave | 331 | Welle der Heilung | Vague de soins | Onda de curación | Ola de sanación | Onda Curativa | NOT FOUND | Волна исцеления | SN T9 |
| Earth Shock | 8042 | Erdschock | Horion de terre | Choque de tierra | Choque de tierra | Choque Terreno | NOT FOUND | Земной шок | SN T7 |
| Lightning Shield | 324 | Blitzschlagschild | Bouclier de foudre | Escudo de relámpagos | Escudo de relámpagos | Escudo de Raios | NOT FOUND | Щит молний | SN T7 |
| Flame Shock | 8050 | Flammenschock | Horion de flammes | Choque de llamas | Choque de llamas | Choque Flamejante | NOT FOUND | Огненный шок | SN T5 |
| Fire Nova | 408341 | Feuernova | Nova de feu | Nova de Fuego | Nova de Fuego | Nova de Fogo | NOT FOUND | Кольцо огня | SN T5 |
| Purge | 370 | Reinigen | Expiation | Purgar | Purgar | Expurgar | NOT FOUND | Развеяние магии | SN T2 |
| Ancestral Spirit | 2008 | Geist der Ahnen | Esprit ancestral | Espíritu ancestral | Espíritu ancestral | Espírito Ancestral | NOT FOUND | Дух предков | SN T5 |
| Cure Poison | 526 | Vergiftung heilen | Guérison du poison | Curar veneno | Curar envenenamiento | Curar Veneno | NOT FOUND | Выведение яда | SN T1 |
| Frost Shock | 8056 | Frostschock | Horion de givre | Choque de Escarcha | Choque de Escarcha | Choque Gélido | NOT FOUND | Ледяной шок | SN T4 |
| Lesser Healing Wave | 8004 | Geringe Welle der Heilung | Vague de soins inférieurs | Onda inferior de curación | Ola de sanación inferior | Onda Curativa Menor | NOT FOUND | Малая волна исцеления | SN T6 |
| Healing Stream Totem | 5394 | Totem des heilenden Flusses | Totem guérisseur | Tótem Corriente de sanación (5394, 6375 +2) / Tótem de corriente curativa (6377) | Tótem Corriente de sanación | Totem de Torrente Curativa | NOT FOUND | Тотем исцеляющего потока | SN T5 RV |
| Grounding Totem | 8177 | Totem der Erdung | Totem de Glèbe | Tótem derribador | Tótem derribador | Totem de Aterramento | NOT FOUND | Тотем заземления | SN T1 |
| Chain Lightning | 421 | Kettenblitzschlag | Chaîne d'éclairs | Cadena de relámpagos | Cadena de relámpagos | Cadeia de Raios | NOT FOUND | Цепная молния | SN T4 |
| Chain Heal | 1064 | Kettenheilung | Salve de guérison | Curación en cadena | Sanación en cadena | Cura Encadeada | NOT FOUND | Цепное исцеление | SN T3 |
| Water Shield | 408510 | Wasserschild | Bouclier d’eau | Escudo de agua | Escudo de agua | Escudo de Água | NOT FOUND | Водный щит | SN S1 |
| Stormstrike | 17364 | Sturmschlag | Courroux naturel | Golpe de tormenta | Golpe de tormenta | Ataque da Tempestade | NOT FOUND | Удар бури | SN S1 |
| Mana Tide Totem | 16190 | Totem der Manaflut | Totem de Vague de mana (16190, 17354, 17359) / Totem de vague de mana (1325256) | Tótem de marea de maná (16190, 17354, 17359) / Tótem Marea de maná (1325256) | Tótem Marea de maná | Totem de Vagalhão de Mana | NOT FOUND | Тотем прилива маны | SN T4 RV |
| Nature's Swiftness | 16188 | Schnelligkeit der Natur | Rapidité de la nature | Rapidez de la Naturaleza | Presteza de la Naturaleza | Rapidez da Natureza | NOT FOUND | Природная стремительность | SN S2 |
| Riptide | 408521 | Springflut | Remous | Mareas vivas | Mareas Vivas | Contracorrente | NOT FOUND | Быстрина | SN T3 |
| Lightning Mastery | 16166 | Blitzbeherrschung | Maîtrise de la foudre | Maestría de Relámpago | Maestría en relámpagos | Maestria em Raio | NOT FOUND | Власть над молнией | SN L1 (see section 5) |
| Rage of the Farseer | 425336 | Zorn des Scharfsehers | Rage long-voyante | Ira del clarividente | Ira del clarividente | Fúria do Clarividente | NOT FOUND | Ярость предсказателя | SN S1 |
| Magma Totem | 8190 | Totem der glühenden Magma | Totem de Magma | Tótem de magma | Tótem de Magma (8190) / Tótem de magma (10585, 10586, 10587) | Totem de Magma | NOT FOUND | Тотем магмы | SN T4 RV |

#### Warlock

| English | spell id | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | source + build |
|---|---|---|---|---|---|---|---|---|---|
| Summon Imp | 688 | Wichtel beschwören | Invocation d'un diablotin | Invocar a diablillo | Invocar diablillo | Evocar Diabrete | NOT FOUND | Призыв беса | SN S1 |
| Summon Voidwalker | 697 | Leerwandler beschwören | Invocation d'un marcheur du Vide | Invocar a abisario | Invocar abisario | Evocar Emissário do Caos | NOT FOUND | Призыв демона Бездны | SN S1 |
| Summon Succubus | 712 | Sukkubus beschwören | Invocation d'une succube | Invocar a súcubo | Invocar súcubo | Evocar Súcubo | NOT FOUND | Призыв суккуба | SN S1 |
| Summon Incubus | 713 | Inkubus beschwören | Invocation d’incube | Invocar íncubo | Invocar íncubo | Evocar Íncubo | NOT FOUND | Призыв инкуба | SN S1 |
| Summon Felhunter | 691 | Teufelsjäger beschwören | Invocation d'un chasseur corrompu | Invocar a manáfago | Invocar manáfago | Evocar Caçador Vil | NOT FOUND | Призыв охотника Скверны | SN S1 |
| Inferno | 1122 | Inferno | Inferno | Inferno | Inferno | Inferno | NOT FOUND | Инфернал | SN S1 |
| Torment | 3716 | Qual | Tourment | Tormento | Tormento | Tormento | NOT FOUND | Мучение | SN S6 |
| Spell Lock | 19244 | Zaubersperre | Verrou magique | Bloqueo de hechizo | Bloqueo de hechizo | Bloquear Feitiço | NOT FOUND | Запрет чар | SN S2 |
| Shadow Bolt | 686 | Schattenblitz | Trait de l'ombre | Descarga de las Sombras | Descarga de las Sombras | Seta Sombria | NOT FOUND | Стрела Тьмы | SN T9 |
| Immolate | 348 | Feuerbrand | Immolation | Inmolar | Inmolar | Imolação | NOT FOUND | Жертвенный огонь | SN T7 |
| Demon Skin | 687 | Dämonenhaut | Peau de démon | Piel de demonio | Piel de demonio | Pele de Demônio | NOT FOUND | Шкура демона | SN T2 |
| Demon Armor | 706 | Dämonenrüstung | Armure démoniaque | Armadura demoníaca | Armadura demoníaca | Armadura Demoníaca | NOT FOUND | Демонический доспех | SN T5 |
| Corruption | 172 | Verderbnis | Corruption | Corrupción | Corrupción | Corrupção | NOT FOUND | Порча | SN T6 |
| Curse of Weakness | 702 | Fluch der Schwäche | Malédiction de faiblesse | Maldición de debilidad | Maldición de debilidad | Maldição da Fraqueza | NOT FOUND | Проклятие слабости | SN T6 |
| Curse of the Elements | 440892 | Fluch der Elemente | Malédiction des éléments | Maldición de los Elementos | Maldición de los Elementos (440892) / Maldición de los elementos (1311676, 1311677, 1311680) | Maldição dos Elementos | NOT FOUND | Проклятие стихий | SN T4 RV |
| Life Tap | 1454 | Aderlass | Connexion | Transfusión de vida | Transfusión de vida | Conversão de Vida | NOT FOUND | Жизнеотвод | SN T6 |
| Bane of Agony | 980 | Omen der Pein | Plaie d'agonie (980) / Plaie d’agonie (1014, 6217 +3) | Terror de agonía | Terror de agonía | Ruína da Agonia | NOT FOUND | Бич агонии | SN T6 RV |
| Fear | 5782 | Furcht | Peur | Miedo | Miedo | Medo | NOT FOUND | Страх | SN T3 |
| Drain Soul | 1120 | Seelendieb | Siphon d'âme | Drenar alma | Drenar alma | Drenar Alma | NOT FOUND | Похищение души | SN T4 |
| Create Healthstone | 5699 | Gesundheitsstein herstellen | Création de Pierre de soins | Crear piedra de salud | Crear piedra de salud (5699, 6201) / Crear piedra de salud (inferior) (6202) / Crear piedra de salud (superior) (11729) / Crear piedra de salud (sublime) (11730) | Criar Pedra de Vida | NOT FOUND | Создание камня здоровья | SN T5 RV |
| Will of the Forsaken | 7744 | Wille der Verlassenen | Volonté des Réprouvés | Voluntad de los Renegados | Voluntad de los Renegados | Determinação dos Renegados | NOT FOUND | Воля Отрекшихся | SN S1 |
| Drain Life | 689 | Blutsauger | Drain de vie | Drenar vida | Drenar vida | Drenar Vida | NOT FOUND | Похищение жизни | SN T6 |
| Health Funnel | 755 | Lebenslinie | Captation de vie | Cauce de salud | Cauce de salud | Funil de Vida | NOT FOUND | Канал здоровья | SN T7 |
| Unending Breath | 5697 | Unendlicher Atem | Respiration interminable | Fuerza inmortal | Aliento inagotable | Fôlego Interminável | NOT FOUND | Нескончаемое дыхание | SN T1 |
| Searing Pain | 5676 | Sengender Schmerz | Douleur brûlante | Dolor abrasador | Dolor abrasador | Dor Lancinante | NOT FOUND | Жгучая боль | SN T6 |
| Create Soulstone | 693 | Seelenstein herstellen | Création de pierre d'âme (693, 20752 +2) / Création de Pierre d'âme (20755) | Crear piedra de alma | Crear piedra de alma | Criar Pedra da Alma | NOT FOUND | Создание камня души | SN T5 RV |
| Curse of Tongues | 1714 | Fluch der Sprachen | Malédiction des langages | Maldición de la lengua | Maldición de las lenguas | Maldição de Línguas | NOT FOUND | Проклятие косноязычия | SN T2 |
| Ritual of Summoning | 698 | Ritual der Beschwörung | Rituel d'invocation | Ritual de invocación | Ritual de invocación | Ritual de Evocação | NOT FOUND | Ритуал призывания | SN T1 |
| Rain of Fire | 5740 | Feuerregen | Pluie de feu | Lluvia de Fuego | Lluvia de Fuego | Chuva de Fogo | NOT FOUND | Огненный ливень | SN T4 |
| Banish | 710 | Verbannen | Bannir | Desterrar | Desterrar | Banir | NOT FOUND | Изгнание | SN T2 |
| Hellfire | 1949 | Höllenfeuer | Flammes infernales | Piroinferno | Llamas infernales | Fogo do Inferno | NOT FOUND | Адское Пламя | SN T3 |
| Shadow Ward | 6229 | Schattenzauberschutz | Gardien de l'ombre | Custodia de las Sombras | Resguardo contra las Sombras | Proteção contra Sombra | NOT FOUND | Защита от темной магии | SN T3 |
| Howl of Terror | 5484 | Schreckensgeheul | Hurlement de terreur | Aullido de terror | Aullido de terror | Uivo do Terror | NOT FOUND | Вой ужаса | SN T2 |
| Death Coil | 6789 | Todesmantel | Voile mortel | Espiral mortal | Espiral de la muerte | Espiral da Morte | NOT FOUND | Лик смерти | SN T3 |
| Soul Fire | 6353 | Seelenfeuer | Feu de l'âme | Fuego de alma | Fuego de alma | Fogo d'Alma | NOT FOUND | Ожог души | SN T2 |
| Bane of Doom | 603 | Omen der Verdammnis | Plaie funeste | Terror de fatalidad | Terror de fatalidad | Ruína do Destino | NOT FOUND | Бич судьбы | SN T1 |
| Shadowburn | 17877 | Schattenbrand | Brûlure de l'ombre | Quemadura de las Sombras | Quemadura de las Sombras | Sombra Ardente | NOT FOUND | Ожог Тьмы | SN T6 |
| Amplify Curse | 18288 | Fluch verstärken | Malédiction amplifiée | Amplificar maldición | Amplificar maldición | Amplificar Maldição | NOT FOUND | Усиление проклятия | SN S1 |
| Demonic Sacrifice | 18788 | Dämonische Opferung | Sacrifice démoniaque | Sacrificio demoníaco | Sacrificio demoníaco | Sacrifício Demoníaco | NOT FOUND | Демоническое жертвоприношение | SN S1 |
| Curse of Exhaustion | 18223 | Fluch der Erschöpfung | Malédiction de fatigue | Maldición de agotamiento | Maldición de agotamiento | Maldição da Exaustão | NOT FOUND | Проклятие изнеможения | SN S1 |
| Fel Domination | 18708 | Teufelsbeherrschung | Domination corrompue | Dominio de lo maldito | Dominación vil | Dominância Vil | NOT FOUND | Господство Скверны | SN S1 |
| Siphon Life | 18265 | Lebensentzug | Siphon de vie | Succionar vida | Succionar vida | Sifão de Vida | NOT FOUND | Вытягивание жизни | SN T4 |
| Soul Link | 19028 | Seelenverbindung | Lien spirituel | Vínculo de alma | Enlace de alma | Vínculo Anímico | NOT FOUND | Связка души | SN S1 |
| Conflagrate | 17962 | Feuersbrunst | Conflagration | Conflagrar | Conflagrar | Conflagrar | NOT FOUND | Поджигание | SN T5 |
| Bane of Havoc | 1225228 | Omen der Verwüstung | Plaie de tumulte | Terror de caos | Terror de caos | Ruína Devastadora | NOT FOUND | Бич сокрушения | SN S1 |
| Wrack | 1316697 | Zermürben | Calvaire | Arruinar | Arruinar | Destruição | NOT FOUND | Судороги | SN S1 |
| Incinerate | 412758 | Verbrennen | Incinérer | Incinerar | Incinerar | Incinerar | NOT FOUND | Испепеление | SN T3 |

## 5. Per-rank variants (detail, GEMETEN in SpellName 70862)

Levels are from MH's own `ForeverTrainerData.lua` (`l =`); "rank 1" for an id that is not in that list is AFGELEID
(lowest id, the start or quest spell). Locales not named here have one name for all ranks.

1. **Revive** (Druid), deDE: 437138 (l12) "Wiederbelebung"; 1237948 (l24), 1237949 (l36), 1237950 (l48), 1237951 (l60)
   "Wiederbeleben".
2. **Seal of Righteousness**, esMX: 20154 (rank 1, start spell) "Sello de Rectitud"; 20287 (l10), 20288 (l18),
   20289 (l26), 20290 (l34), 20291 (l42), 20292 (l50), 20293 (l58) "Sello de rectitud" (case only).
3. **Hammer of Justice**, esMX: 853 (l8) "Martillo de Justicia"; 5588 (l24), 5589 (l40), 10308 (l54) "Martillo de
   justicia" (case only). esES has "Martillo de justicia" for all.
4. **Arcane Intellect**, ptBR: 1459 (l1) "Inteligência Arcana"; 1460 (l14), 1461 (l28), 10156 (l42), 10157 (l56)
   "Intelecto Arcano".
5. **Frostfire Bolt**, esMX: 401502 (l40) "Descarga de Pirofrío"; 1237312 (l50), 1237313 (l60) "Descarga de
   pirofrío" (case only).
6. **Demoralizing Shout**, deDE: 1160 (l14) "Demoralisierender Ruf"; 6190 (l24), 11554 (l34), 11555 (l44), 11556 (l54)
   "Demoralisierungsruf".
7. **Slam**, ruRU: 1240193 (l20, Forever's new rank 1) "Мощный удар"; 1464 (l30), 8820 (l38), 11604 (l46), 11605 (l54)
   "Сокрушение". Note ruRU Shield Slam is "Сокрушение щитом".
8. **Death Mark** (Rogue), esES: 1316709 (rank 1, not in the trainer list) "Marca de muerte"; 1325756 (l48), 1325757
   (l56), 1325758 (l60) "Marca de la muerte".
9. **Smite**, deDE: 585 (rank 1, start spell) "Heilige Pein"; 591 (l6), 598 (l14), 984 (l22), 1004 (l30), 6060 (l38),
   10933 (l46), 10934 (l54) "Göttliche Pein". Wowhead Forever shows the same split (585 / 591, checked 7 Nov 2026).
10. **Healing Stream Totem**, esES: 5394 (rank 1, quest), 6375 (l30), 10462 (l50), 10463 (l60) "Tótem Corriente de
    sanación"; 6377 (l40) "Tótem de corriente curativa".
11. **Mana Tide Totem**, frFR and esES: 16190 (talent 590), 17354 (l38), 17359 (l48) "Totem de Vague de mana" /
    "Tótem de marea de maná"; 1325256 (l58) "Totem de vague de mana" / "Tótem Marea de maná".
12. **Magma Totem**, esMX: 8190 (l26) "Tótem de Magma"; 10585 (l36), 10586 (l46), 10587 (l56) "Tótem de magma".
13. **Curse of the Elements**, esMX: 440892 (l20) "Maldición de los Elementos"; 1311676 (l30), 1311677 (l40), 1311680
    (l50) "Maldición de los elementos".
14. **Bane of Agony**, frFR: 980 (l8) "Plaie d'agonie" (straight '); 1014 (l18), 6217 (l28), 11711 (l38), 11712 (l48),
    11713 (l58) "Plaie d’agonie" (curly ’).
15. **Create Healthstone**, esMX: 6201 (l10) and 5699 (l34) "Crear piedra de salud"; 6202 (l22) "Crear piedra de salud
    (inferior)"; 11729 (l46) "Crear piedra de salud (superior)"; 11730 (l58) "Crear piedra de salud (sublime)". In enUS
    and the other five languages all five ranks share one name.
16. **Create Soulstone**, frFR: 693 (l18), 20752 (l30), 20756 (l50), 20757 (l60) "Création de pierre d'âme"; 20755
    (l40) "Création de Pierre d'âme".
17. **Lightning Mastery** (Shaman): the text's 40-level talent on key Q is taken as spell 16166 = Talent 573 (tab 261,
    tier 6). That it is this one and not the passive is AFGELEID from "40 at the earliest" + tier 6 + the key being an
    active key. The passive Talent 721 (tab 261, tier 5) has ranks 16578 "Elemental Alacrity" and 16579-16582
    "Lightning Mastery" (enUS); those four are named deDE "Blitzschlagbeherrschung", esES "Maestría en relámpagos",
    ruRU "Покорение молнии" (frFR, esMX, ptBR as 16166).

Not real variants for the player (ids outside the trainer list, left out): Holy Light 1313348-1313352 (esMX "Luz
sagrada"), Flash of Light 412020 and 1313342-1313346 (frFR "Éclair lumineux"), Lightning Bolt and Chain Lightning
408xxx (frFR "Éclair", "Chaîne d’éclairs"), Serpent Sting 4257xx (esES "Picadura de serpiente"), Immolation Trap 13797
and 14298-14301 (the trap effect, frFR "Piège d’immolation"), Cleave 427744 (esES "Rajar"), Conjure Water 468766.
These are SkillLineAbility entries that are not trainer ranks; they are not shown to a Forever player as far as I can
tell (AFGELEID).

## 6. Not measured, or NOT FOUND

- **itIT, every row:** NOT FOUND. Forever ships no Italian client (section 1, GEMETEN three ways).
- **Quest titles have no Blizzard DB2 source** in 1.60.1; section 4d is Wowhead Forever (second source, marked). Which
  "Vile Familiars" (1485 or 1499) is the Summon Imp quest: not measured; only ptBR differs between them.
- **Plain gameplay words** in the text that are not a client name: buff, DoT, CC, stun, interrupt, bleed, opener,
  finisher, threat, melee, pull, taunt (as a verb), "dead zone", form, stance, aura, seal, blessing, curse, bane,
  aspect, weapon buff, "teleports and portals" (no specific Teleport/Portal spell is named), "the Greater Blessing"
  (the three specific ones are measured), "potion" singular (only ItemSubClass "Potions" exists), "cooldown" as a word
  (the client only has it inside tooltip templates, measured in 4a). These are for the translator to write in the
  language; no client string to copy. Not searched further.
- **Which Settings label the Forever menu shows** (SETTINGS "Optionen"/"Réglages"… vs GAMEOPTIONS_MENU
  "Optionen"/"Options"…), and that the action bar settings page uses ACTIONBARS_LABEL: not measured in the client.
- **Demon creature names**: wago's `Creature` table has no rows for Forever (empty result for "Voidwalker"); the names
  in 4b are `CreatureFamily`, which is what the pet frame shows for a family. "Infernal" (the Inferno demon) is not in
  CreatureFamily and is not named alone in the text.
- **Hotfixes:** not checked whether wago's CSV includes them (section 2).
- **The Shaman totem items' quest names** and the "Twisted … Totem" items are not in the text; not measured.

## 7. Retail versus Forever (selection, GEMETEN against retail SpellName 12.1.5.70783)

Same spell id, different string. Do not copy names from MH's retail packs.

- Id reused for another spell in retail (enUS differs): 2098 Eviscerate → retail "Dispatch"; 71 Defensive Stance →
  "Vanguard"; 1463 Mana Shield → "Incanter's Flow"; 527 Dispel Magic → "Purify"; 528 Cure Disease → "Dispel Magic";
  2050 Lesser Heal → "Holy Word: Serenity"; 2060 Greater Heal → "Heal"; 8004 Lesser Healing Wave → "Healing Surge";
  16166 Lightning Mastery → "Master of the Elements"; 1066 Aquatic Form → "Travel Form"; 99 Demoralizing Roar →
  "Incapacitating Roar"; 980 Bane of Agony → "Agony"; 603 Bane of Doom → "Doom"; 6789 Death Coil → "Mortal Coil";
  1122 Inferno → "Summon Infernal"; 3716 Torment → "Consuming Shadows"; 20271 Judgement → "Judgment"; 21562 Prayer of
  Fortitude → "Power Word: Fortitude"; 9484 Shackle Undead → "Shackle Horror"; 8647 Expose Armor → "Mystic Touch";
  475 Remove Lesser Curse → "Remove Curse"; 883 Call Pet → "Call Pet 1". (22 ids.)
- Same English, other translation: esES Charge "Embestir" (retail "Cargar"); esES Whirlwind "Huracán" (retail
  "Torbellino"); esES Thunder Clap "Trueno" (retail "Atronar"); esES Taunt "Irritar" (retail "Provocar"); esES
  Entangling Roots "Enredaderas" (retail "Raíces enredadoras"); deDE Cleanse "Reinigung des Glaubens" (retail
  "Läuterung"); deDE Moonkin Form "Moonkingestalt" (retail "Mondkingestalt"); deDE Hibernate "Winterschlaf" (retail
  "Überwintern"); frFR Stormstrike "Courroux naturel" (retail "Frappe-tempête"); frFR Purge "Expiation" (retail
  "Purge"); frFR Fade "Oubli" (retail "Disparition"); frFR Revenge "Vengeance" (retail "Revanche"); ruRU Silence
  "Молчание" (retail "Безмолвие"); ruRU Arcane Missiles "Чародейские снаряды" (retail "Чародейские стрелы"); ptBR Maul
  "Malho" (retail "Espancar"); and the frFR capital-E accents in section 3.
- Totals: of the 346 representative ids, 160 are not in retail SpellName at all, and 97 of the other 186 differ from
  retail in at least one of the six languages.

## Counts

- Rows: 346 spells + 45 UI words + 30 classes/races/creature words + 20 items + 7 quest rows (6 titles) = 448.
- All 448 rows are MEASURED in deDE, frFR, esES, esMX, ptBR and ruRU (quest titles via the second source).
- 0 rows are measured in itIT, because that locale does not exist for Forever.
- 17 spell names carry rank variants (section 5).
