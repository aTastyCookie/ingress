#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
PGUID=$3
DELTALAT=$(($RANDOM%40-20))
DELTALON=$(($RANDOM%40-20))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
HEXLATE6SHORT=`HEXE6   $LATE6|cut -c1-6`
HEXLONE6SHORT=`HEXE6   $LONE6|cut -c1-6`
CUBETOSACRIFICE=7
MYLEVEL=`bin/getmylevel.sh`
NORMXM=$((1000+MYLEVEL*1000))
#check input for regmatch
java -jar bin/S2Geometry.jar $LAT $LON  0.0002 0.0002 > cells.txt
./bin/getObjectsInCellsa.0.pl cells.txt $HEXLATE6 $HEXLONE6 |gzip  > payload.gz
./bin/postapi.sh getObjectsInCells
cp response/getObjectsInCells response/getObjectsInCells.0
XM=`cat xm.txt 2>/dev/null`

	if [ "$XM" == "" ]; then
		echo xm is not defined,assuming it is empty
		XM=0
	fi
  if [ $XM -le "$NORMXM" ]; then
     echo "XM lower than $NORMXM, recharging"
#we should get rid of this (0.0002 0.0002) and calculate necessary xmguids from above request
     java -jar bin/S2Geometry.jar $LAT $LON   0.0002 0.0002 > cells.txt
     ./bin/getObjectsInCellsa.0.pl cells.txt $HEXLATE6 $HEXLONE6 |gzip  > payload.gz
     ./bin/postapi.sh getObjectsInCells
     ./bin/getObjectsInCellsa.1.pl response/getObjectsInCells cells.txt $HEXLATE6 $HEXLONE6 
     cat payload|gzip > payload.gz
     ./bin/postapi.sh getObjectsInCells
  fi
  XM=`cat xm.txt 2>/dev/null`
	if [ "$XM" == "" ]; then
		echo xm is not defined,assuming it is empty
		XM=0
	fi
	ITEMID=""
  if [ "$XM" -le "2400" ]; then
    echo "XM still low, recharging through cube"
    ITEMID=`grep -e "CUBE,[1-$CUBETOSACRIFICE]" inventory.txt|sort -n|head -n 1|cut -d, -f3`
    echo $ITEMID|grep -qE "[a-z0-9]{32}.5"
    if [ "$?" -eq "0" ]; then 
      ./bin/dischargePowerCube.sh $LAT $LON $ITEMID
      XM=`cat xm.txt`
      if [ $XM -le "2400" ]; then
        echo "XM still low, recharging through cube"
        ITEMID=`grep -e "CUBE,[1-$CUBESTOSACRIFICE]" inventory.txt|sort -n|head -n 1|cut -d, -f3`
        ./bin/dischargePowerCube.sh $LAT $LON $ITEMID
      fi
    fi #if there are cubes
  fi
