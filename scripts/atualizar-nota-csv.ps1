<#
.SYNOPSIS
  Atualiza com seguranca as colunas "Nota" e "Comentarios de feedback" de um CSV de notas
  do Moodle (avaliacoes/*), sem alterar nenhuma outra coluna, linha, cabecalho ou delimitador.

.DESCRIPTION
  Nunca usar edicao de texto livre para alterar o CSV de notas. Este script:
  - Le o arquivo preservando o texto bruto de cada campo (mantendo aspas/formatacao originais
    de todas as colunas nao alteradas).
  - Valida todos os registros antes de aplicar alteracoes (evita escritas parciais).
  - Valida o JSON em lote (tipos, intervalos de 0 a 100, IDs duplicados, campos obrigatorios).
  - Grava primeiro em arquivo temporario seguro e valida estruturalmente o resultado antes
    de substituir o arquivo definitivo.
  - Re-le o arquivo apos a escrita e valida linha a linha cada nota e comentario atualizados.
  - Retorna saida estruturada (APLICADO|... e contagens SOLICITADOS/APLICADOS).

.PARAMETER CsvPath
  Caminho do arquivo .csv de notas a ser atualizado (editado in-place com seguranca).

.PARAMETER ParticipanteId
  Numero do participante (ex.: 61750) para atualizacao de uma unica linha. Usar junto com
  -Nota e -Comentario.

.PARAMETER Nota
  Nota de 0 a 100 (numero, ponto ou virgula decimal). Sera convertida para o formato "87,50"
  (virgula, 2 casas) usado pela coluna "Nota maxima" do proprio arquivo.

.PARAMETER Comentario
  Texto do comentario de feedback para a linha atualizada.

.PARAMETER UpdatesJson
  Caminho de um arquivo JSON com uma lista de atualizacoes em lote, no formato:
  [ { "ParticipanteId": "61750", "Nota": 87.5, "Comentario": "..." }, ... ]

.PARAMETER WhatIf
  Mostra o que seria alterado sem gravar o arquivo.

.EXAMPLE
  ./atualizar-nota-csv.ps1 -CsvPath "avaliacoes/A2N1/Notas-...csv" -ParticipanteId 61750 -Nota 87.5 -Comentario "Atende a maior parte da rubrica."

.EXAMPLE
  ./atualizar-nota-csv.ps1 -CsvPath "avaliacoes/A2N1/Notas-...csv" -UpdatesJson "avaliacoes/A2N1/notas-lote.json"
#>
[CmdletBinding(DefaultParameterSetName = 'Single')]
param(
    [Parameter(Mandatory = $true)]
    [string]$CsvPath,

    [Parameter(Mandatory = $true, ParameterSetName = 'Single')]
    [string]$ParticipanteId,

    [Parameter(Mandatory = $true, ParameterSetName = 'Single')]
    [double]$Nota,

    [Parameter(Mandatory = $true, ParameterSetName = 'Single')]
    [string]$Comentario,

    [Parameter(Mandatory = $true, ParameterSetName = 'Batch')]
    [string]$UpdatesJson,

    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

function Split-CsvLineRaw {
    # Retorna os campos de uma linha CSV preservando o texto bruto (aspas incluidas).
    param([string]$Line)

    $fields = New-Object System.Collections.Generic.List[string]
    $current = New-Object System.Text.StringBuilder
    $inQuotes = $false
    for ($i = 0; $i -lt $Line.Length; $i++) {
        $c = $Line[$i]
        if ($inQuotes) {
            if ($c -eq '"') {
                if ($i + 1 -lt $Line.Length -and $Line[$i + 1] -eq '"') {
                    [void]$current.Append('""')
                    $i++
                }
                else {
                    [void]$current.Append('"')
                    $inQuotes = $false
                }
            }
            else {
                [void]$current.Append($c)
            }
        }
        else {
            if ($c -eq '"') {
                [void]$current.Append('"')
                $inQuotes = $true
            }
            elseif ($c -eq ',') {
                $fields.Add($current.ToString())
                [void]$current.Clear()
            }
            else {
                [void]$current.Append($c)
            }
        }
    }
    $fields.Add($current.ToString())
    return $fields
}

function Unescape-CsvField {
    # Converte um campo bruto (possivelmente entre aspas) para seu valor logico.
    param([string]$Raw)

    if ($Raw.Length -ge 2 -and $Raw[0] -eq '"' -and $Raw[$Raw.Length - 1] -eq '"') {
        return $Raw.Substring(1, $Raw.Length - 2).Replace('""', '"')
    }
    return $Raw
}

function Format-CsvField {
    # Formata um valor logico em um campo CSV bruto, citando quando necessario (RFC 4180 + espacos).
    param([string]$Value)

    if ($null -eq $Value) { $Value = '' }
    if ($Value -match '[",\r\n ]') {
        return '"' + ($Value -replace '"', '""') + '"'
    }
    return $Value
}

function Format-NotaBr {
    # Converte um numero 0-100 para o formato "87,50" (virgula, 2 casas), igual a "Nota maxima".
    param([double]$Value)

    if ($Value -lt 0 -or $Value -gt 100) {
        throw "Nota fora do intervalo permitido (0 a 100): $Value"
    }
    $texto = $Value.ToString('F2', [System.Globalization.CultureInfo]::InvariantCulture)
    return $texto.Replace('.', ',')
}

function Test-ComentarioObrigatorio {
    # Garante feedback preenchido e com rastreabilidade quando houver nota de atividade entregue.
    param(
        [string]$Comentario,
        [double]$Nota,
        [string]$ParticipanteId
    )

    if ([string]::IsNullOrWhiteSpace($Comentario)) {
        throw "Comentario obrigatorio ausente para o ParticipanteId $ParticipanteId"
    }

    if ($Comentario -match "`r|`n") {
        throw "Comentario deve estar em linha unica para o ParticipanteId $ParticipanteId"
    }

    $comentarioNormalizado = $Comentario.Trim()
    $ehSemEnvio = $comentarioNormalizado -match '^Atividade (não|nao) entregue / Sem envio\.?$'
    if ($ehSemEnvio) {
        return
    }

    $temNotaFinal = $comentarioNormalizado -match 'Nota\s*Final\s*:\s*\d+[\.,]?\d*/100'
    $temItem = $comentarioNormalizado -match 'Item\s*\d+'
    $temPontuacaoItem = $comentarioNormalizado -match '\d+\s*/\s*\d+\s*pts'

    if (-not ($temNotaFinal -and $temItem -and $temPontuacaoItem)) {
        throw "Comentario sem detalhamento minimo (Nota Final + Item + pontuacao Y/Z pts) para o ParticipanteId $ParticipanteId"
    }
}

