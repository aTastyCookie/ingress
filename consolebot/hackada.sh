#!/bin/bash
. bin/func.inc
if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  exit 1
fi
SKIP=$2
if [ "$SKIP" == "" ]; then
        SKIP=0
fi

TOTALCOUNT=`wc -l < $1`
CURCOUNT=0
PWD=`pwd`
NAME=`basename $PWD`
for i in `cat $1`;do
        let CURCOUNT++
        if [ "$SKIP" != "0" ]; then
                let SKIP--
                continue;
        fi
        LAT=`echo $i|cut -d, -f1`
	LON=`echo $i|cut -d, -f2`
	PAUSE=`echo $i|cut -d, -f3`
	PGUID=`echo $i|cut -d, -f4`
	if [ -f error.lock ]; then
	  echo "error.lock is present, i will not continue"
	  break
  	fi
	echo $i > cur.txt
        echo "---------hack started ($NAME $CURCOUNT / $TOTALCOUNT at $1) ------------"
        echo $CURCOUNT of $TOTALCOUNT
        touch sleep.lock
	echo sleeping for $PAUSE seconds
	sleep $PAUSE
        rm sleep.lock
        #./bin/getObjectsInCellsa.sh $LAT $LON $PGUID
   GETITEMID=`./bin/getitemid.sh FLIP_CARD ADA 1`
   if [ "$?" -eq "1" ]; then
         echo "getitem failed"
         exit 1
   fi
        itemid=`cat tempitemids.txt`
        ./bin/flipPortal.sh $LAT $LON $itemid $PGUID
        ./bin/getObjectsInCellsa.sh $LAT $LON $PGUID
        cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells
        cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells
        cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells
        cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells
        DSTPGUID=`cat curp.prev.txt|cut -d, -f4`
#        ./bin/linkportals.sh $PGUID $DSTPGUID
        echo $i > curp.prev.txt
        echo "---------hack ended ($NAME $CURCOUNT / $TOTALCOUNT at $1) ------------"
        echo 
done
