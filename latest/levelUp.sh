#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
LEVEL=$3
DELTALAT=$(($RANDOM%100-50))
DELTALON=$(($RANDOM%100-50))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
echo will request levelup $LEVEL
echo "$LAT,$LON" > cur.txt
./bin/levelUp.pl $HEXLATE6 $HEXLONE6 $LEVEL |gzip > payload.gz
./bin/postapi.sh levelUp
