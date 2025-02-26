$folders = Get-Content -Path $PSScriptRoot\folders.txt
$servers = Get-Content -Path $PSScriptRoot\servers.txt

$hits = @()

foreach($s in $servers) {
    Write-Host "Querying" $s -BackgroundColor Cyan -ForegroundColor Black
    $drives = Invoke-Command -ComputerName $s -ScriptBlock {gdr -PSProvider 'FileSystem'}
    foreach($d in $drives) {
        Write-Host "Searching $d..." -ForegroundColor Yellow
        foreach($f in $folders) {
            $hits += Get-ChildItem -Recurse -Filter $f -Directory -ErrorAction SilentlyContinue -Path $("\\" + $s + "\" + $d.Name + "$") | select FullName
        }
    }

    foreach($h in $hits) {
    Get-ChildItem $h.FullName | Select Fullname,@{Name="Owner";Expression={ (Get-Acl $_.FullName).Owner }} | Export-Csv -Path $PSScriptRoot\output.csv -Append
    $hits = @()
    }
}
