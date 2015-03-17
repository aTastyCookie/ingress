#!/bin/bash
. bin/func.inc
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
	echo $i > cur.txt
	echo "---------charge started ($NAME $CURCOUNT / $TOTALCOUNT at $1) ------------"
	echo $CURCOUNT of $TOTALCOUNT
	touch sleep.lock
	echo sleeping for $PAUSE seconds
	sleep $PAUSE
	rm sleep.lock
	touch cur.txt
        bin/upgradeportalmod.sh $LAT $LON $PGUID
        touch portalcharge.txt
        while [ -f "portalcharge.txt" ]; do
          ./bin/rechargeportal.sh $LAT $LON $PGUID
        done
	echo "---------charge ended ($NAME $CURCOUNT / $TOTALCOUNT at $1) ------------"
	echo 
done
