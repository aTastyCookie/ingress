#!/bin/sh
. bin/func.inc
cp inventory.txt tmp.inv.txt
PARAM='EMP_BURSTER,8|POWER_CUBE,8|ULTRA_STRIKE,8|RES_SHIELD|FLIP|MULTIHACK|HEATSINK';
echo paramsting  $PARAM
ID=`cat tmp.inv.txt | grep CAPS -m 1 |cut -d "," -f 4`;
echo capsid $ID
COUNT=`cat tmp.inv.txt |cut -d, -f1,2|sort -n|uniq -c|grep -E "$PARAM" -c`;
echo godnih $COUNT
for i in `seq 1 $COUNT `
do
TYPE=`cat tmp.inv.txt | grep -E "$PARAM" -m 1 |cut -d, -f1`;
echo type = $TYPE
LVL=`cat tmp.inv.txt | grep -E "$PARAM" -m 1 |cut -d, -f2`;
echo lvl= $LVL
AMOUNT=`cat tmp.inv.txt | grep -E "$TYPE,$LVL" -c`;
echo  amo=$AMOUNT
MARK=`cat tmp.inv.txt | grep -E "$PARAM" -m 1 |cut -d, -f1,2`;
echo mark=$MARK
bin/loadContainer.sh $TYPE $LVL $AMOUNT $ID;
sed -i "/$MARK/d" tmp.inv.txt;
done
cat inventory.txt | grep -E "$ID" |cut -d "," -f 3 >capsguid.txt;

