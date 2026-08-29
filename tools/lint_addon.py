#!/usr/bin/env python3
"""
Midnight Helper — addon data-integrity linter (Design Spec 06).

Catches the bug classes the changelog keeps showing — missing/typo'd locale
keys, unregistered files, duplicate keys, tabs that fall out of the search
index — BEFORE they ship. It touches no game data; it only guards that what the
code *names* actually *exists* (never-lie: no silently-broken displays).

Report-first, no auto-fix. HARD checks fail the build (exit 1); SOFT checks only
inform (locale parity, since EN fallback is by design).

Pure stdlib, regex-based (like the repo's other tools — no Lua runtime).

Usage:
    python tools/lint_addon.py                 # run all checks
    python tools/lint_addon.py --parity        # also print the full parity table
    python tools/lint_addon.py --dump-keys L   # print every defined key for locale L
"""

from __future__ import annotations

import os
import glob
import re
import sys

# ⚠️ Force UTF-8 out, so the caller never needs `python -X utf8 ...`.
#
# Every permission rule in .claude/settings.json matches a command STRING. Adding a
# flag makes a different string, so a rule written for the bare call cannot match it
# and Rob gets a prompt. On 11 Aug the report's `·` separators came out as `Â·` on his
# console, I reached for `-X utf8`, and that one extra flag was enough. The fix belongs
# in the script: the command line stays one fixed, matchable string.
for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

LOCALES = ["enUS", "deDE", "frFR", "esES", "ptBR", "itIT", "nlNL"]
LOCALE_FILE_RE = re.compile(r"^(deDE|frFR|esES|ptBR|itIT|nlNL)\.lua$")

# A defined key: `KEY =` or `["KEY"] =` at (mostly) top-level of a locale table.
KEY_BARE_RE = re.compile(r'^\s*([A-Z][A-Z0-9_]+)\s*=')
KEY_BRACKET_RE = re.compile(r'^\s*\[\s*"([A-Z][A-Z0-9_]+)"\s*\]\s*=')
# Inline batch style: `deDE.KEY = "..."` possibly several per line (semicolons).
KEY_DOTTED_RE = re.compile(r'\b(?:deDE|frFR|esES|ptBR|itIT|nlNL|enUS)\.([A-Z][A-Z0-9_]+)\s*=')

# Context switches inside multi-locale files.
CTX_MERGE_RE = re.compile(r'merge\(\s*ns\._mhLocales(?:\s+and\s+ns\._mhLocales)?\.(\w+)\s*,')
CTX_FILL_RE = re.compile(r'fill\(\s*"(\w+)"\s*,')
CTX_ENUS_TABLE_RE = re.compile(r'ns\._mhLocales\.enUS\s*=\s*\{')
CTX_DOTTED_LOCAL_RE = re.compile(r'local\s+(\w+)\s*=\s*ns\._mhLocales\.(\w+)\s+or')

# References.
REF_RE = re.compile(r'(?:ns:L|[^A-Za-z0-9_]VL)\(\s*(["\'])([A-Z][A-Z0-9_]+)\1')
# Dynamic reference we cannot statically resolve, e.g. ns:L("PRE_"..x).
REF_DYNAMIC_RE = re.compile(r'(?:ns:L|[^A-Za-z0-9_]VL)\(\s*["\'][A-Z0-9_]*["\']?\s*\.\.')
# Several files alias the resolver to a bare local -- `local function L(key)` in
# NavSearch, `local L = ...` elsewhere -- then call L("SOME_KEY"). Those calls never
# matched REF_RE, leaving 39 key references across six files unchecked. Found on
# 2026-07-22 while adding the side panels to the search index: four brand-new
# undefined keys went in and this check still reported zero missing. Nothing was
# broken at the time, but an undefined key renders as a raw key name on screen,
# which is the exact failure check [1] exists to catch.
"""Aliases the resolver is wrapped in, per file.

`L` and `SL` are locally-defined shorthands for ns:L / ns:SafeL. Neither matched
REF_RE, so their key references were never validated: 39 behind L(), 68 behind
SL(). Found on 2026-07-22 -- four brand-new undefined keys were added to
NavSearch and this check still reported zero missing. Nothing was broken at the
time, but an undefined key renders as a raw key name on screen, which is the
exact failure check [1] exists to catch.

Only trusted in a file that defines the alias itself, so an unrelated function
of the same name elsewhere cannot invent references.
"""
ALIAS_DEF_RE = re.compile(r'^\s*local (?:function )?(S?L)\b', re.M)
ALIAS_REF_RE = re.compile(r'(?<![\w.:])(S?L)\(\s*(["\'])([A-Z][A-Z0-9_]+)\2')


def repo_root() -> str:
    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def read_lines(path: str) -> list[str]:
    with open(path, "r", encoding="utf-8", errors="replace") as fh:
        return fh.read().splitlines()


def locale_files(root: str) -> list[str]:
    d = os.path.join(root, "Locales")
    return [os.path.join(d, f) for f in sorted(os.listdir(d)) if f.endswith(".lua")]


def collect_locale_keys(paths: list[str]):
    """Return defined[locale] -> {key: [(relpath, lineno), ...]}."""
    root = repo_root()
    defined = {loc: {} for loc in LOCALES}

    def add(loc, key, rel, ln):
        if loc not in defined:
            return
        defined[loc].setdefault(key, []).append((rel, ln))

    for path in paths:
        base = os.path.basename(path)
        try:
            rel = os.path.relpath(path, root).replace("\\", "/")
        except ValueError:
            rel = base  # external file on another drive
        if rel.startswith(".."):
            rel = base
        lines = read_lines(path)

        file_locale = None
        m = LOCALE_FILE_RE.match(base)
        if m:
            file_locale = m.group(1)  # whole-file context: this locale's OVERRIDES
        is_enus_file = base == "enUS.lua"

        ctx = file_locale or ("enUS" if is_enus_file else None)
        for i, line in enumerate(lines, 1):
            # context switches (multi-locale files)
            cm = CTX_MERGE_RE.search(line)
            if cm:
                ctx = cm.group(1)
            cf = CTX_FILL_RE.search(line)
            if cf:
                ctx = cf.group(1)
            if CTX_ENUS_TABLE_RE.search(line):
                ctx = "enUS"
            cl = CTX_DOTTED_LOCAL_RE.search(line)
            if cl:
                ctx = cl.group(2)

            # dotted inline assignments carry their own locale
            for dm in KEY_DOTTED_RE.finditer(line):
                # locale prefix is captured group-less; re-extract prefix
                pref = re.match(r'\s*.*?\b(deDE|frFR|esES|ptBR|itIT|nlNL|enUS)\.', line)
                if pref:
                    add(pref.group(1), dm.group(1), rel, i)

            if ctx is None:
                continue
            kb = KEY_BARE_RE.match(line)
            if kb:
                add(ctx, kb.group(1), rel, i)
                continue
            kk = KEY_BRACKET_RE.match(line)
            if kk:
                add(ctx, kk.group(1), rel, i)

    return defined


