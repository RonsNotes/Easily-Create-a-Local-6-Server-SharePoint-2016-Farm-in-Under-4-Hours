# *************************************************************************
#
# Script Name: Add External Adapter back.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 12/23/2016
# 
# Description: This script creates an array of virtual machine names, adds an External Network Adapter,
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
#Create an array of virtual machine names
$VMs = @('dc01','SPApp','SPcache','SPSearch','SPweb','SQLSvr')

#TASK: SHUT DOWN ALL VIRTUAL MACHINES
$VMs | Stop-vm 

#TASK: ADDING AN EXTERNAL NETWORK ADAPTER
$VMs | Add-VMNetworkAdapter -SwitchName VMExternalNetwork

#TASK: ATTATCH SQL SERVER 2016 ISO
Set-VMDvdDrive -VMName SQLSvr -Path C:\RonsNotes\ISOs\SQL2016\SQLServer2016-x64-ENU.iso
