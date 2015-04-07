#!/bin/bash
LAT=$1
LON=$2
RADIUS=$3
bin/getmap.sh $LAT $LON 0.02
bin/generateportalslistfromcells.pl response/getObjectsInCells


