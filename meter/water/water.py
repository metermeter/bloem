#!/usr/bin/python

###########################################################
# CHANGES:
# v0.2.1
# - creates the log directory if it doesn't exist
# - log file extension changed to .log
#
# v0.2
# - preparation for electricity monitoring
# - use a regex to identify the pulse from the datastring
#
# v0.1
# - initial version
###########################################################

APPVERSION = "v0.2.1"

from time import strftime
import serial
import rrdtool
import re
import os

if not os.path.exists('log'):
    os.makedirs('log')

ser = serial.Serial('/dev/ttyACM0', 115200)

datastring = re.compile('^(water|elec),(\d+)')

print "Watermeter "+APPVERSION
print "Waiting...\n"

while(True):
    line = ser.readline()

    consolefile = open('log/console.log', 'a')
    consolefile.write(line)
    consolefile.close()

    result = datastring.search(line)
    if result:

        if result.group(1) == 'water':
            amount = result.group(2)
            timestamp = strftime("%Y-%m-%dT%H:%M:%S")
            message = 'water,' + timestamp + ',' + amount
            print(message)

            file = open('log/water.log', 'a')
            file.write(message + '\n')
            file.close()

            rrdtool.update('data/water.rrd', 'N:1')
