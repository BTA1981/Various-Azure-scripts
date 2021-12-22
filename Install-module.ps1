$installedModules = Get-InstalledModule
if ($installedModules.Name -notmatch "Az") {
    Install-Module Az -Force -AllowClobber
}

# Connect-AzAccount
# Select-AzSubscription -SubscriptionId SUBSCRIPTION ID | Set-AzContext
