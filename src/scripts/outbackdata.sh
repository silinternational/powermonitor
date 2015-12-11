#!/bin/bash
# outbackdata.sh
# get all controller, flexnetdc and inverter records
# copyright 2011 Paul Zwierzynski
# 08-31-2011
# 11-30-2015 Updated for USB input on RPI

# execute this every minute of every day using the following
#   CRON/crontab (ChRONological TABle) command...
# * * * * * => Execute every minute
# [ Minute - Hour - Day - Month - Weekday ] - Command
# * * * * * /usr/local/bin/outbackdata.sh

# avoid having more than one copy of this script running...
name=`echo $0 | sed 's@.*/@@'`
copiesrunning=`ps -C $name | grep $name | wc -l `

if [ $copiesrunning -gt 4 ]; then
    echo "there are $copiesrunning copies running now"
    /usr/bin/logger -t ipcop "outbackdata failed to run. a hung outbackdata.sh process was found."
    exit 1
fi

time=`date "+%H:%M, "`
unixtime=`date +%s`
filename=`date +%Y.%m.%d.csv`
device=/dev/ttyUSB0

# complete lines have 47 characters. Usually the first line is incomplete.
# Throw away incomplete lines.
/usr/local/bin/queryMateSerial $device 2000 | egrep '^.{48}$' | sed 's/.$//' > /tmp/matedata

for controller in "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K"
    do
    grep "^$controller" < /tmp/matedata >/dev/null
        if [ "$?" == "0" ]
	then
           cat /tmp/matedata | grep "^$controller" -m1 | sed "s/^/$unixtime, $time/" >> "/home/httpd/html/power/C$controller.$filename"
        fi
    done

for flexnetdc in "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k"
    do
    grep "^$flexnetdc" < /tmp/matedata >/dev/null
        if [ "$?" == "0" ]
	then
           cat /tmp/matedata | grep "^$flexnetdc" -m1 | sed "s/^/$unixtime, $time/" >> "/home/httpd/html/power/F$flexnetdc.$filename"
        fi
    done
    
for inverter in "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"
    do
    grep "^$inverter" < /tmp/matedata >/dev/null
        if [ "$?" == "0" ]
	then
           cat /tmp/matedata | grep "^$inverter" -m1 | sed "s/^/$unixtime, $time/" >> "/home/httpd/html/power/I$inverter.$filename"
        fi
    done


