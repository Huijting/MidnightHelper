# CLAUDE.md — Midnight Helper

Guidance for Claude when working in this repository. Read this first every session.

## What this is

**Midnight Helper** is an all-in-one utility addon for **World of Warcraft Retail** (patch **12.1 "Curse of Ula'tek"**, live since 11 Aug 2026; Season 2 since 18 Aug. The `.toc` declares `## Interface: 120007, 120100`), written in **Lua**. It covers weekly planning, Delves, Great Vault, achievement hunts, a live class-layout coach, on-screen combat helpers, standalone route guidance, and reference guides — localized in 7 languages.

The maintainer (**Rob**) is a non-developer but tests every change in-game. A second tester (**Cisca**) is used for big changes.

## How to work with Rob (important)

- **Respond in Dutch, concise and direct.** Minimal fluff.
- **Never-lie / verify, don't guess.** Never invent spell IDs, coordinates, texcoords, API names or achievement criteria. Prefer "I don't know, let's check" over a plausible guess. Rob/Cisca confirm in-game.
  - ⚠️ **The other installed addons are a place to find CANDIDATES, never proof.** They go stale, they guard calls behind `if`, and they contain combat-log samples full of monsters' spell IDs. On 8 Aug 2026 `LEARNED_SPELL_IN_TAB` was registered because the name appeared four times across them; 12.x threw "Attempt to register unknown event" on the next reload. The same night, grepping for "Arcane Explosion" produced 22271 — a Blackwing Mage's version of it.
  - 🔴 **EN DAT GELDT OOK VOOR STATUS, NIET ALLEEN VOOR SPEL-DATA. Rob, 31 aug 2026: "je moet
    niets aannemen maar altijd en dan ook altijd factchecken."** Die dag somde ik elf Spec
    31-punten op als af/open, en Rob vroeg tweemaal of ik het écht gecontroleerd had. Beide keren
    terecht: één punt had ik nul keer aangeraakt, twee greps zochten naar **zelfverzonnen
    sleutelnamen**, en één regel had ik stilzwijgend laten vallen omdat mijn patroon niets vond.
    De conclusies klopten toevallig — dat maakt het erger, niet beter.
    **Een status uit een document citeren is géén controle.** `NEXT_SESSION.md` zei diezelfde
    dag dat 7 van de 11 beroepen ongecontroleerd waren; dat was 's ochtends waar en 's middags
    niet meer, en ik gaf het door als feit.
    Dus, verplicht, elke keer:
    1. **Meet het in de bron** — de code, het bestand, de client — niet in een aantekening
       erover. Een aantekening is een claim mét een datum, geen bewijs.
    2. 🔴 **Een leeg zoekresultaat bewijst NIETS zonder positieve controle in dezelfde run.**
       Bewijs eerst dat je patroon iets vindt dat er zéker is. GEMETEN diezelfde dag: `grep
       RING_OF_GLORY` gaf nul treffers in `enUS.lua` — de sleutel heet daar `RINGOFGLORY`. Was
       ik gestopt, dan had ik gemeld dat een delve geen tips had. Zie [[silence-is-not-absence]].
    3. **Zeg per bewering of hij GEMETEN of AFGELEID is.** Een tabel waarin die twee er hetzelfde
       uitzien is een tabel die liegt over zijn eigen betrouwbaarheid.
    4. **Kun je iets niet meten, zeg dat** in plaats van het weg te laten. Weglaten leest als
       "gecontroleerd en in orde".
  - **Ask the client instead.** Write the answer to `ns.db.<something>`, have Rob `/reload`, then read the SavedVariables file. `scannedIds` in the automap dump and `/mh events` exist for exactly this. Wowhead (12.0.7) and the official API wiki are fine for candidates too — the client settles it.
