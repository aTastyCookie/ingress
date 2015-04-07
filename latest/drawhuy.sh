#!/bin/bash
POS=`cat cur.txt`;
for i in `cat map.txt`;do
 x=`echo $i|cut -d, -f1`
 y=`echo $i|cut -d, -f2`
 z=`echo $i|cut -d, -f3`
 bin/move.sh $x*$1 $y*$1
  if  [ "$z" -eq  "1" ]; then
  bin/multidrop.sh $2 $3 1 ;
  fi 
done
echo $POS>CUR.txt;
bin/move.sh 60 120
# bin/move.sh $x $y;
# use bin/drawhuy.sh [step] [item_type] [q-ty per drop]
# bin/drawhuy.sh 5 EMP_BURSTER 
# bin/drawhuy.sh 5 all

