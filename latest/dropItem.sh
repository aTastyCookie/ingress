#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
ITEMID=$3
DELTALAT=$(($RANDOM%100-50))
DELTALON=$(($RANDOM%100-50))
LATE6=`echo $LAT*1000000/1|bc`
LONE6=`echo $LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
echo will drop `cat inventory.txt|grep $ITEMID`
echo "$LAT,$LON" > cur.txt
./bin/dropItem.pl $HEXLATE6 $HEXLONE6 $ITEMID |gzip > payload.gz
./bin/removefrominv.sh $ITEMID
./bin/postapi.sh dropItem
echo `cat response/dropItem | grep -oE '"[0-9a-f]{32}.4"'|tr -d '"'`>>nopick.txt