def collect_references(root: str):
    """Return (static_refs: {key: [(rel,line)]}, dynamic_count, ref_files)."""
    static = {}
    dynamic = 0
    targets = []
    for name in ("UI.lua", "Core.lua"):
        p = os.path.join(root, name)
        if os.path.isfile(p):
            targets.append(p)
    moddir = os.path.join(root, "Modules")
    if os.path.isdir(moddir):
        for f in sorted(os.listdir(moddir)):
            if f.endswith(".lua"):
                targets.append(os.path.join(moddir, f))
    for p in targets:
        rel = os.path.relpath(p, root).replace("\\", "/")
        lines = read_lines(p)
        aliases = set(ALIAS_DEF_RE.findall("\n".join(lines)))
        for i, line in enumerate(lines, 1):
            for m in REF_RE.finditer(line):
                # a literal followed by `..` is a dynamic key prefix, not a key
                if line[m.end():].lstrip().startswith(".."):
                    dynamic += 1
                    continue
                static.setdefault(m.group(2), []).append((rel, i))
            if aliases:
                for m in ALIAS_REF_RE.finditer(line):
                    if m.group(1) not in aliases:
                        continue  # this file does not define that alias
                    if line[m.end():].lstrip().startswith(".."):
                        dynamic += 1
                        continue
                    static.setdefault(m.group(3), []).append((rel, i))
    return static, dynamic


def parse_toc(root: str) -> set[str]:
    toc = os.path.join(root, "MidnightHelper.toc")
    files = set()
    for line in read_lines(toc):
        s = line.strip()
        if s.lower().endswith(".lua") and not s.startswith("#"):
            files.add(s.replace("\\", "/"))
    return files


# Generated knowledge data (RFC-002) is written to Modules/ but is deliberately NOT in the
# .toc while the feature is being built: it is compiled and tested, and nothing reaches a
# player yet. Skipping the .toc check needs BOTH signals below, so a hand-written file can
# never drift out of the .toc unnoticed by leaning on this exemption.
#
# GENERATED DATA ONLY. This was briefly widened to cover hand-written runtime modules as
# well, which weakened the check and blocked the addon session with two HARD orphans. The
# right home for unfinished, unregistered runtime code is tools/, not an exemption here —
# tools/ is excluded from the release zip and needs no .toc entry at all. Do not widen this
# again: if a Lua file belongs in Modules/, it belongs in the .toc.
PENDING_TOC_PREFIX = "Modules/KnowledgeData_"
GENERATED_MARKER = "GENERATED FILE"


def _is_pending_generated(root: str, rel: str) -> bool:
    if not rel.startswith(PENDING_TOC_PREFIX):
        return False
    try:
        with open(os.path.join(root, rel), encoding="utf-8") as fh:
            head = fh.read(2000)
    except OSError:
        return False
    return GENERATED_MARKER in head


def find_orphans(root: str, toc_files: set[str]):
    """Returns (orphans, pending). Orphans are HARD. Pending files are reported as a SOFT
    note, so a deliberately unregistered file stays visible instead of silently exempt."""
    orphans, pending = [], []
    for sub in ("Modules", "Locales"):
        d = os.path.join(root, sub)
        if not os.path.isdir(d):
            continue
        for f in sorted(os.listdir(d)):
            if f.endswith(".lua"):
                rel = f"{sub}/{f}"
                if rel not in toc_files:
                    if _is_pending_generated(root, rel):
                        pending.append(rel)
                    else:
                        orphans.append(rel)
    return orphans, pending


def collect_indexed_tabs(root: str) -> set[str]:
    """Tab ids the search index can actually reach.

    The `tab()` helper is the common form, but entries needing a context hint call
    `add()` with a bare `OpenTab("id")` instead -- so count that too, or the check
    reports a tab as unreachable at the very moment it was made reachable."""
    p = os.path.join(root, "Modules", "NavSearch.lua")
    ids = set()
    if os.path.isfile(p):
        for line in read_lines(p):
            for m in re.finditer(r'\btab\(\s*"[^"]+"\s*,\s*"([^"]+)"'
                                 r'|\bOpenTab\(\s*"([a-z][a-z0-9_]*)"', line):
                ids.add(m.group(1) or m.group(2))
    return ids


def collect_selecttab_ids(root: str) -> dict:
    """Best-effort: tab ids the addon can navigate to.

    Originally only `SelectTab("id")`. That missed `profacademy`, which is reached
    through a `navTab` data field -- the profession course sat in the UI with no
    way to search for it until Rob went looking on 2026-07-22. Destinations are
    declared in data as often as they are called, so read both."""
    ids = {}
    targets = [os.path.join(root, n) for n in ("UI.lua", "Core.lua")]
    moddir = os.path.join(root, "Modules")
    if os.path.isdir(moddir):
        targets += [os.path.join(moddir, f) for f in os.listdir(moddir) if f.endswith(".lua")]
    for p in targets:
        if not os.path.isfile(p):
            continue
        rel = os.path.relpath(p, root).replace("\\", "/")
        for i, line in enumerate(read_lines(p), 1):
            for m in re.finditer(r'(?:SelectTab|OpenTab)\(\s*"([a-z][a-z0-9_]*)"'
                                 r'|navTab\s*=\s*"([a-z][a-z0-9_]*)"', line):
                ids.setdefault(m.group(1) or m.group(2), (rel, i))
    return ids


