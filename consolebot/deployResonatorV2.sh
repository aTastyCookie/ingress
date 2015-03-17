#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
PORTALGUID=$3
SLOTID=$4
ITEMGUID=$5
DELTALAT=$(($RANDOM%50))
DELTALON=$((DELTALAT+250))
DELTALAT=$DELTALON
LATN=`echo $DELTALAT/1000000+$LAT|bc -l`
LONN=`echo $DELTALON/1000000+$LON|bc -l`
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
./bin/distance.pl $LAT,$LON $LATN,$LONN
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
echo "$LATN,$LONN,$PORTALGUID" > cur.txt
echo "$LATN,$LONN,$PORTALGUID,$SLOTID,$ITEMGUID" >> deploy.log
./bin/deployResonatorV2.pl $HEXLATE6 $HEXLONE6 $PORTALGUID $SLOTID $ITEMGUID |gzip > payload.gz
./bin/postapi.sh deployResonatorV2
./bin/removefrominv.sh $ITEMGUID
