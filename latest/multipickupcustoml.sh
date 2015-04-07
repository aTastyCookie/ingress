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

TYPE=$1

LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`
NUMDROP=20
if [ "$2" -ge "20" ]; then
  NUMDROP=$2
fi
##bin/getObjectsInCellsamini.sh $LAT $LON
#temp hack
cat maps/lida.payload.gz >payload.gz; bin/postapi.sh getObjectsInCells; cat response/getObjectsInCells >response/getObjectsInCells.0
bin/getObjectsInCells.checkpickUpcustom.pl response/getObjectsInCells.0 > tempitemidstemp.txt
cat tempitemidstemp.txt|grep -E $TYPE > tempitemids.txt
rm -f tempitemidstemp.txt
NUMOFITEMS=`wc -l tempitemids.txt|awk '{print $1}'`
echo will pick $NUMOFITEMS $TYPE
CURCOUNT=0
for itemdata in `cat tempitemids.txt|head -n $NUMDROP`;do
   let CURCOUNT++
   LAT=`echo $itemdata|cut -d, -f1`
   LON=`echo $itemdata|cut -d, -f2`
   itemid=`echo $itemdata|cut -d, -f3`
   ./bin/pickUp.sh $LAT $LON $itemid
   echo picked $CURCOUNT of $NUMOFITEMS
done