- **Rob's in-game `/reload` is the final syntax check.** Do a static check too where possible (see Build & verify), but assume Rob will reload and report errors.
- **Git & CurseForge are Rob's job.** Provide the exact commands + checklist, but do not push releases or trigger uploads unless Rob explicitly says to run them. (In Claude Code you *can* run git with permission — still confirm with Rob before commit/push/tag on a release.)
- **Version bumps & releases only when Rob says "af"/"go".** Don't bump the version or write release docs pre-emptively.
- **Big releases: consider Beta-first on CurseForge** (Cisca-test) before Release — Rob decides.

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
  naar de scratchpad en draai het als `python <pad>`. Dat pad staat in de allowlist.
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

## Build & verify

- **Syntax check Lua** before handing off. If `luacheck` or `luac` is available, use it; otherwise a Lua parser. Rob's `/reload` is the final word.
- **Package for CurseForge:** `powershell -ExecutionPolicy Bypass -File tools\package.ps1` → `dist\MidnightHelper-<version>.zip` (reads version from the `.toc`). The script **fails the build** if any `.bat`/`.cmd`/`.ps1`/`.py`/`.exe` slips into the zip. Zip root must be exactly `MidnightHelper/`; `tools/`, `data/`, `docs/` and dev markdown are excluded.
- See `RELEASE_CHECKLIST.md` for the full release flow.
- ⚠️ **The repo IS the live AddOns folder.** There is no sync script and no staging copy — every
  edit lands in Rob's running game immediately. (This file used to claim they were separate; that
  was wrong, and the mistake below is what it cost.)
- ⚠️ **Write files ATOMICALLY.** A plain `open(path, "w")` truncates first and writes after, so
  there is a window where the file on disk is empty or half-finished. On 2026-07-22 Rob logged in
  during exactly that window while `Locales/enUS.lua` was being rewritten: the locale table broke
  off mid-file and his Great Vault popup rendered raw keys (`VAULT_REMINDER_POPUP_TITLE`). Nothing
  was wrong with the addon. Always write to a temp file and rename — `os.replace` is atomic, so the
  game sees either the old file or the new one, never something in between:
  ```python
  io.open(p + ".tmp", "w", encoding="utf-8", newline="").write(t)
  os.replace(p + ".tmp", p)
  ```
  The Write/Edit tools are fine; this applies to scripted rewrites.

## 🔴 Bouw je iets dat kan zwijgen, bouw dan een manier om te zien dát het zweeg

Uit Spec 30, en op 26 aug 2026 duur betaald. Deze addon staat vol met *"zwijg als je het
niet zeker weet"* — `issecretvalue`-guards in 36 bestanden, `ns.Aura` waar `nil`
**onleesbaar** betekent en niet **afwezig**, en de regel dat een lege API-uitkomst niets
bewijst. Dat is goed ontwerp, maar het maakt **stilte de normale uitkomst**, en van
buitenaf is correct zwijgen niet te onderscheiden van kapot zijn.

Elke module waarvan de normale uitkomst "niets doen" is, krijgt daarom een
`/mh <ding>`-diagnose die **de beslissing én de reden** print, en waar iets zichtbaars
hoort te gebeuren een manier om dat te tonen zonder op de echte trigger te wachten.
Verplicht als de trigger niet op afroep is, als het gedrag in combat anders is, of als de
toestand niet te reproduceren is.

- **Precedenten die zich al terugbetaald hebben:** `/mh arrow` (standing down on purpose
  en echt kapot zien er van buiten identiek uit), `/mh glow`, `/mh dispeltest`.
- ⚠️ **De test moet door dezelfde deur als het spel.** Geen `if testMode`-takken in het
  echte pad; `ns.FireAccessibleAlert` bestaat zodat de test dezelfde cooldown krijgt. Een
  test die de gap overslaat, slaagt juist op de build waar de dubbel-alarm-bug in zit.
- ⚠️ **En verzin geen toestand die de client zelf maakt.** Een secret value kun je in Lua
  niet nabouwen; `/mh dispeltest` zégt dat dus, in plaats van een nep-secret te testen die
  zich anders gedraagt.
