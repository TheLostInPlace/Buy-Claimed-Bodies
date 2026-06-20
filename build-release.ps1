# Package gamedata into an MO2 ready zip for a GitHub release.
# Usage:
#   .\build-release.ps1                  build from the VERSION file
#   .\build-release.ps1 -Version 1.1.0   set the version (updates VERSION) and build
#   .\build-release.ps1 -Publish         build, then create the release and upload the zip with gh
[CmdletBinding()]
param(
    [string]$Version,
    [switch]$Publish
)

$ErrorActionPreference = 'Stop'
$root    = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$modName = 'Buy-Claimed-Bodies'
$repo    = 'TheLostInPlace/Buy-Claimed-Bodies'
$repoUrl = "https://github.com/$repo"

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
Remove-Item -LiteralPath $stage -Recurse -Force

Write-Host "built $zipPath"

if ($Publish) {
    $dirty = git -C $root status --porcelain
    if ($dirty) { Write-Warning "working tree has uncommitted changes, the tag $tag will point at the last commit" }
    gh release create $tag $zipPath --repo $repo --title $tag --notes "Release $tag"
    Write-Host "published release $tag"
}
