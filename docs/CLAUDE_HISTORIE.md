# CLAUDE.md — historie

Teksten die uit `CLAUDE.md` zijn gehaald omdat een script ze afdwingt of omdat ze geschiedenis zijn (plan deel 7;
regel: een les gaat alleen uit CLAUDE.md als een script hem afdwingt of als het puur geschiedenis is).
Ongewijzigd verplaatst; nieuwste blok bovenaan.

---

## 11 nov 2026 — de goedemorgen-ronde (stond in CLAUDE.md tussen "What this is" en "How to work with Rob")

Verplaatst in de bouwchat op Robs ja ("Ja, doe het"), opdracht B van de sparring-chat. De stappen en
harde regels staan nu kort in `docs/OCHTENDRONDE.md`; de wachter-tabel alleen nog in `docs/REGIE.md`, tabel 1.

## 🔴 Als Rob "goedemorgen" zegt: eerst ophalen, dan pas praten

Vanaf 2 sep 2026 pushen **vier cloud-wachters** naar `main` terwijl niemand aan de pc zit, elke
ochtend tussen 05:30 en 06:00 Robs tijd. Zonder ophalen werk je in een repo die achterloopt, en
dat merk je pas bij de eerste push.

| tijd (Rob) | wachter | schrijft | bewaakt |
|---|---|---|---|
| 05:30 | API | `docs/API_WATCH.md` | wat de addon **breekt** |
| 05:40 | PTR/roadmap | `docs/PTR_12.1_WATCH.md` | wat er nog **komt** |
| 05:50 | blue post/data | `docs/PTR_12.0.7_DATA.md` | welk **feit** we missen |
| 06:00 | content | `docs/CONTENT_WATCH.md` | waar de addon **liegt** |
| 04:15 | **MH nachtcontrole** (`trig_01EKor6SCGxyPJPurc4MML3P`, omgeving "Midnight Helper") | `docs/NACHTCONTROLE.md` | events (C1) en spel-nummers (C2) tegen de nieuwste build |
| zo 08:00 | **MH ideeënbus** (`trig_0168w6QPWBbUob5hYf5HXFWz`) | alleen het blok "Voorstellen van de wachter" onderaan `docs/IDEEEN.md` | max 3 ideeën per week |
| 08:15 | **MH regie — dagelijks overzicht** (`trig_017LQWJNvptK8hWLuByuEDzg`, omgeving "Midnight Helper", ook de site-repo, alleen lezen) | alleen `docs/REGIE.md` (+ telefoonmelding alleen bij nieuws) | het geheel: wie wat doet, wat scheefloopt, wat op Rob wacht |

📌 **Sinds 11 nov 2026 een regisseur** (Rob: *"Ja, bouw hem"*; plan deel 8). In de ochtendronde: **lees eerst blok 0 van
`docs/REGIE.md`**. Op de pc doet het recept `/regisseur` dezelfde ronde, plus wat de cloud niet ziet.
Home Assistant start hem ook zodra Rob wakker is (06:20–08:15) en via de knop "Regisseur nu" op dashboard MH HQ
(`rest_command.regie_nu` in HA `packages/regie.yaml`, sleutel `regie_bearer` in HA `secrets.yaml`). Werkt dat niet meer:
401 = sleutel verlopen/fout → Rob maakt een nieuwe op claude.ai → Routines → MH regie → API-trigger.

📌 **Sinds 10 nov 2026 zes routines** (Rob: *"Ja, stap 4 en 5 mogen ook"*, bevestigd in de bouwchat). De twee nieuwe
hebben bewust namen die NIET op de vier oude lijken (les van 12 sep). In de ochtendronde: lees ook de laatste regel van
`docs/NACHTCONTROLE.md` (staat de snapshot achter → `run event_snapshot --write`) en, op maandag, de voorstellen van de
ideeënbus — verplaats ze naar Open of Nee; Rob beslist.
📌 **Sinds 11 nov 2026 dekken de vier ochtendwachters ook WoW: Forever** (Rob: *"Ja, voeg Forever toe aan de wachters"*).
Hun opdracht eindigt met een verwijzing naar `docs/WATCHER_FOREVER.md`; de Forever-regels staan dáár, niet in de vier
opdrachten. Wijzig dat bestand alleen met Robs ja.

Ze rapporteren alleen; ze repareren nooit. Elk raakt precies één bestand aan.

