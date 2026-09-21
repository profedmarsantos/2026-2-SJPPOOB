<#
.SYNOPSIS
  Cria um manifesto local de entradas da correcao e recusa sobrescrita.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string]$CsvPath,
    [Parameter(Mandatory = $true)] [string]$MaterialPath,
    [Parameter(Mandatory = $true)] [string]$GabaritoPath,
    [Parameter(Mandatory = $true)] [string]$OutputPath
)

$ErrorActionPreference = 'Stop'
if (Test-Path -LiteralPath $OutputPath) { throw "Manifesto ja existe; nao sobrescrever: $OutputPath" }
foreach ($path in @($CsvPath, $MaterialPath, $GabaritoPath)) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Entrada obrigatoria nao encontrada: $path" }
}

$csvRows = @(Import-Csv -LiteralPath $CsvPath -Encoding utf8)
$ids = @($csvRows | ForEach-Object { "$($_.Identificador)" } | Where-Object { $_ -match '^Participante\d+$' })
$header = (Get-Content -LiteralPath $CsvPath -Encoding utf8 -TotalCount 1)
$gabaritoFiles = @(Get-ChildItem -LiteralPath $GabaritoPath -File -Recurse | Sort-Object FullName)
$gabarito = @($gabaritoFiles | ForEach-Object {
    [ordered]@{
        caminho = $_.FullName
        sha256 = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    }
})

$manifest = [ordered]@{
    schema = 'sjppooob.correcao.manifesto.v1'
    criado_em = (Get-Date).ToString('o')
    csv = [ordered]@{
        caminho = (Resolve-Path -LiteralPath $CsvPath).Path
        sha256_antes = (Get-FileHash -LiteralPath $CsvPath -Algorithm SHA256).Hash
        cabecalho = $header
        quantidade_linhas_dados = $csvRows.Count
        ids_alvo = $ids
    }
    material = [ordered]@{
        caminho = (Resolve-Path -LiteralPath $MaterialPath).Path
        sha256 = (Get-FileHash -LiteralPath $MaterialPath -Algorithm SHA256).Hash
    }
    gabarito = $gabarito
}

$manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputPath -Encoding utf8
Write-Output "MANIFESTO_CRIADO|CAMINHO=$OutputPath|IDS_ALVO=$($ids.Count)|GABARITO_ARQUIVOS=$($gabaritoFiles.Count)"
