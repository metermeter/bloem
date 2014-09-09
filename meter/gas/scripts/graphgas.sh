#!/bin/bash

# cd to the parent directory of the script's directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/..

# check if a configuration file is present
CONFIG='config/graphgas.cfg'
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
if [ ! -f data/gas.rrd ]; then
	exit 1
fi

# create the graphs
rrdtool \
    graph output/gas_1h.png \
    -a PNG \
    -s -3600 \
    -w 800 \
    -h 200 \
    'DEF:ds1=data/gas.rrd:gaspulse:AVERAGE' \
    'CDEF:liter=ds1,10,/' \
    'AREA:liter#FBDB0C:Gas' \
    -t 'Gasverbruik (1h)'

rrdtool \
    graph output/gas_4h.png \
    -a PNG \
    -s -14400 \
    -w 800 \
    -h 200 \
    'DEF:ds1=data/gas.rrd:gaspulse:AVERAGE' \
    'CDEF:liter=ds1,10,/' \
    'AREA:liter#FBDB0C:Gas' \
    -t 'Gasverbruik (4h)'

rrdtool \
    graph output/gas_24h.png \
    -a PNG \
    -s -86400 \
    -w 800 \
    -h 200 \
    'DEF:ds1=data/gas.rrd:gaspulse:AVERAGE' \
    'CDEF:liter=ds1,10,/' \
    'AREA:liter#FBDB0C:Gas' \
    -t 'Gaverbruik (24h)'

if [ -d $GASWWWDIR ]; then
	cp -v output/gas*.png $GASWWWDIR
fi
