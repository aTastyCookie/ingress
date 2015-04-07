#!/bin/bash
. bin/func.inc
for i in `cat portalids.txt` ;do cat inventory.txt |grep $i|cut -d, -f3|head -n 5;done > tempitemids.txt
LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`

for itemid in `cat tempitemids.txt`;do 
     ./bin/dropItem.sh $LAT $LON $itemid
     ./bin/removefrominv.sh $itemid
done

