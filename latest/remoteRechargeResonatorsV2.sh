#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
KEYGUID=$3
DELTALAT=$(($RANDOM%200-100))
DELTALON=$(($RANDOM%200-100))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch

echo "$LAT,$LON" > cur.txt

./bin/remoteRechargeResonatorsV2.pl $HEXLATE6 $HEXLONE6 $KEYGUID |gzip > payload.gz
./bin/postapi.sh remoteRechargeResonatorsV2
