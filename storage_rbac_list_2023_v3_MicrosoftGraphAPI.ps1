# Login to Azure
# Connect-AzAccount

# Get all subscriptions
$subList = Get-AzSubscription

# Initialize an empty array to store the results
$results = @()

# Loop through each subscription
foreach ($sub in $subList) {
    Set-AzContext -Subscription $sub.Id | Out-Null
    Write-Host "Processing subscription $($sub.Name)"

    # Get all Storage accounts in the subscription
    $storageList = Get-AzStorageAccount

    # Loop through each Storage account
    foreach ($storage in $storageList) {
        Write-Host "Processing Storage account $($storage.StorageAccountName) in $($sub.Name)"
        
        # Get all role assignments for the Storage account
        $roleList = Get-AzRoleAssignment -Scope ("/subscriptions/" + $sub.Id + "/resourceGroups/" + $storage.ResourceGroupName + "/providers/Microsoft.Storage/storageAccounts/" + $storage.StorageAccountName)

        # Loop through each role assignment and add it to the results array
        foreach ($role in $roleList) {
            $result = [PSCustomObject] @{
                SubscriptionName = $sub.Name
                StorageAccountName = $storage.StorageAccountName
                RoleName = $role.RoleDefinitionName
                PrincipalName = $role.PrincipalName
                RoleType = $role.RoleDefinitionType
            }
            $results += $result
        }
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\Temp\VNET-RBAC\RBACRoles_for_Storages.csv" -NoTypeInformation

# Disconnect from Azure
# Disconnect-AzAccount
