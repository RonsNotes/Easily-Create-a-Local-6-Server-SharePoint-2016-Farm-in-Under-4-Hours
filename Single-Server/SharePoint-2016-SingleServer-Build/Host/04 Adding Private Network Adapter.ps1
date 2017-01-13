# *************************************************************************
#
# Script Name: Adding Private Network Adapter
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/11/2017
# 
# Description: This script  will shut down the virtual machine, add a private network adapter, then restart the virtual machine.         
#
#
# *************************************************************************

#Verify PowerShell is running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
	Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Sleep -Seconds 1
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
	exit
}

#TASK: ADDING PRIVATE NETWORK ADAPTER
$VMName = "Humongous"
$VMName | Stop-VM
$VMName | Add-VMNetworkAdapter -SwitchName VMPrivateNetwork
$VMName | Start-VM