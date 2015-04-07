#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
DELTALAT=$(($RANDOM%40-20))
DELTALON=$(($RANDOM%40-20))
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
HEXLATE6SHORT=`HEXE6   $LATE6|cut -c1-6`
HEXLONE6SHORT=`HEXE6   $LONE6|cut -c1-6`
MYLEVEL=`bin/getmylevel.sh`
NORMXM=$((1000+MYLEVEL*1000))
#check input for regmatch
echo "eating xm.."
cp maps/getobj.l8.req.gz payload.gz
./bin/postapi.sh getObjectsInCells
guids=`cat response/getObjectsInCells|json_xs |grep -iE '"[a-z0-9]{32}.6"'|wc -l`
if [ "$guids" -ge "50" ]; then
  cat response/getObjectsInCells|json_xs |grep -oE "\"[0-9a-z]{32}.6\"," | head -n 50  > maps/xmguids
fi
echo "available guids: $guids"
cp response/getObjectsInCells response/getObjectsInCells.0
./bin/getObjectsInCellsa.eatall.pl response/getObjectsInCells cells.txt $HEXLATE6 $HEXLONE6
cat payload |gzip > payload.gz
./bin/postapi.sh getObjectsInCells
guids=`cat response/getObjectsInCells|json_xs |grep -iE '"[a-z0-9]{32}.6"'|wc -l`
echo "ate $guids guids :-)"
