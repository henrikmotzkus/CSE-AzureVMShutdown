# Shutdown Script that is called by a task


function Stop-MySelf () {
    Connect-AzAccount -Identity
    $instance = Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
    $name = $instance.compute.name
    $rg = $instance.compute.resourceGroupName
    $sub = $instance.compute.subscriptionId
    Select-AzSubscription -Subscription "a70316fd-0761-4d1d-aa6a-743ef1133f7a"
    Stop-AzVM -Name $name -ResourceGroupName $rg -Force -

}

if ((Get-Module -ListAvailable -Name Az.Accounts) -and (Get-Module -ListAvailable -Name Az.Compute)) {
    Stop-MySelf
} 
else {
    install-module -name Az.Accounts
    install-module -name Az.Compute
    Stop-MySelf
}

