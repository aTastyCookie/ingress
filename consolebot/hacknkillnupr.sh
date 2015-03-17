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
        ./bin/getObjectsInCellsa.sh $LAT $LON $PGUID
        sleep 1
	./bin/collectItemsFromPortal.sh $LAT $LON $PGUID
	sleep 1
        ./bin/destroyportalr.sh $LAT $LON $PGUID
        sleep 1
        ./bin/deployportal.sh $LAT $LON $PGUID
        sleep 1
        ./bin/upgradeportal.sh $LAT $LON $PGUID
        sleep 1
        ./bin/getObjectsInCellsa.sh $LAT $LON $PGUID
        DSTPGUID=`cat curp.prev.txt|cut -d, -f4`
        ./bin/linkportals.sh $PGUID $DSTPGUID
        sleep 1
        echo $i > curp.prev.txt
        echo "---------hack ended ($NAME $CURCOUNT / $TOTALCOUNT at $1) ------------"
        echo 
done
