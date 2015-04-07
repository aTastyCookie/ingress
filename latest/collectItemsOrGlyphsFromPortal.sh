#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
PGUID=$3
DELTALAT=$(($RANDOM%200-100))
DELTALON=$(($RANDOM%200-100))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
numitemslimit=1980
#get overrides
cat maps/p|gzip > payload.gz ; bin/postapi.sh getObjectsInCells
XM=`cat xm.txt`
if [ $XM -eq $XM 2> /dev/null ]; then
  echo > /dev/null
else
  echo xm is not defined,assuming it is empty
    XM=0
fi
if [ $XM -le "650" ]; then
     echo "XM low, will not hack"
     exit 2
fi

#check input for regmatch
echo DROPMETHOD:$DROPMETHOD
echo hacking $1,$2
./bin/collectItemsOrGlyphsFromPortal.pl $HEXLATE6 $HEXLONE6 $PGUID |gzip > payload.gz
./bin/postapi.sh collectItemsOrGlyphsFromPortal
cat response/collectItemsOrGlyphsFromPortal | ./bin/parseinv.pl
cat response/collectItemsOrGlyphsFromPortal | ./bin/parseinv.pl >> inventory.txt
./bin/getObjectsInCellsa.sh $LAT $LON $PGUID
./bin/getModifiedEntitiesByGuid.sh $LAT $LON $PGUID
./bin/hacklog.pl $PGUID 2>&1 >> ~/mitm/hacklog/hacklog.`date +%Y_%m_%d`
clientLevel=`cat response/collectItemsOrGlyphsFromPortal|json_xs |grep __disabled__nextLevelToken|cut -d: -f2|awk '{print $1}'|tr -d "\n"`
if [[ "$clientLevel" =~ ^[0-9]+$ ]]; then
  echo "you have gained new level $clientLevel, leveling up.."
  ./bin/verifyLevelUp.sh $LAT $LON  $clientLevel
  cat response/verifyLevelUp | ./bin/parseinv.pl
  cat response/verifyLevelUp | ./bin/parseinv.pl >> inventory.txt
  echo "newlevelup $clientLevel at ap `cat ap.txt`" >> levelup.log
fi
numitems=`wc -l < inventory.txt`
if [ "$numitems" -ge "$numitemslimit" ]; then
   echo > /dev/null
   bin/clearinv_low.sh
  numitems=`wc -l < inventory.txt`
  if [ "$numitems" -ge "$numitemslimit" ]; then
      echo "too much items, i will not continue"
      touch error.lock
      echo "too much items, i will not continue" > error.lock
      exit 1
  fi
fi
#bin/autoclearinv.sh
