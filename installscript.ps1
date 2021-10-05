# Install script that creates a Task (shudownscript.ps1) when the user shuts down the OS

#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }


function Register-EventScript {
    param (
        [string] $eventToRegister, # Either Startup or Shutdown
        [string] $pathToScript,
        [string] $scriptParameters
    )
    
    $path = "$ENV:systemRoot\System32\GroupPolicy\Machine\Scripts\$eventToRegister"
    if (-not (Test-Path $path)) {
        # path HAS to be available for this to work
        New-Item -path $path -itemType Directory
    }

    # Add script to Group Policy through the Registry
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\$eventToRegister\0\0",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\$eventToRegister\0\0" |
    ForEach-Object { 
        if (-not (Test-Path $_)) {
            New-Item -path $_ -force
        }
    }

    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\$eventToRegister\0",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\$eventToRegister\0" |
    ForEach-Object {
        New-ItemProperty -path "$_" -name DisplayName -propertyType String -value "Local Group Policy" -force
        New-ItemProperty -path "$_" -name FileSysPath -propertyType String -value "$ENV:systemRoot\System32\GroupPolicy\Machine"  -force
        New-ItemProperty -path "$_" -name GPO-ID -propertyType String -value "LocalGPO" -force
        New-ItemProperty -path "$_" -name GPOName -propertyType String -value "Local Group Policy" -force
        New-ItemProperty -path "$_" -name PSScriptOrder -propertyType DWord -value 2  -force
        New-ItemProperty -path "$_" -name SOM-ID -propertyType String -value "Local" -force
    }
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\$eventToRegister\0\0",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\$eventToRegister\0\0" |
    ForEach-Object {
        New-ItemProperty -path "$_" -name Script -propertyType String -value $pathToScript -force 
        New-ItemProperty -path "$_" -name Parameters -propertyType String -value $scriptParameters -force
        New-ItemProperty -path "$_" -name IsPowershell -propertyType DWord -value 1 -force
        New-ItemProperty -path "$_" -name ExecTime -propertyType QWord -value 0 -force
    }
}

$mypath = Split-Path $MyInvocation.MyCommand.Path
$path = $mypath + "\shutdown.ps1"

$path
Register-EventScript -eventToRegister "Shutdown" -pathToScript $path

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
install-module -name Az.Accounts -Force
install-module -name Az.Compute -Force