if (-not (Test-Path -LiteralPath $CsvPath)) {
    throw "Arquivo CSV nao encontrado: $CsvPath"
}

# Resolve caminho completo absoluto
$fullCsvPath = (Get-Item -LiteralPath $CsvPath).FullName

# Preserva BOM e encoding original do arquivo.
$bytes = [System.IO.File]::ReadAllBytes($fullCsvPath)
$hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
$encoding = New-Object System.Text.UTF8Encoding($hasBom)
# GetString nao remove o BOM sozinho; os 3 bytes precisam ser pulados manualmente.
$conteudoBytes = if ($hasBom) { $bytes[3..($bytes.Length - 1)] } else { $bytes }
$conteudo = $encoding.GetString($conteudoBytes)

# Preserva o estilo de quebra de linha original (CRLF ou LF).
$eol = if ($conteudo.Contains("`r`n")) { "`r`n" } else { "`n" }
$linhas = $conteudo -split "`r`n|`n"
# Remove uma ultima linha vazia gerada pela quebra final do arquivo, se houver.
$temQuebraFinal = $conteudo.EndsWith($eol)
if ($temQuebraFinal -and $linhas.Length -gt 0 -and $linhas[-1] -eq '') {
    $linhas = $linhas[0..($linhas.Length - 2)]
}

