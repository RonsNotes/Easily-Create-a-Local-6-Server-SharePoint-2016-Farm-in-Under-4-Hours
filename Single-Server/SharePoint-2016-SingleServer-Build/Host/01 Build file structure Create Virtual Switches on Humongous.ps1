# *************************************************************************
#
# Script Name: Build file structure Enable Enhanced Mode Create Virtual Switches.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 12/21/2016
# 
# Description: This script enables Enhanced Session Mode, creates virtual switches,
# and builds the file structure.
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

#TASK: ENABLE ENHANCED MODE IN HYPER-V
Set-VMhost -EnableEnhancedSessionMode $TRUE 

#TASK: CREATE VIRTUAL SWITCHES
Function Create-vmSwitches{ 
$ExistSwitchPrivate  = get-VMSwitch -SwitchType Private -Name "VMPrivateNetwork" -ErrorAction SilentlyContinue

If (!($ExistSwitchPrivate)) {
New-VMSwitch "VMPrivateNetwork" -SwitchType Private 
}

$ExistExternalSwitch =  Get-VMSwitch -Name "VMExternalNetwork" -SwitchType External -ErrorAction SilentlyContinue
$ExistExternalSwitch
$NAdapterName = Get-NetAdapter -Physical 
If (!($ExistExternalSwitch)) {
New-VMSwitch -Name "VMExternalNetwork" -NetAdapterName $NAdapterName.Name
}
}#End

Create-vmSwitches

#TASK: BUILD THE FILE STRUCTURE
Function Build-FileStructure{

If(!( Test-Path c:\RonsNotes\ISOs\Server2016\)){
New-Item C:\RonsNotes\ISOs\Server2016\ -ItemType directory -ErrorAction SilentlyContinue}

If(!( Test-Path c:\RonsNotes\ISOs\SQL2016\)){
New-Item C:\RonsNotes\ISOs\SQL2016\ -ItemType directory -ErrorAction SilentlyContinue}

If(!( Test-Path c:\RonsNotes\ISOs\Sharepoint2016\)){
New-Item C:\RonsNotes\ISOs\Sharepoint2016\ -ItemType directory -ErrorAction SilentlyContinue}

If(!( Test-Path c:\RonsNotes\Labs\)){
New-Item C:\RonsNotes\Labs\ -ItemType directory -ErrorAction SilentlyContinue}

If(!( Test-Path c:\RonsNotes\Script_Folders\)){
New-Item C:\RonsNotes\Script_Folders\ -ItemType directory -ErrorAction SilentlyContinue}

#Upon completion, File Explorer will be open showing the RonsNotes folder contents.
ii C:\RonsNotes
} #End
Build-FileStructure

Write-Host " Copy the ISOs and Office.IMG files and the scripts to the correct location as explained in the documentation" -ForegroundColor Yellow