Connect-AzAccount

$fileUri = @("https://raw.githubusercontent.com/henrikmotzkus/CSE-AzureVMShutdown/main/installscript.ps1",
"https://raw.githubusercontent.com/henrikmotzkus/CSE-AzureVMShutdown/main/shutdown.ps1")

$settings = @{"fileUris" = $fileUri};

$storageAcctName = "xxxxxxx"
$storageKey = "1234ABCD"
$protectedSettings = @{"storageAccountName" = $storageAcctName; "storageAccountKey" = $storageKey; "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File 1_Add_Tools.ps1"};

#run command
Set-AzVMExtension -ResourceGroupName "aadjoinedhostpool" `
    -Location "westeurope" `
    -VMName "vm-0" `
    -Name "buildserver1" `
    -Publisher "Microsoft.Compute" `
    -ExtensionType "CustomScriptExtension" `
    -TypeHandlerVersion "1.10" `
    -Settings $settings `
    -ProtectedSettings $protectedSettings;