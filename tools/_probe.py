"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: is Rob's layout account-wide or character-specific, and how many are there?
"""
import subprocess

LUA = r'C:\Users\RobHu\AppData\Local\Programs\Lua\bin\lua.exe'
SV = (r'E:/World of Warcraft/_retail_/WTF/Account/JOEYWHATEVER/'
      r'SavedVariables/MidnightHelper.lua')

script = r'''
local chunk = assert(loadfile([[__SV__]])); chunk()
local b = MidnightHelperDB.editModeBackups and MidnightHelperDB.editModeBackups[1]
if not b then print("geen back-up") return end
print("actieve index (presets tellen mee):", tostring(b.active))
print("opgeslagen layouts:", tostring(#((b.data and b.data.layouts) or {})))
for i, l in ipairs((b.data and b.data.layouts) or {}) do
  print(string.format("   %d  naam=%-16s layoutType=%s",
    i, tostring(l.layoutName), tostring(l.layoutType)))
end
print("")
print("Enum.EditModeLayoutType: 0 = Preset, 1 = Account, 2 = Character (Blizzard-volgorde)")
'''.replace('__SV__', SV)

r = subprocess.run([LUA, '-e', script], capture_output=True, text=True,
                   encoding='utf-8', errors='replace')
print(r.stdout)
if r.stderr.strip():
    print('STDERR:', r.stderr[:600])
