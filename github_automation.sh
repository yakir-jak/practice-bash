#/bin/bash

###########################################################################################
#
# Created By : Yakir BST
# Purpose : Upload Files Automatically To Git Hub 
# Date : Wed Feb 12 14:18:32 IST 2020
# Version : 0.0.1
#
###########################################################################################

######### VARS ############

Project_name=P
Script_name=S
date=DATE
PS3="What You Want to Do ? "

######## FUNCS #############

f_create_project(){
	
	read -p "Type Name Of Project" P
	echo "Creating New Project..."

	cd /home/jak/Desktop/Linux/projects
	mkdir $P && cd $P
	git init
	git config --global user.name "yakir-jak"
	git config --global user.email "yakir6594@gmail.com"
	
	if [ $? == 0 ]; then echo "Done"
	fi
}

f_push_to_git(){

	read -p "Type The Name Of The Project You Want To Upload To Git-Hub : " P
	cd /home/jak/Desktop/Linux/projects/$P
	git add *
	git commit -m "MADE UPDATE $DATE"
	git status
	git push
}
######### MAIN ########

echo "Hello, This Is Automation Tool For Git-Hub Users...!"
select i in "Working On New Project" "Existing Project" "Exit"
do
	case $i in
		"Working On New Project") f_create_project ;;
		"Existing Project") f_push_to_git ;;
		"Exit") exit ;;
	esac
done

