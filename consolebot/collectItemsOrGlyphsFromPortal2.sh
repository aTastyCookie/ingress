#!/bin/bash
. bin/func.inc
#bin/proposetorecycle.sh |grep KEY|sh
LAT=$1
LON=$2
PGUID=$3
DELTALAT=$(($RANDOM%200-100))
DELTALON=$(($RANDOM%200-100))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
numitemslimit=99
numitemslimit=`cat config.ini|grep numitemslimit|cut -d=  -f2`
#get overrides
XM=`cat xm.txt`
if [ $XM -eq $XM 2> /dev/null ]; then
  echo > /dev/null
else
  echo xm is not defined,assuming it is empty
    XM=0
fi
#if [ $XM -le "650" ]; then
     cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells
#fi

#check input for regmatch
echo DROPMETHOD:$DROPMETHOD
echo hacking $1,$2 with glyphs
./bin/collectItemsOrGlyphsFromPortal2.pl $HEXLATE6 $HEXLONE6 $PGUID |gzip > payload.gz
./bin/postapi.sh collectItemsOrGlyphsFromPortal
bin/responseparser.pl response/collectItemsOrGlyphsFromPortal|grep FULL
if [ "$?" -eq "0" ]; then
  bin/clearinv.sh
fi
bin/responseparser.pl response/collectItemsOrGlyphsFromPortal
if [ "$?" -eq "1" ]; then
  exit 1
fi
./bin/collectItemsOrGlyphsFromPortal2p2ng.pl $HEXLATE6 $HEXLONE6 $PGUID |gzip > payload.gz
./bin/collectItemsOrGlyphsFromPortal2p2ng.pl $HEXLATE6 $HEXLONE6 $PGUID > glyphpayload
./bin/postapi.sh collectItemsFromPortalWithGlyphResponse
cat response/collectItemsFromPortalWithGlyphResponse | ./bin/parseinv.pl
cat response/collectItemsFromPortalWithGlyphResponse | ./bin/parseinv.pl >> inventory.txt
#echo ---str--- >> glyph.log
#echo ---str--- >> ~/glyph.log
./bin/collectItemsOrGlyphsFromPortal2p3.pl >> glyph.log
./bin/collectItemsOrGlyphsFromPortal2p3.pl >> ~/glyph.log
#echo ---end--- >> glyph.log
#echo ---end--- >> ~/glyph.log
#RES=`./bin/collectItemsOrGlyphsFromPortal2p3.pl|cut -d, -f3`
#if [ "$RES" -eq "1" ]; then
#  echo "success" > error.lock
#  exit 6
#fi
##./bin/getObjectsInCellsa.sh $LAT $LON $PGUID
./bin/getModifiedEntitiesByGuid.sh $LAT $LON $PGUID
./bin/hackloggl.pl $PGUID 2>&1 >> ~/mitm/hacklog/hackloggl.`date +%Y_%m_%d`
clientLevel=`cat response/collectItemsFromPortalWithGlyphResponse|json_xs |grep nextLevelToken|cut -d: -f2|awk '{print $1}'|tr -d "\n"`
if [[ "$clientLevel" =~ ^[0-9]+$ ]]; then
  echo "you have gained new level $clientLevel, leveling up.."
  ./bin/verifyLevelUp.sh $LAT $LON  $clientLevel
  echo "newlevelup $clientLevel at ap `cat ap.txt`" >> levelup.log
fi
numitems=`wc -l < inventory.txt`
if [ "$numitems" -ge "$numitemslimit" ]; then
  bin/clearinv.sh
   echo > /dev/null  
  numitems=`wc -l < inventory.txt`
  if [ "$numitems" -ge "$numitemslimit" ]; then
      echo "too much items, i will not continue"
#      touch error.lock
#      echo "too much items, i will not continue" > error.lock
#      exit 1
  fi
fi
