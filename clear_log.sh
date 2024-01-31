#!/bin/bash
#
#Create files if they dont exist
FILE=~/HW1/debug_log.csv
if [ -f "$FILE" ]; then
    echo -e "$FILE exists.Proceding... \n"
    echo -e "" > $FILE
    bash -c "echo -e timestamp,AlertString,1minavg,5minavg,15minavg > $FILE"
else
    echo -e "$FILE does not exist.Creating and populating with header values \n"
    touch $FILE
    bash -c "echo -e timestamp,AlertString,1minavg,5minavg,15minavg > $FILE"
fi

FILE=~/HW1/log_monitor.csv
if [ -f "$FILE" ]; then
    echo -e "$FILE exists.Proceding... \n"
    echo -e "" > $FILE
    bash -c "echo -e timestamp,1minavg,5minavg,15minavg > $FILE"
else
    echo -e "$FILE does not exist.Creating and populating with header values \n"
    touch $FILE
    bash -c "echo -e timestamp,1minavg,5minavg,15minavg > $FILE"
fi
