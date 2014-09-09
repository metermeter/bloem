#!/bin/bash

# cd to the parent directory of the script's directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/..

# check if a configuration file is present
CONFIG='config/graphwater.cfg'
if [ ! -f $CONFIG ]; then
	echo "No configuration file found. Check $CONFIG"
	exit 1
else
	. $CONFIG
fi

# create the output directory if it doesn't exist
if [ ! -d output/ ]; then
	mkdir output/
fi

# exit if the rrd file doesn't exist
if [ ! -f data/water.rrd ]; then
	exit 1
fi

# create the graphs
rrdtool \
    graph output/water_1h.png \
    -a PNG \
    -s -3600 \
    -w 800 \
    -h 200 \
    'DEF:ds1=data/water.rrd:waterpulse:AVERAGE' \
    'CDEF:liter=ds1,10,/' \
    'AREA:liter#0000FF:Water' \
    -t 'Waterverbruik (1h)'

rrdtool \
    graph output/water_4h.png \
    -a PNG \
    -s -14400 \
    -w 800 \
    -h 200 \
    'DEF:ds1=data/water.rrd:waterpulse:AVERAGE' \
    'CDEF:liter=ds1,10,/' \
    'AREA:liter#0000FF:Water' \
    -t 'Waterverbruik (4h)'

rrdtool \
    graph output/water_24h.png \
    -a PNG \
    -s -86400 \
    -w 800 \
    -h 200 \
    'DEF:ds1=data/water.rrd:waterpulse:AVERAGE' \
    'CDEF:liter=ds1,10,/' \
    'AREA:liter#0000FF:Water' \
    -t 'Waterverbruik (24h)'

if [ -d $WATERWWWDIR ]; then
	cp -v output/water*.png $WATERWWWDIR
fi