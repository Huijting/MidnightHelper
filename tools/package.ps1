# Build MidnightHelper-<Version>.zip for CurseForge (folder MidnightHelper/ at zip root).
# When asked to "build the CurseForge zip" or "release package", run this script from the repo root.
$ErrorActionPreference = "Stop"
# Repo root (folder containing MidnightHelper.toc)
$src = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $src "MidnightHelper.toc"))) {
	throw "Expected MidnightHelper.toc next to tools/; wrong layout."
}

$toc = Get-Content (Join-Path $src "MidnightHelper.toc") -Raw
if ($toc -notmatch '## Version:\s*(\S+)') {
	throw "Could not parse ## Version from MidnightHelper.toc"
}
$ver = $Matches[1]

$stagingRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("MidnightHelper-pack-" + [guid]::NewGuid().ToString("n"))
$folder = Join-Path $stagingRoot "MidnightHelper"
New-Item -ItemType Directory -Path $folder | Out-Null

$robolog = Join-Path $stagingRoot "robocopy.log"
$excludeDirs = @(".git", ".cursor", "tools", "docs", ".github", "dist", "data", "__pycache__")
$xf = @(
	".cursorrules", ".gitattributes", ".gitignore", ".luarc.json",
	"CLAUDE.md", "README.md", "CHANGELOG.md", "RELEASE_CHECKLIST.md", "CURSEFORGE_DESCRIPTION.md",
	"*.bat", "*.cmd", "*.ps1", "*.py", "*.exe"
)
$args = @($src, $folder, "/E", "/NFL", "/NDL", "/NJH", "/NJS", "/nc", "/ns", "/np")
foreach ($d in $excludeDirs) {
	$args += "/XD"
	$args += $d
}
foreach ($f in $xf) {
	$args += "/XF"
	$args += $f
}
& robocopy @args | Out-Null
$rc = $LASTEXITCODE
if ($rc -gt 7) {
	throw "robocopy failed with exit code $rc"
}

# CurseForge rejects non-addon executables/scripts (e.g. Sync-MidnightHelper.bat).
$blockedExt = @(".bat", ".cmd", ".ps1", ".py", ".exe", ".vbs")
$blocked = Get-ChildItem -Path $folder -Recurse -File -ErrorAction SilentlyContinue |
	Where-Object { $blockedExt -contains $_.Extension.ToLowerInvariant() }
if ($blocked -and $blocked.Count -gt 0) {
	$names = ($blocked | ForEach-Object { $_.FullName.Substring($folder.Length + 1) }) -join ", "
	throw ("Package contains blocked files (not allowed on CurseForge): " + $names)
}

$dist = Join-Path $src "dist"
New-Item -ItemType Directory -Force -Path $dist | Out-Null
$zip = Join-Path $dist ("MidnightHelper-" + $ver + ".zip")
if (Test-Path $zip) {
	Remove-Item $zip -Force
}
Compress-Archive -Path $folder -DestinationPath $zip -CompressionLevel Optimal
Remove-Item -Recurse -Force $stagingRoot

Write-Host ("Created " + $zip)
