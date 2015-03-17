#!/bin/bash
while true; do
if [ -f "maps/pickpick" ]; then
  LAT=`cat cur.txt|cut -d, -f1`
  LON=`cat cur.txt|cut -d, -f2`
  ITEMGUID=`cat maps/pickpick`
  bin/pickUp.sh $LAT $LON  $ITEMGUID
  PICKEDGUID=`cat response/pickUp |json_xs |grep -oE "[0-9a-z]{32}.5"`
  cat response/pickUp |json_xs |grep -oE "[0-9a-z]{32}.5"
  if [ "$?" -eq "0" ]; then
    sed -i "/$ITEMGUID/d" maps/itemspile
    bin/dropItem.sh $LAT $LON $PICKEDGUID
    dropid=`cat response/dropItem |json_xs |grep -oE "[0-9a-f]{32}.4"`
    echo $dropid >> maps/itemspile
  fi
fi
done
