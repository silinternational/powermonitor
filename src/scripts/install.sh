#!/bin/bash
# installer for SIL GTIS power monitor on Raspberry Pi
# copyright paul zwierzynski
# 07-27-2010
# 1-21-2016 Modified for Raspberry Pi and labjack
# 2-4-2016 install bc so we can average readings

# only root can install
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root. Try using sudo ./install.sh" 1>&2
   exit 1
fi

USER="pi"
if [ ! -d /home/$USER ]; then
    echo "username $USER not found. This script is specific for he user $USER."
    exit 1
fi
  
echo " "
echo "Installing GTIS Power systems Powermon"

#make sure we're in the folder contining theis install script
myname="$(readlink -f "$0")"
foldername=`dirname $myname`
cd $foldername

# copy files in place
cp -f ftppush.pl /usr/local/bin/
cp -f outbackdata.sh /usr/local/bin/
cp -f purgedata.sh /usr/local/bin/
cp -f queryMateSerial /usr/local/bin/

chmod 755 /usr/local/bin/ftppush.pl
chmod 755 /usr/local/bin/outbackdata.sh
chmod 755 /usr/local/bin/purgedata.sh
chmod 755 /usr/local/bin/queryMateSerial

mkdir /home/$USER/LJFuse
cp -f fuse.py /home/$USER/LJFuse/
cp -f ljfuse.py /home/$USER/LJFuse/
cp -f monitorLJ.sh /home/$USER/LJFuse/
chown -R $USER:$USER /home/$USER/LJFuse
mkdir /home/$USER/power
chown -R $USER:$USER /home/$USER/power

if [ ! -d /home/$USER/power ]
  then
  echo "Can't create the data folder $FOLDER"
  echo "Check path and permissions"
  echo "Exiting"
  echo "Can't create the data folder $FOLDER" >> "/var/log/messages"
  echo "Check path and permissions" >> "/var/log/messages"
  exit 1
fi
chown $USER:$USER /home/$USER/power

#Install libraries for LabjackPython
apt-get install libusb-1.0 bc fuse

# compile and install the labjack exodriver
cd $foldername
unzip ./exodriver-master.zip
cd exodriver-master
./install.sh
cd $foldername
# install LabJackPython
unzip LabJackPython-5-26-2015.zip
cd LabJackPython-5-26-2015
python setup.py install
usermod -a -G adm pi


# add 3 new cron jobs
cd $foldername
#check if its already installed
if [ ! -f /etc/cron.d/powermon ]
    then
    echo "adding extra cron jobs"
    cat ./cronextra > /etc/cron.d/powermon
fi

# set the comm port for the scripts to use
commport="/dev/ttyUSB0"

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
echo "GTIS Powermon install complete"