def find_undefined_ns_calls(root: str, toc_files: set[str]) -> list[tuple]:
    """`ns.Foo(...)` where ns.Foo is never defined anywhere.

    Every call site guards with `if ns.Foo then`, which is good practice and also
    the perfect hiding place: a function that was never written simply never runs,
    and the guard makes that look deliberate.

    FOUND 2026-07-22: the "Advice goal: Allround / Gold / Self-sufficient" buttons
    on the Professions overview called ns.MH_SetProfAdvisorGoal and
    ns.MH_GetProfAdvisorGoal. Neither exists. Three buttons with tooltips explaining
    what each one picks, and clicking them did nothing -- shipped that way, in front
    of the user, with no error anywhere.

    Definitions counted: `function ns.Foo`, `function ns:Foo`, and `ns.Foo = ...`.
    Calls inside comments are skipped, or the very comment explaining that a
    function does not exist would report it.
    """
    defined: set[str] = set()
    called: dict[str, tuple] = {}
    files = []
    for rel in sorted(toc_files):
        path = os.path.join(root, rel.replace("\\", os.sep))
        if path.endswith(".lua") and os.path.isfile(path):
            files.append(path)

    for p in files:
        text = "\n".join(read_lines(p))
        for m in re.finditer(r'function ns[.:](\w+)', text):
            defined.add(m.group(1))
        for m in re.finditer(r'^\s*ns\.(\w+)\s*=', text, re.M):
            defined.add(m.group(1))

    # --[[ ]] blocks must go too, keeping the line count intact so numbers stay
    # right. Without this the file-header comment explaining that a function does
    # NOT exist reports that very function -- which is exactly what happened on the
    # first run of this check.
    block_re = re.compile(r"--\[(=*)\[.*?\]\1\]", re.S)
    for p in files:
        rel = os.path.relpath(p, root).replace("\\", "/")
        text = "\n".join(read_lines(p))
        text = block_re.sub(lambda m: re.sub(r"[^\n]", " ", m.group(0)), text)
        for i, line in enumerate(text.split("\n"), 1):
            code = line.split("--", 1)[0] if not line.lstrip().startswith("--") else ""
            for m in re.finditer(r'(?<![\w.])ns[.:](\w+)\s*\(', code):
                called.setdefault(m.group(1), (rel, i))

    return [(name, where[0], where[1]) for name, where in sorted(called.items())
            if name not in defined]


def find_colon_call_on_dot_function(root: str, toc_files: set[str]) -> list[tuple]:
    """`ns:Foo(x)` where Foo is declared `function ns.Foo(param)`.

    Lua turns `ns:Foo(x)` into `ns.Foo(ns, x)`, so the FIRST parameter silently
    becomes the namespace table and every real argument shifts one place right.
    Valid syntax, no error, wrong values -- `luac -p` is happy.

    THIS COST TWO DAYS IN JULY 2026. `ns:QueueMidnightToast({...})` made spec = ns,
    so three different toasts queued an empty notification. While ApplyToastContent
    still had a hardcoded fallback title, that empty spec rendered as "Trovehunter
    Bounty detected!" -- in a follower dungeon, where no bounty exists. The hunt for
    the phantom sender never found it, because the sender looked correct at every
    call site. Found 2026-07-22 by reading the definition next to the call.

    Only definitions WITH parameters are reported. A zero-parameter function simply
    ignores the extra argument, so `ns:Foo()` on `function ns.Foo()` is harmless and
    there are 22 of those here -- flagging them would bury the six that matter.
    A name declared anywhere as `function ns:Foo` is exempt: it wants self.
    """
    dot: dict[str, tuple] = {}
    colon_defs: set[str] = set()
    files = []
    for rel in sorted(toc_files):
        path = os.path.join(root, rel.replace("\\", os.sep))
        if path.endswith(".lua") and os.path.isfile(path):
            files.append(path)
    for p in files:
        text = "\n".join(read_lines(p))
        for m in re.finditer(r'^\s*function ns\.(\w+)\s*\(([^)]*)\)', text, re.M):
            params = [x.strip() for x in m.group(2).split(",") if x.strip()]
            dot[m.group(1)] = (os.path.relpath(p, root).replace("\\", "/"), params)
        for m in re.finditer(r'^\s*function ns:(\w+)\s*\(', text, re.M):
            colon_defs.add(m.group(1))

    out = []
    for p in files:
        rel = os.path.relpath(p, root).replace("\\", "/")
        for i, line in enumerate(read_lines(p), 1):
            for m in re.finditer(r'(?<![\w.:])ns:(\w+)\s*\(', line):
                name = m.group(1)
                if name in colon_defs or name not in dot:
                    continue
                decl_file, params = dot[name]
                if not params:
                    continue  # extra arg is ignored; not a defect
                out.append((rel, i, name, params[0], decl_file))
    return out


def find_use_before_local(root: str, toc_files: set[str]) -> list[tuple]:
    """Calls to a `local function` BEFORE it is declared.

    Lua resolves an undeclared name as a GLOBAL, so calling a local function that
    is defined further down the same file is not a syntax error -- it is a nil
    call at runtime, and `luac -p` passes it happily. This bit us three times in
    one day (boss-window prompt, dispel section, Moxie probe); the last reached
    Rob as a live crash. HARD, because it always throws once that path runs.

    Forward declarations (`local foo` earlier, assigned later) are legitimate and
    are NOT flagged -- the name is already in scope by then.
    """
    hits = []
    def_re = re.compile(r"^[ \t]*local[ \t]+function[ \t]+([A-Za-z_]\w*)[ \t]*\(", re.M)
    fwd_re = re.compile(r"^[ \t]*local[ \t]+([A-Za-z_][\w, \t]*?)[ \t]*$", re.M)
    # ⚠️ TABLES ARE **NOT** COVERED, AND THAT WAS TRIED AND REVERTED ON 27 AUG 2026.
    #
    # The bug that prompted it: `local castLog = {}` sat beside the code that fills it,
    # ~100 lines below the diagnostic that reads it, so `#castLog` there was a global
    # lookup and /mh glow threw the moment Rob ran it. This check had caught a local
    # FUNCTION in the very same edit and walked straight past the table.
    #
    # Two attempts, both worse than the gap. Allowing indentation gave 2320 hits: with no
    # notion of scope, a `local value` inside one function matches `value(...)` inside
    # another, and every library lit up. Restricting to file scope still gave 70, because
    # short names (`f`, `icon`, `en`) exist BOTH at file scope and as an inner local, and
    # a regex cannot tell which one a given line means.
    #
    # Local functions are catchable because `local function Foo` is a distinctive,
    # rarely-shadowed shape. Values are not. Left uncovered deliberately rather than
    # shipping a check that cries wolf seventy times — that is how a linter stops being
    # read at all.
    block_re = re.compile(r"--\[(=*)\[.*?\]\1\]", re.S)

    def strip_block_comments(src: str) -> str:
        """Blank out --[[ ]] blocks, keeping line count so numbers stay right.

        Without this, prose mentioning a helper ("See inTrackedInstance().") in a
        file header reads as a call and reports a false positive.
        """
        def blank(m):
            return re.sub(r"[^\n]", " ", m.group(0))

        return block_re.sub(blank, src)
    for rel in sorted(toc_files):
        path = os.path.join(root, rel.replace("\\", os.sep))
        if not path.endswith(".lua") or not os.path.isfile(path):
            continue
        try:
            with open(path, encoding="utf-8", errors="replace") as fh:
                text = fh.read()
        except OSError:
            continue
        text = strip_block_comments(text)
        lines = text.splitlines()
        declared = {}  # name -> earliest line on which it is in scope
        for m in def_re.finditer(text):
            name = m.group(1)
            ln = text.count(chr(10), 0, m.start()) + 1
            if name not in declared or ln < declared[name]:
                declared[name] = ln
        for m in fwd_re.finditer(text):  # forward decls legitimise earlier use
            ln = text.count(chr(10), 0, m.start()) + 1
            for nm in m.group(1).replace(" ", "").replace(chr(9), "").split(","):
                if nm and (nm not in declared or ln < declared[nm]):
                    declared[nm] = ln
        for name, decl_ln in declared.items():
            call_re = re.compile(r"(?<![\w.:])" + re.escape(name) + r"[ \t]*\(")
            for cm in call_re.finditer(text):
                ln = text.count(chr(10), 0, cm.start()) + 1
                if ln >= decl_ln:
                    continue
                src = lines[ln - 1] if ln - 1 < len(lines) else ""
                if src.lstrip().startswith("--"):
                    continue
                hits.append((rel, ln, name, decl_ln))
    return hits


