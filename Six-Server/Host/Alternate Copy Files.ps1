# *************************************************************************
#
# Script Name: Alternate Copy Files.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/13/2017
# 
# Description: This script is to be used if you have a copy failure in the previous script.         
#
# *************************************************************************

#Verify PowerShell is running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
	Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Sleep -Seconds 1
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
	exit
}

Write-Host "------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "Enter the number of the VM you wish to copy the files to. If they already have been copied or if the VM is not fully running this will fail" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------------" -ForegroundColor Yellow
$a = Read-Host -Prompt "Enter 1 for DC01, 2 = SQLSvr, 3 = SPApp, 4 = SPWeb, 5 = SPCache, 6 = SPSearch"

switch ($a) 
    { 
        1 {CopyFiles-DC} 
        2 {CopyFiles-SQLSvr} 
        3 {CopyFiles-SPAPP} 
        4 {CopyFiles-SPWeb} 
        5 {CopyFiles-SPCache} 
        6 {CopyFiles-SPSearch}
      
      
    }



Function CopyFiles-DC {
$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\DC01 Scripts'
$CSS

foreach ($s in $CSS){

Copy-VMFile DC01 -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\DC01 Scripts\$s" -DestinationPath c:\ -CreateFullPath
}
} #End 


Function CopyFiles-SPAPP {
$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\SPApp Scripts'
$CSS

foreach ($s in $CSS){
Copy-VMFile SPApp -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\SPApp Scripts\$s" -DestinationPath c:\ -CreateFullPath
}
Copy-VMFile SPApp  -FileSource Host -SourcePath "C:\RonsNotes\ISOs\Sharepoint2016\officeserver.img" -DestinationPath c:\ -CreateFullPath 
} #End 


Function CopyFiles-SQLSvr {

$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\SQLSvr Scripts'
$CSS

foreach ($s in $CSS){

Copy-VMFile SQLSvr -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\SQLSvr Scripts\$s" -DestinationPath c:\ -CreateFullPath
}
} #End 

Function CopyFiles-SPCache {
$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\SPCache Scripts'

foreach ($s in $CSS){
Copy-VMFile SPCache -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\SPCache Scripts\$s" -DestinationPath c:\ -CreateFullPath;
}
Copy-VMFile SPCache -FileSource Host -SourcePath "C:\RonsNotes\ISOs\Sharepoint2016\officeserver.img" -DestinationPath c:\ -CreateFullPath 
} #End 


Function CopyFiles-SPSearch {
$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\SPSearch Scripts'

foreach ($s in $CSS){
Copy-VMFile SPSearch -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\SPSearch Scripts\$s" -DestinationPath c:\ -CreateFullPath;
}
Copy-VMFile SPSearch -FileSource Host -SourcePath "C:\RonsNotes\ISOs\Sharepoint2016\officeserver.img" -DestinationPath c:\ -CreateFullPath 
} #End 

Function CopyFiles-SPWeb {
$CSS = Get-ChildItem 'C:\RonsNotes\Script_Folders\SPWeb Scripts'

foreach ($s in $CSS){
Copy-VMFile SPWeb -FileSource Host -SourcePath "C:\RonsNotes\Script_Folders\SPWeb Scripts\$s" -DestinationPath c:\ -CreateFullPath;
}
Copy-VMFile SPWeb -FileSource Host -SourcePath "C:\RonsNotes\ISOs\Sharepoint2016\officeserver.img" -DestinationPath c:\ -CreateFullPath 
} #End 