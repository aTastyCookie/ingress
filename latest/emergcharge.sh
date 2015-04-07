#!/bin/sh
. bin/func.inc
PORTALID=`cat *.txt|grep $1|grep -oE "[0-9a-z]{32}.1[1-6]"|head -n 1`
LAT=`cat maps/*.txt|grep $PORTALID|cut -d, -f1|head -n 1`
LON=`cat maps/*.txt|grep $PORTALID|cut -d, -f2|head -n 1`
echo $LAT $LON $PORTALID
while true;do bin/rechargeportal.sh $LAT $LON $PORTALID; bin/eatncharge.sh; done
