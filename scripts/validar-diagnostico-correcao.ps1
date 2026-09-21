<#
.SYNOPSIS
  Valida a cobertura e os contadores do diagnostico local antes da analise tecnica.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$CsvPath,

    [Parameter(Mandatory = $true)]
    [string]$DiagnosticPath,

    [Parameter(Mandatory = $true)]
    [string]$LogPath
)

$ErrorActionPreference = 'Stop'
foreach ($path in @($CsvPath, $DiagnosticPath, $LogPath)) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Arquivo obrigatorio nao encontrado: $path" }
}

$log = Get-Content -LiteralPath $LogPath -Raw
if ($log -notmatch 'PREPROCESSAMENTO_CONCLUIDO\|STATUS=SUCESSO') {
    throw 'O log nao contem o marcador de conclusao bem-sucedida do pre-processamento.'
}

$rows = @(Import-Csv -LiteralPath $CsvPath -Encoding utf8)
$csvIds = @($rows | ForEach-Object { "$($_.Identificador)".Trim() } | Where-Object { $_ -match '^Participante\d+$' } | Sort-Object -Unique)
$diagnostic = Get-Content -LiteralPath $DiagnosticPath -Raw | ConvertFrom-Json
$results = @($diagnostic.resultados)
$diagnosticIds = @($results | ForEach-Object { "$($_.participante_id)".Trim() } | Sort-Object -Unique)

$missing = @($csvIds | Where-Object { $_ -notin $diagnosticIds })
$extra = @($diagnosticIds | Where-Object { $_ -notin $csvIds })
if ($missing.Count -gt 0) { throw "IDs ausentes no diagnostico: $($missing -join ', ')" }
if ($extra.Count -gt 0) { throw "IDs extras no diagnostico: $($extra -join ', ')" }
if ($results.Count -ne $csvIds.Count) { throw "Quantidade invalida: CSV=$($csvIds.Count), diagnostico=$($results.Count)" }

$withSubmission = @($results | Where-Object { $_.status_envio -eq 'Com envio' })
$withoutSubmission = @($results | Where-Object { $_.status_envio -eq 'Sem envio' })
$buildOk = @($withSubmission | Where-Object { $_.compilacao -and $_.compilacao.compilou -eq $true })
$buildFailed = @($withSubmission | Where-Object { -not $_.compilacao -or $_.compilacao.compilou -ne $true })

Write-Output "DIAGNOSTICO_VALIDO|IDS_CSV=$($csvIds.Count)|RESULTADOS=$($results.Count)|FALTANTES=$($missing.Count)|EXTRAS=$($extra.Count)|COM_ENVIO=$($withSubmission.Count)|SEM_ENVIO=$($withoutSubmission.Count)|BUILD_APROVADO=$($buildOk.Count)|BUILD_REPROVADO=$($buildFailed.Count)"