def find_broken_locale_strings(root: str) -> list[tuple]:
    """Locale entries whose quotes make Lua read something other than a string.

    HARD, and the most expensive bug this linter has ever missed. On 2026-07-21
    one line went in unescaped:

        TRACKCEIL_SEE_CODEX = "Codex > Professions > "%s" walks through ...",

    Lua reads that as a string, then `%` (modulo), then `s "..."` -- a CALL of the
    nil global `s`. Loading enUS.lua aborts on that line, so every key below it
    never registers and ns:L returns key names. Rob's entire interface rendered as
    MAIN_TITLE, TAB_SETTINGS and so on, and the addon was unusable for a day.

    Nothing caught it: it is valid Lua syntax, so `luac -p` passes, and the key
    itself exists so the missing-key check is happy too.

    Method: walk each table line the way Lua's parser would, consuming KEY = "value"
    pairs left to right. A line that stops matching before its end has a quote in
    the wrong place. Several pairs on one line are fine -- TranslationsS2.lua packs
    four language labels per line, and a naive quote count flags all of them.
    """
    # \x22 is the double quote; written as an escape so the pattern needs no juggling.
    pair_re = re.compile(r'\s*[A-Za-z_][A-Za-z0-9_]*\s*=\s*\x22(?:[^\x22\\]|\\.)*\x22\s*,?')
    entry_re = re.compile(r'^\s*[A-Za-z_][A-Za-z0-9_]*\s*=\s*\x22')
    block_re = re.compile(r"--\[\[.*?\]\]", re.S)

    hits = []
    for path in locale_files(root):
        try:
            with open(path, encoding="utf-8", errors="replace") as fh:
                text = fh.read()
        except OSError:
            continue
        # Blank block comments but keep line numbering intact.
        text = block_re.sub(lambda m: re.sub(r"[^\n]", " ", m.group(0)), text)
        rel = os.path.relpath(path, root)
        for lineno, raw in enumerate(text.split("\n"), 1):
            line = raw.rstrip()
            if not entry_re.match(line):
                continue  # not a table entry: code, comment or continuation
            pos = 0
            while pos < len(line):
                m = pair_re.match(line, pos)
                if not m or m.end() == pos:
                    break
                pos = m.end()
            if pos < len(line):
                hits.append((rel, lineno, line[pos:pos + 50]))
    return hits



def check_and_guard_truncation(root):
    """`local a, b = f and f()` — the guard silently throws away every return
    value but the first.

    Lua's `and`/`or` yield a single value, so guarding a multi-return call this
    way is a bug that cannot be seen by reading the line: the first variable is
    filled correctly and every later one is nil. On 17 Aug 2026 the Delve
    Coach's hazard heading read "(?)" for exactly this reason -- the zone name
    was the second return of three.

    Only flags calls with NO arguments, where `X and X()` is a pure existence
    guard. `f and f(x)` on a multi-assignment is the same trap, but the pattern
    is rarer and this stays a check with no false positives.
    """
    hits = []
    pat = re.compile(
        r'local\s+([A-Za-z_][\w]*\s*(?:,\s*[A-Za-z_][\w]*\s*)+)=\s*'
        r'([\w.:]+)\s+and\s+\2\(\s*\)')
    paths = [os.path.join(root, "Core.lua"), os.path.join(root, "UI.lua")]
    paths += sorted(glob.glob(os.path.join(root, "Modules", "*.lua")))
    for path in paths:
        if not os.path.exists(path):
            continue
        with open(path, "r", encoding="utf-8", errors="replace") as fh:
            text = fh.read()
        for n, line in enumerate(text.splitlines(), 1):
            m = pat.search(line)
            if m:
                names = [v.strip() for v in m.group(1).split(",") if v.strip()]
                hits.append((os.path.basename(path), n, m.group(2), len(names)))
    return hits


VALUE_BARE_RE = re.compile(r'^\s*([A-Z][A-Z0-9_]+)\s*=\s*\x22((?:[^\x22\\]|\\.)*)\x22')
VALUE_BRACKET_RE = re.compile(
    r'^\s*\[\s*\x22([A-Z][A-Z0-9_]+)\x22\s*\]\s*=\s*\x22((?:[^\x22\\]|\\.)*)\x22')

FORMAT_RE = re.compile(r"%(?:\d+\$)?[sdfg%]")
COLOUR_OPEN_RE = re.compile(r"\|c[0-9a-fA-F]{8}")
COLOUR_CLOSE_RE = re.compile(r"\|r")


# Fill-only merges: they set a key only where the pack has nothing of its own, or
# still carries a verbatim copy of the English. A key they define on top of such a
# copy is the merge working, not a clash -- see the header of Translations2026.lua.
FILL_FILES = {"Locales/Translations2026.lua", "Locales/TranslationsS2.lua"}


def value_at(root: str, rel: str, lineno: int):
    """The string a single-line `KEY = "value"` sets at rel:lineno, or None."""
    try:
        lines = read_lines(os.path.join(root, rel))
    except OSError:
        return None
    if not 1 <= lineno <= len(lines):
        return None
    hit = VALUE_BARE_RE.match(lines[lineno - 1]) or VALUE_BRACKET_RE.match(lines[lineno - 1])
    return hit.group(2) if hit else None


def collect_locale_values(root: str) -> dict:
    """defined[locale] -> {key: (value, rel, lineno)} for single-line entries.

    Deliberately simpler than collect_locale_keys: only entries whose whole
    `KEY = "value"` fits on one line are captured, because those are the ones a
    translator edits. A multi-line concatenation is skipped rather than guessed at.
    """
    values = {loc: {} for loc in LOCALES}
    for path in locale_files(root):
        base = os.path.basename(path)
        rel = os.path.relpath(path, root).replace("\\", "/")
        m = LOCALE_FILE_RE.match(base)
        ctx = m.group(1) if m else ("enUS" if base == "enUS.lua" else None)
        for i, line in enumerate(read_lines(path), 1):
            cm = CTX_MERGE_RE.search(line)
            if cm:
                ctx = cm.group(1)
            cf = CTX_FILL_RE.search(line)
            if cf:
                ctx = cf.group(1)
            if CTX_ENUS_TABLE_RE.search(line):
                ctx = "enUS"
            cl = CTX_DOTTED_LOCAL_RE.search(line)
            if cl:
                ctx = cl.group(2)
            if ctx not in values:
                continue
            hit = VALUE_BARE_RE.match(line) or VALUE_BRACKET_RE.match(line)
            if hit:
                values[ctx].setdefault(hit.group(1), (hit.group(2), rel, i))
    return values


