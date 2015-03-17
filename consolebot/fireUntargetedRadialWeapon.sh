#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
ITEMID=$3
PGUID=$4
DELTALAT=$(($RANDOM%200-100))
DELTALON=$(($RANDOM%200-100))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
echo $ITEMID|grep -qE "[a-z0-9]{32}.5"
if [ "$?" -eq "0" ]; then
  echo will fire `cat inventory.txt|grep $ITEMID`
	echo "$LAT,$LON" > cur.txt
  ./bin/fireUntargetedRadialWeapon.pl $HEXLATE6 $HEXLONE6 $ITEMID $PGUID |gzip > payload.gz
  ./bin/removefrominv.sh $ITEMID
  ./bin/postapi.sh fireUntargetedRadialWeaponV2
  exit 0
fi
echo "bad itemid"
exit 1
