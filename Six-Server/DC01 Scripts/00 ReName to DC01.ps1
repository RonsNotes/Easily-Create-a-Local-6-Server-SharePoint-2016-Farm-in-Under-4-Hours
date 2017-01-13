# *************************************************************************
#
# Script Name: ReName to DC01.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 12/23/2016
# 
# Description: This script renames DC01 and restarts the VM.          
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

#TASK: RENAMING DC01
Rename-Computer -NewName DC01 -Restart