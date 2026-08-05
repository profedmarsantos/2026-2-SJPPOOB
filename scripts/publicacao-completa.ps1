param(
  [string]$Branch = "main",
  [string]$Mensagem = "chore(publicacao): publicacao completa",
  [string]$DataAtualizacao = (Get-Date -Format "dd/MM/yyyy HH:mm:ss"),
  [switch]$SincronizarAgente
)

$ErrorActionPreference = "Stop"

Write-Host "[1/6] Verificando repositorio git..."
git rev-parse --is-inside-work-tree | Out-Null

Write-Host "[2/6] Validando estrutura da pasta lessons..."
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

if ($SincronizarAgente) {
  Write-Host "[3/7] Sincronizando agente modulo-writer..."
  $scriptSync = Join-Path "scripts" "sync-modulo-writer-agent.ps1"
  if (-not (Test-Path $scriptSync)) {
    throw "Script nao encontrado: $scriptSync"
  }
  & $scriptSync
}
else {
  Write-Host "[3/7] Sincronizacao do agente ignorada (use -SincronizarAgente para ativar)."
}

Write-Host "[4/7] Sincronizando log de ultima atualizacao nas licoes..."
for ($i = 1; $i -le 20; $i++) {
  $name = "lesson{0:D3}.html" -f $i
  $path = Join-Path "material/html-moodle/lessons" $name
  $content = Get-Content -LiteralPath $path -Raw

  if ($content -match '(?i)class=[''"'']update-log[''"'']') {
    $updated = [regex]::Replace(
      $content,
      '(?is)(<section[^>]*class=[''"'']update-log[''"''][^>]*>.*?<p>\s*(?:<strong>\s*)?(?:ultima|última)\s+(?:atualizacao|atualização)\s*:\s*(?:</strong>\s*)?)(\d{2}/\d{2}/\d{4}(?:\s+\d{2}:\d{2}:\d{2})?)(\s*</p>)',
      "`${1}$DataAtualizacao`${3}"
    )
  } else {
    $logBlock = "`r`n    <section class='update-log' aria-label='Informação de atualização'>`r`n      <p>Última atualização: $DataAtualizacao</p>`r`n    </section>`r`n"
    $updated = $content -replace "</article>", ($logBlock + "  </article>")
  }

  Set-Content -LiteralPath $path -Value $updated -Encoding utf8
}

for ($i = 1; $i -le 20; $i++) {
  $name = "lesson{0:D3}.html" -f $i
  $path = Join-Path "material/html-moodle/lessons" $name
  $content = Get-Content -LiteralPath $path -Raw
  $pattern = "(?i)(ultima|última)\s+(atualizacao|atualização)\s*:\s*$([regex]::Escape($DataAtualizacao))"
  if (-not ($content -match $pattern)) {
    throw "Log de atualizacao ausente ou incorreto em: $path"
  }
}

Write-Host "[5/7] Adicionando alteracoes..."
git add -A

$temMudanca = (git diff --cached --name-only)
if (-not $temMudanca) {
  Write-Host "Nenhuma mudanca para commit."
} else {
  Write-Host "[6/7] Gerando commit..."
  git commit -m $Mensagem
}

Write-Host "[7/7] Enviando para origin/$Branch..."
git push origin $Branch

Write-Host "Publicacao completa concluida. O deploy do GitHub Pages sera disparado pelo push."
Write-Host "Checklist recomendado: material/html-moodle/CHECKLIST_PUBLICACAO_LICOES.md"
