#!/bin/bash
LAT=$1
LON=$2
PGUID=$3
DELTALAT=$(($RANDOM%40-20))
DELTALON=$(($RANDOM%40-20))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`printf %08x $LATE6`
HEXLONE6=`printf %08x $LONE6`
HEXLATE6SHORT=`printf %08x $LATE6|cut -c1-6`
HEXLONE6SHORT=`printf %08x $LONE6|cut -c1-6`
#check input for regmatch
FILENAME=tempcell/`ls tempcell/|grep -E "^$HEXLATE6SHORT..,$HEXLONE6SHORT.."|head -n1`
if [ -f portalcells/"$PGUID" ]; then
  echo "found file with portalcellmap, proceeding with xm collect"
else 
  if [ -f "$FILENAME" ]; then
    echo "found file with cellmap, proceeding with xm collect"
  else
    echo "no file with cellmap found"
    exit 1
  fi
fi
./getObjectsInCells.0.pl $FILENAME $HEXLATE6 $HEXLONE6 |gzip  > payload.gz
./postapi.sh getObjectsInCells
cp response/getObjectsInCells response/getObjectsInCells.0

        XM=`cat xm.txt`
        if [ $XM -eq $XM 2> /dev/null ]; then
                echo > /dev/null
        else
                echo xm is not defined,assuming it is empty
                XM=0
        fi

./getObjectsInCells.1.pl response/getObjectsInCells $FILENAME $HEXLATE6 $HEXLONE6 |gzip  > payload.gz
./postapi.sh getObjectsInCells
