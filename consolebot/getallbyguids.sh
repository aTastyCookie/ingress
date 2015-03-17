#!/bin/bash
echo 53.900228,27.564707 > cur.txt
LAT="53.900228"
LON="27.564707"
find mapres/ -type f -size 0|xargs rm
mkdir mapres
TOTALCOUNT=`wc -l < maps/allguids.txt`
CURCOUNT=0
for PGUID in `cat maps/allguids.txt|sort -n|uniq`;
do
  let CURCOUNT++
  echo $CURCOUNT of $TOTALCOUNT
  bin/getModifiedEntitiesByGuid.sh $LAT $LON $PGUID
  cp response/getModifiedEntitiesByGuid mapres/$PGUID
done
bin/concantenatejsonsclient.pl  > response/getObjectsInCells
