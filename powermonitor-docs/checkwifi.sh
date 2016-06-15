#!/bin/bash
   if ifconfig wlan0 | grep -q "inet addr:" ; then
      exit 0
   else
      /sbin/ifup --force wlan0
   fi

