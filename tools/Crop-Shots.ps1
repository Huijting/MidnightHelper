<#
.SYNOPSIS
    Crops the screenshots taken by `/mh shots` to exactly the Midnight Helper window.

.DESCRIPTION
    The in-game rig (Modules/DevShots.lua) records a pixel rectangle per scene into
    SavedVariables. This script reads those rectangles, matches them to the newest N
    screenshots in order, and writes cropped copies to Screenshots\mh-shots\.

    Run it AFTER a /reload — WoW only flushes SavedVariables on logout or reload, so
    the rectangles are not on disk until then.

    Needs nothing installed: System.Drawing ships with Windows.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools\Crop-Shots.ps1
#>

[CmdletBinding()]
param(
    # Override if your WoW install is not the parent of this addon folder.
    [string] $RetailRoot
)

Add-Type -AssemblyName System.Drawing

if (-not $RetailRoot) {
    # tools -> MidnightHelper -> AddOns -> Interface -> _retail_
    $RetailRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")).Path
}

$shotDir = Join-Path $RetailRoot "Screenshots"
if (-not (Test-Path $shotDir)) { throw "No Screenshots folder at $shotDir" }

$svFiles = @(Get-ChildItem -Path (Join-Path $RetailRoot "WTF\Account") -Recurse -Filter "MidnightHelper.lua" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -like "*\SavedVariables\*" })
if ($svFiles.Count -eq 0) { throw "No SavedVariables\MidnightHelper.lua found under $RetailRoot\WTF\Account" }

$sv = ($svFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
Write-Host "SavedVariables: $($sv.FullName)"
$text = Get-Content -Raw -LiteralPath $sv.FullName

# WoW writes SavedVariables without indentation, so a lazy regex like "up to the next
# '},'" stops at the first RECORD's brace, not the table's. Count braces instead.
function Get-BalancedBody([string] $s, [int] $openBraceIndex) {
    $depth = 0
    for ($j = $openBraceIndex; $j -lt $s.Length; $j++) {
        if ($s[$j] -eq '{') { $depth++ }
        elseif ($s[$j] -eq '}') {
            $depth--
            if ($depth -eq 0) { return $s.Substring($openBraceIndex + 1, $j - $openBraceIndex - 1) }
        }
    }
    return $null
}

$keyIdx = $text.IndexOf('["devShotRects"]')
if ($keyIdx -lt 0) { throw 'No devShotRects in SavedVariables. Run /mh shots, then /reload, then this script.' }
$openIdx = $text.IndexOf('{', $keyIdx)
$tableBody = Get-BalancedBody $text $openIdx
if (-not $tableBody) { throw "devShotRects table is not closed - SavedVariables truncated?" }

# Top-level { ... } records inside that table.
$records = @()
for ($j = 0; $j -lt $tableBody.Length; $j++) {
    if ($tableBody[$j] -eq '{') {
        $rec = Get-BalancedBody $tableBody $j
        if ($rec) { $records += $rec; $j += $rec.Length + 1 }
    }
}

$rects = @()
foreach ($body in $records) {
    $get = {
        param($key)
        $mm = [regex]::Match($body, '\["' + $key + '"\]\s*=\s*"?([^",\r\n]+)"?')
        if ($mm.Success) { $mm.Groups[1].Value.Trim() } else { $null }
    }
    $name = & $get "name"
    if (-not $name) { continue }
    $rects += [pscustomobject]@{
        Name = $name
        X    = [int](& $get "x")
        Y    = [int](& $get "y")
        W    = [int](& $get "w")
        H    = [int](& $get "h")
    }
}
if ($rects.Count -eq 0) { throw "devShotRects was empty." }
Write-Host "Found $($rects.Count) crop rectangles."

# The rig shoots in order, so the N newest images map 1:1 onto the N rectangles.
$images = @(Get-ChildItem -LiteralPath $shotDir -File |
    Where-Object { $_.Extension -in ".png", ".jpg", ".jpeg", ".tga" } |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First $rects.Count |
    Sort-Object LastWriteTime)

if ($images.Count -lt $rects.Count) {
    throw "Only $($images.Count) recent screenshots for $($rects.Count) rectangles. Re-run /mh shots."
}

$outDir = Join-Path $shotDir "mh-shots"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

for ($i = 0; $i -lt $rects.Count; $i++) {
    $r = $rects[$i]
    $src = $images[$i]
    $bmp = [System.Drawing.Bitmap]::FromFile($src.FullName)
    try {
        # Clamp: a window dragged partly off-screen would otherwise throw.
        $x = [Math]::Max(0, [Math]::Min($r.X, $bmp.Width - 1))
        $y = [Math]::Max(0, [Math]::Min($r.Y, $bmp.Height - 1))
        $w = [Math]::Min($r.W, $bmp.Width - $x)
        $h = [Math]::Min($r.H, $bmp.Height - $y)
        if ($w -le 0 -or $h -le 0) { Write-Warning "$($r.Name): rectangle outside the image, skipped."; continue }

        $rect = New-Object System.Drawing.Rectangle $x, $y, $w, $h
        $crop = $bmp.Clone($rect, $bmp.PixelFormat)
        try {
            $dest = Join-Path $outDir ("{0}.png" -f $r.Name)
            $crop.Save($dest, [System.Drawing.Imaging.ImageFormat]::Png)
            Write-Host ("  {0,-20} {1}x{2}  <- {3}" -f $r.Name, $w, $h, $src.Name)
        } finally { $crop.Dispose() }
    } finally { $bmp.Dispose() }
}

Write-Host ""
Write-Host "Done -> $outDir"
