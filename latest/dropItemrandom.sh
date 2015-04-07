#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
ITEMID=$3
DELTALAT=$(($RANDOM%200-100))
DELTALON=$(($RANDOM%200-100))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
echo will drop `cat inventory.txt|grep $ITEMID`
echo "$LAT,$LON" > cur.txt
./bin/dropItem.pl $HEXLATE6 $HEXLONE6 $ITEMID |gzip > payload.gz
./bin/removefrominv.sh $ITEMID
./bin/postapi.sh dropItem
