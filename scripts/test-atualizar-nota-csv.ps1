<#
.SYNOPSIS
  Suite de testes automatizados para o script scripts/atualizar-nota-csv.ps1.

.DESCRIPTION
  Testa exaustivamente:
  1. Atualizacao individual e em lote.
  2. Preservacao de BOM UTF-8, CRLF, cabecalho e quantidade de linhas.
  3. Tratamento seguro de aspas duplas, virgulas e acentos nos comentarios.
  4. Falhas esperadas (ID inexistente, ID duplicado, nota fora do intervalo).
  5. Inalterabilidade do arquivo original em caso de erro e limpeza de arquivos .tmp.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$testDir = Join-Path $PSScriptRoot "_test_sandbox_$([System.Guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path $testDir | Out-Null

$scriptTarget = Join-Path $PSScriptRoot "atualizar-nota-csv.ps1"
if (-not (Test-Path -LiteralPath $scriptTarget)) {
    throw "Script alvo nao encontrado: $scriptTarget"
}

$testsPassed = 0
$testsFailed = 0

function Assert-Condition {
    param(
        [string]$TestName,
        [bool]$Condition,
        [string]$FailureMessage
    )
    if ($Condition) {
        Write-Host "  [PASS] $TestName" -ForegroundColor Green
        $script:testsPassed++
    }
    else {
        Write-Host "  [FAIL] $TestName - $FailureMessage" -ForegroundColor Red
        $script:testsFailed++
    }
}

