# Feiten, ronde 3: defensives, Divine Shield, cooldowns, "hoe", dummies, interrupt, label (7 okt 2026)

Onderzoek bij `ROLE_SWITCH_REREAD2_NEWCOMER_2026-10-07.md` (wat nog botst).
Alleen gelezen en gemeten. Niets aan code of locale veranderd.

**Legenda**
- **GEMETEN** = gezien in een bron met naam en datum of build.
- **AFGELEID** = mijn eigen redenering. Niet gemeten.
- Niets hiervan is in de client getest. Robs `/reload` blijft de echte test.

**Bronnen (alle op 7 okt 2026 gelezen)**
- **wago.tools DB2 + GlobalStrings**, build **12.1.0.69933** (live). Via het browservenster, Inertia-JSON.
- **Blizzards UI-code**: GitHub `Gethe/wow-ui-source`, tak `live`, commit `09b9db79` = "12.1.0 (69933)", 22 sep 2026.
- **Icy Veins** (datum = "Last Updated" bovenaan de pagina):
  Tanking Guide (21 sep 2026); Protection Paladin Rotation (21 aug 2026, changelog 21 sep 2026);
  Protection Paladin Mythic+ Tips (21 sep 2026); Protection Paladin Spell List (10 aug 2026);
  Holy Paladin Guide (1 okt 2026); Holy Paladin Rotation (10 aug 2026); Holy Paladin Mythic+ Tips (10 aug 2026);
  Shadow Priest Mythic+ Tips (25 aug 2026); Frost Mage Spell List (10 aug 2026).
- **Wowhead**: Protection Paladin Rotation (Updated 2026/08/12); Holy Paladin Rotation (Updated 2026/09/20);
  NPC-pagina's van de dummies (geen datum; kaartdata uit `g_mapperData`); spell-tooltips 167381 en 167385.
- **Method**: Holy Paladin Playstyle (Last Updated 27 aug 2026); "Where to find the Training Dummies in Silvermoon City" (24 feb 2026).
- **warcraft.wiki.gg** (datum = laatste bewerking, via de wiki-API): *Cast time* (16 sep 2026), *Interrupt* (23 mrt 2026),
  *Talents & Spellbook* (6 feb 2026), *Chat* (21 jan 2026), *Edit Mode* (24 jul 2026), *Group Finder* (8 sep 2026),
  *Console variables/Complete list* (4 sep 2026).
- 📌 Data van vóór 18 aug 2026 (start Season 2) heb ik alleen gebruikt als de pagina "Updated for Patch 12.1" zegt,
  of als een nieuwere bron hetzelfde zegt. Dat staat bij het punt zelf.

📌 **Eerlijk:** één grep (op `31884`) had een glob die `docs/` níét uitsloot. Ik zag daardoor een paar regels uit
`docs/audit_2026-09-17/`, `docs/playcards_audit_2026-10-03/`, `docs/NEXT_SESSION.md`, `docs/KEYBIND_MAP_DRAFT_*.md`,
`docs/SPEC_32_KEYBIND_DATA_DRIFT.md` en `docs/ROLE_SWITCH_REVIEW_NEWCOMER_2026-10-07.md`. Die heb ik **niet** als bron gebruikt.

---

## 1. Grote defensives: vooraf drukken of bewaren?

### Wat er nu staat (GEMETEN, repo)
- `SURVIVAL_STEP_BIG` (enUS:1573, nlNL:1523): *"a big one: save it for when your health drops fast"*.
- `SURVIVAL_STEP_SMALL` (enUS:1572): *"a small one: press it often, just before a big hit"*.
- `TANKKIT_CDDESC_DR` (enUS:4108, nlNL:3612): *"Press it before a big hit or at the start of a big pull, not when your health is already low. One at a time."*
- `HEALTOOLKIT_DEF_DESC` (enUS:4068): *"Press it just before a big hit lands on you, not after."*
- `SURVIVAL_STEP_BIG` geldt voor **alle 13 klassen**: `SurvivalPlan.lua:122` koppelt de stap `big` aan die tekst, en
  `PlayCardWindow.lua:735-739` zet hem onder elke rij. Minstens **28 rijen** hebben `survival = "big"` (grep op
  `Modules/KeybindRoles_*.lua`; één regel in `KeybindRoles_Priest.lua:204` was te lang om te lezen).
- Die 28 zijn van **twee soorten** (GEMETEN de lijst, AFGELEID de indeling):
  - **Grote schade-verlagers:** Guardian of Ancient Kings, Sentinel, Shield Wall, Die by the Sword, Enraged Regeneration,
    Icebound Fortitude, Vampiric Blood, Metamorphosis (Vengeance), Survival Instincts, Fortifying Brew, Astral Shift,
    Unending Resolve, Dispersion, Obsidian Scales, Heart of the Wild.
  - **Noodknoppen** (immuun, "red me van de dood", of iets anders): Divine Shield, Blessing of Protection,
    Blessing of Spellwarding, Ice Block, Aspect of the Turtle, Cloak of Shadows, Evasion, Guardian Spirit, Life Cocoon,
    Pain Suppression, Cold Snap, Earth Elemental, Rallying Cry.

