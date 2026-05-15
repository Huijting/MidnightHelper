#!/usr/bin/env python3
"""Run luac -p on all addon Lua files (matches CI). Exit 1 on first batch of failures."""
from __future__ import annotations

import pathlib
import shutil
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
DIRS = ("Addons", "Locales", "Modules")

# Ubuntu lua5.1 package (GitHub Actions apt install).
LUAC_CANDIDATES = (
    "luac5.1",
    "luac",
    "/usr/bin/luac5.1",
    "/usr/bin/luac",
)


def find_luac() -> str | None:
    for name in LUAC_CANDIDATES:
        path = shutil.which(name) if not name.startswith("/") else name
        if path and pathlib.Path(path).is_file():
            return path
    return None


def check_file(luac: str, path: pathlib.Path) -> tuple[bool, str]:
    if path.read_bytes().startswith(b"\xef\xbb\xbf"):
        return False, "UTF-8 BOM at start of file (breaks Lua 5.1 / luac5.1 on CI)"
    r = subprocess.run(
        [luac, "-p", str(path)],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    if r.returncode == 0:
        return True, ""
    err = (r.stderr or r.stdout or "syntax error").strip()
    return False, err


def main() -> int:
    luac = find_luac()
    if not luac:
        print("luac5.1/luac not found. Tried:", ", ".join(LUAC_CANDIDATES), file=sys.stderr)
        return 2

    files = sorted(
        p
        for d in DIRS
        for p in (ROOT / d).rglob("*.lua")
        if p.is_file()
    )
    if not files:
        print("No .lua files under Addons/, Locales/, Modules/", file=sys.stderr)
        return 2

    failed: list[tuple[pathlib.Path, str]] = []
    for f in files:
        ok, err = check_file(luac, f)
        if not ok:
            failed.append((f, err))

    if not failed:
        print(f"Lua syntax OK ({len(files)} files, {luac})", flush=True)
        return 0

    print(f"Lua syntax FAILED ({len(failed)} of {len(files)} files, {luac}):", flush=True)
    print(f"Lua syntax FAILED ({len(failed)} of {len(files)} files):", file=sys.stderr)
    for f, err in failed:
        rel = f.relative_to(ROOT)
        print(f"::error file={rel}::{err}", file=sys.stderr)
        print(f"  {rel}: {err}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