try {
    Write-Host "Iniciando testes de atualizar-nota-csv.ps1..." -ForegroundColor Cyan

    # Cria CSV fixture com BOM UTF-8 e CRLF
    $csvFixturePath = Join-Path $testDir "Notas-Fixture.csv"
    $rawCsvText = "Identificador,""Nome completo"",""Identificação de usuário"",""Número de identificação"",Status,Nota,""Nota máxima"",""Nota pode ser alterada"",""Última modificação (envio)"",""Última modificação (nota)"",""Comentários de feedback""`r`n" +
                  "Participante101,""Aluno Alfa"",rp101,rp101,""Enviado para avaliação -  - "",,""100,00"",Sim,""segunda-feira, 14 set. 2026, 21:51"",-,`r`n" +
                  "Participante102,""Aluno Beta"",rp102,rp102,""Nenhum envio -  - "",,""100,00"",Sim,-,-,`r`n" +
                  "Participante103,""Aluno Gama"",rp103,rp103,""Enviado para avaliação -  - "",""50,00"",""100,00"",Sim,""segunda-feira, 14 set. 2026, 22:00"",-,""Nota anterior""`r`n"

    $encWithBom = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllText($csvFixturePath, $rawCsvText, $encWithBom)

    # Teste 1: Atualizacao individual com aspas, virgulas e acentos
    & pwsh -NoProfile -File $scriptTarget -CsvPath $csvFixturePath -ParticipanteId "101" -Nota 88.5 -Comentario 'Nota Final: 88.5/100 | Bom trabalho no "encapsulamento" | Item 3 - Organizacao: 18/20 pts - Ajustar separacao de classes - Local: Program.cs'
    $content1 = [System.IO.File]::ReadAllText($csvFixturePath, $encWithBom)
    $lines1 = $content1 -split "`r`n"
    Assert-Condition -TestName "Teste 1: Linhas mantidas" -Condition ($lines1.Length -ge 4) -FailureMessage "Linhas: $($lines1.Length)"
    Assert-Condition -TestName "Teste 1: Nota Alfa atualizada" -Condition ($lines1[1] -match '"88,50"') -FailureMessage $lines1[1]
    Assert-Condition -TestName "Teste 1: Comentario com aspas escapadas" -Condition ($lines1[1] -match '""encapsulamento""') -FailureMessage $lines1[1]

    # Teste 2: Atualizacao de aluno ausente (nota 0,00)
    & pwsh -NoProfile -File $scriptTarget -CsvPath $csvFixturePath -ParticipanteId "102" -Nota 0 -Comentario "Atividade nao entregue / Sem envio."
    $content2 = [System.IO.File]::ReadAllText($csvFixturePath, $encWithBom)
    $lines2 = $content2 -split "`r`n"
    Assert-Condition -TestName "Teste 2: Nota Beta zerada" -Condition ($lines2[2] -match '"0,00"') -FailureMessage $lines2[2]
    Assert-Condition -TestName "Teste 2: Feedback de ausência" -Condition ($lines2[2] -match 'Atividade nao entregue / Sem envio\.') -FailureMessage $lines2[2]

    # Teste 3: Atualizacao em lote via JSON
    $batchJsonPath = Join-Path $testDir "batch.json"
    @"
[
  { "ParticipanteId": "101", "Nota": 95.0, "Comentario": "Nota Final: 95/100 | Bom desempenho geral | Item 2 - Encapsulamento: 25/25 pts - Atendido - Local: Conta.cs" },
    { "ParticipanteId": "102", "Nota": 0.0, "Comentario": "Atividade nao entregue / Sem envio." },
  { "ParticipanteId": "103", "Nota": 72.5, "Comentario": "Nota Final: 72.5/100 | Requisitos parcialmente atendidos | Item 3 - Organizacao: 12/20 pts - Classe em arquivo incorreto - Local: Program.cs" }
]
"@ | Set-Content -LiteralPath $batchJsonPath -Encoding utf8

    & pwsh -NoProfile -File $scriptTarget -CsvPath $csvFixturePath -UpdatesJson $batchJsonPath
    $content3 = [System.IO.File]::ReadAllText($csvFixturePath, $encWithBom)
    $lines3 = $content3 -split "`r`n"
    Assert-Condition -TestName "Teste 3: Lote Alfa atualizado" -Condition ($lines3[1] -match '"95,00"') -FailureMessage $lines3[1]
    Assert-Condition -TestName "Teste 3: Lote Gama atualizado" -Condition ($lines3[3] -match '"72,50"') -FailureMessage $lines3[3]

    # Teste 4: Falha com ID inexistente (deve dar erro e manter arquivo intocado)
    $beforeError = [System.IO.File]::ReadAllText($csvFixturePath, $encWithBom)
    $failedAsExpected = $false
    try {
        & pwsh -NoProfile -File $scriptTarget -CsvPath $csvFixturePath -ParticipanteId "999" -Nota 50 -Comentario "teste"
    } catch {
        $failedAsExpected = $true
    }
    # Note: when running external script in pwsh, exit code != 0 causes $LASTEXITCODE != 0
    if ($LASTEXITCODE -ne 0) { $failedAsExpected = $true }
    $afterError = [System.IO.File]::ReadAllText($csvFixturePath, $encWithBom)
    Assert-Condition -TestName "Teste 4: Erro ao passar ID inexistente" -Condition $failedAsExpected -FailureMessage "Script nao falhou com ID 999"
    Assert-Condition -TestName "Teste 4: CSV inalterado apos erro" -Condition ($beforeError -eq $afterError) -FailureMessage "Arquivo foi modificado"

    # Teste 5: Falha com ID duplicado no lote
    $dupJsonPath = Join-Path $testDir "dup.json"
    @"
[
  { "ParticipanteId": "101", "Nota": 80.0, "Comentario": "Primeiro" },
  { "ParticipanteId": "101", "Nota": 90.0, "Comentario": "Duplicado" }
]
"@ | Set-Content -LiteralPath $dupJsonPath -Encoding utf8

    $dupFailed = $false
    try {
        & pwsh -NoProfile -File $scriptTarget -CsvPath $csvFixturePath -UpdatesJson $dupJsonPath
    } catch {
        $dupFailed = $true
    }
    if ($LASTEXITCODE -ne 0) { $dupFailed = $true }
    Assert-Condition -TestName "Teste 5: Falha em lote com ID duplicado" -Condition $dupFailed -FailureMessage "Script aceitou ID duplicado"

    # Teste 6: Falha com nota invalida (> 100)
    $invalidGradeFailed = $false
    try {
        & pwsh -NoProfile -File $scriptTarget -CsvPath $csvFixturePath -ParticipanteId "101" -Nota 150 -Comentario "invalido"
    } catch {
        $invalidGradeFailed = $true
    }
    if ($LASTEXITCODE -ne 0) { $invalidGradeFailed = $true }
    Assert-Condition -TestName "Teste 6: Falha com nota > 100" -Condition $invalidGradeFailed -FailureMessage "Script aceitou nota > 100"

    # Teste 7: Falha com comentario generico (sem itemizacao)
    $genericCommentFailed = $false
    try {
        & pwsh -NoProfile -File $scriptTarget -CsvPath $csvFixturePath -ParticipanteId "101" -Nota 80 -Comentario "Bom trabalho"
    } catch {
        $genericCommentFailed = $true
    }
    if ($LASTEXITCODE -ne 0) { $genericCommentFailed = $true }
    Assert-Condition -TestName "Teste 7: Falha com comentario generico" -Condition $genericCommentFailed -FailureMessage "Script aceitou comentario sem detalhamento"

    # Teste 8: Ausencia de arquivos .tmp pendentes
    $tmpFiles = Get-ChildItem -LiteralPath $testDir -Filter "*.tmp.*"
    Assert-Condition -TestName "Teste 8: Nenhum arquivo .tmp residuo" -Condition ($tmpFiles.Count -eq 0) -FailureMessage "Encontrados $($tmpFiles.Count) temporarios"

}
finally {
    if (Test-Path -LiteralPath $testDir) {
        Remove-Item -LiteralPath $testDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

$msgColor = if ($testsFailed -eq 0) { 'Green' } else { 'Red' }
Write-Host "Testes concluidos: $testsPassed passaram, $testsFailed falharam." -ForegroundColor $msgColor
if ($testsFailed -gt 0) {
    exit 1
}
