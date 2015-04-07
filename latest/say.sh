#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
MESSAGE=$3
LATE6=`echo $LAT*1000000/1|bc`
LONE6=`echo $LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
./bin/say.pl $HEXLATE6 $HEXLONE6  "${MESSAGE}" |sed -e 's/\\\\/\\/g' > payload
cat payload|json_xs
./bin/postapiPlayer.sh say
