#!/bin/sh
. bin/func.inc
cp inventory.txt tmp.inv.txt
PARAM='|EMP_BURSTER|EMITTER|MULTIHACK,12|HEATSINK,7]|POWER_CUBE,8|ULTRA_STRIKE,8|FLIP_CARD,ADA|FLIP_CARD,JARVIS|RES_SHIELD,[4-6]|LINK_AMPLIFIER,7000';
ID=`cat tmp.inv.txt | grep CAPS -m 1 |cut -d "," -f4`;
echo id=$ID
COUNT=`cat tmp.inv.txt |cut -d, -f1,2|sort -n|uniq -c|grep -E "$PARAM" -c`;
echo TOTAL: $COUNT
for i in `seq 1 $COUNT `
do
echo WOOOP $i of $COUNT
TYPE=`cat tmp.inv.txt | grep -E "$PARAM" -m 1 |cut -d, -f1`;
LVL=`cat tmp.inv.txt | grep -E "$PARAM" -m 1 |cut -d, -f2`;
AMOUNT=`cat tmp.inv.txt | grep -E "$TYPE,$LVL" -c`;
MARK=`cat tmp.inv.txt | grep -E "$PARAM" -m 1 |cut -d, -f1,2`;
bin/loadContainer.sh $TYPE $LVL $AMOUNT $ID;
sed -i "/$MARK/d" tmp.inv.txt;
done
cat inventory.txt | grep -E "$ID" |cut -d "," -f 3 >capsguid.txt;