- 📌 **Niet met terugwerkende kracht op alles** — wel bij nieuwe modules, en bij bestaande
  zodra je ze toch aanraakt.

## Layout

- `MidnightHelper.toc` — load order + metadata (`## Version`, `## Interface 120007`). Adding a module = add its file here.
- `Core.lua`, `UI.lua`, `Config.lua` — bootstrap, main window, config.
- `Modules/` — one file per feature (e.g. `NativeArrow.lua`, `MissingBuff.lua`, `Openables.lua`, `FastMark.lua`, `KeyboardLayoutPrototype.lua`, `KeybindAutoMap.lua`, `KeybindRoles_*.lua`, `Achievements.lua`, `Delves.lua`, `Changelog.lua`, `SettingsPage.lua`).
- `Locales/` — one pack per language + the resolver + a fill-file (see Localization).
- `docs/` — dev notes, per-release CurseForge notes (`CURSEFORGE_<version>.md`), plans, handoffs. `docs/NEXT_SESSION.md` is the running state/handoff log — read it for current context.

## Key systems & conventions

### Localization (`ns:L`)
- `ns:L(key)` resolves against the active pack and **falls back to `enUS`** if a key is missing — so a missing translation shows English, never a raw key. Nothing is "broken" if only `enUS` has a key.
- Language packs: `Locales/<code>.lua` (`enUS`, `deDE`, `frFR`, `esES`, `ptBR`, `itIT`, `nlNL`) register into `ns._mhLocales[code]`. Settings-page strings live in `Locales/SettingsPage.lua`.
- `Locales/Translations2026.lua` is a **fill-only merge** (`fill(code, patch)` sets a key only if the pack lacks it) that adds post-2025 translations for **de/fr/es/pt/it**. Add new translations here — it never overwrites existing ones.
- **Workflow for a new user-facing string:** add it to `enUS.lua` (and `nlNL.lua`), then add translations to the other 5 via `Translations2026.lua`. `nlNL` is manual-only (never auto-selected). `CHANGELOG_*` keys stay **English** on purpose (fallback).
- **What never gets translated.** The rules existed but were scattered across four file headers; collected here 14 aug 2026 because they are easy to break and nothing checks them.
  - **Proper nouns Blizzard owns:** zone, NPC, rare, mount, item and **currency names**, quest titles, and **achievement names**. Translating an achievement title invents a name Blizzard did not use, and the player's own Achievements pane will disagree with us (`Translations2026.lua:2289`). Same for `Corrosive Coin`/`Corrosive Soul`: the name is English in every pack, the sentence around it is not.
  - **Game terms:** Mythic+, PvP, Raid, Renown, Knowledge Points/KP, Delves, Vault, Bountiful, Tier, ilvl, Keys, Shards — WoW UI spelling, all packs (`nlNL.lua:5`, `Translations2026.lua:312`).
  - **`CHANGELOG_*`** — English everywhere, on purpose.
  - **Markup:** `%s`/`%d`/`%%`, `|cff…|r` pairs around the same words, `|n` where the layout needs it, and the `->` arrow in menu paths (`docs/TRANSLATE_START_HERE.md`).
  - 🔴 **The test is "what does THIS player's client show", not "is this word translatable".**
    Rob, 28 aug 2026, after checking crests with Carola: she did not recognise "Kampioen
    crest" as the *Champion Crest* on her screen. **There is no Dutch WoW client**, so a
    Dutch player always sees Blizzard's English terms — translating one in `nlNL` names a
    thing that exists on no screen anywhere. German and French are real client languages, so
    translating there can be right. **One language translating a term says nothing about
    another.** Measured that day: `DAWNCREST_TIER_CHAMPION` is "Champion" in de/fr/it but
    "Kampioen"/"Campeón"/"Campeão" in nl/es/pt, with nobody having decided that on purpose.
  - ⚠️ **The article around an English name follows the language, not the name.** The packs write "der Coiled Isle", "la Coiled Isle", "na Coiled Isle", "de Coiled Isle" — the English "The" is dropped. On 14 aug the new Codex bodies shipped "auf The Coiled Isle" in six languages while the same feature's dashboard strings, two files away, already said "auf der Coiled Isle". Check the habit with a grep before inventing one.
  - ⚠️ **And "currency" itself is not settled by rule but by pack.** `itIT` and `nlNL` keep the English word (12 and 10 uses in `Codex.lua`); de/fr/es/pt translate it (14 each). Grep the pack before writing the sentence.
