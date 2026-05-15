#!/usr/bin/env python3
"""Run luac -p on all addon Lua files (matches CI). Exit 1 on first batch of failures."""
from __future__ import annotations

import pathlib
import shutil
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
DIRS = ("Addons", "Locales", "Modules")


def find_luac() -> str | None:
    for name in ("luac5.1", "luac"):
        path = shutil.which(name)
        if path:
            return path
    return None


def main() -> int:
    luac = find_luac()
    if not luac:
        print("luac5.1/luac not found on PATH", file=sys.stderr)
        return 2

    files = sorted(
        p
        for d in DIRS
        for p in (ROOT / d).rglob("*.lua")
        if p.is_file()
    )
    failed: list[tuple[pathlib.Path, str]] = []
    for f in files:
        r = subprocess.run([luac, "-p", str(f)], capture_output=True, text=True)
        if r.returncode != 0:
            err = (r.stderr or r.stdout or "syntax error").strip()
            failed.append((f, err))

    if not failed:
        print(f"Lua syntax OK ({len(files)} files, {luac})")
        return 0

    print(f"Lua syntax FAILED ({len(failed)} of {len(files)} files):", file=sys.stderr)
    for f, err in failed:
        rel = f.relative_to(ROOT)
        print(f"::error file={rel}::{err}", file=sys.stderr)
        print(f"  {rel}: {err}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
