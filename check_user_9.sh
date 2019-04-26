#/bin/bash

###########################################################################################
#
# Created By : Yakir BST
# Purpose : 
# Date : Mon Apr 22 16:38:49 IDT 2019
# Version : 0.0.1
#
###########################################################################################
echo "this script will check if a user name exist and guve all details about : "

sleep 1

echo "Type user name you want to check :"

read user

details=$(id $user)

uid=$(id -u $user)

all_uid=$(cat /etc/passwd |awk -F : '{print $3}')

exist=0
for i in $all_uid;
do

		if [ $i = $uid ] ; then

			echo " The user $user exist !!"
			
			exist=1			

			break

#		else 	
#			echo "user $user is not exist !!"

		fi 2> /dev/null

done

if [ $uid -ge 500 -a $uid -le 1000 ]; then

	echo "$details"

	else exit

fi 2> /dev/null