### Wat de gidsen zeggen (GEMETEN)
- **Icy Veins Tanking Guide (21 sep 2026):**
  - Voorkomen is beter dan genezen; gebruik ze vaak als je niet hoeft te sparen voor één bepaald moment.
  - Knoppen die **schade verlagen**: altijd vooraf. Op 5% leven is het te laat.
  - Knoppen die **leven geven of healen**: vooraf of achteraf; bewaar ze liefst voor een plotselinge diepe dip.
  - Niet stapelen.
- **Icy Veins Protection Paladin Rotation (21 aug 2026):** Guardian of Ancient Kings: gebruik hem **vóór** een periode
  met veel schade. Ardent Defender: niet bang zijn om hem te drukken; ook goed om een dodelijke klap te overleven.
  Lay on Hands: noodheal.
- **Wowhead Protection Paladin Rotation (12 aug 2026):** "Plan your Defensives": wissel je defensives actief af
  tijdens zware schade. De 50%-knop (dat is Guardian of Ancient Kings, **AFGELEID** uit "50%, lange cooldown"; de kopjes
  op de pagina kwamen verminkt door) is voor "dangerous periods during a pull or encounter".
- **Icy Veins Shadow Priest Mythic+ (25 aug 2026), een DPS-spec:** gebruik de **kleine** knoppen vaak, bij elke
  mechaniek die eraan komt, en **bewaar de grote (Dispersion) voor grote schade die eraan komt**.
  📌 "Bewaren" betekent hier: bewaren *voor de klap die je ziet aankomen*. Niet: wachten tot je laag staat.
- **Icy Veins Frost Mage Spell List (10 aug 2026, "Updated for 12.1"):** Ice Block is het best om een mechaniek op te
  vangen die je anders zou doden, **of** als laatste redmiddel om niet dood te gaan.
- **Icy Veins Holy Paladin Guide (1 okt 2026):** Divine Protection kun je bij elk gevaarlijk moment aan hebben;
  Divine Shield is een "get out of jail free card".

### Antwoord
- **(a) Tanks:** grote schade-verlager **vóór** de grote klap of aan het begin van een grote pull. Eén tegelijk.
  Houd één noodknop achter de hand. — **GEMETEN** (Icy Veins 21 sep, Wowhead 12 aug). `TANKKIT_CDDESC_DR` klopt al.
- **(b) DPS en healers:** dezelfde regel. Kleine knop vaak, net vóór een klap. Grote knop vóór de hardste klap die
  je ziet aankomen. Een immuniteit mag óók als laatste redmiddel. — **GEMETEN** (Shadow Priest 25 aug, Frost Mage
  10 aug, Holy Paladin 1 okt), **AFGELEID** dat het voor álle specs geldt.
- **De nuance:**
  - Kleine defensive: vaak, en vooraf.
  - Grote schade-verlager: vooraf. Pas drukken als je al laag staat is te laat.
  - Noodknop (immuun, overleef-een-dodelijke-klap, grote heal op jezelf): vooraf tegen iets dodelijks, **of** als je
    bijna dood bent. Ga niet dood met hem ongebruikt.
- **Moet `SURVIVAL_STEP_BIG` anders? Ja.** — **AFGELEID**. "Bewaar hem voor als je health snel zakt" is fout voor de
  15 grote schade-verlagers hierboven (Icy Veins: "op 5% is het te laat"). Voor de noodknoppen is het half waar.
  De tekst geldt voor alle klassen tegelijk, dus hij moet beide soorten dekken.

### Voorstel (Rob kiest)
- **Eén zin die voor alle specs klopt** (voor de Academy):
  - EN: "Small defensive: press it often, just before a hit. Big defensive: press it just before the hardest hit you see coming. Immunity or cheat-death: also fine when you are about to die. Never all at once."
  - NL: "Kleine defensive: vaak, net vóór een klap. Grote defensive: net vóór de hardste klap die je ziet aankomen. Immuun of 'red me': ook goed als je bijna dood bent. Nooit allemaal tegelijk."
- **`SURVIVAL_STEP_BIG`** (de korte regel op de kaart):
  - EN: "a big one: press it just before the hardest hit you see coming - or, if that goes wrong, when you are about to die"
  - NL: "een grote: druk hem net vóór de hardste klap die je ziet aankomen - of, als dat misgaat, als je bijna dood bent"
- `SURVIVAL_STEP_SMALL` en `TANKKIT_CDDESC_DR` mogen blijven. — **AFGELEID**.

---

## 2. Divine Shield: welke uitleg is waar?

