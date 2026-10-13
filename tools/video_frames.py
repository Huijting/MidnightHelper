"""Pull still frames out of a gameplay video so Claude can read them (Rob, 13 Oct 2026: "kan ik mijn delve
filmen zodat jij hem kan analyseren?").

Claude reads images, not video. This cuts a recording into JPEGs at a fixed interval, optionally only between two
timestamps, into one new folder per run next to the video's name in the scratch area.

Run through the front door (no arguments on the command line -- see CLAUDE.md):
    probe_job.txt:  run video_frames <video path> [every_seconds=5] [start=00:00:00] [end=]
Examples:
    run video_frames "C:/Users/RobHu/Videos/Captures/World of Warcraft 2026-10-13.mp4"
    run video_frames "C:/.../run.mp4" 2 00:12:30 00:14:00     (a boss fight, one frame every 2 s)

ffmpeg: C:/Users/RobHu/Tools/ffmpeg (gyan.dev essentials 9.0.2, sha256 checked 13 Oct 2026).
Frames are scaled to 1280 wide: enough to read chat and objective text, small enough to look at many.
"""
import os
import subprocess
import sys

FFMPEG_ROOT = r"C:\Users\RobHu\Tools\ffmpeg"
OUT_ROOT = os.path.join(os.environ.get("TEMP", r"C:\Temp"), "mh_video_frames")


def find_ffmpeg():
    for root, _, files in os.walk(FFMPEG_ROOT):
        if "ffmpeg.exe" in files:
            return os.path.join(root, "ffmpeg.exe")
    return None


def main(argv):
    if not argv:
        print(__doc__)
        return 1
    video = argv[0]
    every = float(argv[1]) if len(argv) > 1 else 5.0
    start = argv[2] if len(argv) > 2 else None
    end = argv[3] if len(argv) > 3 else None
    if not os.path.isfile(video):
        print("no such video:", video)
        return 1
    ff = find_ffmpeg()
    if not ff:
        print("ffmpeg not found under", FFMPEG_ROOT)
        return 1
    base = os.path.splitext(os.path.basename(video))[0]
    tag = (start or "0").replace(":", "") + "_" + (end or "end").replace(":", "") + "_every" + str(every)
    out = os.path.join(OUT_ROOT, base + "_" + tag)
    os.makedirs(out, exist_ok=True)
    cmd = [ff, "-hide_banner", "-loglevel", "error"]
    if start:
        cmd += ["-ss", start]
    if end:
        cmd += ["-to", end]
    cmd += ["-i", video, "-vf", "fps=1/%s,scale=1280:-2" % every, "-q:v", "4",
            os.path.join(out, "f_%05d.jpg")]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print("ffmpeg failed:", r.stderr.strip()[:2000])
        return 1
    frames = sorted(f for f in os.listdir(out) if f.endswith(".jpg"))
    print("frames:", len(frames), "in", out)
    # Frame n sits at start + (n-1)*every seconds -- print a few so a frame number maps back to video time.
    off = 0
    if start:
        parts = [float(p) for p in start.split(":")]
        while len(parts) < 3:
            parts.insert(0, 0.0)
        off = parts[0] * 3600 + parts[1] * 60 + parts[2]
    shown = frames if len(frames) <= 4 else frames[:3] + ["..."] + frames[-1:]
    for f in shown:
        if f == "...":
            print("   ...")
            continue
        n = int(f[2:7])
        t = off + (n - 1) * every
        print("   %s  ~%02d:%02d:%02d" % (f, t // 3600, (t % 3600) // 60, t % 60))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
