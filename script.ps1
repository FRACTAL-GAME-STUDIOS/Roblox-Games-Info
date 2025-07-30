# script-summary.ps1
$file    = "modelup_history.txt"
$out     = "modelup_summary.csv"

# 1. Prepare the CSV (header)
if (Test-Path $out) { Remove-Item $out }
"commit,timestamp,upVotes,downVotes" | Out-File -FilePath $out -Encoding utf8

# 2. Process line by line
$commit    = ""
$timestamp = ""
$upVotes   = ""
$downVotes = ""

Get-Content $file | ForEach-Object {
    # Capture the commit hash
    if ($_ -match '===\s*([0-9a-f]+)\s*===') {
        $commit = $matches[1]
    }
    # Capture timestamp
    elseif ($_ -match '"timestamp":\s*"([^"]+)"') {
        $timestamp = $matches[1]
    }
    # Capture upVotes
    elseif ($_ -match '"upVotes":\s*(\d+)') {
        $upVotes = $matches[1]
    }
    # Capture downVotes and write the row
    elseif ($_ -match '"downVotes":\s*(\d+)') {
        $downVotes = $matches[1]
        "$commit,$timestamp,$upVotes,$downVotes" | Out-File -FilePath $out -Append -Encoding utf8
    }
}

Write-Output "✅ Summary exported to .\$out"
