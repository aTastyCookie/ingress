#!/bin/bash
MISSIONGUID=$1
RATING=$2
LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`
echo starting mission $MISSIONGUID with rating $RATING
bin/startMission.sh $LAT $LON $MISSIONGUID
sleep 1
bin/abortMission.sh $LAT $LON $MISSIONGUID
sleep 1
bin/rateMission.sh $LAT $LON $MISSIONGUID $RATING
