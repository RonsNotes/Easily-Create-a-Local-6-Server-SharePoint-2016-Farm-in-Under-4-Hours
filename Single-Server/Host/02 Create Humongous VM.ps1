# *************************************************************************
#
# Script Name: Create Humongous VM.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/13/2017
# 
# Description: This script will verify the correct files are in the proper location and create the humongous server virtual machine.
#              
#
# *************************************************************************

#Verify PowerShell is running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
	Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Sleep -Seconds 1
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
	exit
} #END


#TASK: VERIFYING THE CORRECT FILES ARE IN THE PROPER LOCATION
Function Test-CorrectFiles {
# Test for the moving of the correct images to the expected location else fail 

$ISOSvr2016 = Get-ChildItem C:\RonsNotes\ISOs\Server2016\ | %{$_.Name} -ErrorAction inquire # ASK
$ISOSql = Get-ChildItem C:\RonsNotes\ISOs\SQL2016\ | %{$_.Name} -ErrorAction inquire # ASK
$IMGSharePoint2016 = Get-ChildItem C:\RonsNotes\ISOs\Sharepoint2016\ | %{$_.Name} -ErrorAction inquire # ASK

If ($ISOSvr2016 -eq "14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO")
{Write-Host "Expected version of ISO for Server 2016 in expected location" -ForegroundColor Green}
Else {Write-Host "Wrong or missing Server 2016 ISO. 14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO expected Correct to continue " -ForegroundColor Red; Read-Host -Prompt "Any key to continue" }

If ($ISOSQL -eq "SQLServer2016-x64-ENU.iso")
{Write-Host "Expected version of IMG for SQLServer 2016 in expected location" -ForegroundColor Green}
Else {Write-Host "Wrong or missing SQL 2016 ISO. SQLServer2016-x64-ENU.iso expected. Correct to continue " -ForegroundColor Red ;  Read-Host -Prompt "Any key to continue"}

If ($IMGSharePoint2016 -eq "officeserver.img")
{Write-Host "Expected version of IMG for SharePoint Svr 2016 in expected location" -ForegroundColor Green}
Else {Write-Host "Wrong or missing SharePoint.IMG. officeserver.img expected. Correct to continue " -ForegroundColor Red ;  Read-Host -Prompt "Any key to continue"}

Write-host "*******"
Write-host "*******"
Write-host "*******"
Write-host "*******"

} #END
Test-CorrectFiles


#TASK: CREATE HUMONGOUS VIRTUAL MACHINE
Function Create-Humongous {
$VMName = "Humongous"
New-VHD  -Path "C:\RonsNotes\VM_Drives\Humongus\Humongus.vhdx" -SizeBytes 80GB -Dynamic
New-vm -Name $VMName -MemoryStartupBytes 4GB  -VHDPath "C:\RonsNotes\VM_Drives\Humongus\Humongus.vhdx" -BootDevice IDE -SwitchName "VMExternalNetwork" 
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
Set-vm $VMName -ProcessorCount 4 
Add-VMDvdDrive -VMNAME $VMName -ControllerNumber 1 -ControllerLocation 1 -Path C:\RonsNotes\ISOs\SQL2016\SQLServer2016-x64-ENU.iso
Start-VM  $VMName
} #END
Create-Humongous