- 🔴 **Na ELKE correctie aan een enUS-string: `python tools/check_drift.py`.** De vijf packs blijven dan de oude bewering doen — `ns:L` valt alleen terug op enUS als een key *ontbreekt*, niet als hij aanwezig is. Op 26 aug stonden zo 7 keys los, waaronder `VALEERA_RUN_FMT`, dat in vijf talen nog steeds de claim droeg die we op 20 aug juist hadden ingetrokken.
  - 🔴 **WIJ VERTALEN ZELF. "Naar #translations" was een dood spoor** (Rob, 30 aug 2026: *"er is nog helemaal niemand op Discord"*). Die regel stond hier maandenlang en betekende in de praktijk "wordt nooit gerepareerd" — een verouderde vertaling die iets onwaars beweert is erger dan een zorgvuldige die we zelf maken. Dus: drift zelf wegwerken, mét de regels hieronder (markup, eigennamen, `KEEP_ENGLISH`), en drift níét met `fill()` dichtplakken.
  - ⚠️ **Zeg wél welke van ons zijn.** Een zelfgemaakte vertaling is niet nagekeken door een moedertaalspreker. Verschijnt er ooit iemand, dan moet die weten waar hij moet kijken; noteer het in de commit en in `docs/TRANSLATION_DRIFT.md`'s opvolger, niet in het pack zelf.
  - ⚠️ **En de checker meet HERKOMST, niet inhoud.** Gemeten 30 aug: van 11 gedrifte keys waren er **5 loos alarm** — `VALEERA_RUN_FMT`/`_NONE` zeggen "kills included" al in alle zes de talen, `SET_CONSREADY_TOGGLE_TITLE` klopt, `CURIO_NO_TEXT` is andere woorden met dezelfde betekenis, en `DAWNCREST_TIER_ADVENTURER` was een mechanische splitsing. Lees de tabel vóór je iets herschrijft; "gedrift" betekent alleen dat het Engels sindsdien veranderd is.
- **Verify translations by running them, not by counting them.** `lua5.1 tools/locale_probe.lua KEY [KEY …]` loads `Locales/` in `.toc` order and prints, per language, what `ns:L` resolves — OK / "still English" / nil. It runs the whole load **once per language** because the packs are locale-gated (`if GetLocale() ~= "deDE" then return end`), so one pass only ever builds enUS + nlNL.