if ($linhas.Length -lt 1) {
    throw "CSV vazio ou invalido: $CsvPath"
}

$headerOriginal = $linhas[0]
$headerFields = Split-CsvLineRaw -Line $headerOriginal | ForEach-Object { Unescape-CsvField -Raw $_ }
$colunaEsperadas = $headerFields.Length

$idxIdentificador = [array]::IndexOf($headerFields, 'Identificador')
$idxNota = [array]::IndexOf($headerFields, 'Nota')
$idxComentario = [array]::IndexOf($headerFields, 'Comentários de feedback')

if ($idxIdentificador -lt 0 -or $idxNota -lt 0 -or $idxComentario -lt 0) {
    throw "Cabecalho do CSV nao contem as colunas esperadas (Identificador / Nota / Comentários de feedback)."
}

# Mapeia todos os identificadores presentes no CSV original
$mapLinhasPorId = @{}
for ($linhaIdx = 1; $linhaIdx -lt $linhas.Length; $linhaIdx++) {
    $linhaOriginal = $linhas[$linhaIdx]
    if ([string]::IsNullOrWhiteSpace($linhaOriginal)) { continue }
    $campos = Split-CsvLineRaw -Line $linhaOriginal
    if ($campos.Count -ne $colunaEsperadas) {
        throw "Linha $($linhaIdx + 1) tem $($campos.Count) colunas, esperado $colunaEsperadas. Abortando para nao corromper o CSV."
    }
    $id = Unescape-CsvField -Raw $campos[$idxIdentificador]
    if ($mapLinhasPorId.ContainsKey($id)) {
        throw "Identificador duplicado no CSV: $id"
    }
    $mapLinhasPorId[$id] = $linhaIdx
}

