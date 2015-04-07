#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
ITEMID=$3
DELTALAT=$(($RANDOM%100-50))
DELTALON=$(($RANDOM%100-50))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
echo "$LAT,$LON" > cur.txt
echo will recycle `cat inventory.txt|grep $ITEMID`
./bin/recycleItem.pl $HEXLATE6 $HEXLONE6 $ITEMID |gzip > payload.gz
./bin/removefrominv.sh $ITEMID
./bin/postapi.sh recycleItem
