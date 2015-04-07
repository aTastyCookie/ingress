#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
ITEMID=$3
PORTALGUID=$4
LATE6=`echo $LAT*1000000/1|bc`
LONE6=`echo $LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
./bin/getLinkabilityImpediment.pl $HEXLATE6 $HEXLONE6 $ITEMID $PORTALGUID |gzip > payload.gz
RET=`./bin/postapi.sh getLinkabilityImpediment`
RET_OK=`echo $RET | grep -F "request getLinkabilityImpediment ok" | wc -l`
if [ "$RET_OK" == "1" ]; then
	./bin/getLinkabilityImpediment.parse.pl response/getLinkabilityImpediment $ITEMID
else
	echo $RET
fi

