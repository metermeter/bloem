#!/bin/bash

# make sure the data directory exists
if [ ! -d ../data/ ]; then
	mkdir ../data/
fi

cd ../data

# create the rrd file
rrdtool \
    create gas.rrd \
    --no-overwrite \
    --start 1408744800 \
    --step 300 \
    DS:gaspulse:ABSOLUTE:600:0:U \
    RRA:AVERAGE:0:1:288 \
    RRA:AVERAGE:0:3:672 \
    RRA:AVERAGE:0:12:744 \
    RRA:AVERAGE:0:72:1460