### Wat er nu staat (GEMETEN, repo)
De naam "Divine Shield" staat **niet** letterlijk in `enUS.lua` of `nlNL.lua` (grep gaf 0; positieve controle: dezelfde
glob vond wel `TANKKIT_CDDESC_IMMUNITY`). De naam komt live uit het spel. De drie uitleggen die bij spell 642 komen:
1. **Tank-toolkit:** `TANKKIT_CDDESC_IMMUNITY` (enUS:4109): *"Panic button — survives a lethal hit. While it is up, enemies hit someone else, and they do not always come back to you: be ready to taunt."* (`TankToolkit.lua:109`, soort `immunity`).
2. **Heal-toolkit (Holy):** `HEALTOOLKIT_DEF_DESC` (enUS:4068): *"Press it just before a big hit lands on you, not after."* Dezelfde zin staat ook bij Divine Protection (`HealerCooldowns.lua:223`; `RoleAcademy.lua:596`).
3. **Kaart, Blijf leven:** `SURVIVAL_STEP_BIG` + `SURVIVAL_NOTE_FORBEARANCE` (`KeybindRoles_Paladin.lua:66`).

### Wat de bronnen zeggen (GEMETEN)
- **DB2 12.1.0.69933, spell 642:** immuun voor alle schade, schadelijke effecten, wegduwen en verplaatsen, **8 sec**
  (SpellDuration 31 = 8000 ms). Cooldown **5 min** (300000 ms). Met het talent **Final Stand (204077)**: "Taunts all
  targets within 15 yd". Geeft **Forbearance**; met Forbearance kun je hem niet drukken.
- **Icy Veins Prot Paladin Spell List (10 aug 2026):** Forbearance duurt 30 sec. Vijanden die jou slaan, gaan iemand
  anders slaan, want je bent geen geldig doel zolang hij aan staat.
- **Icy Veins Prot Paladin Rotation (21 aug 2026):** vijanden negeren je zolang je immuun bent; Final Stand dwingt een
  taunt af. Truc: druk hem als een spreuk op jou al bezig is, en haal hem weg als die klaar is.
- **Wowhead Prot Paladin (12 aug 2026)** en **Icy Veins Holy Paladin (1 okt 2026):** "Get out of jail free card".
- **warcraft.wiki.gg *Divine Shield*** (20 apr 2026, in FACTS1 punt 8): threat blijft staan, maar vijanden komen niet altijd terug.

### Antwoord
Geen van de drie is helemaal fout, maar elk vertelt maar één kant. — **AFGELEID**.
- Uitleg 1 (tank) klopt het best: noodknop, vijanden gaan naar iemand anders. Hij mist alleen Final Stand.
- Uitleg 2 ("niet erna") klopt voor gepland gebruik, maar niet als noodknop: dan druk je hem juist als het misgaat.
- Uitleg 3 ("bewaar tot je zakt") klopt alleen voor de noodknop-kant.

**De ene ware uitleg:** een noodknop van 8 sec. Druk hem net vóór een klap die je zou doden, **of** als je bijna dood
bent. Zolang hij aan staat, slaan vijanden iemand anders (behalve met Final Stand).

### Voorstel (Rob kiest)
- Voor alle drie de plekken:
  - EN: "Your panic button: 8 sec immune to almost all damage. Press it just before a hit that would kill you, or when you are about to die. While it is up, enemies attack someone else - unless you have Final Stand."
  - NL: "Je noodknop: 8 sec immuun voor bijna alle schade. Druk hem net vóór een klap die je zou doden, of als je bijna dood bent. Zolang hij aan staat, slaan vijanden iemand anders - tenzij je Final Stand hebt."
- Voor de tank-toolkit erachter: EN "Be ready to taunt when it ends." NL "Wees klaar om te taunten als hij afloopt."
- 📌 De heal-toolkit gebruikt één zin voor Divine Protection én Divine Shield. Voor Divine Protection klopt "net vóór
  een grote klap" wél. **AFGELEID:** geef Divine Shield in de heal-toolkit dus een eigen zin, of laat de toolkit per
  soort (verlager / immuun) een andere zin kiezen.

---

## 3. Avenging Wrath en Divine Toll: meteen of wachten?

### Eerst een correctie op de opdracht (GEMETEN)
- **31884 staat níét in `Modules/TankToolkit.lua`.** Grep op `31884` buiten `docs/`: alleen `HealerCooldowns.lua:102`,
  `DpsToolkit.lua:56`, `KeybindRoles_Paladin.lua:214` en de locales. (Positieve controle: dezelfde grep vond die drie.)
- De zin "tijdens zware schade" is `HEALCD_WHEN_FLOW` (enUS:4059, nlNL:3563) in de **heal**-toolkit, voor **Holy
  Paladin (65)**: `HealerCooldowns.lua:102-103`. Dat is botsing A3 uit het newcomer-rapport.
