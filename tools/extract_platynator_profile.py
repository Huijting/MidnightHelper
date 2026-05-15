"""
Optional: regenerate Addons/PlatynatorData.lua from a Cursor transcript JSONL line
that still contains the Platynator profile JSON.

  set CURSOR_TRANSCRIPT=path\\to\\....jsonl
  python tools/extract_platynator_profile.py
"""

import json
import os

_HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(_HERE, "..", "Addons", "PlatynatorData.lua")

MARK_START = '{"stack_region_scale_x"'
MARK_END = '"friendlyNPC":false}}'


def main() -> None:
	path = os.environ.get("CURSOR_TRANSCRIPT")
	if not path or not os.path.isfile(path):
		raise SystemExit("Set CURSOR_TRANSCRIPT to a .jsonl file containing the profile export.")
	with open(path, "r", encoding="utf-8") as f:
		for line in f:
			if "stack_region_scale_x" not in line:
				continue
			o = json.loads(line)
			text = o["message"]["content"][0]["text"]
			i = text.find(MARK_START)
			if i < 0:
				raise SystemExit("start marker not found")
			j = text.rfind(MARK_END)
			if j < 0:
				raise SystemExit("end marker not found")
			j += len(MARK_END)
			prof = text[i:j]
			lua = (
				"local addonName, ns = ...\n"
				"--[[ Platynator profile export (JSON). Do not hand-edit. ]]\n"
				"ns.CustomPlatyString = [=====[\n"
				+ prof
				+ "\n]=====]\n"
			)
			os.makedirs(os.path.dirname(OUT), exist_ok=True)
			with open(OUT, "w", encoding="utf-8") as w:
				w.write(lua)
			print("wrote", OUT, "len", len(prof))
			return
	raise SystemExit("no matching line in transcript")


if __name__ == "__main__":
	main()
