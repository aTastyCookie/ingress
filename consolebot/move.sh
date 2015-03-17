#!/bin/sh
LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`
DELTALAT=`echo "scale=6;($1/6378)*(180/3.1415)/1000"|bc -l`
DELTALON=`echo "scale=6;($2/6378)*(180/3.1415)/c($LAT/180*3.1415)/1000"|bc -l`
LAT2=`echo "($LAT+$DELTALAT)"|bc`
LON2=`echo "($LON+$DELTALON)"|bc`
echo OLD: $LAT,$LON
echo NEW: $LAT2,$LON2
echo DELTA: $DELTALAT,$DELTALON
echo $LAT2,$LON2 > cur.txt

