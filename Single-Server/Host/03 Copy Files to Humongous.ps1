# *************************************************************************
#
# Script Name: Copy Files to Humongous.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/11/2017
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


#TASK: ENABLING GUEST SERVICES ON THE VIRTUAL MACHINE
$VMName = "Humongous"
Enable-VMIntegrationService -VMName $VMname -Name "Guest Service Interface"


#TASK: STARTING THE VIRTUAL MACHINE
$VMName = "Humongous"
$VMName | Start-VM

#Count down timer to wait for machine to fully start
function CountdownTimer{
$x = 2*60
$length = $x / 100
while($x -gt 0) {
  $min = [int](([string]($x/60)).split('.')[0])
  $text = " " + $min + " minutes " + ($x % 60) + " seconds left"
  Write-Progress "Pausing Script" -status $text -perc ($x/$length)
  start-sleep -s 1
  $x--
}
}

Write-host "***"
Write-host "***"
Write-host "***"
Write-Host "Pausing to allow the virtual machine to fully start else copy file will fail" -ForegroundColor Yellow 
CountdownTimer 
Write-host "***"
Write-host "***"
Write-host "***"

#TASK: COPYING FILES TO THE VIRTUAL MACHINE
Function CopyFiles-Humongous {
$VMName = "Humongous"
$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\Humongous Scripts'
$CSS
foreach ($s in $CSS){

Copy-VMFile $VMName -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\Humongous Scripts\$s" -DestinationPath c:\ -CreateFullPath -Force
}

Copy-VMFile  Humongous -FileSource Host -SourcePath C:\RonsNotes\ISOs\Sharepoint2016\officeserver.img -DestinationPath c:\ -CreateFullPath -Force

} #End
CopyFiles-Humongous