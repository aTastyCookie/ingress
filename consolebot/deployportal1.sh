#!/bin/sh
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}
LAT=$1
LON=$2
PGUID=$3
[ "$#" -eq 3 ] || die "3 arguments required, $# provided, synopsys: $0 LAT LON PGUID"
if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  exit 1
fi

#temp broken# ./bin/getObjectsInCellsa.sh $LAT $LON $PGUID
./bin/getModifiedEntitiesByGuid.sh $LAT $LON $PGUID
./bin/getObjectsInCells.checkdeploy.pl response/getModifiedEntitiesByGuid $PGUID > portaldeploy.txt
res2deploy=1
slotid=255
numemptyslots=`wc -l portaldeploy.txt|awk '{print $1}'`
echo $numemptyslots
if [ "$numemptyslots" -eq "8" ]; then
   echo will deploy slot $slotid with $res2deploy
   echo "will try to find $res2deploy"
   GETITEMID=`./bin/getitemid.sh EMITTER_A $res2deploy 1`
   if [ "$?" -eq "1" ]; then
     echo "getitem failed"
     exit 1
   fi
   itemid=`cat tempitemids.txt`
   ./bin/deployResonatorV2.sh $LAT $LON $PGUID $slotid $itemid
fi
cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells
#./bin/getObjectsInCellsa.sh $LAT $LON $PGUID
exit 0
