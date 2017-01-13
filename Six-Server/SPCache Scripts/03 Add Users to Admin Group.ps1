# *************************************************************************
#
# Script Name: Add Users to Admin Group.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 12/23/2016
# 
# Description: This script adds users to the admin group.         
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

#TASK: ADDING USERS TO ADMINISTRATORS GROUP (SHAREPOINT VMS ONLY)
Function Add-SPLocalAdmins {
$group = [ADSI]("WinNT://"+$env:COMPUTERNAME+"/administrators,group")
$group.add("WinNT://$env:USERDOMAIN/svc_Farm,user")
$group.add("WinNT://$env:USERDOMAIN/svc_Sync,user")
$group.add("WinNT://$env:USERDOMAIN/svc_Installation,user")
}
Add-SPLocalAdmins