🔴 **Exa kan een WEEK OUDE PAGINA teruggeven, en dat is aan niets te zien.** GEMETEN 3 sep 2026:
`web_fetch_exa` op news.blizzard.com gaf een pagina met als titel *"Hotfixes: August 27, 2026"* —
ouder dan wat de run van de dág ervoor al gelezen had. De API-wachter ving het alleen doordat hij
tegen zijn eigen logboek vergeleek; de PTR-wachter liep er dezelfde ochtend tegenaan op
bluetracker.gg en telde het terecht niet mee. Zonder die vangst had er gestaan *"niets sinds
27 aug"*, terwijl er twee dagen aan hotfixes lagen.
✅ Alle vier de routines dragen sinds 3 sep de regel *"hang een `?nocache=JJJJMMDD` achter elke
Exa-URL"* — geverifieerd byte-voor-byte tegen wat de server opslaat, niet alleen op HTTP 200.
📌 En de bredere vorm, want die geldt overal: **is het nieuwste dat je ziet ouder dan wat je eigen
aantekening gisteren al noemde, dan kijk je naar een cache en niet naar de werkelijkheid.** Dat is
dezelfde val als [[silence-is-not-absence]], maar met een tijdstempel erop die gezond oogt.

Dus bij een groet of de eerste boodschap van de dag, ongevraagd en in deze volgorde:

