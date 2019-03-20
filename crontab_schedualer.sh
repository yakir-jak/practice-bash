#/bin/bash

###########################################################################################
#
# Created By : Yakir BST
# Purpose : Tasks Schedualer 
# Date : Sat Mar 16 11:45:18 IST 2019
# Version : 0.0.1
#
###########################################################################################

###Vars::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

PS3="How Often You'de Like To Execute The Command?"

###Funcs:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

f_Minute(){

	echo "  *  *  *  *  * $USER  $Command" >> /etc/crontab

}

f_Hour(){ 

	echo " 0  *  *  *  * $USER $Command" >> /etc/crontab

}

f_Day(){

	echo "Enter The Exact Hour You Want The Command To Be Execute : (0-23)"
	read Hour

	echo "  0  $Hour  *  *  * $USER  $Command"  >> /etc/crontab

}


f_Week(){

	echo "Eneter Which Day Of The Week You Want To Execute The Command : (sun,mon,tue...) "
	read -p "Day Of Week :" Day
	echo "Enter The Hour Of The Day : (0-23)"
	read -p "Hour :" Hour

	echo "  0  $Hour  *  *  $Day $User $Command" >> /etc/crontab

}


f_Month(){

	echo "Enter The Exact Time (Day And Hour) For The Command Execution : (day 1-31) (hour 0-23) "
	read -p "Day :" Day
	read -p "Hour :" Hour

	echo "  0  $Hour  $Day  *  * $USER  $Comand" >> /etc/crontab

}

f_Year(){

	echo "Enter The Time Of the Day + Month + Hour For The Command To Run : (Month 1-12) (day 1-31) (hour 0-23)"


	read -p "Month :" Month
	read -p "Day :" Day
	read -p "Hour :" Hour
	
	echo "  0  $Hour  $Day  $Month  * $USER  $Command" >> /etc/crontab

}

f_Once(){

	echo -e "To Schedual Only Once You Need To Enter The:\nMinute (0-59):\nHour (0-23) :\nDay Of Month (1-31):\nMonth (1-12) :"

	read -p "Minute :" Minute
	read -p "Hour :" Hour
	read -p "Day Of Month :" Day 
	read -p "Month :" Month

	echo "  $Minute  $Hour  $Day  $Month  * $USER  $Command" >> /etc/crontab
}
###Main::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



echo "Hello ! With This Tool You Can Schedual A Tasks And Scripts In The System !"
sleep 1
echo "Which Command You'de Like To Schedual? :"
echo "*** For Script Type Full Path --> /home/Desktop/script123 *** "

read Command

echo "GOOD ! Now Let's Schedual It :"
sleep 0.7

select i in "Every Minute" "Hourly" "Daily" "Weekly" "Monthly" "Yearly" "Only Once" "Exit"
do
	case $i in
		"Every Minute") f_Minute ;;

		"Hourly") f_Hour	;;

		"Daily") f_Day		;;

		"Weekly") f_Week	;;

		"Monthly") f_Month	;;

		"Yearly") f_Year	;;

		"Only Once") f_Once	;;

		"Exit") exit		;;
	esac

done


