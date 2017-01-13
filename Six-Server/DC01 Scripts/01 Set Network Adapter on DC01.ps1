# *************************************************************************
#
# Script Name: Set Network Adapter on DC01.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 12/23/2016
# 
# Description: This script sets the Network Adapter on the DC01 VM.         
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

#TASK: CONFIGURE NETWORK ADAPTER ON DC01
$IP = "10.0.0.1"
$MaskBits =  24 # This means subnet mask = 255.255.255.0

$Dns = "10.0.0.1"
$IPType = "IPv4"# Retrieve the network adapter that you want to configure
$NA = Get-NetAdapter | where status -EQ up
$Na.Name
# Configure the IP address and default gateway
New-NetIPAddress -InterfaceAlias $NA.Name -AddressFamily $IPType -IPAddress $IP -PrefixLength $MaskBits 
   
    `
# Configure the DNS client server IP addresses
Get-NetAdapter -Name $NA.Name | Set-DnsClientServerAddress -ServerAddresses $DNS
Ping 10.0.0.1
Ping 10.0.0.1
ipconfig