# Fixes a Data Connect Dart SDK generator bug: classes with `late final Optional`
# fields must not declare a generative `const` constructor
# (late_final_field_with_const_constructor).
#
# Run after regenerating the SDK, e.g.:
#   firebase dataconnect:sdk:generate
#   .\tool\patch_dataconnect_generated.ps1

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'lib\dataconnect_generated'

if (-not (Test-Path $dir)) {
  Write-Error "Directory not found: $dir"
}

$patched = 0
Get-ChildItem -Path $dir -Filter '*.dart' | ForEach-Object {
  $content = Get-Content -Raw -LiteralPath $_.FullName
  if ($content -notmatch 'late final Optional') { return }

  $updated = [regex]::Replace(
    $content,
    '(?m)^(\s*)const (\w+Variables\()',
    '$1$2'
  )

  if ($updated -ne $content) {
    Set-Content -LiteralPath $_.FullName -Value $updated -NoNewline
    Write-Host "Patched $($_.Name)"
    $patched++
  }
}

Write-Host "Done. Files patched: $patched"
