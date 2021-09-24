Connect-AzAccount

$fileUri = @("https://raw.githubusercontent.com/henrikmotzkus/CSE-AzureVMShutdown/main/installscript.ps1",
"https://raw.githubusercontent.com/henrikmotzkus/CSE-AzureVMShutdown/main/shutdown.ps1")

$settings = @{"fileUris" = $fileUri};

$protectedSettings = @{"commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File installscript.ps1"};

#run command
Set-AzVMExtension -ResourceGroupName "aadjoinedhostpool" -Location "westeurope" -VMName "vm-0" -Name "CSEShutdown" -ExtensionType "CustomScriptExtension" -Settings $settings -Publisher "Microsoft.Compute" -TypeHandlerVersion "1.10" -ProtectedSettings $protectedSettings
    