#/bin/bash

###########################################################################################
#
# Created By : Yakir BST
# Purpose : Interface Configeration
# Date : Fri Mar 15 15:34:34 IST 2019
# Version : 0.0.1
#
###########################################################################################


f_Iface_Configuration(){

echo "Choose An Interface You Want To Configure :"
	nmcli device|awk '{print $1}'  				#list interfaces

read Iface

echo "The Interface You Chose : $Iface"				#ask the user for interface

echo "Begin $Iface Configuration :"

echo "Type Name Of Profile :"					#ask user for profile name
read Profile

echo "Type IP Address:(10.0.0.100/24) "						#ask user for IP
read Ip

echo "Type Defaulte Getway : "					#ask user fo Default Getway
read Getway

echo "Type DNS Server :(for two or more do - 1.1.1.1 8.8.8.8) " #ask user for DNS
read Dns

echo -e "WELL DONE !\nYour Parameters Are:\nInterface : $Iface\nProfile Name : $Profile\nIP Address : $Ip\nDefault Getway : $Getway\nDNS Server : $Dns"

echo "Sure You Want To Configure $Iface ? [y,n]"
read Ans

if [ "$Ans" = "y" -o "$Ans" = "Y" -o "$Ans" = "" ] ; then        # show user parameters
	echo "***START CONFIGURATION***"

	nmcli con add type ethernet con-name $Profile ifname $Iface ip4 $Ip gw4 $Getway      # configure interface
	nmcli con mod $Profile ip4.dns $Dns                                      # add DNS server
	
	sleep 1

	echo "DONE !"

	sleep 0.5

	echo "$Iface Status :"

	nmcli connection show $Profile


else exit

fi

}



f_Iface_Configuration
