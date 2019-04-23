#!bin/bash



######VARS##

f_ifconfig (){

	local format="%-16s %-16s %12s \n"


	Inets=$(ifconfig|awk '{print $1}'|grep :)

	printf "%s\n" "$line"
		printf "$format" "INET" "IP" "MAC"
	printf "%s\n" "$line"

	for i in $Inets
		do


			Ip=$(ifconfig|grep 'inet '|awk '{print $2}')
			Mac=$(ifconfig|grep ether|awk '{print $2}')

			   if [[ $IP == "" ]];then
                                 IP="#### NONE ####"
                         fi
                         if [[ $MAC == "" ]];then
                                  MAC="#### NONE ####"
                         fi


         
			printf "$format" "$i" "$Ip" "$Mac"
		


done

printf "%s\n" "$line"

}


f_ifconfig














: '

FName=$(ifconfig|awk '{print $1}'|grep :|sed -n '1p')
SName=$(ifconfig|awk '{print $1}'|grep :|sed -n '2p')
TName=$(ifconfig|awk '{print $1}'|grep :|sed -n '3p')

Mac=$(ifconfig|grep ether|awk '{print $2}')

FIp=$(ifconfig|grep 'inet '|awk '{print $2}'|sed -n '1p')
SIp=$(ifconfig|grep 'inet '|awk '{print $2}'|sed -n '2p')
TIp=$(ifconfig|grep 'inet '|awk '{print $2}'|sed -n '3p')




echo "$FName $FIp"
echo "$SName $SIp"
echo "$TName $TIp"

echo "MAC: $Mac"

'





