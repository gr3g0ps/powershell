# Install and import the Az module if not already installed
# Install-Module -Name Az -Force -AllowClobber
# Import-Module Az -Force -AllowClobber

# Specify the CSV file path
$csvFilePath = "C:\Temp\SQL Servers List\SQLServersList.csv"

# Get all Azure subscriptions
$subscriptions = Get-AzSubscription

# Create an array to store SQL Server information
$sqlServerInfo = @()

foreach ($subscription in $subscriptions) {
    # Select the current subscription
    Set-AzContext -SubscriptionId $subscription.Id

    Write-Host "Listing SQL Servers in subscription: $($subscription.Name)"

    # Get all SQL servers in the current subscription
    $sqlServers = Get-AzSqlServer

    foreach ($sqlServer in $sqlServers) {
        $sqlServerInfo += [PSCustomObject]@{
            'SQLServerName'       = $sqlServer.ServerName
            'ResourceGroup'       = $sqlServer.ResourceGroupName
            'SubscriptionID'      = $sqlServer.SubscriptionId
            'AdminLogin'          = $sqlServer.AdministratorLogin
            'ServerVersion'       = $sqlServer.ServerVersion
            'Location'            = $sqlServer.Location
            'Tags'                = $sqlServer.Tags -join ';'
        }

        Write-Host "  SQL Server Name: $($sqlServer.ServerName)"
        Write-Host "    Resource Group: $($sqlServer.ResourceGroupName)"
        Write-Host "    Subscription ID: $($sqlServer.SubscriptionId)"
        Write-Host "    Server Admin Login: $($sqlServer.AdministratorLogin)"
        Write-Host "    Server Version: $($sqlServer.ServerVersion)"
        Write-Host "    Location: $($sqlServer.Location)"
        Write-Host "    Tags: $($sqlServer.Tags)"
        Write-Host ""
    }
}

# Export the SQL Server information to a CSV file
$sqlServerInfo | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "CSV export completed. File saved to: $csvFilePath"
