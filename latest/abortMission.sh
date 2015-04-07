#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
MISSIONGUID=$3
DELTALAT=$(($RANDOM%40-20))
DELTALON=$(($RANDOM%40-20))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
./bin/abortMission.pl $HEXLATE6 $HEXLONE6 $MISSIONGUID |gzip  > payload.gz
./bin/postapi.sh abortMission
