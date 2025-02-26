$item = get-item '\\Server_fqdn_or_IP\Folder_name\myfile_wg.pdf'
$dst = "c:\users\$env:USERNAME\desktop\myfile_wogo.pdf"
$time=Measure-Command -Expression {Copy-Item -literalpath '\\Server_fqdn_or_IP\Folder_name\myfile_wg.pdf' '$dst'} 
$TransferRate = ($item.length/1024/1024) / $time.TotalSeconds
write-host "$TransferRate MB/Sec"

$result = New-Object -TypeName psobject -Property @{
                    Source           = $item.fullname
                    TimeTaken        = $time.TotalSeconds
                    TransferRateMBs  = $TransferRate
                    }

$result