# *************************************************************************
#
# Script Name: Add External Adapter back Three Servers.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 12/23/2016
# 
# Description: This script adds an External Network Adapter
# and attatches the SQL ISO file to the SQL VM.           
#
# *************************************************************************

#Verify PowerShell is running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
	Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Sleep -Seconds 1
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
	exit
}

$hOLD = @(Get-Content  "C:\RonsNotes\VMNames\AllVMs\AllVMs.txt" )
$VMs = $hOLD -split ","
$VMs
$VMs | Stop-vm 

$VMs | Add-VMNetworkAdapter -SwitchName VMExternalNetwork 


Set-VMDvdDrive -VMName SQLSvr -Path C:\RonsNotes\ISOs\SQL2016\SQLServer2016-x64-ENU.iso

Function DropAndCreateVirtualSwitch{
#This step prevents conflicts if the switch already exists


} #End
