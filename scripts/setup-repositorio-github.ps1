param(
  [Parameter(Mandatory = $true)]
  [string]$GitHubOwner,

  [string]$RepoName = "2026-2-SJPPOOB",
  [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"

$remoteUrl = "https://github.com/$GitHubOwner/$RepoName.git"

if (-not (Test-Path ".git")) {
  Write-Host "Inicializando repositorio local..."
  git init
}

Write-Host "Configurando branch principal..."
git checkout -B $Branch

$hasOrigin = $false
try {
  git remote get-url origin | Out-Null
  $hasOrigin = $true
} catch {
  $hasOrigin = $false
}

if ($hasOrigin) {
  Write-Host "Atualizando remote origin para $remoteUrl"
  git remote set-url origin $remoteUrl
} else {
  Write-Host "Adicionando remote origin $remoteUrl"
  git remote add origin $remoteUrl
}

Write-Host "Repositorio pronto para push inicial."
Write-Host "Proximo passo: executar .\\scripts\\publicacao-completa.ps1"
