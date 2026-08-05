param(
  [string]$Source = ".github/agents/modulo-writer.agent.md",
  [string]$Target = "$env:USERPROFILE/.copilot/agents/modulo-writer.agent.md"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $repoRoot $Source

if (-not (Test-Path $sourcePath)) {
  throw "Arquivo fonte nao encontrado: $sourcePath"
}

$targetDir = Split-Path -Parent $Target
if (-not (Test-Path $targetDir)) {
  New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

Copy-Item -Path $sourcePath -Destination $Target -Force

Write-Host "Agente sincronizado com sucesso."
Write-Host "Fonte: $sourcePath"
Write-Host "Destino: $Target"