### Route arrow / navigation (`Modules/NativeArrow.lua`)
- A shared on-screen arrow + Blizzard user-waypoint driver for every route type.
- **Ownership convention:** a route claims the arrow with `ns._mhRouteOwner = "<type>"` (`rare`/`treasure`/`achievement`/`reset`) and sets it to `nil` **only when the route is truly finished — never on a zone change**.
- **Never couple arrow lifetime to `ns.lastTarget` alone** — several modules nil `ns.lastTarget` in zone handlers, which used to kill the arrow. NativeArrow caches its own `activeLead` and keys off the stable `_mhRouteOwner`. Modules that nil `ns.lastTarget` expose `ns.GetNearestIncomplete<X>Lead()` for the arrow to follow.
- Per-content icon/colour comes from an `OWNER_STYLE` table. If **TomTom** is driving, our arrow stays idle — its crazy arrow is the same kind of thing as ours. Otherwise **we draw**, including alongside WaypointUI.
- ⚠️ **Changed 5 Aug 2026.** We used to stand down for **WaypointUI** too, which quietly cancelled the route arrow for everyone who has that addon — most of Rob's testers. `/mh arrow` on his own machine, with TomTom off, read "wij sturen: ja / onze pijl getekend: nee". A feature a release announced and that silently never appears is worse than two indicators, and the two are not even the same: WaypointUI draws a pin at a place, ours gives a direction, a distance and the next stop's name. Restore the old behaviour per player with `/mh arrow yield`.
- ⚠️ **Do not hang information on the arrow's label.** Fixed 19 Aug 2026, and it is the same
  mistake as the WaypointUI one above wearing a different hat. The rare arrival hints ("this one
  roams", "comes out of a chest") were written onto the arrow's label — invisible to Rob, because
  he runs TomTom and we stand down for it, and invisible to every other TomTom user with him. The
  arrow is a place we *sometimes* own; a sentence the player needs is not conditional on that.
  Say it in chat (`ns.StartRareArrivalWatch` in `Rares.lua`), where no other addon can take it away.
- **`/mh arrow`** prints who is driving and whether a route ever published a target. Use it before debugging a "the arrow does not work" report: standing down on purpose and being genuinely broken look identical from outside.

### Secure frames (WoW 12.x — read before touching markers/casting UI)
- Since patch 12.0, `SetRaidTarget` and `PlaceRaidMarker` are **protected**. Set raid target icons via a secure button `type="macro"`, `macrotext="/tm N"` (N=1–8, 0=clear); world markers via `type="worldmarker"`, `marker=N`, `action="set"/"clear"`. (See `FastMark.lua`.)
- A `SecureActionButtonTemplate` can only be re-anchored to its own parent or `UIParent`. A frame that **parents** a secure button (or is anchored-to by one) becomes **protected** and cannot be re-anchored/shown/hidden **in combat**; protection propagates up the parent chain.
- The clickable-in-combat pattern (see `MissingBuff.lua`): a separate non-secure visual frame stays visible; a secure button parented to `UIParent`, positioned independently out of combat, with `RegisterStateDriver(btn, "visibility", "[combat] hide; nil")`, strata `DIALOG`, `RegisterForClicks("AnyUp","AnyDown")`, and **cast by spell-ID** (names break on renamed pets).
- Draggable bars that parent secure buttons: only move/show/hide them **out of combat** (guard with `InCombatLockdown()`; defer to `PLAYER_REGEN_ENABLED`).

### 12.x "secret values"
- Other units' aura `spellId`/tooltip `leftText` can be secret. Guard with `issecretvalue()` before comparing/using.

### In-game changelog
- `Modules/Changelog.lua` holds `CHANGELOG_ENTRIES` (newest first: `{ version = "x.y.z", lines = { "CHANGELOG_XYZ_1", ... } }`), with the line texts as `CHANGELOG_<ver>_N` keys in `enUS.lua` (English only).

### Release artifacts (keep in sync on a version bump)
- `MidnightHelper.toc` `## Version`
- `Modules/Changelog.lua` + `CHANGELOG_<ver>_*` in `enUS.lua` (**enUS only** — the in-game changelog has been English-only since 2.4.0)
- `RELEASE_NOTES.md` (repo root) — **the CurseForge release notes**. The packager uploads it *verbatim* (`.pkgmeta` → `manual-changelog`, `markup-type: markdown`), so it must hold **only the current release**, pure Markdown starting with a plain `# heading`, and stay identical to `docs/CURSEFORGE_<ver>.md`.
  - ✅ **THE LENGTH RULE IS DEAD — SETTLED 20 Aug 2026. Write what needs saying.** For months the auto-upload arrived backslash-escaped with its newlines collapsed (`\## Know your role`), and from 2.8.2 onward we responded by keeping the file "under ~40 lines and without bullet lists". Nine clean uploads followed. **The rule deserved none of the credit.** See the settlement below the table; the table stays as history, not as a constraint.

    | Release | Lines | Chars | Bullets | Auto-upload |
    |---|---|---|---|---|
    | 2.8.2 | 65 | 3164 | 9 | ❌ mangled |
    | 2.8.3 | 30 | 1433 | 1 | ✅ clean |
    | 2.8.4 | 55 | 2775 | 6 | ❌ mangled |
    | 2.9.0 | 38 | 1785 | 0 | ✅ clean |
    | 2.11.1 | 22 | 1110 | 0 | ✅ clean |
    | 2.12.0 | 37 | 1652 | 0 | ✅ clean |
    | 2.13.0 | 39 | 1937 | 0 | ✅ clean |
    | 2.14.0 | 40 | 1936 | 0 | ✅ clean |
    | 3.2.0 | 27 | 2341 | 0 | ✅ clean (twice) |
    | **3.3.0** | **58** | **4568** | **9** | ✅ **clean — the experiment** |

    ✅ **SETTLED 20 Aug 2026, by deliberately breaking the rule.** 3.3.0 went up at **58 lines, 4568 characters and 9 bullet points** — larger on every axis than both mangled releases — and rendered perfectly. Rob confirmed it in two screenshots: the `# Midnight Helper 3.3.0` heading clean with no backslash, paragraphs intact, and the four-item list under "Three slots that could never get advice" rendering as a real bulleted list. **Length, character count and bullets are all cleared.** Write the release notes the length the release deserves.

    **Why the rule looked true for nine releases, and why that was a trap.** The last mangled upload was 20 Jul 2026. From 2.9.0 on we wrote short, and every upload was clean — but `.github/workflows/release.yml` pins `BigWigsMods/packager@v2`, a *floating* tag whose code can change under us silently, and the fault was always in the upload path rather than the file (Rob's hand-paste of the identical source always rendered fine). So two explanations fit all nine data points equally: our rule worked, or the packager was fixed upstream in July and our rule had been doing nothing since. **Being careful can never distinguish those.** Only a deliberate violation can, and Rob was the one who asked for it — "misschien was er toen wel wat anders fout, toch?"

    🔴 **Two claims here were also simply false, and were restated as fact every release.** They said no clean upload had ever carried a bullet. Counted from the archived files (`grep -c "^[-*] " docs/CURSEFORGE_*.md`) rather than from the summary: **2.8.3 uploaded clean with one bullet**, and it is in the table directly above the sentence that denied it. Lesson worth keeping past this section: a summary written beside its own evidence still needs checking against that evidence.

    ⚠️ **What is still true.** `RELEASE_NOTES.md` holds **only the current release**, is pure Markdown starting with a plain `# heading`, and stays byte-identical to `docs/CURSEFORGE_<ver>.md` (`diff` them before committing). And if a release ever arrives mangled again, that is *new* information about the packager — record the exact shape, do not quietly reintroduce a length limit.
  - **Earlier theories, all DISPROVEN — do not revive them.** HTML in the file (2.7.0), then a leading `<!-- HTML comment -->` (2.8.0), then "pure Markdown fixes it" (2.8.1, still mangled at 60+ lines). Rob also pasted the *identical* source into CF's own editor and it rendered perfectly, which puts the fault in the upload path, not the file's contents.
  - If a release ever arrives wrong again: CF page → the file → Changelog → Markdown mode → paste `docs/CURSEFORGE_<ver>.md`. That fallback costs Rob two minutes and is the reason the 3.3.0 experiment was safe to run at all.
- `CHANGELOG.md` (full history)
- `docs/CURSEFORGE_<ver>.md` (per-version Markdown archive, paste-ready if the CF page needs fixing by hand)
- `CURSEFORGE_DESCRIPTION.md` (repo root — the **canonical** CF page description; there is only this one). The packager does **not** upload this; Rob pastes it.

Full procedure: `docs/RELEASE_CHECKLIST.md`.

## Gotchas

- Some older files use **CRLF** line endings; keep them consistent when editing.
- Match the existing indentation style (tabs) in Lua files.
- Don't reintroduce library dependencies that were deliberately removed (e.g. borrowed `HereBeDragons`); prefer the game's own `C_Map` world coordinates.
