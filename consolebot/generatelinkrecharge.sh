#!/bin/sh
#bin/getmap.sh 53.900228 27.564707 0.21;
#bin/findlongportalstorecharge.pl response/getObjectsInCells > maps/links.txt
#cat maps/links.txt |cut -d, -f8-9|tr "," "\n" > pguid.list
cat maps/guids.txt |grep -vE "^#" >> pguid.list
echo 53.900228,27.564707 > cur.txt
LAT="53.900228"
LON="27.564707"
rm -rf map.war.txt.tmp
for PGUID in `cat pguid.list|sort -n|uniq`;
do
  bin/getModifiedEntitiesByGuid.sh $LAT $LON $PGUID
  bin/getModifiedEntitiesByGuid.checkrecharge.pl response/getModifiedEntitiesByGuid $PGUID
  if [ -f "portalcharge.txt" ];then
   bin/getportallocation.pl response/getModifiedEntitiesByGuid  $PGUID >> map.war.txt.tmp
   echo will remote recharge portal 
   rm portalcharge.txt
  else
    echo "alien portal, removing"
  fi
  if [ -f "portaldelete.txt" ];then
    echo "portal already at max, will remove it"
    rm portaldelete.txt
  fi
done
vim map.war.txt.tmp
cat  map.war.txt.tmp |grep -vE "^#" > map.war.txt
bin/genblobmap.sh map.war.txt
bin/randomizemap.sh map.war.txt
echo "run bin/hackkey.sh map.war.txt to begin portalcharge/keyhack" 
