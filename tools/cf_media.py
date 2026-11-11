"""cf_media -- real screenshots on one fixed background, for CurseForge and the site.

Rob, 11 Nov 2026 (via the werkwijze chat, his "Ja, bouw het"): at most 4-6 images on CurseForge,
always current. Rob takes the screenshots in game; ComfyUI only makes ONE background (no fake addon
windows). This script puts each screenshot on that background so the set looks like one family.

Everything lives OUTSIDE the repo and the WoW folder, in MEDIA (below). Nothing here reaches the zip.

    run cf_media              render every line of MEDIA\\shots.txt into MEDIA\\output\\
    run cf_media --proef      set up MEDIA (copy background, font, one existing screenshot),
                              write an example shots.txt if there is none, and render it
    run cf_media --help       this text

shots.txt, one line per image, fields separated by "|":
    file name in MEDIA\\input | short English title | optional crop x,y,w,h (pixels in the shot)
    Lines starting with # are comments.

Look (fixed, so every image matches): 1920x1080, the screenshot scaled to fit a box above the
desk edge of the background (aspect ratio never changed), a thin gold border (#FFCC00) with a soft
shadow, and the title above it in gold, in Cinzel (SIL Open Font License 1.1).
"""
import io
import os
import shutil
import sys

try:
    from PIL import Image, ImageDraw, ImageFilter, ImageFont
except ImportError:
    sys.exit("cf_media needs Pillow (pip install pillow)")

MEDIA = r"E:\MidnightHelper-media"
BG_SOURCE = r"E:\ComfyMCP\output\mh_cf_achtergrond_00002_.png"   # Rob's choice, "Nummer 2"
FONT_SOURCE = r"E:\ComfyMCP\halloween_express\fonts\Cinzel-VariableFont_wght.ttf"
PROEF_SHOT = r"E:\World of Warcraft\_retail_\Screenshots\mh-shots\02-this-week.png"

W, H = 1920, 1080
GOLD = (255, 204, 0)
BORDER = 3
# Where the screenshot may go. The background's desk edge starts near y 970 (measured on
# background 2): the box stops above it, so the lantern top and the desk stay visible.
BOX = (230, 165, 1690, 935)          # left, top, right, bottom
TITLE_Y = 92                          # vertical centre of the title line
TITLE_SIZE = 62


def paths():
    return {
        "bg": os.path.join(MEDIA, "achtergrond.png"),
        "font": os.path.join(MEDIA, "fonts", "Cinzel-VariableFont_wght.ttf"),
        "input": os.path.join(MEDIA, "input"),
        "output": os.path.join(MEDIA, "output"),
        "list": os.path.join(MEDIA, "shots.txt"),
    }


def load_font(path, size):
    font = ImageFont.truetype(path, size)
    try:
        font.set_variation_by_name("Bold")
    except Exception as e:  # older FreeType: regular weight is still fine
        print("note: could not pick the Bold weight (%s); using the default weight" % e)
    return font


def read_list(p):
    rows = []
    for n, line in enumerate(io.open(p, encoding="utf-8"), 1):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        parts = [x.strip() for x in line.split("|")]
        if len(parts) < 2 or not parts[0] or not parts[1]:
            sys.exit("shots.txt line %d: need 'file | title [| x,y,w,h]'" % n)
        crop = None
        if len(parts) > 2 and parts[2]:
            try:
                x, y, w, h = [int(v) for v in parts[2].split(",")]
            except ValueError:
                sys.exit("shots.txt line %d: crop must be x,y,w,h in whole pixels" % n)
            crop = (x, y, x + w, y + h)
        rows.append((parts[0], parts[1], crop))
    return rows