# Monta e valida a lista de atualizacoes a aplicar
$updates = @()
if ($PSCmdlet.ParameterSetName -eq 'Single') {
    if ([string]::IsNullOrWhiteSpace($ParticipanteId)) {
        throw "ParticipanteId nao pode ser vazio."
    }
    if ($Nota -lt 0 -or $Nota -gt 100) {
        throw "Nota fora do intervalo permitido (0 a 100): $Nota"
    }

    $comentarioSingle = if ($null -eq $Comentario) { '' } else { "$Comentario".Trim() }
    Test-ComentarioObrigatorio -Comentario $comentarioSingle -Nota $Nota -ParticipanteId $ParticipanteId

    $updates += [PSCustomObject]@{
        ParticipanteId = $ParticipanteId
        Nota           = $Nota
        Comentario     = $comentarioSingle
    }
}
else {
    if (-not (Test-Path -LiteralPath $UpdatesJson)) {
        throw "Arquivo de atualizacoes em lote nao encontrado: $UpdatesJson"
    }
    $rawJson = Get-Content -LiteralPath $UpdatesJson -Raw
    if ([string]::IsNullOrWhiteSpace($rawJson)) {
        throw "Arquivo de lote JSON esta vazio: $UpdatesJson"
    }
    $parsed = $rawJson | ConvertFrom-Json
    if (-not ($parsed -is [System.Collections.IEnumerable])) {
        $parsed = @($parsed)
    }
    if ($parsed.Count -eq 0) {
        throw "Lista de atualizacoes no JSON nao contem nenhum item: $UpdatesJson"
    }

    $seenIds = @{}
    foreach ($item in $parsed) {
        if (-not $item.PSObject.Properties['ParticipanteId'] -or [string]::IsNullOrWhiteSpace("$($item.ParticipanteId)")) {
            throw "Item no lote sem ParticipanteId valido: $($item | ConvertTo-Json -Compress)"
        }
        $itemPid = "$($item.ParticipanteId)"
        if ($seenIds.ContainsKey($itemPid)) {
            throw "ParticipanteId duplicado no lote JSON: $itemPid"
        }
        $seenIds[$itemPid] = $true

        if (-not $item.PSObject.Properties['Nota'] -or $null -eq $item.Nota) {
            throw "Item no lote sem campo 'Nota' para o ParticipanteId $itemPid"
        }
        $notaRaw = "$($item.Nota)".Trim()
        if ([string]::IsNullOrWhiteSpace($notaRaw)) {
            throw "Item no lote com campo 'Nota' vazio para o ParticipanteId $itemPid"
        }
        $notaVal = [double]$notaRaw
        if ($notaVal -lt 0 -or $notaVal -gt 100) {
            throw "Nota fora do intervalo permitido (0 a 100) para o ParticipanteId $itemPid : $notaVal"
        }

        $comentVal = if ($item.PSObject.Properties['Comentario'] -and $null -ne $item.Comentario) { "$($item.Comentario)".Trim() } else { '' }
        Test-ComentarioObrigatorio -Comentario $comentVal -Nota $notaVal -ParticipanteId $itemPid

        $updates += [PSCustomObject]@{
            ParticipanteId = $itemPid
            Nota           = $notaVal
            Comentario     = $comentVal
        }
    }

    $idsCsvAlvo = @($mapLinhasPorId.Keys | Where-Object { $_ -match '^Participante\d+$' })
    $idsLoteAlvo = @($updates | ForEach-Object {
        $valor = "$($_.ParticipanteId)"
        if ($valor.StartsWith('Participante')) { $valor } else { "Participante$valor" }
    })
    if ($updates.Count -ne $idsCsvAlvo.Count) {
        throw "Lote incompleto: CSV possui $($idsCsvAlvo.Count) participantes alvo, mas o lote possui $($updates.Count) atualizacoes."
    }
    $faltantes = @($idsCsvAlvo | Where-Object { $_ -notin $idsLoteAlvo })
    $extras = @($idsLoteAlvo | Where-Object { $_ -notin $idsCsvAlvo })
    if ($faltantes.Count -gt 0) {
        throw "Lote sem participantes: $($faltantes -join ', ')"
    }
    if ($extras.Count -gt 0) {
        throw "Lote possui participantes extras: $($extras -join ', ')"
    }
}

# Pre-validacao: todos os IDs solicitados devem existir no CSV antes de qualquer alteracao
$idsEsperadosMapeados = [ordered]@{}
foreach ($u in $updates) {
    $rawId = "$($u.ParticipanteId)"
    $chaveIdentificador = if ($rawId.StartsWith("Participante")) { $rawId } else { "Participante$rawId" }
    if (-not $mapLinhasPorId.ContainsKey($chaveIdentificador)) {
        throw "ParticipanteId '$rawId' ($chaveIdentificador) nao encontrado no CSV (coluna Identificador). Nenhuma alteracao foi feita; corrija o ID informado."
    }
    $idsEsperadosMapeados[$chaveIdentificador] = $u
}

$resultados = @()

# Aplica as alteracoes na memoria
foreach ($chaveId in $idsEsperadosMapeados.Keys) {
    $u = $idsEsperadosMapeados[$chaveId]
    $linhaIdx = $mapLinhasPorId[$chaveId]
    $campos = Split-CsvLineRaw -Line $linhas[$linhaIdx]

    $notaFormatada = Format-NotaBr -Value ([double]$u.Nota)
    $comentarioTexto = [string]$u.Comentario

    $campos[$idxNota] = Format-CsvField -Value $notaFormatada
    $campos[$idxComentario] = Format-CsvField -Value $comentarioTexto
    $linhas[$linhaIdx] = [string]::Join(',', $campos)

    $resultados += [PSCustomObject]@{
        Identificador = $chaveId
        Nota          = $notaFormatada
        Comentario    = $comentarioTexto
        Aplicado      = $true
    }
}

