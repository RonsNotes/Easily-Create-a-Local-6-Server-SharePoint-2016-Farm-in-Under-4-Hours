# *************************************************************************
#
# Script Name: Add DNS Records Create Organization Units and AD Users.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 12/23/2016
# 
# Description: This script configures DNS, creates OU's and adds active directory users.         
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

#TASK: DNS CONFIGURATION FOR THE REMAINING VIRTUAL MACHINES
Function Add-DNSRecords {
Add-DnsServerResourceRecordA -ZoneName "RonsNotes.training.local" -Name "SQLSvr" -IPv4Address "10.0.0.2"
Add-DnsServerResourceRecordA -ZoneName "RonsNotes.training.local" -Name "SPApp" -IPv4Address "10.0.0.3" 
Add-DnsServerResourceRecordA -ZoneName "RonsNotes.training.local" -Name "SPCache" -IPv4Address "10.0.0.4" 
Add-DnsServerResourceRecordA -ZoneName "RonsNotes.training.local" -Name "SPSearch" -IPv4Address "10.0.0.5" 
Add-DnsServerResourceRecordA -ZoneName "RonsNotes.training.local" -Name "SPWeb" -IPv4Address "10.0.0.6" 
}
Add-DNSRecords

#TASK: CREATE ORGANIZATIONAL UNITS
Function Create-OUs{
New-ADOrganizationalUnit -Name Sharepoint_Svrs -Path "DC=RonsNotes, DC=Training, DC=Local"
New-ADOrganizationalUnit -Name SQL_Svrs -Path "DC=RonsNotes, DC=Training, DC=Local"
New-ADOrganizationalUnit -Name RN_Users -Path "DC=RonsNotes, DC=Training, DC=Local"
New-ADOrganizationalUnit -Name SP_Owners -Path "OU=RN_Users, DC=RonsNotes, DC=Training, DC=Local"
New-ADOrganizationalUnit -Name SP_Members -Path "OU=RN_Users, DC=RonsNotes, DC=Training, DC=Local"
New-ADOrganizationalUnit -Name SP_Visitors -Path "OU=RN_Users, DC=RonsNotes, DC=Training, DC=Local"
New-ADOrganizationalUnit -Name SP_Designers -Path "OU=RN_Users, DC=RonsNotes, DC=Training, DC=Local"
New-ADOrganizationalUnit -Name SP_Approvers -Path "OU=RN_Users, DC=RonsNotes, DC=Training, DC=Local"
New-ADOrganizationalUnit -Name Svc_Accounts -Path "OU=RN_Users, DC=RonsNotes, DC=Training, DC=Local"
New-ADOrganizationalUnit -Name SQLDba -Path "DC=RonsNotes, DC=Training, DC=Local"
}
Create-OUs

#TASK: ADDING ACTIVE DIRECTORY USERS
Function Create-AdUserAccounts {
$Password = (ConvertTo-SecureString -AsPlainText "Passw0rd" -Force )
$SvcAccountOU = "OU=SVC_Accounts,OU=RN_Users,DC=RonsNotes, DC=Training, DC=Local"

New-ADUser -Name SVC_Farm -SamAccountName SVC_Farm -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name SVC_WebSvcAccount -SamAccountName SVC_WebSvcAccount -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name SVC_App -SamAccountName SVC_App -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name SVC_Profile -SamAccountName SVC_Profile -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name SVC_Search -SamAccountName SVC_Search -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name SVC_Installation -SamAccountName SVC_Installation -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name SVC_Sync -SamAccountName SVC_Sync -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name SVC_Content -SamAccountName SVC_Content -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name SVC_superReader -SamAccountName SVC_superReader -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name SVC_Unattend -SamAccountName SVC_Unattend -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name SVC_DBA -SamAccountName SVC_DBA -AccountPassword $Password  -ChangePasswordAtLogon $false -Path $SvcAccountOU -Enabled $true
New-ADUser -Name Designer_Bobbie -SamAccountName Designer_Bobbie -AccountPassword $Password  -ChangePasswordAtLogon $false -Path "OU=SP_Designers,OU=RN_Users,DC=RonsNotes, DC=Training, DC=Local"  -Enabled $true
New-ADUser -Name Approver_Kate -SamAccountName Approver_Kate -AccountPassword $Password  -ChangePasswordAtLogon $false -Path "OU=SP_Approvers,OU=RN_Users,DC=RonsNotes, DC=Training, DC=Local"  -Enabled $true
New-ADUser -Name Member_Sam -SamAccountName Member_Sam -AccountPassword $Password  -ChangePasswordAtLogon $false -Path "OU=SP_Members,OU=RN_Users,DC=RonsNotes, DC=Training, DC=Local"  -Enabled $true
New-ADUser -Name Owner_Ron -SamAccountName Owner_Ron -AccountPassword $Password  -ChangePasswordAtLogon $false -Path "OU=SP_Owners,OU=RN_Users,DC=RonsNotes, DC=Training, DC=Local"  -Enabled $true
New-ADUser -Name Visitor_Carlos -SamAccountName Visitor_Carlos -AccountPassword $Password  -ChangePasswordAtLogon $false -Path "OU=SP_Visitors,OU=RN_Users,DC=RonsNotes, DC=Training, DC=Local"  -Enabled $true
New-ADUser -Name SQLDba -SamAccountName SQLDba -AccountPassword $Password  -ChangePasswordAtLogon $false -Path "OU=SQLDba,DC=RonsNotes, DC=Training, DC=Local"  -Enabled $true
}
Create-AdUserAccounts