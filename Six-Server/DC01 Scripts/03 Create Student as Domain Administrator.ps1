# *************************************************************************
#
# Script Name: Create Student as Domain Administrator.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/13/2017
# 
# Description: This script creates student as domain administrator and turns off the firewall.         
#
#
# *************************************************************************

#TASK: CREATE STUDENT AS DOMAIN ADMINISTRATOR
New-ADUser -SamAccountName 'Student' -AccountPassword (ConvertTo-SecureString Passw0rd -AsPlainText -Force) -UserPrincipalName 'Student' -DisplayName 'Student' -Name 'Student' -Enabled $true
Add-ADGroupMember -Identity 'Enterprise admins' Student
Add-ADGroupMember -Identity 'Domain Admins' Student

#TASK: TURN OFF THE FIREWALL
Set-NetFirewallProfile -Profile domain,Public,Private -Enabled False 