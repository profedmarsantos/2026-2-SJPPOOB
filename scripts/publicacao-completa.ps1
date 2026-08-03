param(
  [string]$Branch = "main",
  [string]$Mensagem = "chore(publicacao): publicacao completa",
  [string]$DataAtualizacao = (Get-Date -Format "dd/MM/yyyy")
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

Write-Host "[3/6] Sincronizando log de ultima atualizacao nas licoes..."
for ($i = 1; $i -le 20; $i++) {
  $name = "lesson{0:D3}.html" -f $i
  $path = Join-Path "material/html-moodle/lessons" $name
  $content = Get-Content -LiteralPath $path -Raw

  if ($content -match "Ultima atualizacao:") {
    $updated = [regex]::Replace(
      $content,
      "(?i)(<strong>\s*Ultima atualizacao:\s*</strong>\s*)(\d{2}/\d{2}/\d{4})",
      "`${1}$DataAtualizacao"
    )
  } else {
    $logBlock = "`r`n    <section class='update-log' aria-label='Informacao de atualizacao'>`r`n      <p><strong>Ultima atualizacao:</strong> $DataAtualizacao</p>`r`n    </section>`r`n"
    $updated = $content -replace "</article>", ($logBlock + "  </article>")
  }

  Set-Content -LiteralPath $path -Value $updated -Encoding utf8
}

for ($i = 1; $i -le 20; $i++) {
  $name = "lesson{0:D3}.html" -f $i
  $path = Join-Path "material/html-moodle/lessons" $name
  $content = Get-Content -LiteralPath $path -Raw
  $pattern = "(?i)Ultima atualizacao[^0-9]*$([regex]::Escape($DataAtualizacao))"
  if (-not ($content -match $pattern)) {
    throw "Log de atualizacao ausente ou incorreto em: $path"
  }
}

Write-Host "[4/6] Adicionando alteracoes..."
git add -A

$temMudanca = (git diff --cached --name-only)
if (-not $temMudanca) {
  Write-Host "Nenhuma mudanca para commit."
} else {
  Write-Host "[5/6] Gerando commit..."
  git commit -m $Mensagem
}

Write-Host "[6/6] Enviando para origin/$Branch..."
git push origin $Branch

Write-Host "Publicacao completa concluida. O deploy do GitHub Pages sera disparado pelo push."
Write-Host "Checklist recomendado: material/html-moodle/CHECKLIST_PUBLICACAO_LICOES.md"
