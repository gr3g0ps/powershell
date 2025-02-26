$servers = Get-ADComputer -SearchBase "OU=XXX,DC=external,DC=example,DC=com" -properties * -filter 'OperatingSystem -like "*Server*"' | select Name
$array = @()

foreach ($server in $servers) {

    $LocalAdmins=Invoke-Command -ComputerName $server.Name -ScriptBlock {net localgroup administrators}

    $LocalAdmins = $LocalAdmins.Split([Environment]::NewLine) | ? { $_ -ne "" }

    foreach ($user in $LocalAdmins)

    {

    $LocalUser=$user

    $Properties=[ordered]@{'ComputerName'=$server;'User'=$LocalUser}

    $array += New-Object -TypeName PSObject -Property $Properties

    }

 }

$output = $array | Where-Object { $_ -notlike '*-------*'}| Where-Object { $_ -notlike '*Alias name*'} | Where-Object { $_ -notlike '*The command completed successfully.*'} | Where-Object { $_ -notlike '*Comment*'} | Where-Object { $_ -notlike '*Members*'}
$output | export-csv C:\Temp\LocalAdmins_export.csv -NoTypeInformation