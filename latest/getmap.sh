#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
DIST=$3
echo $DIST|grep -E "^0\.([0-9])"
if [ "$?" -eq "1" ]; then
  echo "eatxm.sh lat lon delta ; delta should be < 1. setting to 0.2"
  DIST="0.2"
fi
DELTALAT=$(($RANDOM%40-20))
DELTALON=$(($RANDOM%40-20))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
HEXLATE6SHORT=`HEXE6   $LATE6|cut -c1-6`
HEXLONE6SHORT=`HEXE6   $LONE6|cut -c1-6`
MYLEVEL=`bin/getmylevel.sh`
NORMXM=$((1000+MYLEVEL*1000))
#check input for regmatch
echo "getting info"
java -jar bin/S2Geometry.jar $LAT $LON   $DIST $DIST > cells.txt
./bin/getObjectsInCellsa.0.pl cells.txt $HEXLATE6 $HEXLONE6 |gzip  > payload.gz
./bin/postapi.sh getObjectsInCells
guids=`cat response/getObjectsInCells|json_xs |grep -iE '"[a-z0-9]{32}.6"'|wc -l`
echo "available guids: $guids"
echo "your map is at response/getObjectsInCells"
