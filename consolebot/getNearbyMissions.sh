#!/bin/bash
. bin/func.inc
if [ "$#" -eq "2" ]; then
  LAT=$1
  LON=$2
else 
  LAT=`cat cur.txt|cut -d, -f1`
  LON=`cat cur.txt|cut -d, -f2`
fi

DELTALAT=$(($RANDOM%40-20))
DELTALON=$(($RANDOM%40-20))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
./bin/getNearbyMissions.pl $HEXLATE6 $HEXLONE6 |gzip  > payload.gz
./bin/postapi.sh getNearbyMissions
