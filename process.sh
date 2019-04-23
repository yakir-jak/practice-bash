#/bin/bash

###########################################################################################
#
# Created By : Yakir BST
# Purpose : proccess managment 
# Date : Mon Apr 22 22:07:11 IDT 2019
# Version : 0.0.1
#
###########################################################################################


###VATS:::::::::::::::::::::::::::::




inp=""
Pid=""
Check_Pid=""


echo "This tool help you to manage your proccess easly (make sure to use sudo user)"

echo -e "Enter What You Want To Do : \n[1] Check Active Proccess\n[2] Kill Procces\n[3] Check PID\n[4] Exit"

read inp



###funcs###############



f_Kill(){

                read -p "Type the PID you want to kill : " Pid

        kill -9 $Pid
}


f_Check(){

        read -p "Enter Name Of Ptocces You Want To Check : " Check_Pid

        echo "The PID Of $Check_Pid is :  " 

        pgrep $Check_Pid
}


###MAIN:::::::::::::::::::::::::






if
       	[ $inp == 1 ] ; then

	ps -aux

elif
       	[ $inp == 2 ] ; then

	f_Kill
elif
        [ $inp == 3 ] ; then

        f_Check 

else	 exit

fi

sleep 1
bash /home/jak/Desktop/Linux/bash_exersizes/process.sh
