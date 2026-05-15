# Build MidnightHelper-<Version>.zip for CurseForge (folder MidnightHelper/ at zip root).
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
$excludeDirs = @(".git", ".cursor", "tools", "docs", ".github", "dist", "__pycache__")
$xf = @(".cursorrules", "PHASES.txt", ".gitattributes", ".gitignore")
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

$dist = Join-Path $src "dist"
New-Item -ItemType Directory -Force -Path $dist | Out-Null
$zip = Join-Path $dist ("MidnightHelper-" + $ver + ".zip")
if (Test-Path $zip) {
	Remove-Item $zip -Force
}
Compress-Archive -Path $folder -DestinationPath $zip -CompressionLevel Optimal
Remove-Item -Recurse -Force $stagingRoot

Write-Host ("Created " + $zip)