1. **`git -C "<repo>" status` EERST.** Op 2 sep stond `docs/API_WATCH.md` gewijzigd-maar-
   ongecommit in de working tree, met een `.git/index.lock` die de pull blokkeerde. Een lege pull
   bewijst dus niet dat er niets gebeurd is — het werk kan op schijf staan zonder ooit in een
   commit te belanden.
   ✅ **Staat een van de vier wachter-bestanden uit de tabel gewijzigd-maar-ongecommit, commit het
   dan meteen** — alleen dat bestand, via `stage.txt` + `git_stage.py`, met als boodschap *"Commit
   the «wachter» watcher's entry of «datum», left uncommitted on disk"*. Pas daarna pullen:
   met een vuile working tree weigert `pull --rebase`. Rob, 10 sep: *"commit die API_WATCH maar
   mee, en hoe kunnen we dat voortaan wel laten gebeuren?"* — dit is het antwoord.
   ⚠️ **Kijk eerst wát er staat:** een nieuwe `- [JJJJ-MM-DD]`-regel onderaan is wachter-werk; iets
   anders (een halve regel, een wijziging midden in het bestand) meld je in plaats van te committen.
   ⚠️ **Geeft de pull daarna een conflict in dat bestand** (11 sep: de cloud-wachter had diezelfde
   dag óók een regel gepusht), **houd dan beide regels**: eerst de gepushte, dan de lokale, met een
   lege regel ertussen. Markeringen weg, `git_stage.py`, dan
   `git -C "<repo>" -c core.editor=true rebase --continue` (zonder `-c` opent git een editor).
   ✅ **DE SCHRIJVER IS GEVONDEN — 12 sep 2026.** Een **Cowork**-taak (de agentmodus van de
   desktopapp, draait in een lokale VM met deze map gemount): `midnight-helper--api-wachter`,
   `C:\Users\RobHu\Claude\Scheduled\midnight-helper--api-wachter\SKILL.md`, aangemaakt 18 aug,
   dagelijks 06:00 lokaal. Zijn opdracht zegt letterlijk *"Voeg je bevindingen toe aan
   `docs/API_WATCH.md` … geen commits"*. Dat zijn precies de wees-regels van 2, 5, 7, 10 en 11 sep, en
   de sandbox verklaart de `EGRESS_BLOCKED` in hun tekst. Twee zustertaken schrijven op dezelfde
   manier naar `PTR_12.0.7_DATA.md` en `PTR_12.1_WATCH.md`, met opdrachten uit juni.
   ⚠️ Een run in september staat niet in `main.log`; de toewijzing is afgeleid, wel sterk.
   📌 **Waarom het twee weken duurde:** `list_scheduled_tasks` toont alleen de taken van de Code-tab.
   Cowork-taken zie je alleen in `%APPDATA%\Claude\logs\main*.log`
   (`[ScheduledTasks] Spawning new session for scheduled task …`). GEMETEN uitgesloten op 12 sep: 7
   cloud-routines, 2 Code-tab-taken, 394 Windows-taken, de cron van deze sessie en andere
   desktopsessies. Memory: `cowork-scheduled-tasks-local`.
   ✅ **Verwijderd door Rob op 12 sep**; GEMETEN dat `C:\Users\RobHu\Claude\Scheduled\` leeg is. Duikt er
   tóch weer een wees-regel op, dan is er een nieuwe lokale schrijver: kijk eerst in die map en in
   `main*.log`. Het recept hierboven (committen, dan pullen) blijft de terugval.
   🔴 **LET OP DE NAMEN. De cloud-routines en de Cowork-taken lijken op elkaar** ("API watch" /
   "api-wachter", "blue post / data watch" / "bluepost-check", "PTR / roadmap watch" /
   "ptr-12-1-watch"). Op 12 sep zijn daardoor de drie verkeerde verwijderd: de **cloud**-wachters.
   Diezelfde ochtend zijn ze teruggezet uit een `RemoteTrigger list` van eerder die dag, en een script
   bevestigde byte-voor-byte gelijkheid van opdracht, schema, model, tools, repo en connectoren
   (nieuwe ID's `trig_01FLuvPV5NAb2UEN4e1fboTS`, `trig_018jpghYW8vRpDsj9qkWWD8f`,
   `trig_015Bz5PbUNrgr6x7KTiSXVqe`). 📌 Wie ooit routines laat opruimen: noem het ID en de plek
   (claude.ai → Routines, of desktopapp → Cowork → Scheduled), niet alleen de naam.
2. `git -C "<repo>" pull --rebase origin main`
3. Lees wat er nieuw in staat: de vier bestanden uit de tabel hierboven.
4. Kijk op CurseForge én GitHub: `run gh_inbox` (via `probe_job.txt`). Geen enkele wachter dekt mensen
   die ons willen helpen — Andy's vijf PR's lagen daardoor 17 dagen ongelezen, en op 1 okt 2026 bleek een
   CF-bugmelding (MrsBoojiePanda, debug-regel in de chat) óók 17 dagen ongezien. Sindsdien leest gh_inbox
   eerst de CF-reacties (open JSON: `curseforge.com/api/v1/mods/1528577/comments`; de gewone pagina geeft
   403). **Een 🔴 WAITING FOR AN ANSWER meld je Rob altijd, ook als de rest "niets" is.** Een draadje telt
   als beantwoord zodra Rob (twelveinchy) er met *Reply* in reageert; een losse nieuwe reactie telt niet.
4b. **Kijk welke van Robs andere addons zijn bijgewerkt:** `python "<repo>/tools/_probe.py" run
   addon_updates`. Sinds 22 sep 2026 (Rob: *"hebben we addons die geupdate zijn ook getest?"* → *"ja doe
   maar"*). Hij vergelijkt `## Version` met de vorige keer en print de top van elke changelog; **jij**
   oordeelt of iets MH raakt (taint, markers, secret values, TomTom, DBM-formaat, JustAC-data). Lezen is
   geen testen: zeg dat erbij, Robs `/reload` + BugSack is de test.
   📌 **Sinds 8 nov 2026 ook Forever** (`_forever_`, eigen seen-bestand) **en een wachtlijst** (Rob: *"sinds ik het op
   automatisch updaten heb gezet heb ik geen idee wat er verandert is"* → *"Ja, bouw maar"*). Een addon die op élk
   character uit staat (`WTF/.../AddOns.txt`) en een nieuwe versie krijgt, staat bovenaan met 🔔: meld die Rob altijd,
   met wat de maker veranderde — heeft hij geen changelog in de map, zoek het dan op CurseForge op. Rob praat Nederlands
   en wil per addon één zin over wat er voor HEM veranderde (niet alleen wat MH raakt), voor beide spellen.
4b'. **Kijk wat er in HandyNotes is veranderd:** `run handynotes_watch` (via `probe_job.txt`). Sinds 15 okt 2026 (Rob:
   *"op alles, en dat moet eigenlijk altijd"* — HandyNotes is volgens hem *"meestal de beste bron van allemaal"*). Hij print
   per zone de toegevoegde/verwijderde regels mét coördinaten en ID's, sinds de vorige keer (kopie in
   `tools/handynotes_snapshot/`, lokaal). **Jij** vergelijkt met MH's eigen data (DelveChestData, rares, schatten, Codex
   {WAY}-links) en neemt over wat beter is. Aanleiding: versie 158 gaf die dag élke Labyrinth-kist een quest-ID en 5
   zegelkisten die geen gids had — onzichtbaar zonder het bestand te openen.
