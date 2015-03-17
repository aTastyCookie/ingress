#!/bin/sh
. bin/func.inc
LAT=$1
LON=$2
PORTALGUID=$3
echo "------------------------------------------------------------"
#temp ./bin/getObjectsInCellsa.sh $LAT $LON $PORTALGUID
#temp ./bin/getObjectsInCells.checkup2grade.pl response/getObjectsInCells.0 $PORTALGUID > portalup.txt
./bin/getModifiedEntitiesByGuid.sh  $LAT $LON $PORTALGUID
cat response/getModifiedEntitiesByGuid > response/getObjectsInCells.0
echo checking for upgrade
./bin/getObjectsInCells.checkaddMod.pl response/getObjectsInCells.0 $PORTALGUID > portalmod.txt
if [ -f "portalmod.txt" ];then
  modcount=1
  for i in `cat portalmod.txt|head -n 2`; do
   slotid=$i
   cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells
   if [ "$modcount" -eq "1" ]; then
     GETITEMID=`./bin/getitemid.sh EXTRA_SHIELD 70 1`
     if [ "$?" -eq "1" ]; then
       GETITEMID=`./bin/getitemid.sh RES_SHIELD 60 1`
       if [ "$?" -eq "1" ]; then
         echo "getitem failed"
         exit 1
       fi
       echo will deploy 60 shield slot $slotid
     fi
     echo will deploy 70 shield slot $slotid
     itemid=`cat tempitemids.txt`
     cat tempitemids.txt
     echo "huyhuyhuy"
     ./bin/addMod.sh $LAT $LON $PORTALGUID $slotid $itemid
     echo "just runt addMod.sh"

  #   ./bin/say.sh $LAT $LON "oh, shit.. this trial version is over, you should buy full one"
     ./bin/removefrominv.sh $itemid
     modcount=$(($modcount+1))
   elif [ "$modcount" -eq "2" ]; then
     GETITEMID=`./bin/getitemid.sh EXTRA_SHIELD 70 1`
     if [ "$?" -eq "1" ]; then
       GETITEMID=`./bin/getitemid.sh RES_SHIELD 60 1`
       if [ "$?" -eq "1" ]; then
         echo "getitem failed"
         exit 1
       fi
       echo will deploy 70 shield slot $slotid
     fi
     echo will deploy 70 shield slot $slotid
     itemid=`cat tempitemids.txt`
     ./bin/addMod.sh $LAT $LON $PORTALGUID $slotid $itemid
     ./bin/removefrominv.sh $itemid
     modcount=$(($modcount+1))
   fi
  done
fi

exit 0