def compose(bg, shot, title, font):
    canvas = bg.convert("RGBA").resize((W, H), Image.LANCZOS) if bg.size != (W, H) else bg.convert("RGBA")
    l, t, r, b = BOX
    bw, bh = r - l - 2 * BORDER, b - t - 2 * BORDER
    scale = min(bw / shot.width, bh / shot.height)
    sw, sh = max(1, round(shot.width * scale)), max(1, round(shot.height * scale))
    shot = shot.convert("RGBA").resize((sw, sh), Image.LANCZOS)
    fw, fh = sw + 2 * BORDER, sh + 2 * BORDER
    fx = l + ((r - l) - fw) // 2
    fy = t + ((b - t) - fh) // 2

    # soft shadow: a dark rectangle, blurred, a little down and right of the frame
    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rectangle([fx + 8, fy + 12, fx + fw + 8, fy + fh + 12], fill=(0, 0, 0, 170))
    canvas = Image.alpha_composite(canvas, shadow.filter(ImageFilter.GaussianBlur(14)))

    d = ImageDraw.Draw(canvas)
    d.rectangle([fx, fy, fx + fw - 1, fy + fh - 1], fill=GOLD + (255,))
    canvas.alpha_composite(shot, (fx + BORDER, fy + BORDER))

    # title: gold on a soft dark glow, so it reads on any part of the sky
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.text((W // 2, TITLE_Y), title, font=font, anchor="mm", fill=(0, 0, 0, 220),
            stroke_width=6, stroke_fill=(0, 0, 0, 220))
    canvas = Image.alpha_composite(canvas, glow.filter(ImageFilter.GaussianBlur(6)))
    ImageDraw.Draw(canvas).text((W // 2, TITLE_Y), title, font=font, anchor="mm", fill=GOLD + (255,))
    return canvas.convert("RGB"), (fx, fy, fw, fh)


def setup_proef(p):
    for d in (MEDIA, p["input"], p["output"], os.path.dirname(p["font"])):
        os.makedirs(d, exist_ok=True)
    for src, dst in ((BG_SOURCE, p["bg"]), (FONT_SOURCE, p["font"])):
        if not os.path.isfile(dst):
            shutil.copy2(src, dst)          # copy: the original stays where it is
            print("copied", src, "->", dst)
    shot_dst = os.path.join(p["input"], os.path.basename(PROEF_SHOT))
    if not os.path.isfile(shot_dst):
        shutil.copy2(PROEF_SHOT, shot_dst)
        print("copied", PROEF_SHOT, "->", shot_dst)
    if not os.path.isfile(p["list"]):
        io.open(p["list"], "w", encoding="utf-8").write(
            "# file in input\\ | short English title | optional crop x,y,w,h\n"
            "%s | Your week, one click at a time\n" % os.path.basename(PROEF_SHOT))
        print("wrote example", p["list"])


def main():
    args = sys.argv[1:]
    if "--help" in args or "-h" in args:
        print(__doc__)
        return
    p = paths()
    if "--proef" in args:
        setup_proef(p)
    for need in ("bg", "font", "list"):
        if not os.path.isfile(p[need]):
            sys.exit("missing %s (run 'cf_media --proef' once to set up %s)" % (p[need], MEDIA))
    os.makedirs(p["output"], exist_ok=True)
    bg = Image.open(p["bg"])
    if bg.size != (W, H):
        print("note: background is %dx%d, scaled to %dx%d" % (bg.size + (W, H)))
    font = load_font(p["font"], TITLE_SIZE)
    rows = read_list(p["list"])
    if not rows:
        sys.exit("shots.txt has no lines")
    for i, (name, title, crop) in enumerate(rows, 1):
        src = os.path.join(p["input"], name)
        if not os.path.isfile(src):
            print("SKIP %s: not in %s" % (name, p["input"]))
            continue
        shot = Image.open(src)
        if crop:
            shot = shot.crop(crop)
        out_img, frame = compose(bg, shot, title, font)
        if font.getbbox(title)[2] - font.getbbox(title)[0] > W - 120:
            print("WARN %s: title is wider than the image; shorten it" % name)
        out = os.path.join(p["output"], "%02d-%s.png" % (i, os.path.splitext(name)[0]))
        out_img.save(out + ".tmp.png")
        os.replace(out + ".tmp.png", out)
        print("OK %s -> %s  (shot %dx%d, frame at %d,%d size %dx%d)"
              % (name, out, shot.width, shot.height, frame[0], frame[1], frame[2], frame[3]))


if __name__ == "__main__":
    main()
