#Connect-AzAccount -DeviceCode

$Subscriptions = Get-AzSubscription
$data = foreach ($sub in $Subscriptions) {
    # suppress output on this line
    Write-Host Working with Subscription $sub.Name 
    $null = Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext
    # let Select-Object output the objects that will be collected in variable $data
    Get-AzStorageAccount | Select-Object StorageAccountName, ResourceGroupName,
                                         @{Name = 'TLSVersion'; Expression = {$_.MinimumTlsVersion}}

}

# write a CSV file containing this data
$data | Export-Csv -Path C:\AzureStorage\data.csv -NoTypeInformation
