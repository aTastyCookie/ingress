#!/bin/sh
. bin/func.inc
LAT=$1
LON=$2
PORTALGUID=$3
echo "------------------------------------------------------------"
#./bin/getObjectsInCellsa.sh $LAT $LON $PORTALGUID
#./bin/getObjectsInCells.checkup2grade.pl response/getObjectsInCells.0 $PORTALGUID > portalup.txt
./bin/getModifiedEntitiesByGuid.sh  $LAT $LON $PORTALGUID
cat response/getModifiedEntitiesByGuid > response/getObjectsInCells.0
echo checking for upgrade
./bin/getObjectsInCells.checkup2grade.pl response/getObjectsInCells.0 $PORTALGUID > portalup.txt


if [ -f "portalup.txt" ];then
  for i in `cat portalup.txt`; do
   slotid=`echo $i|cut -d, -f1`
   res2update=`echo $i|cut -d, -f2`
   echo will update slot $slotid with $res2update
   GETITEMID=`./bin/getitemid.sh EMITTER_A $res2update 1`
   if [ "$?" -eq "1" ]; then
     echo "getitem failed"
     exit 1
   fi
   itemid=`cat tempitemids.txt`
   ./bin/upgradeResonatorV2.sh $LAT $LON $PORTALGUID $slotid $itemid
   ./bin/removefrominv.sh $itemid
  done
fi
./bin/getObjectsInCells.checkaddMod.pl response/getObjectsInCells.0 $PORTALGUID > portalmod.txt
if [ -f "portalmod.txt" ];then
  for i in `cat portalmod.txt|head -n 2`; do
   slotid=$i
   echo will deploy very rare shield slot $slotid
   GETITEMID=`./bin/getitemid.sh LINK_AMPLIFIER 2000 1`
   if [ "$?" -eq "1" ]; then
     GETITEMID=`./bin/getitemid.sh RES_SHIELD 20 1`
     if [ "$?" -eq "1" ]; then
       echo "getitem failed"
       exit 1
     fi
   fi
   itemid=`cat tempitemids.txt`
   ./bin/addMod.sh $LAT $LON $PORTALGUID $slotid $itemid
#   ./bin/say.sh $LAT $LON "oh, shit.. this trial version is over, you should buy full one"
   ./bin/removefrominv.sh $itemid
  done
fi

exit 0
