# *************************************************************************
#
# Script Name: Set Network Adapter.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/13/2017
# 
# Description: This script sets up a network adapter.         
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

#TASK: CONFIGURE NETWORK ADAPTER
$IP = "10.0.0.5"
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
Ping DC01

