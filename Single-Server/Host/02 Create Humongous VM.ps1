# *************************************************************************
#
# Script Name: Create Humongous VM.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/13/2017
# 
# Description: This script will verify the correct files are in the proper location and create the humongous server virtual machine.
#              
#
# *************************************************************************

#Verify PowerShell is running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
	Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Sleep -Seconds 1
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
	exit
} #END


#TASK: CREATE HUMONGOUS VIRTUAL MACHINE
$SQLISOName = Get-ChildItem -Path 'C:\ISO\SQL\SQL 2016'
Function Create-Humongous {
$VMName = "Humongous"
New-VHD  -Path "C:\RonsNotes\VM_Drives\Humongus\Humongus.vhdx" -SizeBytes 80GB -Dynamic
New-vm -Name $VMName -MemoryStartupBytes 4GB  -VHDPath "C:\RonsNotes\VM_Drives\Humongus\Humongus.vhdx" -BootDevice IDE -SwitchName "VMExternalNetwork" 
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
Set-vm $VMName -ProcessorCount 4 
Add-VMDvdDrive -VMNAME $VMName -ControllerNumber 1 -ControllerLocation 1 -Path $SQLISOName.Name
Start-VM  $VMName
} #END
Create-Humongous