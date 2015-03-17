#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
ITEMID=$3
ORIGINPORTALGUID=$4
DESTPORTALGUID=$5
LATE6=`echo $LAT*1000000/1|bc`
LONE6=`echo $LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
./bin/createLink.pl $HEXLATE6 $HEXLONE6 $ITEMID $ORIGINPORTALGUID $DESTPORTALGUID |gzip > payload.gz
./bin/postapi.sh createLink

#RET_OK=`echo $RET | grep -F "request createLink ok" | wc -l`
