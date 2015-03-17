#!/bin/sh
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}
LAT=$1
LON=$2
PGUID=$3
mylevel=`bin/getmylevel.sh`
visiblelevel=`cat config.ini|grep visiblelevel|cut -d=  -f2`
visiblelevel=`bin/getmylevel.sh`
[ "$#" -eq 3 ] || die "3 arguments required, $# provided, synopsys: $0 LAT LON PGUID"
if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  exit 1
fi

#temp broken# ./bin/getObjectsInCellsa.sh $LAT $LON $PGUID
./bin/getModifiedEntitiesByGuid.sh $LAT $LON $PGUID

./bin/getObjectsInCells.checkdeploy.pl response/getModifiedEntitiesByGuid $PGUID > portaldeploy.txt

if [ -f "portaldeploy.txt" ];then
  for i in `cat portaldeploy.txt`; do
   slotid=`echo $i|cut -d, -f1`
   res2deploy=`echo $i|cut -d, -f2`
   echo will deploy slot $slotid with $res2deploy
   GETITEMID=`./bin/getitemid.sh EMITTER_A $res2deploy 1`
   if [ "$?" -eq "1" ]; then
     if [ "$res2deploy" -ge "2" ]; then
       echo "no reso $res2deploy, try to use lower"
#       res2deploy=`echo $res2deploy-1|bc`
       res2deploy=`bin/showinv.sh |grep EMITTER|cut -d, -f2|sort -rn|grep -v 8|grep -v $res2deploy|head -n 1`
      echo "bin/showinv.sh |grep EMITTER|cut -d, -f2|sort -rn|grep -v 8|grep -v $res2deploy|head -n 1"
       echo "will try to find $res2deploy"
       GETITEMID=`./bin/getitemid.sh EMITTER_A $res2deploy 1`
       if [ "$?" -eq "1" ]; then
         echo "getitem failed"
         exit 1
       fi
     fi
   fi
   itemid=`cat tempitemids.txt`
   ./bin/deployResonatorV2.sh $LAT $LON $PGUID $slotid $itemid
  done
fi
./bin/getObjectsInCellsa.sh $LAT $LON $PGUID
./bin/getObjectsInCells.checkaddMod.pl response/getObjectsInCells.0 $PGUID > portalmod.txt
if [ -f "portalmod.txt" ];then
  for i in `cat portalmod.txt|head -n 2`; do
   slotid=$i
   echo will deploy mod at  $slotid
   GETITEMID=`./bin/getitemid.sh RES_SHIELD 10 1`
   if [ "$?" -eq "1" ]; then
     GETITEMID=`./bin/getitemid.sh RES_SHIELD 30 1`
     if [ "$?" -eq "1" ]; then
       GETITEMID=`./bin/getitemid.sh TURRET 2000 1`
       if [ "$?" -eq "1" ]; then
         GETITEMID=`./bin/getitemid.sh  FORCE_AMP 2000 1`
         if [ "$?" -eq "1" ]; then
           GETITEMID=`./bin/getitemid.sh RES_SHIELD 10 1`
           if [ "$?" -eq "1" ]; then
             echo "getitem failed"
             exit 1
           fi 
         fi
       fi
     fi
   fi
   itemid=`cat tempitemids.txt`
   ./bin/addMod.sh $LAT $LON $PGUID $slotid $itemid
  done
fi

exit 0
