# *************************************************************************
#
# Script Name: Create-VMs.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/13/2017
# 
# Description: This script tests for the moving of the correct images to the expected location, creates six virtual machines and enables guest services.
# Then the script starts the VMs and opens Hyper-V Manager.            
#
# *************************************************************************

#Verify PowerShell is running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
	Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Sleep -Seconds 1
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
	exit
}

#TASK: VERIFYING THE CORRECT FILES ARE IN THE PROPER LOCATION
Function Test-CorrectFiles {
$ISOSvr2016 = Get-ChildItem C:\RonsNotes\ISOs\Server2016\ | %{$_.Name} -ErrorAction SilentlyContinue
$ISOSql = Get-ChildItem C:\RonsNotes\ISOs\SQL2016\ | %{$_.Name} -ErrorAction SilentlyContinue
$IMGSharePoint2016 = Get-ChildItem C:\RonsNotes\ISOs\Sharepoint2016\ | %{$_.Name} -ErrorAction SilentlyContinue

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

}
Test-CorrectFiles

#The following six code blocks create the virtual machines.
#TASK: CREATE DC01
Function Create-VMDC01 {
$VMName = "DC01"
$VHDPath = "C:\RonsNotes\VM_Drives\DomainController\First\DC01.vhdx"
New-VHD  -Path $VHDPath -SizeBytes 40GB -Dynamic
New-vm -Name $VMName -MemoryStartupBytes 1GB  -VHDPath $VHDPath -BootDevice IDE -SwitchName "VMExternalNetwork"
#Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $True
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
}
Create-VMDC01


#TASK: CREATE SPAPP
Function Create-SPApp {
$VMName = "SPApp"
$VHDPath = "C:\RonsNotes\VM_Drives\SharePoint_Servers\SharePoint_AppServer\SPApp.vhdx"
New-VHD  -Path $VHDPath -SizeBytes 40GB -Dynamic

New-vm -Name $VMName  -MemoryStartupBytes 1.6GB  -VHDPath $VHDPath -BootDevice IDE -SwitchName "VMExternalNetwork" 
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $False
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
Set-VMProcessor -VMName $VMName -Count 4
}
Create-SPApp

#TASK: CREATE SPCACHE
Function Create-SPCache {
$VMName = "SPCache"
$VHDPath = "C:\RonsNotes\VM_Drives\SharePoint_Servers\SharePoint_CacheServer\SPCache.vhdx"
New-VHD  -Path $VHDPath -SizeBytes 40GB -Dynamic

New-vm -Name $VMName -MemoryStartupBytes 1.6GB  -VHDPath $VHDPath -BootDevice IDE -SwitchName "VMExternalNetwork"
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $False
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
Set-VMProcessor -VMName $VMName -Count 4
}
Create-SPCache

#TASK: CREATE SPSEARCH
Function Create-SPSearch {
$VMName = "SPSearch"
$VHDPath = "C:\RonsNotes\VM_Drives\SharePoint_Servers\SharePoint_SearchServer\SPSearch.vhdx"
New-VHD  -Path $VHDPath -SizeBytes 40GB -Dynamic

New-vm -Name $VMName -MemoryStartupBytes 1.6GB  -VHDPath $VHDPath -BootDevice IDE -SwitchName "VMExternalNetwork"
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $False
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
Set-VMProcessor -VMName $VMName -Count 4
}
Create-SPSearch

#TASK: CREATE SPWEB
Function Create-SPWeb {
$VMName = "SPWeb"
$VHDPath = "C:\RonsNotes\VM_Drives\SharePoint_Servers\SharePoint_WebServer\SPWeb.vhdx"
New-VHD  -Path $VHDPath -SizeBytes 40GB -Dynamic

New-vm -Name $VMName -MemoryStartupBytes 1.6GB  -VHDPath $VHDPath -BootDevice IDE -SwitchName "VMExternalNetwork"
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $False
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
Set-VMProcessor -VMName $VMName -Count 4
}
Create-SPWeb

#TASK: CREATE SQLSVR
Function Create-SQLSvr {
$VMName = "SQLSvr"
$VHDPath = "C:\RonsNotes\VM_Drives\SQL_Servers\First\SQLSvr.vhdx"
New-VHD  -Path $VHDPath -SizeBytes 40GB -Dynamic

New-vm -Name $VMName -MemoryStartupBytes 1GB  -VHDPath $VHDPath -BootDevice IDE -SwitchName "VMExternalNetwork"
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $True
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path C:\RonsNotes\ISOs\Server2016\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO
}
Create-SQLSvr

#TASK: ENABLING GUEST SERVICES ON EACH OF THE VIRTUAL MACHINES
$VMs = @('dc01','SPApp','SPcache','SPSearch','SPweb','SQLSvr')
Foreach ($VM in $Vms){
Enable-VMIntegrationService -VMName $Vm -Name "Guest Service Interface"
}

#TASK: STARTING ALL VIRTUAL MACHINES
$Vms | Start-VM 


Read-host -Prompt "Press Enter to exit" 
#Start Hyper-V Manager 
virtmgmt.msc




