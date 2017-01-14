# *************************************************************************
#
# Script Name: Change adapters copy SharePoint image.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/13/2017
# 
# Description: This script changes network adapters and copies files to individual virtual machines.           
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

#Count down timer to wait for machines to fully start
function CountdownTimer{
$x = 3*60
$length = $x / 100
while($x -gt 0) {
  $min = [int](([string]($x/60)).split('.')[0])
  $text = " " + $min + " minutes " + ($x % 60) + " seconds left"
  Write-Progress "Pausing Script" -status $text -perc ($x/$length)
  start-sleep -s 1
  $x--
}
}

#Create an array of the virtual machine names
$VMs = @('dc01','SPApp','SPcache','SPSearch','SPweb','SQLSvr')

#TASK: SHUT DOWN ALL VIRTUAL MACHINES
$VMs | Stop-vm 

#TASK: REMOVING EXTERNAL NETWORK ADAPTER
$Vms | Remove-VMNetworkAdapter

#TASK: ADDING PRIVATE NETWORK ADAPTER
$VMs | Add-VMNetworkAdapter -SwitchName VMPrivateNetwork 

#TASK: STARTING ALL VIRTUAL MACHINES
$VMs | Start-VM

#Countdown timer to wait for the machines to fully start. Includes a prompt to press any key once the Domain Controller and all other machines are up.
Write-host "***"
Write-host "***"
Write-host "***"
Write-Host "Pausing to allow VMs to fully start else copy file will fail" -ForegroundColor Yellow 
CountDownTimer 
Write-host "***"
Write-host "***"
Write-host "***"
Read-host -Prompt "The Domain Controller is the slowest VM to start. Make sure the log on screen is available in the DC before proceeding. Once confirmed Enter to continue" 


#TASK: COPYING FILES TO INDIVIDUAL VIRTUAL MACHINES
$SPVMs = @('SPApp','SPcache','SPSearch','SPweb')
$Spvms

ForEach ($s in $SPVMs){
Copy-VMFile  $s -FileSource Host -SourcePath "C:\RonsNotes\ISOs\Sharepoint2016\officeserver.img" -DestinationPath c:\ -CreateFullPath 
}

$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\DC01 Scripts'
$CSS

foreach ($s in $CSS){

Copy-VMFile DC01 -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\DC01 Scripts\$s" -DestinationPath c:\ -CreateFullPath
}

$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\SPApp Scripts'
$CSS

foreach ($s in $CSS){

Copy-VMFile SPApp -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\SPApp Scripts\$s" -DestinationPath c:\ -CreateFullPath
}

$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\SPCache Scripts'
$CSS

foreach ($s in $CSS){

Copy-VMFile SPCache -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\SPCache Scripts\$s" -DestinationPath c:\ -CreateFullPath
}

$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\SPSearch Scripts'
$CSS

foreach ($s in $CSS){

Copy-VMFile SPSearch -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\SPSearch Scripts\$s" -DestinationPath c:\ -CreateFullPath
}

$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\SPWeb Scripts'
$CSS

foreach ($s in $CSS){

Copy-VMFile SPWeb -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\SPWeb Scripts\$s" -DestinationPath c:\ -CreateFullPath
}

$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\SQLSvr Scripts'
$CSS

foreach ($s in $CSS){

Copy-VMFile SQLSvr -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\SQLSvr Scripts\$s" -DestinationPath c:\ -CreateFullPath
}

#Prompt to press any key to exit once files have successfully been copied to the appropriate machines
Read-Host "Press any key to exit"