#Connect-AzAccount -DeviceCode

$Subscriptions = Get-AzSubscription
$data = foreach ($sub in $Subscriptions) {
Write-Host Working with Subscription $sub.Name 
$null = Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext
Get-AzStorageAccount | Set-AzStorageAccount -MinimumTlsVersion TLS1_2 @{Name = 'TLSVersion'; Expression = {$_.MinimumTlsVersion}}
}
   $data | Export-Csv -Path C:\storage_tls12.csv -NoTypeInformation ‘
