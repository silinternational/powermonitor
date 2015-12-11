#!/bin/bash
# installer for JAARS outback power monitor on IPCop
# copyright paul zwierzynski
# 07-27-2010
echo " "
echo "Installing JAARS Outback Power monitor addon"

# copy files in place
cp -f ftppush.pl /usr/local/bin/
cp -f outbackdata.sh /usr/local/bin/
cp -f purgedata.sh /usr/local/bin/
cp -f queryMateSerial /usr/local/bin/
mkdir ~/power
# install perl libraries needed to push data to an FTP site
mkdir /usr/lib/perl5/5.10.1/Net
if [ -d /usr/lib/perl/5.10.1 ]
    then
    cp -r ./2.0/FTP /usr/lib/perl/5.10.1/
    cp ./2.0/FTP.pm /usr/lib/perl/5.10.1/
fi
# add 3 new cron jobs
grep "addon - Outback monitor" < /var/spool/cron/root.orig >/dev/null    #check if its already installed
if [ "$?" != "0" ]
	then
		echo "adding extra cron jobs"
		cat ./cronextra >> /var/spool/cron/root.orig
		/usr/bin/fcrontab -z root
fi
# set the comm port for the scripts to use
commport="/dev/ttyUSB0"
#echo " "
#echo "If you use a serial modem for your internet connection,"
#echo "autodetect might temporarily break your connection." 
#echo "                    #####"
#echo "Would you like to autodetect your comm port? (Y or N?)"
#read -n 1 answer
#echo " "
#if [ "$answer" == "Y" -o "$answer" == "y" ]
#    then
#    echo "Connect the serial cable to the Mate and this computer before continuing."
#   read -n 1 -p "Hit any key to continue..." keystroke
#	# autodetect serial port Outback is hooked up to
#	for port in 0 1 2 3
#	do
#		setserial -g /dev/ttyUSB$port | grep -v unknown | grep UART >/dev/null
#		if [ "$?" == "0" ]
#		    then
#		    #/bin/stty 19200 -crtscts -F /dev/ttyUSB$port
#		    # set a background process to dump port data, kill after 3 seconds
#		    (queryMateSerial /dev/ttyUSB$port 2000 > /tmp/matedata) &
#		    sleep 3
#		    # kill may need fixing or may be unnecessary - test
#		    #/bin/kill `ps | grep queryMateSerial | sed -e 's/pts.*//'` >/dev/null
#		    egrep "[0-9],[0-9][0-9],[0-9][0-9]," < /tmp/matedata  >/dev/null     #check for data from port
#		    if [ "$?" == "0" ]
#				then
#		        echo "Looks like data coming in on ttyUSB$port = comm$(($port))"
#		        echo "Setting scripts to use ttyUSB$port" 
#		        sed -i -e "s@device=.*@device=/dev/ttyUSB$port@" /usr/local/bin/outbackdata.sh
#		        commport="/dev/ttyUSB$port"
#		        break
#		        else
#		        echo "No data seen on ttyUSB$port"
#		        rm -f /tmp/matedata
#			fi
#	    	else
#			echo "ttyUSB$port looks dead"
#		fi
#	done
#echo "If you don't like this choice, you can manually set a different comm port."
#echo " "
#fi
#echo "Would you like to manually set your comm port? (Y or N?)"
#read -n 1 answer
#echo " "
#if [ "$answer" == "Y" -o "$answer" == "y" ]
#    then
#    port=N
#    while [ "x$port" != "x0" -a "x$port" != "x1" -a "x$port" != "x2" -a "x$port" != "x3" ]
#	    do
#	    echo "Enter 0 1 2 or 3 respectively for USB0, USB1, etc."
#	    read -n 1 port
#	    done
#
#    echo "Setting scripts to use ttyUSB$port" 
#    sed -i -e "s@device=.*@device=/dev/ttyUSB$port@" /usr/local/bin/outbackdata.sh
#    commport="/dev/ttyUSB$port"
#    else
#    echo "Setting scripts to use ttyUSB0" 
#    sed -i -e "s@device=.*@device=/dev/ttyUSB0@" /usr/local/bin/outbackdata.sh
#    commport="/dev/ttyUSB0"
#    echo "comm port has been arbitrarily set to ttyUSB0 which may not be right."
#    echo "You'll need to manually edit /usr/local/bin/outbackpower.sh"
#    echo " and /etc/rc.d/rc.local"
#    echo "Find the lines refering to /dev/ttyUSB0  and Substitute the correct port #"
#    echo " ...you might want to write that down..."
#fi
#	#force comm port settings
#	/bin/stty 19200 -crtscts -F $commport
#	# clean out rc.local in case we've run the install script before
#	sed -i '/\/bin\/stty /d' /etc/rc.d/rc.local
#	# add serial port settings to startup routine
#	echo  "/bin/stty 19200 -crtscts -F $commport" >> /etc/rc.d/rc.local
#	echo " "
#	echo "Data should start appearing in the /home/httpd/html/power folder in a minute."
#
#echo " "

echo "Enter your powermon.org ftp account username, then [ENTER]"
echo "   leave off the @powermon.org part!"
read  username
echo "Enter your powermon.org ftp account password, then [ENTER]"
read  password
#set the username and password inside the ftppush.pl script
sed -i -e "s/#USERNAME#/$username/" /usr/local/bin/ftppush.pl
sed -i -e "s/#PASSWORD#/$password/" /usr/local/bin/ftppush.pl
echo " "
echo "You can edit /usr/local/bin/ftppush.pl"
echo "if you need to change your username or password."
echo " "
echo "JAARS Outback Power monitor install complete"

