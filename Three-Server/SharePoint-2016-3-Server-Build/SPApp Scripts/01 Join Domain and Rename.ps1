# *************************************************************************
#
# Script Name: Join Domain and Rename
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 12/23/2016
# 
# Description: This script joins the domain and renames the virtual machine.         
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

#TASK: RENAME THE VIRTUAL MACHINE AND JOIN THE DOMAIN
$PCName = $env:COMPUTERNAME
$DomainName = "RonsNotes.Training.Local"
Add-Computer -ComputerName $PCName -DomainName $DomainName -NewName SPApp -Credential RonsNotes\Student -Force -Restart 