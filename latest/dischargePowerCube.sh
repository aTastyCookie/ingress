#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
ITEMID=$3
LATE6=`echo $LAT*1000000/1|bc`
LONE6=`echo $LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
echo $ITEMID|grep -qE "[a-z0-9]{32}.5"
if [ "$?" -eq "0" ]; then
  echo will discharge cube `cat inventory.txt|grep $ITEMID`
  ./bin/dischargePowerCube.pl $HEXLATE6 $HEXLONE6 $ITEMID |gzip > payload.gz
  ./bin/removefrominv.sh $ITEMID
  ./bin/postapi.sh dischargePowerCube
  exit 0
fi
echo "bad itemid"
exit 1
