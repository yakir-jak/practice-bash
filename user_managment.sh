#/bin/bash

###########################################################################################
#
# Created By : Yakir BST
# Purpose : Create And Manage Users 
# Date : Sun Feb  9 14:06:41 IST 2020
# Version : 0.0.1
#
###########################################################################################


############ VARS ###########

U=User
G=Group
PS3="Choose What To Do? :"
########## FUNCS ########

f_add_user(){ 		# Function Create Users
	
	read -p "Type Name Of User You Want To Add : " U  #get username from the user
	adduser -d /home/$U $U	#use the user as a variable to the command"

	if [ $? == 0 ];then				 #VALIDATION WITH EXIT STATUS
		echo "Done"
#	elif [ $? == 1 ];then
#		echo "Permmission Denied"
#	elif [ $? == 9 ];then
#		echo "User Already Exist"
#	else echo "User Not Created Successfully, Need To Check The Problem"
	fi
		
}

f_user_managment(){		# Manage User Details

	read -p "Type Name Of User You Want To Manage: " U  #get username from the user
	echo "Great ! Now Choose What You Want To Do :"

	select i in "User Information" "Add To Group" "Remove From Group" "Delete User"	#use select
	do
		case $i in
			"User Information")
				echo "Last Logins :"
				last $U|tail -7|head -5	#show last login of user
				sleep 1
				echo "Groups and ID :"	
				id $U	# show id and groups belong to user
				exit ;;
			"Add To Group")
				read -p "Type Name Of The Group You Want To Add $U To (for multiple groups separate by a comma) : " G	# get from user group name
				adduser -G $G $U	# add user to group by using variables
				if [ $? == 0 ];then echo "Done"
				fi
				exit ;;
			"Remove Frome Group")
				read -p "Type Name Of Group You Want To Remove $U From (for multiple     groups separate by a comma) : " # get group name from user
				usermod -G $G $U	# remove user from group by using variables
				if [ $? == 0 ];then echo "Done"	# validation with exit status
				fi
				exit ;;
			"Delete User")
         			userdel -r $U 	# remove user with home directory

         			if [ $? == 0 ];then           # validation with exit status
                		echo "Done Successfully"
          			fi
				exit ;;

		esac
	done		


}

f_create_group(){
	read -p "Type Name Of Group You Want To Create : " G	# getting groupname from user
	groupadd $G
	if [ $? == 0 ];then echo "Done"				# validation by exit status
	fi

}


f_group_managment(){
	read -p "Type Name Of Group You Want To Use : " G
	echo "Great ! Now Choos What You Want To Do : "
	
	select i in "Create Group" "Delete Group"
	do
		case $i in
			"Create Group") 
				groupadd $G				# create group by using varaible
        			if [ $? == 0 ];then echo "Done"           # validation by exit status
        			fi
				exit ;;
			"Delete Group")
				groupdel $G				# delete the group by using variable
				if [ $? == 0 ];then echo "Done"
				fi
				exit
			       	;;
		esac
	done

}

######### MAIN #######

echo "Hello ! This Tool Will Help You To Manage Users And Groups "
sleep 0.5

select i in "Add User" "User Managment" "List All Groups" "Group Managment" "Exit" 
do
	case $i in 
		"Add User") f_add_user ;;
		"User Managment") f_user_managment ;;
		"List All Groups") cat /etc/group | awk -F ":" '{print $1}' ;;# list groups from /etc/group file
		"Group Managment") f_group_managment ;;
		"Exit") exit ;;

	esac

done
