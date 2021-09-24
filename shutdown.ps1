# Shutdown Script that is called by a task


function Stop-MySelf () {
    Connect-AzAccount -Identity
    $instance = Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
    $name = $instance.compute.name
    $rg = $instance.compute.resourceGroupName
    Stop-AzVM -Name $name -ResourceGroupName $rg

}


if ((Get-Module -ListAvailable -Name Az.Accounts) -and (Get-Module -ListAvailable -Name Az.Compute)) {
    Stop-MySelf
} 
else {
    install-module -name Az.Accounts
    install-module -name Az.Compute
    Stop-MySelf
}

