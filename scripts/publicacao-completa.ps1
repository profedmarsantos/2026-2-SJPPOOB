param(
  [string]$Branch = "main",
  [string]$Mensagem = "chore(publicacao): publicacao completa"
)

$ErrorActionPreference = "Stop"

Write-Host "[1/5] Verificando repositorio git..."
git rev-parse --is-inside-work-tree | Out-Null

Write-Host "[2/5] Validando estrutura da pasta lessons..."
if (-not (Test-Path "material/html-moodle/lessons/index.html")) {
  throw "Arquivo material/html-moodle/lessons/index.html nao encontrado."
}
for ($i = 1; $i -le 20; $i++) {
  $name = "lesson{0:D3}.html" -f $i
  $path = Join-Path "material/html-moodle/lessons" $name
  if (-not (Test-Path $path)) {
    throw "Arquivo ausente: $path"
  }
}

Write-Host "[3/5] Adicionando alteracoes..."
git add -A

$temMudanca = (git diff --cached --name-only)
if (-not $temMudanca) {
  Write-Host "Nenhuma mudanca para commit."
} else {
  Write-Host "[4/5] Gerando commit..."
  git commit -m $Mensagem
}

Write-Host "[5/5] Enviando para origin/$Branch..."
git push origin $Branch

Write-Host "Publicacao completa concluida. O deploy do GitHub Pages sera disparado pelo push."
