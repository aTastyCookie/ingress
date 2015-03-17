#!/bin/sh
#i will drop 1 key for each portal to cur.txt
if [ -f error.lock ]; then
        ERROR=`cat error.lock`
        if [ "$ERROR" != "too much items, i will not continue" ]; then
                 echo "error.lock is present, i will not continue"
                exit 1
        fi
        echo "Too much items in inventory. Drop allowed."
fi

if [ "$LOCATION" != "" ]; then
        cat $LOCATION > cur.txt
        touch cur.txt
fi
for i in `cat inventory.txt|grep KEY|cut -d, -f4-|sort -n|uniq -c|sort -n|grep -oE "[0-9a-z]{32}.16"`;
do
  cat inventory.txt|grep $i|head -n 1|cut -d, -f3 > tempitemids.txt
  LAT=`cat cur.txt|cut -d, -f1`
  LON=`cat cur.txt|cut -d, -f2`
  for itemid in `cat tempitemids.txt`;do
    ./bin/dropItem.sh $LAT $LON $itemid
    ./bin/removefrominv.sh $itemid
  done
done

