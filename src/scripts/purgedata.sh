#!/bin/bash

# purge 4 year old data
#find /home/httpd/html/power/ -name "*.csv" -type f -maxdepth 1 -mtime +1462 -exec rm -f {} \;

# or purge 1 year old data
find /home/httpd/html/power/ -name "*.csv" -type f -maxdepth 1 -mtime +366 -exec rm -f {} \;