- De Prot-kaart: `PLAYCARD_66_S1` (enUS:1197): *"{Avenging Wrath} and {Divine Toll} when ready: they start your big moment."*
- De Holy-kaart: `PLAYCARD_65_S1` (enUS:1247) *"whenever they are ready"* en `PLAYCARD_65_HERO1` (enUS:1253) *"Press Divine Toll on cooldown"*.

### Protection Paladin (66) — GEMETEN
- **Icy Veins Prot Rotation (21 aug 2026):** prioriteit 1 = Avenging Wrath, 3 = Divine Toll. De opener: Avenging
  Wrath, dan Divine Toll.
- **Wowhead Prot Rotation (12 aug 2026):** "Cast Avenging Wrath on cooldown." Divine Toll: "Try to use this on cooldown as much as possible."
- **Antwoord:** de kaart `PLAYCARD_66_S1` klopt. — **GEMETEN**.

### Holy Paladin (65) — GEMETEN
- **Icy Veins Holy Rotation (10 aug 2026, "Updated for Patch 12.1"):** "Keep Divine Toll on cooldown as much as
  possible." Avenging Wrath: zo vaak mogelijk, en liefst samen met een langere periode met veel schade.
- **Icy Veins Holy Guide (1 okt 2026):** houd Divine Toll op cooldown; anders mis je veel healing.
- **Wowhead Holy Rotation (20 sep 2026):** "Strive to get as many uses of Divine Toll and Avenging Wrath as possible. If in doubt, use them."
- **Method Holy (27 aug 2026):** Avenging Wrath eigenlijk op cooldown. Divine Toll meestal op cooldown; alleen
  vasthouden als je weet dat er **zo** een grote klap komt.
- **Antwoord:** de kaart klopt. `HEALCD_WHEN_FLOW` ("zet in tijdens zware schade") is voor deze twee **misleidend**:
  een beginner gaat erop wachten. — **AFGELEID** uit vier bronnen.
- ⚠️ `HEALCD_WHEN_FLOW` hoort ook bij Tree of Life, Convoke, Stasis, Ultimate Penitence en Apotheosis
  (`HealerCooldowns.lua:111, 112, 119, 131, 141`). Of "vaak" voor die ook geldt: **niet onderzocht**. Verander de
  gedeelde tekst dus niet blind; geef Avenging Wrath en Divine Toll een eigen "wanneer".

### Extra botsing die ik zag: Sentinel (Prot)
- **GEMETEN:** Icy Veins (21 aug 2026): "Sentinel replaces Avenging Wrath." Sentinel staat in de repo als grote
  defensive op de kaart (`KeybindRoles_Paladin.lua:218`, `survival = "big"`) en in de tank-toolkit (`TankToolkit.lua:107`, soort `dr`).
- **AFGELEID:** wie Sentinel heeft, krijgt dus op dezelfde knop "druk als klaar" (S1) én "bewaar" (Blijf leven).
  De gidsen zetten de Avenging Wrath-plek bovenaan de prioriteit. Met de nieuwe `SURVIVAL_STEP_BIG` uit punt 1
  ("net vóór de hardste klap") wordt de botsing kleiner, maar niet nul. Hoe `{SPELL:31884}` op de kaart toont als
  Sentinel gekozen is: **niet gemeten**.

### Voorstel (Rob kiest)
- Nieuwe "wanneer" voor Avenging Wrath en Divine Toll (Holy):
  - EN: "Use it often - close to on cooldown. Only hold it a few seconds if you know a big damage moment is coming."
  - NL: "Gebruik hem vaak, bijna op cooldown. Houd hem alleen een paar seconden vast als je weet dat er zo een grote klap komt."
- `PLAYCARD_66_S1`, `PLAYCARD_65_S1` en `PLAYCARD_65_HERO1` mogen blijven. — **AFGELEID**.

---

## 4. "Hoe" per stap van het stappenplan

### Wat ik vond over standaardtoetsen
- **Standaardtoetsen staan niet in de Blizzard-code en niet in de DB2.** — **GEMETEN**:
  - GlobalStrings 12.1.0.69933: zoeken op `%(N)%`, `%(I)%`, `%[N]%`, `%Shift+J%` en dergelijke gaf 0. Positieve
    controle: `%Spellbook%` vond 21 regels.
  - UI-code: de enige `Bindings.xml`-bestanden (PingUI, Commentator, GlueXML, PTRFeedback) hebben geen standaardtoets.
- **Wel GEMETEN in de code:** de knoppen in het **micromenu** tonen bij muis-erover de toets die de speler écht heeft.
  `MainMenuBarMicroButtons.lua:56-59` (`MicroButtonTooltipText` → `FormatBindingKeyIntoText`), met de bindings
  `TOGGLETALENTS` (`:665`), `TOGGLEGROUPFINDER` (`:1294`) en `TOGGLEGAMEMENU` (`:1788`).
  📌 Dat is beter dan een vaste toets: het klopt ook als iemand zijn toetsen heeft veranderd.
