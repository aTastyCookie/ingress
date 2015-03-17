if [ "$#" -gt "0" ]; then
PARAM=$1;
else
PARAM="EMITTER_A,8.ULTRA_STRIKE,8.FLIP_CARD,ADA.EMITTER_A,4.RES_SHIELD,30.EMP_BURSTER,7.EMP_BURSTER,8.EMP_BURSTER,6.POWER_CUBE,8.RES_SHIELD,40.RES_SHIELD,60.EMITTER_A,8.EXTRA_SHIELD,70.ULTRA_STRIKE,8.FLIP_CARD,JARVIS"
fi
COUNT=`cat inventory.txt | grep -E "$PARAM" -c`;
for i in `cat inventory.txt | grep 0/100 | cut -d , -f4`; do
 for y in `seq 1 28`;do
  C=`echo $PARAM | cut -d . -f$y`;
  COUNT=`cat inventory.txt |grep $C -c`;
# echo "$COUNT of $C to $i . Y=$y"
   if [ $COUNT -eq "0" ]; then
    continue;
    elif [ $COUNT -ge "100" ]; then
    TYPE=`echo $C | cut -d , -f1`;
     LVL=`echo $C | cut -d , -f2`;
    bin/loadContainer.sh $TYPE $LVL 100 $i;
    elif [ $COUNT -lt "100" ]; then 
    TYPE=`echo $C | cut -d , -f1`;
    LVL=`echo $C | cut -d , -f2`;
    bin/loadContainer.sh $TYPE $LVL $COUNT $i;
   fi
  break;
  done
done

