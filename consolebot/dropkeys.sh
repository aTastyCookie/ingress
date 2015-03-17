#!/bin/bash
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}
PGUID=$1
if [ -f error.lock ]; then
	ERROR=`cat error.lock`
	if [ "$ERROR" != "too much items, i will not continue" ]; then
		 echo "error.lock is present, i will not continue"
		exit 1
	fi
	echo "Too much items in inventory. Drop allowed."
fi

if [ "$LOCATION" != "" ]; then
	cat $LOCATION > cur.txt
	touch cur.txt
fi
cat inventory.txt|grep $PGUID|cut -d, -f3 > tempitemids.txt
NUMITEMS=`wc -l < tempitemids.txt`
if [ "$NUMITEMS" -lt "1" ]; then
        echo "no keys for portal"
        exit 1
fi

LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`

for itemid in `cat tempitemids.txt`;do 
   ./bin/dropItem.sh $LAT $LON $itemid
   ./bin/removefrominv.sh $itemid
done
