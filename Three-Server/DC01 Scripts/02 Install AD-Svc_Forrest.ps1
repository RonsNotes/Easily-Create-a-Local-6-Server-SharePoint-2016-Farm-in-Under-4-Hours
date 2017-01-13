# *************************************************************************
#
# Script Name: 02 Install AD-Svc_Forrest.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/13/2017
# 
# Description: This script creates the domain and configures the forest.          
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

#TASK: CREATING THE DOMAIN
Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
$domain_Name = "RonsNotes.training.local"
$secure_string_pwd = ConvertTo-SecureString "Passw0rd" -asplaintext -Force

#TASK: CONFIGURING THE FOREST
Install-ADDSForest -DomainName $domain_Name -SkipPreChecks -InstallDns:$true -DomainNetbiosName RonsNotes -SafeModeAdministratorPassword $secure_string_pwd -Force