4c. **Lees de mail van de site:** Gmail-connector, `search_threads` met
   `subject:(MH feedback OR MH vragenlijst) newer_than:3d` (afzender `feedback@midnighthelper.com`). Sinds 2 okt
   2026 (Rob: *"ik weet niet of we automatisch kijken in onze mail … anders moet deze alsnog in de
   ochtendroutine"*) — tot dan keek niemand: de cloud-wachters hebben geen Gmail. `[MH feedback]` = bug of wens
   (altijd melden, zoals een CF-reactie); `[MH vragenlijst]` = tel hem bij in `docs/SURVEY_RESULTS.md`. Robs eigen
   tests tellen niet mee (1 okt 21:09 UTC, "winnend staatslot"). Alleen lezen: nooit antwoorden, labelen of
   archiveren.
4d. **Lees de vragen van de site-chat:** `C:\Users\RobHu\Downloads\midnighthelper-site\drafts\BOUW_VRAAG.md` (Read, alleen
   lezen; de site-chat schrijft het, wij nooit). Sinds 10 nov 2026, plan deel 5 (Rob: *"het klopt allemaal, volgorde is
   goed"*). Een open vraag beantwoord je in **`docs/SITE_SEIN.md`** (ons prikbord, nieuwste regel bovenaan, statuswoorden
   *alleen op main / getagd / staat op CurseForge*). Bestaat het bestand niet of staat de lokale kopie achter, meld dat
   gewoon. Bij elke nieuwe functie, tag of CurseForge-upload werk je `SITE_SEIN.md` bij in dezelfde commit.
5. Vertel hem alleen wat hém raakt. De meeste dagen is dat "niets" — zeg dat dan ook, mét wat er
   gelezen is, zodat stilte te onderscheiden is van niet-kijken.

⚠️ **Het is nu 06:00 en de wachten schrijven vroeg, maar niet allemaal even vroeg.** Staat er nog
niets van vandaag, meld dat als *"heeft nog niet gedraaid"* en niet als *"niets gevonden"* —
dat is precies het verschil dat dit project al drie keer verkeerd om heeft gelezen.


## 11 nov 2026 — het shell-deel (stond in CLAUDE.md tussen "Spel-data snel" en "Build & verify")

Verplaatst in de bouwchat op Robs ja ("Ja, doe het"), opdracht A van de sparring-chat. In CLAUDE.md staat nu een
kort blok met alleen de regels die `tools/bash_guard.py` niet afdwingt.

## 🔴 26 sep 2026: `_probe.py` krijgt GEEN argumenten meer

GEMETEN: `settings.local.json` bevat 192 losse "Always allow"-regels voor `_probe.py" scratch <x>` en 66 voor
`_probe.py" run <x>`. De sterregel `Bash(python ".../_probe.py" *)` heeft dus nooit gematcht; elke run met
argumenten was een prompt. Waarom is niet vastgesteld. Argumentloze regels (`git_stage.py`, `lint_addon.py`,
`lua_syntax_check.py`) draaien wél schoon. Dus, net als `git_stage.py`:
1. Write `<scratchpad>/probe_job.txt` met één regel, bv. `scratch filelog.py Modules/X.lua` of
   `run check_drift --mark KEY`.
2. Draai altijd exact `python "E:/World of Warcraft/_retail_/Interface/AddOns/MidnightHelper/tools/_probe.py"`.
De job wordt na lezen hernoemd naar `probe_job.done.txt`. Overal hieronder waar `_probe.py run …` of
`_probe.py scratch …` staat: lees het als de inhoud van `probe_job.txt`.
Geschiedenis van één bestand: `scratch filelog.py <pad>` (git met een pad prompt, zie verderop).

## ⚠️ De PowerShell-tool: niet gebruiken

Op 11 aug 2026 stonden de prompts er ineens weer, terwijl er niets aan de regels was
veranderd. Oorzaak: ik was voor bestandsdatums overgestapt op de **PowerShell-tool** met
lange one-liners (`Get-ChildItem ... | ForEach-Object { ... } | Format-Table`). Elke zo'n
regel is uniek, dus geen enkele regel matcht — en "Always allow" schrijft dan de héle
regel letterlijk weg. Zo staan er inmiddels **938 regels in `settings.local.json`** die
samen bijna niets afvangen. Meer regels lossen dit dus niet op; het commando moet elke
keer dezelfde string zijn.

- **Alles wat scripting nodig heeft gaat door `tools/_probe.py`** — bestandsdatums,
  versies uit `.toc`'s, bulk-edits, tellingen. Het pad is vast en staat in de allowlist,
  dus de commandoregel verandert nooit. Het variabele deel hoort ín het script.
- 🔴 **EN DAT GELDT OOK VOOR NIEUW GEREEDSCHAP — GEMETEN 31 aug 2026.** De allowlist dekt
  precies **vijf** scriptpaden (`_probe`, `lua_syntax_check`, `lint_addon`, `lint_hook`,
  `git_stage`). Elk nieuw script is een nieuwe commandoregel en dus **een prompt bij élke
  run**. Die dag maakte ik er vier op één dag — `replay_advice`, `apply_agent_translation`,
  `fix_ptbr_valeera`, `audit_spell_placeholders` — goed voor zo'n tien prompts voordat Rob
  vroeg waarom ze bleven komen. Ik dacht dat deze regel over losse probeersels ging; hij gaat
  over de hele tools-map.
  **Dus: een blijvend werktuig krijgt nog steeds een eigen, goed benoemd bestand — maar je
  roept het aan via de voordeur:**
  ```
  python "<repo>/tools/_probe.py" run apply_agent_translation esES <bestand> --write
  ```
  `_probe.py *` staat al in de allowlist, dus dit vraagt nooit. Direct aanroepen
  (`python .../tools/apply_agent_translation.py`) werkt óók, maar kost Rob een prompt —
  doe dat niet.
  ⚠️ **Een nieuwe permissieregel toevoegen lost dit niet op**: `settings.json` wordt alleen
  bij het opstarten gelezen, dus die regel werkt pas de vólgende sessie. De voordeur werkt nu.
- **Bestanden zoeken/lezen doe je met Glob, Grep en Read.** Die vragen nooit toestemming.
  `Get-ChildItem -Recurse` is dus altijd de verkeerde keus.
- **Geen extra vlaggen op een bestaand commando.** `python -X utf8 tools/lint_addon.py`
  is een andere string dan `python tools/lint_addon.py` en matcht de regel niet meer. Los
  het op ín het script (de linter forceert nu zelf UTF-8 op stdout).
- Uitzondering: `tools/package.ps1` bij een release, en `tools/copy_to_ptr.bat` — beide
  vast, beide in een **eigen** tool-call.

## ⚠️ Shell-commando's: geen ketens, geen heredocs, geen inline scripts

Rob kreeg op 8-10 aug 2026 tientallen toestemmingsprompts omdat vrijwel elk commando de
vorm `cd "..." && python - <<'PY' ...` had. Zulke commando's zijn **niet statisch te
beoordelen**, dus er bestaat geen enkele toestemmingsregel die ze ooit kan matchen — de
prompt komt altijd. Hij heeft er drie keer om gevraagd en ik verviel er twee keer in terug.

### 📊 GEMETEN 15 aug 2026 — en het is erger dan de schatting hierboven

50 sessies, **6274 Bash-aanroepen**. Daarvan zijn er **5372 (86%) principieel onmatchbaar**:

| vorm | aantal |
|---|---|
| `&&` | 4820 |
| pijp `\|` | 442 |
| `;` | 87 |
| `\|\|` | 23 |
| heredoc `<<` | 15 |

Wat wél matchbaar is, staat allang in `.claude/settings.json`: `git -C "<repo>" *`,
`luac -p *`, `python tools/_probe.py`, `grep *`, `ls *`. Er ontbreken geen regels.

**Dus: meer regels toevoegen kan het probleem niet oplossen, en heeft dat ook nooit
gekund.** Op 15 aug zijn 159 dode regels uit `settings.local.json` gehaald (alle
PowerShell-one-liners, alle `git commit -m '<unieke tekst>'`); er staan er nog ~900,
vrijwel allemaal even eenmalig. Ze doen niets en ze kosten niets — ze zijn alleen het
bewijs dat "Always allow" op een uniek commando een dood spoor is.

De rest van dit hoofdstuk is geen stijladvies maar de enige werkende oplossing.

**De vorm is het probleem, niet de frequentie.** Dus:

- **Geen `cd X && <commando>`.** De Bash-tool onthoudt de werkmap tussen aanroepen: doe
  `cd "<map>"` als een **los** commando (die staan exact in de allowlist), daarna kale
  commando's.
- **Geen `python - <<'PY'` en geen `python -c "..."`.** Schrijf het script met de Write-tool
  naar de scratchpad en draai het via de voordeur:
  ```
  python "<repo>/tools/_probe.py" scratch <naam>
  ```
  🔴 **DEZE REGEL ZEI TOT 3 SEP 2026 IETS ONWAARS**, namelijk *"draai het als `python <pad>`,
  dat pad staat in de allowlist"*. **GEMETEN: dat pad staat er niet in.**
  `.claude/settings.json` heeft voor de Temp-map alleen `Read()` en `Write()` en **geen enkele
  `Bash`-regel** — dus elk los script vroeg toestemming, bij élke run. Op 3 sep kostte dat Rob
  zo'n vijftien prompts in één dag, en de instructie die het veroorzaakte was juist degene die
  zei dat het veilig was.
  ⚠️ **Een onjuiste regel is erger dan een ontbrekende.** Een ontbrekende laat je kijken; een
  onjuiste maakt je zeker.
- 🔴 **GEEF `git_stage.py` NOOIT EEN ARGUMENT.** De regel is
  `Bash(python ".../git_stage.py")` **zonder** ster, dus zodra er een pad achter staat matcht
  hij niet meer. Op de ochtend van 3 sep is dat argument toegevoegd als "verbetering" van een
  hardcoded sessie-id, en het brak precies de eigenschap waarvoor dit bestand bestaat: ~10
  prompts diezelfde dag. Hij zoekt zelf de nieuwste `stage.txt`.
- ⚠️ **En dat geldt voor élk allowlist-item zonder ster.** Kijk vóór je een tool uitbreidt of
  zijn regel een `*` heeft; zo niet, dan is een extra argument een prompt.
- **Geen `git commit -m` met een heredoc.** Schrijf de tekst naar `scratchpad/msg.txt` en
  gebruik `git commit -F <pad>`.
- **Geen `&&` of `;` om stappen te koppelen** die ook los kunnen. Aparte tool-calls zijn
  goedkoper dan één prompt.
- **Geen pijpen en geen redirects.** `| tail -3` en `2>&1` maken een commando net zo
  onbeoordeelbaar als een `&&`-keten. Draai de linter kaal en lees de hele uitvoer; dat
  is één scrollbeurt tegenover een prompt.
- 🔴 **Geef git NOOIT bestandsnamen als argument mee.** GEMETEN 28 aug 2026, vier proeven
  op Robs scherm: `git -C "<repo>" log --oneline -4` draait schoon, maar diezelfde regel
  mét `-- docs/NEXT_SESSION.md` erachter geeft een prompt. Read-only git staat in Claude
  Codes ingebouwde lijst en hoort nooit te vragen; die dekking valt weg zodra er paden bij
  staan (vermoedelijk "commands the analysis can't parse"). Kale git is dus gratis —
  `log`, `status`, `show`, `tag`, `rev-list`. Moet je per bestand filteren, doe het in
  `tools/_probe.py`. ⚠️ Of de `--` zelf meetelt is niet vastgesteld; deze regel dekt beide.
  📌 Dit is ook waaróm `tools/git_stage.py` werkt: `git add <lijst bestanden>` heeft exact
  dezelfde vorm. Die oplossing was goed om de verkeerde reden.
- ⚠️ **De theorie dat de allowlist verkeerd geschreven is, is DOOD** (28 aug 2026). De
  regels gebruiken `Bash(git -C "..." *)` met een spatie-ster; de officiële
  permissions-documentatie bevestigt dat `Bash(ls *)` zowel `ls -la` als kaal `ls` matcht
  en dat `:*` slechts een gelijkwaardige schrijfwijze is. **Niet omschrijven** — dat maakt
  een werkende regel kapot.
- ⚠️ **De werkmap valt hier terug** naar `Interface/AddOns` tussen tool-calls, dus `cd`
  houdt geen stand. Gebruik **absolute paden** en `git -C "<repo>"`. De regels in
  `.claude/settings.json` zijn op die vorm geschreven.
- ⚠️ **`.claude/settings.json` wordt alleen bij het opstarten gelezen.** Nieuwe regels
  werken pas na een herstart van Claude Code. En `settings.local.json` wordt door de app
  zelf teruggeschreven — zet regels daarom in `settings.json`, niet in het local-bestand.

Zie `.claude/settings.local.json` — de regels staan er, ze werken alleen als het commando
de bovenstaande vorm heeft.