def check_translation_markup(root):
    """[13] A translation that breaks its own formatting, or drops a name.

    Rob, 19 aug, on hearing that five languages sit at 82%: "moeten we niet meer
    vertalen??" The answer is yes, and the reason this check comes first is that
    2935 strings are about to be written that nobody in this project can read back.
    Neither Rob nor I can judge Portuguese prose. Both of the ways a translation
    genuinely BREAKS, as opposed to reading awkwardly, are mechanical:

      * Format specifiers. `%s` and `%d` are filled in by the code. Drop one and
        the sentence loses its number; add one and string.format throws. This is
        the same class of fault as the unescaped quote in check [7], which cost a
        day of Rob's interface rendering as raw key names.
      * Colour markup. `|cffffcc00...|r` must balance. An unclosed one bleeds its
        colour over everything printed after it.

    HARD, both of them, because they are not opinions.

    A third failure is real but softer: translating a proper noun Blizzard owns.
    "Corrosive Coin" rendered as "Korrosive Münze" cannot be found in the player's
    own game -- CLAUDE.md collects these rules and they were written by hand. It is
    SOFT because a legitimate translation may reword around a term, and a check
    that cries wolf gets switched off.
    """
    values = collect_locale_values(root)
    enus = values.get("enUS", {})

    # Names that must survive verbatim when enUS uses them.
    #
    # ⚠️ THIS LIST STARTED WRONG AND THE FIRST RUN PROVED IT. "Great Vault" and
    # "Midnight Helper" were in it and produced 215 warnings, every one of them
    # false: Blizzard localises the Great Vault itself (German players read "Große
    # Schatzkammer" in their own game, so translating it is CORRECT), and a title
    # need not repeat the addon's name. A check that shouts 215 times on its first
    # run is a check nobody will read twice.
    #
    # What is left are names Blizzard does NOT localise -- zone and currency names
    # that the player will search for verbatim in their own client. "Raid", "Vault"
    # and "Tier" are deliberately absent: they are ordinary words in five of these
    # languages.
    # ⚠️ "Coiled Isle" REMOVED 22 aug 2026, for exactly the reason Great Vault was
    # removed above: Blizzard localises it. Zone 16365 is Die Gewundene Insel /
    # Île Annelée / Isla Serpenteante / A Ilha Enrolada / Isola Serpeggiante, each
    # with its own page in Blizzard's own locale data. A German player searching
    # their map for "Coiled Isle" finds nothing, so keeping it English is the
    # failure this check exists to catch — the list had it backwards.
    #
    # The test for this list is not "is it a proper noun" but "does Blizzard leave
    # it in English". Zone names: localised. Currency names like Corrosive Coin:
    # not, verified across all seven packs. When in doubt, look it up per language
    # before adding a name here; a wrong entry teaches five translators to write
    # something the player cannot find.
    KEEP = [
        "Corrosive Coin", "Corrosive Soul", "Atal'Utek",
    ]

    hard, soft = [], []
    for loc in LOCALES:
        if loc == "enUS":
            continue
        for key, (val, rel, ln) in sorted(values[loc].items()):
            src = enus.get(key)
            if not src:
                continue
            en = src[0]
            if en == val:
                continue  # untranslated copy; check [5] already counts those

            if sorted(FORMAT_RE.findall(en)) != sorted(FORMAT_RE.findall(val)):
                hard.append((loc, key, rel, ln, "format specifiers differ from enUS"))

            # ⚠️ A DOUBLED BACKSLASH BEFORE n. Lua reads `\\n` as a literal backslash
            # followed by the letter n, so the player reads "\n" as text where a
            # paragraph break belongs. Found 19 Aug in 362 places across deDE, esES,
            # frFR and ptBR -- almost all of them in the Academy, which is the
            # teaching content this addon is built around. enUS, nlNL and itIT were
            # correct, so it was one generation run and not a convention.
            #
            # Checked against the string itself rather than against enUS: there is no
            # sentence in any language where a literal backslash-n is wanted.
            if "\\\\n" in val:
                hard.append((loc, key, rel, ln,
                             "\\\\n renders as literal text, not a line break"))

            # ⚠️ THREE backslashes before a quote, not two. 116 of these across the
            # same four packs, mostly the Academy's party-chat lines, where the
            # player read \"like this\" with the slashes showing.
            #
            # The count matters and is why this is measured rather than eyeballed:
            # the first repair attempt assumed two, removed one, left two, and every
            # quote then closed its own string. All four packs failed luac and had
            # to be reverted. Reading escaping off a rendered view is how that
            # happened; the fix came from counting the bytes.
            if ("\\" * 3 + '"') in val:
                hard.append((loc, key, rel, ln,
                             "three backslashes before a quote; one is an escape"))

            # ⚠️ Measured against enUS, NOT against zero. The first version demanded
            # that opens equal closes and immediately flagged six faithful
            # translations of FPS_HIGHER_IN_RAID -- whose ENGLISH original opens
            # three colours and closes two, on purpose, because |r resets to default
            # rather than to the previous colour. The translations were copying the
            # original correctly. What matters is whether a translation drifted from
            # its source, not whether the source suits a tidy rule.
            if (len(COLOUR_OPEN_RE.findall(val)) - len(COLOUR_CLOSE_RE.findall(val))
                    != len(COLOUR_OPEN_RE.findall(en)) - len(COLOUR_CLOSE_RE.findall(en))):
                hard.append((loc, key, rel, ln, "colour markup drifted from enUS"))

            for name in KEEP:
                if name in en and name not in val:
                    soft.append((loc, key, rel, ln, f'"{name}" was translated away'))
    return hard, soft


