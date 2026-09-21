<#
.SYNOPSIS
  Valida o lote de notas antes da persistencia no CSV do Moodle.

.DESCRIPTION
  Nao altera arquivos. Confirma que o lote contem exatamente todos os
  participantes do CSV e que cada atualizacao atende ao contrato do script
  atualizar-nota-csv.ps1.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$CsvPath,

    [Parameter(Mandatory = $true)]
    [string]$UpdatesJson
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $CsvPath)) {
    throw "CSV nao encontrado: $CsvPath"
}
if (-not (Test-Path -LiteralPath $UpdatesJson)) {
    throw "JSON de lote nao encontrado: $UpdatesJson"
}

$csvRows = @(Import-Csv -LiteralPath $CsvPath -Encoding utf8)
$targetIds = [System.Collections.Generic.HashSet[string]]::new()
foreach ($row in $csvRows) {
    $identifier = "$($row.Identificador)".Trim()
    if ($identifier -match '^Participante\d+$') {
        [void]$targetIds.Add($identifier)
    }
}
if ($targetIds.Count -eq 0) {
    throw 'O CSV nao contem participantes no formato Participante<id>.'
}

$rawJson = Get-Content -LiteralPath $UpdatesJson -Raw
if ([string]::IsNullOrWhiteSpace($rawJson)) {
    throw 'O JSON de lote esta vazio.'
}
$parsed = ConvertFrom-Json -InputObject $rawJson
$updates = @($parsed)
if ($updates.Count -eq 0) {
    throw 'O JSON de lote nao contem atualizacoes.'
}

$updateIds = [System.Collections.Generic.HashSet[string]]::new()
foreach ($update in $updates) {
    if (-not $update.PSObject.Properties['ParticipanteId']) {
        throw 'Atualizacao sem ParticipanteId.'
    }
    $rawId = "$($update.ParticipanteId)".Trim()
    if ($rawId -match '^Participante(\d+)$') {
        $identifier = $rawId
    }
    elseif ($rawId -match '^\d+$') {
        $identifier = "Participante$rawId"
    }
    else {
        throw "ParticipanteId invalido: $rawId"
    }

    if (-not $updateIds.Add($identifier)) {
        throw "ParticipanteId duplicado: $identifier"
    }
    if (-not $update.PSObject.Properties['Nota'] -or [string]::IsNullOrWhiteSpace("$($update.Nota)")) {
        throw "Nota ausente para $identifier"
    }
    $nota = 0.0
    if (-not [double]::TryParse("$($update.Nota)", [Globalization.NumberStyles]::Float, [Globalization.CultureInfo]::InvariantCulture, [ref]$nota)) {
        throw "Nota invalida para $identifier"
    }
    if ($nota -lt 0 -or $nota -gt 100) {
        throw "Nota fora do intervalo de 0 a 100 para $identifier"
    }
    if (-not $update.PSObject.Properties['Comentario']) {
        throw "Comentario ausente para $identifier"
    }
    $comentario = "$($update.Comentario)".Trim()
    if ([string]::IsNullOrWhiteSpace($comentario) -or $comentario -match "`r|`n") {
        throw "Comentario vazio ou multilinha para $identifier"
    }
    if ($comentario -notmatch '^Atividade (nao|não) entregue / Sem envio\.?$') {
        if ($comentario -notmatch 'Nota\s*Final\s*:\s*\d+[\.,]?\d*/100' -or
            $comentario -notmatch 'Item\s*\d+' -or
            $comentario -notmatch '\d+\s*/\s*\d+\s*pts') {
            throw "Comentario sem detalhamento minimo para $identifier"
        }
    }
}

$missing = @($targetIds | Where-Object { -not $updateIds.Contains($_) })
$extra = @($updateIds | Where-Object { -not $targetIds.Contains($_) })
if ($missing.Count -gt 0) {
    throw "Participantes ausentes no lote: $($missing -join ', ')"
}
if ($extra.Count -gt 0) {
    throw "Participantes extras no lote: $($extra -join ', ')"
}

Write-Output "VALIDO|PARTICIPANTES=$($targetIds.Count)|ATUALIZACOES=$($updateIds.Count)"
