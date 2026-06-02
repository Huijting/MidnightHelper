param(
	[string]$RepoRoot = "",
	[string]$WowAddOnDir = "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper",
	[switch]$Pull
)

$ErrorActionPreference = "Stop"

function Resolve-RepoRoot {
	if ($RepoRoot -and (Test-Path (Join-Path $RepoRoot "MidnightHelper.toc"))) {
		return $RepoRoot
	}
	$root = Split-Path -Parent $PSScriptRoot
	if (Test-Path (Join-Path $root "MidnightHelper.toc")) {
		return $root
	}
	throw "Could not locate repo root. Pass -RepoRoot pointing at the folder containing MidnightHelper.toc."
}

$repo = Resolve-RepoRoot

if (-not (Test-Path $WowAddOnDir)) {
	throw "WoW AddOn directory not found: $WowAddOnDir"
}

if ($Pull) {
	Push-Location $repo
	try {
		if (-not (Test-Path (Join-Path $repo ".git"))) {
			throw "Repo root has no .git folder: $repo"
		}
		Write-Host "git pull in $repo"
		& git pull
	} finally {
		Pop-Location
	}
}

Write-Host "Sync repo -> WoW AddOn dir"
Write-Host "  repo: $repo"
Write-Host "  wow : $WowAddOnDir"

$args = @($repo, $WowAddOnDir, "/E", "/XD", ".git", "/NFL", "/NDL", "/NJH", "/NJS", "/nc", "/ns", "/np")
& robocopy @args | Out-Null
$rc = $LASTEXITCODE
if ($rc -gt 7) {
	throw "robocopy failed with exit code $rc"
}

Write-Host "Done. In WoW run: /reload"

