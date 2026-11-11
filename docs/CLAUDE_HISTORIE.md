# CLAUDE.md — historie

Teksten die uit `CLAUDE.md` zijn gehaald omdat een script ze afdwingt of omdat ze geschiedenis zijn (plan deel 7;
regel: een les gaat alleen uit CLAUDE.md als een script hem afdwingt of als het puur geschiedenis is).
Ongewijzigd verplaatst; nieuwste blok bovenaan.

---

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

