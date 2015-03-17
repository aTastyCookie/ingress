#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
PORTALGUID=$3
#bin/say.sh $LAT $LON "@Devocub"
#DELTALAT=$(($RANDOM%200-100))
#DELTALON=$(($RANDOM%200-100))
DELTALAT=0
DELTALON=0
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
echo $PORTALGUID|grep -qE "[a-z0-9]{32}.1[1-6]"
if [ "$?" -eq "0" ]; then
  echo will check portal $PORTALGUID
  echo "$LAT,$LON" > cur.txt
  ./bin/getModifiedEntitiesByGuid.pl $HEXLATE6 $HEXLONE6 $PORTALGUID|gzip > payload.gz
  ./bin/postapi.sh getModifiedEntitiesByGuid
  exit 0
fi
echo "bad itemid"
exit 1
