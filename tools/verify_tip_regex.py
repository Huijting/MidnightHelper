import pathlib, re

ROOT = pathlib.Path(__file__).resolve().parents[1]
text = (ROOT / "Addons" / "GuideData.lua").read_text(encoding="utf-8")
ROW_RE = re.compile(
    r'(\{\s*spell\s*=\s*\d+\s*,\s*)text\s*=\s*"((?:[^"\\]|\\.)*)"\s*(\}\s*,)'
)
matches = list(ROW_RE.finditer(text))
print("matches", len(matches))
