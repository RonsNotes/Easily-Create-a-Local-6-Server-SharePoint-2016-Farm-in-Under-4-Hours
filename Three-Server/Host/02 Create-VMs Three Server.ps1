﻿# *************************************************************************
#
# Script Name: Create-VMs Three Server.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/13/2017
# 
# Description: This script tests for the moving of the correct images to the expected location, creates three virtual machines and enables guest services.
# Then the script starts the VMs and opens Hyper-V Manager.            
#
# *************************************************************************

#Verify PowerShell is running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
	Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Sleep -Seconds 1
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
	exit
}


#The following three code blocks create the virtual machines.
#TASK: CREATE DC01
Function Create-VMDC01 {
$VMName = "DC01"
$VHDPath = "C:\RonsNotes\VM_Drives\DomainControler\ThreeServer\DC01.vhdx"
New-VHD  -Path $VHDPath -SizeBytes 40GB -Dynamic
New-vm -Name $VMName -MemoryStartupBytes 1GB  -VHDPath $VHDPath -BootDevice IDE -SwitchName "VMExternalNetwork"
#Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $True
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
}
Create-VMDC01


#TASK: CREATE SPAPP
Function Create-SPApp {
$VMName = "SPApp"
$VHDPath = "C:\RonsNotes\VM_Drives\SharePoint_Servers\SharePoint_AppServer\ThreeServer\SPApp.vhdx"
New-VHD  -Path $VHDPath -SizeBytes 40GB -Dynamic

New-vm -Name $VMName  -MemoryStartupBytes 2GB  -VHDPath $VHDPath -BootDevice IDE -SwitchName "VMExternalNetwork" 
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $True
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
Set-VMProcessor -VMName $VMName -Count 4
}
Create-SPApp



#TASK: CREATE SQLSVR
Function Create-SQLSvr {
$VMName = "SQLSvr"
$VHDPath = "C:\RonsNotes\VM_Drives\SQL_Servers\ThreeServer\SQLSvr.vhdx"
New-VHD  -Path $VHDPath -SizeBytes 40GB -Dynamic

New-vm -Name $VMName -MemoryStartupBytes 2GB  -VHDPath $VHDPath -BootDevice IDE -SwitchName "VMExternalNetwork"
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $True
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
}
Create-SQLSvr

#TASK: ENABLING GUEST SERVICES ON EACH OF THE VIRTUAL MACHINES
$VMs = @('dc01','SPApp','SQLSvr')
Foreach ($VM in $Vms){
Enable-VMIntegrationService -VMName $Vm -Name "Guest Service Interface"
}

#TASK: STARTING ALL VIRTUAL MACHINES
$Vms | Start-VM 


Read-host -Prompt "Press any key to exit" 
#Start Hyper-V manager 
virtmgmt.msc




