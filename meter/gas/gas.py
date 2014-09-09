#!/usr/bin/python

###########################################################
# CHANGES:
# v0.1.1
# - creates the log directory if it doesn't exist
# - log file extension changed to .log
#
# v0.1
# - initial version
###########################################################

APPVERSION = "v0.1.1"

import RPi.GPIO as GPIO
import time
from time import sleep,strftime
import rrdtool
import os

if not os.path.exists('log'):
    os.makedirs('log')

GPIO.setmode(GPIO.BCM)

# GPIO 23 set up as input. It is pulled up to stop false signals
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_UP)


print "Gasmeter "+APPVERSION
print "Waiting...\n"

def gaspulse(channel):
    timestamp = strftime("%Y-%m-%dT%H:%M:%S")
    
    message = 'gas,' + timestamp + ',1'
    print(message)
    
    file = open('log/gas.log', 'a')
    file.write(message + '\n')
    file.close()
    
    rrdtool.update('data/gas.rrd', 'N:1')

GPIO.add_event_detect(23, GPIO.FALLING, callback=gaspulse, bouncetime=1000)

while(True):
    sleep(1)

GPIO.cleanup
