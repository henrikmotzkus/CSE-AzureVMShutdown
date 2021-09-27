# CSE-AzureVMShutdown
Custom script extension to shutdown the Azure VM when the user shuts down the OS inside the VM.

# Problem
Azure Virtual Desktop is a popular service in the Azure cloud. User are using virtual machines (VMs) for their daily work. When a user diconnects from the VM or shuting down th VM from inside the OS. The corresponding resource will not be shut down too.

Installing this custom script extension on the VMS will place a script in the VM that shuts down the Azure resource when the user clicks on the shut down button. 