if ($WhatIf) {
    Write-Host "Modo WhatIf: nenhuma alteracao gravada. Atualizacoes que seriam aplicadas:"
    foreach ($r in $resultados) {
        Write-Host ("WHATIF|" + $r.Identificador + "|" + $r.Nota + "|" + $r.Comentario)
    }
    Write-Host "SOLICITADOS=$($updates.Count)"
    Write-Host "APLICADOS=0 (WhatIf)"
    return
}

# Gravacao segura via arquivo temporario no mesmo diretorio
$dir = [System.IO.Path]::GetDirectoryName($fullCsvPath)
$tempFileName = [System.IO.Path]::GetFileName($fullCsvPath) + ".tmp." + [System.Guid]::NewGuid().ToString("N")
$tempFilePath = [System.IO.Path]::Combine($dir, $tempFileName)

$textoFinal = [string]::Join($eol, $linhas)
if ($temQuebraFinal) { $textoFinal += $eol }

try {
    [System.IO.File]::WriteAllText($tempFilePath, $textoFinal, $encoding)

    # Validacao interna pos-escrita no arquivo temporario
    $verifyBytes = [System.IO.File]::ReadAllBytes($tempFilePath)
    $verifyConteudoBytes = if ($hasBom) { $verifyBytes[3..($verifyBytes.Length - 1)] } else { $verifyBytes }
    $verifyConteudo = $encoding.GetString($verifyConteudoBytes)
    $verifyLinhas = $verifyConteudo -split "`r`n|`n"
    if ($temQuebraFinal -and $verifyLinhas.Length -gt 0 -and $verifyLinhas[-1] -eq '') {
        $verifyLinhas = $verifyLinhas[0..($verifyLinhas.Length - 2)]
    }

    if ($verifyLinhas.Length -ne $linhas.Length) {
        throw "Falha de verificacao: contagem de linhas no arquivo temporario ($($verifyLinhas.Length)) difere do esperado ($($linhas.Length))."
    }
    if ($verifyLinhas[0] -ne $headerOriginal) {
        throw "Falha de verificacao: cabecalho no arquivo temporario foi alterado."
    }

    # Valida cada campo atualizado na releitura
    foreach ($r in $resultados) {
        $linhaIdx = $mapLinhasPorId[$r.Identificador]
        $camposVerificados = Split-CsvLineRaw -Line $verifyLinhas[$linhaIdx]
        $notaLida = Unescape-CsvField -Raw $camposVerificados[$idxNota]
        $comentarioLido = Unescape-CsvField -Raw $camposVerificados[$idxComentario]

        if ($notaLida -ne $r.Nota) {
            throw "Falha de verificacao pos-escrita: Nota para $($r.Identificador) esperada '$($r.Nota)', mas foi lida '$notaLida'."
        }
        if ($comentarioLido -ne $r.Comentario) {
            throw "Falha de verificacao pos-escrita: Comentario para $($r.Identificador) esperado '$($r.Comentario)', mas foi lido '$comentarioLido'."
        }
    }

    # Substituicao atomica do arquivo de destino
    Move-Item -LiteralPath $tempFilePath -Destination $fullCsvPath -Force
}
catch {
    if (Test-Path -LiteralPath $tempFilePath) {
        Remove-Item -LiteralPath $tempFilePath -Force -ErrorAction SilentlyContinue
    }
    throw $_
}

# Saida estruturada e amigavel
foreach ($r in $resultados) {
    Write-Host ("APLICADO|" + $r.Identificador + "|" + $r.Nota + "|" + $r.Comentario)
}

Write-Host "SOLICITADOS=$($updates.Count)"
Write-Host "APLICADOS=$($resultados.Count)"
Write-Host "CSV atualizado com sucesso: $fullCsvPath"
