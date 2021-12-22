Function CreateWVDHostPools {
    Param (
        [Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $False)]
        [String]$ResourceGroupName,
        [Parameter(Mandatory = $True, Position = 2, ValueFromPipeline = $False)]
        [string[]]$HostPools
    )
 
    $Location = "WestEurope"
 
    $ExistingResourceGroups = Get-AzResourceGroup
 
    if ($ExistingResourceGroups.ResourceGroupName -notcontains $ResourceGroupName) {
 
        Write-Host "ResourceGroup $($ResourceGroupName) does not exist. Creating new ResourceGroup" -ForegroundColor Green
 
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
        
    }
    else {
        Write-Host "ResourceGroup $($ResourceGroupName) already exists" -ForegroundColor Yellow
    }
 
    foreach ($HostPoolName in $HostPools){
 
    New-AzWvdWorkspace -ResourceGroupName $ResourceGroupName `
                        -Name "$($HostPoolName)-Workspace" `
                        -Location $Location `
                        -FriendlyName "$($HostPoolName)-Workspace" `
                        -ApplicationGroupReference $null `
                        -Description "$($HostPoolName)-Workspace"
 
    New-AzWvdHostPool   -Name $HostPoolName `
                        -ResourceGroupName $ResourceGroupName `
                        -Location $Location `
                        -HostPoolType Pooled `
                        -PreferredAppGroupType 'Desktop' `
                        -LoadBalancerType DepthFirst `
                        -MaxSessionLimit '12' `
    
    $HostPool = Get-AzWvdHostPool -Name $HostPoolName -ResourceGroupName $ResourceGroupName
 
    New-AzWvdApplicationGroup   -Name "$($HostPoolName)-DAG" `
                                -ResourceGroupName $ResourceGroupName `
                                -ApplicationGroupType 'Desktop' `
                                -HostPoolArmPath $HostPool.id `
                                -Location $Location
 
    $DAG = Get-AzWvdApplicationGroup -Name "$($HostPoolName)-DAG" -ResourceGroupName $ResourceGroupName
 
    Register-AzWvdApplicationGroup  -ResourceGroupName $ResourceGroupName `
                                    -WorkspaceName "$($HostPoolName)-Workspace" `
                                    -ApplicationGroupPath $DAG.id
    
    }
}
# Example
# CreateWVDHostPools -ResourceGroupName Demo -HostPools Demo