def check_command_list(root):
    """Commands shown to players in Modules/CommandList.lua that nothing routes.

    The list is a promise: it appears in the Tools room with a description, so an
    entry the addon no longer answers to is the same fault as the Alt+M line in
    the welcome popup -- telling someone to type something that does nothing.
    Verified against Core.lua and every module, because routing lives in both
    (/mh skip is in Achievements.lua, /mh items in DelveItemsPopup.lua).
    """
    src_path = os.path.join(root, "Modules", "CommandList.lua")
    if not os.path.exists(src_path):
        return []
    with open(src_path, "r", encoding="utf-8", errors="replace") as fh:
        src = fh.read()
    cmds = re.findall(r'cmd = "(/mh[^"]*)"', src)

    routes = ""
    for path in [os.path.join(root, "Core.lua")] + sorted(
            glob.glob(os.path.join(root, "Modules", "*.lua"))):
        if not os.path.isfile(path):
            continue
        with open(path, "r", encoding="utf-8", errors="replace") as fh:
            routes += fh.read()

    missing = []
    for full in cmds:
        arg = full[3:].strip()
        if not arg:
            continue                      # bare /mh opens the main window
        first = arg.split()[0]
        patterns = (
            'msg == "%s"' % arg, 'msg == "%s"' % first,
            'line == "%s"' % arg, 'line == "%s"' % first,
            'msg:match("^%s' % first,
        )
        if not any(p in routes for p in patterns):
            missing.append(full)
    return missing


def check_keybind_wish_conflicts(root):
    """Two spells in the same spec asking for the same key.

    `bindKey` is how the AoE twin rule is written down -- "Blizzard belongs on
    Shift+2 because Flurry is on 2". The allocator grants those wishes before
    anything else may take the key, so the only remaining way one can fail is
    two spells in one spec wanting the same key, which nothing can satisfy.

    Found by a throwaway harness on 7 Aug 2026: 8 such conflicts across 7 specs,
    including Warrior asking three separate spells to sit on Ctrl+F1. Nothing in
    the build noticed, and nothing would have. This is the check that means we
    never have to go looking for them again.

    An entry with no `specs` applies to every spec of its class, so it is
    compared against all of them.
    """
    out = []
    for path in sorted(glob.glob(os.path.join(root, "Modules", "KeybindRoles_*.lua"))):
        cls = os.path.basename(path)[len("KeybindRoles_"):-len(".lua")]
        with open(path, "r", encoding="utf-8", errors="replace") as fh:
            src = fh.read()

        # One entry per line, read line by line. A single regex over the whole file
        # cannot do this: the body itself contains braces (`specs = { 71, 72 }`), so
        # a non-greedy match stops at the FIRST closing brace and truncates the spec
        # list to nothing -- which is exactly how the first version of this check
        # reported zero conflicts while a harness was finding eight.
        entries = []          # (name, bindKey, [specs] or None)
        all_specs = set()
        for line in src.splitlines():
            m = re.match(r'\s*\["([^"]+)"\]\s*=\s*\{(.*)\}', line)
            if not m:
                continue
            name, body = m.group(1), m.group(2)
            specs_m = re.search(r'specs\s*=\s*\{([^}]*)\}', body)
            specs = None
            if specs_m:
                specs = [int(x) for x in re.findall(r'\d+', specs_m.group(1))]
                all_specs.update(specs)
            excl_m = re.search(r'excludes\s*=\s*"([^"]+)"', body)
            bind_m = re.search(r'bindKey\s*=\s*"([^"]+)"', body)
            if bind_m:
                entries.append((name, bind_m.group(1), specs, excl_m.group(1) if excl_m else None))

        for spec in sorted(all_specs):
            seen = {}
            excl = {}
            for name, key, specs, excludes in entries:
                if specs is None or spec in specs:
                    seen.setdefault(key, []).append(name)
                    if excludes:
                        excl[name] = excludes
            for key, names in sorted(seen.items()):
                if len(names) < 2:
                    continue
                # A pair that can never both be known may share a key. Two reasons
                # produce that, and `excludes` covers both: a real override (Death
                # Sweep IS Blade Dance under Metamorphosis) and a talent choice node
                # (Arms picks Bladestorm OR Ravager, never both). Neither shows up in
                # FindSpellOverrideByID as the same thing, but the consequence for a
                # keyboard layout is identical.
                remaining = []
                for n in sorted(names):
                    partner = excl.get(n)
                    if partner and partner in names:
                        continue      # declared mutually exclusive with someone here
                    remaining.append(n)
                if len(remaining) > 1:
                    out.append((cls, spec, key, remaining))
    return out

def check_emoji_in_strings(root):
    """[14] An emoji in a SHIPPED string, which WoW's font cannot draw.

    Caught on Rob's screen 25 aug 2026: the tier guide's two warning bullets rendered
    as two empty boxes, because the client has no glyph for U+26A0. In a Lua COMMENT
    the same character is harmless and this repo is full of them -- they never reach a
    screen. So the distinction this check makes is comment versus string, not
    file-by-file.

    Colour codes are the alternative that always works: |cffffd100Note:|r renders in
    every locale and needs no font support.

    ⚠️ THE FIRST VERSION FLAGGED 62 ARROWS. It matched every symbol block, which caught
    the "→" in Codex, DungeonGuide and RitualTips -- strings that have shipped for
    months and that Rob has never once reported as broken, because the arrow renders
    fine. A check that cries wolf 62 times is worse than no check: it teaches everyone
    to run past section [14].

    So the test is narrow and matches what actually fails. Emoji presentation is the
    problem: U+FE0F after a symbol (that is what makes ⚠️ an emoji rather than a plain
    warning sign), and the astral emoji planes. Plain arrows and typographic symbols
    stay legal.
    """
    hits = []
    loc = os.path.join(root, "Locales")
    if not os.path.isdir(loc):
        return hits
    bad = re.compile("[←-⯿]️"          # symbol + emoji selector
                     "|[\U0001F000-\U0001FAFF]")      # astral emoji
    for fn in sorted(os.listdir(loc)):
        if not fn.endswith(".lua"):
            continue
        with open(os.path.join(loc, fn), "r", encoding="utf-8",
                  errors="replace") as fh:
            for ln, line in enumerate(fh, 1):
                if line.lstrip().startswith("--"):
                    continue
                # Only the quoted VALUE, never the key or a trailing comment.
                m = re.match(r'\s*\[?"?([A-Za-z0-9_]+)"?\]?\s*=\s*"(.*)"\s*,?\s*$',
                             line)
                if not m:
                    continue
                found = bad.search(m.group(2))
                if found:
                    hits.append((os.path.join("Locales", fn), ln, m.group(1),
                                 found.group(0)))
    return hits


