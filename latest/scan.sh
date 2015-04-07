#!/bin/bash
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}

if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  exit 1
fi

LOCATION=$1
if [ -f "$LOCATION" ]; then
	cat $LOCATION > cur.txt
	touch cur.txt
fi

LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`

bin/getObjectsInCellsamini.sh $LAT $LON
#bin/getObjectsInCellsa.sh $LAT $LON
bin/getObjectsInCells.checkpickUp.pl response/getObjectsInCells.0 > tempitemids.txt
NUMOFITEMS=`wc -l tempitemids.txt|awk '{print $1}'`
echo "there are following items here"
bin/getObjectsInCells.checkpickUpcustom.pl response/getObjectsInCells.0|cut -d, -f4,5|sort -n|uniq -c|sort -n
echo will pick $NUMOFITEMS items
