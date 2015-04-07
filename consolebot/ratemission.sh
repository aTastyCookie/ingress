#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
MISSIONGUID=$3
RATING=$4
DELTALAT=$(($RANDOM%40-20))
DELTALON=$(($RANDOM%40-20))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
./bin/rateMission.pl $HEXLATE6 $HEXLONE6 $MISSIONGUID $RATING |gzip  > payload.gz
./bin/postapi.sh rateMission