def check_keep_english(root):
    """[15] A key that must stay English, translated anyway.

    Locales/KeepEnglish.lua lists keys where Blizzard's own UI shows that exact string --
    achievement titles above all. Translating one invents a name the game never used, and
    the player's own Achievements pane then disagrees with us. The rule has been in
    CLAUDE.md since 14 aug 2026 and was broken in five of six packs on 29 aug, so writing
    it down again was never going to be enough.

    ⚠️ IT DID NOT SURVIVE BEING FOLLOWED, WHICH IS WHY THIS EXISTS. `fill()` replaces a
    value identical to enUS, because the packs copy every English string at load and a
    "is it nil" test could never fire. That rescued ~400 real translations per language --
    and it also means a key left in English ON PURPOSE looks exactly like a placeholder.
    itIT kept "Veteran of the Dawn" correctly and Translations2026 overwrote it. Intent
    had to become data; this is the half that catches the next lapse.

    Compares each pack's literal assignment against enUS. Anything that differs is a
    translation of a name Blizzard owns.
    """
    hits = []
    loc = os.path.join(root, "Locales")
    keep_path = os.path.join(loc, "KeepEnglish.lua")
    if not os.path.isfile(keep_path):
        return hits
    with open(keep_path, "r", encoding="utf-8", errors="replace") as fh:
        keep_src = fh.read()
    # Keys of ns.KEEP_ENGLISH: `KEY = "why",` inside the table, comments skipped.
    keep = set()
    for line in keep_src.splitlines():
        s = line.strip()
        if s.startswith("--"):
            continue
        m = re.match(r'([A-Z][A-Z0-9_]+)\s*=\s*"', s)
        if m:
            keep.add(m.group(1))
    if not keep:
        return hits

    def literals(fn):
        out = {}
        p = os.path.join(loc, fn)
        if not os.path.isfile(p):
            return out
        with open(p, "r", encoding="utf-8", errors="replace") as fh:
            for ln, line in enumerate(fh, 1):
                if line.lstrip().startswith("--"):
                    continue
                m = re.match(r'\s*\[?"?([A-Za-z0-9_]+)"?\]?\s*=\s*"((?:[^"\\]|\\.)*)"',
                             line)
                if m and m.group(1) in keep:
                    out.setdefault(m.group(1), []).append((ln, m.group(2)))
        return out

    english = {k: v[0][1] for k, v in literals("enUS.lua").items() if v}
    for fn in sorted(os.listdir(loc)):
        if not fn.endswith(".lua") or fn in ("enUS.lua", "KeepEnglish.lua"):
            continue
        for key, rows in literals(fn).items():
            want = english.get(key)
            if want is None:
                continue
            for ln, got in rows:
                if got != want:
                    hits.append((os.path.join("Locales", fn), ln, key, got, want))
    return hits


