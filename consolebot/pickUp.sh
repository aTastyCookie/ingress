#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
ITEMID=$3
LATE6=`echo $LAT*1000000/1|bc`
LONE6=`echo $LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
echo "$LAT,$LON" > cur.txt
./bin/pickUp.pl $HEXLATE6 $HEXLONE6 $ITEMID |gzip > payload.gz
./bin/postapi.sh pickUp
cat response/pickUp | ./bin/parseinv.pl 
cat response/pickUp | ./bin/parseinv.pl >> inventory.txt


