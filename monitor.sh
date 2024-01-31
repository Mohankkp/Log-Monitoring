#!/bin/bash
#
bbold=$(tput bold)
nnormal=$(tput sgr0)

#Create files if they dont exist
FILE=~/HW1/debug_log.csv
if [ -f "$FILE" ]; then
    echo -e "$FILE exists.Proceeding... \n"
else
    echo -e "$FILE does not exist.Creating and populating with header values \n"
    touch $FILE
    bash -c "echo -e timestamp,AlertString,1minavg,5minavg,15minavg > $FILE"
fi

FILE=~/HW1/log_monitor.csv
if [ -f "$FILE" ]; then
    echo -e "$FILE exists.Proceeding... \n"
else
    echo -e "$FILE does not exist.Creating and populating with header values \n"
    touch $FILE
    bash -c "echo -e timestamp,1minavg,5minavg,15minavg > $FILE"
fi


helpFunction()
{
   echo ""
   echo -e "Usage: $0 -t 2 -s 55 -x 70 -y 90" "\n t and ts values must be in seconds, X & Y threshold values are in percents not exceeding 100 :). All Values are necessary to run the monitor script"
   echo -e "\t-t Granularity in seconds"
   echo -e "\t-s Total run time in seconds"
   echo -e "\t-x High usage threshold percentage"
   echo -e "\t-y Very high usage threshold percentage"
   exit 1 # Exit script after printing help
}

while getopts "t:s:x:y:" opt
do
   case "$opt" in
      t ) T="$OPTARG" ;;
      s ) TP="$OPTARG" ;;
      x ) X="$OPTARG" ;;
      y ) Y="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z ${T+x} ] || [ -z ${TP+x} ] || [ -z ${X+x} ] || [ -z ${Y+x} ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
   exit 1
fi

#echo $T $TP $X $Y

#TODO
#check wrong parameters - Done, added new options method
#csv file and header line - DONE
#### and the CPU load is still increasing (indicated by 1 minute average) -DONE
#Testing - DONE but some negatives are PENDING


#
echo "This Script"
echo -e "\n Will log and capture cpu usage every  "${bbold}$T${nnormal}"  second/s"  "for  "${bbold}$TP${nnormal}"  second/s" "\n Will generate HIGH CPU usage log if CPU usage is greater than  "${bbold}$X${nnormal}"  percent in the last one minute" "\n Will generate VERY HIGH CPU usage log if CPU usage is greater than  "${bbold}$Y${nnormal}"  percent in the last five minutes and still increasinig \n \n \n"
#
#
# Get until time in epoch
Until=$(expr $(date +%s) + $TP)
#echo $Until
#
#Compare until epoch and loop
#Assumption last minute was 0
lastmin=0
while (($(date +%s) < $Until)); do
	#bash -c "uptime |  sed -n -e 's/^.*load average: //p'| ts | paste -sd ', ' >> log_monitor.csv"

	# move averages into seperate variables
	IFS=, read -r onemin fivemin fifteenmin <<< $(uptime |  sed -n -e 's/^.*load average: //p')
	echo -e "$(date):: Current averages are at $onemin $fivemin $fifteenmin" 
	# Log cpu monitor stats
	bash -c "echo $(date),$onemin,$fivemin,$fifteenmin | paste -sd ',' >> ~/HW1/log_monitor.csv"
	#echo $onemin $fivemin $fifteenmin

	# One minute average above threshold
	if (($(echo "$onemin > $X" | bc) > 0))
	then
		echo -e "$(date):: HIGH USAGE ALERT recorded $onemin $fivemin $fifteenmin"
		bash -c "echo $(date),HIGH USAGE,$onemin,$fivemin,$fifteenmin | paste -sd ',' >> ~/HW1/debug_log.csv"
	fi

	#### and the CPU load is still increasing (indicated by 1 minute average) -DONE
	# Five minute average above threshold - DONE
	if (($(echo "$fivemin > $Y" | bc) > 0))
	then
		if (($(echo "$onemin > $lastmin" | bc) > 0))
		then
			echo -e "$(date):: VERY HIGH USAGE ALERT recorded $onemin $fivemin $fifteenmin"
			bash -c "echo $(date),VERY HIGH USAGE,$onemin,$fivemin,$fifteenmin | paste -sd ',' >> ~/HW1/debug_log.csv"
		fi
	fi
	lastmin=$onemin
    sleep $T
done
