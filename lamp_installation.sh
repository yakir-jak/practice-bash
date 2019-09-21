#/bin/bash

###########################################################################################
#
# Created By : Yakir BST
# Purpose : LAMP Installation Script
# Date : Tue Sep 17 16:27:26 IDT 2019
# Version : 0.0.1
#
###########################################################################################

############## VARS ###############

#Os=$(cat /etc/os-release|awk -F'=' {'print $2'}|head -3|)

F=fedora
C=centos
D=debian
U=ubuntu

########### FUNCS ###################

f_Fedora(){

	echo "You Using Fedora !"
	sudo dnf update -y
	sudo dnf install -y httpd mariadb
	sudo dnf install -y python37


	if [ $? == 0 ];then
	echo "DONE !"

else echo "Have A Problem --> Check journalctl"

fi
}

f_Centos(){

echo "You Using CentOS"
	sudo yum update -y
	sudo yum install -y httpd mariadb
	sudo yum install -y centos-release-scl
	sudo yum install -y rh-python36
	sudo scl enable rh-python36 bash
	sudo yum groupinstall “Development Tools”


        if [ $? == 0 ];then
        echo "DONE !"

else echo "Have A Problem --> Check journalctl"

fi
}

f_Debian(){


	echo "You Using Debian"
	sudo apt-get update -y
	sudo apt-get install -y apache mariadb
	sudo apt-get install -y python-pip


        if [ $? == 0 ];then
        echo "DONE !"

else echo "Have A Problem --> Check journalctl"

fi
}

f_Ubuntu(){

        echo "You Using Ubuntu"
        sudo apt-get update -y
        sudo apt-get install -y apache mariadb
        sudo apt install python-pip


        if [ $? == 0 ];then
        echo "DONE !"

else echo "Have A Problem --> Check journalctl"

fi
}
#################### MAIN ################################

if cat /etc/os-release|awk -F'=' {'print $2'}|grep $F; then
	f_Fedora
elif cat /etc/os-release|awk -F'=' {'print $2'}|grep $C; then
	f_Centos
elif cat /etc/os-release|awk -F'=' {'print $2'}|grep $D; then
	f_Debian
elif cat /etc/os-release|awk -F'=' {'print $2'}|grep $U; then
	f_Ubuntu
else echo "You Usnig Unkown Distrebution" 
	fi

