# script-summary.ps1
$file       = "modelup_history.txt"
$out        = "modelup_summary.csv"

# 1. Prepara el CSV (encabezado)
if (Test-Path $out) { Remove-Item $out }
"commit,timestamp,upVotes,downVotes" | Out-File -FilePath $out -Encoding utf8

# 2. Procesa línea a línea
$commit    = ""
$timestamp = ""
$upVotes   = ""
$downVotes = ""

Get-Content $file | ForEach-Object {
    # Captura el hash de commit
    if ($_ -match '===\s*([0-9a-f]+)\s*===') {
        $commit = $matches[1]
    }
    # Captura timestamp
    elseif ($_ -match '"timestamp":\s*"([^"]+)"') {
        $timestamp = $matches[1]
    }
    # Captura upVotes
    elseif ($_ -match '"upVotes":\s*(\d+)') {
        $upVotes = $matches[1]
    }
    # Captura downVotes y escribe la fila
    elseif ($_ -match '"downVotes":\s*(\d+)') {
        $downVotes = $matches[1]
        "$commit,$timestamp,$upVotes,$downVotes" | Out-File -FilePath $out -Append -Encoding utf8
    }
}

Write-Output "✅ Resumen exportado en .\$out"
