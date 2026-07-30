#!/usr/bin/env python3
"""Actually build the German pack the way the game does, and count what is German.

Rob cannot test this. deDE.lua returns immediately unless GetLocale() == "deDE",
so on his English client the pack is never built and the addon says so. That
leaves the fill() fix from 30 jul unverifiable in-game without him switching his
WoW client language, which is a multi-gigabyte download for a code change.

So run the real files instead. This drives a Lua interpreter over the actual
Locales/ in .toc order with GetLocale() stubbed to "deDE", then counts how many
keys hold something other than the English string. No simulation, no assumptions
about what the files contain -- the same code the client runs.

Usage: python tools/i18n_runtime_check.py [git-ref]
       (no ref = working tree; e.g. HEAD~1 to compare against before a change)
"""

import io
import os
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

HARNESS = r'''
-- Minimal stand-ins for the client APIs the locale files touch.
GetLocale = function() return "deDE" end
local function noop() end
C_Map = setmetatable({}, {__index = function() return noop end})
UnitClass = function() return "Warrior", "WARRIOR", 1 end
UnitFactionGroup = function() return "Alliance" end
_G = _G or {}

local ns = {}
local addonName = "MidnightHelper"

local files = FILELIST_TOKEN

local loadedCount, failedCount = 0, 0
for _, rel in ipairs(files) do
    local path = BASE .. "/" .. rel
    local chunk, err = loadfile(path)
    if not chunk then
        failedCount = failedCount + 1
        io.stderr:write("could not load " .. rel .. ": " .. tostring(err) .. "\n")
    else
        local ok, e = pcall(chunk, addonName, ns)
        if ok then
            loadedCount = loadedCount + 1
        else
            failedCount = failedCount + 1
            io.stderr:write("error running " .. rel .. ": " .. tostring(e) .. "\n")
        end
    end
end
print(string.format("locale files: %d loaded, %d failed", loadedCount, failedCount))

local packs = ns._mhLocales or {}
local en = packs.enUS
local de = packs.deDE
if type(en) ~= "table" then print("NO enUS PACK"); os.exit(1) end
if type(de) ~= "table" then print("NO deDE PACK"); os.exit(1) end

local total, german = 0, 0
for k, v in pairs(en) do
    if type(v) == "string" then
        total = total + 1
        local mine = de[k]
        if type(mine) == "string" and mine ~= v then german = german + 1 end
    end
end
print(string.format("enUS strings: %d", total))
print(string.format("actually German: %d  (%.1f%%)", german, german / total * 100))
'''


def toc_locale_files(base):
    out = []
    for line in (base / "MidnightHelper.toc").read_text(encoding="utf-8", errors="replace").splitlines():
        s = line.strip()
        if s.lower().startswith("locales\\") and s.lower().endswith(".lua"):
            out.append(s.replace("\\", "/"))
    return out


def main():
    ref = sys.argv[1] if len(sys.argv) > 1 else None
    if ref:
        base = Path(tempfile.mkdtemp(prefix="mh_i18n_"))
        subprocess.run(
            "git archive %s | tar -x -C %s" % (ref, base.as_posix()),
            shell=True, cwd=str(ROOT), check=True,
        )
        print("checked out %s into %s" % (ref, base))
    else:
        base = ROOT
        print("working tree")

    files = toc_locale_files(base)
    # Keep the braces: the placeholder is written {FILELIST} inside them in the
    # harness, so replacing the token alone would eat the table constructor and
    # leave `local files = "a", "b"` -- a string, which ipairs walks zero times.
    lua = HARNESS.replace(
        "FILELIST_TOKEN", "{" + ", ".join('"%s"' % f for f in files) + "}"
    ).replace("BASE", '"%s"' % base.as_posix())

    script = base / "_i18n_runtime_check.lua"
    io.open(str(script), "w", encoding="utf-8", newline="").write(lua)
    r = subprocess.run(["lua", str(script)], capture_output=True, text=True)
    sys.stdout.write(r.stdout)
    if r.stderr.strip():
        sys.stderr.write("--- loader notes ---\n" + r.stderr)
    os.remove(str(script))


if __name__ == "__main__":
    main()
