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

    # `b` is the distance from the screen BOTTOM. Preferred over `y`: we turn it into a
    # top-left y using the real image height, so the addon's idea of the screen size
    # cannot shift every crop (it did, over a remote desktop). PS 5.1 has no `if`
    # expression, hence the separate assignment.
    $bRaw = & $get "b"
    $bottom = $null
    if ($bRaw) { $bottom = [int]$bRaw }

    $rects += [pscustomobject]@{
        Name   = $name
        X      = [int](& $get "x")
        Y      = [int](& $get "y")
        W      = [int](& $get "w")
        H      = [int](& $get "h")
        Bottom = $bottom
        Stamp  = (& $get "t")   # MMDDYY_HHMMSS, as WoW names its screenshots
    }
}
if ($rects.Count -eq 0) { throw "devShotRects was empty." }
Write-Host "Found $($rects.Count) crop rectangles."

# Match each rectangle to the screenshot the rig stamped for it. WoW names files
# WoWScrnShot_MMDDYY_HHMMSS.<ext>, and the rig records that same stamp at the shutter.
#
# "Take the N newest files" seemed obvious and is wrong: one stray manual screenshot in
# the folder shifts the whole mapping by one, and the crops still look plausible - the
# first run cropped the mounts tab and labelled it 01-this-week.
# PS 5.1 will not resolve TryParseExact when the provider is $null and the styles are a
# bare string: both must be the real types.
$STAMP_FMT = 'MMddyy_HHmmss'
$STAMP_CULTURE = [Globalization.CultureInfo]::InvariantCulture
$STAMP_STYLES = [Globalization.DateTimeStyles]::None

function ConvertFrom-Stamp([string] $stamp) {
    $when = [datetime]::MinValue
    if ([datetime]::TryParseExact($stamp, $STAMP_FMT, $STAMP_CULTURE, $STAMP_STYLES, [ref]$when)) { return $when }
    return $null
}

$candidates = @(Get-ChildItem -LiteralPath $shotDir -File |
    Where-Object { $_.Extension -in ".png", ".jpg", ".jpeg", ".tga" } |
    Where-Object { $_.BaseName -match '^WoWScrnShot_(\d{6}_\d{6})$' } |
    ForEach-Object {
        $null = $_.BaseName -match '^WoWScrnShot_(\d{6}_\d{6})$'
        $when = ConvertFrom-Stamp $Matches[1]
        if ($when) { [pscustomobject]@{ File = $_; When = $when } }
    })

function Resolve-Shot([string] $stamp) {
    if (-not $stamp) { return $null }
    $want = ConvertFrom-Stamp $stamp
    if (-not $want) { return $null }
    # Exact name first; otherwise the nearest shot within a few seconds, because WoW can
    # write the file a tick after the call.
    $hit = $candidates | Where-Object { $_.When -eq $want } | Select-Object -First 1
    if (-not $hit) {
        $hit = $candidates |
            Where-Object { [Math]::Abs(($_.When - $want).TotalSeconds) -le 3 } |
            Sort-Object { [Math]::Abs(($_.When - $want).TotalSeconds) } |
            Select-Object -First 1
    }
    if ($hit) { return $hit.File }
    return $null
}

$legacy = @($rects | Where-Object { -not $_.Stamp })
if ($legacy.Count -gt 0) {
    Write-Warning "$($legacy.Count) rectangle(s) carry no timestamp (recorded by an older /mh shots). Re-run it."
}

$outDir = Join-Path $shotDir "mh-shots"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$done = 0
for ($i = 0; $i -lt $rects.Count; $i++) {
    $r = $rects[$i]
    $src = Resolve-Shot $r.Stamp
    if (-not $src) {
        Write-Warning "$($r.Name): no screenshot found for stamp '$($r.Stamp)'. Skipped."
        continue
    }
    $bmp = [System.Drawing.Bitmap]::FromFile($src.FullName)
    try {
        # Derive y from the image itself where we can, so a mismatch between the
        # rendered resolution and GetPhysicalScreenSize() cannot shift the crop.
        $yWanted = $r.Y
        if ($null -ne $r.Bottom) { $yWanted = $bmp.Height - $r.Bottom - $r.H }

        # Clamp: a window dragged partly off-screen would otherwise throw.
        $x = [Math]::Max(0, [Math]::Min($r.X, $bmp.Width - 1))
        $y = [Math]::Max(0, [Math]::Min($yWanted, $bmp.Height - 1))
        $w = [Math]::Min($r.W, $bmp.Width - $x)
        $h = [Math]::Min($r.H, $bmp.Height - $y)
        if ($w -le 0 -or $h -le 0) { Write-Warning "$($r.Name): rectangle outside the image, skipped."; continue }

        $rect = New-Object System.Drawing.Rectangle $x, $y, $w, $h
        $crop = $bmp.Clone($rect, $bmp.PixelFormat)
        try {
            $dest = Join-Path $outDir ("{0}.png" -f $r.Name)
            $crop.Save($dest, [System.Drawing.Imaging.ImageFormat]::Png)
            Write-Host ("  {0,-20} {1}x{2}  <- {3}" -f $r.Name, $w, $h, $src.Name)
            $done++
        } finally { $crop.Dispose() }
    } finally { $bmp.Dispose() }
}

Write-Host ""
Write-Host "Done -> $outDir  ($done of $($rects.Count) cropped)"
