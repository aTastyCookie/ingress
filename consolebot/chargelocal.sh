#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
DIST=$3
echo $DIST|grep -E "^0\.([0-9])"
if [ "$?" -eq "1" ]; then
  echo "eatxm.sh lat lon delta ; delta should be < 1. setting to 0.002"
  DIST="0.002"
fi
echo $LAT,$LON > cur.txt
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
java -jar bin/S2Geometry.jar $LAT $LON   $DIST $DIST > cells.txt
./bin/getObjectsInCellsa.0.pl cells.txt $HEXLATE6 $HEXLONE6 |gzip  > payload.gz
./bin/postapi.sh getObjectsInCells
guids=`cat response/getObjectsInCells|json_xs |grep -iE '"[a-z0-9]{32}.6"'|wc -l`
echo "available guids: $guids"
cp response/getObjectsInCells response/getObjectsInCells.0
./bin/getObjectsInCellsa.1.pl response/getObjectsInCells cells.txt $HEXLATE6 $HEXLONE6
cat payload|gzip > payload.gz
./bin/postapi.sh getObjectsInCells
cat payload  > p.1
guids=`cat response/getObjectsInCells|json_xs |grep -iE '"[a-z0-9]{32}.6"'|wc -l`
echo "ate $guids guids :-)"
bin/generateportalslistfromcells.pl response/getObjectsInCells.0 |grep -E "RESISTANCE,.,1" | awk -F, '{print $1","$2",5,"$3}' > map.war.txt
bin/randomizemap.sh map.war.txt
bin/hackonlyrechargelocal.sh map.war.txt
