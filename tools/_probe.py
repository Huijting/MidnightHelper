"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the Hunter's UI probe, and what is really on the three "refused" slots.
"""
import subprocess

LUA = r'C:\Users\RobHu\AppData\Local\Programs\Lua\bin\lua.exe'
SV = (r'E:/World of Warcraft/_retail_/WTF/Account/JOEYWHATEVER/'
      r'SavedVariables/MidnightHelper.lua')

script = r'''
local chunk = assert(loadfile([[__SV__]])); chunk()
local b = MidnightHelperDB.barInventory
local u = b and b.ui
print("=== personage / balken ===")
if u then
  local keys = {}
  for k in pairs(u) do if k ~= "systemNames" then keys[#keys+1] = k end end
  table.sort(keys)
  for _, k in ipairs(keys) do print(string.format("   %-30s %s", k, tostring(u[k]))) end
else
  print("   geen ui-blok -- oude scan")
end

print("")
print("=== Edit Mode systeemnamen ===")
if u and u.systemNames then
  local nums = {}
  for n in pairs(u.systemNames) do nums[#nums+1] = tonumber(n) end
  table.sort(nums)
  for _, n in ipairs(nums) do
    print(string.format("   system %-3d %s", n, tostring(u.systemNames[tostring(n)])))
  end
else
  print("   niet gelezen")
end

print("")
print("=== wat staat er op vakje 3, 4 en 39? ===")
local want = { [3]=true, [4]=true, [39]=true }
for _, s in ipairs((b and b.slots) or {}) do
  if want[s.slot] then
    print(string.format("   slot %2d  kind=%-10s id=%-10s %s", s.slot, tostring(s.kind),
      tostring(s.id), tostring(s.name)))
    want[s.slot] = nil
  end
end
for slot in pairs(want) do print(string.format("   slot %2d  LEEG", slot)) end
'''.replace('__SV__', SV)

r = subprocess.run([LUA, '-e', script], capture_output=True, text=True,
                   encoding='utf-8', errors='replace')
print(r.stdout)
if r.stderr.strip():
    print('STDERR:', r.stderr[:600])
