[CmdletBinding()]
param(
  [string]$RepoUrl = "https://github.com/Arrr-temm/codex-config.git",
  [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"

function Write-Step {
  param([string]$Message)
  Write-Host "[codex-config] $Message"
}

function Ensure-Directory {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
  }
}

function Backup-File {
  param([string]$Path)
  if (Test-Path -LiteralPath $Path) {
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    Copy-Item -LiteralPath $Path -Destination "$Path.bak.$stamp" -Force
  }
}

function Sync-File {
  param(
    [string]$Source,
    [string]$Destination
  )
  Ensure-Directory -Path (Split-Path -Parent $Destination)
  if (Test-Path -LiteralPath $Destination) {
    Backup-File -Path $Destination
  }
  Copy-Item -LiteralPath $Source -Destination $Destination -Force
}

function Sync-DirectoryContents {
  param(
    [string]$Source,
    [string]$Destination
  )
  Ensure-Directory -Path $Destination
  Get-ChildItem -LiteralPath $Source -Directory -Force | ForEach-Object {
    $target = Join-Path $Destination $_.Name
    if (Test-Path -LiteralPath $target) {
      Remove-Item -LiteralPath $target -Recurse -Force
    }
    Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse -Force
  }
  Get-ChildItem -LiteralPath $Source -File -Force | ForEach-Object {
    $target = Join-Path $Destination $_.Name
    if (Test-Path -LiteralPath $target) {
      Backup-File -Path $target
    }
    Copy-Item -LiteralPath $_.FullName -Destination $target -Force
  }
}

function Ensure-PathContains {
  param([string]$Entry)
  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  $parts = @()
  if ($userPath) {
    $parts = $userPath.Split(";") | Where-Object { $_ }
  }
  $normalizedEntry = $Entry.TrimEnd("\")
  $exists = $parts | Where-Object { $_.TrimEnd("\") -ieq $normalizedEntry }
  if (-not $exists) {
    $newPath = if ($parts.Count -gt 0) { ($parts + $Entry) -join ";" } else { $Entry }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    $confirmed = [Environment]::GetEnvironmentVariable("Path", "User")
    if (-not $confirmed -or (($confirmed.Split(";") | ForEach-Object { $_.TrimEnd("\") }) -notcontains $normalizedEntry)) {
      Set-ItemProperty -Path "HKCU:\Environment" -Name Path -Value $newPath
    }
  }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  throw "git is required to install codex-config."
}

$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$vendorImports = Join-Path $codexHome "vendor_imports"
$repoDir = Join-Path $vendorImports "codex-config"
$binDir = Join-Path $codexHome "bin"
$localRepoRoot = Split-Path -Parent $PSScriptRoot
$usingLocalCheckout = Test-Path -LiteralPath (Join-Path $localRepoRoot ".git")

Ensure-Directory -Path $codexHome
Ensure-Directory -Path $vendorImports
Ensure-Directory -Path $binDir

if ($usingLocalCheckout) {
  Write-Step "Updating local checkout in $localRepoRoot"
  git -C $localRepoRoot fetch origin $Branch
  git -C $localRepoRoot checkout $Branch
  git -C $localRepoRoot pull --ff-only origin $Branch
  $sourceRoot = $localRepoRoot
} else {
  if (-not (Test-Path -LiteralPath $repoDir)) {
    Write-Step "Cloning $RepoUrl into $repoDir"
    git clone --branch $Branch $RepoUrl $repoDir
  } else {
    Write-Step "Updating checkout in $repoDir"
    git -C $repoDir fetch origin $Branch
    git -C $repoDir checkout $Branch
    git -C $repoDir pull --ff-only origin $Branch
  }
  $sourceRoot = $repoDir
}

$managedRoot = Join-Path $sourceRoot "codex"
$sourceConfig = Join-Path $managedRoot "config.toml"
$sourceSkills = Join-Path $managedRoot "skills"
$sourceRules = Join-Path $managedRoot "rules"

if (Test-Path -LiteralPath $sourceConfig) {
  Write-Step "Syncing config.toml"
  Sync-File -Source $sourceConfig -Destination (Join-Path $codexHome "config.toml")
}

if (Test-Path -LiteralPath $sourceSkills) {
  Write-Step "Syncing skills"
  Sync-DirectoryContents -Source $sourceSkills -Destination (Join-Path $codexHome "skills")
}

if (Test-Path -LiteralPath $sourceRules) {
  Write-Step "Syncing rules"
  Sync-DirectoryContents -Source $sourceRules -Destination (Join-Path $codexHome "rules")
}

$wrapperPath = Join-Path $binDir "get-codex-config.ps1"
$wrapperSource = Join-Path $sourceRoot "bootstrap\install.ps1"
$wrapper = @"
& '$wrapperSource'
"@
Set-Content -LiteralPath $wrapperPath -Value $wrapper -Encoding UTF8

$cmdWrapperPath = Join-Path $binDir "get-codex-config.cmd"
$cmdWrapper = @"
@echo off
powershell -ExecutionPolicy Bypass -File "$wrapperSource" %*
"@
Set-Content -LiteralPath $cmdWrapperPath -Value $cmdWrapper -Encoding ASCII
Ensure-PathContains -Entry $binDir

$profilePath = $PROFILE.CurrentUserAllHosts
Ensure-Directory -Path (Split-Path -Parent $profilePath)
if (Test-Path -LiteralPath $profilePath) {
  $profileContent = Get-Content -LiteralPath $profilePath -Raw
} else {
  $profileContent = ""
}

$startMarker = "# >>> codex-config >>>"
$endMarker = "# <<< codex-config <<<"
$profileBlock = @"
$startMarker
function get-codex-config { & '$wrapperPath' @args }
Set-Alias Get-CodexConfigFromGitHub get-codex-config
$endMarker
"@

if ($profileContent -match [regex]::Escape($startMarker)) {
  $escapedStart = [regex]::Escape($startMarker)
  $escapedEnd = [regex]::Escape($endMarker)
  $updated = [regex]::Replace($profileContent, "$escapedStart[\s\S]*?$escapedEnd", $profileBlock)
  Set-Content -LiteralPath $profilePath -Value $updated -Encoding UTF8
} else {
  $separator = if ([string]::IsNullOrWhiteSpace($profileContent)) { "" } else { "`r`n`r`n" }
  Set-Content -LiteralPath $profilePath -Value ($profileContent + $separator + $profileBlock + "`r`n") -Encoding UTF8
}

Write-Step "Install complete. Open a new shell and run: get-codex-config"
