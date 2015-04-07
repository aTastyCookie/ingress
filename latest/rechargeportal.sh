#!/bin/sh
. bin/func.inc
LAT=$1
LON=$2
PORTALGUID=$3
echo "------------------------------------------------------------"
echo "$LAT,$LON" > cur.txt
touch portalcharge.txt
rm portalcharge.txt
#temp broken# ./bin/getObjectsInCellsa.sh $LAT $LON $PORTALGUID
./bin/getModifiedEntitiesByGuid.sh $LAT $LON $PORTALGUID 
LAT1=`cat response/getModifiedEntitiesByGuid |json_xs |grep latE6|cut -d: -f2|cut -d, -f1|awk '{print $1/1000000}'|grep -E "[0-9]"`
LON1=`cat response/getModifiedEntitiesByGuid |json_xs |grep lngE6|cut -d: -f2|cut -d, -f1|awk '{print $1/1000000}'|grep -E "[0-9]"`
echo "$LAT,$LON,$PORTALGUID"
#temp broken# ./bin/getObjectsInCells.checkrecharge.pl response/getObjectsInCells.0 $PORTALGUID
./bin/getObjectsInCells.checkrecharge.pl response/getModifiedEntitiesByGuid $PORTALGUID
cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells
xm=`cat xm.txt`
xm=2000
if [ "$xm" -le "1500" ]; then
    echo "low xm, will not recharge"
    rm portalcharge.txt
    exit 1
 fi
if [ -f "portalcharge.txt" ];then
   echo will recharge portal $3 ololo
   ./bin/rechargeResonatorsV2.sh $LAT $LON $PORTALGUID
   ./bin/rechargeResonatorsV2.sh $LAT $LON $PORTALGUID
   currentxm=`cat response/rechargeResonatorsV2 |json_xs|grep -E '"energy"'|head -n 1 |cut -d: -f2|tr -d ','|awk '{print $1}'`
   gainedap=`cat response/rechargeResonatorsV2 |json_xs|grep -i apGainAmount|cut -d: -f2|tr -d '",'|awk '{print $1}'`
   echo xm:$currentxm / ap:+$gainedap
   if [ $currentxm -eq 3000 -a $gainedap -eq 10 ]; then
#     echo bot `pwd` invalid at `date` |mail -s bot_invalid valery.tereshko@gmail.com
     touch error.lock
   fi
   cat response/rechargeResonatorsV2 |json_xs |grep error
   ERR=$?
   if [ "$ERR" -eq "0" ]; then 
     echo error while recharging, will remove portalcharge.txt to avoid cycle
     rm -f portalcharge.txt
   fi
else 
  echo "portal $3 does not need recharging"
fi
exit 0
