# Package gamedata into an MO2 ready zip for a GitHub release.
# Every build also mirrors the result into the local installed copy under
# $modsDir, unless -NoSync is passed.
# Usage:
#   .\build-release.ps1                  build from the VERSION file (and sync local copy)
#   .\build-release.ps1 -Version 1.1.0   set the version (updates VERSION) and build
#   .\build-release.ps1 -Publish         build, then create the release and upload the zip with gh
#   .\build-release.ps1 -NoSync          build without touching the local installed copy
[CmdletBinding()]
param(
    [string]$Version,
    [switch]$Publish,
    [switch]$NoSync
)

$ErrorActionPreference = 'Stop'
$root    = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$modName = 'Buy-Claimed-Bodies'
$repo    = 'TheLostInPlace/Buy-Claimed-Bodies'
$repoUrl = "https://github.com/$repo"
$modsDir = 'F:\GAMMA\mods'   # local install kept in sync with every build

# resolve the version from the parameter or the VERSION file
$versionFile = Join-Path $root 'VERSION'
if ($Version) {
    $Version = $Version.TrimStart('v')
    Set-Content -LiteralPath $versionFile -Value $Version -Encoding ascii -NoNewline
} elseif (Test-Path -LiteralPath $versionFile) {
    $Version = (Get-Content -LiteralPath $versionFile -Raw).Trim()
} else {
    throw "no -Version given and no VERSION file at $versionFile"
}
if ($Version -notmatch '^\d+\.\d+\.\d+$') { throw "version '$Version' must look like X.Y.Z" }

$tag     = "v$Version"
$dist    = Join-Path $root 'dist'
$zipPath = Join-Path $dist "$modName-$tag.zip"

# stage the files that go into the zip
$stage = Join-Path $env:TEMP "$modName-stage-$Version"
if (Test-Path -LiteralPath $stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
New-Item -ItemType Directory -Path $stage | Out-Null

$gamedata = Join-Path $root 'gamedata'
if (-not (Test-Path -LiteralPath $gamedata)) { throw "gamedata not found at $gamedata" }
Copy-Item -LiteralPath $gamedata -Destination $stage -Recurse

$readme = Join-Path $root 'README.md'
if (Test-Path -LiteralPath $readme) { Copy-Item -LiteralPath $readme -Destination $stage }

# meta.ini so MO2 shows the version and a clickable source link
$meta = @"
[General]
modid=0
version=$Version
newestVersion=
category=0
url=$repoUrl
hasCustomURL=true
comments=Buy Claimed Bodies, buy bodies that NPCs have claimed
notes=
"@
[System.IO.File]::WriteAllText((Join-Path $stage 'meta.ini'), $meta, (New-Object System.Text.UTF8Encoding($false)))

# build the zip with gamedata at the root so MO2 installs it as a mod
New-Item -ItemType Directory -Path $dist -Force | Out-Null
if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force }
Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $zipPath -CompressionLevel Optimal

# keep the local installed copy in sync: mirror gamedata (so files deleted in the
# dev folder are removed there too) and refresh meta.ini and the readme. skipped
# with -NoSync or if the mods folder is not on this machine
if (-not $NoSync) {
    if (Test-Path -LiteralPath $modsDir) {
        $install = Join-Path $modsDir $modName
        New-Item -ItemType Directory -Path $install -Force | Out-Null
        robocopy (Join-Path $stage 'gamedata') (Join-Path $install 'gamedata') /MIR /NFL /NDL /NJH /NJS /NP | Out-Null
        if ($LASTEXITCODE -ge 8) { Write-Warning "robocopy reported errors syncing gamedata (code $LASTEXITCODE)" }
        $global:LASTEXITCODE = 0
        Copy-Item -LiteralPath (Join-Path $stage 'meta.ini') -Destination $install -Force
        if (Test-Path -LiteralPath (Join-Path $stage 'README.md')) {
            Copy-Item -LiteralPath (Join-Path $stage 'README.md') -Destination $install -Force
        }
        Write-Host "synced local copy at $install"
    } else {
        Write-Warning "local mods folder not found at $modsDir, skipped sync"
    }
}

Remove-Item -LiteralPath $stage -Recurse -Force

Write-Host "built $zipPath"

if ($Publish) {
    $dirty = git -C $root status --porcelain
    if ($dirty) { Write-Warning "working tree has uncommitted changes, the tag $tag will point at the last commit" }
    $notes = @"
Release $tag

## Compatibility
AlifePlus 1.7.7+ ships its own corpse loot ownership (ap_ext_loot_claim) that overlaps this mod. Turn AlifePlus loot ownership off in its MCM (economy, loot) when using this mod. AlifePlus 1.7.6 and earlier are unaffected.
"@
    gh release create $tag $zipPath --repo $repo --title $tag --notes "$notes"
    Write-Host "published release $tag"
}