def main() -> int:
    root = repo_root()
    args = sys.argv[1:]
    lf = locale_files(root)
    defined = collect_locale_keys(lf)
    values = collect_locale_values(root)
    static_refs, dynamic = collect_references(root)
    toc_files = parse_toc(root)
    orphans, pending_toc = find_orphans(root, toc_files)

    if "--dump-keys" in args:
        loc = args[args.index("--dump-keys") + 1]
        for k in sorted(defined.get(loc, {})):
            print(k)
        return 0

    hard = 0
    soft = 0
    print("=" * 70)
    print("Midnight Helper — addon lint")
    print("=" * 70)

    # 1. Missing locale keys (HARD)
    enus = set(defined["enUS"])
    missing = sorted(k for k in static_refs if k not in enus)
    print(f"\n[1] Missing enUS keys (referenced by ns:L/VL but undefined): {len(missing)}")
    for k in missing[:60]:
        rel, ln = static_refs[k][0]
        print(f"    HARD  {k}   first ref {rel}:{ln}")
    if len(missing) > 60:
        print(f"    ... and {len(missing) - 60} more")
    hard += len(missing)
    print(f"    (statically checked {len(static_refs)} distinct keys; "
          f"{dynamic} dynamic refs skipped — blind spot, not checked)")

    # 2. Unregistered files (HARD)
    print(f"\n[2] Files not registered in .toc: {len(orphans)}")
    for o in orphans:
        print(f"    HARD  {o}")
    hard += len(orphans)
    for p in pending_toc:
        print(f"    SOFT  {p}   generated, not registered yet — deliberate (RFC-002)")
    soft += len(pending_toc)

    # 3. Duplicate keys within a locale (HARD)
    dup_total = 0
    fill_ok = 0
    dead_fill = 0
    print("\n[3] Duplicate keys within a locale (last-wins silent override):")
    for loc in LOCALES:
        dups = {k: v for k, v in defined[loc].items() if len(v) > 1}
        real, dead, benign = {}, {}, 0
        for k, sites in dups.items():
            fills = [s for s in sites if s[0] in FILL_FILES]
            owners = [s for s in sites if s[0] not in FILL_FILES]
            if len(fills) < 1 or len(owners) != 1:
                real[k] = sites          # two owners, or two fills: someone loses
                continue
            owner_value = value_at(root, owners[0][0], owners[0][1])
            en_value = (values.get("enUS", {}).get(k) or (None,))[0]
            if owner_value is not None and owner_value == en_value:
                benign += 1              # the fill replaces an English copy: by design
            else:
                dead[k] = sites          # the fill can never apply -- worse than a dup
        fill_ok += benign
        dead_fill += len(dead)
        dup_total += len(real) + len(dead)
        if real or dead or benign:
            parts = []
            if real:
                parts.append(f"{len(real)} duplicated")
            if dead:
                parts.append(f"{len(dead)} fill never applies")
            if benign:
                parts.append(f"{benign} fill over an English copy (by design)")
            print(f"    {loc}: " + ", ".join(parts))
            for k, sites in list(sorted(real.items()))[:12]:
                where = "  ".join(f"{r}:{n}" for r, n in sites)
                print(f"      HARD  {k}   {where}")
            for k, sites in list(sorted(dead.items()))[:12]:
                where = "  ".join(f"{r}:{n}" for r, n in sites)
                print(f"      HARD  {k}   the pack already translates this, so the "
                      f"fill is dead code   {where}")
    if dup_total == 0 and fill_ok == 0:
        print("    none")
    print(f"    (fill-only files: {', '.join(sorted(FILL_FILES))} — a key they set on top "
          f"of an English copy is the merge doing its job, not a duplicate)")
    hard += dup_total

    # 4. Search-index coverage (SOFT for now — best-effort)
    indexed = collect_indexed_tabs(root)
    seltabs = collect_selecttab_ids(root)
    not_indexed = sorted(t for t in seltabs if t not in indexed)
    print(f"\n[4] Tabs used via SelectTab but missing from NavSearch index: "
          f"{len(not_indexed)}  (SOFT/best-effort)")
    for t in not_indexed:
        rel, ln = seltabs[t]
        print(f"    warn  {t}   e.g. {rel}:{ln}")
    print(f"    (indexed tabs: {len(indexed)}; SelectTab ids seen: {len(seltabs)})")
    soft += len(not_indexed)

    # 5. Locale parity (SOFT — EN fallback is by design)
    print("\n[5] Locale parity (enUS keys without a native translation):")
    print(f"    enUS defines {len(enus)} keys")
    for loc in LOCALES:
        if loc == "enUS":
            continue
        gap = enus - set(defined[loc])
        pct = 100 * (len(enus) - len(gap)) / max(1, len(enus))
        print(f"    {loc}: {len(defined[loc]):5d} translated · "
              f"{len(gap):5d} still English · {pct:5.1f}% covered")
        soft += 0  # informational only
    if "--parity" in args:
        for loc in LOCALES:
            if loc == "enUS":
                continue
            gap = sorted(enus - set(defined[loc]))
            print(f"\n    --- {loc} missing {len(gap)} ---")
            for k in gap:
                print(f"      {k}")

    print("\n" + "=" * 70)

    # 6. Local function called before it is declared (HARD -- runtime nil call)
    ubl = find_use_before_local(root, toc_files)
    print(f"\n[6] Local function called before its declaration: {len(ubl)}")
    for rel, ln, name, decl in ubl[:40]:
        print(f"    HARD  {rel}:{ln}  calls {name}()  declared line {decl}")
    if len(ubl) > 40:
        print(f"    ... and {len(ubl) - 40} more")
    hard += len(ubl)

    # 7. Locale strings whose quoting changes what Lua reads (HARD -- kills the file)
    broken = find_broken_locale_strings(root)
    print(f"\n[7] Locale strings Lua would not read as intended: {len(broken)}")
    for rel, ln, rest in broken[:20]:
        print(f"    HARD  {rel}:{ln}  parsing stops at: {rest}")
    if len(broken) > 20:
        print(f"    ... and {len(broken) - 20} more")
    hard += len(broken)

    # 8. ns:Foo() on a dot-declared function (HARD -- silently shifts every argument)
    shifted = find_colon_call_on_dot_function(root, toc_files)
    print(f"\n[8] Colon call on a dot-declared ns function: {len(shifted)}")
    for rel, ln, name, first, decl in shifted[:20]:
        print(f"    HARD  {rel}:{ln}  ns:{name}(...) -> {first} becomes ns   ({decl})")
    if len(shifted) > 20:
        print(f"    ... and {len(shifted) - 20} more")
    hard += len(shifted)

    # 9. ns.Foo() called but never defined (HARD -- a dead control the user can click)
    undef = find_undefined_ns_calls(root, toc_files)
    print(f"\n[9] ns functions called but never defined: {len(undef)}")
    for name, rel, ln in undef[:20]:
        print(f"    HARD  ns.{name}()   {rel}:{ln}")
    if len(undef) > 20:
        print(f"    ... and {len(undef) - 20} more")
    hard += len(undef)

    # 10. Every command listed in Modules/CommandList.lua must actually be routed
    # (HARD -- the list is shown to players, so an entry that no longer works is
    # the addon telling someone to type something that does nothing). Added 6 Aug
    # 2026 with the list itself: three promises had to be corrected that week
    # because nothing checked them.
    listed = check_command_list(root)
    print(f"\n[10] Commands listed to players but not routed: {len(listed)}")
    for cmd in listed[:20]:
        print(f"    HARD  {cmd}   listed in Modules/CommandList.lua")
    hard += len(listed)

    # 11. Two spells in one spec asking for the same key (HARD since 7 Aug 2026).
    #
    # A throwaway harness found 8 of these across 7 specs that morning, including
    # Warrior asking three spells to sit on Ctrl+F1. Nothing in the build noticed.
    # It ran SOFT for exactly as long as it took to work out what each one was,
    # because this file cannot see the difference between a real clash and a
    # harmless one on its own.
    #
    # Now it can, and all eight are settled, so it fails the build:
    #   - Three were DEAD DATA. Carve went in 11.0.0, Butchery and Void Bolt in
    #     12.0.0, and four more Survival abilities with them. Two spells that do
    #     not exist were fighting over Shift+1.
    #   - Two pairs genuinely cannot coexist and now say so with `excludes`:
    #     Death Sweep IS Blade Dance under Metamorphosis, and Arms picks
    #     Bladestorm OR Ravager from one choice node.
    #   - Three were real and got real keys: Frostscythe moved off Howling
    #     Blast's Shift+1, Crash Lightning off Chain Lightning's, and the three
    #     Warrior cooldowns lost a wish for a key the standard reserves for the
    #     player's trinket anyway.
    #
    # So a hit here now means one of two things, and both deserve a stopped
    # build: a new clash, or a spell that stopped existing.
    conflicts = check_keybind_wish_conflicts(root)
    print(f"\n[11] Spells in one spec wanting the same key: {len(conflicts)}")
    for cls, spec, key, names in conflicts[:20]:
        print(f"    HARD  {cls} spec {spec}: {key} wanted by {', '.join(names)}")
    hard += len(conflicts)

    # [12] The guard that eats return values. Invisible by reading: the first
    # variable is right and the rest are nil, so the bug shows up as a "?" or a
    # missing label somewhere far from the line that caused it.
    trunc = check_and_guard_truncation(root)
    print(f"\n[12] Multi-assignment behind an `and` guard: {len(trunc)}")
    for fname, line, call, count in trunc[:20]:
        print(f"    HARD  {fname}:{line}  {call}() feeds {count} names, "
              f"but `and` returns only the first")
    hard += len(trunc)

    tm_hard, tm_soft = check_translation_markup(root)
    print(f"\n[13] Translations that break their own markup: {len(tm_hard)}")
    for loc, key, rel, ln, why in tm_hard[:20]:
        print(f"    HARD  {loc}  {key}   {rel}:{ln}  — {why}")
    hard += len(tm_hard)
    print(f"     proper nouns translated away: {len(tm_soft)}  (SOFT)")
    for loc, key, rel, ln, why in tm_soft[:12]:
        print(f"    warn  {loc}  {key}   {rel}:{ln}  — {why}")
    soft += len(tm_soft)

    emoji = check_emoji_in_strings(root)
    print(f"\n[14] Emoji inside a string the player sees: {len(emoji)}")
    for rel, ln, key, ch in emoji[:20]:
        print(f"    HARD  {rel}:{ln}  {key}  contains {ch!r} — WoW's font draws an empty box")
    hard += len(emoji)

    keepen = check_keep_english(root)
    print(f"\n[15] Keys that must stay English, translated anyway: {len(keepen)}")
    for rel, ln, key, got, want in keepen[:20]:
        print(f"    HARD  {rel}:{ln}  {key}  is {got!r} — Blizzard's own name is {want!r}")
    hard += len(keepen)

    print("=" * 70)
    print(f"HARD issues: {hard}   SOFT notes: {soft}")
    print("=" * 70)
    return 1 if hard else 0


if __name__ == "__main__":
    sys.exit(main())
