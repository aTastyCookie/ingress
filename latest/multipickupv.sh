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

##bin/getObjectsInCellsamini.sh $LAT $LON
#temp hack
cat maps/v.payload.gz >payload.gz; bin/postapi.sh getObjectsInCells; cat response/getObjectsInCells >response/getObjectsInCells.0
bin/getObjectsInCells.checkpickUp.pl response/getObjectsInCells.0 > tempitemids.txt
NUMOFITEMS=`wc -l tempitemids.txt|awk '{print $1}'`
echo "there are following items here"
bin/getObjectsInCells.checkpickUpcustom.pl response/getObjectsInCells.0|cut -d, -f4,5|sort -n|uniq -c|sort -n
echo will pick $NUMOFITEMS items
CURCOUNT=0
for itemdata in `cat tempitemids.txt|head -n 100`;do
   let CURCOUNT++
   LAT=`echo $itemdata|cut -d, -f1`
   LON=`echo $itemdata|cut -d, -f2`
   itemid=`echo $itemdata|cut -d, -f3`
   ./bin/pickUp.sh $LAT $LON $itemid
   echo picked $CURCOUNT of $NUMOFITEMS
done
