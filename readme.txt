Monitoring script________________
monitor.sh script will log(log_monitor.csv)  and capture cpu usage every T(-t) second/s for TP (-s)  second/s and will generate HIGH CPU usage log(debug_log.csv) if CPU usage is greater than X(-x)  percent in the last one minute it will also generate VERY HIGH CPU usage log (debug_log.csv) if CPU usage is greater than Y(-y) percent in the last five minutes and still increasing

In order to run the script follow usage guidelines 

Usage: ./monitor.sh -t 2 -s 55 -x 70 -y 90 
 t and ts values must be in seconds, X & Y threshold values are in percents not exceeding 100 :). All Values are necessary to run the monitor script
	-t Granularity in seconds
	-s Total run time in seconds
	-x High usage threshold percentage
	-y Very high usage threshold percentage

-Assumption- Initial last 1min average value is set to 0 (Initial only)

Clear log script_______________
clear log script will clear both the log files and write headers back

ron job example________________
# m h  dom mon dow   command
*/30 * * * * bash ~/HW1/monitor.sh -t 1 -s 30 -x 1 -y 2
* 12 * * * bash ~/HW1/clear_log.sh