- **Het micromenu staat rechtsonder.** — **GEMETEN**: `MicroButtonAndBagsBar` hangt aan BOTTOMRIGHT van het scherm
  (`MicroMenuContainer.xml:4`, x −6, y 6); het menu hangt daaraan (`EditModePresetLayoutConstants.lua:15-17`, Standard).
- **Toetsen die alleen een wiki noemt** (dus **niet** in Blizzard-code; Rob kiest of ze erin mogen):
  - Talents & Spellbook = **N** (warcraft.wiki.gg *Talents & Spellbook*, 6 feb 2026).
  - Chat openen = **Enter** of **/** (warcraft.wiki.gg *Chat*, 21 jan 2026).
  - Edit Mode via **Esc** (warcraft.wiki.gg *Edit Mode*, 24 jul 2026).
  - Group Finder = **I**: **niet** gevonden in een gedateerde bron. De wiki-pagina *Group Finder* (8 sep 2026) noemt
    geen toets. FACTS1 had alleen Icy Veins zonder datum. **Dus niet gebruiken.**
  - ⚠️ Let op: `ACADEMY_SEE_BODY` noemt al **Shift+J**. Die komt ook alleen uit de wiki (FACTS2). Voor gelijkheid: óf
    alle wiki-toetsen mogen, óf ook Shift+J wordt "via het menu".

### Per stap
| Stap | Hoe (letterlijke namen) | Status |
|---|---|---|
| Talents & Spellbook | Knop **"Talents & Spellbook"** in het rijtje kleine knoppen rechtsonder. Muis erop = je toets. | **GEMETEN** naam (`PLAYERSPELLS_BUTTON`), plek en tooltip (code). |
| Spell op een toets | Talents & Spellbook → tab **"Spellbook"** → sleep de spreuk met de **linkermuisknop** naar een vak op je actiebalk. | **GEMETEN**: tab `TALENT_FRAME_TAB_LABEL_SPELLBOOK`; slepen = `RegisterForDrag("LeftButton")` → `PickupSpellBookItem` (`Blizzard_SpellBookItem.lua:730, 752-754, 639-644`). Blizzard zegt het zelf: `NEWBIE_TOOLTIP_SPELLBOOK` en `RPE_NO_INTERRUPT_ACTION` = "Add an interrupt ability to your action bar from your Spellbook". |
| ... welke spreuk mist? | Een spreuk die op **geen enkele** balk staat, licht op in het Spellbook, en de tooltip zegt **"You haven't added this to your action bars"**. | **GEMETEN** in code (`Blizzard_SpellBookItem.lua:325-342, 509-511`; `TALENT_BUTTON_TOOLTIP_NOT_ON_ACTION_BAR`). Alleen voor je huidige spec (`Blizzard_SpellBookCategory.lua:214`). Hoe het oplicht eruitziet: **AFGELEID**. |
| ... welke toets is het dan? | De toets die op dat vak van de actiebalk staat. | **AFGELEID** (niet gemeten welke toets bij welk vak hoort). |
| Group Finder | Knop **"Group Finder"** rechtsonder → links **"Dungeon Finder"** → keuzelijst. | **GEMETEN** (`DUNGEONS_BUTTON`, `LOOKING_FOR_DUNGEON_PVEFRAME`; FACTS1). |
| Stap 6 follower | ... keuzelijst **"Follower Dungeons"** → kies dungeon en rol → **"Find Group"**. | **GEMETEN** (FACTS1; `LFG_TYPE_FOLLOWER_DUNGEON`, `FIND_A_GROUP`). |
| Stap 7 normal | ... keuzelijst **"Random Dungeon (Midnight)"** of **"Specific Dungeons"** → rol → **"Find Group"**. | **GEMETEN**: LFGDungeons 2746 = "Random Dungeon (Midnight)", DifficultyID 1 (Normal); `SPECIFIC_DUNGEONS` = "Specific Dungeons". Dat precies die naam in de keuzelijst staat: **AFGELEID**. |
| Edit Mode | **Esc** → knop **"Edit Mode"**. Zonder Esc: knop **"Game Menu"** rechtsonder → "Edit Mode". Of: rechtsklik op je eigen portret → "Edit Mode". | **GEMETEN** knoppen (`HUD_EDIT_MODE_MENU`, `MAINMENU_BUTTON`; FACTS1 `GameMenuFrame.lua:184-185`, `UnitPopupMenus.lua:21`). Esc als toets: alleen wiki. |
| /mh typen | In het **chatvenster linksonder**: druk Enter, typ `/mh play`, druk Enter. | **GEMETEN**: chatvenster BOTTOMLEFT (`EditModePresetLayouts.lua:484-497`, x 35); Enter verstuurt (`ChatFrameEditBox.lua:405-409`, `OnEnterPressed` → `SendText`). Enter om te openen: alleen wiki. Chat-stijl standaard `im` (wiki CVar-lijst, 4 sep 2026). |

### Voorstel-zinnen (Rob kiest)
- `ACADEMY_STEP_HINT`, erbij:
  - EN: "Tip: hover a button in the row of small buttons at the bottom right - the tooltip shows its key."
  - NL: "Tip: houd je muis op een knop in het rijtje kleine knoppen rechtsonder - de tooltip toont de toets."
- `ACADEMY_STEP_TANK_SPEC` / `_HEAL_SPEC`:
  - EN: "Switch to your tank spec: Talents & Spellbook (bottom right) -> Specialization -> Activate"
  - NL: "Wissel naar je tank-spec: Talents & Spellbook (rechtsonder) -> Specialization -> Activate"
- `ACADEMY_STEP_TANK_KEYS`:
  - EN: "Your taunt and your interrupt are on a key: Talents & Spellbook -> Spellbook, drag each spell with the left mouse button onto your action bar"
  - NL: "Je taunt en je interrupt staan op een toets: Talents & Spellbook -> Spellbook, sleep elke spreuk met de linkermuisknop naar je actiebalk"
- `ACADEMY_STEP_FOLLOWER`:
  - EN: "One follower dungeon done (Group Finder, bottom right -> Dungeon Finder -> Follower Dungeons -> Find Group)"
  - NL: "Eén follower dungeon gedaan (Group Finder, rechtsonder -> Dungeon Finder -> Follower Dungeons -> Find Group)"
- `ACADEMY_STEP_NORMAL`:
  - EN: "One normal dungeon done with real players (Group Finder -> Dungeon Finder -> Random Dungeon (Midnight) -> Find Group)"
  - NL: "Eén normal dungeon gedaan met echte spelers (Group Finder -> Dungeon Finder -> Random Dungeon (Midnight) -> Find Group)"
- `ACADEMY_STEP_CARD`:
  - EN: "Read your spec's card once: press Enter, type /mh play, press Enter"
  - NL: "De kaart van je spec één keer gelezen: druk Enter, typ /mh play, druk Enter"
  - (Enter om de chat te openen komt uit de wiki. Wil Rob alleen Blizzard-code: "type /mh play in the chat box at the bottom left and press Enter".)
- `ACADEMY_STEP_HEAL_FRAMES` mag blijven. — **AFGELEID**.

---

## 5. Training dummies

### In Silvermoon (GEMETEN)
- **MH-pin:** `UI.lua:1317`, "Training Dummies", map 2393, **36.0 / 84.2** (tab "Silvermoon City", `TAB_SMC`).
- **Wowhead (kaartdata, geen datum), map 2393 Silvermoon City**, allemaal tussen **35.8–36.6 / 83.5–85.6**:
  | NPC | Soort (Wowhead) | Plek |
  |---|---|---|
  | 243214 Training Dummy | Healing | 36.0 / 84.2 |
  | 243207 Training Dummy | Damage | 36.4 / 84.0 en 36.6 / 83.8 |
  | 243208 Cleave Training Dummy | Damage | 4×, 36.2–36.6 / 85.0–85.6 |
  | 243168 Dungeoneer's Training Dummy | Damage | 35.8 / 84.4 en 35.8 / 84.6 |
  | 243167 Dungeoneer's Training Dummy | **Tanking** | 36.0 / 84.8 |
  | 243166 **Normal Tank Dummy** | **Tanking** | 36.2 / 83.5 |
  | 243211 / 243212 PvP Training Dummy | Damage / Healing | 39.8 / 84.0 (een eindje oostelijker) |
- **Method (24 feb 2026):** "Western side of Silvermoon City just outside of the Falconwing Square", `/way #2393 36.32 84.60`.
  Ouder dan Season 2, maar Wowhead zegt hetzelfde.
- **Antwoord:** de MH-pin staat **goed**, midden in de groep (precies op de heal-dummy). — **GEMETEN**.

### Elders in Midnight (GEMETEN, Wowhead NPC-lijst "dummy", zones via wago AreaTable 12.1.0.69933)
- **Isle of Quel'Danas** (map 2424): één Training Dummy (243207, Damage) op **54 / 58**.
- **Voidstorm** (map 2405): twee Training Dummies (256302) op **50.2 / 61.0** en **50.6 / 59.6**. Wat voor plek dat is: **niet gemeten**.
- **Slayer's Rise / Masters' Perch** (map 2444, PvP-hub in Voidstorm): vier **PvP** Training Dummies (255824/255825),
  35.0–40.2 / 78.8–81.4.
- **Harandar, Zul'Aman, Eversong Woods, Coiled Isle:** **niet gevonden** in die lijst. Positieve controle: dezelfde lijst
  vond Silvermoon, Quel'Danas en Voidstorm wel. ⚠️ Een lege lijst bewijst niet dat er geen dummy staat (een andere naam
  wordt niet gevonden).
- Oudere steden (bv. Dornogal, area 14771) hebben ook dummies. — **GEMETEN** (zelfde lijst).

### Kun je een dummy taunten en interrupten?
- **Normal Tank Dummy (243166)** slaat terug. Wowhead noemt twee aanvallen: **Dummy Strike** (instant, fysiek) en
  **Uber Strike** (**1 sec cast**, Shadow, +10% schade voor 20 sec). — **GEMETEN** (Wowhead-tooltips 167381, 167385).
- Uber Strike heeft in de DB2 `InterruptFlags = 8` (SpellInterrupts, 12.1.0.69933). — **GEMETEN**. Dat bit 8 "te
  interrupten" betekent: **AFGELEID** (betekenis uit server-emulators). **In de client niet getest.**
- Druk je een interrupt op een doel dat niets cast, dan is hij verspild (gaat wel op cooldown). — **GEMETEN**
  (warcraft.wiki.gg *Interrupt*, 23 mrt 2026). Dus oefenen van "waar zit mijn toets" kan altijd.
- Taunt op een dummy: **niet gemeten**. **AFGELEID:** de tank-dummies vallen aan, dus taunten heeft daar zin.

### Voorstel (Rob kiest)
- `ACADEMY_STEP_TANK_DUMMY`:
  - EN: "Practised at the training dummies in Silvermoon (west side, by Falconwing Square - MH's Silvermoon City tab has a pin): the Normal Tank Dummy hits back - taunt it, press your defensive, and press your interrupt once"
  - NL: "Geoefend bij de training dummies in Silvermoon (westkant, bij Falconwing Square - de MH-tab Silvermoon City heeft een pin): de Normal Tank Dummy slaat terug - taunt hem, druk je defensive, en druk één keer je interrupt"
- Een zin in de woordenlijst (`ACADEMY_WORDS_BODY`), want het woord wordt nergens uitgelegd:
  - EN: "Training dummy: a straw target in town that never dies. Hit it to practise your buttons."
  - NL: "Training dummy: een oefenpop in de stad die nooit doodgaat. Sla erop om je knoppen te oefenen."

---

## 6. Interrupt: wanneer?

### Wat er nu staat (GEMETEN)
- `ACADEMY_SEE_BODY` (enUS:2226, nlNL:2150): *"Is de balk vol, dan komt de spreuk. Dát is je moment om te interrupten, weg te stappen of je defensive te drukken."*
- `TANKKIT_TK_KICK` (enUS:4089, nlNL:3593): *"stopt een spreuk van een vijand terwijl die gecast wordt. Let op de balk die vol loopt ..."* Die klopt.

### Wat de bronnen zeggen (GEMETEN)
- **warcraft.wiki.gg *Cast time* (16 sep 2026):** het effect van een spreuk gebeurt pas als de balk **helemaal vol** is.
- **warcraft.wiki.gg *Interrupt* (23 mrt 2026):** een interrupt werkt alleen terwijl het doel aan het casten is. Druk je
  hem als het doel niet cast, dan is hij verspild. Instant-spreuken kun je niet interrupten. Een cast met een **schild**
  rond het icoon kun je niet interrupten.
- **Blizzard zelf** (GlobalStrings 12.1.0.69933): `RPE_SPELL_INTERRUPT` = "Shielded cast bars cannot be interrupted".

### Antwoord
- **De lezer van het newcomer-rapport heeft gelijk: de zin is fout te lezen.** Is de balk vol, dan is de spreuk al
  geland: dan is het **te laat** om te interrupten, weg te stappen of een defensive te drukken. — **AFGELEID** uit de
  twee wiki-pagina's (**GEMETEN**).
- **Juist:** interrupt **terwijl de balk volloopt**. Zodra je hem ziet is prima.
- Nuance (niet voor beginners): een paar gidsen (zonder sterke naam, maart 2026) zeggen dat ervaren spelers pas bij
  70–80% van de balk kicken. Ook dat is **vóór** vol. — **GEMETEN** in die bronnen; zwakke bronnen, dus niet gebruiken
  in de les.

### Voorstel (Rob kiest)
Tweede alinea van `ACADEMY_SEE_BODY`:
- EN: "When an enemy casts a spell, a bar fills up under its health bar (and under its portrait if it is your target). The spell lands the moment the bar is full. So interrupt, step away or press a defensive while the bar is still filling - as soon as you see it is fine. A full bar is too late. A bar with a shield cannot be interrupted."
- NL: "Cast een vijand een spreuk, dan loopt er een balk vol onder zijn health-balk (en onder zijn portret als hij je doel is). De spreuk komt op het moment dat de balk vol is. Dus interrupt, stap weg of druk je defensive terwijl de balk nog volloopt - zodra je hem ziet is prima. Een volle balk is te laat. Een balk met een schild kun je niet interrupten."

---

## 7. Het label "Zuinig" / "Efficient" op de grote heal

### Wat er nu staat (GEMETEN)
- `HEALCORE_TAG_BIG` = "Efficient" (enUS:4139), "Zuinig" (nlNL:3643); ook de/fr/es/pt/it in `Translations2026.lua:6113, 6521, 6935, 7353, 7778`.
- Het label hangt op Holy Light, Enveloping Mist en Healing Wave (`HealerCooldowns.lua:161, 185, 202`).
- De uitleg ernaast: `HEALCORE_DESC_BIG` (enUS:4146) "Bigger, slower heal - heals a lot, but takes time to cast. Whether it saves mana depends on your spec."

### Wat de data zegt (GEMETEN, DB2 12.1.0.69933, spell-tooltips)
- Holy Light (82326): **"A powerful but expensive spell"**. 7% mana voor Holy (FACTS2).
- Healing Wave (77472): **"An efficient wave of healing energy"**.
- Enveloping Mist (124682): "Wraps the target in healing mists ..." — **niets** over zuinig of duur.

### Antwoord
"Zuinig" is **fout** voor Holy Light (Blizzard zegt zelf "expensive"), **waar** voor Healing Wave, en **onbekend** voor
Enveloping Mist. — **GEMETEN** de tooltips, **AFGELEID** het oordeel. Wat wél voor alle drie klopt: groter en trager.

### Voorstel (Rob kiest)
- **Optie A (mijn voorkeur, AFGELEID):** EN **"Big"**, NL **"Groot"**. Past bij Triage ("je grote heal") en bij `HEALCORE_DESC_BIG` ("Bigger, slower heal").
- Optie B: EN "Slow", NL "Traag". Ook waar, maar klinkt als een nadeel.
- Dan Triage gelijk trekken (`ACADEMY_HEAL_TRIAGE_BODY`, enUS:2250, nlNL:2174), want "je zuinige heal" wijst bij
  Resto Druid nergens naar (newcomer-rapport A4):
  - EN, laatste zin: "Calm: a heal that costs little mana (the tooltip shows the cost)."
  - NL, laatste zin: "Rustig: een heal die weinig mana kost (de tooltip toont de kosten)."
- ⚠️ De vijf andere talen moeten mee: hun huidige woord betekent ook "zuinig".

---

## Extra's die ik onderweg zag (niet gevraagd)

- **Pull met taunt (`PLAYCARD_66_S5`, botsing 1 van het newcomer-rapport).** Icy Veins Prot Rotation (21 aug 2026):
  opener = "pull the enemy with Hand of Reckoning". Wowhead Prot (12 aug 2026): "Hand of Reckoning on pull so no
  DPS/Healers get punched". Beide gaan over **één baas**. — **GEMETEN**. De Academy zegt: pack = AoE. Dat botst niet.
  - Voorstel EN: "On a boss, start with {SPELL:62124}. On a pack, start with your AoE. Taunt whenever an enemy hits someone else."
  - Voorstel NL: "Bij een baas: begin met {SPELL:62124}. Bij een pack: begin met je AoE. Taunt zodra een vijand iemand anders slaat."
- **Hoe lang duurt de taunt?** Icy Veins Prot Rotation (21 aug 2026) zegt bij Hand of Reckoning **3 sec**. FACTS1
  mat in de DB2 **6 sec** voor alle zes de taunts, en de Academy zegt 6 (`ACADEMY_TANK_WHAT_BODY`). **Niet opgelost.**
  De DB2 is de hardere bron.

---

## Wat ik niet vond of niet kon meten

- **Niets in de client getest.** Paden komen uit Blizzards UI-code van build 69933, niet uit een screenshot.
- **Standaardtoetsen** (N, I, Enter, Esc, Shift+J) staan niet in Blizzard-code of DB2. N, Enter en Esc alleen in de wiki;
  I nergens met een datum.
- Of **Uber Strike** van de tank-dummy echt te interrupten is.
- Of je een **dummy kunt taunten**.
- Wat de **Voidstorm-dummies** (50.2 / 61.0) voor plek zijn.
- Of er dummies in **Harandar, Zul'Aman of Eversong** staan (niet gevonden is niet "bestaan niet").
- Hoe de kaart `{SPELL:31884}` toont als **Sentinel** gekozen is.
- Of "gebruik hem vaak" ook geldt voor de andere `flow`-cooldowns (Tree of Life, Convoke, Stasis, Ultimate Penitence, Apotheosis).
- Heal per mana voor **Enveloping Mist** (ook in FACTS1/2 niet).
- De taunt-duur: 3 sec (Icy Veins) tegen 6 sec (DB2).
- Wowhead-NPC-pagina's tonen geen datum. Exa-pagina's kunnen een oude kopie zijn; ik hing er `?nocache=20261007` achter.
